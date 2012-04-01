local Over = Game:addState('Over')

function Over:render()
  g.setColor(255,255,255)
  g.print("Game over", 350, 280)
end

function Over:update()
end

return Over
