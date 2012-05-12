local Loading = Game:addState('Loading')

function Loading:enteredState()
  self.loader = require 'lib/love-loader'
  self.preloaded_image = {}
  self.preloaded_json = {}

  for index, image in ipairs(love.filesystem.enumerate('images')) do
    if image:match('(.*).png$') ~= nil or image:match('(.*).gif$') ~= nil or image:match('(.*).jpg$') ~= nil then
      self.loader.newImage(self.preloaded_image, image, 'images/' .. image)
    end
  end

  -- self.loader.newJson(self.preloaded_json, 'test1', 'levels/test1.json')

  self.loader.start(function()
    -- loader finished callback
    -- initialize game stuff here

    self:gotoState("Menu")
  end)
end

function Loading:render()
  local percent = 0
  -- It's necessary to check for the loader because loader.update will trigger the state change
  -- The state change will kill the loader but we'll still be in this function which expects the loader
  if self.loader.resourceCount ~= 0 then
    percent = self.loader.loadedCount / self.loader.resourceCount 
  end
  g.print(("Loading .. %d%%"):format(percent*100),100,100)
end

function Loading:update(dt)
  self.loader.update()
end

function Loading:exitedState()
  self.loader = nil
end

return Loading
