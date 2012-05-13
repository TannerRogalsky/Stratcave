local Main = Game:addState('Main')

function Main:enteredState()
  local MAX_BALLS = 50
  overlay = true
  god_mode = false
  spawn_rate = spawn_rate or 3
  max_torches = max_torches or 5
  crawler_ratio = crawler_ratio or 8
  screenshots_enabled = false

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
  self.round_time = 0

  screenshots = {}

  local boss_spawn_rate
  if difficulty == "insane" then
    boss_spawn_rate = 10
  else
    boss_spawn_rate = 60
  end
  cron.every(boss_spawn_rate, function()
    local x,y = self:get_enemy_spawn_position()
    local enemy = Boss:new({x = x, y = y}, 40)
    self.enemies[enemy.id] = enemy
  end)

  if screenshots_enabled then
    cron.every(1, take_screenshot)
  end

  local raw = love.filesystem.read("shaders/overlay.c"):format(MAX_BALLS)
  self.overlay = love.graphics.newPixelEffect(raw)
  self.bg = love.graphics.newImage("images/bg2.png")

  local positions, radii, deltas = self:pack_game_objects()
  self.overlay:send('num_balls', self.num_torches + self.num_shooters)
  self.overlay:send('num_flashlights', self.num_shooters)
  self.overlay:send('balls', unpack(positions))
  self.overlay:send('radii', unpack(radii))
  self.overlay:send('delta_to_target', unpack(deltas))

  raw = love.filesystem.read("shaders/topbar.c"):format(g.getHeight(), g.getWidth(), 30, 200)
  self.topbar = g.newPixelEffect(raw)
end

function take_screenshot()
  table.insert(screenshots, g.newScreenshot())
end

function Main:render()
  camera:set()

  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(self.bg, 0, 0)

  game.player:render()

  for id,enemy in pairs(self.enemies) do
    if instanceOf(Shooter, enemy) then
      love.graphics.setColor(255,255,0)
    else
      love.graphics.setColor(0,255,0)
    end
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

  if game.over then
    g.setColor(0,0,0,255/2)
    g.rectangle('fill', 0,0,love.graphics.getWidth(), love.graphics.getHeight())
  end

  g.setPixelEffect(self.topbar)
  g.setColor(68, 153, 238)
  g.rectangle("fill", 0, 0, g.getWidth(), 70)
  g.setPixelEffect()

  if game.over then
    g.setColor(0,0,0,255)
    local text = "You done went and got yourself killed. Click to continue."
    local offset = self.ui_font:getWidth(text)
    g.print(text, g.getWidth() - offset - 10, 4)
  end

  -- love.graphics.setColor(0,255,0,255)
  -- love.graphics.print(love.timer.getFPS(), 2, 2)
  g.setColor(0,0,0)
  g.print("Score: " .. self.player.score, 2, 4)
  g.print("Time: " .. math.round(self.round_time, 1), 250, 4)
  g.print("Torches available: " .. max_torches - self.num_torches, 400, 4)
end

function Main:update(dt)
  if game.over == true then
    return
  end

  cron.update(dt)
  self.round_time = self.round_time + dt
  self.collider:update(dt)

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
    if game.over then
      game:gotoState("GameOver")
    else
      game.player.firing = true
    end
  end
end

function Main.mousereleased(x, y, button)
  if button == "l" then
    game.player.firing = false
  end
end

function Main:spawn_baddy(current_time)
  if current_time - self.time_since_last_spawn > spawn_rate then

    local x,y = self:get_enemy_spawn_position()

    local enemy_type
    if math.random(1,10) >= crawler_ratio then
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

  if shape_one.bound and instanceOf(Enemy, shape_two.parent) or shape_two.bound and instanceOf(Enemy, shape_one.parent) or game.over then
    return
  end

  if god_mode ~= true then
    if shape_one.parent == game.player and shape_two.bound ~= true or shape_two.parent == game.player and shape_one.bound ~= true then
      game.over = true
      return
    end
  end
  
  if instanceOf(Bullet, shape_one.parent) and instanceOf(Enemy, shape_two.parent) then
    -- collision resolution
    if instanceOf(Boss, shape_two.parent) then
      shape_two.parent.health = shape_two.parent.health - 1
      local dead = shape_two.parent.health <= 0
      if dead then
        game.collider:remove(shape_one, shape_two)
        game.enemies[shape_two.parent.id] = nil
        game.bullets[shape_one.parent.id] = nil
      else
        game.collider:remove(shape_one)
        game.bullets[shape_one.parent.id] = nil
      end
    else
      game.collider:remove(shape_one, shape_two)
      game.enemies[shape_two.parent.id] = nil
      game.bullets[shape_one.parent.id] = nil
    end
    -- scoring calc
    if instanceOf(Shooter, shape_two.parent) then
      game.player.score = game.player.score + 3
    else
      game.player.score = game.player.score + 1
    end
    return
  elseif instanceOf(Bullet, shape_two.parent) and instanceOf(Enemy, shape_one.parent) then
    -- collision resolution
    if instanceOf(Boss, shape_one.parent) then
      shape_one.parent.health = shape_one.parent.health - 1
      local dead = shape_one.parent.health <= 0
      if dead then
        game.collider:remove(shape_one, shape_two)
        game.enemies[shape_one.parent.id] = nil
        game.bullets[shape_two.parent.id] = nil
      else
        game.collider:remove(shape_two)
        game.bullets[shape_two.parent.id] = nil
      end
    else
      game.collider:remove(shape_one, shape_two)
      game.enemies[shape_one.parent.id] = nil
      game.bullets[shape_two.parent.id] = nil
    end
    -- scoring calc
    if instanceOf(Shooter, shape_one.parent) then
      game.player.score = game.player.score + 3
    else
      game.player.score = game.player.score + 1
    end
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

  stats = {
    score = self.player.score,
    round_time = self.round_time
  }
  self.player = nil
  self.enemies = nil
  self.bullets = nil
  cron.reset()
end

function Main:create_bounds()
  local bound = self.collider:addRectangle(-50, -20, g.getWidth() + 100, 50)
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
  local bosses = {}
  table.insert(positions, {self.player.pos.x, love.graphics.getHeight() - self.player.pos.y})
  table.insert(radii, self.player.radius)
  table.insert(deltas, self.player.delta_to_mouse)
  self.num_shooters = 1
  for id,enemy in pairs(self.enemies) do
    if instanceOf(Shooter, enemy) then
      table.insert(positions, {enemy.pos.x, love.graphics.getHeight() - enemy.pos.y})
      table.insert(radii, enemy.radius)
      table.insert(deltas, enemy.delta_to_player)
      self.num_shooters = self.num_shooters + 1
    elseif instanceOf(Boss, enemy) then
      table.insert(bosses, enemy)
    end
  end


  self.num_torches = 0
  for index,boss in ipairs(bosses) do
    table.insert(positions, {boss.pos.x, love.graphics.getHeight() - boss.pos.y})
    table.insert(radii, boss.radius + 10)
    table.insert(deltas, boss.delta_to_player)
    self.num_torches = self.num_torches + 1
  end

  for id,torch in pairs(self.torches) do
    table.insert(positions, {torch.pos.x, love.graphics.getHeight() - torch.pos.y})
    table.insert(radii, torch.radius)
    self.num_torches = self.num_torches + 1
  end

  -- print(inspect(deltas))
  return positions, radii, deltas
end

function Main.get_enemy_spawn_position()
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
  return x, y
end

return Main
