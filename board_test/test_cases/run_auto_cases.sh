#!/usr/bin/env bash
# Run only AUTO cases: safe for full automation, no system damage.
# Usage: on board: cd /opt/falco-test/test_cases && bash run_auto_cases.sh
#        from host: ./run_tests_remote.sh cases

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Safe cases: read-only, short-lived, or non-destructive actions only
AUTO_CASES=(
    SYS-CONT-001.sh   # Host path read (/proc)
    SYS-KERN-002.sh   # ptrace attach (strace)
    SYS-KERN-003.sh   # ls /sys/kernel/debug (read)
    SYS-LOG-002.sh    # auditctl -l (list only)
    SYS-NET-001.sh    # Outbound connection
    SYS-NET-002.sh    # Bind port
    SYS-NET-003.sh    # ping (raw socket)
    SYS-NET-004.sh    # AF_CAN socket
    SYS-PHY-001.sh    # udevadm / lsusb (read)
    SYS-PHY-002.sh    # ls /sys/bus/usb (read)
    SYS-PHY-003.sh    # USB/PHY read
    SYS-PROC-001.sh   # runuser/sudo -u (different user)
    SYS-PROC-002.sh   # Exec from /tmp
    SYS-PROC-003.sh   # Interactive shell (bash -i)
    SYS-PROC-005.sh   # Non-baseline binary (/tmp)
    SYS-RES-003.sh    # Mass process spawn (5x sleep 0.1)
)

echo "=========================================="
echo "Running AUTO test cases (safe for automation)"
echo "=========================================="

PASSED=0
FAILED=0
FAILED_LIST=""

for f in "${AUTO_CASES[@]}"; do
    [[ -f "$f" ]] || continue
    echo "----------------------------------------"
    echo ">>> Running: $f"
    echo "----------------------------------------"
    if bash "$f" 2>&1; then
        ((PASSED++)) || true
        echo "[PASS] $f"
    else
        ((FAILED++)) || true
        FAILED_LIST="$FAILED_LIST $f"
        echo "[FAIL] $f"
    fi
    echo ""
done

echo "=========================================="
echo "Summary (AUTO)"
echo "=========================================="
echo "Passed: $PASSED"
echo "Failed: $FAILED"
[[ -n "$FAILED_LIST" ]] && echo "Failed:$FAILED_LIST"
[ "$FAILED" -gt 0 ] && exit 1
exit 0
