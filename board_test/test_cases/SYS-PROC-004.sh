#!/usr/bin/env bash
# SYS-PROC-004 (embedded): Privilege escalation (sudo/su). Rule: IDPS SYS-PROC-004.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-PROC-004"

echo "=========================================="
echo "SYS-PROC-004 (embedded): Privilege escalation"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

echo ">>> Executing: sudo id"
sudo id 2>/dev/null || true

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED] IDPS SYS-PROC-004"; else echo "[NOT DETECTED]"; fi
echo "Done."
