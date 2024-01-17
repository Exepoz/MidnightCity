local isBusy = false
currentZone = nil

--- Skatepark

RegisterNetEvent('qb-jail:client:GrabBMX', function()
    if isBusy then return end
    isBusy = true

    QBCore.Functions.SpawnVehicle('bmx', function(veh)
        TaskWarpPedIntoVehicle(cache.ped, veh, -1)
        Wait(2000)
        isBusy = false
    end, Config.SpawnBMX, true)
end)

CreateThread(function()
    local pedModel = `a_m_y_skater_01`
    lib.requestModel(pedModel, 1500)

    local bmxPed = CreatePed(0, pedModel, Config.BMXCoords.x, Config.BMXCoords.y, Config.BMXCoords.z, Config.BMXCoords.w, false, false)
    FreezeEntityPosition(bmxPed, true)
    SetEntityInvincible(bmxPed, true)
    SetBlockingOfNonTemporaryEvents(bmxPed, true)
    
    exports['qb-target']:AddTargetEntity(bmxPed, {
        options = {
            {
                type = 'client',
                event = 'qb-jail:client:GrabBMX',
                icon = 'fas fa-bicycle',
                label = Locales['target_bmx'],
            }
        },
        distance = 2.5,
    })
end)

--- Running

local obstacles = {
    [1] = {
        coords = vector4(1752.39, 2530.19, 44.57, 114.4),
        prop = 'prop_barier_conc_02b',
        propheading = 114.4,
    },
    [2] = {
        coords = vector4(1733.28, 2520.6, 44.56, 114.5),
        prop = 'prop_cons_ply02',
        propheading =  204.5,
    },
    [3] = {
        coords = vector4(1713.74, 2504.28, 44.56, 175.38),
        prop = 'prop_drywallpile_01',
        propheading = 265.38,
    },
    [4] = {
        coords = vector4(1688.8, 2493.79, 44.56, 89.37),
        prop = 'prop_barier_conc_01a',
        propheading = 89.37,
    },
    [5] = {
        coords = vector4(1653.45, 2502.17, 44.56, 48.29),
        prop = 'prop_logpile_05',
        propheading = 138.29,
    },
    [6] = {
        coords = vector4(1622.93, 2540.7, 44.56, 359.57),
        prop = 'prop_mc_conc_barrier_01',
        propheading = 359.57,
    },
    [7] = {
        coords = vector4(1643.49, 2560.98, 44.56, 270.52),
        prop = 'prop_pipes_01a',
        propheading = 180.52,
    },
    [8] = {
        coords = vector4(1690.35, 2560.85, 44.56, 269.94),
        prop = 'prop_shuttering03',
        propheading = 359.94,
    },
    [9] = {
        coords = vector4(1719.48, 2560.92, 44.56, 268.6),
        prop = 'prop_woodpile_03a',
        propheading = 178.6,
    },
    [10] = {
        coords = vector4(1754.04, 2560.93, 44.57, 268.61),
        prop = 'prop_barier_conc_02b',
        propheading = 268.61,
    }
}

local currentCheckpoint = 1

