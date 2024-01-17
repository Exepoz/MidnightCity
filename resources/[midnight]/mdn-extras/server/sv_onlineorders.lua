local QBCore = exports['qb-core']:GetCoreObject()
local gState = {}
local Stock = {}
local Jobs = {}
GlobalState.OnlineOrders = {}

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for k, _ in pairs(Config.OnlineOrders.jobs) do
        Jobs[k] = {cart = {}, total = 0}
    end
    for _, v in pairs(Config.OnlineOrders.Shops) do
        for _, b in pairs(v.items) do Stock[b.item] = {stock = b.stock, price = b.price, maxStock = b.stock, loc = b.loc, max = b.max, subt = b.subt or nil} end
    end
     gState.Jobs = Jobs gState.Stock = Stock
     GlobalState.OnlineOrders = gState
    CreateThread(function()
        while true do
            for _, v in pairs(Stock) do if v.stock < v.maxStock then v.stock = v.stock + 1 end end
            gState.Stock = Stock
            GlobalState.OnlineOrders = gState
            Wait(Config.OnlineOrders.RestockTime * 60000)
            --Wait(1* 60000)
        end
    end)
end)

RegisterNetEvent('OnlineOrders:FinishOrder', function(args)
    local job = args.job
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cJob = {}
    if Config.OnlineOrders.CustomJobs[job.name] then cJob = Config.OnlineOrders.CustomJobs[job.name] end
    local account = cJob.bankAccount or job.name
    local aMoney = (cJob.isGang and exports['qb-management']:GetGangAccount(account)) or exports['qb-management']:GetAccount(account)
    if Jobs[job.name].total > aMoney then
        TriggerClientEvent('QBCore:Notify', src, "The Society Account doesn't have enough money!", "error")
        TriggerClientEvent('OnlineOrders:OpenCart', src, job) return
    end
    local info = {job = job.name, items = Jobs[job.name].cart}
    if Player.Functions.AddItem("orderconfirmation", 1, false, info) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['orderconfirmation'], "add", 1)
        TriggerClientEvent('QBCore:Notify', src, "Transaction Successful!", "success")
        if cJob.isGang then exports['qb-management']:RemoveGangMoney(account, Jobs[job.name].total)
        else exports['qb-management']:RemoveMoney(account, Jobs[job.name].total) end
        Jobs[job.name] = {cart = {}, total = 0}
        gState.Jobs = Jobs GlobalState.OnlineOrders = gState
    else TriggerClientEvent('QBCore:Notify', src, "You can't carry the order confirmation!", "error") end
end)

RegisterNetEvent('OnlineOrders:UpdateCart', function(item, amount, oldAmount, cJob)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local job = cJob.name or Player.PlayerData.job.name
    if Stock[item].stock < amount then TriggerClientEvent('QBCore:Notify', src, "The shop does not have enough in stock!", "error") return end
    if amount > Stock[item].max then TriggerClientEvent('QBCore:Notify', src, "You can only order a maxiumum of ".. Stock[item].max .." of this item!", "error") amount = Stock[item].max end
    Stock[item].stock = Stock[item].stock + oldAmount - amount
    Jobs[job].total = Jobs[job].total - (Stock[item].price * oldAmount) + (Stock[item].price * amount)
    if amount == 0 then Jobs[job].cart[item] = nil else Jobs[job].cart[item].amt = amount end
    gState.Jobs = Jobs gState.Stock = Stock GlobalState.OnlineOrders = gState
end)

RegisterNetEvent('OnlineOrders:AddToCart', function(shop, item, amount, iKey, job, subtype)
    local src = source
    local stock = Stock[item].stock
    if stock - amount < 0 then TriggerClientEvent('QBCore:Notify', src, "The shop does not have enough in stock!", "error") return end
    if Jobs[job].cart[item] and Jobs[job].cart[item].subtype ~= subtype then TriggerClientEvent('QBCore:Notify', src, "You have already selected this item, but with a different subtype. Please finish the transaction if you want to chose an other one.", "error")  return end
    Stock[item].stock = Stock[item].stock - amount
    if not Jobs[job].cart[item] then Jobs[job].cart[item] = {amt = 0, loc = Stock[item].loc, subtype = subtype} end
    if Jobs[job].cart[item].amt + amount > Stock[item].max then TriggerClientEvent('QBCore:Notify', src, "You can only order a maxiumum of ".. Stock[item].max .." of this item!", "error") amount = Stock[item].max end
    Jobs[job].cart[item].amt = Jobs[job].cart[item].amt + amount
    Jobs[job].total = Jobs[job].total + (Stock[item].price * amount)
    gState.Jobs = Jobs gState.Stock = Stock
    GlobalState.OnlineOrders = gState
end)

