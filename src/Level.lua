Level = Class{}

function Level:init()
  -- create physics world with 300 units of y gravity
  self.world = love.physics.newWorld(0, 300)
  
  -- ground
  self.groundBody = love.physics.newBody(self.world, 0, VIRTUAL_SIZE.y - TILE_SIZE, 'static')
  self.edgeShape = love.physics.newEdgeShape(0, 0, VIRTUAL_SIZE.x, 0)
  self.groundFixture = love.physics.newFixture(self.groundBody, self.edgeShape)
  self.groundFixture:setFriction(0.5)
  
  -- aliens
  self.aliens = {}
  table.insert(self.aliens, Alien(self.world, 'square', VIRTUAL_SIZE.x - 80, VIRTUAL_SIZE.y - TILE_SIZE - ALIEN_SQUARE_SIZE / 2))
  
  -- obstacles
  self.obstacles = {}
  table.insert(self.obstacles, Obstacle(self.world, 'vertical', VIRTUAL_SIZE.x - 120, VIRTUAL_SIZE.y - 35 - 110 / 2))
  table.insert(self.obstacles, Obstacle(self.world, 'vertical', VIRTUAL_SIZE.x - 35, VIRTUAL_SIZE.y - 35 - 110 / 2))
  table.insert(self.obstacles, Obstacle(self.world, 'horizontal', VIRTUAL_SIZE.x - 80, VIRTUAL_SIZE.y - 35 - 110 - 35 / 2))
  
  -- player
  self.player = Player(Alien(self.world, 'round', 90, VIRTUAL_SIZE.y - 100))

  -- background
  self.background = Background()
end

function Level:update(dt)
  self.world:update(dt)
  self.player:update(dt)
end

function Level:render()
  self.background.gameObject:render()
  
  -- ground tiles
  for x = 0, VIRTUAL_SIZE.x, TILE_SIZE do
    love.graphics.draw(TEXTURES['tiles'], QUADS['tiles'][12], x, VIRTUAL_SIZE.y - TILE_SIZE)
  end
  
  -- aliens
  for k, alien in pairs(self.aliens) do
    alien:render()
  end
  
  -- obstacles
  for k, obstacle in pairs(self.obstacles) do
    obstacle:render()
  end
  
  -- player
  self.player:render()
end