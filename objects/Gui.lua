local utf8 = require("utf8")
timer = require("libs.timer")
Class = require("libs.class")
Gui = Class {}

function Gui:init(windowWidth, windowHeight)
    self.windowWidth = windowWidth
    self.windowHeight = windowHeight
    self.textInput = ""
    self.font = love.graphics.setNewFont("libs/fonts/Roboto-Regular.ttf", 24)
    self.colorGreen = {0, 1, 0}
    self.colorBlue = {0, 0, 1}
    self.colorRed = {1, 0, 0}
    self.colorWhite = {1, 1, 1}
    self.colorBlack = {0, 0, 0}
    love.keyboard.setKeyRepeat(true)
    self.gameStart = false
    self.timeLapsed = 10
    self.timer = timer.new()
    self.timerActive = false
    self.openScoreboard = false

    self.scorePanelBackground = love.graphics.newImage("sprites/gui/panel/woodPanel.png")
end

function Gui:load()
    love.graphics.setDefaultFilter("nearest, nearest")
end

function Gui:update(dt)
    self.timer:update(dt)
end

function Gui:userInput()
    local text_input_heigh = love.graphics.getFont():getHeight(self.textInput)
    local text_input_width = love.graphics.getFont():getWidth("xxxxxxxxxxxx")
    local text_input_length = 10

    function love.textinput(t)
        if self.textInput:len() < text_input_length and self.gameStart == false then
            self.textInput = self.textInput .. t
        end
    end

    function love.keypressed(key)
        if key == "backspace" then
            local byte_offset = utf8.offset(self.textInput, -1)

            if byte_offset then
                self.textInput = string.sub(self.textInput, 1, byte_offset - 1)
            end
        elseif key == "return" and #self.textInput > 1 then
            self.gameStart = true
        elseif key == "lalt" or key == "ralt" then
            self.openScoreboard = not self.openScoreboard
        end
    end

    love.graphics.rectangle("fill", (self.windowWidth - text_input_width) / 2,
        (self.windowHeight - text_input_heigh) / 2, text_input_width, text_input_heigh, 5, 5)
    love.graphics.setColor(self.colorBlack)
    love.graphics.print(self.textInput, (self.windowWidth - text_input_width + 14) / 2,
        (self.windowHeight - text_input_heigh) / 2)
    love.graphics.setColor(self.colorWhite)
end

function Gui:drawStartScreenTitle()
    local text = "T-Rex Game"
    local text_width = love.graphics.getFont():getWidth(text)
    local text_height = love.graphics.getFont():getHeight(text)
    love.graphics.setColor(self.colorBlack)
    love.graphics.print(text, (self.windowWidth - text_width) / 2.5, (self.windowHeight - text_height - 180) / 2, 0, 2,
        2)
    love.graphics.setColor(self.colorWhite)

end

function Gui:drawStartScreenSubTitle()
    local text = "Write your name"
    local text_width = love.graphics.getFont():getWidth(text)
    local text_height = love.graphics.getFont():getHeight(text)
    love.graphics.print(text, (self.windowWidth - text_width + 15) / 2, (self.windowHeight - text_height * 3) / 2, 0,
        0.8, 0.8)
end

function Gui:drawStartScreenStartText()
    local text = "Press [Enter] to Start..."
    local text_width = love.graphics.getFont():getWidth(text)
    local text_height = love.graphics.getFont():getHeight(text)
    love.graphics.print(text, (self.windowWidth - text_width + 20) / 2, (self.windowHeight + text_height * 2) / 2, 0)
end
function Gui:drawStartScreenScoreText()
    local text = "Press [Alt] to show Scores..."
    local text_width = love.graphics.getFont():getWidth(text)
    local text_height = love.graphics.getFont():getHeight(text)
    love.graphics.print(text, (self.windowWidth - text_width + 20) / 2, (self.windowHeight + text_height * 2) / 1.8, 0)
end

function Gui:drawTimer(dt)
    local text = "Elapsed Time:"
    local text_width = love.graphics.getFont():getWidth(text)
    local text_height = love.graphics.getFont():getHeight(text)

    love.graphics.setColor(self.colorBlack)
    love.graphics.print(text, self.font, (self.windowWidth - text_width) / 2, 0)

    local time = gameTime
    local time_width = love.graphics.getFont():getWidth(time)
    love.graphics.print(gameTime .. "s", self.font, (self.windowWidth - time_width) / 2, text_height)
    love.graphics.setColor(self.colorWhite)
end

