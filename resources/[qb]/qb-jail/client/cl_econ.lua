--- Slushie Stuff

local makingSlushie = false

RegisterNetEvent('qb-jail:client:MakeSlushie', function()
    if makingSlushie then return end
    makingSlushie = true

    -- Animation
    local ped = cache.ped
    lib.requestAnimDict('mp_ped_interaction', 1500)
    TaskPlayAnim(ped, 'mp_ped_interaction', 'handshake_guy_a', 8.0, 8.0, -1, 16, 0.0, 0, 0, 0)
	 
    -- Minigame
    exports['ps-ui']:Circle(function(success)
        if success then
            -- Open Store
            if Config.Inventory == 'ox_inventory' then
                exports['ox_inventory']:openInventory('shop', { type = 'jailslushie', id = 1 })
            elseif Config.Inventory == 'qb' then
                TriggerServerEvent('inventory:server:OpenInventory', 'shop', Locales['shop_slushie'], {
                    label = Locales['shop_slushie'],
                    slots = 1,
                    items = {
                        [1] = { 
                            name = 'prisonslushie', 
                            price = 0, 
                            amount = 1, 
                            info = {}, 
                            type = 'item', 
                            slot = 1, 
                        },
                    }
                })
            end
            	
        end

        StopAnimTask(ped, 'mp_ped_interaction', 'handshake_guy_a', 1.0)
        RemoveAnimDict('amb@mp_ped_interaction')
        makingSlushie = false
    end, 1, 14)
end)

RegisterNetEvent('qb-jail:client:UseSlushie', function()
    TriggerEvent('animations:client:EmoteCommandStart', {'drink'})

    if lib.progressBar({
        duration = 5000,
        label = 'Drinking..',
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true, mouse = false },
    }) then
        TriggerEvent('animations:client:EmoteCommandStart', {'c'})
        TriggerServerEvent('consumables:server:addThirst', QBCore.Functions.GetPlayerData().metadata['thirst'] + 69.0)
        TriggerServerEvent('consumables:server:addHunger', QBCore.Functions.GetPlayerData().metadata['hunger'] + 69.0)
    else
        Utils.Notify(Locales['notify_canceled'], 'error', 2500)
    end
end)

CreateThread(function()
    exports['qb-target']:AddBoxZone('prison_slushie', vector3(1777.72, 2559.82, 45.50), 1.0, 0.4, {
        name = 'prison_slushie',
        heading = 270,
        debugPoly = Config.TargetDebug,
        minZ = 45.50,
        maxZ = 46.50
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:MakeSlushie',
                icon = 'fas fa-glass-water',
                label = Locales['target_make_slushie']
            }
        },
        distance = 1.5,
    })
end)

--- Crafting Stuff

RegisterNetEvent('qb-jail:client:OpenCraftingMenu', function()
    if PlayerData.metadata.injail == 0 then return end

    local options = {}

    for k, v in ipairs(Config.CraftingCost) do
        local metadata = {}

        for i = 1, #v.items do
            metadata[#metadata + 1] = {
                label = QBCore.Shared.Items[v.items[i].item].label,
                value = v.items[i].amount
            }
        end
        
        options[#options + 1] = {
            title = v.amount .. 'x ' .. v.header .. ' (' .. v.durationLabel .. ')',
            description = QBCore.Shared.Items[v.item].description,
            metadata = metadata,
            icon = 'fas fa-circle-chevron-right',
            event = 'qb-jail:client:CraftItem',
            args = k,
        }

    end

    lib.registerContext({
        id = 'jail_crafting',
        title = Locales['menu_title_crafting'],
        options = options
    })

    lib.showContext('jail_crafting')
end)

RegisterNetEvent('qb-jail:client:CraftItem', function(index)
    if not Config.CraftingCost[index] then return end

    if PlayerData.metadata.injail == 0 then return end

    if lib.progressBar({
        duration = Config.CraftingCost[index].duration,
        label = Locales['progressbar_crafting'],
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true, mouse = false },
        anim = { dict = 'anim@gangops@facility@servers@bodysearch@', clip = 'player_search', flag = 16 },
    }) then
        TriggerServerEvent('qb-jail:server:CraftItem', index)
    else
        Utils.Notify(Locales['notify_canceled'], 'error', 2500)
    end
end)

CreateThread(function()
    exports['qb-target']:AddBoxZone('prison_crafting_1', vector3(1776.79, 2560.8, 44.67), 0.8, 0.8, {
        name = 'prison_crafting_1',
        heading = 0,
        debugPoly = Config.TargetDebug,
        minZ = 44.67,
        maxZ = 46.67
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:OpenCraftingMenu',
                icon = 'fas fa-screwdriver-wrench',
                label = Locales['target_crafting'],
                canInteract = function()
                    return PlayerData.metadata.injail ~= 0
                end
            }
        },
        distance = 1.5,
    })
end)

--- Stashes

