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
local PlayerLevel = 0

local SupplierPosition = nil
local usedLocations = {}

local selectedRouteIndex = 1
local car = 0
local oxyVeh
local oxyPed

local timer = 0
local resetTime = false
local isInside = false

-- Create Ped
function CreatePedAtCoords(pedModel, coords, scenario)
    if type(pedModel) == "string" then pedModel = GetHashKey(pedModel) end
	SD.utils.LoadModel(pedModel)
    local ped = CreatePed(0, pedModel, coords.x, coords.y, coords.z, coords.w, false, false)
    FreezeEntityPosition(ped, true)
	TaskStartScenarioInPlace(ped, scenario, 0, true)
    SetEntityVisible(ped, true)
    SetEntityInvincible(ped, true)
    PlaceObjectOnGroundProperly(ped)
    SetBlockingOfNonTemporaryEvents(ped, true)

	SD.target.AddTargetEntity(ped, {
        options = {
            {
				type = "client",
				event = "sd-oxyrun:client:start",
				icon = Config.Ped.Interaction.Icon,
				label = Lang:t("target.oxyboss"),
				canInteract = function()
					if not isOnRun then
						return true
					end
				end
            },
        },
        distance = Config.Ped.Interaction.Distance
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
    local ped =  CreatePedAtCoords(Config.Ped.Model, GlobalState.OxyBossLocation, Config.Ped.Scenario)
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
        local blip = AddBlipForCoord(GlobalState.OxyBossLocation.x, GlobalState.OxyBossLocation.y, GlobalState.OxyBossLocation.z)
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

        if Config.CheckForItem.Enable then
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

                    SD.utils.LoadAnim('misscarsteal4@actor')
                    TaskPlayAnim(ped, "misscarsteal4@actor", "actor_berating_loop", 8.0, 8.0, 50000, 49, 1, 0, 0, 0)

                    SD.StartProgress('talk_to_boss', Lang:t("progress.talking_to_boss"), 4000, function()
                        ClearPedTasks(ped)
                        TriggerServerEvent('sd-oxyrun:server:startr')
                    end, function()
                        ClearPedTasks(ped)
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

                SD.utils.LoadAnim('misscarsteal4@actor')
                TaskPlayAnim(ped, "misscarsteal4@actor", "actor_berating_loop", 8.0, 8.0, 50000, 49, 1, 0, 0, 0)

                SD.StartProgress('talk_to_boss', Lang:t("progress.talking_to_boss"), 4000, function()
                    ClearPedTasks(ped)

                    TriggerServerEvent('sd-oxyrun:server:startr')
                end, function()
                    ClearPedTasks(ped)
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

RegisterNetEvent("sd-oxyrun:createOxyVehicle", function()
    local routeConfig = Config.Routes[PlayerLevel][selectedRouteIndex]
    local loc = routeConfig.locations
    local oxyVehicleModel = GetHashKey(Config.Cars[math.random(1, #Config.Cars)])
    local heading = routeConfig.info.startHeading

    if IsModelValid(oxyVehicleModel) then
        if IsThisModelACar(oxyVehicleModel) then
            SD.utils.LoadModel(oxyVehicleModel)

            if not DoesEntityExist(oxyVeh) then
                oxyVeh = CreateVehicle(oxyVehicleModel, loc[1].pos.x, loc[1].pos.y, loc[1].pos.z, heading, true, false)
                SetEntityAsMissionEntity(oxyVeh, true, true)
                SetVehicleEngineOn(oxyVeh, true, true, false)
                SetModelAsNoLongerNeeded(oxyVehicleModel)
                SetHornEnabled(oxyVeh, true)
                StartVehicleHorn(oxyVeh, 1000, GetHashKey("NORMAL"), false)
            end
        end
    end

    local model = GetHashKey(Config.DriverPed[math.random(#Config.DriverPed)])

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
    TaskVehicleDriveToCoordLongrange(oxyPed, oxyVeh, loc[2].pos.x, loc[2].pos.y, loc[2].pos.z, 7.5, Config.DriveStyle, 4.0)
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

AddEventHandler("sd-oxyrun:deleteOxyVehicle", function(ped, veh)
    local routeConfig = Config.Routes[PlayerLevel][selectedRouteIndex]
    local loc = routeConfig.locations
	SetPedKeepTask(ped, false)
	TaskVehicleDriveToCoordLongrange(oxyPed, oxyVeh, loc[3].pos.x,loc[3].pos.y,loc[3].pos.z, 7.5, Config.DriveStyle, 4.0)
	Wait(Config.TimeBetweenCars.Min*800)
	DeleteEntity(oxyPed)
	DeleteEntity(oxyVeh)
end)

-- Function that handles package delivery
local function deliverPackage(success)
    if holdingBox then
        SD.target.RemoveTargetEntity(oxyVeh)
        TriggerEvent("sd-oxyrun:deleteOxyVehicle", oxyPed, oxyVeh)
        if currentCars <= deliveries then
            currentCars = currentCars + 1
            SD.ShowNotification('' .. currentCars .. '/' .. deliveries .. '')
            if math.random(1, 100) <= Config.Levels[PlayerLevel].CallCopsChance then
                policeAlert()
            end
        end

        if success then TriggerServerEvent("sd-oxyrun:server:deliver", true, true) else TriggerServerEvent('sd-oxyrun:server:removeItem') end
        Delivered = true
        Wait(1000)
        Delivered = false
        if currentCars == deliveries then
            TriggerEvent("sd-oxyrun:client:endOxy")
            return
        end
        Wait(Config.TimeBetweenCars.Min*1200, Config.TimeBetweenCars.Max*1200)
        TriggerEvent("sd-oxyrun:createOxyVehicle", selectedRouteIndex)
    else
        SD.ShowNotification(Lang:t('error.no_package'), 'error')
    end
end

-- Function that starts a minigame when exchanging a package
local function packageMinigame()
    if lib ~= nil then
        local success = lib.skillCheck(Config.Levels[PlayerLevel].Robbery.Difficulty, Config.Levels[PlayerLevel].Robbery.Inputs or {'e'})
        if success then deliverPackage(true) SD.ShowNotification(Lang:t('error.stopped_robbery')) else deliverPackage(false) SD.ShowNotification(Lang:t('error.you_were_robbed')) end
    else print('ox_lib has not been imported and the minigame is not available') deliverPackage(true) end
end

-- Hand in Packages Event
RegisterNetEvent("sd-oxyrun:client:deliverPackage", function()
    if Config.Levels[PlayerLevel].Robbery.Enable and Config.Levels[PlayerLevel].Robbery.Chance >= math.random(1,100) then
    SD.ShowNotification(Lang:t('error.you_robbed'), 'error') Wait(Config.Levels[PlayerLevel].Robbery.Delay) packageMinigame() 
    else deliverPackage(true) end
end)

CreateThread(function()
    while true do
		Wait(1000)
		if gettingVehicle then
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				gettingVehicle = false
				SD.ShowNotification(Lang:t('success.suppliers_position'), 'success')
				local loc = Config.Supplier.Locations[math.random(#Config.Supplier.Locations)]
                SupplierPosition = vector3(loc.x, loc.y, loc.z)
				oxyBlip = AddBlipForCoord(loc.x, loc.y, loc.z)
				SetBlipSprite(oxyblip, 1)
				SetBlipColour(oxyBlip, 11)
				SetBlipRoute(oxyBlip, true)
				SpawnSupplier(loc)
			end
		end
	end
end)

function SpawnSupplier(loc)
    if Supplier then SD.target.RemoveTargetEntity(Supplier) end
    local SupplierHash = Config.Supplier.Peds[math.random(#Config.Supplier.Peds)]
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
    usedLocations[loc] = true
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

RegisterNetEvent('sd-oxyrun:client:sendToOxy', function()
    local source = source

    SD.ServerCallback('sd-oxyrun:server:getPlayerLevel', function(playerLevel)
        if not playerLevel then SD.ShowNotification("Unable to determine player level.", 'error') return end

        PlayerLevel = playerLevel
        deliveries = math.random(Config.Deliveries.Min, Config.Deliveries.Max)

        SD.ServerCallback("sd-oxyrun:server:getAvailableRoutes", function(availableRoutes)
            if #availableRoutes == 0 then
                SD.ShowNotification(Lang:t('error.occupied_routes'), 'error')
                return
            end

            -- Select a random route from available ones for this level
            selectedRouteIndex = availableRoutes[math.random(1, #availableRoutes)]

            TriggerServerEvent('sd-oxyrun:server:SetRouteOccupied', PlayerLevel, selectedRouteIndex, true)

            TriggerServerEvent('sd-oxyrun:server:TakeMoney')
            isOnRun = true
            gettingBox = true
            gettingVehicle = true 
            TriggerEvent('sd-oxyrun:client:email')

            if Config.Cooldown.EnablePersonalCooldown then TriggerEvent('sd-oxyrun:client:cooldown') end

            if Config.Cooldown.EnableTimeout then
                SetTimeout(Config.Cooldown.Timeout * 60000, function()
                    TriggerEvent('sd-oxyrun:client:endOxy')
                end)
            end
        end, playerLevel) 
    end)
end)

local function getUniqueLocation()
    local loc repeat loc = Config.Supplier.Locations[math.random(#Config.Supplier.Locations)] until not usedLocations[loc] usedLocations[loc] = true
    return loc
end

RegisterNetEvent('sd-oxyrun:client:getBox', function()
    local player = PlayerPedId()

    if gettingBox then
        if not holdingBox then
            if not IsPedInAnyVehicle(player, false) then -- Check if player is not in a vehicle
                amountOfBox = deliveries
                TriggerServerEvent('sd-oxyrun:server:addItem', SupplierPosition, isOnRun)
                if currentBoxes < amountOfBox then
                    currentBoxes = currentBoxes + 1
                    SD.ShowNotification(''.. currentBoxes .. '/' .. amountOfBox .. '')

                    if Config.Supplier.Roaming and currentBoxes ~= amountOfBox then 
                        RemoveBlip(oxyBlip) DeleteEntity(pedprop) ClearPedTasks(Supplier) Wait(500) SetPedAsNoLongerNeeded(Supplier)

                        local loc = getUniqueLocation() SpawnSupplier(loc) SupplierPosition = vector3(loc.x, loc.y, loc.z)

                        oxyBlip = AddBlipForCoord(loc.x, loc.y, loc.z)
                        SetBlipSprite(oxyblip, 1)
                        SetBlipColour(oxyBlip, 11)
                        SetBlipRoute(oxyBlip, true)
                    end

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
                        usedLocations = {}
                    end
                end
            else
                SD.ShowNotification(Lang:t('error.get_out_vehicle'), 'error')
            end
        else
            SD.ShowNotification(Lang:t('error.bring_other_package'), 'error')
        end
    else
        SD.ShowNotification(Lang:t('error.what_do_you_want'), 'error')
    end
end)

RegisterNetEvent('sd-oxyrun:client:startOxy', function()
    local carRoute = Config.Routes[PlayerLevel][selectedRouteIndex]
    local position = carRoute.locations[2].pos

    doingOxy = true
    oxyBlip = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(oxyBlip, 1)
    SetBlipColour(oxyBlip, 11)
    SetBlipRoute(oxyBlip, true)
end)

RegisterNetEvent('sd-oxyrun:client:sendCar', function()
	if doingOxy and atOxy then
		TriggerServerEvent("sd-oxyrun:server:sendCar", selectedRouteIndex)
	end
end)

RegisterNetEvent('sd-oxyrun:client:endOxy', function()
    TriggerServerEvent('sd-oxyrun:server:SetRouteOccupied', PlayerLevel, selectedRouteIndex, false)

    isOnRun = false
    currentCars = 0
    doingOxy = false
    atOxy = false
    selectedRouteIndex = 0
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
    for level, routes in pairs(Config.Routes) do
        for _, route in ipairs(routes) do
            local position = route.locations[2].pos

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
    end
end)

-- E-Mail Creation
local function sendEmail(messageKey)
    local message = Lang:t(messageKey)
    local sender = Lang:t(messageKey == "mailstart.message" and "mailstart.sender" or "mailfinish.sender")
    local subject = Lang:t(messageKey == "mailstart.message" and "mailstart.subject" or "mailfinish.subject")

    SD.utils.SendEmail(sender, subject, message)
end

RegisterNetEvent('sd-oxyrun:client:email', function() 
    if Config.SendEmail then
        SD.ShowNotification(Lang:t("success.send_email_right_now"), 'success')
        sendEmail("mailstart.message")
    else
        SD.ShowNotification(Lang:t("success.start_run"), 'success')
    end
end)

RegisterNetEvent('sd-oxyrun:client:endemail', function() 
    if Config.SendEmail then
        sendEmail("mailfinish.message")
    end
end)
