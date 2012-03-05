dofile('requirements.lua')

function love.load()
  game = Game:new()
  camera = Camera:new()

  level = Game.load_level("test1")
  game.current_level = level

  -- ternary hack (player ? new(player) : new({}))
  game.player = game.current_level.player and PlayerCharacter:new(game.current_level.player) or PlayerCharacter:new({})
end

function love.update(dt)
  print(game.player.physics_body:stringify())
  game:update(dt)
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
  if key == 'q' or key == 'escape' then
    os.exit(1)
  elseif key == 'up' and game.player.on_ground then
    game.player.physics_body.velocity.y = -200
  end
end

function love.keyreleased(key, unicode)
end

function love.draw()
  camera:set()

  game:render()

  -- leave this in for debugging (draws the collider's hash grid)
  g.setColor(255, 0, 0)
  game.Collider._hash:draw('line', true, true)

  camera:unset()
end
