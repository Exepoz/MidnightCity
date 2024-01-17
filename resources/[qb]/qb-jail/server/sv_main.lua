QBCore = exports['qb-core']:GetCoreObject()

jailedPlayers = {}

--- Method to print debug messages to console when Config.Debug is enabled
---@param message string - message to print
---@return nil
debugPrint = function(message)
    if Config.Debug and type(message) == 'string' then
        print('^3[' .. Config.Resource .. '] ^5' .. message .. '^7')
    end
end

--- Jailtime management functions

--- Method to add a player to the jailed players, confiscate his items and send him to prison, returns true if successful, false if not successful
---@param src number - playerId
---@param takeItems boolean - Whether to confiscate a players items
---@param time number - Time in minutes, not zero
---@return boolean - Success
local jailPlayer = function(src, takeItems, time)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or type(time) ~= 'number' or time == 0 or type(takeItems) ~= 'boolean' then return false end

    if isPlayerInJail(src) then return false end

    jailedPlayers[src] = time
    Player.Functions.SetMetaData('injail', time)
    TriggerClientEvent('qb-prison:client:SendPlayerToPrison', src, takeItems, time)

    if takeItems then
        -- Take cash and put it in bank
        local cash = Player.PlayerData.money.cash
        if Player.Functions.RemoveMoney('cash', cash, 'prison-belongings') then
            Player.Functions.AddMoney('bank', cash, 'prison-belongings')
        end

        -- Set Unarmed
        SetCurrentPedWeapon(GetPlayerPed(src), `WEAPON_UNARMED`, true)

        if Config.Inventory == 'qb' then
            if takeItems and (not Player.PlayerData.metadata['jailitems'] or table.type(Player.PlayerData.metadata['jailitems']) == 'empty') then
                Player.Functions.SetMetaData('jailitems', Player.PlayerData.items)
                Wait(2000)
                Player.Functions.ClearInventory()
            end
        elseif Config.Inventory == 'ox_inventory' then
            exports['ox_inventory']:ConfiscateInventory(src)
        end
    end

    debugPrint('Added ' .. Player.PlayerData.name .. ' (' .. src .. ')' .. ' to jailedPlayers, time: ' .. time)
    
    return true
end

--- Method to remove a player from jailed players, Relinquish his items and release him, returns true if successful, false if not successful
---@param src number - playerId
---@return boolean - Success
local unJailPlayer = function(src)
    if not isPlayerInJail(src) then return false end

    jailedPlayers[src] = nil
    removeFromJobGroup(src, getPlayerJobGroup(src))

    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if Config.Inventory == 'qb' then
        Player.Functions.ClearInventory()

        Wait(1000)
    
        for _, v in pairs(Player.PlayerData.metadata['jailitems']) do
            Player.Functions.AddItem(v.name, v.amount, false, v.info)
        end
    
        Player.Functions.SetMetaData('jailitems', {})
    elseif Config.Inventory == 'ox_inventory' then
        exports['ox_inventory']:ReturnInventory(src)
    end

    local ped = GetPlayerPed(src)
    SetEntityCoords(ped, Config.Locations['exit'].xyz)
    SetEntityHeading(ped, Config.Locations['exit'].w)

    Player.Functions.SetMetaData('injail', 0)
    TriggerClientEvent('qb-jail:client:PostPrisonExit', src)

    debugPrint(Player.PlayerData.name .. ' (' .. src .. ')' .. ' has been unjailed')

    return true
end

--- Method to return a players remaining jail sentence
---@param src number - playerId
---@return number | boolean - Time in minutes | false
local getPlayerTimeRemaining = function(src)
    if isPlayerInJail(src) then
        return jailedPlayers[src]
    end

    return false
end

--- Method to check if a player can be released from prison, i.e. when his sentence is completed
---@param src number - playerId
---@return boolean - canReleasePlayer
local canReleasePlayer = function(src)
    return jailedPlayers[src] and jailedPlayers[src] < 0
end

--- Method to check if a player is supposed to be in prison, true can mean that the player is released and can exit prison on his request
---@param src number - playerId
---@return boolean - isPlayerInJail
isPlayerInJail = function(src)
    return jailedPlayers[src] and jailedPlayers[src] ~= 0 
