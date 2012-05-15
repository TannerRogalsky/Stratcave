local GameOver = Game:addState('GameOver')

function GameOver:enteredState()
  for i,screen in ipairs(screenshots) do
    screen:encode("screen" .. i .. ".png")
  end

  local scores = {}
  local json = require('json')
  if love.filesystem.isFile("scores.txt") then
    local raw = love.filesystem.read("scores.txt")
    scores = json.decode(raw)
  else
    scores["easy"] = {
      time = 0,
      score = 0
    }

    scores["hard"] = {
      time = 0,
      score = 0
    }

    scores["insane"] = {
      time = 0,
      score = 0
    }
  end
  if stats.score > scores[difficulty].score then
    scores[difficulty].score = stats.score
    scores[difficulty].time = math.round(stats.round_time, 1)
    self.new_highscore = true
  else
    self.new_highscore = false
  end

  love.filesystem.write("scores.txt", json.encode(scores))

end

function GameOver:render()
  g.setColor(255,255,255)
  g.print("GAME OVER. Click to return to the game menu.", 100, 100)
  g.print("Score: " .. stats.score, 100, 200)
  g.print("Survived for " .. math.round(stats.round_time, 1) .. " seconds.", 100, 300)

  if self.new_highscore then
    g.setColor(255,0,0)
    g.print("HOLY MOTHER! NEW HIGHSCOOOOOOOORE!", 400, 200)
  end
end

function GameOver:update(dt)
end

function GameOver:exitedState()
end

function GameOver.mousepressed(x, y, button)
  game:gotoState("Menu")
end

return GameOver
