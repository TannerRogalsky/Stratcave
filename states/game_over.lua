local GameOver = Game:addState('GameOver')

function GameOver:enteredState()
  for i,screen in ipairs(screenshots) do
    screen:encode("screen" .. i .. ".png")
  end
end

function GameOver:render()
  g.setColor(255,255,255)
  g.print("GAME OVER", 100, 100)
  g.print("Score: " .. stats.score, 100, 200)
  g.print("Survived for " .. math.round(stats.round_time, 1) .. " seconds.", 100, 300)
end

function GameOver:update(dt)
end

function GameOver:exitedState()
end

function GameOver.mousepressed(x, y, button)
  game:gotoState("Main")
end

return GameOver
