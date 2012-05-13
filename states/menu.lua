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
  end
  table.insert(self.ui, box)
end

function Menu:render()
  g.setColor(255,255,255)
  g.print("GENERIC SCHMUP", 100, 100)
  g.print("Controls:", 200, 125)
  g.print("WASD", 200, 150)
  g.print("SPACE to drop a torch", 200, 175)
  g.print("MOUSE to aim", 200, 200)
  g.print("LEFT CLICK to shoot (hold it down for happiness)", 200, 225)

  for i,box in ipairs(self.ui) do
    box:render()
  end
end

function Menu:update(dt)
  self.collider:update()
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
