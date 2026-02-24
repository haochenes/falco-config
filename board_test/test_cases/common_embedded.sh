#!/usr/bin/env bash
# Common helpers for embedded test cases (board_test/test_cases).
# Source this at the start of each SYS-*.sh:  source "$(dirname "$0")/common_embedded.sh"
# Use check_falco_embedded instead of check_falco so detection works on board (systemd, pgrep -f, etc.).

set -e

# Robust Falco running check for embedded (no Docker, SSH, systemd).
# Succeeds if any of: pgrep -x falco, pgrep -f falco, systemctl is-active falco, ps | grep falco, or recent falco.log.
check_falco_embedded() {
    local running=0
    if pgrep -x falco >/dev/null 2>&1; then
        running=1
    fi
    if [ "$running" -eq 0 ] && pgrep -f '[f]alco' >/dev/null 2>&1; then
        running=1
    fi
    if [ "$running" -eq 0 ] && command -v systemctl >/dev/null 2>&1 && [ "$(systemctl is-active falco 2>/dev/null)" = "active" ]; then
        running=1
    fi
    if [ "$running" -eq 0 ] && ps 2>/dev/null | grep -q '[f]alco'; then
        running=1
    fi
    # Fallback: falco.log modified in last 90s (Falco writes when running)
    if [ "$running" -eq 0 ] && [ -f /var/log/falco.log ]; then
        local now mtime
        now=$(date +%s 2>/dev/null || echo 0)
        mtime=$(stat -c %Y /var/log/falco.log 2>/dev/null || echo 0)
        [ "$now" -gt 0 ] && [ "$mtime" -gt 0 ] && [ $((now - mtime)) -lt 90 ] && running=1
    fi
    if [ "$running" -eq 0 ]; then
        echo "ERROR: Falco does not appear to be running on this board."
        echo "  Start with: systemctl start falco  OR  /opt/falco-test/falco-start.sh"
        echo "  Or: /usr/local/bin/falco -c /etc/falco/falco.yaml &"
        exit 1
    fi
    echo "Falco is running."
}
