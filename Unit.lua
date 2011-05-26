Unit = class("Unit", Entity)
Unit.CATEGORYA = 13
Unit.CATEGORYB = 14
Unit.MAX_VELX = 35
Unit.MAX_VELY = 50

function Unit:initialize(body, team)
	Entity.initialize(self, body, team)
	self.body:setFixedRotation(true)
	self.health = 2
	if self.team == "red" then
		self.force = 1
	elseif self.team == "blue" then
		self.force = -1
	end
end

function Unit:update(dt)
	self.body:applyForce(self.force, 0, self.body:getPosition())
	
	local velX, velY = self.body:getLinearVelocity()
	if velX > Unit.MAX_VELX then
		velX = Unit.MAX_VELX
	elseif velX < -Unit.MAX_VELX then
		velX = -Unit.MAX_VELX
	elseif velY > Unit.MAX_VELY then
		velY = Unit.MAX_VELY
	elseif velY < -Unit.MAX_VELY then
		velY = -Unit.MAX_VELY
	end
	self.body:setLinearVelocity(velX, velY)
end

function Unit:reverse()
	self.force = -self.force
end