RegisterNetEvent('qb-jail:client:OpenStash', function(data)
    if PlayerData.metadata.injail == 0 then return end
    
    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'StashOpen', 0.4)
        
    if Config.Inventory == 'qb' then
        TriggerServerEvent('inventory:server:OpenInventory', 'stash', data.stash)
        TriggerEvent('inventory:client:SetCurrentStash', data.stash)
    elseif Config.Inventory == 'ox_inventory' then
        exports['ox_inventory']:openInventory('stash', data.stash)
    end
end)

CreateThread(function()
    exports['qb-target']:AddBoxZone('prison_stash_1', vector3(1778.25, 2545.55, 44.67), 1.6, 0.7, {
        name = 'prison_stash_1',
        heading = 270,
        debugPoly = Config.TargetDebug,
        minZ = 44.67,
        maxZ = 46.00
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:OpenStash',
                icon = 'fas fa-user-secret',
                label = Locales['target_stash'],
                stash = 'prison_stash_1',
                canInteract = function()
                    return PlayerData.metadata.injail ~= 0
                end
            }
        },
        distance = 1.5,
    })

    exports['qb-target']:AddBoxZone('prison_stash_2', vector3(1772.78, 2567.8, 44.73), 1.6, 0.7, {
        name = 'prison_stash_2',
        heading = 0,
        debugPoly = Config.TargetDebug,
        minZ = 44.73,
        maxZ = 46.05
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:OpenStash',
                icon = 'fas fa-user-secret',
                label = Locales['target_stash'],
                stash = 'prison_stash_2',
                canInteract = function()
                    return PlayerData.metadata.injail ~= 0
                end
            }
        },
        distance = 1.5,
    })

    exports['qb-target']:AddBoxZone('prison_stash_3', vector3(1689.31, 2553.23, 44.73), 1.9, 1.2, {
        name = 'prison_stash_3',
        heading = 270,
        debugPoly = Config.TargetDebug,
        minZ = 44.73,
        maxZ = 46.05
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:OpenStash',
                icon = 'fas fa-user-secret',
                label = Locales['target_stash'],
                stash = 'prison_stash_3',
                canInteract = function()
                    return PlayerData.metadata.injail ~= 0
                end
            }
        },
        distance = 1.5,
    })
end)

--- Prison Gangster Stuff

RegisterNetEvent('qb-jail:client:PrisonerPedShop', function()
    if PlayerData.metadata.injail == 0 then return end
    
    local options = {}

    for k, v in ipairs(Config.PrisonerPedShop) do 
        options[#options + 1] = {
            title = ('%s (%sx %s)'):format(v.header, v.cost.amount, QBCore.Shared.Items[v.cost.item].label),
            description = v.text,
            metadata = {
                { label = QBCore.Shared.Items[v.cost.item].label, value = v.cost.amount }
            },
            icon = 'fas fa-circle-chevron-right',
            event = 'qb-jail:client:PurchaseItem',
            args = k,
        }
    end

    lib.registerContext({
        id = 'jail_prisonerpedshop',
        title = Locales['menu_title_prisonshop'],
        options = options
    })

    lib.showContext('jail_prisonerpedshop')
end)

RegisterNetEvent('qb-jail:client:PurchaseItem', function(index)
    if PlayerData.metadata.injail == 0 then return end

    if not Config.PrisonerPedShop[index] then return end

    if lib.progressBar({
        duration = 6000,
        label = Locales['progressbar_purchaseitem'],
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true, mouse = false },
        anim = { dict = 'mp_safehouselost@', clip = 'package_dropoff', flag = 16 },
    }) then
        TriggerServerEvent('qb-jail:server:PurchaseItem', index)
    else
        Utils.Notify(Locales['notify_canceled'], 'error', 2500)
    end
end)

prisonerPed = 0

createPrisonPed = function()
    local coords = vector4(1734.96, 2544.32, 43.59, 210.0)
    local pedModel = `s_m_y_prismuscl_01`
    lib.requestModel(pedModel, 1500)
    
    prisonerPed = CreatePed(0, pedModel, coords.x, coords.y, coords.z, coords.w, false, false)
    lib.requestAnimDict('timetable@ron@ig_5_p3', 1500)
    TaskPlayAnim(prisonerPed, 'timetable@ron@ig_5_p3', 'ig_5_p3_base', 8.0, 8.0, -1, 2, 0.0, false, false, false)
    Wait(GetAnimDuration('timetable@ron@ig_5_p3', 'ig_5_p3_base') * 1000)

    FreezeEntityPosition(prisonerPed, true)
    SetEntityInvincible(prisonerPed, true)
    SetBlockingOfNonTemporaryEvents(prisonerPed, true)
    
    RemoveAnimDict('timetable@ron@ig_5_p3')

    exports['qb-target']:AddTargetEntity(prisonerPed, {
        options = {
            {
                type = 'client',
                event = 'qb-jail:client:PrisonerPedShop',
                icon = 'fas fa-comments-dollar',
                label = Locales['target_prisonerped'],
                canInteract = function()
                    return PlayerData.metadata.injail ~= 0
                end
            }
        },
        distance = 1.5,
    })
    
end
