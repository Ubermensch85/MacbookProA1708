-- ~/.config/hypr/configs/appearance.lua
-- MacBookPro14,1 — Hyprland 0.55
-- Stile: esagerato e dinamico (spring + overshot mix), velocità media

hl.config({
    general = {
        gaps_in          = 3,
        gaps_out         = 6,
        border_size      = 2,
        ["col.active_border"]   = { colors = { "0xee5e81ac", "0xee0f80a0" }, angle = 45 },
        ["col.inactive_border"] = { colors = { "0xee3b4252", "0xee2e3440" }, angle = 45 },
        resize_on_border = false,
    },
    decoration = {
        rounding           = 10,
        active_opacity     = 1.0,
        inactive_opacity   = 1.0,
        fullscreen_opacity = 1.0,
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            new_optimizations = true,
        },
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
    },
    animations = {
        enabled = true,
    },
})

-- ── Curve bezier ─────────────────────────────────────────────────────────────
-- nordSmooth: la curva classica del tema Nord-Arch
hl.curve("nordSmooth", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
-- overshot: supera il target e torna — finestre che "rimbalzano" in posizione
hl.curve("overshot",   { type = "bezier", points = { {0.13, 0.99}, {0.29, 1.1}   } })
-- spring: elastico pronunciato — molto dinamico
hl.curve("spring",     { type = "bezier", points = { {0.68, -0.55},{0.27, 1.55}  } })
-- bounce: rimbalzo morbido — per le workspace
hl.curve("bounce",     { type = "bezier", points = { {0.17, 0.67}, {0.54, 1.5}   } })
-- smoothOut: uscita rapida e decisa — finestre che chiudono con carattere
hl.curve("smoothOut",  { type = "bezier", points = { {0.36, 0},    {0.66, -0.56} } })
-- easeInOut: classico, per border e fade
hl.curve("easeInOut",  { type = "bezier", points = { {0.42, 0},    {0.58, 1}     } })

-- ── Animazioni ───────────────────────────────────────────────────────────────
-- speed in deciseconds (1 = 100ms). Ottimizzati per Intel Iris Plus 640 (3-4 = 300-400ms)
-- windows: apertura fluida stile Nord
hl.animation({ leaf = "windows",        enabled = true, speed = 4, bezier = "nordSmooth", style = "slide"  })
-- windowsOut: chiusura rapida
hl.animation({ leaf = "windowsOut",     enabled = true, speed = 4, bezier = "easeInOut", style = "slide"  })
-- windowsMove: spostamento morbido
hl.animation({ leaf = "windowsMove",    enabled = true, speed = 4, bezier = "nordSmooth"                  })
-- border: cambio bordo fluido
hl.animation({ leaf = "border",         enabled = true, speed = 4, bezier = "easeInOut"                  })
-- borderangle: rotazione gradiente bordo
hl.animation({ leaf = "borderangle",    enabled = true, speed = 4, bezier = "easeInOut"                   })
-- fade: dissolvenza classica
hl.animation({ leaf = "fade",           enabled = true, speed = 3, bezier = "easeInOut"                   })
-- workspaces: cambio workspace pulito (senza rimbalzi eccessivi per stile Nord)
hl.animation({ leaf = "workspaces",     enabled = true, speed = 4, bezier = "nordSmooth", style = "slide"  })
-- specialWorkspace: scratchpad
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "nordSmooth",  style = "slidevert" })
