local PlayerJob, Props, Targets, Peds, Blip, Log, PersProp, soundID, CraftLock = {}, {}, {}, {}, {}, {}, {}, false
local soundID = GetSoundId()

CreateThread(function()
	JobLocation = PolyZone:Create({
		vec2(-472.15963745117, 5491.6743164062),
		vec2(-413.28948974609, 5466.4072265625),
		vec2(-409.59701538086, 5433.9560546875),
		vec2(-453.06015014648, 5343.3305664062),
		vec2(-484.22805786133, 5246.4096679688),
		vec2(-527.24548339844, 5138.7109375000),
		vec2(-605.85968017578, 5167.9365234375),
		vec2(-724.03887939453, 5184.3515625000),
		vec2(-767.96917724609, 5286.5795898438),
		vec2(-773.60748291016, 5338.3583984375),
		vec2(-680.50872802734, 5425.5415039062),
		vec2(-611.40000000000, 5531.5300000000),
	}, { name = "lumberyard", debugPoly = Config.Debug })
	JobLocation:onPlayerInOut(function(isPointInside) if isPointInside then makeJob() else stopJob() end end)
	--Spawn LumberYard/Clockin Blip
	local loc = Config.Locations["Lumberyard"][1]

	makeBlip({coords = loc.coords, sprite = loc.sprite, col = loc.col, scale = loc.scale, disp = loc.disp, category = loc.cat, name = loc.name})

	for k, v in pairs(Config.Locations["Seller"]) do
		makePed(v.model, v.coords, 1, 1, v.scenario)
		local tname = "Seller"..k
		Targets[tname] =
			exports['qb-target']:AddCircleZone(tname, v.coords.xyz, 1.0, { name=tname, debugPoly=Config.Debug, useZ=true, },
			{ options = { { event = "jim-lumberjack:openShop", icon = "fas fa-store", label = Loc[Config.Lan].info["browse_store"], job = Config.Job, storeid = tname, ped = Peds[#Peds]}, },
				distance = 2.0 })
	end
	for k, v in pairs(Config.Locations["WoodCut"]) do
		if Config.Blips and v.blipTrue then	makeBlip({coords = v.coords, sprite = v.sprite, col = v.col, scale = v.scale, disp = v.disp, category = v.cat, name = v.name}) end
		loadModel(v.prop)
		PersProp[#PersProp+1] = CreateObject(v.prop, v.coords.x, v.coords.y, v.coords.z-1.03, 0, 0, 0)
		SetEntityHeading(PersProp[#PersProp], v.coords.w-180.0)
		FreezeEntityPosition(PersProp[#PersProp], 1)
		Targets["WoodCut"..k] =
			exports['qb-target']:AddCircleZone("WoodCut"..k, v.coords.xyz, 1.2, {name="WoodCut"..k, debugPoly=Config.Debug, useZ=true, },
			{ options = { { event = "jim-lumberjack:CraftMainMenu", icon = "fas fa-tree", job = Config.Job, label = Loc[Config.Lan].info["woodcut"], menu = "Wood", table = Crafting["Wood Crafting"], saw = PersProp[#PersProp] }, },
				distance = 2.0
			})
	end
	for k, v in pairs(Config.Locations["Illegal"]) do
		if Config.Blips and v.blipTrue then	makeBlip({coords = v.coords, sprite = v.sprite, col = v.col, scale = v.scale, disp = v.disp, category = v.cat, name = v.name}) end
		loadModel(v.prop)
		PersProp[#PersProp+1] = CreateObject(v.prop, v.coords.x, v.coords.y, v.coords.z-1.03, 0, 0, 0)
		SetEntityHeading(PersProp[#PersProp], v.coords.w-180.0)
		FreezeEntityPosition(PersProp[#PersProp], 1)
		Targets["IllegalCut"..k] =
			exports['qb-target']:AddCircleZone("IllegalCut"..k, v.coords.xyz, 1.2, {name="IllegalCut"..k, debugPoly=Config.Debug, useZ=true, },
			{ options = { { event = "jim-lumberjack:CraftMainMenu", icon = "fas fa-star", job = Config.Job, label = Loc[Config.Lan].info["illegalcraft"], menu = "Illegal", table = Crafting["Illegal"], saw = PersProp[#PersProp] }, },
				distance = 2.0
			})
	end
	for k, v in pairs(Config.Locations["Buyer"]) do
		if Config.Blips and v.blipTrue then	makeBlip({coords = v.coords, sprite = v.sprite, col = v.col, scale = v.scale, disp = v.disp, category = v.cat, name = v.name}) end
		local name = "Buyer"..k
		Targets[name] =
			exports['qb-target']:AddCircleZone(name, v.coords.xyz, 0.9, { name=name, debugPoly=Config.Debug, useZ=true, },
			{ options = { { event = "jim-lumberjack:SellStock", icon = "fas fa-sack-dollar", job = Config.Job, label = Loc[Config.Lan].info["sellstock"], job = Config.Job, ped = makePed(v.model, v.coords, 1, 1, v.scenario) }, },
				distance = 2.0
			})
	end
end)

function makeJob()
	for k, v in pairs(Config.TreePositions) do
		for _, tree in pairs(Config.Trees) do CreateModelHide(vec3(v.x, v.y, v.z), 2.0, tree, true) end
		FreezeEntityPosition(Props[#Props], true)
		if not Targets["Tree"..k] then
			Targets["Tree"..k] =
				exports['qb-target']:AddBoxZone("Tree"..k, vec3(v.x, v.y, v.z+2), 1.5, 1.5, { name="Tree"..k, heading = 0.0, debugPoly=Config.Debug, minZ = v.z, maxZ = v.z+25, },
					{ options = { { event = "jim-lumberjack:client:CutTree", icon = "fas fa-tree", job = Config.Job, item = "powersaw", label = Loc[Config.Lan].info["cuttree"], tree = makeProp({prop = "prop_tree_cedar_02", coords = v}, 1, 0), id = k }, },
					distance = 2.0 })
		end
	end
	for k, v in pairs(Config.Locations["Saws"]) do
		if Config.Blips and v.blipTrue then Blip[#Blip+1] = makeBlip({coords = v.coords, sprite = v.sprite, col = v.col, scale = v.scale, disp = v.disp, category = v.cat, name = v.name}) end
		Targets["Saws"..k] =
			exports['qb-target']:AddCircleZone("Saws"..k, v.coords.xyz, 1.2, {name="Saws"..k, debugPoly=Config.Debug, useZ=true, },
				{ options = { { item = "debarkedlog", event = "jim-lumberjack:ProcessLog", icon = "fas fa-compact-disc", job = Config.Job, label = Loc[Config.Lan].info["saw"], coords = v.coords, saw = makeProp(v, 1, 0) }, },
				distance = 2.0 })
		end
		for k, v in pairs(Config.Locations["Debark"]) do
			if Config.Blips and v.blipTrue then Blip[#Blip+1] = makeBlip({coords = v.coords, sprite = v.sprite, col = v.col, scale = v.scale, disp = v.disp, category = v.cat,name = v.name}) end
			Targets["Debark"..k] =
				exports['qb-target']:AddBoxZone("Debark"..k, vec3(v.coords.x, v.coords.y, v.coords.z-1.5), 4.0, 1.5, { name="Debark"..k, heading = v.coords.w, debugPoly=Config.Debug, minZ = v.coords.z-1.06, maxZ = v.coords.z+0.6, },
				{ options = { { item = "log", event = "jim-lumberjack:DebarkLog", icon = "fas fa-bacon", job = Config.Job, label = Loc[Config.Lan].info["debark"], coords = v.coords, id = k }, },
				distance = 2.0 })
	end
	for k, v in pairs(Config.Locations["Pulper"]) do
		if Config.Blips and v.blipTrue then Blip[#Blip+1] = makeBlip({coords = v.coords.xyz, sprite = v.sprite, col = v.col, scale = v.scale, disp = v.disp, category = v.cat, name = v.name}) end
			Targets["Pulp"..k] =
				exports['qb-target']:AddBoxZone("Pulp"..k, vec3(v.coords.x, v.coords.y, v.coords.z-5), 4.8, 3.0, { name="Pulp"..k, heading = 69, debugPoly=Config.Debug, minZ = 70.99, maxZ = 78.79, },
					{ options = { { item = "debarkedlog", event = "jim-lumberjack:PulpLog", job = Config.Job, icon = "fas fa-compact-disc", label = Loc[Config.Lan].info["pulp"], spawncoords = v.coords }, },
					distance = 2.0 })
	end
	loadModel("prop_tool_consaw")
end

function stopJob()
	for _, v in pairs(Config.TreePositions) do
		for _, tree in pairs(Config.Trees) do RemoveModelHide(vec3(v.x, v.y, v.z+2), 0.1, tree, true) end
	end
	for k in pairs(Targets) do
		if string.find(k, "Tree") or string.find(k, "Saws") or string.find(k, "Debark") or string.find(k, "Pulp") then
			exports['qb-target']:RemoveZone(k) Targets[k] = nil
		end
	end
	for i = 1, #Props do unloadModel(GetEntityModel(Props[i])) DeleteObject(Props[i]) end
	for k in pairs(Log) do unloadModel(GetEntityModel(Log[k])) destroyProp(Log[k]) end
	for i = 1, #Blip do RemoveBlip(Blip[i]) end
end

RegisterNetEvent('jim-lumberjack:SellStock', function(data)
	lookEnt(data.ped)
	local list = {"log", "wood", "paper", "debarkedlog", "bark"}
	local sellMenu = {}
	if Config.Menu == "qb" then
		sellMenu[#sellMenu+1] = { header = Loc[Config.Lan].info["headersell"], txt = Loc[Config.Lan].info["sell_txt"], isMenuHeader = true }
		sellMenu[#sellMenu+1] = { icon = "fas fa-circle-xmark", header = "", txt = Loc[Config.Lan].info["close"], params = { event = "jim-mining:CraftMenu:Close" } }
	end
	for _, v in pairs(list) do
		local setheader = QBCore.Shared.Items[v].label
		local disable = true
		if HasItem(v, 1) then setheader = setheader.." 💰" disable = false end
		sellMenu[#sellMenu+1] = {
			icon = "nui://"..Config.img..QBCore.Shared.Items[tostring(v)].image,
			isMenuHeader = disable, disabled = Config.Menu == "ox" and disable,
			header = setheader, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems[v].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-lumberjack:SellAnim", args = { item = v, ped = data.ped } },
			title = setheader, description = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems[v].." "..Loc[Config.Lan].info["sell_each"], event = "jim-lumberjack:SellAnim", args = { item = v, ped = data.ped } }
		Wait(0)
	end
	if Config.Menu == "ox" then exports.ox_lib:registerContext({id = 'MenuSelect', title = data.label, position = 'top-right', options = sellMenu }) exports.ox_lib:showContext("MenuSelect")
	elseif Config.Menu == "qb" then exports['qb-menu']:openMenu(sellMenu) end
end)

RegisterNetEvent('jim-lumberjack:SellAnim', function(data) local Ped = PlayerPedId()
	if HasItem(data.item, 1) then
		loadAnimDict("mp_common")
		TriggerServerEvent('jim-lumberjack:Selling', data) -- Had to slip in the sell command during the animation command
		ppRot = GetEntityRotation(data.ped)
		loadAnimDict("mp_common")
		lookEnt(data.ped)
		TaskPlayAnim(Ped, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)	--Start animations
		TaskPlayAnim(data.ped, "mp_common", "givetake2_b", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
		Wait(2000)
		StopAnimTask(Ped, "mp_common", "givetake2_a", 1.0)
		StopAnimTask(data.ped, "mp_common", "givetake2_b", 1.0)
		SetEntityRotation(data.ped, 0, 0, ppRot.z ,0, 0, false) --Reset ped rotation
		unloadAnimDict("mp_common")
		TriggerEvent('jim-lumberjack:SellStock', data)
	end
end)

function breakSaw()
	if math.random(0, 100) >= 90 and Config.SawBreak then
		toggleItem(false, "powersaw", 1)
		local breakId = GetSoundId()
		PlaySoundFromEntity(breakId, "Drill_Pin_Break", PlayerPedId(), "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
	end
end


---[[ CUT DOWN A TREE ]]---
local Cutting = false
RegisterNetEvent("jim-lumberjack:client:CutTree", function(data) local Ped = PlayerPedId()
	if not Cutting then Cutting = true else return end
	if #(GetEntityCoords(data.tree).xy - GetEntityCoords(Ped).xy) >= 1.2 then
		TaskGoStraightToCoord(Ped, GetEntityCoords(data.tree), 2.0, 1000, GetEntityHeading(Ped), 0)
		Wait(1000)
	end
	local sawProp = makeSaw()
	if Config.SawSound then loadDrillSound() PlaySoundFromEntity(soundID, "Drill", sawProp, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0) end
	local dict, anim = "weapons@heavy@minigun", "fire_high"
	loadAnimDict(tostring(dict))
	lookEnt(data.tree)
	TaskPlayAnim(Ped, tostring(dict), tostring(anim), 3.0, 3.0, -1, 1, 0, false, false, false)
	CreateThread(function() -- Dust/Debris Animation
		Wait(200)
		loadPtfxDict("core")
		while Cutting do
			UseParticleFxAssetNextCall("core")
			local dust = StartNetworkedParticleFxNonLoopedAtCoord("ent_dst_wood_splinter", GetOffsetFromEntityInWorldCoords(Ped, 0.235, 0.45, 0.5), 0.0, 0.0, GetEntityHeading(Ped)-180.0, 0.4, 0.0, 0.0, 0.0)
			UseParticleFxAssetNextCall("core")
			local leaves = StartNetworkedParticleFxNonLoopedAtCoord("ent_amb_falling_leaves_m", GetEntityCoords(Ped).x, GetEntityCoords(Ped).y, GetEntityCoords(Ped).z+2, 0.0, 0.0, GetEntityHeading(Ped)-180.0, 1.0, 0.0, 0.0, 0.0)
			Wait(100)
		end
	end)
	if progressBar({label = Loc[Config.Lan].info["cutdown"], time = Config.Debug and 1000 or Config.Timings["TreeCutting"], cancel = true, icon = "log",}) then
		exports['qb-target']:RemoveZone("Tree"..data.id) Targets["Tree"..data.id] = nil
		destroyProp(sawProp)
		unloadDrillSound()
		StopSound(soundID)
		ClearPedTasks(Ped)
		SetEntityAlpha(data.tree, 0)
		CreateThread(function()
			Cutting = false
			breakSaw()
			Log[data.tree] = makeProp({prop = "prop_log_03", coords = vec3(GetEntityCoords(data.tree).x, GetEntityCoords(data.tree).y, GetEntityCoords(Ped).z+2)}, false, false)
			SetEntityDrawOutline(Log[data.tree], true) SetEntityDrawOutlineShader(1) SetEntityDrawOutlineColor(0,255,0,255)	Wait(100)
			SetEntityRotation(Log[data.tree], 90.0, 90.0, 0.0, 2, 0) Wait(200)
			ApplyForceToEntity(Log[data.tree], 1, 0.5, 0.0, 0, 4.0, 0, 0, 0, 1, 1, 1, 0, 0)
			exports["qb-target"]:AddTargetEntity(Log[data.tree], { options = { { event = "jim-lumberjack:client:LogCut", icon = 'fas fa-hand-scissors', label = Loc[Config.Lan].info["cutlog"], item = "powersaw", tree = data.tree, id = data.id } }, distance = 2.5,	})
			Wait(5000)
			FreezeEntityPosition(Log[data.tree], true)
		end)
	else
		Cutting = false destroyProp(sawProp) unloadDrillSound() StopSound(soundID) ClearPedTasks(Ped)
	end
end)

RegisterNetEvent("jim-lumberjack:client:LogCut", function(data) local Ped = PlayerPedId()
	if not Cutting then Cutting = true else return end
	if #(GetEntityCoords(Log[data.tree]) - GetEntityCoords(Ped)) > 1.2 then
		TaskGoStraightToCoord(Ped, GetEntityCoords(Log[data.tree]), 2.0, 1000, GetEntityHeading(Ped), 0)
		Wait(1000)
	end
	lookEnt(Log[data.tree])
	local sawProp = makeSaw()
	if Config.SawSound then loadDrillSound() PlaySoundFromEntity(soundID, "Drill", sawProp, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0) end
	local dict = "weapons@heavy@minigun"
	local anim = "fire_low"
	loadAnimDict(tostring(dict))
	TaskPlayAnim(Ped, tostring(dict), tostring(anim), 3.0, 3.0, -1, 1, 0, false, false, false)
	CreateThread(function() -- Dust/Debris Animation
		Wait(200)
		loadPtfxDict("core")
		while Cutting do
			UseParticleFxAssetNextCall("core")
			local dust = StartNetworkedParticleFxNonLoopedAtCoord("ent_dst_wood_splinter", GetOffsetFromEntityInWorldCoords(Ped, 0.23, 0.5, -0.5), 0.0, 0.0, GetEntityHeading(Ped)-180.0, 0.4, 0.0, 0.0, 0.0)
			Wait(200)
		end
	end)
	if progressBar({label = Loc[Config.Lan].info["logcutting"], time = Config.Debug and 1000 or Config.Timings["LogCutting"], cancel = true, icon = "log",}) then
		Cutting = false
		breakSaw()
		exports["qb-target"]:RemoveTargetEntity(Log[data.tree])
		destroyProp(sawProp) unloadDrillSound() StopSound(soundID)
		ClearPedTasks(ped)
		destroyProp(Log[data.tree])
		CreateThread(function()
			Wait(Config.Timings["TreeSpawn"])
			SetEntityAlpha(data.tree, 255)
			Targets["Tree"..data.id] =
				exports['qb-target']:AddBoxZone("Tree"..data.id, vec3(GetEntityCoords(data.tree).x, GetEntityCoords(data.tree).y, GetEntityCoords(data.tree).z+2), 1.5, 1.5, { name="Tree"..data.id, heading = 0.0, debugPoly=Config.Debug, minZ = GetEntityCoords(data.tree).z, maxZ = GetEntityCoords(data.tree).z+25, },
				{ options = { { event = "jim-lumberjack:client:CutTree", icon = "fas fa-hand-scissors", job = Config.Job, item = "powersaw", label = "Cut", tree = data.tree, id = data.id }, },
					distance = 2.0 })
		end)
		toggleItem(true, "log", 1)
	else
		Cutting = false destroyProp(sawProp) unloadDrillSound() StopSound(soundID) ClearPedTasks(Ped)
	end
end)

RegisterNetEvent("jim-lumberjack:DebarkLog", function(data) local Ped = PlayerPedId()
	if not Cutting then Cutting = true else return end
	if not HasItem("log", 1) then return end
	TaskStartScenarioInPlace(Ped, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
	Wait(1000)
	local log = makeProp({prop = "prop_log_01", coords = vec3(data.coords.x, data.coords.y, data.coords.z+1) }, 1, 1)
	for _, prop in pairs(Props) do SetEntityNoCollisionEntity(log, prop, 0) end
	CreateThread(function()
		DisableCamCollisionForEntity(log)
		SetEntityNoCollisionEntity(log, Ped, 0)
		SetEntityRotation(log, 15.0, 0.0, 250.0, 2, 0)
		Wait(2000)
		ClearPedTasks(Ped)
		while Cutting do
			local sawoff = GetOffsetFromEntityInWorldCoords(log, 0- tonumber( "0."..(math.random(0,3))), math.random(-1,1) + tonumber( "0."..(math.random(0,9))), 0)
			local yforce = 1.0
			FreezeEntityPosition(log, false)
			if data.id == 1 then yforce = -0.05 end
			ApplyForceToEntity(log, 1, -1.2, yforce, 0.1, 0.0, 0.0, 0.2, 0, 0, 0, 1, 0, 0)
			UseParticleFxAssetNextCall("core")
			StartNetworkedParticleFxNonLoopedAtCoord("ent_dst_wood_splinter", sawoff.x, sawoff.y, sawoff.z, 0.0, 0.0, math.random(0, 359)+.0, 0.4, 0.0, 0.0, 0.0)
			local sawoff = GetOffsetFromEntityInWorldCoords(log, 0- tonumber( "0."..(math.random(0,3))), math.random(-1,1) + tonumber( "0."..(math.random(0,9))), 0)
			UseParticleFxAssetNextCall("core")
			StartNetworkedParticleFxNonLoopedAtCoord("ent_dst_wood_splinter", sawoff.x, sawoff.y, sawoff.z, 0.0, 0.0, math.random(0, 359)+.0, 0.4, 0.0, 0.0, 0.0)
			Wait(100)
		end
	end)
	if progressBar({label = Loc[Config.Lan].info["debarking"], time = Config.Debug and 1000 or Config.Timings["Debark"], cancel = true, icon = "log",}) then
		Cutting = false
		destroyProp(log)
		toggleItem(false, "log", 1) toggleItem(true, "debarkedlog", 1) toggleItem(true, "bark", 1)
		unloadDrillSound() StopSound(soundID) ClearPedTasks(Ped)
	else
		Cutting = false
		destroyProp(log)
		unloadDrillSound() StopSound(soundID)
		ClearPedTasks(Ped)
	end
end)

RegisterNetEvent("jim-lumberjack:ProcessLog", function(data) local Ped = PlayerPedId()
	if not Cutting then Cutting = true else return end
	if not HasItem("debarkedlog", 1) then return end
	lookEnt(data.saw)
	local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(data.saw, 0.1, -0.1, 1.445))
	local log = makeProp({prop = "prop_snow_fncwood_14a", coords = vec4(x, y, z, GetEntityHeading(data.saw))}, 1, 1)
	local xRot, yRot, _ = table.unpack(GetEntityRotation(data.saw))
	SetEntityRotation(log, xRot + 270.0, yRot, GetEntityHeading(data.saw)+90, 2, 0)
	loadAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
	TaskPlayAnim(Ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.5, 1.5, 0.3, 16, 0.2, 0, 0, 0)
	if Config.SawSound then loadDrillSound() PlaySoundFromEntity(soundID, "Drill", log, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0) end
	CreateThread(function()
		local sawoff = GetOffsetFromEntityInWorldCoords(log, 0.0, 0.0, 0.1)
		while Cutting do
			loadPtfxDict("core")
			while Cutting do
				UseParticleFxAssetNextCall("core")
				local dust = StartNetworkedParticleFxNonLoopedAtCoord("ent_dst_wood_splinter", sawoff.x, sawoff.y, sawoff.z, 90.0, 0.0, GetEntityHeading(data.saw)+180, 0.4, 0.0, 0.0, 0.0)
				Wait(100)
			end
		end
	end)
	if progressBar({label = Loc[Config.Lan].info["processing"], time = Config.Debug and 1000 or Config.Timings["Processing"], cancel = true, icon = "debarkedlog",}) then
		Cutting = false
		destroyProp(log)
		toggleItem(false, "debarkedlog", 1) toggleItem(true, "wood", 2)
		unloadDrillSound() StopSound(soundID) ClearPedTasks(Ped)
	else
		Cutting = false
		destroyProp(log)
		unloadDrillSound() StopSound(soundID) ClearPedTasks(Ped)
	end
end)

RegisterNetEvent("jim-lumberjack:PulpLog", function(data) local Ped = PlayerPedId()
	if not Cutting then Cutting = true else return end
	TaskStartScenarioInPlace(Ped, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
	Wait(1000)
	local log = makeProp({ prop = "prop_snow_fncwood_14a", coords = vec3(data.spawncoords.x, data.spawncoords.y, data.spawncoords.z+5) }, 0, 0)
	CreateThread(function()
		local zcoord = data.spawncoords.z - 0.5
		while Cutting do
			zcoord = zcoord - 0.003
			SetEntityCoords(log, vec3(data.spawncoords.x, data.spawncoords.y, zcoord))
			local xRot, yRot, zRot = table.unpack({ math.random(-6,6)+.0, math.random(-6,6)+.0, math.random(-6,6)+.0,})
			SetEntityRotation(log, yRot, rot2, zRot, 2, 0)
			Wait(10)
		end
	end)
	CreateThread(function()
		loadPtfxDict("core")
		while Cutting do
			UseParticleFxAssetNextCall("core")
			local dust = StartNetworkedParticleFxNonLoopedAtCoord("ent_dst_wood_splinter", data.spawncoords.x, data.spawncoords.y, data.spawncoords.z-1.5, 0.0, 0.0, math.random(0,359)+.0, 0.7, 0.0, 0.0, 0.0)
			Wait(20)
		end
	end)
	if progressBar({label = Loc[Config.Lan].info["pulping"], time = Config.Debug and 1000 or Config.Timings["PulpLog"], cancel = true, icon = "debarkedlog",}) then
		Cutting = false
		destroyProp(log)
		toggleItem(false, "debarkedlog", 1)	toggleItem(true, "paper", 5)
		unloadDrillSound() StopSound(soundID)
		ClearPedTasks(Ped)
	else
		Cutting = false
		destroyProp(log)
		unloadDrillSound() StopSound(soundID)
		ClearPedTasks(Ped)
	end
end)

RegisterNetEvent("jim-lumberjack:CraftMainMenu", function(data)
	if CraftLock then return end
	local MenuSelect = {}
	if Config.Menu == "qb" then
		MenuSelect[#MenuSelect+1] = { isMenuHeader = true, icon = data.icon, header = data.label, txt = "" }
		MenuSelect[#MenuSelect+1] = { icon = "fas fa-xmark", header = "", txt = Loc[Config.Lan].info["close"], params = { event = "" } }
	end
	if data.menu == "Wood" then
		for k, v in pairsByKeys(data.table) do
			MenuSelect[#MenuSelect+1] = {
				header = k, txt = Loc[Config.Lan].info["section"]..countTable(v),
				params = { event = "jim-lumberjack:SubMenu", args = { icon = data.icon, menu = data.menu, table = data.table, label = data.label, label2 = k, subtable = v, saw = data.saw } },
				title = k, description = Loc[Config.Lan].info["section"]..countTable(v), event = "jim-lumberjack:SubMenu",
				args = { icon = data.icon, menu = data.menu, table = data.table, label = data.label, label2 = k, subtable = v, saw = data.saw },
			}
		end
	end
	if data.menu == "Illegal" then
		for k, v in pairsByKeys(data.table) do
			MenuSelect[#MenuSelect+1] = {
				header = k, txt = Loc[Config.Lan].info["section"]..countTable(v),
				params = { event = "jim-lumberjack:SubMenu", args = { icon = data.icon, menu = data.menu, table = data.table, label = data.label, label2 = k, subtable = v, saw = data.saw } },
				title = k, description = Loc[Config.Lan].info["section"]..countTable(v), event = "jim-lumberjack:SubMenu",
				args = { icon = data.icon, menu = data.menu, table = data.table, label = data.label, label2 = k, subtable = v, saw = data.saw },
			}
		end
	end
	if Config.Menu == "ox" then exports.ox_lib:registerContext({id = 'MenuSelect', title = data.label, position = 'top-right', options = MenuSelect }) exports.ox_lib:showContext("MenuSelect")
	elseif Config.Menu == "qb" then exports['qb-menu']:openMenu(MenuSelect) end
end)

RegisterNetEvent('jim-lumberjack:openShop', function(data)
	local event = "inventory:server:OpenInventory"
	if Config.JimShop then event = "jim-shops:ShopOpen"
	elseif Config.Inv == "ox" then exports.ox_inventory:openInventory('shop', { type = "lumberjack" }) end
	TriggerServerEvent(event, "shop", "lumberjack", Config.Items)
	lookEnt(data.coords)
end)

RegisterNetEvent("jim-lumberjack:SubMenu", function(data)
	local MenuSelect = {}
	if Config.Menu == "qb" then
		MenuSelect[#MenuSelect+1] = { isMenuHeader = true, icon = data.icon, header = data.label, txt = data.label2 }
	end
	MenuSelect[#MenuSelect + 1] = {
		icon = "fas fa-arrow-left",
		header = "", txt = Loc[Config.Lan].info["return"], params = { event = "jim-lumberjack:CraftMainMenu", args = data },
		title = Loc[Config.Lan].info["return"], event = "jim-lumberjack:CraftMainMenu", args = data,
	}
	for k, v in pairsByKeys(data.subtable) do
		MenuSelect[#MenuSelect+1] = {
			header = k, txt = "Recipes: "..countTable(v),
			params = { event = "jim-lumberjack:CraftMenu", args = { icon = data.icon, menu = data.menu, table = data.table, label = data.label, label2 = data.label2, label3 = k, subtable = data.subtable, craftable = v } },
			title = k, description = "Recipes: "..countTable(v), event = "jim-lumberjack:CraftMenu", -- ox_lib
			args = { icon = data.icon, menu = data.menu, table = data.table, label = data.label, label2 = data.label2, label3 = k, subtable = data.subtable, craftable = v }, -- ox_lib
		}
	end
	if Config.Menu == "ox" then exports.ox_lib:registerContext({id = 'MenuSelect', title = data.label, position = 'top-right', options = MenuSelect }) exports.ox_lib:showContext("MenuSelect")
	elseif Config.Menu == "qb" then exports['qb-menu']:openMenu(MenuSelect) end
end)

RegisterNetEvent('jim-lumberjack:CraftMenu', function(data)
	local CraftMenu = {}
	if Config.Menu == "qb" then
		CraftMenu[#CraftMenu + 1] = { icon = data.icon, header = data.label3, txt = data.label.." - "..data.label2, isMenuHeader = true }
	end
	CraftMenu[#CraftMenu + 1] = {
		icon = "fas fa-arrow-left",
		header = "", txt = Loc[Config.Lan].info["return"],
		title = Loc[Config.Lan].info["return"],
		event = "jim-lumberjack:SubMenu", args = data, -- ox_lib
		params = { event = "jim-lumberjack:SubMenu", args = data },
	}
	for i = 1, #data.craftable do
		for k in pairsByKeys(data.craftable[i]) do
			if k ~= "amount" and QBCore.Shared.Items[k] then
				local amount, text, setheader, settext, disabled = table.unpack({ "", "", "", "", false })
				if QBCore.Shared.Items[k] then setheader = QBCore.Shared.Items[k].label else setheader = k.."(?)" end
				if data.craftable[i].amount and data.craftable[i].amount > 1 then setheader = setheader.." x"..data.craftable[i].amount end
				local disable = false
				local checktable = {}
				for l, b in pairs(data.craftable[i][tostring(k)]) do
					if b == 1 then number = "" else number = " x"..b end
					if not QBCore.Shared.Items[l] then print("^3Error^7: ^2Script can't find ingredient item in QB-Core items.lua - ^1"..l.."^7") return end
					if Config.Menu == "ox" then text = text..QBCore.Shared.Items[l].label..number.."\n" end
					if Config.Menu == "qb" then text = text.."- "..QBCore.Shared.Items[l].label..number.."<br>" end
					settext = text
					checktable[l] = HasItem(l, b)
				end
				for _, v in pairs(checktable) do if v == false then disable = true break end end
				if not disable then setheader = setheader.." ✅" end
				CraftMenu[#CraftMenu + 1] = {
					icon = "nui://"..Config.img..QBCore.Shared.Items[tostring(k)].image,
					disabled = disable,
					header = setheader,	txt = settext, -- qb_menu
					params = { event = "jim-lumberjack:MakeItem", -- qb-menu
						args = { item = k, tablenumber = i, craftable = data.craftable, menu = data.menu, table = data.table, subtable = data.subtable, saw = data.saw, label = data.label, label2 = data.label2, } },
					title = "**"..setheader.."**", description = settext, event = "jim-lumberjack:MakeItem", -- ox_lib
					args = { item = k, tablenumber = i, craftable = data.craftable, menu = data.menu, table = data.table, subtable = data.subtable, saw = data.saw, label = data.label, label2 = data.label2, }, -- ox_lib
				}
			end
		end
	end
	if Config.Menu == "ox" then exports.ox_lib:registerContext({id = 'Crafting', title = data.label, position = 'top-right', options = CraftMenu }) exports.ox_lib:showContext("Crafting")
	elseif Config.Menu == "qb" then exports['qb-menu']:openMenu(CraftMenu) end
end)

RegisterNetEvent('jim-lumberjack:MakeItem', function(data)
	if not CraftLock then CraftLock = true else return end
	for k in pairs(data.craftable[data.tablenumber]) do
		if data.item == k then
			lookEnt(data.saw)
			animDictNow = "amb@prop_human_parking_meter@male@idle_a"
			animNow = "idle_a"
			if progressBar({label = Loc[Config.Lan].info["craft"]..QBCore.Shared.Items[data.item].label, time = Config.Debug and 1000 or Config.Timings["Crafting"], cancel = true, icon = data.item, anim = animNow, dict = animDictNow, flag = 8}) then
				CraftLock = false
				TriggerServerEvent('jim-lumberjack:GetItem', data)
				StopAnimTask(PlayerPedId(), animDictNow, animNow, 1.0)
			else
				CraftLock = false
				tiggerNotigy(nil, Loc[Config.Lan].error["cancelled"], 'error')
				StopAnimTask(PlayerPedId(), animDictNow, animNow, 1.0)
			end
		end
	end
end)

-- PROP FUN
local cardHat = nil
RegisterNetEvent("jim-mechanic:carboardHat", function() local Ped = PlayerPedId()
	if DoesEntityExist(cardHat) then
		loadAnimDict("missheist_agency2ahelmet")
		TaskPlayAnim(Ped, "missheist_agency2ahelmet", "take_off_helmet_stand", 3.0, 3.0, 1200, 51, 0, 0, 0, 0)
		CreateThread(function()
			Wait(600)
			AttachEntityToEntity(cardHat, Ped, GetPedBoneIndex(Ped, 18905), 0.08, 0.0, 0.13, 100.0, 18.0, -144.0, true, true, false, false, 1, true)
		end)
		Wait(1200)
		StopAnimTask(Ped, "take_off_helmet_stand", "missheist_agency2ahelmet", 0)
		SetEntityAsMissionEntity(cardHat, true, true)
		Wait(10)
		destroyProp(cardHat)
		cardHat = nil
		unloadModel("v_ind_cfbox2")
		return
	end
	if not DoesEntityExist(cardHat) then
		loadModel("v_ind_cfbox2")
		cardHat = CreateObject("v_ind_cfbox2", GetEntityCoords(Ped), true, true, true)
		AttachEntityToEntity(cardHat, Ped, GetPedBoneIndex(Ped, 18905), 0.03, -0.03, 0.0, 100.0, 10.0, -92.0, true, true, false, false, 1, true)
		loadAnimDict("mp_masks@standard_car@ds@")
		TaskPlayAnim(Ped, "mp_masks@standard_car@ds@", "put_on_mask", 3.0, 3.0, 600, 51, 0, 0, 0, 0)
		Wait(600)
		StopAnimTask(Ped, "put_on_mask", "mp_masks@standard_car@ds@", 0)
		AttachEntityToEntity(cardHat, Ped, GetPedBoneIndex(Ped, 12844), 0.03, -0.03, 0.0, 100.0, 10.0, -92.0, true, true, false, false, 1, true)
	end
end)

local walkingStick = nil
RegisterNetEvent('jim-lumberjack:walkstick', function() local Ped = PlayerPedId()
	if not DoesEntityExist(walkingStick) then
		walkingStick = makeProp({ prop = "prop_cs_walking_stick", coords = vec4(0, 0, 0, 0)}, 0, 1)
		AttachEntityToEntity(walkingStick, Ped, GetPedBoneIndex(Ped, 57005), 0.16, 0.06, 0.0, 335.0, 300.0, 120.0, true, true, false, true, 5, true)
		RequestAnimSet('move_heist_lester')	while not HasAnimSetLoaded('move_heist_lester') do Wait(1) end
		SetPedMovementClipset(Ped, 'move_heist_lester', 1.0)
	else
		ResetPedMovementClipset(Ped, 1.0)
		destroyProp(walkingStick)
	end
end)

local origami = nil
RegisterNetEvent('jim-lumberjack:origamiani', function() local Ped = PlayerPedID()
	if not origami then origami = true else return end
	loadModel("prop_paper_ball")
	loadAnimDict("missheistfbisetup1")
	loadAnimDict("impexp_int-0")
	TaskPlayAnim(Ped, "missheistfbisetup1", "hassle_intro_loop_f", 3.0, 1.0, -1, 1, 0, false, false, false)
	Wait(3000)
	StopAnimTask(Ped, "hassle_intro_loop_f", "missheistfbisetup1")
	TaskPlayAnim(Ped, "impexp_int-0", "mp_m_waremech_01_dual-0", 3.0, 1.0, -1, 16, 0, false, false, false)
	local prop = CreateObject("prop_paper_ball", GetEntityCoords(Ped), true, true, true)
	AttachEntityToEntity(prop, Ped, GetPedBoneIndex(Ped, 18905), 0.16, 0.06, 0.07, 0.0, 0.0, 0.0, true, true, false, false, 1, true)
	Wait(8000)
	StopAnimTask(Ped, "mp_m_waremech_01_dual-0", "impexp_int-0")
	destroyProp(prop)
	origami = nil
end)

AddEventHandler('onResourceStop', function(r) if r ~= GetCurrentResourceName() then return end
	if GetResourceState("qb-target") == "started" or GetResourceState("ox_target") == "started" then
		for _, v in pairs(Config.TreePositions) do
			for _, tree in pairs(Config.Trees) do RemoveModelHide(vec3(v.x, v.y, v.z+2), 0.1, tree, true) end
		end
		for k in pairs(Targets) do exports['qb-target']:RemoveZone(k) end
		for _, v in pairs(Peds) do unloadModel(GetEntityModel(v)) DeletePed(v) end
		for i = 1, #Props do unloadModel(GetEntityModel(Props[i])) DeleteObject(Props[i]) end
		for i = 1, #PersProp do unloadModel(GetEntityModel(PersProp[i])) DeleteObject(PersProp[i]) end
		for k in pairs(Log) do unloadModel(GetEntityModel(Log[k])) DeleteObject(Log[k]) end
		for i = 1, #Blip do RemoveBlip(Blip[i]) end
		DeleteEntity(cardHat)
		StopSound(soundID)
	end
end)