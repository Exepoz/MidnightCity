local QBCore = exports['qb-core']:GetCoreObject()
local safes = {}
GlobalState.Safes = safes
-- Blackout
RegisterNetEvent('mdn-extras:server:SetBlackout', function(state) exports['av_weather']:SetBlackout(state) end)

lib.cron.new("*/30 * * * *", function()
    exports['qb-weathersync']:nextWeatherStage()
end)

--Doorlocks Changes
RegisterNetEvent('qb-doorlock:server:updateState', function(doorID, locked, src, usedLockpick, unlockAnyway, enableSounds, enableAnimation, sentSource)
    print("Updating Door State ["..doorID.."]")
	local door = exports.ox_doorlock:getDoorFromName(doorID)
	local playerId = sentSource or source
	local state = locked and 1 or 0
	local lockpick = usedLockpick or false
	TriggerEvent('ox_doorlock:setState', door.id, locked, lockpick)
end)

-------------
-- Arcades --
-------------
QBCore.Functions.CreateCallback('cyberbar:server:insertcoin', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local coins = Player.Functions.GetItemByName(Config.Items.coins)
    if not coins then cb(false) return end
    cb(coins.amount >= 3)
end)

RegisterNetEvent('cyberbar:server:PayCoins', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(Config.Items.coins, 3)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Items.coins], "remove", 3)
end)

RegisterNetEvent('cyberbar:server:gencoins', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(Config.Items.coins, 100)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Items.coins], "add", 100)
end)

-------------------
-- Safe Drilling --
-------------------
RegisterNetEvent('mdn-extras:server:SafeBusy', function(coords, state) safes[coords] = state GlobalState.Safes = safes end)
RegisterNetEvent('mdn-extras:server:SafeSync', function(type, ...) TriggerClientEvent('mdn-extras:client:SafeSync', -1, type, ...) end)

----------------
-- Roll Dice --
----------------
-- QBCore.Commands.Add("roll", "Roll some dice :)", {{name="number", help="Number of dice"}, {name="sides", help="Number of sides of dice"}}, true, function(source, args)
--     local amount = tonumber(args[1])
--     local DiceSides = tonumber(args[2])
--     if not amount or not DiceSides then return end
--     if (DiceSides > 0 and DiceSides <= 6) and (amount > 0 and amount <= 5) then
--         local result = {}
--         for _ = 1, amount do
--             table.insert(result, math.random(1, DiceSides))
--         end
--         TriggerClientEvent("fs-diceroll:client:roll", -1, source, 5.0, result, DiceSides)
--     else
--         TriggerClientEvent('QBCore:Notify', source, "Make sure your # is Valid and under 6 Sides and 5 Dice...", "error")
--     end
-- end)

-------------------------
-- Alta Tower Elevator --
-------------------------
RegisterNetEvent('mdn-extras:server:goUp', function() TriggerClientEvent('mdn-extras:client:goUp', -1) end)
RegisterNetEvent('mdn-extras:server:goDown', function() TriggerClientEvent('mdn-extras:client:goDown', -1) end)
RegisterNetEvent('mdn-extras:server:elev', function() TriggerClientEvent('mdn-extras:client:elev', -1) end)

---------------------
-- Slime Dispenser --
---------------------
RegisterNetEvent('mdn-extras:server:getslime', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem('slimevial', amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['slimevial'], "add", amount)
end)

-------------------------
-- Toggle Radio Clicks --
-------------------------
QBCore.Commands.Add("toggleradioclicks", "Toggle Radio Clicks on/off", {{name="on/off", help="Toggle clicks on or off"}}, true, function(source, args)
    local toggle = args[1]
    if toggle == "on" then toggle = true
    elseif toggle == "off" then toggle = false
    else QBCore.Functions.Notify("Incorrect Arguments", "error", 5000) end
    TriggerClientEvent('mdn-extras:client:radioclicks', source, toggle)
end)

-------------------
-- Fence Selling --
-------------------
RegisterServerEvent("malmo-fence:server:sellItems", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local price = 0
    local itemsSold = false
    for k, item in pairs(Player.PlayerData.items) do
        if item ~= nil then
            for _, itemInfo in pairs(Config.Fence.Items) do
                if itemInfo.item == item.name then
                    price = price + (itemInfo.price * item.amount)
                    Player.Functions.RemoveItem(item.name, item.amount, k)
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], "remove", item.amount)
                    itemsSold = true
                    break
                end
            end
        end
    end
    if not itemsSold then
        TriggerClientEvent('QBCore:Notify', src, "You don't have anything I want..", 'error')
    else
        Player.Functions.AddMoney("cash", price)
        TriggerClientEvent('QBCore:Notify', src, "Thanks! Bring me more whenever you can!", 'success')
    end
end)

local function comma_value(amount)
    local formatted = amount
    local k
    while true do
        formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1,%2')
        if (k == 0) then
            break
        end
    end
    return formatted
end

