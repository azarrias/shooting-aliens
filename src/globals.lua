-- libraries
Class = require 'libs.class'
push = require 'libs.push'
tiny = require 'libs.tiny'

-- general purpose / utility
require 'Alien'
require 'Background'
require 'Level'
require 'Obstacle'
require 'Player'
require 'ScenePlay'
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
ALIEN_SQUARE_SIZE = 35
ALIEN_ROUND_RADIUS = 17.5
TILE_SIZE = 35

-- resources
FONTS = {
  ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
  ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
  ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
  ['huge'] = love.graphics.newFont('fonts/font.ttf', 64)
}

TEXTURES = {
  ['aliens'] = love.graphics.newImage('graphics/aliens.png'), 
  ['blue-desert'] = love.graphics.newImage('graphics/blue_desert.png'), 
  ['blue-grass'] = love.graphics.newImage('graphics/blue_grass.png'), 
  ['blue-land'] = love.graphics.newImage('graphics/blue_land.png'), 
  ['blue-shroom'] = love.graphics.newImage('graphics/blue_shroom.png'), 
  ['colored-desert'] = love.graphics.newImage('graphics/colored_desert.png'), 
  ['colored-grass'] = love.graphics.newImage('graphics/colored_grass.png'), 
  ['colored-land'] = love.graphics.newImage('graphics/colored_land.png'), 
  ['colored-shroom'] = love.graphics.newImage('graphics/colored_shroom.png'),
  ['tiles'] = love.graphics.newImage('graphics/tiles.png'),
  ['wood'] = love.graphics.newImage('graphics/wood.png')
}

QUADS = {
  ['aliens'] = GenerateQuads(TEXTURES['aliens'], 3, 5, tiny.Vector2D(35, 35)),
  ['tiles'] = GenerateAllQuads(TEXTURES['tiles'], TILE_SIZE, TILE_SIZE),
  ['wood-horizontal-damaged'] = GenerateQuads(TEXTURES['wood'], 1, 1, tiny.Vector2D(110, 35))[1],
  ['wood-horizontal-intact'] = GenerateQuads(TEXTURES['wood'], 1, 1, tiny.Vector2D(110, 35), tiny.Vector2D(0, 35))[1],
  ['wood-vertical-damaged'] = GenerateQuads(TEXTURES['wood'], 1, 1, tiny.Vector2D(35, 110), tiny.Vector2D(320, 180))[1],
  ['wood-vertical-intact'] = GenerateQuads(TEXTURES['wood'], 1, 1, tiny.Vector2D(35, 110), tiny.Vector2D(355, 355))[1]
}