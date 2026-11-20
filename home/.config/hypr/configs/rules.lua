-- ~/.config/hypr/configs/rules.lua
-- MacBookPro14,1 — Hyprland 0.57.2
-- Regole Finestre allineate a ThinkPad X280
-- Static effects: float, tile, fullscreen, move, size, center, pin, workspace
-- Dynamic effects: opacity, border_color, border_size, rounding, no_focus, ...

-- ════════════════════════════════════════════════════════════════════════════
-- REGOLE GLOBALI DI COMPORTAMENTO
-- ════════════════════════════════════════════════════════════════════════════

-- Ignora richieste arbitrarie di massimizzazione (es. app Electron, browser, Steam)
hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- ════════════════════════════════════════════════════════════════════════════
-- DIALOG E FINESTRE MODALI
-- ════════════════════════════════════════════════════════════════════════════

-- Regola globale: qualsiasi finestra riconosciuta nativamente come modale (Wayland)
hl.window_rule({
    match  = { modal = true },
    float  = true,
    center = true,
})

-- Fallback per dialog e finestre di dialogo che non dichiarano modal (XWayland e app legacy)
hl.window_rule({
    match  = { title = "^(Open File|Open Folder|Save As|Save File|Salva come|Apri|Preferences|Settings|Impostazioni|Print|Stampa|Alert|Confirm|Error|Warning|About|Find|Search).*$" },
    float  = true,
    center = true,
})

-- ── Firefox Developer Edition — dialog interni ───────────────────────────────
hl.window_rule({
    match  = { class = "^firefox-developer-edition$", modal = true },
    float  = true,
    center = true,
})
hl.window_rule({
    match  = {
        class = "^firefox-developer-edition$",
        title = "^(Opening|Save|Salva|Enter name|Alert|Confirm|Print|About Mozilla).*$",
    },
    float  = true,
    center = true,
})

-- ── AnyDesk — finestre secondarie / sessioni ──────────────────────────────────
hl.window_rule({
    match  = { class = "^(Anydesk)$", modal = true },
    float  = true,
    center = true,
})
hl.window_rule({
    match  = { class = "^(Anydesk)$", title = "negative:^(AnyDesk)$" },
    float  = true,
    center = true,
})

-- ════════════════════════════════════════════════════════════════════════════
-- SISTEMA E UTILITY (MacBook + X280)
-- ════════════════════════════════════════════════════════════════════════════

-- ── Polkit Authentication Agent ──────────────────────────────────────────────
hl.window_rule({
    match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" },
    float = true,
})

-- ── Pavucontrol (Mixer audio PulseAudio/PipeWire) ────────────────────────────
hl.window_rule({
    match  = { class = "^(pavucontrol|org.pulseaudio.pavucontrol)$" },
    float  = true,
    size   = { 820, 560 },
    center = true,
})

-- ── fly-foot-write (updater) ─────────────────────────────────────────────────
hl.window_rule({
    match  = { initial_title = "^(fly-foot-write)$" },
    float  = true,
    size   = { 858, 534 },
    center = true,
})
hl.window_rule({
    match  = { title = "^(fly-foot-write)$" },
    float  = true,
    size   = { 858, 534 },
    center = true,
})

-- ── fly-kitty (quick floating terminal) ───────────────────────────────────────
hl.window_rule({
    match  = { initial_title = "^(fly-kitty)$" },
    float  = true,
    size   = { 900, 600 },
    center = true,
})
hl.window_rule({
    match  = { title = "^(fly-kitty)$" },
    float  = true,
    size   = { 900, 600 },
    center = true,
})

-- ── fly-foot-tiled (htop monitor) ─────────────────────────────────────────────
hl.window_rule({
    match  = { initial_title = "^(fly-foot-tiled)$" },
    float  = true,
    size   = { 900, 600 },
    center = true,
})
hl.window_rule({
    match  = { title = "^(fly-foot-tiled)$" },
    float  = true,
    size   = { 900, 600 },
    center = true,
})

