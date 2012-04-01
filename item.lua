Item = class('Item', Base)

function Item:initialize(jsonInTableForm)
  Base.initialize(self)

  -- dump the json data into the new object
  for k,v in pairs(jsonInTableForm) do
    self[k] = v
  end

  -- finalize some values with some defaults
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
  self.p:setPosition              (25, 25)
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
  self.p:setColor                 (255, 255, 0, 255, 255, 255, 0, 50)
  self.p:stop() --this stop is to prevent any glitch that could happen after the particle system is created
end

function Item:update(dt)
  -- self.physics_body:apply_gravity(dt)
  -- self.physics_body.velocity.y = math.clamp(-200, self.physics_body.velocity.y, 200)
  -- self.physics_body:move(self.physics_body.velocity.x * dt, self.physics_body.velocity.y * dt)
end

function Item:render()
end

function Item:init_physics_body(x,y)
  self.x, self.y = x or self.x or 0, y or self.y or 0
  self.physics_body = game.current_level.current_screen.physics_layer:add_physics_object("rectangle", self.x, self.y, 50, 50)
  game.Collider:setPassive(self.physics_body)
  self.physics_body.parent = self
  return self.physics_body
end

function Item:on_power_up_collide(...)
  game.player.jump_limit = game.player.jump_limit + 1
  if game.player.jump_limit > 2 then game.player.jump_limit = 2 end
  self:on_collide(...)
end

function Item:on_lamp_collide(...)
  game.player.score = game.player.score + 100
  self:on_collide(...)
end

function Item:on_collide(dt, shape_one, shape_two, mtv_x, mtv_y)
  game.Collider:setGhost(self.physics_body)
  self.physics_body.render = function(self) end
end
