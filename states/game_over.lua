local Over = Game:addState('Over')

local game_over_img = g.newImage("images/game_over.png")

function Over:render()
  g.setColor(255,255,255)
  -- g.print("Game over", 350, 280)
  g.draw(game_over_img, -200, 0)
end

function Over:update()
end

return Over
