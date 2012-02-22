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

  -- assertions
  assert(type(self.starting_screen_index) == "table" and type(self.starting_screen_index.x) == "number"
    and type(self.starting_screen_index.y) == "number", "You need to specify a starting screen for each level")

  -- initialize default value after this line
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