--- Method generate a blip, obstacle prop and polyzone for a new running checkpoint, reset lap if last checkpoint
---@param checkpoint number - checkpoint number
---@return nil
createCheckpoint = function(checkpoint)
    -- Blip
    createJobTaskBlip(obstacles[checkpoint].coords.xyz, 'Checkpoint ' .. checkpoint, 126, false)

    -- New Obstacle
    lib.requestModel(obstacles[checkpoint].prop, 1500)

    if not HasModelLoaded(obstacles[checkpoint].prop) then
		SetModelAsNoLongerNeeded(obstacles[checkpoint].prop)
	else
        local created_object = CreateObjectNoOffset(obstacles[checkpoint].prop, obstacles[checkpoint].coords.xyz, false, false, true)
        SetEntityHeading(created_object, obstacles[checkpoint].propheading)
        FreezeEntityPosition(created_object, true)
        SetEntityInvincible(created_object, true)
        SetModelAsNoLongerNeeded(obstacles[checkpoint].prop)
        jobObjects[1] = created_object
    end

    -- PolyZone around object to mark next obstacle
    currentZone = lib.zones.box({
        coords = obstacles[checkpoint].coords.xyz + vector3(0, 0, 1.5),
        size = vec3(5.0, 2.5, 4.5),
        rotation = obstacles[checkpoint].coords.w,
        debug = false,
        onEnter = function(self)
            self:remove()

            currentCheckpoint += 1

            if currentCheckpoint > #obstacles then -- Completed Lap
                currentCheckpoint = 1
                TriggerServerEvent('qb-jail:server:RequestSentenceReduction', currentJob)
            end

            lib.showTextUI((Locales['textui_runningprogress']):format(math.floor((currentCheckpoint - 1) * 100 / #obstacles)), { position = 'left-center', })

            -- Delete Existing Obstacle
            Wait(2000)
            destroyJobBlips()

            if jobObjects[1] and DoesEntityExist(jobObjects[1]) then
                DeleteEntity(jobObjects[1])
            end

            -- Create New Checkpoint
            createCheckpoint(currentCheckpoint)
        end,
    }) 
end

--- Method to start the running job at prison by creating the first checkpoint
---@return nil
startRunningJob = function()
    currentCheckpoint = 1
    createCheckpoint(currentCheckpoint)

    Utils.Notify(Locales['notify_running'], 'primary', 2500)
end

--- Workout

--- Method to perform the situp animation at a given entity
---@param entity number - entity handle
---@return nil
local SitUp = function(entity)
    if currentJob ~= 'workout' then
        Utils.Notify(Locales['notify_not_group'], 'error', 2500)
        return
    end

    if entity == 0 then return end
    if isBusy then return end
    isBusy = true

    local ped = cache.ped
    local coords = GetEntityCoords(entity)

    lib.requestAnimDict('amb@world_human_sit_ups@male@enter', 1500)
    lib.requestAnimDict('amb@world_human_sit_ups@male@base', 1500)
    lib.requestAnimDict('amb@world_human_sit_ups@male@exit', 1500)

    TaskPlayAnimAdvanced(ped, 'amb@world_human_sit_ups@male@enter', 'enter', coords.x, coords.y, coords.z, 0.0, 0.0, 120.0, 1.0, 1.0, -1, 0, 0, 0, 0)
    Wait(GetAnimDuration('amb@world_human_sit_ups@male@enter', 'enter') * 1000)

    TaskPlayAnim(ped, 'amb@world_human_sit_ups@male@base', 'base', 8.0, 8.0, -1, 0, 0.0, false, false, false)
    Wait(GetAnimDuration('amb@world_human_sit_ups@male@base', 'base') * 1000)
        
    TaskPlayAnim(ped, 'amb@world_human_sit_ups@male@exit', 'exit', 8.0, 8.0, -1, 0, 0.0, false, false, false)
    Wait(GetAnimDuration('amb@world_human_sit_ups@male@exit', 'exit') * 1000)

    RemoveAnimDict('amb@world_human_sit_ups@male@enter')
    RemoveAnimDict('amb@world_human_sit_ups@male@base')
    RemoveAnimDict('amb@world_human_sit_ups@male@exit')

    -- Reward Completion
    TriggerServerEvent('qb-jail:server:RequestSentenceReduction', currentJob)
    isBusy = false
end

--- Method to perform the pushup animation at a given entity
---@param entity number - entity handle
---@return nil
local Pushup = function(entity)
    if currentJob ~= 'workout' then
        Utils.Notify(Locales['notify_not_group'], 'error', 2500)
        return
    end

    if entity == 0 then return end
    if isBusy then return end

    isBusy = true
    local ped = cache.ped
    local coords = GetEntityCoords(entity)

    lib.requestAnimDict('amb@world_human_push_ups@male@enter', 1500)
    lib.requestAnimDict('amb@world_human_push_ups@male@base', 1500)
    lib.requestAnimDict('amb@world_human_push_ups@male@exit', 1500)

    TaskPlayAnimAdvanced(ped, 'amb@world_human_push_ups@male@enter', 'enter', coords.x, coords.y, coords.z, 0.0, 0.0, 120.0, 1.0, 1.0, -1, 0, 0, 0, 0)
    Wait(GetAnimDuration('amb@world_human_push_ups@male@enter', 'enter') * 1000)

    TaskPlayAnim(ped, 'amb@world_human_push_ups@male@base', 'base', 8.0, 8.0, -1, 0, 0.0, false, false, false)
    Wait(GetAnimDuration('amb@world_human_push_ups@male@base', 'base') * 1000)
        
    TaskPlayAnim(ped, 'amb@world_human_push_ups@male@exit', 'exit', 8.0, 8.0, -1, 0, 0.0, false, false, false)
    Wait(GetAnimDuration('amb@world_human_push_ups@male@exit', 'exit') * 1000)

    RemoveAnimDict('amb@world_human_push_ups@male@enter')
    RemoveAnimDict('amb@world_human_push_ups@male@base')
    RemoveAnimDict('amb@world_human_push_ups@male@exit')

    -- Reward Completion
    TriggerServerEvent('qb-jail:server:RequestSentenceReduction', currentJob)
    isBusy = false
end

--- Method to perform the dumbbells animation at a given entity
---@param entity number - entity handle
---@return nil
local Dumbbells = function(entity)
    if currentJob ~= 'workout' then
        Utils.Notify(Locales['notify_not_group'], 'error', 2500)
        return
    end

    if entity == 0 then return end
    
    local ped = cache.ped

    if isBusy then return end
    isBusy = true

    local weight = CreateObject(`prop_barbell_01`, GetEntityCoords(ped), true, true, true)
    AttachEntityToEntity(weight, ped, GetPedBoneIndex(ped, 28422), 0.25, 0.0, -0.05, 0.0, 15.0, 0.0, 1, 1, 0, 1, 0, 1)
    local weight2 = CreateObject(`prop_barbell_01`, GetEntityCoords(ped), true, true, true)
    AttachEntityToEntity(weight2, ped, GetPedBoneIndex(ped, 28422), -0.25, 0.0, -0.05, 0.0, -15.0, 0.0, 1, 1, 0, 1, 0, 1)

    lib.requestAnimDict('amb@world_human_muscle_free_weights@male@barbell@base', 1500)
    TaskPlayAnim(ped, 'amb@world_human_muscle_free_weights@male@barbell@base', 'base', 8.0, 8.0, -1, 1, 0.0, false, false, false)
    Wait(15000)

    -- Complete Reward
    TriggerServerEvent('qb-jail:server:RequestSentenceReduction', currentJob)
    DeleteEntity(weight)
    DeleteEntity(weight2)
    ClearPedTasks(ped)
    isBusy = false
end

--- Method to perform the bench press animation at a given entity
---@param entity number - entity handle
---@return nil
local BenchPress = function(entity)
    if currentJob ~= 'workout' then
        Utils.Notify(Locales['notify_not_group'], 'error', 2500)
        return
    end

    if entity == 0 then return end
    if isBusy then return end
    isBusy = true

    local ped = cache.ped
    local coords = GetEntityCoords(entity)
    local heading = GetEntityHeading(entity)

    local offset = -0.25
    if GetEntityModel(entity) == `prop_weight_bench_02` then offset = 0.6 end -- #DifferentBenchesDifferentOffsets
    TaskStartScenarioAtPosition(ped, 'PROP_HUMAN_SEAT_MUSCLE_BENCH_PRESS_PRISON', coords.x, coords.y, coords.z + offset, heading + 180.0, 0, false, true)
    Wait(8 * 1000)

    exports['ps-ui']:Circle(function(success)
        if success then
            -- Complete Set Reward
            TriggerServerEvent('qb-jail:server:RequestSentenceReduction', currentJob)
        end

        Wait(15 * 1000)
        ClearPedTasks(ped)
        Wait(3000)
        RemovePropType(-1711403533)
        isBusy = false
    end, 1, 15)    
end

RegisterNetEvent('qb-jail:client:ChinUp', function(data)
    if currentJob ~= 'workout' then
        Utils.Notify(Locales['notify_not_group'], 'error', 2500)
        return
    end

    if isBusy then return end
    isBusy = true

    local ped = cache.ped
    
    lib.requestAnimDict('amb@prop_human_muscle_chin_ups@male@enter', 1500)
    lib.requestAnimDict('amb@prop_human_muscle_chin_ups@male@base', 1500)
    lib.requestAnimDict('amb@prop_human_muscle_chin_ups@male@exit', 1500)

    local progress = 0
    lib.showTextUI('Progress: ' .. progress .. '%', { position = 'left-center', })

    if data.index == 1 then
        TaskPlayAnimAdvanced(ped, 'amb@prop_human_muscle_chin_ups@male@enter', 'enter', 1643.44, 2527.82, 45.56, 0.0, 0.0, 50.0, 1.0, 1.0, -1, 0, 0, 0, 0)
    elseif data.index == 2 then
        TaskPlayAnimAdvanced(ped, 'amb@prop_human_muscle_chin_ups@male@enter', 'enter', 1648.93, 2529.77, 45.56, 0.0, 0.0, 230.0, 1.0, 1.0, -1, 0, 0, 0, 0)
    end

    Wait(GetAnimDuration('amb@prop_human_muscle_chin_ups@male@enter', 'enter') * 1000)
    progress += 15.4
    lib.showTextUI('Progress: ' .. progress .. '%', { position = 'left-center', })

    CreateThread(function()
        local totalWait = GetAnimDuration('amb@prop_human_muscle_chin_ups@male@base', 'base') * 1000
        for i = 1, 5 do
            Wait(totalWait / 5)
            progress += (72.85 / 5)
            lib.showTextUI('Progress: ' .. progress .. '%', { position = 'left-center', })
        end
    end)

    TaskPlayAnim(ped, 'amb@prop_human_muscle_chin_ups@male@base', 'base', 8.0, 8.0, -1, 0, 0.0, false, false, false)
    Wait(GetAnimDuration('amb@prop_human_muscle_chin_ups@male@base', 'base') * 1000)
        
    TaskPlayAnim(ped, 'amb@prop_human_muscle_chin_ups@male@exit', 'exit', 8.0, 8.0, -1, 0, 0.0, false, false, false)
    Wait(GetAnimDuration('amb@prop_human_muscle_chin_ups@male@exit', 'exit') * 1000)
    lib.hideTextUI()

    RemoveAnimDict('amb@prop_human_muscle_chin_ups@male@enter')
    RemoveAnimDict('amb@prop_human_muscle_chin_ups@male@base')
    RemoveAnimDict('amb@prop_human_muscle_chin_ups@male@exit')

    -- Reward Completion
    TriggerServerEvent('qb-jail:server:RequestSentenceReduction', currentJob)
    isBusy = false
end)

CreateThread(function()
    local mats = { `prop_yoga_mat_01`, `prop_yoga_mat_02`, `prop_yoga_mat_03` }
    exports['qb-target']:AddTargetModel(mats, {
        options = {
            {
                action = function(entity)
                    SitUp(entity)
                end,
                icon = 'fas fa-circle-chevron-right',
                label = Locales['target_situp'],
                canInteract = function(entity)
                    return insidePrisonZone
                end,
            },
            {
                action = function(entity)
                    Pushup(entity)
                end,
                icon = 'fas fa-circle-chevron-right',
                label = Locales['target_pushup'],
                canInteract = function(entity)
                    return insidePrisonZone
                end,
            }
        },
        distance = 2.5, 
    })

    local benches = { `prop_pris_bench_01`, `prop_weight_bench_02` }
    exports['qb-target']:AddTargetModel(benches, {
        options = {
            {
                action = function(entity)
                    BenchPress(entity)
                end,
                icon = 'fas fa-dumbbell',
                label = Locales['target_benchpress'],
                canInteract = function(entity)
                    return insidePrisonZone
                end,
            }
        },
        distance = 2.5, 
    })

    exports['qb-target']:AddTargetModel(`prop_weight_rack_02`, {
        options = {
            {
                action = function(entity)
                    Dumbbells(entity)
                end,
                icon = 'fas fa-dumbbell',
                label = Locales['target_liftweights'],
                canInteract = function(entity)
                    return insidePrisonZone
                end,
            }
        },
        distance = 2.5, 
    })

    exports['qb-target']:AddBoxZone('prison_workout_chinup1', vector3(1643.27, 2527.85, 44.50), 1.4, 0.4, {
        name = 'prison_workout_chinup1',
        heading = 140,
        debugPoly = Config.TargetDebug,
        minZ = 44.50,
        maxZ = 47.50
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:ChinUp',
                icon = 'fas fa-dumbbell',
                label = Locales['target_chinup'],
                index = 1
            }
        },
        distance = 2.5,
    })

    exports['qb-target']:AddBoxZone('prison_workout_chinup2', vector3(1649.05, 2529.64, 44.50), 1.4, 0.4, {
        name = 'prison_workout_chinup2',
        heading = 140,
        debugPoly = Config.TargetDebug,
        minZ = 44.50,
        maxZ = 47.50
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:ChinUp',
                icon = 'fas fa-dumbbell',
                label = Locales['target_chinup'],
                index = 2
            }
        },
        distance = 2.5,
    })
