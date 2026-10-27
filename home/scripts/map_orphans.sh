#!/bin/bash
ORPHANS_FILE="/home/ubermensch/orphan_binaries.txt"
find /usr/bin -type f | while read -r file; do
    if ! pacman -Qo "$file" >/dev/null 2>&1; then
        echo "$file"
    fi
done > "$ORPHANS_FILE"

echo "Mapping official packages..."
cat "$ORPHANS_FILE" | xargs pacman -F 2>/dev/null | grep "è contenuto in" | awk '{print $5}' | sort -u > /home/ubermensch/identified_official.txt

echo "Identifying potential AUR or manual files..."
while read -r file; do
    pkg=$(pacman -F "$file" 2>/dev/null | grep "è contenuto in" | awk '{print $5}' | head -n 1)
    if [ -z "$pkg" ]; then
        echo "$file"
    fi
done < "$ORPHANS_FILE" > /home/ubermensch/unmapped_files.txt
