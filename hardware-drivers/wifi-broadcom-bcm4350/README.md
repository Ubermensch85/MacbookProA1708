# Scheda Wi-Fi e Bluetooth Broadcom BCM4350 (MacBook Pro A1708)

## 📌 Panoramica Hardware
Il MacBookPro14,1 monta un controller combo PCIe Wi-Fi 802.11ac + Bluetooth 4.2 basato su chipset Broadcom BCM4350 (`brcmfmac`).
Sotto Linux, questo chip è noto per presentare:
1. Micro-disconnessioni frequenti causate dalla scansione aggressiva in background del firmware.
2. Caduta delle prestazioni dovuta al risparmio energetico aggressivo del bus PCIe / MAC.
3. Mancanza del corretto CLM blob per la regione europea (ETSI/IT), che limita i canali 5 GHz.

---

## 🛠️ Risoluzioni Applicate

### 1. Parametri del Modulo Kernel (`/etc/modprobe.d/iwlwifi-bcmfmac.conf`)
```ini
options brcmfmac p2pon=0 roamoff=1
```
- `roamoff=1`: Disabilita il roaming automatico aggressivo del firmware che provocava freeze di qualche secondo e ping spike.
- `p2pon=0`: Disabilita il Wi-Fi Direct non necessario, riducendo l'overhead radio.

### 2. Disattivazione Risparmio Energetico Wi-Fi
- **Regola Udev (`/etc/udev/rules.d/70-wifi-powersave.rules`)**:
  ```udev
  ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlan0", RUN+="/usr/bin/iw dev wlan0 set power_save off"
  ```
- **TLP (`/etc/tlp.conf`)**:
  ```ini
  WIFI_PWR_ON_AC=off
  WIFI_PWR_ON_BAT=off
  RUNTIME_PM_BLACKLIST="wlan0"
  ```

### 3. Dominio Regolatorio Europeo/Italiano
Impostato `WIRELESS_REGDOM="IT"` in `/etc/conf.d/wireless-regdom` per sbloccare l'intera potenza di trasmissione e i canali 5GHz DFS (canali 36-140).

### 4. Firmware e Bluetooth
- `bcm4350-firmware` e `broadcom-bt-firmware` (installati via pacchetti AUR/DKMS).
- Firmware CLM aggiornato in `/lib/firmware/brcm/`.
