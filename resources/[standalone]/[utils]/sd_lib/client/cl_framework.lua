SD = SD or {}

-- Initialize common variables
PlayerLoaded, PlayerData = nil, {}

-- Check if the 'es_extended' resource is started
if Framework == 'esx' then
    -- Get the shared object for 'es_extended'
    ESX = exports[Config.CoreNames.ESX]:getSharedObject()
    
    -- Triggered when a player has loaded into the game
    RegisterNetEvent('esx:playerLoaded', function(xPlayer)
        -- Trigger 'onPlayerLoaded' event for custom script
        TriggerEvent('sd_bridge:onPlayerLoaded')
        -- Save player data to PlayerData variable
        PlayerData = xPlayer
        -- Set PlayerLoaded to true
        PlayerLoaded = true
    end)
    
    -- Triggered when a player logs out
    RegisterNetEvent('esx:onPlayerLogout', function()
        -- Clear the PlayerData table
        table.wipe(PlayerData)
        -- Set PlayerLoaded to false
        PlayerLoaded = false
    end)

    -- Triggered when a resource starts
    AddEventHandler('onResourceStart', function(resourceName)
        -- Check if the current resource is 'es_extended' and if the player has loaded
        if GetCurrentResourceName() ~= resourceName or not ESX.PlayerLoaded then 
            return 
        end
        -- Get the player data and set PlayerLoaded to true
        PlayerData = ESX.GetPlayerData()
        PlayerLoaded = true
    end)

    -- Triggered when the 'esx:setPlayerData' event is called
    AddEventHandler('esx:setPlayerData', function(key, value)
        -- Check if the invoking resource is 'es_extended'
        if GetInvokingResource() ~= Config.CoreNames.ESX then 
            return 
        end
        -- Set the PlayerData key to the given value
        PlayerData[key] = value
    end)
    
-- Check if 'qb-core' resource is started
elseif Framework == 'qb' then
    -- Set QBCore variable to core object of the 'qb-core' resource
    QBCore = exports[Config.CoreNames.QBCore]:GetCoreObject()
    
    -- Add a state bag change handler for 'isLoggedIn' state
    AddStateBagChangeHandler('isLoggedIn', '', function(_bagName, _key, value, _reserved, _replicated)
        -- If the value is true, get the player data, else wipe the PlayerData table
        if value then
            PlayerData = QBCore.Functions.GetPlayerData()
        else
            table.wipe(PlayerData)
        end
        -- Set the PlayerLoaded variable to the value of 'isLoggedIn'
        PlayerLoaded = value
    end)
    
    -- Register event for player loaded
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        TriggerEvent('sd_bridge:onPlayerLoaded')
    end)
    
    -- Add an event handler for resource start
    AddEventHandler('onResourceStart', function(resourceName)
        -- Check if the resource name is the same as the current resource name and the player is logged in
        if GetCurrentResourceName() ~= resourceName or not LocalPlayer.state.isLoggedIn then
            return
        end
        -- Get the player data and set the PlayerLoaded variable to true
        PlayerData = QBCore.Functions.GetPlayerData()
        PlayerLoaded = true
    end)
    
    -- Register event for player data change
    RegisterNetEvent('QBCore:Player:SetPlayerData', function(newPlayerData)
        -- Check if the event was triggered by 'qb-core' resource and source is not empty
        if source ~= '' and GetInvokingResource() ~= Config.CoreNames.QBCore then
            return
        end
        -- Set the PlayerData table to the new player data
        PlayerData = newPlayerData
    end)
else
    -- If neither 'es_extended' nor 'qb-core' is running, print error
    print("Error: Neither ESX nor QBCore resources are running!")
    return
end

-- Function to display a notification
SD.ShowNotification = function(message, type)
     -- Check if the ox_lib (library) is available
    if lib ~= nil and Config.OxLibSettings.EnableNotifications then
        -- Display notification using ox_lib
        lib.notify({
            description = message or false,
            id = id or false,
            position = Config.OxLibSettings.NotificationPos,
            icon = icon or false,
            duration = 3500,
            type = type
        })
    else
        -- Display notification using the respective framework's method if ox_lib isn't imported.
        if Framework == 'esx' then
            ESX.ShowNotification(message)
        elseif Framework == 'qb' then
            QBCore.Functions.Notify(message, type)
        end
    end
end

-- Event to show a notification to the player
RegisterNetEvent('sd_bridge:notification', function(msg, type)
    -- Call the ShowNotification function to display the notification
    SD.ShowNotification(msg, type)
end)

-- Function to get the closest player
SD.GetClosestPlayer = function()
    if Framework == 'esx' then
        return ESX.Game.GetClosestPlayer()
    elseif Framework == 'qb' then
        return QBCore.Functions.GetClosestPlayer()
    end
end

-- Function to trigger a server-side callback
SD.ServerCallback = function(name, cb, ...)
    if Framework == 'esx' then
        ESX.TriggerServerCallback(name, cb, ...)
    elseif Framework == 'qb' then
        QBCore.Functions.TriggerCallback(name, cb, ...)
    end
