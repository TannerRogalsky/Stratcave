dofile('requirements.lua')

function love.load()
  game = Game:new()
  camera = Camera:new()

  level = Game.load_level("test1")
  game.current_level = level

  -- ternary hack (player ? new(player) : new({}))
  game.player = game.current_level.player and Character:new(game.current_level.player) or Character:new({})

  local layer = level.screens[1].physics_layer

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
  elseif key == 'up' then
    game.player.physics_body.velocity.y = game.player.physics_body.velocity.x - 100
  elseif key == 'right' then
    game.player.physics_body.velocity.x = game.player.physics_body.velocity.x + 20
  elseif key == 'left' then
    game.player.physics_body.velocity.x = game.player.physics_body.velocity.x - 20
  end
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
