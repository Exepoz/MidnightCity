local QBCore = exports['qb-core']:GetCoreObject()
local Disposal = {}
for k, _ in pairs(Config.Disposals) do Disposal[k] = 0 end
GlobalState.Disposals = Disposal

-- Use the phone
QBCore.Functions.CreateUseableItem('hightech_phone', function(source, item)
    if not QBCore.Functions.GetPlayer(source).Functions.GetItemByName('hightech_phone') then return end
    TriggerClientEvent('mdn-extras:client:useHTPhone', source)
end)

-- Disposal Logic & Send to Hospital
RegisterNetEvent('mdn-extras:server:disposeBody', function(setting, ply)
    if Disposal[setting] <= 0 then TriggerClientEvent('QBCore:Notify', src, 'That\'s enough bodies, I ain\'t cleaning more.', 'error') return end
    Disposal[setting] = Disposal[setting] - 1
    GlobalState.Disposals = Disposal
    if Disposal[setting] <= 0 then TriggerClientEvent('malmoo-extras:client:endDisposal', -1) end
    TriggerClientEvent('hospital:client:RespawnAtHospital', ply)
end)

-- Pay for the disposal
QBCore.Functions.CreateCallback('mdn-extras:server:payDispo', function(source, cb, setting, amt)
    local Player = QBCore.Functions.GetPlayer(source)
    amt = tonumber(amt)
    local cost = amt * 5
    if not Player.Functions.RemoveItem('hightech_phone', 1) then return end
    if Player.Functions.RemoveMoney('cosmo', cost) then
        Disposal[setting] = amt
        GlobalState.Disposals = Disposal
        TriggerClientEvent('QBCore:Notify', source, 'Diner Reservation set for '..amt..". Meet at the location.", 'success')
        cb(true)
    else
        TriggerClientEvent('QBCore:Notify', src, "You don't have enough Cosmo to complete this Transaction", 'error')
        cb(false)
    end
end)

-- Call back to see if the other player is being escorted
QBCore.Functions.CreateCallback('mdn-extras:server:isEscorted', function(_, cb, ply) cb(Player(ply).state.isEscorted or false) end)