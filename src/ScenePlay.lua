ScenePlay = Class{__includes = tiny.Scene}

function ScenePlay:init()
  self.level = Level()
end

function ScenePlay:update(dt)
  self.level:update(dt)
end

function ScenePlay:render()
  self.level:render()
end