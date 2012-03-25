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

--- Transition between screens
-- @param x The screen x cooridinate to be transitioned to
-- @param y The screen y cooridinate to be transitioned to
-- @return Will return the screen to be transitioned to or nil if the screen with the specified indices does not exist
function Level:transition_to_screen(x, y)
  for _,screen in ipairs(game.current_level.screens) do
    if x == screen.x and y == screen.y then
      game.current_level.current_screen:exit()
      screen:enter()
      return screen
    end
  end
  return nil
end
