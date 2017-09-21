local beautiful = require('beautiful')
local spr       = require('separator')
local wibox     = require('wibox')
local builder = {}
local wrapper = {}
require('helper')

local rightBorder = wibox.widget.imagebox()
rightBorder:set_image(beautiful.widgets.display.right)

function builder:add ( widget )
	self.widgets[#self.widgets+1] = widget
end

function builder:finish ()
	self:add(rightBorder)
end

function builder:new()
	local newBuilder = { widgets = {} }
	setmetatable(newBuilder, builder)
	self.__index = self
	return newBuilder
end

function builder:getWidgets ()
	return self.widgets
end

wrapper.createBuilder = function ()
	return builder:new()
end

wrapper.wrap = function ( layout, contents )
	layout:add(spr.sm)
	layout:add(spr.lg)

	for _, widget in pairs(contents) do
		layout:add(widget)
	end

	layout:add(spr.lg)
end

wrapper.separator = function (layout)
    layout:add(spr.lg)
    layout:add(spr.sm)
    layout:add(spr.lg)
end

return wrapper