local QBCore = exports['qb-core']:GetCoreObject()

local function ClosedShopsNotify(notifType, message, title)
    local src = source
    if Config.Notifications == 'qb' or 'tnj' then
        if notifType == 1 then
            TriggerClientEvent('QBCore:Notify', src, message, 'success')
        elseif notifType == 2 then
            TriggerClientEvent('QBCore:Notify', src, message, 'primary')
        elseif notifType == 3 then
            TriggerClientEvent('QBCore:Notify', src, message, 'error')
        end
    elseif Config.Notifications == 'okok' then
        if notifType == 1 then
            TriggerClientEvent('okokNotify:Alert', src, title, message, 5000, 'success')
        elseif notifType == 2 then
            TriggerClientEvent('okokNotify:Alert', src, title, message, 5000, 'info')
        elseif notifType == 3 then
            TriggerClientEvent('okokNotify:Alert', src, title, message, 5000, 'error')
        end
    elseif Config.Notifications == 'mythic' then
        if notifType == 1 then
            TriggerClientEvent('mythic_notify:client:SendAlert:custom', src, { type = 'success', text = message, length = 5000})
        elseif notifType == 2 then
            TriggerClientEvent('mythic_notify:client:SendAlert:custom', src, { type = 'inform', text = message, length = 5000})
        elseif notifType == 3 then
            TriggerClientEvent('mythic_notify:client:SendAlert:custom', src, { type = 'error', text = message, length = 5000})
        end
    elseif Config.Notifications == 'chat' then
        TriggerClientEvent('chatMessage', src, message)
    end
end

RegisterNetEvent('cr-closedshops:server:buyItem', function(shop, item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local ShopItems = Config.ClosedShops[shop].Shop.items
    local info = {}
    if Player.Functions.GetMoney('cash') < (ShopItems[item].price * amount) then ClosedShopsNotify(3, "Not enough money!", Config.ClosedShops[shop].Shop.label) return end
    Player.Functions.AddItem(ShopItems[item].name, amount, false, info)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[ShopItems[item].name], 'add', amount)
    Player.Functions.RemoveMoney('cash', (ShopItems[item].price * amount))
    if Config.ClosedShops[shop].Shop.BankAccount then exports['qb-management']:AddMoney(Config.ClosedShops[shop].Shop.BankAccount, ShopItems[item].price * amount) end
    if Config.Logs == true then
        TriggerEvent('qb-log:server:CreateLog', 'constantdevelopmentclosedshops', 'Item Bought', 'green', "**Player : **"..GetPlayerName(src).. "\n**Bought : **"..QBCore.Shared.Items[ShopItems[item].name].label.."\n**Amount :** "..amount)
    end
end)

QBCore.Functions.CreateCallback('cr-closedshops:server:GetCops', function(_, cb, jobs)
    local amount = 0
    for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
        for _, job in pairs(jobs) do
            if v.PlayerData.job.name == job and v.PlayerData.job.onduty then
                amount = amount + 1
            end
        end
    end
    cb(amount)
end)
