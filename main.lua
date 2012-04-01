dofile('requirements.lua')

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
  if key == 'q' or key == 'escape' then
    os.exit(1)
  elseif key == 'up' then
    if game.player1 == game.player and game.player.jumps < game.player.jump_limit then
      game.player1.jumps = game.player1.jumps + 1
      game.player1.physics_body.velocity.y = -400
    elseif game.player1 == game.hole then
      game.player1.y = game.player1.y - 100
    end
  elseif key == 'a' then
    if game.player2 == game.hole then
      game.player2.x = game.player2.x - 100
    end
  elseif key == 'd' then
    if game.player2 == game.hole then
      game.hole.x = game.hole.x + 100
    end
  elseif key == 'w' then
    if game.player2 == game.player and game.player.jumps < game.player.jump_limit then
      game.player2.jumps = game.player2.jumps + 1
      game.player2.physics_body.velocity.y = -400
    elseif game.player2 == game.hole then
      game.player2.y = game.player2.y - 100
    end
  elseif key == 's' then
    if game.player2 == game.hole then
      game.hole.y = game.hole.y + 100
    end
  elseif key == 'down' then
    if game.player1 == game.hole then
      game.hole.y = game.hole.y + 100
    end
  elseif key == 'left' then
    if game.player1 == game.hole then
      game.hole.x = game.hole.x - 100
    end
  elseif key == 'right' then
    if game.player1 == game.hole then
      game.hole.x = game.hole.x + 100
    end
  elseif key == ' ' then
    for i,v in ipairs(game.current_level.current_screen.physics_layer.physics_objects) do
      -- We might also need to check to see if hidden_tiles contains the element already
      -- Gonna leave that off for now, though
      if game.hole.physics_body:contains(v:center()) and game.hole.physics_body ~= v then
        if v.power_up or v.tile then
          if v.parent and v.power_up then -- item
            game.hole.max_holes = game.hole.max_holes + 1
            game.Collider:setGhost(v)
            v.render = function(self) end
            return
          elseif #game.hidden_tiles >= game.hole.max_holes and v.tile then -- tile
            local tile = table.remove(game.hidden_tiles, 1)
            game.Collider:setSolid(tile)
            tile.render = nil
          end
          table.insert(game.hidden_tiles, v)
          game.Collider:setGhost(v)
          v.render = function(self) end
        end
      end
    end
  elseif key == 'p' then
    game.player.physics_body:moveTo(300, 200)
  elseif key == 'o' then
    game.player1.score, game.player2.score = game.player2.score, game.player1.score
    game.player1, game.player2 = game.player2, game.player1
  end
  game.hole.physics_body:moveToWithoutCentroid(game.hole.x, game.hole.y)
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

  g.setColor(0,255,0)
  g.print("FPS: " .. love.timer.getFPS(), 2, 2)
  g.print("Player 1: " .. game.player1.score, 2, 20)
  g.print("Player 2: " .. game.player2.score, 2, 40)
end