RegisterNetEvent('OnlineOrders:GetItems', function(loc)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local order = Player.Functions.GetItemByName('orderconfirmation')
    if not order then TriggerClientEvent('QBCore:Notify', src, "You don't have an order confirmation with you!", "error") return end
    local items = Player.PlayerData.items[order.slot].info.items
    local given = false
    for k, v in pairs(items) do
        if v.loc == loc and not v.taken then
            given = true
            local info = {ordereditem = k, qty = v.amt, itemName = QBCore.Shared.Items[k].label, itemImage = QBCore.Shared.Items[k].image, subtype = v.subtype}
            Player.PlayerData.items[order.slot].info.items[k].taken = true
            Player.Functions.AddItem("orderbox", 1, false, info)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['orderbox'], "add", 1)
            Citizen.Wait(500)
        end
    end
    Player = QBCore.Functions.GetPlayer(src)
    Player.PlayerData.items[order.slot].info.items = items
    Player.Functions.SetInventory(Player.PlayerData.items)
    TriggerClientEvent('OnlineOrders:DelBlip', src, loc)
    if not given then TriggerClientEvent('QBCore:Notify', src, "I don't have anything for you!", "error") end
end)

QBCore.Functions.CreateUseableItem('orderconfirmation', function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) then
        TriggerClientEvent('OnlineOrders:CheckOrder', src, item)
    end
end)

QBCore.Functions.CreateUseableItem("orderbox", function(source, item)
    --local openInv = Player(source).state.unboxingOpensInv
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.items[item.slot].info.qty > 0 then
        local oItem = Player.PlayerData.items[item.slot].info.ordereditem
        Player.PlayerData.items[item.slot].info.qty = Player.PlayerData.items[item.slot].info.qty - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
        local info = {}
        if QBCore.Shared.SplitStr(oItem, "_")[1] == "weapon" then
            info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
            info.quality = 100
            info.fromAmmu = true
        elseif oItem == "seedpack" then
            local getConfig = exports['malmo-weedharvest']:fetchConfig()
            info.strain = Player.PlayerData.items[item.slot].info.subtype
            info.showStrain = true
            info.strainlbl = getConfig.Seed[Player.PlayerData.items[item.slot].info.subtype].label
        end
        Player.Functions.AddItem(oItem, 1, false, info)
        TriggerClientEvent('OnlineOrders:OpenInv', source)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[oItem], "add", 1)
    else
        TriggerClientEvent('QBCore:Notify', source, "The box is empty", "error")
    end
end)

QBCore.Functions.CreateUseableItem("boxcutter", function(source, item)
    --local openInv = Player(source).state.unboxingOpensInv
    local Player = QBCore.Functions.GetPlayer(source)
    local box = Player.Functions.GetItemByName("orderbox")
    if not box then TriggerClientEvent('QBCore:Notify', source, "You don't have any boxes with you!", "error") return end
    local qty = Player.PlayerData.items[box.slot].info.qty
    if qty > 0 then
        local oItem = Player.PlayerData.items[box.slot].info.ordereditem
        local info = {}
        local giveAm = 0
        if QBCore.Shared.Items[oItem].unique then
            if oItem == 'seedpack' then
                local getConfig = exports['malmo-weedharvest']:fetchConfig()
                info.strain = Player.PlayerData.items[box.slot].info.subtype
                info.showStrain = true
                info.strainlbl = getConfig.Seed[Player.PlayerData.items[box.slot].info.subtype].label
            end
            for _ = 1, qty do
                if QBCore.Shared.SplitStr(oItem, "_")[1] == "weapon" then
                    info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
                    info.quality = 100
                    info.fromAmmu = true
                end
                if not Player.Functions.AddItem(oItem, 1, false, info) then break end
                giveAm = giveAm + 1
            end
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[oItem], "add", giveAm)
            if giveAm >= qty then
                Player.Functions.RemoveItem("orderbox", 1, box.slot)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["orderbox"], "remove", 1)
            else
                Player = QBCore.Functions.GetPlayer(source)
                Player.PlayerData.items[box.slot].info.qty = qty - giveAm
                Player.Functions.SetInventory(Player.PlayerData.items)
            end
        else
            if not Player.Functions.AddItem(oItem, qty) then TriggerClientEvent('QBCore:Notify', source, "You can't carry all of this!", "error") return end
            Player.Functions.RemoveItem("orderbox", 1, box.slot)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["orderbox"], "remove", 1)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[oItem], "add", qty)
        end
    else
        TriggerClientEvent('QBCore:Notify', source, "The box is empty!", "error")
    end
end)

for k, v in pairs(Config.Foodpacks) do
    QBCore.Functions.CreateUseableItem(v, function(source, item)
        print('used')
        QBCore.Debug(item)
        local Player = QBCore.Functions.GetPlayer(source)
        local oItem = Player.PlayerData.items[item.slot].info.packedItems
        local info = {organic = Player.PlayerData.items[item.slot].info.organic or false}
        if Player.Functions.AddItem(oItem, Player.PlayerData.items[item.slot].info.qty or 1, false, info) then
            if not Player.Functions.RemoveItem(item.name, 1) then Player.Functions.RemoveItem(oItem, Player.PlayerData.items[item.slot].info.qty) return end
            TriggerClientEvent('OnlineOrders:OpenInv', source)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[oItem], "add", Player.PlayerData.items[item.slot].info.qty)
        else
            TriggerClientEvent('QBCore:Notify', source, "You cant carry these!", "error") return
        end
    end)
end