end

-- Client Function to get the player's identifier
SD.GetIdentifier = function()
    local thread = coroutine.running()
    SD.ServerCallback('sd_bridge:getIdentifier', function(identifier)
        assert(thread, "Must be called from a coroutine")
        coroutine.resume(thread, identifier)
    end)
    return coroutine.yield()
end

-- Function to start a progress bar
SD.StartProgress = function(identifier, label, duration, completed, notfinished)
    -- Check if the ox_lib (library) is available for progress bar generation
    if lib ~= nil and Config.OxLibSettings.EnableProgressBar then
        -- Determine the type of progress bar from the configuration settings
        if Config.OxLibSettings.ProgressBarType == 'circular' then
            -- Initiate a circular progress bar using ox_lib functionalities
            if lib.progressCircle({
                duration = duration,  
                position = Config.OxLibSettings.CircularPos,  
                useWhileDead = false, 
                canCancel = true,     
                disable = { move = true }  
            }) then 
                completed()
            else 
                notfinished()
            end
        elseif Config.OxLibSettings.ProgressBarType == 'normal' then
            -- Initiate a standard linear progress bar using ox_lib functionalities
            if lib.progressBar({
                duration = duration,  
                label = label,      
                useWhileDead = false,
                canCancel = true,  
                disable = { move = true } 
            }) then 
                completed()
            else 
                notfinished()
            end
        end
    else
        -- If ox_lib isn't available, determine which Framework should be used for the progress bar
        if Framework == 'esx' then
            -- Use the ESX framework's progress bar functionality
            exports.esx_progressbar:Progressbar(label, duration, {
                FreezePlayer = true,  
                onFinish = function()
                    completed()
                end
            })
        elseif Framework == 'qb' then
            -- Use the QB framework's progress bar functionalities
            QBCore.Functions.Progressbar(identifier, label, duration, false, true, {
                disableMovement = true,      
                disableCarMovement = true,    
                disableMouse = false,         
                disableCombat = true,         
            }, {}, {}, {}, completed, notfinished)
        end
    end
end

-- Function to check if the player has the given items and amount
SD.HasItem = function(items, amount)

    -- Check if the 'ox_inventory' resource is started
    if invState == 'started' then
        -- If the item parameter is a table, search for multiple items
        if type(items) == 'table' then
            local itemArray = {}
            -- If the item table is an array, use it, otherwise convert it to an array
            if next(items, next(items)) then -- Check if it is an array
                itemArray = items
            else
                for k in pairs(items) do
                    itemArray[#itemArray + 1] = k
                end
            end

            -- Search for the given items in the 'ox_inventory' resource
            local returnedItems = exports[Config.InvName.OX]:Search('count', itemArray)
            if returnedItems then
                local count = 0
                -- Loop through the item table and check if each item has the required amount
                for k, amount in pairs(items) do
                    if returnedItems[k] and returnedItems[k] >= amount then
                        count = count + 1
                    end
                end
                -- If all items have the required amount, return true
                return count == #itemArray
            end
            -- If the items are not found, return false
            return false
        else
            -- If the item parameter is a string, search for a single item
            return exports[Config.InvName.OX]:Search('count', items) >= amount
        end
    end

    -- If 'ox_inventory' resource is not started, check based on the Framework
    if Framework == 'esx' then
        -- ESX code
        local PlayerData = ESX.GetPlayerData() and ESX.GetPlayerData().inventory
        if not PlayerData then
            return false
        end

        local inventory = ESX.GetPlayerData().inventory
        local isTable = type(items) == 'table'
        local count = 0
        for _, itemData in pairs(inventory) do
            if isTable then
                for k, amount in pairs(items) do
                    if itemData.name == k and ((itemData.count or itemData.amount) >= amount) then
                        count = count + 1
                    end
                end
                if count == #items then
                    return true
                end
            else
                if itemData.name == items and ((itemData.count or itemData.amount) >= amount) then
                    return true
                end
            end
        end
        return false

    elseif Framework == 'qb' then
        -- QB code
        local PlayerData = QBCore.Functions.GetPlayerData()
        if not PlayerData or not PlayerData.items then
            return false
        end

        local isTable = type(items) == 'table'
        local count = 0

        if isTable then
            for i = 1, #items do
                local itemName, itemAmount = items[i][1], items[i][2] or amount
                local foundItem = false

                for j = 1, #PlayerData.items do
                    local itemData = PlayerData.items[j]

                    if itemData and itemData.name == itemName and itemData.amount >= itemAmount then
                        foundItem = true
                        break
                    end
                end

                if not foundItem then
                    return false
                end
            end

            return true
        else
            for i = 1, #PlayerData.items do
                local itemData = PlayerData.items[i]

                if itemData and itemData.name == items and itemData.amount >= amount then
                    return true
                end
            end

            return false
        end
    end
end