#!/usr/bin/env bash
#
# 检查 TDA4VM 板子环境：内核版本、Falco 相关 config、架构等
# 用于判断 Falco 能否运行、是否需要重编内核。
# 用法：./check_board_env.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOARD_CFG="${SCRIPT_DIR}/board.cfg"

# Load board.cfg
if [[ -f "${BOARD_CFG}" ]]; then
    while IFS='=' read -r key value; do
        [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs | sed 's/^["'\'']//;s/["'\'']$//')
        [[ -n "$key" ]] && export "$key"="${value}"
    done < "${BOARD_CFG}"
fi
BOARD_SSH_PORT="${BOARD_SSH_PORT:-22}"
TARGET="${BOARD_USER}@${BOARD_IP}"

SSH_OPTS=(-o StrictHostKeyChecking=no -o ConnectTimeout=10 -p "${BOARD_SSH_PORT}")
if [[ -n "${BOARD_PASSWORD}" ]] && command -v sshpass &>/dev/null; then
    SSH_CMD=(sshpass -p "${BOARD_PASSWORD}" ssh)
else
    SSH_CMD=(ssh)
fi
SSH_CMD+=("${SSH_OPTS[@]}")

echo "=========================================="
echo "TDA4VM board env check: ${TARGET}"
echo "=========================================="

run() {
    "${SSH_CMD[@]}" "${TARGET}" "$1"
}

echo ""
echo "--- uname ---"
run "uname -a"

echo ""
echo "--- kernel config (Falco relevant) ---"
for opt in CONFIG_BPF_SYSCALL CONFIG_BPF_EVENTS CONFIG_TRACING CONFIG_DEBUG_INFO CONFIG_DEBUG_INFO_BTF CONFIG_MODULES CONFIG_KALLSYMS; do
    v=$(run "grep -s \"^${opt}=\" /boot/config-\$(uname -r) 2>/dev/null || grep -s \"^${opt}=\" /proc/config.gz 2>/dev/null | zcat 2>/dev/null || echo \"\"" || true)
    [[ -z "$v" ]] && v="(not found)"
    echo "  $opt = $v"
done

echo ""
echo "--- /proc/sys/kernel ---"
run "ls /proc/sys/kernel 2>/dev/null | head -20"

echo ""
echo "--- Falco binary (if deployed) ---"
run "which falco 2>/dev/null; falco --version 2>/dev/null || echo 'falco not in PATH or not runnable'"

echo ""
echo "--- /opt/falco-test layout ---"
run "ls -la /opt/falco-test 2>/dev/null; ls /opt/falco-test/cases 2>/dev/null | head -5; ls /opt/falco-test/idps 2>/dev/null | head -5" || echo "/opt/falco-test not found"

echo ""
echo "=========================================="
echo "Done. Copy the above into EMBEDDED_TEST_LOG.md if needed."
echo "=========================================="
