# Falco 服务脚本（板子部署用）

部署到板子后，任选一种方式让 Falco 在后台运行。

## 方式一：systemd（推荐）

板子有 systemd 时，部署会安装 `falco.service`。在板子上执行：

```bash
systemctl daemon-reload
systemctl enable falco
systemctl start falco
systemctl status falco
```

日志：`journalctl -u falco -f` 或 `/var/log/falco.log`。

## 方式二：脚本 falco-start.sh（无 systemd 时）

板子没有 systemd 时，可手动执行：

```bash
/opt/falco-test/services/falco-start.sh
```

或加入开机启动（如 `/etc/rc.local`）：  
`/opt/falco-test/services/falco-start.sh`

## 检查 Falco 是否在跑

```bash
pgrep -x falco
# 或
ps | grep falco
```
