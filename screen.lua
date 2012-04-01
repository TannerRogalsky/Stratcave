Screen = class('Screen', Base)

function Screen:initialize(jsonInTableForm)
  Base.initialize(self)

  -- dump the json data into the new object
  for k,v in pairs(jsonInTableForm) do
    if k == "layers" then
      self.layers = skiplist.new(#v)
      -- for each entry in the screen list
      for _,layerTable in ipairs(v) do
        -- make a new screen from the data and put it into level.screens
        local layer = Layer:new(layerTable)
        if layer.z == 0 then
          assert(self.physics_layer == nil, "You can't have more than one zeroth level layer.")
          self.physics_layer = layer
        end
        self.layers:insert(layer)
      end
    else
      self[k] = v
    end
  end

  -- assertions about the screen data model
  assert(type(self.x) == "number" and type(self.y) == "number", tostring(screen).." needs layout indices.")

  -- finalize some values with some defaults
  self.dimensions = self.dimensions or {width = self.width or g.getWidth(), height = self.height or g.getHeight()}
  self.physics_layer = self.physics_layer or Layer:new({z = 0})
  self.items = self.items or {}
end

-- we probably only need to update the physics layer but whatever
function Screen:update(dt)
  for i,layer in self.layers:ipairs() do
    layer:update(dt)
  end
end

function Screen:render()
  local bx, by = camera.x, camera.y
  -- this will iterate over the skiplist with layers with lower z-indexs going first
  for i,layer in self.layers:ipairs() do
    camera.x = bx * math.abs(layer.z)
    camera.y = by * math.abs(layer.z)
    camera:set()
    layer:render()
    camera:unset()
  end
end

function Screen:enter()
  game.Collider = HC(100, on_start_collide, on_stop_collide)
  game.current_level.current_screen = self
  local image = g.newImage("images/smoke.png")
  for _,json_object in ipairs(self.physics_layer.objects) do
    local object = self.physics_layer:add_physics_object(json_object.type, unpack(json_object.attributes))
    for key, value in pairs(json_object) do
      if key == "functions" then
        for function_name,function_string in pairs(value) do
          object[function_name] = assert(loadstring("local self,dt = ...; " .. function_string))
        end
      elseif key == "rotation" then
        object:setRotation(math.rad(value))
      elseif key == "image_path" then
        object.image = g.newImage("images/".. value)
      else
        object[key] = value
      end
      object.tile = true
      object.anim = newAnimation(image, 100, 100, 0.1, 0)
      object.anim:setMode("once")
    end
    if object.static then game.Collider:setPassive(object) end
  end

  -- power up
  local item = Item:new({})
  local physics_body = self.physics_layer.physics_objects[math.random(#self.physics_layer.physics_objects - 2) + 1]
  local x,y = physics_body:bbox()
  if y < 100 then y = 100 end
  y = math.round(math.random(y - 100) / 100) * 100 + 25
  item:init_physics_body(x + 25, y)
  item.physics_body.power_up = true
  item.physics_body.on_collide = function(self, ...) self.parent:on_power_up_collide(...) end
  item.physics_body.image = g.newImage("images/power_up.png")

  -- lamp
  item = Item:new({})
  physics_body = self.physics_layer.physics_objects[math.random(#self.physics_layer.physics_objects - 2) + 1]
  x,y = physics_body:bbox()
  if y < 100 then y = 100 end
  y = math.round(math.random(y - 100) / 100) * 100 + 25
  item:init_physics_body(x + 25, y)
  item.physics_body.lamp = true
  item.physics_body.on_collide = function(self, ...) self.parent:on_lamp_collide(...) end
  item.physics_body.update = function(self, dt)
    self.parent.p:start()
    self.parent.p:update(dt)
  end
  item.physics_body.image = g.newImage("images/lamp.png")
  item.physics_body.render = function(self)
    local x,y = self:bbox()
    g.draw(self.parent.p, x, y)

    g.setColor(255,255,255)
    g.draw(self.image, x, y)
  end

  local boundary_collision = function(self, dt, shape_one, shape_two, mtv_x, mtv_y)
    local x,y = self:center()
    local delta_x, delta_y = 0, 0
    if x >= g.getWidth() then delta_x = 1 end
    if x <= 0 then delta_x = -1 end
    if y >= g.getHeight() then delta_y = 1 end
    if y <= 0 then delta_y = -1 end

    local to = game.current_level:transition_to_screen(game.current_level.current_screen.x + delta_x, game.current_level.current_screen.y + delta_y, delta_x, delta_y)
    if to == nil then
      -- TODO die
      game.player.physics_body:moveTo(200, 200)
    end
  end

  local bound = self.physics_layer:add_physics_object("rectangle", 0, -10 - 35, g.getWidth(), 10)
  game.Collider:setPassive(bound)
  bound.on_collide = boundary_collision
  bound.render = function(self) end
  bound = self.physics_layer:add_physics_object("rectangle", g.getWidth() + 35, 0, 10, g.getHeight())
  game.Collider:setPassive(bound)
  bound.on_collide = boundary_collision
  bound.render = function(self) end
  bound = self.physics_layer:add_physics_object("rectangle", 0, g.getHeight() + 35, g.getWidth(), 10)
  game.Collider:setPassive(bound)
  bound.on_collide = boundary_collision
  bound.render = function(self) end
  bound = self.physics_layer:add_physics_object("rectangle", -10 - 35, 0, 10, g.getHeight())
  game.Collider:setPassive(bound)
  bound.on_collide = boundary_collision
  bound.render = function(self) end

  -- TODO we need to get the coords to put the player at when he enters this screen.
  game.player:init_physics_body()
  game.hole:init_physics_body()
end

function Screen:exit()
  game.hidden_tiles = {}
  game.hole.physics_body = nil
  game.player.physics_body = nil
  game.current_level.current_screen.physics_layer.physics_objects = {}
  game.current_level.current_screen = nil
  game.Collider = nil
end
