SceneStart = Class{__includes = tiny.Scene}

function SceneStart:init()
  -- background
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
  
  -- physics world
  self.world = love.physics.newWorld(0, 300)
  
  -- ground
  self.groundBody = love.physics.newBody(self.world, 0, VIRTUAL_SIZE.y, 'static')
  self.groundShape = love.physics.newEdgeShape(0, 0, VIRTUAL_SIZE.x, 0)
  self.groundFixture = love.physics.newFixture(self.groundBody, self.groundShape)
  
  -- walls
  self.leftWallBody = love.physics.newBody(self.world, 0, 0, 'static')
  self.rightWallBody = love.physics.newBody(self.world, VIRTUAL_SIZE.x, 0, 'static')
  self.wallShape = love.physics.newEdgeShape(0, 0, 0, VIRTUAL_SIZE.y)
  self.leftWallFixture = love.physics.newFixture(self.leftWallBody, self.wallShape)
  self.rightWallFixture = love.physics.newFixture(self.rightWallBody, self.wallShape)
  
  -- aliens
  self.aliens = {}
  for i = 1, 100 do
    table.insert(self.aliens, Alien(self.world))
  end
end

function SceneStart:update(dt)
  -- first update physics world, then the aliens game objects
  self.world:update(dt)
  for i = 1, #self.aliens do
    self.aliens[i]:update(dt)
  end
end

function SceneStart:render()
  self.backgroundGameObject:render()
  for k, alien in pairs(self.aliens) do
    alien:render()
  end
end