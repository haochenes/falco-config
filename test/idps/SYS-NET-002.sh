#!/usr/bin/env bash
# SYS-NET-002: Unexpected inbound listening on low ports
# Document: System-Level IDPS Detection Test Cases For Embedded Linux v1.1
# Category 4: Abnormal Network Behavior

set -e

echo "=========================================="
echo "SYS-NET-002: Low port listening"
echo "=========================================="
echo ""
echo "Expected Baseline: No bind to ports <1024 except approved services."
echo "Anomaly Condition: bind to low port by non-baseline process."
echo "Evidence Fields: pid, exe, local_port, uid"
echo ""

check_falco() {
    if ! pgrep -x falco > /dev/null 2>&1; then
        echo "Warning: Falco is not running. Start with: sudo falco -c /etc/falco/falco.yaml &"
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        [[ $REPLY =~ ^[Yy]$ ]] || exit 1
    fi
}

check_falco

echo ">>> Executing: Bind to low port (e.g., 4444 or 80)"
echo "    Requires root for port <1024."
echo ""

# Use nc to listen briefly on a port (backdoor-like)
# Port 4444 is often used for backdoors
if nc -h 2>&1 | grep -q '\-l'; then
    nc -l 4444 &
    NC_PID=$!
    sleep 2
    kill $NC_PID 2>/dev/null || true
    wait $NC_PID 2>/dev/null || true
fi

# If we have sudo, try low port 80
if command -v sudo &>/dev/null; then
    (sudo nc -l 80 &
     NC_PID=$!
     sleep 1
     sudo kill $NC_PID 2>/dev/null || true
     wait $NC_PID 2>/dev/null || true) 2>/dev/null || true
fi

echo ""
echo ">>> Verification: Check Falco logs for:"
echo "    - Backdoor_Activity"
echo "    - Listen on low port"
echo "    tail -f /var/log/falco.log"
echo ""
