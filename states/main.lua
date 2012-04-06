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

  camera:unset()

  g.setColor(0,255,0)
  g.print("FPS: " .. love.timer.getFPS(), 2, 2)
end

function Main:update(dt)
  local x,y = game.player:center()
  camera:setPosition((x - g.getWidth() / 2) / 32, (y - g.getHeight() / 2) / 32)

  self.player:update(dt)
  self.current_level:update(dt)
  self.Collider:update(dt)
end

function Main.keypressed(key, unicode)
  local action = game.player.control_map.keyboard.on_press[key]
  if type(action) == "function" then action() end
end

-- it's necessary to add one to the button pressed because the button indices aren't 1-indexed
function Main.joystickpressed(joystick, button)
  local action = game.player.control_map.joystick.on_press[button + 1]
  if type(action) == "function" then action() end
end

function Main.joystickreleased(joystick, button)
  local action = game.player.control_map.joystick.on_release[button + 1]
  if type(action) == "function" then action() end
end

function Main:exitedState()
end

return Main
