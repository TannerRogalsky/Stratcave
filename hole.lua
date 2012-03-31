Hole = class('Hole', Character)

function Hole:initialize(x, y)
  Character.initialize(self, {})
  assert(x and y, "needs moar arguments")
  self.x, self.y = x, y
end

function Hole:update(dt)
  -- if love.keyboard.isDown('z') then
  --   game.player.physics_body.velocity.x = 0
  -- else
  --   game.player.physics_body.velocity.x = 0
  -- end
end

function Hole:init_physics_body()
  self.physics_body = game.current_level.current_screen.physics_layer:add_physics_object("rectangle", self.x, self.y, 100, 100)
end
