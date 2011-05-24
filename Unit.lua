require 'middleclass.init'
Unit = class("Unit", Entity)

function Unit:initialize(b,t)
	Entity:initialize(b)
	self.team = t or "white"
	-- table.insert(self.shapes, love.physics.newRectangleShape(self.body, 0, 0, 50, 50, 0))
	-- self.shapes = {love.physics.newRectangleShape(self.body, 0, 0, 50, 50, 0)}
	-- for x, shape in ipairs(self.shapes) do
		-- print (x, shape)
	-- end
end

function Unit:update(dt)end



-- if self.team == "red" then
		-- self.force = 1
	-- elseif self.team == "blue" then
		-- self.force = -1
	-- end