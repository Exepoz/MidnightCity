if Config.Framework == "ESX" then
  -- Player data
  Globals.PlayerData = ESX.GetPlayerData()

  RegisterNetEvent('esx:playerLoaded')
  AddEventHandler('esx:playerLoaded', function(xPlayer)
    Globals.PlayerData = xPlayer
  end)

  RegisterNetEvent('esx:setJob')
  AddEventHandler('esx:setJob', function(job)
    Globals.PlayerData.job = job
    createJobGarageBlips() -- refresh blips
  end)

  -- ESX admincar replacement
  RegisterNetEvent("jg-advancedgarages:client:SetVehicleAsOwned", function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped)
    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
    local plate = vehicleProps.plate

    if vehicle ~= 0 and vehicle then
      ESX.TriggerServerCallback('jg-advancedgarages:server:GetVehicle', function(veh)
        if not veh.plate then
          TriggerServerEvent('jg-advancedgarages:server:SetVehicleAsOwned', vehicleProps)
        else
          Framework.Client.Notify(Locale.vehiclePlateExistsError, "error")
        end
      end, plate)
    else
      Framework.Client.Notify(Locale.notInsideVehicleError, "error")
    end
  end)
end
