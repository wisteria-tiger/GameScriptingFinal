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

require("enemy")

-- TOPDOWN SHOOTER GAME
-- Create functionality for player movement and shooting
-- Create functionality for enemy movement
-- Create scoring system
-- Create functionality for start screen and gameover on death
-- Let player restart game from gameover screen 

function love.load()
    player = {}
    movementSpeed = 200
    player.x = 100
    player.y = 50
    bullets = {}
    bulletspeed = 500
    enemies = {}
    spawnTimer = 0
    spawnRate = 2
end

function love.update(dt)
    movement(dt)
    shootbullet(dt)
    spawning(dt)
end

function love.draw()
    love.graphics.setColor(250, 250, 250)
    love.graphics.circle("fill", player.x, player.y, 10)
    for i, b in ipairs(bullets) do
        love.graphics.circle("fill", b.x, b.y, b.size)
    end
    
    for i, enemy in ipairs(enemies) do
        love.graphics.setColor(250, 0, 0)
        enemy:draw()
    end
end

-- Calculates bullet angle and velocity 
function love.mousepressed(x, y, button)
    if button == 1 then
        mouseX = x
        mouseY = y
        angle = math.atan2(mouseX - player.x, mouseY - player.y)
        vy = math.cos(angle) * bulletspeed
        vx = math.sin(angle) * bulletspeed
        table.insert(bullets, {x = player.x, y = player.y, size = 5}) 
    end
end

-- Handles player movement
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

-- Fires bullet at calculated angle and velocity. Removes bullet from table if it leaves the screen
function shootbullet(dt) 
    for i, b in ipairs(bullets) do
        b.x = b.x + vx * dt
        b.y = b.y + vy * dt
         
        if b.x > love.graphics.getWidth() or b.x < 0 or b.y < 0 or b.y > love.graphics.getHeight() then
        table.remove(bullets, i)
        end
    end
end

function spawning(dt)
    spawnTimer = spawnTimer + dt
    if spawnTimer > spawnRate then
        spawnEnemy()
        spawnTimer = 0
    end

    -- Update existing enemies
    for i, enemy in ipairs(enemies) do
        enemy:update(dt, player.x, player.y) -- Assuming player is at 400,300
    end
end

function spawnEnemy()
    local x, y
    side = love.math.random(1, 4)
    if side == 1 then x = 0; y = love.math.random(0, love.graphics.getHeight()) -- Left
    elseif side == 2 then x = love.graphics.getWidth(); y = love.math.random(0, love.graphics.getHeight()) -- Right
    elseif side == 3 then x = love.math.random(0, love.graphics.getWidth()); y = 0 -- Top
    else x = love.math.random(0, love.graphics.getWidth()); y = love.graphics.getHeight() -- Bottom
    end
    table.insert(enemies, Enemy.new(x, y))
end