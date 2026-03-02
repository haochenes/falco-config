# 官方 Falco aarch64 二进制包 — 下载与部署

本目录用于**下载、解压并部署** Falco 官方发布的 aarch64 预编译包，无需自行交叉编译。

- 官方下载根地址：<https://download.falco.org/packages/bin/aarch64/>
- 包名格式：`falco-<VERSION>-aarch64.tar.gz`，解压后目录为 `falco-<VERSION>-aarch64/`（内含 `usr/`、`etc/`、`usr/share/falco/` 等，与系统根布局一致）。

## 依赖

- `curl` 或 `wget`（用于下载）
- 部署到板子时：SSH/SCP，可选 `sshpass`（见 `board_test/board.cfg`）

## 用法

```bash
# 下载并解压（默认版本 0.43.0），解压到 official_aarch64/falco-<VERSION>-aarch64/
./download_and_deploy.sh

# 指定版本（0.40.0 已测试可下载、部署、板端 falco --version 通过）
./download_and_deploy.sh 0.40.0

# 下载解压后部署到板子（需先配置 board_test/board.cfg）
./download_and_deploy.sh 0.40.0 --deploy

# 部署并在板子上执行 falco --version 做冒烟测试
./download_and_deploy.sh 0.40.0 --deploy --test-run

# 使用 modern_ebpf 方式测试（推荐）：部署时写入 modern_ebpf 配置并禁用 container 插件，避免启动报错
./download_and_deploy.sh 0.40.0 --deploy --modern-ebpf

# 部署 + modern_ebpf + 板端短时启动测试（约 5 秒）
./download_and_deploy.sh 0.40.0 --deploy --modern-ebpf --test-run
```

若某版本下载失败，可尝试其他版本号（如 0.40.0、0.43.0 等）。

### 关于 “container_id / threads table” 错误

板端若直接执行 `falco -c /etc/falco/falco.yaml`，可能报错：

```text
Error: could not initialize plugin: cannot add the 'container_id' field into the 'threads' table
```

原因是默认或已有配置加载了 **container 插件**，与当前 Falco/libscap 的表结构不兼容。**规避方式**：使用本目录的 `--modern-ebpf` 流程：

- 会部署 `config/falco.modern_ebpf.official.yaml` 到板子 `config.d/`（`engine.kind: modern_ebpf`，`load_plugins: []`）。
- 会将 `config.d` 下与 container 相关的 YAML 重命名为 `.bak`。
- 会将板端 `.../plugins/libcontainer.so` 重命名为 `libcontainer.so.bak`，避免主配置中的 `load_plugins` 仍加载该插件（否则会报 “found another plugin with name container”）。

板端要求：使用 modern eBPF 时内核需支持 BTF 及 Falco 所需 eBPF 程序（如 `BPF_TRACE_RAW_TP`）；若出现 “prog 'BPF_TRACE_RAW_TP' is not supported”，多为当前内核或预编译 probe 与官方包不匹配，可尝试在板子上自编译 Falco 或使用 kmod 驱动。

## 目录结构（脚本运行后）

```
official_aarch64/
├── README.md
├── download_and_deploy.sh
├── config/
│   └── falco.modern_ebpf.official.yaml   # modern_ebpf 用配置（--modern-ebpf 时部署到板子 config.d/）
├── falco-0.43.0-aarch64.tar.gz   # 下载的压缩包（可选保留）
└── falco-0.43.0-aarch64/         # 解压后的根布局
    ├── usr/
    │   ├── bin/falco
    │   └── share/falco/
    └── etc/falco/
```

## 板端要求

- GLIBC 2.28+（官方文档要求）
- 若使用 kmod：需自行安装或编译与板端内核匹配的 falco 驱动（官方包可能不包含你的内核的 .ko）
- 若使用 modern eBPF：内核需支持 BTF（通常 5.8+）
