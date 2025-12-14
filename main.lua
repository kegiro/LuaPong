function love.load()
    math.randomseed(os.time())
    
    love.window.setMode(1400, 800)
    love.window.setTitle("Pong!")

    screenWidth = 1400
    screenHeight = 800

    love.graphics.setDefaultFilter("nearest", "nearest")

    scoreFont = love.graphics.newFont(60)

    ball = {}
    ball.r = 10 -- rayon
    ball.x = screenWidth / 2
    ball.y = screenHeight / 2
    ball.original_speed = 400
    ball.speed = 400
    ball.dx = math.random(-350,350)
    ball.dy = math.random(-350,350)

    paddle = {}
    paddle.x = 0
    paddle.y = screenHeight / 2
    paddle.speed = 400
    paddle.width = 20
    paddle.height = 100

    score = 0
    
end

function love.update(dt)
    local x_collision = (ball.x - ball.r <= paddle.x + paddle.width) and (ball.x + ball.r >= paddle.x)
    local y_collision = (ball.y + ball.r >= paddle.y) and (ball.y - ball.r <= paddle.y + paddle.height)
    local moving_left = ball.dx < 0 

    if x_collision and y_collision and moving_left then
        ball.dx = -ball.dx
        ball.x = paddle.x + paddle.width + ball.r

        ball.dx = ball.dx * 1.1
        ball.dy = ball.dy * 1.1

        score = score + 1 
    end

    ball.x = ball.x + ball.dx * dt
    ball.y = ball.y + ball.dy * dt

    local bottomEdge = screenHeight - ball.r
    if ball.y + ball.r >= screenHeight then
        ball.dy = -ball.dy
        ball.y = bottomEdge
    end

    local upEdge = 0 - ball.r
    if ball.y + ball.r <= 0 then
        ball.dy = -ball.dy
        ball.y = upEdge
    end

    local rightEdge = screenWidth - ball.r
    if ball.x + ball.r >= screenWidth then
        ball.dx = -ball.dx
        ball.x = rightEdge
    end

    local leftEdge = 0 - ball.r
    if ball.x + ball.r <= 0 then
        ball.x = screenWidth / 2
        ball.y = screenHeight / 2

        -- looser()

        ball.dx = ball.original_speed
        ball.dy = ball.original_speed

        score = 0
    end

    -- if ball.x and ball.y + ball.r = paddle.x and paddle.y then
    --     ball.dx = -ball.dx
    --     ball.dy = -ball.dy
    -- end

    if love.keyboard.isDown"z" then
        paddle.y = paddle.y - paddle.speed * dt
    end

    if love.keyboard.isDown"s" then
        paddle.y = paddle.y + paddle.speed * dt
    end

    if paddle.y < 0 then
        paddle.y = 0
    end

    local maxPaddleY = screenHeight - paddle.height
    if paddle.y > maxPaddleY then
        paddle.y = maxPaddleY
    end

    -- DEVELOPMENT USEFULL TRICKS:
    if love.keyboard.isDown"g" then
        ball.dx = ball.dx * 1.2
        ball.dy = ball.dy * 1.2
    end

    if love.keyboard.isDown"f" then
        ball.dx = ball.dx / 1.2
        ball.dy = ball.dy / 1.2
    end

end

function love.draw()
    love.graphics.rectangle("fill", paddle.x, paddle.y, paddle.width, paddle.height)
    love.graphics.circle("fill", ball.x, ball.y, ball.r)

    local scoreText = score
    love.graphics.setFont(scoreFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(score, screenWidth / 2)

    -- function looser()
    --     love.graphics.print("Looser!", screenWidth / 2, screenHeight / 2)
    -- end

end
