Level = Class{}

function Level:init()
  -- create physics world with 300 units of y gravity
  self.world = love.physics.newWorld(0, 300)
  
  -- ground
  self.groundBody = love.physics.newBody(self.world, -VIRTUAL_SIZE.x, VIRTUAL_SIZE.y - ALIEN_SQUARE_SIZE, 'static')
  self.edgeShape = love.physics.newEdgeShape(0, 0, VIRTUAL_SIZE.x, 0)
  self.groundFixture = love.physics.newFixture(self.groundBody, self.edgeShape)
  self.groundFixture:setFriction(0.5)

  -- background
  self.background = Background()
end

function Level:update(dt)
  self.world:update(dt)
end

function Level:render()
  self.background.gameObject:render()
  
  -- ground tiles
  for x = 0, VIRTUAL_SIZE.x, TILE_SIZE do
    love.graphics.draw(TEXTURES['tiles'], QUADS['tiles'][12], x, VIRTUAL_SIZE.y - ALIEN_SQUARE_SIZE)
  end
end