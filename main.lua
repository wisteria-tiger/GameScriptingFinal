if arg[2] == "debug" then
    require("lldebugger").start()
end

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end

-- TOPDOWN SHOOTER GAME
-- Create functionality for player movement and shooting
-- Create functionality for enemy movement
-- Create scoring system
-- Create functionality for start screen and gameover on death
-- Let player restart game from gameover screen 

function love.load()
    player = {}
    movementSpeed = 60
    player.x = 100
    player.y = 50
end

function love.update(dt)
    movement(dt)
end

function love.draw()
    love.graphics.circle("fill", player.x, player.y, 10)
end

function movement(dt)
    if love.keyboard.isDown("w") then
        player.y = player.y - movementSpeed * dt
    end

    if love.keyboard.isDown("d") then
        player.x = player.x + movementSpeed * dt
    end

    if love.keyboard.isDown("s") then
        player.y = player.y + movementSpeed * dt
    end

    if love.keyboard.isDown("a") then
        player.x = player.x - movementSpeed * dt
    end
end
