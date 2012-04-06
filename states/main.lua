local Main = Game:addState('Main')

function Main:enteredState()

end

function Main:render()
  camera:set()

  self.player:render()
  self.current_level:render()

  -- leave this in for debugging (draws the collider's hash grid)
  g.setColor(255, 0, 0)
  game.Collider._hash:draw('line', true, true)

  g.setColor(0,255,0)
  g.print("FPS: " .. love.timer.getFPS(), 2, 2)

  camera:unset()
end

function Main:update(dt)
  self.player:update(dt)
  self.current_level:update(dt)
  self.Collider:update(dt)
end

function Main.keypressed(key, unicode)
  if key == 'q' or key == 'escape' then
    os.exit(1)
  elseif key == 'up' and game.player.on_ground then
    game.player.physics_body.velocity.y = -400
  elseif key == "p" then
    game.player.physics_body:moveTo(300, 200)
  elseif key == "n" then
    local x,y = game.current_level.current_screen.x, game.current_level.current_screen.y
    game.current_level:transition_to_screen(x + 1, y)
  end
end

function Main:exitedState()
end

return Main
