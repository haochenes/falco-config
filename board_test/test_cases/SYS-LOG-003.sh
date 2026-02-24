#!/usr/bin/env bash
# SYS-LOG-003 (embedded): Kill signal. Rule: IDPS SYS-LOG-003.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-LOG-003"

echo "=========================================="
echo "SYS-LOG-003 (embedded): Kill signal"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

echo ">>> Executing: kill -0 1 (signal to init)"
kill -0 1 2>/dev/null || true

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED] IDPS SYS-LOG-003"; else echo "[NOT DETECTED]"; fi
echo "Done."
