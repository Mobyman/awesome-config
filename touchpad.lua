local awful     = require("awful")
local wibox     = require('wibox')
local beautiful = require('beautiful')
local wrapper   = require('widget_wrapper')
local touchpad  = {};

touchpad.private = {};
touchpad.private.widget = wibox.widget.imagebox()

os.execute("synclient CircularScrolling=1 VertEdgeScroll=1 TapButton1=1 HorizTwoFingerScroll=1")

local function updateTouchWidget()
	local touch_stat = io.popen("synclient -l | grep 'TouchpadOff.*=.0'"):read()
	if(touch_stat) then
		touchpad.private.widget:set_image(beautiful.widgets.touchpad.on)
	else
		touchpad.private.widget:set_image(beautiful.widgets.touchpad.off)
	end
end

local function touchpadToggle()
	local touch_stat = io.popen("synclient -l | grep 'TouchpadOff.*=.0'"):read()
	if touch_stat then 
		os.execute("`sleep 1 && synclient TouchpadOff=1`&")
		touchpad.private.widget:set_image(beautiful.widgets.touchpad.off)
	else
		os.execute("`sleep 1 && synclient TouchpadOff=0`&")
		touchpad.private.widget:set_image(beautiful.widgets.touchpad.on)
	end
end

touchpad.bindKey = function ()
	globalkeys = awful.util.table.join(
		globalkeys,
		awful.key({ }, "XF86TouchpadToggle", touchpadToggle)
	)
end

touchpad.private.widget:buttons(awful.util.table.join(
	awful.button({ }, 1, touchpadToggle)
))

touchpad.widget = { touchpad.private.widget }

updateTouchWidget()

return touchpad
--TouchpadOff="..t_status.." CircularScrolling=1 VertEdgeScroll=1 TapButton1=1
