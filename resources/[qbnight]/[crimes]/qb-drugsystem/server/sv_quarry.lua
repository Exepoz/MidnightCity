if not Shared.Enable.Missions then return end
local instance = os.time()
local SpotLights = {}
GlobalState.SpotLightPos = SpotLights
local currentMission
local currentShack, currentTruck, keyId = 0, 0, 0
local foundKey = false
local cachedObjects = {}
local cachedGuards = {}
local cachedEntities = {}
local cachedTrucks = {}
local transferProgress = 0

local TipTruckSpawns = {
    --vector4(2553.86, 2699.12, 41.66, 286.56), --Testing location (Quarry)
    vector4(2462.59, 1600.28, 32.72, 215.99),
    vector4(1117.38, -2468.75, 30.71, 87.96),
    vector4(1363.92, -1874.43, 56.94, 7.25),
    vector4(1114.98, -2233.82, 30.1, 92.61),
    vector4(713.76, -2271.23, 27.47, 81.5),
    vector4(-92.82, -979.65, 21.28, 158.84),
    vector4(-454.0, -992.57, 23.55, 86.47),
    vector4(53.22, -318.78, 44.63, 161.38)
}

local QuarryTrucks = {
    vector4(2703.58, 2865.6, 37.84, 16.2),
    vector4(2702.16, 2821.14, 40.55, 122.98),
    vector4(2697.69, 2889.74, 36.65, 170.0),
    vector4(2648.58, 2879.47, 36.57, 223.41),
    vector4(2612.12, 2831.58, 33.69, 81.82),
    vector4(2662.91, 2781.98, 33.78, 280.66),
}

local AlluminumReady = {}
CreateThread(function()
	local LoadJson = json.decode(LoadResourceFile(GetCurrentResourceName(), 'AlluReady.json'))
    AlluminumReady = LoadJson
	GlobalState.AlluminumReady = AlluminumReady
end)

RegisterNetEvent('qb-drugsystem:server:AlluGangReady', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local emailData = {
        sender = 'Anonymous',
        subject = 'Product Available',
        message = "Your alluminum is ready. Head over to the marked location in the attachment to collect your gang's product.",
        button = {enabled = true, buttonEvent = 'qb-drugsystem:client:getAlluPing'}
    } TriggerEvent('qs-smartphone:server:sendNewMailToOffline', Player.PlayerData.citizenid, emailData)
end)

RegisterNetEvent('qb-drugsystem:server:collectAllu', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not AlluminumReady[Player.PlayerData.gang.name] or AlluminumReady[Player.PlayerData.gang.name] == instance then TriggerClientEvent("QBCore:Notify", src, 'The box has already been picked up!','error') return end
    local info = {qty = 10}
    if Player.Functions.AddItem('shredded_aluminum', 1, false, info) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['shredded_aluminum'], 'add', 1)
        AlluminumReady[Player.PlayerData.gang.name] = nil
        GlobalState.AlluminumReady = AlluminumReady
        SaveResourceFile(GetCurrentResourceName(), "AlluReady.json", json.encode(AlluminumReady), -1)

        local charinfo = Player.PlayerData.charinfo
        local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
        local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
        local pName = firstName.." "..lastName
        local logString = {ply = GetPlayerName(src), txt = "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\n ** Has collected their gang's shredded aluminum**"}
        TriggerEvent("qb-log:server:CreateLog", "MethMissions", "Aluminum Collected", "green", logString)

    else TriggerClientEvent("QBCore:Notify", src, 'You can\'t carry this..','error') end
end)

QBCore.Functions.CreateCallback('qb-drugsystem:server:getInstance', function(source, cb)
    cb(instance)
end)
--- Functions

