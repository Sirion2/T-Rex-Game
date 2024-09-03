require("libs.class")
require("libs.anim8")

Map = Class {}

function Map:init()
    self.background = love.graphics.newImage("sprites/maps/background.png")
    self.foreground = love.graphics.newImage("sprites/maps/level.png")
    self.foregroundx = 0
    self.foregroundgSpeed = 100

    self.cloud = love.graphics.newImage("sprites/maps/cloud.png")
    self.cloudx = 0
    self.cloudSpeed = 245
end

function Map:update(dt)
    self.foregroundx = self.foregroundx - self.foregroundgSpeed * dt
    self.cloudx = self.cloudx - self.cloudSpeed * dt

    if self.foregroundx <= -self.foreground:getWidth() then
        self.foregroundx = 0
    end

    if self.cloudx <= -self.cloud:getWidth() then
        self.cloudx = 0
    end
end

function Map:draw()
    love.graphics.draw(self.background)
    for i = 0, love.graphics.getWidth() / self.foreground:getWidth() + 1 do
        love.graphics.draw(self.foreground, self.foregroundx + i * self.foreground:getWidth(), 0)
    end

    for i = 0, love.graphics.getWidth() / self.cloud:getWidth() + 1 do
        love.graphics.draw(self.cloud, self.cloudx + i * self.cloud:getWidth(), 0)
    end
end
