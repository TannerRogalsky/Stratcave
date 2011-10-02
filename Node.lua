Node = class('Node')

function Node:initialize(x, y, radius)
  self.x = x
  self.y = y
  self.radius = radius
  self.particles = {}
end

function Node:addParticle(particle)
  if instanceOf(Particle, particle) then
    table.insert(self.particles, particle)
    particle.parent = self
  end
end

function Node:draw()
  g.setColor(0,0,255)
  g.circle("fill", self.x, self.y, self.radius, 50)
  g.setColor(255,255,255)
  g.circle("line", self.x, self.y, self.radius, 50)
end