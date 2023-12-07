if not Shared.Enable.Missions then return end
local currentMission

local cachedObjects = {}
local cachedGuards = {}

--- Functions

--- Method to clear all mission objects and guards
--- @return nil
local clearMission = function()
    for i=1, #cachedObjects do
        DeleteEntity(cachedObjects[i])
    end

    for i=1, #cachedGuards do
        if DoesEntityExist(cachedGuards[i]) then
            DeleteEntity(cachedGuards[i])
        end
    end

    currentMission = nil
    cachedObjects = {}
    cachedGuards = {}
end

--- Events

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    clearMission()
end)

local items = {
    ['thorium'] = 'thorium_oxide',
    ['kerosene'] = 'kerosene_barrel'
}

RegisterNetEvent('qb-drugsystem:server:GrabMaterialCrate', function(netId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if type(netId) ~= 'number' or not Player then return end
    local gang = Player.PlayerData.gang.name
    local entity = NetworkGetEntityFromNetworkId(netId)

    for i=1, #cachedObjects do
        if cachedObjects[i] == entity then
            DeleteEntity(entity)
            cachedObjects[i] = 0
            local info = {qty = 100}
            Player.Functions.AddItem(items[GlobalState.GangsData[gang].HeistInProgress], 1, false, info)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[items[GlobalState.GangsData[gang].HeistInProgress]], 'add', 1)
            debugPrint(Player.PlayerData.name .. ' (' .. src .. ')' .. ' has received reward')
            return
        end
    end
end)

--- Callbacks

QBCore.Functions.CreateCallback('qb-drugsystem:server:CanStartMission', function(source, cb, missionType)
    local src = source
    currentMission = math.random(#Shared.Missions[missionType])
    debugPrint(GetPlayerName(src) .. ' (' .. src .. ')' .. ' has started [' ..missionType.. '] mission ' .. currentMission)
    CreateThread(function()
        Wait(Shared.MissionCoolDown * 60 * 1000)
        clearMission()
    end)
    cb(true, currentMission)
end)

QBCore.Functions.CreateCallback('qb-drugsystem:server:EnterMissionZone', function(source, cb, missionType)
    if not currentMission then
        cb(nil)
        return
    end

    for _, v in pairs(Shared.Missions[missionType][currentMission].crates) do
        local created_object = CreateObjectNoOffset(GetHashKey('ch_prop_ch_chemset_01a'), v.x, v.y, v.z - 1.0, true, true, false)
        SetEntityHeading(created_object, v.w)
        FreezeEntityPosition(created_object, true)
        cachedObjects[#cachedObjects + 1] = created_object
        break
    end

    local difficulty = Shared.Missions[missionType][currentMission].difficulty
    local playerPed = GetPlayerPed(source)
    local netIds = {}

    for i=1, #Shared.Missions[missionType][currentMission].guards do
        local npc = CreatePed(30, GetHashKey('g_m_y_armgoon_02'), Shared.Missions[missionType][currentMission].guards[i].x, Shared.Missions[missionType][currentMission].guards[i].y, Shared.Missions[missionType][currentMission].guards[i].z - 1.0, true, false)
        while not DoesEntityExist(npc) do Wait(0) end
        GiveWeaponToPed(npc, Shared.DifficultySettings[difficulty].weapon, 250, false, true)
        SetPedArmour(npc, Shared.DifficultySettings[difficulty].armor)
        TaskCombatPed(npc, playerPed, 0, 16)
        local netId = NetworkGetNetworkIdFromEntity(npc)
        netIds[#netIds + 1] = netId
        cachedGuards[#cachedGuards + 1] = npc
    end

    cb(netIds, Shared.DifficultySettings[difficulty].health)
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