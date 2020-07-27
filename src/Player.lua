Player = Class{}

function Player:init(alien)
  self.alien = alien
  self.alien.body:setType('static')
  -- coordinates to calculate launch vector impulse
  self.initialPosition = tiny.Vector2D(self.alien.gameObject.position.x, self.alien.gameObject.position.y)
  self.draggingPosition = tiny.Vector2D(self.alien.gameObject.position.x, self.alien.gameObject.position.y)
  self.aiming = false
  self.launched = false
end

function Player:update(dt)
  self.alien:update(dt)
end

function Player:render()
  self.alien:render()
end

function Player:Aim(x, y)
  self.draggingPosition.x = math.min(self.initialPosition.x + 30,
    math.max(x, self.initialPosition.x - 30))
  self.draggingPosition.y = math.min(self.initialPosition.y + 30,
    math.max(y, self.initialPosition.y - 30))
end

function Player:Launch()
  self.launched = true
  self.alien.body:setType('dynamic')
  self.alien.body:setLinearVelocity((self.initialPosition.x - self.draggingPosition.x) * 10, 
    (self.initialPosition.y - self.draggingPosition.y) * 10)
  
  -- set player bounciness
  self.alien.fixture:setRestitution(0.4)
  self.alien.body:setAngularDamping(1)
  self.aiming = false
end