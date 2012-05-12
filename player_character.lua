PlayerCharacter = class('PlayerCharacter', Character)

function PlayerCharacter:initialize(jsonInTableForm)
  Character.initialize(self, jsonInTableForm)

  self.pos = jsonInTableForm.pos or {x = 100, y = 100}
  self.speed = 2

  self.control_map = {
    keyboard = {
      on_press = {
        space = function() self:drop_torch() end
      },
      on_release = {

      },
      on_update = {
        w = function() self:move(0, -self.speed) end,
        s = function() self:move(0, self.speed) end,
        a = function() self:move(-self.speed, 0) end,
        d = function() self:move(self.speed, 0) end
      }
    },
    joystick = {
      on_press = {
        [0] = function() end, -- button A
        [1] = function() end, -- button B
        [2] = function() end, -- button X
        [3] = function() end  -- button Y
      },
      on_release = {
      },
      on_update = function()
        self:move(love.joystick.getAxis(0, 0) * 10, love.joystick.getAxis(0,1) * 10)
      end
    }
  }

  self._physics_body = game.collider:addCircle(self.pos.x, self.pos.y, 10)
  self._physics_body.parent = self
  game.collider:addToGroup("player_and_bullets", self._physics_body)

  self.angle = 0
  self.firing = false
  self.time_of_last_fire = 0
  self.gun = Gun:new("machine_gun", 0.1, 20)
  -- self.gun = Gun:new("sniper", 1, 0)

  self.delta_to_mouse = {0,0}
end

function PlayerCharacter:update(dt)
  -- begin handle input
  for key, action in pairs(self.control_map.keyboard.on_update) do
    if love.keyboard.isDown(key) then action() end
  end

  if love.joystick.isOpen(0) then
    self.control_map.joystick.on_update()
  end

  local x, y = love.mouse.getX(), love.mouse.getY()
  self.angle = math.atan2(y - self.pos.y, x - self.pos.x)

  -- end handle input

  local t = love.timer.getMicroTime()
  if self.firing and t - self.time_of_last_fire > self.gun.rate_of_fire then
    self:fire(t)
  end

  local dx = love.mouse.getX() - self.pos.x
  local dy = self.pos.y - love.mouse.getY()
  self.delta_to_mouse = {dx, dy}
end

function PlayerCharacter:render()
  local p_radius = 10
  love.graphics.setColor(255,0,0)
  love.graphics.circle("fill", self.pos.x, self.pos.y, p_radius)

  love.graphics.setColor(0,0,0,255)
  local x = self.pos.x + p_radius * math.cos(self.angle)
  local y = self.pos.y + p_radius * math.sin(self.angle)
  love.graphics.line(self.pos.x, self.pos.y, x, y)
end

function PlayerCharacter:fire(current_time)
  self.time_of_last_fire = current_time

  local spread = math.random(-self.gun.spread, self.gun.spread)
  local angle_of_attack = self.angle + math.rad(spread)
  local x = self.pos.x + 10 * math.cos(angle_of_attack)
  local y = self.pos.y + 10 * math.sin(angle_of_attack)
  local bullet = Bullet:new({x = x, y = y}, angle_of_attack)
  game.bullets[bullet.id] = bullet
  game.collider:addToGroup("player_and_bullets", bullet._physics_body)
end

function PlayerCharacter:drop_torch()
  local pos = {x = self.pos.x, y = self.pos.y}
  local torch = Torch:new(pos, 60)
  game.torches[torch.id] = torch
end
