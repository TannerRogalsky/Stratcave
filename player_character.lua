PlayerCharacter = class('PlayerCharacter', Character)

function PlayerCharacter:initialize(jsonInTableForm)
  Character.initialize(self, jsonInTableForm)
  self.velocity = {x = 0, y = 0}
end

function PlayerCharacter:update(dt)
  if love.keyboard.isDown('right') then
    self.physics_body.velocity.x = 200
  elseif love.keyboard.isDown('left') then
    self.physics_body.velocity.x = -200
  else
    self.physics_body.velocity.x = 0
  end

  self.velocity = {x = self.physics_body.velocity.x, y = self.physics_body.velocity.y}
end

function PlayerCharacter:init_physics_body(player_x, player_y)
  player_x, player_y = player_x or 0, player_y or 0
  self.physics_body = game.current_level.current_screen.physics_layer:add_physics_object("rectangle", player_x, player_y, 50, 50)
  self.physics_body.velocity = self.velocity
  self.physics_body.update = function(self, dt)
  print(self.velocity.x, self.velocity.y)
    self:apply_gravity(dt)
    self.velocity.y = math.clamp(-400, self.velocity.y, 600)
    self:move(self.velocity.x * dt, self.velocity.y * dt)
  end
end
