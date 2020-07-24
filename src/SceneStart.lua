SceneStart = Class{__includes = tiny.Scene}

function SceneStart:init()
  local BACKGROUND_TYPES = {
    'colored-land', 'blue-desert', 'blue-grass', 'blue-land', 
    'blue-shroom', 'colored-desert', 'colored-grass', 'colored-shroom'
  }
  local background = BACKGROUND_TYPES[math.random(#BACKGROUND_TYPES)]
  local texture = TEXTURES[background]
  local sprite = tiny.Sprite(texture)
  self.backgroundGameObject = tiny.Entity(VIRTUAL_SIZE.x / 2, VIRTUAL_SIZE.y / 2, 0, 
    VIRTUAL_SIZE.x / texture:getWidth(), VIRTUAL_SIZE.y / texture:getHeight())
  self.backgroundGameObject:AddComponent(sprite)
end

function SceneStart:update(dt)
end

function SceneStart:render()
  self.backgroundGameObject:render()
end