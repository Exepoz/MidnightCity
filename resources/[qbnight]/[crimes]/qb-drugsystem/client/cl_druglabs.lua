if not Shared.Enable.Druglabs then return end

local druglabs = {}
local comboZone = nil
local inZone = false
local currentLab = nil
local shellCoords = nil
local cachedObjects = {}
local cachedInteractions = {}
local CarryPackage = nil

--- Functions

--- Method to set up the ComboZone for all drug lab entrances
--- @return nil
local setupComboZone = function()
    QBCore.Functions.TriggerCallback('qb-drugsystem:server:GetLabData', function(result)
        druglabs = result
        local zones = {}
        for k, v in pairs(result) do
            zones[#zones + 1] = CircleZone:Create(v.coords, 1.0, {
                name = 'druglabs_' .. v.id,
                data = { id = v.id }
            })
        end

        comboZone = ComboZone:Create(zones, {
            name = 'druglabsComboZone',
            useGrid = true,
            debugPoly = Shared.Debug
        })

        comboZone:onPlayerInOut(function(isPointInside, point, zone)
            if isPointInside then
                inZone = true
                exports['qb-core']:DrawText(_U('interact'), 'left')
                CreateThread(function()
                    while inZone do
                        if IsControlJustPressed(0, 38) then
                            exports['qb-core']:KeyPressed(38)
                            inZone = false
                            TriggerEvent('qb-drugsystem:client:DoorInteractMenu', zone.data.id)
                            return
                        end
                        Wait(3)
                    end
                end)
            else
                inZone = false
                exports['qb-core']:HideText()
            end
        end)
    end)
end

--- Method to destroy all drug lab interaction zones
--- @return nil
local destroyInteractionZones = function()
    for k, v in pairs(cachedInteractions) do
        exports['qb-target']:RemoveZone(k)
    end
    cachedInteractions = {}
end

--- Method that will place the player outside of the current drug lab and clear the lab
--- @return nil
local exitDrugLab = function()
    if not currentLab then return end
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(10) end
    if CarryPackage and DoesEntityExist(CarryPackage) then
        DeleteEntity(CarryPackage)
        CarryPackage = nil
    end
    TriggerEvent('qb-weathersync:client:EnableSync')
    SetEntityCoords(PlayerPedId(), druglabs[currentLab].coords.x, druglabs[currentLab].coords.y, druglabs[currentLab].coords.z - 1.0)
    for _, v in pairs(cachedObjects) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
    end
    cachedObjects = {}
    currentLab = nil
    Wait(100)
    DoScreenFadeIn(1000)
    destroyInteractionZones()
end

