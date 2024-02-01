local QBCore = exports['qb-core']:GetCoreObject()
local Disposal = {}
local needPay = {}
for k, _ in pairs(Config.Disposals) do Disposal[k] = 0 end
GlobalState.Disposals = Disposal
GlobalState.DispoNeedPay = needPay

-- -- Use the phone
-- QBCore.Functions.CreateUseableItem('hightech_phone', function(source, item)
--     if not QBCore.Functions.GetPlayer(source).Functions.GetItemByName('hightech_phone') then return end
--     TriggerClientEvent('mdn-extras:client:useHTPhone', source)
-- end)

-- Disposal Logic & Send to Hospital
RegisterNetEvent('mdn-extras:server:disposeBody', function(setting, ply)
    if Disposal[setting] <= 0 then TriggerClientEvent('QBCore:Notify', src, 'That\'s enough bodies, I ain\'t cleaning more.', 'error') return end
    Disposal[setting] = Disposal[setting] - 1
    GlobalState.Disposals = Disposal
    if Disposal[setting] <= 0 then TriggerClientEvent('malmoo-extras:client:endDisposal', -1) end
    TriggerClientEvent('hospital:client:RespawnAtHospital', ply)
    TriggerClientEvent('hospital:client:RespawnAtMorgue', ply)
end)

-- Pay for the disposal
QBCore.Functions.CreateCallback('mdn-extras:server:setupDispo', function(source, cb, setting, amt)
    if Disposal[setting] > 0 then TriggerClientEvent('QBCore:Notify', source, "This meal is not available at the moment.", 'success') cb(false) return end
    amt = tonumber(amt)
    local cost = amt * 1000
    needPay[setting] = amt
    GlobalState.DispoNeedPay = needPay
    TriggerClientEvent('QBCore:Notify', source, 'Diner Reservation will cost '..cost.." crumbs. Meet at the location.", 'success')
    cb(cost)
end)

-- Pay for the disposal
QBCore.Functions.CreateCallback('mdn-extras:server:payDispo', function(source, cb, setting, amt)
    local Player = QBCore.Functions.GetPlayer(source)
    if Disposal[setting] > 0 then cb(true)
    elseif needPay[setting] then
        amt = tonumber(needPay[setting])
        local cost = amt * 1000
        if Player.Functions.RemoveItem('midnight_crumbs', cost) then
            Disposal[setting] = amt
            needPay[setting] = nil
            GlobalState.Disposals = Disposal
            GlobalState.DispoNeedPay = needPay
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['midnight_crumbs'], "remove", cost)
            TriggerClientEvent('QBCore:Notify', source, "Diner Reservation Paid. You can proceed with your guests.", 'success')
            cb(true)
        else
            TriggerClientEvent('QBCore:Notify', source, "You don't have enough crumbs to complete this Transaction", 'error')
            cb(false)
        end
    else
        cb(false)
    end
end)

-- Call back to see if the other player is being escorted
QBCore.Functions.CreateCallback('mdn-extras:server:isEscorted', function(_, cb, ply) cb(Player(ply).state.isEscorted or false) end)