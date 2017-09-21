local wibox = require('wibox')
local awful = require('awful')

function Runner()
    self:wrapper = wibox({
        type  = "popup_menu",
        ontop = true,
    })
    self:container = wibox.layout.fixed.vertical()
    self:hide = function ()
        self:wrapper.visible = false
    end
    self:show = function ()
        self:wrapper.visible = true
    end
    self:toggle = function ()
        self:wrapper.visible = not self:wrapper.visible
    end
end

return {
    bindKeys = function ()
        globalkeys = awful.util.table.join(
            globalkeys,
            awful.key({ modkey }, 'o', function ()
                runner:hide()
            end)
        )
    end
}
