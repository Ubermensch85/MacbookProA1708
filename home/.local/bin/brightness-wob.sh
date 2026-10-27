#!/bin/bash
BACKLIGHT="/sys/class/backlight/acpi_video0"
CURRENT=$(cat $BACKLIGHT/brightness)
MAX=$(cat $BACKLIGHT/max_brightness)

if [ "$1" = "up" ]; then
    NEW=$((CURRENT + 5))
    [ $NEW -gt $MAX ] && NEW=$MAX
else
    NEW=$((CURRENT - 5))
    [ $NEW -lt 0 ] && NEW=0
fi

echo $NEW > $BACKLIGHT/brightness
PERCENT=$((NEW * 100 / MAX))
echo "$PERCENT" > $XDG_RUNTIME_DIR/wob.wob
