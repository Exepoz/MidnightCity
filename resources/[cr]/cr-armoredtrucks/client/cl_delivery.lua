local QBCore = exports['qb-core']:GetCoreObject()

local DropBlip = nil
local TruckArea = nil
local TruckThermited = false
local CanLoot = false
local TruckZone = nil
local BackDoorPoint = nil

RegisterNetEvent('cr-armoredtrucks:client:GetInQueue', function() TriggerServerEvent('cr-armoredtrucks:server:GetInQueue') end)
RegisterNetEvent('cr-armoredtrucks:client:acceptTruck', function() TriggerServerEvent('cr-armoredtrucks:server:AcceptTruck') end)

RegisterNetEvent('cr-armoredtrucks:client:locatingBankTruck', function(item)
    exports['rpemotes']:EmoteCommandStart('texting')
    Wait(1000)
    exports["glow_minigames"]:StartMinigame(function(success)
        Wait(1000) exports['rpemotes']:CancelEmote()
        TriggerServerEvent('cr-armoredtrucks:server:startParkedTruck', success, item)
    end, "path", {gridSize = 15, lives = 3, timeLimit = 10000})
end)

-- Receive Truck Location
RegisterNetEvent('cr-armoredtrucks:client:StartDelivery', function(loc)
    local TruckPos = loc
    if Config.Debug then SetNewWaypoint(TruckPos.x, TruckPos.y) end
    TruckArea = AddBlipForRadius(TruckPos.x + math.random(-100, 100), TruckPos.y + math.random(-100, 100), TruckPos.z, 300.0)
    SetBlipColour(TruckArea, 72)
    TriggerServerEvent('cr-armoredtrucks:setPlayer')
    TruckZone = lib.points.new(TruckPos, 100.0)
    function TruckZone:onEnter()
        QBCore.Functions.TriggerCallback('cr-armoredtrucks:timeout', function(timeout)
            if timeout then
                QBCore.Functions.Notify('You took too long... The truck is gone..')
                if DeliveryTruck then TriggerEvent('cr-armoredtrucks:client:Clean') end
                TruckZone:remove() TruckZone = nil
                RemoveBlip(TruckArea)
            elseif not DeliveryTruck then
                QBCore.Functions.LoadModel("stockade")
                --local TruckPos = GlobalState.TruckDelivery.Pos
                DeliveryTruck = CreateVehicle("stockade", TruckPos.x, TruckPos.y, TruckPos.z, TruckPos.w, true, true)
                Entity(DeliveryTruck).state.isBankTruck = true
                SetEntityAsMissionEntity(DeliveryTruck, true)
                --local vehID = VehToNet(DeliveryTruck)
                --TriggerServerEvent('cr-armoredtrucks:TruckID', vehID)
                SetVehicleUndriveable(DeliveryTruck, true)
                FreezeEntityPosition(DeliveryTruck, true)
                -- SetEntityDistanceCullingRadius(DeliveryTruck, 1000.0)
                local coords = GetOffsetFromEntityInWorldCoords(DeliveryTruck, 0, -3.0, 0)
                BackDoorPoint = lib.points.new(coords, 1.5)
                function BackDoorPoint:onEnter() exports['qb-core']:DrawText('[E] Plant Thermite') end
                function BackDoorPoint:nearby()
                    if not TruckThermited then if IsControlJustPressed(0, 38) then exports['qb-core']:HideText() TriggerEvent('cr-armoredtrucks:client:PlantDelThermite') end end
                end
                function BackDoorPoint:onExit() exports['qb-core']:HideText() end
                -- local FleecaTruckBones = {'seat_dside_r', 'seat_pside_r'}
                -- exports['qb-target']:AddTargetBone(FleecaTruckBones, {
                --     options = {
                --         { type = "client", icon = 'fas fa-bomb', label = 'Plant Explosives', event = 'cr-armoredtrucks:client:PlantDelThermite', canInteract = function(entity, distance, data) if Entity(entity).state.isBankTruck and not TruckThermited then return true end return false end},
                --         { type = "client", icon = 'fas fa-money-bill-1-wave', label = 'Grab Loot', event = 'cr-armoredtrucks:client:GrabDelLoot', canInteract = function(entity, distance, data) if Entity(entity).state.isBankTruck and CanLoot then return true end return false end}
                --     }, distance = 1.5})
            end
        end)
    end
end)

