Layer = class('Layer', Base)

function Layer:initialize(jsonInTableForm)
  Base.initialize(self)

  -- dump the json data into the new object
  for k,v in pairs(jsonInTableForm) do
    self[k] = v
  end

  -- finalize some values with some defaults
  self.dimensions = self.dimensions or {width = self.width or g.getWidth(), height = self.height or g.getHeight()}

  if self.image then self.image = g.newImage(self.image) end
end

function Layer:update(dt)
end

function Layer:render()
  if self.image then
    g.draw(self.image)
  end
end
