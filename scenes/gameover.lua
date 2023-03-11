local gameover = {}

function gameover:load()
  self.bg_image = love.graphics.newImage("assets/gameover.png")
  --self.font = love.graphics.newFont("assets/font.ttf", 18)
  self.menu_options = {"try again?", "main menu"}
  self.current_sel = 1
end

function gameover:update(dt)
  self:nav()
end

function gameover:draw()
  local scale_x = _G.push:getWidth()/self.pause_image:getWidth()
  local scale_y = _G.push:getHeight()/self.pause_image:getHeight()
  love.graphics.draw(self.bg_image, 0, 0, scale_x, scale_y)
  for i, option in ipairs(self.menu_options) do
    if i == self.current_sel then
      love.graphics.setColor(239/255, 58/255, 12/255)
    end
    love.graphics.print(option, _G.push:getWidth() - 384, _G.push:getHeight() - 210 + i * 20)
    love.graphics.setColor(1, 1, 1)
  end
end

function gameover:nav()
  if _G.input:pressed "up" then
    _G.sounds.nav:play()
    self.current_sel = self.current_sel - 1
    if self.current_sel < 1 then
      self.current_sel = #self.menu_options
    end
  elseif _G.input:pressed "down" then
    _G.sounds.nav:play()
    self.current_sel = self.current_sel + 1
    if self.current_sel > #self.menu_options then
      self.current_sel = 1
    end
  elseif _G.input:pressed "jump" or _G.input:pressed "select" then
    _G.sounds.select:play()
    if self.current_sel == 1 then
      -- if continue pressed then read the fs
      if love.filesystem.getInfo("save.txt") then
        local curr_level = love.filesystem.read("save.txt")
        setScene("game", { level = tonumber(curr_level) })
      else
        setScene("game", { level = 1 })
      end
    else
      setScene("menu")
    end
    --
  end
end

return gameover
