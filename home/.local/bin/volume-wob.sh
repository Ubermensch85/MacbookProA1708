#!/bin/bash

case "$1" in
    up)   pamixer -ui 2 ;;
    down) pamixer -ud 2 ;;
    mute) pamixer --toggle-mute ;;
esac

sleep 0.1

if [ "$(pamixer --get-mute)" = "true" ]; then
    echo "0" > $XDG_RUNTIME_DIR/wob.wob
else
    pamixer --get-volume > $XDG_RUNTIME_DIR/wob.wob
fi
