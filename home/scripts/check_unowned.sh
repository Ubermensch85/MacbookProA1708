#!/bin/bash
# Find files in /usr/bin and /usr/lib not owned by any pacman package
# Limited to 100 results to avoid flooding
count=0
find /usr/bin /usr/lib -type f | while read -r file; do
    if ! pacman -Qo "$file" >/dev/null 2>&1; then
        echo "UNOWNED: $file"
        count=$((count + 1))
    fi
    if [ $count -ge 100 ]; then
        echo "Reached limit of 100 files."
        break
    fi
done
