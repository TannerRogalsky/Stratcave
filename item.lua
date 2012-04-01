Item = class('Item', Base)

function Item:initialize(jsonInTableForm)
  Base.initialize(self)

  -- dump the json data into the new object
  for k,v in pairs(jsonInTableForm) do
    self[k] = v
  end

  -- finalize some values with some defaults
end

function Item:update(dt)
  -- self.physics_body:apply_gravity(dt)
  -- self.physics_body.velocity.y = math.clamp(-200, self.physics_body.velocity.y, 200)
  -- self.physics_body:move(self.physics_body.velocity.x * dt, self.physics_body.velocity.y * dt)
end

function Item:render()
end

function Item:init_physics_body(x,y)
  self.x, self.y = x or self.x or 0, y or self.y or 0
  self.physics_body = game.current_level.current_screen.physics_layer:add_physics_object("rectangle", self.x, self.y, 50, 50)
  game.Collider:setPassive(self.physics_body)
  self.physics_body.parent = self
  self.physics_body.item = true
  self.physics_body.on_collide = function(self, ...) self.parent:on_collide(...) end
  return self.physics_body
end

function Item:on_collide(dt, shape_one, shape_two, mtv_x, mtv_y)
  -- print(self, self.physics_body == shape_one, self.physics_body == shape_two)
  game.player.jump_limit = game.player.jump_limit + 1
  game.Collider:setGhost(self.physics_body)
  self.physics_body.render = function(self) end
end