function Gui:drawLoseScreenTitle()
    local text = "You Loose"
    local text_width = love.graphics.getFont():getWidth(text)
    local text_height = love.graphics.getFont():getHeight(text)
    love.graphics.setColor(self.colorBlack)
    love.graphics.print(text, (self.windowWidth - text_width) / 2.5, (self.windowHeight - text_height - 140) / 2.5, 0,
        2, 2)
    love.graphics.setColor(self.colorWhite)
end

function Gui:drawLoseScore(dt)
    local text = "Score: " .. score .. "s"
    local text_width = love.graphics.getFont():getWidth(text)
    local text_height = love.graphics.getFont():getHeight(text)

    love.graphics.print(text, (self.windowWidth - text_width - 50) / 2,
        (self.windowHeight - text_height + 50) / 2.5, 0, 1.2, 1.2)

end

function Gui:drawLoseRespawnTime(dt)
    local text = "Game restart in: ".. tostring(self.timeLapsed).."s"
    local text_width = love.graphics.getFont():getWidth(text)
    local text_height = love.graphics.getFont():getHeight(text)
    love.graphics.setColor(self.colorBlack)
    love.graphics.print(text, (self.windowWidth - text_width - 50) / 2,
        (self.windowHeight - text_height + 50) / 2, 0, 1.2, 1.2)
    love.graphics.setColor(self.colorWhite)
end

function Gui:respawnTimeCount(seconds)
    self.timer:every(1, function()
        if self.gameStart and self.timeLapsed > 0 then
            self.timeLapsed = self.timeLapsed - 1
        end
    end)
end

function Gui:drawScorePanelBackground()
  
    love.graphics.draw(self.scorePanelBackground, 50, 50, 0, 0.45, 0.45)
end

function Gui:drawScorePanelTitle()
    local text = "Hall of Fame"
    local text_width = love.graphics.getFont():getWidth(text)
    local text_height = love.graphics.getFont():getHeight(text)
    love.graphics.print(text, (self.scorePanelBackground:getWidth() - text_width) / 5, 90, 0,1.5, 1.5)
end

function Gui:drawScoreHeader()
    local headers = {
        {"No.", 150, 150, 0, 0.9},
        {"Player Name",250, 150,0,0.9},
        {"score", 450, 150,0,0.9},
        {"Date", 580, 150,0,0.9}
    }
    love.graphics.setColor(0.81, 0.16, 0.11, 1)
    love.graphics.rectangle("fill", 79, 153, 630, 25)
    love.graphics.setColor(1, 1, 1, 1)
    for _, headers in pairs(headers) do
        local text, x, y, r, scale = unpack(headers)
        love.graphics.print(text, x, y, r, scale)
    end
end

function Gui:drawScoreTile(userDataTbl)
    
    local baseY = 180
    local offsetY = 30
    
    for i = 1, #userDataTbl, 1 do
        love.graphics.print(i, 150, baseY, 0, 0.7)
        love.graphics.print(tostring(userDataTbl[i].playerName), 300, baseY, 0, 0.7)  
        love.graphics.print(tostring(userDataTbl[i].score), 460, baseY, 0, 0.7)
        love.graphics.print(tostring(userDataTbl[i].date), 550, baseY, 0, 0.7)  
        love.graphics.rectangle("line", 100, baseY + 25, 600, 0)
        baseY = baseY + offsetY
    end
        
    --Iterate and sort overall
    -- table.sort(userDataTbl, function(a, b)
    --     return a.score > b.score
    -- end)

    -- for i, userRow in ipairs(userDataTbl) do
    --     local playerName, score, date = unpack(userDataTbl)
    --    love.graphics.print(i, 150, baseY, 0, 0.7)
    --    love.graphics.print(tostring(userRow.playerName), 300, baseY, 0, 0.7)  
    --    love.graphics.print(tostring(userRow.score), 460, baseY, 0, 0.7)
    --    love.graphics.print(tostring(userRow.date), 550, baseY, 0, 0.7)  
    --    love.graphics.rectangle("line", 100, baseY + 25, 600, 0)
    --     baseY = baseY + offsetY
    -- end
end

function Gui:drawLoseScreen()
    self:drawLoseScreenTitle()
    self:drawLoseRespawnTime()
    self:drawLoseScore()
end


function Gui:drawScorePanel(userDataTbl)
    self:drawScorePanelBackground()
    self:drawScorePanelTitle()
    self.drawScoreHeader()
    self:drawScoreTile(userDataTbl)

end

function Gui:drawStartScreen()
    self:drawStartScreenTitle()
    self:drawStartScreenSubTitle()
    self:userInput()
    self:drawStartScreenStartText()
    self:drawStartScreenScoreText()
end


