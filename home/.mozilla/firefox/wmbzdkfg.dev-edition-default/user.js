// ==============================================================================
// User.js - Firefox Developer Edition (MacBook Pro A1708 - Kaby Lake / Hyprland)
// Hardware: Intel Core i5-7360U (2C/4T) | Intel Iris Plus 640 (iHD VA-API) | 8GB RAM (No Swap)
// Arch Linux + Wayland + Display P3 + tmpfs RAM Cache
// ==============================================================================

// === BROWSER PREDEFINITO & AVVIO ===
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.shell.defaultBrowserCheckCount", 1);

// === PERFORMANCE & RENDERING ===
user_pref("nglayout.initialpaint.delay", 0);
user_pref("browser.sessionstore.interval", 600000);
user_pref("browser.sessionstore.resume_from_crash", false);
user_pref("image.mem.decode_bytes_at_a_time", 65536);

// === WEBRENDER & ACCELERAZIONE GRAFICA 2D/3D (Intel Iris Plus 640) ===
user_pref("gfx.webrender.all", true);
// Evita il bug di disallineamento spazio colore su Wayland + Intel iHD
user_pref("gfx.webrender.compositor", false);
user_pref("gfx.webrender.compositor.force-enabled", false);
user_pref("gfx.webrender.precache-shaders", true);
user_pref("gfx.webrender.program-binary-disk", true);
user_pref("gfx.canvas.accelerated", true);

// === COLOR MANAGEMENT (Display P3 Retina / Wayland wp-color-management-v1) ===
user_pref("gfx.color_management.mode", 1);
user_pref("gfx.color_management.enablev4", true);
user_pref("gfx.color_management.rendering_intent", 0);
user_pref("gfx.wayland.hdr", true);

// === WAYLAND / HYPRLAND NATIVO ===
user_pref("widget.wayland.fractional-scale.enabled", true);
user_pref("widget.wayland.fractional-scale", true);
user_pref("widget.wayland.vsync.enabled", true);
user_pref("widget.use-xdg-desktop-portal.file-picker", 1);
user_pref("widget.use-xdg-desktop-portal.mime-handler", 1);
user_pref("widget.use-xdg-desktop-portal.settings", 1);

// === DECODIFICA VIDEO HARDWARE (VA-API Intel iHD Driver) ===
user_pref("media.ffmpeg.vaapi.enabled", true);
user_pref("media.hardware-video-decoding.enabled", true);
user_pref("media.rdd-ffmpeg.enabled", true);
user_pref("media.webrtc.hw.h264.enabled", true);
// Kaby Lake Gen9.5 non possiede decoder hardware AV1: forza VP9/H.264 in HW
user_pref("media.av1.enabled", false);

// === GESTIONE MEMORIA & PROTEZIONE ANTI-OOM (8GB RAM - ZERO SWAP) ===
user_pref("browser.tabs.unloadOnLowMemory", true);
user_pref("browser.tabs.unloadTabInContextMenu", true);
user_pref("browser.low_commit_space_threshold_mb", 768);
user_pref("browser.tabs.min_inactive_duration_before_unload", 300000);

// === CACHE SU RAM (tmpfs 512MB in ~/.cache/mozilla/firefox) ===
user_pref("browser.cache.disk.enable", true);
user_pref("browser.cache.disk.capacity", 524288);
user_pref("browser.cache.disk.smart_size.enabled", false);
user_pref("browser.cache.memory.enable", true);
user_pref("browser.cache.memory.capacity", -1);
user_pref("browser.cache.memory.max_entry_size", 10240);

// === NETWORK & PROTOCOLLI MODERNI (Early Hints HTTP 103, HTTP/3 0-RTT, TLS Cache) ===
user_pref("network.early-hints.enabled", true);
user_pref("network.early-hints.preconnect.enabled", true);
user_pref("network.http.http3.enable", true);
user_pref("network.http.http3.enable_0rtt", true);
user_pref("network.ssl_tokens_cache_capacity", 32768);

// === DNS, ECH (ENCRYPTED CLIENT HELLO) & NATIVE RESOLVER ===
user_pref("network.trr.mode", 5);
user_pref("network.dns.native_https_query", true);
user_pref("network.dns.echconfig.enabled", true);
user_pref("network.dns.echconfig.fallback_to_origin_when_all_failed", true);
user_pref("network.dns.use_https_rr_as_altsvc", true);

// === PRIVACY & ENHANCED TRACKING PROTECTION ===
// Prevenzione stalli D-Bus verso geoclue
user_pref("geo.provider.use_geoclue", false);
user_pref("geo.enabled", false);
user_pref("geo.provider.network.url", "");
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.trackingprotection.cryptomining.enabled", true);
user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
user_pref("network.cookie.cookieBehavior", 5);
user_pref("privacy.donottrackheader.enabled", true);
user_pref("privacy.globalprivacycontrol.enabled", true);
user_pref("beacon.enabled", false);
user_pref("browser.send_pings", false);

// === TELEMETRIA & REPORTING ===
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.coverage.opt-out", true);
user_pref("toolkit.coverage.opt-out", true);
user_pref("toolkit.coverage.endpoint.base", "");

// === ESPERIMENTI & SHIELD STUDIES ===
user_pref("experiments.supported", false);
user_pref("experiments.enabled", false);
user_pref("experiments.manifest.uri", "");
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");

// === CRASH REPORTS ===
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);

// === COLORI & PREVENZIONE PROBLEMI DI CONTRASTO / LEGGIBILITA SUI SITI WEB ===
user_pref("browser.display.document_color_use", 1);
user_pref("browser.display.use_system_colors", false);
user_pref("browser.display.background_color", "#ffffff");
user_pref("browser.display.foreground_color", "#000000");
user_pref("browser.anchor_color", "#0000ee");
user_pref("browser.visited_color", "#551a8b");
user_pref("layout.css.prefers-color-scheme.content-override", 2);

// === CUSTOM UI (chrome/userChrome.css) ===
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
