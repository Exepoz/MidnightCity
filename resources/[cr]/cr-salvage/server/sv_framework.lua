SSUtils = {}
if Config.Framework.Framework == "QBCore" then
    QBCore = nil
    QBCore = exports['qb-core']:GetCoreObject()

    QBCore.Functions.CreateUseableItem(Config.PowerSawItem , function(source, item)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player.Functions.GetItemByName(Config.PowerSawItem) ~= nil then
            TriggerClientEvent('cr-salvage:client:CheckHarvest', source, item)
        end
    end)

    QBCore.Functions.CreateUseableItem(Config.SawBladePackItem , function(source, _)
        SSUtils.LowerMetadata(source, Config.SawBladePackItem, "bpp")
        SSUtils.GiveItem(source, Config.SawBladeItem, 1)
    end)

    QBCore.Functions.CreateUseableItem(Config.SawBladeItem , function(source, _)
        if SSUtils.HasItem(source, Config.BrokenPowerSawItem) then
            SSUtils.RemoveItem(source, Config.SawBladeItem)
            TriggerClientEvent('cr-salvage:client:RepairSaw', source)
        end
    end)

elseif Config.Framework.Framework == "ESX" then
    ESX = exports['es_extended']:getSharedObject()

    ESX.RegisterUsableItem(Config.PowerSawItem, function(source, item)
        if SSUtils.HasItem(source, item) then
            TriggerClientEvent('cr-salvage:client:CheckHarvest', source, item)
        end
    end)

    ESX.RegisterUsableItem(Config.SawBladePackItem, function(source, item)
        if SSUtils.HasItem(source, item) then
            SSUtils.LowerMetadata(source, item, "bpp")
            SSUtils.GiveItem(source, Config.SawBladeItem, 1)
        end
    end)

    ESX.RegisterUsableItem(Config.SawBladeItem, function(source, _)
        if SSUtils.HasItem(source, Config.BrokenPowerSawItem) then
            SSUtils.RemoveItem(source, Config.SawBladeItem)
            TriggerClientEvent('cr-salvage:client:RepairSaw', source)
        end
    end)

    ESX.RegisterServerCallback('cr-salvage:server:HasItem', function(source, cb, item)
        if Config.Framework.UseOxInv then
            local ox_inventory = exports.ox_inventory
            local Item = ox_inventory:Search(source, 1, item)
            if Item then cb(true) end
        else
            local xPlayer = ESX.GetPlayerFromId(source)
            local invItem = xPlayer.getInventoryItem(item)
            if invItem.count >= 1 then cb(true) else cb(false) end
        end
    end)
end

-- Logs
---@param title string - Title of the logs
---@param color string - color for the logs
---@param text string - Log content
function SSUtils.Logs(title, color, text)
    if Config.Framework.Framework == "QBCore" then
        TriggerEvent('qb-log:server:CreateLog', 'crsalvage', title, color, text)
    end
end

-- Has Item function
---@param source number -- Player source
---@param item string -- Item being searched for
---@return boolean
function SSUtils.HasItem(source, item)
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

---Database email toggling
---@param source number -- Player source
---@param toggle boolean -- Emails toggle on/off
function SSUtils.ToggleEmails(source, toggle)
    if Config.Framework.Framework == "QBCore" then
        local PlayerInfo = QBCore.Functions.GetPlayer(source)
        local cid = PlayerInfo.PlayerData.citizenid
        exports['oxmysql']:query("UPDATE players SET cr_salvage_emails = ? WHERE citizenid = ?", {Player(source).state.cr_salvage_emails, cid})
    elseif Config.Framework.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        local ident = xPlayer.getIdentifier()
        exports['oxmysql']:query("UPDATE users SET cr_salvage_emails = ? WHERE identifier = ?", {toggle, ident})
    end
end

---Checking if player has emails notif toggled or not
RegisterNetEvent('cr-salvage:server:EmailCheck', function()
    local src = source
    if Config.Framework.Framework == "QBCore" then
        local PlayerInfo = QBCore.Functions.GetPlayer(source)
        local cid = PlayerInfo.PlayerData.citizenid
        exports['oxmysql']:query("SELECT cr_salvage_emails FROM players WHERE citizenid = ?", {cid}, function(result)
            if result then
                Player(src).state:set('cr_salvage_emails', result[1].cr_salvage_emails, true)
            end
        end)
    elseif Config.Framework.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        local id = xPlayer.getIdentifier()
        exports['oxmysql']:query("SELECT cr_salvage_emails FROM users WHERE identifier = ?", {id}, function(result)
            if result then
                Player(src).state:set('cr_salvage_emails', result[1].cr_salvage_emails, true)
            end
        end)
    end
end)

