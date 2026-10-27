# Display Retina 13.3" & Profilo Colore (MacBook Pro A1708)

## 📌 Specifiche Display
- Risoluzione nativa: **2560 x 1600** (Aspect Ratio 16:10, 227 ppi)
- Spazio colore: Copertura 100% DCI-P3 (Wide Color Gamut)
- Nome output Wayland: `eDP-1`

---

## 🎨 Calibrazione Colore e Profilo ICC
Senza calibrazione, Linux utilizza una curva di gamma lineare sRGB che su questo pannello rende i colori eccessivamente saturi o virati.
Nel repository sono inclusi:
- `MacBook_A1708.icc`: Profilo colore calibrato estratto dal firmware Apple per il pannello A1708.
- `macbook_retina.icc`: Profilo ottimizzato per l'uso con `dispwin` (ArgyllCMS).
- `macbook_edid.bin`: Dump binario dei metadati EDID originali del pannello.

### Applicazione automatica all'avvio di Hyprland:
Nel file `~/.config/hypr/configs/execs.lua`:
```lua
hl.timer(function()
    hl.exec_cmd("dispwin -d 1 $HOME/.local/share/icc/macbook_retina.icc")
end, { timeout = 500, type = "oneshot" })
```

---

## 🖥️ Scaling HiDPI su Hyprland
Nel file `~/.config/hypr/hyprland.lua`:
```lua
hl.monitor({ output = "eDP-1", mode = "2560x1600@60", position = "0x0", scale = 1.6 })
```
Lo scale factor **1.6** offre il perfetto equilibrio tra nitidezza e dimensione degli elementi UI (equivalente visivo al formato Retina 1440x900 o 1680x1050 di macOS).
Per le applicazioni XWayland è abilitato `force_zero_scaling = true` per evitare sfocature nei vecchi programmi X11.
