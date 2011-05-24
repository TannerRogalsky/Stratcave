require 'middleclass.init'
Base = class("Base", Entity)

function Base:initialize(b,t)
	Entity:initialize(b)
	self.team = t or "white"
	-- table.insert(self.shapes, love.physics.newRectangleShape(self.body, 0, 0, 50, 50, 0))
	self.shapes = {love.physics.newRectangleShape(self.body, 0, 0, 50, 50, 0)}
	-- for x, shape in ipairs(self.shapes) do
		-- print (x, shape)
	-- end
end

function Base:update(dt)end