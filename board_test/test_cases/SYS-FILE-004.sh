#!/usr/bin/env bash
# SYS-FILE-004 (embedded): Write to systemd unit. Rule: IDPS SYS-FILE-004.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-FILE-004"

echo "=========================================="
echo "SYS-FILE-004 (embedded): Write systemd unit"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

SVC="test_falco_sys_file_004_$(date +%s).service"
echo ">>> Executing: Write to /etc/systemd/system"
echo "[Unit]" | tee "/etc/systemd/system/${SVC}" >/dev/null 2>&1 || true
rm -f "/etc/systemd/system/${SVC}" 2>/dev/null || true

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED] IDPS SYS-FILE-004"; else echo "[NOT DETECTED]"; fi
echo "Done."
