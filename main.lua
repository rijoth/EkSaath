--#global imports
_G.object = require 'lib.classic'
_G.push = require 'lib.push'
_G.anim8 = require 'lib.anim8'
_G.bump = require 'lib.bump'
_G.shack = require 'lib.shack' -- screenshake
_G.ser = require 'lib.ser'
_G.sounds = require 'sound' -- sounds
_G.baton = require 'lib.baton'
_G.gamepad = require 'objects.gamepad'
--#global objects table
_G.objects = {}

-- inputs
_G.input = _G.baton.new {
  controls = {
    left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
    right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
    up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
    down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
    jump = {'key:x', 'button:a'},
    switch = {'key:z', 'button:b'},
    pause = {'key:escape', 'button:start'},
    select = {'key:return'},
  },
  pairs = {
    move = {'left', 'right', 'up', 'down'}
  },
  joystick = love.joystick.getJoysticks()[1],
}

-- #scene management
local SceneryInit = require('lib.scenery')
local scenery = SceneryInit(
  { path = "scenes.flash", key = "flash"},
  { path = "scenes.menu"; key="menu" },
  { path= "scenes.game"; key = "game"; },
  { path= "scenes.gameover"; key = "gameover" },
  { path= "scenes.gameend"; key = "gameend" }
)
-- local game = require 'scenes.game'
--
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.graphics.setLineStyle("rough")
--
local gameWidth, gameHeight = love.graphics.getDimensions()
--local windowWidth, windowHeight = love.window.getDesktopDimensions()
local windowWidth, windowHeight = 1280, 720
_G.push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, resizable = false, ... })
--
function love.load()
  scenery:load()
end

function love.update(dt)
  -- baton
  _G.input:update()
  -- scne management
  scenery:update(dt)
end

function love.draw()
  _G.push:start()
-- background
    love.graphics.setColor(31/255, 26/255, 10/255)
    love.graphics.rectangle("fill", 0, 0, _G.push:getWidth(), _G.push:getHeight())
    love.graphics.setColor(1, 1, 1)
-- game
    scenery:draw()
  _G.push:finish()
end

function love.keypressed(key)
  scenery:keypressed(key)
end

function love.keyreleased(key)
  scenery:keyreleased(key)
end

function love.mousepressed(x, y, key)
end

function love.resize(w, h)
  return _G.push:resize(w, h)
end
