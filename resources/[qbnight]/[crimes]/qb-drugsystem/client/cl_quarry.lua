if not Shared.Enable.Missions then return end

local missionBlip
local qPoint, cPoint
local veh
local trucks = {}
local truckBlips = {}
local fBlip, fBlip2
local PlayerFocus
local TrackPolys = {}
local trainTracks1 = {
    vector3(2788.16, 2841.37, 36.14),
    vector3(2663.95, 2764.21, 37.19),
    vector3(2643.76, 2756.72, 37.29),
    vector3(2623.24, 2754.5, 37.56),
    vector3(2599.69, 2760.37, 38.01),
    vector3(2582.26, 2773.86, 38.15),
    vector3(2573.29, 2788.71, 38.2),
    vector3(2572.74, 2794.1, 38.04),
    vector3(2567.62, 2793.07, 38.04),
    vector3(2572.17, 2779.17, 38.11),
    vector3(2591.23, 2760.07, 38.06),
    vector3(2611.28, 2750.78, 37.8),
    vector3(2637.95, 2750.14, 37.29),
    vector3(2665.82, 2761.24, 37.26),
    vector3(2789.2, 2836.16, 36.22)
}

local trainTracks2 = {
    vector3(2571.51, 2806.1, 38.18),
    vector3(2569.4, 2815.12, 38.23),
    vector3(2571.43, 2837.62, 38.19),
    vector3(2579.99, 2863.74, 38.08),
    vector3(2630.58, 2953.34, 40.06),
    vector3(2729.02, 3091.46, 44.3),
    vector3(2708.58, 3100.26, 43.01),
    vector3(2676.72, 3042.08, 41.54),
    vector3(2656.36, 3007.62, 40.77),
    vector3(2503.89, 2798.82, 37.96),
    vector3(2515.48, 2790.07, 38.02),
    vector3(2589.94, 2894.95, 38.98),
    vector3(2567.03, 2839.5, 38.08),
    vector3(2564.82, 2806.99, 38.02),
    vector3(2565.16, 2805.21, 38.01)
}
QBCore.Functions.LoadModel(`s_m_m_trucker_01`)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded" , function()
    Wait(2000)
    QBCore.Functions.TriggerCallback('qb-drugsystem:server:getInstance', function(i)
        local gang = QBCore.Functions.GetPlayerData().gang.name
        for k, v in pairs(GlobalState.AlluminumReady) do
            if k == gang and v ~= i then TriggerServerEvent('qb-drugsystem:server:AlluGangReady') break end
        end
    end)
end)

local GrabAllu = function()
    TriggerServerEvent('qb-drugsystem:server:collectAllu')
    exports['qb-target']:RemoveZone("AlluDoor")
end

RegisterNetEvent('qb-drugsystem:client:getAlluPing', function()
    SetNewWaypoint(974.29, -1937.29)
	exports['qb-target']:RemoveZone("AlluDoor")
	local loc = vector3(974.29, -1937.29, 32.22)
	local options =  {{name = "AlluDoor", action = GrabAllu, icon = "fa-solid fa-box", label = 'Grab Shredded Alluminum'}}
	exports['qb-target']:AddBoxZone("AlluDoor", loc, 1.0, 1.0, {name = "AlluDoor", heading = 0, debugPoly = false, minZ = loc.z-0.5, maxZ = loc.z+1.0}, {options = options, distance = 2.5})
end)

--- Functions

-- Searching Dump Trucks animation
local searchDumpTruck = function(entity)
    local ped = PlayerPedId()
    local ecoords = GetEntityCoords(entity)
    local pcoords = GetEntityCoords(ped)
    if pcoords.z - ecoords.z < 3.0 then QBCore.Functions.Notify('You can\'t see the content from here...') return end

    QBCore.Functions.Progressbar("searchDump", 'Searching Truck...', 5000, true, true,
    { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true },
    {}, {}, {}, function()
        ClearPedTasks(ped)
        if Entity(entity).state.hasCargo then QBCore.Functions.Notify('This is the truck with the cargo!')
            TriggerServerEvent('qb-drugsystem:server:foundDump', Entity(entity).state.loc)
        else
            RemoveBlip(truckBlips[Entity(entity).state.loc])
            QBCore.Functions.Notify('This isn\'t the right truck...')
        end
    end, function() ClearPedTasks(ped) end)
    Citizen.CreateThread(function() ExecuteCommand('e medic') end)
end

-- Start Cargo Transfer Handle
local transferCargo = function(e) TriggerServerEvent('qb-drugsystem:server:transferStarted', NetworkGetNetworkIdFromEntity(e)) end


