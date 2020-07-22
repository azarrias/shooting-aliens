-- libraries
Class = require 'libs.class'
push = require 'libs.push'
tiny = require 'libs.tiny'

-- general purpose / utility
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
