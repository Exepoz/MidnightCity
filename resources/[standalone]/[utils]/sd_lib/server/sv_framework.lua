SD = SD or {}

-- Check if the 'es_extended' resource is started
if Framework == 'esx' then
    print('^2es_extended Recognized.^7')
    
    -- Get the shared object from the 'es_extended' resource
    ESX = exports[Config.CoreNames.ESX]:getSharedObject()

elseif Framework == 'qb' then
    print('^2qb-core Recognized.^7')
    
    -- Get the core object from the qb-core resource
    QBCore = exports[Config.CoreNames.QBCore]:GetCoreObject()

else
    print('^1No supported framework detected. Ensure either es_extended or qb-core is running.^7')
    return
end

-- Define a function to retrieve advanced information on a player (Discord, Steam, License, IP, Name, Identifier)
local function GetPlayerInfo(source)
    local identifiers = GetPlayerIdentifiers(source)
    local playerInfo = { discord = "not found", steam = "not found", license = "not found", ip = "not found", name = SD.GetName(source), identifier = SD.GetIdentifier(source), serverId = source }

    for i = 1, #identifiers do
        if string.match(identifiers[i], "discord:") then
            playerInfo.discord = identifiers[i]
        elseif string.match(identifiers[i], "steam:") then
            playerInfo.steam = identifiers[i]
        elseif string.match(identifiers[i], "license:") then
            playerInfo.license = identifiers[i]
        elseif string.match(identifiers[i], "ip:") then
            playerInfo.ip = identifiers[i]
        end
    end

    return playerInfo
end

-- Validate that the Functions are being triggered within the correct Space.
local function ValidateResource(source)
    local invokingResource = GetInvokingResource()

    if not SD.utils.Contains(Secure.AllowedResources, invokingResource) then
        -- Get the player's information
        local playerInfo = GetPlayerInfo(source)

        SD.KickPlayer(source, "Unauthorized resource access detected.")
        
        print("^1ERROR: Resource '" .. invokingResource .. "' attempted unauthorized access by player: ".. playerInfo.name .. " with ID: " .. playerInfo.identifier .. ".^0")
        -- print("If you're a server-owner and seeing this message whilst testing, then you've probably renamed the resource. If you have, head to sv_config.lua of this Resource.")
        
        if Config.EnableLogs then
            TriggerEvent('sd_lib:CreateLog', "default", "Unauthorized Access", 'default', "Originating resource: `" .. invokingResource .. "` attempted unauthorized access.\n\nInformation on the player that attempted the access:\n\n**Player:** " .. playerInfo.name .. "\n**Identifier:** `" .. playerInfo.identifier .. "`\n**Server ID:** `" .. playerInfo.serverId .. "`\n**Discord ID:** `" .. playerInfo.discord .. "`\n**Steam ID:** `" .. playerInfo.steam .. "`\n**License:** `" .. playerInfo.license .. "`\n**IP Address:** `" .. playerInfo.ip .. "`", true)
        end
        
        return false
    end

    return true
end

-- GetPlayer: Returns the player object for a given player source
SD.GetPlayer = function(source)
    if Framework == 'esx' then
        return ESX.GetPlayerFromId(source)
    elseif Framework == 'qb' then
        return QBCore.Functions.GetPlayer(source)
    end
end

-- GetPlayers: Returns a table of all online players
SD.GetPlayers = function()
    if Framework == 'esx' then
        return ESX.GetExtendedPlayers()
    elseif Framework == 'qb' then
        return QBCore.Functions.GetPlayers()
    end
end

-- RegisterCallback: Registers a callback function to be triggered later
SD.RegisterCallback = function(name, cb)
    if Framework == 'esx' then
        ESX.RegisterServerCallback(name, cb)
    elseif Framework == 'qb' then
        QBCore.Functions.CreateCallback(name, cb)
    end
end

-- KickPlayer: Kicks a player with the given reason
SD.KickPlayer = function(source, reason)
    if Framework == 'esx' then
        local player = SD.GetPlayer(source)
        return player.kick(reason)
    elseif Framework == 'qb' then
        QBCore.Functions.Kick(source, reason, nil, nil)
    end
end

