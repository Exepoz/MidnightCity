if not Shared.Enable.Weedfarm then return end

local insideWeedPoly = false
local harvesting = false

local WeedFarm = PolyZone:Create({
    vector2(2215.2211914062, 5579.9609375),
    vector2(2214.6799316406, 5574.75390625),
    vector2(2234.0637207031, 5573.7646484375),
    vector2(2234.40234375, 5578.8569335938)
  }, {
    name = 'weedfarm',
    minZ = 52.80,
    maxZ = 54.60,
    debugPoly = Shared.Debug
})

WeedFarm:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
    insideWeedPoly = isPointInside
    if isPointInside then
        exports['qb-core']:DrawText(_U('farming_start_harvesting'), 'left')

        -- Start/Stop thread
        CreateThread(function()
            while insideWeedPoly do
                Wait(0)
                if IsControlJustPressed(0, 38) then
                    harvesting = not harvesting
                    if harvesting then
                        exports['qb-core']:ChangeText(_U('farming_stop_harvesting'), 'left')
                        local ped = PlayerPedId()
                        FreezeEntityPosition(ped, true)
                    else
                        exports['qb-core']:ChangeText(_U('farming_start_harvesting'), 'left')
                        local ped = PlayerPedId()
                        FreezeEntityPosition(ped, false)
                        ClearPedTasksImmediately(ped)
                    end
                end
            end
        end)

        -- Animation Loop
        CreateThread(function()
            while insideWeedPoly do
                Wait(0)
                if harvesting then
                    local ped = PlayerPedId()
                    TaskStartScenarioInPlace(ped, 'PROP_HUMAN_BUM_BIN', 0, true)   
                    Wait(Shared.WeedFarmingDuration * 1000)
                    if harvesting then
                        TaskGoStraightToCoord(ped, GetEntityCoords(ped), -1, 1)
                    end
                else
                    Wait(1000)
                end
            end
        end)

        -- Harvesting loop
        CreateThread(function()
            while insideWeedPoly do
                Wait(Shared.WeedFarmingDuration * 1000)
                if harvesting and IsPedOnFoot(PlayerPedId()) then
                    exports['ps-ui']:Circle(function(success)
                        if success then
                            TriggerServerEvent('qb-drugsystem:server:FarmWeed')
                        else
                            QBCore.Functions.Notify(_U('farming_failed'), 'error', 2500)
                        end
                    end, 1, 15)
                end
            end
        end)

    else
        exports['qb-core']:HideText()
    end
end)

--- Events

RegisterNetEvent('qb-drugsystem:client:CreateWeedBags', function()
    local ped = PlayerPedId()
    QBCore.Functions.Progressbar('make1ozbags', _U('farming_buds_bags_progressbar'), 3000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
		anim = 'weed_inspecting_high_base_inspector',
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(ped, 'anim@amb@business@weed@weed_inspecting_high_dry@', 'weed_inspecting_high_base_inspector', 1.0)
        TriggerServerEvent('qb-drugsystem:server:CreateWeedBags')
    end, function() -- Cancel
        StopAnimTask(ped, 'anim@amb@business@weed@weed_inspecting_high_dry@', 'weed_inspecting_high_base_inspector', 1.0)
        QBCore.Functions.Notify(_U('canceled'), 'error', 2500)
    end)
end)

--- Threads

CreateThread(function()
    if Shared.WeedFarmingBlip then
        local blip = AddBlipForCoord(Shared.WeedFarmingCoords.xyz)
        SetBlipSprite(blip, 140)
        SetBlipDisplay(blip, 2)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 2)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(_U('farming_blip'))
        EndTextCommandSetBlipName(blip)
    end
end)
