hl.env("XCURSOR_SIZE", "12")
hl.env("HYPRCURSOR_SIZE", "12")
hl.env("XCURSOR_THEME", "minecur")
hl.env("HYPRCURSOR_THEME", "minecur")

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QUICK_CONTROLS_STYLE", "org.hyprland.style")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
-- hl.env("QT_WL_SECRET_SERVICE", "1")

hl.env("MPD_HOST", os.getenv("HOME") .. "/.config/mpd/socket")
-- hl.env("PATH", "$PATH:$HOME/.local/bin")
hl.env("PATH", os.getenv("PATH") .. ":" .. os.getenv("HOME") .. "/.local/bin")

hl.env("AQ_DRM_DEVICES", "/dev/dri/card0:/dev/dri/card1")
hl.env("AQ_NO_KMS_REQUIREMENT", "1")

hl.env("MAIN_CONFIG_FOLDER", "~/settings")
