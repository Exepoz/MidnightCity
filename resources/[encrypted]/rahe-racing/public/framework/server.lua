--
--[[ Framework specific functions ]]--
--

local framework = shConfig.framework
local supportedFrameworks = { ESX = true, QB = true, STANDALONE = true, CUSTOM = true }

if not supportedFrameworks[framework] then
    print("[^1ERROR^7] Invalid framework used in '/public/config/shared.lua' - please choose a supported value (ESX / QB / STANDALONE / CUSTOM).")
end

local ESX, QBCore
if framework == 'ESX' then
    ESX = exports["es_extended"]:getSharedObject()
elseif framework == 'QB' then
    QBCore = exports['qb-core']:GetCoreObject()
else
    -- Fill this in for STANDALONE/CUSTOM if needed..
end

function getPlayerIdentifier(playerId)
    if framework == 'ESX' then
        return tostring(ESX.GetPlayerFromId(playerId).identifier)
    elseif framework == 'QB' then
        local Player = QBCore.Functions.GetPlayer(playerId)
        if Player then
            return tostring(Player.PlayerData.citizenid)
        end
    elseif framework == 'STANDALONE' then
        local playerIdentifiers, steamId = GetPlayerIdentifiers(playerId)

        for _, v in pairs(playerIdentifiers) do
            if string.sub(v, 1, string.len("steam:")) == "steam:" then
                steamId = v
            end
        end

        return steamId
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
        -- Fill this in for STANDALONE/CUSTOM if needed..
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
        -- Fill this in for STANDALONE/CUSTOM if needed..
    end
end

function givePlayerMoney(playerId, amount)
    if framework == 'ESX' then
        ESX.GetPlayerFromId(playerId).addMoney(amount)
    elseif framework == 'QB' then
        local Player = QBCore.Functions.GetPlayer(playerId)
        Player.Functions.AddMoney('cash', amount)
    else
        -- Fill this in for STANDALONE/CUSTOM if needed..
    end
end
QBCore.Functions.CreateUseableItem('racingtablet', function(source, item)    
    TriggerClientEvent('rahe-racing:client:openTablet', source)
end)