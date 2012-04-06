Character = class('Character', Base)

function Character:initialize(jsonInTableForm)
  Base.initialize(self)

  -- dump the json data into the new object
  for k,v in pairs(jsonInTableForm) do
    self[k] = v
  end

  -- finalize some values with some defaults
end

function Character:update(dt)
end

function Character:render()
end
