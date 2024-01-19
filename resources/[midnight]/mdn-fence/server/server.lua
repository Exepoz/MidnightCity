local QBCore = exports['qb-core']:GetCoreObject()
local Midnight = exports['mdn-nighttime']:GetMidnightCore()
local transactionInProgress = false
local gState = {}
local Stock = {}
local CurrentQuests = {}
CompletedBounties = {}
GlobalState.CompletedBounties = CompletedBounties
local fenceData


-- bounty items
-- if item stock is less than x% of the shop stock, then it becomes "hot"
-- items can also be manually added as hot via the config.
-- a hot item sells for 1.5x*** the normal price
-- The price given is the price showned, no deviation during the transation.
-- Updates every 15 minutes, can only be redeemed once per player per cycle, & a max amount (If item stays, item is locked until next tsu or new item).

local updatePrice = function(i, stock)
    if not stock then stock = i.stock end
    if not stock then return i.price end
    local steps = math.floor(stock / i.devStep)
    local deviation = i.devAmount * steps
    local price = i.price - (i.price * deviation)
    if price < 0 then price = 1 end
    return price
end

-- Events
RegisterNetEvent('mdn-fence:server:sellToFence', function(data)
    local src = source
    local item, slot, am = data[1], data[2], data[3]
    if not item or not slot then return end
    local Player = QBCore.Functions.GetPlayer(src)
    local slotItem = Player.Functions.GetItemBySlot(slot)
    if not slotItem or slotItem.name ~= item or slotItem.amount ~= am then return print("Tried exploiting?") end
    while transactionInProgress do Wait(0) end
    transactionInProgress = true
    local moneyRec = 0
    for i = 1, am do
        Config.FenceItems[item].currentPrice = updatePrice(Config.FenceItems[item])
        Player.Functions.RemoveItem(item, 1, slot)
        moneyRec = moneyRec + Config.FenceItems[item].currentPrice
        Config.FenceItems[item].stock = Config.FenceItems[item].stock + 1
    end
    moneyRec = math.floor(moneyRec)
    TriggerClientEvent('inventory:client:ItemBox',src, QBCore.Shared.Items[item], "remove", am)
    Player.Functions.AddItem('midnight_crumbs', moneyRec)
    TriggerClientEvent('inventory:client:ItemBox',src, QBCore.Shared.Items['midnight_crumbs'], "add", moneyRec)
    local a = MySQL.update.await('UPDATE midnight_fence SET stock = ? WHERE item = ?', {Config.FenceItems[item].stock, item})
    if a == 0 then MySQL.insert.await('INSERT INTO `midnight_fence` (stock, item) VALUES (?, ?)', {Config.FenceItems[item].stock, item}) end

    local pName = Midnight.Functions.GetCharName(src)
    local txt = "Sold stuff to fence : "..item.." | x"..am.."\nCrumbs Received : "..moneyRec
    local logString = {ply = GetPlayerName(src), txt = "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n"..txt}
    TriggerEvent("qb-log:server:CreateLog", "fence", "Item Sold", "green", logString)

    transactionInProgress = false
    Wait(50) TriggerClientEvent('fence:client:backToSelling', src)
end)

RegisterNetEvent('mdn-fence:server:buyItem', function(itemTable, item, am, k, subt, shop)
    QBCore.Debug(itemTable)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local crumbs = Player.Functions.GetItemByName('midnight_crumbs')
    local price = (itemTable.items[k].price * am)
    if not crumbs then TriggerClientEvent('QBCore:Notify', src, "You don't have any crumbs on you.. How do you think we do business here?", "error") return end
    if gState.Stock[item].stock < am then TriggerClientEvent('QBCore:Notify', src, "We don't have enough of that in stock right now.", "error") return end
    if not Player.Functions.RemoveItem('midnight_crumbs', price) then TriggerClientEvent('QBCore:Notify', src, "You don't have enough gold crumbs...", "error") return end
    --if crumbs.amount < (itemTable.items[k].price * am) then TriggerClientEvent('QBCore:Notify', src, "You don't have enough gold crumbs...", "error") return end

    local info = {ordereditem = item, qty = am, itemName = QBCore.Shared.Items[item].label, itemImage = QBCore.Shared.Items[item].image, subtype = subt, scratched = itemTable.items[k].scratched or false}
    QBCore.Debug(info)
    if Player.Functions.AddItem("fencepackage", 1, false, info) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['midnight_crumbs'], "remove", price)
        Citizen.Wait(500)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['fencepackage'], "add", 1)
        gState.Stock[item].stock = gState.Stock[item].stock - am
        GlobalState.FenceShop = gState

        local pName = Midnight.Functions.GetCharName(src)
        local logString = {ply = GetPlayerName(src), txt = "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\nBought stuff from fence : "..item.." | x"..info.qty..(itemTable.items[k].scratched and "\nScratched Weapon" or "")}
        TriggerEvent("qb-log:server:CreateLog", "fence", "Item Bought", "green", logString)

    else Player.Functions.AddItem("midnight_crumbs", price) end
