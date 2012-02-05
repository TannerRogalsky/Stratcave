Base = class('Base')

function Base:initialize()
  self.id = generateID()
end

function Base:update()
end

function Base:render()
end

function Base:__tostring()
  return "Instance of ".. self.class.name .." with ID ".. self.id
end