-- ── fly-foot-info (foot) ──────────────────────────────────────────────────────
hl.window_rule({
    match = { initial_class = "^(foot)$", initial_title = "^(fly-foot-info)$" },
    float = true,
    pin   = true,
    size  = { 900, 600 },
    move  = { "45%", "8%" },
})

-- ── fly-foot-info class diretta ───────────────────────────────────────────────
hl.window_rule({
    match  = { class = "^(fly-foot-info)$" },
    float  = true,
    size   = { 858, 534 },
    center = true,
})

-- ── fly-kitty-info ───────────────────────────────────────────────────────────
hl.window_rule({
    match  = { class = "^(fly-kitty-info)$" },
    float  = true,
    size   = { 800, 650 },
    center = true,
})
hl.window_rule({
    match  = { class = "^(fly-kitty-info)$", initial_title = "^(fly-kitty-info)$" },
    float  = true,
    size   = { 800, 650 },
    center = true,
})

-- ── Kitty su workspace 2 ─────────────────────────────────────────────────────
hl.window_rule({
    match = { class = "^(kitty)$", workspace = "2" },
    float = true,
    size  = { 700, 450 },
    move  = { 864, 80 },
})

-- ════════════════════════════════════════════════════════════════════════════
-- BROWSER WEB (100% opachi, nessuna trasparenza)
-- ════════════════════════════════════════════════════════════════════════════

hl.window_rule({
    match   = { class = "^(firefox-developer-edition|firefox|librewolf|chromium|brave-browser)$" },
    opacity = "1.0 override 1.0 override",
})

-- ════════════════════════════════════════════════════════════════════════════
-- APPLICAZIONI SPECIFICHE & MEDIA (100% opache)
-- ════════════════════════════════════════════════════════════════════════════

-- ── Player video e visualizzatori documenti ──────────────────────────────────
hl.window_rule({
    match   = { class = "^(mpv|haruna|[Aa]tril)$" },
    opacity = "1.0 override 1.0 override",
})

-- ── AnyDesk (Finestra principale) ────────────────────────────────────────────
hl.window_rule({
    match       = { class = "^(Anydesk)$", title = "^(AnyDesk)$" },
    float       = true,
    center      = true,
    size        = { 1400, 850 },
    opacity     = "1.0 override 1.0 override",
    border_size = 0,
})

-- ── GeForce NOW ──────────────────────────────────────────────────────────────
hl.window_rule({
    match                = { class = "^([Gg]e[Ff]orce.*|geforcenow-electron)$" },
    opacity              = "1.0 override 1.0 override",
    no_blur              = true,
    no_shadow            = true,
    idle_inhibit         = "focus",
    render_unfocused     = true,
    no_shortcuts_inhibit = true,
})

hl.window_rule({
    match                = { class = "^([Gg]e[Ff]orce.*|geforcenow-electron)$", title = "^([Gg]e[Ff]orce [Nn][Oo][Ww])$" },
    fullscreen           = false,
    float                = true,
    size                 = { 1280, 820 },
    center               = true,
    opacity              = "1.0 override 1.0 override",
    no_blur              = true,
    no_shadow            = true,
    idle_inhibit         = "focus",
    render_unfocused     = true,
    no_shortcuts_inhibit = true,
})

hl.window_rule({
    match                = { class = "^([Gg]e[Ff]orce.*|geforcenow-electron)$", title = ".*(su|on) GeForce NOW.*" },
    fullscreen           = true,
    opacity              = "1.0 override 1.0 override",
    no_blur              = true,
    no_shadow            = true,
    idle_inhibit         = "always",
    render_unfocused     = true,
    no_shortcuts_inhibit = true,
})

-- ════════════════════════════════════════════════════════════════════════════
-- XWAYLAND DRAG FIX
-- ════════════════════════════════════════════════════════════════════════════
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})