RegisterNetEvent('cr-armoredtrucks:client:PlantDelThermite', function ()
    if IsVehicleStopped(DeliveryTruck) and not IsEntityInWater(DeliveryTruck) then
        RemoveBlip(TruckArea)
        TriggerServerEvent('cr-armoredtrucks:server:foundTruck')
        if TruckZone then TruckZone:remove() TruckZone = nil end
        if QBCore.Functions.HasItem(Config.Delivery.ThermiteItem) then
            local ped = PlayerPedId()
            TruckThermited = true
            SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
            RequestAnimDict('anim@heists@ornate_bank@thermal_charge_heels')
            while not HasAnimDictLoaded('anim@heists@ornate_bank@thermal_charge_heels') do Wait(50) end
                Dispatch()
                TriggerServerEvent("QBCore:Server:RemoveItem", Config.Delivery.ThermiteItem, 1)
                TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[Config.Delivery.ThermiteItem], "remove")
                local diff = Config.Delivery.ThermiteHack
                exports['memorygame']:thermiteminigame(diff.CorrectBlocks, diff.IncorrectBlocks, diff.TimeToShow, diff.TimeToLose, function()
                    if BackDoorPoint then BackDoorPoint:remove() BackDoorPoint = nil end
                    local loc = GetOffsetFromEntityInWorldCoords(DeliveryTruck, 0.0, -3.58, 0.5)
                    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(ped)))
                    local bagscene = NetworkCreateSynchronisedScene(loc.x, loc.y, loc.z, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)
                    local bag = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), loc.x, loc.y, loc.z,  true,  true, false)
                    SetEntityCollision(bag, false, true)
                    NetworkAddPedToSynchronisedScene(ped, bagscene, 'anim@heists@ornate_bank@thermal_charge', 'thermal_charge', 1.5, -4.0, 1, 16, 1148846080, 0)
                    NetworkAddEntityToSynchronisedScene(bag, bagscene, 'anim@heists@ornate_bank@thermal_charge', 'bag_thermal_charge', 4.0, -8.0, 1)
                    NetworkStartSynchronisedScene(bagscene)
                    Wait(1500)
                    local x, y, z = table.unpack(GetEntityCoords(ped))
                    local thermal_charge = CreateObject(GetHashKey('hei_prop_heist_thermite'), x, y, z + 0.2,  true,  true, true)

                    SetEntityCollision(thermal_charge, false, true)
                    AttachEntityToEntity(thermal_charge, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
                    Wait(4000)

                    DetachEntity(thermal_charge, 1, 1)
                    FreezeEntityPosition(thermal_charge, true)
                    Wait(100)
                    DeleteObject(bag)
                    ClearPedTasks(ped)

                    Wait(100)
                    local termcoords = GetEntityCoords(thermal_charge)
                    ptfx = vector3(termcoords.x, termcoords.y + 1.0, termcoords.z)
                    TriggerServerEvent('cr-armoredtrucks:server:LoopFx', ptfx)
                    Wait(91000)
                    DeleteObject(thermal_charge)
                    SetVehicleDoorBroken(DeliveryTruck, 2, false)
                    SetVehicleDoorBroken(DeliveryTruck, 3, false)
                    local FleecaTruckCoords = GetEntityCoords(DeliveryTruck)
                    ApplyForceToEntity(DeliveryTruck, 0, FleecaTruckCoords.x, FleecaTruckCoords.y, FleecaTruckCoords.z, 0.0, 0.08, 0.0, 1, false,true, true, true, true)
                    CanLoot = true
                    BackDoorPoint = lib.points.new(GetOffsetFromEntityInWorldCoords(DeliveryTruck, 0, -3.0, 0), 1.5)
                    function BackDoorPoint:onEnter() exports['qb-core']:DrawText('[E] Grab Loot') end
                    function BackDoorPoint:nearby()
                        if CanLoot then if IsControlJustPressed(0, 38) then exports['qb-core']:HideText() TriggerEvent('cr-armoredtrucks:client:GrabDelLoot') end end
                    end
                    function BackDoorPoint:onExit() exports['qb-core']:HideText() end
                end, function()
                    TruckThermited = false
                    ClearPedTasks(ped)
                    QBCore.Functions.Notify("Failed to arm the device...", 'error')
                end)
        else
            NeedAccess2 = true
            QBCore.Functions.Notify("You need something to melt through these doors...", 'error')
        end
    end
end)

RegisterNetEvent('cr-armoredtrucks:client:LoopFx', function(coords)
    local pCoords = GetEntityCoords(PlayerPedId())
    if #(pCoords - coords) < 500 then
        RequestNamedPtfxAsset('scr_ornate_heist')
        while not HasNamedPtfxAssetLoaded('scr_ornate_heist') do
            Wait(1)
        end
        SetPtfxAssetNextCall('scr_ornate_heist')
        local effect = StartParticleFxLoopedAtCoord('scr_heist_ornate_thermal_burn', coords, 0, 0, 0, 0x3F800000, 0, 0, 0, 0)
        Wait(90000)
        StopParticleFxLooped(effect, 0)
        RemoveNamedPtfxAsset("scr_ornate_heist")
    end
end)

RegisterNetEvent('cr-armoredtrucks:client:GrabDelLoot', function ()
    CanLoot = false
    SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
    if BackDoorPoint then BackDoorPoint:remove() BackDoorPoint = nil end
    ClearPedTasks(PlayerPedId())
    Wait(1500)
    QBCore.Functions.Progressbar("start_looting", 'Looting', 10000, false, true,
    { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
    { animDict = "anim@heists@ornate_bank@grab_cash_heels", anim = "grab", flags = 49},
    { model = "prop_cs_heist_bag_02", bone = 57005, coords = { x = -0.004, y = 0.00, z = -0.14 }, rotation = { x = 235.0, y = -25.0, z = 0.0 }},
    {}, function()
        CanLoot = false
        TriggerServerEvent('cr-armoredtrucks:server:DeliveryPayouts')
    end, function()
        CanLoot = true
        QBCore.Functions.Notify("Cancelled", 'error')
    end,"fas fa-boxes-stacked")
end)

RegisterNetEvent('cr-armoredtrucks:client:Clean', function ()
    if DoesEntityExist(DeliveryTruck) then QBCore.Functions.DeleteVehicle(DeliveryTruck) end
    DeliveryTruck = nil
    if BackDoorPoint then BackDoorPoint:remove() BackDoorPoint = nil end
    if TruckZone then TruckZone:remove() TruckZone = nil end
    RemoveBlip(DropBlip)
    RemoveBlip(TruckArea)
    TruckSpawn = false
    GotLocation = false
    DropBlip = nil
    TruckArea = nil
    DropLocation = vector3(0.0, 0.0, 0.0)
end)