--- Method to set up all the interaction zones inside the drug lab for a given lab id
--- @param id number - druglabs index number
--- @return nil
local createInteractionZones = function(id)
    local coords = druglabs[id].coords

    -- Exit
    cachedInteractions['druglabs_exit'] = exports['qb-target']:AddBoxZone('druglabs_exit', vector3(coords.x + Shared.DrugLabs[druglabs[id].type].POIOffsets.exit.x, coords.y + Shared.DrugLabs[druglabs[id].type].POIOffsets.exit.y, 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.exit.z), 1.0, 1.0, {
        name = 'druglabs_exit',
        heading = Shared.DrugLabs[druglabs[id].type].POIOffsets.exit.w,
        minZ = 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.exit.z - 1.0,
        maxZ = 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.exit.z + 1.0,
        debugPoly = Shared.Debug
    }, {
        options = { 
            {
                action = function()
                    exitDrugLab()
                end,
                icon = 'fas fa-user-secret',
                label = _U('exit_lab'),
            }
        },
        distance = 1.5,
    })

    -- Supplies
    cachedInteractions['druglabs_supplies'] = exports['qb-target']:AddBoxZone('druglabs_supplies', vector3(coords.x + Shared.DrugLabs[druglabs[id].type].POIOffsets.supplies.x, coords.y + Shared.DrugLabs[druglabs[id].type].POIOffsets.supplies.y, 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.supplies.z), 1.0, 1.0, {
        name = 'druglabs_supplies',
        heading = Shared.DrugLabs[druglabs[id].type].POIOffsets.supplies.w,
        minZ = 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.supplies.z - 1.0,
        maxZ = 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.supplies.z + 1.0,
        debugPoly = Shared.Debug
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-drugsystem:client:CheckSupplies',
                icon = 'fas fa-user-secret',
                label = _U('check_supplies'),
            }
        },
        distance = 1.5,
    })

    -- Task 1
    cachedInteractions['druglabs_task_1'] = exports['qb-target']:AddBoxZone('druglabs_task_1', vector3(coords.x + Shared.DrugLabs[druglabs[id].type].POIOffsets.task1.x, coords.y + Shared.DrugLabs[druglabs[id].type].POIOffsets.task1.y, 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.task1.z), 1.0, 1.0, {
        name = 'druglabs_task_1',
        heading = Shared.DrugLabs[druglabs[id].type].POIOffsets.task1.w,
        minZ = 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.task1.z - 1.0,
        maxZ = 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.task1.z + 1.0,
        debugPoly = Shared.Debug
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-drugsystem:client:CheckTask',
                icon = 'fas fa-user-secret',
                label = _U(druglabs[id].type .. '_inspect_machine'),
                task = 1,
            }
        },
        distance = 1.5,
    })

    -- Task 2
    cachedInteractions['druglabs_task_2'] = exports['qb-target']:AddBoxZone('druglabs_task_2', vector3(coords.x + Shared.DrugLabs[druglabs[id].type].POIOffsets.task2.x, coords.y + Shared.DrugLabs[druglabs[id].type].POIOffsets.task2.y, 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.task2.z), 1.0, 1.0, {
        name = 'druglabs_task_2',
        heading = Shared.DrugLabs[druglabs[id].type].POIOffsets.task2.w,
        minZ = 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.task2.z - 1.0,
        maxZ = 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.task2.z + 1.0,
        debugPoly = Shared.Debug
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-drugsystem:client:CheckTask',
                icon = 'fas fa-user-secret',
                label = _U(druglabs[id].type .. '_inspect_machine'),
                task = 2,
            }
        },
        distance = 1.5,
    })

    -- Task 3
    cachedInteractions['druglabs_task_3'] = exports['qb-target']:AddBoxZone('druglabs_task_3', vector3(coords.x + Shared.DrugLabs[druglabs[id].type].POIOffsets.task3.x, coords.y + Shared.DrugLabs[druglabs[id].type].POIOffsets.task3.y, 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.task3.z), 1.0, 1.0, {
        name = 'druglabs_task_3',
        heading = Shared.DrugLabs[druglabs[id].type].POIOffsets.task3.w,
        minZ = 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.task3.z - 1.0,
        maxZ = 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.task3.z + 1.0,
        debugPoly = Shared.Debug
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-drugsystem:client:CheckTask',
                icon = 'fas fa-user-secret',
                label = _U(druglabs[id].type .. '_inspect_machine'),
                task = 3,
            }
        },
        distance = 1.5,
    })

    -- Curing
    cachedInteractions['druglabs_curing'] = exports['qb-target']:AddBoxZone('druglabs_curing', vector3(coords.x + Shared.DrugLabs[druglabs[id].type].POIOffsets.curing.x, coords.y + Shared.DrugLabs[druglabs[id].type].POIOffsets.curing.y, 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.curing.z), 1.0, 1.0, {
        name = 'druglabs_curing',
        heading = Shared.DrugLabs[druglabs[id].type].POIOffsets.curing.w,
        minZ = 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.curing.z - 1.0,
        maxZ = 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.curing.z + 1.0,
        debugPoly = Shared.Debug
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-drugsystem:client:CheckCuring',
                icon = 'fas fa-user-secret',
                label = _U(druglabs[id].type .. '_inspect_curing'),
            }
        },
        distance = 1.5,
    })

    -- Reward
    cachedInteractions['druglabs_reward'] = exports['qb-target']:AddBoxZone('druglabs_reward', vector3(coords.x + Shared.DrugLabs[druglabs[id].type].POIOffsets.reward.x, coords.y + Shared.DrugLabs[druglabs[id].type].POIOffsets.reward.y, 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.reward.z), 1.0, 1.0, {
        name = 'druglabs_reward',
        heading = Shared.DrugLabs[druglabs[id].type].POIOffsets.reward.w,
        minZ = 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.reward.z - 1.0,
        maxZ = 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.reward.z + 1.0,
        debugPoly = Shared.Debug
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-drugsystem:client:CheckReward',
                icon = 'fas fa-user-secret',
                label = _U('inspect_reward'),
            }
        },
        distance = 1.5,
    })
