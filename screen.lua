Screen = class('Screen', Base)

function Screen:initialize(dimensions)
  Base.initialize(self)
  self.dimensions = dimensions or {width = g.getWidth(), height = g.getHeight()}
end

function Screen:update(dt)
end

function Screen:render()
end
