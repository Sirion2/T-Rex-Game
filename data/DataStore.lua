require("libs.class")
local json = require("libs.dkjson")

DataStore = Class {}

function DataStore:init(playerName, score)
    self.playerName = playerName
    self.score = score
    self.dateTime = os.date('%Y-%m-%d %H:%M:%S')

    self.gameDataTbl = {
        playerName = self.playerName,
        score = self.score,
        date = self.dateTime
    }

    self.userDataTbl = {}
    
    self.dataFileName = "data/Gamedata.json"
end

function DataStore:writeJsonData()
        local existingData = {}
        local file = io.open(self.dataFileName, "r")
        if file then
            local file_content = file:read("*a")
            file:close()
            
            existingData, _, err = json.decode(file_content)
            if err then
                print("Error decoding JSON " .. err)
                existingData = {}
            end
        end
    
        table.insert(existingData, self.gameDataTbl)
    
        local json_string = json.encode(existingData, {
            indent = true
        })
        local file = io.open(self.dataFileName, "w")
        file:write(json_string)
        file:close()
end

function DataStore:readJsonData()
    local file = io.open(self.dataFileName, "r")
    if not file then
        print("File not found. Creating new file: " .. self.dataFileName)
        file = io.open(self.dataFileName, "w") -- Crear un archivo nuevo
        file:write("") -- Escribir un array JSON vacío en el nuevo archivo
        file:close()

        -- Vuelve a abrir el archivo en modo lectura
        file = io.open(self.dataFileName, "r")
    end

    local file_content = file:read("*a")
    file:close()

    if file_content == "" then
        print("File is empty")
        return
    end

    local data, pos, err = json.decode(file_content)
    if err then
        print("Error decoding JSON: " .. err)
        return
    end

    if #data == 0 then
        print("No data found in JSON file.")
        return
    end

    self.userDataTbl = {}

    table.sort(data, function(a, b)
        return a.score > b.score
    end)
        for i, entry in ipairs(data) do
            if i < 11 then               
                local userData = {
                    playerName = entry.playerName,
                    score = entry.score,
                    date = entry.date    
                }
                table.insert(self.userDataTbl, userData)
            end
    end
end

