# Falco IDPS 配置与测试项目 — 综合概述

## 一、项目目的与功能

本项目是一个围绕 **Falco**（开源云原生运行时安全工具）构建的 **入侵检测与防御系统（IDPS）** 研究与工程化项目。其核心目标是：

1. **为嵌入式 Linux 平台（汽车 ECU）提供系统级安全监控能力**：基于 Falco 的 eBPF / 内核模块驱动，在操作系统层面实时监控进程、文件、网络、内核等异常行为。
2. **对齐 UN R155 法规要求**：所有检测用例严格映射到 **UN Regulation No. 155**（联合国汽车网络安全法规）的条款 7.2.2.2(g)/(h)、7.2.2.3、7.2.2.4，覆盖实时威胁检测、事件评估、结构化日志收集和持续监控。
3. **提供完整的端到端工作流**：从 x86 主机上的 Docker 模拟测试 → ARM64 交叉编译 → TI-TDA4VM 嵌入式开发板部署与远程测试，形成闭环。

### 核心检测能力（30 个 IDPS 用例）

项目定义了 **30 个系统级 IDPS 检测用例**（`SYS-*`），按类别涵盖：

| 类别 | 用例 ID | 检测内容 |
|------|---------|----------|
| 异常进程执行与提权 | SYS-PROC-001 ~ 005 | 非预期 uid/gid 执行、从可写目录执行、交互式 shell、sudo/su 提权、隐藏进程 |
| 文件系统篡改 | SYS-FILE-001 ~ 004 | /etc 写入、系统二进制目录修改、PAM/SSH/cron 篡改、systemd 单元文件修改 |
| 内核操作 | SYS-KERN-001 ~ 004 | 内核模块加载、ptrace 附加、capset 提权、mount/remount |
| 网络行为 | SYS-NET-001 ~ 004 | 外联连接、低端口监听、RAW 套接字/ping、AF_CAN 套接字（车载总线） |
| 容器安全 | SYS-CONT-001 ~ 004 | Docker 容器创建、特权容器、主机路径挂载、危险 capability |
| 资源滥用 | SYS-RES-001 ~ 003 | CPU 滥用（挖矿模式）、内存耗尽、fork 炸弹 |
| 日志篡改 | SYS-LOG-001 ~ 003 | 日志文件删除/截断、审计规则篡改、日志守护进程终止 |
| 物理接口 | SYS-PHY-001 ~ 003 | USB 存储设备、HID 设备、通用 USB 设备枚举 |

此外还包含 **12 个通用测试用例**（case1 ~ case12），覆盖敏感文件读取、端口扫描、反弹 shell、编码命令执行、进程注入、批量文件访问等场景。

---

## 二、主要组件与项目结构

