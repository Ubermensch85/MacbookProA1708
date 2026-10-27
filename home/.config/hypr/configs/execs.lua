-- ~/.config/hypr/configs/execs.lua
-- MacBookPro14,1 — Hyprland 0.55

-- ── Variabili d'ambiente ─────────────────────────────────────────────────────
hl.env("LIBVA_DRIVER_NAME",  "iHD")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("XCURSOR_THEME",      "Bibata-Original-Classic")
hl.env("XCURSOR_SIZE",       "24")
hl.env("HYPRCURSOR_THEME",   "Bibata-Original-Classic")
hl.env("HYPRCURSOR_SIZE",    "24")

-- ── Autostart ────────────────────────────────────────────────────────────────
hl.on("hyprland.start", function()

    -- ── Sessione ─────────────────────────────────────────────────────────────
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user mask sleep.target suspend.target")

    -- ── Demoni di sistema ─────────────────────────────────────────────────────
    hl.exec_cmd("mako")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("/usr/local/bin/kbd-backlight.sh")

    -- ── wob (OSD volume/luminosità) ───────────────────────────────────────────
    hl.exec_cmd("rm -f $XDG_RUNTIME_DIR/wob.wob && mkfifo $XDG_RUNTIME_DIR/wob.wob && tail -f $XDG_RUNTIME_DIR/wob.wob | wob")
    hl.exec_cmd("~/.local/bin/brightness-monitor.sh")

    -- ── GTK ──────────────────────────────────────────────────────────────────
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme Adwaita")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme Bibata-Original-Classic")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface font-name 'JetBrains Mono 11'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface text-scaling-factor 1")
    hl.exec_cmd("gsettings set org.cinnamon.desktop.default-applications.terminal exec kitty")

    -- ── Display-dipendenti: aspetta che i monitor siano inizializzati ─────────
    -- swaybg e waybar a 500/800 ms;
    -- dispwin: carica il profilo colore calibrato specifico per MacBook Retina
    hl.timer(function()
        hl.exec_cmd("swaybg -i $HOME/Pictures/van.jpg -m fill")
        hl.exec_cmd("dispwin -d 1 $HOME/.local/share/icc/macbook_retina.icc")
    end, { timeout = 500, type = "oneshot" })

    hl.timer(function()
        hl.exec_cmd("sh $HOME/scripts/waybar.sh")
    end, { timeout = 800, type = "oneshot" })

end)
