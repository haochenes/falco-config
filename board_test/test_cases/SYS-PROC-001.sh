#!/usr/bin/env bash
# SYS-PROC-001 (embedded): Process executed with unexpected user/group identity
# Triggers: runuser -u / sudo -u (rule IDPS SYS-PROC-001 in falco_rules.local.yaml).
# Deploy must include falco_rules.local.yaml so the rule is loaded.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common_embedded.sh
source "${SCRIPT_DIR}/common_embedded.sh"

FALCO_LOG="${FALCO_LOG:-/var/log/falco.log}"
# SYS-PROC-001 = run as different user; SYS-PROC-004 = privilege escalation (sudo/su) - both fire on sudo -u / runuser
RULE_MARKERS="IDPS SYS-PROC-001|IDPS SYS-PROC-004"

echo "=========================================="
echo "SYS-PROC-001 (embedded): Unexpected uid/gid"
echo "=========================================="
echo "Expected: Falco rule 'IDPS SYS-PROC-001' fires on runuser/sudo -u (need falco_rules.local.yaml deployed)."
echo ""

check_falco_embedded

# Count lines in falco.log before trigger (to detect new entries)
LOG_LINES_BEFORE=0
[[ -f "$FALCO_LOG" ]] && LOG_LINES_BEFORE=$(wc -l < "$FALCO_LOG")

echo ">>> Executing: Run process as different user (runuser or sudo -u nobody)"
if command -v runuser &>/dev/null; then
    runuser -u nobody -- id 2>/dev/null || true
fi
if command -v sudo &>/dev/null; then
    sudo -u nobody id 2>/dev/null || true
fi

sleep 2
if [[ -f "$FALCO_LOG" ]]; then
    if grep -qE "$RULE_MARKERS" "$FALCO_LOG"; then
        NEW=$(($(wc -l < "$FALCO_LOG") - LOG_LINES_BEFORE))
        echo "[DETECTED] Falco log contains IDPS SYS-PROC-001 or SYS-PROC-004 (new lines: $NEW)"
    else
        echo "[NOT DETECTED] No IDPS SYS-PROC-001/004 in $FALCO_LOG. Deploy falco_rules.local.yaml and restart Falco (systemctl restart falco)."
    fi
else
    echo "[SKIP] $FALCO_LOG not found, cannot verify detection."
fi
echo "Done."
