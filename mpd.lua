local awful       = require('awful')
local wibox       = require('wibox')
local beautiful   = require('beautiful')
local wrapper     = require('widget_wrapper')
local naughty     = require('naughty')
local logger      = require('util.logger').globalLogger
local base        = require('base-config')
local stringUtils = require('util.string')

require('helper')
require('util.mpd')

local mpd   = mpd
local os    = os
local timer = timer
local math  = math

local defaultSongData = {
    Track = '0';
    Date = '';
    Artist = 'No artist';
    Album = 'No album';
    Title = 'No title';
    file = '';
}
local widgets = {}

mpd = mpd.connect()
local currentStatus =  {}

widgets.next      = wibox.widget.imagebox()
widgets.prev      = wibox.widget.imagebox()
widgets.separator = wibox.widget.imagebox()
widgets.toggle    = wibox.widget.imagebox()
widgets.favorites = wibox.widget.imagebox()

widgets.next:set_image(beautiful.widgets.mpd.next)
widgets.prev:set_image(beautiful.widgets.mpd.prev)
widgets.favorites:set_image(beautiful.widgets.mpd.favorites)
widgets.separator:set_image(beautiful.widgets.mpd.separator)

local builder = wrapper.createBuilder()

builder:add(widgets.prev)
builder:add(widgets.toggle)
builder:add(widgets.next)

local favoritesMpdCommand = base.favoritesMpdCommand or '~'
local isFavoritesSupported = favoritesMpdCommand:gmatch('%S+')()
local checkerCommand = 'which ' .. isFavoritesSupported .. ' | grep -v "not found"'
isFavoritesSupported = assert(io.popen(checkerCommand))

if isFavoritesSupported:read() ~= nil then
    builder:add(widgets.favorites)
end

isFavoritesSupported:close()

local function updateStatus(force)
    currentStatus = {
        status = mpd:status();
        lastUpdate = os.time();
    }
    if force then currentStatus.song = mpd:currentsong() end
    if currentStatus.status.state == 'play' then
        widgets.toggle:set_image(beautiful.widgets.mpd.pause)
    else
        widgets.toggle:set_image(beautiful.widgets.mpd.play)
    end
end

local function toggle()
    if currentStatus.status.state == 'play' then
        mpd:pause()
        updateStatus()
    else
        mpd:unpause()
        updateStatus()
    end
end

widgets.toggle:buttons(awful.util.table.join(
    awful.button({ }, 1, toggle)
))

widgets.next:buttons(awful.util.table.join(
    awful.button({}, 1, function ()
        mpd:next()
        updateStatus()
    end)
))

widgets.prev:buttons(awful.util.table.join(
    awful.button({}, 1, function ()
        mpd:previous()
        updateStatus()
    end)
))

local function needsUpdate()
    local timeDiff = os.time() - currentStatus.lastUpdate
    return timeDiff > 2 or not currentStatus.song
end

local function getSongInfo(format, songData)
    return stringUtils.format(format, awful.util.table.join(defaultSongData, songData))
end

local function addToFavorites()
    local handler = io.popen(favoritesMpdCommand)
    if needsUpdate() then
        updateStatus(true)
    end
    naughty.notify({
        text     = stringUtils.htmlSpecialChars(handler:read());
        timeout  = 5;
        position = 'top_right';
        fg       = beautiful.fg_focus;
        bg       = beautiful.bg_focus;
    })
    handler:close()
end

widgets.favorites:buttons(awful.util.table.join(
    awful.button({}, 1, addToFavorites)
))

updateStatus(true)

local tooltip = awful.tooltip({
    objects = getTableParts(widgets).values,
    timer_function = function ()
        if needsUpdate() then
            updateStatus(true)
        end
        return
            "\n " ..
                getSongInfo("{Artist} - {Title} \n [{file}]", currentStatus.song)
            .. " \n"
    end
})

return {
    widget = builder:getWidgets();
    bindKeys = function ()
        globalkeys = awful.util.table.join(
            globalkeys,
            awful.key({}, 'XF86AudioPlay', toggle),
            awful.key({}, 'XF86AudioPrev', function ()
                mpd:previous()
                updateStatus()
            end),
            awful.key({modkey}, 'XF86AudioPlay', addToFavorites),
            awful.key({}, 'XF86AudioNext', function ()
                mpd:next()
                updateStatus()
            end)
        )
    end;
}