```
falco-config/
├── README.md                          # 项目总体说明
├── QUICKSTART.md                      # 快速启动指南
├── Dockerfile                         # Ubuntu 22.04 容器镜像定义
├── docker-compose.yml                 # Docker Compose 编排（挂载内核追踪、/proc、Docker socket 等）
│
├── falco-config/                      # Falco 运行时配置（挂载到容器 /etc/falco）
│   ├── falco.yaml                     # Falco 主配置文件
│   ├── falco_rules.yaml               # Falco 默认规则
│   ├── falco_rules.local.yaml         # 自定义 IDPS 规则（30 条，对齐 R155）
│   └── config.d/                      # 可选配置片段（容器插件等）
│
├── scripts/                           # 自动化脚本
│   ├── setup_docker.sh                # 构建并启动 Docker 容器
│   ├── install_falco.sh               # Falco 安装脚本（支持 stable/latest/compile）
│   ├── test_falco.sh                  # Falco 安装后测试
│   └── cleanup.sh                     # 清理容器与镜像
│
├── test/                              # x86 Docker 环境下的测试用例
│   ├── examples/                      # 12 个通用测试脚本（case1 ~ case12）
│   ├── test_cases/                    # 30 个 IDPS 用例（SYS-*.sh）
│   │   ├── SYS-PROC-001.sh ~ SYS-PHY-003.sh
│   │   ├── run_all_idps_tests.sh      # 一键运行全部 30 条
│   │   ├── collect_logs_host.ps1      # PowerShell 日志采集脚本
│   │   ├── IDIADA_FALCO_LOGS/         # 真实 Falco 检测日志（文本格式）
│   │   ├── IDIADA_FALCO_LOGS_JSON/    # 真实 Falco 检测日志（JSON 格式）
│   │   └── IDIADA_COMPLIANCE_FALCO_LOGS.md  # IDIADA 合规报告
│   └── TESTING_NOTES.md               # 测试注意事项
│
├── cross_compile/                     # ARM64 交叉编译（面向 TI J721E/TDA4VM）
│   ├── build_falco.sh                 # 主构建脚本（clone → patch → configure → build → install）
│   ├── build.cfg                      # 构建配置（sysroot 路径、编译器、构建选项）
│   ├── toolchain-aarch64.cmake        # CMake 交叉编译工具链文件
│   ├── env.sh                         # 手动构建时的环境变量设置
│   ├── patches/                       # 交叉编译补丁（OpenSSL、TBB）
│   └── README.md
│
├── board_test/                        # 嵌入式开发板部署与远程测试
│   ├── board.cfg                      # 板子 SSH 配置（IP、用户、路径）
│   ├── deploy_to_board.sh             # 部署 Falco + 规则 + 测试脚本到板子
│   ├── run_tests_remote.sh            # 通过 SSH 远程运行测试
│   ├── collect_falco_json_log.sh      # 从板子拉取 JSON 合规日志
│   ├── check_board_env.sh             # 检查板子环境
│   ├── config/                        # 板端 Falco 配置变体
│   │   ├── falco.modern_bpf.board.yaml     # modern eBPF 引擎配置
│   │   ├── falco.embedded.board.yaml       # kmod 引擎配置
│   │   ├── falco.nodriver.board.yaml       # 无驱动模式配置
│   │   ├── falco.json_output.board.yaml    # JSON 告警输出配置
│   │   ├── falco.container_plugin.board.yaml
│   │   └── falco_rules_embedded.yaml       # 嵌入式专用规则（无容器字段）
│   ├── services/                      # Falco 服务脚本
│   │   ├── falco.service              # systemd 服务单元
│   │   ├── falco-start.sh             # 无 systemd 时的启动脚本
│   │   └── load-falco-ko.sh           # 内核模块加载脚本
│   ├── test_cases/                    # 嵌入式适配版 30 个 IDPS 用例
│   │   ├── common_embedded.sh         # 公共函数（check_falco_embedded）
│   │   ├── SYS-*.sh                   # 各用例（含检测验证 [DETECTED]/[NOT DETECTED]）
│   │   ├── run_auto_cases.sh          # 安全自动化用例（16 个）
│   │   ├── run_manual_cases.sh        # 需人工确认的用例（14 个）
│   │   └── run_all_embedded_cases.sh  # 全部运行
│   ├── embedded_tests/                # 极简嵌入式验证测试（3 个，无 Docker 依赖）
│   ├── driverkit/                     # Falco 驱动构建配置示例
│   └── KERNEL_CONFIG_TDA4_FALCO.md    # TDA4 内核配置说明
│
├── shadow/                            # 项目早期版本的备份/参考副本
│
└── docs/                              # 文档
    ├── System-Level-IDPS-v1.1.md      # IDPS 检测用例规范文档（R155 对齐）
    ├── COLLEAGUE_FEEDBACK_REPLY_CN.md # 同事反馈回复
    └── COLLEAGUE_FEEDBACK_SOLUTIONS.md # 反馈问题解决方案
```

---

## 三、关键技术与依赖

### 核心技术

| 技术 | 用途 |
|------|------|
| **Falco** (0.42+) | 运行时安全监控引擎，基于系统调用捕获进行规则匹配 |
| **eBPF (modern_ebpf)** | Falco 推荐的数据采集驱动，无需编译内核模块（需 Linux 5.8+ 且支持 BTF） |
| **kmod (falco.ko)** | 备选的 Falco 内核模块驱动，适用于不支持 modern eBPF 的内核 |
| **Docker / Docker Compose** | x86 开发环境容器化，模拟 Ubuntu 22.04 测试环境 |
| **CMake + GCC ARM 11.x** | ARM64 (aarch64) 交叉编译工具链 |
| **TI Processor SDK** | 目标平台 sysroot（TI J721E/TDA4VM EVM） |

### 目标硬件平台

- **TI TDA4VM (J721E)**：汽车级 SoC，ARM Cortex-A72 (aarch64)
- 使用 TI Processor SDK Linux ADAS J721E EVM 09.02.00.05 的 sysroot

### 软件依赖

**Docker 容器内（x86 测试）**：
- Ubuntu 22.04、curl、gnupg、clang、llvm、vim、net-tools、iputils-ping、strace、auditd、netcat、python3、docker.io

**交叉编译主机**：
- CMake 3.16+、Git、Make、wget
- GCC ARM 11.x 交叉编译器 (`aarch64-none-linux-gnu`)
- clang + llvm（modern eBPF 构建时需要）
- libelf-dev、zlib1g-dev（bpftool 构建时需要）

### 合规标准

- **UN Regulation No. 155 (R155)**：联合国汽车网络安全法规
- **IDIADA** 合规验证：项目包含完整的 IDIADA 合规检测日志（文本 + JSON 格式）

---

## 四、构建与使用方法

