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
  game.current_level.current_screen = self
  local objects = self.physics_layer.objects
  self.physics_layer.objects = {}
  for _,json_object in ipairs(objects) do
    local object = self.physics_layer:add_physics_object(json_object.type, unpack(json_object.attributes))
    json_object.type, json_object.attributes = nil, nil
    for key, value in pairs(json_object) do
      if key == "functions" then
        for function_name,function_string in pairs(value) do
          object[function_name] = assert(loadstring("local self,dt = ...; " .. function_string))
        end
      else
        object[key] = value
      end
    end

    if object.static then game.Collider:setPassive(object) end
  end
  table.insert(self.physics_layer.objects, game.player.physics_body)

  local bound = self.physics_layer:add_physics_object("rectangle", 0, 0, g.getWidth(), 10)
  game.Collider:setPassive(bound)
  bound.on_collide = function(self) game.player.physics_body:moveTo(300, 200) end
  bound = self.physics_layer:add_physics_object("rectangle", g.getWidth(), 0, 10, g.getHeight())
  game.Collider:setPassive(bound)
  bound.on_collide = function(self) game.player.physics_body:moveTo(300, 200) end
  bound = self.physics_layer:add_physics_object("rectangle", 0, g.getHeight(), g.getWidth(), 10)
  game.Collider:setPassive(bound)
  bound.on_collide = function(self) game.player.physics_body:moveTo(300, 200) end
  bound = self.physics_layer:add_physics_object("rectangle", 0, 0, 10, g.getHeight())
  game.Collider:setPassive(bound)
  bound.on_collide = function(self) game.player.physics_body:moveTo(300, 200) end

  -- TODO we need to get the coords to put the player at when he enters this screen.
  game.player.physics_body = self.physics_layer:add_physics_object("rectangle", 300, 0, 50, 50)
end

function Screen:exit()
  for _,object in ipairs(self.physics_layer.objects) do
    game.Collider:remove(object)
  end
  game.Collider:remove(game.player.physics_body)
  game.player.physics_body = nil
  self.physics_layer.objects = nil
  game.current_level.current_screen = nil
end
