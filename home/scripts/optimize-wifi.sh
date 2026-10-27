#!/usr/bin/env bash
# ==============================================================================
# Ottimizzazione e Stabilizzazione Wi-Fi Broadcom BCM4350 (MacBook Pro 14,1)
# ==============================================================================
set -e

BLUE="\e[1;34m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
RESET="\e[0m"

echo -e "${BLUE}=== OTTIMIZZAZIONE WI-FI BROADCOM BCM4350 ===${RESET}\n"

if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}Inserisci la password di root/sudo per procedere:${RESET}"
    sudo -v
fi

# 1. Imposta roamoff=1 in /etc/modprobe.d/iwlwifi-bcmfmac.conf
echo -e "${BLUE}1. Configurazione parametri modulo brcmfmac...${RESET}"
echo "options brcmfmac p2pon=0 roamoff=1" | sudo tee /etc/modprobe.d/iwlwifi-bcmfmac.conf > /dev/null
echo -e "${GREEN}✓ Impostato roamoff=1 (disabilita scan aggressivi del firmware in background).${RESET}"

# 2. Imposta regulatory domain IT in /etc/conf.d/wireless-regdom
echo -e "\n${BLUE}2. Configurazione dominio regolatorio Wi-Fi (Italia)...${RESET}"
sudo sed -i 's/^#WIRELESS_REGDOM="IT"/WIRELESS_REGDOM="IT"/' /etc/conf.d/wireless-regdom
sudo iw reg set IT 2>/dev/null || true
echo -e "${GREEN}✓ Dominio regolatorio impostato su IT (ETSI - canali 1-13 e potenza 5GHz sbloccata).${RESET}"

echo -e "\n${GREEN}======================================================${RESET}"
echo -e "${GREEN} OTTIMIZZAZIONI WI-FI APPLICATE CON SUCCESSO!        ${RESET}"
echo -e "${GREEN}======================================================${RESET}"
echo -e "\nStato attuale link Wi-Fi:"
iw dev wlan0 link | grep -E "SSID|freq|signal|rx bitrate|tx bitrate" || true
echo ""
echo "Premi un tasto qualsiasi per chiudere..."
read -n 1 -s
