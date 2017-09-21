local awful = require('awful')
local base  = require('base-config')
local logger = require('util/logger').globalLogger
local s = {}

s.programm = 'shutter'
s.keys = {}
s.keys.area = '-s'
s.keys.window = '-s'
s.config = {}
s.config.pathTemplate = base.screenshotPath .. '/%d.%m.%Y %H:%M:%S (\$wx\$h).png'

local function makeScreenshot()
	awful.util.spawn_with_shell(s.programm .. ' ' .. '\'' .. s.config.pathTemplate .. '\' &')
end

local function makeAreashot()
	awful.util.spawn_with_shell('sleep 0.3 && ' .. s.programm .. ' ' .. s.keys.area .. ' ' .. '\'' .. s.config.pathTemplate .. '\' &')
end

local function makeWindowshot()
	awful.util.spawn_with_shell('sleep 0.3 && ' .. s.programm .. ' ' .. s.keys.window .. ' ' .. '\'' .. s.config.pathTemplate .. '\' &')
end

s.bindKeys = function ()
	globalkeys = awful.util.table.join(
		globalkeys,
		awful.key({ }, "Print", makeScreenshot),
		awful.key({ modkey }, "Print", makeAreashot),
		awful.key({ modkey, "Mod1" }, "Print", makeWindowshot)
	)
end

return s
