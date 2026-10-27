# 🍏 MacBook Pro 13" (A1708 - Mid 2017) Linux Dotfiles & Hardware Tuning

> **Backup completo, driver personalizzati, ottimizzazioni kernel e configurazione Hyprland + Waybar su misura per Apple MacBookPro14,1.**

[![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?logo=arch-linux&logoColor=white)](https://archlinux.org/)
[![Kernel](https://img.shields.io/badge/Kernel-Linux%207.2+-brightgreen)](https://kernel.org)
[![Hyprland](https://img.shields.io/badge/Wayland-Hyprland%200.55-00c853)](https://hyprland.org)
[![Hardware](https://img.shields.io/badge/Model-MacBookPro14%2C1%20(A1708)-lightgrey)](https://everymac.com/systems/apple/macbook_pro/specs/macbook-pro-core-i5-2.3-13-mid-2017-two-thunderbolt-3-ports-non-touch-bar-specs.html)

---

## 📖 Indice
1. [Introduzione & Filosofia](#-introduzione--filosofia)
2. [Specifiche Tecniche del Laptop](#-specifiche-tecniche-del-laptop)
3. [Componenti Hardware Risolti & Driver Custom](#-componenti-hardware-risolti--driver-custom)
4. [Albero del Repository](#-albero-del-repository)
5. [Ambiente Grafico (Hyprland + Waybar)](#-ambiente-grafico-hyprland--waybar)
6. [Scorciatoie da Tastiera Principali](#-scorciatoie-da-tastiera-principali)
7. [Installazione e Ripristino Rapido](#-installazione-e-ripristino-rapido)
8. [Manutenzione e Script Inclusi](#-manutenzione-e-script-inclusi)

---

## 💡 Introduzione & Filosofia
Installare Linux su un Apple MacBook con architettura Intel recente richiede un lavoro approfondito su ogni singolo sottosistema hardware (audio codec Cirrus, fotocamera PCIe FaceTime HD, gestione termica SMC con ventola singola, stabilità Broadcom Wi-Fi e gestione scaling Retina).

Questo repository contiene:
- Il backup ad albero di **tutte le configurazioni di sistema e dotfiles** del computer.
- I driver kernel e le patch DKMS create su misura per far funzionare ogni periferica al 100%.
- Un'interfaccia moderna e reattiva con **Hyprland**, animazioni fluide su GPU Intel Iris 640 e una barra **Waybar** personalizzata con monitoraggio avanzato di batteria e hardware.

---

## 💻 Specifiche Tecniche del Laptop
| Parametro | Valore |
|---|---|
| **Dispositivo** | Apple MacBook Pro 13" (Metà 2017, Due porte Thunderbolt 3, No Touch Bar) |
| **Identificatore Modello** | `MacBookPro14,1` - Modello `A1708` |
| **Processore** | Intel Core i5-7360U (2 Core / 4 Thread, 2.30 GHz fino a 3.60 GHz) |
| **Grafica** | Intel Iris Plus Graphics 640 (Kaby Lake GT3e, 64 MB eDRAM) |
| **Display** | 13.3" IPS Retina 2560x1600 (227 ppi, Wide Color P3) |
| **Audio** | Codec Cirrus Logic CS8409 + CS4208 |
| **Wireless** | Broadcom BCM4350 PCIe 802.11ac + Bluetooth 4.2 |
| **Webcam** | Apple FaceTime HD Camera (PCIe Broadcom BCM15700A2) |
| **Tastiera & Trackpad** | Apple SPI Keyboard con retroilluminazione & Force Touch Trackpad |
| **Batteria & SMC** | Apple System Management Controller con bypass hardware e soglia carica |

---

## 🛠️ Componenti Hardware Risolti & Driver Custom

### 1. 🔋 Batteria & Soglia di Carica Hardware (AppleSMC Patch)
- **Problema**: Nei kernel moderni gli hook ACPI standard non consentivano l'impostazione di una soglia di carica massima per preservare la salute della batteria durante l'alimentazione fissa da scrivania.
- **Soluzione creata**: Patch dedicata al driver `applesmc-next-dkms` (`hardware-drivers/applesmc-battery-limit/`) che espone il sysfs `/sys/devices/platform/applesmc.768/charge_limit`.
- **Automazione**: Servizio systemd `macbook-charge-limit.service` e regola udev `99-macbook-charge-limit.rules` che bloccano automaticamente la carica all'**80%** (configurabile in `/etc/tlp.conf`).

### 2. 🔊 Scheda Audio Cirrus Logic (CS8409 / CS4208)
- **Problema**: Audio muto con i soli driver generici del kernel Linux.
- **Soluzione**: Driver DKMS `snd_hda_macbookpro` abbinato all'opzione modprobe `options snd-hda-intel model=cs8409` (`etc/modprobe.d/alsa-base.conf`) e disattivazione del powersave audio su batteria in TLP per eliminare i fastidiosi "click" e pop sonori.

### 3. 📷 Fotocamera FaceTime HD PCIe
- **Problema**: Webcam su bus PCIe proprietario non supportata da driver UVC standard e immagini con dominante violacea.
- **Soluzione**: Modulo `facetimehd-dkms-git` con firmware estratto, abbinato alla regola udev `etc/udev/rules.d/99-facetimehd.rules` con parametri `v4l2-ctl` calibrati per bilanciamento del bianco, contrasto e saturazione.

### 4. 📶 Wi-Fi Broadcom BCM4350
- **Problema**: Disconnessioni frequenti, roaming aggressivo in background e ping instabile.
- **Soluzione**: Parametri del modulo `options brcmfmac p2pon=0 roamoff=1` (`etc/modprobe.d/iwlwifi-bcmfmac.conf`), disattivazione del power save tramite udev `70-wifi-powersave.rules` e impostazione del regulatory domain italiano `IT`.

### 5. 🖥️ Display Retina & Calibrazione Colore
- **Display**: Risoluzione 2560x1600 renderizzata a scala **1.6** in Wayland/Hyprland per la massima nitidezza visiva.
- **Colore**: Profilo colore calibrato `macbook_retina.icc` applicato automaticamente al boot tramite `dispwin`.
- **Flickering**: Parametri kernel `i915.enable_guc=2 i915.enable_psr=0 i915.enable_fbc=1 pcie_aspm=off` in GRUB.

### 6. ⌨️ Tastiera Apple SPI, Tasto Fn & Retroilluminazione
- Scambio Alt/Command (`swap_opt_cmd=1`) e mapping Fn/Ctrl via `hid_apple`, `keyd` e udev hwdb.
- Script per ripristinare la retroilluminazione della tastiera a 255 (`/usr/local/bin/kbd-backlight.sh`).

---

## 🌳 Albero del Repository
```
MacbookProA1708/
├── README.md                              # Documentazione principale completa
├── install.sh                             # Script di ripristino automatico
├── .gitignore                             # Regole di esclusione dati sensibili
├── packages/                              # Elenco pacchetti installati
│   ├── pkglist-native.txt                 # Pacchetti ufficiali Arch Linux (pacman)
│   └── pkglist-aur.txt                    # Pacchetti AUR (yay)
├── etc/                                   # Configurazioni di sistema (/etc)
│   ├── default/grub                       # Parametri kernel i915, pcie_aspm
│   ├── environment                        # Variabili di sessione Wayland & Qt
│   ├── fstab                              # Punti di mount e tmpfs Firefox
│   ├── makepkg.conf                       # Flag compilazione gcc -march=native
│   ├── mkinitcpio.conf                    # Moduli i915, hid_apple, nvme, lz4
│   ├── keyd/default.conf                  # Mappatura tasti Fn / Ctrl
│   ├── modprobe.d/                        # Opzioni kernel audio, wifi, apple
│   ├── systemd/system/                    # Servizio limite carica batteria SMC
│   ├── tlp.conf                           # Ottimizzazione energetica e termica
│   ├── tlp.d/99-usb-wake.conf             # Regole autosuspend USB
│   └── udev/                              # Regole udev (wifi, webcam, brightness)
├── home/                                  # Dotfiles dell'utente (~/)
│   ├── .bashrc & .zshrc                   # Configurazioni shell ZSH con fzf e autosuggestions
│   ├── .dir_colors                        # Palette colori terminale
│   ├── battery.sh & battery_tooltip.sh    # Notifiche batteria avanzate Nord Theme
│   ├── update.sh                          # Script aggiornamento mirrorlist + yay
│   ├── scripts/                           # Script di gestione alimentazione e display
│   ├── .local/bin/                        # Script OSD volume e luminosità (wob)
│   ├── .local/share/icc/                  # Profili colore Retina ICC
│   └── .config/                           # Configurazioni applicazioni Wayland
│       ├── hypr/                          # Hyprland (Lua config, binds, execs, rules)
│       ├── waybar/                        # Barra di stato personalizzata
│       ├── rofi/                          # App launcher e power menu
│       ├── kitty/ & foot/                 # Emulatori di terminale
│       ├── mako/                          # Demone notifiche
│       ├── wob/                           # Overlay OSD
│       └── cava/                          # Visualizzatore spettro audio
├── hardware-drivers/                      # Patch, driver custom e guide
│   ├── applesmc-battery-limit/            # Sorgenti C e patch driver AppleSMC
│   ├── audio-cirrus-cs8409/               # Script compilazione driver audio
│   ├── facetimehd-camera/                 # Note e regole webcam FaceTime HD
│   ├── wifi-broadcom-bcm4350/             # Parametri stabilità Wi-Fi Broadcom
│   ├── display-retina-a1708/              # EDID e profili colore ICC
│   └── keyboard-trackpad/                 # Retroilluminazione e mapping tasti
└── docs/                                  # Documentazione approfondita
    ├── HARDWARE_DEEP_DIVE.md              # Analisi approfondita di ogni fix kernel
    ├── HYPRLAND_WAYBAR_SETUP.md           # Guida all'ambiente Hyprland
    └── REINSTALLATION_GUIDE.md            # Guida alla reinstallazione da zero
```

---

## 🎨 Ambiente Grafico (Hyprland + Waybar)
L'ambiente desktop è configurato in **Lua nativo** (`~/.config/hypr/hyprland.lua`) e sfrutta la piena accelerazione grafica hardware di Intel Iris 640 tramite driver `iHD` e backend Wayland nativo.

- **Compositor**: Hyprland con blur attivo, bordi eleganti e animazioni fluide.
- **Status Bar**: Waybar tematizzata con visualizzazione carico CPU, memoria, volume, batteria con stato percentuale reale e data/ora.
- **Launcher**: Rofi Wayland con tema coerente.
- **OSD**: Wob per regolazione istantanea di volume e luminosità dello schermo.
- **Notifiche**: Mako integrato con lo script di monitoraggio batteria.

---

## ⌨️ Scorciatoie da Tastiera Principali
| Scorciatoia | Funzione |
|---|---|
| `SUPER + Return` | Apri terminale **Kitty** |
| `SUPER + D` | Apri lanciatore applicazioni (**Rofi**) |
| `SUPER + B` | Apri browser **Firefox Developer Edition** |
| `SUPER + N` | Apri file manager **Nemo** |
| `SUPER + Q` | Chiudi finestra attiva |
| `SUPER + O` | Modalità Finestra Fluttuante (Floating centrata 900x600) |
| `SUPER + F` | Schermo intero (Fullscreen toggle) |
| `SUPER + Z` | Cattura screenshot con **Hyprshot** |
| `SUPER + I` | Mostra notifica dettagliata salute batteria e consumi in Watt |
| `SUPER + W` | Toggle luce notturna (**Gammastep**) |
| `SUPER + A` | Ricarica barra **Waybar** |
| `SUPER + SHIFT + E` | Menù spegnimento / riavvio (**rofi-power.sh**) |

---

## 🚀 Installazione e Ripristino Rapido
Per ripristinare tutte le configurazioni su una nuova installazione di Arch Linux:

```bash
# 1. Clona il repository
git clone https://github.com/Ubermensch85/MacbookProA1708.git
cd MacbookProA1708

# 2. Installa i pacchetti (opzionale se già presenti)
sudo pacman -S --needed - < packages/pkglist-native.txt
yay -S --needed - < packages/pkglist-aur.txt

# 3. Esegui lo script di installazione automatica
chmod +x install.sh
./install.sh
```

---

## 🛠️ Manutenzione e Script Inclusi
- `home/update.sh`: Aggiorna automaticamente la lista dei mirror più veloci italiani ed europei con `rate-mirrors` o `reflector`, aggiorna il sistema con `yay`, pulisce la cache e rigenera GRUB.
- `home/battery_tooltip.sh`: Genera una notifica con salute percentuale reale della batteria calcolata rispetto al design capacity nominale, stato di carica e wattaggio istantaneo assorbito.
- `home/scripts/set-charge-limit.sh`: Imposta manualmente o automaticamente il tetto di carica all'80% direttamente nel chip SMC.
- `home/scripts/apply-hardware-optimizations.sh`: Riapplica in qualsiasi momento le ottimizzazioni di frequenza GPU, ASPM e parametri GRUB.
