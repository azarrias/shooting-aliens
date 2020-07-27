Player = Class{}

function Player:init(alien)
  self.alien = alien
end

function Player:update(dt)
  self.alien:update(dt)
end

function Player:render()
  self.alien:render()
end