end

--- Method to create the drug lab shell and place the player inside
--- @param id number - druglabs index number
--- @return nil
local createDrugLab = function(id)
    local objects = {}
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(10) end
    currentLab = id
    local coords = druglabs[id].coords
    local shell = Shared.DrugLabs[druglabs[id].type].shell
    RequestModel(shell)
    while not HasModelLoaded(shell) do Wait(10) end
    local shellObject = CreateObject(shell, coords.x, coords.y, 2000.0, false, false, false)
    shellCoords = vector3(coords.x, coords.y, 2000.0)
    FreezeEntityPosition(shellObject, true)
    objects[#objects+1] = shellObject
    cachedObjects = objects
    SetEntityCoords(PlayerPedId(), coords.x + Shared.DrugLabs[druglabs[id].type].POIOffsets.exit.x, coords.y + Shared.DrugLabs[druglabs[id].type].POIOffsets.exit.y, 2000.0 + Shared.DrugLabs[druglabs[id].type].POIOffsets.exit.z - 1.0, 0, 0, 0, false)
    SetEntityHeading(PlayerPedId(), Shared.DrugLabs[druglabs[id].type].POIOffsets.exit.w)
    TriggerEvent('qb-weathersync:client:DisableSync')
    Wait(100)
    DoScreenFadeIn(1000)
    createInteractionZones(id)
end

--- Start/Stop Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    setupComboZone()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    druglabs = {}
    comboZone:destroy()
    
    if currentLab then
        TriggerEvent('qb-weathersync:client:EnableSync')
        SetEntityCoords(PlayerPedId(), druglabs[currentLab].coords.x, druglabs[currentLab].coords.y, druglabs[currentLab].coords.z - 1.0)
        for _, v in pairs(cachedObjects) do
            if DoesEntityExist(v) then
                DeleteEntity(v)
            end
        end
        cachedObjects = {}
        currentLab = nil
    end

    if CarryPackage and DoesEntityExist(CarryPackage) then
        DeleteEntity(CarryPackage)
        CarryPackage = nil
    end
end)

AddEventHandler('onResourceStop', function (resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    comboZone:destroy()

    if currentLab then
        TriggerEvent('qb-weathersync:client:EnableSync')
        SetEntityCoords(PlayerPedId(), druglabs[currentLab].coords.x, druglabs[currentLab].coords.y, druglabs[currentLab].coords.z - 1.0)
        for _, v in pairs(cachedObjects) do
            if DoesEntityExist(v) then
                DeleteEntity(v)
            end
        end
    end

    if CarryPackage and DoesEntityExist(CarryPackage) then
        DeleteEntity(CarryPackage)
        CarryPackage = nil
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    setupComboZone()
end)

--- Events

RegisterNetEvent('qb-drugsystem:client:NewForSaleLab', function(data)
    druglabs[data.id] = data
    local zone = CircleZone:Create(data.coords, 1.0, {
        name = 'druglabs_' .. data.id,
        data = { id = data.id }
    })
    comboZone:AddZone(zone)
end)

RegisterNetEvent('qb-drugsystem:client:LabPurchased', function(id, cid)
    if not druglabs[id] then return end
    druglabs[id].owner = cid
    druglabs[id].owned = 1
end)

RegisterNetEvent('qb-drugsystem:client:DoorInteractMenu', function(id)
    if not druglabs[id] then return end
    if druglabs[id].owned == 1 then
        if PlayerData.citizenid == druglabs[id].owner then -- Owner menu
            exports['qb-menu']:openMenu({
                {
                    header = _U('drug_lab'),
                    txt = _U('click_or_esc'),
                    icon = 'fas fa-chevron-left',
                    params = {
                        event = 'qb-menu:closeMenu'
                    }
                },
                {
                    header = _U('enter'),
                    txt = _U('enter_lab'),
                    icon = 'fas fa-door-open',
                    params = {
                        event = 'qb-drugsystem:client:EnterDruglab',
                        args = id
                    }
                },
                {
                    header = _U('change_password_header'),
                    txt = _U('change_password_txt'),
                    icon = 'fas fa-user-shield',
                    params = {
                        event = 'qb-drugsystem:client:ChangeCode',
                        args = id
                    }
                }
            })
        else -- Enter code or raid for police
            if Shared.PoliceRaid and PlayerData.job.type == 'leo' then
                exports['qb-menu']:openMenu({
                    {
                        header = _U('private_property'),
                        txt = _U('click_or_esc'),
                        icon = 'fas fa-chevron-left',
                        params = {
                            event = 'qb-menu:closeMenu'
                        }
                    },
                    {
                        header = _U('raid_building_header'),
                        txt = _U('raid_building_txt'),
                        icon = 'fas fa-user-shield',
                        params = {
                            event = 'qb-drugsystem:client:EnterDruglab',
                            args = id
                        }
                    }
                })
            else
                local dialog = exports['qb-input']:ShowInput({
                    header = _U('enter_password_header'),
                    submitText = _U('enter_password_submit'),
                    inputs = {
                        {
                            text = _U('enter_password_placeholder'),
                            name = 'password',
                            type = 'text',
                            isRequired = true
                        }
                    }
                })
            
                if not dialog or not next(dialog) then return end
                if dialog.password == druglabs[id].code then
                    TriggerEvent('qb-drugsystem:client:EnterDruglab', id)
                else
                    QBCore.Functions.Notify(_U('incorrect_password'), 'error', 2500)
                end
            end
        end
    else -- For sale menu
        exports['qb-menu']:openMenu({
            {
                header = _U('drug_lab'),
                txt = _U('click_or_esc'),
                icon = 'fas fa-chevron-left',
                params = {
                    event = 'qb-menu:closeMenu'
                }
            },
            {
                header = 'Lab: ' .. druglabs[id].type .. ' - Price: $' .. druglabs[id].price,
                txt = _U('purchase_lab'),
                icon = 'fas fa-cart-arrow-down',
                params = {
                    isServer = true,
                    event = 'qb-drugsystem:server:PurchaseDrugLab',
                    args = id
                }
            }
        })
    end
end)

RegisterNetEvent('qb-drugsystem:client:EnterDruglab', function(id)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped, false)
    if #(coords - druglabs[id].coords) < 1.0 then
        if currentLab then return end
        createDrugLab(id)
    end
end)

