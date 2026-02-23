# Chen Shi Feedback – Solutions

Summary of colleague feedback and proposed solutions.

---

## 1. Logs: JSON Output

**Feedback**: Logs are plain text. Check if Falco can output JSON to simplify collection and analysis.

**Solution**:
- Enable `json_output: true` in `falco.yaml`
- Falco natively supports JSON; each event becomes a structured JSON object with fields like `output`, `priority`, `rule`, `time`, `source`, `tags`, `output_fields`
- Update `collect_logs_host.ps1` to parse JSON (e.g. `ConvertFrom-Json`) instead of raw text
- If both formats are needed, keep `file_output` and add `json_output` or use Falco’s program_output with `jq` to convert

**Config**:
```yaml
# falco.yaml
json_output: true
file_output:
  enabled: true
  filename: /var/log/falco.log
  # Falco can write JSON lines to file when json_output=true
```

---

## 2. Unrelated Alerts from Cleanup

**Feedback**: Some runs include unrelated alerts (e.g. from log truncate or cleanup). Avoid cleanup steps that trigger detections.

**Solution**:
- `truncate -s 0` can trigger file-write rules; remove truncate from the collection flow
- Option A: Use `echo "" > /var/log/falco.log` or `true >` – may still trigger some rules
- Option B: Rotate instead of truncate – `logrotate` or move-and-recreate
- Option C: Do not clear the log; filter by timestamp before and after each test
- **Preferred**: Before each test, record timestamp. After the test, only collect events with `time` after that timestamp; avoid truncate entirely

**collect_logs_host.ps1**:
- Replace `truncate -s 0` with a timestamp-based approach
- Or add a short delay and parse only new entries by timestamp

---

## 3. SYS-FILE Overlap (001 Hides 003, 004)

**Feedback**: SYS-FILE-003 and SYS-FILE-004 are hidden by SYS-FILE-001 (/etc write). Tighten the broad rule so each case triggers its own alert.

**Solution**:
- Narrow SYS-FILE-001 to paths *not* covered by 003 and 004
- Exclude: `/etc/pam.d`, `/etc/cron*`, `/etc/systemd`, `/lib/systemd`, `authorized_keys`, `*.service`, `*.timer`
- Or rely on rule order: define SYS-FILE-003 and SYS-FILE-004 before SYS-FILE-001; use `rule_matching: all` so multiple rules can fire
- **Preferred**: Restrict SYS-FILE-001 to auth/config under `/etc` only (e.g. `passwd`, `shadow`, `group`, `sudoers`, `hosts`) and exclude cron/pam/systemd paths:

**Rule change**:
```yaml
# SYS-FILE-001: exclude paths covered by 003, 004
condition: open_write and fd.name startswith /etc/
  and not (fd.directory in (/etc/pam.d, /etc/cron.d, /etc/cron.daily, ...)
         or fd.name contains authorized_keys
         or fd.directory in (/etc/systemd, /lib/systemd)
         or fd.name endswith .service or fd.name endswith .timer)
```

---

## 4. Enrich Alerts with Key Fields

**Feedback**: Network, container, and USB alerts lack remote IP/port, socket type, mount source/target, USB VID/PID/serial.

**Solution**:
- **Network**: Add `fd.sip`, `fd.dip`, `fd.sport`, `fd.dport`, `fd.lport`, `fd.l4proto`, `fd.l4proto`
- **Container**: Add mount fields (e.g. from `evt.args` or container plugin), `container.mount_source`, `container.mount_dest` if exposed
- **USB**: Add `fd.name` with USB device path; parse `/sys/bus/usb/devices/*/idVendor`, `idProduct`, `serial` from `open_read` events or udev; or extend output with a custom field

**Example output additions**:
```yaml
# Network rule
output: ... | fd.sip=%fd.sip fd.dip=%fd.dip fd.sport=%fd.sport fd.dport=%fd.dport fd.lport=%fd.lport fd.l4proto=%fd.l4proto

# Container (if plugin provides)
output: ... | container_id=%container.id mount_source=... mount_dest=...

# USB
output: ... | fd.name=%fd.name (parse /sys/bus/usb/devices/ for VID/PID)
```

---

## 5. SYS-NET-004: Cmdline Substring Misfire

**Feedback**: SYS-NET-004 is triggered by "SOCK_RAW" in comments. Use socket fields (family/type/proto) instead of cmdline.

**Solution**:
- Use `evt.type=socket` and `evt.arg.domain`
- AF_CAN = 29; use `evt.arg.domain contains AF_CAN` or `evt.arg.domain=29` (if supported)
- Do not match on `proc.cmdline` for SOCK_RAW/AF_CAN

**Rule change**:
```yaml
# SYS-NET-004: Use socket syscall
- rule: IDPS SYS-NET-004 AF_CAN socket
  condition: evt.type=socket and evt.arg.domain=AF_CAN
  output: IDPS SYS-NET-004 AF_CAN socket created | domain=%evt.arg.domain type=%evt.arg.type protocol=%evt.arg.protocol ...
```

Remove the `proc.cmdline contains` condition.

