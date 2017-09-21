local awful = require('awful')
local wrapper = require('widget_wrapper')
local beautiful = require('beautiful')
local wibox = require('wibox')
local io = require('io')
local math = require('math')

local widget = {}
widget.text = wibox.widget.textbox()
widget.label = wibox.widget.imagebox()
widget.main = wibox.widget.background()
widget.left = wibox.widget.imagebox()
widget.left:set_image(beautiful.widgets.display.left)
widget.main:set_widget(widget.text)
widget.main:set_bgimage(beautiful.widgets.display.bg)

local maxBrightnessFile = io.open('/sys/class/backlight/intel_backlight/max_brightness')
local maxBrightness = maxBrightnessFile:read('*n')
maxBrightnessFile:close()
local redrawLoop = timer({timeout = 5})

local function getBacklight()
   local currentBrightnessFile = io.open('/sys/class/backlight/intel_backlight/actual_brightness')
   local currentBrightness = currentBrightnessFile:read('*n')
   currentBrightnessFile:close()
   return math.floor(currentBrightness / maxBrightness * 100 + 0.5)
end

local function redraw()
    local backlight = getBacklight()
    widget.text:set_text(backlight .. '%')
    if backlight >= 75 then
        widget.label:set_image(beautiful.widgets.backlight.high)
    elseif backlight >= 40 then
        widget.label:set_image(beautiful.widgets.backlight.medium)
    else
        widget.label:set_image(beautiful.widgets.backlight.low)
    end
end

redrawLoop:connect_signal('timeout', redraw)
redrawLoop:start()
redraw()

local builder = wrapper.createBuilder()
builder:add(widget.label)
builder:add(widget.left)
builder:add(widget.main)
builder:finish()

local step = 5
local lowerBrightness = function ()
    awful.util.spawn_with_shell('xbacklight -dec ' .. step)
end
local raiseBrightness = function ()
    awful.util.spawn_with_shell('xbacklight -inc ' .. step)
end

local bindKeys = function ()
    globalkeys = awful.util.table.join(
        globalkeys,
        awful.key({}, 'XF86MonBrightnessUp', function ()
            raiseBrightness()
            redraw()
        end),
        awful.key({}, 'XF86MonBrightnessDown', function ()
            lowerBrightness()
            redraw()
        end)
    )
end

local uiBindings = awful.util.table.join(
    awful.button({ }, 5, function ()
        lowerBrightness()
        redraw()
    end),
    awful.button({ }, 4, function ()
        raiseBrightness()
        redraw()
    end)
)

widget.main:buttons(uiBindings)
widget.label:buttons(uiBindings)
widget.left:buttons(uiBindings)

return { widget=builder:getWidgets(); bindKeys=bindKeys }

