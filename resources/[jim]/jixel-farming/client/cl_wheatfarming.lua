

if WheatZone.Enabled then
local wheatPlants = {}
local SpawnedWheat = #wheatPlants
local isPickingUp = false
local inTrailerZone = false
local Parking = {}
local Targets = {}
local Props = {}
local wheatZone = CircleZone:Create(WheatZone.Zones.WheatField.coords, WheatZone.Zones.WheatField.radius,
    { name = "wheatfield", debugPoly = Config.DebugOptions.Debug })
local trailerZone = CircleZone:Create(WheatZone.Zones.TrailerLoc.coords, WheatZone.Zones.TrailerLoc.radius,
{ name = "trailerzone", debugPoly = Config.DebugOptions.Debug })
local currentVeh = { out = false, current = nil, yeehawTractor = false }
local trailerout = nil
local canWheat = true
local Keys = {
    [322] = 'ESC', [288] = 'F1', [289] = 'F2', [170] = 'F3', [166] = 'F5', [167] = 'F6', [168] = 'F7', [169] = 'F8', [56] = 'F9', [57] = 'F10',
    [243] = '~', [157] = '1', [158] = '2', [160] = '3', [164] = '4', [165] = '5', [159] = '6', [161] = '7', [162] = '8', [163] = '9', [84] = '-', [83] = '=', [177] = 'BACKSPACE',
    [37] = 'TAB', [44] = 'Q', [32] = 'W', [38] = 'E', [45] = 'R', [245] = 'T', [246] = 'Y', [303] = 'U', [199] = 'P', [39] = '[', [40] = ']', [18] = 'ENTER',
    [137] = 'CAPS', [34] = 'A', [8] = 'S', [9] = 'D', [23] = 'F', [47] = 'G', [74] = 'H', [311] = 'K', [182] = 'L',
    [21] = 'LEFTSHIFT', [20] = 'Z', [73] = 'X', [26] = 'C', [0] = 'V', [29] = 'B', [249] = 'N', [244] = 'M', [82] = ',', [81] = '.',
}
--TODO refactor to work similar to cigar farming in later update
CreateThread(function()
	local wheatzonekey = WheatZone.PickUpKey
	local key = Keys[wheatzonekey]
    wheatZone:onPlayerInOut(function(isPointInside)
        if isPointInside then
			if canWheat == true then
				SpawnWheat()
				exports[Config.CoreOptions.CoreName]:DrawText(key.."- Pick Up Wheat", "right")
				local nearbyObject = nil
				local playerPed = PlayerPedId()
				local pedCoords
				CreateThread(function()
					while isPointInside do
						if IsControlJustPressed(0, wheatzonekey) then
							pedCoords = GetEntityCoords(playerPed)
							nearbyObject = GetClosestObjectOfType(pedCoords, WheatZone.PickupDistance, GetHashKey(WheatZone.WheatPlant), false, false, false)
							if Config.DebugOptions.Debug then print("the ped coords are: "..pedCoords) end
								if Config.DebugOptions.Debug then print("the obj distance is: "..nearbyObject) end
							if nearbyObject == 0 then
								triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["notonwheat"], "error")
							else
								if not currentVeh.current then -- checks if in tractor is the tractor we got from the farm tractor spawn guy
									triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["notractor"], "error")
								else
									if WheatZone.TractorOptions.RakeNeeded then
										if HasRake() then
											PickThing("jixel-farming:client:PickWheat")
										end
									else
										PickThing("jixel-farming:client:PickWheat")
									end
								end
							end
							Wait(100)
						end
						Wait(100)
					end
				end)
			end
        else
			DeSpawnWheat()
            DeleteWaypoint()
            exports[Config.CoreOptions.CoreName]:HideText()
        end
    end)
end)

if WheatZone.TractorOptions.RakeNeeded then
	CreateThread(function()
		trailerZone:onPlayerInOut(function(isPointInside)
		if isPointInside then
			inTrailerZone = true
			if currentVeh.current then
			exports[Config.CoreOptions.CoreName]:DrawText("Back Up Into Rake Slowly to Attach", "right")
			SetNewWaypoint(WheatZone.Zones.WheatField.coords.x, WheatZone.Zones.WheatField.coords.y)
				CreateThread(function()
					while inTrailerZone do
							AttachVehicleToTrailer(currentVeh, trailerout, 1.1)
				Wait(100)
					end
				end)
			else
				triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["notractor"], "error")
			end
		else
			inTrailerZone = false
			exports['qb-core']:HideText()
			end
		end)
	end)
