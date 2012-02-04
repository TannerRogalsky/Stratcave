Level = class('Level', Base)

function Level:initialize(dimensions)
  Base.initialize(self)
  self.dimensions = dimensions or {width = g.getWidth(), height = g.getHeight()}
end

function Level:update(dt)
end

function Level:render()
end
