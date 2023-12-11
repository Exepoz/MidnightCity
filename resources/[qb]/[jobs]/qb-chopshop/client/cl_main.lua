local QBCore = exports['qb-core']:GetCoreObject()

local active = false

local areaZone = nil
local areaBlip = nil

local dropOffZone = nil
local dropOffBlip = nil
local rejoinBlip = nil

local vehMods = { -- You can add more here
    0, -- Spoiler
    1, -- Front Bumper
    2, -- Rear Bumper
    3, -- Skirt
    4, -- Exhaust
    5, -- Chassis
    6, -- Grill
    7, -- Bonnet
    8, -- Wing L
    9, -- Wing R
    10, -- Roof
    22 -- Xenon Lights
}

--- Functions

--- Alerts the police - Change this to whatever police alert script you use, ProjectSloth qb-dispatch by default
---@param veh object - Vehicle object
---@return nil
local AlertPolice = function(veh)
    if GetResourceState('ps-dispatch') ~= 'started' then return end
    exports['ps-dispatch']:VehicleTheft(veh)
end

--- Creates a randomly off-set blip radius for given coordinates
---@param coords vec3 - Coordinates of a location
---@return blip object - Off-set blip radius
local CreateAreaBlip = function(coords)
    local offsetSign = math.random(-100, 100) / 100
    local blip = AddBlipForRadius(coords.x + (offsetSign * Shared.VehicleBlipOffset), coords.y + (offsetSign * Shared.VehicleBlipOffset), coords.z + (offsetSign * Shared.VehicleBlipOffset), Shared.VehicleBlipRadius)
    SetBlipHighDetail(blip, true)
    SetBlipAlpha(blip, 100)
    SetBlipColour(blip, 1)
    return blip
end

--- Creates a drop-off zone blip for given coordinates
---@param coords vec3 - Coordinates of a location
---@return blip object - blip
local CreateDropOffBlip = function(coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 227)
    SetBlipColour(blip, 2)
    SetBlipScale(blip, 0.80)
    BeginTextCommandSetBlipName('MYBLIP')
    AddTextComponentSubstringPlayerName(Locales['blip_dropoff'])
    EndTextCommandSetBlipName(blip)
    return blip
end

--- Creates a rejoin blip for given coordinates
---@param coords vec3 - Coordinates of a location
---@return blip object - blip
local CreateRejoinBlip = function(coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 227)
    SetBlipColour(blip, 2)
    SetBlipScale(blip, 0.80)
    BeginTextCommandSetBlipName('MYBLIP')
    AddTextComponentSubstringPlayerName(Locales['blip_rejoin'])
    EndTextCommandSetBlipName(blip)
    return blip
end

--- Gives a vehicle random cosmetic upgrades
---@param vehicle object - Vehicle object
---@return nil
local SetRandomCosmetics = function(vehicle)
    -- Colours
    local c1, c2 = math.random(160), math.random(160)
    SetVehicleColours(vehicle, c1, c2)

    -- Cosmetics
    SetVehicleModKit(vehicle, 0)
    for i=1, #vehMods, 1 do
        local modAmount = GetNumVehicleMods(vehicle, vehMods[i])
        local rndm = math.random(modAmount)
        SetVehicleMod(vehicle, vehMods[i], rndm, false)
    end
end

--- Enables upgrades for a specific vehicle
---@param vehicle object - Vehicle object
---@return nil
local EnableUpgrades = function(vehicle)
    SetVehicleModKit(vehicle, 0)
    SetVehicleMod(vehicle, 11, 3, false) -- Engine
    SetVehicleMod(vehicle, 12, 2, false) -- Brakes
    SetVehicleMod(vehicle, 13, 2, false) -- Transmission
    ToggleVehicleMod(vehicle, 18, true) -- Turbo
end

