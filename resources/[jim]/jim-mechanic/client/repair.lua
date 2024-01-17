--========================================================== Repair
local repairing = false
local br = Config.System.Menu == "ox" and "\n" or "<br>"
if not Config.Main.ItemRequiresJob or Config.Repairs.FreeRepair then Config.Repairs.StashRepair = false end

RegisterNetEvent('jim-mechanic:client:Repair:Apply', function(data, crimHub) local Ped = PlayerPedId()
	local stashName, stashItems = PlayerJob.name.."Safe", {}
	emptyHands(Ped)
	if not repairing then repairing = true else return end
	local vehicle = nil
	local above = isVehicleLift(vehicle)
	if not IsPedInAnyVehicle(Ped, false) then	vehicle = getClosest(GetEntityCoords(Ped)) pushVehicle(vehicle) end
	local getoff, bartext, cam, currentFuel = {}, Loc[Config.Lan]["repair"].repairing, nil, GetVehicleFuelLevel(vehicle)
	local repairTable = {
		["engine"] = { dict = "amb@world_human_vehicle_mechanic@male@base", anim = "base", flags = 1 },
		["body"] = { task = "WORLD_HUMAN_WELDING" },
		["oil"] = { dict = "mini@repair", anim = "fixing_a_ped", flags = 16, bartext = Loc[Config.Lan]["repair"].changing },
		["axle"] = { dict = "amb@world_human_vehicle_mechanic@male@base", anim = "base", flags = 1 },
		["spark"] = { dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", anim = "machinic_loop_mechandplayer", flags = 1, bartext = Loc[Config.Lan]["repair"].changing },
		["battery"] = { dict = "amb@world_human_vehicle_mechanic@male@base", anim = "base", flags = 1, bartext = Loc[Config.Lan]["repair"].changing },
		["fuel"] = { dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", anim = "machinic_loop_mechandplayer", flags = 1, },
		["wheels"] = { dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", anim = "machinic_loop_mechandplayer", bartext = Loc[Config.Lan]["repair"].changing },
	}
	if isVehicleLift(vehicle) then
		for k in pairs(repairTable) do repairTable[k].task = nil repairTable[k].dict = "amb@prop_human_movie_bulb@idle_a" repairTable[k].anim = "idle_b" repairTable[k].flags = 32 end
	end
	--Specific Actions/Animations
	if data.part == "engine" then
		cam = createTempCam(vehicle, Ped)
		if Config.Overrides.DoorAnimations then SetVehicleDoorOpen(vehicle, 4, false, true) end
		if #(GetEntityCoords(Ped) - GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "engine"))) >= 1.5 then
			TaskGoStraightToCoord(Ped, GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "engine")), 1.0, -1, GetEntityHeading(Ped), 0)
			Wait(600)
		end
		lookAtEngine(vehicle)
		Wait(100)
		SetEntityHeading(Ped, GetEntityHeading(Ped)-180.0)
	elseif data.part == "body" then
		cam = createTempCam(vehicle, Ped, { emergency = true })
		if Config.Overrides.DoorAnimations then SetVehicleDoorOpen(vehicle, 4, false, true) end
	elseif data.part == "oil" then
		cam = createTempCam(vehicle, Ped)
		if Config.Overrides.DoorAnimations then SetVehicleDoorOpen(vehicle, 4, false, true) end
		if #(GetEntityCoords(Ped) - GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "engine"))) >= 1.5 then
			TaskGoStraightToCoord(Ped, GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "engine")), 1.0, -1, GetEntityHeading(Ped), 0)
			Wait(600)
		end
		lookVeh(GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "engine")))
	elseif data.part == "wheels" then
		cam = createTempCam(vehicle, Ped, { wheel = true })
		local coord = nil
		for _, v in pairs({"wheel_lf", "wheel_rf", "wheel_lm1", "wheel_rm1", "wheel_lm2", "wheel_rm2", "wheel_lm3", "wheel_rm3", "wheel_lr", "wheel_rr"}) do
			if #(GetEntityCoords(Ped) - GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, v))) <= 1.5 then
				coord = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, v))
				break
			end
		end
		lookVeh(coord)
	elseif data.part == "battery" then
		cam = createTempCam(vehicle, Ped)
		if Config.Overrides.DoorAnimations then SetVehicleDoorOpen(vehicle, 4, false, true) end
		if #(GetEntityCoords(Ped) - GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "engine"))) >= 1.5 then
			TaskGoStraightToCoord(Ped, GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "engine")), 1.0, -1, GetEntityHeading(Ped), 0)
			Wait(600)
		end
		lookVeh(GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "engine")))
		Wait(100)
		SetEntityHeading(Ped, GetEntityHeading(Ped)-180.0)
	elseif data.part == "axle" then
		cam = createTempCam(vehicle, Ped)
		local coord = nil
		for _, v in pairs({"wheel_lf", "wheel_rf", "wheel_lm1", "wheel_rm1", "wheel_lm2", "wheel_rm2", "wheel_lm3", "wheel_rm3", "wheel_lr", "wheel_rr"}) do
			if #(GetEntityCoords(PlayerPedId()) - GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, v))) <= 1.5 then
				coord = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, v))
				break
			end
		end
		lookVeh(coord)
		Wait(100)
		SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId())-180.0)
	else
		cam = createTempCam(vehicle, Ped)
		lookVeh(vehicle)
	end

	if not crimHub and Config.Repairs.StashRepair and not Config.Repairs.FreeRepair then
		local p = promise.new()
		QBCore.Functions.TriggerCallback('jim-mechanic:server:GetStashItems', function(cb) p:resolve(cb) end, stashName)
		stashItems = Citizen.Await(p)
	end
	emptyHands(Ped)
	if (Config.Repairs.StashRepair and stashHasItem(stashItems, Config.Repairs.Parts[data.part].part, data.cost)) or not Config.Repairs.StashRepair or crimHub then
		if progressBar({label = bartext..data.partname, time =  math.random(8000,10000), cancel = true, dict = repairTable[data.part].dict, anim = repairTable[data.part].anim, flag = repairTable[data.part].flags, task = repairTable[data.part].task, icon = "mechanic_tools", cam = cam }) then
			repairing = false
			if data.part == "body" then
				local tirehealth = {}
				enhealth = GetVehicleEngineHealth(vehicle)
				for _, v in pairs({0, 1, 2, 3, 4, 5, 45, 47}) do
					tirehealth[v] = { health = GetVehicleWheelHealth(vehicle, v) }
					if IsVehicleTyreBurst(vehicle, v, false) == 1 or IsVehicleTyreBurst(vehicle, v, true) == 1 then
						tirehealth[v].defalte = IsVehicleTyreBurst(vehicle, v, false)
						tirehealth[v].rim = IsVehicleTyreBurst(vehicle, v, true)
					end
				end
				SetVehicleBodyHealth(vehicle, 1000.0)
				SetVehicleFixed(vehicle)
				SetVehicleEngineHealth(vehicle, enhealth)
				for _, v in pairs({0, 1, 2, 3, 4, 5, 45, 47}) do
					SetVehicleWheelHealth(vehicle, v, tirehealth[v].health)
					if tirehealth[v].deflate == 1 then SetVehicleTyreBurst(vehicle, v, 0, tirehealth[v].health)
					elseif tirehealth[v].rim == 1 then SetVehicleTyreBurst(vehicle, v, 1, 0.0) end
				end
			elseif data.part == "engine" then
				SetVehicleEngineHealth(vehicle, 1000.0) SetVehiclePetrolTankHealth(vehicle, 1000.0) SetVehicleOilLevel(vehicle, 1000.0)
			elseif data.part == "wheels" then
				for _, v in pairs({0, 1, 2, 3, 4, 5, 45, 47}) do
					if getoff[v] then SetVehicleWheelXOffset(vehicle, v, getoff[v]) end
					SetVehicleWheelHealth(vehicle, v, 1000.0)
					SetVehicleTyreFixed(vehicle, v)
				end
				TriggerEvent('kq_wheeldamage:fixCar', vehicle)
			elseif data.part ~= "engine" and data.part ~= "body" and data.part ~= "wheels" then
				SetVehicleStatus(trim(GetVehicleNumberPlateText(vehicle)), data.part, 100)
			end
			updateCar(vehicle)
			if Config.Repairs.StashRepair then stashRemoveItem(stashItems, stashName, Config.Repairs.Parts[data.part].part, data.cost) end
			if not Config.Repairs.StashRepair and not Config.Repairs.FreeRepair or crimHub then toggleItem(false, crimHub and 'midnight_crumbs' or Config.Repairs.Parts[data.part].part, data.cost) end
			triggerNotify(nil, data.partname..Loc[Config.Lan]["repair"].repaired, "success")
			Wait(250)
			TriggerEvent("jim-mechanic:client:Repair:Check")
		else
			repairing = false
			triggerNotify(nil, data.partname..Loc[Config.Lan]["repair"].cancel, "error")
		end
		if Config.Overrides.DoorAnimations then for i = 0, 5 do SetVehicleDoorShut(vehicle, i, false, true) Wait(200) end end
	else
		triggerNotify(nil, Loc[Config.Lan]["repair"].nomaterials, 'error')
		repairing = false
		return
	end
	SetVehicleFuelLevel(vehicle, currentFuel)
	--emptyHands(Ped)
