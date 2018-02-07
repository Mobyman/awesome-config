local awful     = require('awful')
local wibox     = require('wibox')
local beautiful = require('beautiful')
local wrapper   = require('widget_wrapper')

local notConnectedText = "VPN"

local current = nil
local widgets = {}

widgets.main  = wibox.widget.background()
widgets.text  = wibox.widget.textbox()
widgets.label = wibox.widget.imagebox()
widgets.left  = wibox.widget.imagebox()

local function isActive(name)
    local h = io.popen('systemctl is-active openvpn@' .. name .. ' | grep inactive')
    local result = not h:read()
    h:close()
    return result
end

local function getVpnList()
    local handler = io.popen('ls -1 /etc/openvpn 2> /dev/null | grep "\\.conf" | sed "s/.conf//g"')
    local result = {}
    for line in handler:lines() do
        result[#result + 1] = line
        if isActive(line) then
            current = line
        end
    end
    handler:close()
    return result
end

local function disconnect(name)
    if name then
        if current == name then
            current = nil
        end
        awful.util.spawn_with_shell('sudo systemctl stop openvpn@' .. name)
    end
end

local function connect(name)
    if current then
        disconnect(current)
    end
    awful.util.spawn_with_shell('sudo systemctl start openvpn@' .. name)
    current = name
end

local function createMenuEntry(name)
    return { name, function ()
        connect(name)
        widgets.text:set_text(name)
    end }
end

local function createMenu()
    local available = getVpnList()
    local result = {}
    for i = 1, #available do
        result[i] = createMenuEntry(available[i])
    end
    result[#available + 1] = { "Disconnect", function ()
        disconnect(current)
        widgets.text:set_text(notConnectedText)
    end }
    return awful.menu(result)
end

local menu = createMenu()

if not current then
    widgets.text:set_text(notConnectedText)
else
    widgets.text:set_text(current)
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

return {
    widget = builder:getWidgets()
}
