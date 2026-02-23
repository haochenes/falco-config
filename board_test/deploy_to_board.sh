#!/usr/bin/env bash
#
# Deploy Falco and test scripts to TI-TDA4VM board
# Reads board.cfg for IP, user, password. Overwrites existing files on board.
# Falco binaries come from cross_compile/install (build with cross_compile first).
#
# Usage: ./deploy_to_board.sh [--falco-only | --tests-only]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
BOARD_CFG="${SCRIPT_DIR}/board.cfg"
TEST_CASES_DIR="${REPO_ROOT}/test/cases"
TEST_IDPS_DIR="${REPO_ROOT}/test/idps"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'
log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error()   { echo -e "${RED}[ERR]${NC} $1"; }

# Load board.cfg
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
    INSTALL_DIR="${REPO_ROOT}/${FALCO_INSTALL_DIR}"
}

# Build SSH/SCP base (ssh uses -p port, scp uses -P port)
setup_ssh() {
    TARGET="${BOARD_USER}@${BOARD_IP}"
    SSH_OPTS=(-o StrictHostKeyChecking=no -o ConnectTimeout=10 -p "${BOARD_SSH_PORT}")
    SCP_OPTS=(-o StrictHostKeyChecking=no -o ConnectTimeout=10 -P "${BOARD_SSH_PORT}")
    if [[ -n "${BOARD_PASSWORD}" ]]; then
        if command -v sshpass &>/dev/null; then
            SCP_CMD=(sshpass -p "${BOARD_PASSWORD}" scp)
            SSH_CMD=(sshpass -p "${BOARD_PASSWORD}" ssh)
        else
            log_warn "BOARD_PASSWORD set but sshpass not installed. Use: apt install sshpass"
            SCP_CMD=(scp)
            SSH_CMD=(ssh)
        fi
    else
        SCP_CMD=(scp)
        SSH_CMD=(ssh)
    fi
    SCP_CMD+=("${SCP_OPTS[@]}")
    SSH_CMD+=("${SSH_OPTS[@]}")
}

check_board() {
    log_info "Checking board ${BOARD_USER}@${BOARD_IP}:${BOARD_SSH_PORT}..."
    if "${SSH_CMD[@]}" "${TARGET}" "echo ok" &>/dev/null; then
        log_success "Board reachable."
    else
        log_error "Cannot SSH to ${TARGET}. Check IP, user, password/keys and port."
        exit 1
    fi
}

deploy_falco() {
    log_info "Deploying Falco to board (overwrite existing)..."

    if [[ ! -f "${INSTALL_DIR}/bin/falco" ]]; then
        log_error "Falco binary not found: ${INSTALL_DIR}/bin/falco"
        log_info "Build first: cd cross_compile && ./build_falco.sh all"
        exit 1
    fi

    "${SSH_CMD[@]}" "${TARGET}" "mkdir -p ${BOARD_FALCO_BIN_DIR} ${BOARD_FALCO_ETC_DIR} ${BOARD_FALCO_SHARE_DIR}"

    "${SCP_CMD[@]}" "${INSTALL_DIR}/bin/falco" "${TARGET}:${BOARD_FALCO_BIN_DIR}/"
    if [[ -f "${INSTALL_DIR}/bin/falcoctl" ]]; then
        "${SCP_CMD[@]}" "${INSTALL_DIR}/bin/falcoctl" "${TARGET}:${BOARD_FALCO_BIN_DIR}/"
    fi
    "${SSH_CMD[@]}" "${TARGET}" "chmod +x ${BOARD_FALCO_BIN_DIR}/falco"
    log_success "Falco binary deployed to ${BOARD_FALCO_BIN_DIR}"

    if [[ -d "${INSTALL_DIR}/etc/falco" ]]; then
        "${SSH_CMD[@]}" "${TARGET}" "mkdir -p ${BOARD_FALCO_ETC_DIR}/config.d"
        "${SCP_CMD[@]}" -r "${INSTALL_DIR}/etc/falco/"* "${TARGET}:${BOARD_FALCO_ETC_DIR}/"
        log_success "Falco config deployed to ${BOARD_FALCO_ETC_DIR}"
    fi

    if [[ -d "${INSTALL_DIR}/share/falco" ]]; then
        "${SSH_CMD[@]}" "${TARGET}" "mkdir -p ${BOARD_FALCO_SHARE_DIR}"
        "${SCP_CMD[@]}" -r "${INSTALL_DIR}/share/falco/"* "${TARGET}:${BOARD_FALCO_SHARE_DIR}/" 2>/dev/null || true
        log_success "Falco share deployed to ${BOARD_FALCO_SHARE_DIR}"
    fi

    if [[ -d "${INSTALL_DIR}/etc/falcoctl" ]]; then
        "${SSH_CMD[@]}" "${TARGET}" "mkdir -p /etc/falcoctl"
        "${SCP_CMD[@]}" -r "${INSTALL_DIR}/etc/falcoctl/"* "${TARGET}:/etc/falcoctl/" 2>/dev/null || true
    fi
}

deploy_tests() {
    log_info "Deploying test scripts to ${BOARD_TEST_DIR} (overwrite)..."

    "${SSH_CMD[@]}" "${TARGET}" "mkdir -p ${BOARD_TEST_DIR}/cases ${BOARD_TEST_DIR}/idps"

    if [[ -d "${TEST_CASES_DIR}" ]]; then
        for f in "${TEST_CASES_DIR}"/*.sh; do
            [[ -f "$f" ]] || continue
            "${SCP_CMD[@]}" "$f" "${TARGET}:${BOARD_TEST_DIR}/cases/"
        done
        log_success "test/cases deployed to ${BOARD_TEST_DIR}/cases"
    else
        log_warn "test/cases not found: ${TEST_CASES_DIR}"
    fi

    if [[ -d "${TEST_IDPS_DIR}" ]]; then
        for f in "${TEST_IDPS_DIR}"/SYS-*.sh; do
            [[ -f "$f" ]] || continue
            "${SCP_CMD[@]}" "$f" "${TARGET}:${BOARD_TEST_DIR}/idps/"
        done
        [[ -f "${TEST_IDPS_DIR}/README.md" ]] && "${SCP_CMD[@]}" "${TEST_IDPS_DIR}/README.md" "${TARGET}:${BOARD_TEST_DIR}/idps/" 2>/dev/null || true
        log_success "test/idps deployed to ${BOARD_TEST_DIR}/idps"
    else
        log_warn "test/idps not found: ${TEST_IDPS_DIR}"
    fi

    "${SSH_CMD[@]}" "${TARGET}" "chmod +x ${BOARD_TEST_DIR}/cases/*.sh ${BOARD_TEST_DIR}/idps/*.sh 2>/dev/null || true"
}

# --- main
load_board_cfg
setup_ssh
check_board

DEPLOY_FALCO=1
DEPLOY_TESTS=1
for arg in "$@"; do
    case "$arg" in
        --falco-only)  DEPLOY_TESTS=0 ;;
        --tests-only) DEPLOY_FALCO=0 ;;
        -h|--help)
            echo "Usage: $0 [--falco-only | --tests-only]"
            echo "  --falco-only   Deploy only Falco binary and config"
            echo "  --tests-only   Deploy only test scripts to ${BOARD_TEST_DIR}"
            exit 0
            ;;
    esac
done

[[ "$DEPLOY_FALCO" -eq 1 ]] && deploy_falco
[[ "$DEPLOY_TESTS" -eq 1 ]] && deploy_tests

log_success "Deploy done. Board: ${BOARD_USER}@${BOARD_IP}"
