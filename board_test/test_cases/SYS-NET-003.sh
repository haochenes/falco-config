#!/usr/bin/env bash
# SYS-NET-003 (embedded): Raw socket / ping. Rule: IDPS SYS-NET-003.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-NET-003"

echo "=========================================="
echo "SYS-NET-003 (embedded): Raw socket / ping"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

echo ">>> Executing: ping -c 1 127.0.0.1"
ping -c 1 127.0.0.1 2>/dev/null || true
if command -v python3 &>/dev/null; then
    python3 -c "
import socket
try:
    s = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_ICMP)
    s.close()
except: pass
" 2>/dev/null || true
fi

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED] IDPS SYS-NET-003"; else echo "[NOT DETECTED]"; fi
echo "Done."
