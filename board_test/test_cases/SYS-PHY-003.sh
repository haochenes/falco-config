#!/usr/bin/env bash
# SYS-PHY-003 (embedded): Physical interface test. Rule: IDPS SYS-PHY.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-PHY"

echo "=========================================="
echo "SYS-PHY-003 (embedded): USB/PHY test"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

echo ">>> Executing: lsusb; read /sys/bus/usb"
lsusb 2>/dev/null || true
cat /sys/bus/usb/devices/usb*/idVendor 2>/dev/null | head -1 || true

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED]"; else echo "[NOT DETECTED]"; fi
echo "Done."
