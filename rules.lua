local awful     = require('awful')
awful.rules     = require("awful.rules")
local beautiful = require('beautiful')

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = { },
		properties = { 
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus        = awful.client.focus.filter,
			raise        = true,
			keys         = clientkeys,
			buttons      = clientbuttons
		}
	}, {
		rule = { class = "MPlayer" },
	  	properties = { floating = true } 
	}, {
		rule = { class = "pinentry" },
		properties = { floating = true } 
	}, {
		rule = { class = "gimp" },
		properties = { floating = true } 
	},
	{ rule = { class = "Google-chrome" }, properties = { tag = tags[1][1], floating = false, maximized_vertical = true, maximized_horizontal = true } },
    { rule = { class = "sun-awt-X11-XDialogPeer" }, properties = { tag = tags[1][2], floating = true } },
    { rule = { class = "jetbrains-idea" },  properties = { tag = tags[1][2], floating = true, maximized_vertical = true, maximized_horizontal = true } },
    { rule = { class = "Telegram" },  properties = { tag = tags[1][3], floating = true, maximized_vertical = true, maximized_horizontal = true } },
    { rule = { class = "x-terminal-emulator" },  properties = { tag = tags[1][4], floating = true, maximized_vertical = true, maximized_horizontal = true } },
    { rule = { class = "Sublime" },  properties = { tag = tags[1][5], floating = true, maximized_vertical = true, maximized_horizontal = true } }

	-- Set Firefox to always map on tags number 2 of screen 1.
	-- { rule = { class = "Firefox" },
	--   properties = { tag = tags[1][2] } },
}