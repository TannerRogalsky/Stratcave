Particle = class('Particle')

function Particle:initialize(x, y, radius, velx, vely)
  self.x = x or 0
  self.y = y or 0
  self.originalx = self.x
  self.originaly = self.y
  self.radius = radius or 10
  self.velx = velx or 10
  self.vely = vely or 10
  self.deltax = 0
  self.deltay = 0
  self.angle = 0
end

function Particle:update(dt)
  self.angle = self.angle + dt

  if self.parent == nil then
    self.parent = {}
    self.parent.x, self.parent.y = 0, 0
  end

  local x, y = self.parent.x + math.cos(self.angle) * (self.originalx - self.parent.x), self.parent.y + math.sin(self.angle) * (self.originaly - self.parent.y)
  self.deltax, self.deltay = self.x - x, self.y - y
  self.x, self.y = x, y
end

function Particle:draw()
  g.setColor(255,0,0)
  g.circle("fill", self.x, self.y, self.radius, 50)
  g.setColor(255,255,255)
  g.circle("line", self.x, self.y, self.radius, 50)
end