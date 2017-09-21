-- Standard awesome library {{{

local awful     = require("awful")
awful.rules     = require("awful.rules")
local wibox     = require("wibox")     -- Widget and layout library
local beautiful = require("beautiful") -- Theme handling library
local layouts   = require("layouts")   -- Layouts list

-- }}}


-- Setting theme {{{

theme = 'pro-v1'
beautiful.init(os.getenv("HOME") .. "/.config/awesome/"..theme.."/theme.lua") -- Setting theme

-- }}}

-- Base configuration {{{

base = require('base-config')

-- Custom widgets {{{

local widgetList = require('widget-list')
local autostart  = require('autostart')

local spr           = require('separator')            --   Widget separators
local run_once      = require('run_once')             --   Autostart library
local widget        = require('widget_wrapper')       --   Widget manipulation library

-- }}}


-- Configuring {{{

-- This is used later as the default terminal and editor to run.
terminal = base.terminal
editor = base.editor
editor_cmd = terminal .. " -e " .. editor
local titlebars_enabled = base.isTitlebarsEnabled

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = base.modkey

awful.util.spawn_with_shell("wmname LG3D") -- Java fix

--- }}}


-- Base system {{{

require('signals')       -- Managing signals
require('error_handler') -- Error handling
require('wallpaper')     -- Wallpaper
require('tags')          -- Tags
require('tasklist')      -- Tasks
require('menu')          -- Menu

-- }}}


-- Panel {{{

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}

local mypromptholder = wibox.widget.background()
mypromptholder:set_widget(wibox.widget.textbox())
mypromptholder:set_bgimage(beautiful.panel:sub(5))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- mypromptbox:set_bg(beautiful.panel)
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
        awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
        awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end))
    )
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 22 })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(spr.lg)
    left_layout:add(mytaglist[s])
    left_layout:add(spr.lg)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(mypromptbox[s])

    for i, customWidget in pairs(widgetList) do
        if customWidget.widget ~= nil then
            widget.wrap(right_layout, customWidget.widget)
        end
        if customWidget == 'systray' and ( s == 1 or not base.onlyOneTray ) then
                right_layout:add(require('separator').lg)
                right_layout:add(require('separator').sm)
                right_layout:add(require('separator').lg)
                right_layout:add(wibox.widget.systray())
        end
    end

    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_bg(beautiful.panel)
    mywibox[s]:set_widget(layout)
end

-- }}}


-- Setting keybindings {{{

clientkeys = require('keys')
require('rules') -- Initializing rules

-- Bind keys for custom widgets {{{

for i, customWidget in pairs(widgetList) do
    if customWidget.bindKey ~= nil then
        customWidget.bindKey()
    elseif customWidget.bindKeys ~= nil then
        customWidget.bindKeys()
    end
end

-- }}}

root.keys(globalkeys) -- Set keys

-- }}}


-- Autostarted applications {{{

for i, app in pairs(autostart) do
    run_once(app)
end

-- }}}
