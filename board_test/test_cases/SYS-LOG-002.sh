#!/usr/bin/env bash
# SYS-LOG-002 (embedded): Audit rule change (auditctl). May trigger Falco/syscall rules.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="auditctl|audit"

echo "=========================================="
echo "SYS-LOG-002 (embedded): Audit rule list"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

echo ">>> Executing: auditctl -l (list rules only, no -D)"
if command -v auditctl &>/dev/null; then
    auditctl -l 2>/dev/null | head -5 || true
fi

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED]"; else echo "[NOT DETECTED]"; fi
echo "Done."
