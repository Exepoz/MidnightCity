QBCore = exports['qb-core']:GetCoreObject()

local powerState = {
    city = false,
    east = false
}

--- Functions

--- Method to print debug messages to console when Config.Debug is enabled
---@param message string - message to print
---@return nil
local debugPrint = function(message)
    if type(message) == 'string' then
        print('^3[qb-powerplant] ^5' .. message .. '^7')
    end
end

--- Function to return whether or not the specific powerplant is hit
---@param plant string - powerState index, city or eastern power plant
---@return powerState boolean - Whether or not the powerplant is hit
local getPowerPlantState = function(plant)
    return powerState[plant]
end

--- Method to checks which stations are hit and trigger power plant explosions if needed
---@param playerId number - player server id
---@return nil
local CheckStationHits = function(playerId)
    local plant = nil

    if Config.Locations[1].hit and Config.Locations[2].hit and Config.Locations[3].hit and Config.Locations[4].hit then
        plant = 'east'
    elseif Config.Locations[5].hit and Config.Locations[6].hit and Config.Locations[7].hit then
        plant = 'city'
    end

    if plant then
        if powerState[plant] then return end

        powerState[plant] = true

        Wait(10 * 1000) -- Gives the player 10 seconds to move away before explosion
        TriggerClientEvent('qb-powerplant:client:PowerPlantExplosion', -1, plant)
        TriggerEvent('qb-powerplant:server:PowerPlantHit', plant, playerId) -- Listen to in other resources
        debugPrint('East Power Plant Hit')
        exports['qb-weathersync']:setBlackout(true)
        TriggerClientEvent('chatMessage', -1, Locales['powerplant_hit_title'], 'error', Locales['powerplant_hit_text'])
        TriggerClientEvent('police:client:DisableAllCameras', -1)

        SetTimeout(1000 * 60 * 60, function() -- 60 minutes before reset
            if plant == 'east' then
                Config.Locations[1].hit = false
                Config.Locations[2].hit = false
                Config.Locations[3].hit = false
                Config.Locations[4].hit = false

                TriggerClientEvent('qb-powerplant:client:SetStationStatus', -1, {1, 2, 3, 4}, false)
            elseif plant == 'city' then
                Config.Locations[5].hit = false
                Config.Locations[6].hit = false
                Config.Locations[7].hit = false

                TriggerClientEvent('qb-powerplant:client:SetStationStatus', -1, {5, 6, 7}, false)
            end

            powerState[plant] = false
            TriggerEvent('qb-powerplant:server:PowerPlantRestored', plant) -- Listen to in other resources
            TriggerClientEvent('police:client:EnableAllCameras', -1)
            TriggerClientEvent('chatMessage', -1, Locales['powerplant_hit_title'], 'normal', Locales['powerplant_restored_text'])
            exports['qb-weathersync']:setBlackout(false)
        end)
    end
end

--- Events

RegisterNetEvent('qb-powerplant:server:RemoveThermite', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if Config.Inventory == 'ox_inventory' then
        exports['ox_inventory']:RemoveItem(src, Config.ThermiteItem, 1, false)
    elseif Config.Inventory == 'qb' then
        Player.Functions.RemoveItem(Config.ThermiteItem, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.ThermiteItem], 'remove', 1)
    end
end)

RegisterNetEvent('qb-powerplant:server:SetStationStatus', function(key, isHit)
    local src = source
    local pos = GetEntityCoords(GetPlayerPed(src))
    if #(pos - Config.Locations[key].coords) > 5 then return end
    if type(isHit) ~= 'boolean' or not Config.Locations[key] then return end

    Config.Locations[key].hit = isHit
    debugPrint('Station: ' .. key .. ' is hit successfully by ' .. GetPlayerName(src) .. ' (' .. src .. ')')
    TriggerClientEvent('qb-powerplant:client:SetStationStatus', -1, key, isHit)
    CheckStationHits(src)
end)

RegisterNetEvent('qb-powerplant:server:ThermitePtfx', function(coords)
    TriggerClientEvent('qb-powerplant:client:ThermitePtfx', -1, coords)
end)

--- Callbacks

lib.callback.register('qb-powerplant:server:GetConfig', function(source)
    return Config, powerState
end)

lib.callback.register('qb-powerplant:server:getCops', function(source)
    return Utils.GetCopCount()
end)

--- Commands

lib.addCommand('powerplant', {
    help = Locales['command_help'],
    params = {
        {
            name = 'plant',
            type = 'string',
            help = Locales['command_arg_help'],
            optional = false
        }
    },
    restricted = 'qbcore.god'
}, function(source, args, raw)
    if args.plant == 'city' then
        Config.Locations[5].hit = true
        Config.Locations[6].hit = true
        Config.Locations[7].hit = true

        TriggerClientEvent('qb-powerplant:client:SetStationStatus', -1, {5, 6, 7}, true)
    elseif args.plant == 'east' then
        Config.Locations[1].hit = true
        Config.Locations[2].hit = true
        Config.Locations[3].hit = true
        Config.Locations[4].hit = true

        TriggerClientEvent('qb-powerplant:client:SetStationStatus', -1, {1, 2, 3, 4}, true)
    end

    CheckStationHits(source)
end)

--- exports

exports('getPowerPlantState', getPowerPlantState)
