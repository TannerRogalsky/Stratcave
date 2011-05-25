require 'middleclass.init'
Base = class("Base", Entity)

function Base:initialize(body, team)
	Entity.initialize(self, body, team)
	self.shapes = {love.physics.newRectangleShape(self.body, 0, 0, 50, 50, 0)}
end

function Base:update(dt)end