Level = class('Level', Base)

function Level:initialize(jsonInTableForm)
  Base.initialize(self)

  -- dump all attributes into the blank level
  for k,v in pairs(jsonInTableForm) do

    if k == "screens" then
      self.screens = {}

      -- for each entry in the screen list
      for _,screenTable in ipairs(v) do
        -- make a new screen from the data and put it into level.screens
        table.insert(self.screens, Screen:new(screenTable))
      end
    else
      self[k] = v
    end
  end

  -- initialize default value after this line
end

function Level:update(dt)
  for i,screen in ipairs(self.screens) do
    screen:update(dt)
  end
end

function Level:render()
  for i,screen in ipairs(self.screens) do
    screen:render()
  end
end
