local Loading = Game:addState('Loading')

local percent = 0
local loading_screen = g.newImage("images/loading_screen.png")

function Loading:enteredState()

  print('Entered Loading')

  cron.after(10, function()
    self.current_level.current_screen:enter(true)
    self:gotoState('MainMenu')
  end)

  local level = Game.load_level("test1")
  self.current_level = level
  local music = love.audio.newSource("audio/GameSongFull.ogg")
  love.audio.play(music)
end

function Loading:render()
  g.setColor(255,255,255)
  g.draw(loading_screen,-200,0)
end

return Loading
