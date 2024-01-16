local QBCore = exports['qb-core']:GetCoreObject()

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

function LoadModel(hash)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(10)
    end
end

-- Puts player back in queue after disconnect
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() Wait(5000) TriggerServerEvent('cr-armoredtrucks:server:ReviveQueue') end)

-- Deestroys zones on startup (If restarted)
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then

    end
end)

--todo
RegisterNetEvent('cr-armoredtrucks:client:Clean', function ()
    QBCore.Functions.DeleteVehicle(Truck)
    MW_CanLoot, MW_Bombplanted = false, false

    BodySearched = false
    CanLoot = false
    TruckThermited = false
    GuardAlerted = false
    MeetLocationBlip = nil
    FleecaGuard = nil
    FleecaGuardBlip = nil
    FleecaGuardLocation = nil
    TruckZoneBlip = nil
    Driver = nil
    CoPilot = nil
    TruckBlip = nil
    ThermiteProp = nil
end)

-- Call Cops
function Dispatch() exports['ps-dispatch']:BankTruckRobbery() end

-------------------
-- Xora Additions
-------------------
RegisterNetEvent('cr-armoredtrucks:client:disabletruck', function()
    if Truck and DoesEntityExist(Truck) then
        SetVehicleEngineHealth(Truck, 0)
        SetVehicleMaxSpeed(Truck, 0)
    end
    if DeliveryTruck and DoesEntityExist(DeliveryTruck) then
        SetVehicleEngineHealth(DeliveryTruck, 0)
        SetVehicleMaxSpeed(DeliveryTruck, 0)
    end
end)

RegisterNetEvent('cr-armoredtrucks:client:get10100Room', function() SetNewWaypoint(569.63, -3126.75) end)

-------------
-- Targets --
-------------



-------------
-- Syncing --
-------------

-- Commands
if Config.Debug then
    RegisterCommand('gmbills', function(_, args) TriggerServerEvent('mb-t', args[1]) end)
    RegisterCommand('TruckStart', function() TriggerEvent('cr-armoredtrucks:client:StartDelivery') end)
    RegisterCommand('TruckQueue', function() TriggerEvent('cr-armoredtrucks:client:GetInQueue') end)
    RegisterCommand('testpayout', function() TriggerServerEvent('cr-armoredtrucks:server:DeliveryPayouts') end)
    RegisterCommand('convoytest', function() TriggerEvent('cr-armoredtrucks:client:GetTruckLocation') end)
    RegisterCommand('wep', function() local ped = PlayerPedId() GiveWeaponToPed(ped, Config.GuardWeapon, 300, false, true) end)
    RegisterCommand('sendfax', function() TriggerEvent('cr-armoredtrucks:client:ExoCompleted') end)
    RegisterCommand('exosays', function() TriggerServerEvent('cr-armoredtrucks:server:PlayExoSays') end)
end

-- RegisterNetEvent('cr-armoredtrucks:client:searchBody', function() SearchAnim() Wait(1000) TriggerServerEvent('cr-armoredtrucks:server:grabkeys') end)

-- function SearchAnim()
--     local ped = PlayerPedId()
--     SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
--     Wait(2500)
--     LoadAnimDict('amb@medic@standing@kneel@base')
--     LoadAnimDict('anim@gangops@facility@servers@bodysearch@')
--     TaskPlayAnim(ped, "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
--     TaskPlayAnim(ped, "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 49, 0, false, false, false )
--     Wait(5000) ClearPedTasks(ped)
-- end

-- exports['qb-target']:AddBoxZone("bobcatcomputer", vector3(873.46, -2126.92, 31.23), 0.3, 1, { name="bobcatcomputer", heading = 336, debugPoly = false, minZ = 31.23, 31.83, },
-- { options = { { event = "cr-armoredtrucks:client:hackcomputer", icon = "fas fa-bug", label = "Hack System" }, }, distance = 2 })

-- RegisterNetEvent('cr-armoredtrucks:client:hackcomputer', function()
--     if QBCore.Functions.HasItem('uhackingdevice') then
--         local ped = PlayerPedId()
--         -- add texting animaiton
--         TriggerEvent("mhacking:show")
--         TriggerEvent("mhacking:start", 3, 12, function(success)
--             TriggerEvent('mhacking:hide')
--             ClearPedTasks(ped)
--             if success then TriggerServerEvent('cr-armoredtrucks:server:bobcatHack') end
--         end)
--     end
-- end)