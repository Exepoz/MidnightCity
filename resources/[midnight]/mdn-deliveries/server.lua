local cooldown = {}
local Midnight = exports['mdn-nighttime']:GetMidnightCore()

MySQL.ready(function()
    local done = MySQL.query.await([[
    CREATE TABLE IF NOT EXISTS `kloud_delivery` (
        `job` varchar(55) NOT NULL,
        `stock` int NOT NULL DEFAULT (1),
        PRIMARY KEY (`job`)
    )]])

    if done then
        for k, _ in pairs(KloudDev.Locations) do
            local result = MySQL.query.await('SELECT stock FROM kloud_delivery WHERE job = ?', { k })
            if not result[1] then
                MySQL.insert.await("INSERT INTO kloud_delivery (job) VALUES (?)", { k })
            end
        end
    end
end)

lib.callback.register("delivery:callback:get_current_stock", function(source, data)
    local result = MySQL.query.await('SELECT stock FROM kloud_delivery WHERE job = ?', { data.job })
    if not result[1] then
        MySQL.insert.await("INSERT INTO kloud_delivery (job) VALUES (?)", { data.job })
        return 0
    else
        return result[1].stock
    end
end)

lib.callback.register("delivery:callback:can_stock", function(source, data)
    local src = source
    local current_stock = MySQL.query.await('SELECT stock FROM kloud_delivery WHERE job = ?', { data.job })
    local can_stock = true

    if current_stock[1].stock >= data.max_stocks then
        can_stock = false
        SVNotify(src, locale("max_stock"), "error")
    end

    if GetItemCount(src, data.restock.item) < 1 then
        can_stock = false
        SVNotify(src, locale("no_required_item"), "error")
    end

    return can_stock
end)

lib.callback.register("delivery:callback:can_start", function(source, data, delAmount)
    local src = source

    if data.delivery.deposit.enabled then
        if data.delivery.money_type == 'crumbs' then
            local crumbs = GetPlayer(source).Functions.GetItemByName('midnight_crumbs')
            if not crumbs or crumbs.amount < (data.delivery.deposit.amount * delAmount) then
                SVNotify(src, 'You don\'t have enough crumbs!', "error")
                return false
            end
        else
            if GetMoney(src, data.delivery.money_type) < (data.delivery.deposit.amount * delAmount) then
                SVNotify(src, locale("no_money"), "error")
                return false
            end
        end
    end
    if cooldown[src] then
        SVNotify(src, locale("cooldown", cooldown[src].time), "error")
        return false
    end

    return true
end)

lib.callback.register("delivery:callback:can_deliver", function(source, data)
    local src = source

    if GetItemCount(src, data.delivery.item) < 1 then
        SVNotify(src, locale("no_delivery_item"), "error")
        return false
    end

    return true
end)

lib.callback.register("delivery:callback:add_stock", function(source, data)
    local src = source
    local current_stock = MySQL.query.await('SELECT stock FROM kloud_delivery WHERE job = ?', { data.job })
    local reward = math.random(data.restock.reward.min, data.restock.reward.max)

    if current_stock[1].stock >= data.max_stocks then
        SVNotify(src, locale("max_stock"), "error")
        return false
    end

    if RemoveItem(src, data.restock.item, 1) then
        --if data.restock.reward.enabled then AddMoney(src, data.restock.reward.type, reward, "Delivery Restock Pay") end
        exports['Renewed-Banking']:addAccountMoney(data.job, reward)
        if data.restock.reward.enabled then AddItem(src, 'payticket', 1) end

        MySQL.update("UPDATE kloud_delivery SET stock = ? WHERE job = ?", {
            current_stock[1].stock + 1,
            data.job
        })
    end

    return true
end)

RegisterNetEvent("delivery:server:start_delivery", function(data, delAmount)
    local src = source
    local current_stock = MySQL.query.await('SELECT stock FROM kloud_delivery WHERE job = ?', { data.job })

    if data.delivery.deposit.enabled then
        if data.job =='fence' then
            if not RemoveItem(src, 'midnight_crumbs', (data.delivery.deposit.amount * delAmount)) then
                SVNotify(src, locale("no_money"), "error")
                return
            end
        else
            if not RemoveMoney(src, data.delivery.money_type, (data.delivery.deposit.amount * delAmount), "Delivery Deposit") then
                SVNotify(src, locale("no_money"), "error")
                return
            end
        end
    end

    local allBags = true
    for i = 1, delAmount do
        if not AddItem(src, data.delivery.item, 1) then
            allBags = false
        end
    end

    if not allBags then
        if data.job =='fence' then
            AddItem(src, 'midnight_crumbbs', (data.delivery.deposit.amount * delAmount))
        else
            AddMoney(src, data.delivery.money_type, (data.delivery.deposit.amount * delAmount), "Error Occured")
        end
        SVNotify(src, locale("error"), "error")
        return
    end

    if data.job ~= 'fence' then
        MySQL.update("UPDATE kloud_delivery SET stock = ? WHERE job = ?", {
            current_stock[1].stock - delAmount,
            data.job
        })
    end
end)

RegisterNetEvent("delivery:server:end_delivery", function(data, delAmount, ogAMount)
    local src = source
    local reward = math.random(data.delivery.reward.min, data.delivery.reward.max)
    if ogAMount == 3 then reward = reward * 1.1 elseif ogAMount == 5 then reward = reward * 1.3 end
    if data.job ~= 'fence' and Midnight.Functions.IsNightTime() then reward = reward * NightBonus end
    local item = data.delivery.item

    if not RemoveItem(src, item, 1) then
        SVNotify(src, locale("no_delivery_item"), "error")
        return
    end

    cooldown[src] = { time = data.cooldown }
    reward = math.floor(reward)
    if data.job == 'fence' then
        AddItem(src, 'midnight_crumbs', reward)
    else
        AddMoney(src, data.delivery.money_type, reward, "Delivery Pay")
    end
end)

Cooldown = function()
    for player, _ in pairs(cooldown) do
        cooldown[player].time = cooldown[player].time - 1
        if cooldown[player].time <= 0 then
            cooldown[player] = nil
        end
    end

    SetTimeout(1000, Cooldown)
end

CreateThread(Cooldown)

-- Version Check from https://github.com/CodineDev/cdn-fuel

local updatePath
local resourceName

CheckVersion = function(err, response, headers)
    local curVersion = LoadResourceFile(GetCurrentResourceName(), "version")
	if response == nil then print("^1"..resourceName.." check for updates failed ^7") return end
    if curVersion ~= nil and response ~= nil then
		if curVersion == response then Color = "^2" else Color = "^1" end
        print("\n^1----------------------------------------------------------------------------------^7")
        print(resourceName.."'s latest version is: ^2"..response.."!\n^7Your current version: "..Color..""..curVersion.."^7!\nIf needed, update from https://github.com"..updatePath.."")
        print("^1----------------------------------------------------------------------------------^7")
    end
end

CreateThread(function()
	updatePath = "/kloudzxc/kloud-food-delivery"
	resourceName = "kloud-food-delivery ("..GetCurrentResourceName()..")"
	PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/version", CheckVersion, "GET")
end)
