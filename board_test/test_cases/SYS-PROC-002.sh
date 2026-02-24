#!/usr/bin/env bash
# SYS-PROC-002 (embedded): Binary executed from writable path (e.g. /tmp)
# Adapted for embedded: no Docker. Robust Falco check.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common_embedded.sh
source "${SCRIPT_DIR}/common_embedded.sh"

echo "=========================================="
echo "SYS-PROC-002 (embedded): Exec from /tmp"
echo "=========================================="
echo "Expected: No exec from writable dirs. Anomaly: exe_path in /tmp or similar."
echo ""

FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-PROC-002"
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

SCRIPT="/tmp/emb_sys_proc_002_$$.sh"
echo "#!/bin/sh" > "$SCRIPT"
echo "echo ok" >> "$SCRIPT"
chmod +x "$SCRIPT"
"$SCRIPT"
rm -f "$SCRIPT"

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED] IDPS SYS-PROC-002"; else echo "[NOT DETECTED]"; fi
echo "Done."
