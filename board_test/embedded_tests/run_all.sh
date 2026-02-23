#!/bin/sh
# Run all embedded tests in order. No Docker, for TDA4VM/embedded only.

set -e
cd "$(dirname "$0")"
echo "=========================================="
echo "Embedded Falco tests (no Docker)"
echo "=========================================="
for f in 01_exec_from_tmp.sh 02_write_etc.sh 03_read_shadow.sh; do
    [ -f "$f" ] || continue
    echo ""
    sh "$f"
done
echo ""
echo "All embedded tests finished. Check /var/log/falco.log on board."
