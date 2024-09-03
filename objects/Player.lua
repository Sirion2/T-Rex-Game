anim8 = require("libs.anim8")

Class = require("libs.class")

Player = Class {}

function Player:init(windowWidth, windowHeight, listOfObstacles)
    self.windowHeight = windowHeight
    self.windowWidth = windowWidth
    self.listOfObstacles = listOfObstacles
    self.playerName = ""
    self.score = 0
    self.width = 90
    self.height = 90
    self.speed = 100
    self.x = 30
    self.y = self.windowHeight - self.height * 2
    self.gravity = 600
    self.jumpSpeed = -350
    self.yVelocity = 0
    self.isJumping = false
    self.isDead = false
    self.playerSpritesheet = love.graphics.newImage("sprites/dinosaur/sprite_sheet.png")
    self.grid = anim8.newGrid(680, 472, self.playerSpritesheet:getWidth(), self.playerSpritesheet:getHeight())

    self.playerAnimations = {}
    self.playerAnimations.run = anim8.newAnimation(self.grid('1-8', 5), 0.1)
    self.playerAnimations.jump = anim8.newAnimation(self.grid('1-12', 1), 0.1)
    self.playerAnimations.dead = anim8.newAnimation(self.grid('1-8', 4), 0.1, 'pauseAtEnd')

    self.anim = self.playerAnimations.run
end

function Player:update(dt)
    if not self.isDead then
        self:move(dt)
    end
    self.anim:update(dt)
end

function Player:draw()
    self:drawplayerName()
    self.anim:draw(self.playerSpritesheet, self.x, self.y, nill, 0.22)
end

function Player:move(dt)
    if self.isJumping then
        self.yVelocity = self.yVelocity + self.gravity * dt
        self.y = self.y + self.yVelocity * dt
    end
    if self.y >= self.windowHeight - self.height * 2 then
        self.y = self.windowHeight - self.height * 2
        self.yVelocity = 0
        self.isJumping = false

        if not self.isDead then
            self.anim = self.playerAnimations.run
        end
    end
    if love.keyboard.isDown("space") and not self.isJumping then
        self.yVelocity = self.jumpSpeed
        self.isJumping = true
        self.anim = self.playerAnimations.jump
    end
    if self:checkCollision() then
        self.isDead = true
        self.anim = self.playerAnimations.dead
        self.y = self.windowHeight - self.height * 2
        self.yVelocity = 0
        self.isJumping = false
        self.score = gameTime
        print("colition")
    end
end

function Player:checkCollision()

    local a_left = self.x
    local a_right = self.x + self.width
    local a_top = self.y
    local a_bottom = self.y + self.height

    for _, v in ipairs(self.listOfObstacles) do
        local b_left = v.x
        local b_right = v.x + v.width
        local b_top = v.y
        local b_bottom = v.y + v.height

        if a_right > b_left and a_left < b_right and a_bottom > b_top and a_top < b_bottom then
            print("colition")
            return true
        end
    end
    return false
end

function Player:resetPlayer()
    self.x = 30
    self.y = self.windowHeight - self.height * 2
    self.yVelocity = 0
    self.isJumping = false
    self.isDead = false
    self.anim = self.playerAnimations.run
    self.score = 0
end

function Player:drawplayerName()
    love.graphics.setColor({0, 0, 0})
    love.graphics.print("Player: " .. player1.playerName, 10, 60, 0, 1)
    love.graphics.setColor({1, 1, 1})
end

