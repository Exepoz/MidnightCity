local QBCore = exports['qb-core']:GetCoreObject()
local currentGroup, towersDone, currentTruck = 0, 0, 0
local onCooldown = false
local doneToday = {}
GlobalState['SignalTruck:foundTruck'] = false
GlobalState['SignalTruck:truckSpawned'] = false
GlobalState['SignalTruck:thermited'] = false
HeistTime = 0
local Towers = {}

local jobStages = {
    [1] = {name = "Visit cell towers to applify the signal & narrow down the search area.", isDone = false, id = 1},
    [2] = {name = "Find the Parked Bank Truck.", isDone = false, id = 2},
    [3] = {name = "Plant Thermite at the back of the truck.", isDone = false, id = 3},
    [4] = {name = "Loot the bank truck.", isDone = false, id = 4}
}


local cachedEntities = {}

for k, v in ipairs(Config.Signal.Towers) do
    local t = lib.zones.sphere({coords = v, radius = 20})
    Towers[k] = {}
    Towers[k].coords = v
    Towers[k].point = t
    Towers[k].key = k
end

function sortByDistance(coordinates, referencePoint)
    print('sorting')
    table.sort(coordinates, function(a, b)
        local distanceToA = ((a.x - referencePoint.x)^2 + (a.y - referencePoint.y)^2)^0.5
        local distanceToB = ((b.x - referencePoint.x)^2 + (b.y - referencePoint.y)^2)^0.5
        return distanceToA < distanceToB
    end)
end

function ToggleCD(bool)
    Citizen.CreateThread(function()
        if bool then
            if onCooldown then return end
            Wait(Config.Signal.TimeToComplete * 60000)
            onCooldown = true
            Wait(Config.Signal.Cooldown * 60000)
            ToggleCD(false)
        else
            onCooldown = false
        end
    end)
end