end)

--- Kitchen

local cafeteriaTables = {
    [1] = { completed = false, coords = vector3(1780.96, 2554.46, 45.08) },
    [2] = { completed = false, coords = vector3(1780.96, 2550.85, 45.08) },
    [3] = { completed = false, coords = vector3(1780.96, 2547.30, 45.08) },
    [4] = { completed = false, coords = vector3(1786.77, 2547.30, 45.08) },
    [5] = { completed = false, coords = vector3(1786.77, 2550.85, 45.08) },
    [6] = { completed = false, coords = vector3(1786.77, 2554.46, 45.08) }
}

local taskCompleted = false

--- Method to return the closest cafetariaTable index for given coordinates
---@param coords vector3 - location coordinates
---@return k number - CafeteriaTable index
local getClosestCafeteriaTable = function(coords)
    for k, v in pairs(cafeteriaTables) do
        if #(coords - v.coords) < 2.0 then
            return k
        end
    end
end

--- Method to check if all tables have been completed, if so, reset the tables so they can be cleaned again
---@return nil
local checkTables = function()
    local reset = true
    for i = 1, #cafeteriaTables do
        if not cafeteriaTables[i].completed then
            reset = false
            break
        end
    end

    if reset then
        for i = 1, #cafeteriaTables do
            cafeteriaTables[i].completed = false
        end

        Utils.Notify(Locales['notify_kitchen_reset'], 'error', 2500)
    end
