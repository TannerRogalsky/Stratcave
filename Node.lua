Node = class('Node', Entity)

function Node:initialize(x, y, radius)
  Entity.initialize(self)
  self.x = x
  self.y = y
  self.radius = radius
  self.sphereOfInfluence = self.radius * 2
  self.particles = {}
end

function Node:addParticle(particle)
  if instanceOf(Particle, particle) then
    table.insert(self.particles, particle)
    particle.indexInParent = #self.particles
    particle.parent = self
  end
end

function Node:removeParticle(particleToRemove)
  if particleToRemove.indexInParent then
    table.remove(self.particles, particleToRemove.indexInParent)
  end
end

function Node:draw()
  g.setColor(0,0,255)
  g.circle("fill", self.x, self.y, self.radius, 50)
  g.setColor(255,255,255)
  g.circle("line", self.x, self.y, self.radius, 50)
  g.setLineStipple(0xFF)
  g.setColor(255,255,255,100)
  g.circle("line", self.x, self.y, self.sphereOfInfluence, 50)
  g.setLineStipple(0xFFFFFF)
end
