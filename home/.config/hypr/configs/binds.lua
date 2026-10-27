-- ~/.config/hypr/configs/binds.lua
-- MacBookPro14,1 — Hyprland 0.55
-- Verificato su wiki.hypr.land/Configuring/Basics/Binds/ e Dispatchers/ (maggio 2026)

local mainMod = "SUPER"

-- ── Terminali ────────────────────────────────────────────────────────────────
hl.bind(mainMod .. " + Return",           hl.dsp.exec_cmd("kitty --title=fly-kitty"))
hl.bind(mainMod .. " + SHIFT + Return",   hl.dsp.exec_cmd("kitty -o background=#A0D7F2 --title=fly-kitty-tiled"))
hl.bind(mainMod .. " + SHIFT + CTRL + Return", hl.dsp.exec_cmd("kitty -o background=#000000 --title=fly-kitty"))
hl.bind(mainMod .. " + K",               hl.dsp.exec_cmd("kitty"))

-- ── Finestre ─────────────────────────────────────────────────────────────────
hl.bind(mainMod .. " + Q",               hl.dsp.window.close())
-- SUPER + O: float toggle + center + resize 900x600
hl.bind(mainMod .. " + O", function()
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    hl.timer(function()
        local win = hl.get_active_window()
        if win and win.floating then
            hl.dispatch(hl.dsp.window.resize({ x = 900, y = 600 }))
            hl.dispatch(hl.dsp.window.center())
        end
    end, { timeout = 50, type = "oneshot" })
end)
hl.bind(mainMod .. " + F",               hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + F",       hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + C",               hl.dsp.window.center())

-- ── Applicazioni ─────────────────────────────────────────────────────────────
hl.bind(mainMod .. " + D",               hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + Z",               hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind(mainMod .. " + B",               hl.dsp.exec_cmd("firefox-developer-edition"))
hl.bind(mainMod .. " + N",               hl.dsp.exec_cmd("nemo"))
hl.bind(mainMod .. " + A",               hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))
hl.bind(mainMod .. " + SHIFT + E",       hl.dsp.exec_cmd("$HOME/scripts/rofi-power.sh"))
hl.bind(mainMod .. " + S",               hl.dsp.exec_cmd("hyprdvd --screensaver"))
hl.bind(mainMod .. " + W",               hl.dsp.exec_cmd("~/scripts/gammastep.sh toggle"))
hl.bind(mainMod .. " + I",               hl.dsp.exec_cmd("~/battery_tooltip.sh"))

-- ── Sistema & alimentazione ───────────────────────────────────────────────────
hl.bind(mainMod .. " + Escape",          hl.dsp.exec_cmd("systemctl poweroff"))
hl.bind("CTRL + Escape",                 hl.dsp.exec_cmd("$HOME/scripts/rofi-power.sh"))
hl.bind(mainMod .. " + E",               hl.dsp.exit())
-- ── Mouse drag/resize ────────────────────────────────────────────────────────
hl.bind(mainMod .. " + mouse:272",       hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + SHIFT + mouse:272", hl.dsp.window.drag(), { mouse = true })

-- ── Workspace 1-10 ───────────────────────────────────────────────────────────
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,           hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i, follow = false }))
end

-- ── Scroll workspace con mouse ────────────────────────────────────────────────
hl.bind(mainMod .. " + mouse_down",      hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",        hl.dsp.focus({ workspace = "e-1" }))

-- ── Audio ─────────────────────────────────────────────────────────────────────
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("~/.local/bin/volume-wob.sh up"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("~/.local/bin/volume-wob.sh down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("~/.local/bin/volume-wob.sh mute"), { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true })

-- ── Luminosità schermo ────────────────────────────────────────────────────────
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"),  { repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+"),  { repeating = true })

-- ── Retroilluminazione tastiera ───────────────────────────────────────────────
hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd("brightnessctl -d 'spi::kbd_backlight' set 25%-"), { repeating = true })
hl.bind("XF86KbdBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -d 'spi::kbd_backlight' set +25%"), { repeating = true })

-- ── Lid switch ───────────────────────────────────────────────────────────────
-- switch:on = lid chiuso, switch:off = lid aperto
hl.bind("switch:on:Lid Switch", function()
    hl.dispatch(hl.dsp.exec_cmd("hyprctl keyword monitor 'eDP-1, disable'"))
    hl.dispatch(hl.dsp.exec_cmd("brightnessctl -d spi::kbd_backlight set 0%"))
end, { locked = true })

hl.bind("switch:off:Lid Switch", function()
    hl.timer(function()
        hl.dispatch(hl.dsp.exec_cmd("hyprctl keyword monitor 'eDP-1, 2560x1600@60, 0x0, 1.6'"))
        hl.dispatch(hl.dsp.exec_cmd("brightnessctl -d spi::kbd_backlight set 100%"))
    end, { timeout = 600, type = "oneshot" })
end, { locked = true })