-- Define a function to check if a player has a group
SD.HasGroup = function(source, filter)
    local player = SD.GetPlayer(source)
    if not player then return end
    if Framework == 'esx' then
            local type = type(filter)
    
            if type == 'string' then
                if player.job.name == filter then
                    return player.job.name, player.job.grade
                end
            else
                local tabletype = table.type(filter)
    
                if tabletype == 'hash' then
                    local grade = filter[player.job.name]
    
                    if grade and grade <= player.job.grade then
                        return player.job.name, player.job.grade
                    end
                elseif tabletype == 'array' then
                    for i = 1, #filter do
                        if player.job.name == filter[i] then
                            return player.job.name, player.job.grade
                        end
                    end
                end
            end
        elseif Framework == 'qb' then
            local groups = { 'job', 'gang' }
            local type = type(filter)
    
            if type == 'string' then
                -- Check if the player is in the specified group
                for i = 1, #groups do
                    local data = player.PlayerData[groups[i]]
    
                    if data.name == filter then
                        if groups[i] == 'job' and Config.CheckForDuty and not player.PlayerData.job.onduty then
                            return nil
                        end
                        return data.name, data.grade.level
                    end
                end
            else
                local tabletype = table.type(filter)
    
                if tabletype == 'hash' then
                    -- Check if the player is in any of the groups specified in the hash
                    for i = 1, #groups do
                        local data = player.PlayerData[groups[i]]
                        local grade = filter[data.name]
    
                        if grade and grade <= data.grade.level then
                            if groups[i] == 'job' and Config.CheckForDuty and not player.PlayerData.job.onduty then
                                return nil
                            end
                            return data.name, data.grade.level
                        end
                    end
                elseif tabletype == 'array' then
                    -- Check if the player is in any of the groups specified in the array
                    for i = 1, #filter do
                        local group = filter[i]
    
                        for j = 1, #groups do
                            local data = player.PlayerData[groups[j]]
    
                            if data.name == group then
                                if groups[j] == 'job' and Config.CheckForDuty and not player.PlayerData.job.onduty then
                                    return nil
                                end
                                return data.name, data.grade.level
                            end
                        end
                    end
                end
            end
    end
end

-- Define a function to get the (citizen) ID of a player
SD.GetIdentifier = function(source, identifierType)
    local player = SD.GetPlayer(source)
    if player then
        if Framework == 'esx' then
            return player.identifier
        elseif Framework == 'qb' then
            return player.PlayerData.citizenid
        end
    end
end

-- Register a callback to get the identifier of the target player
SD.RegisterCallback('sd_bridge:getIdentifier', function(source, cb)
    -- Call the cb function with the identifier of the target player
    cb(SD.GetIdentifier(source))
end)

-- Define a function to get the full name of a player
SD.GetName = function(source)
    local player = SD.GetPlayer(source)
    if player then
        if Framework == 'esx' then
            return player.getName()
        elseif Framework == 'qb' then
            return player.PlayerData.charinfo.firstname..' '..player.PlayerData.charinfo.lastname
        end
    end
end

-- RegisterUsableItem: Registers a function to be called when a player uses an item
SD.RegisterUsableItem = function(item, cb)
    if Framework == 'esx' then
        ESX.RegisterUsableItem(item, cb)
    elseif Framework == 'qb' then
        QBCore.Functions.CreateUseableItem(item, cb)
    end
end

-- HasItem: Returns the amount of a specific item a player has
SD.HasItem = function(source, item)
    if not ValidateResource(source) then return end

    local player = SD.GetPlayer(source)
    if player == nil then
        return 0
    end

    if Config.EnableLogs and Config.LogType.HasItem then
        local playerInfo = GetPlayerInfo(source)
        TriggerEvent('sd_lib:CreateLog', "default", "Item Checked", 'default', "Originating resource: `" .. GetInvokingResource() .. "` \n - This is the resource from which the `HasItem` function was triggered.\n\nInformation on the player that triggered it:\n\n**Player:** " .. playerInfo.name .. "\n**Identifier:** `" .. playerInfo.identifier .. "`\n**Server ID:** `" .. playerInfo.serverId .. "`\n**Discord ID:** `" .. playerInfo.discord .. "`\n**Steam ID:** `" .. playerInfo.steam .. "`\n**License:** `" .. playerInfo.license .. "`\n**IP Address:** `" .. playerInfo.ip .. "`\n**Function:** HasItem\n**Item:** `" .. item .. "`", false)
    end

    if invState == 'started' then
        -- Call the 'Search' function from the 'ox_inventory' resource if it is started
        local count = exports[Config.InvName.OX]:Search(source, 'count', item)
        return count
    else
        -- Check which framework is in use
        if Framework == 'esx' then
            -- ESX Standard inventory check if 'ox_inventory' isn't started
            local item = player.getInventoryItem(item)
            if item ~= nil then
                return item.count
            else
                return 0
            end
        elseif Framework == 'qb' then
            -- QBCore Standard inventory check if 'ox_inventory' isn't started
            local item = player.Functions.GetItemByName(item)
            if item ~= nil then 
                return item.amount
            else
                return 0
            end
        end
    end
