RegisterServerEvent('cr-fleecabankrobbery:server:VaultCodesRight', function(bank)
    if Config.Logs then FBSUtils.Logs(Lcl('FleecaTitle'), 'green', Lcl('logs_vaultoppened', GetPlayerName(source))) end
    TriggerClientEvent('cr-fleecabankrobbery:client:VaultCodesRight', -1, bank)
end)

RegisterNetEvent('cr-fleecabankrobbery:server:VaultSync', function(type, bank,arg1, arg2, arg3)
    TriggerClientEvent('cr-fleecabankrobbery:client:VaultSync', -1, type, bank, arg1, arg2, arg3)
end)

RegisterNetEvent('cr-fleecabankrobbery:server:GenSyncs', function(arg1, arg2, arg3, arg4)
    TriggerClientEvent('cr-fleecabankrobbery:client:GenSyncs', -1, arg1, arg2, arg3, arg4)
end)

RegisterNetEvent("cr-fleecabankrobbery:server:DeleteZones", function(bank, zone, pos)
    TriggerClientEvent('cr-fleecabankrobbery:client:DeleteZones', -1, bank, zone, pos)
end)

RegisterNetEvent('cr-fleecabankrobbery:server:callCops', function(coords)
    TriggerClientEvent('cr-fleecabankrobbery:client:callCops', -1, coords)
end)


