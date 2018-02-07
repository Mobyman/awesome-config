return {
    'systray',               -- | Sytem tray
    require('kbd'),          -- | Keyboard layout widget (ru/en)
    require('wifi'),          -- | WiFi
    require('vpn'),          -- | VPN manager for systemd
    require('mpd'),          -- | Music Player Daemon control widget
    require('touchpad'),     -- | Touchpad control widget
    require('battery'),      -- | Battery indicator
    require('backlight'),    -- | Backlight control widget
    require('volume'),       -- | Pulseaudio volume control widget
    require('clock'),        -- | Clock widget
    require('xrandr'),       -- | XRandr control keybindings
    require('screenshooter') -- | Screenshot via scrot keybindings
}
