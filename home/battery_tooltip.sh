#!/usr/bin/env bash
# Battery Tooltip Script - Nord Theme Edition
# Colors (Nord)
BLUE="#88c0d0"
GREEN="#a3be8c"
YELLOW="#ebcb8b"
RED="#bf616a"
SNOW="#d8dee9"

bat=/sys/class/power_supply/BAT0
read_file() { [[ -r "$1" ]] && cat "$1" || echo "0"; }

cycles=$(read_file "$bat/cycle_count")
status=$(read_file "$bat/status")
capacity=$(read_file "$bat/capacity")

energy_now=$(read_file "$bat/energy_now")
if [ "$energy_now" -eq 0 ]; then
    # Fallback to charge and current (common on some drivers/MacBooks)
    charge_now=$(read_file "$bat/charge_now")
    charge_full=$(read_file "$bat/charge_full")
    charge_design=$(read_file "$bat/charge_full_design")
    current_now=$(read_file "$bat/current_now")
    voltage_now=$(read_file "$bat/voltage_now")
    voltage_design=$(read_file "$bat/voltage_min_design")

    # Determine voltage to use for energy/capacity (nominal design voltage)
    volt_design=$voltage_design
    if [ "$volt_design" -eq 0 ]; then
        volt_design=$voltage_now
    fi
    if [ "$volt_design" -eq 0 ]; then
        volt_design=11100000 # Fallback 11.1V
    fi

    # Determine voltage to use for active power (current active voltage)
    volt_active=$voltage_now
    if [ "$volt_active" -eq 0 ]; then
        volt_active=$volt_design
    fi

    # Calculate equivalent energy/power values in micro-units
    energy_now=$(awk -v c="$charge_now" -v v="$volt_design" 'BEGIN{printf("%.0f", (c * v)/1000000)}')
    energy_full=$(awk -v c="$charge_full" -v v="$volt_design" 'BEGIN{printf("%.0f", (c * v)/1000000)}')
    energy_full_design=$(awk -v c="$charge_design" -v v="$volt_design" 'BEGIN{printf("%.0f", (c * v)/1000000)}')
    power_now=$(awk -v c="$current_now" -v v="$volt_active" 'BEGIN{printf("%.0f", (c * v)/1000000)}')
else
    energy_full=$(read_file "$bat/energy_full")
    energy_full_design=$(read_file "$bat/energy_full_design")
    power_now=$(read_file "$bat/power_now")
fi

# Convert to Wh/W (μWh/μW -> Wh/W)
full_wh=$(awk -v f="$energy_full" 'BEGIN{printf("%.2f", f/1000000)}')
design_wh=$(awk -v d="$energy_full_design" 'BEGIN{printf("%.2f", d/1000000)}')
now_wh=$(awk -v n="$energy_now" 'BEGIN{printf("%.2f", n/1000000)}')
power_w=$(awk -v p="$power_now" 'BEGIN{printf("%.2f", p/1000000)}')

health=$(awk -v f="$energy_full" -v d="$energy_full_design" 'BEGIN{if(d>0) printf("%.1f", (f/d)*100); else print "0"}')

# Calculate real charge percentage to match Waybar/UPower (energy_now / energy_full)
if [ "$energy_full" -gt 0 ]; then
    capacity=$(awk -v n="$energy_now" -v f="$energy_full" 'BEGIN{printf("%.0f", (n/f)*100)}')
fi

# Icon selection based on capacity
icon=""
if [ "$capacity" -lt 20 ]; then icon="";
elif [ "$capacity" -lt 40 ]; then icon="";
elif [ "$capacity" -lt 60 ]; then icon="";
elif [ "$capacity" -lt 80 ]; then icon=""; fi

# Status icon
stat_icon="󱐋"
if [ "$status" == "Charging" ]; then stat_icon="󱐋";
elif [ "$status" == "Full" ]; then stat_icon="󰚥";
else stat_icon="󰁹"; fi

title="$icon Batteria: $capacity% ($status)"
body="󰚥 Salute: $health% ($full_wh Wh / $design_wh Wh)
$stat_icon Consumo: $power_w W | Carica: $now_wh Wh
󱍸 Cicli: $cycles"

# Send notification (mako will handle the styling if configured, 
# but we can use simple text here)
notify-send -u low -t 5000 "$title" "$body"