-- -- Transfer vehicle to player in passenger seat
-- QBCore.Commands.Add('transfervehicle',  "Gift or sell your vehicle", {{name = 'ID', help = "ID of buyer"}, {name = 'amount', help = "Sell amount (optionnal)"}}, false, function(source, args)
--     local src = source
--     local buyerId = tonumber(args[1])
--     local sellAmount = tonumber(args[2])
--     if buyerId == 0 then return TriggerClientEvent('QBCore:Notify', src, "Invalid Player Id Supplied", 'error') end
--     local ped = GetPlayerPed(src)
--     local targetPed = GetPlayerPed(buyerId)
--     if targetPed == 0 then return TriggerClientEvent('QBCore:Notify', src, "Couldn\'t get buyer info", 'error') end
--     local vehicle = GetVehiclePedIsIn(ped, false)
--     if vehicle == 0 then return TriggerClientEvent('QBCore:Notify', src, "You must be in the vehicle you want to transfer", 'error') end
--     local plate = QBCore.Shared.Trim(GetVehicleNumberPlateText(vehicle))
--     if not plate then return TriggerClientEvent('QBCore:Notify', src, "Couldn\'t get vehicle info", 'error') end
--     local player = QBCore.Functions.GetPlayer(src)
--     local target = QBCore.Functions.GetPlayer(buyerId)
--     local row = MySQL.single.await('SELECT * FROM player_vehicles WHERE plate = ?', {plate})
--     if not row or row.citizenid ~= player.PlayerData.citizenid then return TriggerClientEvent('QBCore:Notify', src, "You don\'t own this vehicle", 'error') end
--     if #(GetEntityCoords(ped) - GetEntityCoords(targetPed)) > 5.0 then return TriggerClientEvent('QBCore:Notify', src, "This player is not close enough", 'error') end
--     local targetcid = target.PlayerData.citizenid
--     local targetlicense = QBCore.Functions.GetIdentifier(target.PlayerData.source, 'license')
--     if not target then return TriggerClientEvent('QBCore:Notify', src, "Couldn\'t get buyer info", 'error') end
--     if not sellAmount then
--         MySQL.update('UPDATE player_vehicles SET citizenid = ?, license = ? WHERE plate = ?', {targetcid, targetlicense, plate})
--         TriggerClientEvent('QBCore:Notify', src, "You gifted your vehicle", 'success')
--         TriggerClientEvent('vehiclekeys:client:SetOwner', buyerId, plate)
--         TriggerClientEvent('QBCore:Notify', buyerId, "You were gifted a vehicle", 'success')
--         return
--     end
--     if target.Functions.GetMoney('cash') > sellAmount then
--         MySQL.update('UPDATE player_vehicles SET citizenid = ?, license = ? WHERE plate = ?', {targetcid, targetlicense, plate})
--         player.Functions.AddMoney('cash', sellAmount)
--         target.Functions.RemoveMoney('cash', sellAmount)
--         TriggerClientEvent('QBCore:Notify', src, "You sold your vehicle for $" .. comma_value(sellAmount), 'success')
--         TriggerClientEvent('vehiclekeys:client:SetOwner', buyerId, plate)
--         TriggerClientEvent('QBCore:Notify', buyerId, "You bought a vehicle for $" .. comma_value(sellAmount), 'success')
--     elseif target.Functions.GetMoney('bank') > sellAmount then
--         MySQL.update('UPDATE player_vehicles SET citizenid = ?, license = ? WHERE plate = ?', {targetcid, targetlicense, plate})
--         player.Functions.AddMoney('bank', sellAmount)
--         target.Functions.RemoveMoney('bank', sellAmount)
--         TriggerClientEvent('QBCore:Notify', src, "You sold your vehicle for $" .. comma_value(sellAmount), 'success')
--         TriggerClientEvent('vehiclekeys:client:SetOwner', buyerId, plate)
--         TriggerClientEvent('QBCore:Notify', buyerId, "You bought a vehicle for $" .. comma_value(sellAmount), 'success')
--     else
--         TriggerClientEvent('QBCore:Notify', src, "The buyer doesn\'t have enough money", 'error')
--     end
-- end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local pName = "No Character Selected"
    if not Player or Player.PlayerData == nil then return end
    local time = os.date("%Y-%m-%d %H:%M:%S")
    local charinfo = Player.PlayerData.charinfo
    local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
    local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
    pName = firstName.." "..lastName
    print("^8Player Dropped : ^9[^7"..time.."^9] (^5"..GetPlayerName(src).." ^9| ^5"..pName.." ^9| ^5"..Player.PlayerData.citizenid.."^9) ^7Reason : ^3"..reason.."^7")
end)

QBCore.Functions.CreateCallback('Ammunation:CheckLicenses', function(source, cb, cid)
    local Player = QBCore.Functions.GetPlayerByCitizenId(cid)
    if not Player then TriggerClientEvent('QBCore:Notify', source, "Could not find anyone matching this Citizen ID", 'error') cb(false) return end
    local licenses = Player.PlayerData.metadata['licences']
    local sentLic = {
        ['name'] = Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname,
        ['weapon1'] = licenses['weapon1'] or false,
        ['weapon2'] = licenses['weapon2'] or false,
        ['weapon3'] = licenses['weapon3'] or false,
        ['hunting'] = licenses['hunting'] or false,
    }
    cb(sentLic)
end)

RegisterNetEvent('mdn-extras:server:getPlushie', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local ranItem = GenerateItem(Config.UwuPlushies)
    Player.Functions.AddItem('slimevial', amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['slimevial'], "add", amount)
end)

-- QBCore.Functions.CreateUseableItem('police_stormram', function(source, item)
--     local Player = QBCore.Functions.GetPlayer(source)
--     if Player.Functions.GetItemByName("police_stormram") then

--     end
-- end)