end)

-- Xora Edited
local prevVehicle = nil
RegisterNetEvent('jim-mechanic:client:Repair:Check', function(skip) local Ped = PlayerPedId()
	local str = QBCore.Shared.SplitStr(inLocation, ": ")[2]
	local crimHub = Config.Locations[tonumber(str)].CriminalHub or false
	--skip = skip or Config.Locations[tonumber(str)].CriminalHub or false
	if not enforceRestriction("repairs") then return end
	if repairing then return end
	emptyHands(Ped)
	if not skip then if not crimHub and not jobChecks() then return end if not locationChecks() then return end end
	if not inCar() then return end
	if not nearPoint(GetEntityCoords(Ped)) then return end
	if not IsPedInAnyVehicle(Ped, false) then vehicle = getClosest(GetEntityCoords(Ped)) pushVehicle(vehicle) lookVeh(vehicle) end
    if not enforceClassRestriction(getClass(vehicle)) then return end
	if lockedCar(vehicle) then return end
	local stashItems = {}
	local plate = trim(GetVehicleNumberPlateText(vehicle))
	if not VehicleStatus[plate] then
		if Config.System.Debug then print("^5Debug^7: ^4VehicleStatus^7[^6"..plate.."^7]^2 not found^7,^2 loading^7...") end
		TriggerServerEvent("jim-mechanic:server:setupVehicleStatus", plate, GetVehicleEngineHealth(veh), GetVehicleBodyHealth(veh))
		while not VehicleStatus[plate] do Wait(10) end
	else TriggerServerEvent("jim-mechanic:server:getStatusList", true, plate) Wait(1000) end
	local damageTable = VehicleStatus[plate]
		damageTable["wheels"] = 0
		damageTable["engine"] = (GetVehicleEngineHealth(vehicle) / 10)
		damageTable["body"] = (GetVehicleBodyHealth(vehicle) / 10)
		for _, v in pairs({0, 1, 2, 3, 4, 5, 45, 47}) do if IsVehicleTyreBurst(vehicle, v, 0) == 1 or IsVehicleTyreBurst(vehicle, v, 1) == 1 or GetVehicleWheelHealth(vehicle, v) <= 0.0 then damageTable["wheels"] += 1 end end
	local costTable = { ["engine"] = "", ["body"] = "", ["oil"] = "", ["axle"] = "", ["spark"] = "", ["battery"] = "", ["fuel"] = "",  }
	local costCalc = {}
	if not skip then
		if not Config.Repairs.FreeRepair then
			if crimHub then
				for k, v in pairs(costTable) do
					costCalc[k] = 0
					if k == "engine" or k == "body" then
						costCalc[k] = Config.Repairs.Crumbs[k] - math.floor(Config.Repairs.Crumbs[k] * math.floor(damageTable[k]+0.5) / 100)
					else
						if Config.Repairs.ExtraDamages == true then
							costCalc[k] = (Config.Repairs.Crumbs[k] - math.floor(Config.Repairs.Crumbs[k] * math.floor((damageTable[k]+0.5) or 90) / 100)) or 0
							costCalc[k] = costCalc[k] or 0
						end
					end
					if costCalc[k] > 0 then
						costTable[k] = Loc[Config.Lan]["repair"].cost.. costCalc[k].. " " ..QBCore.Shared.Items['midnight_crumbs'].label
					end
				end
			else
				for k, v in pairs(costTable) do
					costCalc[k] = 0
					if k == "engine" or k == "body" then
						costCalc[k] = Config.Repairs.Parts[k].cost - math.floor(Config.Repairs.Parts[k].cost * math.floor(damageTable[k]+0.5) / 100)
					else
						if Config.Repairs.ExtraDamages == true then
							costCalc[k] = (Config.Repairs.Parts[k].cost - math.floor(Config.Repairs.Parts[k].cost * math.floor((damageTable[k]+0.5) or 90) / 100)) or 0
							costCalc[k] = costCalc[k] or 0
						end
					end
					if costCalc[k] > 0 then
						costTable[k] = Loc[Config.Lan]["repair"].cost.. costCalc[k].. " " ..QBCore.Shared.Items[Config.Repairs.Parts[k].part].label
					end
				end
			end
		end
	end
	if Config.Repairs.StashRepair and not crimHub then local p = promise.new() QBCore.Functions.TriggerCallback('jim-mechanic:server:GetStashItems', function(cb) p:resolve(cb) end, PlayerJob.name.."Safe") stashItems = Citizen.Await(p) end
	local RepairMenu = {}
	local headertxt = Loc[Config.Lan]["check"].plate.." ["..trim(GetVehicleNumberPlateText(vehicle)).."]"..br..(isOx() and br or "")..Loc[Config.Lan]["check"].value..searchPrice(vehicle)..br..(isOx() and br or "")..searchDist(vehicle)
	print()
	local mechjobTable = {}
	if (damageTable["wheels"] or 0) >= 1 then mechjobTable[#mechjobTable+1] = { part = "wheels", amount = damageTable["wheels"], header = Loc[Config.Lan]["repair"].tire, icon = "fas fa-compact-disc" } end
	mechjobTable[#mechjobTable+1] = { part = "engine", amount = costCalc["engine"], cost = costTable["engine"], header = Loc[Config.Lan]["repair"].engine, item = Config.Repairs.Parts["engine"].part, icon = "fas fa-wrench" }
	mechjobTable[#mechjobTable+1] = { part = "body", amount = costCalc["body"], cost = costTable["body"], header = Loc[Config.Lan]["repair"].body, item = Config.Repairs.Parts["body"].part, icon = "fas fa-car-side" }
	if Config.Repairs.ExtraDamages == true then
		mechjobTable[#mechjobTable+1] = { part = "oil", amount = costCalc["oil"], cost = costTable["oil"], header = Loc[Config.Lan]["repair"].oil, item = Config.Repairs.Parts["oil"].part, icon = "fas fa-oil-can" }
		mechjobTable[#mechjobTable+1] = { part = "axle", amount = costCalc["axle"], cost = costTable["axle"], header = Loc[Config.Lan]["repair"].driveshaft, item = Config.Repairs.Parts["axle"].part, icon = "fas fa-toolbox" }
		mechjobTable[#mechjobTable+1] = { part = "spark", amount = costCalc["spark"], cost = costTable["spark"], header = Loc[Config.Lan]["repair"].spark, item = Config.Repairs.Parts["spark"].part , icon = "fas fa-wand-magic-sparkles" }
		mechjobTable[#mechjobTable+1] = { part = "battery", amount = costCalc["battery"], cost = costTable["battery"], header = Loc[Config.Lan]["repair"].battery, item = Config.Repairs.Parts["battery"].part, icon = "fas fa-car-battery" }
		mechjobTable[#mechjobTable+1] = { part = "fuel", amount = costCalc["fuel"], cost = costTable["fuel"], header = Loc[Config.Lan]["repair"].tank, item = Config.Repairs.Parts["fuel"].part, icon = "fas fa-gas-pump" }
	end
	for _, v in pairs(mechjobTable) do
		local headerlock = false
		if math.floor(damageTable[v.part]+0.5) >= 100 then headerlock = true end
		if (Config.Repairs.StashRepair or Config.Repairs.FreeRepair) and not crimHub then
			if Config.Repairs.StashRepair then
				headerlock = not stashHasItem(stashItems, Config.Repairs.Parts[v.part].part, v.amount)
				if math.floor(damageTable[v.part]+0.5) >= 100 then headerlock = true costTable[v.part] = "" end
			end
		else
			if not HasItem(crimHub and 'midnight_crumbs' or Config.Repairs.Parts[v.part].part, v.amount) then headerlock = true
				if Config.System.Menu == "qb" then costTable[v.part] = "<span style='color:red'>"..(costTable[v.part] or damageTable["wheels"]).."</span>" end
			end
		end
		RepairMenu[#RepairMenu+1] =	{ arrow = (isOx() and not headerlock),
			icon = v.icon,
			isMenuHeader = (headerlock or skip),
			header = v.header.." - "..math.floor((damageTable[v.part]+0.5)).."%",
			txt = costTable[v.part],
			onSelect = function() TriggerEvent("jim-mechanic:client:Repair:Sure", { part = v.part, partname = v.header, vehicle = vehicle, cost = v.amount }, crimHub) end,
			progress = damageTable[v.part],
			colorScheme = (damageTable[v.part] and (damageTable[v.part] > 80)) and "green.5" or ((damageTable[v.part] and (damageTable[v.part] < 30)) and "red.8") or "yellow.8"
		}
		--Wait(10)
		if v.part == "wheels" then -- Adjust for weel numbers
			RepairMenu[#RepairMenu].progress = nil
			RepairMenu[#RepairMenu].header = Loc[Config.Lan]["repair"].replacetire
			if not Config.Repairs.FreeRepair then
				RepairMenu[#RepairMenu].text = Loc[Config.Lan]["repair"].cost..damageTable["wheels"].." "..QBCore.Shared.Items["sparetire"].label
			end
			RepairMenu[#RepairMenu].title = Loc[Config.Lan]["repair"].replacetire.." - "..Loc[Config.Lan]["repair"].cost..damageTable["wheels"].." "..QBCore.Shared.Items["sparetire"].label
		else
			--RepairMenu[#RepairMenu].text = nosBar(math.floor((damageTable[v.part]+0.5) or 90)) .." "..math.floor((damageTable[v.part]+0.5) or 90).."%<br>"..(costTable[v.part] or damageTable["wheels"])
		end
	end
	if DoesEntityExist(vehicle) then
		if prevVehicle == vehicle then
			local clipboardProp = makeProp({prop = "p_amb_clipboard_01", coords = vec4(0,0,0,0) }, false, true)
			AttachEntityToEntity(clipboardProp, Ped, GetPedBoneIndex(Ped, 36029), 0.16, 0.08, 0.1, -130.0, -50.0, 0.0, true, true, false, false, 1, true)
			loadAnimDict("missfam4")
			TaskPlayAnim(Ped, "missfam4", "base", 3.0, 3.0, 2000, 1, 1.0, false, false, false)
			CreateThread(function()	Wait(4000) destroyProp(clipboardProp) end)

			openMenu(RepairMenu, { header = searchCar(vehicle), headertxt = headertxt, canClose = true, onExit = function() end, })
		else
			if Config.Overrides.DoorAnimations then for i = 0, 5 do SetVehicleDoorOpen(vehicle, i, false, false) CreateThread(function() Wait(15000) SetVehicleDoorShut(vehicle, i, true) end) end end
			local above = isVehicleLift(vehicle)
			if progressBar({label = Loc[Config.Lan]["repair"].checkeng, time = math.random(3000,5000), anim = above and "idle_b" or "fixing_a_ped", dict = above and "amb@prop_human_movie_bulb@idle_a" or "mini@repair", flag = above and 1 or 16, icon = "mechanic_tools"}) then
				if progressBar({label = Loc[Config.Lan]["repair"].checkbody, time = math.random(3000,5000), anim = above and "idle_b" or "machinic_loop_mechandplayer", dict = above and "amb@prop_human_movie_bulb@idle_a" or "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", icon = "mechanic_tools"}) then
					prevVehicle = vehicle
					local clipboardProp = makeProp({prop = "p_amb_clipboard_01", coords = vec4(0,0,0,0) }, false, true)
					AttachEntityToEntity(clipboardProp, Ped, GetPedBoneIndex(Ped, 36029), 0.16, 0.08, 0.1, -130.0, -50.0, 0.0, true, true, false, false, 1, true)
					loadAnimDict("missfam4")
					TaskPlayAnim(Ped, "missfam4", "base", 3.0, 3.0, 2000, 1, 1.0, false, false, false)
					CreateThread(function()	Wait(4000) destroyProp(clipboardProp) end)
					if Config.Overrides.DoorAnimations then for i = 0, 5 do SetVehicleDoorShut(vehicle, i, true) end end

					openMenu(RepairMenu, { header = searchCar(vehicle), headertxt = headertxt, canClose = true, onExit = function() end, })
				else
					return
				end
			else return end
		end
	end
end)

RegisterNetEvent('jim-mechanic:client:Repair:Sure', function(data, crimHub)
	local Ped = PlayerPedId()
	local coords = GetEntityCoords(Ped)
	local RepairMenu = {}
	if not inCar() then return end
	if not IsPedInAnyVehicle(Ped, false) then vehicle = getClosest(coords) pushVehicle(vehicle) end
	if lockedCar(vehicle) then return end
	if DoesEntityExist(vehicle) then
		local headertxt = Loc[Config.Lan]["check"].plate.." ["..trim(GetVehicleNumberPlateText(vehicle)).."]"..br..(isOx() and br or "")..Loc[Config.Lan]["check"].value..searchPrice(vehicle)..br..(isOx() and br or "")..searchDist(vehicle)
		RepairMenu[#RepairMenu+1] = { header = Loc[Config.Lan]["repair"].doyou..data.partname.."?", isMenuHeader = true, }
		RepairMenu[#RepairMenu+1] = { icon = "fas fa-circle-check", txt = Loc[Config.Lan]["check"].label47,	onSelect = function() TriggerEvent("jim-mechanic:client:Repair:Apply", data, crimHub) end, }
		RepairMenu[#RepairMenu+1] = { icon = "fas fa-circle-xmark", txt = Loc[Config.Lan]["check"].label48, onSelect = function() TriggerEvent("jim-mechanic:client:Repair:Check", data) end, }
		openMenu(RepairMenu, { header = searchCar(vehicle), headertxt = headertxt, })
	end
end)