end

RegisterNetEvent("jixel-farming:client:PickWheat", function()
    local Ped = PlayerPedId()
    local coords = GetEntityCoords(Ped)
    local nearbythefuckingObject, nearbyID
	local effect = WheatZone.Effect
    for i=1, #wheatPlants, 1 do
        if #(coords-GetEntityCoords(wheatPlants[i])) < 2 then
            nearbythefuckingObject, nearbyID = wheatPlants[i], i
        end
    end
    if currentVeh.yeehawTractor and nearbythefuckingObject then
		if not isPickingUp then isPickingUp = true
			if Config.ScriptOptions.ParticleFXEnabled then
			CreateThread(function()
				Wait(200)
				loadPtfxDict("core")
				while isPickingUp do
					UseParticleFxAssetNextCall("core")
					particle = StartParticleFxLoopedAtCoord(effect, GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z+2, 0.0, 0.0, GetEntityHeading(PlayerPedId())-180.0, WheatZone.Scale, 0.0, 0.0, 0.0)
					Wait(5000)
					StopParticleFxLooped(particle, true)
				end
			end)
			end
			if progressBar({label = (Loc[Config.CoreOptions.Lan].progress["progress_harvesting"].." Wheat"), time = 5000, cancel = true}) then
				TriggerServerEvent('jixel-farming:server:pickWheat')
				ClearPedTasks(Ped)
				StopParticleFxLooped(particle, true)
				DeleteObject(nearbythefuckingObject)
				table.remove(wheatPlants, nearbyID)
				SpawnedWheat -= 1
				if Config.DebugOptions.Debug then
					print(SpawnedWheat)
				end
				isPickingUp = false
				toggleCanWheat()
				if SpawnedWheat == 0 then
					SpawnWheat()
				end
			end
		end
    elseif not currentVeh.yeehawTractor and nearbythefuckingObject then
        triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["notinveh"], "error")
    end
end)

RegisterNetEvent('jixel-farming:client:TryPickWheat', function (canPick)
	if canPick then
		TriggerEvent("jixel-farming:client:pickWheat")
	else
		triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["notwheat"], "error")
	end
end)

