#!/usr/bin/env bash
#
# 下载 Falco 官方 aarch64 预编译包，解压，并可选部署到板子、测试运行。
# 用法: ./download_and_deploy.sh [VERSION] [--deploy] [--test-run] [--modern-ebpf]
#   VERSION      默认 0.43.0
#   --deploy     部署到 board_test/board.cfg 中配置的板子
#   --test-run   部署后在板子上执行 falco --version（需先 --deploy）
#   --modern-ebpf 部署时启用 modern_ebpf 配置并禁用 container 插件，避免插件初始化错误
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
BOARD_CFG="${REPO_ROOT}/board_test/board.cfg"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'
log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error()   { echo -e "${RED}[ERR]${NC} $1"; }

# 解析参数：版本号与 --deploy / --test-run
FALCO_VERSION="0.43.0"
DEPLOY=false
TEST_RUN=false
MODERN_EBPF=false
for arg in "$@"; do
    case "$arg" in
        --deploy)       DEPLOY=true ;;
        --test-run)     TEST_RUN=true ;;
        --modern-ebpf)  MODERN_EBPF=true ;;
        *)  [[ "$arg" != --* ]] && [[ -n "$arg" ]] && FALCO_VERSION="$arg" ;;
    esac
done

BASE_URL="https://download.falco.org/packages/bin/aarch64"
TARBALL_NAME="falco-${FALCO_VERSION}-aarch64.tar.gz"
EXTRACT_DIR_NAME="falco-${FALCO_VERSION}-aarch64"

# 下载并解压
download_and_extract() {
    log_info "Falco 官方 aarch64 包: ${TARBALL_NAME}"
    local url="${BASE_URL}/${TARBALL_NAME}"
    local tarball="${SCRIPT_DIR}/${TARBALL_NAME}"
    local extract_dir="${SCRIPT_DIR}/${EXTRACT_DIR_NAME}"

    if [[ -d "${extract_dir}" ]]; then
        log_info "已存在解压目录 ${EXTRACT_DIR_NAME}，跳过下载解压（删除该目录可重新下载）"
        return 0
    fi

    log_info "下载: ${url}"
    if command -v curl &>/dev/null; then
        if ! curl -L -f -o "${tarball}" "${url}"; then
            log_error "下载失败。可尝试指定版本，例如: $0 0.44.0"
            exit 1
        fi
    elif command -v wget &>/dev/null; then
        if ! wget -q -O "${tarball}" "${url}"; then
            log_error "下载失败。可尝试指定版本，例如: $0 0.44.0"
            exit 1
        fi
    else
        log_error "需要 curl 或 wget"
        exit 1
    fi

    log_info "解压到 ${SCRIPT_DIR}"
    tar -xvf "${tarball}" -C "${SCRIPT_DIR}"
    if [[ ! -d "${extract_dir}" ]]; then
        log_error "解压后未找到目录 ${extract_dir}"
        exit 1
    fi
    log_success "已解压: ${extract_dir}"
}

