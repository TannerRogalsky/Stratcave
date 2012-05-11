local Main = Game:addState('Main')

function Main:enteredState()
  local MAX_BALLS = 100

  self.collider = HC(50, self.on_start_collide, self.on_stop_collide)
  self.player = PlayerCharacter:new({pos = {x = 100, y = 100}})

  self.enemies = {}
  local enemy = Enemy:new({x = 400, y = 300})
  self.enemies[enemy.id] = enemy
  enemy.update = function(self, dt, t)
    self:moveTo(math.sin(2*t) * 120 + love.graphics.getWidth()/2, math.cos(t) * 120 + love.graphics.getHeight()/2)
  end

  enemy = Enemy:new({x = 400, y = 300})
  self.enemies[enemy.id] = enemy
  enemy.update = function(self, dt, t)
    self:moveTo(math.sin(t) * 120 + love.graphics.getWidth()/2, math.cos(2*t) * 120 + love.graphics.getHeight()/2)
  end

  enemy = Enemy:new({x = 400, y = 300})
  self.enemies[enemy.id] = enemy
  enemy.update = function(self, dt, t)
    self:moveTo(math.sin(t) * (110 + math.sin(.01*t) * 110)  + love.graphics.getWidth()/2,
      math.cos(t) * (110 + math.sin(.01*t) * 110)  + love.graphics.getHeight()/2)
  end


  local raw = love.filesystem.read("shader.c"):format(MAX_BALLS)
  self.overlay = love.graphics.newPixelEffect(raw)
  self.bg = love.graphics.newImage("images/game_over.png")

  local positions = self:pack_game_objects()
  self.overlay:send('num_balls', #positions)
  self.overlay:send('balls', unpack(positions))

  local dx = love.mouse.getX() - self.player.pos.x
  local dy = self.player.pos.y - love.mouse.getY()
  self.overlay:send('delta_to_mouse', {dx, dy})
end

function Main:render()
  camera:set()

  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(self.bg, 0, 0)

  game.player:render()

  for id,enemy in pairs(self.enemies) do
    enemy:render()
  end

  love.graphics.setColor(255,255,255,255)
  love.graphics.setPixelEffect(self.overlay)
  love.graphics.rectangle('fill', 0,0,love.graphics.getWidth(), love.graphics.getHeight())
  love.graphics.setPixelEffect()

  camera:unset()

  love.graphics.setColor(0,255,0,255)
  love.graphics.print(love.timer.getFPS(), 2, 2)
end

function Main:update(dt)
  local t = love.timer.getMicroTime( )
  self.collider:update(dt)

  for k,v in pairs(self.player.control_map.keyboard.on_update) do
    if love.keyboard.isDown(k) then v() end
  end

  self.player:update(dt)
  for id,enemy in pairs(self.enemies) do
    enemy:update(dt, t)
  end

  local dx = love.mouse.getX() - self.player.pos.x
  local dy = self.player.pos.y - love.mouse.getY()
  self.overlay:send('delta_to_mouse', {dx, dy})

  self.overlay:send('balls', unpack(self:pack_game_objects()))
end

function Main.keypressed(key, unicode)
  local action = game.player.control_map.keyboard.on_press[key]
  if type(action) == "function" then action() end
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

function Main.on_start_collide(dt, shape_one, shape_two, mtv_x, mtv_y)
  print(tostring(shape_one.parent) .. " is colliding with " .. tostring(shape_two.parent))
end

function Main.on_stop_collide(dt, shape_one, shape_two)
  print(tostring(shape_one.parent) .. " stopped colliding with " .. tostring(shape_two.parent))
end

function Main:pack_game_objects()
  local result = {}
  table.insert(result, {self.player.pos.x, love.graphics.getHeight() - self.player.pos.y})
  for id,enemy in pairs(self.enemies) do
    table.insert(result, {enemy.pos.x, love.graphics.getHeight() - enemy.pos.y})
  end
  return result
end

return Main
