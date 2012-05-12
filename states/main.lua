local Main = Game:addState('Main')

function Main:enteredState()
  local MAX_BALLS = 50
  local num_enemies = 10
  overlay = true
  spawn_rate = 3

  self.collider = HC(50, self.on_start_collide, self.on_stop_collide)

  self.player = PlayerCharacter:new({pos = {x = g.getWidth() / 2, y = g.getHeight() / 2}})
  self.enemies = {}
  self.num_shooters = 0
  self.bullets = {}
  self.torches = {}
  self.num_torches = 0

  self:create_bounds()

  self.time_since_last_spawn = 0
  self.over = false

  local raw = love.filesystem.read("shader.c"):format(MAX_BALLS)
  self.overlay = love.graphics.newPixelEffect(raw)
  self.bg = love.graphics.newImage("images/game_over.png")

  local positions, radii, deltas = self:pack_game_objects()
  self.overlay:send('num_balls', self.num_torches + self.num_shooters)
  self.overlay:send('num_flashlights', self.num_shooters)
  self.overlay:send('balls', unpack(positions))
  self.overlay:send('radii', unpack(radii))
  self.overlay:send('delta_to_target', unpack(deltas))
end

function Main:render()
  camera:set()

  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(self.bg, 0, 0)

  game.player:render()

  for id,enemy in pairs(self.enemies) do
    enemy:render()
  end

  for id,bullet in pairs(self.bullets) do
    bullet:render()
  end

  if overlay then
    love.graphics.setColor(255,255,255,255)
    love.graphics.setPixelEffect(self.overlay)
    love.graphics.rectangle('fill', 0,0,love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setPixelEffect()
  end

  camera:unset()

  love.graphics.setColor(0,255,0,255)
  love.graphics.print(love.timer.getFPS(), 2, 2)
end

function Main:update(dt)
  self.collider:update(dt)
  if game.over == true then
    return
  end

  for k,v in pairs(self.player.control_map.keyboard.on_update) do
    if love.keyboard.isDown(k) then v() end
  end

  local action = self.player.control_map.joystick.on_update
  if type(action) == 'function' then action() end

  self.player:update(dt)
  for id,enemy in pairs(self.enemies) do
    enemy:update(dt)
  end
  for id,bullet in pairs(self.bullets) do
    bullet:update(dt)
  end

  for id,torch in pairs(self.torches) do
    torch:update(dt)
  end

  local t = love.timer.getMicroTime()
  self:spawn_baddy(t)

  local positions, radii, deltas = self:pack_game_objects()
  -- print(self.num_torches + self.num_shooters, self.num_shooters)
  self.overlay:send('num_balls', self.num_torches + self.num_shooters)
  self.overlay:send('num_flashlights', self.num_shooters)
  self.overlay:send('balls', unpack(positions))
  self.overlay:send('radii', unpack(radii))
  self.overlay:send('delta_to_target', unpack(deltas))
end

function Main.keypressed(key, unicode)
  if key == " " then key = "space" end
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

function Main.mousepressed(x, y, button)
  if button == "l" then
    game.player.firing = true
  end
end

function Main.mousereleased(x, y, button)
  if button == "l" then
    game.player.firing = false
  end
end

function Main:spawn_baddy(current_time)
  if current_time - self.time_since_last_spawn > spawn_rate then

    local x, y = math.random(0, g.getWidth()), math.random(0, g.getHeight())
    if math.random(0,1) == 0 then
      if x > g.getWidth() / 2 then
        x = g.getWidth() + 90
      else
        x = 0 - 90
      end
    else
      if y > g.getHeight() / 2 then
        y = g.getHeight() + 90
      else
        y = 0 - 90
      end
    end

    local enemy_type
    if math.random(1,10) >= 8 then
      enemy_type = Shooter
    else
      enemy_type = Enemy
    end

    local enemy = enemy_type:new({x = x, y = y})
    self.enemies[enemy.id] = enemy

    self.time_since_last_spawn = current_time
  end
end

function Main.on_start_collide(dt, shape_one, shape_two, mtv_x, mtv_y)
  -- print(tostring(shape_one.parent) .. " is colliding with " .. tostring(shape_two.parent))

  if shape_one.bound and instanceOf(Enemy, shape_two.parent) or shape_two.bound and instanceOf(Enemy, shape_one.parent) then
    return
  end

  if shape_one.parent == game.player and shape_two.bound ~= true or shape_two.parent == game.player and shape_one.bound ~= true then
    game:gotoState("GameOver")
    game.over = true
    return
  end

  if instanceOf(Bullet, shape_one.parent) and instanceOf(Enemy, shape_two.parent) then
    game.collider:remove(shape_one, shape_two)
    game.enemies[shape_two.parent.id] = nil
    game.bullets[shape_one.parent.id] = nil
    return
  elseif instanceOf(Bullet, shape_two.parent) and instanceOf(Enemy, shape_one.parent) then
    game.collider:remove(shape_one, shape_two)
    game.enemies[shape_one.parent.id] = nil
    game.bullets[shape_two.parent.id] = nil
    return
  end

  if shape_two.bound then
    if instanceOf(PlayerCharacter, shape_one.parent) then
      shape_one.parent:move(mtv_x, mtv_y)
    elseif instanceOf(Bullet, shape_one.parent) then
      game.collider:remove(shape_one)
      game.bullets[shape_one.parent.id] = nil
    end
    return
  elseif shape_one.bound then
    if instanceOf(PlayerCharacter, shape_two.parent) then
      shape_two.parent:move(mtv_x, mtv_y)
    elseif instanceOf(Bullet, shape_two.parent) then
      game.collider:remove(shape_two)
      game.bullets[shape_two.parent.id] = nil
    end
    return
  end

  shape_one.parent:move(mtv_x/2, mtv_y/2)
  shape_two.parent:move(-mtv_x/2, -mtv_y/2)

  --   local player, other, collision
  --   if shape_one.parent == game.player then
  --     player, other = shape_one, shape_two
  --     collision = {
  --       is_down = mtv_y < 0,
  --       is_up = mtv_y > 0,
  --       is_left = mtv_x > 0,
  --       is_right = mtv_x < 0
  --     }
  --   elseif shape_two.parent == game.player then
  --     player, other = shape_two, shape_one
  --     collision = {
  --       is_down = mtv_y > 0,
  --       is_up = mtv_y < 0,
  --       is_left = mtv_x < 0,
  --       is_right = mtv_x > 0
  --     }
  --   end
end

function Main.on_stop_collide(dt, shape_one, shape_two)
  -- print(tostring(shape_one.parent) .. " stopped colliding with " .. tostring(shape_two.parent))
end

function Main:exitedState()
  self.collider:clear()
  self.collider = nil

  self.player = nil
  self.enemies = nil
  self.bullets = nil
end

function Main:create_bounds()
  local bound = self.collider:addRectangle(-50, -50, g.getWidth() + 100, 50)
  bound.bound = true
  self.collider:setPassive(bound)
  bound.on_collide = boundary_collision
  bound = self.collider:addRectangle(g.getWidth(), -50, 50, g.getHeight() + 100)
  bound.bound = true
  self.collider:setPassive(bound)
  bound.on_collide = boundary_collision
  bound = self.collider:addRectangle(-50, g.getHeight(), g.getWidth() + 100, 50)
  bound.bound = true
  self.collider:setPassive(bound)
  bound.on_collide = boundary_collision
  bound = self.collider:addRectangle(-50, -50, 50, g.getHeight() + 100)
  bound.bound = true
  self.collider:setPassive(bound)
end


function Main:pack_game_objects()
  local positions = {}
  local radii = {}
  local deltas = {}
  table.insert(positions, {self.player.pos.x, love.graphics.getHeight() - self.player.pos.y})
  table.insert(radii, 10)
  table.insert(deltas, self.player.delta_to_mouse)
  self.num_shooters = 1
  for id,enemy in pairs(self.enemies) do
    if instanceOf(Shooter, enemy) then
      table.insert(positions, {enemy.pos.x, love.graphics.getHeight() - enemy.pos.y})
      table.insert(radii, 10)
      table.insert(deltas, enemy.delta_to_player)
      self.num_shooters = self.num_shooters + 1
    end
  end

  self.num_torches = 0
  for id,torch in pairs(self.torches) do
    table.insert(positions, {torch.pos.x, love.graphics.getHeight() - torch.pos.y})
    table.insert(radii, torch.radius)
    self.num_torches = self.num_torches + 1
  end

  -- print(inspect(deltas))
  return positions, radii, deltas
end

return Main
