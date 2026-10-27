#!/usr/bin/env bash
# ==============================================================================
# Script di Ottimizzazione Hardware e Power Management (MacBook Pro 13" A1708)
# ==============================================================================
set -e

# Colori per output
BLUE="\e[1;34m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
RESET="\e[0m"

echo -e "${BLUE}=== APPLICAZIONE OTTIMIZZAZIONI HARDWARE & TLP ===${RESET}\n"

# Richiedi credenziali sudo all'inizio
if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}Inserisci la password di root/sudo per procedere:${RESET}"
    sudo -v
fi

# 1. Backup e ottimizzazione di /etc/tlp.conf
echo -e "${BLUE}1. Aggiornamento configurazione TLP (/etc/tlp.conf)...${RESET}"
sudo cp -a /etc/tlp.conf /etc/tlp.conf.bak_$(date +%Y%m%d_%H%M%S)

# Rimuovi override GPU a 300MHz a fine file
sudo sed -i '/INTEL_GPU_MIN_FREQ_ON_BAT=300/d' /etc/tlp.conf
sudo sed -i '/INTEL_GPU_MAX_FREQ_ON_BAT=300/d' /etc/tlp.conf
sudo sed -i '/INTEL_GPU_BOOST_FREQ_ON_BAT=300/d' /etc/tlp.conf

# Ripristina/assicura frequenze GPU su batteria bilanciate
if ! grep -q '^INTEL_GPU_MIN_FREQ_ON_BAT=' /etc/tlp.conf; then
    sudo sed -i '/INTEL_GPU_BOOST_FREQ_ON_AC=/a INTEL_GPU_MIN_FREQ_ON_BAT=300\nINTEL_GPU_MAX_FREQ_ON_BAT=700\nINTEL_GPU_BOOST_FREQ_ON_BAT=800' /etc/tlp.conf
fi

# Commenta DISK_DEVICES e APM level (non supportati su NVMe)
sudo sed -i 's/^DISK_DEVICES="nvme0n1"/# DISK_DEVICES="nvme0n1"/' /etc/tlp.conf
sudo sed -i 's/^DISK_APM_LEVEL_ON_AC=/# DISK_APM_LEVEL_ON_AC=/' /etc/tlp.conf
sudo sed -i 's/^DISK_APM_LEVEL_ON_BAT=/# DISK_APM_LEVEL_ON_BAT=/' /etc/tlp.conf

# Wi-Fi Power Save off anche su batteria per stabilizzare Broadcom brcmfmac
sudo sed -i 's/^WIFI_PWR_ON_BAT=on/WIFI_PWR_ON_BAT=off/' /etc/tlp.conf

# Audio Power Save su batteria a 0 per eliminare pop/click Cirrus CS8409
sudo sed -i 's/^SOUND_POWER_SAVE_ON_BAT=1/SOUND_POWER_SAVE_ON_BAT=0/' /etc/tlp.conf

echo -e "${GREEN}✓ /etc/tlp.conf ottimizzato con successo.${RESET}"

# Riavvio TLP
echo -e "${BLUE}2. Ricarica del servizio TLP...${RESET}"
sudo tlp start
echo -e "${GREEN}✓ TLP attivo con i nuovi parametri.${RESET}"

# 2. Backup e ottimizzazione di /etc/default/grub
echo -e "\n${BLUE}3. Pulizia parametri kernel in /etc/default/grub...${RESET}"
sudo cp -a /etc/default/grub /etc/default/grub.bak_$(date +%Y%m%d_%H%M%S)

# Rimuovi force_probe 5917 e acpi_osi errati
sudo sed -i 's|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 i915.enable_guc=2 i915.enable_psr=0 i915.enable_fbc=1 pcie_aspm=off quiet"|' /etc/default/grub
echo -e "${GREEN}✓ /etc/default/grub aggiornato.${RESET}"

# 3. Rigenerazione GRUB
echo -e "\n${BLUE}4. Rigenerazione configurazione GRUB (grub-mkconfig)...${RESET}"
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo -e "${GREEN}✓ /boot/grub/grub.cfg aggiornato con successo.${RESET}"

echo -e "\n${GREEN}======================================================${RESET}"
echo -e "${GREEN} TUTTE LE OTTIMIZZAZIONI SONO STATE APPLICATE!       ${RESET}"
echo -e "${GREEN}======================================================${RESET}"
echo -e "\nPremi un tasto qualsiasi per chiudere..."
read -n 1 -s
