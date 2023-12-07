QBCore = exports['qb-core']:GetCoreObject()

--- Functions

--- Method to print debug messages to console when Config.Debug is enabled
--- @param message string - message to print
--- @return nil
debugPrint = function(message)
    if type(message) == 'string' then
        print('^3[qb-drugsystem] ^5' .. message .. '^7')
    end
end

--- Method to grab amount of cops on duty
--- @return amount number - Amount of cops on duty
getCopCount = function()
    local amount = 0
    local Players = QBCore.Functions.GetQBPlayers()
    for _, Player in pairs(Players) do
        if Player.PlayerData.job.type == 'leo' and Player.PlayerData.job.onduty then
            amount += 1
        end
    end
    return amount
end

--- Events

RegisterNetEvent('qb-drugsystem:server:MakeBaggies', function(drug)
    if not Shared.DrugLabs[drug] then return end
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = Player.Functions.GetItemByName(Shared.DrugLabs[drug].items.curedItem)
    if Player and QBCore.Functions.HasItem(src, Shared.EmptyBagItem, Shared.EmptyBagAmount) and Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], 'remove', 1)
        Player.Functions.RemoveItem(Shared.EmptyBagItem, Shared.EmptyBagAmount, false)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Shared.EmptyBagItem], 'remove', Shared.EmptyBagAmount)
        local info = { purity = item.info.purity }
        Player.Functions.AddItem(Shared.DrugLabs[drug].items.bagItem, Shared.EmptyBagAmount, false, info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Shared.DrugLabs[drug].items.bagItem], 'add', Shared.EmptyBagAmount)
    end
end)

--- Callbacks

QBCore.Functions.CreateCallback('qb-drugsystem:server:GetCopCount', function(source, cb)
    cb(getCopCount())
end)

--- Items

-- QBCore.Functions.CreateUseableItem(Shared.DrugLabs.meth.items.curedItem, function(source, item)
--     local src = source
--     if QBCore.Functions.HasItem(src, Shared.EmptyBagItem, Shared.EmptyBagAmount) then
--         TriggerClientEvent('qb-drugsystem:client:MakeBaggies', src, 'meth')
--     else
--         TriggerClientEvent('QBCore:Notify', src, _U('not_enough_baggies') .. ' (' .. Shared.EmptyBagAmount .. ')', 'error', 2500)
--     end
-- end)

-- QBCore.Functions.CreateUseableItem(Shared.DrugLabs.coke.items.curedItem, function(source, item)
--     local src = source
--     if QBCore.Functions.HasItem(src, Shared.EmptyBagItem, Shared.EmptyBagAmount) then
--         TriggerClientEvent('qb-drugsystem:client:MakeBaggies', src, 'coke')
--     else
--         TriggerClientEvent('QBCore:Notify', src, _U('not_enough_baggies') .. ' (' .. Shared.EmptyBagAmount .. ')', 'error', 2500)
--     end
-- end)

-- QBCore.Functions.CreateUseableItem(Shared.DrugLabs.weed.items.curedItem, function(source, item)
--     local src = source
--     if QBCore.Functions.HasItem(src, Shared.EmptyBagItem, Shared.EmptyBagAmount) then
--         TriggerClientEvent('qb-drugsystem:client:MakeBaggies', src, 'weed')
--     else
--         TriggerClientEvent('QBCore:Notify', src, _U('not_enough_baggies') .. ' (' .. Shared.EmptyBagAmount .. ')', 'error', 2500)
--     end
-- end)

-- QBCore.Functions.CreateUseableItem(Shared.DrugLabs.meth.items.bagItem, function(source, item)
--     local src = source
--     local Player = QBCore.Functions.GetPlayer(src)
--     if Player and Player.Functions.RemoveItem(item.name, 1, item.slot) then
--         TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], 'remove', 1)
--         if item.info.purity then
--             TriggerClientEvent('qb-drugsystem:client:UseMethBag', src, item.info.purity)
--         else -- Fallback value
--             TriggerClientEvent('qb-drugsystem:client:UseMethBag', src, 50)
--         end
--     end
-- end)

-- QBCore.Functions.CreateUseableItem(Shared.DrugLabs.meth.items.bagItem, function(source, item)
--     local src = source
--     local Player = QBCore.Functions.GetPlayer(src)
--     if Player and Player.Functions.RemoveItem(item.name, 1, item.slot) then
--         TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], 'remove', 1)
--         if item.info.purity then
--             TriggerClientEvent('qb-drugsystem:client:UseMethBag', src, item.info.purity)
--         else -- Fallback value
--             TriggerClientEvent('qb-drugsystem:client:UseMethBag', src, 50)
--         end
--     end
-- end)

-- QBCore.Functions.CreateUseableItem(Shared.MethcamperRewardItem, function(source, item)
--     local src = source
--     local Player = QBCore.Functions.GetPlayer(src)
--     if Player and Player.Functions.RemoveItem(item.name, 1, item.slot) then
--         TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], 'remove', 1)
--         if item.info.purity then
--             TriggerClientEvent('qb-drugsystem:client:UseCokeBag', src, item.info.purity)
--         else -- fallback value
--             TriggerClientEvent('qb-drugsystem:client:UseCokeBag', src, 50)
--         end
--     end
-- end)

