Hole = class('Hole', Character)

function Hole:initialize(x, y)
  Character.initialize(self, {})
  assert(x and y, "needs moar arguments")
  self.x, self.y = x, y
  self.max_holes = 2

  local image = g.newImage("images/djinn.png")
  self.anim = newAnimation(image, 100, 100, 0.1, 5)

  --sorry, too lazy to pick an image, just skip point 1a and 1b when you use an image file
  --1a. create a blank 32px*32px image data
  local id = love.image.newImageData(32, 32)
  --1b. fill that blank image data
  for x = 0, 31 do
    for y = 0, 31 do
      local gradient = 1 - ((x-15)^2+(y-15)^2)/40
      id:setPixel(x, y, 255, 255, 255, 255*(gradient<0 and 0 or gradient))
    end
  end
  
  --2. create an image from that image data
  local i = love.graphics.newImage(id)
  
  --3a. create a new particle system which uses that image, set the maximum amount of particles (images) that could exist at the same time to 256
  self.p = love.graphics.newParticleSystem(i, 256)
  --3b. set various elements of that particle system, please refer the wiki for complete listing
  self.p:setEmissionRate          (20)
  self.p:setLifetime              (2)
  self.p:setParticleLife          (2)
  self.p:setPosition              (50, 50)
  self.p:setDirection             (0)
  self.p:setSpread                (6.28)
  self.p:setSpeed                 (10, 30)
  self.p:setGravity               (0)
  self.p:setRadialAcceleration    (10)
  self.p:setTangentialAcceleration(0)
  self.p:setSize                  (1)
  self.p:setSizeVariation         (0.5)
  self.p:setRotation              (0)
  self.p:setSpin                  (0)
  self.p:setSpinVariation         (0)
  self.p:setColor                 (0, 170, 255, 255, 0, 170, 255, 50)
  self.p:stop() --this stop is to prevent any glitch that could happen after the particle system is created
end

function Hole:update(dt)
  -- if love.keyboard.isDown('z') then
  --   game.player.physics_body.velocity.x = 0
  -- else
  --   game.player.physics_body.velocity.x = 0
  -- end
  --4a. on each frame, the particle system should be started/burst. try to move this line to love.load instead and see what happens
  self.p:start()
  --4b. on each frame, the particle system needs to update its particles's positions after dt miliseconds
  self.p:update(dt)
end

function Hole:init_physics_body()
  self.physics_body = game.current_level.current_screen.physics_layer:add_physics_object("rectangle", self.x, self.y, 100, 100)
  self.physics_body.render = function(self) end
  game.Collider:setGhost(self.physics_body)
end

function Hole:render()
  local x,y = self.physics_body:bbox()
  g.draw(self.p, x, y)

  g.setColor(255,255,255)
  self.anim:draw(x,y)
end
