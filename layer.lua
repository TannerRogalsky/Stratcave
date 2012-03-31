Layer = class('Layer', Base)

function Layer:initialize(jsonInTableForm)
  Base.initialize(self)

  -- dump the json data into the new object
  for k,v in pairs(jsonInTableForm) do
    self[k] = v
  end

  -- finalize some values with some defaults
  self.dimensions = self.dimensions or {width = self.width or g.getWidth(), height = self.height or g.getHeight()}
  self.z = self.z or 0
  if self.image then self.image = g.newImage(self.image) end
  self.objects = self.objects or {} -- this is the json
  self.physics_objects = {}         -- this will be the Collider objects
end

function Layer:update(dt)
  for i,object in ipairs(self.physics_objects) do
    if type(object.update) == "function" then
      object:update(dt)
    end
  end
end

function Layer:render()
  if self.image then
    g.setColor(255,255,255)
    -- g.draw(self.image, 100 * (self.z / 1.6), -100)
    g.draw(self.image, -200, -100)
  end

  -- for debugging, we probably shouldn't be drawing the actual physics objects on screen
  for i,object in ipairs(self.physics_objects) do
    if type(object.render) == "function" then
      object:render()
    elseif object.image then
      g.setColor(255,255,255)
      local x,y = object:bbox()
      g.draw(object.image, x, y)
    else
      g.setColor(0,0,255)
      object:draw("fill")
    end
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
  object.apply_gravity = function(self, dt) self.velocity.y = self.velocity.y + (GRAVITY * dt) end

  -- override any of the metafunctionality of the physics object you want without breaking stuff
  local mt = getmetatable(object)
  mt.__tostring = function(self) return "Physics obj: ".. self.id .. "; velx: ".. self.velocity.x .. "; vely: " .. self.velocity.y end
  setmetatable(object, mt)

  table.insert(self.physics_objects, object)
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
