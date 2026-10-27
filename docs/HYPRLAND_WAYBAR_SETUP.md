# Guida Ambiente Grafico: Hyprland & Waybar (MacBook Pro A1708)

## 🎨 Panoramica dell'Ambiente
L'interfaccia grafica è basata su **Hyprland** (compositor dinamico Wayland con rendering fluido su GPU Intel Iris 640) configurato tramite **Lua scripting** e arricchito da una barra di stato modulare **Waybar**, lanciatore **Rofi (Wayland)**, terminali leggeri **Kitty** / **Foot** e notifiche **Mako**.

---

## 🎹 Scorciatoie da Tastiera Principali (Keybindings)
Tutti i tasti di scelta rapida utilizzano il tasto `SUPER` (mappato sul tasto fisico `Command / Cmd` o `Alt` in base al tuning Apple).

### 🖥️ Gestione Finestre & Desktop
| Tasto Rapido | Azione | Note |
|---|---|---|
| `SUPER + Q` | Chiude la finestra attiva | Chiusura immediata |
| `SUPER + O` | Modalità Floating centrata | Attiva la finestra fluttuante ridimensionandola a 900x600 e centrandola |
| `SUPER + F` | Schermo Intero (Fullscreen) | Toggle visualizzazione full screen |
| `SUPER + C` | Centra Finestra | Centra la finestra floating a schermo |
| `SUPER + 1..10` | Cambia Workspace | Passa allo spazio di lavoro specificato |
| `SUPER + SHIFT + 1..10` | Sposta finestra nel Workspace | Trasferisce l'app selezionata |
| `SUPER + Mouse SX` | Ridimensiona finestra | Drag interattivo |
| `SUPER + SHIFT + Mouse SX` | Sposta finestra | Move interattivo |

### 🚀 Applicazioni & Strumenti
| Tasto Rapido | Applicazione / Script |
|---|---|
| `SUPER + Return` | Terminale **Kitty** (modalità fly-kitty) |
| `SUPER + SHIFT + Return` | Terminale **Kitty** con sfondo azzurro chiaro |
| `SUPER + K` | Terminale **Kitty** standard |
| `SUPER + D` | Lanciatore Applicazioni (**Rofi**) |
| `SUPER + B` | Browser Web (**Firefox Developer Edition**) |
| `SUPER + N` | File Manager (**Nemo**) |
| `SUPER + Z` | Screenshot dello schermo con **Hyprshot** |
| `SUPER + W` | Toggle filtro luce notturna (**Gammastep**) |
| `SUPER + I` | Tooltip informativo stato avanzato batteria (**battery_tooltip.sh**) |
| `SUPER + A` | Ricarica/riavvia **Waybar** |
| `SUPER + SHIFT + E` | Menù di spegnimento/riavvio (**rofi-power.sh**) |
| `SUPER + Escape` | Spegnimento immediato sicuro |

---

## 📊 Waybar & Widget Modulari
La configurazione di Waybar è suddivisa in:
- `~/.config/waybar/config`: Barra superiore con workspace, monitor CPU, memoria, volume, batteria e orologio.
- `~/.config/waybar/config_bottom`: Barra inferiore (attivabile a piacimento).
- `~/.config/waybar/style.css`: Tema CSS scuro/nord moderno con angoli smussati e trasparenze.
- `arch-script.sh` & `update_system.sh`: Notifiche aggiornamenti di sistema e aggiornamento rapido con `yay`.
- `battery_tooltip.sh`: Notifica OSD in stile Nord Theme con calcolo di usura (Wh/Wh design), cicli e consumo istantaneo in Watt.
- `wob`: OSD a barra minimale e reattiva per volume e luminosità dello schermo.
