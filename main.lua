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
  -- camera:setPosition((x - g.getWidth() / 2) / 16, (y - g.getHeight() / 2) / 64)
  camera:setPosition((x - g.getWidth() / 2) / 16, 0)
  game:update(dt)
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
  if key == 'q' or key == 'escape' then
    os.exit(1)
  elseif key == 'up' and game.player.jumps < game.player.jump_limit then
    game.player.jumps = game.player.jumps + 1
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
    for i,v in ipairs(game.current_level.current_screen.physics_layer.physics_objects) do
      -- We might also need to check to see if hidden_tiles contains the element already
      -- Gonna leave that off for now, though
      if game.hole.physics_body:contains(v:center()) and game.hole.physics_body ~= v then
        if v.parent then -- item
          game.hole.max_holes = game.hole.max_holes + 1
          game.Collider:setGhost(v)
          v.render = function(self) end
          return
        elseif #game.hidden_tiles >= game.hole.max_holes then -- tile
          local tile = table.remove(game.hidden_tiles, 1)
          game.Collider:setSolid(tile)
          tile.render = nil
        end
        table.insert(game.hidden_tiles, v)
        game.Collider:setGhost(v)
        v.render = function(self) end
      end
    end
  elseif key == 'p' then
    game.player.physics_body:moveTo(300, 200)
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
