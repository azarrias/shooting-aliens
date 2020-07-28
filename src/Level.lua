Level = Class{}

function Level:init()
  -- create physics world with 300 units of y gravity
  self.world = love.physics.newWorld(0, 300)
  
  -- bodies to be destroyed after the world update cycle; destroying these in the
  -- actual collision callbacks could cause stack overflow and other errors
  self.destroyedBodies = {}
  
  -- ground
  self.groundBody = love.physics.newBody(self.world, 0, VIRTUAL_SIZE.y - TILE_SIZE, 'static')
  self.edgeShape = love.physics.newEdgeShape(0, 0, VIRTUAL_SIZE.x, 0)
  self.groundFixture = love.physics.newFixture(self.groundBody, self.edgeShape)
  self.groundFixture:setFriction(0.5)
  self.groundFixture:setUserData('Ground')
  
  -- aliens
  self.aliens = {}
  table.insert(self.aliens, Alien(self.world, 'square', VIRTUAL_SIZE.x - 80, VIRTUAL_SIZE.y - TILE_SIZE - ALIEN_SQUARE_SIZE / 2, 'Alien'))
  
  -- obstacles
  self.obstacles = {}
  table.insert(self.obstacles, Obstacle(self.world, 'vertical', VIRTUAL_SIZE.x - 120, VIRTUAL_SIZE.y - 35 - 110 / 2))
  table.insert(self.obstacles, Obstacle(self.world, 'vertical', VIRTUAL_SIZE.x - 35, VIRTUAL_SIZE.y - 35 - 110 / 2))
  table.insert(self.obstacles, Obstacle(self.world, 'horizontal', VIRTUAL_SIZE.x - 80, VIRTUAL_SIZE.y - 35 - 110 - 35 / 2))
  
  -- player
  self.player = Player(Alien(self.world, 'round', 90, VIRTUAL_SIZE.y - 100, 'Player'))

  -- background
  self.background = Background()
  
  --[[
      Set functions for collision callbacks during the world update.
      When called, each function will be passed three arguments. 
      The first two arguments are the colliding fixtures and the third 
      argument is the Contact between them. 
  ]]
  -- Gets called when two fixtures begin to overlap.
  function BeginContact(fixtureA, fixtureB, contact)
    local types = {}
    types[fixtureA:getUserData()] = true
    types[fixtureB:getUserData()] = true
    
    -- if obstacle collides with alien, as by debris falling
    if types['Obstacle'] and types['Alien'] then
      local obstacle, alien
      if fixtureA:getUserData() == 'Obstacle' then
        obstacle, alien = fixtureA, fixtureB
      else
        obstacle, alien = fixtureB, fixtureA
      end
      
      -- if the obstacle is fast enough, destroy the alien      
      local velX, velY = obstacle:getBody():getLinearVelocity()
      local sumVel = math.abs(velX) + math.abs(velY)
      if sumVel > 20 then
        table.insert(self.destroyedBodies, alien:getBody())
      end
      
    elseif types['Player'] and types['Alien'] then
      local player, alien
      if fixtureA:getUserData() == 'Player' then
        player, alien = fixtureA, fixtureB
      else
        player, alien = fixtureB, fixtureA
      end
      
      -- if the player is fast enough, destroy the alien
      local velX, velY = player:getBody():getLinearVelocity()
      local sumVel = math.abs(velX) + math.abs(velY)
      if sumVel > 20 then
        table.insert(self.destroyedBodies, alien:getBody())
      end
    end
  end

  -- Gets called when two fixtures cease to overlap. 
  -- This will also be called outside of a world update, when colliding 
  -- objects are destroyed.
  function EndContact(fixtureA, fixtureB, contact)
  end

  -- Gets called before a collision gets resolved.
  function PreSolve(fixtureA, fixtureB, contact)
  end

  -- Gets called after the collision has been resolved.
  function PostSolve(fixtureA, fixtureB, contact, normalImpulse, tangentImpulse)
  end

  self.world:setCallbacks(BeginContact, EndContact, PreSolve, PostSolve)
end

function Level:update(dt)
  self.world:update(dt)
  self.player:update(dt)
  
  -- destroy all bodies we calculated to destroy during the update call
  for k, body in pairs(self.destroyedBodies) do
    if not body:isDestroyed() then 
      body:destroy()
    end
  end
  
  -- reset destroyed bodies to empty table for next update phase
  self.destroyedBodies = {}

  -- remove all destroyed obstacles from level
  for i = #self.obstacles, 1, -1 do
    if self.obstacles[i].body:isDestroyed() then
      table.remove(self.obstacles, i)
    end
  end

  -- remove all destroyed aliens from level
  for i = #self.aliens, 1, -1 do
    if self.aliens[i].body:isDestroyed() then
      table.remove(self.aliens, i)
    end
  end
  
  -- aliens
  for k, alien in pairs(self.aliens) do
    alien:update(dt)
  end
  
  -- obstacles
  for k, obstacle in pairs(self.obstacles) do
    obstacle:update(dt)
  end  
  
  -- respawn player if original body stopped moving, or if went through the left side of the screen
  if self.player.launched then
    local posX, posY = self.player.alien.body:getPosition()
    local velX, velY = self.player.alien.body:getLinearVelocity()
        
    -- if we fired our alien to the left or it's almost done rolling, respawn
    if posX < 0 - ALIEN_SQUARE_SIZE or posX > VIRTUAL_SIZE.x + ALIEN_SQUARE_SIZE or 
        (math.abs(velX) + math.abs(velY) < 1.5) then
      self.player.alien.body:destroy()
      self.player = Player(Alien(self.world, 'round', 90, VIRTUAL_SIZE.y - 100, 'Player'))
            
      -- re-initialize level if we have no more aliens
      if #self.aliens == 0 then
        sceneManager:change('Start')
      end
    end
  end
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
  
  -- draw trajectory preview when the player is aiming before the shot
  if not self.player.launched and self.player.aiming then
    local linearVelocityX = (self.player.initialPosition.x - self.player.draggingPosition.x) * 10
    local linearVelocityY = (self.player.initialPosition.y - self.player.draggingPosition.y) * 10
    
    local trajectoryX, trajectoryY = self.player.draggingPosition.x, self.player.draggingPosition.y
    local gravityX, gravityY = self.world.getGravity(self.world)
    
    -- http://www.iforce2d.net/b2dtut/projected-trajectory
    for i = 1, 90 do
        
      -- magenta color that starts off slightly transparent
      love.graphics.setColor(1, 80 / 255, 1, (1 / 12) * i)
        
      -- trajectory X and Y for this iteration of the simulation
      trajectoryX = self.player.draggingPosition.x + i * 1/60 * linearVelocityX
      trajectoryY = self.player.draggingPosition.y + i * 1/60 * linearVelocityY + 
        0.5 * (i * i + i) * gravityY * 1/60 * 1/60

      -- render every fifth calculation as a circle
      if i % 5 == 0 then
        love.graphics.circle('fill', trajectoryX, trajectoryY, 3)
      end
    end
  end
  
  love.graphics.setColor(1, 1, 1, 1)
  
  -- player
  self.player:render()
  
  -- render instruction text if the alien has not been launched
  if not self.player.launched then
    love.graphics.setFont(FONTS['large'])
    love.graphics.setColor(75 / 255, 75 / 255, 75 / 255, 1)
    love.graphics.printf('Click and drag\ncircular alien to shoot!',
      0, 64, VIRTUAL_SIZE.x, 'center')
    love.graphics.setColor(1, 1, 1, 1)
  end
end