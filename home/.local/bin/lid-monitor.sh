#!/usr/bin/env bash
# Monitora lo stato del coperchio tramite UPower D-Bus (event-driven, 0% CPU)
# e spegne/accende schermo e retroilluminazione tastiera su Hyprland (Lua mode).

for pid in $(pgrep -f "lid-monitor.sh"); do
    if [[ "$pid" != "$$" ]]; then
        kill "$pid" 2>/dev/null || true
    fi
done

gdbus monitor --system --dest org.freedesktop.UPower --object-path /org/freedesktop/UPower | while IFS= read -r line; do
    if [[ "$line" == *"'LidIsClosed': <true>"* ]]; then
        hyprctl dispatch 'hl.dsp.dpms({action = "off", monitor = "eDP-1"})' >/dev/null 2>&1
        brightnessctl -d 'spi::kbd_backlight' set 0% >/dev/null 2>&1
    elif [[ "$line" == *"'LidIsClosed': <false>"* ]]; then
        hyprctl dispatch 'hl.dsp.dpms({action = "on", monitor = "eDP-1"})' >/dev/null 2>&1
        brightnessctl -d 'spi::kbd_backlight' set 100% >/dev/null 2>&1
    fi
done
