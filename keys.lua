local awful     = require('awful')
local layouts   = require('layouts')
local menubar   = require('menubar')
local beautiful = require('beautiful')
local cyclefocus = require('cyclefocus')

--menubar.get():set_bg(beautiful.panel)

-- Mouse {{{

root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- }}}


-- Keyboard {{{

globalkeys = awful.util.table.join(
    -- awful.key({ modkey },            "Left",   awful.tag.viewprev       ),
    -- awful.key({ modkey },            "Right",  awful.tag.viewnext       ),
    awful.key({ modkey },            "Escape", awful.tag.history.restore),
    awful.key({ modkey },            "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end
    ),
    awful.key({ modkey }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end
    ),
    awful.key({ modkey },            "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift" },   "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift" },   "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey },            "u", awful.client.urgent.jumpto),
    awful.key({ modkey },            "v", function () awful.util.spawn_with_shell("gvim") end),
    awful.key({ modkey },            "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end
    ),

    -- Standard program
    awful.key({ modkey },            "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"},    "q", awesome.quit),

    awful.key({ modkey },            "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey },            "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift" },   "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift" },   "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey },            "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift" },   "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    awful.key({ }, "#107", function () awful.util.spawn("flameshot gui") end),
    awful.key({ modkey }, "l", function () awful.util.spawn("gnome-screensaver-command -l") end),
 
    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey },            "x",
        function ()
            awful.prompt.run({ prompt = "Run Lua code: " },
            mypromptbox[mouse.screen].widget,
            awful.util.eval, nil,
            awful.util.getdir("cache") .. "/history_eval")
        end
    ),
    -- Menubar
    awful.key({ modkey },            "p", function() menubar.show() end)
)

-- }}}


-- Windows {{{

local wa = screen[mouse.screen].workarea
ww = wa.width
wh = wa.height
ph = 22 -- (panel height)

local clientkeys = awful.util.table.join(
    awful.key({ modkey },            "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift" },   "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey },            "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey },            "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey },            "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end
    ),
    awful.key({ modkey },            "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end
    ),
    -- awful.key({ modkey            }, "Next",     function () awful.client.moveresize( 20,  20, -40, -40) end),
    -- awful.key({ modkey            }, "Prior",    function () awful.client.moveresize(-20, -20,  40,  40) end),
    -- awful.key({ modkey            }, "Down",     function () awful.client.moveresize(  0,  20,   0,   0) end),
    -- awful.key({ modkey            }, "Up",       function () awful.client.moveresize(  0, -20,   0,   0) end),
    -- awful.key({ modkey            }, "Left",     function () awful.client.moveresize(-20,   0,   0,   0) end),
    -- awful.key({ modkey            }, "Right",    function () awful.client.moveresize( 20,   0,   0,   0) end),
    awful.key({ modkey               }, "Left",  function (c) c:geometry( { width = ww / 2, height = wh, x = 0, y = ph } ) end),
    awful.key({ modkey               }, "Right", function (c) c:geometry( { width = ww / 2, height = wh, x = ww / 2, y = ph } ) end),
    awful.key({ modkey               }, "Up",    function (c) c:geometry( { width = ww, height = wh / 2, x = 0, y = ph } ) end),
    awful.key({ modkey               }, "Down",  function (c) c:geometry( { width = ww, height = wh / 2, x = 0, y = wh / 2 + ph } ) end),
    awful.key({ modkey, "Control" }, "Right", function (c) c:geometry( { width = ww / 2, height = wh / 2, x = ww / 2, y = ph } ) end),
    awful.key({ modkey, "Control" }, "Left",  function (c) c:geometry( { width = ww / 2, height = wh / 2, x = ww / 2, y = wh / 2 + ph } ) end),
    awful.key({ modkey, "Control" }, "Up",  function (c) c:geometry( { width = ww / 2, height = wh / 2, x = 0, y = ph } ) end),
    awful.key({ modkey, "Control" }, "Down",   function (c) c:geometry( { width = ww / 2, height = wh / 2, x = 0, y = wh / 2 + ph } ) end),
    awful.key({ modkey, "Control" }, "KP_Begin", function (c) c:geometry( { width = ww, height = wh, x = 0, y = ph } ) end),
    cyclefocus.key({ "Mod1", }, "Tab", 1, {
    -- cycle_filters as a function callback:
    -- cycle_filters = { function (c, source_c) return c.screen == source_c.screen end },

    -- cycle_filters from the default filters:
        cycle_filters = { cyclefocus.filters.same_screen, cyclefocus.filters.common_tag },
        keys = {'Tab', 'ISO_Left_Tab'}  -- default, could be left out
    })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function ()
                local screen = mouse.screen
                local tag = awful.tag.gettags(screen)[i]
                if tag then
                    awful.tag.viewonly(tag)
                end
            end
        ),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function ()
                local screen = mouse.screen
                local tag = awful.tag.gettags(screen)[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end
        ),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = awful.tag.gettags(client.focus.screen)[i]
                    if tag then
                        awful.client.movetotag(tag)
                    end
                end
            end
        ),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = awful.tag.gettags(client.focus.screen)[i]
                    if tag then
                        awful.client.toggletag(tag)
                    end
                end
            end
        )
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- }}}

return clientkeys
