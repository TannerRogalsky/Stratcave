Torch = class('Torch', Base)

function Torch:initialize(position, radius)
  Base.initialize(self, {})

  assert(type(position) == "table")
  assert(radius ~= nil)

  self.pos = position
  self.radius = radius
end

function Torch:update(dt)
  self.radius = self.radius - (5 * dt)
  if self.radius <= 0 then
    game.torches[self.id] = nil
  end
end

function Torch:render()
end
