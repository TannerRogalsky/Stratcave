dofile('revelator/requirements.lua')

function love.load()
  game = Game:new()
  camera = Camera:new()

  -- ternary hack (player ? new(player) : new({}))
  game.player = game.current_level.player and PlayerCharacter:new(game.current_level.player) or PlayerCharacter:new({})
  game.hole = Hole:new(100,100)

  game.player1 = game.player
  game.player2 = game.hole

  game.player1.score, game.player2.score = 0,0
end

function love.update(dt)
  -- print(game.player.physics_body)
  cron.update(dt)
  game:update(dt)
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
  game:keypressed(key, unicode)
end

function love.keyreleased(key, unicode)
end

function love.draw()
  camera:set()

  game:render()

  -- leave this in for debugging (draws the collider's hash grid)
  -- g.setColor(255, 0, 0)
  -- game.Collider._hash:draw('line', true, true)

  camera:unset()

  g.setColor(255,255,255)
  -- g.print("FPS: " .. love.timer.getFPS(), 2, 2)
  g.draw(game.score_board, 5,5)
  g.setColor(0,0,0)
  g.print("Player 1: " .. game.player1.score, 50, 50)
  g.print("Player 2: " .. game.player2.score, 50, 70)
end
