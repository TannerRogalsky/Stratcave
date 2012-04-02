Game = class('Game', Base):include(Stateful)

function Game:initialize()
  Base.initialize(self)
  self.hidden_tiles = {}
  -- self.hidden_tiles.contains = function(self, element)
  --   for index, value in ipairs(self) do
  --     if value == element then
  --       return index
  --     end
  --   end
  --   return false
  -- end
  self.switches = 0
  self:gotoState('Loading')
  self.score_board = g.newImage("images/score_board.png")
end

function Game:update(dt)
end

function Game:render()
end

function Game:keypressed(key, unicode)
end

-- shape_one and shape_two are the colliding shapes. mtv_x and mtv_y define the minimum translation vector,
-- i.e. the direction and magnitude shape_one has to be moved so that the collision will be resolved.
-- Note that if one of the shapes is a point shape, the translation vector will be invalid.
function on_start_collide(dt, shape_one, shape_two, mtv_x, mtv_y)
  if type(shape_one.on_collide) == "function" then
    shape_one:on_collide(dt, shape_one, shape_two, mtv_x, mtv_y)
  end

  if type(shape_two.on_collide) == "function" then
    shape_two:on_collide(dt, shape_one, shape_two, mtv_x, mtv_y)
  end

  if shape_one.static == true and shape_two.static ~= true then
    shape_two:move(mtv_x, mtv_y)
  elseif shape_two.static == true and shape_one.static ~= true then
    shape_one:move(mtv_x, mtv_y)
  end

  local player, other, collision = nil, nil, nil
  if shape_one == game.player.physics_body then
    player, other = shape_one, shape_two
    collision = {
      is_down = mtv_y < 0,
      is_up = mtv_y > 0,
      is_left = mtv_x > 0,
      is_right = mtv_x < 0
    }
  elseif shape_two == game.player.physics_body then
    player, other = shape_two, shape_one
    collision = {
      is_down = mtv_y > 0,
      is_up = mtv_y < 0,
      is_left = mtv_x < 0,
      is_right = mtv_x > 0
    }
  else
    return
  end

  -- After this line, we can assume player refers to the player's physics_body
  -- collision values will use the player as a point of reference

  if other.static ~= true then
    other:move(mtv_x, mtv_y)
  end

  if collision.is_down and not other.item then
    game.player.jumps = 0
    game.player.physics_body:setRotation(other:rotation())
    game.player.physics_body.velocity.y = 0
  end
end

function on_stop_collide(dt, shape_one, shape_two)
  -- if shape_one == game.player.physics_body or shape_two == game.player.physics_body then
  --   game.player.on_ground = false
  -- end
  -- print("stop", shape_one, shape_two)
end

function Game:load_levels()
  self.levels = {}
  local levelNames = love.filesystem.enumerate("levels")
  for _,name in ipairs(levelNames) do
    table.insert(levels, Game.load_level(name))
  end
end

-- ### Class Methods ###

function Game.load_level(levelName)
  filePath = "levels/".. levelName .. ".json"
  if love.filesystem.isFile(filePath) then
    -- read in the json and parse it
    local raw = love.filesystem.read(filePath)
    local levelData = json.decode(raw)
    return Level:new(levelData)
  else
    return nil
  end
end
