local GameOver = Game:addState('GameOver')

function GameOver:enteredState()
end

function GameOver:render()
  g.setColor(255,255,255,255)
  g.print("GAME OVER, BITCH", 100, 100)
end

function GameOver:update(dt)
end

function GameOver:exitedState()
end

return GameOver