end

RegisterNetEvent('qb-jail:client:CleanDishes', function()
    if currentJob ~= 'kitchen' then
        Utils.Notify(Locales['notify_not_group'], 'error', 2500)
        return
    elseif taskCompleted == 'clean' then
        Utils.Notify(Locales['notify_done_task'], 'error', 2500)
        return
    end

    if isBusy then return end
    isBusy = true

    if lib.progressBar({
        duration = 7800,
        label = Locales['progressbar_dishes'],
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true, mouse = false },
        anim = { dict = 'anim@gangops@facility@servers@bodysearch@', clip = 'player_search', flag = 16 },
    }) then
        exports['ps-ui']:Circle(function(success)
            TriggerServerEvent('qb-jail:server:FinishKitchenTask', 2, success)
            isBusy = false
            taskCompleted = 'clean'
        end, 1, 14)
    else
        Utils.Notify(Locales['notify_canceled'], 'error', 2500)
        isBusy = false
    end
end)

RegisterNetEvent('qb-jail:client:SortShelf', function()
    if currentJob ~= 'kitchen' then
        Utils.Notify(Locales['notify_not_group'], 'error', 2500)
        return
    elseif taskCompleted == 'sort' then
        Utils.Notify(Locales['notify_done_task'], 'error', 2500)
        return
    end

    if isBusy then return end
    isBusy = true

    if lib.progressBar({
        duration = 7800,
        label = Locales['progressbar_shelves'],
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true, mouse = false },
        anim = { dict = 'anim@gangops@facility@servers@bodysearch@', clip = 'player_search', flag = 16 },
    }) then
        exports['ps-ui']:Circle(function(success)
            TriggerServerEvent('qb-jail:server:FinishKitchenTask', 2, success)
            isBusy = false
            taskCompleted = 'sort'
        end, 1, 14)
    else
        Utils.Notify(Locales['notify_canceled'], 'error', 2500)
        isBusy = false
    end
end)

RegisterNetEvent('qb-jail:client:MakeFoodShelf', function()
    if currentJob ~= 'kitchen' then
        Utils.Notify(Locales['notify_not_group'], 'error', 2500)
        return
    elseif taskCompleted == 'shelf' then
        Utils.Notify(Locales['notify_done_task'], 'error', 2500)
        return
    end

    if isBusy then return end
    isBusy = true

    if lib.progressBar({
        duration = 7800,
        label = Locales['progressbar_prepare_food'],
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true, mouse = false },
        anim = { dict = 'anim@gangops@facility@servers@bodysearch@', clip = 'player_search', flag = 16 },
    }) then
        exports['ps-ui']:Circle(function(success)
            TriggerServerEvent('qb-jail:server:FinishKitchenTask', 1, success)
            isBusy = false
            taskCompleted = 'shelf'
        end, 1, 14)
    else
        Utils.Notify(Locales['notify_canceled'], 'error', 2500)
        isBusy = false
    end
end)

RegisterNetEvent('qb-jail:client:MakeFoodCounter', function()
    if currentJob ~= 'kitchen' then
        Utils.Notify(Locales['notify_not_group'], 'error', 2500)
        return
    elseif taskCompleted == 'counter' then
        Utils.Notify(Locales['notify_done_task'], 'error', 2500)
        return
    end

    if isBusy then return end
    isBusy = true

    if lib.progressBar({
        duration = 7800,
        label = Locales['progressbar_prepare_food'],
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true, mouse = false },
        anim = { dict = 'anim@gangops@facility@servers@bodysearch@', clip = 'player_search', flag = 16 },
    }) then
        exports['ps-ui']:Circle(function(success)
            TriggerServerEvent('qb-jail:server:FinishKitchenTask', 1, success)
            isBusy = false
            taskCompleted = 'counter'
        end, 1, 14)
    else
        Utils.Notify(Locales['notify_canceled'], 'error', 2500)
        isBusy = false
    end
end)

RegisterNetEvent('qb-jail:client:MakeFoodStove', function()
    if currentJob ~= 'kitchen' then
        Utils.Notify(Locales['notify_not_group'], 'error', 2500)
        return
    elseif taskCompleted == 'stove' then
        Utils.Notify(Locales['notify_done_task'], 'error', 2500)
        return
    end

    if isBusy then return end
    isBusy = true

    if lib.progressBar({
        duration = 7800,
        label = Locales['progressbar_prepare_food'],
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true, mouse = false },
        anim = { dict = 'amb@prop_human_bbq@male@base', clip = 'base', flag = 16 },
    }) then
        exports['ps-ui']:Circle(function(success)
            TriggerServerEvent('qb-jail:server:FinishKitchenTask', 1, success)
            isBusy = false
            taskCompleted = 'stove'
        end, 1, 14)
    else
        Utils.Notify(Locales['notify_canceled'], 'error', 2500)
        isBusy = false
    end
end)

RegisterNetEvent('qb-jail:client:CleanTables', function(data)
    if currentJob ~= 'kitchen' then
        Utils.Notify(Locales['notify_not_group'], 'error', 2500)
        return
    end

    if isBusy then return end

    local tableCoords = GetEntityCoords(data.entity)
    local table = getClosestCafeteriaTable(tableCoords)

    if cafeteriaTables[table].completed then
        Utils.Notify(Locales['notify_table_cleaned'], 'error', 2500)
        return
    end

    isBusy = true

    local ped = cache.ped
    TaskTurnPedToFaceEntity(ped, data.entity, 1.0)
    Wait(1500)

    if lib.progressBar({
        duration = 7800,
        label = Locales['progressbar_table'],
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true, mouse = false },
        anim = { dict = 'anim@gangops@facility@servers@bodysearch@', clip = 'player_search', flag = 16 },
    }) then
        exports['ps-ui']:Circle(function(success)
            cafeteriaTables[table].completed = true
            TriggerServerEvent('qb-jail:server:FinishKitchenTask', 3, success)
            checkTables()
            isBusy = false
        end, 1, 14)
    else
        Utils.Notify(Locales['notify_canceled'], 'error', 2500)
        isBusy = false
    end
