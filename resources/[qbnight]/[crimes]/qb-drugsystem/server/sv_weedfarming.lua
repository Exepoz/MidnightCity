if not Shared.Enable.Weedfarm then return end

--- Events

RegisterNetEvent('qb-drugsystem:server:FarmWeed', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local coords = GetEntityCoords(GetPlayerPed(src))
    if #(coords - Shared.WeedFarmingCoords) > 15 then return end

    local receiveAmount = math.random(Shared.WeedFarmingReceive.min, Shared.WeedFarmingReceive.max)
    if Player.Functions.AddItem(Shared.WeedFarmingBudsItem, receiveAmount, false) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Shared.WeedFarmingBudsItem], 'add', receiveAmount)
        TriggerClientEvent('QBCore:Notify', src, _U('farming_success'), 'success', 2500)
    else
        TriggerClientEvent('QBCore:Notify', src, _U('farming_pockets_full'), 'error', 2500)
    end
end)

RegisterNetEvent('qb-drugsystem:server:CreateWeedBags', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if QBCore.Functions.HasItem(src, Shared.EmptyBagItem) and QBCore.Functions.HasItem(src, Shared.WeedFarmingBudsItem, Shared.WeedFarmingBaggingAmount) then
        Player.Functions.RemoveItem(Shared.WeedFarmingBudsItem, Shared.WeedFarmingBaggingAmount, false)
        Player.Functions.RemoveItem(Shared.EmptyBagItem, 1, false)
        Player.Functions.AddItem(Shared.WeedFarmingBagsItem, 1, false)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Shared.WeedFarmingBudsItem], 'remove', Shared.WeedFarmingBaggingAmount)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Shared.EmptyBagItem], 'remove', 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Shared.WeedFarmingBagsItem], 'add', 1)
    end
end)

--- Items

QBCore.Functions.CreateUseableItem(Shared.WeedFarmingBudsItem, function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if item.amount >= Shared.WeedFarmingBaggingAmount then
        if QBCore.Functions.HasItem(src, Shared.EmptyBagItem) then
            TriggerClientEvent('qb-drugsystem:client:CreateWeedBags', src)
        else
            TriggerClientEvent('QBCore:Notify', src, _U('not_enough_baggies'), 'error', 2500)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, _U('farming_not_enough_buds'), 'error', 2500)
    end
end)
