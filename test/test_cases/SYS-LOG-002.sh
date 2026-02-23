#!/usr/bin/env bash
# SYS-LOG-002: Unexpected disabling or redirection of audit logs
# Document: System-Level IDPS Detection Test Cases For Embedded Linux v1.1
# Category 7: Log & Audit Integrity
# Use --execute to trigger real auditctl -D and rollback (for IDPS detection)

set -e

EXECUTE_MODE=false
[[ "$1" = "--execute" || "$1" = "-x" ]] && EXECUTE_MODE=true

echo "=========================================="
echo "SYS-LOG-002: Audit rule changes"
echo "=========================================="
echo ""
echo "Expected Baseline: auditd rules immutable post-boot."
echo "Anomaly Condition: auditctl -D or rule change attempts."
echo "Evidence Fields: pid, exe, audit_command, uid"
echo ""

check_falco() {
    if ! pgrep -x falco > /dev/null 2>&1; then
        echo "Warning: Falco is not running. Start with: sudo falco -c /etc/falco/falco.yaml &"
        if [ -t 0 ]; then
            read -p "Continue anyway? (y/n) " -n 1 -r
            echo
            [[ $REPLY =~ ^[Yy]$ ]] || exit 1
        else
            echo "Non-interactive mode: continuing anyway..."
        fi
    fi
}

check_falco

echo ">>> Executing: auditctl commands (list/delete rules)"
echo ""

if command -v auditctl &>/dev/null; then
    if $EXECUTE_MODE; then
        BACKUP="/tmp/audit_backup_sys_log_002_$$"
        trap 'sudo auditctl -R "$BACKUP" 2>/dev/null; rm -f "$BACKUP"; exit' INT TERM EXIT
        sudo auditctl -l > "$BACKUP" 2>/dev/null || true
        echo "Backup: $BACKUP"
        echo "Running: auditctl -D (delete all rules)"
        sudo auditctl -D 2>/dev/null || true
        sleep 2
        echo "Restoring rules from backup..."
        sudo auditctl -R "$BACKUP" 2>/dev/null || true
        rm -f "$BACKUP"
        trap - INT TERM EXIT
    else
        sudo auditctl -l 2>/dev/null || true
        echo "Note: Use --execute or -x to run auditctl -D with rollback."
    fi
else
    echo "auditctl not available on this system."
fi

echo ""
echo ">>> Verification: Check Falco logs for:"
echo "    - Log_Tampering"
echo "    - auditctl rule modification"
echo "    tail -f /var/log/falco.log"
echo ""