end

-- Define a function to add an item to a player's inventory
SD.AddItem = function(source, item, count, slot, metadata)
    if not ValidateResource(source) then return end

    local player = SD.GetPlayer(source)

    if Config.EnableLogs and Config.LogType.AddItem then
        local playerInfo = GetPlayerInfo(source)
        TriggerEvent('sd_lib:CreateLog', "default", "Item Added", 'default', "Originating resource: `" .. GetInvokingResource() .. "` \nThis is the resource from which the `AddItem` function was triggered.\n\nInformation on the player that triggered it:\n\n**Player:** " .. playerInfo.name .. "\n**Identifier:** `" .. playerInfo.identifier .. "`\n**Server ID:** `" .. playerInfo.serverId .. "`\n**Discord ID:** `" .. playerInfo.discord .. "`\n**Steam ID:** `" .. playerInfo.steam .. "`\n**License:** `" .. playerInfo.license .. "`\n**IP Address:** `" .. playerInfo.ip .. "`\n**Function:** AddItem\n**Item:** `" .. item .. "`\n**Quantity:** `" .. count .. "`", false)
    end

    if invState == 'started' then
        -- Call the 'AddItem' function from the 'ox_inventory' resource if it is started
        return exports[Config.InvName.OX]:AddItem(source, item, count, metadata, slot)
    else
        -- Check which framework is in use
        if Framework == 'esx' then
            -- Call the 'addInventoryItem' functiAon from the 'es_extended' resource if 'ox_inventory' is not started
            return player.addInventoryItem(item, count, metadata, slot)
        elseif Framework == 'qb' then
            -- Standard AddItem if 'ox_inventory' isn't started
            player.Functions.AddItem(item, count, slot, metadata)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], 'add', count)
        end
    end
end

-- Define a function to add a weapon to a player's inventory
SD.AddWeapon = function(source, weapon, ammo)
    if not ValidateResource(source) then return end

    local player = SD.GetPlayer(source)

    if Config.EnableLogs and Config.LogType.AddWeapon then
        local playerInfo = GetPlayerInfo(source)
        TriggerEvent('sd_lib:CreateLog', "default", "Weapon Added", 'default', "Originating resource: `" .. GetInvokingResource() .. "` \nThis is the resource from which the `AddWeapon` function was triggered.\n\nInformation on the player that triggered it:\n\n**Player:** " .. playerInfo.name .. "\n**Identifier:** `" .. playerInfo.identifier .. "`\n**Server ID:** `" .. playerInfo.serverId .. "`\n**Discord ID:** `" .. playerInfo.discord .. "`\n**Steam ID:** `" .. playerInfo.steam .. "`\n**License:** `" .. playerInfo.license .. "`\n**IP Address:** `" .. playerInfo.ip .. "`\n**Function:** AddWeapon\n**Weapon:** `" .. weapon .. "`\n**Ammo:** `" .. ammo .. "`", false)
    end

    -- This function is specific to ESX
    if Framework == 'esx' then
        player.addWeapon(weapon, ammo)
    else
        print("AddWeapon function is not supported in the current framework.")
    end
end

-- Define a function to remove an item from a player's inventory
SD.RemoveItem = function(source, item, count, slot, metadata)
    if not ValidateResource(source) then return end

    local player = SD.GetPlayer(source)

    if Config.EnableLogs and Config.LogType.AddItem then
        local playerInfo = GetPlayerInfo(source)
        TriggerEvent('sd_lib:CreateLog', "default", "Item Removed", 'default', "Originating resource: `" .. GetInvokingResource() .. "` \nThis is the resource from which the `RemoveItem` function was triggered.\n\nInformation on the player that triggered it:\n\n**Player:** " .. playerInfo.name .. "\n**Identifier:** `" .. playerInfo.identifier .. "`\n**Server ID:** `" .. playerInfo.serverId .. "`\n**Discord ID:** `" .. playerInfo.discord .. "`\n**Steam ID:** `" .. playerInfo.steam .. "`\n**License:** `" .. playerInfo.license .. "`\n**IP Address:** `" .. playerInfo.ip .. "`\n**Function:** RemoveItem\n**Item:** `" .. item .. "`\n**Quantity:** `" .. count .. "`", false)
    end

    if invState == 'started' then
        -- Call the 'RemoveItem' function from the 'ox_inventory' resource if it is started
        return exports[Config.InvName.OX]:RemoveItem(source, item, count, metadata, slot)
    else
        -- Check which framework is in use
        if Framework == 'esx' then
            -- Call the 'removeInventoryItem' function from the 'es_extended' resource if 'ox_inventory' is not started
            return player.removeInventoryItem(item, count, metadata, slot)
        elseif Framework == 'qb' then
            -- Standard RemoveItem if 'ox_inventory' isn't started
            player.Functions.RemoveItem(item, count, slot, metadata)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "remove", count)
        end
    end
