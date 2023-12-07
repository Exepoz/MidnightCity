BSUtils = {}
if Config.Framework.Framework == "QBCore" then
    QBCore = exports['qb-core']:GetCoreObject()

    for k, _ in pairs(Config.Burnerphones) do
        QBCore.Functions.CreateUseableItem(k, function(source, _)
            if BSUtils.HasItem(source, k) then
                TriggerClientEvent('cr-burnerphones:client:BurnerPhoneUse', source, k)
            end
        end)
    end

    QBCore.Functions.CreateCallback('cr-burnerphones:server:GetCops', function(_, cb)
        local amount = BSUtils.GetCurrentCops()
        cb(amount)
    end)

elseif Config.Framework.Framework == "ESX" then
    ESX = exports['es_extended']:getSharedObject()

    for k, _ in pairs(Config.Burnerphones) do
        ESX.RegisterUsableItem(k, function(source, _)
            if BSUtils.HasItem(source, k) then
                TriggerClientEvent('cr-burnerphones:client:BurnerPhoneUse', source, k)
            end
        end)
    end

    ESX.RegisterServerCallback('cr-burnerphones:server:HasItem', function(source, cb, item)
        if Config.Framework.UseOxInv then
            local ox_inventory = exports.ox_inventory
            local Item = ox_inventory:Search(source, 1, item)
            if Item then cb(true) end
        else
            local xPlayer = ESX.GetPlayerFromId(source)
            local itemAmount = xPlayer.getInventoryItem(item).count
            if itemAmount >= 1 then cb(true) else cb(false) end
        end
    end)

    ESX.RegisterServerCallback('cr-burnerphones:server:GetCops', function(_, cb, _)
        local amount = BSUtils.GetCurrentCops()
        cb(amount)
    end)
end

function BSUtils.GetCurrentCops()
    local amount = 0
    if Config.Framework.Framework == "QBCore" then
        for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
            for _, jobs in pairs(Config.Police.PoliceJobs) do
                if v.PlayerData.job.name == jobs and v.PlayerData.job.onduty then
                    amount = amount + 1
                end
            end
        end
    elseif Config.Framework.Framework == "ESX" then
        for _, xPlayer in pairs(ESX.GetExtendedPlayers()) do
            for _, jobs in pairs(Config.Police.PoliceJobs) do
                if xPlayer.job.name == jobs and xPlayer.job.onduty then
                    amount = amount + 1
                end
            end
        end
    end
    return amount
end

-- Logs
---@param title string - Title of the logs
---@param color string - color for the logs
---@param text string - Log content
function BSUtils.Logs(title, color, text)
    if Config.Framework.Framework == "QBCore" then
        TriggerEvent('qb-log:server:CreateLog', 'burnerphones', title, color, text)
    end
end

-- Has Item function
---@param source number -- Player source
---@param item string -- Item being searched for
---@return boolean
function BSUtils.HasItem(source, item)
    local Item
    if Config.Framework.UseOxInv then
        local ox_inventory = exports.ox_inventory
        Item = ox_inventory:Search(source, 1, item)
    elseif Config.Framework.Framework == "QBCore" then
        local Player = QBCore.Functions.GetPlayer(source)
        Item = Player.Functions.GetItemByName(item)
    elseif Config.Framework.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        local itemAmount = xPlayer.getInventoryItem(item).count
        if itemAmount >= 1 then Item = true end
    end
    if Item then return true else return false end
end

