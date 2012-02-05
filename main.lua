dofile('requirements.lua')

function love.load()
  game = Game:new()
  level = Game.loadLevel("test1")
  -- debug.debug()
  print(level)
end

function love.update(dt)
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
  if key == 'q' or key == 'escape' then
    os.exit(1)
  end
end

function love.keyreleased(key, unicode)
end

function love.draw()
end