-- Deposit Loot into box & Get in Queue
RegisterNetEvent('cr-armoredtrucks:server:startSignal', function(srcc)
    local src = srcc or source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = Player.Functions.GetItemByName('truck_locator_1')
    if not item then TriggerClientEvent('QBCore:Notify', src, 'You don\'t have anything to connect to this', 'error') return end
    local qual = item.info.quality
    if qual-50 <= 0 then TriggerClientEvent('QBCore:Notify', src, 'Your locator doesn\'t have enough powert to receive a signal...', 'error') return end
    if HeistInProgress then TriggerClientEvent('QBCore:Notify', src, 'The signal has been lost...', 'error') return end
    HeistInProgress = true
    local group = exports['qb-phone']:GetGroupByMembers(src)
    currentGroup = group
    HeistTime = os.time()
    currentTruck = math.random(#Config.Signal.TruckLocations)
    ToggleCD(true)

    Player.PlayerData.items[item.slot].info.quality = item.info.quality - 50
    Player.Functions.SetInventory(Player.PlayerData.items)

    local truck = Config.Signal.TruckLocations[currentTruck]
    local d = Config.Signal.Towers
    sortByDistance(d, truck)
    for i = 1, 5 do for k, v in ipairs(Towers) do if v.coords == d[i] then Towers[k].close = true break end end end
    local oX, oY = math.random(-1000, 1000), math.random(-1000, 1000)
    exports['qb-phone']:NotifyGroup(currentGroup, 'Signal Locked. Visit Cell Towers to increase precision.', 'success')
    exports['qb-phone']:CreateBlipForGroup(currentGroup, 'crBankTruck_'..towersDone, {radius = 2500.0, coords = vector3(truck.x+oX, truck.y+oY, truck.z), color = 72, alpha = 120})
    exports['qb-phone']:setJobStatus(currentGroup, "Bank Truck Tracking", jobStages)
    for _, v in ipairs(Towers) do exports['qb-phone']:CreateBlipForGroup(currentGroup, 'signalTower_'..v.key, {coords = v.coords, scale = 1.5, sprite = 161, color = 1, alpha = 120}) end
    local members = exports['qb-phone']:getGroupMembers(currentGroup)
    for _, v in ipairs(members) do
        TriggerClientEvent('cr-armoredtrucks:client:prepTruck', v, truck)
        doneToday[QBCore.Functions.GetPlayer(v).PlayerData.citizenid] = true
    end
end)


RegisterNetEvent('cr-armoredtrucks:server:precisionDone', function(tower)
    local src = source
    if Towers[tower].done then return end
    exports['qb-phone']:RemoveBlipForGroup(currentGroup, 'signalTower_'..Towers[tower].key)
    if not Towers[tower].close then
        TriggerClientEvent('QBCore:Notify', src, 'This tower is too far from the truck to properly amplify it\'s signal...', 'error')
    return end
    exports['qb-phone']:RemoveBlipForGroup(currentGroup, 'crBankTruck_'..towersDone)
    towersDone = towersDone + 1
    Towers[tower].done = true
    exports['qb-phone']:NotifyGroup(currentGroup, 'Signal Applified. GPS Updated.', 'success')
    Wait(500)
    local truck = Config.Signal.TruckLocations[currentTruck]
    local oX, oY = math.random(-1000+(towersDone*100), 1000-(towersDone*100)), math.random(-1000+(towersDone*100), 1000-(towersDone*100))
    if towersDone >= 5 then
        jobStages[1].isDone = true
        for k, v in pairs(Towers) do  exports['qb-phone']:RemoveBlipForGroup(currentGroup, 'signalTower_'..v.key) end
        exports['qb-phone']:setJobStatus(currentGroup, "Bank Truck Tracking", jobStages)
        exports['qb-phone']:CreateBlipForGroup(currentGroup, 'crBankTruck_'..towersDone, {coords = truck, scale = 1.0, sprite = 67, color = 1, alpha = 255})
    else
        exports['qb-phone']:CreateBlipForGroup(currentGroup, 'crBankTruck_'..towersDone, {radius = 2500.0-towersDone*500, coords = vector3(truck.x+oX, truck.y+oY, truck.z), color = 72, alpha = 120})
    end
end)

RegisterNetEvent('cr-armoredtrucks:server:foundSignalTruck', function(coords)
    GlobalState['SignalTruck:foundTruck'] = true
    jobStages[1].isDone = true
    jobStages[2].isDone = true
    exports['qb-phone']:setJobStatus(currentGroup, "Bank Truck Tracking", jobStages)
    exports['qb-phone']:RemoveBlipForGroup(currentGroup, 'crBankTruck_'..towersDone)
    for k, v in ipairs(Towers) do exports['qb-phone']:RemoveBlipForGroup(currentGroup, 'signalTower_'..v.key) end
    Wait(500)
    if towersDone < 5 then exports['qb-phone']:CreateBlipForGroup(currentGroup, 'crBankTruck_'..towersDone, {coords = coords, scale = 1.0, sprite = 67, color = 1, alpha = 255}) end
end)

RegisterNetEvent('cr-armoredtrucks:server:doDoorPoint', function(coords, veh)
    local members = exports['qb-phone']:getGroupMembers(currentGroup)
    for _, v in ipairs(members) do TriggerClientEvent('cr-armoredtrucks:client:doDoorPoint', v, coords, veh) end
end)

RegisterNetEvent('cr-armoredtrucks:server:thermTruck', function(bool)
    jobStages[3].isDone = true
    exports['qb-phone']:setJobStatus(currentGroup, "Bank Truck Tracking", jobStages)
    GlobalState['SignalTruck:thermited'] = bool
end)

-- Check if player can start the heist.
QBCore.Functions.CreateCallback('cr-armoredtrucks:canStartSignalHeist', function(source, cb)
    local src = source
    if HeistInProgress then TriggerClientEvent('QBCore:Notify', source, 'The signal has been lost...', 'error') cb(false) return end

    local item = QBCore.Functions.GetPlayer(src).Functions.GetItemByName('truck_locator_1')
    if not item then TriggerClientEvent('QBCore:Notify', source, 'You don\'t have anything to connect to this', 'error') cb(false) return end
    local qual = item.info.quality
    if qual-50 <= 0 then TriggerClientEvent('QBCore:Notify', source, 'Your locator doesn\'t have enough powert to receive a signal...', 'error') return end

    local group = exports['qb-phone']:GetGroupByMembers(src)
    if not group then TriggerClientEvent('QBCore:Notify', source, 'You need to be in a group before doing this...', 'error') cb(false) return end
    if exports['qb-phone']:getGroupSize(group) > 5 then TriggerClientEvent('QBCore:Notify', source, 'Your group is too big, you can have a maximum of 5 people!', 'error') cb(false) return end
    local members = exports['qb-phone']:getGroupMembers(group)
    for _, v in ipairs(members) do if doneToday[QBCore.Functions.GetPlayer(v).PlayerData.citizenid] then TriggerClientEvent('QBCore:Notify', source, 'Someone in your group has done this job today already!', 'error') cb(false) return end end
    cb(true)
end)

-- Checks if the heist is on timeout
QBCore.Functions.CreateCallback('cr-armoredtrucks:signalTimeout', function(source, cb, coords)
    if onCooldown then cb(false) else
        CurrentTruck = QBCore.Functions.SpawnVehicle(source, 'stockade', coords)
        cachedEntities[1] = NetworkGetNetworkIdFromEntity(CurrentTruck)
        GlobalState['SignalTruck:truckSpawned'] = true
        cb(NetworkGetNetworkIdFromEntity(CurrentTruck))
    end
end)

QBCore.Functions.CreateUseableItem('truck_locator_1', function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) then
        if onCooldown then TriggerClientEvent('QBCore:Notify', src, 'The locator doesn\'t detect anything at the moment.', 'error') return end
        if not HeistInProgress and not onCooldown then TriggerClientEvent('QBCore:Notify', src, 'The locator detects a faint signal, use the computer at the Hub to lock on it.', 'error') return end
        local pCoords = GetEntityCoords(GetPlayerPed(src))
        for k, v in ipairs(Towers) do if v.point:contains(pCoords) then
            if v.done then return end
            if exports['qb-phone']:GetGroupByMembers(src) ~= currentGroup then return end
            if os.time() > HeistTime + 30 * 60 then exports['qb-phone']:NotifyGroup(currentGroup, 'The Truck Signal Has Been Lost...', 'error') return end
            local qual = item.info.quality
            if qual-5 <= 0 then TriggerClientEvent('QBCore:Notify', source, 'Your locator is too broken to receive a signal...', 'error') return end
            Player.PlayerData.items[item.slot].info.quality = item.info.quality - 5
            Player.Functions.SetInventory(Player.PlayerData.items)
            TriggerClientEvent('cr-armoredtrucks:client:connectToTower', src, towersDone, k)
            break
        end end
    end
end)

