local player = _G.object:extend()
local anim8 = _G.anim8
--
local input = _G.input
--
function player:new(x, y, type)
  self.x = x
  self.y = y
  self.w = 19
  self.h = 32
  self.flip = 1
  self.type = type
  self.active = false
  self.id = "player"
  --
  self.vx = 0
  self.vy = 0
  self.speed = 110
  self.jumping = false
  self.pushing = false
  self.jump_speed = -160
  self.gravity = 300
  --
  self.death = false
  --#change sprites based on type
  if self.type == "red" then
    self.image = love.graphics.newImage("assets/player_red.png")
  else
    self.image = love.graphics.newImage("assets/player_blue.png")
  end
  self.grid = anim8.newGrid(32, 32, self.image:getWidth(), self.image:getHeight())
  self.animations = {
    idle = anim8.newAnimation(self.grid("1-4", 1), 0.1),
    run  = anim8.newAnimation(self.grid("1-6", 2), 0.1),
    jump = anim8.newAnimation(self.grid("1-8", 3), 0.1),
    push = anim8.newAnimation(self.grid("1-6", 4), 0.1),
    death = anim8.newAnimation(self.grid("1-8", 5), 0.1)
  }
  self.current_animation = self.animations.idle
  -- # add player to the world
  _G.world:add(self, self.x, self.y, self.w, self.h)
  --
  --_G.gamepad:load()
end

function player:update(dt)
  --
  --_G.gamepad:update(dt)
  --#player active then do the movements
  if self.active then
    -- handling keypresses
    local x, y = _G.input:get 'move'
    if x < 0 then --or _G.gamepad:isDown() == "left" then
      self.vx = -self.speed
      self.flip = -1
    elseif x > 0 then --or _G.gamepad:isDown() == "right" then
      self.vx = self.speed
      self.flip = 1
    else
      self.vx = 0
    end
    if _G.input:pressed 'jump' and not self.jumping then --or _G.gamepad:isDown() == "jump" and not self.jumping then
      _G.sounds.jump:play()
      self.vy = self.jump_speed
      self.jumping = true
      _G.shack:setShake(2)
    end
  end
  -- if key release then no pushing
  if _G.input:released "move" then
    self.pushing = false
  end
  --# update gravity
  self.vy = self.vy + self.gravity * dt
  --# actual movement
  local actualX, actualY, cols, len = _G.world:move(self, self.x + self.vx * dt, self.y + self.vy * dt,
  function (item, other)
    if other.id == "player" then
      return 'cross'
   -- elseif other.id == "laser" and other.type ~= self.type and other.active then
   --   return 'cross'
   -- elseif other.id == "laser" and not other.active then
   --   return 'cross'
    else
      return 'slide'
    end
  end)
  --# collision resolution
  if #cols > 0 then
    for i=1, len do
      -- reset switch shake
      if cols[i].other.id == "ground" and self.active then
        local items, _ = _G.world:getItems()
        for _, object in pairs(items) do
          if object.id == "switch" then
            if not object.can_shake then
             object.can_shake = true
            end
          end
        end
      end
      --
      if cols[i].other.id == "ground" or cols[i].other.id == "box" or cols[i].other.id == "switch"
      or cols[i].other.id == "portal" or  string.match(cols[i].other.id, "spike")
      then
        self.vy = 0
        self.jumping = false
      end
      -- there is a matching color pattern in self.type and spike id
      if  string.match(cols[i].other.id, self.type) then
        self.death = true
      end
    --
    end
    --
  end

  -- player death change scene
  if self.death and self.current_animation == self.animations.death then
    -- sfx
    if self.current_animation.position > 4 then
      if not _G.sounds.dead:isPlaying() then
        _G.sounds.dead:play()
      end
    end
    -- go to gameover scene
    if self.current_animation.position == 8 then
      setScene("gameover")
    end
  end

  -- # fix platform corner jump
  --actualX, actualY = self:corner_collision(cols, actualX, actualY)

  --# player x and y to actual x and y
  self.x, self.y = actualX, actualY
  --# update animation
  if self.jumping then
    self.current_animation = self.animations.jump
  elseif self.pushing then
    self.current_animation = self.animations.push
  elseif self.death then
    self.current_animation = self.animations.death
  elseif self.vx == 0 then
    self.current_animation = self.animations.idle
  else
    self.current_animation = self.animations.run
  end

  --# update current animation
  self.current_animation:update(dt)
  --# push an object
  self:push(cols, dt)
  ---# sound fx
  self:sfx()
end

function player:draw()
  -- drawing + keeping the image inside collision box
  self.current_animation:draw(self.image, self.x + self.w/2 - 5 * self.flip, self.y + self.h/2, 0,
             self.flip, 1, self.w/2, self.h/2)
  -- debug
  -- love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
  -- _G.gamepad:draw()
end

--# player push an object
function player:push(collisions, dt)
  for _, collision in pairs(collisions) do
    --[[
      if the collider object is box then stores it an object &
        
    --]]
    if collision.other.id == "box" then
      local object = collision.other
      local x, y, w, h = _G.world:getRect(collision.other)
      local player_bottom = self.y + self.h
      if player_bottom > y  then
      --if collision.normal.x == 1 or collision.normal.x == -1 then
        self.pushing = true
        _G.shack:setShake(2) -- small screen shake when pushing
        object.x, object.y, collisions = world:move(object, object.x + self.vx * dt, object.y)
      end
    end
  end
end

-- sound effects
function player:sfx()
  -- jump
  if not self.jumping and love.keyboard.isDown("x") then
    if not _G.sounds.jump:isPlaying() then
      --_G.sounds.jump:play()
    end
    if _G.sounds.walk:isPlaying() then
      _G.sounds.walk:stop()
    end
    -- walk
  elseif love.keyboard.isDown("left") or love.keyboard.isDown("right")
  then
    if not _G.sounds.walk:isPlaying() then
      _G.sounds.walk:play()
    end
  end
end

_G.objects.player = player
