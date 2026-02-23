# Board-Level Test (TI-TDA4VM)

板级部署与远程测试，与 **cross_compile**（仅负责编译）分离。

## 依赖

- Falco 已通过 **cross_compile** 编译：`cross_compile/install/` 下存在 `bin/falco`、`etc/falco`、`share/falco`
- 测试脚本在仓库根目录：`test/cases/`、`test/idps/`
- 板子可 SSH：在 `board.cfg` 中配置 IP、用户、密码（或密钥）

## 配置

编辑 `board.cfg`：

- **BOARD_IP**：板子 IP（默认 `192.168.1.3`）
- **BOARD_USER**：SSH 用户（默认 `root`）
- **BOARD_PASSWORD**：密码（留空则用密钥或无密码）
- **FALCO_INSTALL_DIR**：相对仓库根目录的 Falco 安装路径（默认 `cross_compile/install`）
- 板端路径：Falco 装到 `/usr/local/bin`、`/etc/falco`、`/usr/share/falco`，测试脚本放到 **BOARD_TEST_DIR**（默认 `/opt/falco-test`）

## 部署

```bash
cd board_test

# 部署 Falco + 测试脚本（会覆盖板子上已有文件）
./deploy_to_board.sh

# 仅部署 Falco
./deploy_to_board.sh --falco-only

# 仅部署测试脚本
./deploy_to_board.sh --tests-only
```

## 远程运行测试

```bash
cd board_test

# 运行全部 idps + cases
./run_tests_remote.sh

# 仅 IDPS 用例
./run_tests_remote.sh idps

# 仅 cases 用例
./run_tests_remote.sh cases

# 单条用例
./run_tests_remote.sh SYS-PROC-001
./run_tests_remote.sh case1_sensitive_file_opening

# 先在板子上启动 Falco，再跑全部
./run_tests_remote.sh --start-falco all
```

若使用密码登录，需安装 `sshpass`：`apt install sshpass`。