RegisterNetEvent('qb-drugsystem:client:ChangeCode', function(id)
    local dialog = exports['qb-input']:ShowInput({
		header = _U('change_password_header'),
		submitText = _U('enter_password_submit'),
		inputs = {
			{
				text = _U('current_password_placeholder'),
				name = 'current',
				type = 'text',
				isRequired = true
			},
			{
				text = _U('new_password_placeholder'),
				name = 'new',
				type = 'text',
                isRequired = true
			}
		}
	})

    if not dialog or not next(dialog) then return end
    if dialog.current ~= druglabs[id].code then
        QBCore.Functions.Notify(_U('incorrect_current_pass'), 'error', 2500)
        return
    end

    if dialog.current == dialog.new then
        QBCore.Functions.Notify(_U('current_is_new'), 'error', 2500)
        return
    end

    TriggerServerEvent('qb-drugsystem:server:ChangeCode', id, dialog.current, dialog.new)
end)

RegisterNetEvent('qb-drugsystem:client:CheckSupplies', function()
    if not currentLab then return end
    QBCore.Functions.TriggerCallback('qb-drugsystem:server:GetSupplyInfo', function(result)
        local menu = {
            {
                header = _U('supplies_menu_header'),
                txt = _U('current_stock') .. result,
                icon = 'fas fa-angle-left',
                params = {
                    event = 'qb-menu:closeMenu',
                }
            },
            {
                header = _U('add_ingredients_header'),
                txt = _U('add_ingredients_txt'),
                icon = 'fas fa-plus',
                params = {
                    event = 'qb-drugsystem:client:AddStock'
                }
            }
        }

        if result > 0 and not CarryPackage then
            menu[#menu+1] = {
                header = _U('grab_ingredients_header'),
                txt = _U('grab_ingredients_txt'),
                icon = 'fas fa-hand-holding',
                params = {
                    event = 'qb-drugsystem:client:GrabStock'
                }
            }
        else
            menu[#menu+1] = {
                header = _U('grab_ingredients_header'),
                txt = _U('grab_ingredients_txt'),
                icon = 'fas fa-hand-holding',
                isMenuHeader = true
            }
        end

        if CarryPackage then
            menu[#menu+1] = {
                header = _U('return_ingredients_header'),
                txt = _U('return_ingredients_txt'),
                icon = 'fas fa-hand-holding-medical',
                params = {
                    event = 'qb-drugsystem:client:ReturnStock'
                }
            }
        end
        exports['qb-menu']:openMenu(menu)
    end, currentLab)
end)

