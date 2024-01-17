--
--[[ Framework specific functions ]]--
--

local framework = shConfig.framework
local supportedFrameworks = { ESX = true, QB = true, CUSTOM = true }

if not supportedFrameworks[framework] then
    print("[^1ERROR^7] Invalid framework used in '/config/shared.lua' - please choose a supported value (ESX / QB / CUSTOM).")
end

local ESX, QBCore
if framework == 'ESX' then
    ESX = exports["es_extended"]:getSharedObject()
elseif framework == 'QB' then
    QBCore = exports['qb-core']:GetCoreObject()
end

function getPlayerIdentifier(playerId)
    if framework == 'ESX' then
        return tostring(ESX.GetPlayerFromId(playerId).identifier)
    elseif framework == 'QB' then
        local Player = QBCore.Functions.GetPlayer(playerId)
        if Player then
            return tostring(Player.PlayerData.citizenid)
        end

        return -1
    else
        -- CUSTOM
    end
end

function getPlayerMoney(playerId)
    if framework == 'ESX' then
        return ESX.GetPlayerFromId(playerId).getMoney()
    elseif framework == 'QB' then
        return QBCore.Functions.GetPlayer(playerId).PlayerData.money.cash
    else
        -- CUSTOM
        return 0
    end
end

function removePlayerMoney(playerId, amount)
    if framework == 'ESX' then
        ESX.GetPlayerFromId(playerId).removeMoney(amount)
    elseif framework == 'QB' then
        local Player = QBCore.Functions.GetPlayer(playerId)
        Player.Functions.RemoveMoney('cash', amount)
    else
        -- CUSTOM
    end
end

function givePlayerMoney(playerId, amount)
    if framework == 'ESX' then
        ESX.GetPlayerFromId(playerId).addMoney(amount)
    elseif framework == 'QB' then
        local Player = QBCore.Functions.GetPlayer(playerId)
        Player.Functions.AddMoney('cash', amount)
    else
        -- CUSTOM
    end
end

function giveItem(playerId, itemId, amount)
    if framework == 'ESX' then

    elseif framework == 'QB' then

    else
        -- CUSTOM
    end
end

-- Use this variable if you want to set the police count with an event from another resource. If it's not nil, it will be used.
local policeCount

function getOnDutyPoliceAmount()
    if policeCount or framework == 'QB' then
        if not policeCount then -- If the QB framework has yet not set the police count.
            policeCount = 0
        end

        return policeCount
    elseif framework == 'ESX' then
        return #ESX.GetExtendedPlayers('job', 'police')
    else
        -- CUSTOM
    end
end

-- This is event is only relevant if you're using QB. If you're using QB, please check the readme to make sure you have triggered this event in qb-policejob.
AddEventHandler('police:SetCopCount', function(amount)
    policeCount = amount
end)

--
--[[ General]]--
--

QBCore.Functions.CreateUseableItem("boostingtablet", function(source, item)
    TriggerClientEvent("rahe-boosting:client:openTablet", source)
end)

QBCore.Functions.CreateUseableItem("hackingdevice", function(source, item)
    TriggerClientEvent("rahe-boosting:client:hackingDeviceUsed", source)
end)

QBCore.Functions.CreateUseableItem("gpshackingdevice", function(source, item)
    TriggerClientEvent("rahe-boosting:client:gpsHackingDeviceUsed", source)
end)


function notifyPlayer(playerId, message, type)
    TriggerClientEvent('rahe-boosting:client:notify', playerId, message, type)
end

-- The event which will be triggered when a player successfully completes his VIN scratch boosting contract.
-- This event must be used to give a vehicle to the player.
AddEventHandler('rahe-boosting:server:vinScratchSuccessful', function(playerId, vehicleModel, vehicleModelName, licensePlate, vehicleProperties, contractOwnerIdentifier)
    local Player = QBCore.Functions.GetPlayer(playerId)
    MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
        Player.PlayerData.license,
        Player.PlayerData.citizenid,
        vehicleModel,
        GetHashKey(vehicleModel),
        '{}',
        licensePlate,
        'legionsquare',
        1
    })
end)

-- Function that determines if player is a superuser (is allowed to use the admin panel).
function isPlayerSuperUser(playerIdentifier, playerId)
    if svConfig.adminPrincipal and IsPlayerAceAllowed(playerId, 'boosting.admin') then
        return true
    end

    for _, v in ipairs(svConfig.adminIdentifiers) do
        if v == playerIdentifier then
            return true
        end
    end

    return false
end