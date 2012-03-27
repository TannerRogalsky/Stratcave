PlayerCharacter = class('PlayerCharacter', Character)

function PlayerCharacter:initialize(jsonInTableForm)
  Character.initialize(self, jsonInTableForm)
end

function PlayerCharacter:update(dt)
  if love.keyboard.isDown('right') then
    game.player.physics_body.velocity.x = 200
  elseif love.keyboard.isDown('left') then
    game.player.physics_body.velocity.x = -200
  else
    game.player.physics_body.velocity.x = 0
  end

  self.physics_body:apply_gravity(dt)
  self.physics_body.velocity.y = math.clamp(-400, self.physics_body.velocity.y, 600)
  self.physics_body:move(self.physics_body.velocity.x * dt, self.physics_body.velocity.y * dt)
end

function PlayerCharacter:init_physics_body()
  self.physics_body = game.current_level.current_screen.physics_layer:add_physics_object("rectangle", 300, 0, 50, 50)
end