end

--- Method to increase a players jail sentence, if player was already released, the amount is now his sentence
---@param src number - playerId
---@param amount number - Time in minutes
---@return boolean - Was successful
increasePlayerJailSentence = function(src, amount)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return false end

    if not isPlayerInJail(src) or type(amount) ~= 'number' then return false end
    
    local currentJailTime = getPlayerTimeRemaining(src)
    local newJailTime = currentJailTime + amount
    if currentJailTime < 0 then newJailTime = amount end
    jailedPlayers[src] = newJailTime

    Player.Functions.SetMetaData('injail', newJailTime)

    if newJailTime > 0 then
        Utils.Notify(src, (Locales['notify_increased_sentence']):format(amount, newJailTime), 'primary', 4000)
    end

    debugPrint('Increased jail sentence of ' .. Player.PlayerData.name .. ' (' .. src .. ')' .. ' by ' .. amount .. ' to ' .. newJailTime)

    return true
end

--- Method to reduce a players jail sentence
---@param src number - playerId
---@param amount number - Time in minutes
---@return boolean - Was successful
reducePlayerJailSentence = function(src, amount)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return false end
    if not isPlayerInJail(src) or type(amount) ~= 'number' then return false end

    local currentJailTime = getPlayerTimeRemaining(src)
    local newJailTime = currentJailTime - amount
    if newJailTime == 0 then newJailTime = -1 end

    jailedPlayers[src] = newJailTime
    Player.Functions.SetMetaData('injail', newJailTime)

    if currentJailTime > 0 and newJailTime < 0 then
        Utils.Notify(src, Locales['notify_sent_prison2'], 'primary', 4000)
    end
    
    debugPrint('Reduced jail sentence of ' .. Player.PlayerData.name .. ' (' .. src .. ')' .. ' by ' .. amount .. ' to ' .. newJailTime)

    return true
end

--- Method to attempt to reduce a players jail sentence for good behaviour
---@param src number - playerId
---@return boolean - Was successful
reduceJailSentenceAttempt = function(src)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local group = getPlayerJobGroup(src)
    if not group or not isPlayerInJail(src) then return end

    local chance = Config.ReduceReward[group].chance
    local amount = Config.ReduceReward[group].amount

    if chance >= math.random(100) then
        local currentJailTime = Player.PlayerData.metadata.injail
        local newJailTime = currentJailTime - amount

        if newJailTime == 0 then newJailTime = -1 end

        if newJailTime < 0 then
            Utils.Notify(src, Locales['notify_sent_prison2'], 'primary', 4000)
        else
            Utils.Notify(src, (Locales['notify_reduced_sentence']):format(amount), 'primary', 4000)
        end

        jailedPlayers[src] = newJailTime

        Player.Functions.SetMetaData('injail', newJailTime)

        debugPrint(Player.PlayerData.name .. ' (' .. src .. ')' .. ' reduced jail sentence by ' .. amount .. ' (' .. group .. ')')
        
        return true
    else
        return false
    end
end

--- Method to reduce every jailed players sentence by one, repeats every minute
---@return nil
SentenceLoop = function()
    for k, v in pairs(jailedPlayers) do
        if v then
            jailedPlayers[k] -= 1

            if jailedPlayers[k] == 0 then
                jailedPlayers[k] = -1
                Utils.Notify(k, Locales['notify_sent_prison2'], 'primary', 4000)
            end

            local Player = QBCore.Functions.GetPlayer(k)
            Player.Functions.SetMetaData('injail', jailedPlayers[k])
        end
    end

    SetTimeout(60000, SentenceLoop)
end

CreateThread(SentenceLoop)