end)

CreateThread(function()
    exports['qb-target']:AddBoxZone('prison_kitchen_clean', vector3(1778.68, 2565.07, 44.50), 1.5, 0.8, {
        name = 'prison_kitchen_clean',
        heading = 270,
        debugPoly = Config.TargetDebug,
        minZ = 44.50,
        maxZ = 46.50
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:CleanDishes',
                icon = 'fas fa-hand-sparkles',
                label = Locales['target_clean_dishes'],
            }
        },
        distance = 2.5,
    })

    exports['qb-target']:AddBoxZone('prison_kitchen_shelves', vector3(1787.01, 2564.73, 44.50), 2.4, 0.4, {
        name = 'prison_kitchen_shelves',
        heading = 270,
        debugPoly = Config.TargetDebug,
        minZ = 44.50,
        maxZ = 46.50
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:SortShelf',
                icon = 'fas fa-boxes-packing',
                label = Locales['target_sort_shelves'],
            },
            {
                type = 'client',
                event = 'qb-jail:client:MakeFoodShelf',
                icon = 'fas fa-utensils',
                label = Locales['target_make_food'],
            }
        },
        distance = 2.5,
    })

    exports['qb-target']:AddBoxZone('prison_kitchen_counter', vector3(1776.83, 2563.69, 44.50), 2.0, 0.8, {
        name = 'prison_kitchen_counter',
        heading = 0,
        debugPoly = Config.TargetDebug,
        minZ = 44.50,
        maxZ = 46.50
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:MakeFoodCounter',
                icon = 'fas fa-utensils',
                label = Locales['target_make_food'],
            }
        },
        distance = 2.5,
    })

    exports['qb-target']:AddBoxZone('prison_kitchen_stove', vector3(1780.84, 2565.03, 44.50), 1.4, 0.8, {
        name = 'prison_kitchen_stove',
        heading = 270,
        debugPoly = Config.TargetDebug,
        minZ = 44.50,
        maxZ = 46.50
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:MakeFoodStove',
                icon = 'fas fa-utensils',
                label = Locales['target_make_food'],
            }
        },
        distance = 2.5,
    })

    exports['qb-target']:AddTargetModel(`sanhje_Prison_Cafeteria_table`, {
        options = {
            {
                type = 'client',
                event = 'qb-jail:client:CleanTables',
                icon = 'fas fa-hand-sparkles',
                label = Locales['target_clean_table'],
                canInteract = function(entity)
                    return insidePrisonZone
                end,
            }
        },
        distance = 2.5, 
    })    
end)

--- Cleaning

--- Method to perform the cleaning animation, circle minigame for time reduction and sends the netId of the entity to the server to delete
---@param entity number - entity handle
---@return nil
local CleanUp = function(entity)
    if currentJob ~= 'cleaning' then
        Utils.Notify(Locales['notify_not_group'], 'error', 2500)
        return
    end
    
    if entity == 0 then return end
    if isBusy then return end
    isBusy = true

    local ped = cache.ped
    local netId = NetworkGetNetworkIdFromEntity(entity)
    TaskTurnPedToFaceEntity(ped, entity, 1.0)
    Wait(1500)

    if lib.progressBar({
        duration = 7800,
        label = Locales['progressbar_cleaning'],
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true, mouse = false },
        anim = { dict = 'anim@gangops@facility@servers@bodysearch@', clip = 'player_search', flag = 16 },
    }) then
        exports['ps-ui']:Circle(function(success)
            TriggerServerEvent('qb-jail:server:FinishCleaningTask', netId, success)
            isBusy = false
        end, 1, 14)
    else
        Utils.Notify(Locales['notify_canceled'], 'error', 2500)
        isBusy = false
    end
end

RegisterNetEvent('qb-jail:client:FinishCleaningTask', function(coords)
    for i = 1, #jobBlips do
        if GetBlipInfoIdCoord(jobBlips[i]) == coords then
            if DoesBlipExist(jobBlips[i]) then
                RemoveBlip(jobBlips[i])
                table.remove(jobBlips, i)
                return  
            end
        end
    end
end)

RegisterNetEvent('qb-jail:client:CompletedCleaningTask', function(result)
    for i = 1, #result do
        createJobTaskBlip(result[i], Locales['cleaning'], 456, false)
    end

    lib.showTextUI(Locales['textui_cleaningcompleted'], { position = 'left-center', })
    Wait(4000)
    lib.showTextUI(Locales['textui_cleaningcomplete'], { position = 'left-center', })
end)

CreateThread(function()
    local objects = {
        `prop_big_shit_01`, 
        `prop_big_shit_02`, 
        `ng_proc_litter_plasbot2`, 
        `ng_proc_litter_plasbot3`, 
        `ng_proc_cigpak01c`
    }

    exports['qb-target']:AddTargetModel(objects, {
        options = {
            {
                action = function(entity)
                    CleanUp(entity)
                end,
                icon = 'fas fa-hand-sparkles',
                label = Locales['target_cleaning'],
                canInteract = function(entity)
                    return insidePrisonZone
                end,
            },
        },
        distance = 2.5,
    })
end)

--- Scrapyard

RegisterNetEvent('qb-jail:client:PrisonScrap', function(data)
    if currentJob ~= 'scrapyard' then
        Utils.Notify(Locales['notify_not_group'], 'error', 2500)
        return
    end

    if entity == 0 then return end
    if isBusy then return end

    isBusy = true

    local ped = cache.ped
    local coords = GetEntityCoords(ped)
    TaskTurnPedToFaceEntity(ped, data.entity, 1.0)
    Wait(1500)
    
    local animation = {
        [1] = {'amb@world_human_welding@male@base', 'base', 1, true},
        [2] = {'pickup_object', 'pickup_low', 0, false}
    }

    local welder = nil
    local effect = nil

    if animation[data.index][4] then
        welder = CreateObject(`prop_weld_torch`, coords, 1, 1, 1)
        AttachEntityToEntity(welder, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.25 , 1, 1, 0, 1, 0, 1)    
    end

    if lib.progressBar({
        duration = 7800,
        label = Locales['progressbar_scrap'],
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true, mouse = false },
        anim = { dict = animation[data.index][1], clip = animation[data.index][2], flag = animation[data.index][3] },
    }) then
        exports['ps-ui']:Circle(function(success)
            TriggerServerEvent('qb-jail:server:PrisonScrap', data.index, success)
            isBusy = false

            if welder then DeleteEntity(welder) end
            ClearPedTasks(ped)
        end, 1, 14)
    else
        Utils.Notify(Locales['notify_canceled'], 'error', 2500)
        isBusy = false
    end
