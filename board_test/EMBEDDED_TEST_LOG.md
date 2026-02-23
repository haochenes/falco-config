# TDA4VM 嵌入式板端测试记录

板子首次跑 Falco + IDPS 测试的问题与解决方案记录。若内核不支持 Falco 所需特性，会在此说明并建议你重新编译内核。

---

## 板子环境（请先运行 `./check_board_env.sh` 填到此处）

| 项目 | 值 |
|------|-----|
| 内核版本 | 6.1.80-ti-g2e423244f8c0 (J721E EVM) |
| 架构 | aarch64 |
| Falco 二进制 | /usr/local/bin/falco (已部署) |
| Falco 运行方式 | 待测（依赖 driver/plugin 配置） |
| /proc/sys/kernel 存在 | 是（bpf_stats_enabled 等存在，说明部分 BPF 可能可用） |
| 内核 config 文件 | 未在 /boot 或 /proc/config.gz 找到，无法直接确认 CONFIG_BPF_* 等 |

---

## 测试执行记录

### 1. 环境检查（首次必做）

```bash
cd board_test
./check_board_env.sh
```

- 若输出里提示缺少 `CONFIG_DEBUG_INFO`、`CONFIG_BPF_*`、`CONFIG_TRACING` 等，且 Falco 报错，则需要**重新编译内核**并打开对应选项。

### 2. 运行测试

```bash
# 启动 Falco 并跑全部测试
./run_tests_remote.sh --start-falco all

# 或只跑 IDPS
./run_tests_remote.sh --start-falco idps
```

---

## 问题与解决方案

_（下面按时间顺序记录：现象 → 原因 → 解决/待办）_

---

### 问题 1：部署时提示 test/examples 或 test/test_cases not found

**现象**  
`[WARN] test/examples not found: .../test/cases` 或 `test/test_cases not found: .../test/idps`

**原因**  
脚本里测试用例路径仍为旧目录 `test/cases`、`test/idps`，而 master 已改为 `test/examples`、`test/test_cases`。

**解决**  
已在 `deploy_to_board.sh` 中改为：
- `TEST_CASES_DIR="${REPO_ROOT}/test/examples"`
- `TEST_IDPS_DIR="${REPO_ROOT}/test/test_cases"`
- 成功/失败日志统一为 "test/examples"、"test/test_cases"。

---

### 问题 2：Plugin requirement not satisfied, must load one of: container (>= 0.4.0)

**现象**  
直接运行 `falco -c /etc/falco/falco.yaml` 报错：必须加载 container 插件。

**原因**  
- 默认配置启用了 container 插件，且规则文件里有 `required_plugin_versions: container`。
- 交叉编译产出的 `libcontainer.so` 为 **x86_64**，板子是 **aarch64**，无法加载。

**解决**  
- 在 `board_test/config/` 下增加嵌入式用配置与规则：
  - `falco.embedded.board.yaml`：`load_plugins: []`、`engine.kind: kmod`、`rules_files: [falco_rules_embedded.yaml]`。
  - `falco_rules_embedded.yaml`：仅主机侧规则，不引用 `container.*`。
- 部署时删除 `config.d/falco.container_plugin.yaml`，并部署上述两个文件；部署脚本会改写板端 `falco.yaml` 的 `rules_files`，只加载嵌入式规则文件。

---

### 问题 3：MODERN_BPF engine is not supported in this build

**现象**  
不加载 container 后，Falco 报 modern_ebpf 在此构建中不支持。

**原因**  
当前 Falco 交叉编译未启用或未包含 modern_ebpf 驱动（build.cfg 中 BUILD_MODERN_BPF=OFF）。

**解决**  
- **短期**：在 `falco.embedded.board.yaml` 中设置 `engine.kind: kmod`，使用内核模块驱动（需单独编 falco.ko）。
- **推荐**：在 `cross_compile/build.cfg` 中设 `BUILD_MODERN_BPF=ON` 后重新编译 Falco，板端使用 `engine.kind: modern_ebpf`，无需 .ko，性能与兼容性更好（Falco 0.32+ 默认推荐）。

---

### 问题 4：error opening device /dev/falco0 ... falco module is loaded

**现象**  
使用 kmod 后报错：无法打开 `/dev/falco0`，提示需加载 falco 内核模块。

**原因**  
板端未加载 Falco 内核模块（falco.ko），/dev/falco0 不存在。

**解决**  
- 需为当前板子内核编译并部署 Falco 内核模块（与 `uname -r` 一致），或**改用 modern eBPF**（推荐）：在 cross_compile 中设 `BUILD_MODERN_BPF=ON` 重新编译，板端配置 `engine.kind: modern_ebpf`，无需 .ko。
- `falco-start.sh` 已增加：若存在 `falco.ko` 则自动 `insmod`。
- 若 cross_compile 流程中会产出 kmod，需在 `deploy_to_board.sh` 中增加对 falco.ko 的拷贝与加载步骤。
- **TDA4 内核需开启的配置**：见 [KERNEL_CONFIG_TDA4_FALCO.md](KERNEL_CONFIG_TDA4_FALCO.md)。

---

