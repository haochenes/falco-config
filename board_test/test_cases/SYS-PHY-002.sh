#!/usr/bin/env bash
# SYS-PHY-002 (embedded): USB device access. Rule: IDPS SYS-PHY (read /sys/bus/usb).

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-PHY"

echo "=========================================="
echo "SYS-PHY-002 (embedded): /sys/bus/usb read"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

echo ">>> Executing: ls /sys/bus/usb/devices"
ls /sys/bus/usb/devices 2>/dev/null | head -5 || true

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED]"; else echo "[NOT DETECTED]"; fi
echo "Done."
