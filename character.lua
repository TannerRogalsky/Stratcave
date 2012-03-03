Character = class('Character', Base)

function Character:initialize(jsonInTableForm)
  Base.initialize(self)

  -- dump the json data into the new object
  for k,v in pairs(jsonInTableForm) do
    self[k] = v
  end

  -- finalize some values with some defaults
  self.physics_body = game.current_level.current_screen.physics_layer:add_physics_object("rectangle", 300, 400, 50, 50)
end

function Character:update(dt)
  self.physics_body:apply_gravity(dt)
  self.physics_body.velocity.y = math.clamp(-200, self.physics_body.velocity.y, 200)
  self.physics_body:move(self.physics_body.velocity.x * dt, self.physics_body.velocity.y * dt)
end

function Character:render()
end
