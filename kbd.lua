local beautiful = require("beautiful")
local awful     = require('awful')
local wibox     = require('wibox')

kbdcfg = {}
kbdcfg.cmd = "setxkbmap"
kbdcfg.layout = { { "us", "", 'en' }, { "ru", "", 'ru' } }
kbdcfg.current = 1
kbdcfg.private = {}
kbdcfg.private.widget = wibox.widget.imagebox()
kbdcfg.private.widget:set_image(beautiful.widgets.keyboard[kbdcfg.layout[kbdcfg.current][3]])
local function switch ()
  kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
  local t = kbdcfg.layout[kbdcfg.current]
  kbdcfg.private.widget:set_image(beautiful.widgets.keyboard[t[3]])
  os.execute( kbdcfg.cmd .. " " .. t[1] .. ",us" )
end
kbdcfg.private.widget:buttons(
  awful.util.table.join(awful.button({ }, 1, function () switch() end))
)
kbdcfg.bindKey = function ()
    globalkeys = awful.util.table.join(
        globalkeys,
        awful.key({ "Mod1" }, "Shift_L", function () switch() end),
        awful.key({ "Shift" }, "#64", function () switch() end)
    )
end

kbdcfg.widget = { kbdcfg.private.widget }
return kbdcfg