end)

CreateThread(function()
    exports['qb-target']:AddBoxZone('prison_scrap_1', vector3(1658.67, 2519.24, 44.50), 7.0, 7.0, {
        name = 'prison_scrap_1',
        heading = 90,
        debugPoly = Config.TargetDebug,
        minZ = 44.50,
        maxZ = 47.50
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:PrisonScrap',
                icon = 'fas fa-person-digging',
                label = Locales['target_scrap'],
                index = 1
            }
        },
        distance = 2.5,
    })

    exports['qb-target']:AddBoxZone('prison_scrap_2', vector3(1649.94, 2511.99, 44.50), 3.0, 3.0, {
        name = 'prison_scrap_2',
        heading = 90,
        debugPoly = Config.TargetDebug,
        minZ = 44.50,
        maxZ = 45.50
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:PrisonScrap',
                icon = 'fas fa-person-digging',
                label = Locales['target_scrap'],
                index = 2
            }
        },
        distance = 2.5,
    })
end)

--- Electrical

--- Method to perform the welding animation and request the server for time reduction
---@param index number - electrical box config index
---@param entity number - entity handle
---@return nil
ElectricalJob = function(index, entity)
    if currentJob ~= 'electrical' then
        Utils.Notify(Locales['notify_not_group'], 'error', 2500)
        return
    end

    if Config.Electrical[index].completed then
        Utils.Notify(Locales['notify_electrical_complete'], 'error', 2500)
        return
    end

    if entity == 0 then return end
    if isBusy then return end
    isBusy = true

    local ped = cache.ped
    local coords = GetEntityCoords(ped)
    TaskTurnPedToFaceEntity(ped, entity, 1.0)
    Wait(1500)
    
    local welder = CreateObject(`prop_weld_torch`, coords, true, true, true)
    AttachEntityToEntity(welder, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.25 , 1, 1, 0, 1, 0, 1)

    if lib.progressBar({
        duration = 7800,
        label = Locales['progressbar_electrical'],
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true, mouse = false },
        anim = { dict = 'amb@world_human_welding@male@base', clip = 'base', flag = 1 },
    }) then
        TriggerServerEvent('qb-jail:server:CompleteElectrical', index)
        isBusy = false
        if welder then DeleteEntity(welder) end
    else
        Utils.Notify(Locales['notify_canceled'], 'error', 2500)
        isBusy = false
    end
end

