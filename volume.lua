local awful     = require('awful')
local wibox     = require('wibox')
local beautiful = require('beautiful')
local wrapper   = require('widget_wrapper')
local pa        = require('util.pulseaudio')
local math      = math
require('helper')

local volume    = {}
local widgets = {}
local currentLabelImage = beautiful.widgets.volume.mute
local muted = pa.isMuted()

widgets.main  = wibox.widget.background()
widgets.text  = wibox.widget.textbox()
widgets.label = wibox.widget.imagebox()
widgets.left  = wibox.widget.imagebox()

widgets.main:set_bgimage(beautiful.widgets.display.bg)
widgets.main:set_widget(widgets.text)
widgets.left:set_image(beautiful.widgets.display.left)

local builder = wrapper.createBuilder()
builder:add(widgets.label)
builder:add(widgets.left)
builder:add(widgets.main)
builder:finish()

volume.widget = builder:getWidgets()

local function drawVolume(volumeLevel)
    volumeLevel = math.abs(round(volumeLevel))
    local icon = beautiful.widgets.volume.mute
    if volumeLevel > 66 then
        icon = beautiful.widgets.volume.high
    elseif volumeLevel > 33 then
        icon = beautiful.widgets.volume.normal
    elseif volumeLevel ~= 0 then
        icon = beautiful.widgets.volume.low
    end
    widgets.text:set_text(math.abs(round(volumeLevel)) .. '%')
    currentLabelImage = icon
end

local function update()
    if muted then
        widgets.label:set_image(beautiful.widgets.volume.mute)
    else
        widgets.label:set_image(currentLabelImage)
    end
end

local function event(volumeLevel)
    drawVolume(volumeLevel)
    update()
end

event(pa.getVolume())

volume.bindKeys = function ()
    globalkeys = awful.util.table.join(
        globalkeys,
        awful.key({}, 'XF86AudioRaiseVolume', function ()
            event(pa.volumeUp())
        end),
        awful.key({}, 'XF86AudioLowerVolume', function ()
            event(pa.volumeDown())
        end),
        awful.key({}, 'XF86AudioMute', function ()
            muted = not pa.muteToggle()
            update()
        end)
    )
end

local uiBindings = awful.util.table.join(
    awful.button({ }, 1, function ()
        muted = not pa.muteToggle()
        update()
    end),
    awful.button({ }, 4, function () event(pa.volumeUp()) end),
    awful.button({ }, 5, function () event(pa.volumeDown()) end)
)

widgets.main:buttons(uiBindings)
widgets.label:buttons(uiBindings)
widgets.left:buttons(uiBindings)

return volume
