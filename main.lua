height = 500
width = 800


state = "ready"

paddle = {}
ball = {}
state = "ready"
blop = love.audio.newSource("blop.wav", "static")

function love.load()
  love.window.setMode(width,height)
  love.graphics.setNewFont(12)
  initializePositions()
  text = "Nothing pressed"
end

function love.update(dt)
  if state=="playing" then
    movePaddle(dt)
    detectCollision()
    moveBall(dt)
  end
end

function love.draw()
  love.graphics.setColor(255,255,255,255)
  love.graphics.rectangle("fill", paddle.x, paddle.y, paddle.width, paddle.height)
  love.graphics.print( text, 330, 300 )
  love.graphics.print("ball.x: " .. ball.x, 330, 200)
  love.graphics.print("ball.y: " .. ball.y, 330, 210)
  love.graphics.print("paddle.x: " .. paddle.x, 330, 220)
  love.graphics.print("paddle.y: " .. paddle.y, 330, 230)
  love.graphics.setColor(255,255,0,255)
  love.graphics.circle("fill", ball.x, ball.y, ball.radius)
  
end

function love.keypressed(key)
   if state == "ready" then
      state = "playing"
      
   end
end

function movePaddle(dt)
  if love.keyboard.isDown( "right" ) then
    text = "The RIGHT Arrow key is held down!"
    if paddle.x+paddle.width<width then
      paddle.x = paddle.x + paddle.speed*dt
    end
  elseif love.keyboard.isDown( "left" ) then
    text = "The LEFT Arrow key is held down!"
    if paddle.x>0 then
      paddle.x = paddle.x - paddle.speed*dt
    end
  else
    text = "Nothing pressed"
  end
end

function moveBall(dt)
  ball.x = ball.x + ball.dx*dt
  ball.y = ball.y + ball.dy*dt
end

function detectCollision()
  -- detect collision with the wall
  if ball.x<ball.radius or ball.x+ball.radius>width then
    ball.dx = -1*ball.dx
    blop:play()
  end
  if ball.y<ball.radius then
    ball.dy = -1*ball.dy
    blop:play()
  end
  if ball.y-ball.radius>height then
    state = "ready"
    initializePositions()
  end
  -- detect collision with the paddle
  if ball.dy>0 and ball.x>paddle.x and ball.x<paddle.x+paddle.width and math.abs(ball.y - paddle.y)<ball.radius then
    ball.dy = -1*ball.dy
    blop:play()
  end
end

function initializePositions()
-- initialize the paddle postion
  paddle.x = width/2
  paddle.y = height*9/10
  paddle.speed = 200
  paddle.width = 40
  paddle.height = 10
-- initialize the ball position and randomize direction
  ball.x = width/2
  ball.y = height*6/10
  ball.radius = 5
  speed = 150
  math.randomseed( os.time() )
  dir = math.random(360)
  ball.dx = speed*math.sin(dir)
  ball.dy = speed*math.abs(math.cos(dir))
end
