Gun = class('Gun', Base)

function Gun:initialize(type, rate_of_fire, spread)
  Base.initialize(self, {})

  assert(type ~= nil, "name that gun!")
  self.type = type
  self.rate_of_fire = rate_of_fire or 1
  self.spread = spread or 0
end

function Gun:update(dt)
end

function Gun:render()
end
