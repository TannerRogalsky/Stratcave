local Main = Game:addState('Main')

function Main:enteredState()
  local MAX_BALLS = 100

  balls = {{100,100}, {400,300}, {400,300}, {400,300}}
  self.player = PlayerCharacter:new({pos = balls[1]})

  local raw = love.filesystem.read("shader.c"):format(MAX_BALLS)
  self.overlay = love.graphics.newPixelEffect(raw)
  self.bg = love.graphics.newImage("images/game_over.png")

  self.overlay:send('num_balls', #balls)
  self.overlay:send('balls', unpack(balls))

  local dx = love.mouse.getX() - self.player.pos.x
  local dy = self.player.pos.y - love.mouse.getY()
  self.overlay:send('delta_to_mouse', {dx, dy})
end

function Main:render()
  camera:set()

  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(self.bg, 0, 0)

  local p_radius = 10
  love.graphics.setColor(255,0,0)
  love.graphics.circle("fill", self.player.pos.x, self.player.pos.y, p_radius)

  love.graphics.setColor(0,0,0,255)
  local x, y = love.mouse.getX(), love.mouse.getY()
  local angle = math.atan2(y - self.player.pos.y, x - self.player.pos.x)
  x = self.player.pos.x + p_radius * math.cos(angle)
  y = self.player.pos.y + p_radius * math.sin(angle)
  love.graphics.line(self.player.pos.x, self.player.pos.y, x, y)

  love.graphics.setColor(255,255,255,255)
  love.graphics.setPixelEffect(self.overlay)
  love.graphics.rectangle('fill', 0,0,love.graphics.getWidth(), love.graphics.getHeight())
  love.graphics.setPixelEffect()

  camera:unset()

  love.graphics.setColor(0,255,0,255)
  love.graphics.print(love.timer.getFPS(), 2, 2)
end

function Main:update(dt)
  local t = love.timer.getMicroTime( )

  for k,v in pairs(self.player.control_map.keyboard.on_update) do
    if love.keyboard.isDown(k) then v() end
  end

  balls[1] = {self.player.pos.x, love.graphics.getHeight() - self.player.pos.y}
  balls[2] = {math.sin(2*t) * 120 + love.graphics.getWidth()/2, math.cos(t) * 120 + love.graphics.getHeight()/2}
  balls[3] = {math.sin(t) * 120 + love.graphics.getWidth()/2, math.cos(2*t) * 120 + love.graphics.getHeight()/2}
  balls[4] = {
    math.sin(t) * (110 + math.sin(.01*t) * 110)  + love.graphics.getWidth()/2,
    math.cos(t) * (110 + math.sin(.01*t) * 110)  + love.graphics.getHeight()/2,
  }

  local dx = love.mouse.getX() - self.player.pos.x
  local dy = self.player.pos.y - love.mouse.getY()
  self.overlay:send('delta_to_mouse', {dx, dy})

  self.overlay:send('balls', unpack(balls))
end

function Main.keypressed(key, unicode)
  local action = game.player.control_map.keyboard.on_press[key]
  if type(action) == "function" then action() end
end

function Main.joystickpressed(joystick, button)
  local action = game.player.control_map.joystick.on_press[button]
  if type(action) == "function" then action() end
end

function Main.joystickreleased(joystick, button)
  local action = game.player.control_map.joystick.on_release[button]
  if type(action) == "function" then action() end
end

function Main:exitedState()
end

return Main
