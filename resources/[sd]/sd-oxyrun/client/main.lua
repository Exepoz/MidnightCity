local SD = exports['sd_lib']:getLib()

local zoneEntered = false
local Cooldown = false
local deliveries = 0
local gettingBox = false
local amountOfBox = 0
local gettingVehicle = false
local Delivered = false
local holdingBox = false
local isOnRun = false
local doingOxy = false
local atOxy = false
local currentCars = 0
local currentBoxes = 0

local SupplierPosition = nil

local Routes = 1
local car = 0
local oxyVeh
local oxyPed

local timer = 0
local resetTime = false
local isInside = false

-- Create Ped
function CreatePedAtCoords(pedModel, coords)
    if type(pedModel) == "string" then pedModel = GetHashKey(pedModel) end
	SD.utils.LoadModel(pedModel)
    local ped = CreatePed(0, pedModel, coords.x, coords.y, coords.z, coords.w, false, false)
    FreezeEntityPosition(ped, true)
	TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
    SetEntityVisible(ped, true)
    SetEntityInvincible(ped, true)
    PlaceObjectOnGroundProperly(ped)
    SetBlockingOfNonTemporaryEvents(ped, true)

	SD.target.AddTargetEntity(ped, {
        options = {
            {
				type = "client",
				event = "sd-oxyrun:client:start",
				icon = "fas fa-circle",
				label = Lang:t("target.oxyboss"),
				canInteract = function()
					if not isOnRun then
						return true
					end
				end
            },
        },
        distance = 3.0
    })

	AddEventHandler("onResourceStop", function(resource)
        if resource == GetCurrentResourceName() then
            DeleteEntity(ped)
        end
    end)
	
    return ped
end

RegisterNetEvent('sd-oxyrun:client:setLocationAvailable', function(loc, available)
	Config.PickUpLocations[loc].available = available
end)

CreateThread(function()
    while not GlobalState.OxyBossLocation do Wait(0) end
    local ped = CreatePedAtCoords(Config.BossPed, GlobalState.OxyBossLocation)
end)

function hasPackageChanged()
    local player = PlayerPedId()
        hasPackage = SD.HasItem(Config.Items.Package, 1)
        if hasPackage then
            if not holdingBox then
                holdingBox = true
                SD.utils.LoadAnim('anim@heists@box_carry@')
                TaskPlayAnim(player, 'anim@heists@box_carry@', 'idle', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
                CarryAnimation()
                SD.utils.LoadModel('hei_prop_heist_box')
                OxyBox = CreateObject('hei_prop_heist_box', 0, 0, 0, true, true, true)
                AttachEntityToEntity(OxyBox, player, GetPedBoneIndex(player, 0xEB95), 0.075, -0.10, 0.255, -130.0, 105.0, 0.0, true, true, false, false, 0, true)
                DisableControls()
            end
        elseif holdingBox then
            ClearPedTasks(player)
            DeleteEntity(OxyBox)
            holdingBox = false
        end
end

CreateThread(function()
    
    while true do
        hasPackageChanged()
        
        Wait(1250)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() and holdingBox then
        ClearPedTasks(PlayerPedId())
        DeleteEntity(OxyBox)
        holdingBox = false
    end
end)

function DisableControls()
    CreateThread(function ()
        while holdingBox do
            DisableControlAction(0, 21, true) -- Sprinting
            DisableControlAction(0, 22, true) -- Jumping
            DisableControlAction(0, 23, true) -- Vehicle Entering
            DisableControlAction(0, 36, true) -- Ctrl
			DisableControlAction(0, 24, true) -- disable attack
			DisableControlAction(0, 25, true) -- disable aim
			DisableControlAction(0, 47, true) -- disable weapon
			DisableControlAction(0, 58, true) -- disable weapon
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 142, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
            Wait(1)
        end
    end)
end

function CarryAnimation()
    CreateThread( function ()
        while holdingBox do
            if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
                TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
            end
            Wait(1000)
        end
    end)
end

-- Blip Creation
CreateThread(function()
    if Config.Blip.Enable then
        local blip = AddBlipForCoord(GlobalState.OxyBossLocation)
        SetBlipSprite(blip, Config.Blip.Sprite)
        SetBlipDisplay(blip, Config.Blip.Display)
        SetBlipScale(blip, Config.Blip.Scale)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, Config.Blip.Colour)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Blip.Name)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Personal Cooldown
