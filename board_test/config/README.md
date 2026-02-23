# Board-specific Falco config (embedded / no container)

Used when deploying Falco to the TI-TDA4VM (or other aarch64 embedded) board.

**现代推荐：** 若 Falco 编译时开启了 **BUILD_MODERN_BPF=ON**，优先使用 **modern eBPF**：无需编 falco.ko，在 config.d 中选用 `falco.modern_bpf.board.yaml`（`engine.kind: modern_ebpf`），性能与兼容性更好（Falco 0.32+ 默认推荐）。板端也可用 `falco-driver-loader modern-bpf` 加载驱动。

- **falco.modern_bpf.board.yaml** – `engine.kind: modern_ebpf`，无 .ko；需 Falco 构建含 modern-bpf 且内核支持 BTF（通常 5.8+）。

- **falco.embedded.board.yaml** – `engine.kind: kmod`，使用内核模块（需 falco.ko）。适用于未包含 modern_ebpf 的构建。

- **falco_rules_embedded.yaml** – 主机侧规则（无 `container.*`），用于嵌入式/无容器场景。

- **falco.container_plugin.board.yaml** – 当板上有 aarch64 `libcontainer.so` 时使用：启用 container 插件、完整规则；可与 kmod 或（若支持）modern_ebpf 搭配。

**kmod 路径：** 若使用 `engine.kind: kmod`，需为板子内核编并部署 falco.ko（见 [falcosecurity/libs](https://github.com/falcosecurity/libs) driver 或 driverkit），并放到 `/usr/share/falco/` 等；`falco-start.sh` 会在存在时尝试加载。
