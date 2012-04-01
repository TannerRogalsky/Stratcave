PlayerCharacter = class('PlayerCharacter', Character)

function PlayerCharacter:initialize(jsonInTableForm)
  Character.initialize(self, jsonInTableForm)
  self.velocity = {x = 0, y = 0}
  self.jump_limit = 1
  self.jumps = 0
  local image = g.newImage("images/player.png")
  local still = g.newImage("images/still.png")
  local jump = g.newImage("images/jump.png")
  self.animations = {
    left = newFlippedAnimation(image, 50, 75, 0.1, 5),
    right = newAnimation(image, 50, 75, 0.1, 5),
    stand_right = newAnimation(still, 50, 75, 1, 1),
    stand_left = newFlippedAnimation(still, 50, 75, 1, 1),
    jump_right = newAnimation(jump, 50, 75, 1, 1),
    jump_left = newFlippedAnimation(jump, 50, 75, 1, 1)
  }  
  self.anim = self.animations.stand_right
end

function PlayerCharacter:update(dt)
  if love.keyboard.isDown('right') then
    self.physics_body.velocity.x = 200
    if self.jumps == 0 then
      self.anim = self.animations.right
    else
      self.anim = self.animations.jump_right
    end
  elseif love.keyboard.isDown('left') then
    self.physics_body.velocity.x = -200
    if self.jumps == 0 then
      self.anim = self.animations.left
    else
      self.anim = self.animations.jump_left
    end
  else
    if self.physics_body.velocity.x > 0 then
      if self.jumps == 0 then
        self.anim = self.animations.stand_right
      else
        self.anim = self.animations.jump_right
      end
    elseif self.physics_body.velocity.x < 0 then
      if self.jumps == 0 then
        self.anim = self.animations.stand_left
      else
        self.anim = self.animations.jump_left
      end
    else
      -- if self.jumps == 0 then
      --   self.anim = self.animations.stand_left
      -- else
      --   self.anim = self.animations.jump_left
      -- end
    end
    self.physics_body.velocity.x = 0
  end

  self.velocity = {x = self.physics_body.velocity.x, y = self.physics_body.velocity.y}
  self.anim:update(dt)
end

function PlayerCharacter:init_physics_body(player_x, player_y)
  player_x, player_y = player_x or 0, player_y or 0
  self.physics_body = game.current_level.current_screen.physics_layer:add_physics_object("rectangle", player_x, player_y, 50, 75)
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
  self.anim:draw(x,y)
end
