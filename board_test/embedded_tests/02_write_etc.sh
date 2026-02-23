#!/bin/sh
# Embedded test 02: Write a file under /etc.
# Falco may detect: file below /etc opened for writing.
# No Docker, no python3. Run as root on embedded.

echo "=== 02 write under /etc ==="
F="/etc/falco_emb_test_02_$$"
touch "$F" 2>/dev/null || true
rm -f "$F" 2>/dev/null || true
echo "Done. Check Falco: File below /etc opened for writing"
