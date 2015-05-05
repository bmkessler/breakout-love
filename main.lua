height = 500
width = 800

speed = 100
math.randomseed( os.time() )
dir = math.random(360)

paddle = {x=width/2, y=height*9/10, speed=200, width=30, height=15} 
ball = {x=width/2, y=height*6/10, radius=10, dx=speed*math.sin(dir), dy =speed*math.cos(dir)}

function love.load()
  love.window.setMode(width,height)
  love.graphics.rectangle("fill", paddle.x, paddle.y, paddle.height, paddle.width )
  love.graphics.setNewFont(12)
  text = "Nothing pressed"
end

function love.update(dt)
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
  if ball.x<ball.radius or ball.x+ball.radius>width then
    ball.dx = -1*ball.dx
  end
  if ball.y<ball.radius or ball.y+ball.radius>height then
    ball.dy = -1*ball.dy
  end
  if ball.dy>0 and ball.x>paddle.x and ball.x<paddle.x+paddle.width and math.abs(ball.y - paddle.y)<ball.radius then
    ball.dy = -1*ball.dy
  end
  ball.x = ball.x + ball.dx*dt
  ball.y = ball.y + ball.dy*dt
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
