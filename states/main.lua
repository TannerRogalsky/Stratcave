local MainMenu = Game:addState('MainMenu')

function MainMenu:enteredState()
  print('Entering MainMenu')
end

function MainMenu:render()
  self.current_level:render()
  self.player:render()
  self.hole:render()
end

function MainMenu:update(dt)
  local x,y = game.player.physics_body:center()
  -- camera:setPosition((x - g.getWidth() / 2) / 16, (y - g.getHeight() / 2) / 64)
  camera:setPosition((x - g.getWidth() / 2) / 16, 0)

  self.player:update(dt)
  self.hole:update(dt)
  self.current_level:update(dt)
  self.Collider:update(dt)
end

function MainMenu:exitedState()
  self.menu = nil
  print('Exiting MainMenu')
end

function MainMenu:keypressed(key, unicode)
  -- if key == 'q' or key == 'escape' then
  --   os.exit(1)
  -- else
  if key == 'up' then
    if game.player1 == game.player and game.player.jumps < game.player.jump_limit then
      game.player1.jumps = game.player1.jumps + 1
      game.player1.physics_body.velocity.y = -400
    elseif game.player1 == game.hole then
      game.player1.y = game.player1.y - 100
      if game.player1.y < 0 then game.player1.y = 0 end
    end
  elseif key == 'a' then
    if game.player2 == game.hole then
      game.player2.x = game.player2.x - 100
      if game.player2.x < 0 then game.player2.x = 0 end
    end
  elseif key == 'd' then
    if game.player2 == game.hole then
      game.hole.x = game.hole.x + 100
      if game.hole.x > 900 then game.hole.x = 900 end
    end
  elseif key == 'w' then
    if game.player2 == game.player and game.player.jumps < game.player.jump_limit then
      game.player2.jumps = game.player2.jumps + 1
      game.player2.physics_body.velocity.y = -400
    elseif game.player2 == game.hole then
      game.player2.y = game.player2.y - 100
      if game.player2.y < 0 then game.player2.y = 0 end
    end
  elseif key == 's' then
    if game.player2 == game.hole then
      game.hole.y = game.hole.y + 100
      if game.hole.y > 500 then game.hole.y = 500 end
    end
  elseif key == 'down' then
    if game.player1 == game.hole then
      game.hole.y = game.hole.y + 100
      if game.hole.y > 500 then game.hole.y = 500 end
    end
  elseif key == 'left' then
    if game.player1 == game.hole then
      game.hole.x = game.hole.x - 100
      if game.hole.x < 0 then game.hole.x = 0 end
    end
  elseif key == 'right' then
    if game.player1 == game.hole then
      game.hole.x = game.hole.x + 100
      if game.hole.x > 900 then game.hole.x = 900 end
    end
  elseif key == ' ' then
    for i,v in ipairs(game.current_level.current_screen.physics_layer.physics_objects) do
      -- We might also need to check to see if hidden_tiles contains the element already
      -- Gonna leave that off for now, though
      if game.hole.physics_body:contains(v:center()) and game.Collider:isSolid(v) then
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
            tile.update = nil
          end
          table.insert(game.hidden_tiles, v)
          game.Collider:setGhost(v)
          v.update = function(self, dt)
            self.anim:update(dt)
          end
          v.render = function(self) 
            local x,y = self:bbox()
            self.anim:draw(x,y)
          end
          v.anim:reset()
          v.anim:play()
        end
      end
    end
  elseif key == 'p' then
    game.player.physics_body:moveTo(300, 200)
  end
  game.hole.physics_body:moveToWithoutCentroid(game.hole.x, game.hole.y)
end

return MainMenu
