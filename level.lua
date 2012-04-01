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
function Level:transition_to_screen(x, y, delta_x, delta_y)
  -- screens should probably be stored in tables with their indices indexed so we don't have to loop to search
  if x == 5 then x = 0 end
  if x == -1 then x = 4 end
  if y == 2 then y = 0 end
  if y == -1 then y = 1 end
  for _,screen in ipairs(game.current_level.screens) do
    if x == screen.x and y == screen.y then
      local px, py = game.player.physics_body:center()
      game.current_level.current_screen:exit()
      screen:enter()

      -- This stuff should maybe already be in the player character model
      local x1,y1, x2,y2 = game.player.physics_body:bbox()
      local p_height, p_width = x2 - x1, y2 - y1

      if delta_x > 0 then
        px = 0
      elseif delta_x < 0 then
        px = g.getWidth()
      elseif delta_y > 0 then
        py = 0 + p_height

        game.switches = game.switches + 1
        if game.switches >= 6 then
          game:gotoState("Over")
        end

        -- switch players. so hardcoded it's brutal
        game.player1.score, game.player2.score = game.player2.score, game.player1.score
        game.player1, game.player2 = game.player2, game.player1

        game.player.jump_limit = 1
        game.hole.max_holes = 2
      elseif delta_y < 0 then
        py = g.getHeight() - p_height
      end

      game.player.physics_body:moveTo(px, py)
      return screen
    end
  end
  return nil
end
