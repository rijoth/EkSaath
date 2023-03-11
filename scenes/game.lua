local level = require 'scenes.level'
local game = {}

function game:load(args)
  if args.level ~= nil then
    self.current_lvl = args.level
  else
    self.current_lvl = 1
  end
  --# pause screen
  self.pause = false
  self.pause_image = love.graphics.newImage("assets/pause.png")
  self.pause_options =  {"continue", "main menu"}
  self.pause_sel = 1
  --
  self.red_portal_active = false
  self.blue_portal_active = false
  --
  self.bg_image = love.graphics.newImage("assets/bg.png")
  self.bg_w = _G.push:getWidth()/self.bg_image:getWidth()
  self.bg_h = _G.push:getHeight()/self.bg_image:getHeight()
  --
  level:load("tilesets/level"..self.current_lvl..".lua")
end

function game:update(dt)
  if not self.pause then
    level:update(dt)
    -- change levels if both portals are active
    local items, _ = _G.world:getItems()
    for _, object in pairs(items) do
      if object.id == "portal" then
        if object.type == "red" then
          self.red_portal_active = object.active
        else
          self.blue_portal_active = object.active
        end
      end
    end
    -- # play bgm is not playing
    if not _G.sounds.bgm:isPlaying() then
      _G.sounds.bgm:play()
     end
    --
    if self.red_portal_active and self.blue_portal_active then
      -- play sfx
      if not _G.sounds.teleport:isPlaying() then
        _G.sounds.teleport:play()
      end
      -- rest of code
      self.current_lvl = self.current_lvl + 1
      love.filesystem.write("save.txt", tostring(self.current_lvl)) -- write curr level to save file 
      self.red_portal_active = false
      self.blue_portal_active = false
      if self.current_lvl <= 8 then
        level:load("tilesets/level"..self.current_lvl..".lua")
      else
        setScene("gameend")
      end
    end
    --
  else
    -- if paused stop bgm
    _G.sounds.bgm:pause()
  end

  -- pause function
  if _G.input:pressed 'pause' then
    self.pause = not self.pause
  end
  if self.pause then
    self:pause_control()
  end
  --
end

function game:draw()
  -- draw bg
  love.graphics.draw(self.bg_image, self.x, self.y, 0, self.bg_w, self.bg_h)
  -- draw level
  level:draw()
  -- draw pause state
  if self.pause then
    local scale_x = _G.push:getWidth()/self.pause_image:getWidth()
    local scale_y = _G.push:getHeight()/self.pause_image:getHeight()
    love.graphics.draw(self.pause_image, 0, 0, 0, scale_x, scale_y)
    for i, option in ipairs(self.pause_options) do
      if i == self.pause_sel then
        love.graphics.setColor(239/255, 58/255, 12/255)
      end
      love.graphics.print(option, _G.push:getWidth() - 378, _G.push:getHeight() - 220 + i * 20)
      love.graphics.setColor(1, 1, 1)
    end
  end
end

function game:pause_control()
  if _G.input:pressed 'up' then
    _G.sounds.nav:play()
    self.pause_sel = self.pause_sel - 1
    if self.pause_sel < 1 then
      self.pause_sel = #self.pause_options
    end
  elseif _G.input:pressed 'down' then
    _G.sounds.nav:play()
    self.pause_sel = self.pause_sel + 1
    if self.pause_sel > #self.pause_options then
      self.pause_sel = 1
    end
  elseif _G.input:down 'jump' then
    if self.pause_sel == 1 then
      _G.sounds.select:play()
      self.pause = false
    elseif self.pause_sel == 2 then
      setScene("menu")
    end
  elseif _G.input:pressed 'switch' then
    _G.sounds.select:play()
    self.pause = false
  end
end


return game