RegisterNetEvent('qb-drugsystem:client:AddStock', function()
    if not currentLab then return end
    local hasItem = QBCore.Functions.HasItem(Shared.DrugLabs[druglabs[currentLab].type].items.supply)
    if hasItem then
        local ped = PlayerPedId()
        TaskStartScenarioInPlace(ped, 'PROP_HUMAN_BUM_BIN', 0, true)
        Wait(5000)
        ClearPedTasks(ped)
        TriggerServerEvent('qb-drugsystem:server:AddStock', currentLab)
    else
        QBCore.Functions.Notify(_U('nothing_useful_on_you'), 'error', 2500)
    end
end)

RegisterNetEvent('qb-drugsystem:client:GrabStock', function()
    if CarryPackage or not currentLab then return end
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, 'PROP_HUMAN_BUM_BIN', 0, true)
    QBCore.Functions.Progressbar('pickup_reycle_package', _U('grabbing_ingredients'), 5000, false, true, {}, {}, {}, {}, function() -- Done
        ClearPedTasks(ped)
        local model = `bkr_prop_meth_toulene`
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(10) end
        local pos = GetEntityCoords(ped, true)
        CarryPackage = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)
        AttachEntityToEntity(CarryPackage, ped, GetPedBoneIndex(ped, 28422), 0.55, 0.00, 0.00, 00.0, -90.0, 0.0, true, true, false, true, 1, true)
        TriggerServerEvent('qb-drugsystem:server:GrabStock', currentLab)
    end, function() -- cancel
        ClearPedTasks(ped)
    end)
end)

RegisterNetEvent('qb-drugsystem:client:ReturnStock', function()
    if not CarryPackage or not currentLab then return end
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, 'PROP_HUMAN_BUM_BIN', 0, true)
    QBCore.Functions.Progressbar('pickup_reycle_package', _U('returning_ingredients'), 2500, false, false, {}, {}, {}, {}, function() -- Done
        ClearPedTasks(ped)
        DeleteObject(CarryPackage)
        CarryPackage = nil
        TriggerServerEvent('qb-drugsystem:server:ReturnStock', currentLab)
    end)
end)

RegisterNetEvent('qb-drugsystem:client:CheckTask', function(data)
    if not currentLab then return end
    QBCore.Functions.TriggerCallback('qb-drugsystem:server:GetTaskData', function(result)
        if not result then return end

        if result.state == 'started' then
            QBCore.Functions.Notify(_U('nothing_just_wait'), 'error', 5000)
            return
        end

        if result.state == 'completed' then
            QBCore.Functions.Notify(_U('step_completed'), 'error', 5000)
            return
        end

        local menu = {
            {
                header = _U('close'),
                txt = _U('click_or_esc'),
                icon = 'fas fa-angle-left',
                params = {
                    event = 'qb-menu:closeMenu',
                }
            },
            {
                header = _U('parameter_set'),
                txt = _U('parameter_current') .. result.parameter .. ' ' .. _U(druglabs[currentLab].type .. '_parameter'),
                icon = 'fas fa-temperature-low',
                params = {
                    event = 'qb-drugsystem:client:SetTaskParameter',
                    args = data.task
                }
            }
        }

        if result.current == Shared.DrugLabs[druglabs[currentLab].type].tasks[data.task].requiredIngredients then
            menu[#menu + 1] = {
                header = _U('ingredients_add'),
                txt = _U('ingredients_currently') .. result.current .. ' / ' .. Shared.DrugLabs[druglabs[currentLab].type].tasks[data.task].requiredIngredients,
                isMenuHeader = true,
                icon = 'fas fa-plus',
            }
            menu[#menu + 1] = {
                header = _U('task_start_header'),
                txt = _U('task_start_txt'),
                icon = 'fas fa-hourglass-start',
                params = {
                    isServer = true,
                    event = 'qb-drugsystem:server:StartMachine',
                    args = {
                        id = currentLab,
                        task = data.task
                    }
                }
            }
        else
            menu[#menu + 1] = {
                header = _U('ingredients_add'),
                txt = _U('ingredients_currently') .. result.current .. ' / ' .. Shared.DrugLabs[druglabs[currentLab].type].tasks[data.task].requiredIngredients,
                icon = 'fas fa-plus',
                params = {
                    event = 'qb-drugsystem:client:AddTaskIngredients',
                    args = data.task
                }
            }
            menu[#menu + 1] = {
                header = _U('task_start_header'),
                txt = _U('task_start_txt'),
                icon = 'fas fa-hourglass-start',
                isMenuHeader = true,
            }
        end

        exports['qb-menu']:openMenu(menu)
    end, currentLab, data.task)
end)

