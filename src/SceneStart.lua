SceneStart = Class{__includes = tiny.Scene}

function SceneStart:init()
  -- background
  self.background = Background()
  
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
  
  -- menu title
  self.text = {
    { string = GAME_TITLE, font = FONTS['huge'], color = { 200 / 255, 200 / 255, 200 / 255, 1 }, shadow = true },
    { string = '\nClick to start!', font = FONTS['medium'], color = { 200 / 255, 200 / 255, 200 / 255, 1 }, shadow = true }
  }
end

function SceneStart:update(dt)
  -- first update physics world, then the aliens game objects
  self.world:update(dt)
  for i = 1, #self.aliens do
    self.aliens[i]:update(dt)
  end
  
  -- handle input
  if love.mouse.buttonPressed[1] then
    sceneManager:change('Play')
  end
end

function SceneStart:render()
  self.background.gameObject:render()
  for k, alien in pairs(self.aliens) do
    alien:render()
  end
  
  love.graphics.setColor(64 / 255, 64 / 255, 64 / 255, 200 / 255)
  love.graphics.rectangle('fill', VIRTUAL_SIZE.x / 2 - 270, VIRTUAL_SIZE.y / 2 - 45,
    530, 108, 3)
  RenderCenteredText(self.text)
end