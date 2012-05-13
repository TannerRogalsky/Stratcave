Boss = class('Boss', Enemy)

function Boss:initialize(pos, radius)
  assert(radius)
  Enemy.initialize(self, pos, radius)

  self.radius = radius
  self.speed = 0.5
  self.time_of_last_fire = 0
  self.health = 10

  self.image = g.newImage('images/boss.png')

  self.delta_to_player = {0,0}

  game.collider:addToGroup("boss_and_boss_bullets", self._physics_body)

  self.guns = {}
  local gun_1 = Gun:new("side_1", 1, 5)
  self.guns[gun_1.id] = gun_1
  gun_1.orientation = 90
  gun_1.time_of_last_fire = 0

  local gun_2 = Gun:new("side_2", 1, 5)
  self.guns[gun_2.id] = gun_2
  gun_2.orientation = -90
  gun_2.time_of_last_fire = 0

  if difficulty == "insane" then
    local gun_3 = Gun:new("main", 0.5, 0)
    self.guns[gun_3.id] = gun_3
    gun_3.orientation = 0
    gun_3.time_of_last_fire = 0
  end
end

function Boss:update(dt)
  local player_x, player_y = game.player.pos.x, game.player.pos.y
  self.angle = math.atan2(player_y - self.pos.y, player_x - self.pos.x)
  local x = self.pos.x + self.speed * math.cos(self.angle)
  local y = self.pos.y + self.speed * math.sin(self.angle)
  self:moveTo(x,y)

  local t = love.timer.getMicroTime()
  for id,gun in pairs(self.guns) do
    -- print(gun.rate_of_fire, t - gun.time_of_last_fire, gun.time_of_last_fire)
    if t - gun.time_of_last_fire > gun.rate_of_fire then
      local spread = math.random(-gun.spread, gun.spread)
      local angle_of_attack = self.angle + math.rad(spread)
      local x = self.pos.x + self.radius * math.cos(angle_of_attack + gun.orientation)
      local y = self.pos.y + self.radius * math.sin(angle_of_attack + gun.orientation)
      local bullet = Bullet:new({x = x, y = y}, angle_of_attack)
      game.bullets[bullet.id] = bullet
      game.collider:addToGroup("boss_and_boss_bullets", bullet._physics_body)
      gun.time_of_last_fire = t
    end
  end

  local dx = player_x - self.pos.x
  local dy = self.pos.y - player_y
  self.delta_to_player = {dx, dy}
end

function Boss:render()
  -- love.graphics.setColor(255,255,0,255/2)
  -- love.graphics.circle("fill", self.pos.x, self.pos.y, self.radius)
  g.setColor(255,255,255,255)
  local x,y = self:bbox()
  g.draw(self.image, x + 40, y + 40, self.angle, 1,1, 160, 160)

  -- love.graphics.setColor(0,0,0,255)
  -- x = self.pos.x + self.radius * math.cos(self.angle)
  -- y = self.pos.y + self.radius * math.sin(self.angle)
  -- love.graphics.line(self.pos.x, self.pos.y, x, y)

  -- x = self.pos.x + self.radius * math.cos(self.angle - 90)
  -- y = self.pos.y + self.radius * math.sin(self.angle - 90)
  -- love.graphics.line(self.pos.x, self.pos.y, x, y)

  -- x = self.pos.x + self.radius * math.cos(self.angle + 90)
  -- y = self.pos.y + self.radius * math.sin(self.angle + 90)
  -- love.graphics.line(self.pos.x, self.pos.y, x, y)
end