--- Start/Stop Events

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() ~= resource then return end
    for i = 1, #skateParkObjects do
        if DoesEntityExist(skateParkObjects[i]) then
            DeleteEntity(skateParkObjects[i])
        end
    end

    for i = 1, #cleaningSetup do
        if DoesEntityExist(cleaningSetup[i].handle) then
            DeleteEntity(cleaningSetup[i].handle)
        end
    end

    for i = 1, #scrapYardObjects do 
        if DoesEntityExist(scrapYardObjects[i]) then
            DeleteEntity(scrapYardObjects[i])
        end
    end

    for i = 1, #farmingSetup do
        if DoesEntityExist(farmingSetup[i].handle) then
            DeleteEntity(farmingSetup[i].handle)
        end
    end
    
    for i = 1, #spawnedGuards, 1 do
        if DoesEntityExist(spawnedGuards[i]) then
            DeleteEntity(spawnedGuards[i])
        end
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() ~= resource then return end
    Wait(1000)

    for k, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if v.PlayerData.metadata.injail ~= 0 then
            Utils.Notify(v.PlayerData.source, Locales['notify_script_restart'], 'primary', 4000)
            jailPlayer(v.PlayerData.source, false, v.PlayerData.metadata.injail)
        end
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source

    if isPlayerInJail(src) then 
        jailedPlayers[src] = nil
        removeFromJobGroup(src, getPlayerJobGroup(src))
    end
end)

--- Player Load/Unload event

AddEventHandler('QBCore:Server:OnPlayerUnload', function(src)
    if isPlayerInJail(src) then 
        jailedPlayers[src] = nil
        removeFromJobGroup(src, getPlayerJobGroup(src))
    end
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if Player.PlayerData.metadata.injail ~= 0 then
        jailPlayer(src, false, Player.PlayerData.metadata.injail)
    end
end)

--- Jail Events

RegisterNetEvent('qb-jail:server:RequestPrisonExit', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local ped = GetPlayerPed(src)
    if #(GetEntityCoords(ped) - Config.Locations.services) > 15 then return end

    if canReleasePlayer(src) then
        unJailPlayer(src)
        Utils.CreateLog(Player.PlayerData.name, 'Left Prison', 'Left Prison', Player.PlayerData.name .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. src .. ')' .. ' has left the prison')
    end
end)

RegisterNetEvent('qb-jail:server:RequestSentenceReduction', function(sentGroup)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not sentGroup or not isPlayerInJail(src) or not Config.ReduceReward[sentGroup] then return end

    if sentGroup == getPlayerJobGroup(src) then
        reduceJailSentenceAttempt(src)
    end
end)

--- Reception

RegisterNetEvent('qb-jail:server:RequestPrisoner', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(playerId)
    if not Player or not Target then return end
    
    local request = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
    Utils.Notify(playerId, (Locales['notify_visitation_request']):format(request), 'primary', 8000)
end)

lib.callback.register('qb-jail:server:GetAllPrisoners', function(source)
    local prisoners = {}

    for k, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if isPlayerInJail(v.PlayerData.source) then
            prisoners[#prisoners + 1] = {
                id = v.PlayerData.source,
                name = v.PlayerData.charinfo.firstname .. ' ' .. v.PlayerData.charinfo.lastname,
                time = getPlayerTimeRemaining(v.PlayerData.source)
            }

        end
    end

    return prisoners
end)

--- Commands for confiscating and returning player items

