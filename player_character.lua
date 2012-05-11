PlayerCharacter = class('PlayerCharacter', Character)

function PlayerCharacter:initialize(jsonInTableForm)
  Character.initialize(self, jsonInTableForm)

  self.pos = jsonInTableForm.pos or {x = 100, y = 100}
  self.speed = 3

  self.control_map = {
    keyboard = {
      on_press = {
        up = function() end
      },
      on_release = {

      },
      on_update = {
        w = function() self:move(0, -self.speed) end,
        s = function() self:move(0, self.speed) end,
        a = function() self:move(-self.speed, 0) end,
        d = function() self:move(self.speed, 0) end
      }
    },
    joystick = {
      on_press = {
        [0] = function() end, -- button A
        [1] = function() end, -- button B
        [2] = function() end, -- button X
        [3] = function() end  -- button Y
      },
      on_release = {
      },
      on_update = function() self.velocity.x = love.joystick.getAxis(0, 0) * 200 end
    }
  }

  self._physics_body = game.collider:addCircle(self.pos.x, self.pos.y, 10)
  self._physics_body.parent = self
end

function PlayerCharacter:update(dt)
  -- begin handle input
  for key, action in pairs(self.control_map.keyboard.on_update) do
    if love.keyboard.isDown(key) then action() end
  end

  if love.joystick.isOpen(0) then
    self.control_map.joystick.on_update()
  end

  -- end handle input

end

function PlayerCharacter:render()
  local p_radius = 10
  love.graphics.setColor(255,0,0)
  love.graphics.circle("fill", self.pos.x, self.pos.y, p_radius)

  love.graphics.setColor(0,0,0,255)
  local x, y = love.mouse.getX(), love.mouse.getY()
  local angle = math.atan2(y - self.pos.y, x - self.pos.x)
  x = self.pos.x + p_radius * math.cos(angle)
  y = self.pos.y + p_radius * math.sin(angle)
  love.graphics.line(self.pos.x, self.pos.y, x, y)
end
