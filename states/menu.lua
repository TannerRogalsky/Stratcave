local Menu = Game:addState('Menu')

function Menu:enteredState()
end

function Menu:render()
  g.setColor(255,255,255)
  g.print("GENERIC SCHMUP", 100, 100)
  g.print("CLICK TO ENTER HARD MODE (ONLY MODE)", 100, 200)
end

function Menu:update(dt)
end

function Menu.mousepressed(x, y, button)
  game:gotoState("Main")
end

function Menu:exitedState()
end

return Menu
