function love.load()
	love.graphics.setBackgroundColor(104, 136, 248)
	love.graphics.setMode(1300, 650, false, true, 0)
	
	
	require "Entity.lua"
	require "Base.lua"
	require "Unit.lua"

	world = love.physics.newWorld(-650, -650, 650, 650)
	world:setGravity(0, 15)
	world:setMeter(64)
	world:setCallbacks(add, persist, rem, nil)
	
	delta = 0
	
	entities = {} -- table for every body and shape(s)
	removals = {} -- entities to be removed after the world updates
	
	local entity = Entity(love.physics.newBody(world, 650/2, 650, 0, 0))
	entity:add("rectangle", 0, 0, 650, 50, 0)
	table.insert(entities, entity)
	
	entity = Base(love.physics.newBody(world, 650/3, 650 - 50, 0, 0), "blue")
	table.insert(entities, entity)
	
	entity = Base(love.physics.newBody(world, 650/2, 650 - 50, 0, 0), "red")
	table.insert(entities, entity)
	
	entity = Unit(love.physics.newBody(world, 650/2, 650/2, 0, 0), "red", "test")
	entity:add("circle", 0, 0, 15)
	entity.body:setMassFromShapes()
	table.insert(entities, entity)
	
	-- gotta set the userData for the shapes as their tables indices
	for i, entity in ipairs(entities) do
		entity:setData(i)
	end		
	
	for i, entity in ipairs(entities) do
		for j, shape in ipairs(entity.shapes) do
			print (entity.class, shape:getData()(), entity.body:isStatic())
		end
	end
end

function love.update(dt)
	delta = delta + dt
	world:update(dt)
	
	-- safe (semi? :/) workaround for Love2d body removal problem
	for _, entity in ipairs(removals) do
		entity.body:destroy()
	end
	removals = {}
	
	-- performs any specified updates for the indidual bodies
	for _, entity in ipairs(entities) do
		entity:update(dt)
	end	
	
	-- spawns random objects. for testing
	-- if delta >= 0.1 then
		-- local entity = Unit(love.physics.newBody(world, math.random(50, 650), 650/2 - math.random(0,100), 0, 0), "blue")
		-- entity:add("circle", 0, 0, 3)
		-- entity.body:setMassFromShapes()
		-- table.insert(entities, entity)
		
		-- for i, entity in ipairs(entities) do
			-- entity:setData(i)
		-- end
		
		-- delta = 0
	-- end
end

function love.draw()
	love.graphics.setColor(255, 0, 0)
	for _,entity in ipairs(entities) do
		entity:draw()
	end
	
	love.graphics.setColor(255,255,255)
	love.graphics.print("FPS: ".. love.timer.getFPS(),25,25)
end

-- Just sets table indices so that they can be referenced in collisions
-- Should be called every time a shape is removed
-- Doesn't necessarily need to be called when a single shape is added because it would
-- be more efficient to just use table.getn(entities) and setData manually
-- In practise, however, this seems very safe and reasonable fast.
function setShapeData()
	-- for x,entity in ipairs(entities) do
		-- for y,shape in ipairs(entity) do
			-- shape:setData(function() return x, y end)
		-- end
	-- end
end

-- called when a collision first occurs
function add(a, b, coll)
	-- gets the indices of the two objects colliding
	local i,j = a()
	local x,y = b()
	
	-- gets the actual objects
	local entityA, entityB = entities[i], entities[x]
		
	-- just a bit to test removing bodies. seems to work
	-- if not entityA.body:isStatic() and not entityB.body:isStatic() then
		-- if i < x then 
			-- x = x - 1 
		-- end
	
		-- for _, shape in ipairs(entityA.shapes) do
			-- shape:setMask(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
		-- end
		-- table.remove(entities, i)
		-- table.insert(removals, entityA)
		
		-- for _, shape in ipairs(entityB.shapes) do
			-- shape:setMask(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
		-- end
		-- table.remove(entities, x)
		-- table.insert(removals, entityB)
		
		-- for i, entity in ipairs(entities) do
			-- entity:setData(i)
		-- end
	-- end
end

-- called a collision continues
function persist(a, b, coll)
    
end

-- called when a collision stops
function rem(a, b, coll)
    
end