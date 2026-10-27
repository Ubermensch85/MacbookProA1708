#!/bin/bash
BACKLIGHT="/sys/class/backlight/acpi_video0"
MAX=$(cat $BACKLIGHT/max_brightness)

inotifywait -m -e modify $BACKLIGHT/actual_brightness 2>/dev/null |
while read; do
    CURRENT=$(cat $BACKLIGHT/actual_brightness)
    PERCENT=$((CURRENT * 100 / MAX))
    echo "$PERCENT" > $XDG_RUNTIME_DIR/wob.wob
done
