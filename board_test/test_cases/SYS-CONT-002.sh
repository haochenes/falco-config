#!/usr/bin/env bash
# SYS-CONT-002 (embedded): Privileged container. On embedded no Docker → skip trigger; rule IDPS SYS-CONT.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common_embedded.sh"
FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
RULE_MARKERS="IDPS SYS-CONT"

echo "=========================================="
echo "SYS-CONT-002 (embedded): Privileged container"
echo "=========================================="
check_falco_embedded
if command -v docker &>/dev/null; then
    LOG_LINES_BEFORE=0; [[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")
    echo ">>> Executing: docker run --rm --privileged alpine id"
    docker run --rm --privileged alpine id 2>/dev/null || true
    sleep 2
    [[ -f "$FALCO_LOG" ]] && grep -qE "$RULE_MARKERS" "$FALCO_LOG" && echo "[DETECTED] IDPS SYS-CONT" || echo "[NOT DETECTED]"
else
    echo "[SKIP] Docker not available on board"
fi
echo "Done."
