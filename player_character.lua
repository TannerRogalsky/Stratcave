PlayerCharacter = class('PlayerCharacter', Character)

function PlayerCharacter:initialize(jsonInTableForm)
  Character.initialize(self, jsonInTableForm)

  self.pos = {}
  self.pos.x, self.pos.y = jsonInTableForm.pos[1], jsonInTableForm.pos[2]
  self.pos.incr = function(self, k, v) self[k] = self[k] + v end

  self.control_map = {
    keyboard = {
      on_press = {
        up = function() end
      },
      on_release = {

      },
      on_update = {
        w = function() self.pos:incr("y", -5) end,
        s = function() self.pos:incr("y", 5) end,
        a = function() self.pos:incr("x", -5) end,
        d = function() self.pos:incr("x", 5) end
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

function PlayerCharacter:center()
  return self._physics_body:center()
end

function PlayerCharacter:clean_up_physics_body()
  self._physics_body = nil
end

function PlayerCharacter:moveTo(x,y)
  self._physics_body:moveTo(x,y)
end

function PlayerCharacter:bbox()
  return self._physics_body:bbox()
end
