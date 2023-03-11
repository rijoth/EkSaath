local easing = require 'lib.easing'
local cam_target = _G.object:extend()

function cam_target:new(x, y)
  self.x = x
  self.y = y
  self.targetX = x
  self.targetY = y
  self.speed = 300
end

function cam_target:update(dt, x, y)
  -- Move the player towards the self.target position
  local dx = self.targetX - self.x
  local dy = self.targetY - self.y
  local distance = math.sqrt(dx^2 + dy^2)
  if distance > 0.5 then
    local angle = math.atan2(dy, dx)
    local t = math.min(dt * self.speed / distance, 1)
    local easingFunc = easing.out_quad
    --self.x = self.x + math.cos(angle) * self.speed * dt
    --self.y = self.y + math.sin(angle) * self.speed * dt
    self.x = self.x + easingFunc(t) * distance * math.cos(angle)
    self.y = self.y + easingFunc(t) * distance * math.cos(angle)
  end
end

function cam_target:draw()
  love.graphics.rectangle("line", self.x, self.y, 14, 14)
end

function cam_target:change(x, y)
  self.targetX, self.targetY = x, y
end

_G.objects.cam_target = cam_target
