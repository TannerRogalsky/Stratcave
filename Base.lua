Base = class("Base", Entity)
Base.CATEGORYA = 15
Base.CATEGORYB = 16

function Base:initialize(body, team)
	Entity.initialize(self, body, team)
	self:add("rectangle", 0, 0, 50, 75, 0)
	self.health = 5
	self.resources = 0
end

function Base:spawn(world)
	self.resources = self.resources - 50
	local unit = Unit(love.physics.newBody(world, self.body:getX(), self.body:getY(), 0, 0), self.team)
	unit:add("circle", 0, 10, 15)
	unit:add("rectangle", 0, -15, 25, 25, 0)
	-- unit:add("circle", 0, -10, 14)
	unit.body:setMassFromShapes()
	return unit
end

function Base:update(dt)
	self.resources = self.resources + 1
end