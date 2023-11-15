if Config.Framework == "ESX" then

  -- /admincar db insert
  RegisterNetEvent('jg-advancedgarages:server:SetVehicleAsOwned', function(vehicleProps)
    local src = source
    local player = ESX.GetPlayerFromId(src)

    MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (?, ?, ?)', {player.identifier, vehicleProps.plate, json.encode(vehicleProps)})
    Framework.Server.Notify(src, string.gsub(Locale.vehicleReceived, '%%{value}', vehicleProps.plate))
  end)

  -- /admincar command
  ESX.RegisterCommand('admincar', 'admin', function(xPlayer)
    TriggerClientEvent("jg-advancedgarages:client:SetVehicleAsOwned", xPlayer.source)
  end, false)
end