RegisterNetEvent('qb-jail:client:CompleteElectrical', function(index)
    Config.Electrical[index].completed = true

    for i = 1, #jobBlips do
        if GetBlipInfoIdCoord(jobBlips[i]) == Config.Electrical[index].coords.xyz then
            if DoesBlipExist(jobBlips[i]) then
                RemoveBlip(jobBlips[i])
                table.remove(jobBlips, i)
                break  
            end
        end
    end

    local amount = 0
    for i = 1, #Config.Electrical do
        if not Config.Electrical[i].completed then
            amount += 1
        end
    end

    lib.showTextUI((Locales['textui_electricalprogress']):format(math.floor(100 * (#Config.Electrical - amount) / #Config.Electrical)), { position = 'left-center', })
end)

RegisterNetEvent('qb-jail:client:ResetElectrical', function()
    destroyJobBlips()

    for i = 1, #Config.Electrical do
        Config.Electrical[i].completed = false
        createJobTaskBlip(Config.Electrical[i].coords.xyz, Locales['electrical'], 354, false)
    end

    lib.showTextUI(Locales['textui_electricalcompleted'], { position = 'left-center', })
    Wait(4000)
    lib.showTextUI(Locales['textui_electricalcomplete'], { position = 'left-center', })
end)

CreateThread(function()
    for k, v in pairs(Config.Electrical) do
        exports['qb-target']:AddBoxZone('prison_electrical_' .. k, vector3(v.coords.x, v.coords.y, v.coords.z - 0.25), 0.5, 1.0, {
            name = 'prison_electrical_' .. k,
            heading = v.coords.w,
            debugPoly = Config.TargetDebug,
            minZ = v.coords.z - 0.25,
            maxZ = v.coords.z + 0.75
        }, {
            options = { 
                {
                    icon = 'fas fa-bolt',
                    label = Locales['target_electrical'],
                    action = function(entity)
                        ElectricalJob(k, entity)
                    end
                }
            },
            distance = 2.5,
        })
    end
end)

--- Gardening

RegisterNetEvent('qb-jail:client:FarmingSupplies', function()
    if currentJob ~= 'gardening' then
        Utils.Notify(Locales['notify_not_group'], 'error', 2500)
        return
    end

    if Config.Inventory == 'qb' then
        TriggerServerEvent('inventory:server:OpenInventory', 'shop', 'Gardening Supplies', {
            label = 'Gardening Supplies',
            slots = 3,
            items = {
                [1] = { 
                    name = 'prisonfarmseeds', 
                    price = 0, 
                    amount = 10, 
                    info = {}, 
                    type = 'item', 
                    slot = 1, 
                },
                [2] = { 
                    name = 'prisonwateringcan', 
                    price = 0, 
                    amount = 10, 
                    info = {}, 
                    type = 'item', 
                    slot = 2, 
                },
                [3] = { 
                    name = 'prisonfarmnutrition', 
                    price = 0, 
                    amount = 10, 
                    info = {}, 
                    type = 'item', 
                    slot = 3, 
                },
            }
        })
    elseif Config.Inventory == 'ox_inventory' then
        exports['ox_inventory']:openInventory('shop', { type = 'jailgardening', id = 1 })
    end
end)

RegisterNetEvent('qb-jail:client:InspectFarming', function(data)
    if currentJob ~= 'gardening' then
        Utils.Notify(Locales['notify_not_group'], 'error', 2500)
        return
    end

    local index = data.index
    if not index then return end

    lib.callback('qb-jail:server:GetFarmingStatus', false, function(result)
        if not result then return end

        local options = nil

        if not result.planted then
            options = {
                {
                    title = Locales['menu_plant_title'],
                    description = Locales['menu_plant_text'],
                    icon = 'fas fa-seedling',
                    event = 'qb-jail:client:PlantSeed',
                    args = index
                }
            }
        elseif result.dead then
            options = {
                {
                    title = Locales['menu_clear_title'],
                    description = Locales['menu_clear_text'],
                    icon = 'fas fa-ban',
                    event = 'qb-jail:client:ClearPlant',
                    args = index
                }
            }
        elseif result.growth == 100 then
            options = {
                {
                    title = (Locales['menu_harvest_title']):format(result.stage, result.health),
                    description = Locales['menu_harvest_text'],
                    progress = result.growth,
                    colorScheme = 'green',
                    icon = 'fas fa-hand',
                    event = 'qb-jail:client:HarvestPlant',
                    args = index
                }
            }
        else
            options = {
                {
                    title = (Locales['menu_growing_title']):format(result.growth, result.stage),
                    description = Locales['menu_growing_text']:format(result.health),
                    progress = result.health,
                    colorScheme = 'green',
                    icon = 'fas fa-chart-simple',
                    args = index
                },
                {
                    title = (Locales['menu_water_title']):format(result.water),
                    description = Locales['menu_water_text'],
                    progress = result.water,
                    colorScheme = 'cyan',
                    icon = 'fas fa-shower',
                    event = 'qb-jail:client:GiveWater',
                    args = index
                },
                {
                    title = (Locales['menu_fertilizer_title']):format(result.fertilizer),
                    description = Locales['menu_fertilizer_text'],
                    progress = result.fertilizer,
                    colorScheme = 'brown',
                    icon = 'fab fa-nutritionix',
                    event = 'qb-jail:client:GiveFertilizer',
                    args = index
                }
            }
        end

        lib.registerContext({
            id = 'jail_farming',
            title = (Locales['menu_title_farming']):format(index),
            options = options
        })
    
        lib.showContext('jail_farming')

    end, index)      
end)

RegisterNetEvent('qb-jail:client:PlantSeed', function(index)
    if currentJob ~= 'gardening' then
        Utils.Notify(Locales['notify_not_group'], 'error', 2500)
        return
    end

    if Config.Inventory == 'ox_inventory' and exports['ox_inventory']:Search('count', 'prisonfarmseeds') == 0 then
        Utils.Notify(Locales['notify_noseeds'], 'error', 2500)
        return
    elseif Config.Inventory == 'qb' and not QBCore.Functions.HasItem('prisonfarmseeds') then
        Utils.Notify(Locales['notify_noseeds'], 'error', 2500)
        return
    end

    local ped = cache.ped

    lib.requestAnimDict('amb@medic@standing@kneel@base', 1500)
    lib.requestAnimDict('anim@gangops@facility@servers@bodysearch@', 1500)

    TaskPlayAnim(ped, 'amb@medic@standing@kneel@base', 'base', 8.0, 8.0, -1, 1, 0, false, false, false)
    TaskPlayAnim(ped, 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, 8.0, -1, 48, 0, false, false, false)

    if lib.progressBar({
        duration = 8500,
        label = Locales['progressbar_planting'],
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true, mouse = false },
    }) then
        TriggerServerEvent('qb-jail:server:PlantSeed', index)
        ClearPedTasks(ped)
        RemoveAnimDict('amb@medic@standing@kneel@base')
        RemoveAnimDict('anim@gangops@facility@servers@bodysearch@')
    else
        Utils.Notify(Locales['notify_canceled'], 'error', 2500)
        ClearPedTasks(ped)
        RemoveAnimDict('amb@medic@standing@kneel@base')
        RemoveAnimDict('anim@gangops@facility@servers@bodysearch@')
    end
end)

RegisterNetEvent('qb-jail:client:ClearPlant', function(index)
    if currentJob ~= 'gardening' then
        Utils.Notify(Locales['notify_not_group'], 'error', 2500)
        return
    end

    local ped = cache.ped

    lib.requestAnimDict('amb@medic@standing@kneel@base', 1500)
    lib.requestAnimDict('anim@gangops@facility@servers@bodysearch@', 1500)

    TaskPlayAnim(ped, 'amb@medic@standing@kneel@base', 'base', 8.0, 8.0, -1, 1, 0, false, false, false)
    TaskPlayAnim(ped, 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, 8.0, -1, 48, 0, false, false, false)
    
    if lib.progressBar({
        duration = 8500,
        label = Locales['progressbar_clearing'],
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true, mouse = false },
    }) then
        TriggerServerEvent('qb-jail:server:ClearPlant', index)
        ClearPedTasks(ped)
        RemoveAnimDict('amb@medic@standing@kneel@base')
        RemoveAnimDict('anim@gangops@facility@servers@bodysearch@')
    else
        Utils.Notify(Locales['notify_canceled'], 'error', 2500)
        ClearPedTasks(ped)
        RemoveAnimDict('amb@medic@standing@kneel@base')
        RemoveAnimDict('anim@gangops@facility@servers@bodysearch@')
    end
end)

RegisterNetEvent('qb-jail:client:HarvestPlant', function(index)
    if currentJob ~= 'gardening' then
        Utils.Notify(Locales['notify_not_group'], 'error', 2500)
        return
    end

    local ped = cache.ped

    lib.requestAnimDict('amb@medic@standing@kneel@base', 1500)
    lib.requestAnimDict('anim@gangops@facility@servers@bodysearch@', 1500)

    TaskPlayAnim(ped, 'amb@medic@standing@kneel@base', 'base', 8.0, 8.0, -1, 1, 0, false, false, false)
    TaskPlayAnim(ped, 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, 8.0, -1, 48, 0, false, false, false)

    if lib.progressBar({
        duration = 8500,
        label = Locales['progressbar_harvesting'],
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true, mouse = false },
    }) then
        TriggerServerEvent('qb-jail:server:HarvestPlant', index)
        ClearPedTasks(ped)
        RemoveAnimDict('amb@medic@standing@kneel@base')
        RemoveAnimDict('anim@gangops@facility@servers@bodysearch@')
    else
        Utils.Notify(Locales['notify_canceled'], 'error', 2500)
        ClearPedTasks(ped)
        RemoveAnimDict('amb@medic@standing@kneel@base')
        RemoveAnimDict('anim@gangops@facility@servers@bodysearch@')
    end
end)

RegisterNetEvent('qb-jail:client:GiveWater', function(index)
    if currentJob ~= 'gardening' then
        Utils.Notify(Locales['notify_not_group'], 'error', 2500)
        return
    end

    if Config.Inventory == 'ox_inventory' and exports['ox_inventory']:Search('count', 'prisonwateringcan') == 0 then
        Utils.Notify(Locales['notify_nowater'], 'error', 2500)
        return
    elseif Config.Inventory == 'qb' and not QBCore.Functions.HasItem('prisonwateringcan') then
        Utils.Notify(Locales['notify_nowater'], 'error', 2500)
        return
    end

    local ped = cache.ped
    local coords = GetEntityCoords(ped)
    local model = `prop_wateringcan`
    lib.requestModel(model, 1500)
    
    lib.requestNamedPtfxAsset('core', 1500)
    
    SetPtfxAssetNextCall('core')
    local created_object = CreateObject(model, coords.x, coords.y, coords.z, true, true, true)
    AttachEntityToEntity(created_object, ped, GetPedBoneIndex(ped, 28422), 0.4, 0.1, 0.0, 90.0, 180.0, 0.0, true, true, false, true, 1, true)
    local effect = StartParticleFxLoopedOnEntity('ent_sht_water', created_object, 0.35, 0.0, 0.25, 0.0, 0.0, 0.0, 2.0, false, false, false)

    if lib.progressBar({
        duration = 6000,
        label = Locales['progressbar_watering'],
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true, mouse = false },
        anim = { dict = 'weapon@w_sp_jerrycan', clip = 'fire', flag = 1 },
    }) then
        TriggerServerEvent('qb-jail:server:GiveWater', index)
        ClearPedTasks(ped)
        DeleteEntity(created_object)
        StopParticleFxLooped(effect, 0)
    else
        ClearPedTasks(ped)
        DeleteEntity(created_object)
        StopParticleFxLooped(effect, 0)
        Utils.Notify(Locales['notify_canceled'], 'error', 2500)
    end
end)

