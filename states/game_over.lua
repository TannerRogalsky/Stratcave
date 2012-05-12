local GameOver = Game:addState('GameOver')

function GameOver:enteredState()
end

function GameOver:render()
  g.setColor(255,255,255,255)
  g.print("GAME OVER", 100, 100)
end

function GameOver:update(dt)
end

function GameOver:exitedState()
end

function GameOver.mousepressed(x, y, button)
  game:gotoState("Main")
end

return GameOver
