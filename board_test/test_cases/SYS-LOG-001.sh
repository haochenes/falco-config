#!/usr/bin/env bash
# SYS-LOG-001 (embedded): Log file tampering. Rule: Clear Log Activities / Log files were tampered.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="Log files were tampered|Clear Log|tampered"

echo "=========================================="
echo "SYS-LOG-001 (embedded): Log tampering"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

TEST_LOG="/var/log/test_falco_sys_log_001_$(date +%s).log"
echo ">>> Executing: Write and truncate in /var/log"
echo "test" | tee "$TEST_LOG" >/dev/null 2>&1 || true
truncate -s 0 "$TEST_LOG" 2>/dev/null || true
rm -f "$TEST_LOG" 2>/dev/null || true

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED] Log tampering rule"; else echo "[NOT DETECTED]"; fi
echo "Done."
