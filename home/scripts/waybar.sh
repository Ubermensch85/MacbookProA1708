#!/bin/bash
# Uccidi tutto una volta sola
pkill waybar
sleep 1

# Aspetta la rete in modo non bloccante
nm-online -q -t 5

# Avvia le barre
waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css &
