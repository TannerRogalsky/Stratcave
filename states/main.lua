local MainMenu = Game:addState('MainMenu')

function MainMenu:enteredState()
  print('Entering MainMenu')
end

function MainMenu:render()
  self.current_level:render()
  self.player:render()
end

function MainMenu:update(dt)
  local x,y = game.player.physics_body:center()
  -- camera:setPosition((x - g.getWidth() / 2) / 16, (y - g.getHeight() / 2) / 64)
  camera:setPosition((x - g.getWidth() / 2) / 16, 0)

  self.player:update(dt)
  self.current_level:update(dt)
  self.Collider:update(dt)
end

function MainMenu:exitedState()
  self.menu = nil
  print('Exiting MainMenu')
end

return MainMenu
