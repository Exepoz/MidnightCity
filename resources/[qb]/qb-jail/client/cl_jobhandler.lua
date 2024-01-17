currentJob = nil
jobBlips = {}
jobObjects = {}
jobSelectionBoards = {}

--- Method to create a job task blip with given coords, label, sprite and creates a second radius blip if isRadius is true
---@param coords vector3 - blip coordinates
---@param label string - Text string to label the blip
---@param sprite number - The sprite number for the blip
---@param isRadius boolean - Whether to create a secondary radius blip
---@return nil
createJobTaskBlip = function(coords, label, sprite, isRadius)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 2)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 18)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName((Locales['blip_job']):format(label))
    EndTextCommandSetBlipName(blip)

    jobBlips[#jobBlips + 1] = blip

    if isRadius then
        local blip2 = AddBlipForRadius(coords, 10.0)
        SetBlipHighDetail(blip2, true)
        SetBlipAlpha(blip2, 150)
        SetBlipColour(blip2, 18)
        jobBlips[#jobBlips + 1] = blip2
    end
end

--- Method to iterate through all jobBlips and deletes them if they still exist, sets jobBlips to empty array
---@return nil
destroyJobBlips = function()
    for i = 1, #jobBlips do
        if DoesBlipExist(jobBlips[i]) then
            RemoveBlip(jobBlips[i])
        end
    end

    jobBlips = {}
end

--- Method to check all objects and deletes it if it is attached to the player's ped and has the given model hash
---@param hash number - object hash
---@return nil
RemovePropType = function(hash)
    local objects = GetGamePool('CObject')
    local ped = cache.ped
    
    for _, object in pairs(objects) do
        if IsEntityAttachedToEntity(ped, object) and GetEntityModel(object) == hash then
            SetEntityAsMissionEntity(object, true, true)
            DeleteObject(object)
            DeleteEntity(object)
            return
        end
    end
end

CreateThread(function()
    local planningBoardModel = 'p_planning_board_02'
    local coords = {
        vector4(1759.023, 2496.597, 46.518, 300.00), -- cells
        vector4(1769.418, 2566.920, 46.934, 180.00) -- canteen
    }

    lib.requestModel(planningBoardModel, 1500)

    if not HasModelLoaded(planningBoardModel) then
		SetModelAsNoLongerNeeded(planningBoardModel)
	else
        for i = 1, #coords do
            local created_object = CreateObjectNoOffset(planningBoardModel, coords[i].xyz, false, false, true)
            SetEntityHeading(created_object, coords[i].w)
            FreezeEntityPosition(created_object, true)
            SetEntityInvincible(created_object, true)
            jobSelectionBoards[#jobSelectionBoards + 1] = created_object

            exports['qb-target']:AddTargetEntity(created_object, {
                options = {
                    {
                        type = 'client',
                        event = 'qb-jail:client:SelectJobMenu',
                        icon = 'fas fa-group-arrows-rotate',
                        label = Locales['target_select_job'],
                        canInteract = function()
                            return PlayerData.metadata.injail ~= 0
                        end
                    },
                },
                distance = 2.0
            })
        end
        
        SetModelAsNoLongerNeeded(planningBoardModel)
	end
end)

RegisterNetEvent('qb-jail:client:SelectJobMenu', function()
    lib.callback('qb-jail:server:GetGroupData', false, function(result)
        local options = {}

        for k, v in ipairs(result) do
            options[#options + 1] = {
                title = v.job ~= currentJob and (Locales['menu_group_title']):format(k, v.label) or (Locales['menu_group_title2']):format(k, v.label),
                description = (Locales['menu_group_description']):format(v.amount),
                icon = v.job ~= currentJob and 'fas fa-circle-chevron-right' or 'fas fa-circle-xmark',
                disabled = v.job == currentJob,
                event = 'qb-jail:client:ChangeJob',
                args = v.job,
            }
        end

        lib.registerContext({
            id = 'jail_jobmenu',
            title = Locales['menu_title_job'],
            options = options
        })

        lib.showContext('jail_jobmenu')

    end)
end)

RegisterNetEvent('qb-jail:client:ChangeJob', function(selectedJob)
    currentJob = selectedJob
    TriggerServerEvent('qb-jail:server:ChangeJob', selectedJob)

    -- Clear Current job objects
    for i = 1, #jobObjects do
        DeleteEntity(jobObjects[i])
    end

    -- Clear Current job blips
    destroyJobBlips()

    -- Clear Current PolyZone
    if currentZone then 
        currentZone:remove()
        currentZone = nil
    end

    if selectedJob == 'running' then
        startRunningJob()

        lib.showTextUI(Locales['textui_running'], { position = 'left-center', })
        Wait(4000)
        lib.hideTextUI()
    elseif selectedJob == 'workout' then
        Utils.Notify(Locales['notify_workout'], 'primary', 2500)

        createJobTaskBlip(vector3(1745.71, 2540.47, 43.59), Locales['workout'], 311, true)
        createJobTaskBlip(vector3(1643.02, 2530.02, 45.56), Locales['workout'], 311, true)
        createJobTaskBlip(vector3(1747.63, 2482.18, 45.74), Locales['workout'], 311, true)

        lib.showTextUI(Locales['textui_workout'], { position = 'left-center', })
        Wait(4000)
        lib.hideTextUI()
    elseif selectedJob == 'kitchen' then
        lib.callback('qb-jail:server:GetCurrentKitchenTask', false, function(label, progress)
            if label and progress then
                Utils.Notify(Locales['notify_kitchen'], 'primary', 2500)
                createJobTaskBlip(vector3(1783.57, 2552.57, 45.67), Locales['kitchen'], 436, true)

                lib.showTextUI((Locales['textui_kitchen']):format(label, progress), { position = 'left-center', })
                Wait(4000)
                lib.hideTextUI()
            end
        end)
    elseif selectedJob == 'cleaning' then
        lib.callback('qb-jail:server:GetActiveCleaningTasks', false, function(result)
            for i = 1, #result do
                createJobTaskBlip(result[i], Locales['cleaning'], 456, false)
            end

            Utils.Notify(Locales['notify_cleaning'], 'primary', 2500)
            
            local progress = math.floor(100 * (Config.CleaningTaskAmount - #result) / Config.CleaningTaskAmount)
            lib.showTextUI(Locales['textui_cleaning']:format(progress), { position = 'left-center' })

            Wait(4000)
            lib.hideTextUI()
        end)
    elseif selectedJob == 'scrapyard' then
        createJobTaskBlip(vector3(1653.66, 2513.7, 45.56), Locales['scrapyard'], 728, true)
        Utils.Notify(Locales['notify_scrapyard'], 'primary', 2500)

        lib.showTextUI(Locales['textui_scrapyard'], { position = 'left-center', })
        Wait(4000)
        lib.hideTextUI()
    elseif selectedJob == 'electrical' then
        lib.callback('qb-jail:server:GetActiveElectricalTasks', false, function(result)
            for i = 1, #result do
                createJobTaskBlip(Config.Electrical[result[i]].coords.xyz, Locales['electrical'], 354, false)
            end

            Utils.Notify(Locales['notify_electrical'], 'primary', 2500)

            lib.showTextUI((Locales['textui_electrical']):format(math.floor(100 * (#Config.Electrical - #result) / #Config.Electrical)), { position = 'left-center', })
            Wait(4000)
            lib.hideTextUI()
        end)
    elseif selectedJob == 'lockup' then
        createJobTaskBlip(vector3(1768.65, 2490.387, 45.56), Locales['lockup'], 730, true)

        lib.showTextUI(Locales['textui_lockup'], { position = 'left-center', })
        Wait(4000)
        lib.hideTextUI()
    elseif selectedJob == 'gardening' then
        createJobTaskBlip(vector3(1693.38, 2546.65, 45.56), Locales['gardening'], 162, true)

        Utils.Notify(Locales['notify_gardening'], 'primary', 2500)

        lib.showTextUI(Locales['textui_gardening'], { position = 'left-center', })
        Wait(4000)
        lib.hideTextUI()
    end
end)

RegisterNetEvent('qb-jail:client:ProgressUpdate', function(message)
    lib.showTextUI(message, { position = 'left-center', })
end)