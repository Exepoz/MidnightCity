--- Anti Helicopter Guards

spawnedGuards = {}
local guardsSpawned = false

local spawnPoints = {
    vector4(1820.41, 2618.72, 62.96, 126.23),
    vector4(1845.89, 2696.83, 62.97, 143.1),
    vector4(1773.67, 2758.71, 62.92, 219.15),
    vector4(1651.61, 2754.45, 62.89, 203.36),
    vector4(1573.81, 2679.3, 62.76, 268.84),
    vector4(1538.56, 2585.67, 62.71, 253.6),
    vector4(1543.58, 2472.1, 62.75, 267.09),
    vector4(1658.79, 2398.57, 62.73, 14.97),
    vector4(1759.47, 2413.68, 62.73, 2.3),
    vector4(1820.13, 2476.68, 62.7, 22.49),
    vector4(1785.75, 2575.54, 59.92, 242.5),
    vector4(1758.17, 2477.14, 55.14, 207.36),
    vector4(1678.81, 2443.67, 55.16, 145.47),
    vector4(1602.32, 2477.58, 55.19, 143.81),
    vector4(1574.27, 2565.48, 55.19, 28.04),
    vector4(1637.88, 2692.61, 55.2, 12.28),
    vector4(1718.39, 2723.93, 55.19, 301.37),
    vector4(1783.98, 2700.91, 55.2, 317.75),
    vector4(1736.27, 2635.18, 59.95, 221.07)
}

local weapons = {
    `WEAPON_CARBINERIFLE`,
    `WEAPON_SPECIALCARBINE`,
    `WEAPON_HOMINGLAUNCHER`
}