end)

RegisterNetEvent('mdn-fence:server:HandInBounty', function(key, amount)
	local src = source
	local bounty = CurrentQuests[key]
	local Player = QBCore.Functions.GetPlayer(src)
	local item = Player.Functions.GetItemByName(bounty.item)
	local items = Player.Functions.GetItemsByName(bounty.item)

	local cid = Player.PlayerData.citizenid
    if GlobalState.CompletedBounties[cid] and GlobalState.CompletedBounties[cid][bounty.item] then return TriggerClientEvent('QBCore:Notify', src, 'We already made this deal!', 'error') end

	local totAmount = 0

	if items then for _, v in pairs(items) do
		totAmount = totAmount + v.amount
        if totAmount >= 5 then totAmount = 5 break end
	end end
	if not item or totAmount == 0 then return TriggerClientEvent('QBCore:Notify', src, 'You do not have this item...', 'error') end

    local removed = 0
	for _ = 1, totAmount do  if Player.Functions.RemoveItem(bounty.item, 1) then removed = removed + 1 end end
    if removed < 0 then return TriggerClientEvent('QBCore:Notify', src, 'Something went wrong...', 'error') end
    local reward = Config.Quests[bounty.item]?.price or math.floor(Config.FenceItems[bounty.item].price * removed * 1.5)
    if Player.Functions.AddItem('midnight_crumbs', reward) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[bounty.item], "remove", totAmount)
        Wait(500)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['midnight_crumbs'], "add", reward)
        if Config.FenceItems[bounty.item] then
            Config.FenceItems[bounty.item].stock = Config.FenceItems[bounty.item].stock + removed
            Config.FenceItems[bounty.item].currentPrice = updatePrice(Config.FenceItems[bounty.item])

            local a = MySQL.update.await('UPDATE midnight_fence SET stock = ? WHERE item = ?', {Config.FenceItems[bounty.item].stock, bounty.item})
            if a == 0 then MySQL.insert.await('INSERT INTO `midnight_fence` (stock, item) VALUES (?, ?)', {Config.FenceItems[bounty.item].stock, bounty.item}) end
        end

    else Player.Functions.AddItem(bounty.item, removed)  end

        -- Rep Acquisition?
	-- local repAmount = 1
	-- if bounty.item == 'lootbag' or bounty.item == 'malmo_laptop' then repAmount = 3 end
	-- if bounty.item == 'tv' then repAmount = 2 end
	-- if Config.Rep[currentLvl].double and math.random(100) <= 50 then
	-- 	TriggerClientEvent('QBCore:Notify', src, 'You got double the rewards for this bounty!', 'success')
	-- 	repAmount = repAmount * 2
	-- end
    if not CompletedBounties[cid] then CompletedBounties[cid] = {} end
	CompletedBounties[cid][bounty.item] = true
	GlobalState.CompletedBounties = CompletedBounties


        -- Daily Completion Reward???
	-- local dBountyStr = ""
	-- if Quests[1][cid] and Quests[2][cid] and Quests[3][cid] then
	-- 	dBountyStr = " \n\n**Daily Bounties Completed!**\n**Reward :** "
	-- 	local rStr = ""
	-- 	TriggerClientEvent('QBCore:Notify', src, 'You gain an extra reputation for completing all bounties!', 'success')
	-- 	repAmount = repAmount + 1
	-- 	if Rewards.t == 'item' then
	-- 		Player.Functions.AddItem(Rewards.r, 1)
	-- 		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Rewards.r], "add")
	-- 		rStr = QBCore.Shared.Items[Rewards.r].label
	-- 	elseif Rewards.t == 'cash' then
	-- 		Player.Functions.AddMoney('cash', Rewards.r)
	-- 		rStr = "$"..Rewards.r
	-- 	elseif Rewards.t == 'xp' then
	-- 		repAmount = repAmount + Rewards.r
	-- 		rStr = Rewards.r.." Extra Reputation"
	-- 	end
	-- 	dBountyStr = dBountyStr..rStr
	-- 	Wait(1000)
	-- 	TriggerClientEvent('QBCore:Notify', src, 'Thank you, here\'s for the trouble. I will have an other list tomorrow.', 'success')
	-- end
	-- Player.Functions.SetMetaData('house_robbery_rep', Player.PlayerData.metadata.house_robbery_rep+repAmount)
	-- Wait(3000)
	-- TriggerClientEvent('QBCore:Notify', src, 'You gained a total of '..repAmount..' rep!', 'success')

        -- Logs
	local charinfo = Player.PlayerData.charinfo
    local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
    local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
    local pName = firstName.." "..lastName
	local logString = "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\n"..Player.PlayerData.citizenid.."\n\nBounty : "..QBCore.Shared.Items[bounty.item].label.."\nAmount : "..removed --..dBountyStr.." \nRep Gained : "..repAmount.."\nTotal Rep : "..Player.PlayerData.metadata.house_robbery_rep+repAmount
	TriggerEvent("qb-log:server:CreateLog", "fenceBounties", "Bounty Handed In!", "green", {ply = GetPlayerName(src), txt = logString})
