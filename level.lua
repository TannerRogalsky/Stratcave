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
  if type(self.starting_screen_index) == "table" then
    self.starting_screen_index.x = self.starting_screen_index.x or 0
    self.starting_screen_index.y = self.starting_screen_index.y or 0
  else
    self.starting_screen_index = {x = 0, y = 0}
  end

  for i,screen in ipairs(self.screens) do
    if screen.x == self.starting_screen_index.x and screen.y == self.starting_screen_index.y then
      self.current_screen = screen
    end
  end
end

function Level:update(dt)
  self.current_screen:update(dt)
end

function Level:render()
  self.current_screen:render()
end