--- Method to clear all mission objects and guards
--- @return nil
local clearMission = function()
    for i=1, #cachedObjects do
        DeleteEntity(cachedObjects[i])
    end

    for i=1, #cachedEntities do
        if DoesEntityExist(cachedEntities[i]) then
            DeleteEntity(cachedEntities[i])
        end
    end

    for i=1, #cachedTrucks do
        if DoesEntityExist(cachedTrucks[i]) then
            DeleteEntity(cachedTrucks[i])
        end
    end
    currentMission = nil
    cachedObjects = {}
    cachedGuards = {}
    cachedEntities = {}
    cachedTrucks = {}
end

--- Events

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    clearMission()
end)

local SLI = {}
for k, v in pairs(Shared.QuarrySpotLights) do
    SLI[k] = {
        betweenDis = 0.0,
        dir = 1,
        currentStart = 1,
        WaitTime = nil,
        mTime = GetGameTimer(),
        CoordA = v.lightPath[1].coords,
        CoordB = v.lightPath[2].coords,
        CoordA_k = 1,
        CoordB_k = 2,
        nextWaitTime = v.lightPath[1].wait,
        vB = vector3(0,0,0)
    }
end

local spotLightLogic = function(src)
    Citizen.CreateThread(function()
        local mv = {}
        for k, v in ipairs(Shared.QuarrySpotLights) do
            mv[k] = {
                time = v.lightPath[1].timeToNext,
                newLoc = v.lightPath[2].coords,
                newLocc = 2
            }
            GlobalState['SpotLightMove'..k] = mv[k]
        end
        while true do
            for k, v in ipairs(Shared.QuarrySpotLights) do
                -- if SLI[k].PlayerFocus then
                --     SLI[k].vB = GetEntityCoords(SLI[k].PlayerFocus)
                --     if #(GetEntityCoords(SLI[k].PlayerFocus) - v.loc) > 45 then SLI[k].PlayerFocus = false end
                --     goto skip
                -- end
                local timeToNext = mv[k].time
                SLI[k].betweenDis = 1 - (SLI[k].mTime + timeToNext - GetGameTimer()) / timeToNext

                if SLI[k].betweenDis > 1.0 then SLI[k].betweenDis = 1.0 end
                if SLI[k].betweenDis == 1.0 then
                    if not SLI[k].WaitTime then SLI[k].WaitTime = GetGameTimer() end
                    if GetGameTimer() > SLI[k].WaitTime + SLI[k].nextWaitTime and not SLI[k].processing then
                        SLI[k].processing = true
                        SLI[k].WaitTime = nil
                        if SLI[k].dir == 1 then
                            SLI[k].currentStart = SLI[k].currentStart + 1
                            SLI[k].CoordA = v.lightPath[SLI[k].currentStart].coords
                            SLI[k].CoordA_k = SLI[k].currentStart
                            if SLI[k].currentStart >= #v.lightPath then
                                SLI[k].dir = 2
                                SLI[k].CoordB = v.lightPath[#v.lightPath - 1].coords
                                SLI[k].CoordB_k = #v.lightPath - 1
                                SLI[k].nextWaitTime = v.lightPath[#v.lightPath - 1].wait
                            else
                                SLI[k].CoordB = v.lightPath[SLI[k].currentStart + 1].coords
                                SLI[k].nextWaitTime = v.lightPath[SLI[k].currentStart + 1].wait
                                SLI[k].CoordB_k = SLI[k].currentStart + 1
                            end
                        elseif SLI[k].dir == 2 then
                            SLI[k].currentStart = SLI[k].currentStart - 1
                            if SLI[k].currentStart <= 1 then
                                SLI[k].dir = 1
                                SLI[k].CoordA = v.lightPath[1].coords
                                SLI[k].CoordA_k = 1
                                SLI[k].CoordB = v.lightPath[2].coords
                                SLI[k].CoordB_k = 2
                                SLI[k].nextWaitTime = v.lightPath[2].wait
                            else
                                SLI[k].CoordA = v.lightPath[SLI[k].currentStart].coords
                                SLI[k].CoordA_k = SLI[k].currentStart
                                SLI[k].CoordB = v.lightPath[SLI[k].currentStart - 1].coords
                                SLI[k].nextWaitTime = v.lightPath[SLI[k].currentStart - 1].wait
                            end
                        end
                        SLI[k].betweenDis = 0.0
                        SLI[k].mTime = GetGameTimer()
                        if SLI[k].dir == 1 then timeToNext = v.lightPath[SLI[k].currentStart].timeToNext else timeToNext = v.lightPath[SLI[k].currentStart].timeToPrev end
                        mv[k] = {time = timeToNext, newLoc = SLI[k].CoordB, newLocc = SLI[k].CoordB_k}
                        GlobalState['SpotLightMove'..k] = mv[k]
                        --print("Finished Updating State "..k.." | Loc : "..SLI[k].CoordA_k)
                        SLI[k].processing = false
                    end
                end
            end
            if PlayerCaught or not currentMission then break end
            Wait(200)
        end
    end)
end

QBCore.Functions.CreateCallback('qb-drugsystem:server:CanStartQuarry', function(source, cb, missionType)
    local src = source
    currentMission = math.random(#Shared.Quarry[missionType])
    local pData = QBCore.Functions.GetPlayer(source).PlayerData
    debugPrint(GetPlayerName(src) .. ' (' .. src .. ')' .. ' has started [' ..missionType.. '] mission ' .. currentMission)
    CreateThread(function()
        Wait(Shared.MissionCoolDown * 60 * 1000)
        clearMission()
    end)
    local Player = QBCore.Functions.GetPlayer(src)
    local charinfo = Player.PlayerData.charinfo
    local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
    local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
    local pName = firstName.." "..lastName
    local logString = {ply = GetPlayerName(src), txt = "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\nHas started the quarry mission ("..Player.PlayerData.gang.name..")"}
    TriggerEvent("qb-log:server:CreateLog", "MethMissions", "Quarry Mission Started", "green", logString)

    local str = "Hey. You need to get to the quarry and bring back the cargo. We will transform it for you. Here is your tasks :<br><br>- Steal the Tip-Truck<br>- Get to the Quarry.<br>- Find the right Dump Truck.<br>- Find the Truck Key in one of the shacks<br>- Start the Truck to initiate the transfer<br>- Bring the Tip Truck Behind the Dump Truck & Fill the bin<br>- Once Filled, bring back the truck to the foundry.<br><br>Do NOT get caught, do NOT get seen and DO NOT CROSS the Train Tracks."
    local emailData = {
        sender = 'Anonymous',
        subject = _U('phone_title_current'),
        message = str
        --"Go find steal the tip truck and bring it to the quarry, don't get caught and don't be seen. You'll have to find the dump truck containing the cargo, find it's key and transfer the content to your truck. Bring the stuff back to the foundry after. Good luck.",
    } TriggerEvent('qs-smartphone:server:sendNewMailToOffline', pData.citizenid, emailData)
    local tCoords = math.random(#TipTruckSpawns)
    -- -- Creates the Small Truck the players have to steal.
    -- local veh = CreateVehicle('tiptruck2', TipTruckSpawns[tCoords].x, TipTruckSpawns[tCoords].y, TipTruckSpawns[tCoords].z, TipTruckSpawns[tCoords][4], true, true)
    -- while not DoesEntityExist(veh) do Wait(0) end
    -- SetEntityDistanceCullingRadius(veh, 2000.0)
    -- --while NetworkGetEntityOwner(veh) ~= source do Wait(0) end
    -- cachedEntities[1] = NetworkGetNetworkIdFromEntity(veh)
    -- TriggerClientEvent('qb-drugsystem:client:startQMission', -1, pData.gang.name, cachedEntities, TipTruckSpawns[tCoords])
    cb(true, tCoords, TipTruckSpawns[tCoords])
end)

RegisterNetEvent("qb-drugsystem:server:vanPrepped", function(loc, coords)
    local src = source
    -- Creates the Small Truck the players have to steal.
    local veh = CreateVehicle('tiptruck2', TipTruckSpawns[loc].x, TipTruckSpawns[loc].y, TipTruckSpawns[loc].z, TipTruckSpawns[loc][4], true, true)
    while not DoesEntityExist(veh) do Wait(0) end
    --SetEntityDistanceCullingRadius(veh, 2000.0)
    Citizen.CreateThread(function() while NetworkGetEntityOwner(veh) ~= src do Wait(0) end end)
    cachedEntities[1] = NetworkGetNetworkIdFromEntity(veh)
    local pData =QBCore.Functions.GetPlayer(src).PlayerData
    TriggerClientEvent('qb-drugsystem:client:startQMission', -1, pData.gang.name, cachedEntities, TipTruckSpawns[loc])

end)

QBCore.Functions.CreateCallback('qb-drugsystem:server:EnterQuarryZone', function(source, cb, missionType)
    if not currentMission then cb(nil) return  end
    -- local emailData = {
    --     sender = 'Anonymous',
    --     subject = _U('phone_title_current'),
    --     message = _U('enter_area'),
    -- } TriggerEvent('qs-smartphone:server:sendNewMailToOffline', QBCore.Functions.GetPlayer(source).PlayerData.citizenid, emailData)
    currentShack = math.random(#Shared.QuarryShacks)
    currentTruck = math.random(#QuarryTrucks)
    -- Spawn the Big Dump Trucks, Choses which one is the Cargo Truck
    keyId = math.random(1111,9999)
    for k, v in ipairs(QuarryTrucks) do
        local veh = CreateVehicle('dump', v, true, true)
        while not DoesEntityExist(veh) do Wait(0) end
        SetEntityDistanceCullingRadius(veh, 2000.0)
        Entity(veh).state.loc = k
        if k == currentTruck then
            Entity(veh).state.keyId = keyId
            Entity(veh).state.hasCargo = true
        end
        Citizen.CreateThread(function() while NetworkGetEntityOwner(veh) ~= src do Wait(0) end end)
        cachedTrucks[k] = NetworkGetNetworkIdFromEntity(veh)
    end

    -- Starts the Spotlights Logic
    spotLightLogic()

    --cachedEntities[2] = NetworkGetNetworkIdFromEntity(driver)
    TriggerClientEvent('qb-drugsystem:client:startLoop', -1, QBCore.Functions.GetPlayer(source).PlayerData.gang.name, cachedEntities, cachedTrucks)
    cb(cachedEntities)
end)

function GetVector3Between(vectorA, vectorB, percentage)
    local direction = vectorB - vectorA
    local magnitude = #(direction)

    if magnitude == 0 then
        return vectorA
    end

    local normalizedDirection = direction / magnitude
    local vector3Between = vectorA + normalizedDirection * (magnitude * percentage)

    return vector3Between
end

RegisterNetEvent('qb-drugsystem:server:playerCaught', function()
    local src = source
    if not currentMission then return end
    Wait(4000)
    TriggerClientEvent('qb-drugsystem:client:quarryPlayerCaught', -1)
    Wait(1000)
    PlayerCaught = true
end)

RegisterNetEvent('qb-drugsystem:server:markerColor', function()
    TriggerClientEvent('qb-drugsystem:client:markerColor', -1, false)
end)

RegisterNetEvent('qb-drugsystem:server:quarryFinished', function()
    local src = source
    if not currentMission then return end
    local Player = QBCore.Functions.GetPlayer(src)
    Wait(5000)
    local emailData = {
        sender = 'Anonymous',
        subject = "Well Done",
        message = "Well done on the job, we'll process the stuff and send you an email once it's ready. It might take a day.",
    } TriggerEvent('qs-smartphone:server:sendNewMailToOffline',Player.PlayerData.citizenid, emailData)
    AlluminumReady[Player.PlayerData.gang.name] = instance
    GlobalState.AlluminumReady = AlluminumReady
    SaveResourceFile(GetCurrentResourceName(), "AlluReady.json", json.encode(AlluminumReady), -1)
    TriggerClientEvent('qb-drugsystem:client:cleanQuarry', -1, Player.PlayerData.gang.name)

    local charinfo = Player.PlayerData.charinfo
    local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
    local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
    local pName = firstName.." "..lastName
    local logString = {ply = GetPlayerName(src), txt = "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\nHas finished the quarry mission ("..Player.PlayerData.gang.name..")"}
    TriggerEvent("qb-log:server:CreateLog", "MethMissions", "Quarry Mission Finished", "green", logString)
end)

local transferDone = false
RegisterNetEvent('qb-drugsystem:server:isInTransferZone', function()
    local src = source
    if not currentMission then return end
    transferProgress = transferProgress + 1.1
    if transferProgress > 100 then transferProgress = 100 end
    TriggerClientEvent('qb-drugsystem:client:showQuarryProgress', -1, QBCore.Functions.GetPlayer(src).PlayerData.gang.name, transferProgress)
    TriggerClientEvent('qb-drugsystem:client:markerColor', -1, true)
    if transferProgress == 100 and not transferDone then
        transferDone = true
        TriggerClientEvent('qb-drugsystem:client:transferDone', -1, QBCore.Functions.GetPlayer(src).PlayerData.gang.name)
    end
end)

RegisterNetEvent('qb-drugsystem:server:transferStarted', function(t)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local key = Player.Functions.GetItemByName('dump_key')
    if not key or Player.PlayerData.items[key.slot].info.id ~= keyId then
        TriggerClientEvent("QBCore:Notify", src, 'Something went wrong...','error')
    return end
    if Player.Functions.RemoveItem('dump_key', 1) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['dump_key'], 'remove', 1)
        TriggerClientEvent('qb-drugsystem:client:startTransfer', -1, Player.PlayerData.gang.name, t)
    end
end)

RegisterNetEvent('qb-drugsystem:server:foundDump', function(truck)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    truck = NetworkGetEntityFromNetworkId(cachedTrucks[truck])
    Entity(truck).state.searched = true
    TriggerClientEvent('qb-drugsystem:client:foundDump', -1, Entity(truck).state.loc)
end)

RegisterNetEvent('qb-drugsystem:server:searchShack', function(shack)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not currentMission  or foundKey then return end
    if shack == currentShack then
        foundKey = true
        Player.Functions.AddItem('dump_key', 1, false, {id = keyId})
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['dump_key'], 'add', 1)
    end
end)


--- Threads

-- CreateThread(function() -- Used to test set up of crates
--     for missionType, _ in pairs(Shared.Missions) do
--         currentMission = 1
--         local difficulty = Shared.Missions[missionType][currentMission].difficulty

--         for i=1, #Shared.Missions[missionType][currentMission].crates do
--             local created_object = CreateObjectNoOffset(`ch_prop_ch_chemset_01a`, Shared.Missions[missionType][currentMission].crates[i].x, Shared.Missions[missionType][currentMission].crates[i].y, Shared.Missions[missionType][currentMission].crates[i].z - 1.0, true, true, false)
--             SetEntityHeading(created_object, Shared.Missions[missionType][currentMission].crates[i].w)
--             FreezeEntityPosition(created_object, true)
--             cachedObjects[#cachedObjects + 1] = created_object
--         end
--         print('peds')
--         for i=1, #Shared.Missions[missionType][currentMission].guards do
--             print(Shared.Missions[missionType][currentMission].guards[i].xyz)
--             local npc = CreatePed(4, `s_m_y_swat_01`, Shared.Missions[missionType][currentMission].guards[i].x, Shared.Missions[missionType][currentMission].guards[i].y, Shared.Missions[missionType][currentMission].guards[i].z - 1.0, true, false)
--             print(npc)
--             print(GetEntityCoords(npc))
--             while not DoesEntityExist(npc) do Wait(0) end
--             GiveWeaponToPed(npc, Shared.DifficultySettings[difficulty].weapon, 250, false, true)
--             SetPedArmour(npc, Shared.DifficultySettings[difficulty].armor)
--             cachedGuards[#cachedGuards + 1] = npc
--         end
--         print('peds done')
--     end
-- end)