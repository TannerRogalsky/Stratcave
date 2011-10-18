Particle = class('Particle')

function Particle:initialize(x, y, parent, radius)
  self.x = x or 0
  self.y = y or 0
  self.original = {x = self.x, y = self.y}
  self.radius = radius or 2
  self.delta = {x = 0, y = 0}
  self.angle = math.random(360)
  self.z = math.random(2) == 2 and 1 or -1 -- fakin' dat ternary

  if parent and instanceOf(Node, parent) then
    parent:addParticle(self)
  end
end

function Particle:update(dt)
  self.angle = self.angle + dt

  if self.parent then
    -- ellipse equation
    local x, y = self.parent.x + math.cos(self.angle) * (self.original.x - self.parent.x), self.parent.y + math.sin(self.angle * 0.9) * (self.original.y - self.parent.y)

    -- are we at the far end of our ellipse? if so, adjust z-index
    if (self.original.x > self.original.y and self.x - x > 0 and self.delta.x < 0) or 
       (self.original.x > self.original.y and self.x - x < 0 and self.delta.x > 0) or 
       (self.original.x < self.original.y and self.y - y > 0 and self.delta.y < 0) or 
       (self.original.x < self.original.y and self.y - y < 0 and self.delta.y > 0) then
        self.z = -self.z
    end

    self.delta.x, self.delta.y = self.x - x, self.y - y
    self.x, self.y = x, y
  end
end

function Particle:draw()
  g.setColor(255,0,0)
  g.circle("fill", self.x, self.y, self.radius, 50)
  -- g.setColor(255,255,255)
  -- g.circle("line", self.x, self.y, self.radius, 50)
end
