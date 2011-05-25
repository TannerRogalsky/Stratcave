Entity = class('Entity')

function Entity:initialize(body, team)
	self.body = body
	self.team = team or "white"
	self.shapes = {}
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

function Entity:update(dt)end

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

-- return heigh, bottom of shape, top of shape
function Entity:getHeight()
	local low, high = 10000, -10000
	for _,shape in ipairs(self.shapes) do
		local x1, y1, x2, y2, x3, y3, x4, y4 = shape:getBoundingBox()
		if y1 < low then
			low = y1
		end
		if y4 < low then
			low = y4
		end
		if y2 > high then
			high = y2
		end
		if y3 > high then
			high = y3
		end
	end
	return low - high, low, high
end

function draw_shape(mode, shape)
	if(shape:type() == "PolygonShape") then
		love.graphics.polygon(mode, shape:getPoints())
	elseif(shape:type() == "CircleShape") then
		local x, y = shape:getWorldCenter()
		love.graphics.circle(mode, x, y, shape:getRadius(), 20)
	end
end

function Entity:__tostring()
  return 'Entity: [' .. tostring(self.body) .. ', ' .. tostring(self.team) .. ']'
end