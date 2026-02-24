#!/usr/bin/env bash
# SYS-NET-002 (embedded): Bind to low port (4444). Rule: IDPS SYS-NET-002.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-NET-002"

echo "=========================================="
echo "SYS-NET-002 (embedded): Low port bind"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

echo ">>> Executing: Bind to port 4444"
if command -v python3 &>/dev/null; then
    python3 -c "
import socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind(('0.0.0.0', 4444))
s.listen(1)
s.settimeout(1)
try: s.accept()
except: pass
s.close()
" 2>/dev/null || true
else
    (nc -l -p 4444 -e true &); sleep 1; kill %1 2>/dev/null || true
fi

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED] IDPS SYS-NET-002"; else echo "[NOT DETECTED]"; fi
echo "Done."