RegisterNetEvent('qb-drugsystem:client:AddTaskIngredients', function(task)
    if not CarryPackage or not currentLab then return end
    RequestNamedPtfxAsset('core')
    while not HasNamedPtfxAssetLoaded('core') do Wait(10) end
    SetPtfxAssetNextCall('core')
    local effect = StartParticleFxLoopedOnEntity('ent_sht_water', CarryPackage, 0.35, 0.0, 0.25, 0.0, 0.0, 0.0, 2.0, false, false, false)

    QBCore.Functions.Progressbar('druglabs_add_ingredients', _U('adding_ingredients'), 6000, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'weapon@w_sp_jerrycan',
        anim = 'fire',
        flags = 1,
    }, {}, {}, function()
        TriggerServerEvent('qb-drugsystem:server:AddTaskIngredients', currentLab, task)
        ClearPedTasks(PlayerPedId())
        DeleteObject(CarryPackage)
        CarryPackage = nil
        StopParticleFxLooped(effect, 0)
    end)
end)

RegisterNetEvent('qb-drugsystem:client:SetTaskParameter', function(task)
    local input = exports['qb-input']:ShowInput({
        header = _U('parameter_set'),
        submitText = _U('enter_password_submit'),
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'parameter',
                text = _U(druglabs[currentLab].type .. '_parameter')
            }
        }
    })
    if input and input.parameter and currentLab then
        local p = tonumber(input.parameter)
        if p <= 0 or p > 100 then
            QBCore.Functions.Notify(_U('parameter_invalid_input'), 'error', 2500)
            return
        end
        TriggerServerEvent('qb-drugsystem:server:SetTaskParameter', currentLab, task, p)
    end
end)

RegisterNetEvent('qb-drugsystem:client:CheckReward', function()
    if not currentLab then return end
    TriggerServerEvent('qb-drugsystem:server:CheckReward', currentLab)
end)

RegisterNetEvent('qb-drugsystem:client:CheckCuring', function()
    if not currentLab then return end
    QBCore.Functions.TriggerCallback('qb-drugsystem:server:GetCuringData', function(result)
        if result.state == 'notstarted' then
            exports['qb-menu']:openMenu({
                {
                    header = _U('close'),
                    txt = _U('click_or_esc'),
                    icon = 'fas fa-angle-left',
                    params = {
                        event = 'qb-menu:closeMenu',
                    }
                },
                {
                    header = _U('curing_start_header'),
                    txt = _U(druglabs[currentLab].type .. '_curing_start_txt'),
                    icon = 'fas fa-plus',
                    params = {
                        isServer = true,
                        event = 'qb-drugsystem:server:AddCureBatch',
                        args = currentLab
                    }
                }
            })
        elseif result.state == 'started' then
            QBCore.Functions.Notify(_U('nothing_just_wait'), 'error', 5000)
        elseif result.state == 'completed' then
            exports['qb-menu']:openMenu({
                {
                    header = _U('close'),
                    txt = _U('click_or_esc'),
                    icon = 'fas fa-angle-left',
                    params = {
                        event = 'qb-menu:closeMenu',
                    }
                },
                {
                    header = _U('curing_grab_batch_header'),
                    txt = _U('curing_grab_batch_txt'),
                    icon = 'fas fa-plus',
                    params = {
                        isServer = true,
                        event = 'qb-drugsystem:server:GrabCureBatch',
                        args = currentLab
                    }
                }
            })
        end
    end, currentLab)
end)

--- Commands 

--- Command to get POIOffsets for shell
RegisterCommand('laboffset', function()
    if not currentLab then return end
    local coords = GetEntityCoords(PlayerPedId())
    local x_offset = coords.x - shellCoords.x
    local y_offset = coords.y - shellCoords.y
    local z_offset = coords.z - 2000.0
    local w = GetEntityHeading(PlayerPedId())
    print(vector4(x_offset, y_offset, z_offset, w))
end)
