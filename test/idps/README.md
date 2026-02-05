# System-Level IDPS Test Scripts

Test scripts aligned with **System-Level IDPS Detection Test Cases For Embedded Linux v1.1**.

Each script corresponds to a test case ID in the document and simulates the anomaly condition for IDPS detection verification.

## Test Case Mapping

| Script | Document ID | Category |
|--------|-------------|----------|
| SYS-PROC-001.sh | SYS-PROC-001 | Abnormal Process Execution |
| SYS-PROC-002.sh | SYS-PROC-002 | Executable from writable dirs |
| SYS-PROC-003.sh | SYS-PROC-003 | Interactive shell spawn |
| SYS-PROC-004.sh | SYS-PROC-004 | Privilege escalation |
| SYS-PROC-005.sh | SYS-PROC-005 | Unknown binary execution |
| SYS-FILE-001.sh | SYS-FILE-001 | Writes to /etc auth files |
| SYS-FILE-002.sh | SYS-FILE-002 | Modifications to system binaries |
| SYS-FILE-003.sh | SYS-FILE-003 | PAM/SSH/cron modifications |
| SYS-FILE-004.sh | SYS-FILE-004 | systemd unit modifications |
| SYS-KERN-001.sh | SYS-KERN-001 | Kernel module loading |
| SYS-KERN-002.sh | SYS-KERN-002 | ptrace abuse |
| SYS-KERN-003.sh | SYS-KERN-003 | capset operations |
| SYS-KERN-004.sh | SYS-KERN-004 | mount/umount operations |
| SYS-NET-001.sh | SYS-NET-001 | Non-baseline outbound connections |
| SYS-NET-002.sh | SYS-NET-002 | Low port listening |
| SYS-NET-003.sh | SYS-NET-003 | SOCK_RAW creation |
| SYS-NET-004.sh | SYS-NET-004 | AF_CAN socket creation |
| SYS-CONT-001.sh | SYS-CONT-001 | Container host path access |
| SYS-CONT-002.sh | SYS-CONT-002 | Privileged container |
| SYS-CONT-003.sh | SYS-CONT-003 | Host dir mount in container |
| SYS-CONT-004.sh | SYS-CONT-004 | Capabilities elevation in container |
| SYS-RES-001.sh | SYS-RES-001 | CPU/memory abuse |
| SYS-RES-002.sh | SYS-RES-002 | Hidden process (unlinked exe) |
| SYS-RES-003.sh | SYS-RES-003 | Fork bomb / mass spawning |
| SYS-LOG-001.sh | SYS-LOG-001 | Log file tampering |
| SYS-LOG-002.sh | SYS-LOG-002 | Audit rule changes |
| SYS-LOG-003.sh | SYS-LOG-003 | Log process termination |
| SYS-PHY-001.sh | SYS-PHY-001 | USB Mass Storage insertion |
| SYS-PHY-002.sh | SYS-PHY-002 | USB HID insertion |
| SYS-PHY-003.sh | SYS-PHY-003 | Generic USB insertion |

## Usage

```bash
# Ensure Falco is running
sudo falco -c /etc/falco/falco.yaml &

# Run a specific test
cd /opt/falco-test  # or your test directory
bash idps/SYS-PROC-001.sh

# Run all IDPS tests
for f in idps/SYS-*.sh; do bash "$f"; done
```

## Prerequisites

- Falco installed and running (eBPF or kernel module)
- Root/sudo for tests requiring elevated privileges
- Docker (for container-related tests SYS-CONT-*)
- Python 3 (for some network/socket tests)