RegisterServerEvent('cr-armoredtrucks:server:SignalPayouts', function()
    if GetTimeOut() then TriggerClientEvent('QBCore:Notify', source, 'You took too long... The deal is off!', 'error') SetTimeOut(false) return end
    onCooldown = true
	local PlayerId = source
	local Player = QBCore.Functions.GetPlayer(PlayerId)

    exports['mdn-extras']:GiveLootBag(PlayerId, 'SignalTruck')
    jobStages[4].isDone = true
    exports['qb-phone']:setJobStatus(currentGroup, "Bank Truck Tracking", jobStages)

    local charinfo = Player.PlayerData.charinfo
    local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
    local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
    local pName = firstName.." "..lastName
    local logString = {ply = GetPlayerName(PlayerId), txt = "Player : ".. GetPlayerName(PlayerId) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\n ** Has completed the Truck Signal Heist"}
    TriggerEvent("qb-log:server:CreateLog", "armTruck", "Heist Completed (Signal).", "green", logString)

    exports['qb-phone']:NotifyGroup(currentGroup, 'Job Completed, Good Job!', 'success')
    exports['qb-phone']:resetJobStatus(currentGroup)
    exports['qb-phone']:RemoveBlipForGroup(currentGroup, 'crBankTruck')
    for _, v in ipairs(Towers) do exports['qb-phone']:RemoveBlipForGroup(currentGroup, 'signalTower_'..v.key) end
    HeistInProgress = false
    CreateThread(function()
        Wait(Config.Signal.Cooldown * 60000)
        GlobalState['SignalTruck:foundTruck'] = false
        GlobalState['SignalTruck:truckSpawned'] = false
        GlobalState['SignalTruck:thermited'] = false

        for k, v in pairs(cachedEntities) do if DoesEntityExist(v) then DeleteEntity(v) end end
        for k, v in ipairs(Towers) do v.close = nil v.done = nil end
        for k, v in ipairs(jobStages) do v.isDone = false end
        currentGroup, towersDone, currentTruck, HeistTime = 0, 0, 0, 0
        ToggleCD(false)
    end)
end)
