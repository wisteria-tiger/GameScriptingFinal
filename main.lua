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
end

function love.update()
end

function love.draw()
end