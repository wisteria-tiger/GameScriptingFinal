if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

-- TOPDOWN SHOOTER GAME
-- Create functionality for player movement and shooting
-- Create functionality for enemy movement
-- Create scoring system
-- Create functionality for start screen and gameover on death
-- Let player restart game from gameover screen 

-- main.lua
-- Simple top-down shooter in LÖVE2D

function love.load()
    love.window.setTitle("Top Down Shooter")
    love.window.setMode(900, 600)

    math.randomseed(os.time())

    player = {
        x = 450,
        y = 300,
        speed = 220,
        radius = 18
    }

    bullets = {}
    enemies = {}

    enemySpawnTimer = 0
    score = 0
    gameOver = false
    gameWin = false
    gameStart = true
end

function spawnEnemy()
    local side = math.random(4)
    local x, y

    if side == 1 then
        x = -30
        y = math.random(0, love.graphics.getHeight())
    elseif side == 2 then
        x = love.graphics.getWidth() + 30
        y = math.random(0, love.graphics.getHeight())
    elseif side == 3 then
        x = math.random(0, love.graphics.getWidth())
        y = -30
    else
        x = math.random(0, love.graphics.getWidth())
        y = love.graphics.getHeight() + 30
    end

    table.insert(enemies, {
        x = x,
        y = y,
        speed = 100,
        radius = 16
    })
end

function love.update(dt)
    if gameStart then
        if gameOver then
        return
    end

    if gameWin then
        return
    end

    -- Player movement
    local mx = 0
    local my = 0

    if love.keyboard.isDown("w") then
        my = my - 1
    end
    if love.keyboard.isDown("s") then
        my = my + 1
    end
    if love.keyboard.isDown("a") then
        mx = mx - 1
    end
    if love.keyboard.isDown("d") then
        mx = mx + 1
    end

    local len = math.sqrt(mx * mx + my * my)
    if len > 0 then
        mx = mx / len
        my = my / len
    end

    player.x = player.x + mx * player.speed * dt
    player.y = player.y + my * player.speed * dt

    -- Keep player in bounds
    player.x = math.max(player.radius, math.min(love.graphics.getWidth() - player.radius, player.x))
    player.y = math.max(player.radius, math.min(love.graphics.getHeight() - player.radius, player.y))

    -- Spawn enemies
    enemySpawnTimer = enemySpawnTimer + dt
    if enemySpawnTimer >= 1 then
        enemySpawnTimer = 0
        spawnEnemy()
    end

    -- Update bullets
    for i = #bullets, 1, -1 do
        local b = bullets[i]

        b.x = b.x + b.dx * b.speed * dt
        b.y = b.y + b.dy * b.speed * dt

        if b.x < 0 or b.x > love.graphics.getWidth()
        or b.y < 0 or b.y > love.graphics.getHeight() then
            table.remove(bullets, i)
        end
    end

    -- Update enemies
    for i = #enemies, 1, -1 do
        local e = enemies[i]

        local dx = player.x - e.x
        local dy = player.y - e.y
        local dist = math.sqrt(dx * dx + dy * dy)

        if dist > 0 then
            dx = dx / dist
            dy = dy / dist
        end

        e.x = e.x + dx * e.speed * dt
        e.y = e.y + dy * e.speed * dt

        -- Collision with player
        if dist < player.radius + e.radius then
            gameOver = true
        end

        -- Bullet collisions
        for j = #bullets, 1, -1 do
            local b = bullets[j]

            local bx = e.x - b.x
            local by = e.y - b.y
            local bd = math.sqrt(bx * bx + by * by)

            if bd < e.radius + b.radius then
                table.remove(enemies, i)
                table.remove(bullets, j)
                score = score + 1
                if score == 20 then
                    gameWin = true
                end
                break
            end
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 and not gameOver then
        local dx = x - player.x
        local dy = y - player.y
        local dist = math.sqrt(dx * dx + dy * dy)

        dx = dx / dist
        dy = dy / dist

        table.insert(bullets, {
            x = player.x,
            y = player.y,
            dx = dx,
            dy = dy,
            speed = 500,
            radius = 5
        })
    end
    end 
end

function love.keypressed(key)
    if key == "r" and gameOver then
        love.load()
    end
    if key == "enter" and gameStart then
        gameStart = false
    end
end

function love.draw()
    -- Background
    love.graphics.clear(0.08, 0.08, 0.1)

    -- Draw player
    love.graphics.setColor(0.2, 0.9, 0.3)
    love.graphics.circle("fill", player.x, player.y, player.radius)

    -- Draw bullets
    love.graphics.setColor(1, 1, 0)
    for _, b in ipairs(bullets) do
        love.graphics.circle("fill", b.x, b.y, b.radius)
    end

    -- Draw enemies
    love.graphics.setColor(0.9, 0.2, 0.2)
    for _, e in ipairs(enemies) do
        love.graphics.circle("fill", e.x, e.y, e.radius)
    end

    -- UI
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. score, 10, 10)

    if gameOver then
        love.graphics.printf(
            "GAME OVER\nPress R to Restart",
            0,
            love.graphics.getHeight() / 2 - 30,
            love.graphics.getWidth(),
            "center"
        )
    end

    if gameWin then
        love.graphics.printf(
            "YOU WIN!\nPress R to Restart",
            0,
            love.graphics.getHeight() / 2 - 30,
            love.graphics.getWidth(),
            "center"
        )
    end
end

local love_errorhandler = love.errorhandler
function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2) -- Throws the error back to VS Code
    else
        return love_errorhandler(msg) -- Shows the standard blue error screen
    end
end


