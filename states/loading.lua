local Loading = Game:addState('Loading')

function Loading:enteredState()
  self.loader = require 'lib/love-loader'
  self.images = {}

  for index, image in ipairs(love.filesystem.enumerate('images')) do
    if image:match('(.*).png$') ~= nil or image:match('(.*).gif$') ~= nil or image:match('(.*).jpg$') ~= nil then
      self.loader.newImage(self.images, image, 'images/' .. image)
    end
  end

  self.loader.start(function()
    local level = Game.load_level("test1")
    game.current_level = level

    -- ternary hack (player ? new(player) : new({}))
    game.player = game.current_level.player and PlayerCharacter:new(game.current_level.player) or PlayerCharacter:new({})

    game.current_level.current_screen:enter()

    self:gotoState("Main")
  end)
end

function Loading:render()
end

function Loading:update(dt)
  self.loader.update()
  local percent = 0
  -- It's necessary to check for the loader because loader.update will trigger the state change
  -- The state change will kill the loader but we'll still be in this function which expects the loader
  if self.loader and self.loader.resourceCount ~= 0 then 
    percent = self.loader.loadedCount / self.loader.resourceCount 
  end
  print(("Loading .. %d%%"):format(percent*100))
end

function Loading:exitedState()
  self.loader = nil
end

return Loading
