#!/usr/bin/env bash
# SYS-FILE-001 (embedded): Writes to core /etc and read sensitive file
# Rule: IDPS SYS-FILE-001. Need falco_rules.local.yaml deployed.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common_embedded.sh
source "${SCRIPT_DIR}/common_embedded.sh"

FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-FILE-001|Sensitive file opened"

echo "=========================================="
echo "SYS-FILE-001 (embedded): /etc write + shadow read"
echo "=========================================="
check_falco_embedded

LOG_LINES_BEFORE=0
[[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

TEST_FILE="/etc/test_falco_sys_file_001_$(date +%s)"
echo ">>> Executing: Write under /etc and read /etc/shadow"
echo "test" | tee "$TEST_FILE" >/dev/null 2>&1 || true
cat /etc/shadow 2>/dev/null | head -1 || true
rm -f "$TEST_FILE" 2>/dev/null || true

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then
    echo "[DETECTED] Falco log contains IDPS SYS-FILE-001 or Sensitive file"
else
    echo "[NOT DETECTED] No match in $FALCO_LOG. Deploy falco_rules.local.yaml and restart Falco."
fi
echo "Done."
