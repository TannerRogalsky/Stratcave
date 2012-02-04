Character = class('Character', Base)

function Character:initialize(position, dimensions)
  Base.initialize(self)
  self.position = position or {x = 0, y = 0}
  self.dimensions = dimensions or {width = 0, height = 0}
end

function Character:update(dt)
end

function Character:render()
end
