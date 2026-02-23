# Chen Shi 反馈回复

感谢细致的 review，针对每条意见的回复与说明如下。

---

## 一、日志格式（JSON）

**意见**：当前为纯文本，建议使用 JSON 方便采集与分析。

**回复**：采纳。Falco 支持 `json_output: true`，输出为结构化 JSON，后续会在 falco.yaml 中开启，并调整 collect_logs_host.ps1 的解析逻辑以适配 JSON。

---

## 二、清理步骤触发告警

**意见**：truncate 等清理操作会触发告警，影响 pass/fail 判读。

**回复**：采纳。将改为按时间戳采集：每个 case 执行前记录时间，采集时只保留该时间点之后的事件，不再使用 truncate，避免清理操作产生的误报。

---

## 三、SYS-FILE 规则重叠（001 遮盖 003、004）

**意见**：SYS-FILE-001 过宽，导致 003、004 被其覆盖。

**回复**：采纳。将收紧 SYS-FILE-001 条件，排除 `/etc/pam.d`、`/etc/cron*`、`/etc/systemd`、`/lib/systemd`、`authorized_keys`、`*.service`、`*.timer` 等路径，或调整规则顺序，使 003、004 能单独触发。原则是：每类路径对应独立规则，避免宽规则遮蔽细分场景。

---

## 四、告警缺少关键字段

**意见**：网络、容器、USB 告警缺少 remote IP/port、socket 类型、挂载信息、USB VID/PID/serial 等。

**回复**：

- **网络**：会在规则 output 中补充 `fd.sip`、`fd.dip`、`fd.sport`、`fd.dport`、`fd.lport` 等。
- **容器**：挂载信息依赖 Falco 容器插件的字段，当前 Docker 环境以进程级检测为主，挂载详情可能需结合 `evt.args` 或自定义插件获取。
- **USB**：**受 Docker 环境限制**。容器内无法物理接入 USB，当前 SYS-PHY 系列通过 `udevadm info -e`、`lsusb` 或脚本名做近似检测。真实 VID/PID/serial 需在**真实嵌入式环境**下，连接实际 USB 设备后由 udev/sysfs 事件采集验证。

---

## 五、SYS-NET-004 误报（cmdline 子串）

**意见**：规则通过 cmdline 中的 "SOCK_RAW" 匹配，易误报；应用 socket 字段（family/type/proto）判断 AF_CAN。

**回复**：采纳。将改为基于 `evt.type=socket` 与 `evt.arg.domain`（AF_CAN）进行判断，不再依赖 cmdline，从 syscall 参数层面精准识别 AF_CAN socket 创建。

---

## 六、SYS-NET-002 无告警；SYS-RES-001 误报

**意见**：SYS-NET-002 无告警；SYS-RES-001 因匹配 settimeout() 中的 "time" 产生误报。

**回复**：

- **SYS-NET-002**：将增加基于 `evt.type=bind` 与 `fd.lport` 的规则（如 `fd.lport < 1024` 或指定端口），用于检测低端口监听。
- **SYS-RES-001**：将收紧条件，避免匹配 `settimeout()` 等常见调用。例如限定为 `proc.name=yes`，或对 python3 要求 cmdline 中包含 `yes`、`while True`、`/dev/null` 等 CPU 滥用典型模式，排除含 "time" 的普通 API 调用。

---

## 七、SYS-PROC-002 规则范围

**意见**：应检测从 /tmp 执行的程序，而非仅 cmdline 中提及 /tmp。

**回复**：采纳。将移除 `proc.cmdline contains "/tmp/sys_proc_002"`，仅保留 `proc.exepath startswith /tmp/`（及 `/var/tmp/`、`/dev/shm/`）。exepath 表示实际执行路径，可避免“仅引用路径但未执行”的误报。

---

## 八、SYS-LOG-003 target_pid 错误

**意见**：target_pid 显示为 bash 而非数字 PID。

**回复**：需要排查 Falco 对 kill/tkill/tgkill 的字段映射。`evt.arg.pid` 理论上应为目标 PID；若输出异常，可能涉及参数顺序或字段名差异。会在本地核对 Falco 文档及实际输出，确定正确字段并修正 output 模板。若为 Falco 内核事件解析问题，可能需要查看其 syscall 表或上游 issue。

---

## 九、SYS-LOG-002 未触发真实异常

**意见**：测试仅列出规则，未真实修改/删除；建议真实测试放在 flag 后并做回滚。

**回复**：采纳。将增加 `--execute` 参数：
- 默认：只执行 `auditctl -l`，不修改规则；
- 带 `--execute`：备份规则 → 执行 `auditctl -D` → 采集 → 从备份恢复；
- 使用 `trap` 保证异常退出时也能回滚。

---

## 十、Docker 与真实嵌入式环境的差异说明

当前测试在 **Docker Ubuntu** 中完成，部分用例因环境限制采用替代或近似实现：

| 类别 | Docker 限制 | 真实嵌入式环境建议 |
|------|-------------|---------------------|
| **USB（SYS-PHY）** | 无真实 USB 设备 | 需在目标板接 USB 存储/HID 等，结合 udev 验证 VID/PID/serial |
| **AF_CAN（SYS-NET-004）** | 通常无 CAN 控制器 | 需在带 CAN 的 ECU/工控板上验证 socket(29) 检测 |
| **内核模块（SYS-KERN-001）** | 容器内 insmod 受限 | 在真实内核环境测试 modprobe/insmod |
| **挂载（SYS-KERN-004）** | 容器挂载与宿主机不同 | 在目标系统上测试 remount、umount 等 |
| **容器相关（SYS-CONT）** | 在宿主机发起 docker run | 与车载/嵌入式容器运行时对齐场景 |
| **auditd（SYS-LOG-002）** | 容器内 audit 配置可能不同 | 在目标系统验证规则变更与回滚 |

以上用例在 Docker 中主要用于**规则逻辑与 Falco 行为验证**；**合规与最终结论**宜在真实嵌入式/车载环境复测。

---

## 实施计划摘要

| 序号 | 项目 | 计划 |
|------|------|------|
| 1 | JSON 输出 | 开启 Falco json_output，调整采集脚本 |
| 2 | 采集流程 | 改为按时间戳采集，去除 truncate |
| 3 | SYS-FILE 规则 | 收紧 001，排除 003/004 路径，或调整顺序 |
| 4 | 告警字段 | 补充网络字段；容器/USB 视 Falco 能力逐步完善 |
| 5 | SYS-NET-004 | 使用 evt.type=socket + evt.arg.domain |
| 6 | SYS-NET-002 / SYS-RES-001 | 新增 bind 规则；收紧 SYS-RES-001 条件 |
| 7 | SYS-PROC-002 | 移除 cmdline 条件，仅用 exepath |
| 8 | SYS-LOG-003 | 核对 kill 事件字段，修正 target_pid |
| 9 | SYS-LOG-002 | 增加 --execute 及回滚逻辑 |

再次感谢，后续按上述计划逐步落实，并在真实嵌入式环境做补充验证。