end

-- Define a function to convert MoneyType to framework specific variant if needed
SD.ConvertMoneyType = function(moneyType)
    if moneyType == 'money' and Framework == 'qb' then
        moneyType = 'cash'
    elseif moneyType == 'cash' and Framework == 'esx' then
        moneyType = 'money'
    end

    return moneyType
end

-- Define a function to add money to a player's account
SD.AddMoney = function(source, moneyType, amount)
    if not ValidateResource(source) then return end

    local player = SD.GetPlayer(source)
    moneyType = SD.ConvertMoneyType(moneyType)

    if Config.EnableLogs and Config.LogType.AddMoney then
        local playerInfo = GetPlayerInfo(source)
        TriggerEvent('sd_lib:CreateLog', "default", "Money Added", 'default', "Originating resource: `" .. GetInvokingResource() .. "` \nThis is the resource from which the `AddMoney` function was triggered.\n\nInformation on the player that triggered it:\n\n**Player:** " .. playerInfo.name .. "\n**Identifier:** `" .. playerInfo.identifier .. "`\n**Server ID:** `" .. playerInfo.serverId .. "`\n**Discord ID:** `" .. playerInfo.discord .. "`\n**Steam ID:** `" .. playerInfo.steam .. "`\n**License:** `" .. playerInfo.license .. "`\n**IP Address:** `" .. playerInfo.ip .. "`\n**Function:** AddMoney\n**Money Type:** `" .. moneyType .. "`\n**Amount:** `" .. amount .. "`", false)
    end
    
    if player then
        if Framework == 'esx' then
            player.addAccountMoney(moneyType, amount)
        elseif Framework == 'qb' then
            player.Functions.AddMoney(moneyType, amount)
        end
    end
end

-- Define a function to remove money from a player's account
SD.RemoveMoney = function(source, moneyType, amount)
    if not ValidateResource(source) then return end

    local player = SD.GetPlayer(source)
    moneyType = SD.ConvertMoneyType(moneyType)

    if Config.EnableLogs and Config.LogType.RemoveMoney then
        local playerInfo = GetPlayerInfo(source)
        TriggerEvent('sd_lib:CreateLog', "default", "Money Removed", 'default', "Originating resource: `" .. GetInvokingResource() .. "` \nThis is the resource from which the `RemoveMoney` function was triggered.\n\nInformation on the player that triggered it:\n\n**Player:** " .. playerInfo.name .. "\n**Identifier:** `" .. playerInfo.identifier .. "`\n**Server ID:** `" .. playerInfo.serverId .. "`\n**Discord ID:** `" .. playerInfo.discord .. "`\n**Steam ID:** `" .. playerInfo.steam .. "`\n**License:** `" .. playerInfo.license .. "`\n**IP Address:** `" .. playerInfo.ip .. "`\n**Function:** RemoveMoney\n**Money Type:** `" .. moneyType .. "`\n**Amount:** `" .. amount .. "`", false)
    end

    if player then
        if Framework == 'esx' then
            player.removeAccountMoney(moneyType, amount)
        elseif Framework == 'qb' then
            player.Functions.RemoveMoney(moneyType, amount)
        end
    end
end

-- Define a function to get the amount of money in a player's account of a specific type
SD.GetPlayerAccountFunds = function(source, moneyType)
    if not ValidateResource(source) then return end

    local player = SD.GetPlayer(source)
    moneyType = SD.ConvertMoneyType(moneyType)

    if Framework == 'qb' then
        return player.PlayerData.money[moneyType]
    elseif Framework == 'esx' then
        return player.getAccount(moneyType).money
    end
end