AddEventHandler('onResourceStop', function (resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    for k, v in pairs(trucks) do
        DeleteEntity(v)
    end
    if DoesBlipExist(missionBlip) then
        RemoveBlip(missionBlip)
    end
end)

----------------
-- Spotlights --
----------------
-- Util Function for distance check
PlayerFocusCheck = function(coords)
    return #(GetEntityCoords(PlayerPedId()) - coords) < 6.7
end

-- Util function for light movement
local GetVector3Between = function(vectorA, vectorB, percentage)
    local direction = vectorB - vectorA
    local magnitude = #(direction)

    if magnitude == 0 then
        return vectorA
    end

    local normalizedDirection = direction / magnitude
    local vector3Between = vectorA + normalizedDirection * (magnitude * percentage)

    return vector3Between
end

-- Spotlights Updating
local updating = {}
for k, v in ipairs(Shared.QuarrySpotLights) do
    AddStateBagChangeHandler("SpotLightMove"..k, nil, function(bagName, key, va)
        if PlayerFocus == k then return end
        if updating[k] then Wait(250) if updating[k] then return end end
        updating[k] = true
        Citizen.CreateThread(function()
            local mTime = GetGameTimer()
            local betweenDis = 0.0
            local oldLoc = v.currentLoc or v.lightPath[1].coords
            while true do
                betweenDis = 1 - (mTime + va.time - GetGameTimer()) / va.time
                Shared.QuarrySpotLights[k].currentLoc = GetVector3Between(oldLoc, va.newLoc, betweenDis)
                if betweenDis > 1.0 then updating[k] = false break end
                Wait(0)
            end
        end)
    end)
end

-- Player Cuaght by Spoitlights
local caught, stop = false, false
RegisterNetEvent('quarryPlayerCaught', function()
    if not caught then
        caught = true
        exports['ps-dispatch']:QuarryCaught()
        TriggerServerEvent('qb-drugsystem:server:playerCaught')
        Wait(5000)
        stop = true
    end
end)

-- Player Cuaght by Spoitlights
RegisterNetEvent('qb-drugsystem:client:quarryPlayerCaught', function()
    if not caught then
        caught = true
        stop = true
    end
end)

-- Spotlights
local startSpotLights = function()
    Citizen.CreateThread(function()
        local vDir = vector3(0, 0.00, -10.0)
        while true do
            for i = 1, #Shared.QuarrySpotLights do
                local v = Shared.QuarrySpotLights[i].currentLoc or Shared.QuarrySpotLights[i].lightPath[1].coords
                if PlayerFocusCheck(v) then
                    PlayerFocus = i
                    v = GetEntityCoords(PlayerPedId())
                    Shared.QuarrySpotLights[i].currentLoc = v
                    TriggerEvent('quarryPlayerCaught')
                end
                DrawSpotLight(v.x, v.y, v.z+15.0, vDir, 255, 0, 0, 18.0, 1.0, 0.9, 45.0, 0.95)
            end
            Wait(0)
            if stop then break end
        end
    end)
end

-------------
-- Mission --
-------------

-- Starting up the mission
RegisterNetEvent('qb-drugsystem:client:StartQuarry', function(missionType)
    QBCore.Functions.TriggerCallback('qb-drugsystem:server:CanStartQuarry', function(canStart, loc, coords)
        if not canStart then return end
        local xcoords, ycoords = coords.x + math.random(-30.0, 30), coords.y + math.random(-30.0, 30)
        local vehBlip = AddBlipForRadius(xcoords, ycoords, coords.z, 100.0)

        local vPoint = lib.points.new(coords, 100.0)
        SetBlipHighDetail(vehBlip, true)
        SetBlipAlpha(vehBlip, 100)
        SetBlipColour(vehBlip, 47)
        function vPoint:onEnter()
            RemoveBlip(vehBlip)
            vPoint:remove()
            TriggerServerEvent("qb-drugsystem:server:vanPrepped", loc, coords)
        end
        local sPoint = lib.points.new(vector3(2579.59, 2721.41, 42.69), 250.0)
        function sPoint:onEnter()
            sPoint:remove()
            QBCore.Functions.TriggerCallback('qb-drugsystem:server:EnterQuarryZone', function(netIds)
                Wait(1000)
                if not veh then veh = NetworkGetEntityFromNetworkId(netIds[1]) end
                while not veh or veh == 0 do Wait(0) NetworkGetEntityFromNetworkId(netIds[1]) end
                exports['cdn-fuel']:SetFuel(veh, math.random(75,85))
            end, missionType)
        end
    end, missionType)
end)

-- All members of the gang receive the blip & notification
RegisterNetEvent('qb-drugsystem:client:startQMission', function(gang, netIds, tcoords)
    local pData = QBCore.Functions.GetPlayerData()
    if pData.gang.name ~= gang then return end

    -- local vehBlip = AddBlipForRadius(xcoords, ycoords, tcoords.z, 100.0)
    -- SetBlipHighDetail(vehBlip, true)
    -- SetBlipAlpha(vehBlip, 100)
    -- SetBlipColour(vehBlip, 47)
    local ePoint = lib.points.new(tcoords.xyz, 30.0)
    function ePoint:onEnter()
        RemoveBlip(vehBlip)
        if not veh then veh = NetworkGetEntityFromNetworkId(netIds[1]) end
        while not veh do veh = NetworkGetEntityFromNetworkId(netIds[1]) Wait(0) end
        vehBlip = AddBlipForEntity(veh)
        SetBlipSprite(vehBlip, 477)
        SetBlipColour(vehBlip, 47)
        SetBlipScale(vehBlip, 1.0)
        SetBlipFlashes(vehBlip, true)
        SetBlipHiddenOnLegend(vehBlip, true)
        ePoint:remove()
    end

    missionBlip = AddBlipForRadius(2579.59, 2721.41, 42.69, 151.7, 250.00)
    SetBlipHighDetail(missionBlip, true)
    SetBlipAlpha(missionBlip, 100)
    SetBlipColour(missionBlip, 3)

    currentWorking = true
    qPoint = lib.points.new(vector3(2579.59, 2721.41, 42.69), 150.0)
    function qPoint:onEnter() RemoveBlip(missionBlip) end

    CreateThread(function()
        exports['qb-target']:AddTargetModel('dump', {
            options = {
                { action = function(entity) searchDumpTruck(entity) end, canInteract = function(e) return not Entity(e).state.searched end, icon = 'fas fa-user-secret', label = "Inspect Content"},
                { action = function(entity) transferCargo(entity) end, item = 'dump_key', canInteract = function(e) return Entity(e).state.hasCargo and Entity(e).state.searched end, icon = 'fas fa-user-secret', label = "Start Transfer" }
            },
            distance = 1.5,
        })
    end)
end)


local function t_onEnter() TriggerEvent('quarryPlayerCaught') end

-- Loop when entities get generated to fetch blip & other things related to it
RegisterNetEvent('qb-drugsystem:client:startLoop', function(gang, netIds, dumpTrucks)
    local pData = QBCore.Functions.GetPlayerData()
    if pData.gang.name ~= gang then return end
    --TriggerEvent('qs-smartphone:client:notify', { title = _U('phone_title_current'), text = _U('goto_area'), icon = "./img/apps/whatsapp.png", timeout = 15000})
    startSpotLights()

    for k, v in pairs(Shared.QuarryShacks) do
        exports['qb-target']:RemoveZone("QuarryShack_"..k)
        local DoorOptions = {{name = "QuarryShack_"..k, type = "client", event = "qb-drugsystem:client:searchShack", icon = "fas fa-user-secret", label = "Search", shack = k, scoords = v}}
        exports['qb-target']:AddBoxZone("QuarryShack_"..k, v.xyz, 1.0, 1.0, {name = "QuarryShack_"..k, heading = v[4], debugPoly = false, minZ = v.z-1.2, maxZ = v.z+1.5}, {options = DoorOptions})
    end

    for k, v in pairs(dumpTrucks) do
        while not trucks[k] do trucks[k] = NetworkGetEntityFromNetworkId(v) Wait(0) end
        --if not trucks[k] then trucks[k] = NetworkGetEntityFromNetworkId(v) end
        truckBlips[k] = AddBlipForEntity(trucks[k])
        SetBlipSprite(truckBlips[k], 800)
        SetBlipColour(truckBlips[k], 7)
        SetBlipScale(truckBlips[k], 0.7)
        SetBlipHiddenOnLegend(truckBlips[k], true)

        SetVehicleDoorsLockedForPlayer(trucks[k], PlayerId(), false)
        if Entity(trucks[k]).state.hasCargo then
            cargoTruck = k
        end
    end

    TrackPolys[1] = lib.zones.poly({
        points = trainTracks1,
        thickness = 20,
        debug = false,
        onEnter = t_onEnter,
    })

    TrackPolys[2] = lib.zones.poly({
        points = trainTracks2,
        thickness = 35,
        debug = false,
        onEnter = t_onEnter,
    })
end)

local markerColor = {204,102,0}
-- When someone gets into the truck.
RegisterNetEvent('qb-drugsystem:client:markerColor', function(bool)
    local pData = QBCore.Functions.GetPlayerData()
    if pData.gang.name ~= g then return end
    if bool then markerColor = {0,255,0} else markerColor = {204,102,0} end
end)

-- Starting up the mission
RegisterNetEvent('qb-drugsystem:client:startTransfer', function(gang, truck)
    local pData = QBCore.Functions.GetPlayerData()
    if pData.gang.name ~= gang then return end
    truck = NetworkGetEntityFromNetworkId(truck)
    local ptcoord = GetOffsetFromEntityInWorldCoords(truck, 0.0, -4.0, 0.0)
    cPoint = lib.points.new(ptcoord, 4.0)
    exports['qb-core']:DrawText('Progress : 0 %')
    function cPoint:onEnter()
        if not IsPedInAnyVehicle(ped) or GetVehiclePedIsIn(ped) ~= veh and GetPedInVehicleSeat(veh) ~= ped then return end
        QBCore.Functions.Notify('Truck is in a good location to be filled. Don\'t let the spotlights catch you!', 'success')
    end
    function cPoint:nearby()
        local ped = PlayerPedId()
        if not IsPedInAnyVehicle(ped) or GetVehiclePedIsIn(ped) ~= veh and GetPedInVehicleSeat(veh, -1) ~= ped then return end
        TriggerServerEvent('qb-drugsystem:server:isInTransferZone', ptcoord)
        Wait(2000)
    end
    function cPoint:onExit()
        if not IsPedInAnyVehicle(ped) or GetVehiclePedIsIn(ped) ~= veh and GetPedInVehicleSeat(veh, -1) ~= ped then return end
        TriggerServerEvent('qb-drugsystem:server:markerColor')
    end

    Citizen.CreateThread(function()
        while true do
            local color = markerColor
            DrawMarker(1, ptcoord.x,ptcoord.y, ptcoord.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 4.0, color[1],color[2],color[3] , 50, false, true, 2, false, nil, nil, false)
            Citizen.Wait(0)
        end
    end)

end)

-- When someone gets into the truck.
RegisterNetEvent('qb-drugsystem:client:showQuarryProgress', function(g, p)
    local pData = QBCore.Functions.GetPlayerData()
    if pData.gang.name ~= g then return end
    p = tostring(math.floor(p))
    exports['qb-core']:DrawText('Progress : '..p..' %')
end)

-- When someone gets into the truck.
RegisterNetEvent('qb-drugsystem:client:foundDump', function(l)
    for k, v in pairs(truckBlips) do
        if k ~= l then RemoveBlip(v)
        else SetBlipColour(v, 2) end
    end
end)

-- When someone gets into the truck.
RegisterNetEvent('qb-drugsystem:client:transferDone', function(g)
    local pData = QBCore.Functions.GetPlayerData()
    if pData.gang.name ~= g then return end
    cPoint:remove()
    Wait(100)
    exports["qb-core"]:HideText()
    QBCore.Functions.Notify('Bring the truck back to the foundry! Don\'t get caught!', 'success')

    fBlip = AddBlipForCoord(1120.03, -2037.99, 30.99)
    fBlip2 = AddBlipForCoord(1120.03, -2037.99, 30.99)
    SetBlipSprite(fBlip, 390)
    SetBlipSprite(fBlip2, 161)
    SetBlipColour(fBlip, 1)
    SetBlipColour(fBlip2, 1)
    SetBlipScale(fBlip, 1.0)
    SetBlipScale(fBlip2, 2.0)
    PulseBlip(fBlip2)
    cPoint = lib.points.new(vector3(1120.03, -2037.99, 30.99), 4.0)
    function cPoint:onEnter()
        local ped = PlayerPedId()
        QBCore.Functions.Notify('Perfect, leave the truck here!', 'success')
        if not IsPedInAnyVehicle(ped) or GetVehiclePedIsIn(ped) ~= veh and GetPedInVehicleSeat(veh) ~= ped then return end
        -- Add Cop Distance Check
        TriggerServerEvent('qb-drugsystem:server:quarryFinished')
    end
end)

-- Cleans Everything
RegisterNetEvent('qb-drugsystem:client:cleanQuarry', function(gang)
    local pData = QBCore.Functions.GetPlayerData()
    if pData.gang.name ~= gang then return end
    RemoveBlip(fBlip)
    RemoveBlip(fBlip2)
    for _, v in pairs(TrackPolys) do
        if v then v:remove() end
    end
end)

-- Searching Worker Shack
RegisterNetEvent("qb-drugsystem:client:searchShack", function(data)
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    DoScreenFadeOut(1500)
    while not IsScreenFadedOut() do Wait(0) end
    local pcoords = GetEntityCoords()
    SetEntityCoords(pcoords.x, pcoords.y, pcoords.z-3.0, 0, 0, 0)
    QBCore.Functions.Progressbar('searching', 'Searching Through Worker Shack...', 5000, false, false,
    { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, },
    {}, {}, {}, function()
        TriggerServerEvent("qb-drugsystem:server:searchShack", data.shack)
        Wait(1000)
        SetEntityCoords(ped, data.scoords.x, data.scoords.y, data.scoords.z-0.8, 0, 0, 0)
        SetEntityHeading(ped, data.scoords[4]-180)
        FreezeEntityPosition(ped, false)
        DoScreenFadeIn(2000)
        while not IsScreenFadedIn() do Wait(0) end
    end)
end)

--------------------
-- Debug & Unused --
--------------------

-- --Start the lights (local only)
-- RegisterCommand('testlight', function()
--     for k, v in pairs(Shared.QuarrySpotLights) do
--         local betweenDis, dir, currentStart, WaitTime, mTime = 0.0, 1, 1, nil, GetGameTimer()
--         local PlayerFocus = false
--         local vDir = vector3(0, 0.00, -10.0)
--         local CoordA = v.lightPath[currentStart].coords
--         local CoordB = v.lightPath[currentStart + 1].coords
--         local nextWaitTime = v.lightPath[currentStart + 1].wait
--         Citizen.CreateThread(function()
--             while true do
--                 local vB = vector3(0,0,0)
--                 if PlayerFocus then
--                     vB = GetEntityCoords(PlayerPedId())
--                     if #(GetEntityCoords(PlayerPedId()) - v.loc) > 45 then PlayerFocus = false end
--                     goto skip
--                 end
--                 if dir == 1 then betweenDis = 1 - (mTime + v.lightPath[currentStart].timeToNext - GetGameTimer()) / v.lightPath[currentStart].timeToNext
--                 else betweenDis = 1 - (mTime + v.lightPath[currentStart].timeToPrev - GetGameTimer()) / v.lightPath[currentStart].timeToPrev end

--                 if betweenDis > 1.0 then betweenDis = 1.0 end
--                 if betweenDis == 1.0 then

--                     if not WaitTime then WaitTime = GetGameTimer() end
--                     if GetGameTimer() > WaitTime + nextWaitTime then
--                         WaitTime = nil
--                         if dir == 1 then
--                             currentStart = currentStart + 1
--                             CoordA = v.lightPath[currentStart].coords
--                             if currentStart >= #v.lightPath then
--                                 dir = 2
--                                 CoordB = v.lightPath[#v.lightPath - 1].coords
--                                 nextWaitTime = v.lightPath[currentStart - 1].wait
--                             else
--                                 CoordB = v.lightPath[currentStart + 1].coords
--                                 nextWaitTime = v.lightPath[currentStart + 1].wait
--                             end
--                         elseif dir == 2 then
--                             currentStart = currentStart - 1
--                             if currentStart <= 1 then dir, currentStart = 1, 1 end
--                             CoordA = v.lightPath[currentStart].coords or v.lightPath[1].coords
--                             CoordB = v.lightPath[currentStart - 1] and v.lightPath[currentStart - 1].coords or v.lightPath[2].coords
--                             nextWaitTime = v.lightPath[currentStart - 1] and v.lightPath[currentStart - 1].wait or v.lightPath[2].wait
--                         end
--                         betweenDis = 0.0
--                         mTime = GetGameTimer()
--                     end
--                 end
--                 vB = GetVector3Between(CoordA, CoordB, betweenDis)
--                 PlayerFocus = PlayerFocusCheck(vB)
--                 ::skip::
--                 DrawSpotLight(vB.x, vB.y, vB.z+15.0, vDir, 255, 0, 0, 18.0, 1.0, 0.8, 25.0, 0.95)
--                 Wait(0)
--             end
--         end)
--     end
-- end)

-- -- Start the heist
-- RegisterCommand('startlights', function()
--     TriggerEvent('qb-drugsystem:client:StartQuarry', 'alluminum')
-- end)
