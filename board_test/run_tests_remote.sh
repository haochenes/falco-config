#!/usr/bin/env bash
#
# Run Falco test cases on TI-TDA4VM board via SSH
# Reads board.cfg. Tests must be deployed first (./deploy_to_board.sh).
#
# Usage:
#   ./run_tests_remote.sh embedded     # run embedded_tests/*.sh (quick actions)
#   ./run_tests_remote.sh cases        # run embedded IDPS cases (test_cases/run_all_embedded_cases.sh, robust Falco check)
#   ./run_tests_remote.sh idps         # run legacy idps/SYS-*.sh (from test/test_cases)
#   ./run_tests_remote.sh all          # idps + cases
#   ./run_tests_remote.sh --start-falco embedded  # start Falco then run embedded

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOARD_CFG="${SCRIPT_DIR}/board.cfg"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'
log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error()   { echo -e "${RED}[ERR]${NC} $1"; }

load_board_cfg() {
    if [[ ! -f "${BOARD_CFG}" ]]; then
        log_error "board.cfg not found: ${BOARD_CFG}"
        exit 1
    fi
    while IFS='=' read -r key value; do
        [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs | sed 's/^["'\'']//;s/["'\'']$//')
        [[ -n "$key" ]] && export "$key"="${value}"
    done < "${BOARD_CFG}"
    BOARD_SSH_PORT="${BOARD_SSH_PORT:-22}"
}

setup_ssh() {
    TARGET="${BOARD_USER}@${BOARD_IP}"
    SSH_OPTS=(-o StrictHostKeyChecking=no -o ConnectTimeout=10 -p "${BOARD_SSH_PORT}")
    if [[ -n "${BOARD_PASSWORD}" ]]; then
        if command -v sshpass &>/dev/null; then
            SSH_CMD=(sshpass -p "${BOARD_PASSWORD}" ssh)
        else
            SSH_CMD=(ssh)
        fi
    else
        SSH_CMD=(ssh)
    fi
    SSH_CMD+=("${SSH_OPTS[@]}")
}

start_falco_on_board() {
    log_info "Starting Falco on board (systemd or start script)..."
    "${SSH_CMD[@]}" "${TARGET}" "pkill falco 2>/dev/null; sleep 1; \
        if command -v systemctl >/dev/null 2>&1 && [ -f /etc/systemd/system/falco.service ]; then \
            systemctl start falco 2>/dev/null && echo 'Falco started (systemd)' || echo 'systemctl start falco failed'; \
        elif [ -x /opt/falco-test/falco-start.sh ]; then \
            /opt/falco-test/falco-start.sh; \
        elif [ -x /opt/falco-test/services/falco-start.sh ]; then \
            /opt/falco-test/services/falco-start.sh; \
        else \
            nohup /usr/local/bin/falco -c /etc/falco/falco.yaml >> /var/log/falco.log 2>&1 & sleep 1; \
        fi; \
        pgrep -x falco >/dev/null && echo 'Falco is running' || echo 'Falco may have failed - check /var/log/falco.log'"
}

run_remote() {
    local cmd="$1"
    "${SSH_CMD[@]}" "${TARGET}" "cd ${BOARD_TEST_DIR} && ${cmd}"
}

run_one_test() {
    local name="$1"
    name="${name%.sh}"
    log_info "Running on board: ${name}"
    # Prefer embedded test_cases (SYS-*.sh with check_falco_embedded), then idps, then legacy cases
    run_remote "([ -f test_cases/${name}.sh ] && bash test_cases/${name}.sh) || ([ -f idps/${name}.sh ] && bash idps/${name}.sh) || ([ -f cases/${name}.sh ] && bash cases/${name}.sh) || echo 'Test not found: ${name}'"
}

run_all_idps() {
    log_info "Running all IDPS tests (idps/SYS-*.sh) on board..."
    run_remote 'for f in idps/SYS-*.sh; do [ -f "$f" ] && echo "=== $f ===" && bash "$f"; done'
}

# Run AUTO embedded test cases only (safe for automation)
run_auto_cases() {
    log_info "Running AUTO test cases (test_cases/run_auto_cases.sh) on board..."
    run_remote 'if [ -f test_cases/run_auto_cases.sh ]; then bash test_cases/run_auto_cases.sh; else echo "No test_cases/run_auto_cases.sh (deploy board_test first)"; exit 1; fi'
}

# Run MANUAL embedded test cases (may affect system; run when needed)
run_manual_cases() {
    log_info "Running MANUAL test cases (test_cases/run_manual_cases.sh) on board..."
    run_remote 'if [ -f test_cases/run_manual_cases.sh ]; then bash test_cases/run_manual_cases.sh; else echo "No test_cases/run_manual_cases.sh (deploy board_test first)"; exit 1; fi'
}

# Run ALL embedded test cases (AUTO + MANUAL)
run_all_cases() {
    log_info "Running ALL embedded test cases (test_cases/run_all_embedded_cases.sh) on board..."
    run_remote 'if [ -f test_cases/run_all_embedded_cases.sh ]; then bash test_cases/run_all_embedded_cases.sh; else echo "No test_cases/run_all_embedded_cases.sh (deploy board_test first)"; exit 1; fi'
}

run_all_embedded() {
    log_info "Running all embedded tests (embedded/*.sh) on board..."
    run_remote 'for f in embedded/*.sh; do [ -f "$f" ] && echo "=== $f ===" && bash "$f"; done'
}

# --- main
load_board_cfg
setup_ssh
TARGET="${BOARD_USER}@${BOARD_IP}"

START_FALCO=0
MODE="all"

while [[ -n "$1" ]]; do
    case "$1" in
        --start-falco) START_FALCO=1; shift ;;
        idps)            MODE="idps"; shift ;;
        cases)           MODE="cases"; shift ;;
        cases-manual)    MODE="cases-manual"; shift ;;
        cases-all)       MODE="cases-all"; shift ;;
        embedded)        MODE="embedded"; shift ;;
        all)             MODE="all"; shift ;;
        -h|--help)
            echo "Usage: $0 [mode] [--start-falco]"
            echo "  mode: embedded | idps | cases | cases-manual | cases-all | all | <test_name>"
            echo "  --start-falco  Start Falco on board before running tests"
            echo "  cases         run AUTO cases only (safe for automation)"
            echo "  cases-manual  run MANUAL cases only (may affect system)"
            echo "  cases-all     run all embedded cases (AUTO + MANUAL)"
            echo "  Examples:"
            echo "    $0 cases         # run auto cases only (safe)"
            echo "    $0 cases-manual # run manual cases (write/mount/kill/CPU etc.)"
            echo "    $0 SYS-PROC-001  # run single test"
            exit 0
            ;;
        *) MODE="$1"; shift ;;
    esac
done

if [[ "$START_FALCO" -eq 1 ]]; then
    start_falco_on_board
fi

case "$MODE" in
    all)
        run_all_idps
        run_all_cases
        ;;
    idps)
        run_all_idps
        ;;
    cases)
        run_auto_cases
        ;;
    cases-manual)
        run_manual_cases
        ;;
    cases-all)
        run_all_cases
        ;;
    embedded)
        run_all_embedded
        ;;
    *)
        run_one_test "$MODE"
        ;;
esac

log_success "Remote test run finished."
