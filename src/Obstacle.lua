Obstacle = Class{}

function Obstacle:init(world, orientation, x, y)
  self.world = world
  
  local posX = x
  local posY = y
  self.body = love.physics.newBody(self.world, posX, posY, 'dynamic')
  self.gameObject = tiny.Entity(posX, posY)
  self.orientation = orientation
  
  if orientation == 'horizontal' then
    self.width = 110
    self.height = 35
  elseif orientation == 'vertical' then
    self.width = 35
    self.height = 110
  end
  
  self.shape = love.physics.newRectangleShape(self.width, self.height)
  local quad = 'wood-'..orientation..'-intact'
  local sprite = tiny.Sprite(TEXTURES['wood'], QUADS[quad])
  self.gameObject:AddComponent(sprite)
  
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData('Obstacle')
end

function Obstacle:update(dt)
  self.gameObject.position.x = self.body:getX()
  self.gameObject.position.y = self.body:getY()
  self.gameObject.rotation = self.body:getAngle()
end

function Obstacle:render()
  self.gameObject:render()
end