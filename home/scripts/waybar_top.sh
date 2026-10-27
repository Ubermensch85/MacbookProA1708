#!/bin/bash
pkill waybar
# Aspetta che NetworkManager sia online (KISS)
nm-online -q -t 5 
waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css &
