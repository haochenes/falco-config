# Embedded test cases (board_test/test_cases)

IDPS test cases adapted from **test/test_cases** for **embedded boards** (e.g. TDA4VM): no Docker, no interactive prompts, robust Falco check, and **detection verification** ([DETECTED]/[NOT DETECTED]) plus **JSON logs for compliance**.

## JSON output and compliance log

- **Enable JSON**: Deploy includes `falco.json_output.board.yaml` so Falco writes alerts to **`/var/log/falco/falco_events.json`** (one JSON object per line, JSONL).
- **Collect from board** (for compliance/audit):
  ```bash
  cd board_test
  ./collect_falco_json_log.sh                    # -> falco_events_YYYYMMDD_HHMMSS.jsonl
  ./collect_falco_json_log.sh my_audit.jsonl    # -> my_audit.jsonl
  ```
- After deploying rules and JSON config, restart Falco: `systemctl restart falco` (on board).

## Falco check (why it failed before)

The original `test/test_cases` use `pgrep -x falco`. On the board, Falco may be run by systemd or show in process list differently, so the check falsely reported "Falco not running."  

Here we use **check_falco_embedded** (in `common_embedded.sh`), which considers Falco running if any of:

- `pgrep -x falco`
- `pgrep -f falco`
- `systemctl is-active falco` (active)
- `/var/log/falco.log` modified in the last 90 seconds

If none match, the script exits with a clear error and start instructions.

## Auto vs Manual cases

Cases are split so **automation runs only safe ones**; **manual** ones may affect the system and are run when you need to verify those rules.

| Type | Runner | Description |
|------|--------|-------------|
| **AUTO** | `run_auto_cases.sh` | Safe for full automation: read-only, short-lived, or non-destructive (e.g. read /proc, network, ptrace, exec from /tmp). |
| **MANUAL** | `run_manual_cases.sh` | May affect system: write system dirs (/etc, /usr/bin, cron.d, systemd), load kernel module, mount, kill signal, CPU abuse, privilege escalation, Docker privileged/mount. Run only when you intend to test these rules. |

- **AUTO** (16): SYS-CONT-001, SYS-KERN-002, 003, SYS-LOG-002, SYS-NET-001–004, SYS-PHY-001–003, SYS-PROC-001, 002, 003, 005, SYS-RES-003.
- **MANUAL** (14): SYS-CONT-002, 003, 004, SYS-FILE-001–004, SYS-KERN-001, 004, SYS-LOG-001, 003, SYS-PROC-004, SYS-RES-001, 002.

## Layout

- **common_embedded.sh** – Defines `check_falco_embedded`; sourced by each SYS-*.sh.
- **SYS-*.sh** (30 cases) – Embedded IDPS cases; each checks falco.log and prints [DETECTED] or [NOT DETECTED].
- **run_auto_cases.sh** – Runs AUTO cases only (default for `./run_tests_remote.sh cases`).
- **run_manual_cases.sh** – Runs MANUAL cases only (`./run_tests_remote.sh cases-manual`).
- **run_all_embedded_cases.sh** – Runs all AUTO + MANUAL (`./run_tests_remote.sh cases-all`).

## IDPS detection (SYS-PROC-001, SYS-FILE-001, etc.)

For test cases to **detect** and report `[DETECTED]`, the board must load the IDPS rules:

1. Deploy the rules file:  
   `./deploy_to_board.sh --rules-only`  
   (copies `falco-config/falco_rules.local.yaml` to `/etc/falco/` on the board.)

2. Restart Falco so it reloads rules:  
   On the board: `systemctl restart falco`

3. Then run the test cases (single or all).

## Running on the board

After deploy (`deploy_to_board.sh` copies these under `/opt/falco-test/test_cases/`):

```bash
# Single case
/opt/falco-test/test_cases/SYS-PROC-001.sh

# AUTO only (safe for automation)
/opt/falco-test/test_cases/run_auto_cases.sh

# MANUAL only (when you need to test those rules)
/opt/falco-test/test_cases/run_manual_cases.sh

# All (AUTO + MANUAL)
/opt/falco-test/test_cases/run_all_embedded_cases.sh
```

## Running from host (SSH)

```bash
cd board_test
./run_tests_remote.sh cases          # AUTO only (default)
./run_tests_remote.sh cases-manual  # MANUAL only
./run_tests_remote.sh cases-all     # AUTO + MANUAL
./run_tests_remote.sh SYS-PROC-001  # single test
```

## Adding more cases

1. Copy a case from `test/test_cases/SYS-XXX.sh`.
2. At the top, source common and call `check_falco_embedded` instead of `check_falco`.
3. Remove Docker-only steps; use host-only equivalents (e.g. read `/proc/1` instead of `docker run ... cat /proc/1/cmdline`).
4. Remove interactive `read -p`; exit with error if Falco is not running.
