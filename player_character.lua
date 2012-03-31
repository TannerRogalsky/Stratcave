PlayerCharacter = class('PlayerCharacter', Character)

function PlayerCharacter:initialize(jsonInTableForm)
  Character.initialize(self, jsonInTableForm)
  self.velocity = {x = 0, y = 0}
  self.jump_limit = 1
  self.jumps = 0
  local image = g.newImage("images/red.png")
  self.animations = {
    left = newFlippedAnimation(image, 130, 130, 0.05, 18),
    right = newAnimation(image, 130, 130, 0.05, 18),
    stand = newAnimation(image, 130, 130, 1, 1)
  }  
  self.anim = self.animations.stand
end

function PlayerCharacter:update(dt)
  if love.keyboard.isDown('right') then
    self.physics_body.velocity.x = 200
    self.anim = self.animations.right
  elseif love.keyboard.isDown('left') then
    self.physics_body.velocity.x = -200
    self.anim = self.animations.left
  else
    self.physics_body.velocity.x = 0
    self.anim = self.animations.stand
  end

  self.velocity = {x = self.physics_body.velocity.x, y = self.physics_body.velocity.y}
  self.anim:update(dt)
end

function PlayerCharacter:init_physics_body(player_x, player_y)
  player_x, player_y = player_x or 0, player_y or 0
  self.physics_body = game.current_level.current_screen.physics_layer:add_physics_object("rectangle", player_x, player_y, 50, 100)
  self.physics_body.velocity = self.velocity
  self.physics_body.update = function(self, dt)
    self:apply_gravity(dt)
    self.velocity.y = math.clamp(-400, self.velocity.y, 600)
    self:move(self.velocity.x * dt, self.velocity.y * dt)
  end
  self.physics_body.render = function(self) end
end

function PlayerCharacter:render()
  g.setColor(255,255,255)
  local x,y = self.physics_body:bbox()
  self.anim:draw(x - 40,y - 30)
end
