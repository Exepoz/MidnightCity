local toolbox = nil

RegisterNetEvent('jim-mechanic:client:Menu', function(editable)
	local ped = PlayerPedId()
	emptyHands(PlayerPedId())
	local coords = GetEntityCoords(ped) local vehicle = nil
	if not nearPoint(coords) then return end
	if not inCar() then return end
	if not IsPedInAnyVehicle(ped, false) then vehicle = getClosest(coords) pushVehicle(vehicle) end
	if lockedCar(vehicle) then return end
	if not DoesEntityExist(vehicle) then return end
	local possMods = checkHSWMods(vehicle)
	if editable then
		if not enforceRestriction("perform") then return end
		if not enforceClassRestriction(getClass(vehicle)) then return end
		if not jobChecks() then return end
		if not locationChecks() then return end
		loadAnimDict("anim@heists@narcotics@trash") playAnim("anim@heists@narcotics@trash", "idle", 6000, 8)
		if not Config.Overrides.disableToolboxProp then
			if not toolbox then toolbox = makeProp({prop = "v_ind_cs_toolbox4", coords = vec4(0,0,0,0)}, 1, 1) else emptyHands(ped) end
			AttachEntityToEntity(toolbox, ped, GetPedBoneIndex(ped, 57005),0.3, -0.04, 0.0, 20.0, 245.0, 95.0, true, true, false, true, 1, true)
			CreateThread(function() Wait(8000)	DeleteEntity(toolbox) toolbox = nil unloadAnimDict("anim@heists@narcotics@trash") end)
		end
	end
	local plate = trim(GetVehicleNumberPlateText(vehicle))
	if not VehicleStatus[plate] then
		if Config.System.Debug then print("^5Debug^7: ^4VehicleStatus^7[^6"..plate.."^7]^2 not found^7,^2 loading^7...") end
		TriggerServerEvent("jim-mechanic:server:setupVehicleStatus", plate, GetVehicleEngineHealth(vehicle), GetVehicleBodyHealth(vehicle))
		while not VehicleStatus[plate] do Wait(10) end
	else TriggerServerEvent("jim-mechanic:server:getStatusList", true, plate) Wait(1000) end
	local CheckMenu = {}
	local headertxt = Loc[Config.Lan]["check"].plate.." ["..trim(GetVehicleNumberPlateText(vehicle)).."]"..br..(isOx() and br or "")..Loc[Config.Lan]["check"].value..searchPrice(vehicle)..br..(isOx() and br or "")..searchDist(vehicle)

	local CheckTable = {
		[1] = { lock = true, part = "nos", head = Loc[Config.Lan]["check"].label58.." "..Loc[Config.Lan]["common"].notinstall, hide = true },
		[2] = { lock = true, part = "engine", desc = Loc[Config.Lan]["common"].stock..": [LVL 0 / "..possMods[11].."]", head = Loc[Config.Lan]["check"].label1 },
		[3] = { lock = true, part = "brakes", desc = Loc[Config.Lan]["common"].stock..": [LVL 0 / "..possMods[12].."]", head = Loc[Config.Lan]["check"].label2 },
		[4] = { lock = true, part = "suspension", desc = Loc[Config.Lan]["common"].stock..": [LVL 0 / "..possMods[15].."]", head = Loc[Config.Lan]["check"].label3 },
		[5] = { lock = true, part = "transmission", desc = Loc[Config.Lan]["common"].stock..": [LVL 0 / "..possMods[13].."]", head = Loc[Config.Lan]["check"].label4 },
		[6] = { lock = true, part = "car_armor", head = Loc[Config.Lan]["check"].label5.." "..Loc[Config.Lan]["common"].stock, },
		[7] = { lock = true, part = "turbo", head = Loc[Config.Lan]["check"].label6.." "..Loc[Config.Lan]["common"].notinstall },
		[8] = { lock = true, part = "headlights", head = Loc[Config.Lan]["check"].label7.." "..Loc[Config.Lan]["common"].notinstall },
		[9] = { lock = true, part = "drifttires", head = Loc[Config.Lan]["check"].label8.." "..Loc[Config.Lan]["common"].notinstall, hide = true  },
		[10] = { lock = true, part = "bprooftires", head = Loc[Config.Lan]["check"].label9.." "..Loc[Config.Lan]["common"].notinstall, hide = true  },
		[11] = { lock = true, part = "antilag", head = Loc[Config.Lan]["check"].label50.." "..Loc[Config.Lan]["common"].notinstall, hide = true  },
		[12] = { lock = true, part = "harness", head = Loc[Config.Lan]["check"].label51.." "..Loc[Config.Lan]["common"].notinstall, hide = true  },
	}

	--NOS--
	if VehicleNitrous[plate] and not Config.Overrides.disableNos then CheckTable[1].lock = false
		CheckTable[1].head = Loc[Config.Lan]["check"].label58.." "..math.floor(VehicleNitrous[plate].level).."%"
		CheckTable[1].icon = "nui://"..Config.System.img..QBCore.Shared.Items[CheckTable[1].part].image
		CheckTable[1].progress = math.floor(VehicleNitrous[plate].level)
	end
	--Engine--
	if possMods[11] == 0 then CheckTable[2].head = Loc[Config.Lan]["check"].label1.." "..Loc[Config.Lan]["check"].unavail CheckTable[2].desc = nil end
	if GetVehicleMod(vehicle, 11) ~= -1 then local lvl = (GetVehicleMod(vehicle, 11)+1) CheckTable[2].lock = false
		CheckTable[2].desc = QBCore.Shared.Items[CheckTable[2].part..lvl].label..": [LVL "..lvl.." / "..possMods[11].."]"
		CheckTable[2].icon = "nui://"..Config.System.img..QBCore.Shared.Items[CheckTable[2].part..lvl].image
	end
	--Brakes--
	if possMods[12] == 0 then CheckTable[3].head = Loc[Config.Lan]["check"].label2.." "..Loc[Config.Lan]["check"].unavail CheckTable[3].desc = nil end
	if GetVehicleMod(vehicle, 12) ~= -1 then local lvl = (GetVehicleMod(vehicle, 12)+1) CheckTable[3].lock = false
		CheckTable[3].desc = QBCore.Shared.Items[CheckTable[3].part..lvl].label..": [LVL "..lvl.." / "..possMods[12].."]"
		CheckTable[3].icon = "nui://"..Config.System.img..QBCore.Shared.Items[CheckTable[3].part..lvl].image
	end
	--Suspension--
	if possMods[15] == 0 then CheckTable[4].head = Loc[Config.Lan]["check"].label3.." "..Loc[Config.Lan]["check"].unavail CheckTable[4].desc = nil end
	if GetVehicleMod(vehicle, 15) ~= -1 then local lvl = (GetVehicleMod(vehicle, 15)+1) CheckTable[4].lock = false
		CheckTable[4].desc = QBCore.Shared.Items[CheckTable[4].part..lvl].label..": [LVL "..lvl.." / "..possMods[15].."]"
		CheckTable[4].icon = "nui://"..Config.System.img..QBCore.Shared.Items[CheckTable[4].part..lvl].image
	end
	--Transmission--
	if possMods[13] == 0 then CheckTable[5].head = Loc[Config.Lan]["check"].label4.." "..Loc[Config.Lan]["check"].unavail CheckTable[5].desc = nil end
	if GetVehicleMod(vehicle, 13) ~= -1 then local lvl = (GetVehicleMod(vehicle, 13)+1) CheckTable[5].lock = false
		CheckTable[5].desc = QBCore.Shared.Items[CheckTable[5].part..lvl].label.." [LVL "..lvl.." / "..possMods[13].."]"
		CheckTable[5].icon = "nui://"..Config.System.img..QBCore.Shared.Items[CheckTable[5].part..lvl].image
	end
	--Armor--
	if GetNumVehicleMods(vehicle, 16) == 0 then CheckTable[6].head = Loc[Config.Lan]["check"].label5.." "..Loc[Config.Lan]["check"].unavail CheckTable[6].desc = nil end
	if (GetVehicleMod(vehicle, 16)+1) == GetNumVehicleMods(vehicle, 16) then CheckTable[6].lock = false
		CheckTable[6].head = Loc[Config.Lan]["check"].label5
		CheckTable[6].desc = Loc[Config.Lan]["common"].installed:gsub("!","")
		CheckTable[6].icon = "nui://"..Config.System.img..QBCore.Shared.Items[CheckTable[6].part].image
	end
	--Turbo--
	if not IsToggleModOn(vehicle, 18) and GetNumVehicleMods(vehicle,11) ~= 0 then
	elseif IsToggleModOn(vehicle, 18) then CheckTable[7].lock = false
		CheckTable[7].head = Loc[Config.Lan]["check"].label6
		CheckTable[7].desc = Loc[Config.Lan]["common"].installed:gsub("!","")
		CheckTable[7].icon = "nui://"..Config.System.img..QBCore.Shared.Items[CheckTable[7].part].image
	elseif GetNumVehicleMods(vehicle,11) == 0 then CheckTable[7].desc = Loc[Config.Lan]["check"].unavail end
	--Xenons--
	local custom, r, g, b = GetVehicleXenonLightsCustomColor(vehicle) local xenonColor = ""
	if not IsToggleModOn(vehicle, 22) and GetNumVehicleMods(vehicle,11) ~= 0 then
	elseif IsToggleModOn(vehicle, 22) then CheckTable[8].lock = false
		CheckTable[8].head = Loc[Config.Lan]["check"].label7
		CheckTable[8].icon = "nui://"..Config.System.img..QBCore.Shared.Items[CheckTable[8].part].image
		if Config.System.Menu == "ox" then	CheckTable[8].desc = "R: "..r.." G: "..g.." B: "..b
		else CheckTable[8].desc = "<span style='color:#"..rgbToHex(r, g, b):upper().."; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black, 0em 0em 0.5em white, 0em 0em 0.5em white'> ⯀ </span> R: "..r.." G: "..g.." B: "..b end
	elseif GetNumVehicleMods(vehicle,11) == 0 then CheckTable[8].desc = Loc[Config.Lan]["check"].unavail  end
	--Drift
	if GetGameBuildNumber() >= 2372 then
		if GetDriftTyresEnabled(vehicle) == 1 then CheckTable[9].head = QBCore.Shared.Items[CheckTable[9].part].label
			CheckTable[9].desc = Loc[Config.Lan]["common"].installed:gsub("!","") CheckTable[9].icon = "nui://"..Config.System.img..QBCore.Shared.Items[CheckTable[9].part].image CheckTable[9].lock = false
		end
	end
	--BulletProof
	if GetVehicleTyresCanBurst(vehicle) == false then CheckTable[10].head = QBCore.Shared.Items[CheckTable[10].part].label
		CheckTable[10].desc = Loc[Config.Lan]["common"].installed:gsub("!","")
		CheckTable[10].icon = "nui://"..Config.System.img..QBCore.Shared.Items[CheckTable[10].part].image
		CheckTable[10].lock = false
	end
	--Anitlag
	if VehicleStatus[plate].antiLag == 1 then CheckTable[11].head = QBCore.Shared.Items[CheckTable[11].part].label
		CheckTable[11].desc = Loc[Config.Lan]["common"].installed:gsub("!","") CheckTable[11].icon = "nui://"..Config.System.img..QBCore.Shared.Items[CheckTable[11].part].image CheckTable[11].lock = false
	end
	--Harness
	if VehicleStatus[plate].harness == 1 then CheckTable[12].head = QBCore.Shared.Items[CheckTable[12].part].label
		CheckTable[12].icon = "nui://"..Config.System.img..QBCore.Shared.Items[CheckTable[12].part].image CheckTable[12].lock = false end
	if Config.Harness.HarnessControl ~= true then
		CheckTable[12] = nil
	end
	if Config.Repairs.ExtraDamages == true then
		CheckTable[#CheckTable+1] = { lock = VehicleStatus[plate].oillevel == 0, part = "oilp", head = "Oil Pump",
			icon = VehicleStatus[plate].oillevel ~= 0 and "nui://"..Config.System.img..QBCore.Shared.Items["oilp"..VehicleStatus[plate].oillevel].image or "",
			desc =  (VehicleStatus[plate].oillevel ~= 0 and QBCore.Shared.Items["oilp"..VehicleStatus[plate].oillevel].label or Loc[Config.Lan]["common"].stock)..": [LVL "..VehicleStatus[plate].oillevel.." / ".."3".."]"
		}
		CheckTable[#CheckTable+1] = { lock = VehicleStatus[plate].shaftlevel == 0, part = "drives", head = "Drive Shaft",
			icon = VehicleStatus[plate].shaftlevel ~= 0 and "nui://"..Config.System.img..QBCore.Shared.Items["drives"..VehicleStatus[plate].shaftlevel].image or "",
			desc =  (VehicleStatus[plate].shaftlevel ~= 0 and QBCore.Shared.Items["drives"..VehicleStatus[plate].shaftlevel].label or Loc[Config.Lan]["common"].stock)..": [LVL "..VehicleStatus[plate].shaftlevel.." / ".."3".."]"
		}
		CheckTable[#CheckTable+1] = { lock = VehicleStatus[plate].cylinderlevel == 0, part = "cylind", head = "Cylinder Head",
			icon = VehicleStatus[plate].cylinderlevel ~= 0 and "nui://"..Config.System.img..QBCore.Shared.Items["cylind"..VehicleStatus[plate].cylinderlevel].image or "",
			desc =  (VehicleStatus[plate].cylinderlevel ~= 0 and QBCore.Shared.Items["cylind"..VehicleStatus[plate].cylinderlevel].label or Loc[Config.Lan]["common"].stock)..": [LVL "..VehicleStatus[plate].cylinderlevel.." / ".."3".."]"
		}
		CheckTable[#CheckTable+1] = { lock = VehicleStatus[plate].cablelevel == 0, part = "cables", head = "Battery Cables",
			icon = VehicleStatus[plate].cablelevel ~= 0 and "nui://"..Config.System.img..QBCore.Shared.Items["cables"..VehicleStatus[plate].cablelevel].image or "",
			desc =  (VehicleStatus[plate].cablelevel ~= 0 and QBCore.Shared.Items["cables"..VehicleStatus[plate].cablelevel].label or Loc[Config.Lan]["common"].stock)..": [LVL "..VehicleStatus[plate].cablelevel.." / ".."3".."]"
		}
		CheckTable[#CheckTable+1] = { lock = VehicleStatus[plate].fuellevel == 0, part = "fueltank", head = "Fuel Tank",
			icon = VehicleStatus[plate].fuellevel ~= 0 and "nui://"..Config.System.img..QBCore.Shared.Items["fueltank"..VehicleStatus[plate].fuellevel].image or "",
			desc =  (VehicleStatus[plate].fuellevel ~= 0 and QBCore.Shared.Items["fueltank"..VehicleStatus[plate].fuellevel].label or Loc[Config.Lan]["common"].stock)..": [LVL "..VehicleStatus[plate].fuellevel.." / ".."3".."]"
		}
	end

	for k, v in ipairs(CheckTable) do
		if v.hide and v.lock then else
			local extra = false
			for l, b in pairs({"oilp", "drives", "cylind", "cables", "fueltank"}) do if v.part == b then extra = true end end
			CheckMenu[#CheckMenu+1] = {
				icon = v.icon,
				isMenuHeader = (not editable) or v.lock,
				header = v.head, txt = v.desc,
				onSelect = not v.lock and (function() TriggerEvent("jim-mechanic:client:Menu:Remove", { vehicle = vehicle, mod = v.part, extra = extra }) end),
				progress = v.progress,
				colorScheme = editable and ((v.progress and (v.progress > 80)) and "green.5" or ((v.progress and (v.progress < 30)) and "red.6") or "yellow.5" ) or "gray.0"
			}
		end
	end
	if editable then
		CheckMenu[#CheckMenu+1] = { arrow = true,
			icon = "fas fa-toolbox",
			txt = Loc[Config.Lan]["check"].label10,
			onSelect = function() TriggerEvent("jim-mechanic:client:Menu:List") end,
		}
	end
	openMenu(CheckMenu, { header = searchCar(vehicle), headertxt = headertxt, canClose = true, onExit = function() end, })
end)

