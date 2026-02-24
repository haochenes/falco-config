#!/usr/bin/env bash
# SYS-NET-001 (embedded): Outbound to non-baseline IP. Rule: IDPS SYS-NET-001 (nc/curl 8.8.8.8 or example.com).

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-NET-001"

echo "=========================================="
echo "SYS-NET-001 (embedded): Outbound connection"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

echo ">>> Executing: nc -zv 8.8.8.8 53; curl -s --connect-timeout 2 https://example.com"
nc -zv 8.8.8.8 53 2>/dev/null || true
curl -s --connect-timeout 2 https://example.com >/dev/null 2>&1 || true

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED] IDPS SYS-NET-001"; else echo "[NOT DETECTED]"; fi
echo "Done."
