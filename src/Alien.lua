Alien = Class{}

local SQUARE_SIZE = 35

function Alien:init(world, x, y)
  self.world = world
  
  local posX = x or math.random(VIRTUAL_SIZE.x)
  local posY = y or math.random(VIRTUAL_SIZE.y - SQUARE_SIZE)
  self.body = love.physics.newBody(self.world, posX, posY, 'dynamic')
  self.gameObject = tiny.Entity(posX, posY)
  
  self.shape = love.physics.newRectangleShape(SQUARE_SIZE, SQUARE_SIZE)
  local sprite = tiny.Sprite(TEXTURES['aliens'], QUADS['aliens'][math.random(5)])
  self.gameObject:AddComponent(sprite)
  
  self.fixture = love.physics.newFixture(self.body, self.shape)
end

function Alien:update(dt)
  self.gameObject.position.x = self.body:getX()
  self.gameObject.position.y = self.body:getY()
  self.gameObject.rotation = self.body:getAngle()
end

function Alien:render()
  self.gameObject:render()
end