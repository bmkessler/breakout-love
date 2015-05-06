height = 500
width = 800


state = "ready"

paddle = {}
ball = {}
state = "ready"
blop = love.audio.newSource("blop.wav", "static")

blocks = {}
for i=1,19 do
    for j=1,5 do
        local block = {}
        block.width = 40
        block.height = 20
        block.x = (i-1) * (block.width + 2)
        block.y = (j-1) * (block.height + 2) + 100
        block.magenta = (5-j)*255/4
        block.yellow = (j-1)*255/4
        table.insert(blocks, block)
    end
end

function love.load()
  love.window.setMode(width,height)
  love.graphics.setNewFont(12)
  initializePositions()
  text = "Nothing pressed"
end

function love.update(dt)
  if table.getn(blocks) == 0 then
    state = "won"
    text = "You won!"
  end
  if state=="playing" then
    movePaddle(dt)
    detectCollision()
    moveBall(dt)
  end
end

function love.draw()
-- draw the debug text
  love.graphics.setColor(255,255,255,255)
  love.graphics.print("ball.x: " .. ball.x, 330, 250)
  love.graphics.print("ball.y: " .. ball.y, 330, 260)
  love.graphics.print("paddle.x: " .. paddle.x, 330, 270)
  love.graphics.print("paddle.y: " .. paddle.y, 330, 280)
  love.graphics.print( text, 330, 320 )
  love.graphics.print("blocks left:" .. table.getn(blocks), 330, 350)
-- draw the paddle  
  love.graphics.setColor(255,255,0,255)
  love.graphics.rectangle("fill", paddle.x, paddle.y, paddle.width, paddle.height)
-- draw the ball
  love.graphics.setColor(255,255,255,255)
  love.graphics.circle("fill", ball.x, ball.y, ball.radius)
-- draw the blocks
  for i,v in ipairs(blocks) do
    love.graphics.setColor(0,v.magenta,v.yellow,255)
    love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
  end

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
  -- detect collision with the blocks
  for i,v in ipairs(blocks) do
    if ball.dy>0 and ball.y+ball.radius>v.y and ball.y<v.y+v.height and ball.x>v.x and ball.x<v.x+v.width then
      ball.dy = -1* ball.dy
      table.remove(blocks,i)
      blop:play()
    end
    if ball.dy<0 and ball.y-ball.radius<v.y+v.height and ball.y>v.y and ball.x>v.x and ball.x<v.x+v.width then 
      ball.dy = -1* ball.dy 
      blop:play() 
      table.remove(blocks,i)
    end
  end

end

function initializePositions()
-- initialize the paddle postion
  paddle.speed = 200
  paddle.width = 40
  paddle.height = 10
  paddle.x = width/2-paddle.width/2
  paddle.y = height*9/10
-- initialize the ball position and randomize direction
  ball.radius = 5
  ball.x = width/2-ball.radius
  ball.y = height*6/10
  speed = 150
  math.randomseed( os.time() )
  dir = math.random(360)
  ball.dx = speed*math.sin(dir)
  ball.dy = speed*math.abs(math.cos(dir))
end
