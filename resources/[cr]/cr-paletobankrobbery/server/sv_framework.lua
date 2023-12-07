PBSUtils = {}
if Config.Framework.Framework == "QBCore" then
    QBCore = exports['qb-core']:GetCoreObject()

    QBCore.Functions.CreateUseableItem(Config.Items.Explosives.item , function(source)
        if PBSUtils.HasItem(source, Config.Items.Explosives.item) then
            TriggerClientEvent('cr-paletobankrobbery:client:BombMetalGate', source)
        end
    end)

    QBCore.Functions.CreateCallback('cr-paletobankrobbery:server:GetCops', function(_, cb)
        local amount = PBSUtils.GetCurrentCops()
        cb(amount)
    end)

elseif Config.Framework.Framework == "ESX" then
    ESX = nil
    PlayerData = {}
    TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

    ESX.RegisterServerCallback('cr-paletobankrobbery:server:HasItem', function(source, cb, item)
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

    ESX.RegisterServerCallback('cr-paletobankrobbery:server:GetCops', function(_, cb, _)
        local amount = PBSUtils.GetCurrentCops()
        cb(amount)
    end)
end

--~===============~--
--~ Items Related ~--
--~===============~--

--- Random Loot Generation (Based on weight/importance)
---@param items table -- Table Containing Loot Pool
---@return number -- Chosen Item's Key
function PBSUtils.GenerateLoot(items)
    local total_weight = 0
    for _, item in ipairs(items) do
        total_weight = total_weight + item.weight
    end
    local chosenLoot = math.random(total_weight)
    local chosenItem
    for k, item in ipairs(items) do
        chosenLoot = chosenLoot - item.weight
        if chosenLoot <= 0 then chosenItem = k break end
    end
    return chosenItem
end

--- Check if player has a certain item.
---@param source number -- Player's ID
---@param item string -- Item being looked for
---@return boolean -- true = Has Item | false = doesn't have the item
function PBSUtils.HasItem(source, item)
    local Item = false
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
    return Item
end

--- Gives an item to a player
---@param source number -- Player's ID
---@param item string -- Item being given
---@param amount number -- Amount being given
---@param info? table -- Item Metadata (If needed)
---@return boolean -- Returns if the player can carry the item
function PBSUtils.GiveItem(source, item, amount, info)
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

--- Removes an item from a player
---@param source number -- Player's ID
---@param item string -- Item being removed
---@param amount? number -- Amount removed
function PBSUtils.RemoveItem(source, item, amount)
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

--- Adding a Specific Metadata Use & Removing the Item when reached limit
---@param source number -- Player source
---@param item string -- Item given
---@param dataType string -- Metadata changed
---@param limit integer -- Total Uses before deletion
function PBSUtils.AddItemUse(source, item, dataType, limit)
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
        if not itemData then itemData = 1 end
        itemData = itemData + 1
        Player.PlayerData.items[invItem.slot].info[dataType] = itemData
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
    if itemData >= limit then PBSUtils.RemoveItem(source, item, 1) end
end

--~=====================~--
--~ Cops & Jobs Related ~--
--~=====================~--

-- Get Amount of Cops on Duty
---@return number -- Cop Amount
function PBSUtils.GetCurrentCops()
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

--- Adding Money
---@param source number -- Player source
---@param type string -- Currency being added
---@param amount number -- Amounnt being added
function PBSUtils.AddMoney(source, type, amount)
    if Config.Framework.Framework == "QBCore" then
        local Player = QBCore.Functions.GetPlayer(source)
        Player.Functions.AddMoney(type, amount)
    elseif Config.Framework.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        if type == "cash" then xPlayer.addMoney(amount)
        else xPlayer.addAccountMoney(type, amount) end
    end
end

--~=======~--
--~ Utils ~--
--~=======~--

-- Exploit Check Log (Distance)
---@param playerName string - Steam Name of the player who triggered the event
---@param playerID integer - Server ID of the player who triggered the event
---@param event? string - Event Triggered
---@param distance? number - Distance the player is from the position they should be triggering the event from
function PBSUtils.ExploitCheckLogs(type, playerName, playerID, event, distance)
    if type == "distance" then
        TriggerEvent('qb-log:server:CreateLog', 'paletobankrobbery', Lcl('logs_title'), 'red', Lcl('logs_TooFarExploit', playerName, playerID, event, distance))
    end
end

-- Checks if player is close to the bank when being given loot
---@param src integer - Server ID of the player who triggered the event
---@param coords table - Apporox. Coordinates of the interaction
---@param event? string - Event Triggered
---@return boolean - true = Player Might be Exploiting | false = Player is near the coords
function PBSUtils.CheckExploit(src, coords, event)
    local ped = GetPlayerPed(src)
    local pcoords = GetEntityCoords(ped)
    local dist = #(pcoords - coords)
    if dist < 15 then return false
    else
        print(Lcl('logs_TooFarExploit', GetPlayerName(src), src, event, dist))
        PBSUtils.ExploitCheckLogs("distance", GetPlayerName(src), src, event, dist)
        return true
    end
end

--- Debug Message
---@param msg string -- Debug Message
function PBSUtils.Debug(msg)
    if not Config.Debug then return end
    print("^4[^1DEBUG^4]^2 "..msg.."^0")
end

-- Logs
---@param title string - Title of the logs
---@param color string - color for the logs
---@param text string - Log content
function PBSUtils.Logs(title, color, text)
    if not Config.Logs or not Config.Framework.Framework == "QBCore" then return end
    TriggerEvent('qb-log:server:CreateLog', 'paletobankrobbery', title, color, text)
end

-- Server-sided Notification Matrix
---@param notifType number - Type of Notification Shown (1 = Success, 2 = Info, 3 = Failure)
---@param message string - Message Sent
---@param title string - Message Title (If Applicable)
---@param serversource? number -- Sent if source is needed.
function PBSUtils.Notify(notifType, message, title, serversource)
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
        TriggerClientEvent('cr-paletobankrobbery:client:Notify', src, nType, message, title)
    elseif Config.Framework.Notifications == "ESX" then
        TriggerClientEvent('esx:showNotification', src, message, nType)
--luacheck: push ignore
	elseif Config.Framework.Notifications == 'other' then
		--You can add any notification system here.
	end
--luacheck: pop
end

RegisterNetEvent('cr-paletobankrobbery:server:TriggerOxLocks', function(name, state)
    local door = exports['ox_doorlock']:getDoorFromName(name)
    TriggerEvent('ox_doorlock:setState', door.id, state)
end)