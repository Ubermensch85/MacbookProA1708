-- ~/.config/hypr/configs/appearance.lua
-- MacBookPro14,1 — Hyprland 0.57.2
-- Tema: Nord + Blu Elettrico (allineato a ThinkPad X280)
-- Palette:
--   nord0  #2e3440 — Polar Night (background)
--   nord3  #4c566a — Polar Night (bordo inattivo)
--   accent #00bfff / #0088ff / #0055ff — Blu Elettrico

hl.config({
    general = {
        gaps_in                 = 4,
        gaps_out                = 6,
        border_size             = 1,
        col = {
            active_border   = { colors = { "rgb(00bfff)", "rgb(0088ff)", "rgb(0055ff)", "rgb(0088ff)", "rgb(00bfff)" }, angle = 45 },
            inactive_border = "rgb(4c566a)",
        },
        extend_border_grab_area = 15,
        resize_on_border        = false,
        layout                  = "dwindle",
    },
    decoration = {
        rounding           = 10,
        rounding_power     = 2.0,
        active_opacity     = 0.90,
        inactive_opacity   = 0.85,
        fullscreen_opacity = 1.0,
        blur = {
            enabled    = true,
            size       = 4,
            passes     = 2,
            vibrancy   = 0.2,
            noise      = 0.02,
            brightness = 0.85,
        },
        shadow = {
            enabled      = true,
            range        = 6,
            render_power = 2,
            color        = "rgba(10152066)",
        },
    },
    animations = {
        enabled = true,
    },
})

-- ── Curve Bezier ─────────────────────────────────────────────────────────────
hl.curve("overshot",  { type = "bezier", points = { {0.13, 0.99}, {0.29, 1.1}   } })
hl.curve("smoothOut", { type = "bezier", points = { {0.36, 0},    {0.66, -0.56} } })
hl.curve("spring",    { type = "bezier", points = { {0.68, -0.55},{0.27, 1.55}  } })
hl.curve("linear",    { type = "bezier", points = { {0, 0},       {1, 1}        } })
hl.curve("easeInOut", { type = "bezier", points = { {0.42, 0},    {0.58, 1}     } })
hl.curve("bounce",    { type = "bezier", points = { {0.17, 0.67}, {0.54, 1.5}   } })

-- ── Animazioni ───────────────────────────────────────────────────────────────
hl.animation({ leaf = "windows",          enabled = true, speed = 5, bezier = "spring",    style = "slide"     })
hl.animation({ leaf = "windowsOut",       enabled = true, speed = 4, bezier = "smoothOut", style = "slide"     })
hl.animation({ leaf = "windowsMove",      enabled = true, speed = 5, bezier = "overshot"                       })
hl.animation({ leaf = "border",           enabled = true, speed = 6, bezier = "easeInOut"                      })
-- Rotazione gradiente disattivata per preservare la batteria
hl.animation({ leaf = "borderangle",      enabled = false })
hl.animation({ leaf = "fade",             enabled = true, speed = 4, bezier = "easeInOut"                      })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 5, bezier = "bounce",    style = "slide"     })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "spring",    style = "slidevert" })