---Lowering Specific Metadata values
---@param source number -- Player source
---@param item string -- Item given
function BSUtils.PhoneBattery(source, item)
    local ItemInfo
    local Phone = Config.Burnerphones[item]
    if Config.Framework.UseOxInv then
        local ox_inventory = exports.ox_inventory
        local invItem = ox_inventory:Search(source, 1, item)
        ItemInfo = invItem[1].metadata
        if not ItemInfo then
            if Config.Debug then print(Lcl('debug_SettingUpUses')) end
            ItemInfo.uses, ItemInfo.maxuses = 0, math.random(Phone.Uses.min, Phone.Uses.max)
            invItem[1].metadata['maxuses'] = ItemInfo.maxuses
        end
        ItemInfo.uses = ItemInfo.uses + 1
        invItem[1].metadata['uses'] = ItemInfo.uses
        ox_inventory:SetMetadata(source, invItem[1].slot, invItem[1].metadata)
    elseif Config.Framework.Framework == "QBCore" then
        local Player = QBCore.Functions.GetPlayer(source)
        local invItem = Player.Functions.GetItemByName(item)
        if type(Player.PlayerData.items[invItem.slot].info) == "string" then Player.PlayerData.items[invItem.slot].info = {} end
        ItemInfo =  Player.PlayerData.items[invItem.slot].info
        if not ItemInfo.maxuses then
            if Config.Debug then print(Lcl('debug_SettingUpUses')) end
            ItemInfo.uses, ItemInfo.maxuses = 0, math.random(Phone.Uses.min, Phone.Uses.max)
        end
        ItemInfo.uses = ItemInfo.uses + 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
    if Config.Debug then print(Lcl('debug_uses', ItemInfo.uses, ItemInfo.maxuses)) end
    if ItemInfo.uses >= ItemInfo.maxuses then
        TriggerEvent('cr-burnerphones:server:BatteryOut', item, source)
    end
end

--- Adding Items
---@param source number -- Player source
---@param item string -- Item being added
---@param amount number -- Amoung being added
---@param info? any -- Item metadata (if needed)
---@return boolean -- Returns if the player can carry the item
function BSUtils.GiveItem(source, item, amount, info)
    local itemGiven = false
    if Config.Framework.UseOxInv then
        local ox_inventory = exports.ox_inventory
        if ox_inventory:CanCarryItem(source, item, amount) then print(4) ox_inventory:AddItem(source, item, amount) itemGiven = true end
    elseif Config.Framework.Framework == "QBCore" then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player.Functions.AddItem(item, amount, false, info) then TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "add", amount) itemGiven = true end
    elseif Config.Framework.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.canCarryItem(item, amount) then xPlayer.addInventoryItem(item, amount) itemGiven = true end
    end
    return itemGiven
end

-- Removing Items
---@param source number -- Player source
---@param item any -- Item being removed
---@param amount? any -- Amount being removed
function BSUtils.RemoveItem(source, item, amount)
    if not amount then amount = 1 end
    if Config.Framework.UseOxInv == "OxInv" then
        local ox_inventory = exports.ox_inventory
        ox_inventory:RemoveItem(source, item, amount)
    elseif Config.Framework.Framework == "QBCore" then
        local Player = QBCore.Functions.GetPlayer(source)
        Player.Functions.RemoveItem(item, amount)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "remove", amount)
    elseif Config.Framework.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(item, amount)
    end
end

-- Server-sided Notification Matrix
---@param notifType number - Type of Notification Shown (1 = Success, 2 = Info, 3 = Failure)
---@param message string - Message Sent
---@param title string - Message Title (If Applicable)
---@param serversource? number -- Sent if source is needed.
function BSUtils.Notify(notifType, message, title, serversource)
    local src = source
    if serversource then src = serversource end

    local notif = Config.Framework.Notifications
    local nType
    if notifType == 1 then
        nType = "success"
    elseif notifType == 2 then
        if notif == "qb" or notif == "tnj" or notif == "oxlib" then
            nType = "primary"
        elseif notif == "okok" or notif == "ESX" then
            nType = "info"
        elseif notif == "mythic" then
            nType = "inform"
        end
    elseif notifType == 3 then
        nType = "error"
    end
	if Config.Framework.Notifications == 'qb' or Config.Framework.Notifications == 'tnj' then
        TriggerClientEvent('QBCore:Notify', src, message, nType)
	elseif Config.Framework.Notifications == "okok" then
        TriggerClientEvent('okokNotify:Alert', src, title, message, 5000, nType)
	elseif Config.Framework.Notifications == "mythic" then
        TriggerClientEvent('mythic_notify:client:SendAlert:custom', src, { type = nType, text = message, length = 5000})
	elseif Config.Framework.Notifications == 'chat' then
		TriggerClientEvent('chatMessage', src, message)
    elseif Config.Framework.Notifications == "oxlib" then
        TriggerClientEvent('cr-burnerphones:client:Notify', src, nType, message, title)
    elseif Config.Framework.Notifications == "ESX" then
        TriggerClientEvent('esx:showNotification', src, message, nType)
--luacheck: push ignore
	elseif Config.Framework.Notifications == 'other' then
		--You can add any notification system here.
	end
--luacheck: pop
end