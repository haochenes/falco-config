#!/usr/bin/env bash
# SYS-PROC-005 (embedded): Exec from non-baseline path (/tmp). Rule: IDPS SYS-PROC-002 or "Executing binary not part of base image".

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-PROC-002|Executing binary not part of base|exe_path.*tmp"

echo "=========================================="
echo "SYS-PROC-005 (embedded): Non-baseline binary"
echo "=========================================="
check_falco_embedded
LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

UNKNOWN_BIN="/tmp/unknown_bin_$(date +%s)"
cp -f /bin/true "$UNKNOWN_BIN" 2>/dev/null || cp -f /usr/bin/true "$UNKNOWN_BIN" 2>/dev/null || true
if [[ -f "$UNKNOWN_BIN" ]]; then
    echo ">>> Executing: $UNKNOWN_BIN"
    "$UNKNOWN_BIN"
    rm -f "$UNKNOWN_BIN"
else
    SCRIPT="/tmp/non_baseline_$(date +%s).sh"
    echo "#!/bin/sh" > "$SCRIPT"; echo "echo test" >> "$SCRIPT"; chmod +x "$SCRIPT"
    "$SCRIPT"; rm -f "$SCRIPT"
fi

sleep 2
if [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then echo "[DETECTED]"; else echo "[NOT DETECTED]"; fi
echo "Done."
