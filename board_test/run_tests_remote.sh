#!/usr/bin/env bash
#
# Run Falco test cases on TI-TDA4VM board via SSH
# Reads board.cfg. Tests must be deployed first (./deploy_to_board.sh).
#
# Usage:
#   ./run_tests_remote.sh              # run all idps + cases
#   ./run_tests_remote.sh idps         # run all IDPS tests
#   ./run_tests_remote.sh cases        # run all case*.sh tests
#   ./run_tests_remote.sh SYS-PROC-001 # run single IDPS test
#   ./run_tests_remote.sh --start-falco # start Falco on board then run all

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
    log_info "Starting Falco on board (background)..."
    "${SSH_CMD[@]}" "${TARGET}" "pkill falco 2>/dev/null; nohup falco -c /etc/falco/falco.yaml > /var/log/falco.log 2>&1 & sleep 1; pgrep falco && echo Falco started || echo Falco may have failed"
}

run_remote() {
    local cmd="$1"
    "${SSH_CMD[@]}" "${TARGET}" "cd ${BOARD_TEST_DIR} && ${cmd}"
}

run_one_test() {
    local name="$1"
    name="${name%.sh}"
    log_info "Running on board: ${name}"
    run_remote "([ -f idps/${name}.sh ] && bash idps/${name}.sh) || ([ -f cases/${name}.sh ] && bash cases/${name}.sh) || echo 'Test not found: ${name}'"
}

run_all_idps() {
    log_info "Running all IDPS tests (idps/SYS-*.sh) on board..."
    run_remote 'for f in idps/SYS-*.sh; do [ -f "$f" ] && echo "=== $f ===" && bash "$f"; done'
}

run_all_cases() {
    log_info "Running all case tests (cases/case*.sh) on board..."
    run_remote 'for f in cases/case*.sh; do [ -f "$f" ] && echo "=== $f ===" && bash "$f"; done'
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
        idps)         MODE="idps"; shift ;;
        cases)        MODE="cases"; shift ;;
        all)          MODE="all"; shift ;;
        -h|--help)
            echo "Usage: $0 [mode] [--start-falco]"
            echo "  mode: all (default) | idps | cases | <test_name>"
            echo "  --start-falco  Start Falco on board before running tests"
            echo "  Examples:"
            echo "    $0                    # run all idps + cases"
            echo "    $0 idps               # run all SYS-*.sh"
            echo "    $0 cases               # run all case*.sh"
            echo "    $0 SYS-PROC-001        # run single IDPS test"
            echo "    $0 case1_sensitive_file_opening"
            echo "    $0 --start-falco all   # start Falco then run all"
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
        run_all_cases
        ;;
    *)
        run_one_test "$MODE"
        ;;
esac

log_success "Remote test run finished."
