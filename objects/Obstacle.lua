local timer = require("libs.timer")
Class = require("libs.class")
Obstacle = Class {}

function Obstacle:init(windowWidth, windowHeight)
    self.windowHeight = windowHeight
    self.windowWidth = windowWidth
    self.listOfObstacles = {}
    self.timer = timer
    self.generationSpeed = 3
    self:setupTimers()
    self.speed = 100
    self.speedCounter = 0
    self.a = love.graphics.newImage("sprites/obstacles/01.Mushroom.png")
    self.obstaclesImages = {love.graphics.newImage("sprites/obstacles/01.Mushroom.png"),
                            love.graphics.newImage("sprites/obstacles/01.Stone.png"),
                            love.graphics.newImage("sprites/obstacles/02.Mushroom.png"),
                            love.graphics.newImage("sprites/obstacles/03.Tree.png")}
end

function Obstacle:setupTimers()

    self.timer.every(self.generationSpeed, function()
        if gameStart then
            self.speedCounter = self.speedCounter + 5
            self:createObstacle()
        end
    end)
end

function Obstacle:createObstacle()
    local obs = {}
    local imageIndex = math.random(#self.obstaclesImages)
    obs.image = self.obstaclesImages[imageIndex]
    obs.width = 45
    obs.height = 70
    obs.x = self.windowWidth
    obs.y = self.windowHeight - obs.height * 2 + 14
    obs.speed = self.speed

    if self.listOfObstacles then
        table.insert(self.listOfObstacles, obs)
        print("Obstacle created at position:", obs.x, obs.y)
    end

end

function Obstacle:removeObstacle(dt)
    if self.listOfObstacles then
        for i = #self.listOfObstacles, 1, -1 do
            local v = self.listOfObstacles[i]
            v.x = v.x - v.speed * dt

            if v.x + v.width < 0 then
                table.remove(self.listOfObstacles, i)
            end
        end
    end
end

function Obstacle:update(dt)

    self.timer.update(dt)
    self:generationRate(dt)
    self:removeObstacle(dt)

    if self.listOfObstacles then
        for i, v in ipairs(self.listOfObstacles) do
            v.x = v.x - v.speed * dt
        end
    end
end

function Obstacle:draw(dt)
    if self.listOfObstacles then
        for i, v in ipairs(self.listOfObstacles) do
            love.graphics.draw(v.image, v.x, v.y)
        end
    end
end

function Obstacle:generationRate()
    if self.speedCounter == 10 then
        self.generationSpeed = math.random(0.8, 3)
        self.speed = self.speed + 1.5
        self.speedCounter = 0
    end
end

function Obstacle:resetObstacle()
    self.listOfObstacles = {}
end
