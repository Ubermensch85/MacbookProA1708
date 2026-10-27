-- ~/.config/hypr/hyprland.lua
-- MacBookPro14,1 — Hyprland 0.55 Lua config
-- Verificato su wiki.hypr.land latest git (maggio 2026)

require("configs.execs")
require("configs.appearance")
require("configs.rules")
require("configs.binds")

-- ── Monitor ───────────────────────────────────────────────────────────────────
hl.monitor({ output = "eDP-1", mode = "2560x1600@60", position = "0x0",    scale = 1.6 })
hl.monitor({ output = "DP-2",  mode = "3840x2160@60", position = "1600x0", scale = 2.0 })
-- Fallback per monitor non specificati
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- ── Config globale ────────────────────────────────────────────────────────────
hl.config({
    input = {
        kb_layout    = "it",
        follow_mouse = 1,
        sensitivity  = -0.2,
        touchpad = {
            natural_scroll       = true,
            disable_while_typing = true,
            tap_to_click         = true,
        },
    },
    dwindle = {
        preserve_split         = true,
        split_width_multiplier = 1.5,
    },
    misc = {
        disable_hyprland_logo = true,
        vrr                   = 0,
    },
    xwayland = {
        force_zero_scaling = true,
    },
})