end)

-- Callbacks
QBCore.Functions.CreateCallback('fence:fetchCurrentPrices', function(source, cb, args)
    cb(Config.FenceItems)
end)

QBCore.Functions.CreateUseableItem("fencepackage", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    local itemInfo = Player.PlayerData.items[item.slot].info
    QBCore.Debug(itemInfo)
    if itemInfo.qty > 0 then
        local oItem = itemInfo.ordereditem
        itemInfo.qty = itemInfo.qty - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
        local info = {}
        if QBCore.Shared.SplitStr(oItem, "_")[1] == "weapon" then
            info.serie = itemInfo.scratched and "||/|////|||/||" or tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
            info.quality = 100
            -- info.fromAmmu = true
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
        TriggerClientEvent('QBCore:Notify', source, "The package is empty", "error")
    end
end)

-- Resource Start/Stop
AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
    for _, v in pairs(Config.Shop) do
        for _, b in pairs(v.items) do Stock[b.item] = {stock = b.stock, price = b.price, maxStock = b.stock, loc = b.loc, max = b.max, subt = b.subt or nil, b.scratched or false} end
    end
    gState.Stock = Stock
    GlobalState.FenceShop = gState
    CreateThread(function()
        while true do
            for _, v in pairs(Stock) do if v.stock < v.maxStock then v.stock = v.stock + 1 end end
            gState.Stock = Stock
            GlobalState.FenceShop = gState
            --Wait(Config.OnlineOrders.RestockTime * 60000)
            Wait(1* 60000)
        end
    end)

    fenceData = MySQL.query.await('SELECT * FROM `midnight_fence`')
    if fenceData and fenceData[1] ~= nil then
        for k, v in pairs(fenceData) do
            local i = Config.FenceItems[v.item]
            if i then
                Config.FenceItems[v.item].stock = v.stock
                Config.FenceItems[v.item].currentPrice = updatePrice(i, v.stock)
            end
        end
    end

    local function UpdateBounties()
        print("Updating Fence Bounties...")
        local totalStock = 0
        local stockSplit = {}
        local usedKeys = {}
        CurrentQuests = {}
        for _, v in pairs(Config.FenceItems) do totalStock = totalStock + v.stock end
        for k, v in pairs(Config.FenceItems) do
            stockSplit = v.stock / totalStock
            if stockSplit < 0.05 then
                usedKeys[k] = true
                CurrentQuests[#CurrentQuests+1] = {item = k}
            end
        end
        for k, v in pairs(Config.Quests) do
            if not usedKeys[k] then CurrentQuests[#CurrentQuests+1] = {item = k} end
        end
        GlobalState.FenceBounties = CurrentQuests
    end
    UpdateBounties()

    --Updating Bounties every 15 minutes
    lib.cron.new('*/15 * * * *', UpdateBounties)
end)

-- lib.cron.new('* */3 * * *', function() -- Happens every 3 hours
lib.cron.new('15 23 */3 * *', function() -- Happens every 3 hours
    print('Updating Current Fence Stock...')
    fenceData = MySQL.query.await('SELECT * FROM `midnight_fence`')
    if fenceData and fenceData[1] ~= nil then
        for _, v in pairs(fenceData) do
            local i = Config.FenceItems[v.item]
            if i then
                local newStock = (v.stock - i.removed > 0) and v.stock - i.removed or 0
                Config.FenceItems[v.item].stock = newStock
                Config.FenceItems[v.item].currentPrice = updatePrice(i)
                MySQL.update.await('UPDATE midnight_fence SET stock = ? WHERE item = ?', {newStock, v.item})
            end
        end
    end
    --QBCore.Debug(Config.FenceItems)
    --print('Current Fence Stock Updated!')
end)
