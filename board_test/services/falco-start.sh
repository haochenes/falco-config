#!/bin/sh
# Start Falco in background (use this if systemd is not available on board).
# Logs go to /var/log/falco.log

FALCO=/usr/local/bin/falco
CONFIG=/etc/falco/falco.yaml
LOG=/var/log/falco.log

if [ ! -x "$FALCO" ]; then
    echo "Falco not found: $FALCO"
    exit 1
fi

# Kill existing falco
pkill -x falco 2>/dev/null || true
sleep 1

# Load falco kernel module if present (required for syscall capture when using engine kind kmod)
for f in /usr/share/falco/falco.ko /lib/modules/$(uname -r)/extra/falco.ko /opt/falco-test/falco.ko; do
    [ -f "$f" ] && insmod "$f" 2>/dev/null && echo "Loaded $f" && break
done

echo "Starting Falco in background, log: $LOG"
nohup "$FALCO" -c "$CONFIG" >> "$LOG" 2>&1 &
sleep 1

if pgrep -x falco >/dev/null; then
    echo "Falco started (PID $(pgrep -x falco))"
else
    echo "Falco may have failed. Check: tail $LOG"
    exit 1
fi
