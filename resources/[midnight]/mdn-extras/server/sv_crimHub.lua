local QBCore = exports['qb-core']:GetCoreObject()
local Midnight = exports['mdn-nighttime']:GetMidnightCore()

local fetchExchangeRate = function()
    return Config.CrimHub.BHExchangeRate
end exports('fetchExchangeRate', fetchExchangeRate)

local getCurrency = function(source, currency)
    local Player = QBCore.Functions.GetPlayer(source)
    if currency == 'crumbs' then
        local crumbs = Player.Functions.GetItemByName('midnight_crumbs')
        if not crumbs then return 0 else return crumbs.amount end
    elseif currency == 'cash' then
        return Player.Functions.GetMoney('cash')
    else
        local result = MySQL.query.await('SELECT crypto FROM ra_boosting_user_settings WHERE player_identifier = ?', {Player.PlayerData.citizenid})
        if not result or not result[1] then return 0 else return result end
    end
end

local convertCurrency = function(buyA, sellA, amountSelected)
    return math.floor(sellA / buyA * amountSelected)
end

local removeCurrency = function(source, currency, amount, currencyAmount)
    local Player = QBCore.Functions.GetPlayer(source)
    if currency == 'cash' then
        return Player.Functions.RemoveMoney('cash', amount, 'Currency Exchange')
    elseif currency == 'crumbs' then
        if Player.Functions.RemoveItem('midnight_crumbs', amount) then
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['midnight_crumbs'], "remove", amount)
        return true else return false end
    else
        if currencyAmount - amount >= 0 then
            return MySQL.update.await('UPDATE ra_boosting_user_settings SET crypto = ? WHERE player_identifier = ?', {currencyAmount - amount, Player.PlayerData.citizenid})
        else return false end
    end
end

local addCurrency = function(source, currency, amount)
    local Player = QBCore.Functions.GetPlayer(source)
    if currency == 'cash' then
        return Player.Functions.AddMoney('cash', amount, 'Currency Exchange')
    elseif currency == 'crumbs' then
        if Player.Functions.AddItem('midnight_crumbs', amount) then
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['midnight_crumbs'], "add", amount)
        return true else return false end
    else
        local result = MySQL.update.await('UPDATE ra_boosting_user_settings SET crypto = crypto + '..amount..' WHERE player_identifier = ?', {Player.PlayerData.citizenid})
        if result == 0 then TriggerClientEvent('QBCore:Notify', source, "sCoins account not found!", 'error') return false else return true end
    end
end

QBCore.Functions.CreateCallback('crimHub:server:fetchBagsCount', function(source, cb, currency)
    local Player = QBCore.Functions.GetPlayer(source)
    local marked = Player.Functions.GetItemsByName("markedbills")
    local worth = 0
    for _,v in pairs(marked) do
        worth = worth + Player.PlayerData.items[v.slot].info.worth
        --Player.Functions.RemoveItem('markedbills', 1, v.slot)
    end
    cb(math.floor(worth * 0.4))
end)

RegisterNetEvent('crimHub:server:exchangeMoneyBags', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local marked = Player.Functions.GetItemsByName("markedbills")
    local worth, remAmount = 0, 0
    for _,v in pairs(marked) do
        worth = worth + Player.PlayerData.items[v.slot].info.worth
        Player.Functions.RemoveItem('markedbills', 1, v.slot)
    end
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['midnight_crumbs'], "add", amount)
end)

QBCore.Functions.CreateCallback('crimHub:server:getCurrency', function(source, cb, currency)
    cb(getCurrency(source, currency))
end)

RegisterNetEvent('crimHub:server:exchangeCurrency', function(buy, sell, selectedAmount)
    local src = source
    local finalAmount = convertCurrency(Config.CrimHub.CurrencyExchange[buy].rec, Config.CrimHub.CurrencyExchange[buy][sell], selectedAmount)
    local currencyAmount = getCurrency(src, sell)
    if currencyAmount < selectedAmount then
        TriggerClientEvent('QBCore:Notify', src, "You don't have enough to buy!", 'error')
    return end
    if removeCurrency(src, sell, selectedAmount, currencyAmount) then
        if addCurrency(src, buy, finalAmount) then
            TriggerClientEvent('QBCore:Notify', src, "Transaction Completed with success!", 'success')
            local Player = QBCore.Functions.GetPlayer(src)
            local pName = Midnight.Functions.GetCharName(src)
            local txt = 'Has bought '..finalAmount.." "..buy..' with '..selectedAmount.." "..sell
            local logString = {ply = GetPlayerName(src), txt = "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\n"..txt}
            TriggerEvent("qb-log:server:CreateLog", "currencyExchange", "Exchanged Currencies", "green", logString)
        else TriggerClientEvent('QBCore:Notify', src, "Transaction Error", 'error') addCurrency(src, sell, selectedAmount) end
    end
end)

RegisterNetEvent('bpGuy:server:getItem', function(item, cost, blueprint)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if cost.items then
        for _, v in pairs(cost.items) do
            local itemD = Player.Functions.GetItemByName(v[1])
            if not itemD or itemD.amount < v[2] then
                TriggerClientEvent('QBCore:Notify', src, "You don't have what I'm asking for!", 'error')
            return end
        end
        for _, v in pairs(cost.items) do
            if not Player.Functions.RemoveItem(v[1], v[2]) then
                TriggerClientEvent('QBCore:Notify', src, "You don't have what I'm asking for!", 'error')
            return end
        end
    end
    if not Player.Functions.RemoveItem('midnight_crumbs', cost.crumbs) then
        if cost.items then for _, v in pairs(cost.items) do Player.Functions.AddItem(v[1], v[2]) end end
        TriggerClientEvent('QBCore:Notify', src, "You don't have enough crumbs!", 'error')
    return end

    if blueprint then
            if not exports['cw-crafting']:giveBlueprintItem(src, item) then
                TriggerClientEvent('QBCore:Notify', src, "You can't carry the blueprint!", 'error')
            if cost.items then for _, v in pairs(cost.items) do Player.Functions.AddItem(v[1], v[2]) end end
            Player.Functions.AddItem('midnight_crumbs', cost.crumbs)
        return end
    else
        if not Player.Functions.AddItem(item) then
            TriggerClientEvent('QBCore:Notify', src, "You can't carry the blueprint!", 'error')
            if cost.items then for _, v in pairs(cost.items) do Player.Functions.AddItem(v[1], v[2]) end end
            Player.Functions.AddItem('midnight_crumbs', cost.crumbs)
        return end
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", 1)
    end
    if cost.item then TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[cost.item[1]], "remove", cost.item[2]) end
    if cost.items then for _, v in pairs(cost.items) do TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[v[1]], "remove", v[2]) end end
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['midnight_crumbs'], "remove", cost.crumbs)
end)