lib.addCommand('confiscate', {
    help = Locales['command_confiscate_help'],
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = Locales['command_increase_arg1_help'],
            optional = false
        },
    },
}, function(source, args, raw)
    local Player = QBCore.Functions.GetPlayer(source)
    local OtherPlayer = QBCore.Functions.GetPlayer(args.target)

    if Player and OtherPlayer and Utils.PlayerIsLeo(Player.PlayerData.job) then
        local ped = GetPlayerPed(source)
        local targetPed = GetPlayerPed(args.target)

        if #(GetEntityCoords(ped) - GetEntityCoords(targetPed)) < 2.5 then
            if OtherPlayer.PlayerData.metadata["ishandcuffed"] or OtherPlayer.PlayerData.metadata["isdead"] or OtherPlayer.PlayerData.metadata["inlaststand"] then
                -- Take cash and put it in bank
                local cash = OtherPlayer.PlayerData.money.cash

                if OtherPlayer.Functions.RemoveMoney('cash', cash, 'prison-belongings') then
                    OtherPlayer.Functions.AddMoney('bank', cash, 'prison-belongings')
                end

                -- Set unarmed
                SetCurrentPedWeapon(targetPed, `WEAPON_UNARMED`, true)

                -- Take Items
                if Config.Inventory == 'qb' then
                    if not OtherPlayer.PlayerData.metadata['jailitems'] or table.type(OtherPlayer.PlayerData.metadata['jailitems']) == 'empty' then
                        OtherPlayer.Functions.SetMetaData('jailitems', OtherPlayer.PlayerData.items)

                        Wait(2000)

                        OtherPlayer.Functions.ClearInventory()
                    else
                        Utils.Notify(source, Locales['notify_cannot_confiscate'], 'error', 2500)
                    end
                elseif Config.Inventory == 'ox_inventory' then
                    exports['ox_inventory']:ConfiscateInventory(source)
                end

                -- Log
                Utils.CreateLog(Player.PlayerData.name, 'LEO Confiscate', 'LEO Confiscate', Player.PlayerData.name .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')' .. ' has confiscted items of ' .. OtherPlayer.PlayerData.name)
            else
                Utils.Notify(source, Locales['notify_cuffed_or_dead'], 'error', 2500)
            end
        else
            Utils.Notify(source, Locales['notify_player_toofar'], 'error', 2500)
        end
    else
        Utils.Notify(source, Locales['notify_for_police'], 'error', 2500)
    end
end)

lib.addCommand('relinquish', {
    help = Locales['command_relinquish_help'],
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = Locales['command_increase_arg1_help'],
            optional = false
        },
    },
}, function(source, args, raw)
    local Player = QBCore.Functions.GetPlayer(source)
    local OtherPlayer = QBCore.Functions.GetPlayer(args.target)

    if Player and OtherPlayer and Utils.PlayerIsLeo(Player.PlayerData.job) then
        local ped = GetPlayerPed(source)
        local targetPed = GetPlayerPed(args.target)

        if #(GetEntityCoords(ped) - GetEntityCoords(targetPed)) < 2.5 then
            if Config.Inventory == 'qb' then
                if OtherPlayer.PlayerData.metadata['jailitems'] and table.type(OtherPlayer.PlayerData.metadata['jailitems']) ~= 'empty' then
                    OtherPlayer.Functions.ClearInventory()

                    Wait(1000)

                    for _, v in pairs(OtherPlayer.PlayerData.metadata['jailitems']) do
                        OtherPlayer.Functions.AddItem(v.name, v.amount, false, v.info)
                    end
                    
                    OtherPlayer.Functions.SetMetaData('jailitems', {})
                else
                    Utils.Notify(src, Locales['notify_cannot_return'], 'error', 2500)
                end
            elseif Config.Inventory == 'ox_inventory' then
                exports['ox_inventory']:ReturnInventory(source)
            end

            -- Log
            Utils.CreateLog(Player.PlayerData.name, 'LEO Return', 'LEO Return', Player.PlayerData.name .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')' .. ' has returned items of ' .. OtherPlayer.PlayerData.name)
        else
            Utils.Notify(source, Locales['notify_player_toofar'], 'error', 2500)
        end
    else
        Utils.Notify(source, Locales['notify_for_police'], 'error', 2500)
    end
end)

--- Exports

exports('jailPlayer', jailPlayer)
exports('unJailPlayer', unJailPlayer)
exports('isPlayerInJail', isPlayerInJail)
exports('canReleasePlayer', canReleasePlayer)
exports('getPlayerTimeRemaining', getPlayerTimeRemaining)
exports('increasePlayerJailSentence', increasePlayerJailSentence)
exports('reducePlayerJailSentence', reducePlayerJailSentence)

--- Testing: /jail command doesn't allow self-test, remove or comment when done testing, this requires server ace perms => server console

RegisterCommand('jailPlayer', function(source, args, rawCommand)
    local playerId = tonumber(args[1])
    local time = tonumber(args[2])
    if not playerId or not time then return end

    local Player = QBCore.Functions.GetPlayer(playerId)
    if not Player then return end

    jailPlayer(playerId, true, time)
end, true)