### 问题 5：配置了 engine.kind: modern_ebpf 仍然报错 /dev/falco0、Events detected: 0

**现象**  
板端已放入 `falco.modern_bpf.board.yaml`（或手动设置了 `engine.kind: modern_ebpf`），但 Falco 仍报：`error opening device /dev/falco0 ... No such file or directory`，且 Events detected: 0。

**原因**  
- **/dev/falco0 是 kmod 驱动用的设备**；modern eBPF 根本不用这个设备，用的是内核 BPF 子系统。
- 若仍出现 /dev/falco0 报错，说明**当前运行的 Falco 二进制里没有 modern_ebpf 引擎**，实际用的还是 kmod，所以会去打开 /dev/falco0。
- 当前交叉编译为了在没有 clang 的环境下通过，在 `build.cfg` 中使用了 `BUILD_MODERN_BPF=OFF`，且 `MINIMAL_BUILD=ON` 时构建脚本会强制关闭 modern BPF。因此**当前部署的 Falco 二进制不包含 modern_ebpf**，配置里写 `engine.kind: modern_ebpf` 会被忽略或回退到 kmod。

**解决**  
二选一：

1. **真正启用 modern eBPF（推荐，无需 .ko）**  
   - 在**编译主机**上安装 **clang**（及可选 llvm），例如：`apt install clang llvm`.  
   - 在 `cross_compile/build.cfg` 中：`BUILD_MODERN_BPF=ON`，且 **MINIMAL_BUILD=OFF**（否则现有 patch 会强制关掉 modern BPF）。  
   - 重新执行 `./build_falco.sh all`，再部署到板子。  
   - 板端确保使用 `engine.kind: modern_ebpf` 的配置（如把 `config/falco.modern_bpf.board.yaml` 拷到板子 `/etc/falco/config.d/`，并去掉或覆盖掉指定 `kmod` 的 config.d 文件）。  
   - 板端内核需支持 BTF（通常 5.8+），见 [KERNEL_CONFIG_TDA4_FALCO.md](KERNEL_CONFIG_TDA4_FALCO.md)。

2. **继续用 kmod**  
   - 保持 `engine.kind: kmod`，为板子内核编译并加载 falco.ko，使 `/dev/falco0` 存在后再运行 Falco。

---

### 交叉编译 + 部署 + 启动测试（2026-01-10）

**执行**：`./build_falco.sh all`（未改 BUILD_MODERN_BPF）→ `./deploy_to_board.sh` → 板端 `falco -c /etc/falco/falco.yaml`。

**结果**：
- 部署成功：二进制、配置、libcontainer.so、falco-start.sh、测试脚本均就绪。
- Falco 能启动并完成配置与插件加载（container@0.6.1），规则加载正常。
- **无法打开 syscall 源**：`Opening 'syscall' source with Kernel module` → `Unable to load the driver` → `error opening device /dev/falco0`（板端未加载 falco.ko）。

**结论**：当前缺的是**驱动**二选一：
1. **kmod**：为板子内核编译并部署 `falco.ko`，在板端 `insmod` 后 Falco 即可用。
2. **modern eBPF**：在交叉编译环境安装 **clang/LLVM**（用于 BPF 编译），在 `build.cfg` 中设 `BUILD_MODERN_BPF=ON` 后重新编译 Falco，板端配置 `engine.kind: modern_ebpf`（无需 .ko）。尝试 `BUILD_MODERN_BPF=ON` 时曾报错：`[MODERN BPF] unable to find clang`，需先安装 clang 再打开该选项。

---

### 内核相关说明（TDA4 / Falco）

- **Falco 依赖**（按常见用法）：
  - 若用 **eBPF**：需内核支持 BPF、BTF、tracepoint；部分发行版需 `CONFIG_DEBUG_INFO_BTF=y`。
  - 若用 **kmod**：需能加载内核模块，且版本与当前内核一致。
  - **nodriver**：仅读 capture 文件，不依赖内核驱动，适合先做基础功能验证。
- **TDA4 内核**：TI SDK 内核可能未打开上述选项。若 Falco 报 “driver not found”“BPF not supported” 或 “Plugin requirement not satisfied (must load one of: ...)”，请：
  1. 运行 `./check_board_env.sh` 保存输出；
  2. 在本文件“问题 N”中记录完整报错；
  3. 若确认为内核缺选项，会在此写明需要**重新编译内核**并打开哪些 `CONFIG_*`。

---

## 建议下一步（首次板端测试）

1. **重新部署**（含路径修复与 container 插件禁用）：  
   `./deploy_to_board.sh`  
   确认无 `test/examples` / `test/test_cases` 的 WARN，且 Falco 配置已覆盖。

2. **板子上验证 Falco**：  
   `ssh root@192.168.1.3 '/usr/local/bin/falco --dry-run -c /etc/falco/falco.yaml'`  
   若仍报 driver/plugin 相关错误，把完整输出记入本 log。

3. **跑测试**：  
   `./run_tests_remote.sh --start-falco idps` 或 `./run_tests_remote.sh --start-falco all`  
   把失败用例与报错贴到本文件“问题 N”。

---

_（后续问题继续按“问题 N”追加到本文件即可）_
