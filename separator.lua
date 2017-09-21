local beautiful = require('beautiful')
local wibox     = require('wibox')

local separator = {}

separator.sm = wibox.widget.imagebox()
separator.md = wibox.widget.imagebox()
separator.lg = wibox.widget.imagebox()

separator.sm:set_image(beautiful.separator.sm)
separator.md:set_image(beautiful.separator.md)
separator.lg:set_image(beautiful.separator.lg)

return separator