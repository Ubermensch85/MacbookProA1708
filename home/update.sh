#!/bin/bash
set -euo pipefail

MAX_RETRIES=3
ENTRY_COUNTRY="IT"
MIRRORLIST="/etc/pacman.d/mirrorlist"
REAL_USER="${SUDO_USER:-$USER}"

# ── Selezione mirrors ─────────────────────────────────────────────────────────
update_mirrors() {
    echo "[*] Tentativo con rate-mirrors..."
    if command -v rate-mirrors &>/dev/null; then
        if rate-mirrors \
            --entry-country "$ENTRY_COUNTRY" \
            --country-neighbors-per-country 3 \
            --allow-root \
            --disable-comments-in-file \
            --save "$MIRRORLIST" \
            arch; then
            echo "[+] Mirrorlist aggiornata con rate-mirrors."
            return 0
        fi
        echo "[!] rate-mirrors fallito, passo a reflector..."
    else
        echo "[!] rate-mirrors non trovato, uso reflector..."
    fi

    for ((i=1; i<=MAX_RETRIES; i++)); do
        echo "[*] Reflector: tentativo $i/$MAX_RETRIES..."
        if reflector \
            --country Italy,Switzerland,France,Germany \
            --age 12 \
            --protocol https \
            --sort score \
            --fastest 20 \
            --number 20 \
            --save "$MIRRORLIST"; then
            echo "[+] Mirrorlist aggiornata con reflector."
            return 0
        fi
        ((i < MAX_RETRIES)) && sleep 3
    done

    echo "[!] Impossibile aggiornare la mirrorlist." >&2
    return 1
}

# ── Aggiornamento ─────────────────────────────────────────────────────────────
update_mirrors

echo "[*] Aggiornamento sistema..."
sudo -u "$REAL_USER" yay -Syyu --devel --overwrite "*" --noconfirm

echo "[*] Pulizia cache..."
sudo -u "$REAL_USER" yay -Scc --noconfirm
pacman -Scc --noconfirm

echo "[*] Rigenerazione GRUB..."
grub-mkconfig -o /boot/grub/grub.cfg

echo "[*] Completato."
