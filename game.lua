Game = class('Game', Base)

function Game:initialize()
  Base.initialize(self)
  self.Collider = HC(100, on_start_collide, on_stop_collide)
end

function Game:update(dt)
  self.Collider:update(dt)
  self.currentLevel:update(dt)
end

function Game:render()
  self.currentLevel:render()
end

function Game:loadLevels()
  self.levels = {}
  local levelNames = love.filesystem.enumerate("levels")
  for _,name in ipairs(levelNames) do
    table.insert(levels, Game.loadLevel(name))
  end
end

-- shape_one and shape_two are the colliding shapes. mtv_x and mtv_y define the minimum translation vector,
-- i.e. the direction and magnitude shape_one has to be moved so that the collision will be resolved.
-- Note that if one of the shapes is a point shape, the translation vector will be invalid.
function on_start_collide(dt, shape_one, shape_two, mtv_x, mtv_y)

end

function on_stop_collide(dt, shape_one, shape_two)

end

-- ### Class Methods ###

function Game.loadLevel(levelName)
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
