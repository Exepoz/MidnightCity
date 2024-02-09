local QBCore = exports['qb-core']:GetCoreObject()
local SpawnVehicle = false

-- Vehicle Rentals

local comma_value = function(n) -- credit http://richard.warburton.it
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

RegisterNetEvent('qb-rental:client:LicenseCheck', function(data)
    TriggerEvent('qb-rental:client:openMenu', data)
    -- license = data.LicenseType
    -- if license == "driver" then
    --     QBCore.Functions.TriggerCallback("qb-rentals:server:getDriverLicenseStatus", function(hasLicense)
    --         if hasLicense  then
    --             TriggerEvent('qb-rental:client:openMenu', data)
    --             MenuType = "vehicle"
    --         else
    --             QBCore.Functions.Notify(Lang:t("error.no_driver_license"), "error", 4500)
    --         end
    --     end)
    -- elseif license == "pilot" then
    --     QBCore.Functions.TriggerCallback("qb-rentals:server:getPilotLicenseStatus", function(hasLicense)
    --         if hasLicense  then
    --             TriggerEvent('qb-rental:client:openMenu', data)
    --             MenuType = "aircraft"
    --         else
    --             QBCore.Functions.Notify(Lang:t("error.no_pilot_license"), "error", 4500)
    --         end
    --     end)
    -- end
end)

RegisterNetEvent('qb-rental:client:openMenu', function(data)
    menu = data.data.shop

    local vehMenu = {
        [1] = {
            header = "Rental Vehicles"..(data.data.crumbs and " - Crumbs Only" or ""),
            isMenuHeader = true,
        },

        [2] = {
            id = 1,
            header = "Return Vehicle ",
            txt = Lang:t("task.return_veh"),
            params = {
                event = "qb-rental:client:return",
            }
        }
    }

    for k, v in ipairs(Config.Vehicles[menu]) do
        local veh = QBCore.Shared.Vehicles[v.model]
        local name = veh and ('%s %s'):format(veh.brand, veh.name) or v.model:sub(1,1):upper()..v.model:sub(2)
        local txt = data.data.crumbs and comma_value(v.money).." crumbs" or ("$%s"):format(comma_value(v.money))
        vehMenu[#vehMenu+1] = {
            id = k,
            header = name,
            txt = txt,
            params = {
                event = "qb-rental:client:spawncar",
                args = {
                    model = v.model,
                    money = v.money,
                    data = data,
                }
            }
        }
    end
    exports['qb-menu']:openMenu(vehMenu)
end)

local SpawnNPC = function()
    for k, v in pairs(Config.Locations) do
        RequestModel(v.pedhash)
        while not HasModelLoaded(v.pedhash) do
            Wait(1)
        end
        v.activeped = CreatePed(5, v.pedhash, v.coords.x, v.coords.y, v.coords.z, v.coords.w, false, true)
        FreezeEntityPosition(created_ped_3, true)
        SetEntityInvincible(created_ped_3, true)
        SetBlockingOfNonTemporaryEvents(created_ped_3, true)
        TaskStartScenarioInPlace(created_ped_3, 'WORLD_HUMAN_CLIPBOARD', 0, true)
        local event = v.licenseNeeded ~= nil and 'qb-rental:client:LicenseCheck' or "qb-rental:client:openMenu"
        local vehicleType = Config.VehicleTypes[v.shop]
        exports['ox_target']:addLocalEntity(v.activeped, {
                {
                    type = "client",
                    event = event,
                    icon = "fas fa-car",
                    label = "Rent "..vehicleType,
                    LicenseType = v.licenseNeeded,
                    data = v,
                    distance = 3.0
                },
          })
    end
end

CreateThread(function()
    SpawnNPC()
end)

RegisterNetEvent('qb-rental:client:spawncar', function(data)
    local player = PlayerPedId()
    local money = data.money
    local model = data.model
    local ldata = data.data.data
    local crumbs = ldata.crumbs
    local label = Lang:t("error.not_enough_space", {vehicle = menu:sub(1,1):upper()..menu:sub(2)})
    if SpawnVehicle == true then QBCore.Functions.Notify('You already have a rented vehicle!', 'error') return end
    if IsAnyVehicleNearPoint(ldata.spawnpoint.x, ldata.spawnpoint.y, ldata.spawnpoint.z, 2.0) then
        QBCore.Functions.Notify('There is a vehicle in the way!', "error", 4500)
        return
    end


    QBCore.Functions.TriggerCallback("qb-rental:server:CashCheck",function(money)
        if money then
            QBCore.Functions.SpawnVehicle(model, function(vehicle)
                SetEntityHeading(vehicle, ldata.spawnpoint.w)
                SetVehicleNumberPlateText(vehicle, "RENT"..tostring(math.random(1000, 9999)))
                TaskWarpPedIntoVehicle(player, vehicle, -1)
                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
                SetVehicleEngineOn(vehicle, true, true)
                SetVehicleDirtLevel(vehicle, 0.0)
                exports[Config.FuelExport]:SetFuel(vehicle, 100)
                SpawnVehicle = vehicle
            end, ldata.spawnpoint, true)
            Wait(1000)
            local vehicle = GetVehiclePedIsIn(player, false)
            local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            vehicleLabel = GetLabelText(vehicleLabel)
            local plate = GetVehicleNumberPlateText(vehicle)
            TriggerServerEvent('qb-rental:server:rentalpapers', plate, vehicleLabel)
        else
            QBCore.Functions.Notify(Lang:t("error.not_enough_money"), "error", 4500)
        end
    end, money, crumbs)
end)

RegisterNetEvent('qb-rental:client:return', function()
    if SpawnVehicle then
        local Player = QBCore.Functions.GetPlayerData()
        local car = GetVehiclePedIsIn(PlayerPedId(),true)
        if car ~= SpawnVehicle or #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(SpawnVehicle)) > 10.0 then QBCore.Functions.Notify('Where is your rented vehicle?', 'error') return end
        QBCore.Functions.Notify(Lang:t("task.veh_returned"), 'success')
        TriggerServerEvent('qb-rental:server:removepapers')
        NetworkFadeOutEntity(car, true,false)
        Citizen.Wait(2000)
        QBCore.Functions.DeleteVehicle(car)
    else
        QBCore.Functions.Notify(Lang:t("error.no_vehicle"), "error")
    end
    SpawnVehicle = false
end)

Citizen.CreateThread(function()
    for _, info in pairs(Config.Blips) do
    info.blip = AddBlipForCoord(info.x, info.y, info.z)
    SetBlipSprite(info.blip, info.id)
    SetBlipDisplay(info.blip, 4)
    SetBlipScale(info.blip, 0.65)
    SetBlipColour(info.blip, info.colour)
    SetBlipAsShortRange(info.blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(info.title)
    EndTextCommandSetBlipName(info.blip)
    end
end)
