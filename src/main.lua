require 'globals'

function love.load()
  if DEBUG_MODE then
    if arg[#arg] == "-debug" then 
      require("mobdebug").start() 
    end
    io.stdout:setvbuf("no")
  end
  
  math.randomseed(os.time())

  -- use nearest-neighbor (point) filtering on upscaling and downscaling to prevent blurring of text and 
  -- graphics instead of the bilinear filter that is applied by default 
  love.graphics.setDefaultFilter('nearest', 'nearest')
  
  -- Set up window
  push:setupScreen(VIRTUAL_SIZE.x, VIRTUAL_SIZE.y, WINDOW_SIZE.x, WINDOW_SIZE.y, {
    vsync = true,
    fullscreen = MOBILE_OS,
    resizable = not (MOBILE_OS or WEB_OS),
    stencil = not WEB_OS and true or false
  })
  love.window.setTitle(GAME_TITLE)

  -- new Box2D "world" which will run all of our physics calculations
  world = love.physics.newWorld(0, 300)

  -- body that stores velocity and position and all fixtures
  boxBody = love.physics.newBody(world, VIRTUAL_SIZE.x / 2, VIRTUAL_SIZE.y / 2, 'dynamic')

  -- shape that we will attach using a fixture to our body for collision detection
  boxShape = love.physics.newRectangleShape(10, 10)

  -- fixture that attaches a shape to our body
  boxFixture = love.physics.newFixture(boxBody, boxShape)
  boxFixture:setRestitution(0.5) -- defines "bounciness"
  
  -- static ground body
  groundBody = love.physics.newBody(world, 0, VIRTUAL_SIZE.y - 30, 'static')
  
  -- edge shape Box2D provides, perfect for ground
  edgeShape = love.physics.newEdgeShape(0, 0, VIRTUAL_SIZE.x, 0)
  
  -- affix edge shape to our body
  groundFixture = love.physics.newFixture(groundBody, edgeShape)
  
  love.keyboard.keysPressed = {}
end

function love.update(dt)
  -- exit if esc is pressed
  if love.keyboard.keysPressed['escape'] then
    love.event.quit()
  end
  
  -- update world, calculating collisions
  world:update(dt)
  
  love.keyboard.keysPressed = {}
end

function love.resize(w, h)
  push:resize(w, h)
end
  
-- Callback that processes key strokes just once
-- Does not account for keys being held down
function love.keypressed(key)
  love.keyboard.keysPressed[key] = true
end

function love.draw()
  push:start()
  
  -- draw a polygon shape by getting the world points for our body, using the box shape's
  -- definition as a reference
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.polygon('fill', boxBody:getWorldPoints(boxShape:getPoints()))
  
  -- draw a line that represents our ground, calculated from ground body and edge shape
  love.graphics.setColor(1, 0, 0, 1)
  love.graphics.setLineWidth(2)
  love.graphics.line(groundBody:getWorldPoints(edgeShape:getPoints()))
  
  push:finish()
end