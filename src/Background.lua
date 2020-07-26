Background = Class{}

function Background:init()
  local BACKGROUND_TYPES = {
    'colored-land', 'blue-desert', 'blue-grass', 'blue-land', 
    'blue-shroom', 'colored-desert', 'colored-grass', 'colored-shroom'
  }
  local background = BACKGROUND_TYPES[math.random(#BACKGROUND_TYPES)]
  local texture = TEXTURES[background]
  local sprite = tiny.Sprite(texture)
  self.gameObject = tiny.Entity(VIRTUAL_SIZE.x / 2, VIRTUAL_SIZE.y / 2, 0, 
    VIRTUAL_SIZE.x / texture:getWidth(), VIRTUAL_SIZE.y / texture:getHeight())
  self.gameObject:AddComponent(sprite)
end