Base = class("Base", Entity)
Base.CATEGORYA = 15
Base.CATEGORYB = 16

function Base:initialize(body, team)
	Entity.initialize(self, body, team)
	self:add("rectangle", 0, 0, 50, 75, 0)	
end

function Base:spawn(world)
	local unit = Unit(love.physics.newBody(world, self.body:getX(), self.body:getY(), 0, 0), self.team)
	unit:add("circle", 0, 0, 15)
	-- unit:add("rectangle", 0, 0, 25, 25, 0)	
	unit.body:setMassFromShapes()
	return unit
end