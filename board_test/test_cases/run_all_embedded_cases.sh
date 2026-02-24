#!/usr/bin/env bash
# Run ALL embedded test cases (AUTO + MANUAL). Prefer run_auto_cases.sh for automation.
# Usage: on board: cd /opt/falco-test/test_cases && bash run_all_embedded_cases.sh
#        from host: ./run_tests_remote.sh cases-all

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=========================================="
echo "Running ALL embedded IDPS test cases (AUTO + MANUAL)"
echo "=========================================="
echo "For automation use: bash run_auto_cases.sh"
echo "Manual cases may: write system dirs, load modules, mount, kill signals, CPU load."
echo ""

# Same lists as run_auto_cases.sh and run_manual_cases.sh
AUTO_CASES=(
    SYS-CONT-001.sh SYS-KERN-002.sh SYS-KERN-003.sh SYS-LOG-002.sh
    SYS-NET-001.sh SYS-NET-002.sh SYS-NET-003.sh SYS-NET-004.sh
    SYS-PHY-001.sh SYS-PHY-002.sh SYS-PHY-003.sh
    SYS-PROC-001.sh SYS-PROC-002.sh SYS-PROC-003.sh SYS-PROC-005.sh
    SYS-RES-003.sh
)
MANUAL_CASES=(
    SYS-CONT-002.sh SYS-CONT-003.sh SYS-CONT-004.sh
    SYS-FILE-001.sh SYS-FILE-002.sh SYS-FILE-003.sh SYS-FILE-004.sh
    SYS-KERN-001.sh SYS-KERN-004.sh
    SYS-LOG-001.sh SYS-LOG-003.sh
    SYS-PROC-004.sh SYS-RES-001.sh SYS-RES-002.sh
)

PASSED=0
FAILED=0
FAILED_LIST=""

run_list() {
    local list_name="$1"
    shift
    local list=("$@")
    for f in "${list[@]}"; do
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
}

run_list "AUTO" "${AUTO_CASES[@]}"
run_list "MANUAL" "${MANUAL_CASES[@]}"

echo "=========================================="
echo "Summary"
echo "=========================================="
echo "Passed: $PASSED"
echo "Failed: $FAILED"
[[ -n "$FAILED_LIST" ]] && echo "Failed:$FAILED_LIST"
[ "$FAILED" -gt 0 ] && exit 1
exit 0
