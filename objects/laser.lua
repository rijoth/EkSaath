local laser = _G.object:extend()

function laser:new(x, y, w, h, type)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  self.id = "laser"
  self.type = type
  --
  if self.h > self.w then
    self.orientation = "vertical"
  else
    self.orientation = "horizontal"
  end
  --
  self.active = true
  -- add grid w and all according to orientation
  if self.orientation == "vertical" then
    if self.type == "red" then
      self.image = love.graphics.newImage("assets/laser_redv.png")
    else
      self.image = love.graphics.newImage("assets/laser_bluev.png")
    end
    self.grid_w = 12
    self.grid_h = 46
    --_G.world:add(self, self.x, self.y, self.w, self.h - 10) -- add a small gap in bottom for object to pass
  else
    if self.type == "red" then
      self.image = love.graphics.newImage("assets/laser_redh.png")
    else
      self.image = love.graphics.newImage("assets/laser_blueh.png")
    end
    self.grid_w = 46
    self.grid_h = 12
    --_G.world:add(self, self.x, self.y, self.w, self.h)
  end
  -- 
  self.grid = _G.anim8.newGrid(self.grid_w, self.grid_h, self.image:getWidth(), self.image:getHeight())
  self.animation = anim8.newAnimation(self.grid("1-3", 1), 0.1)
  --
  self.scale_v = self.w/self.grid_w
  self.scale_h = self.h/self.grid_h
end

function laser:update(dt)
  -- update animation
  if self.active then
    self.animation:update(dt)
  end
  -- turn off laser if switch off
  local items, _ = _G.world:getItems()
  for _, obj in pairs(items) do
    if obj.id == "switch" then
      self.active = obj.active
    end
--    if obj.id == "switch" and not obj.active then
--      self.active = false
--    elseif obj.id == "switch" and obj.active then
--      self.active = true
--    end
  end
  -- laser behavior
  local objects, len = _G.world:queryRect(self.x, self.y, self.w, self.h)
  if len > 0 then
    for i =1, len do
      local object = objects[i]
      if object.id == 'player' and object.type == self.type and self.active then --kills player if laser active and color matches
        object.death = true
      end
    end
  end
--
end

function laser:draw()
  if self.active then
    self.animation:draw(self.image, self.x, self.y, 0, self.scale_v, self.scale_h)
  end
end

_G.objects.laser = laser
