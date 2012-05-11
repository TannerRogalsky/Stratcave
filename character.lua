Character = class('Character', Base)

function Character:initialize(jsonInTableForm)
  Base.initialize(self)

  -- dump the json data into the new object
  for k,v in pairs(jsonInTableForm) do
    self[k] = v
  end

  -- finalize some values with some defaults
  self.pos = self.pos or {}
  self.pos.incr = function(self, k, v) self[k] = self[k] + v end
end

function Character:update(dt)
end

function Character:render()
end

function Character:center()
  return self._physics_body:center()
end

function Character:clean_up_physics_body()
  self._physics_body = nil
end

function Character:moveTo(x,y)
  self.pos.x, self.pos.y = x, y
  self._physics_body:moveTo(x,y)
end

function Character:move(x,y)
  self.pos:incr('x', x)
  self.pos:incr('y', y)
  self._physics_body:move(x,y)
end

function Character:bbox()
  return self._physics_body:bbox()
end
