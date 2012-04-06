love.filesystem.load('requirements.lua')()

function love.load()
  game = Game:new()
  local Camera = require 'lib/camera.lua'
  camera = Camera:new()

  level = Game.load_level("test1")
  game.current_level = level

  -- ternary hack (player ? new(player) : new({}))
  game.player = game.current_level.player and PlayerCharacter:new(game.current_level.player) or PlayerCharacter:new({})

  game.current_level.current_screen:enter()
end

function love.update(dt)
  -- print(game.player.physics_body)
  local x,y = game.player.physics_body:center()
  camera:setPosition((x - g.getWidth() / 2) / 32, (y - g.getHeight() / 2) / 32)
  game:update(dt)
end

function love.mousepressed(x, y, button)
  game.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
  game.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
  game.keypressed(key, unicode)
end

function love.keyreleased(key, unicode)
  game.keyreleased(key, unicode)
end

function love.draw()
  game:render()
end
