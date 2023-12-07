if not Shared.Enable.Cornerselling then return end

local isCornerSelling = false
local corneringZone = nil
local isSelling = false
local currentCornerPed = nil

--- Functions

--- Method to create new peds to corner sell to, peds are spawned on the sidewalk and interactable with through qb-target
--- @param centerCoords vector3 - Center location of where to spawn peds in a radius in
--- @return nil
local createNewCornerPed = function(centerCoords)
    local radius = Shared.CornerSellZoneRadius + 20.0
    local offSetX = math.random(-radius, radius)
	local offSetY = math.random(-radius, radius)
    local retval, outPosition = GetSafeCoordForPed(centerCoords.x + offSetX, centerCoords.y, centerCoords.z, true, 1)
    if retval ~= 1 then return end
    local pedModel = Shared.CornerSellPeds[#Shared.CornerSellPeds]
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do Wait(0) end
    local ped = CreatePed(0, pedModel, outPosition.x, outPosition.y, outPosition.z - 1.0, 0.0, true, false)
    
    if math.random(100) <= Shared.CornerSellSuccessChance and not currentCornerPed then
        currentCornerPed = ped
        SetPedKeepTask(ped, false)
        TaskSetBlockingOfNonTemporaryEvents(ped, false)
        TaskGoStraightToCoord(ped, GetEntityCoords(PlayerPedId()), 1.2, -1, 0.0, 0.0)
        exports['qb-target']:AddTargetEntity(ped, {
            options = {
                {
                    type = 'client',
                    event = 'qb-drugsystem:client:CornerSellToPed',
                    icon = 'fas fa-comment-dollar',
                    label = _U('cornersell_sellto'),
                    canInteract = function(entity, distance, data)
                        return isCornerSelling and not IsEntityDead(entity)
                    end
                }
            },
            distance = 1.5,
        })
    else
        SetPedKeepTask(ped, false)
        TaskSetBlockingOfNonTemporaryEvents(ped, false)
        TaskWanderStandard(ped, 10.0, 10)
        SetPedAsNoLongerNeeded(ped)
        Wait(20000)
        if #(GetEntityCoords(ped) - centerCoords) < 15.0 then Wait(20000) end
        DeletePed(ped)
    end
end

--- Events

RegisterNetEvent('qb-drugsystem:client:StartCornerSell', function(data)
    if isCornerSelling then return end
    isCornerSelling = true
    local vehicle = data.entity
    local vehCoords = GetEntityCoords(vehicle)
    SetVehicleDoorOpen(vehicle, 5, false, false)
    QBCore.Functions.Notify(_U('started_cornering'), 'primary', 2500)
    corneringZone = CircleZone:Create(vehCoords, Shared.CornerSellZoneRadius, { name = 'cornering_zone', debugPoly = Shared.Debug })
    corneringZone:onPlayerInOut(function(isPointInside, point)
        if not isPointInside then
            QBCore.Functions.Notify(_U('moved_too_far'), 'primary', 2500)
            corneringZone:destroy()
            isCornerSelling = false
            if currentCornerPed then
                SetPedKeepTask(currentCornerPed, false)
                TaskSetBlockingOfNonTemporaryEvents(currentCornerPed, false)
                TaskWanderStandard(currentCornerPed, 10.0, 10)
                SetPedAsNoLongerNeeded(currentCornerPed)
                Wait(20000)
                DeletePed(currentCornerPed)
                currentCornerPed = nil
            end
        end
    end)

    Wait(Shared.CornerSellPedInterval * 1000)
    while isCornerSelling do
        QBCore.Functions.TriggerCallback('qb-drugsystem:server:GetCopCount', function(copCount)
            if copCount >= Shared.CornerSellingCops then
                createNewCornerPed(vehCoords)
            else
                corneringZone:destroy()
                isCornerSelling = false
                QBCore.Functions.Notify(_U('not_enough_cops'), 'error', 2500)
            end
        end)
        Wait(Shared.CornerSellPedInterval * 1000)
    end
end)

RegisterNetEvent('qb-drugsystem:client:StopCornerSell', function(data)
    if not isCornerSelling then return end
    QBCore.Functions.Notify(_U('stopped_cornering'), 'primary', 2500)
    SetVehicleDoorShut(data.entity, 5, false)
    corneringZone:destroy()
    isCornerSelling = false
    if currentCornerPed then
        SetPedKeepTask(currentCornerPed, false)
        TaskSetBlockingOfNonTemporaryEvents(currentCornerPed, false)
        TaskWanderStandard(currentCornerPed, 10.0, 10)
        SetPedAsNoLongerNeeded(currentCornerPed)
        Wait(20000)
        DeletePed(currentCornerPed)
        currentCornerPed = nil
    end
end)

RegisterNetEvent('qb-drugsystem:client:CornerSellToPed', function(data)
    if isSelling or not isCornerSelling then return end
    isSelling = true
    exports['qb-target']:RemoveTargetEntity(data.entity)
    local ped = PlayerPedId()
    if not IsPedOnFoot(ped) then return end

    -- Alert Cops
    if math.random(100) <= Shared.CornerCallCopsChance then
        if GetResourceState('ps-dispatch') == 'started' then
            exports['ps-dispatch']:DrugSale() -- Project-Sloth ps-dispatch
        end
    end

    TaskTurnPedToFaceEntity(data.entity, ped, 1.0)
    TaskTurnPedToFaceEntity(ped, data.entity, 1.0)
    PlayAmbientSpeech1(ped, 'Generic_Hi', 'Speech_Params_Force')
    Wait(1500)
    FreezeEntityPosition(ped, true)
    PlayAmbientSpeech1(data.entity, 'Generic_Hi', 'Speech_Params_Force')
    Wait(1000)
    RequestAnimDict('mp_safehouselost@')
    while not HasAnimDictLoaded('mp_safehouselost@') do Wait(0) end
    TaskPlayAnim(ped, 'mp_safehouselost@', 'package_dropoff', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
    Wait(800)
    local zone = GetNameOfZone(GetEntityCoords(data.entity))
    local netId = NetworkGetNetworkIdFromEntity(data.entity)
    TriggerServerEvent('qb-drugsystem:server:CornerSellToPed', netId, zone)
    PlayAmbientSpeech1(data.entity, 'Chat_State', 'Speech_Params_Force')
    Wait(500)
    RequestAnimDict('mp_safehouselost@')
    while not HasAnimDictLoaded('mp_safehouselost@') do Wait(0) end
    TaskPlayAnim(data.entity, 'mp_safehouselost@', 'package_dropoff', 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Wait(3000)
    isSelling = false
    FreezeEntityPosition(ped, false)
    SetPedKeepTask(data.entity, false)
    TaskSetBlockingOfNonTemporaryEvents(data.entity, false)
    ClearPedTasks(data.entity)
    TaskWanderStandard(data.entity, 10.0, 10)
    SetPedAsNoLongerNeeded(data.entity)
    Wait(5000)
    currentCornerPed = nil
    Wait(15000)
    DeletePed(data.entity)
end)

--- Threads

CreateThread(function()
    exports['qb-target']:AddGlobalVehicle({
        options = {
            {
                type = 'client',
                event = 'qb-drugsystem:client:StartCornerSell',
                icon = 'fas fa-cannabis',
                label = _U('start_cornering'),
                canInteract = function(entity, distance, data)
                    return not isCornerSelling
                end
            },
            {
                type = 'client',
                event = 'qb-drugsystem:client:StopCornerSell',
                icon = 'fas fa-cannabis',
                label = _U('stop_cornering'),
                canInteract = function(entity, distance, data)
                    return isCornerSelling
                end
            }
        },
        distance = 1.5,
    })
end)
