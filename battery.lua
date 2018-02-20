local wibox     = require('wibox')
local naughty   = require("naughty")
local beautiful = require("beautiful")
local awful     = require("awful")
local wrapper   = require('widget_wrapper')
local interval

local battery = {}
battery.private = {}
battery.private.widgets = {}
battery.private.widgets.text = wibox.widget.textbox()
battery.private.widgets.label = wibox.widget.imagebox()
battery.private.widgets.main = wibox.widget.background()
battery.private.widgets.left = wibox.widget.imagebox()
battery.private.widgets.left:set_image(beautiful.widgets.display.left)
battery.private.widgets.main:set_widget(battery.private.widgets.text)
battery.private.widgets.main:set_bgimage(beautiful.widgets.display.bg)

local notify = function (status)
    naughty.notify({
        title      = "Battery Warning",
        text       = "Battery low! "..status.percentage.."("..status.remaining..") left!",
        timeout    = 5,
        position   = "top_right",
        fg         = beautiful.fg_focus,
        bg         = beautiful.bg_focus,
    })
end

local info = function ()
    return io.popen("acpi -b | cut -d ',' -f3 | cut -d ' ' -f2"):read()
end

battery.tooltip = awful.tooltip({
    objects = { battery.private.widgets.text },
    timer_function = function ()
        local wrapped = info()
        local preffix
        if io.popen("acpi -b"):read():match("Discharging") then
            preffix = " Life-time remaining: "
        elseif io.popen("acpi -b"):read():match("Charging") then
            preffix = " Until charge: "
        else
            preffix = " Charged"
        end
        wrapped = "\n" .. preffix .. wrapped .. " \n"
        return wrapped
    end
})

local update = function ()
    local status = {}
    status.fullInfo = io.popen("acpi -b"):read()
    status.percentage = tonumber(io.popen("acpi -b | cut -d \" \" -f4 | cut -d \",\" -f1 | sed 's/%//'"):read())
    status.remaining = io.popen("acpi -b | cut -d ',' -f3 | cut -d ' ' -f2"):read()

    local percentNumber = status.percentage
    local color = 'gray'

    if not percentNumber then
        color = 'gray'
    elseif  percentNumber > 99 then
        color = 'white'
    elseif percentNumber <= 10 then
        color = 'red'
    elseif percentNumber <= 15 then
        color = 'orange'
    elseif percentNumber >= 16 then
        color = 'green' 
    end             

    widgetText = "<span color='" .. color .."'>".. status.percentage .."%</span>"
    if status.fullInfo:match("Charging") then
        battery.private.widgets.label:set_image(beautiful.widgets.battery.charging)
        battery.private.widgets.text:set_markup(widgetText)
    elseif status.fullInfo:match("Discharging") then
        battery.private.widgets.text:set_markup(widgetText)
        if percentNumber < 25 then
            battery.private.widgets.label:set_image(beautiful.widgets.battery.low)
            if percentNumber < 10 then
                notify(status)
                battery.private.widgets.label:set_image(beautiful.widgets.battery.critical)
            end
        elseif percentNumber < 75 then
            battery.private.widgets.label:set_image(beautiful.widgets.battery.middle)
        else
            battery.private.widgets.label:set_image(beautiful.widgets.battery.full)
        end
        battery.private.widgets.text:set_markup(widgetText)
    else
        if percentNumber > 75 then
            battery.private.widgets.label:set_image(beautiful.widgets.battery.charging)
        end
        battery.private.widgets.text:set_markup(widgetText)
    end
end

interval = timer({timeout = 5})
interval:connect_signal('timeout', update)
interval:start()
update()

local builder = wrapper.createBuilder()
builder:add(battery.private.widgets.label)
builder:add(battery.private.widgets.left)
builder:add(battery.private.widgets.main)
builder:finish()

battery.widget = builder:getWidgets()

return battery