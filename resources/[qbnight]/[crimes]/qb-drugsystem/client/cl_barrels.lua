if not Shared.Enable.Missions then return end

local missionBlip, doorBlip
local veh
local trucks = {}
local FactoryZone, InsideZone
local noiseLvl = 0
local barrelObject
local carrying = false
local alarmTriggered, missionEnded = false, false
local ePoint
QBCore.Functions.LoadModel(`s_m_m_trucker_01`)

--- Functions

local function LoadAnim(animDict)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(10)
	end
end

local function RequestWalking(set)
	RequestAnimSet(set)
	while not HasAnimSetLoaded(set) do
		Citizen.Wait(1)
	end
end

local function IsNight()
	local time = GetClockHours()
	if time > 21 or time < 7 then
		return true
	end
	return false
end

local CarryBarrel = function()
    local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	LoadAnim('mp_common_heist')
	LoadAnim("anim@heists@box_carry@")
    barrelObject = CreateObject(GetHashKey("prop_offroad_barrel01"), coords.x, coords.y, coords.z,  true,  true, false)
    AttachEntityToEntity(barrelObject, ped, GetPedBoneIndex(ped, 57005), 0.0, 0.4, -0.3, 90.0, 0.0, 0.0, true, true, false, true, 1, true)
    RequestWalking('anim_group_move_ballistic')
    SetPedMovementClipset(ped, 'anim_group_move_ballistic', 0.2)
    --DeleteEntity(items[i].object)
    carrying = true
    local ui = false
    exports['qb-core']:DrawText('[X] Drop Item')
    local nextStumble = math.random(7500, 12500)
    local stumbleTime = GetGameTimer()
    while true do
        local w = 0
        if not IsEntityPlayingAnim(ped, "anim@heists@box_carry@", "walk", 3) then TaskPlayAnim(ped, 'anim@heists@box_carry@', "walk", 8.0, -8, -1, 49, 0, 0, 0, 0) end
        if GetGameTimer() > stumbleTime + nextStumble then
            lib.hideTextUI()
            QBCore.Functions.Notify('You stumble!', 'error')
            Wait(100)
            SetPedToRagdoll(ped, 1500, 2000, 3, true, true, false)
            Wait(400)
            QBCore.Functions.Notify('Catch Yourself Up!', 'info')
            nextStumble = math.random(12500, 20000)
            stumbleTime = GetGameTimer()
            local success = lib.skillCheck({areaSize = 90, speedMultiplier = 2.5}, {'e'})
            if not success then
                DetachEntity(barrelObject, 1, 1)
                FreezeEntityPosition(barrelObject, false)
                ActivatePhysics(barrelObject)
                ClearPedTasksImmediately(ped)
                RemoveAnimSet('anim_group_move_ballistic')
                ResetPedMovementClipset(ped)
                SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                QBCore.Functions.Notify('You stumbled and dropped the barrel! The content spilled and you need a new one.', 'error')
                carrying = false
                break
            else
                ClearPedTasks(ped)
                Wait(1000)
                TaskPlayAnim(ped, 'anim@heists@box_carry@', "walk", 8.0, -8, -1, 49, 0, 0, 0, 0)
                if not IsEntityPlayingAnim(ped, "anim@heists@box_carry@", "walk", 3) then TaskPlayAnim(ped, 'anim@heists@box_carry@', "walk", 8.0, -8, -1, 49, 0, 0, 0, 0) end
                QBCore.Functions.Notify('You catched yourself back up!', 'success')
            end
        end
        local pcoords = GetEntityCoords(PlayerPedId())
        local vehicle = lib.getClosestVehicle(pcoords, 4.0, false)
        if vehicle and Entity(vehicle).state.BarrelsVan then
            local d1 = GetModelDimensions(GetEntityModel(vehicle))
            local vehicleCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d1["y"]+0.60,0.0)
            local Distance = #(vehicleCoords - pcoords)
            if Distance < 2.0 then
                if not ui then exports['qb-core']:DrawText("[E] Place Barrel Inside") ui = true end
            end
            if IsControlJustReleased(0, 38) then
                if FactoryZone:contains(GetEntityCoords(vehicle)) then
                    QBCore.Functions.Notify('You shouldn\'t put the barrel in the van while in front of CCTV....', 'error')
                else
                    exports['qb-core']:HideText()
                    Citizen.Wait(400)
                    DetachEntity(barrelObject, 1, 0)
                    DeleteEntity(barrelObject)
                    barrelObject = nil
                    ClearPedTasksImmediately(ped)
                    RemoveAnimSet('anim_group_move_ballistic')
                    ResetPedMovementClipset(ped)
                    TriggerServerEvent('qb-drugsystem:server:depoBarrel', trunkInfo)
                    carrying = false
                    break
                end
            end
        end

        if IsControlJustReleased(0, 73) then
            lib.hideTextUI()
            DetachEntity(barrelObject, 1, 1)
            FreezeEntityPosition(barrelObject, false)
            ActivatePhysics(barrelObject)
            ClearPedTasksImmediately(ped)
            RemoveAnimSet('anim_group_move_ballistic')
            ResetPedMovementClipset(ped)
            carrying = false
            QBCore.Functions.Notify('You drop the barrel', 'info')
            break
        end
        Citizen.Wait(w)
    end
