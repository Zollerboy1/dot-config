-- Hyprland Lua config. See https://wiki.hypr.land/Configuring/
-- Machine-local monitor layout lives in hyprland/monitors.lua (gitignored).
require("hyprland.monitors")

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("GDK_BACKEND", "wayland,x11")
hl.env("GDK_SCALE", "2")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_SCALE_FACTOR", "2")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("GTK_THEME", "Breeze-Dark")
hl.env("QT_QPA_PLATFORMTHEME", "gtk2")
hl.env("XCURSOR_THEME", "WhiteSur-cursors")
hl.env("XCURSOR_SIZE", "16")

hl.env("AQ_DRM_DEVICES", "/dev/dri/amd-dgpu:/dev/dri/intel-igpu")

---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "uwsm-app -- kitty"
local fileManager = "uwsm-app -- nemo"
local menu        = "walker"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprctl setcursor WhiteSur-cursors 16")
    hl.exec_cmd("uwsm-app -- kdeconnectd")
    hl.exec_cmd("uwsm-app -- kdeconnect-indicator")
    hl.exec_cmd("uwsm-app -- walker --gapplication-service")
    hl.exec_cmd("uwsm-app -- kitty", { workspace = "1 silent" })
    hl.exec_cmd("uwsm-app -- brave", { workspace = "2 silent" })
end)

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- For all options, see https://wiki.hypr.land/Configuring/core/config-options/
hl.config({
    debug = {
        disable_logs = false,
    },

    input = {
        kb_layout  = "de",
        kb_variant = "mac_nodeadkeys",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        resolve_binds_by_sym = true,

        repeat_rate  = 50,
        repeat_delay = 300,

        follow_mouse = 1,

        touchpad = {
            disable_while_typing = false,
            natural_scroll       = true,
            clickfinger_behavior = true,
        },

        sensitivity = 0.3, -- -1.0 - 1.0, 0 means no modification.
    },

    general = {
        gaps_in     = 2,
        gaps_out    = 5,
        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(6d3277ee)", "rgba(9e4399ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        layout = "dwindle",

        -- Please see https://wiki.hypr.land/Configuring/extra/tearing/ before you turn this on
        allow_tearing = false,
    },

    decoration = {
        rounding = 5,

        blur = {
            enabled = true,
            size    = 3,
            passes  = 1,
        },

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true, -- you probably want this
    },

    master = {
    },

    gestures = {
        workspace_swipe_invert             = true,
        workspace_swipe_min_speed_to_force = 10,
    },

    cursor = {
        inactive_timeout = 10,
    },

    misc = {
        force_default_wallpaper = 0, -- Set to 0 to disable the anime mascot wallpapers
        focus_on_activate       = true,
    },

    ecosystem = {
        no_update_news  = true,
        no_donation_nag = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },
})

-- Per-device config
hl.device({
    name       = "keychron-keychron-k1",
    kb_layout  = "us",
    kb_variant = "colemak_dh",
    kb_options = "altwin:swap_alt_win",
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

--------------------
---- ANIMATIONS ----
--------------------

-- See https://wiki.hypr.land/Configuring/core/animations/
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" })

----------------------
---- WINDOW RULES ----
----------------------

-- See https://wiki.hypr.land/Configuring/core/rules/window-rules/
hl.window_rule({ match = { class = "^(nemo|wlogout)$" }, float = true })
hl.window_rule({ match = { class = "^(brave-browser)$" }, tile = true })
hl.window_rule({ match = { class = "^(wlogout)$" }, no_anim = true })
hl.window_rule({ match = { title = "^((Open( ((F|f)ile|(F|f)older)s?)?))$" }, float = true })
hl.window_rule({ match = { class = "^xdg-desktop-portal-gtk$" }, float = true })
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" }) -- You'll probably like this.

hl.window_rule({
    match  = { title = "^(Discord Updater|Steam Settings)$" },
    float  = true,
    center = true,
})

hl.window_rule({
    match = { class = "^(com.github.wwmm.easyeffects)$" },
    float = true,
    size  = { 800, 600 },
})

-- Vivado: float and center every window, except the main "Vivado X.Y" window
-- which is tiled (rules are evaluated top to bottom, last match wins; RE2 has no lookahead).
hl.window_rule({
    match  = { class = "^(ui-PlanAhead)$" },
    float  = true,
    center = true,
})
hl.window_rule({
    match = { class = "^(ui-PlanAhead)$", title = "^(Vivado [0-9]+\\.[0-9]+)$" },
    tile  = true,
})

hl.window_rule({
    match = { class = "^(thunderbird)$", title = "^(Write:.*)$" },
    float = true,
    size  = { 700, 850 },
})

hl.window_rule({
    match = { class = "^(dev.zed.Zed-Preview)$", title = "^(About Zed)$" },
    float = true,
    size  = { 450, 300 },
})

---------------------
---- KEYBINDINGS ----
---------------------

-- See https://wiki.hypr.land/Configuring/core/binds/
local mainMod = "SUPER"

hl.bind(mainMod .. " + T",     hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q",     hl.dsp.window.close())
hl.bind(mainMod .. " + E",     hl.dsp.exec_cmd("uwsm stop"))
hl.bind(mainMod .. " + L",     hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mainMod .. " + M",     hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + space", hl.dsp.exec_raw(menu))
-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())         -- dwindle
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))   -- dwindle

-- Move focus with mainMod + CTRL + arrow keys
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + CTRL + F",     hl.dsp.window.float({ action = "toggle" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
-- (the SHIFT variants use keycodes because SHIFT changes the keysym)
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,                    hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + code:" .. (i + 9),   hl.dsp.window.move({ workspace = i }))
end

-- Move workspaces with mainMod + ALT + arrow keys
hl.bind(mainMod .. " + ALT + left",  hl.dsp.exec_cmd("~/.local/bin/hyprworkspacectl move left"))
hl.bind(mainMod .. " + ALT + right", hl.dsp.exec_cmd("~/.local/bin/hyprworkspacectl move right"))

-- Move/resize windows with mainMod + LMB and dragging
hl.bind(mainMod .. " + mouse:272",           hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + SHIFT + mouse:272",   hl.dsp.window.resize(), { mouse = true })

-- Lid switch
hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("loginctl lock-session"), { locked = true })
hl.bind("switch:on:Lid Switch", function()
    -- The wiki recommends not dispatching dpms directly from a bind.
    hl.timer(function() hl.dispatch(hl.dsp.dpms({ action = "off" })) end, { timeout = 500, type = "oneshot" })
end, { locked = true })
hl.bind("switch:off:Lid Switch", function()
    hl.timer(function() hl.dispatch(hl.dsp.dpms({ action = "on" })) end, { timeout = 500, type = "oneshot" })
end, { locked = true })

-- Screenshots
hl.bind(mainMod .. " + CTRL + 3", hl.dsp.exec_cmd([[grim -o "$(hyprctl activeworkspace -j | jq -r '.monitor')" - | swappy -f -]]))
hl.bind(mainMod .. " + CTRL + 4", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | swappy -f -]]))