---Lowering Specific Metadata values
---@param source number -- Player source
---@param item string -- Item given
---@param dataType string -- Metadata changed
function SSUtils.LowerMetadata(source, item, dataType)
    local itemData
    if Config.Framework.UseOxInv then
        local ox_inventory = exports.ox_inventory
        local invItem = ox_inventory:Search(source, 1, item)
        itemData = invItem[1].metadata[dataType]
        if not itemData then
            if dataType == 'bladequal' then itemData = Config.PowerSaw.Durability
            elseif dataType == 'bpp' then itemData = Config.PowerSaw.BladesPerPack
        end end
        itemData = itemData - 1
        invItem[1].metadata[dataType] = itemData
        ox_inventory:SetMetadata(source, invItem[1].slot, invItem[1].metadata)
    elseif Config.Framework.Framework == "QBCore" then
        local Player = QBCore.Functions.GetPlayer(source)
        local invItem = Player.Functions.GetItemByName(item)
        if type(Player.PlayerData.items[invItem.slot].info) == "string" then Player.PlayerData.items[invItem.slot].info = {} end
        itemData = Player.PlayerData.items[invItem.slot].info[dataType]
        if not itemData then
            if dataType == 'bladequal' then itemData = Config.PowerSaw.Durability
            elseif dataType == 'bpp' then itemData = Config.PowerSaw.BladesPerPack end
        end
        itemData = itemData - 1
        Player.PlayerData.items[invItem.slot].info[dataType] = itemData
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
    if itemData == 0 then
        if dataType == "bladequal" then
            TriggerEvent('cr-salvage:server:BreakSaw', source, source)
            TriggerClientEvent('cr-salvage:client:StopSalvage', source)
        elseif dataType == "bpp" then SSUtils.RemoveItem(source, item) end
    end
    if Config.Debug then print(Lcl("debug_bladequality", itemData)) end
end

--- Adding Money
---@param source number -- Player source
---@param type string -- Currency being added
---@param amount number -- Amounnt being added
function SSUtils.AddMoney(source, type, amount)
    if Config.Framework.Framework == "QBCore" then
        local Player = QBCore.Functions.GetPlayer(source)
        Player.Functions.AddMoney(type, amount)
    elseif Config.Framework.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        if type == "cash" then xPlayer.addMoney(amount)
        else xPlayer.addAccountMoney(type, amount) end
    end
end

--- Removing Money
---@param source number -- Player source
---@param type string -- Currency being added
---@param amount number -- Amounnt being added
---@return boolean -- returns if the player has enough money
function SSUtils.TakeMoney(source, type, amount)
    local Taken = false
    if Config.Framework.Framework == "QBCore" then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player.Functions.GetMoney(type) >= (amount) then Player.Functions.RemoveMoney(type, amount) Taken = true end
    elseif Config.Framework.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        if type == "cash" then if xPlayer.getMoney() >= amount then xPlayer.removeMoney(amount) Taken = true end
        else local account = xPlayer.getAccount(type) if account.money >= (amount) then xPlayer.removeAccountMoney(type, amount) Taken = true end end
    end
    return Taken
end

--- Adding Items
---@param source number -- Player source
---@param item string -- Item being added
---@param amount number -- Amoung being added
---@param info? any -- Item metadata (if needed)
---@return boolean -- Returns if the player can carry the item
function SSUtils.GiveItem(source, item, amount, info)
    local itemGiven = false
    if Config.Framework.UseOxInv then
        local ox_inventory = exports.ox_inventory
        if ox_inventory:CanCarryItem(source, item, amount) and ox_inventory:AddItem(source, item, amount, info) then itemGiven = true end
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
function SSUtils.RemoveItem(source, item, amount)
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
function SSUtils.SalvageNotify(notifType, message, title, serversource)
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
        TriggerClientEvent('cr-salvage:client:SalvageNotify', src, nType, message, title)
    elseif Config.Framework.Notifications == "ESX" then
        TriggerClientEvent('esx:showNotification', src, message, nType)
--luacheck: push ignore
	elseif Config.Framework.Notifications == 'other' then
		--You can add any notification system here.
	end
--luacheck: pop
end