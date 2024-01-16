local QBCore = exports['qb-core']:GetCoreObject()

local DropBlip = nil
local TruckArea = nil
local TruckThermited = false
local CanLoot = false
local TruckZone = nil
local BackDoorPoint = nil
local SignalTruck

Citizen.CreateThread(function()
    exports.ox_target:addSphereZone({coords = vector3(-607, -1625, 33), radius = 0.5, debug = Config.Debug, drawSprite = true,
    options = {{label = 'Connect Device', icon = 'fas fa-microchip', onSelect = function()
        QBCore.Functions.TriggerCallback('cr-armoredtrucks:canStartSignalHeist', function(canDo)
            if not canDo then return end
            local ped = PlayerPedId()
            TaskTurnPedToFaceCoord(ped, -607, -1625, 33, 1500) Wait(1500)
            QBCore.Functions.Progressbar("pingingTruck", 'Locating Truck...', 1000, false, true,
            { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
            { animDict = 'mp_prison_break', anim = 'hack_loop', flags = 33}, {}, {}, function()
                if GlobalState.HeistInProgress then QBCore.Functions.Notify('The signal has been lost...', 'error') return end

                local sdata =  {width = 20, difficultyFactor = 0.98, lineSpeedUp = 1, time = 30, halfSuccessMin = 100,
                valueUpSpeed = 0.4, valueDownSpeed = 0.4, areaMoveSpeed = 0.6, img = "img/antenna.webp"}

                exports['nakres_skill']:GetMiniGame().Start(sdata, {
                    controlDisables = { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
                    animation = { animDict = 'mp_prison_break', anim = 'hack_loop', flags = 33}
                }, function(progress)
                    if progress ~= 100 then QBCore.Functions.Notify('The signal has been lost...', 'error') return end
                    ClearPedTasks(ped)
                    Wait(1000) TriggerServerEvent('cr-armoredtrucks:server:startSignal')
                end)
            end, function()
                Wait(1000) exports['rpemotes']:EmoteCancel()
            end,"fas fa-boxes-stacked")
        end)
    end}}})

end)

--- Function to check if player is wearing gloves or not
---@return boolean - Is the player wearing gloves?
function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true

    if model == 'mp_m_freemode_01' then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

RegisterNetEvent('cr-armoredtrucks:client:GetInQueue', function() TriggerServerEvent('cr-armoredtrucks:server:GetInQueue') end)
RegisterNetEvent('cr-armoredtrucks:client:acceptTruck', function() TriggerServerEvent('cr-armoredtrucks:server:AcceptTruck') end)
RegisterNetEvent('cr-armoredtrucks:client:towerZones', function() end)


RegisterNetEvent('cr-armoredtrucks:client:connectToTower', function(precision, tower)
    exports['rpemotes']:EmoteCommandStart('phone')
    QBCore.Functions.Progressbar("pingingTruck", 'Locating Truck...', 7500, false, true,
    { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
    {}, {}, {}, function()
        local diff = 0.4 - (0.05 * precision)
        local w = 20 - 1.5*precision
        local sdata =  {width = w, difficultyFactor = 0.98, lineSpeedUp = 1, time = 30, halfSuccessMin = 100,
        valueUpSpeed = diff, valueDownSpeed = diff, areaMoveSpeed = 0.6, img = "img/antenna.webp"}
        exports['rpemotes']:EmoteCancel()
        Wait(1000)
        exports['nakres_skill']:GetMiniGame().Start(sdata, {
            controlDisables = { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
            --animation = { task = 'WORLD_HUMAN_STAND_MOBILE'}
        }, function(progress)
            if progress ~= 100 then QBCore.Functions.Notify('You failed to lock on the signal...', 'error') return end
            ClearPedTasks(ped) Wait(1000) TriggerServerEvent('cr-armoredtrucks:server:precisionDone', tower)
        end)

    end, function()
        Wait(1000) exports['rpemotes']:EmoteCancel()
    end,"fas fa-boxes-stacked")
end)

-- Receive Truck Location
RegisterNetEvent('cr-armoredtrucks:client:prepTruck', function(loc)
    local TruckPos = loc
    if Config.Debug then SetNewWaypoint(TruckPos.x, TruckPos.y) end
    TruckZone = lib.points.new(TruckPos, 100.0)
    local foundTruck = lib.points.new(TruckPos, 10.0)
    function foundTruck:onEnter()
        if GlobalState['SignalTruck:foundTruck'] then self:remove() return end
        TriggerServerEvent('cr-armoredtrucks:server:foundSignalTruck', loc)
    end
    function TruckZone:onEnter()
        if GlobalState['SignalTruck:foundTruck'] or GlobalState['SignalTruck:truckSpawned'] then return end
        QBCore.Functions.TriggerCallback('cr-armoredtrucks:signalTimeout', function(netVeh)
            if not netVeh then
                QBCore.Functions.Notify('You took too long... The truck is gone..')
                if SignalTruck then TriggerEvent('cr-armoredtrucks:client:Clean') end
                TruckZone:remove() TruckZone = nil
                RemoveBlip(TruckArea)
            else
                local veh = NetworkGetEntityFromNetworkId(netVeh)
                SetVehicleUndriveable(veh, true)
                FreezeEntityPosition(veh, true)
                local coords = GetOffsetFromEntityInWorldCoords(veh, 0, -3.0, 0)
                TriggerServerEvent('cr-armoredtrucks:server:doDoorPoint', coords, netVeh)
            end
        end, loc)
    end
end)

-- Receive Back Door Location
RegisterNetEvent('cr-armoredtrucks:client:doDoorPoint', function(coords, truck)
    SignalTruck = NetworkGetEntityFromNetworkId(truck)
    BackDoorPoint = lib.points.new(coords, 1.5)
    function BackDoorPoint:onEnter() if not GlobalState['SignalTruck:thermited'] then exports['qb-core']:DrawText('[E] Plant Thermite') end end
    function BackDoorPoint:nearby()
        if IsControlJustPressed(0, 38) then
            if not GlobalState['SignalTruck:thermited'] then
                exports['qb-core']:HideText() TriggerEvent('cr-armoredtrucks:client:PlantSignalThermite')
            end
        end
    end
    function BackDoorPoint:onExit() exports['qb-core']:HideText() end
end)

RegisterNetEvent('cr-armoredtrucks:client:PlantSignalThermite', function ()
    if IsVehicleStopped(SignalTruck) and not IsEntityInWater(SignalTruck) then
        RemoveBlip(TruckArea)
        if TruckZone then TruckZone:remove() TruckZone = nil end
        if QBCore.Functions.HasItem(Config.Delivery.ThermiteItem) then
            TriggerServerEvent('cr-armoredtrucks:server:thermTruck', true)
            local ped = PlayerPedId()
            SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
            RequestAnimDict('anim@heists@ornate_bank@thermal_charge_heels')
            while not HasAnimDictLoaded('anim@heists@ornate_bank@thermal_charge_heels') do Wait(50) end
                Dispatch()
                TriggerServerEvent("cr-armoredtrucks:server:remThermite")
                local diff = Config.Delivery.ThermiteHack
                exports['memorygame']:thermiteminigame(diff.CorrectBlocks, diff.IncorrectBlocks, diff.TimeToShow, diff.TimeToLose, function()
                    if BackDoorPoint then BackDoorPoint:remove() BackDoorPoint = nil end
                    local loc = GetOffsetFromEntityInWorldCoords(SignalTruck, 0.0, -3.58, 0.5)
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
                    SetVehicleDoorBroken(SignalTruck, 2, false)
                    SetVehicleDoorBroken(SignalTruck, 3, false)
                    local FleecaTruckCoords = GetEntityCoords(SignalTruck)
                    ApplyForceToEntity(SignalTruck, 0, FleecaTruckCoords.x, FleecaTruckCoords.y, FleecaTruckCoords.z, 0.0, 0.08, 0.0, 1, false,true, true, true, true)
                    CanLoot = true
                    BackDoorPoint = lib.points.new(GetOffsetFromEntityInWorldCoords(SignalTruck, 0, -3.0, 0), 1.5)
                    function BackDoorPoint:onEnter() exports['qb-core']:DrawText('[E] Grab Loot') end
                    function BackDoorPoint:nearby()
                        if CanLoot then if IsControlJustPressed(0, 38) then exports['qb-core']:HideText() TriggerEvent('cr-armoredtrucks:client:GraSignalLoot') end end
                    end
                    function BackDoorPoint:onExit() exports['qb-core']:HideText() end
                end, function()
                    ClearPedTasks(ped)
                    TriggerServerEvent('cr-armoredtrucks:server:thermTruck', false)
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

RegisterNetEvent('cr-armoredtrucks:client:GraSignalLoot', function ()
    CanLoot = false
    local ped = PlayerPedId()
    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
    if BackDoorPoint then BackDoorPoint:remove() BackDoorPoint = nil end
    ClearPedTasks(ped)
    Wait(1500)
    QBCore.Functions.Progressbar("start_looting", 'Looting', 10000, false, true,
    { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
    { animDict = "anim@heists@ornate_bank@grab_cash_heels", anim = "grab", flags = 49},
    { model = "prop_cs_heist_bag_02", bone = 57005, coords = { x = -0.004, y = 0.00, z = -0.14 }, rotation = { x = 235.0, y = -25.0, z = 0.0 }},
    {}, function()
        CanLoot = false
        TriggerServerEvent('cr-armoredtrucks:server:SignalPayouts')
        if not IsWearingHandshoes() then TriggerServerEvent("evidence:server:CreateFingerDrop", GetEntityCoords(ped)) end
    end, function()
        CanLoot = true
        QBCore.Functions.Notify("Cancelled", 'error')
    end,"fas fa-boxes-stacked")
end)

RegisterNetEvent('cr-armoredtrucks:client:Clean', function ()
    if DoesEntityExist(SignalTruck) then QBCore.Functions.DeleteVehicle(SignalTruck) end
    SignalTruck = nil
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
