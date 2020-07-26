Level = Class{}

function Level:init()
  -- background
  self.background = Background()
end

function Level:update(dt)
end

function Level:render()
  self.background.gameObject:render()
end