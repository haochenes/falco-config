#!/usr/bin/env bash
# SYS-RES-001 (embedded): CPU abuse (yes / python loop). Rule: IDPS SYS-RES-001.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-RES-001"

echo "=========================================="
echo "SYS-RES-001 (embedded): CPU abuse"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

echo ">>> Executing: yes > /dev/null (brief)"
# Never block: use timeout if available, else start yes, sleep, kill (no wait to avoid hang)
if command -v timeout &>/dev/null; then
  timeout 2 yes > /dev/null 2>/dev/null || true
else
  yes > /dev/null &
  YPID=$!
  sleep 2
  kill $YPID 2>/dev/null || true
  sleep 1
fi
if command -v python3 &>/dev/null; then
    python3 -c "import time; e=time.time()+0.5; [None for _ in iter(int,1) if time.time()>=e]" 2>/dev/null || true
fi

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED] IDPS SYS-RES-001"; else echo "[NOT DETECTED]"; fi
echo "Done."
