if not Shared.Enable.Missions then return end
local BarrelsInTrunk = 0
GlobalState.FactoryBarrels = 5
local missionStarted = false
local currentMission, currentMissionType
local cachedEntities = {}

RegisterCommand('startMission', function(source) TriggerEvent('qb-drugsystem:server:CanStartBarrels', source, 'methy') end)

local VanSpawns = {
    --vector4(917.62, -2341.37, 30.38, 84.8), --Testing location (Factory 1)
    vector4(-691.67, -2459.21, 13.83, 109),
    vector4(-32.26, -2234.56, 7.81, 26),
    vector4(233.19, -1775.91, 28.70, 225),
    vector4(1199.41, -1264.27, 35.23, 213),
    vector4(1392.93, -752.87, 67.43, 68),
    vector4(1662.69, 1.38, 173.77, 211),
    vector4(-760.38, 690.78, 143.96, 208),
    vector4(-1111.00, -968.93, 2.24, 15),
    vector4(-1155.37, -1413.49, 4.87, 60),
}

--- Functions

--- Method to clear all mission objects and guards
--- @return nil
local clearMission = function()
    for i=1, #cachedEntities do
        if DoesEntityExist(cachedEntities[i]) then
            DeleteEntity(cachedEntities[i])
        end
    end
    currentMission = nil
    cachedEntities = {}
end

--- Events

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    clearMission()
end)

-- Bringing back a barrel to start an other mission.
RegisterNetEvent('malmo-goldentrail:server:giveBackBarrel', function(mission)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = "barrel_methylamine"
    if mission == "kerosene" then item = "barrel_kerosene" end
    if Player.Functions.RemoveItem(item, 1) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'remove', 1)
        TriggerEvent('mdn-extras:server:giveBackBarrel', src, mission)
        TriggerEvent('qb-drugsystem:server:CanStartBarrels', src, mission)
    end
end)

-- Check if player can start the mission & sends the info to the gang
RegisterNetEvent('qb-drugsystem:server:CanStartBarrels', function(source, missionType)
    if missionStarted then return end
    missionStarted = true
    local src = source
    currentMission = math.random(#Shared.Barrels[missionType])
    currentMissionType = missionType
    local pData = QBCore.Functions.GetPlayer(source).PlayerData
    debugPrint(GetPlayerName(src) .. ' (' .. src .. ')' .. ' has started [' ..missionType.. '] mission ' .. currentMission)

    -- 1 hour to complete the heist
    CreateThread(function()
        Wait(Shared.MissionCoolDown * 60 * 1000)
        clearMission()
    end)

    -- Email
    local str = "Hey. Go grab the van & we will send you the location of the factory. Go there at night, get inside the building and grab some methyliamine barrels. Bring 3 of them back to the van & you will keep one. Do NOT Get Caught."
    if missionType == "kerosene" then str = "Hey. Go grab the van & get to the airfield marked on your GPS at night. There, you will need to get inside the building and grab some kerosene barrels. Bring 3 of them back to the van & you will keep one. Do NOT Get Caught." end
    local emailData = {
        sender = 'Anonymous',
        subject = _U('phone_title_current'),
        message = str
    } TriggerEvent('qs-smartphone:server:sendNewMailToOffline', pData.citizenid, emailData)
    currentMission = math.random(#Shared.Barrels[missionType])
    local tCoords = math.random(#VanSpawns)
    TriggerClientEvent("qb-drugsystem:client:prepVan", source, VanSpawns[tCoords], tCoords)
    -- Creates the Van Truck the players have to steal.
    --local veh = CreateVehicle('speedo', VanSpawns[tCoords].x, VanSpawns[tCoords].y, VanSpawns[tCoords].z, VanSpawns[tCoords][4], true, true)
    --while not DoesEntityExist(veh) do Wait(0) end
    --SetEntityDistanceCullingRadius(veh, 2000.0)

    -- Selects the location where the heist takes place
    --Citizen.CreateThread(function() while NetworkGetEntityOwner(veh) ~= source do Wait(0) end end)

    --cachedEntities[1] = NetworkGetNetworkIdFromEntity(veh)
    --TriggerClientEvent('qb-drugsystem:client:startBMission', -1, pData.gang.name, cachedEntities, VanSpawns[tCoords], currentMission, missionType)
end)

-- Bringing back a barrel to start an other mission.
RegisterNetEvent('qb-drugsystem:server:preppedVan', function(coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
        -- Creates the Van Truck the players have to steal.
        local veh = CreateVehicle('speedo', VanSpawns[coords].x, VanSpawns[coords].y, VanSpawns[coords].z, VanSpawns[coords][4], true, true)
        while not DoesEntityExist(veh) do Wait(0) end
        Entity(veh).state.BarrelsVan = true
        --SetEntityDistanceCullingRadius(veh, 2000.0)

        -- Selects the location where the heist takes place
        Citizen.CreateThread(function() while NetworkGetEntityOwner(veh) ~= source do Wait(0) end end)

        cachedEntities[1] = NetworkGetNetworkIdFromEntity(veh)
        TriggerClientEvent('qb-drugsystem:client:startBMission', -1, Player.PlayerData.gang.name, cachedEntities, VanSpawns[coords], currentMission, currentMissionType)
end)

-- Player Grabbed a barrel
RegisterNetEvent('qb-drugsystem:server:grabbedBarrel', function()
    GlobalState.FactoryBarrels = GlobalState.FactoryBarrels - 1
end)

-- Player Placed a barrel inside the van
RegisterNetEvent('qb-drugsystem:server:depoBarrel', function(trunk)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    BarrelsInTrunk = BarrelsInTrunk + 1
    if BarrelsInTrunk >= 3 then
        TriggerClientEvent("qb-drugsystem:client:sendToFinish", -1, Player.PlayerData.gang.name)
    else
        TriggerClientEvent("QBCore:Notify", src, 'Just '.. 3 - BarrelsInTrunk.." more barrels!",'error')
    end
end)

-- Player Placed a barrel inside the van
local barrelGiven = false
RegisterNetEvent('qb-drugsystem:server:finishBarrelMission', function()
    if barrelGiven then return end
    barrelGiven = true
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = "methylamine"
    if currentMissionType == "kerosene" then item = "kerosene_barrel" end
    local info = {qty = 100}
    if Player.Functions.AddItem(item, 1, false, info) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add', 1)
        TriggerClientEvent('qb-drugsystem:client:finishState', -1)
        Wait(60000 * 2)
        TriggerClientEvent('qb-drugsystem:client:cleanBarrels', -1)
        barrelGiven = false
        clearMission()
    end
end)





-- RegisterNetEvent('qb-drugsystem:server:quarryFinished', function()
--     local src = source
--     if not currentMission then return end
--     local Player = QBCore.Functions.GetPlayer(src)
--     Wait(5000)
--     local emailData = {
--         sender = 'Anonymous',
--         subject = "Well Done",
--         message = "Well done on the job, we'll process the stuff and send you an email once it's ready.",
--     } TriggerEvent('qs-smartphone:server:sendNewMailToOffline',Player.PlayerData.citizenid, emailData)
--     -- Add Completed Mission Logic + Give Mats
--     TriggerClientEvent('qb-drugsystem:client:transferDone', -1, Player.PlayerData.gang.name)
-- end)