end

AddEventHandler('onResourceStop', function (resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    for k, v in pairs(trucks) do
        DeleteEntity(v)
    end
    if DoesBlipExist(missionBlip) then
        RemoveBlip(missionBlip)
    end
end)

-------------
-- Mission --
-------------

-- Searching Factory to grab the barrel
RegisterNetEvent("qb-drugsystem:client:BringBackBarrel", function(mission, gang)
    local pData = QBCore.Functions.GetPlayerData()
    if pData.gang.name ~= gang then return end
    local coords = vector3(701.82, -2195.0, 29.55)

    local barrelBlip = AddBlipForCoord(coords)
    SetBlipHighDetail(barrelBlip, true)
    SetBlipSprite(barrelBlip, 616)
    SetBlipColour(barrelBlip, 1)
    exports['qb-target']:RemoveZone("BBBarrel")
    local DoorOptions = {{name = "BBBarrel", type = "client", scoords = coords, event = "qb-drugsystem:client:giveBackBarrel", icon = "fas fa-user-secret", label = "Give Barrel", mission = mission, item = "barrel_methylamine"}}
    exports['qb-target']:AddBoxZone("BBBarrel", coords.xyz, 1.0, 1.0, {name = "BBBarrel", heading = coords[4], debugPoly = false, minZ = coords.z-1.2, maxZ = coords.z+1.5}, {options = DoorOptions})
end)
RegisterNetEvent('qb-drugsystem:client:giveBackBarrel', function(data) TriggerServerEvent('qb-drugsystem:server:giveBackBarrel') end)


RegisterNetEvent('qb-drugsystem:client:prepVan', function(coords, loc)
    local vehBlip = AddBlipForCoord(coords.xyz)
    SetBlipHighDetail(vehBlip, true)
    SetBlipSprite(vehBlip, 616)
    SetBlipColour(vehBlip, 1)
    local p = lib.points.new(coords.xyz, 100)
    function p:onEnter()
        RemoveBlip(vehBlip)
        p:remove()
        TriggerServerEvent('qb-drugsystem:server:preppedVan', loc)
    end
end)


-- All members of the gang receive the blip & notification
RegisterNetEvent('qb-drugsystem:client:startBMission', function(gang, netIds, v_coords, m, m_type)
    local pData = QBCore.Functions.GetPlayerData()
    if pData.gang.name ~= gang then return end
    -- Citizen.CreateThread(function()
    --     if not veh then veh = NetworkGetEntityFromNetworkId(netIds[1]) end
    --     while not veh do veh = NetworkGetEntityFromNetworkId(netIds[1]) Wait(0) end
    -- end)
    -- local vehBlip = AddBlipForCoord(v_coords.xyz)
    -- SetBlipHighDetail(vehBlip, true)
    -- SetBlipSprite(vehBlip, 616)
    -- SetBlipColour(vehBlip, 1)
    -- ePoint = lib.points.new(v_coords.xyz, 5.0)
    -- function ePoint:onEnter()
    --     RemoveBlip(vehBlip)
    --     ePoint:remove()
    -- end
    local coords = Shared.Barrels[m_type][m].door
    local t_onEnter = function(self)
        local ped = PlayerPedId()
        InsideZone = true
        TriggerEvent('qb-drugsystem:client:noiseLvl')
        if IsPedInAnyVehicle(ped) then
            QBCore.Functions.Notify('Get out of here with this vehicle, you\'ll get caught!', 'error')
            Wait(10000)
            if FactoryZone:contains(GetEntityCoords(ped)) and IsPedInAnyVehicle(ped) then
                QBCore.Functions.Notify("You triggered the alarm.", 'error')
                if not alarmTriggered then
                    exports['ps-dispatch']:BarrelAlarm(GetEntityCoords(ped))
                    alarmTriggered = true
                end
            end
        elseif not IsNight() then
            QBCore.Functions.Notify('Get out of here! Doing this during the day is asking to get caught!', 'error')
            Wait(10000)
            if FactoryZone:contains(GetEntityCoords(ped)) then
                QBCore.Functions.Notify("You triggered the alarm.", 'error')
                if not alarmTriggered then
                    exports['ps-dispatch']:BarrelAlarm(GetEntityCoords(ped))
                    alarmTriggered = true
                end
            end
        end
    end
    local t_onExit = function()
        SendNUIMessage({closeProgress = true})
        noiseLvl = 0
        local ped = PlayerPedId()
        InsideZone = false
    end
    local t_inside = function()
        DrawMarker(1, coords.x,coords.y, coords.z - 2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 2.0, 0, 255, 0, 50, false, true, 2, false, nil, nil, false)
        --Citizen.Wait(0)
    end
    FactoryZone = lib.zones.poly({
        points = Shared.Barrels[m_type][m].zone,
        thickness = 20,
        debug = false,
        onEnter = t_onEnter,
        onExit = t_onExit,
        inside = t_inside,
    })

    missionBlip = AddBlipForRadius(coords.x, coords.y, coords.z, 100.00)
    SetBlipHighDetail(missionBlip, true)
    SetBlipAlpha(missionBlip, 100)
    SetBlipColour(missionBlip, 3)

    doorBlip = AddBlipForCoord(coords)
    SetBlipHighDetail(doorBlip, true)
    SetBlipSprite(doorBlip, 50)
    SetBlipColour(doorBlip, 1)
    SetBlipAsShortRange(doorBlip, true)

    exports['qb-target']:RemoveZone("BarrelFactoryDoor")
    local DoorOptions = {{name = "BarrelFactoryDoor", type = "client", scoords = coords, event = "qb-drugsystem:client:searchFactory", icon = "fas fa-user-secret", label = "Search", canInteract = function() return not carrying end}}
    exports['qb-target']:AddBoxZone("BarrelFactoryDoor", coords.xyz, 1.0, 1.0, {name = "BarrelFactoryDoor", heading = coords[4], debugPoly = false, minZ = coords.z-1.2, maxZ = coords.z+1.5}, {options = DoorOptions, distance = 1.5})
end)

local function noiseNUI(progress) SendNUIMessage({runProgress = true, Length = progress}) end

RegisterNetEvent('qb-drugsystem:client:noiseLvl', function()
	local ped = PlayerPedId()
	--InsideHouse()
	while true do
		if InsideZone then
			noiseNUI(noiseLvl)
			if IsPedShooting(ped) then noiseLvl = noiseLvl + 20 end
			if GetEntitySpeed(ped) > 1.7 then noiseLvl = noiseLvl + 10
				if GetEntitySpeed(ped) > 2.5 then noiseLvl = noiseLvl + 15 end
				if GetEntitySpeed(ped) > 3.0 then noiseLvl = noiseLvl + 20 end
				Citizen.Wait(300)
			else
				noiseLvl = noiseLvl - 2
				if noiseLvl < 0 then noiseLvl = 0 end
				Citizen.Wait(1000)
			end
			noiseNUI(noiseLvl)
			if noiseLvl > 100 then
				-- caught = true --?
                if not alarmTriggered then
                    QBCore.Functions.Notify("You triggered the alarm.", 'error')
                    exports['ps-dispatch']:BarrelAlarm(GetEntityCoords(ped))
                    alarmTriggered = true
                end
				-- MissionInProgress = false --?
			end
        else
            break
		end
		Citizen.Wait(5)
		if heistFinished then break end
	end
end)

-- Searching Factory to grab the barrel
RegisterNetEvent("qb-drugsystem:client:searchFactory", function(data)
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    DoScreenFadeOut(1500)
    while not IsScreenFadedOut() do Wait(0) end
    local pcoords = GetEntityCoords()
    SetEntityCoords(pcoords.x, pcoords.y, pcoords.z-3.0, 0, 0, 0)
    FreezeEntityPosition(ped, true)
    QBCore.Functions.Progressbar('searching', 'Searching Through Factory...', 15000, false, false,
    { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, },
    {}, {}, {}, function()
        if GlobalState.FactoryBarrels <= 0 then QBCore.Functions.Notify('There is no more barrels in the factory...', 'error')
        else
            Citizen.CreateThread(function()
                TriggerServerEvent('qb-drugsystem:server:grabbedBarrel')
                CarryBarrel()
            end)
        end
        SetEntityCoords(ped, data.scoords.x, data.scoords.y, data.scoords.z-0.8, 0, 0, 0)
        SetEntityHeading(ped, data.scoords[4]-180)
        FreezeEntityPosition(ped, false)
        DoScreenFadeIn(2000)
        while not IsScreenFadedIn() do Wait(0) end
    end)
end)

RegisterNetEvent('qb-drugsystem:client:sendToFinish', function(gang)
    local pData = QBCore.Functions.GetPlayerData()
    if pData.gang.name ~= gang then return end
    QBCore.Functions.Notify('That\'s all the barrels we need, bring them back to the marked location and you\'ll get your share.')
    RemoveBlip(missionBlip)
    RemoveBlip(doorBlip)
    Wait(100)
    local coords = vector3(609.23, -3137.05, 6.07)
    missionBlip = AddBlipForCoord(coords)
    SetBlipHighDetail(missionBlip, true)
    SetBlipSprite(missionBlip, 50)
    SetBlipColour(missionBlip, 1)
    SetBlipAsShortRange(missionBlip, true)
    SetBlipRoute(missionBlip, true)
    SetBlipRouteColour(missionBlip, 28)
    ePoint = lib.points.new(coords, 70)
    function ePoint:onEnter() end
    function ePoint:nearby()
        DrawMarker(1, coords.x,coords.y, coords.z - 2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 2.0, 0, 255, 0, 50, false, true, 2, false, nil, nil, false)
        if self.currentDistance < 2.0 then
            local ped = PlayerPedId()
            if not IsPedInAnyVehicle(ped) or not Entity(GetVehiclePedIsIn(ped)).state.BarrelsVan and GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1) ~= ped then return end
            if not missionEnded then
                Wait(3000)
                TriggerServerEvent('qb-drugsystem:server:finishBarrelMission')
            end
        end
    end
end)

RegisterNetEvent('qb-drugsystem:client:cleanBarrels', function(gang)
    -- local pData = QBCore.Functions.GetPlayerData()
    -- if pData.gang.name ~= gang then return end
    RemoveBlip(missionBlip)
    if ePoint then ePoint:remove() end

end)

RegisterNetEvent('qb-drugsystem:client:finishState', function()
    missionEnded = true
    SendNUIMessage({closeProgress = true})
    if ePoint then ePoint:remove() end
    RemoveBlip(missionBlip)
end)



-- RegisterCommand('testCarry', function()
--     CarryBarrel()
-- end)


--------------------
-- Debug & Unused --
--------------------