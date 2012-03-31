dofile('requirements.lua')

function love.load()
  game = Game:new()
  camera = Camera:new()

  level = Game.load_level("test1")
  game.current_level = level

  -- ternary hack (player ? new(player) : new({}))
  game.player = game.current_level.player and PlayerCharacter:new(game.current_level.player) or PlayerCharacter:new({})
  game.hole = Hole:new(100,100)

  game.current_level.current_screen:enter()
end

function love.update(dt)
  -- print(game.player.physics_body)
  local x,y = game.player.physics_body:center()
  camera:setPosition((x - g.getWidth() / 2) / 32, (y - g.getHeight() / 2) / 32)
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
    game.player.physics_body.velocity.y = -400
  end
end

function love.keyreleased(key, unicode)
  if key == 'a' then
    game.hole.x = game.hole.x - 100
  elseif key == 'd' then
    game.hole.x = game.hole.x + 100
  elseif key == 'w' then
    game.hole.y = game.hole.y - 100
  elseif key == 's' then
    game.hole.y = game.hole.y + 100
  elseif key == ' ' then
  end
  game.hole.physics_body:moveToWithoutCentroid(game.hole.x, game.hole.y)
end

function love.draw()
  camera:set()

  game:render()

  g.setColor(255,255,0)
  g.rectangle('line', game.hole.x, game.hole.y, 100, 100)

  -- leave this in for debugging (draws the collider's hash grid)
  -- g.setColor(255, 0, 0)
  -- game.Collider._hash:draw('line', true, true)

  g.setColor(0,255,0)
  g.print("FPS: " .. love.timer.getFPS(), 2, 2)

  camera:unset()
end
