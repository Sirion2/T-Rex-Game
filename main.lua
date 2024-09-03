timer = require("libs.timer")

require("objects.Player")
require("objects.Obstacle")
require("objects.Gui")
require("data.DataStore")
require("objects.Map")

local windowWidth = love.graphics.getWidth()
local windowHeight = love.graphics.getHeight()

gameTime = 0
isDeath = false
function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setVSync( -1 )
    GameLine()
    map = Map()
    gui = Gui(windowWidth, windowHeight)
    playerName = gui.textInput
    obstacle = Obstacle(windowWidth, windowHeight, gameStart)
    player1 = Player(windowWidth, windowHeight, obstacle.listOfObstacles, playerName)
end

function love.update(dt)
    timer.update(dt)
    if not isDead then
        obstacle:update(dt)
        map:update(dt)
    end
    player1:update(dt)
    gui:update(dt)

    gameStart = gui.gameStart
    player1.playerName = gui.textInput
    score = player1.score
    isDead = player1.isDead
    showScoreboard = gui.openScoreboard

    if isDead then
        if not gui.timerActive then
            gui.timerActive = true
            gui:respawnTimeCount(10)
            dataStore = DataStore(player1.playerName, player1.score)
            dataStore:writeJsonData()
        end
        if gui.timeLapsed == 0 and isDead then
            gameRestart()
            gui.timerActive = false
        end
    end
end

function love.draw(dt)
    map:draw(dt)

    if not gameStart and not isDead then
        gui:drawStartScreen(dt)

    elseif isDead then
        gui:drawLoseScreen()
    end
    if showScoreboard then
        dataStore = DataStore(player1.playerName, player1.score)
        dataStore:readJsonData()
        gui:drawScorePanel(dataStore.userDataTbl)
    else
        gui:drawTimer(dt)
        obstacle:draw(dt)
        player1:draw(dt)

    end
end

function gameRestart()
    gui.gameStart = false
    gui.textInput = ""
    gameTime = 0
    score = 0
    isDead = false
    gui.timeLapsed = 10
    obstacle:resetObstacle()
    obstacle = Obstacle(windowWidth, windowHeight)
    player1:resetPlayer()
    player1 = Player(windowWidth, windowHeight, obstacle.listOfObstacles, gui.textInput)
    gameStart = true
end

function GameLine()
    timer.every(1, function()
        if gameStart and not isDead then
            gameTime = gameTime + 1
        end
    end)
end
