love.filesystem.load('requirements.lua')()

-- function love.load()
--   game = Game:new()
-- end

-- function love.update(dt)
--   game:update(dt)
-- end

-- function love.mousepressed(x, y, button)
--   game.mousepressed(x, y, button)
-- end

-- function love.mousereleased(x, y, button)
--   game.mousereleased(x, y, button)
-- end

-- function love.keypressed(key, unicode)
--   game.keypressed(key, unicode)
-- end

-- function love.keyreleased(key, unicode)
--   game.keyreleased(key, unicode)
-- end

-- function love.joystickpressed(joystick, button)
--   game.joystickpressed(joystick, button)
-- end

-- function love.joystickreleased(joystick, button)
--   game.joystickreleased(joystick, button)
-- end

-- function love.draw()
--   game:render()
-- end


-- function love.load()
--   shader = love.graphics.newPixelEffect(love.filesystem.read("test1.c"))
--   shader:send("pi", math.pi)
--   shader:send("width", love.graphics.getWidth())
--   shader:send("height", love.graphics.getHeight())

--   local Camera = require 'lib/camera'
--   camera = Camera:new()
-- end

-- function love.update(dt)
--   -- camera:rotate(dt)
-- end

-- function love.draw()
--   camera:set()
--   love.graphics.setPixelEffect(shader)
--   local x,y = love.mouse.getPosition()
 
--   love.graphics.setColor(255,255,255)
--   love.graphics.rectangle("fill",0,0, love.graphics.getWidth(), love.graphics.getHeight())
--   love.graphics.setPixelEffect()
--   camera:unset()
-- end

function love.load()
  balls = {{400,300}, {400,300}, {400,300}, {400,300}}
  raw = love.filesystem.read("shader.c"):format(#balls)
  effect = love.graphics.newPixelEffect(raw)
  bg = love.graphics.newImage("images/game_over.png")

  effect:send('balls', unpack(balls))

  pos = {x = 100, y = 100}

  dx = love.mouse.getX() - pos.x
  dy = pos.y - love.mouse.getY()
  effect:send('delta_to_mouse', {dx, dy})

  pos.incr = function(self, k, v) self[k] = self[k] + v end 
  keyboard = {
    w = function() pos:incr("y", -5) end,
    s = function() pos:incr("y", 5) end,
    a = function() pos:incr("x", -5) end,
    d = function() pos:incr("x", 5) end
  }
end

function love.draw()
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(bg, 0, 0)

  local p_radius = 10
  love.graphics.setColor(255,0,0)
  love.graphics.circle("fill", pos.x, pos.y, p_radius)

  love.graphics.setColor(0,0,0,255)
  local x, y = love.mouse.getX(), love.mouse.getY()
  local angle = math.atan2(y - pos.y, x - pos.x)
  x = pos.x + p_radius * math.cos(angle)
  y = pos.y + p_radius * math.sin(angle)
  love.graphics.line(pos.x, pos.y, x, y)

  love.graphics.setColor(255,255,255,255)
  love.graphics.setPixelEffect(effect)
  love.graphics.rectangle('fill', 0,0,love.graphics.getWidth(), love.graphics.getHeight())
  love.graphics.setPixelEffect()

  love.graphics.setColor(0,255,0,255)
  love.graphics.print(love.timer.getFPS(), 2, 2)
end

t = 0
function love.update(dt)
  t = t + dt

  for k,v in pairs(keyboard) do
    if love.keyboard.isDown(k) then v() end
  end

  balls[1] = {pos.x, love.graphics.getHeight() - pos.y}
  balls[2] = {math.sin(2*t) * 120 + love.graphics.getWidth()/2, math.cos(t) * 120 + love.graphics.getHeight()/2}
  balls[3] = {math.sin(t) * 120 + love.graphics.getWidth()/2, math.cos(2*t) * 120 + love.graphics.getHeight()/2}
  balls[4] = {
    math.sin(t) * (110 + math.sin(.01*t) * 110)  + love.graphics.getWidth()/2,
    math.cos(t) * (110 + math.sin(.01*t) * 110)  + love.graphics.getHeight()/2,
  }
  dx = love.mouse.getX() - pos.x
  dy = pos.y - love.mouse.getY()
  effect:send('delta_to_mouse', {dx, dy})

  effect:send('balls', unpack(balls))
end
