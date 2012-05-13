Shooter = class('Shooter', Enemy)

function Shooter:initialize(pos, radius)
  Enemy.initialize(self, pos, radius)

  self.speed = 1
  self.time_of_last_fire = 0

  self.delta_to_player = {0,0}
end

function Shooter:update(dt)
  local player_x, player_y = game.player.pos.x, game.player.pos.y
  self.angle = math.atan2(player_y - self.pos.y, player_x - self.pos.x)
  local x = self.pos.x + self.speed * math.cos(self.angle)
  local y = self.pos.y + self.speed * math.sin(self.angle)
  self:moveTo(x,y)

  local t = love.timer.getMicroTime()
  if t - self.time_of_last_fire > 0.8 then
    self:fire(t)
  end

  local dx = player_x - self.pos.x
  local dy = self.pos.y - player_y
  self.delta_to_player = {dx, dy}
end

-- function Shooter:render()
--   love.graphics.setColor(255,255,0)
--   love.graphics.circle("fill", self.pos.x, self.pos.y, self.radius)

--   love.graphics.setColor(0,0,0,255)
--   x = self.pos.x + self.radius * math.cos(self.angle)
--   y = self.pos.y + self.radius * math.sin(self.angle)
--   love.graphics.line(self.pos.x, self.pos.y, x, y)
-- end

function Shooter:fire(current_time)
  self.time_of_last_fire = current_time

  local x = self.pos.x + self.radius * math.cos(self.angle)
  local y = self.pos.y + self.radius * math.sin(self.angle)
  local bullet = Bullet:new({x = x, y = y}, self.angle)
  game.bullets[bullet.id] = bullet
end
