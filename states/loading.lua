local Loading = Game:addState('Loading')

local percent = 0

function Loading:enteredState()

  print('Entered Loading')

  local counterId = cron.every(0.5, function()
    percent = percent + 10
  end)

  cron.after(5, function()
    cron.cancel(counterId)
    self.current_level.current_screen:enter(true)
    self:gotoState('MainMenu')
  end)



  local level = Game.load_level("test1")
  self.current_level = level
  local music = love.audio.newSource("audio/GameSongFull.ogg")
  love.audio.play(music)
end

function Loading:render()
  g.print("Loading ... " .. percent .. "%", 350, 280)
end

return Loading
