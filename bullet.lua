Bullet = class('Bullet', Base)

function Bullet:initialize(origin, angle)
  Base.initialize(self, {})

  self.pos = origin
  self.pos.incr = function(self, k, v) self[k] = self[k] + v end

  self._physics_body = game.collider:addPoint(self.pos.x, self.pos.y)
  self._physics_body.parent = self
  game.collider:addToGroup("player_and_bullets", self._physics_body)

  self.angle = angle
  self.speed = 3
end

function Bullet:update(dt)
  local x = self.speed * math.cos(self.angle)
  local y = self.speed * math.sin(self.angle)
  self:move(x,y)
end

function Bullet:render()
  local p_radius = 5
  love.graphics.setColor(0,0,255)
  love.graphics.circle("fill", self.pos.x, self.pos.y, p_radius)
end

function Bullet:move(x,y)
  self.pos:incr('x', x)
  self.pos:incr('y', y)
  self._physics_body:move(x,y)
end
