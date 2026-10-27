#!/usr/bin/env bash
# Script to apply charge limit from TLP config to AppleSMC

SMC_PATH="/sys/devices/platform/applesmc.768/charge_limit"

if [ ! -f "$SMC_PATH" ]; then
    echo "Error: applesmc charge_limit interface not found!" >&2
    exit 1
fi

# Get threshold from TLP config, fallback to 80
LIMIT=$(grep -oP '^STOP_CHARGE_THRESH_BAT0=\K\d+' /etc/tlp.conf 2>/dev/null || echo "80")

# Write to SMC
echo "$LIMIT" > "$SMC_PATH"
echo "Applied battery charge limit: $LIMIT%"
