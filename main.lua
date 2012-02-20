dofile('requirements.lua')

function love.load()
  game = Game:new()

  level = Game.load_level("test1")
  game.currentLevel = level

  local layer = level.screens[1].layers[3]
  local object = layer:add_physics_object("circle", 200, 300, 10)

  object.velocity = {x = 0, y = 100}
  object.update = function(self, dt)
    self:move(self.velocity.x * dt, self.velocity.y * dt)
  end

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
end

function love.keyreleased(key, unicode)
end

function love.draw()
  game:render()

  -- leave this in for debugging (draws the collider's hash grid)
  g.setColor(255, 0, 0)
  game.Collider._hash:draw('line', true, true)
end
