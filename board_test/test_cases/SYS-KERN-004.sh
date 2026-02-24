#!/usr/bin/env bash
# SYS-KERN-004 (embedded): Mount/remount. Rule: IDPS SYS-KERN-004.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-KERN-004"

echo "=========================================="
echo "SYS-KERN-004 (embedded): Mount remount"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

echo ">>> Executing: mount --bind / /mnt (may fail)"
mount --bind / /mnt 2>/dev/null || true
umount /mnt 2>/dev/null || true

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED] IDPS SYS-KERN-004"; else echo "[NOT DETECTED]"; fi
echo "Done."
