#!/usr/bin/env bash
# SYS-RES-002 (embedded): Hidden process (run then unlink exe). Falco may detect exec from /tmp.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-PROC-002|/tmp/"

echo "=========================================="
echo "SYS-RES-002 (embedded): Hidden process (unlink exe)"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

HIDDEN_BIN="/tmp/hidden_$(date +%s)"
cp -f /bin/sleep "$HIDDEN_BIN" 2>/dev/null || cp -f /usr/bin/sleep "$HIDDEN_BIN" 2>/dev/null || true
if [[ -f "$HIDDEN_BIN" ]]; then
    echo ">>> Executing: run binary then unlink"
    "$HIDDEN_BIN" 5 &
    PID=$!
    sleep 1
    rm -f "$HIDDEN_BIN"
    kill $PID 2>/dev/null || true
    wait $PID 2>/dev/null || true
else
    SCRIPT="/tmp/hidden_script_$(date +%s).sh"
    echo "#!/bin/sh" > "$SCRIPT"; echo "sleep 2" >> "$SCRIPT"; chmod +x "$SCRIPT"
    "$SCRIPT" & sleep 0.5; rm -f "$SCRIPT"; wait 2>/dev/null || true
fi

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED]"; else echo "[NOT DETECTED]"; fi
echo "Done."
