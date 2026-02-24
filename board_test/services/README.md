# Falco 服务脚本（板子部署用）

部署到板子后，任选一种方式让 Falco 在后台运行。

## 方式一：systemd（推荐）

板子有 systemd 时，部署会把 `falco.service` 和 `load-falco-ko.sh` 放到 `/opt/falco-test/`。**首次或更新后**需把 unit 拷到 systemd 目录并重载：

```bash
cp /opt/falco-test/falco.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable falco   # 可选：开机自启
systemctl start falco
systemctl status falco
```

`falco.service` 的 `ExecStartPre` 会先执行 `/opt/falco-test/load-falco-ko.sh`（先 rmmod 再 insmod `/usr/share/falco/falco.ko`），再启动 Falco，因此**无需手动先 insmod**。

日志：`journalctl -u falco -f` 或 `/var/log/falco.log`。

## 方式二：脚本 falco-start.sh（无 systemd 时）

板子没有 systemd 时，可手动执行：

```bash
/opt/falco-test/services/falco-start.sh
```

或加入开机启动（如 `/etc/rc.local`）：  
`/opt/falco-test/falco-start.sh`

## 检查 Falco 是否在跑

```bash
pgrep -x falco
# 或
ps | grep falco
```
