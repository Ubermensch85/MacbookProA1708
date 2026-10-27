#!/bin/bash
echo "Identifying owned files..."
pacman -Qlq | grep '^/usr/bin/' | sort -u > /tmp/owned_binaries.txt

echo "Identifying all binaries..."
find /usr/bin -type f | sort -u > /tmp/all_binaries.txt

echo "Finding orphans..."
comm -23 /tmp/all_binaries.txt /tmp/owned_binaries.txt > /tmp/orphans.txt

echo "Mapping orphans to official packages..."
# Run pacman -F in batches to avoid command line length limits
cat /tmp/orphans.txt | xargs -P 4 -n 50 pacman -Fq 2>/dev/null | sort -u > /tmp/to_reinstall.txt

if [ -s /tmp/to_reinstall.txt ]; then
    echo "Reinstalling official packages..."
    sudo pacman -S --noconfirm --overwrite "*" $(cat /tmp/to_reinstall.txt)
else
    echo "No official packages found to reinstall."
fi

# Re-check for AUR/orphans
pacman -Qlq | grep '^/usr/bin/' | sort -u > /tmp/owned_binaries_after.txt
comm -23 /tmp/all_binaries.txt /tmp/owned_binaries_after.txt > /tmp/still_orphans.txt

echo "Remaining orphan files (likely AUR):"
cat /tmp/still_orphans.txt
