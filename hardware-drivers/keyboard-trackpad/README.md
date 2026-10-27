# Tastiera Apple SPI, Retroilluminazione & Trackpad (MacBook Pro A1708)

## 📌 Panoramica Hardware
Il MacBookPro14,1 (senza Touch Bar) utilizza tastiera e trackpad Force Touch collegati tramite il controller proprietario Apple SPI (`applespi`).

---

## ⌨️ Mappatura Tasti & Layout

### 1. Scambio Tasti Alt/Option e Windows/Command (`/etc/modprobe.d/hid_apple.conf`)
```ini
options hid_apple swap_opt_cmd=1
options hid_apple swap_fn_leftctrl=1
```
- `swap_opt_cmd=1`: Posiziona Alt e Super come su una tastiera standard PC (Alt a sinistra di Super).
- `swap_fn_leftctrl=1`: Permette un utilizzo intuitivo delle combinazioni Ctrl.

### 2. Mappatura a Livello Hardware Evdev (`/etc/udev/hwdb.d/90-apple-keyboard.hwdb`)
Per assicurare che il tasto Fn fisico venga riconosciuto direttamente dal kernel a basso livello come Left Ctrl:
```ini
evdev:name:Apple SPI Keyboard:dmi:*:*
 KEYBOARD_KEY_464=leftctrl
```

### 3. Demone di Rimappatura Keyd (`/etc/keyd/default.conf`)
Il demone di sistema `keyd` garantisce la perfetta coerenza tra le sessioni console TTY e la sessione Wayland:
```ini
[ids]
*

[main]
leftcontrol = fn
fn = leftcontrol
```

---

## 💡 Retroilluminazione Tastiera
Gestita dallo script `/usr/local/bin/kbd-backlight.sh` (copiato anche in questa cartella):
```bash
#!/bin/bash
echo 255 > /sys/class/leds/spi::kbd_backlight/brightness
```
Eseguito automaticamente all'avvio della sessione grafica tramite `~/.config/hypr/configs/execs.lua`.

---

## 🖱️ Trackpad Force Touch
Configurato nativamente in `~/.config/hypr/hyprland.lua`:
- Natural scroll (scorrimento naturale in stile macOS)
- Tap to click abilitato
- Disabilitazione automatica durante la digitazione (`disable_while_typing = true`)
