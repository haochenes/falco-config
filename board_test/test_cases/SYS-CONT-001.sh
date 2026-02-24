#!/usr/bin/env bash
# SYS-CONT-001 (embedded): Host sensitive path access (no container)
# Adapted for embedded: no Docker. Simulate by reading host /proc/1/cmdline and /proc from host.
# Falco can still detect read of sensitive paths; container-specific rules may not fire.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common_embedded.sh
source "${SCRIPT_DIR}/common_embedded.sh"

echo "=========================================="
echo "SYS-CONT-001 (embedded): Host path access"
echo "=========================================="
echo "Embedded: No container. Simulating host read of /proc/1, /proc. Check for file read rules."
echo ""

FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-CONT|Sensitive file|read.*proc"
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

echo ">>> Executing: Read /proc/1/cmdline and list /proc (host)"
cat /proc/1/cmdline 2>/dev/null | tr '\0' ' ' || true
echo ""
ls -la /proc 2>/dev/null | head -5 || true

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED]"; else echo "[NOT DETECTED] (container rules may not fire on host)"; fi
echo "Done."
