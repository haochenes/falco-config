#!/bin/sh
# Embedded test 03: Read /etc/shadow (sensitive file).
# Falco may detect: sensitive file opened for reading.
# No Docker, no python3.

echo "=== 03 read /etc/shadow ==="
head -1 /etc/shadow 2>/dev/null || true
echo "Done. Check Falco: Sensitive file opened for reading"