RegisterNetEvent('sd-oxyrun:client:cooldown', function()
    Cooldown = true
    local timer = Config.Cooldown.PersonalCooldown * 60000
    while timer > 0 do
        Wait(1000)
        timer = timer - 1000
        if timer == 0 then
            Cooldown = false
        end
    end
end)

-- Police Alert for Oxy Run (Drug Deal/Suspicious Handoff) (Used Dispatch System can be changed in sd_lib/sh_config.lua)
function policeAlert()
    SD.utils.PoliceDispatch({
        displayCode = "10-95",                   -- Suspicious vehicle/person report
        title = 'Suspicious handoff',                       -- Title is used in cd_dispatch/ps-dispatch
        description = "Suspicious handoff reported", -- Description of the event
        message = "Potential drug deal in progress", -- Additional message
        -- Blip information is used for ALL dispatches besides ps_dispatch, please reference dispatchcodename below.
        sprite = 51,                           -- The blip sprite for handoff or related icon
        scale = 1.0,                            -- The size of the blip
        colour = 1,                             -- Color of the blip
        blipText = "Suspicious handoff",                   -- Text on the Blip
        -- ps-dispatch
        dispatchcodename = "oxy_run"            -- This is the name used by ps-dispatch users for the sv_dispatchcodes.lua or config.lua under the Config.Blips entry. (Depending on Version)
    })
end 

-- Start!
RegisterNetEvent('sd-oxyrun:client:start', function()
    if Cooldown then
        SD.ShowNotification(Lang:t("error.done_recently"), 'error')
        return
    end
    
    SD.ServerCallback("sd-oxyrun:server:getCops", function(enoughCops)
        if enoughCops < Config.MinimumPolice then
            SD.ShowNotification(Lang:t("error.cannot_do_this_right_now"), 'error')
            return
        end

        if Config.CheckForItem then
            SD.ServerCallback('sd-oxyrun:server:hasItem', function(hasItem)
                if not hasItem then
                    SD.ShowNotification(Lang:t("error.missing_required_item"), 'error')
                    return
                end

                SD.ServerCallback("sd-oxyrun:server:coolc", function(isCooldown)
                    if isCooldown then
                        SD.ShowNotification(Lang:t("error.someone_recently_did_this"), 'error')
                        return
                    end

                    local ped = PlayerPedId()

                    if Config.EnableAnimation then
                        SD.utils.LoadAnim('misscarsteal4@actor')
                        TaskPlayAnim(ped, "misscarsteal4@actor", "actor_berating_loop", 8.0, 8.0, 50000, 49, 1, 0, 0, 0)
                    end

                    SD.StartProgress('talk_to_boss', Lang:t("progress.talking_to_boss"), 4000, function()
                        if Config.EnableAnimation then
                            ClearPedTasks(ped)
                        end

                        TriggerServerEvent('sd-oxyrun:server:startr')
                    end, function()
                        if Config.EnableAnimation then
                            ClearPedTasks(ped)
                        end
                        SD.ShowNotification(Lang:t("error.canceled"), 'error')
                    end)
                end)
            end)
        else
            -- If no item check, directly Check Cooldown
            SD.ServerCallback("sd-oxyrun:server:coolc", function(isCooldown)
                if isCooldown then
                    SD.ShowNotification(Lang:t("error.someone_recently_did_this"), 'error')
                    return
                end

                -- Start Animation and Progress
                local ped = PlayerPedId()

                if Config.EnableAnimation then
                    SD.utils.LoadAnim('misscarsteal4@actor')
                    TaskPlayAnim(ped, "misscarsteal4@actor", "actor_berating_loop", 8.0, 8.0, 50000, 49, 1, 0, 0, 0)
                end

                SD.StartProgress('talk_to_boss', Lang:t("progress.talking_to_boss"), 4000, function()
                    if Config.EnableAnimation then
                        ClearPedTasks(ped)
                    end

                    TriggerServerEvent('sd-oxyrun:server:startr')
                end, function()
                    if Config.EnableAnimation then
                        ClearPedTasks(ped)
                    end
                    SD.ShowNotification(Lang:t("error.canceled"), 'error')
                end)
            end)
        end
    end)
end)

-- Car Events
function WaitTaskToEnd(ped, task)
	while GetScriptTaskStatus(ped, task) == 0 do
		Wait(250)
	end
	while GetScriptTaskStatus(ped, task) == 1 do
		Wait(250)
	end
end

