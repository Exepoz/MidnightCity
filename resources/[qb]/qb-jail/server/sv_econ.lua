--- Event Handlers

if Config.Inventory == 'ox_inventory' then
    AddEventHandler('onServerResourceStart', function(resourceName)
        if resourceName == 'ox_inventory' or resourceName == Config.Resource then
            exports['ox_inventory']:RegisterStash('prison_stash_1', 'Prison Stash', 80, 4000000, false)
            exports['ox_inventory']:RegisterStash('prison_stash_2', 'Prison Stash', 80, 4000000, false)
            exports['ox_inventory']:RegisterStash('prison_stash_3', 'Prison Stash', 80, 4000000, false)

            -- Slushie
            exports['ox_inventory']:RegisterShop('jailslushie', {
                name = Locales['shop_slushie'],
                inventory = {
                    { name = 'prisonslushie', price = 0, amount = 1 },
                },
            })

            -- Gardening Supplies
            exports['ox_inventory']:RegisterShop('jailgardening', {
                name = Locales['shop_gardening'],
                inventory = {
                    { name = 'prisonfarmseeds', price = 0, amount = 10 },
                    { name = 'prisonwateringcan', price = 0, amount = 10 },
                    { name = 'prisonfarmnutrition', price = 0, amount = 10 },
                },
            })
        end
    end)
end

--- Crafting Stuff

RegisterNetEvent('qb-jail:server:CraftItem', function(index)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not Config.CraftingCost[index] then return end
    
    if not isPlayerInJail(src) then return end

    if Config.Inventory == 'ox_inventory' then
        local playerItems = exports['ox_inventory']:GetInventoryItems(src)
        local hasItems = true

        for _, v in pairs(Config.CraftingCost[index].items) do
            for item, data in pairs(playerItems) do
                if data.name == v.item and data.count < v.amount then
                    hasItems = false
                    Utils.Notify(src, Locales['notify_missing_items'], 'error', 2500)
                    return
                end
            end
        end

        if hasItems then
            for _, v in pairs(Config.CraftingCost[index].items) do
                exports['ox_inventory']:RemoveItem(src, v.item, v.amount)
            end

            exports['ox_inventory']:AddItem(src,Config.CraftingCost[index].item, Config.CraftingCost[index].amount)
        end
    elseif Config.Inventory == 'qb' then
        local hasItems = true

        for _, v in pairs(Config.CraftingCost[index].items) do
            if not QBCore.Functions.HasItem(src, v.item, v.amount) then
                hasItems = false
                Utils.Notify(src, Locales['notify_missing_items'], 'error', 2500)
                return
            end
        end

        if hasItems then
            for _, v in pairs(Config.CraftingCost[index].items) do
                Player.Functions.RemoveItem(v.item, v.amount, false)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[v.item], 'remove', v.amount)
            end

            Player.Functions.AddItem(Config.CraftingCost[index].item, Config.CraftingCost[index].amount, false)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.CraftingCost[index].item], 'add', Config.CraftingCost[index].amount)
        end
    end
end)

--- Prison Gangster Stuff

RegisterNetEvent('qb-jail:server:PurchaseItem', function(index)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not Config.PrisonerPedShop[index] then return end

    if not isPlayerInJail(src) then return end

    if Config.Inventory == 'ox_inventory' then
        if exports['ox_inventory']:RemoveItem(src, Config.PrisonerPedShop[index].cost.item, Config.PrisonerPedShop[index].cost.amount) then
            exports['ox_inventory']:AddItem(src, Config.PrisonerPedShop[index].item, 1)
            Utils.CreateLog(Player.PlayerData.name, 'Purchase Item', 'Purchase Item', Player.PlayerData.name .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. src .. ')' .. ' has purchased ' .. Config.PrisonerPedShop[index].item .. ' from prison ped')
        end
    elseif Config.Inventory == 'qb' then
        if Player.Functions.RemoveItem(Config.PrisonerPedShop[index].cost.item, Config.PrisonerPedShop[index].cost.amount, false) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.PrisonerPedShop[index].cost.item], 'remove', Config.PrisonerPedShop[index].cost.amount)
            Player.Functions.AddItem(Config.PrisonerPedShop[index].item, 1, false)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.PrisonerPedShop[index].item], 'add', 1)
            Utils.CreateLog(Player.PlayerData.name, 'Purchase Item', 'Purchase Item', Player.PlayerData.name .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. src .. ')' .. ' has purchased ' .. Config.PrisonerPedShop[index].item .. ' from prison ped')
        end
    end
end)

--- Slushie Stuff

QBCore.Functions.CreateUseableItem('prisonslushie', function(source, item)
    local src = source

    if Config.Inventory == 'ox_inventory' then
        if exports['ox_inventory']:RemoveItem(src, 'prisonslushie', 1) then
            TriggerClientEvent('qb-jail:client:UseSlushie', src)

            if Config.SlushieSpoonChance >= math.random(100) and isPlayerInJail(src) then
                exports['ox_inventory']:AddItem(src, 'prisonspoon', 1)
            end
        end
    elseif Config.Inventory == 'qb' then
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return end

        if Player.Functions.RemoveItem('prisonslushie', 1, false) then
            TriggerClientEvent('qb-jail:client:UseSlushie', src)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['prisonslushie'], 'remove', 1)

            if Config.SlushieSpoonChance >= math.random(100) and isPlayerInJail(src) then
                Player.Functions.AddItem('prisonspoon', 1, false)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['prisonspoon'], 'add', 1)
            end
        end
    end
end)
