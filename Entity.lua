Entity = {}

function Entity.new(b)
	return setmetatable({body = b}, Entity)
end

function Entity:add(shape)
	table.insert(self, shape)
end

function Entity:draw()
	for _,shape in ipairs(self) do
		draw_shape("line", shape)
	end
end

function Entity:setData(index)
	for i,shape in ipairs(self) do
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

Entity.__index = Entity -- redirect queries to the Entity table