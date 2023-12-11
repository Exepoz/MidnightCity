FBSUtils = {}
if Config.Framework.Framework == "QBCore" then
    QBCore = nil
    QBCore = exports['qb-core']:GetCoreObject()

    -- QBCore.Functions.CreateUseableItem(Config.Items.ComputerHackItem.item, function(source, item)
    --     local Player = QBCore.Functions.GetPlayer(source)
    --     if Player.Functions.GetItemByName(Config.Items.ComputerHackItem.item) ~= nil then
    --         TriggerClientEvent('cr-fleecabankrobbery:client:FleecaBankUSBUsage', source, item)
    --     end
    -- end)

    QBCore.Functions.CreateUseableItem(Config.Items.VaultCardItem.item, function(source, item)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player.Functions.GetItemByName(Config.Items.VaultCardItem.item) ~= nil then
            TriggerClientEvent('cr-fleecabankrobbery:client:VaultCard', source, item)
        end
    end)

    QBCore.Functions.CreateUseableItem(Config.Items.DrillingItem.item, function(source, _)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player.Functions.GetItemByName(Config.Items.DrillingItem.item) ~= nil then
            TriggerClientEvent('cr-fleecabankrobbery:client:DrillBoxes', source)
        end
    end)

    QBCore.Functions.CreateCallback('cr-fleecabankrobbery:server:GetCops', function(_, cb)
        local amount = FBSUtils.GetCurrentCops()
        cb(amount)
    end)

    QBCore.Functions.CreateCallback('cr-fleecabankrobbery:server:hasItemData', function(src, cb)
        local Player = QBCore.Functions.GetPlayer(src)
        local item = Player.Functions.GetItemByName('camera_looper')
        if item and item.amount > 0 then cb(item.info.quality > 0)
        else cb(false) end
    end)

elseif Config.Framework.Framework == "ESX" then
    ESX = exports['es_extended']:getSharedObject()

    ESX.RegisterUsableItem(Config.Items.ComputerHackItem.item, function(source, item)
        if FBSUtils.HasItem(source, Config.Items.ComputerHackItem.item) then
            TriggerClientEvent('cr-fleecabankrobbery:client:FleecaBankUSBUsage', source, item)
        end
    end)

    ESX.RegisterUsableItem(Config.Items.VaultCardItem.item, function(source, item)
        if FBSUtils.HasItem(source, Config.Items.VaultCardItem.item) then
            TriggerClientEvent('cr-fleecabankrobbery:client:VaultCard', source, item)
        end
    end)

    ESX.RegisterUsableItem(Config.Items.DrillingItem.item, function(source, _)
        if FBSUtils.HasItem(source, Config.Items.DrillingItem.item) then
            TriggerClientEvent('cr-fleecabankrobbery:client:DrillBoxes', source)
        end
    end)

    ESX.RegisterServerCallback('cr-fleecabankrobbery:server:HasItem', function(source, cb, item)
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

    ESX.RegisterServerCallback('cr-fleecabankrobbery:server:GetCops', function(_, cb, _)
        local amount = FBSUtils.GetCurrentCops()
        cb(amount)
    end)
end

--~=====================~--
--~ Cops & Jobs Related ~--
--~=====================~--

function FBSUtils.GetCurrentCops()
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

--~===============~--
--~ Items Related ~--
--~===============~--

-- Has Item function
---@param source number -- Player source
---@param item string -- Item being searched for
---@return boolean
function FBSUtils.HasItem(source, item)
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
---@param dataType string -- Metadata changed
---@param amount number -- Amount to lower
function FBSUtils.LowerMetadata(source, item, dataType, amount)
    if not amount then amount = 1 end
    local itemData
    if Config.Framework.UseOxInv then
        local ox_inventory = exports.ox_inventory
        local invItem = ox_inventory:Search(source, 1, item)
        itemData = invItem[1].metadata[dataType]
        if not itemData then itemData = 1 end
        itemData = itemData + 1
        invItem[1].metadata[dataType] = itemData
        ox_inventory:SetMetadata(source, invItem[1].slot, invItem[1].metadata)
    elseif Config.Framework.Framework == "QBCore" then
        local Player = QBCore.Functions.GetPlayer(source)
        local invItem = Player.Functions.GetItemByName(item)
        if type(Player.PlayerData.items[invItem.slot].info) == "string" then Player.PlayerData.items[invItem.slot].info = {} end
        itemData = Player.PlayerData.items[invItem.slot].info[dataType]
        if not itemData then itemData = 1 else itemData = itemData + amount end
        Player.PlayerData.items[invItem.slot].info[dataType] = itemData
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
    if item == Config.Items.ComputerHackItem and itemData >= Config.Difficulties.ComputerHack.ItemUses then FBSUtils.RemoveItem(source, item, 1) end
    --if Config.Debug then print(Lcl("debug_bladequality", itemData)) end
end

--- Adding Items
---@param source number -- Player source
---@param item string -- Item being added
---@param amount number -- Amoung being added
---@param info? any -- Item metadata (if needed)
---@return boolean -- Returns if the player can carry the item
function FBSUtils.GiveItem(source, item, amount, info)
    local itemGiven = false
    if Config.Framework.UseOxInv then
        local ox_inventory = exports.ox_inventory
        if ox_inventory:CanCarryItem(source, item, amount) then ox_inventory:AddItem(source, item, amount, info) itemGiven = true end
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
function FBSUtils.RemoveItem(source, item, amount)
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

--~=======~--
--~ Utils ~--
--~=======~--

-- Logs
---@param title string - Title of the logs
---@param color string - color for the logs
---@param text string - Log content
function FBSUtils.Logs(title, color, text)
    if Config.Framework.Framework == "QBCore" then
        TriggerEvent('qb-log:server:CreateLog', 'fleecabankrobbery', title, color, text)
    end
end

--- Adding Money
---@param source number -- Player source
---@param type string -- Currency being added
---@param amount number -- Amounnt being added
function FBSUtils.AddMoney(source, type, amount)
    if Config.Framework.Framework == "QBCore" then
        local Player = QBCore.Functions.GetPlayer(source)
        Player.Functions.AddMoney(type, amount)
    elseif Config.Framework.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        if type == "cash" then xPlayer.addMoney(amount)
        else xPlayer.addAccountMoney(type, amount) end
    end
end

-- Server-sided Notification Matrix
---@param notifType number - Type of Notification Shown (1 = Success, 2 = Info, 3 = Failure)
---@param message string - Message Sent
---@param title string - Message Title (If Applicable)
---@param serversource? number -- Sent if source is needed.
function FBSUtils.Notify(notifType, message, title, serversource)
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
        TriggerClientEvent('cr-fleecabankrobbery:client:Notify', src, nType, message, title)
    elseif Config.Framework.Notifications == "ESX" then
        TriggerClientEvent('esx:showNotification', src, message, nType)
--luacheck: push ignore
	elseif Config.Framework.Notifications == 'other' then
		--You can add any notification system here.
	end
--luacheck: pop
end

RegisterNetEvent('cr-fleecabankrobbery:server:TriggerOxLocks', function(name, state)
    local door = exports['ox_doorlock']:getDoorFromName(name)
    TriggerEvent('ox_doorlock:setState', door.id, state)
end)