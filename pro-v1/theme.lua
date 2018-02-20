
                -- [    Pro-v1 theme for Awesome 3.5.5    ] --
                -- [            author: gyrfalco          ] --
                -- [    http://github.com/gyrfalco/pro    ] --

                -- // got the idea from Holo theme by Luke Bonham (https://github.com/copycat-killer)



-- patch for taglist: https://github.com/awesomeWM/awesome/pull/39
-- patch for transparent / w.image tray: https://awesome.naquadah.org/bugs/index.php?do=details&task_id=1198&project=1&pagenum=3

require('helper')
local folder = debug.getinfo(1).source:gsub('\@', '')
folder = '/'..table.concat(table_slice(folder:split('[\\/]+'), 1, -2), '/')

local theme     = {}
theme.widgets   = {}
theme.icons     = folder .. "/icons/"
theme.wallpaper = folder .. "/wallpapers/v2.png"
theme.panel     = "png:" .. theme.icons .. "/panel/panel.png"
theme.font      = "GohuFont 11"

theme.fg_normal  = "#888888"
theme.fg_focus   = "#e4e4e4"
theme.fg_urgent  = "#CC9393"

theme.bg_normal  = "#3F3F3F"
theme.bg_focus   = "#5a5a5a"
theme.bg_urgent  = "#3F3F3F"
--theme.bg_systray = "#2E2D2B"
theme.bg_systray = "#000000" .. 0.01
--theme.clockgf    = "#d5d5c3"

-- | Tooltip | --

theme.tooltip_bg_color = "png:" .. theme.icons .. "/panel/tooltip/bg.png"
theme.tooltip_fg_color = theme.fg_normal
theme.tooltip_border_color = "#141414"
theme.tooltip_border_width = 1

-- | Borders | --

theme.border_width  = 1
theme.border_normal = "#3c3c3c"
theme.border_focus  = "#2c2c2c"
theme.border_marked = "#4c3c3c"

-- | Menu | --

theme.menu_height   = 16
theme.menu_width    = 160

-- | Layout | --

theme.layout_floating   = theme.icons .. "/panel/layouts/floating.png"
theme.layout_tile       = theme.icons .. "/panel/layouts/tile.png"
theme.layout_tileleft   = theme.icons .. "/panel/layouts/tileleft.png"
theme.layout_tilebottom = theme.icons .. "/panel/layouts/tilebottom.png"
theme.layout_tiletop    = theme.icons .. "/panel/layouts/tiletop.png"

-- | Taglist | --

theme.taglist_bg_empty    = "png:" .. theme.icons .. "/panel/taglist/empty.png"
theme.taglist_bg_occupied = "png:" .. theme.icons .. "/panel/taglist/occupied.png"
theme.taglist_bg_urgent   = "png:" .. theme.icons .. "/panel/taglist/urgent.png"
theme.taglist_bg_focus    = "png:" .. theme.icons .. "/panel/taglist/focus.png"

-- | Tasklist | --

theme.tasklist_font       = "Ubuntu Condensed 10"

theme.tasklist_bg_normal = "png:" .. theme.icons .. "panel/tasklist/normal.png"
theme.tasklist_bg_focus  = "png:" .. theme.icons .. "panel/tasklist/focus.png"
theme.tasklist_bg_urgent = "png:" .. theme.icons .. "panel/tasklist/urgent.png"

theme.tasklist_fg_focus  = "#DDDDDD"
theme.tasklist_fg_urgent = "#EEEEEE"
theme.tasklist_fg_normal = "#AAAAAA"

theme.tasklist_disable_icon         = true
theme.tasklist_floating             = ""
theme.tasklist_sticky               = ""
theme.tasklist_ontop                = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical   = ""

-- | Widget | --

theme.widgets.display = {}
theme.widgets.display.bg     = theme.icons .. "/panel/widgets/widget_display.png"
theme.widgets.display.right  = theme.icons .. "/panel/widgets/widget_display_r.png"
theme.widgets.display.center = theme.icons .. "/panel/widgets/widget_display_c.png"
theme.widgets.display.left   = theme.icons .. "/panel/widgets/widget_display_l.png"

-- | Keyboard widget | --

theme.widgets.keyboard = {}
theme.widgets.keyboard.en = theme.icons .. "/panel/widgets/keyboard/en_GB.png"
theme.widgets.keyboard.ru = theme.icons .. "/panel/widgets/keyboard/ru_RU.png"

-- | Touchpad widget | --

theme.widgets.touchpad = {}
theme.widgets.touchpad.off = theme.icons .. "/panel/widgets/touchpad/off.png"
theme.widgets.touchpad.on  = theme.icons .. "/panel/widgets/touchpad/on.png"

-- | Battery widget | --

theme.widgets.battery = {}
theme.widgets.battery.critical = theme.icons .. "/panel/widgets/battery/critical.png"
theme.widgets.battery.low      = theme.icons .. "/panel/widgets/battery/low.png"
theme.widgets.battery.middle   = theme.icons .. "/panel/widgets/battery/middle.png"
theme.widgets.battery.full     = theme.icons .. "/panel/widgets/battery/full.png"
theme.widgets.battery.charging = theme.icons .. "/panel/widgets/battery/charging.png"

-- | Volume widget | --

theme.widgets.volume = {}
theme.widgets.volume.low    = theme.icons .. '/panel/widgets/volume/low.png'
theme.widgets.volume.normal = theme.icons .. '/panel/widgets/volume/normal.png'
theme.widgets.volume.high   = theme.icons .. '/panel/widgets/volume/high.png'
theme.widgets.volume.mute   = theme.icons .. '/panel/widgets/volume/mute.png'

-- | MPD | --

theme.widgets.mpd = {}
theme.widgets.mpd.prev      = theme.icons .. '/panel/widgets/mpd/mpd_prev.png'
theme.widgets.mpd.next      = theme.icons .. '/panel/widgets/mpd/mpd_next.png'
theme.widgets.mpd.pause     = theme.icons .. '/panel/widgets/mpd/mpd_pause.png'
theme.widgets.mpd.play      = theme.icons .. '/panel/widgets/mpd/mpd_play.png'
theme.widgets.mpd.start     = theme.icons .. '/panel/widgets/mpd/mpd_sepl.png'
theme.widgets.mpd.separator = theme.icons .. '/panel/widgets/mpd/mpd_spr.png'
theme.widgets.mpd.back      = theme.icons .. '/panel/widgets/mpd/mpd_sepr.png'
theme.widgets.mpd.favorites = theme.icons .. '/panel/widgets/mpd/mpd_favorites.png'

-- | Backlight widget | --

theme.widgets.backlight = {}
theme.widgets.backlight.low    = theme.icons .. '/panel/widgets/backlight/low.png'
theme.widgets.backlight.medium = theme.icons .. '/panel/widgets/backlight/medium.png'
theme.widgets.backlight.high   = theme.icons .. '/panel/widgets/backlight/high.png'

-- | Separators | --

theme.separator = {}
theme.separator.sprtr            = theme.icons .. "/panel/separators/sprtr.png"
theme.separator.sm           = theme.icons .. "/panel/separators/spr.png"
theme.separator.md           = theme.icons .. "/panel/separators/spr4px.png"
theme.separator.lg           = theme.icons .. "/panel/separators/spr5px.png"

-- | Clock / Calendar | --

theme.widgets.clock     = theme.icons .. "/panel/widgets/widget_clock.png"
theme.widgets.calendar  = theme.icons .. "/panel/widgets/widget_cal.png"

-- | CPU / TMP | --

theme.widget_cpu       = theme.icons .. "/panel/widgets/widget_cpu.png"
-- theme.widget_tmp       = theme.icons .. "/panel/widgets/widget_tmp.png"

-- | MEM | --

theme.widget_mem       = theme.icons .. "/panel/widgets/widget_mem.png"

-- | FS | --

theme.widget_fs        = theme.icons .. "/panel/widgets/widget_fs.png"

-- | Mail | --

theme.widget_mail        = theme.icons .. "/panel/widgets/widget_mail.png"

-- | NET | --

theme.widget_netdl        = theme.icons .. "/panel/widgets/widget_netdl.png"
theme.widget_netul        = theme.icons .. "/panel/widgets/widget_netul.png"

-- | Misc | --

theme.menu_submenu_icon = theme.icons .. "submenu.png"

return theme

