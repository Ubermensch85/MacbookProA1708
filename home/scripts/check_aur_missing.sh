#!/bin/bash
# Find files in /usr/bin not owned by pacman and not found in official repos
while read -r file; do
    if ! pacman -Qo "$file" >/dev/null 2>&1; then
        if ! pacman -F "$file" >/dev/null 2>&1; then
            echo "$file"
        fi
    fi
done < <(find /usr/bin -type f)
