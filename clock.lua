local awful     = require('awful')
local wibox     = require('wibox')
local vicious   = require('vicious')
local beautiful = require('beautiful')
local wrapper   = require('widget_wrapper')

local months = {
    "января",
    "февраля",
    "марта",
    "апреля",
    "мая",
    "июня",
    "июля",
    "августа",
    "сентября",
    "октября",
    "ноября",
    "декабря"
}

local clock = {}
clock.private = {}
clock.private.widgets = {}
clock.private.widgets.text = wibox.widget.textbox()
clock.private.widgets.main = wibox.widget.background()
clock.private.widgets.label = wibox.widget.imagebox(beautiful.widgets.clock)
clock.private.widgets.left  = wibox.widget.imagebox()
clock.private.widgets.main:set_widget(clock.private.widgets.text)
clock.private.widgets.main:set_bgimage(beautiful.widgets.display.bg)
clock.private.widgets.left:set_image(beautiful.widgets.display.left)

clock.tooltip = awful.tooltip({
    objects = { clock.private.widgets.text },
    timer_function = function ()
        local c = "date +%"
        local month = io.popen(c.."m"):read()
        local week  = io.popen(c.."A"):read()
        local day   = io.popen(c.."d"):read()
        local year  = io.popen(c.."Y"):read()
	    month = months[tonumber(month)]
	return 
            "\n "..
            week  ..", "..
            day   .." "..
            month .." "..
            year  .." года."..
            " \n"
    end
})
vicious.register(clock.private.widgets.text, vicious.widgets.date, "%R", 60)

local builder = wrapper.createBuilder()
builder:add(clock.private.widgets.label)
builder:add(clock.private.widgets.left)
builder:add(clock.private.widgets.main)
builder:finish()
clock.widget = builder:getWidgets()

return clock
