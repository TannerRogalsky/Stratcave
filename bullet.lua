Bullet = class('Bullet', Base)

function Bullet:initialize(origin, angle)
  Base.initialize(self, {})

  self.pos = origin
  self.pos.incr = function(self, k, v) self[k] = self[k] + v end

  self._physics_body = game.collider:addPoint(self.pos.x, self.pos.y)
  self._physics_body.parent = self

  self.angle = angle
  self.speed = 10

  local id = love.image.newImageData(32, 32)
  --1b. fill that blank image data
  for x = 0, 31 do
    for y = 0, 31 do
      local gradient = 1 - ((x-15)^2+(y-15)^2)/40
      id:setPixel(x, y, 255, 255, 255, 255*(gradient<0 and 0 or gradient))
    end
  end

  --2. create an image from that image data
  local i = g.newImage(id)

  --3a. create a new particle system which uses that image, set the maximum amount of particles (images) that could exist at the same time to 256
  self.p = g.newParticleSystem(i, 256)
  --3b. set various elements of that particle system, please refer the wiki for complete listing
  self.p:setEmissionRate          (20)
  self.p:setLifetime              (2)
  self.p:setParticleLife          (2)
  self.p:setPosition              (0, 0)
  self.p:setDirection             (self.angle)
  self.p:setSpread                (math.rad(45))
  self.p:setSpeed                 (-50, -60)
  self.p:setGravity               (0)
  self.p:setRadialAcceleration    (10)
  self.p:setTangentialAcceleration(0)
  self.p:setSizes                 (1)
  self.p:setSizeVariation         (0.5)
  self.p:setRotation              (0)
  self.p:setSpin                  (0)
  self.p:setSpinVariation         (0)
  self.p:setColors                (255, 0, 0, 255,
                                  255, 0, 255, 255 / 2,
                                  0, 0, 155, 0)
  self.p:stop() --this stop is to prevent any glitch that could happen after the particle system is created
end

function Bullet:update(dt)
  local x = self.speed * math.cos(self.angle)
  local y = self.speed * math.sin(self.angle)
  self:move(x,y)

  --4a. on each frame, the particle system should be started/burst. try to move this line to love.load instead and see what happens
  self.p:start()
  --4b. on each frame, the particle system needs to update its particles's positions after dt miliseconds
  self.p:update(dt)
end

function Bullet:render()
  g.draw(self.p, self.pos.x, self.pos.y)

  local p_radius = 2
  g.setColor(255,0,0)
  g.circle("fill", self.pos.x, self.pos.y, p_radius)
end

function Bullet:move(x,y)
  self.pos:incr('x', x)
  self.pos:incr('y', y)
  self._physics_body:move(x,y)
end
