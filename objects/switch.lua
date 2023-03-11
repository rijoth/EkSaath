require 'lib.boundingbox'
local switch = _G.object:extend()
function switch:new(x, y)
  self.id = "switch"
  self.x = x
  self.y = y
  self.image = love.graphics.newImage("assets/switch.png")
  self.w = 18
  self.h = 16
  self.active = true
  --
  self.grid_w = 18
  self.grid_h = 16
  self.grid = _G.anim8.newGrid(self.grid_w, self.grid_h, self.image:getWidth(), self.image:getHeight())
  self.frame_on = _G.anim8.newAnimation(self.grid("1-1", 1), 0.1)
  self.frame_off = _G.anim8.newAnimation(self.grid("2-2", 1), 0.1)
  -- 
  _G.world:add(self, self.x, self.y, self.grid_w, self.grid_h)
  -- 
  self.can_shake = true
end

function switch:update(dt)
  -- since querying a rectangle it need to be little bigger
  self.active = true
  local objects, len = _G.world:queryRect(self.x, self.y - 1, self.w, self.h)
  if len > 0 then
    for i =1, len do
      local object = objects[i]
      if object.id == 'player' then
        self.active = false
        -- shake once
        if self.can_shake and object.active then
          _G.sounds.off:play()
          _G.shack:setShake(10)
          self.can_shake = false
        end
        --
      end
    end
  end

  -- to reactivate shake again if player is jumping (basically creating in an rectangle collider 64 pixel above switch)
  local _, len2 = _G.world:queryRect(self.x, self.y - 64, self.w, self.h)
  if len2 > 0 then
    self.can_shake = true
  end
 -- disable other switches also if one is disabled else game bug
--  local items, _ = _G.world:getItems()
--  for _, object in pairs(items) do
--    if object.id == "switch"  then
--        object.active = self.active
--    end
--  end
--
end

function switch:draw()
  if self.active then
    self.frame_on:draw(self.image, self.x, self.y)
  else
    self.frame_off:draw(self.image, self.x, self.y)
  end
end


_G.objects.switch = switch
