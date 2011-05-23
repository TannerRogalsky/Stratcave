require 'middleclass.init'
Base = class("Base", Entity)

function Base:initialize(b,t)
	self.body = b
	self.team = t
	self.shapes = {love.physics.newRectangleShape(self.body, 0, 0, 50, 50, 0)}
end