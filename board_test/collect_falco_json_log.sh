#!/usr/bin/env bash
# Fetch Falco JSON event log from the board for compliance / audit.
# Reads board.cfg. Output: current dir or OUT_FILE.
# Usage: ./collect_falco_json_log.sh [output_file]

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOARD_CFG="${SCRIPT_DIR}/board.cfg"
OUT_FILE="${1:-falco_events_$(date +%Y%m%d_%H%M%S).jsonl}"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
log_info()  { echo -e "[INFO] $1"; }
log_error() { echo -e "${RED}[ERR]${NC} $1"; }

load_board_cfg() {
    [[ -f "${BOARD_CFG}" ]] || { log_error "board.cfg not found: ${BOARD_CFG}"; exit 1; }
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
    SCP_OPTS=(-o StrictHostKeyChecking=no -o ConnectTimeout=10 -P "${BOARD_SSH_PORT}")
    if [[ -n "${BOARD_PASSWORD}" ]] && command -v sshpass &>/dev/null; then
        SCP_CMD=(sshpass -p "${BOARD_PASSWORD}" scp)
    else
        SCP_CMD=(scp)
    fi
    SCP_CMD+=("${SCP_OPTS[@]}")
}

load_board_cfg
setup_ssh
TARGET="${BOARD_USER}@${BOARD_IP}"

BOARD_JSON="/var/log/falco/falco_events.json"
if [[ ! -f "${SCRIPT_DIR}/board.cfg" ]]; then
    log_error "board.cfg missing"
    exit 1
fi

log_info "Fetching ${BOARD_JSON} from ${TARGET} -> ${OUT_FILE}"
SSH_OPTS=(-o StrictHostKeyChecking=no -o ConnectTimeout=10 -p "${BOARD_SSH_PORT}")
if ssh "${SSH_OPTS[@]}" "${TARGET}" "test -r ${BOARD_JSON}" 2>/dev/null; then
    if "${SCP_CMD[@]}" "${TARGET}:${BOARD_JSON}" "${OUT_FILE}" 2>/dev/null; then
        :
    else
        ssh "${SSH_OPTS[@]}" "${TARGET}" "cat ${BOARD_JSON}" > "${OUT_FILE}"
    fi
    LINES=$(wc -l < "${OUT_FILE}" 2>/dev/null || echo 0)
    echo -e "${GREEN}[OK]${NC} Saved to ${OUT_FILE} (${LINES} lines, JSONL for compliance)"
else
    # Fallback: fetch text log for review if JSON not enabled
    BOARD_LOG="/var/log/falco.log"
    FALLBACK_FILE="${OUT_FILE%.jsonl}.log"
    if ssh "${SSH_OPTS[@]}" "${TARGET}" "test -r ${BOARD_LOG}" 2>/dev/null; then
        ssh "${SSH_OPTS[@]}" "${TARGET}" "cat ${BOARD_LOG}" > "${FALLBACK_FILE}"
        LINES=$(wc -l < "${FALLBACK_FILE}" 2>/dev/null || echo 0)
        echo -e "${GREEN}[OK]${NC} (JSON not found) Saved text log to ${FALLBACK_FILE} (${LINES} lines). For JSON: deploy --rules-only, restart Falco, then re-run tests and collect."
        exit 0
    fi
    log_error "Board has no ${BOARD_JSON} nor ${BOARD_LOG}. Enable JSON: ./deploy_to_board.sh --rules-only, restart Falco (systemctl restart falco), run tests, then collect."
    exit 1
fi
