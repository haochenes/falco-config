#!/usr/bin/env bash
# SYS-PHY-001 (embedded): USB enumeration. Rule: IDPS SYS-PHY (udevadm, lsusb, /sys/bus/usb).

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-PHY"

echo "=========================================="
echo "SYS-PHY-001 (embedded): USB / udevadm"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

echo ">>> Executing: udevadm info -e; lsusb"
udevadm info -e 2>/dev/null | grep -E "ID_VENDOR_ID|ID_MODEL" | head -5 || true
lsusb 2>/dev/null | head -3 || true

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED] IDPS SYS-PHY"; else echo "[NOT DETECTED]"; fi
echo "Done."
