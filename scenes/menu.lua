local menu = {}

function menu:load()
  -- for test
  --setScene("game", { level = 1 }) -- remove this
  self.bg_image = love.graphics.newImage("assets/menu_bg.png")
  --self.font = love.graphics.newFont("assets/font.ttf", 18)
  --self.font = love.graphics.newImageFont("assets/font.png",
  --" abcdefghijklmnopqrstuvwxyz" ..
  --"ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
  --"123456789.,!?-+/():;%&`'*#=[]\"")
  --love.graphics.setFont(self.font)
  self.logo = love.graphics.newImage("assets/logo.png")
  --
  self.menu_options = {"play", "continue", "settings", "quit"}
  self.current_sel = 1
  --
  if _G.sounds.bgm.isPlaying then
    _G.sounds.bgm:stop()
  end
end

function menu:update(dt)
  self:nav()
end

function menu:draw()
  love.graphics.draw(self.bg_image, 0, 0)
  for i, option in ipairs(self.menu_options) do
    if i == self.current_sel then
      love.graphics.setColor(239/255, 58/255, 12/255)
    end
    love.graphics.print(option, _G.push:getWidth() - 372, _G.push:getHeight() - 220 + i * 20)
    love.graphics.setColor(1, 1, 1)
  end
  love.graphics.draw(self.logo, _G.push:getWidth() - 410, _G.push:getHeight() - 262)
end

function menu:nav()
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
      setScene("game", { level = 1 })
    elseif self.current_sel == 2 then
      -- if continue pressed then read the fs
      if love.filesystem.getInfo("save.txt") then
        local curr_level = love.filesystem.read("save.txt")
        if tonumber(curr_level) <= 8 then
          setScene("game", { level = tonumber(curr_level) })
        else
          setScene("gameend")
        end
      --else
      --  setScene("game", { level = 1 })
      end
    elseif self.current_sel == 4 then
      love.event.quit(0)
    end
    --
  end
end

return menu
