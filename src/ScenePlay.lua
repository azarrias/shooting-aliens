ScenePlay = Class{__includes = tiny.Scene}

function ScenePlay:init()
  self.level = Level()
end

function ScenePlay:update(dt)
  self.level:update(dt)
  
  if not self.level.player.launched then
    local x, y = push:toGame(love.mouse.getPosition())
    
    -- if the mouse is clicked and the player has not been launched,
    -- aim using the mouse coordinates
    if love.mouse.buttonPressed[1] then
      self.level.player.aiming = true

    -- if the mouse is released, launch the player
    elseif love.mouse.buttonReleased[1] and self.level.player.aiming then
      self.level.player:Launch()
  
    elseif self.level.player.aiming then
      self.level.player:Aim(x, y)
    end
  end
    
end

function ScenePlay:render()
  self.level:render()
end