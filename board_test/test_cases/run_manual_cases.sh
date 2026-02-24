#!/usr/bin/env bash
# Run only MANUAL cases: may affect system (CPU load, writes, kill, mount, etc.).
# Run when you need to verify these rules; not for unattended automation.
# Usage: on board: cd /opt/falco-test/test_cases && bash run_manual_cases.sh
#        from host: ./run_tests_remote.sh cases-manual

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Manual cases: system damage risk, privilege escalation, or need human oversight
MANUAL_CASES=(
    SYS-CONT-002.sh   # Docker privileged container
    SYS-CONT-003.sh   # Docker host mount
    SYS-CONT-004.sh   # Docker cap-add
    SYS-FILE-001.sh   # Write /etc + read /etc/shadow
    SYS-FILE-002.sh   # Write /usr/bin
    SYS-FILE-003.sh   # Write /etc/cron.d
    SYS-FILE-004.sh   # Write /etc/systemd/system
    SYS-KERN-001.sh   # insmod/modprobe (kernel module)
    SYS-KERN-004.sh   # mount --bind
    SYS-LOG-001.sh    # Log tampering (write/truncate /var/log)
    SYS-LOG-003.sh    # Kill signal (to init)
    SYS-PROC-004.sh   # Privilege escalation (sudo)
    SYS-RES-001.sh    # CPU abuse (yes loop)
    SYS-RES-002.sh    # Hidden process (run then unlink exe)
)

echo "=========================================="
echo "MANUAL test cases (may affect system)"
echo "=========================================="
echo "These cases can: write system dirs, load modules, mount, send signals,"
echo "or stress CPU. Run only when you intend to test these rules."
echo ""

PASSED=0
FAILED=0
FAILED_LIST=""

for f in "${MANUAL_CASES[@]}"; do
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
echo "Summary (MANUAL)"
echo "=========================================="
echo "Passed: $PASSED"
echo "Failed: $FAILED"
[[ -n "$FAILED_LIST" ]] && echo "Failed:$FAILED_LIST"
[ "$FAILED" -gt 0 ] && exit 1
exit 0
