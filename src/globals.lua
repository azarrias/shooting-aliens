-- libraries
Class = require 'libs.class'
push = require 'libs.push'
tiny = require 'libs.tiny'

-- general purpose / utility
require 'Alien'
require 'SceneStart'
require 'util'

--[[
    constants
  ]]
GAME_TITLE = 'Shooting Aliens'
DEBUG_MODE = true

-- OS checks in order to make necessary adjustments to support multiplatform
MOBILE_OS = (love._version_major > 0 or love._version_minor >= 9) and (love.system.getOS() == 'Android' or love.system.getOS() == 'OS X')
WEB_OS = (love._version_major > 0 or love._version_minor >= 9) and love.system.getOS() == 'Web'
  
-- pixels resolution
WINDOW_SIZE = tiny.Vector2D(1280, 720)
VIRTUAL_SIZE = tiny.Vector2D(640, 360)

-- resources
TEXTURES = {
  ['aliens'] = love.graphics.newImage('graphics/aliens.png'), 
  ['blue-desert'] = love.graphics.newImage('graphics/blue_desert.png'), 
  ['blue-grass'] = love.graphics.newImage('graphics/blue_grass.png'), 
  ['blue-land'] = love.graphics.newImage('graphics/blue_land.png'), 
  ['blue-shroom'] = love.graphics.newImage('graphics/blue_shroom.png'), 
  ['colored-desert'] = love.graphics.newImage('graphics/colored_desert.png'), 
  ['colored-grass'] = love.graphics.newImage('graphics/colored_grass.png'), 
  ['colored-land'] = love.graphics.newImage('graphics/colored_land.png'), 
  ['colored-shroom'] = love.graphics.newImage('graphics/colored_shroom.png')
}

QUADS = {
  ['aliens'] = GenerateQuads(TEXTURES['aliens'], 1, 5, tiny.Vector2D(35, 35))
}