--- Performs the animation of chopping a vehicle and deletes the vehicle
---@param veh object - Vehicle object
---@return nil
local ChopVehicle = function(veh)
    if not DoesEntityExist(veh) then return end

    -- Ped steps out of the vehicle
    local ped = cache.ped
    TaskLeaveVehicle(ped, veh, 258)
    FreezeEntityPosition(veh, true)
    local heading = GetEntityHeading(ped)
    local vehCo = GetEntityCoords(veh, false)
    Wait(1500)

    -- Front Left Door
    if not IsVehicleDoorDamaged(veh, 0) then
        local coords = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, 'door_dside_f'))
        SetVehicleDoorOpen(veh, 0, false, true)
        SetEntityCoords(ped, coords.x, coords.y, coords.z-1.0)
        SetEntityHeading(ped, heading-45.0)
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_WELDING', 0, true)
        Wait(14000)
        SetVehicleDoorBroken(veh, 0, true)
        ClearPedTasks(ped)
    end

    -- Rear Left Door
    if GetVehicleMaxNumberOfPassengers(veh) > 1 and not IsVehicleDoorDamaged(veh, 2) then
        local coords = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, 'door_dside_r'))
        SetVehicleDoorOpen(veh, 2, false, true)
        SetEntityCoords(ped, coords.x, coords.y, coords.z-1.0)
        SetEntityHeading(ped, heading-45.0)
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_WELDING', 0, true)
        Wait(14000)
        SetVehicleDoorBroken(veh, 2, true)
        ClearPedTasks(ped)
    end

    -- Trunk
    if not IsVehicleDoorDamaged(veh, 5) then
        if GetEntityBoneIndexByName(veh, 'boot') ~= -1 then
            local coords = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, 'boot'))
            local offSet = GetOffsetFromEntityInWorldCoords(veh, 0.0, -1.25, 0.0)
            local dif = offSet-vehCo
            local animCo = coords+dif
            SetVehicleDoorOpen(veh, 5, false, true)
            SetEntityCoords(ped, animCo.x, animCo.y, coords.z-1.0)
            SetEntityHeading(ped, heading)
            TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_WELDING', 0, true)
            Wait(14000)
            SetVehicleDoorBroken(veh, 5, true)
            ClearPedTasks(ped)
        end
    end

    -- Rear Right door
    if GetVehicleMaxNumberOfPassengers(veh) > 1 and not IsVehicleDoorDamaged(veh, 3) then
        local coords = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, 'door_pside_r'))
        SetVehicleDoorOpen(veh, 3, false, true)
        SetEntityCoords(ped, coords.x, coords.y, coords.z-1.0)
        SetEntityHeading(ped, heading+45.0)
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_WELDING', 0, true)
        Wait(14000)
        SetVehicleDoorBroken(veh, 3, true)
        ClearPedTasks(ped)
    end

    -- Passenger door
    if not IsVehicleDoorDamaged(veh, 1) then
        SetVehicleDoorOpen(veh, 1, false, true)
        local coords = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, 'door_pside_f'))
        SetEntityCoords(ped, coords.x, coords.y, coords.z-1.0)
        SetEntityHeading(ped, heading+45.0)
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_WELDING', 0, true)
        Wait(14000)
        SetVehicleDoorBroken(veh, 1, true)
        ClearPedTasks(ped)
    end

    -- Bonnet
    if not IsVehicleDoorDamaged(veh, 4) then
        if GetEntityBoneIndexByName(veh, 'boot') ~= -1 then
            SetVehicleDoorOpen(veh, 4, false, true)
            local coords = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, 'boot'))
            SetEntityCoords(ped, coords.x, coords.y, coords.z-1.0)
            SetEntityHeading(ped, heading-180.00+45.0) -- quick mafs
            TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_WELDING', 0, true)
            Wait(14000)
            SetVehicleDoorBroken(veh, 4, true)
            ClearPedTasks(ped)
        end
    end

    -- Front Left Wheel
    if not IsVehicleTyreBurst(veh, 0, true) then
        local coords = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, 'wheel_lf'))
        local offSet = GetOffsetFromEntityInWorldCoords(veh, -1.0, 0.0, 0.0)
        local dif = offSet-vehCo
        local animCo = coords+dif
        SetEntityCoords(ped, animCo.x, animCo.y, coords.z-1.0)
        SetEntityHeading(ped, heading-90.00)
        lib.requestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
        TaskPlayAnim(ped, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', -8.0, -8.0, -1, 1, 0, 0, 0, 0)
        Wait(10000)
        SetVehicleTyreBurst(veh, 0, true, 1000.0)
        StopAnimTask(ped, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 1.5)
    end

    -- Rear Left Wheel
    if not IsVehicleTyreBurst(veh, 4, true) then
        local coords = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, 'wheel_lr'))
        local offSet = GetOffsetFromEntityInWorldCoords(veh, -1.0, 0.0, 0.0)
        local dif = offSet-vehCo
        local animCo = coords+dif
        SetEntityCoords(ped, animCo.x, animCo.y, coords.z-1.0)
        SetEntityHeading(ped, heading-90.00)
        lib.requestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
        TaskPlayAnim(ped, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', -8.0, -8.0, -1, 1, 0, 0, 0, 0)
        Wait(10000)
        SetVehicleTyreBurst(veh, 4, true, 1000.0)
        StopAnimTask(ped, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 1.5)
    end

    -- Rear Right Wheel
    if not IsVehicleTyreBurst(veh, 5, true) then
        local coords = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, 'wheel_rr'))
        local offSet = GetOffsetFromEntityInWorldCoords(veh, 1.0, 0.0, 0.0)
        local dif = offSet-vehCo
        local animCo = coords+dif
        SetEntityCoords(ped, animCo.x, animCo.y, coords.z-1.0)
        SetEntityHeading(ped, heading+90.00)
        lib.requestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
        TaskPlayAnim(ped, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', -8.0, -8.0, -1, 1, 0, 0, 0, 0)
        Wait(10000)
        SetVehicleTyreBurst(veh, 5, true, 1000.0)
        StopAnimTask(ped, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 1.5)
    end

    -- Front Right Wheel
    if not IsVehicleTyreBurst(veh, 1, true) then
        local coords = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, 'wheel_rf'))
        local offSet = GetOffsetFromEntityInWorldCoords(veh, 1.0, 0.0, 0.0)
        local dif = offSet-vehCo
        local animCo = coords+dif
        SetEntityCoords(ped, animCo.x, animCo.y, coords.z-1.0)
        SetEntityHeading(ped, heading+90.00)
        lib.requestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
        TaskPlayAnim(ped, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', -8.0, -8.0, -1, 1, 0, 0, 0, 0)
        Wait(10000)
        SetVehicleTyreBurst(veh, 1, true, 1000.0)
        StopAnimTask(ped, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 1.5)
    end

    -- Finishing up
    local netId = NetworkGetNetworkIdFromEntity(veh)
    TriggerServerEvent('qb-chopshop:server:ChopVehicle', netId)
    Utils.PhoneNotification(Locales['phone_success'], 8000)
    active = false    
end

--- Clears all blips and zones and resets variables
---@return nil
local clearCurrent = function()
    active = false

    if areaZone then
        areaZone:remove()
        areaZone = nil
    end

    if dropOffZone then
        dropOffZone:remove()
        dropOffZone = nil
    end

    if DoesBlipExist(areaBlip) then
        RemoveBlip(areaBlip)
        areaBlip = nil
    end

    if DoesBlipExist(dropOffBlip) then
        RemoveBlip(dropOffBlip)
        dropOffBlip = nil
    end

    if DoesBlipExist(rejoinBlip) then
        RemoveBlip(rejoinBlip)
        rejoinBlip = nil
    end
end

--- Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    lib.callback('qb-chopshop:server:GetContractData', false, function(result)
        if result then
            if Shared.Debug then print('Found Active Contract') end

            if result.state == 0 then
                TriggerEvent('qb-chopshop:client:ReceiveNewContract', result.model, result.plate, result.location, result.dropOff, false)
            else
                TriggerEvent('qb-chopshop:client:ReceiveNewContract', result.model, result.plate, result.vehLoc, result.dropOff, true)
            end
        else
            if Shared.Debug then print('No Active Contract Found') end
        end
    end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    clearCurrent()
end)

RegisterNetEvent('qb-chopshop:client:ReceiveNewContract', function(model, plate, location, dropOffLoc, rejoin)
    if active then return end
    active = true
    
    if Shared.Debug then print('Vehicle Location', location) end

    if rejoin then
        Utils.PhoneNotification(Locales['phone_rejoin'], 60000)
        rejoinBlip = CreateRejoinBlip(location)
    else
        Utils.PhoneNotification(Locales['phone_start'], 60000)
        areaBlip = CreateAreaBlip(location)
        areaZone = lib.zones.sphere({
            coords = location,
            radius = Shared.VehicleZoneRadius,
            debug = Shared.Debug,
            onEnter = function()
                lib.callback('qb-chopshop:server:GetVehicleNetId', false, function(netId)
                    while not NetworkDoesEntityExistWithNetworkId(netId) do Wait(0) end
                    local chopVehicle = NetworkGetEntityFromNetworkId(netId)
                    SetRandomCosmetics(chopVehicle)
                    EnableUpgrades(chopVehicle)

                    -- Destroy Zone
                    areaZone:remove()
                    areaZone = nil

                    -- Notify
                    Utils.PhoneNotification(Locales['phone_find'], 60000)
                end)
            end,
        })
    end

    -- Wait until car found
    local madeDropOffZone = false
    while not madeDropOffZone and active do
        Wait(1000)
        local veh = cache.vehicle
        if veh and GetVehicleNumberPlateText(veh) == plate then
            exports[Shared.FuelScript]:SetFuel(veh, Shared.FuelAmount)
            AlertPolice(veh)
            Utils.PhoneNotification(Locales['phone_drop'], 60000)
            RemoveBlip(areaBlip)
            areaBlip = nil
            madeDropOffZone = true

            if DoesBlipExist(rejoinBlip) then
                RemoveBlip(rejoinBlip)
                rejoinBlip = nil
            end
        end
    end

    -- Drop-off Zone
    if not active then return end
    local inZone = false
    dropOffBlip = CreateDropOffBlip(dropOffLoc)
    dropOffZone = lib.zones.sphere({
        coords = dropOffLoc,
        radius = Shared.DropoffZoneRadius,
        debug = Shared.Debug,
        inside = function()
            if IsControlJustPressed(0, 38) and cache.vehicle and GetVehicleNumberPlateText(cache.vehicle) == plate then
                dropOffZone:remove()
                dropOffZone = nil
                RemoveBlip(dropOffBlip)
                dropOffBlip = nil
                lib.hideTextUI()
                ChopVehicle(cache.vehicle)
            end
        end,
        onEnter = function()
            if cache.vehicle and GetVehicleNumberPlateText(cache.vehicle) == plate then
                Utils.PhoneNotification(Locales['phone_chop'], 10000)
                lib.showTextUI(Locales['text_ui'], {
                    position = "left-center",
                    icon = 'box-open',
                    style = {
                        borderRadius = 1,
                        color = 'white'
                    }
                })
            end
        end,
        onExit = function()
            lib.hideTextUI()
        end
    })
end)

RegisterNetEvent('qb-chopshop:client:CancelJob', function()
    clearCurrent()
    TriggerServerEvent('qb-chopshop:server:CancelJob')
end)

--- Threads

CreateThread(function()
    -- Starter Ped
    local pedModel = `ig_josef`
    lib.requestModel(pedModel)

    local ped = CreatePed(0, pedModel, Shared.StartLocation.x, Shared.StartLocation.y, Shared.StartLocation.z - 1.0, Shared.StartLocation.w, false, false)
    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CLIPBOARD', true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    -- Target
    if Shared.Target == 'ox' then
        exports['ox_target']:addLocalEntity(ped, {
            {
                label = Locales['target_start'],
                name = 'chopshop_start',
                icon = 'fas fa-user-secret',
                distance = 1.0,
                serverEvent = 'qb-chopshop:server:RequestContract',
            },
            {
                label = Locales['target_stop'],
                name = 'chopshop_stop',
                icon = 'fas fa-ban',
                distance = 1.0,
                event = 'qb-chopshop:client:CancelJob',
                canInteract = function(entity)
                    return active
                end
            },
        })
    elseif Shared.Target == 'qb' then
        exports['qb-target']:AddTargetEntity(ped, {
            options = {
                {
                    type = 'server',
                    event = 'qb-chopshop:server:RequestContract',
                    icon = 'fas fa-user-secret',
                    label = Locales['target_start']
                },
                {
                    type = 'client',
                    event = 'qb-chopshop:client:CancelJob',
                    icon = 'fas fa-ban',
                    label = Locales['target_stop'],
                    canInteract = function()
                        return active
                    end
                }
            },
            distance = 1.0
        })
    end
end)
