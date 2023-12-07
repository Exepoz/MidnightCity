if not Shared.Enable.Drugruns then return end

local waitingForPackage = false
local delivering = false
local package = nil
local packageZone

local delivering = false
local dropOffBlip
local hasDropOff = false
local dropOffArea
local deliveryPed
local madeDeal = false

--- Functions

--- Checks if a player has a suspicious package on him or her
--- @return nil
local checkPackage = function()
    Wait(250)
    local hasPackageItem = false
    for k, v in pairs(PlayerData.items) do
        if v.name == Shared.DrugrunPackageItem then
            hasPackageItem = true
            break
        end
    end

    if package then
        if not hasPackageItem then
            DetachEntity(package, true, true)
            DeleteObject(package)
            StopAnimTask(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 1.0)
            package = nil
            hasPackage = false
        end
    else
        if hasPackageItem then
            -- Animation
            local ped = PlayerPedId()
            RequestAnimDict('anim@heists@box_carry@')
            while not HasAnimDictLoaded('anim@heists@box_carry@') do Wait(0) end
            TaskPlayAnim(ped, 'anim@heists@box_carry@', 'idle', 5.0, -1, -1, 50, 0, false, false, false)
    
            -- Package
            local pos = GetEntityCoords(ped, true)
            RequestModel(Shared.DrugrunPackageProp)
            while not HasModelLoaded(Shared.DrugrunPackageProp) do Wait(0) end
            local object = CreateObject(Shared.DrugrunPackageProp, pos.x, pos.y, pos.z, true, true, true)
            AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, 57005), 0.1, 0.1, -0.25, 300.0, 250.0, 15.0, true, true, false, true, 1, true)
            package = object
            hasPackage = true
            
            -- Walk
            CreateThread(function()
                while package do
                    Wait(0)
                    SetPlayerSprint(PlayerId(), false)
                    DisableControlAction(0, 21, true)
                    DisableControlAction(0, 22, true)
                    if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
                        TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
                    end
                end
            end)
        end
    end
end