# 部署到板子（读取 board_test/board.cfg）
deploy_to_board() {
    if [[ ! -f "${BOARD_CFG}" ]]; then
        log_error "未找到 ${BOARD_CFG}，无法部署"
        exit 1
    fi
    local extract_dir="${SCRIPT_DIR}/${EXTRACT_DIR_NAME}"
    if [[ ! -d "${extract_dir}" ]]; then
        log_error "请先执行下载解压（不带 --deploy 运行一次）"
        exit 1
    fi

    # 加载 board 配置
    BOARD_SSH_PORT="22"
    while IFS='=' read -r key value; do
        [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs | sed 's/^["'\'']//;s/["'\'']$//')
        [[ -n "$key" ]] && export "$key"="${value}"
    done < "${BOARD_CFG}"
    BOARD_SSH_PORT="${BOARD_SSH_PORT:-22}"
    TARGET="${BOARD_USER}@${BOARD_IP}"
    SSH_OPTS=(-o StrictHostKeyChecking=no -o ConnectTimeout=10 -p "${BOARD_SSH_PORT}")
    SCP_OPTS=(-o StrictHostKeyChecking=no -o ConnectTimeout=10 -P "${BOARD_SSH_PORT}")
    if [[ -n "${BOARD_PASSWORD}" ]] && command -v sshpass &>/dev/null; then
        SCP_CMD=(sshpass -p "${BOARD_PASSWORD}" scp)
        SSH_CMD=(sshpass -p "${BOARD_PASSWORD}" ssh)
    else
        SCP_CMD=(scp)
        SSH_CMD=(ssh)
    fi
    SCP_CMD+=("${SCP_OPTS[@]}")
    SSH_CMD+=("${SSH_OPTS[@]}")

    log_info "部署到 ${TARGET} ..."
    "${SSH_CMD[@]}" "${TARGET}" "mkdir -p ${BOARD_FALCO_BIN_DIR} ${BOARD_FALCO_ETC_DIR} ${BOARD_FALCO_SHARE_DIR}"

    if [[ -f "${extract_dir}/usr/bin/falco" ]]; then
        "${SCP_CMD[@]}" "${extract_dir}/usr/bin/falco" "${TARGET}:${BOARD_FALCO_BIN_DIR}/"
        "${SSH_CMD[@]}" "${TARGET}" "chmod +x ${BOARD_FALCO_BIN_DIR}/falco"
        log_success "falco -> ${BOARD_FALCO_BIN_DIR}/falco"
    else
        log_error "未找到 ${extract_dir}/usr/bin/falco"
        exit 1
    fi

    if [[ -d "${extract_dir}/etc/falco" ]]; then
        "${SCP_CMD[@]}" -r "${extract_dir}/etc/falco/"* "${TARGET}:${BOARD_FALCO_ETC_DIR}/" 2>/dev/null || true
        log_success "etc/falco -> ${BOARD_FALCO_ETC_DIR}"
    fi

    if [[ -d "${extract_dir}/usr/share/falco" ]]; then
        "${SCP_CMD[@]}" -r "${extract_dir}/usr/share/falco/"* "${TARGET}:${BOARD_FALCO_SHARE_DIR}/" 2>/dev/null || true
        log_success "usr/share/falco -> ${BOARD_FALCO_SHARE_DIR}"
    fi

    # 若存在 falcoctl
    if [[ -f "${extract_dir}/usr/bin/falcoctl" ]]; then
        "${SCP_CMD[@]}" "${extract_dir}/usr/bin/falcoctl" "${TARGET}:${BOARD_FALCO_BIN_DIR}/" 2>/dev/null && \
            "${SSH_CMD[@]}" "${TARGET}" "chmod +x ${BOARD_FALCO_BIN_DIR}/falcoctl" && log_success "falcoctl 已部署"
    fi

    # --modern-ebpf：部署 modern_ebpf 配置并禁用 container 插件，避免 "container_id / threads table" 与 "found another plugin" 错误
    if [[ "$MODERN_EBPF" == true ]]; then
        local config_dir="${SCRIPT_DIR}/config"
        local board_test_config="${SCRIPT_DIR}/../board_test/config"
        if [[ -f "${config_dir}/falco.modern_ebpf.official.yaml" ]]; then
            "${SSH_CMD[@]}" "${TARGET}" "mkdir -p ${BOARD_FALCO_ETC_DIR}/config.d"
            "${SCP_CMD[@]}" "${config_dir}/falco.modern_ebpf.official.yaml" "${TARGET}:${BOARD_FALCO_ETC_DIR}/config.d/"
            log_success "已部署 config.d/falco.modern_ebpf.official.yaml（engine: modern_ebpf, load_plugins: [], rules: falco_rules_embedded.yaml）"
            if [[ -f "${board_test_config}/falco_rules_embedded.yaml" ]]; then
                "${SCP_CMD[@]}" "${board_test_config}/falco_rules_embedded.yaml" "${TARGET}:${BOARD_FALCO_ETC_DIR}/"
                log_success "已部署 falco_rules_embedded.yaml（不依赖 container 插件）"
            fi
            # config.d 对 rules_files 是 append，必须覆盖主配置的 rules_files：生成仅含 falco_rules_embedded.yaml 的 falco.yaml 并覆盖板子
            local src_yaml="${extract_dir}/etc/falco/falco.yaml"
            local patched_yaml="${SCRIPT_DIR}/.falco.yaml.modern_ebpf.patched"
            if [[ -f "${src_yaml}" ]]; then
                awk '/^rules_files:/{print; print "  - /etc/falco/falco_rules_embedded.yaml"; skip=1; next} skip&&/^  - \/etc\/falco\//{next} skip{skip=0} {print}' "${src_yaml}" > "${patched_yaml}"
                "${SCP_CMD[@]}" "${patched_yaml}" "${TARGET}:${BOARD_FALCO_ETC_DIR}/falco.yaml"
                rm -f "${patched_yaml}"
                log_success "已覆盖板端 falco.yaml 的 rules_files 为仅 falco_rules_embedded.yaml"
            fi
            # 删除 config.d 下 container 相关配置，确保 Falco 只使用本目录的 load_plugins: []，不加载 container
            "${SSH_CMD[@]}" "${TARGET}" "rm -f ${BOARD_FALCO_ETC_DIR}/config.d/falco.container*.yaml ${BOARD_FALCO_ETC_DIR}/config.d/*container*.yaml ${BOARD_FALCO_ETC_DIR}/config.d/falco.container*.bak ${BOARD_FALCO_ETC_DIR}/config.d/*container*.yaml.bak 2>/dev/null; ls ${BOARD_FALCO_ETC_DIR}/config.d/"
            log_success "已删除 config.d 下 container 插件配置"
            # 若之前曾把 libcontainer.so 改名为 .bak，恢复回来（本次仅通过不加载插件避免冲突，不删除 .so）
            "${SSH_CMD[@]}" "${TARGET}" "if [ -f ${BOARD_FALCO_SHARE_DIR}/plugins/libcontainer.so.bak ] && [ ! -f ${BOARD_FALCO_SHARE_DIR}/plugins/libcontainer.so ]; then mv -n ${BOARD_FALCO_SHARE_DIR}/plugins/libcontainer.so.bak ${BOARD_FALCO_SHARE_DIR}/plugins/libcontainer.so && echo 'restored: libcontainer.so'; fi" 2>/dev/null || true
        else
            log_warn "未找到 ${config_dir}/falco.modern_ebpf.official.yaml，跳过 modern_ebpf 配置"
        fi
    fi

    log_success "部署完成。板端执行: ${BOARD_FALCO_BIN_DIR}/falco -c ${BOARD_FALCO_ETC_DIR}/falco.yaml"
}

