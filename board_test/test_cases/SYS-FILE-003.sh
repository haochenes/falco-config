#!/usr/bin/env bash
# SYS-FILE-003 (embedded): Write to PAM/cron. Rule: IDPS SYS-FILE-003.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-FILE-003"

echo "=========================================="
echo "SYS-FILE-003 (embedded): Write to cron.d"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

CRON_TEST="/etc/cron.d/test_falco_sys_file_003_$(date +%s)"
echo ">>> Executing: Write to /etc/cron.d"
echo "# test" | tee "$CRON_TEST" >/dev/null 2>&1 || true
rm -f "$CRON_TEST" 2>/dev/null || true

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED] IDPS SYS-FILE-003"; else echo "[NOT DETECTED]"; fi
echo "Done."
