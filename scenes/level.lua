local sti = require 'lib.sti'
local camera = require 'lib.camera'
local shack = _G.shack
--
local level = {}
--# objects
require 'objects.player'
require 'objects.box'
require 'objects.spike'
require 'objects.portal'
require 'objects.laser'
require 'objects.switch'
require 'objects.camtarget'
--# new bump world
_G.world = _G.bump.newWorld(32)
--
function level:load(lvl)
  for _, object in ipairs(_G.world:getItems()) do
    _G.world:remove(object)
  end
  --
  self.map_objects = {
    boxes = {},
    spikes = {},
    portals = {},
    lasers = {},
    switches = {},
  } -- hold map objects
  --# map
  -- self.map = sti("tilesets/level4.lua", {"bump"}) --for direct testing
  self.map = sti(lvl, {"bump"}) -- disabled temperoraly for testing enable it back
  self.map:bump_init(_G.world)

  --add ground
  if self.map.layers["obj_ground"] then
    for _, ground in pairs(self.map.layers["obj_ground"].objects) do
      _G.world:add({id = "ground"}, ground.x, ground.y, ground.width, ground.height)
    end
  end
  --add wall
  if self.map.layers["obj_wall"] then
    for _, wall in pairs(self.map.layers["obj_wall"].objects) do
      _G.world:add({id = "wall"}, wall.x, wall.y, wall.width, wall.height)
    end
  end
  -- add boxes
  if self.map.layers["obj_box"] then
    for _, box in pairs(self.map.layers["obj_box"].objects) do
      table.insert(self.map_objects.boxes, _G.objects.box(box.x, box.y))
    end
  end
  -- add switches
  if self.map.layers["obj_switch"] then
    for _, switch in pairs(self.map.layers["obj_switch"].objects) do
      table.insert(self.map_objects.switches, _G.objects.switch(switch.x, switch.y))
    end
  end
  -- add traps
  if self.map.layers["obj_spike"] then
    for _, spike in pairs(self.map.layers["obj_spike"].objects) do
      --table.insert(self.map_objects.spikes, _G.objects.spike(spike.x, spike.y, spike.width, spike.height, spike.class))
      _G.world:add({id = spike.class}, spike.x, spike.y, spike.width, spike.height)
    end
  end
  -- add lasers
  if self.map.layers["obj_laser"] then
    for _, ls in pairs(self.map.layers["obj_laser"].objects) do
      table.insert(self.map_objects.lasers, _G.objects.laser(ls.x, ls.y, ls.width, ls.height, ls.name))
    end
  end
  -- add players
  if self.map.layers["obj_player"] then
    for _, player in pairs(self.map.layers["obj_player"].objects) do
      if player.class == "red" then
        self.player_red = _G.objects.player(player.x, player.y, player.class)
      else
        self.player_blue = _G.objects.player(player.x, player.y, player.class)
      end
    end
  end
  -- add portals
  if self.map.layers["obj_portal"] then
    for _, portal in pairs(self.map.layers["obj_portal"].objects) do
      if portal.name == "red" then
        -- print(portal.name..","..portal.x..","..portal.y..","..portal.width..","..portal.height)
        self.portal_red = _G.objects.portal(portal.x, portal.y, portal.width, portal.height, portal.name)
      else
        self.portal_blue = _G.objects.portal(portal.x, portal.y, portal.width, portal.height, portal.name)
      end
    end
  end

  self.current_player = self.player_red
  self.current_player.active = true

  -- # player active marker sprite and animation
  self.marker_image = love.graphics.newImage("assets/cursor.png")
  self.marker_grid = _G.anim8.newGrid(9, 9, self.marker_image:getWidth(), self.marker_image:getHeight())
  self.marker_animation = _G.anim8.newAnimation(self.marker_grid("1-6", 1), 0.1)

  -- # init camera
  local cw, ch = _G.push:getWidth(), _G.push:getHeight()
  self.camera = camera(cw/2, ch/2, cw, ch)
  self.camera:setFollowLerp(0.2)
  self.camera:setFollowLead(10)
  self.camera:setFollowStyle('LOCKON')
  -- camera bounds from map
  local bw, bh = self.map.width * self.map.tilewidth, self.map.height * self.map.tileheight
  self.camera:setBounds(0, 0, bw, bh)
  -- # screenshake
  shack:setDimensions(_G.push:getDimensions())
  -- cam target (initially pointed to portal)
  self.cam_target = _G.objects.cam_target(self.portal_red.x, self.portal_red.y)
end

function level:update(dt)
  --# update map
  self.map:update(dt)

  --current_player:update(dt)
  self.player_red:update(dt)
  self.player_blue:update(dt)
  self.marker_animation:update(dt)

  -- update objects
  for _, box in pairs(self.map_objects.boxes) do
    box:update(dt)
  end
  for _, laser in pairs(self.map_objects.lasers) do
    laser:update(dt)
  end
  for _, switch in pairs(self.map_objects.switches) do
    switch:update(dt)
  end

  self.portal_red:update(dt)
  self.portal_blue:update(dt)

  -- cam target for smooth camera switch effect
  self.cam_target:update(dt)
  self.cam_target:change(self.current_player.x, self.current_player.y)

  -- update camera
  self.camera:update(dt)
  self.camera:follow(self.cam_target.x, self.cam_target.y)

  -- update shack (screenshake)
  shack:update(dt)
  -- shake camera if player is dead
  local items, _ = _G.world:getItems()
  for _, object in pairs(items) do
    if object.id == "player" then
      if object.death then
        shack:setShake(5)
      end
    end
  end
  --
  for i, switch in pairs(self.map_objects.switches) do
    if not switch.active then
      for j, sw in pairs(self.map_objects.switches) do
        sw.active = false
      end
    end
  end
  --
  -- switch player
  if _G.input:pressed 'switch' then
    self:switch_player()
  end
end

function level:draw()
  --shack:apply() -- draw everything after shack
  -- camera
  self.camera:attach()
  shack:apply()
  --# draw temp tiled layer
  self.map:drawLayer(self.map.layers['tl_bg'])
  self.map:drawLayer(self.map.layers['tl_ground'])
  self.map:drawLayer(self.map.layers['tl_fg'])

  --# draw other objects
  for _, laser in pairs(self.map_objects.lasers) do
    laser:draw()
  end
  for _, box in pairs(self.map_objects.boxes) do
    box:draw()
  end
  for _, switch in pairs(self.map_objects.switches) do
    switch:draw()
  end
  self.portal_red:draw()
  self.portal_blue:draw()
  --# draw players
    self.player_red:draw()
    self.player_blue:draw()
  --#draw an active marker on top of active player if not dead
    if not self.current_player.death then
      self.marker_animation:draw(self.marker_image, self.current_player.x + 8, self.current_player.y - 10)
    end
    -- detach camera
  self.camera:detach()
  -- gamepad
  --_G.gamepad:draw()
end

function level:switch_player()
  self.current_player.vx = 0 -- to prevent player from moving and pushing
  self.current_player.pushing = false
  self.current_player.active = false
  if self.current_player == self.player_red then
    self.current_player = self.player_blue
    self.current_player.active = true
  else
    self.current_player = self.player_red
    self.current_player.active = true
  end
  -- switch cam target to current player
  self.cam_target:change(self.current_player.x, self.current_player.y)
end


return level

