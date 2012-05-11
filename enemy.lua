Enemy = class('Enemy', Character)

function Enemy:initialize(pos, radius)
  Character.initialize(self, {})

  self.pos = pos or {x = 0, y = 0}
  self.pos.incr = function(self, k, v) self[k] = self[k] + v end

  self._physics_body = game.collider:addCircle(self.pos.x, self.pos.y, radius or 10)
  self._physics_body.parent = self
  self.angle = 0
end

function Enemy:update(dt)

end

function Enemy:render()
  local p_radius = 10
  love.graphics.setColor(0,255,0)
  love.graphics.circle("fill", self.pos.x, self.pos.y, p_radius)

  love.graphics.setColor(0,0,0,255)
  x = self.pos.x + p_radius * math.cos(self.angle)
  y = self.pos.y + p_radius * math.sin(self.angle)
  love.graphics.line(self.pos.x, self.pos.y, x, y)
end
