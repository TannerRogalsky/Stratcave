Game = class('Game', Base)

function Game:initialize()
  Base.initialize(self)
end

function Game:update(dt)
end

function Game:render()
end

function Game:loadLevels()
  self.levels = {}
  local levelNames = love.filesystem.enumerate("levels")
  for _,name in ipairs(levelNames) do
    table.insert(levels, Game.loadLevel(name))
  end
end

-- ### Class Methods ###

function Game.loadLevel(levelName)
  filePath = "levels/".. levelName .. ".json"
  if love.filesystem.isFile(filePath) then
    -- read in the json and parse it
    local raw = love.filesystem.read(filePath)
    local levelData = json.decode(raw)
    local level = Level:new()

    -- dump all attributes into the blank level
    for k,v in pairs(levelData) do
      level[k] = v
    end

    return level
  else
    return nil
  end
end
