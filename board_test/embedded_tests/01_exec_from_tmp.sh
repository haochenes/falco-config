#!/bin/sh
# Embedded test 01: Run executable from /tmp (writable dir).
# Falco may detect: exec from non-allowlisted path.
# No Docker, no python3, no sudo required.

echo "=== 01 exec from /tmp ==="
SCRIPT="/tmp/emb_test_01_$$.sh"
echo "#!/bin/sh" > "$SCRIPT"
echo "echo ok" >> "$SCRIPT"
chmod +x "$SCRIPT"
"$SCRIPT"
rm -f "$SCRIPT"
echo "Done. Check Falco: exe_path containing /tmp"