# 在板子上测试运行（falco --version）
test_run_on_board() {
    if [[ ! -f "${BOARD_CFG}" ]]; then
        log_error "未找到 ${BOARD_CFG}"
        exit 1
    fi
    load_board_cfg() {
        while IFS='=' read -r key value; do
            [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
            key=$(echo "$key" | xargs)
            value=$(echo "$value" | xargs | sed 's/^["'\'']//;s/["'\'']$//')
            [[ -n "$key" ]] && export "$key"="${value}"
        done < "${BOARD_CFG}"
    }
    load_board_cfg
    BOARD_SSH_PORT="${BOARD_SSH_PORT:-22}"
    TARGET="${BOARD_USER}@${BOARD_IP}"
    SSH_OPTS=(-o StrictHostKeyChecking=no -o ConnectTimeout=10 -p "${BOARD_SSH_PORT}")
    if [[ -n "${BOARD_PASSWORD}" ]] && command -v sshpass &>/dev/null; then
        SSH_CMD=(sshpass -p "${BOARD_PASSWORD}" ssh)
    else
        SSH_CMD=(ssh)
    fi
    SSH_CMD+=("${SSH_OPTS[@]}")

    log_info "板端执行: falco --version"
    "${SSH_CMD[@]}" "${TARGET}" "${BOARD_FALCO_BIN_DIR}/falco --version" || true
    if [[ "$MODERN_EBPF" == true ]]; then
        log_info "板端启动测试（modern_ebpf，约 5 秒）: falco -c ${BOARD_FALCO_ETC_DIR}/falco.yaml"
        "${SSH_CMD[@]}" "${TARGET}" "timeout 5 ${BOARD_FALCO_BIN_DIR}/falco -c ${BOARD_FALCO_ETC_DIR}/falco.yaml 2>&1 || true" | head -30
        log_success "若上面无 'Error' 且出现 'Opening...' 或 'Enabled event sources'，则 modern_ebpf 启动正常"
    else
        log_info "若需实际跑引擎，请在板子上执行: ${BOARD_FALCO_BIN_DIR}/falco -c ${BOARD_FALCO_ETC_DIR}/falco.yaml（需已配置驱动：kmod 或 modern_ebpf）"
    fi
}

# main
download_and_extract

if [[ "$DEPLOY" == true ]]; then
    deploy_to_board
fi

if [[ "$TEST_RUN" == true ]]; then
    test_run_on_board
fi

log_success "完成。解压目录: ${SCRIPT_DIR}/${EXTRACT_DIR_NAME}"
