Alien = Class{}

function Alien:init(world, shape, x, y, userData)
  self.world = world
  
  local posX = x or math.random(VIRTUAL_SIZE.x)
  local posY = y or math.random(VIRTUAL_SIZE.y - ALIEN_SQUARE_SIZE)
  self.body = love.physics.newBody(self.world, posX, posY, 'dynamic')
  self.gameObject = tiny.Entity(posX, posY)
  
  shape = shape or 'square'
  local quad
  if shape == 'square' then
    self.shape = love.physics.newRectangleShape(ALIEN_SQUARE_SIZE, ALIEN_SQUARE_SIZE)
    quad = math.random(5)
  elseif shape == 'round' then
    self.shape = love.physics.newCircleShape(ALIEN_ROUND_RADIUS)
    quad = 9
  end
  
  local sprite = tiny.Sprite(TEXTURES['aliens'], QUADS['aliens'][quad])
  self.gameObject:AddComponent(sprite)
  
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(userData)
end

function Alien:update(dt)
  self.gameObject.position.x = self.body:getX()
  self.gameObject.position.y = self.body:getY()
  self.gameObject.rotation = self.body:getAngle()
end

function Alien:render()
  self.gameObject:render()
end