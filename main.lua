function love.load()
	love.graphics.setBackgroundColor(104, 136, 248)
	love.graphics.setMode(1300, 650, false, true, 0)
	
	require "Entity.lua"
	
	-- local s = String:new('hello')
	-- s:print()

	world = love.physics.newWorld(-650, -650, 650, 650)
	world:setGravity(0, 15)
	world:setMeter(64)
	world:setCallbacks(add, persist, rem, result)
	
	delta = 0
	
	entities = {} -- table for every body and shape(s)
	removals = {} -- entities to be removed after the world updates
	
	-- e = Entity:new(love.physics.newBody(world, 100, 100, 0, 0))
	-- print(e.body:getMass())
	-- e:add(love.physics.newCircleShape(e.body, 0, 0, 20))
	-- print(e.body:getMass())
	
	local entity = {}
	entity.body = love.physics.newBody(world, 650/2, 650/2, 0, 0)
	table.insert(entity, love.physics.newCircleShape(entity.body, 0, 0, 20))
	table.insert(entity, love.physics.newRectangleShape(entity.body, 50, 0, 25, 25, 0))
	table.insert(entity, love.physics.newRectangleShape(entity.body, -50, 0, 25, 25, 0))
	entity.body:setMassFromShapes()
	table.insert(entities, entity)
	
	entity = {}
	entity.body = love.physics.newBody(world, 650/2, 650, 0, 0)
	table.insert(entity, love.physics.newRectangleShape(entity.body, 0, -25, 650, 50, math.rad(20)))
	table.insert(entity, love.physics.newRectangleShape(entity.body, 0, 0, 650, 50, 0))
	table.insert(entity, love.physics.newRectangleShape(entity.body, 350, -25, 650, 50, math.rad(-30)))
	table.insert(entities, entity)
	
	entity = {}
	entity.body = love.physics.newBody(world, 650, 650/2, 0, 0)
	table.insert(entity, love.physics.newCircleShape(entity.body, 0, 0, 20))
	entity.body:setMassFromShapes()
	table.insert(entities, entity)
	
	entity = {}
	entity.body = love.physics.newBody(world, 800, 650/2, 0, 0)
	table.insert(entity, love.physics.newCircleShape(entity.body, 0, 0, 20))
	entity.body:setMassFromShapes()
	table.insert(entities, entity)
	
	entity = {}
	entity.body = love.physics.newBody(world, 50, 650/2, 0, 0)
	table.insert(entity, love.physics.newCircleShape(entity.body, 0, 0, 20))
	entity.body:setMassFromShapes()
	table.insert(entities, entity)
	
	setShapeData()
end

function love.update(dt)
	delta = delta + dt
	world:update(dt)
	
	for _, entity in ipairs(removals) do
		entity.body:destroy()
	end
	removals = {}
	
	if delta >= 0.1 then
		entity = {}
		entity.body = love.physics.newBody(world, math.random(50, 800), 650/2 - math.random(0,100), 0, 0)
		table.insert(entity, love.physics.newCircleShape(entity.body, 0, 0, 3))
		entity.body:setMassFromShapes()
		table.insert(entities, entity)
		setShapeData()
		
		delta = 0
	end
end

function love.draw()
	love.graphics.setColor(255, 0, 0)
	for _,entity in ipairs(entities) do
		for _,shape in ipairs(entity) do
			draw_shape("line", shape)
		end
	end
	
	love.graphics.print("FPS: ".. love.timer.getFPS(),25,25)
end

function draw_shape(mode, shape)
	if(shape:type() == "PolygonShape") then
		love.graphics.polygon(mode, shape:getPoints())
	elseif(shape:type() == "CircleShape") then
		local x, y = shape:getWorldCenter()
		love.graphics.circle(mode, x, y, shape:getRadius(), 20)
	end
end

-- Just sets table indices so that they can be referenced in collisions
-- Should be called every time a shape is removed
-- Doesn't necessarily need to be called when a single shape is added because it would
-- be more efficient to just use table.getn(entities) and setData manually
-- In practise, however, this seems very safe and reasonable fast.
function setShapeData()
	for x,entity in ipairs(entities) do
		for y,shape in ipairs(entity) do
			shape:setData(function() return x, y end)
		end
	end
end

function add(a, b, coll)
	local i,j = a()
	local x,y = b()
	
	local entityA, entityB = entities[i], entities[x]
		
	if not entityA.body:isStatic() and not entityB.body:isStatic() then
		if i < x then 
			x = x - 1 
		end
	
		for _, shape in ipairs(entityA) do
			shape:setMask(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
		end
		table.remove(entities, i)
		table.insert(removals, entityA)
		
		for _, shape in ipairs(entityB) do
			shape:setMask(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
		end
		table.remove(entities, x)
		table.insert(removals, entityB)
		
		setShapeData()
	end
end

function persist(a, b, coll)
    
end

function rem(a, b, coll)
    
end

function result(a, b, coll)
    
end