local QBCore = exports['qb-core']:GetCoreObject()
local vehNitrous = {}

-- Tackle Players
RegisterNetEvent('tackle:server:TacklePlayer', function(playerId)
    TriggerClientEvent('tackle:client:GetTackled', playerId)
end)

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- Default QBCore NOS
QBCore.Functions.CreateCallback('nos:GetNosLoadedVehs', function(_, cb)
    cb(vehNitrous)
end)

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- Harness
QBCore.Functions.CreateUseableItem('harness', function(source, item)
    TriggerClientEvent('seatbelt:client:UseHarness', source, item)
end)

RegisterNetEvent('equip:harness', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    if not Player.PlayerData.items[item.slot].info.uses then
        Player.PlayerData.items[item.slot].info.uses = Config.HarnessUses - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    elseif Player.PlayerData.items[item.slot].info.uses == 1 then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['harness'], 'remove')
        Player.Functions.RemoveItem('harness', 1)
    else
        Player.PlayerData.items[item.slot].info.uses -= 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

RegisterNetEvent('seatbelt:DoHarnessDamage', function(hp, data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    if hp == 0 then
        Player.Functions.RemoveItem('harness', 1, data.slot)
    else
        Player.PlayerData.items[data.slot].info.uses -= 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- Fetching Player Count for Discord API
QBCore.Functions.CreateCallback('smallresources:server:GetCurrentPlayers', function(_, cb)
    cb(#GetPlayers())
end)

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- Blacklisting entities can just be handled entirely server side with onesync events
-- No need to run coroutines to supress or delete these when we can simply delete them before they spawn
AddEventHandler("entityCreating", function(handle)
    local entityModel = GetEntityModel(handle)

    if Config.BlacklistedVehs[entityModel] or Config.BlacklistedPeds[entityModel] then
        CancelEvent()
    end
end)