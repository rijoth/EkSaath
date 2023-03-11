local gamepad = {}

function gamepad:load()
  self.dir_buttons = {
    {id = "left", x = 16, y = _G.push:getHeight() - 64, w = 32, h = 24, pressed = false},
    {id = "right", x = 68, y = _G.push:getHeight() - 64, w = 32, h = 24, pressed = false},
    {id = "jump", x = _G.push:getWidth() - 72, y = _G.push:getHeight() - 64, w = 32, h = 32, pressed = false},
    {id = "switch", x = _G.push:getWidth() - 172, y = _G.push:getHeight() - 64, w = 32, h = 32, pressed = false},
  }
end

function gamepad:update(dt)
  for _, btn in pairs(self.dir_buttons) do
    btn.pressed = false
  end
  --
  if love.system.getOS() == "Android" then
    for _, touch in ipairs(love.touch.getTouches()) do
      local touch_x, touch_y = _G.push:toGame(love.touch.getPosition(touch))
      for _, btn in pairs(self.dir_buttons) do
        if touch_x > btn.x and touch_x < btn.x + btn.w and touch_y > btn.y and touch_y < btn.y + btn.h then
          btn.pressed = true
        end
      end
    end
  else
    if love.mouse.isDown(1) then
      local touch_x, touch_y = _G.push:toGame(love.mouse.getPosition())
      for _, btn in pairs(self.dir_buttons) do
        if touch_x > btn.x and touch_x < btn.x + btn.w and touch_y > btn.y and touch_y < btn.y + btn.h then
          btn.pressed = true
        end
      end
    end
  end
--
end

function gamepad:isDown()
  for _, btn in pairs(self.dir_buttons) do
    if btn.pressed then
      return btn.id
    end
  end
 --
end

function gamepad:draw()
  for _, button in pairs(self.dir_buttons) do
    love.graphics.rectangle("fill", button.x, button.y, button.w, button.h)
  end
end

return gamepad
