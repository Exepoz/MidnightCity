local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('carcrushing:server:CrushOwnCar', function(plate, class)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local lootGiven = 0
    local lootTypeAmount = math.random(3, 8)
    for k, v in pairs(Config.Classes[class]) do
        local amount = v
        Player.Functions.AddItem(k, v)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[k], "add", amount)
        lootGiven = lootGiven + 1
        if lootGiven >= lootTypeAmount then break end
    end
    MySQL.query('DELETE FROM player_vehicles WHERE plate = ?', {plate})
end)

RegisterNetEvent('carcrushing:server:CrushVinscratched', function(plate)
    MySQL.query('DELETE FROM player_vehicles WHERE plate = ?', {plate})
end)

QBCore.Functions.CreateCallback('carcrushing:server:checkvin', function(source, cb, plate)
    local result = MySQL.Sync.fetchScalar('SELECT vinscratched FROM player_vehicles WHERE plate = ?', {plate})
    cb(result)
end)

QBCore.Functions.CreateCallback('carcrushing:server:checkownership', function(source, cb, plate)
    local pData = QBCore.Functions.GetPlayer(source)
    MySQL.query('SELECT * FROM player_vehicles WHERE citizenid = ? and plate = ?', {pData.PlayerData.citizenid, plate}, function(result)
        if result and result[1] then cb(true) else cb(false) end
    end)
end)