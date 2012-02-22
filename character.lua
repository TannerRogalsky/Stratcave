Character = class('Character', Base)

function Character:initialize(jsonInTableForm)
  Base.initialize(self)

  -- dump the json data into the new object
  for k,v in pairs(jsonInTableForm) do
    self[k] = v
  end

  -- finalize some values with some defaults
  game.current_level.current_screen.physics_layer:add_physics_object("rectangle", 300, 400, 50, 100)
end

function Character:update(dt)
end

function Character:render()
end
