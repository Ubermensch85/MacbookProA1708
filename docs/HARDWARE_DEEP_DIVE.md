# Approfondimento Hardware & Kernel: Apple MacBookPro14,1 (A1708)

Questa guida documenta la totalità dei problemi hardware riscontrati durante il porting di Arch Linux sul MacBook Pro 13" (Non-TouchBar, A1708) e le rispettive soluzioni implementate.

---

## 📋 Specifiche Hardware Principali
| Componente | Modello / Dettagli | Modulo Linux / Driver |
|---|---|---|
| **Chassis / Mac Model** | MacBookPro14,1 (A1708 - Metà 2017) | `apple-gmux`, `applesmc` |
| **CPU** | Intel Core i5-7360U (2C/4T @ 2.30GHz, Turbo 3.60GHz) | `intel_pstate` (powersave) |
| **GPU** | Intel Iris Plus Graphics 640 (Kaby Lake GT3e, 64MB eDRAM) | `i915` (GuC/HuC abilitati) |
| **Display** | 13.3" IPS Retina 2560x1600 (DCI-P3) | `i915`, `dispwin` (Profilo ICC) |
| **Audio** | Cirrus Logic CS8409 + Codec CS4208 | `snd_hda_macbookpro` (DKMS) |
| **Wi-Fi** | Broadcom BCM4350 PCIe 802.11ac | `brcmfmac` + firmware proprietario |
| **Bluetooth** | Broadcom BCM20703A1 USB | `btusb` + `broadcom-bt-firmware` |
| **Webcam** | FaceTime HD Camera (PCIe Broadcom BCM15700A2) | `facetimehd` (DKMS) + udev tuning |
| **Tastiera / Trackpad** | Apple SPI Keyboard & Force Touch Trackpad | `applespi`, `hid_apple`, `keyd` |
| **Batteria / SMC** | Apple System Management Controller | `applesmc-next` patchato su misura |
| **Storage** | Apple Proprietary NVMe SSD | `nvme` |

---

## ⚙️ Parametri della Riga di Comando Kernel (`/etc/default/grub`)
```bash
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 i915.enable_guc=2 i915.enable_psr=0 i915.enable_fbc=1 pcie_aspm=off quiet"
```

### Spiegazione dei Parametri:
1. `i915.enable_guc=2`:
   - Abilita il caricamento del firmware **GuC (Graphics microController)** e **HuC (HEVC microController)** di Intel.
   - Sblocca l'accelerazione hardware completa per la decodifica video e riduce il carico sulla CPU.
2. `i915.enable_psr=0`:
   - Disabilita il **Panel Self Refresh (PSR)**.
   - *Motivo*: Su questo pannello Retina e controller Intel Iris 640, il PSR causava micro-flickering e sfarfallii casuali durante il cambio di frame in Wayland.
3. `i915.enable_fbc=1`:
   - Abilita il **Frame Buffer Compression**, riducendo l'uso della memoria e il consumo energetico quando lo schermo è statico.
4. `pcie_aspm=off`:
   - Disabilita l'**Active State Power Management** aggressivo di PCIe.
   - *Motivo*: Previene crash di sistema e kernel panic legati al controller PCIe NVMe di Apple e alla scheda Broadcom BCM4350.

---

## ❄️ Gestione Termica e Batteria (TLP & AppleSMC)
La dissipazione termica del MacBook Pro 13" con ventola singola tende a causare thermal throttling rapido se il clock del processore raggiunge i 3.6 GHz per periodi prolungati.

Per garantire silenziosità, temperature sotto i 55°C in idle e preservare la longevità della cella al litio:
1. **CPU Clocks limitati nel profilo TLP**:
   - `CPU_MAX_PERF_ON_AC=85`: Limita la frequenza massima su alimentatore a ~3.0 GHz, evitando picchi a 90°C.
   - `CPU_MAX_PERF_ON_BAT=60`: Ottimizza l'efficienza energetica su batteria.
   - `CPU_BOOST_ON_BAT=0`: Disabilita il Turbo Boost a batteria.
2. **Soglia di Carica Batteria a Livello Hardware (80%)**:
   - Integrata direttamente nel modulo SMC patchato (`hardware-drivers/applesmc-battery-limit/`).
   - All'80% di carica, il controller interrompe l'alimentazione della cella e mantiene il laptop alimentato direttamente dal cavo USB-C (Bypass charging).
