#!/bin/bash
IP=$(ip route get 1.2.3.4 | awk '{print $7}' | head -1)
BOOT_TOTAL=$(systemd-analyze 2>/dev/null | grep "Startup finished" | awk '{print $10}')

/usr/bin/kitty --class fly-kitty-info --title fly-kitty-info sh -lc "
  export TERM=xterm-256color
  clear
  neofetch
  echo ''
  echo '🌐 IP:  $IP'
  echo '🕒 Boot Time: $BOOT_TOTAL'
  echo ''
  echo 'Premi qualsiasi tasto per chiudere...'
  read -n 1 -s
"

