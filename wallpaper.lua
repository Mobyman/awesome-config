local beautiful = require('beautiful')
local gears     = require('gears')

if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.tiled(beautiful.wallpaper, s)
    end
end