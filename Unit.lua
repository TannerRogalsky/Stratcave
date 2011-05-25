require 'middleclass.init'
Unit = class("Unit", Entity)

function Unit:initialize(body, team)
	Entity.initialize(self, body, team)
	
	if self.team == "red" then
		self.force = 1
	elseif self.team == "blue" then
		self.force = -1
	end
end

function Unit:update(dt)
	self.body:applyForce(self.force, 0, 0, 0)
end