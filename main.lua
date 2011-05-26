function love.load()
	love.graphics.setBackgroundColor(104, 136, 248)
	love.graphics.setMode(1300, 650, false, true, 0)
	
	require 'middleclass.init'
	require "Entity.lua"
	require "Base.lua"
	require "Unit.lua"

	world = love.physics.newWorld(-650, -650, 1300, 650)
	world:setGravity(0, 15)
	world:setMeter(64)
	world:setCallbacks(add, persist, rem, nil)
	
	delta = 0
	
	entities = {} -- table for every body and shape(s)
	removals = {} -- entities to be removed after the world updates
	
	local entity = Entity(love.physics.newBody(world, 650/2, 650, 0, 0))
	entity:add("rectangle", 0, 0, 650, 50, 0)
	table.insert(entities, entity)
	
	entity = Entity(love.physics.newBody(world, 650 + 150, 450, 0, 0))
	entity:add("rectangle", 0, 0, 300, 50, 0)
	table.insert(entities, entity)
	
	entity = Entity(love.physics.newBody(world, 650 + 25, 550, 0, 0))
	entity:add("rectangle", 0, 0, 50, 150, 0)
	table.insert(entities, entity)
	
	-- entity = Entity(love.physics.newBody(world, 650 + 85, 610, 0, 0))
	-- entity:add("rectangle", 0, 0, 150, 50, math.rad(-30))
	-- table.insert(entities, entity)
	
	entity = Entity(love.physics.newBody(world, -25, 550, 0, 0))
	entity:add("rectangle", 0, 0, 50, 150, 0)
	table.insert(entities, entity)
	
	entity = Base(love.physics.newBody(world, 650 + 300 - 25, 450 - 75 + 12.5, 0, 0), "blue")
	table.insert(entities, entity)
	
	entity = Base(love.physics.newBody(world, 25, 650 - 75 + 12.5, 0, 0), "red")
	table.insert(entities, entity)
	
	-- gotta set the userData for the shapes as their tables indices
	for i, entity in ipairs(entities) do
		entity:setData(i)
	end		
	
	for i, entity in ipairs(entities) do
		for j, shape in ipairs(entity.shapes) do
			-- print (entity.class, print (instanceOf(Base, entity)))
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
	if delta >= 3 then		
		-- for i, entity in ipairs(entities) do
			-- if instanceOf(Base, entity) then
				-- table.insert (entities, entity:spawn(world))
			-- end
		-- end
		
		-- for i, entity in ipairs(entities) do
			-- entity:setData(i)
		-- end
		
		delta = 0
	end
end

function love.draw()
	for _,entity in ipairs(entities) do
		entity:draw()
	end
	
	love.graphics.setColor(255,255,255)
	love.graphics.print("FPS: ".. love.timer.getFPS(),25,25)
end

function love.mousepressed(x, y, button)
	if button == 'l' then
		for _, entity in ipairs(entities) do
			if instanceOf(Base, entity) then
				for _,shape in ipairs(entity.shapes) do
					if shape:testPoint(x,y) then
						table.insert (entities, entity:spawn(world))
					end
				end
			end
		end
		
		for i, entity in ipairs(entities) do
			entity:setData(i)
		end
	end
end

-- called when a collision first occurs
function add(a, b, collision)
	-- gets the indices of the two objects colliding
	local i,j = a()
	local x,y = b()
	print(collision:getPosition())
	
	-- gets the actual objects
	local entityA, entityB = entities[i], entities[x]
		
	-- just a bit to test removing bodies. seems to work
	if not entityA.team ~= entityB.team and entityA.team ~= "white" and entityB.team ~= "white" then
		if i < x then 
			x = x - 1 
		end
	
		for _, shape in ipairs(entityA.shapes) do
			shape:setMask(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
		end
		table.remove(entities, i)
		table.insert(removals, entityA)
		
		for _, shape in ipairs(entityB.shapes) do
			shape:setMask(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
		end
		table.remove(entities, x)
		table.insert(removals, entityB)
		
		for i, entity in ipairs(entities) do
			entity:setData(i)
		end
	elseif instanceOf(Unit, entityA) and entityB.body:isStatic() or instanceOf(Unit, entityB) and entityA.body:isStatic() then
		-- makes sure entityA is the Unit. for simplicitie's sake
		if instanceOf(Unit, entityB) then
			local temp = entityA
			entityA = entityB
			entityB = temp
		end
		
		local height, bottom, top = entityA:getHeight()
		local colX, colY = collision:getPosition()
		-- not perfect but separates the object into quarters and if a collision occurs
		-- on the inner two quarters, it behaves like it's run into something and reverses
		if colY < bottom - height / 4 and colY > top + height / 4 then
			entityA:reverse()
		end
	end
end

-- called a collision continues
function persist(a, b, collision)
    
end

-- called when a collision stops
function rem(a, b, collision)
    
end