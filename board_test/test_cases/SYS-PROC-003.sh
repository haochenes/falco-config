#!/usr/bin/env bash
# SYS-PROC-003 (embedded): Interactive shell (bash -i). Rule: IDPS SYS-PROC-003.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-PROC-003"

echo "=========================================="
echo "SYS-PROC-003 (embedded): Interactive shell"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

echo ">>> Executing: bash -i -c echo"
timeout 1 bash -i -c "echo interactive" 2>/dev/null || bash -i -c "echo interactive; exit" 2>/dev/null || true

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED] IDPS SYS-PROC-003"; else echo "[NOT DETECTED]"; fi
echo "Done."
