PlayerCharacter = class('PlayerCharacter', Character)

function PlayerCharacter:initialize(jsonInTableForm)
  Character.initialize(self, jsonInTableForm)

  self.control_map = {
    keyboard = {
      on_press = {
        up = function() self.physics_body.velocity.y = -400 end
      },
      on_release = {

      },
      on_update = {
        right = function() self.physics_body.velocity.x = 200 end,
        left = function() self.physics_body.velocity.x = -200 end
      }
    }
  }
end

function PlayerCharacter:update(dt)
  game.player.physics_body.velocity.x = 0
  for key, action in pairs(self.control_map.keyboard.on_update) do
    if love.keyboard.isDown(key) then action() end
  end

  self.physics_body:apply_gravity(dt)
  self.physics_body.velocity.y = math.clamp(-400, self.physics_body.velocity.y, 600)
  self.physics_body:move(self.physics_body.velocity.x * dt, self.physics_body.velocity.y * dt)
end

function PlayerCharacter:init_physics_body()
  self.physics_body = game.current_level.current_screen.physics_layer:add_physics_object("rectangle", 300, 0, 50, 50)
end
