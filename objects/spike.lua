local spike = _G.object:extend()

function spike:new(x, y, w, h, id)
  self.id = id
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  --
  self.vx = 0
  self.vy = 0
  self.gravity = 80
  -- 
  _G.world:add(self, self.x, self.y, self.w, self.h)
end

function spike:update(dt)
  -- update gravity
  --self.vy = self.vy + self.gravity * dt
  --
  local actualX, actualY, cols, len = _G.world:move(self, self.x, self.y, function(item, other)
    if other.id == "player_red" then
      return 'cross'
    end
      --return 'slide'
  end)
end

function spike:draw()
  --love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
  --love.graphics.draw(self.image, self.x + self.w/2, self.y + self.h/2, 0, 1, 1, self.w/2, self.h/2)
end

_G.objects.spike = spike
