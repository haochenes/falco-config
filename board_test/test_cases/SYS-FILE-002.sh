#!/usr/bin/env bash
# SYS-FILE-002 (embedded): Write to system binary dirs. Rule: IDPS SYS-FILE-002.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-FILE-002"

echo "=========================================="
echo "SYS-FILE-002 (embedded): Write to /usr/bin"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

TEST_FILE="/usr/bin/test_falco_sys_file_002_$(date +%s)"
echo ">>> Executing: Attempt write to /usr/bin"
touch "$TEST_FILE" 2>/dev/null || echo "test" | tee "$TEST_FILE" >/dev/null 2>&1 || true
rm -f "$TEST_FILE" 2>/dev/null || true

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED] IDPS SYS-FILE-002"; else echo "[NOT DETECTED]"; fi
echo "Done."
