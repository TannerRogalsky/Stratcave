local Main = Game:addState('Main')

function Main:enteredState()
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

function Main:render()
  camera:set()

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

  camera:unset()

  love.graphics.setColor(0,255,0,255)
  love.graphics.print(love.timer.getFPS(), 2, 2)
end

t = 0
function Main:update(dt)
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

function Main.keypressed(key, unicode)
  -- local action = game.player.control_map.keyboard.on_press[key]
  -- if type(action) == "function" then action() end
end

function Main.joystickpressed(joystick, button)
  local action = game.player.control_map.joystick.on_press[button]
  if type(action) == "function" then action() end
end

function Main.joystickreleased(joystick, button)
  local action = game.player.control_map.joystick.on_release[button]
  if type(action) == "function" then action() end
end

function Main:exitedState()
end

return Main
