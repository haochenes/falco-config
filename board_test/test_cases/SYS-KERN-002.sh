#!/usr/bin/env bash
# SYS-KERN-002 (embedded): ptrace attach. Default Falco rule: ptrace PTRACE_ATTACH.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="ptrace|PTRACE_ATTACH"

echo "=========================================="
echo "SYS-KERN-002 (embedded): ptrace attach"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

echo ">>> Executing: strace -p (attach to sleep)"
sleep 2 &
TPID=$!
sleep 0.5
strace -p $TPID -e trace=none 2>/dev/null &
SPID=$!
sleep 1
kill $SPID $TPID 2>/dev/null || true
wait 2>/dev/null || true

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED]"; else echo "[NOT DETECTED]"; fi
echo "Done."
