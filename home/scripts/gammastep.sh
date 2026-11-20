#!/usr/bin/env bash

# Valore ottimale che abbiamo scelto
TEMP=4200

if command -v hyprsunset >/dev/null 2>&1; then
    if [[ $1 = "toggle" ]]; then
        if pgrep -x "hyprsunset" > /dev/null; then
            pkill -x "hyprsunset"
            for _ in {1..20}; do
                pgrep -x "hyprsunset" > /dev/null || break
                sleep 0.05
            done
        else
            setsid -f hyprsunset -t "$TEMP" >/dev/null 2>&1
            for _ in {1..20}; do
                pgrep -x "hyprsunset" > /dev/null && break
                sleep 0.05
            done
        fi
        pkill -SIGRTMIN+9 waybar 2>/dev/null || true
    fi

    if pgrep -x "hyprsunset" > /dev/null; then
        echo '{"text": "󰖔", "tooltip": "Filtro luce blu attivo", "class": "attivo"}'
    else
        echo '{"text": "󰖨", "tooltip": "Filtro luce blu disattivato", "class": "nonattivo"}'
    fi
    exit 0
fi

if [[ $1 = "toggle" ]]; then
    if pgrep -x "gammastep" > /dev/null; then
        pkill -x "gammastep"
        for _ in {1..20}; do
            pgrep -x "gammastep" > /dev/null || break
            sleep 0.05
        done
        hyprctl reload >/dev/null 2>&1 || true
    else
        setsid -f gammastep -O "$TEMP" >/dev/null 2>&1
        for _ in {1..20}; do
            pgrep -x "gammastep" > /dev/null && break
            sleep 0.05
        done
    fi
    pkill -SIGRTMIN+9 waybar 2>/dev/null || true
fi

if pgrep -x "gammastep" > /dev/null; then
    echo '{"text": "󰖔", "tooltip": "Filtro luce blu attivo", "class": "attivo"}'
else
    echo '{"text": "󰖨", "tooltip": "Filtro luce blu disattivato", "class": "nonattivo"}'
fi
