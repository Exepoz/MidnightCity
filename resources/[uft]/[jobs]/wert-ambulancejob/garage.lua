local LLANG = LANG[Config.Locale]
RegisterNetEvent("wert-ambulancejob:client:garage-menu", function(spawn, vehtype)
    local Menu = {
        {
            header = LLANG["garagemenu"],
            isMenuHeader = true,
            icon = "fas fa-warehouse",
        }
    }
    for k,v in pairs(Config.EmsVehicles[vehtype]) do
        Menu[#Menu+1] = {
            header = v:upper(),
            txt = "",
            icon = "fa-solid fa-truck-medical",
            params = {
                event = "wert-ambulancejob:client:spawn-car",
                args = {
                    model = v,
                    spawn = Config.GarageSpawnCoords[spawn][vehtype]
                }
            }
        }
    end
    exports['qb-menu']:openMenu(Menu)
end)

RegisterNetEvent("wert-ambulancejob:client:spawn-car", function(data)
    local VehicleSpawnCoord = data.spawn
    QBCore.Functions.SpawnVehicle(data.model, function(veh)
        local plate = "EMS" .. math.random(1111, 5555)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, VehicleSpawnCoord.w)
        SetEntityAsMissionEntity(veh, true, true)
        TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(veh))
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    end, {x=VehicleSpawnCoord.x, y=VehicleSpawnCoord.y, z=VehicleSpawnCoord.z, h= VehicleSpawnCoord.w}, true)
end)

RegisterNetEvent("wert-ambulancejob:client:store-vehicle", function()
    local ped = PlayerPedId()
    local curVeh = GetVehiclePedIsIn(ped)
    local vehicle = GetVehiclePedIsUsing(PlayerPedId())
    if vehicle then
        TaskLeaveVehicle(PlayerPedId(), vehicle, 0)
        Wait(1800)
        QBCore.Functions.DeleteVehicle(curVeh)
        QBCore.Functions.Notify(LLANG["vehiclestored"])
    end
end)