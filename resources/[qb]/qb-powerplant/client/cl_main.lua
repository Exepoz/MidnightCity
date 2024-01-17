QBCore = exports['qb-core']:GetCoreObject()

local currentStation = 0

local powerState = {
    city = false,
    east = false
}

--- Functions

--- Function to return whether or not the specific powerplant is hit
---@param plant string - powerState index, city or eastern power plant
---@return powerState boolean - Whether or not the powerplant is hit
local getPowerPlantState = function(plant)
    return powerState[plant]
end

--- Sends server sided ptfx for the thermite charge
---@return nil
local ThermiteEffect = function()
    lib.requestAnimDict('anim@heists@ornate_bank@thermal_charge')
    local ped = cache.ped
    local ptfx = Config.Locations[currentStation].ptfx
    Wait(1500)
    TriggerServerEvent('qb-powerplant:server:ThermitePtfx', ptfx)
    Wait(500)
    TaskPlayAnim(ped, 'anim@heists@ornate_bank@thermal_charge', 'cover_eyes_intro', 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
    TaskPlayAnim(ped, 'anim@heists@ornate_bank@thermal_charge', 'cover_eyes_loop', 8.0, 8.0, 3000, 49, 1, 0, 0, 0)
    Wait(25000)
    ClearPedTasks(ped)
    Wait(2000)
end

--- Performs the PlantThermite function and starts the minigame for thermite
---@return nil
local ThermitePlantCharge = function()
    lib.requestAnimDict('anim@heists@ornate_bank@thermal_charge')
    lib.requestModel('hei_p_m_bag_var22_arm_s')
    lib.requestNamedPtfxAsset('scr_ornate_heist')

    local ped = cache.ped
    local pos = vector3(Config.Locations[currentStation].animation.x, Config.Locations[currentStation].animation.y, Config.Locations[currentStation].animation.z)
    Wait(100)
    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(cache.ped)))
    local bagscene = NetworkCreateSynchronisedScene(pos.x, pos.y, pos.z, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(`hei_p_m_bag_var22_arm_s`, pos.x, pos.y, pos.z,  true,  true, false)
    SetEntityCollision(bag, false, true)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local charge = CreateObject(`hei_prop_heist_thermite`, x, y, z + 0.2,  true,  true, true)
    SetEntityCollision(charge, false, true)
    AttachEntityToEntity(charge, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    NetworkAddPedToSynchronisedScene(ped, bagscene, 'anim@heists@ornate_bank@thermal_charge', 'thermal_charge', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, 'anim@heists@ornate_bank@thermal_charge', 'bag_thermal_charge', 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)
    Wait(5000)
    DetachEntity(charge, 1, 1)
    FreezeEntityPosition(charge, true)
    DeleteObject(bag)
    NetworkStopSynchronisedScene(bagscene)

    CreateThread(function()
        Wait(15000)
        DeleteEntity(charge)
    end)
end

--- Creates an explosion effect for a given coordinate
---@param x number - X coordinate
---@param y number - Y coordinate
---@param z number - Z coordinate
---@return nil
local ppExplosion = function(x, y, z)
    CreateThread(function()
        SetPtfxAssetNextCall('core')
        local smoke = StartParticleFxLoopedAtCoord('exp_air_blimp', x, y, z, 0.0, 0.0, 0.0, 6.0, false, false, false, false)

        SetParticleFxLoopedAlpha(smoke, 0.8)
        SetParticleFxLoopedColour(smoke, 0.0, 0.0, 0.0, 0)
        AddExplosion(x, y, z, 29, 0.0, true, false, 3.0)
    end)
end

--- Events

RegisterNetEvent('qb-powerplant:client:thermite', function(data)
    if currentStation == 0 then return end

    if Config.Inventory == 'ox_inventory' and exports['ox_inventory']:Search('count', Config.ThermiteItem) == 0 then
        Utils.Notify(Locales['missing_items'], 'error', 2500)
        return
    elseif Config.Inventory == 'qb' and not QBCore.Functions.HasItem(Config.ThermiteItem) then
        Utils.Notify(Locales['missing_items'], 'error', 2500)
        return
    end

    local ped = cache.ped
    local pos = GetEntityCoords(ped)
    local dist = #(pos - Config.Locations[currentStation].coords)
    
    if dist > 1.5 then return end
    
    lib.callback('qb-powerplant:server:getCops', false, function(cops)
        if cops >= Config.MinimumPolice then
            if not Config.Locations[currentStation].hit then
                if not QBCore.Functions.IsWearingGloves() then
                    TriggerServerEvent('evidence:server:CreateFingerDrop', pos)
                end
                
                TriggerServerEvent('qb-powerplant:server:RemoveThermite')
                ThermitePlantCharge()
                exports['memorygame']:thermiteminigame(Config.ThermiteSettings.correctBlocks, Config.ThermiteSettings.incorrectBlocks, Config.ThermiteSettings.timetoShow, Config.ThermiteSettings.timetoLose, function()
                    if currentStation ~= 0 then
                        TriggerServerEvent('qb-powerplant:server:SetStationStatus', currentStation, true)
                    end

                    ThermiteEffect()
                end, function()
                    Utils.Notify(Locales['thermite_failed'], 'error', 2500)
                end)
            else
                Utils.Notify(Locales['fuses_already_blown'], 'error', 2500)
            end
        else
            Utils.Notify(Locales['not_enough_cops']:format(Config.MinimumPolice), 'error', 2500)
        end
    end)
end)

RegisterNetEvent('qb-powerplant:client:SetStationStatus', function(key, isHit)
    if type(key) == 'table' then
        for i = 1, #key, 1 do
            Config.Locations[key[i]] = isHit
        end
    else
        Config.Locations[key].hit = isHit
    end
end)

RegisterNetEvent('qb-powerplant:client:ThermitePtfx', function(coords)
    if #(GetEntityCoords(cache.ped) - coords) > 250 then return end
    
    lib.requestNamedPtfxAsset('scr_ornate_heist')
    SetPtfxAssetNextCall('scr_ornate_heist')
    local effect = StartParticleFxLoopedAtCoord('scr_heist_ornate_thermal_burn', coords, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    Wait(27500)
    StopParticleFxLooped(effect, 0)
end)

RegisterNetEvent('qb-powerplant:client:PowerPlantExplosion', function(plant)
    powerState[plant] = true
    TriggerEvent('qb-powerplant:client:PowerPlantHit', plant) -- Listen to in other resources

    if plant == 'east' then
        ppExplosion(2727.0825, 1477.4373, 35.695354)
        Wait(350)
        ppExplosion(2742.2595, 1507.0069, 35.695354)
        Wait(350)
        ppExplosion(2737.3876, 1536.5502, 35.6748)
        Wait(350)
        ppExplosion(2755.0556, 1571.2738, 39.294418)
        Wait(350)
        ppExplosion(2815.0053, 1512.393, 29.195352)
        Wait(350)
        ppExplosion(2830.6501, 1490.4455, 29.195352)
        Wait(350)
        ppExplosion(2839.4997, 1562.3775, 29.195352)
    elseif plant == 'city' then
        ppExplosion(710.22, 125.44, 84.90)
        Wait(350)
        ppExplosion(707.13, 106.91, 84.479)
        Wait(350)
        ppExplosion(698.28, 101.89, 84.47)
        Wait(350)
        ppExplosion(664.408,114.9,84.47)
        Wait(350)
        ppExplosion(664.00, 133.15, 84.01)
        Wait(350)
        ppExplosion(673.67, 157.436, 85.47)
        Wait(350)
        ppExplosion(673.67, 157.436, 84.47)
    end
end)

--- Threads

CreateThread(function()
    -- Fetch Config
    lib.callback('qb-powerplant:server:GetConfig', false, function(config, powerstate)
        Config = config
        powerState = powerstate
    end)

    -- Create Target
    for k, v in pairs(Config.Locations) do
        if k == 1 or k == 2 then
            exports['qb-target']:AddBoxZone('powerplantstation_' .. k, v.coords, 0.5, 0.65, {
                name = 'powerplantstation_' .. k,
                heading = 162,
                debugPoly = false,
                minZ = 24.65,
                maxZ = 25.35
             }, {
                options = { 
                    {
                        type = 'client',
                        event = 'qb-powerplant:client:thermite',
                        icon = 'fas fa-user-secret',
                        label = Locales['target_blow_fuses'],
                        canInteract = function()
                            return not Config.Locations[k].hit
                        end,
                    }
                },
                distance = 1.5,
            })
        elseif k == 3 or k == 4 then
            exports['qb-target']:AddBoxZone('powerplantstation_' .. k, v.coords, 0.5, 1.6, {
                name = 'powerplantstation_' .. k,
                heading = 255,
                debugPoly = false,
                minZ = 44.80,
                maxZ = 45.80
             }, {
                options = { 
                    {
                        type = 'client',
                        event = 'qb-powerplant:client:thermite',
                        icon = 'fas fa-user-secret',
                        label = Locales['target_destroy_generator'],
                        canInteract = function()
                            return not Config.Locations[k].hit
                        end,
                    }
                },
                distance = 1.50,
            })
        else
            exports['qb-target']:AddBoxZone('powerplantstation_' .. k, v.coords, 0.5, 0.6, {
                name = 'powerplantstation_' .. k,
                heading = 162,
                debugPoly = false,
                minZ = 80.97,
                maxZ = 81.57
             }, {
                options = { 
                    {
                        type = 'client',
                        event = 'qb-powerplant:client:thermite',
                        icon = 'fas fa-user-secret',
                        label = Locales['target_blow_fuses'],
                        canInteract = function()
                            return not Config.Locations[k].hit
                        end,
                    }
                },
                distance = 1.5,
            })
        end

        -- CurrentStation polyzone
        local box = lib.zones.box({
            coords = v.coords,
            size = vec3(3.0, 3.0, 2.0),
            rotation = 160.0,
            debug = false,
            onEnter = function()
                currentStation = k
            end,
            onExit = function()
                currentStation = 0
            end
        })
    end
end)

--- exports

exports('getPowerPlantState', getPowerPlantState)
