Particle = class('Particle')

function Particle:initialize(x, y, radius)
  self.x = x or 0
  self.y = y or 0
  self.original = {x = self.x, y = self.y}
  self.radius = radius or 2
  self.delta = {x = 0, y = 0}
  self.z = 1
  self.angle = math.random(360)
end

function Particle:update(dt)
  self.angle = self.angle + dt
  if self.angle > 360 then
    self.angle = self.angle - 360
  end

  self.orbitalCenter = self.parent or {x = 0, y = 0}

  -- ellipse equation
  local x, y = self.orbitalCenter.x + math.cos(self.angle) * (self.original.x - self.orbitalCenter.x), self.orbitalCenter.y + math.sin(self.angle) * (self.original.y - self.orbitalCenter.y)

  -- are we at the far end of our ellipse? if so, adjust z-index
  if (self.original.x > self.original.y and self.x - x > 0 and self.delta.x < 0) or (self.original.x > self.original.y and self.x - x < 0 and self.delta.x > 0) then
    self.z = -self.z
  elseif (self.original.x < self.original.y and self.y - y > 0 and self.delta.y < 0) or (self.original.x < self.original.y and self.y - y < 0 and self.delta.y > 0) then
    self.z = -self.z
  end

  self.delta.x, self.delta.y = self.x - x, self.y - y
  self.x, self.y = x, y
end

function Particle:draw()
  g.setColor(255,0,0)
  g.circle("fill", self.x, self.y, self.radius, 50)
  -- g.setColor(255,255,255)
  -- g.circle("line", self.x, self.y, self.radius, 50)
end