### 方式一：Docker 快速体验（x86 主机）

适合在开发机上快速验证 Falco 检测能力。

```bash
# 1. 构建并启动 Docker 容器
chmod +x scripts/setup_docker.sh
./scripts/setup_docker.sh

# 2. 进入容器并安装 Falco
docker exec -it falco-test-ubuntu bash
sudo /tmp/install_falco.sh          # 默认安装稳定版
# 其他选项：sudo /tmp/install_falco.sh latest | compile | stable 0.42.0

# 3. 启动 Falco（在容器内）
sudo falco -c /etc/falco/falco.yaml &

# 4. 运行测试用例（在另一个终端进入容器）
docker exec -it falco-test-ubuntu bash
cd /opt/falco-test
bash cases/case1_sensitive_file_opening.sh       # 单个通用用例
bash test_cases/SYS-PROC-001.sh                  # 单个 IDPS 用例
bash test_cases/run_all_idps_tests.sh            # 全部 30 个 IDPS 用例

# 5. 查看 Falco 告警日志
tail -f /var/log/falco.log
```

**安装选项说明**：

| 命令 | 说明 |
|------|------|
| `sudo /tmp/install_falco.sh` | 安装官方稳定版（默认） |
| `sudo /tmp/install_falco.sh latest` | 安装最新版 |
| `sudo /tmp/install_falco.sh compile` | 从源码编译（推荐，避免版本兼容问题） |
| `sudo /tmp/install_falco.sh stable 0.42.0` | 安装指定版本 |

### 方式二：交叉编译 + 板级部署（嵌入式目标）

适合将 Falco 部署到 TI-TDA4VM 等 ARM64 嵌入式开发板。

**第一步：交叉编译**

```bash
cd cross_compile

# 编辑 build.cfg 配置 sysroot 路径和编译器路径
# 关键配置项：
#   SYSROOT        - TI SDK sysroot 路径
#   CROSS_COMPILE_PREFIX - GCC ARM 工具链路径
#   BUILD_MODERN_BPF     - ON（推荐）或 OFF
#   BUILD_KMOD           - ON（当 modern eBPF 不可用时需要 falco.ko）

chmod +x build_falco.sh
./build_falco.sh all    # 完整构建：clone → patch → configure → build → install
```

构建产物在 `cross_compile/install/` 下：
- `bin/falco`（~5.6MB，已 strip）
- `etc/falco/`（配置文件）
- `share/falco/`（规则文件、插件、可选 falco.ko）

**第二步：部署到开发板**

```bash
cd board_test

# 编辑 board.cfg 配置板子 IP 和 SSH 信息
# 关键配置项：
#   BOARD_IP       - 板子 IP（默认 192.168.1.3）
#   BOARD_USER     - SSH 用户（默认 root）
#   BOARD_PASSWORD - SSH 密码（留空则用密钥）

./deploy_to_board.sh              # 完整部署（Falco + 规则 + 服务 + 测试脚本）
./deploy_to_board.sh --falco-only # 仅部署 Falco 二进制
./deploy_to_board.sh --rules-only # 仅部署规则和 JSON 输出配置
./deploy_to_board.sh --tests-only # 仅部署测试脚本
```

**第三步：远程运行测试**

```bash
cd board_test

./run_tests_remote.sh                     # 全部（idps + cases）
./run_tests_remote.sh cases               # 仅嵌入式适配用例（AUTO 安全子集）
./run_tests_remote.sh cases-all           # 全部嵌入式用例（AUTO + MANUAL）
./run_tests_remote.sh idps                # 仅原始 IDPS 用例
./run_tests_remote.sh SYS-PROC-001       # 单个用例
./run_tests_remote.sh --start-falco all   # 先启动 Falco 再运行全部
```

**第四步：采集合规日志**

```bash
cd board_test
./collect_falco_json_log.sh               # 从板子拉取 JSON 格式告警日志
./collect_falco_json_log.sh audit.jsonl    # 指定输出文件名
```

---

## 五、关键目录用途说明

### `board_test/` — 嵌入式开发板部署与测试

**用途**：将交叉编译产物部署到 TI-TDA4VM 开发板，并通过 SSH 远程执行 IDPS 测试、采集合规日志。

**关键特性**：
- 与 `cross_compile/` 解耦，专注于部署与测试环节
- 提供多种 Falco 引擎配置（modern eBPF / kmod / nodriver）
- 嵌入式适配的测试脚本：不依赖 Docker，使用 `check_falco_embedded` 替代 `pgrep -x falco`
- 用例分为 AUTO（16 个安全自动化）和 MANUAL（14 个可能影响系统）两类
- 支持 systemd 服务管理和无 systemd 的手动启动
- JSON 格式告警输出，便于合规审计

