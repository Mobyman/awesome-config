local awful     = require('awful')
local wibox     = require('wibox')
local beautiful = require('beautiful')
local wrapper   = require('widget_wrapper')
local stringUtils = require('util.string')
local naughty = require('naughty')
local timer = require('timer')

local notConnectedText = "Wi-Fi"

local current = nil
local widgets = {}

widgets.main  = wibox.widget.background()
widgets.text  = wibox.widget.textbox()
widgets.label = wibox.widget.imagebox()
widgets.left  = wibox.widget.imagebox()

local function isActive(id)
    local result = io.popen("PYTHONIOENCODING=utf-8 wicd-cli -i | grep 'Connected to' | awk -F' at ' '{ print $1 }'"):read()
    return result == id
end

local function getSignal() 
    return io.popen("PYTHONIOENCODING=utf-8 wicd-cli -i | grep ' at ' | awk -F'at ' '{ print $2 }' | sed s/dBm.*//"):read()
end 

local function getName() 
    return io.popen("PYTHONIOENCODING=utf-8 wicd-cli -y -i | grep -oP 'Connected to (\\w|\\d|-)+' | awk '{ print $3 }'"):read()
end

local function getStatus() 
    status = io.popen("PYTHONIOENCODING=utf-8 wicd-cli -y -i | grep -P 'Connection status' | awk -F': ' '{ print $2 }'"):read()
    if status == 'Not connected' then
        return notConnectedText
    else 
        return status
    end
end   


local function getPointWithSignal() 
    current = getName()
    if not current then
        return getStatus()
    end 

    signal = tonumber(getSignal())
    color = '#FFFFFF'
    if not signal then
        color = 'gray'
    elseif signal <= -70 then
        color = 'red'
    elseif signal <= -50 then
        color = 'orange'
    elseif signal > -50 then
        color = 'green'  
    else
        color = 'gray'
    end             

    return "<b>" .. current .. "</b> | <span color='" .. color .."'>" .. signal .. " dBm</span>"
end

local function getWifiList()
    local handler = io.popen("wicd-cli --wireless -l | awk '{ print $4 }' | tail -n +2")
    local result = {}
    local key = 0
    for line in handler:lines() do
        result[#result + 1] = line
        if isActive(key) then
            current = line
        end
        key = key + 1
    end
    handler:close()
    return result
end

local function disconnect()
    current = nil
    awful.util.spawn_with_shell('wicd-cli -x')
end

local function connect(id)
    if current then
        disconnect()
    end
    awful.util.spawn_with_shell("wicd-cli -y -c -n " .. id)
    widgets.text:set_markup(getPointWithSignal())    
end

local function createMenuEntry(index, name)
    return { name, function ()
        connect(index)
        widgets.text:set_text(name)
    end }
end

local function createMenu()
    local available = getWifiList()
    local result = {}
    for i = 1, #available do
        result[i] = createMenuEntry((i-1), available[i])
    end
    result[#available + 1] = { "Disconnect", function ()
        disconnect()
        widgets.text:set_text(getStatus())
    end }

    return awful.menu(result)
end

local menu = createMenu()

if current == nil then
    widgets.text:set_text(getStatus())
else
    widgets.text:set_markup_silently(getPointWithSignal())
end


widgets.main:set_bgimage(beautiful.widgets.display.bg)
widgets.main:set_widget(widgets.text)
widgets.left:set_image(beautiful.widgets.display.left)

local builder = wrapper.createBuilder()
builder:add(widgets.label)
builder:add(widgets.left)
builder:add(widgets.main)
builder:finish()

local bindings = awful.util.table.join(
    awful.button({}, 1, function ()
        menu:show()
    end),
    awful.button({}, 2, function ()
        menu = createMenu()
    end),
    awful.button({}, 3, function ()
        menu:show()
    end)
)

widgets.text:buttons(bindings)
widgets.main:buttons(bindings)
widgets.left:buttons(bindings)
widgets.label:buttons(bindings)

wifitimer = timer({ timeout = 1 })
wifitimer:connect_signal("timeout", function() widgets.text:set_markup(getPointWithSignal()) end)
wifitimer:start()

return {
    widget = builder:getWidgets()
}