lib.callback.register('qb-jail:server:SpawnAntiHelicopterGuards', function(source)
    local src = source
    local ped = GetPlayerPed(src)
    
    if guardsSpawned or not Config.AntiHelicopter then return nil end
    guardsSpawned = true

    local netIds = {}       
    for i = 1, #spawnPoints do
        local guard = CreatePed(30, `s_m_m_prisguard_01`, spawnPoints[i].x, spawnPoints[i].y, spawnPoints[i].z, spawnPoints[i].w, true, false)
        GiveWeaponToPed(guard, weapons[math.random(#weapons)], 250, false, true)
        SetPedArmour(guard, 500)

        spawnedGuards[#spawnedGuards + 1] = guard
        while not DoesEntityExist(guard) do Wait(10) end

        local netId = NetworkGetNetworkIdFromEntity(guard)
        netIds[#netIds + 1] = netId
    end

    debugPrint('Spawned AntiHelicopter Guards')

    -- Delete them after 5 minutes
    CreateThread(function()
        Wait(5 * 60 * 1000)

        for i = 1, #spawnedGuards, 1 do
            if DoesEntityExist(spawnedGuards[i]) then
                DeleteEntity(spawnedGuards[i])
            end
        end

        debugPrint('Deleted AntiHelicopter Guards')
        spawnedGuards = {}
        guardsSpawned = false
    end)

    return netIds
end)

--- Jailbreak

AddEventHandler('qb-powerplant:server:PowerPlantHit', function(plant, playerId)
    if plant == 'east' then
        Config.JailBreak.PowerplantHit = true
        TriggerClientEvent('qb-jail:client:SetPowerPlant', -1, true)
        debugPrint('Powerplant hit state set to ' .. tostring(true))
    end
end)

AddEventHandler('qb-powerplant:server:PowerPlantRestored', function(plant, playerId)
    if plant == 'east' then
        Config.JailBreak.PowerplantHit = false
        TriggerClientEvent('qb-jail:client:SetPowerPlant', -1, false)
        debugPrint('Powerplant hit state set to ' .. tostring(false))
    end
end)

RegisterNetEvent('qb-jail:server:ThermiteHit', function(index)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if not Config.JailBreak.Thermite[index] then return end
    if #(GetEntityCoords(GetPlayerPed(src)) - Config.JailBreak.Thermite[index][1].xyz) > 25 then return end
    if Config.JailBreak.Thermite[index][4] or not Config.JailBreak.PowerplantHit then return end

    Config.JailBreak.Thermite[index][4] = true
    TriggerClientEvent('qb-jail:client:ThermiteHit', -1, index)

    debugPrint(GetPlayerName(src) .. ' (' .. src .. ')' .. ' has thermited ' .. index)

    Wait(27000)
    Utils.DoorUpdate(src, Config.JailBreak.Thermite[index][3], 0)
end)

RegisterNetEvent('qb-jail:server:OutsideHack', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    if not Config.JailBreak.PowerplantHit or not Config.JailBreak.Thermite[1][4] or Config.JailBreak.VARHack then return end
    if #(GetEntityCoords(GetPlayerPed(src)) - vector3(1831.31, 2603.95, 45.89)) > 25 then return end

    -- Put prison in lock down
    Config.JailBreak.VARHack = true
    Config.JailBreak.JailBreakActive = true
    
    Utils.DoorUpdate(src, 'jail-door5', 1)
    Utils.DoorUpdate(src, 'jail-gate2', 0)

    for i = 1, 27, 1 do
        local door = 'cell_door_' .. i
        Utils.DoorUpdate(src, door, 1)
    end

    -- Place jailed players in their cells
    local temp = {} -- We store cells to spread the jailedPlayers
    for k, v in pairs(jailedPlayers) do
        if v then
            local random = math.random(#Config.Locations['cells'])

            while temp[random] do random = math.random(#Config.Locations['cells']) end
            temp[random] = true

            local ped = GetPlayerPed(k)
            SetEntityCoords(ped, Config.Locations['cells'][random].xyz)
            SetEntityHeading(ped, Config.Locations['cells'][random].w)

            debugPrint(GetPlayerName(k) .. ' (' .. k .. ')' .. ' has been sent to cell: ' .. random)
            TriggerClientEvent('qb-jail:client:ChangeJob', k, 'lockup')
            Utils.Notify(k, Locales['notify_jailbreak_active'], 'error', 8000)

            Utils.CreateLog(Player.PlayerData.name, 'Start Jailbreak', 'Start Jailbreak', Player.PlayerData.name .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. src .. ')' .. ' has started jailbreak ' .. #jailedPlayers .. ' sent to cells')

            if #temp == #Config.Locations['cells'] then temp = {} end -- Reset temp if all cells occupied
        end
    end

    TriggerClientEvent('qb-jail:client:ActivateLockdown', -1, true)

    SetTimeout(Config.JailBreakDuration * 60 * 1000, function()
        if not Config.JailBreak.JailBreakActive then return end
        
        debugPrint('Jail Break has ended, resetting doorlocks and JailBreakActive')
        Config.JailBreak.JailBreakActive = false
        Utils.DoorUpdate(src, 'jail-door5', 0)
        
        for i = 1, 27, 1 do
            local door = 'cell_door_' .. i
            Utils.DoorUpdate(src, door, 0)
        end

        TriggerClientEvent('qb-jail:client:ActivateLockdown', -1, false)
    end)
end)

RegisterNetEvent('qb-jail:server:RequestJailBreakRelease', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if not Config.JailBreak.JailBreakActive then return end
    if not isPlayerInJail(src) then return false end

    -- Remove from jailedPlayers
    jailedPlayers[src] = nil
    Player.Functions.SetMetaData('injail', 0)

    -- Remove from jobgroups
    removeFromJobGroup(src, getPlayerJobGroup(src))

    -- Clear jailItems
    Player.Functions.SetMetaData('jailitems', {})

    Utils.Notify(src, Locales['notify_jailbreak'], 'success', 4000)
    debugPrint(Player.PlayerData.name .. ' (' .. src .. ')' .. ' has broken out of prison!')
    Utils.CreateLog(Player.PlayerData.name, 'Broken Out', 'Broken Out', Player.PlayerData.name .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. src .. ')' .. ' has broken out of prison')
end)

RegisterNetEvent('qb-jail:server:OpenCellDoor', function(cell)
    if not Config.JailBreak.JailBreakActive then return end

    Utils.DoorUpdate(src, 'cell_door_' .. cell, 0)
end)

RegisterNetEvent('qb-jail:server:ClearLockDown', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if not Config.JailBreak.JailBreakActive then return end

    if Utils.PlayerIsLeo(Player.PlayerData.job) then
        debugPrint(Player.PlayerData.name .. ' (' .. src .. ')' .. ' has ended JailBreak')
        Config.JailBreak.JailBreakActive = false
        
        Utils.DoorUpdate(src, 'jail-door5', 0)
        
        for i=1, 27, 1 do
            local door = 'cell_door_' .. i
            Utils.DoorUpdate(src, door, 0)
        end

        TriggerClientEvent('qb-jail:client:ActivateLockdown', -1, false)
    end
end)

lib.callback.register('qb-jail:server:GetJailBreakConfig', function(source)
    return Config.JailBreak
end)
