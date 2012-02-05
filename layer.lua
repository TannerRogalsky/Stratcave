Layer = class('Layer', Base)

function Layer:initialize(dimensions)
  Base.initialize(self)
  self.dimensions = dimensions or {width = g.getWidth(), height = g.getHeight()}
end

function Layer:update(dt)
end

function Layer:render()
end
