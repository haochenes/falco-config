#!/usr/bin/env bash
# SYS-KERN-001 (embedded): Runtime kernel module loading
# Adapted for embedded: no Docker. Robust Falco check. Only triggers attempt (may fail with EPERM).

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common_embedded.sh
source "${SCRIPT_DIR}/common_embedded.sh"

echo "=========================================="
echo "SYS-KERN-001 (embedded): Kernel module load attempt"
echo "=========================================="
echo "Expected: No insmod/modprobe. Anomaly: init_module/finit_module syscall."
echo ""

FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-KERN-001"
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

echo ">>> Executing: insmod/modprobe attempt (detection on syscall, may fail with permission)"
modprobe -n dummy 2>/dev/null || true
insmod --help 2>/dev/null || true

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED] IDPS SYS-KERN-001"; else echo "[NOT DETECTED]"; fi
echo "Done."
