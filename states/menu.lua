local Menu = Game:addState('Menu')

function Menu:enteredState()
  self.collider = HC()
  self.ui = {}
  local box = self.collider:addRectangle(g.getWidth() / 5 * 1, g.getHeight() / 3 * 2, 150, 100)
  box.render = function(self)
    g.setColor(255,255,255)
    self:draw("line")
    local x,y = self:bbox()
    g.print("Easy Mode", x + 10, y + 10)
  end
  box.onclick = function()
    spawn_rate = 4
    max_torches = 8
    crawler_ratio = 8
    difficulty = "easy"
  end
  table.insert(self.ui, box)

  box = self.collider:addRectangle(g.getWidth() / 5 * 2, g.getHeight() / 3 * 2, 150, 100)
  box.render = function(self)
    g.setColor(255,255,255)
    self:draw("line")
    local x,y = self:bbox()
    g.print("Hard Mode", x + 10, y + 10)
  end
  box.onclick = function()
    spawn_rate = 2
    max_torches = 5
    crawler_ratio = 7
    difficulty = "hard"
  end
  table.insert(self.ui, box)

  box = self.collider:addRectangle(g.getWidth() / 5 * 3, g.getHeight() / 3 * 2, 150, 100)
  box.render = function(self)
    g.setColor(255,255,255)
    self:draw("line")
    local x,y = self:bbox()
    g.print("Insane Mode", x + 10, y + 10)
  end
  box.onclick = function()
    spawn_rate = 0.8
    max_torches = 4
    crawler_ratio = 5
    difficulty = "insane"
  end
  table.insert(self.ui, box)



  self.ui_font = g.newFont(16)
  g.setFont(self.ui_font)

  self.time = 0

  local raw = love.filesystem.read("shaders/menu.c"):format(g.getWidth(), g.getHeight())
  self.bg = love.graphics.newPixelEffect(raw)
end

function Menu:render()
  love.graphics.setColor(0,0,0,255)
  love.graphics.setPixelEffect(self.bg)
  love.graphics.rectangle('fill', 0,0,love.graphics.getWidth(), love.graphics.getHeight())
  love.graphics.setPixelEffect()

  g.setColor(255,255,255)
  g.print("[GRIDPHREAK]", 100, 100)
  g.print("Controls:", 200, 125)
  g.setColor(255,0,0)
  g.print("READ THIS STUFF!", 275, 125)
  g.setColor(255,255,255)
  g.print("WASD to move around", 200, 150)
  g.print("SPACE to drop a torch", 200, 175)
  g.print("MOUSE to aim", 200, 200)
  g.print("LEFT CLICK to shoot (hold it down for constant shooting)", 200, 225)
  g.print("TORCHES recharge after they burn out completely", 200, 250)
  g.print("Graphics by Derian McCrea and Tanner Rogalsky", 100, 300)
  g.print("Code and concept by Tanner Rogalsky", 100, 325)
  g.print("Click a difficulty to begin!", 485, 600)

  for i,box in ipairs(self.ui) do
    box:render()
  end
end

function Menu:update(dt)
  self.collider:update(dt)
  self.time = self.time + dt
  self.bg:send('time', self.time)
end

function Menu.mousepressed(x, y, button)
  for i,box in ipairs(game.ui) do
    if box:contains(x,y) then
      box.onclick()
      game:gotoState("Main")
    end
  end
end

function Menu:exitedState()
  self.collider:clear()
  self.collider = nil
end

return Menu
