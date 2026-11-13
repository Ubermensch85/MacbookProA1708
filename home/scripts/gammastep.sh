#!/usr/bin/env bash

# Valore ottimale che abbiamo scelto
TEMP=4200

if command -v hyprsunset >/dev/null 2>&1; then
    if [[ $1 = "toggle" ]]; then
        if pgrep -x "hyprsunset" > /dev/null; then
            pkill -x "hyprsunset"
        else
            hyprsunset -t $TEMP >/dev/null 2>&1 &
        fi
        sleep 0.05
        pkill -SIGRTMIN+9 waybar 2>/dev/null || true
    fi

    if pgrep -x "hyprsunset" > /dev/null; then
        echo " "
    else
        echo ""
    fi
    exit 0
fi

if [[ $1 = "toggle" ]]; then
    if pgrep -x "gammastep" > /dev/null; then
        pkill -x "gammastep"
        hyprctl reload >/dev/null 2>&1 || true
    else
        gammastep -O $TEMP 2>/dev/null &
    fi
    sleep 0.05
    pkill -SIGRTMIN+9 waybar 2>/dev/null || true
fi

if pgrep -x "gammastep" > /dev/null; then
    echo " "
else
    echo ""
fi
