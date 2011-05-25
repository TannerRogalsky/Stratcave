Base = class("Base", Entity)
Base.CATEGORY = 16

function Base:initialize(body, team)
	Entity.initialize(self, body, team)
	self.shapes = {love.physics.newRectangleShape(self.body, 0, 0, 50, 75, 0)}
	self.shapes[1]:setCategory(Base.CATEGORY)
end

function Base:spawn(world)
	local x = self.body:getX()
	if self.team == "red" then
		x = x + 50
	elseif self.team == "blue" then
		x = x - 50
	end
	local unit = Unit(love.physics.newBody(world, self.body:getX(), self.body:getY(), 0, 0), self.team)
	unit:add("circle", 0, 0, 15)
	unit.shapes[1]:setMask(Base.CATEGORY)
	unit.body:setMassFromShapes()
	return unit
end