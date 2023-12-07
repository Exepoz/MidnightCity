local QBCore = exports['qb-core']:GetCoreObject()

local crusherSetup = false
local scrapyard = lib.points.new(vector3(-532.30, -1720.7, 19.36), 30)
function scrapyard:onEnter()
    if crusherSetup then return end
    crusherSetup = true
    SetupCrushingStation()
end

RegisterNetEvent('carcrushing:client:checkvin', function()
    local entity = PlayerPedId()
    local veh = QBCore.Functions.GetClosestVehicle(GetEntityCoords(entity))
    local plate = QBCore.Functions.GetPlate(veh)
    QBCore.Functions.TriggerCallback('carcrushing:server:checkvin', function(isScratched)
        if isScratched == 1 then QBCore.Functions.Notify("The Vin Number appears to have been scratched off!", "error")
        else QBCore.Functions.Notify("The Vin Number appears to be valid.", "success") end
    end, plate)
end)

function CrushOwnCar(veh, plate)
    local model = GetEntityModel(veh)
    local allCars = QBCore.Shared.Vehicles
    if allCars then for k,v in pairs(allCars) do print(model, v.model, tonumber(v.price)) if model == GetHashKey(string.lower(v.model)) and tonumber(v.price) < 10000 then
        QBCore.Functions.Notify("You can\'t crush this vehicle.. It\'s too cheap!", "error")
        return end
    end end
    local alert = lib.alertDialog({
        header = 'CAREFUL!',
        content = 'By crushing your car down, you will lose it, FOREVER! This is irrevirsible!\n Press Confirm to continue.',
        centered = true,
        cancel = true
    })
    if alert == "confirm" then
        local confirmation = lib.alertDialog({
            header = 'LAST WARNING!',
            content = 'Are you certain you want to destroy your car in exchange of materials?\n You will lose your car FOREVER.\nPress Confirm to continue.',
            centered = true,
            cancel = true
        })
        if confirmation == "confirm" then
            SetEntityCoords(veh, -526.78, -1726.31, 19.51, 0, 0, 0)
            SetEntityHeading(veh, 51.34)
            FreezeEntityPosition(veh, true)
            QBCore.Functions.Progressbar('carcrushing', 'Crushing Down your Car...', 30000, false, false, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = false,
            }, {}, {}, {}, function()
                local class = GetVehicleClass(veh)
                TriggerServerEvent('carcrushing:server:CrushOwnCar', plate, class)
                DeleteEntity(veh)
            end)
        end
    end
end

function CrushVinScratch(veh, plate)
    local alert = lib.alertDialog({
        header = 'CAREFUL!',
        content = 'You\'re about to crush a vehicle without a Vin Number. This car will be destroyed FOREVER! Press Confirm to Continue',
        centered = true,
        cancel = true
    })
    if alert == "confirm" then
        local confirmation = lib.alertDialog({
            header = 'LAST WARNING!',
            content = 'Are you certain you want to destroy this car?\n The vehicle\'s owner will lose this car FOREVER. \n Press Confirm to continue.',
            centered = true,
            cancel = true
        })
        if confirmation == "confirm" then
            SetEntityCoords(veh, -526.78, -1726.31, 19.51, 0, 0, 0)
            SetEntityHeading(veh, 51.34)
            FreezeEntityPosition(veh, true)
            QBCore.Functions.Progressbar('carcrushing', 'Crushing Down Vehicle...', 30000, false, false, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = false,
            }, {}, {}, {}, function()
                TriggerServerEvent('carcrushing:server:CrushVinscratched', plate)
                DeleteEntity(veh)
            end)
        end
    end
end

function SetupCrushingStation()
    print("setting up crusher")
    QBCore.Functions.LoadModel('h4_prop_h4_lever_box_01a')
    local obj = CreateObject(162166615, -532.30, -1720.7, 19.36, 0, 0, 0)
    SetEntityHeading(obj, 145.0)
    FreezeEntityPosition(obj, true)
    exports['qb-target']:AddTargetEntity(obj, {options = {{icon = 'fas fa-car-crash', label = "Crush Car",
    action = function(entity)
        local pcoords = GetEntityCoords(entity)
        local veh = QBCore.Functions.GetClosestVehicle(pcoords)
        if #(pcoords - GetEntityCoords(veh)) > 10 then QBCore.Functions.Notify("There is no car closeby.", "error") return end
        local plate = QBCore.Functions.GetPlate(veh)
        QBCore.Functions.TriggerCallback('carcrushing:server:checkownership', function(isOwned)
            if isOwned then CrushOwnCar(veh, plate)
            else local pData = QBCore.Functions.GetPlayerData()
                if pData.job.name ~= "police" then QBCore.Functions.Notify("You do not own this vehicle.", "error") return end
                if not pData.job.onduty then QBCore.Functions.Notify("You have no reason to do this.", "error") return end
                QBCore.Functions.TriggerCallback('carcrushing:server:checkvin', function(isScratched)
                    if isScratched == 1 then CrushVinScratch(veh, plate)
                    else QBCore.Functions.Notify("You have no reason to do this.", "error") end
                end, plate)
            end
        end, plate)
    end}}, distance = 1.0})
end