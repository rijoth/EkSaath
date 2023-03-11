local box = _G.object:extend()

function box:new(x, y)
  self.id = "box"
  self.x = x
  self.y = y
  self.image = love.graphics.newImage("assets/box.png")
  self.w = self.image:getWidth()
  self.h = self.image:getHeight()
  --
  self.vx = 0
  self.vy = 0
  self.gravity = 80
  -- 
  _G.world:add(self, self.x, self.y, self.w, self.h)
end

function box:update(dt)
  -- update gravity
  self.vy = self.vy + self.gravity * dt
  --
  local actualX, actualY, cols, len = _G.world:move(self, self.x, self.y + self.vy * dt,function(item, other)
    return 'slide'
  end)
  if #cols > 0 then
    for i=1, len do
      if cols[i].other.id == "ground" then
        self.vy = 0
        self.vx = 0
      end
    end
  end

  self.y = actualY

end

function box:draw()
  love.graphics.draw(self.image, self.x + self.w/2, self.y + self.h/2, 0, 1, 1, self.w/2, self.h/2)
end

_G.objects.box = box