RegisterNetEvent('qb-jail:client:GiveFertilizer', function(index)
    if currentJob ~= 'gardening' then
        Utils.Notify(Locales['notify_not_group'], 'error', 2500)
        return
    end

    if Config.Inventory == 'ox_inventory' and exports['ox_inventory']:Search('count', 'prisonfarmnutrition') == 0 then
        Utils.Notify(Locales['notify_nofertilizer'], 'error', 2500)
        return
    elseif Config.Inventory == 'qb' and not QBCore.Functions.HasItem('prisonfarmnutrition') then
        Utils.Notify(Locales['notify_nofertilizer'], 'error', 2500)
        return
    end

    local ped = cache.ped
    local coords = GetEntityCoords(ped)
    local model = `w_am_jerrycan_sf`
    lib.requestModel(model, 1500)

    local created_object = CreateObject(model, coords.x, coords.y, coords.z, true, true, true)
    AttachEntityToEntity(created_object, ped, GetPedBoneIndex(ped, 28422), 0.3, 0.1, 0.0, 90.0, 180.0, 0.0, true, true, false, true, 1, true)
    
    if lib.progressBar({
        duration = 6000,
        label = Locales['progressbar_fertilizing'],
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true, mouse = false },
        anim = { dict = 'weapon@w_sp_jerrycan', clip = 'fire', flag = 1 },
    }) then
        TriggerServerEvent('qb-jail:server:GiveFertilizer', index)
        ClearPedTasks(ped)
        DeleteEntity(created_object)
    else
        ClearPedTasks(ped)
        DeleteEntity(created_object)
        Utils.Notify(Locales['notify_canceled'], 'error', 2500)
    end
end)

CreateThread(function()
    local pedModel = `s_m_m_gardener_01`
    lib.requestModel(pedModel, 1500)

    local farmingPed = CreatePed(0, pedModel, Config.GardeningPed.x, Config.GardeningPed.y, Config.GardeningPed.z, Config.GardeningPed.w, false, false)
    FreezeEntityPosition(farmingPed, true)
    SetEntityInvincible(farmingPed, true)
    SetBlockingOfNonTemporaryEvents(farmingPed, true)
    
    exports['qb-target']:AddTargetEntity(farmingPed, {
        options = {
            {
                type = 'client',
                event = 'qb-jail:client:FarmingSupplies',
                icon = 'fas fa-trowel',
                label = Locales['target_gardeningshop'],
            }
        },
        distance = 2.5,
    })

    exports['qb-target']:AddBoxZone('prison_farming_1', vector3(1689.88, 2545.67, 44.50), 3.5, 3.5, {
        name = 'prison_farming_1',
        heading = 90.0,
        debugPoly = Config.TargetDebug,
        minZ = 44.50,
        maxZ = 45.75
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:InspectFarming',
                icon = 'fas fa-trowel',
                label = Locales['gardening'],
                index = 1
            }
        },
        distance = 3.5,
    })

    exports['qb-target']:AddBoxZone('prison_farming_2', vector3(1695.45, 2553.88, 44.50), 3.5, 3.5, {
        name = 'prison_farming_2',
        heading = 180.0,
        debugPoly = Config.TargetDebug,
        minZ = 44.50,
        maxZ = 45.75
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:InspectFarming',
                icon = 'fas fa-trowel',
                label = Locales['gardening'],
                index = 2
            }
        },
        distance = 3.5,
    })

    exports['qb-target']:AddBoxZone('prison_farming_3', vector3(1695.21, 2548.71, 44.50), 3.5, 3.5, {
        name = 'prison_farming_3',
        heading = 180.0,
        debugPoly = Config.TargetDebug,
        minZ = 44.50,
        maxZ = 45.75
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:InspectFarming',
                icon = 'fas fa-trowel',
                label = Locales['gardening'],
                index = 3
            }
        },
        distance = 3.5,
    })
    
end)
