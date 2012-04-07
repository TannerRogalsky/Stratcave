PlayerCharacter = class('PlayerCharacter', Character)

function PlayerCharacter:initialize(jsonInTableForm)
  Character.initialize(self, jsonInTableForm)

  self.control_map = {
    keyboard = {
      on_press = {
        up = function() if self.on_ground then self.velocity.y = -400 end end
      },
      on_release = {

      },
      on_update = {
        right = function() self.velocity.x = 200 end,
        left = function() self.velocity.x = -200 end
      }
    },
    joystick = {
      on_press = {
        [0] = function() if self.on_ground then self.velocity.y = -400 end end, -- button A
        [1] = function() end,                                                   -- button B
        [2] = function() end,                                                   -- button X
        [3] = function() end                                                    -- button Y
      },
      on_release = {
      },
      on_update = function() self.velocity.x = love.joystick.getAxis(0, 0) * 200 end
    }
  }

  self.velocity = {x = 0, y = 0}
  self.x, self.y = self.x or 0, self.y or 0
end

function PlayerCharacter:update(dt)
  self.velocity.x = 0

  -- begin handle input
  for key, action in pairs(self.control_map.keyboard.on_update) do
    if love.keyboard.isDown(key) then action() end
  end

  if love.joystick.isOpen(0) then
    self.control_map.joystick.on_update()
  end

  -- end handle input

  self.velocity.y = self.velocity.y + (GRAVITY * dt)
  self.velocity.y = math.clamp(-400, self.velocity.y, 600)
  self._physics_body:move(self.velocity.x * dt, self.velocity.y * dt)
end

-- Must be called after world is created
function PlayerCharacter:init_physics_body()
  self._physics_body = game.current_level.current_screen.physics_layer:add_physics_object("rectangle", self.x, self.y, 50, 50)
  self._physics_body.parent = self
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