**子目录**：
- `config/`：板端 Falco 配置文件变体（modern_ebpf / kmod / nodriver / json_output / 嵌入式规则）
- `services/`：Falco systemd 服务单元、启动脚本、内核模块加载脚本
- `test_cases/`：30 个嵌入式适配 IDPS 用例，含检测结果验证（`[DETECTED]` / `[NOT DETECTED]`）
- `embedded_tests/`：3 个极简验证测试（exec_from_tmp、write_etc、read_shadow），用于快速确认 Falco 基本检测能力
- `driverkit/`：Falco 驱动构建配置示例

### `cross_compile/` — ARM64 交叉编译

**用途**：在 x86_64 主机上为 ARM64 目标平台（TI J721E/TDA4VM）交叉编译 Falco。

**关键特性**：
- 完整的自动化构建脚本（`build_falco.sh`），一键完成源码下载、补丁应用、配置、编译、安装
- CMake 工具链文件（`toolchain-aarch64.cmake`），配置交叉编译器、sysroot、链接路径
- 自动修补 Falco 依赖库（TBB、OpenSSL、zlib、jsoncpp、re2）的交叉编译问题
- 自动修正 container 插件架构选择（确保下载 aarch64 版本而非 x86_64）
- 支持 modern eBPF 和 kmod 两种驱动模式的构建
- 可选构建 `falco.ko` 内核模块（需配置目标内核源码路径）

**构建产物**：`install/bin/falco`（~5.6MB）、`install/etc/falco/`、`install/share/falco/`

### `shadow/` — 项目早期版本备份

**用途**：保存项目早期阶段的代码和配置副本，作为历史参考。

**内容**：包含早期版本的 Dockerfile、docker-compose.yml、Falco 配置、安装脚本和部分测试用例（SYS-CONT/FILE/KERN/NET/LOG/PHY）。与主项目结构类似但功能较少，不包含交叉编译和板级部署能力。

### `test/` — x86 Docker 环境测试用例

**用途**：在 x86 Docker 容器中验证 Falco 的检测能力，包含两类测试：

1. **通用测试用例**（`examples/`，12 个）：覆盖敏感文件读取、系统目录写入、端口扫描、提权、可疑进程、文件权限修改、反弹 shell、系统文件修改、编码命令执行、网络异常、进程注入、批量文件访问。

2. **IDPS 标准用例**（`test_cases/`，30 个 `SYS-*.sh`）：严格对齐 System-Level IDPS v1.1 规范文档，每个用例输出预期基线、异常条件、证据字段。包含 IDIADA 合规验证的真实 Falco 检测日志（`.log` 文本格式和 `.json` 结构化格式）。

**与 `board_test/test_cases/` 的区别**：`test/` 中的用例面向 Docker 环境，使用 `pgrep -x falco` 检查进程并支持交互式提示；`board_test/test_cases/` 是嵌入式适配版本，移除了 Docker 依赖和交互式提示，使用更鲁棒的 `check_falco_embedded` 检查，并增加了 `[DETECTED]` / `[NOT DETECTED]` 结果验证。

---

## 六、项目工作流总结

```
┌─────────────────────────────────────────────────────────────────────┐
│                        开发与验证流程                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  x86 主机 (Docker)                                                  │
│  ┌──────────────────┐    ┌──────────────────┐                      │
│  │ 1. 规则开发与调试  │───→│ 2. Docker 内测试  │                      │
│  │ falco_rules.      │    │ test/examples/   │                      │
│  │ local.yaml        │    │ test/test_cases/  │                      │
│  └──────────────────┘    └──────────────────┘                      │
│           │                                                         │
│           ▼                                                         │
│  ┌──────────────────┐                                              │
│  │ 3. 交叉编译       │                                              │
│  │ cross_compile/    │                                              │
│  │ build_falco.sh    │                                              │
│  └──────────────────┘                                              │
│           │                                                         │
│           ▼                                                         │
│  ┌──────────────────┐    ┌──────────────────┐                      │
│  │ 4. 部署到板子     │───→│ 5. 远程测试与     │                      │
│  │ board_test/       │    │    合规日志采集   │                      │
│  │ deploy_to_board   │    │ run_tests_remote │                      │
│  └──────────────────┘    │ collect_json_log  │                      │
│                          └──────────────────┘                      │
│                                                                     │
│  目标板 (TI-TDA4VM, ARM64)                                         │
│  ┌──────────────────────────────────────────┐                      │
│  │ Falco + IDPS 规则 + modern eBPF/kmod     │                      │
│  │ → 实时系统调用监控 → JSON 告警日志         │                      │
│  └──────────────────────────────────────────┘                      │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

本项目实现了从安全规则开发、桌面验证、嵌入式交叉编译到板级部署与合规测试的完整链路，为汽车 ECU 的系统级入侵检测提供了可复现、可审计的工程化方案。