---
- Or require `proc.cmdline` to contain phrases like `"> /dev/null"` (for `yes > /dev/null`) or explicit CPU loops, and exclude `settimeout`

## 6. SYS-NET-002: No Alert; SYS-RES-001 False Positive

**Feedback**: SYS-NET-002 has no alert. SYS-RES-001 falsely matches "time" in settimeout().

**Solutions**:

**SYS-NET-002**:
- Add a rule on `evt.type=bind` with `fd.lport < 1024` (and optionally `fd.lport = 4444` for backdoor-style ports)
```yaml
- rule: IDPS SYS-NET-002 Low port listen
  condition: evt.type=bind and (fd.lport < 1024 or fd.lport = 4444)
  output: IDPS SYS-NET-002 Bind to low port | fd.lport=%fd.lport ...
```

**SYS-RES-001**:
- Current condition matches `proc.cmdline contains "time"` – catches `settimeout(1)` in Python
- Tighten to CPU-abuse patterns: e.g. `proc.name=yes` or `(proc.name=python3 and (proc.cmdline contains "while True" or proc.cmdline contains "yes " or proc.cmdline contains "time.sleep(999)"))`

**Rule change**:
```yaml
# SYS-RES-001: avoid matching settimeout
condition: spawned_process and (
  proc.name=yes
  or (proc.name=python3 and proc.cmdline contains "yes " and proc.cmdline contains "/dev/null")
  or (proc.name=python3 and proc.cmdline contains "while" and proc.cmdline contains "True")
)
```

---

## 7. SYS-PROC-002: Detect Exec from /tmp, Not Cmdline Reference

**Feedback**: Should detect programs executed from /tmp, not commands that only reference /tmp.

**Solution**:
- Keep `proc.exepath startswith /tmp/` (and `/var/tmp/`, `/dev/shm/`) as the main condition
- Remove `proc.cmdline contains "/tmp/sys_proc_002"` – it can match commands that merely mention the path
- Rely only on `proc.exepath` for execution path

**Rule change**:
```yaml
condition: spawned_process and (
  proc.exepath startswith /tmp/
  or proc.exepath startswith /var/tmp/
  or proc.exepath startswith /dev/shm/
)
# Remove: or proc.cmdline contains "/tmp/sys_proc_002"
```

---

## 8. SYS-LOG-003: target_pid Wrong (Shows bash)

**Feedback**: target_pid is wrong (bash). It should be a numeric PID.

**Solution**:
- `evt.arg.pid` for kill/tkill/tgkill is the target PID; verify Falco is emitting it correctly
- If the wrong value appears, check:
  - Use `evt.arg.pid` (or `evt.args`) and ensure the kill syscall is captured with correct args
  - If Falco uses different field names (e.g. `evt.arg.target`), switch to those
- Rule fix: ensure output uses the field that holds the target PID; if `evt.arg.pid` is incorrect, inspect Falco syscall definitions and use the appropriate argument index
- SYS-LOG-003 script: currently sends SIGUSR1 to rsyslog; if no rsyslog, it does `kill -0 1`. Prefer always targeting a real log daemon PID when available and validating that `evt.arg.pid` in output equals that PID

**Debug**: Inspect Falco output for kill events to see which fields contain the target PID.

---

## 9. SYS-LOG-002: Test Only Lists Rules, Doesn’t Trigger Real Anomaly

**Feedback**: Test only lists rules and doesn’t trigger the real anomaly (rule change/delete). Put the real test behind a flag and add rollback.

**Solution**:
- Add an `--execute` (or `-x`) flag to SYS-LOG-002.sh
- Default (no flag): run `auditctl -l` only (safe, no changes)
- With `--execute`: run `auditctl -D` (or modify rules), capture Falco output, then run `auditctl -w ...` to restore baseline rules
- Script steps:
  1. `auditctl -l > /tmp/audit_rules_backup`
  2. If `--execute`: `auditctl -D`, sleep, then `auditctl -R /tmp/audit_rules_backup` (or equivalent restore)
  3. Ensure rollback even on script failure (trap)

**SYS-LOG-002.sh**:
```bash
if [ "$1" = "--execute" ]; then
  auditctl -l > /tmp/audit_backup_$$
  auditctl -D
  sleep 2
  auditctl -R /tmp/audit_backup_$$ 2>/dev/null || true
  rm -f /tmp/audit_backup_$$
fi
```

---

## Implementation Checklist

| # | Item                          | Effort | Priority |
|---|-------------------------------|--------|----------|
| 1 | JSON output + collect script  | Medium | High     |
| 2 | Remove truncate; use ts-based | Low    | High     |
| 3 | SYS-FILE rule ordering/narrow | Medium | High     |
| 4 | Enrich network/container/USB  | Medium | Medium   |
| 5 | SYS-NET-004 use evt.type=socket | Low   | High     |
| 6 | SYS-NET-002 rule; fix SYS-RES-001 | Low  | High     |
| 7 | SYS-PROC-002 drop cmdline     | Low    | High     |
| 8 | SYS-LOG-003 target_pid fix    | Low    | Medium   |
| 9 | SYS-LOG-002 --execute + rollback | Low | Medium   |

---

*Document for review before implementation.*
