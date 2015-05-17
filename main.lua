-- A one-level infinite-life Breakout port to Love2D
-- Author: Brian Kessler
-- Version: 2.0.0
-- Date: 2015-05-06
-- License: https://www.gnu.org/licenses/gpl.html 

function love.load()
-- setup the playing window
  height = 500
  width = 800
  love.window.setMode(width,height)
  love.graphics.setNewFont(12)
  world = love.physics.newWorld(0, 0, true)
  world:setCallbacks(beginContact)
-- top wall zero friction for perfectly inelastic collisions
  topwall = {}
  topwall.body = love.physics.newBody(world, width/2, 0, "static")
  topwall.shape = love.physics.newRectangleShape(width, 10)
  topwall.fixture = love.physics.newFixture(topwall.body, topwall.shape)
  topwall.fixture:setFriction(0.0) -- don't slow the ball down
-- left wall
  leftwall = {}
  leftwall.body = love.physics.newBody(world, 0, height/2, "static")
  leftwall.shape = love.physics.newRectangleShape(10, height)
  leftwall.fixture = love.physics.newFixture(leftwall.body, leftwall.shape)
  leftwall.fixture:setFriction(0.0)
-- right wall
  rightwall = {}
  rightwall.body = love.physics.newBody(world, width, height/2, "static")
  rightwall.shape = love.physics.newRectangleShape(10, height)
  rightwall.fixture = love.physics.newFixture(rightwall.body, rightwall.shape)
  rightwall.fixture:setFriction(0.0)
 
-- create the pieces
  ball = {}
  ball.radius = 5
  ball.x = width/2-ball.radius
  ball.y = height*6/10
  ball.body = love.physics.newBody(world, ball.x, ball.y, "dynamic")
  ball.shape = love.physics.newCircleShape(ball.radius)
  ball.fixture = love.physics.newFixture(ball.body, ball.shape) 
  ball.body:setBullet(true)  -- make sure it won't go through the paddle
  ball.fixture:setRestitution(1.0)  -- make it infinitely bouncy
-- the paddle
  paddle = {}
  paddle.speed = 200
  paddle.width = 40
  paddle.height = 10
  paddle.x = width/2-paddle.width/2
  paddle.y = height*9/10
  paddle.body = love.physics.newBody(world, paddle.x, paddle.y, "static")  -- paddle won't be affected by collisions
  paddle.shape = love.physics.newRectangleShape(paddle.width, paddle.height)
  paddle.fixture = love.physics.newFixture(paddle.body, paddle.shape)
  paddle.fixture:setFriction(0.0)

  initializePositions()

-- load the sound effect
  blop = love.audio.newSource("blop.wav", "static")
end

function love.update(dt)
  if state=="playing" then
    world:update(dt)
    movePaddle(dt)
    detectLoss()
  end
end

function love.draw()
-- draw the text
  love.graphics.setColor(255,255,255,255)
  love.graphics.print( text, 230, 320 )
-- draw the paddle  
  love.graphics.setColor(255,255,0,255)
--  love.graphics.rectangle("fill", paddle.body:getX(), paddle.body:getY(), paddle.width, paddle.height)
  love.graphics.polygon("fill", paddle.body:getWorldPoints(paddle.shape:getPoints()))
-- draw the ball
  love.graphics.setColor(255,255,255,255)
  love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())
end

function love.keypressed(key)
   if key == 'escape' then
      love.event.push('quit')
   elseif state == "ready" then
      state = "playing"
      text = ""
   end
end

function movePaddle(dt)
  if love.keyboard.isDown( "right" ) then
    if paddle.body:getX()+paddle.width/2<width then
      paddle.body:setX(paddle.body:getX() + paddle.speed*dt)
    end
  elseif love.keyboard.isDown( "left" ) then
    if paddle.body:getX()-paddle.width/2>0 then
      paddle.body:setX(paddle.body:getX() - paddle.speed*dt)
    end
  end
end

function detectLoss()
  -- detect ball off the bottom of the screen
  if ball.body:getY()>height then
    initializePositions()
  end
end

function beginContact(a, b, coll)
       blop:play()
end

function initializePositions()
-- reset to ready
  state="ready"
-- set text to display instructions
  text = "Use arrow keys to move. Press any key to start."
-- initialize the paddle postion
  paddle.body:setX(paddle.x)
  paddle.body:setY(paddle.y)
-- initialize the ball position
  ball.body:setX(ball.x)
  ball.body:setY(ball.y)
-- randomize the direction but always down
  speed = 150
  math.randomseed( os.time() )
  dir = math.random(360)
  ball.dx = speed*math.sin(dir)
  ball.dy = speed*math.abs(math.cos(dir))
  ball.body:setLinearVelocity( ball.dx, ball.dy )
end
