dofile('requirements.lua')

function love.load()
  game = Game:new()
  camera = Camera:new()

  level = Game.load_level("test1")
  game.currentLevel = level

  local layer = level.screens[1].layers[3]
  local object = layer:add_physics_object("circle", 200, 300, 10)

  object.update = function(self, dt)
    self:applyGravity(dt)
    self:move(self.velocity.x * dt, self.velocity.y * dt)
  end

  ball = object

  object = layer:add_physics_object("rectangle", 0, 475, 600, 10)
  object.static = true
  game.Collider:setPassive(object)

  -- debug.debug()
  -- print(level)

  -- print(#level.screens)
  -- print(unpack(level.screens))

  -- for i,layer in level.screens[1].layers:ipairs() do
  --   print(layer, "z: "..layer.z)
  -- end
end

function love.update(dt)
  game:update(dt)
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
  if key == 'q' or key == 'escape' then
    os.exit(1)
  end

  ball.velocity.y = ball.velocity.x - 100
end

function love.keyreleased(key, unicode)
end

function love.draw()
  camera:set()

  game:render()

  -- leave this in for debugging (draws the collider's hash grid)
  g.setColor(255, 0, 0)
  game.Collider._hash:draw('line', true, true)

  camera:unset()
end