RegisterNetEvent("sd-oxyrun:createOxyVehicle")
AddEventHandler("sd-oxyrun:createOxyVehicle", function(route)
	local loc = Config.Routes[route].locations
	local oxyVehicleModel = GetHashKey(Config.Cars[math.random(1,#Config.Cars)])
	local heading = Config.Routes[route].info.startHeading

	if IsModelValid(oxyVehicleModel) then
		if IsThisModelACar(oxyVehicleModel) then
			SD.utils.LoadModel(oxyVehicleModel)

			if not DoesEntityExist(oxyVeh) then
				oxyVeh = CreateVehicle(oxyVehicleModel, loc[1].pos.x,loc[1].pos.y,loc[1].pos.z, heading, true, false)
				SetEntityAsMissionEntity(oxyVeh, true, true)
				SetVehicleEngineOn(oxyVeh, true, true, false)
				SetModelAsNoLongerNeeded(oxyVehicleModel)
				SetHornEnabled(oxyVeh, true)
				StartVehicleHorn(oxyVeh, 1000, GetHashKey("NORMAL"), false)
			end
		end
	end
	local model = GetHashKey(Config.DriverPed)

	if DoesEntityExist(oxyVeh) then
		if IsModelValid(model) then
			SD.utils.LoadModel(model)

			oxyPed = CreatePedInsideVehicle(oxyVeh, 26, model, -1, true, false)
			SetAmbientVoiceName(oxyPed, "A_M_M_EASTSA_02_LATINO_FULL_01")
			SetBlockingOfNonTemporaryEvents(oxyPed, true)
			SetEntityAsMissionEntity(oxyPed, true, true)

			SetModelAsNoLongerNeeded(model)

		end
	end
	while not DoesEntityExist(oxyVeh) do
		Wait(1)
	end
	while not DoesEntityExist(oxyPed) do
		Wait(1)
	end
	RollDownWindows(oxyVeh)
	Wait(50)
	TaskVehicleDriveToCoordLongrange(oxyPed, oxyVeh, loc[2].pos.x,loc[2].pos.y,loc[2].pos.z, 7.5, Config.DriveStyle, 4.0)
	SetPedKeepTask(oxyPed, true)
	WaitTaskToEnd(oxyPed, 567490903)
	SD.target.AddTargetEntity(oxyVeh, {
		options = {
			{
				type = "client",
				event = "sd-oxyrun:client:deliverPackage",
				icon = "fas fa-hand-holding",
				label = Lang:t("target.handoff_package"),
			},
		},
		distance = 3.0
	})
end)

AddEventHandler("sd-oxyrun:deleteOxyVehicle", function(ped, veh, route)
	SetPedKeepTask(ped, false)
	loc = Config.Routes[route].locations
	TaskVehicleDriveToCoordLongrange(oxyPed, oxyVeh, loc[3].pos.x,loc[3].pos.y,loc[3].pos.z, 7.5, Config.DriveStyle, 4.0)
	Wait(Config.MinTimeBetweenCars*800)
	DeleteEntity(oxyPed)
	DeleteEntity(oxyVeh)
end)

-- Hand in Packages
RegisterNetEvent("sd-oxyrun:client:deliverPackage")
AddEventHandler("sd-oxyrun:client:deliverPackage", function()
	if holdingBox then
		SD.target.RemoveTargetEntity(oxyVeh)
		TriggerEvent("sd-oxyrun:deleteOxyVehicle", oxyPed, oxyVeh, Routes)
		if currentCars <= deliveries then
			currentCars = currentCars + 1
			SD.ShowNotification('' .. currentCars .. '/' .. deliveries .. '')
			if math.random(1,100) <= Config.CallCopsChance then
				policeAlert()
			end
		end

		TriggerServerEvent("sd-oxyrun:server:deliver", holdingBox, doingOxy)
		Delivered = true
		Wait(1000)
		Delivered = false
		if currentCars == deliveries then
			TriggerEvent("sd-oxyrun:client:endOxy")
			return
		end
		Wait(Config.MinTimeBetweenCars*1200, Config.MaxTimeBetweenCars*1200)
		TriggerEvent("sd-oxyrun:createOxyVehicle", Routes)
	else
		SD.ShowNotification(Lang:t('error.no_package'), 'error')
	end
end)

CreateThread(function()
    while true do
		Wait(1000)
		if gettingVehicle then
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				gettingVehicle = false
				SD.ShowNotification(Lang:t('success.suppliers_position'), 'success')
				loc = Config.PickUpLocations[math.random(#Config.PickUpLocations)]
                SupplierPosition = vector3(loc.x, loc.y, loc.z)
				oxyBlip = AddBlipForCoord(loc.x, loc.y, loc.z)
				SetBlipSprite(oxyblip, 1)
				SetBlipColour(oxyBlip, 11)
				SetBlipRoute(oxyBlip, true)
				SpawnSupplier()
			end
		end
	end
end)

function SpawnSupplier()
    local SupplierHash = Config.SupplierPeds[math.random(#Config.SupplierPeds)]
	SD.utils.LoadModel(SupplierHash)
    Supplier = CreatePed(0, SupplierHash, loc.x, loc.y, loc.z-1.0, loc.w, false, true)
	pedprop = CreateObject('prop_cs_cardbox_01', 0, 0, 0, false, true, true)
    FreezeEntityPosition(Supplier, true)
    SetEntityInvincible(Supplier, true)
	SetPedKeepTask(Supplier, true)
    SetBlockingOfNonTemporaryEvents(Supplier, true)
	AttachEntityToEntity(pedprop, Supplier, GetPedBoneIndex(Supplier, 0xEB95), 0.075, -0.10, 0.255, -130.0, 105.0, 0.0, true, true, false, false, 0, true)
    SD.utils.LoadAnim('anim@heists@box_carry@')
    TaskPlayAnim(Supplier, 'anim@heists@box_carry@', 'idle', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
	SD.target.AddTargetEntity(Supplier, {
		options = {
			{
				type = "client",
				event = "sd-oxyrun:client:getBox",
				icon = "fas fa-box",
				label = Lang:t("target.oxysupplier"),
			},
		},
		distance = 2.0
	})
end


-- Set Route Status client-side
RegisterNetEvent('sd-oxyrun:client:SetRouteOccupied', function(route, toggle)
	Config.Routes[route].info.occupied = toggle
end)

-- Event to Calculate if a route is available, then sets that route to occupied
RegisterNetEvent('sd-oxyrun:client:sendToOxy', function()

	deliveries = math.random(Config.MinDeliveries, Config.MaxDeliveries)
	Routes = math.random(1, #Config.Routes)
	local totalCount = #Config.Routes + 1

	local trueCount = 1
	for _,v1 in pairs(Config.Routes) do
		if Config.Routes[_].info.occupied == true then
			trueCount = trueCount + 1
		end
	end


	if trueCount == totalCount then
		SD.ShowNotification(Lang:t('error.occupied_routes'), 'error')
	else
		isOnRun = true
		if Config.Routes[Routes].info.occupied == true then
			repeat
				Routes = math.random(1, #Config.Routes)
			until(Config.Routes[Routes].info.occupied == false)
		end

		TriggerServerEvent('sd-oxyrun:server:SetRouteOccupied', Routes, true)

		TriggerServerEvent('sd-oxyrun:server:TakeMoney')
		local carRoute = Config.Routes[Routes]

        if Config.Cooldown.EnablePersonalCooldown then
            TriggerEvent('sd-oxyrun:client:cooldown')
        end

		gettingBox = true
		gettingVehicle = true
		TriggerEvent('sd-oxyrun:client:email')
        if Config.Cooldown.EnableTimeout then
            SetTimeout(Config.Cooldown.Timeout * 60000, function()
                TriggerEvent('sd-oxyrun:client:endOxy')
            end)
        end
    end
end)

RegisterNetEvent('sd-oxyrun:client:getBox', function()
    local player = PlayerPedId() -- Get player ped

    if gettingBox then
        if not holdingBox then
            if not IsPedInAnyVehicle(player, false) then -- Check if player is not in a vehicle
                amountOfBox = deliveries
                TriggerServerEvent('sd-oxyrun:server:addItem', SupplierPosition, isOnRun)
                if currentBoxes < amountOfBox then
                    currentBoxes = currentBoxes + 1
                    SD.ShowNotification(''.. currentBoxes .. '/' .. amountOfBox .. '')
                    if currentBoxes == amountOfBox then
                        SupplierPosition = nil
                        RemoveBlip(oxyBlip)
                        SD.ShowNotification(Lang:t('success.drive_to_location'), 'success')
                        DeleteEntity(pedprop)
                        ClearPedTasks(Supplier)
                        Wait(500)
                        SetPedAsNoLongerNeeded(Supplier)
                        TriggerEvent("sd-oxyrun:client:startOxy")
                        gettingBox = false
                    end
                end
            else
                SD.ShowNotification(Lang:t('error.get_out_vehicle'), 'error') -- Notify the player to get out of the vehicle
            end
        else
            SD.ShowNotification(Lang:t('error.bring_other_package'), 'error')
        end
    else
        SD.ShowNotification(Lang:t('error.what_do_you_want'), 'error')
    end
end)

RegisterNetEvent('sd-oxyrun:client:startOxy', function()
	local carRoute = Config.Routes[Routes]
	local carRoute = carRoute
	position = carRoute.locations[2].pos

	doingOxy = true
	oxyBlip = AddBlipForCoord(position)
	SetBlipSprite(oxyblip, 1)
	SetBlipColour(oxyBlip, 11)
	SetBlipRoute(oxyBlip, true)
end)

RegisterNetEvent('sd-oxyrun:client:sendCar', function()
	if doingOxy and atOxy then
		TriggerServerEvent("sd-oxyrun:server:sendCar", Routes)
	end
end)

RegisterNetEvent('sd-oxyrun:client:endOxy', function()
    TriggerServerEvent('sd-oxyrun:server:SetRouteOccupied', Routes, false)

    isOnRun = false
    currentCars = 0
    doingOxy = false
    atOxy = false
    Routes = 0
    currentBoxes = 0
    Delivered = false
    zoneEntered = false
    amountOfBox = 0
    deliveries = 0

    if DoesEntityExist(oxyVeh) and not isInside then
        Wait(5000)
        DeleteVehicle(oxyVeh)
        DeleteEntity(oxyPed)
    end

    if DoesEntityExist(Supplier) then
        DeleteEntity(Supplier)
    end

    if Config.SendEmail then
        TriggerEvent('sd-oxyrun:client:endemail')
    else
        SD.ShowNotification(Lang:t('success.run_ended'), 'success')
    end

    TriggerServerEvent('sd-oxyrun:server:setLocationAvailable', lastLocation, true)

    RemoveBlip(oxyBlip)
end)

AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
        return
    end

    RemoveBlip(oxyBlip)
    for route = 1, #Config.Routes do
        local curr = Config.Routes[route]
        local curr = curr
        local position = curr.locations[2].pos

        DropZone = BoxZone:Create(vector3(position.x, position.y, position.z), 20.0, 20.0, {
            name="AtOxy",
            heading=335.31,
            minZ=position.z-10,
            maxZ=position.z+5,
            debugPoly = Config.OxyRunDebug
        })
        DropZone:onPlayerInOut(function(isPointInside)
            if isPointInside then
                atOxy = true
                if doingOxy and atOxy and not zoneEntered then
                    TriggerEvent("sd-oxyrun:client:sendCar")
                    SD.ShowNotification(Lang:t('success.arrived_location'), 'success')
                    zoneEntered = true
				end
                if timer > 0 and not isInside then
					resetTime = true
                    timer = 0
                end
				Wait(500)
				isInside = true
            else
				isInside = false
                if timer == 0 or timer == -1 then
                    timer = Config.Cooldown.BuyerTimeout * 60000
					if atOxy and doingOxy then
					SD.ShowNotification(Lang:t('error.leave_area'), 'error')
                    CreateThread(function()
                        while timer > 0 do
                            Wait(1000)
                            timer = timer - 1
                            if resetTime and isInside then
								resetTime = false
                                break
                            end
                        end
                        if timer == 0 then
                            TriggerEvent('sd-oxyrun:client:endOxy')
							timer = 0
							resetTime = false
                        end
                    end)
                end
            end
        end
	end)
    end
end)

-- E-Mail Creation
local function sendEmail(messageKey)
    local message = Lang:t(messageKey)
    if SD.Framework == 'qb' then
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = Lang:t(messageKey == "mailstart.message" and "mailstart.sender" or "mailfinish.sender"),
            subject = Lang:t(messageKey == "mailstart.message" and "mailstart.subject" or "mailfinish.subject"),
            message = message,
        })
        Wait(3000)
    else 
        print('Emails on ESX are not supported by default, you can add your own email system -- look for the print in the client')
    end
end

local function runStart()
    Wait(2000) sendEmail("mailstart.message")
end

local function runEnd()
    Wait(2000) sendEmail("mailfinish.message")
end

RegisterNetEvent('sd-oxyrun:client:email', function() 
    if Config.SendEmail then
        SD.ShowNotification(Lang:t("success.send_email_right_now"), 'success')
        runStart()
    else
        SD.ShowNotification(Lang:t("success.start_run"), 'success')
    end
end)

RegisterNetEvent('sd-oxyrun:client:endemail', function() 
    if Config.SendEmail then
        runEnd()
    end
end)
