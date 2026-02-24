#!/usr/bin/env bash
# SYS-RES-003 (embedded): Mass process spawn (sleep). Rule: IDPS SYS-RES-003.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-RES-003"

echo "=========================================="
echo "SYS-RES-003 (embedded): Mass process spawn"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

echo ">>> Executing: Spawn multiple sleep from bash"
for _ in 1 2 3 4 5; do sleep 0.1 & done
wait 2>/dev/null || true

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED] IDPS SYS-RES-003"; else echo "[NOT DETECTED]"; fi
echo "Done."
