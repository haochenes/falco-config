#!/usr/bin/env bash
# SYS-KERN-003 (embedded): Debugfs or kernel debug. Trigger: access /sys/kernel/debug.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="debugfs|Debugfs|/sys/kernel/debug"

echo "=========================================="
echo "SYS-KERN-003 (embedded): Debugfs access"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

echo ">>> Executing: ls /sys/kernel/debug (may be empty or restricted)"
ls /sys/kernel/debug 2>/dev/null | head -3 || true

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED]"; else echo "[NOT DETECTED]"; fi
echo "Done."
