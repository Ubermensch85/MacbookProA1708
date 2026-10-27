#!/bin/bash
# Find orphans
find /usr/bin -type f > /tmp/all_binaries.txt
while read -r f; do
    if ! pacman -Qo "$f" >/dev/null 2>&1; then
        echo "$f"
    fi
done < /tmp/all_binaries.txt > /tmp/orphans.txt

# Map to official packages
echo "Mapping files to official packages..."
cat /tmp/orphans.txt | xargs pacman -Fq 2>/dev/null | sort -u > /tmp/to_reinstall.txt

if [ -s /tmp/to_reinstall.txt ]; then
    echo "Reinstalling official packages: $(cat /tmp/to_reinstall.txt | xargs)"
    sudo pacman -S --noconfirm --overwrite "*" $(cat /tmp/to_reinstall.txt)
else
    echo "No official packages found to reinstall."
fi

# Refresh orphans list
while read -r f; do
    if ! pacman -Qo "$f" >/dev/null 2>&1; then
        echo "$f"
    fi
done < /tmp/all_binaries.txt > /tmp/still_orphans.txt

echo "Remaining orphan files (likely AUR):"
cat /tmp/still_orphans.txt