--- Creates a drop off blip at a given coordinate
--- @param coords vector4 - Coordinates of a location
local createDropOffBlip = function(coords)
	dropOffBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(dropOffBlip, 140)
    SetBlipColour(dropOffBlip, 25)
    SetBlipAsShortRange(dropOffBlip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(_U('drugrun_delivery_blip'))
    EndTextCommandSetBlipName(dropOffBlip)
end

--- Creates a drop off ped at a given coordinate
--- @param coords vector4 - Coordinates of a location
--- @return nil
local createDropOffPed = function(coords)
	if deliveryPed then return end
	local model = Shared.DropOffPeds[math.random(#Shared.DropOffPeds)]
	local hash = GetHashKey(model)

    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(0) end
	deliveryPed = CreatePed(5, hash, coords.x, coords.y, coords.z - 1.0, coords.w, true, true)
	while not DoesEntityExist(deliveryPed) do Wait(0) end
	ClearPedTasks(deliveryPed)
    ClearPedSecondaryTask(deliveryPed)
    TaskSetBlockingOfNonTemporaryEvents(deliveryPed, true)
    SetPedFleeAttributes(deliveryPed, 0, 0)
    SetPedCombatAttributes(deliveryPed, 17, 1)
    SetPedSeeingRange(deliveryPed, 0.0)
    SetPedHearingRange(deliveryPed, 0.0)
    SetPedAlertness(deliveryPed, 0)
    SetPedKeepTask(deliveryPed, true)
	FreezeEntityPosition(deliveryPed, true)
	exports['qb-target']:AddTargetEntity(deliveryPed, {
		options = {
			{
				type = 'client',
				event = 'qb-drugsystem:client:DeliverPackage',
				icon = 'fas fa-truck-arrow-right',
				label = _U('deliver_package'),
			}
		},
		distance = 2.0
	})
end

--- Method to create a drop-off location for delivering the drugrun packages
--- @return nil
local createNewDropOff = function()
    if hasDropOff then return end
    hasDropOff = true
    TriggerEvent('qb-phone:client:CustomNotification', _U('drugrun_delivery_title'), _U('drugrun_delivery_godropoff'), 'fas fa-truck-arrow-right', '#00FF00', 8000)
    local randomLoc = Shared.DropOffLocations[math.random(#Shared.DropOffLocations)]
    createDropOffBlip(randomLoc)
    SetBlipRoute(dropOffBlip, true)
    SetBlipRouteColour(dropOffBlip, 25)
    dropOffArea = CircleZone:Create(randomLoc.xyz, 85.0, {
		name = 'dropOffArea',
		debugPoly = Shared.Debug
	})

	dropOffArea:onPlayerInOut(function(isPointInside, point)
		if isPointInside then
			if not deliveryPed then
				TriggerEvent('qb-phone:client:CustomNotification', _U('drugrun_delivery_title'), _U('drugrun_delivery_makedropoff'), 'fas fa-truck-arrow-right', '#00FF00', 8000)
				createDropOffPed(randomLoc)
			end
		end
	end)
end

--- Method to clear current drug run
--- @return nil
clearDrugRun = function()
    -- Deliveries
    delivering = false
    hasDropOff = false
    RemoveBlip(dropOffBlip)
    ClearAllBlipRoutes()
    if dropOffArea then
        dropOffArea:destroy()
        DeletePed(deliveryPed)
	    deliveryPed = nil
    end

    -- Package
    if package then
        DetachEntity(package, true, true)
        DeleteObject(package)
        StopAnimTask(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 1.0)
        package = nil
        hasPackage = false
    end
end

--- Start/Stop Events

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
    checkPackage()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    -- Package
    if package and DoesEntityExist(package) then
        DeleteEntity(package)
        package = nil
    end
    clearDrugRun()
end)

AddEventHandler('onResourceStop', function (resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    if package and DoesEntityExist(package) then
        DeleteEntity(package)
        package = nil
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    checkPackage()
end)

--- Events

RegisterNetEvent('qb-drugsystem:client:StartPackage', function(data)
    if waitingForPackage then return end
    local hasItem = QBCore.Functions.HasItem(Shared.DrugLabs['meth'].items.curedItem, 1)
    or QBCore.Functions.HasItem(Shared.DrugLabs['coke'].items.curedItem, 1)
    or QBCore.Functions.HasItem(Shared.DrugLabs['weed'].items.curedItem, 1)
    
    if not hasItem then
        QBCore.Functions.Notify(_U('dont_have_anything'), 'error', 2500)
        return
    end

    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    TaskTurnPedToFaceEntity(ped, data.entity, 1.0)
    Wait(1500)
    PlayAmbientSpeech1(ped, 'Generic_Hi', 'Speech_Params_Force')
    Wait(1000)
    RequestAnimDict('mp_safehouselost@')
    while not HasAnimDictLoaded('mp_safehouselost@') do Wait(0) end
    TaskPlayAnim(ped, 'mp_safehouselost@', 'package_dropoff', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
    QBCore.Functions.Progressbar('drugrun_pack', _U('handing_over_drug'), 4000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        FreezeEntityPosition(ped, false)
        QBCore.Functions.TriggerCallback('qb-drugsystem:server:PackageGoods', function(result)
            if not result then return end
            waitingForPackage = true
            QBCore.Functions.Notify(_U('wait_closeby'), 'primary', 2500)
            CreateThread(function()
                Wait(Shared.DrugrunPackageTime * 60 * 1000)
                QBCore.Functions.Notify(_U('done_waiting'), 'primary', 2500)
            end)
    
            packageZone = CircleZone:Create(Shared.DrugrunStartLocation.xyz, 10.0, {
                name = 'drugrunning_start',
                debugPoly = Shared.Debug
            })
            
            packageZone:onPlayerInOut(function(isPointInside, point)
                if not isPointInside then
                    packageZone:destroy()
                    if waitingForPackage then
                        TriggerServerEvent('qb-drugsystem:server:DestroyWaitForPackage')
                        waitingForPackage = false
                    end
                end
            end)
        end)
    end, function()
        QBCore.Functions.Notify(_U('canceled'), 'error', 2500)
        FreezeEntityPosition(ped, false)
    end)
end)

RegisterNetEvent('qb-drugsystem:client:PackageGoodsReceived', function()
    if waitingForPackage then
        packageZone:destroy()
        waitingForPackage = false
    end
end)

RegisterNetEvent('qb-drugsystem:client:ClockIn', function()
    if delivering then return end
    delivering = true
    TriggerEvent('qb-phone:client:CustomNotification', _U('drugrun_delivery_title'), _U('drugrun_delivery_waitfornew'), 'fas fa-truck-arrow-right', '#00FF00', 8000)
    Wait(math.random(Shared.DeliveryWaitTime[1], Shared.DeliveryWaitTime[2]))
    createNewDropOff()
end)

RegisterNetEvent('qb-drugsystem:client:ClockOut', function()
    if not delivering then return end
    delivering = false
    hasDropOff = false
    RemoveBlip(dropOffBlip)
    if dropOffArea then
        dropOffArea:destroy()
        DeletePed(deliveryPed)
	    deliveryPed = nil
    end
    QBCore.Functions.Notify(_U('drugrun_clockout'), 'primary', 2500)
end)

RegisterNetEvent('qb-drugsystem:client:DeliverPackage', function()
    if madeDeal then return end
    if not hasPackage then
        QBCore.Functions.Notify(_U('drugrun_hasnopackage'), 'error', 2500)
        return
    end

    local ped = PlayerPedId()
	if not IsPedOnFoot(ped) then return end
	if #(GetEntityCoords(ped) - GetEntityCoords(deliveryPed)) < 5.0 then
		madeDeal = true
		exports['qb-target']:RemoveTargetEntity(deliveryPed)

		-- Alert Cops
		if math.random(100) <= Shared.DrugrunCallCopsChance then
            if GetResourceState('ps-dispatch') == 'started' then
                exports['ps-dispatch']:DrugSale() -- Project-Sloth ps-dispatch
            end
        end

        FreezeEntityPosition(ped, true)
		TaskTurnPedToFaceEntity(deliveryPed, ped, 1.0)
		TaskTurnPedToFaceEntity(ped, deliveryPed, 1.0)
        PlayAmbientSpeech1(ped, 'Generic_Hi', 'Speech_Params_Force')
		Wait(1500)
		PlayAmbientSpeech1(deliveryPed, 'Generic_Hi', 'Speech_Params_Force')
		Wait(1000)
		TriggerServerEvent('qb-drugsystem:server:DrugrunDelivery')
		PlayAmbientSpeech1(deliveryPed, 'Chat_State', 'Speech_Params_Force')
		Wait(500)
		RequestAnimDict('mp_safehouselost@')
		while not HasAnimDictLoaded('mp_safehouselost@') do Wait(0) end
		TaskPlayAnim(deliveryPed, 'mp_safehouselost@', 'package_dropoff', 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
		Wait(3000)
        FreezeEntityPosition(ped, false)
		RemoveBlip(dropOffBlip)
		dropOffBlip = nil
		dropOffArea:destroy()
		Wait(2000)
		TriggerEvent('qb-phone:client:CustomNotification', _U('drugrun_delivery_title'), _U('drugrun_delivery_success'), 'fas fa-truck-arrow-right', '#00FF00', 20000)
        ClearPedTasks(ped)
        FreezeEntityPosition(deliveryPed, false)
        SetPedKeepTask(deliveryPed, false)
        TaskSetBlockingOfNonTemporaryEvents(deliveryPed, false)
        ClearPedTasks(deliveryPed)
        TaskWanderStandard(deliveryPed, 10.0, 10)
        SetPedAsNoLongerNeeded(deliveryPed)
        Wait(20000)
        DeletePed(deliveryPed)
        deliveryPed = nil
		hasDropOff = false
		madeDeal = false

        Wait(math.random(Shared.DeliveryWaitTime[1], Shared.DeliveryWaitTime[2]))
        createNewDropOff()
	end
end)

--- Threads

CreateThread(function()
    local ped = nil
    RequestModel(Shared.DrugrunStartPedModel)
    while not HasModelLoaded(Shared.DrugrunStartPedModel) do Wait(0) end
    ped = CreatePed(0, Shared.DrugrunStartPedModel,  vector4(Shared.DrugrunStartLocation.x, Shared.DrugrunStartLocation.y, Shared.DrugrunStartLocation.z - 1.0, Shared.DrugrunStartLocation.w ), false, false)
    SetEntityInvincible(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	FreezeEntityPosition(ped, true)
    TaskStartScenarioInPlace(ped,'WORLD_HUMAN_DRUG_DEALER', -1, true)

    exports['qb-target']:AddBoxZone('druglabs_drugrun', vector3(Shared.DrugrunStartLocation.x, Shared.DrugrunStartLocation.y, Shared.DrugrunStartLocation.z), 0.8, 0.8, {
        name = 'druglabs_drugrun',
        heading = Shared.DrugrunStartLocation.w,
        minZ = Shared.DrugrunStartLocation.z - 1.0,
        maxZ = Shared.DrugrunStartLocation.z + 1.0,
        debugPoly = Shared.Debug
    }, {
        options = {
            { -- Create Package
                type = 'client',
                event = 'qb-drugsystem:client:StartPackage',
                icon = 'fas fa-circle-chevron-right',
                label = _U('package_goods'),
                canInteract = function()
                    return not waitingForPackage
                end
            },
            { -- Receive Package
                type = 'server',
                event = 'qb-drugsystem:server:CollectPackageGoods',
                icon = 'fas fa-circle-chevron-right',
                label = _U('grab_packaged_goods'),
                canInteract = function()
                    return waitingForPackage
                end
            },
            { -- Clock In for deliveries
                type = 'client',
                event = 'qb-drugsystem:client:ClockIn',
                icon = 'fas fa-stopwatch',
                label = _U('start_delivering'),
                canInteract = function()
                    return not delivering
                end
            },
            { -- Clock out for deliveries
                type = 'client',
                event = 'qb-drugsystem:client:ClockOut',
                icon = 'fas fa-stopwatch',
                label = _U('stop_delivering'),
                canInteract = function()
                    return delivering
                end
            }
        },
        distance = 1.5
    })

    if Shared.DrugrunStartBlip then
        local blip = AddBlipForCoord(Shared.DrugrunStartLocation.xyz)
        SetBlipSprite(blip, 616)
        SetBlipDisplay(blip, 2)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 18)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(_U('drugrun_blip'))
        EndTextCommandSetBlipName(blip)
    end
end)