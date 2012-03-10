Layer = class('Layer', Base)

function Layer:initialize(jsonInTableForm)
  Base.initialize(self)

  -- dump the json data into the new object
  for k,v in pairs(jsonInTableForm) do
    if k == "objects" then
      self.objects = {}
      self.z = 0

      for _,json_object in ipairs(v) do
        local object = self:add_physics_object(json_object.type, unpack(json_object.attributes))
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
    else
      self[k] = v
    end
  end

  -- finalize some values with some defaults
  self.dimensions = self.dimensions or {width = self.width or g.getWidth(), height = self.height or g.getHeight()}
  self.z = self.z or 0
  if self.image then self.image = g.newImage(self.image) end
  self.objects = self.objects or {}
end

function Layer:update(dt)
  for i,object in ipairs(self.objects) do
    object:update(dt)
  end
end

function Layer:render()
  if self.image then
    g.setColor(255,255,255)
    g.draw(self.image)
  end

  -- for debugging, we probably shouldn't be drawing the actualy physics object on screen
  for i,object in ipairs(self.objects) do
    g.setColor(0,0,255)
    object:draw("fill")
  end
end

function Layer:add_physics_object(objectType, ...)
  assert(self.z == 0, "You can only put physics objects on the zeroth layer.")
  assert(objectType == "circle" or objectType == "rectangle" or objectType == "polygon" or objectType == "point",
    objectType.. " is not a recognized object type.")

  local object = nil

  if objectType == "circle" then
    object = game.Collider:addCircle(...)
  elseif objectType == "rectangle" then
    object = game.Collider:addRectangle(...)
  elseif objectType == "polygon" then
    object = game.Collider:addPolygon(...)
  elseif objectType == "point" then
    object = game.Collider:addPoint(...)
  end

  if object == nil then return object end

  -- dump some stuff into the physics object that I'll probably need later
  object.id = generateID()
  object.velocity = {x = 0, y = 0}
  object.update = function(self, dt) end
  object.apply_gravity = function(self, dt) self.velocity.y = self.velocity.y + (GRAVITY * dt) end
  object.stringify = function(self) return "Physics obj: ".. self.id .. "; velx: ".. self.velocity.x .. "; vely: " .. self.velocity.y end
  table.insert(self.objects, object)
  return object
end

function Layer:__lt(other)
  if self.z < other.z then return true
  elseif self.z == other.z and self.id < other.id then return true
  else return false
  end
end

function Layer:__le(other)
  return self < other
end