--- GARAGE TRACTOR STUFF
CreateThread(function()
	for k, v in pairs(WheatZone.Locations) do
		if v.garage then
			local out = v.garage.out
			if v.BlipEnabled then
			makeBlip({coords = out, sprite = v.BlipSprite, col = v.BlipColor, scale = v.BlipScale, disp = v.Disp, name = v.BlipLabel }) end
			if v.garage.ped then Parking[#Parking+1] = makePed(v.garage.ped.model, out, 1, 1, v.garage.ped.scenario)
			else Parking[#Parking+1] = makeProp({prop = "prop_parkingpay", coords = vector4(out.x, out.y, out.z, out.w-180.0)}, 1, false) end
			Targets["TractorGarage: "..k] =
			exports['qb-target']:AddBoxZone("TractorGarage: "..k, vector3(out.x, out.y, out.z-1.03), 0.8, 0.5, { name="TractorGarage: "..k, heading = out.w+180.0, debugPoly=Config.DebugOptions.Debug, minZ=out.z-1.05, maxZ=out.z+0.80 },
				{ options = { { event = "jixel-farming:client:Garage:Menu", icon = "fas fa-clipboard", label = "Get Your Farm Vehicles", job = v.job, coords = v.garage.spawn, list = v.garage.list, prop = Parking[#Parking] }, },
				distance = 2.0 })
		end
	end
end)

RegisterNetEvent('jixel-farming:client:Garage:Menu', function(data)
	loadAnimDict('amb@prop_human_atm@male@enter') TaskPlayAnim(PlayerPedId(), 'amb@prop_human_atm@male@enter', "enter", 1.0,-1.0, 1500, 1, 1, true, true, true)
	local vehicleMenu = { { icon = "fas fa-car-tunnel", header = "Tractor Garage", isMenuHeader = true } }
	vehicleMenu[#vehicleMenu + 1] = { icon = "fas fa-circle-xmark", header = "", txt = Loc[Config.CoreOptions.Lan].menu["close"], params = { event = "jixel-farming:Menu:Close" } }
	if currentVeh.out and DoesEntityExist(currentVeh.current) then
		vehicleMenu[#vehicleMenu+1] = { icon = "fas fa-clipboard-list", header = Loc[Config.CoreOptions.Lan].menu["out_of_garage"],
										txt = Loc[Config.CoreOptions.Lan].menu["garage_vehicle"]..Loc[Config.CoreOptions.Lan].menu["vehicle_plate"]..GetVehicleNumberPlateText(currentVeh.current),
										params = { event = "jixel-farming:client:Garage:Blip", }, }
		vehicleMenu[#vehicleMenu+1] = { icon = "fas fa-car-burst", header = Loc[Config.CoreOptions.Lan].menu["remove_vehicle"], params = { event = "jixel-farming:client:RemSpawn" } }
	else
		currentVeh = { out = false, current = nil, yeehawTractor = false }
		table.sort(data.list, function(a, b) return a:lower() < b:lower() end)
		for _, v in pairs(data.list) do
			local spawnName = v
			local name = string.lower(GetDisplayNameFromVehicleModel(GetHashKey(spawnName))) name = name:sub(1,1):upper()..name:sub(2).." "..GetMakeNameFromVehicleModel(GetHashKey(tostring(spawnName)))
			for _, b in pairs(QBCore.Shared.Vehicles) do
				if tonumber(b.hash) == GetHashKey(spawnName) then
					if Config.DebugOptions.Debug then print("^5Debug^7: ^2Vehicle^7: ^6"..b.hash.." ^7(^6"..b.name.." "..b.brand.."^7)") end
					name = b.name.." "..b.brand
				end
			end
			vehicleMenu[#vehicleMenu+1] = { header = name, params = { event = "jixel-farming:client:SpawnList", args = { spawnName = spawnName, coords = data.coords } } }
			if Config.DebugOptions.Debug then print("^5Debug^7: Added vehicle "..name.." to garage menu and spawned it at " ..data.coords.." its spawnName is "..spawnName.." ") end
		end
	end
    exports['qb-menu']:openMenu(vehicleMenu)
end)

RegisterNetEvent("jixel-farming:client:SpawnList", function(data)
    if type(data) == "table" and type(data.spawnName) == "string" then
        local coords = data.coords
        local spawnName = data.spawnName
        local oldveh = GetClosestVehicle(coords.x, coords.y, coords.z, 2.5, 0, 71)
        if oldveh ~= 0 then
            local vehModel = GetEntityModel(oldveh)
            local vehName = GetDisplayNameFromVehicleModel(vehModel):lower()
            for k, v in pairs(QBCore.Shared.Vehicles) do
                if tonumber(v.hash) == vehModel then
                    if Config.DebugOptions.Debug then
                        print("^5Debug^7: Vehicle^7: ^6"..v.hash.." ^7(^6"..QBCore.Shared.Vehicles[k].name..")")
                    end
                    vehName = QBCore.Shared.Vehicles[k].name
                    break
                end
            end
            triggerNotify(nil, vehName..Loc[Config.CoreOptions.Lan].error["in_way"], "error")
        else
            spawnVehicle(spawnName, coords+2.5, WheatZone.TractorOptions.RakeNeeded)
        end
    else
        error("Invalid data object received: ", data)
    end
end)

RegisterNetEvent("jixel-farming:client:RemSpawn")
AddEventHandler("jixel-farming:client:RemSpawn", function()
    returnVehicle()
end)

local markerOn = false
RegisterNetEvent("jixel-farming:client:Garage:Blip", function()
	triggerNotify(nil, Loc[Config.CoreOptions.Lan].info["vehicle_map"])
	if markerOn then markerOn = not markerOn end
	markerOn = true
	local carBlip = GetEntityCoords(currentVeh.current)
	if not DoesBlipExist(garageBlip) then
		garageBlip = AddBlipForCoord(carBlip.x, carBlip.y, carBlip.z)
		SetBlipColour(garageBlip, 8)
		SetBlipRoute(garageBlip, true)
		SetBlipSprite(garageBlip, 85)
		SetBlipRouteColour(garageBlip, 3)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(Loc[Config.CoreOptions.Lan].info["job_vehicle"])
		EndTextCommandSetBlipName(garageBlip)
	end
	while markerOn do
		local time = 5000
		local carLoc = GetEntityCoords(currentVeh.current)
		local playerLoc = GetEntityCoords(PlayerPedId())
		if DoesEntityExist(currentVeh.current) then
			if #(carLoc - playerLoc) <= 30.0 then time = 100
			elseif #(carLoc - playerLoc) <= 1.5 then
				RemoveBlip(garageBlip)
				garageBlip = nil
				markerOn = not markerOn
			else time = 5000 end
		else
			RemoveBlip(garageBlip)
			garageBlip = nil
			markerOn = not markerOn
		end
		Wait(time)
	end
end)

------ Functions
function ValidateWheatCoord(plantCoord)
    local validate = true
    if SpawnedWheat > 0 then
        for k, v in pairs(wheatPlants) do
            if #(plantCoord-GetEntityCoords(v)) < 5 then
                validate = false
                break
            end
        end
    end
    if Config.DebugOptions.Debug then print(string.format("Validation of wheat coordinate %s: %s", json.encode(plantCoord), validate)) end
    return validate
end

function GenerateWheatCoords()
    local valid = true
    while valid do
        Wait(1)
        local wheatCoordX, wheatCoordY
        math.randomseed(GetGameTimer())
        local modX = math.random(-20, 20)
        Wait(100)
        math.randomseed(GetGameTimer())
        local modY = math.random(-20, 20)
        wheatCoordX = WheatZone.Zones.WheatField.coords.x + modX
        wheatCoordY = WheatZone.Zones.WheatField.coords.y + modY
        local coordZ = GetCoordZ(wheatCoordX, wheatCoordY)
        local coord = vector3(wheatCoordX, wheatCoordY, coordZ)
        if ValidateWheatCoord(coord) then
            valid = false
           if Config.DebugOptions.Debug then print(string.format("Generated wheat coordinate %s", json.encode(coord))) end
            return coord
        end
    end
end

function SpawnWheat()
	while SpawnedWheat < 10 do
		Wait(0)
		local wheatCoords = GenerateWheatCoords()
		RequestModel("prop_veg_crop_04")
		while not HasModelLoaded("prop_veg_crop_04") do
			Wait(100)
		end
		local obj = makeWheat({prop = "prop_veg_crop_04", coords = wheatCoords.xyz}, false, false)
		while not DoesEntityExist(obj) do
            Wait(10)
        end
		FreezeEntityPosition(obj, true)
		table.insert(wheatPlants, obj)
		SpawnedWheat += 1
		if Config.DebugOptions.Debug then print(SpawnedWheat) end
	end
end


function DeSpawnWheat()
    for _, v in pairs(wheatPlants) do unloadModel(GetEntityModel(v)) DeleteObject(v) end
	SpawnedWheat = 0
end

function spawnVehicle(spawnName, coords, rakeNeeded)
	local depositNeeded = WheatZone.TractorOptions.DepositNeeded
	local money = nil
	if depositNeeded then
		local p = promise.new()
		QBCore.Functions.TriggerCallback('jixel-farming:TractorRent', function(cb) p:resolve(cb) end)
		money = Citizen.Await(p)
	end
	if not depositNeeded or (depositNeeded and money) then
		print(spawnName)
		QBCore.Functions.SpawnVehicle(spawnName, function(veh)
			print(tostring(veh))
			currentVeh = { out = true, current = veh, yeehawTractor = true }
			SetVehicleModKit(veh, 0)
			NetworkRequestControlOfEntity(veh)
			SetVehicleNumberPlateText(veh, "FARM"..tostring(math.random(1000, 9999)))
			SetEntityHeading(veh, coords.w)
			TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
			SetVehicleColours(veh, 38, 38)
			TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
			exports[WheatZone.TractorOptions.Fuel]:SetFuel(veh, 100)
			SetVehicleEngineOn(veh, true, true)
			Wait(250)
			SetVehicleDirtLevel(veh, 0.0)
			triggerNotify(nil, Loc[Config.CoreOptions.Lan].success["retrieved"].." Tractor - ["..GetVehicleNumberPlateText(currentVeh.current).."]", "success")
			triggerNotify(nil, Loc[Config.CoreOptions.Lan].notification["attachtrailer"], "primary")
			if depositNeeded then
				TriggerServerEvent("jixel-farming:server:TractorRent")
			end
			if rakeNeeded then
				SetNewWaypoint(WheatZone.Zones.TrailerLoc.coords.x, WheatZone.Zones.TrailerLoc.coords.y)
			else
				SetNewWaypoint(WheatZone.Zones.WheatField.coords.x, WheatZone.Zones.WheatField.coords.y)
			end
			if Config.DebugOptions.Debug then
				print("^5Debug^7: ^2Vehicle^7: ^6 Spawned"..coords.."^7)")
				print("^Veh = ^7:"..json.encode(currentVeh.current))
			end
		end, coords, true)
		if rakeNeeded then
			QBCore.Functions.SpawnVehicle("raketrailer", function(trailer)
				trailerout = trailer
				NetworkRequestControlOfEntity(trailer)
				SetEntityHeading(trailer, 43.81)
				Wait(250)
				SetVehicleDirtLevel(trailer, 0.0)
				if Config.DebugOptions.Debug then
					print("^CurrentTrailerOut = ^7:"..json.encode(trailerout))
					print("^4Debug^7: ^6Trailer^7: ^6 Spawned"..WheatZone.Zones.TrailerLoc.coords.."^7) ")
				end
			end, WheatZone.Zones.TrailerLoc.coords, true)
		end
	end
end

function HasRake()
	local trailerAttached, currentTrailer = GetVehicleTrailerVehicle(currentVeh.current)
	if not trailerAttached then
		triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["norake"], "error")
		return false
	elseif currentTrailer ~= trailerout then
		triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["wrongrake"], "error")
		return false
	end
	return  true
end

function returnVehicle()
	local depositNeeded = WheatZone.TractorOptions.DepositNeeded
	if currentVeh.out then
		if depositNeeded then
            TriggerServerEvent("jixel-farming:TractorMoneyReturn")
        end
		SetVehicleEngineHealth(currentVeh.current, 200.0)
		SetVehicleBodyHealth(currentVeh.current, 200.0)
		for i = 0, 7 do SmashVehicleWindow(currentVeh.current, i) Wait(150) end
		PopOutVehicleWindscreen(currentVeh.current)
		for i = 0, 5 do SetVehicleTyreBurst(currentVeh.current, i, true, 0) Wait(150) end
		for i = 0, 5 do SetVehicleDoorBroken(currentVeh.current, i, false) Wait(150) end
		for i = 0, 5 do IsVehicleBumperBrokenOff(currentVeh.current, i, false) Wait(150) end
		Wait(800)
		if Config.DebugOptions.Debug then print("^5Debug^7: Deleting vehicle...") end
		QBCore.Functions.DeleteVehicle(currentVeh.current)
		if Config.DebugOptions.Debug then print("^5Debug^7: Vehicle deleted") end
		currentVeh = { out = false, current = nil, yeehawTractor = false}
		if WheatZone.TractorOptions.RakeNeeded then
			QBCore.Functions.DeleteVehicle(trailerout)
			trailerout = nil
		end
		if Config.DebugOptions.Debug then
			print("^5Debug^7: "..Loc[Config.CoreOptions.Lan].success["returned_veh"])
			print("^5Debug^7: currentVeh = "..json.encode(currentVeh))
		end
		triggerNotify(nil, Loc[Config.CoreOptions.Lan].success["returned_veh"], "success")
	end
end

AddEventHandler('onResourceStop', function(r) if r ~= GetCurrentResourceName() then return end
		for _, v in pairs(wheatPlants) do unloadModel(GetEntityModel(v)) DeleteObject(v) end
		for _, k in pairs(Props) do unloadModel(GetEntityModel(k)) DeleteObject(k) end
		for a in pairs(Targets) do exports['qb-target']:RemoveZone(a) end
		for d in pairs(Parking) do unloadPed(d) end
		exports[Config.CoreOptions.CoreName]:HideText()
	end)
end