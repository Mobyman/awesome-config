local awful     = require('awful')
local wibox     = require('wibox')
local beautiful = require('beautiful')
local wrapper   = require('widget_wrapper')
local stringUtils = require('util.string')
local naughty = require('naughty')
local timer = require('timer')

local notConnectedText = "WIFI Off"

local current = nil
local widgets = {}

widgets.main  = wibox.widget.background()
widgets.text  = wibox.widget.textbox()
widgets.label = wibox.widget.imagebox()
widgets.left  = wibox.widget.imagebox()

local function isActive(id)
    local h = io.popen("PYTHONIOENCODING=utf-8 wicd-cli -i | grep 'Идентификатор' | awk -F': ' '{ print $2 }'")
    local result = h:read()
    h:close()
    return result == id
end

local function getSignal() 
    local h = io.popen("PYTHONIOENCODING=utf-8 wicd-cli -i | grep -o '[0-9]*%'")
    local signal = h:read()
    h:close()
    return signal  
end 

local function getPointWithSignal() 
    if current then
        return current .. " " .. getSignal()
    else 
        return notConnectedText
    end
end

local function getWifiList()
    local handler = io.popen("wicd-cli --wireless -l | awk '{ print $1 \" |\" $4 }' | tail -n +2")
    local result = {}
    for line in handler:lines() do
        result[#result + 1] = line
        if isActive(stringUtils.split(line, " |")[1]) then
            current = stringUtils.split(line, " |")[2]
        end
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
    current = name
    widgets.text:set_text(getPointWithSignal())    
end

local function createMenuEntry(name)
    return { name, function ()
        connect(stringUtils.split(name, " |")[1])
        widgets.text:set_text(stringUtils.split(name, " |")[2])
    end }
end

local function createMenu()
    local available = getWifiList()
    local result = {}
    for i = 1, #available do
        result[i] = createMenuEntry(available[i])
    end
    result[#available + 1] = { "Disconnect", function ()
        disconnect()
        widgets.text:set_text(notConnectedText)
    end }

    return awful.menu(result)
end

local menu = createMenu()

if current == nil then
    widgets.text:set_text(notConnectedText)
else
    widgets.text:set_text(getPointWithSignal())
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

wifitimer = timer({ timeout = 5 })
wifitimer:connect_signal("timeout", function() widgets.text:set_text(getPointWithSignal()) end)
wifitimer:start()

return {
    widget = builder:getWidgets()
}