RegisterNetEvent('jim-mechanic:client:Menu:List', function() local Ped = PlayerPedId()
	if not nearPoint(GetEntityCoords(Ped)) then return end
	local vehicle = getClosest(GetEntityCoords(Ped)) pushVehicle(vehicle)
	local CheckMenu = {}
	local exTable = {
		[0] = Loc[Config.Lan]["check"].label15,	[1] = Loc[Config.Lan]["check"].label16,	[2] = Loc[Config.Lan]["check"].label17,	[3] = Loc[Config.Lan]["check"].label18,
		[4] = Loc[Config.Lan]["check"].label19,	[6] = Loc[Config.Lan]["check"].label20,	[7] = Loc[Config.Lan]["check"].label21,	[8] = Loc[Config.Lan]["check"].label22,
		[9] = Loc[Config.Lan]["check"].label23,	[10] = Loc[Config.Lan]["check"].label24, [25] = Loc[Config.Lan]["check"].label25, [26] = Loc[Config.Lan]["check"].label26,
		[27] = Loc[Config.Lan]["check"].label27, [44] = Loc[Config.Lan]["check"].label28, [37] = Loc[Config.Lan]["check"].label29, [39] = Loc[Config.Lan]["check"].label30,
		[40] = Loc[Config.Lan]["check"].label31, [41] = Loc[Config.Lan]["check"].label32, [42] = Loc[Config.Lan]["check"].label33,
	}
	local inTable = {
		[5] = Loc[Config.Lan]["check"].label34,	[25] = Loc[Config.Lan]["check"].label35, [29] = Loc[Config.Lan]["check"].label36, [30] = Loc[Config.Lan]["check"].label37,
		[31] = Loc[Config.Lan]["check"].label38, [32] = Loc[Config.Lan]["check"].label39, [33] = Loc[Config.Lan]["check"].label40, [34] = Loc[Config.Lan]["check"].label41,
		[35] = Loc[Config.Lan]["check"].label42, [36] = Loc[Config.Lan]["check"].label43, [38] = Loc[Config.Lan]["check"].label44, [43] = Loc[Config.Lan]["check"].label45,
		[45] = Loc[Config.Lan]["check"].label46,
	}
	local external, internal = nil
	for k in pairs(exTable) do if GetNumVehicleMods(vehicle, k) ~= 0 then external = true break end end
	for k in pairs(inTable) do if GetNumVehicleMods(vehicle, k) ~= 0 then internal = true break end end

	if external then
		CheckMenu[#CheckMenu+1] = { isMenuHeader = true, disabled = (Config.System.Menu == "ox"), header = Loc[Config.Lan]["check"].label13, title = Loc[Config.Lan]["check"].label13, }
		if GetNumVehicleMods(vehicle, 48) ~= 0 then
			CheckMenu[#CheckMenu+1] = {
				isMenuHeader = true,
				txt = Loc[Config.Lan]["police"].livery.." - [ "..GetNumVehicleMods(vehicle, 48).." "..Loc[Config.Lan]["check"].label12.." ]",
			}
		end
		if GetVehicleLiveryCount(vehicle) ~= -1 then
			CheckMenu[#CheckMenu+1] = {
				isMenuHeader = true,
				txt = Loc[Config.Lan]["police"].livery.." - [ "..GetVehicleLiveryCount(vehicle).." "..Loc[Config.Lan]["check"].label12.." ]",
			}
		end
		for k, v in pairs(exTable) do
			if GetNumVehicleMods(vehicle, k) ~= 0 then
				CheckMenu[#CheckMenu+1] = {
					isMenuHeader = true,
					txt = v..GetNumVehicleMods(vehicle, k).." "..Loc[Config.Lan]["check"].label12.." ]",
				}
			end
		end
	end
	if internal then
		CheckMenu[#CheckMenu+1] = { isMenuHeader = true, header = Loc[Config.Lan]["check"].label14, }
		for k, v in pairs(inTable) do
			if GetNumVehicleMods(vehicle, k) ~= 0 then
				CheckMenu[#CheckMenu+1] = {
					isMenuHeader = true,
					header = "",
					txt = v..GetNumVehicleMods(vehicle, k).." "..Loc[Config.Lan]["check"].label12.." ]",
				}
			end
		end
	end
	local mods = nil
	for k in pairs(exTable) do if GetNumVehicleMods(vehicle, k) ~= 0 then mods = true break end end
	for k in pairs(inTable) do if GetNumVehicleMods(vehicle, k) ~= 0 then mods = true break end end
	if GetVehicleLiveryCount(vehicle) ~= -1 then mods = true end
	if mods then
		openMenu(CheckMenu,{
			header = Loc[Config.Lan]["check"].label11..searchCar(vehicle),
			headertxt = Loc[Config.Lan]["check"].label10, canClose = true,
			onExit = function() end,
		})
	else
		triggerNotify(nil, Loc[Config.Lan]["common"].noOptions, "error") return
	end
end)

RegisterNetEvent('jim-mechanic:client:Menu:Remove', function(data) local plate = trim(GetVehicleNumberPlateText(vehicle))
	local orgTable = {
		["brakes"] = { icon = "nui://"..Config.System.img..((GetVehicleMod(data.vehicle, 12)+1) > 0 and QBCore.Shared.Items["brakes"..(GetVehicleMod(data.vehicle, 12)+1)].image or ""),
			head = ((GetVehicleMod(data.vehicle, 12)+1) > 0 and QBCore.Shared.Items["brakes"..(GetVehicleMod(data.vehicle, 12)+1)].label or ""), event = "applyBrakes", },
		["engine"] = { icon = "nui://"..Config.System.img..((GetVehicleMod(data.vehicle, 11)+1) > 0 and QBCore.Shared.Items["engine"..(GetVehicleMod(data.vehicle, 11)+1)].image or ""),
			head = ((GetVehicleMod(data.vehicle, 11)+1) > 0 and QBCore.Shared.Items["engine"..(GetVehicleMod(data.vehicle, 11)+1)].label or ""), event = "applyEngine" },
		["suspension"] = { icon = "nui://"..Config.System.img..((GetVehicleMod(data.vehicle, 15)+1) > 0 and QBCore.Shared.Items["suspension"..(GetVehicleMod(data.vehicle, 15)+1)].image or ""),
			head = ((GetVehicleMod(data.vehicle, 15)+1) > 0 and QBCore.Shared.Items["suspension"..(GetVehicleMod(data.vehicle, 15)+1)].label or ""), event = "applySuspension" },
		["transmission"] = { icon = "nui://"..Config.System.img..((GetVehicleMod(data.vehicle, 13)+1) > 0 and QBCore.Shared.Items["transmission"..(GetVehicleMod(data.vehicle, 13)+1)].image or ""),
			head = ((GetVehicleMod(data.vehicle, 13)+1) > 0 and QBCore.Shared.Items["transmission"..(GetVehicleMod(data.vehicle, 13)+1)].label or ""), event = "applyTransmission" },
		["car_armor"] = { icon = "nui://"..Config.System.img..QBCore.Shared.Items["car_armor"].image, head = QBCore.Shared.Items["car_armor"].label, event = "applyArmour" },
		["turbo"] = { icon = "nui://"..Config.System.img..QBCore.Shared.Items["turbo"].image, head = QBCore.Shared.Items["turbo"].label, event = "applyTurbo"},
		["headlights"] = {icon = "nui://"..Config.System.img..QBCore.Shared.Items["headlights"].image, head = QBCore.Shared.Items["headlights"].label, event = "giveXenon" },
		["drifttires"] = { icon = "nui://"..Config.System.img..QBCore.Shared.Items["drifttires"].image, head = QBCore.Shared.Items["drifttires"].label, event = "applyDrift" },
		["bprooftires"] = { icon = "nui://"..Config.System.img..QBCore.Shared.Items["bprooftires"].image, head = QBCore.Shared.Items["bprooftires"].label, event = "applyBulletProof" },
		["nos"] = { icon = "nui://"..Config.System.img..QBCore.Shared.Items["noscan"].image, head = QBCore.Shared.Items["noscan"].label, event = "giveNOS" },
		["oilp"] = { icon = "nui://"..Config.System.img..(VehicleStatus[plate].oillevel > 0 and QBCore.Shared.Items["oilp"..VehicleStatus[plate].oillevel].image or ""),
			head = (VehicleStatus[plate].oillevel > 0 and QBCore.Shared.Items["oilp"..VehicleStatus[plate].oillevel].label or ""), event = "applyExtraPart" },
		["drives"] = { icon = "nui://"..Config.System.img..(VehicleStatus[plate].shaftlevel > 0 and QBCore.Shared.Items["drives"..VehicleStatus[plate].shaftlevel].image or ""),
			head = (VehicleStatus[plate].shaftlevel > 0 and QBCore.Shared.Items["drives"..VehicleStatus[plate].shaftlevel].label or ""), event = "applyExtraPart" },
		["cylind"] = { icon = "nui://"..Config.System.img..(VehicleStatus[plate].cylinderlevel > 0 and QBCore.Shared.Items["cylind"..VehicleStatus[plate].cylinderlevel].image or ""),
			head = (VehicleStatus[plate].cylinderlevel > 0 and QBCore.Shared.Items["cylind"..VehicleStatus[plate].cylinderlevel].label or ""), event = "applyExtraPart" },
		["cables"] = { icon = "nui://"..Config.System.img..(VehicleStatus[plate].cablelevel > 0 and QBCore.Shared.Items["cables"..VehicleStatus[plate].cablelevel].image or ""),
			head = (VehicleStatus[plate].cablelevel > 0 and QBCore.Shared.Items["cables"..VehicleStatus[plate].cablelevel].label or ""), event = "applyExtraPart" },
		["fueltank"] = { icon = "nui://"..Config.System.img..(VehicleStatus[plate].fuellevel > 0 and QBCore.Shared.Items["fueltank"..VehicleStatus[plate].fuellevel].image or ""),
			head = (VehicleStatus[plate].fuellevel > 0 and QBCore.Shared.Items["fueltank"..VehicleStatus[plate].fuellevel].label or ""), event = "applyExtraPart" },
		["harness"] = { icon = "nui://"..Config.System.img..QBCore.Shared.Items["harness"].image, head = QBCore.Shared.Items["harness"].label, event = "applyHarness" },
		["antilag"] = { icon = "nui://"..Config.System.img..QBCore.Shared.Items["antilag"].image, head = QBCore.Shared.Items["antilag"].label, event = "applyAntiLag" },
	}
	local CheckMenu = { }
	CheckMenu[#CheckMenu+1] = { icon = orgTable[data.mod].icon,
		isMenuHeader = true,
		header = Loc[Config.Lan]["check"].label49..orgTable[data.mod].head.."?",
	}
	CheckMenu[#CheckMenu+1] = { icon = "fas fa-circle-check",
		txt = Loc[Config.Lan]["check"].label47,
		onSelect = function() TriggerEvent("jim-mechanic:client:"..orgTable[data.mod].event, not data.extra and true or { mod = data.mod, remove = true}) end,
	}
	CheckMenu[#CheckMenu+1] = { icon = "fas fa-circle-xmark",
		txt = Loc[Config.Lan]["check"].label48,
		onSelect = function() TriggerEvent("jim-mechanic:client:Menu", true) end,
	}
	openMenu(CheckMenu, {
		header = searchCar(data.vehicle),
		headertxt = Loc[Config.Lan]["check"].plate.." ["..trim(GetVehicleNumberPlateText(data.vehicle)).."]"..br..(isOx() and br or "")..Loc[Config.Lan]["check"].value..searchPrice(data.vehicle)..br..(isOx() and br or "")..searchDist(data.vehicle),
	})
end)