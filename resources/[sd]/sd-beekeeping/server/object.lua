local ServerObjects = {}
local maintenanceCooldowns = {}
local cooldownPeriod = 600 -- Cooldown period in seconds, adjust as needed

RegisterNetEvent("sd-beekeeping:objects:server:CreateNewObject", function(hive_type, coords, options, defaultData, citizenid)
    local src = source
    if hive_type and coords and options then
        local currentTime = os.time()
        local data = MySQL.query.await("INSERT INTO sd_beekeeping (hive_type, coords, options, data, citizenid, last_maintained) VALUES (?, ?, ?, ?, ?, ?)", {hive_type, json.encode(coords), json.encode(options), json.encode(defaultData), citizenid, currentTime})
        
        ServerObjects[data.insertId] = {id = data.insertId, hive_type = hive_type, coords = coords, options = options, last_maintained = currentTime}
        
        TriggerEvent("sd-beekeeping:server:AddToBeekeepingData", data.insertId, hive_type, coords, options, defaultData, citizenid, currentTime)
        
        TriggerClientEvent("sd-beekeeping:objects:client:AddObject", -1, {id = data.insertId, hive_type = hive_type, coords = coords, options = options})
    end
end)

CreateThread(function()
    local currentTime = os.time()
    local results = MySQL.query.await('SELECT * FROM sd_beekeeping', {})

    for k, v in pairs(results) do
        ServerObjects[v["id"]] = {
            id = v["id"],
            hive_type = v["hive_type"],
            coords = json.decode(v["coords"]),
            options = json.decode(v["options"]),
            last_maintained = v["last_maintained"]
        }
    end
end)

lib.callback.register("sd-beekeeping:objects:server:RequestObjects", function(source)
    return ServerObjects
end)

RegisterNetEvent("sd-beekeeping:objects:server:DeleteObject", function(objectid)
    local src = source
    if objectid > 0 then
        local data = MySQL.query.await('DELETE FROM sd_beekeeping WHERE id = ?', {objectid})
        ServerObjects[objectid] = nil
        TriggerClientEvent("sd-beekeeping:objects:client:receiveObjectDelete", -1, objectid)
    end
end)

RegisterNetEvent('sd-beekeeping:resetMaintenance', function(beeHouseId)
    local src = source
    local currentTime = os.time()

    if not maintenanceCooldowns[src] then maintenanceCooldowns[src] = {} end

    if not maintenanceCooldowns[src][beeHouseId] or currentTime >= maintenanceCooldowns[src][beeHouseId] then
        MySQL.query.await("UPDATE sd_beekeeping SET last_maintained = ? WHERE id = ?", {currentTime, beeHouseId})
        if ServerObjects[beeHouseId] then ServerObjects[beeHouseId].last_maintained = currentTime end
        maintenanceCooldowns[src][beeHouseId] = currentTime + cooldownPeriod
    end
end)

CreateThread(function()
    if Beekeeping.EnableExpiration then
        while true do
            Wait(30000)

            local currentTime = os.time()
            local expiryTime = Beekeeping.ExpiryTime * 3600 

            for id, object in pairs(ServerObjects) do
                local lastMaintained = object.last_maintained or 0
                if (currentTime - lastMaintained) > expiryTime then
                    MySQL.query.await('DELETE FROM sd_beekeeping WHERE id = ?', {id})
                    ServerObjects[id] = nil
                    TriggerClientEvent("sd-beekeeping:objects:client:receiveObjectDelete", -1, id)
                end
            end
        end
    end
end)