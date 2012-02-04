Character = class('Character', Base)

function Character:initialize()
  Base.initialize(self)
  self.id = generateID()
end

function Character:update(dt)
end

function Character:render()
end
