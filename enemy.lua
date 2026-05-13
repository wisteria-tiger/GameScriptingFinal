-- enemy.lua (Simple Enemy Class)
Enemy = {}
Enemy.__index = Enemy

function Enemy.new(x, y)
    local instance = setmetatable({}, Enemy)
    instance.x = x
    instance.y = y
    instance.speed = 100
    instance.radius = 10
    return instance
end

function Enemy:update(dt, playerX, playerY)
    -- Simple movement towards player
    local angle = math.atan2(playerY - self.y, playerX - self.x)
    self.x = self.x + math.cos(angle) * self.speed * dt
    self.y = self.y + math.sin(angle) * self.speed * dt
end

function Enemy:draw()
    love.graphics.setColor(250, 0, 0)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end
