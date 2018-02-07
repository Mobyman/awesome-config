return {
    terminal            = 'terminator',                     -- | Terminal
    editor              = os.getenv('EDITOR') or 'vim', -- | Editor
    isTitlebarsEnabled  = false,                       -- | Whether to use titlebars for clients
    modkey              = 'Mod4',                      -- | "Super"-key
    onlyOneTray         = true,                        -- | Spawn tray only at first screen
    favoritesMpdCommand = nil,                         -- | Command to execute when "add to favorites" of mpd widget clicked
    screenshotPath      = os.getenv('HOME') .. '/'     -- | Path where screenshots would be saved
}
