require 'middleclass.init'
Entity = class('Entity')

function Entity:initialize(b, t)
	self.body = b
	self.team = t
	self.shapes = {}
end

function Entity:__tostring()
  return 'Entity: [' .. tostring(self.body) .. ', ' .. tostring(self.team) .. ']'
end

function Entity:add(shapeType, ...)
	local shape = nil
	if shapeType == "circle" then
		shape = love.physics.newCircleShape(self.body, ...)
	elseif shapeType == "rectangle" then
		shape = love.physics.newRectangleShape(self.body, ...)
	elseif shapeType == polygon then
		shape = love.physics.newPolygonShape(self.body, ...)
	end
	
	table.insert(self.shapes, shape)
end

function Entity:update(dt) end

function Entity:draw()
	if self.team == "red" then
		love.graphics.setColor(255,0,0)
	elseif self.team == "blue" then
		love.graphics.setColor(0,0,255)
	else
		love.graphics.setColor(255,255,255)
	end
	
	for _,shape in ipairs(self.shapes) do
		draw_shape("line", shape)
	end
end

function Entity:setData(index)
	for i,shape in ipairs(self.shapes) do
		shape:setData(function() return index, i end)
	end
end

function draw_shape(mode, shape)
	if(shape:type() == "PolygonShape") then
		love.graphics.polygon(mode, shape:getPoints())
	elseif(shape:type() == "CircleShape") then
		local x, y = shape:getWorldCenter()
		love.graphics.circle(mode, x, y, shape:getRadius(), 20)
	end
end