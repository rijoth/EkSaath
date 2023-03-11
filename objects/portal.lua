local portal = _G.object:extend()

function portal:new(x, y, w, h, type)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  self.type = type or "red"
  self.id = "portal"
  self.active = false
  -- # animation
  self.grid_w = 42
  self.grid_h = 27
  if self.type == "red" then
    self.image = love.graphics.newImage("assets/portal_red.png")
  else
    self.image = love.graphics.newImage("assets/portal_blue.png")
  end
  self.grid = _G.anim8.newGrid(self.grid_w, self.grid_h, self.image:getWidth(), self.image:getHeight())
  self.animations = {
    idle = anim8.newAnimation(self.grid("1-4", 1), 0.1),
    active = anim8.newAnimation(self.grid("5-8", 1), 0.1),
  }
  self.current_animation = self.animations.idle
  -- add to world
  _G.world:add(self, self.x, self.y, self.w, self.h)
end

function portal:update(dt)
  self.active = false
  local objects, len = _G.world:queryRect(self.x, self.y - 1, self.w, self.h + 1)
  if len > 0 then
    for i =1, len do
      local object = objects[i]
      if object.id == 'player' and object.type == self.type then
        self.active = true
      end
    end
  end
  -- update animation
  self.current_animation:update(dt)
  if self.active then
    self.current_animation = self.animations.active
  else
    self.current_animation = self.animations.idle
  end
  --
end

function portal:draw()
  self.current_animation:draw(self.image, self.x, self.y - 15)--, 0, 1, 1, self.w/2, self.h/2)
  --love.graphics.rectangle('line',self.x, self.y, self.w, self.h)
end

_G.objects.portal = portal
