#!/usr/bin/env bash
# ==============================================================================
# Script di Installazione e Ripristino Dotfiles & Hardware
# MacBook Pro 13" A1708 (MacBookPro14,1) - Arch Linux
# ==============================================================================
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BLUE="\e[1;34m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
RED="\e[1;31m"
RESET="\e[0m"

echo -e "${BLUE}=================================================================${RESET}"
echo -e "${BLUE}  Installazione e Ripristino Configurazioni MacBook Pro A1708   ${RESET}"
echo -e "${BLUE}=================================================================${RESET}\n"

# 1. Controllo permessi sudo
echo -e "${BLUE}[*] Verifica permessi amministrativi...${RESET}"
sudo -v

# 2. Ripristino configurazioni di sistema /etc
echo -e "\n${BLUE}[*] Applicazione file di configurazione in /etc...${RESET}"

# Backup preventivo
sudo mkdir -p /etc/backup-macbookpro-$(date +%Y%m%d_%H%M%S)

# Parametri Kernel GRUB
if [ -f "$BASEDIR/etc/default/grub" ]; then
    echo " -> Aggiornamento /etc/default/grub"
    sudo cp -p "$BASEDIR/etc/default/grub" /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg || true
fi

# Variabili d'ambiente
sudo cp -p "$BASEDIR/etc/environment" /etc/environment

# Modprobe
sudo mkdir -p /etc/modprobe.d
sudo cp -p "$BASEDIR/etc/modprobe.d/"*.conf /etc/modprobe.d/

# Udev rules e HWDB
sudo mkdir -p /etc/udev/rules.d /etc/udev/hwdb.d
sudo cp -p "$BASEDIR/etc/udev/rules.d/"*.rules /etc/udev/rules.d/
sudo cp -p "$BASEDIR/etc/udev/hwdb.d/"*.hwdb /etc/udev/hwdb.d/

# TLP e risparmio energetico
sudo cp -p "$BASEDIR/etc/tlp.conf" /etc/tlp.conf
sudo mkdir -p /etc/tlp.d
sudo cp -p "$BASEDIR/etc/tlp.d/"*.conf /etc/tlp.d/ 2>/dev/null || true

# Keyd
sudo mkdir -p /etc/keyd
sudo cp -p "$BASEDIR/etc/keyd/default.conf" /etc/keyd/

# Servizi Systemd
sudo mkdir -p /etc/systemd/system/systemd-hwdb-update.service.d
sudo cp -p "$BASEDIR/etc/systemd/system/macbook-charge-limit.service" /etc/systemd/system/
sudo cp -p "$BASEDIR/etc/systemd/system/systemd-hwdb-update.service.d/"*.conf /etc/systemd/system/systemd-hwdb-update.service.d/ 2>/dev/null || true

# Script retroilluminazione tastiera
if [ -f "$BASEDIR/hardware-drivers/keyboard-trackpad/kbd-backlight.sh" ]; then
    sudo cp -p "$BASEDIR/hardware-drivers/keyboard-trackpad/kbd-backlight.sh" /usr/local/bin/kbd-backlight.sh
    sudo chmod +x /usr/local/bin/kbd-backlight.sh
fi

# Ricarica udev e hwdb
echo -e "\n${BLUE}[*] Ricarica regole hardware (udevadm e systemd-hwdb)...${RESET}"
sudo systemd-hwdb update || true
sudo udevadm control --reload-rules && sudo udevadm trigger || true

# Abilitazione servizi
echo -e "\n${BLUE}[*] Abilitazione servizi di sistema essenziali...${RESET}"
sudo systemctl daemon-reload
sudo systemctl enable --now tlp.service || true
sudo systemctl enable --now keyd.service || true
sudo systemctl enable --now macbook-charge-limit.service || true

# 3. Ripristino dotfiles utente
echo -e "\n${BLUE}[*] Ripristino configurazioni utente (~/)...${RESET}"
mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/.local/share/icc" "$HOME/scripts"

# Shell e utility home
cp -p "$BASEDIR/home/.bashrc" "$HOME/"
cp -p "$BASEDIR/home/.zshrc" "$HOME/"
cp -p "$BASEDIR/home/.dir_colors" "$HOME/" 2>/dev/null || true
cp -p "$BASEDIR/home/battery.sh" "$HOME/"
cp -p "$BASEDIR/home/battery_tooltip.sh" "$HOME/"
cp -p "$BASEDIR/home/battery_check_root.py" "$HOME/"
cp -p "$BASEDIR/home/update.sh" "$HOME/"
chmod +x "$HOME/"*.sh 2>/dev/null || true

# Script utente
cp -rp "$BASEDIR/home/scripts/"* "$HOME/scripts/"
chmod +x "$HOME/scripts/"*.sh 2>/dev/null || true

# ~/.local/bin
cp -rp "$BASEDIR/home/.local/bin/"* "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/"* 2>/dev/null || true

# Profili colore ICC
cp -rp "$BASEDIR/home/.local/share/icc/"* "$HOME/.local/share/icc/"

# .config
for app in hypr waybar rofi kitty foot mako wob cava; do
    if [ -d "$BASEDIR/home/.config/$app" ]; then
        mkdir -p "$HOME/.config/$app"
        cp -rp "$BASEDIR/home/.config/$app/"* "$HOME/.config/$app/"
    fi
done

echo -e "\n${GREEN}=================================================================${RESET}"
echo -e "${GREEN}  Ripristino completato con successo! Riavvia per applicare tutto.${RESET}"
echo -e "${GREEN}=================================================================${RESET}"