-- Touchbar
hl.bind("XF86MonBrightnessDown",  hl.dsp.exec_cmd("~/.config/hypr/scripts/backlight.sh --dec"), { repeating = true })
hl.bind("XF86MonBrightnessUp",    hl.dsp.exec_cmd("~/.config/hypr/scripts/backlight.sh --inc"), { repeating = true })
hl.bind("XF86SelectiveScreenshot", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | swappy -f -]]))
hl.bind("XF86Search",             hl.dsp.exec_cmd(menu))
hl.bind("XF86KbdBrightnessDown",  hl.dsp.exec_cmd("~/.config/hypr/scripts/kb_backlight.sh --dec"), { repeating = true })
hl.bind("XF86KbdBrightnessUp",    hl.dsp.exec_cmd("~/.config/hypr/scripts/kb_backlight.sh --inc"), { repeating = true })
hl.bind("XF86AudioMute",          hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh --toggle-mute"), { repeating = true })
hl.bind("XF86AudioRaiseVolume",   hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh --inc"), { repeating = true })
hl.bind("XF86AudioLowerVolume",   hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh --dec"), { repeating = true })

-- Copy/Paste/Cut/Undo: Cmd+key is translated to CTRL+key for these classes,
-- everything else gets the SUPER+key shortcut forwarded (e.g. kitty handles it itself).
local ctrlShortcutClasses = { ["brave-browser"] = true, thunderbird = true, discord = true, Slack = true }

local function forwardShortcut(key)
    return function()
        local w = hl.get_active_window()
        local mods = (w and ctrlShortcutClasses[w.class]) and "CTRL" or "SUPER"
        hl.dispatch(hl.dsp.send_shortcut({ mods = mods, key = key, window = "activewindow" }))
    end
end

hl.bind(mainMod .. " + C", forwardShortcut("C"))
hl.bind(mainMod .. " + V", forwardShortcut("V"))
hl.bind(mainMod .. " + X", forwardShortcut("X"))
hl.bind(mainMod .. " + Z", forwardShortcut("Z"))

-- Passthrough: disable all binds until mainMod + P is pressed again
hl.bind(mainMod .. " + P", hl.dsp.submap("passthrough"))
hl.define_submap("passthrough", function()
    hl.bind(mainMod .. " + P", hl.dsp.submap("reset"))
end)
