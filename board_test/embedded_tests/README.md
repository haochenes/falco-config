# Embedded tests (no Docker)

用于 TDA4VM 等嵌入式 Linux 的 Falco 检测测试，**不依赖 Docker**，只用 sh 和常用命令。

| 脚本 | 行为 | Falco 可能触发的规则 |
|------|------|----------------------|
| 01_exec_from_tmp.sh | 在 /tmp 创建并执行脚本 | exec from writable dir / non-allowlisted |
| 02_write_etc.sh | 在 /etc 下 touch 一个文件 | File below /etc opened for writing |
| 03_read_shadow.sh | 读取 /etc/shadow 第一行 | Sensitive file opened for reading |
| run_all.sh | 顺序执行 01～03 | - |

**部署与运行**（在 `board_test` 目录）：

```bash
./deploy_to_board.sh
./run_tests_remote.sh --start-falco embedded
```

板子上 Falco 日志：`/var/log/falco.log`。
