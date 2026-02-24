#!/usr/bin/env bash
# SYS-NET-004 (embedded): AF_CAN socket. Rule: IDPS SYS-NET-004.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-NET-004|AF_CAN"

echo "=========================================="
echo "SYS-NET-004 (embedded): AF_CAN socket"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

echo ">>> Executing: socket(AF_CAN, SOCK_RAW, CAN_RAW)"
if command -v python3 &>/dev/null; then
    python3 -c "
import socket
try:
    s = socket.socket(29, 3, 1)  # AF_CAN, SOCK_RAW, CAN_RAW
    s.close()
except Exception as e:
    pass
" 2>/dev/null || true
fi

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED]"; else echo "[NOT DETECTED]"; fi
echo "Done."
