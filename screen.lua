Screen = class('Screen', Base)

function Screen:initialize(jsonInTableForm)
  Base.initialize(self)

  -- dump the json data into the new object
  for k,v in pairs(jsonInTableForm) do
    if k == "layers" then
      self.layers = {}
      -- for each entry in the screen list
      for _,layerTable in ipairs(v) do
        -- make a new screen from the data and put it into level.screens
        table.insert(self.layers, Layer:new(layerTable))
      end
    else
      self[k] = v
    end
  end

  -- finalize some values with some defaults
  self.dimensions = self.dimensions or {width = self.width or g.getWidth(), height = self.height or g.getHeight()}
end

function Screen:update(dt)
end

function Screen:render()
  for i,layer in ipairs(self.layers) do
    layer:render()
  end
end
