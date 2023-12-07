local Cats = {}
local Targets = {}

CreateThread(function()
	for k, v in pairs(PedList) do
		Cats[#Cats+1] = makePed("a_c_cat_01", vec4(v.coords.x, v.coords.y, v.coords.z+0.03, v.coords.w), 0, nil, nil, nil)
		Targets["CatPat"..k] =
		exports["qb-target"]:AddTargetEntity(Cats[#Cats],
			{ options = { {	event = "jim-catcafe:CatPat", icon = "fas fa-cat", label = Loc[Config.Lan].target["pet"], cat = Cats[#Cats], coords = v.coords }, },
			distance = 2.5,	})
		SetBlockingOfNonTemporaryEvents(Cats[#Cats], true)
		SetEntityInvincible(Cats[#Cats], true)
		if v.frozen then
			FreezeEntityPosition(Cats[#Cats], true)
		else
			local cat = Cats[#Cats]
			CreateThread(function()
				local cat = cat
				local routeCoords = {
					vec4(-573.59, -1051.73, 22.34, 312.5),
					vec4(-576.5, -1053.52, 22.34, 123.7),
					vec4(-579.85, -1057.09, 22.34, 194.87),
					vec4(-581.38, -1053.72, 22.35, 38.59),
					vec4(-582.61, -1051.24, 22.34, 46.58),
					vec4(-585.93, -1053.67, 22.35, 107.41),
					vec4(-585.93, -1053.67, 22.35, 107.41),
					vec4(-585.93, -1053.67, 22.35, 107.41),
					vec4(-576.48, -1064.01, 22.34, 175.03),
					vec4(-578.47, -1067.17, 22.34, 119.52),
					vec4(-582.69, -1067.03, 22.34, 81.25),
					vec4(-582.69, -1067.03, 22.34, 81.25),
					vec4(-582.4, -1062.29, 22.35, 343.69),
					vec4(-580.1, -1058.88, 22.34, 295.82)
				}
				local route = math.random(1,#routeCoords)
				while true do
					if math.random(1,2) == 1 then route = route + 1	else route = route - 1
					end
					if (route > #routeCoords) or (route <= 0) then route = 1 end
					Wait(math.random(1000,2000))
					TaskGoStraightToCoord(cat, routeCoords[route].xyz, 0.1, math.random(10000,20000), GetEntityHeading(cat), 0)
					if #(GetEntityCoords(cat) - routeCoords[route].xyz) >= 2 then
						TaskGoStraightToCoord(cat, routeCoords[route].xyz, 0.1, math.random(10000,20000), GetEntityHeading(cat), 0)
					end
					Wait(math.random(10000,20000))
				end
			end)
		end
		if v.animDict and v.animName then
			loadAnimDict(v.animDict)
			TaskPlayAnim(Cats[#Cats], v.animDict, v.animName, 8.0, 0, -1, 1, 0, 0, 0)
		end
		SetEntityNoCollisionEntity(Cats[#Cats], PlayerPedId(), false)
	end
end)

local petting = false
RegisterNetEvent('jim-catcafe:CatPat', function(data)
	if not petting then petting = true else return end
	local Cat = data.cat
	local pid = PlayerPedId()
	loadAnimDict("creatures@cat@amb@world_cat_sleeping_ground@exit")
	loadAnimDict("creatures@cat@amb@world_cat_sleeping_ground@enter")
	loadAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
	ppCoords = GetEntityCoords(Cat)
	if IsEntityPlayingAnim(data.cat, "creatures@cat@amb@world_cat_sleeping_ground@base", "base", 3) then
		TaskTurnPedToFaceEntity(pid, Cat, 1200)
		Wait(1300)
		if ppCoords.z < GetEntityCoords(pid).z then TaskStartScenarioInPlace(pid, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
		else
			TaskPlayAnim(pid, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.5, 1.5, 0.3, 16, 0.2, 0, 0, 0)
		end
		FreezeEntityPosition(pid, true)
		Wait(1000)
		TaskPlayAnim(Cat, "creatures@cat@amb@world_cat_sleeping_ground@exit", "exit", 1.0, 200.0, 0.3, 8, 0.2, 0, 0, 0)
		Wait(4000)
		RemoveAnimDict("creatures@cat@amb@world_cat_sleeping_ground@exit")
		FreezeEntityPosition(Cat, false)
		TaskTurnPedToFaceEntity(Cat, pid, 1000)
		Wait(1000)
		FreezeEntityPosition(Cat, true)
		Wait(1500)
		if math.random(1,2) == 2 then
			loadAnimDict("creatures@cat@player_action@")
			TaskPlayAnim(Cat, "creatures@cat@player_action@", "action_a", 2.0, 200.0, 0.3, 8, 0.2, 0, 0, 0)
		end
		Wait(4000)
		FreezeEntityPosition(pid, false)
		TriggerServerEvent('hud:server:RelieveStress', Config.RelieveStress)
		SetEntityHealth(pid, GetEntityHealth(pid) + Config.PatHeal)
		if ppCoords.z < GetEntityCoords(pid).z then
			TaskStartScenarioInPlace(pid, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
			Wait(2800)
			ClearPedTasksImmediately(pid)
		else
			ClearPedTasks(pid)
		end
		Wait(3000)
		TaskPlayAnim(Cat, "creatures@cat@amb@world_cat_sleeping_ground@enter", "enter", 8.0, 0, -1, 1, 0, 0, 0)
		Wait(2500)
		TaskPlayAnim(Cat, "creatures@cat@amb@world_cat_sleeping_ground@base", "base", 8.0, 0, -1, 1, 0, 0, 0)
		SetEntityCoords(Cat, data.coords.x, data.coords.y, data.coords.z - 1.03, 0, 0, 0, true)
	elseif IsEntityPlayingAnim(data.cat, "creatures@cat@amb@world_cat_sleeping_ledge@base", "base", 3) then
		TaskTurnPedToFaceEntity(pid, Cat, 1200)
		Wait(1200)
		TaskPlayAnim(pid, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.5, 1.5, 0.3, 16, 0.2, 0, 0, 0)
		FreezeEntityPosition(pid, true)
		Wait(11500)
		FreezeEntityPosition(pid, false)
		TriggerServerEvent('hud:server:RelieveStress', Config.RelieveStress)
		SetEntityHealth(pid, GetEntityHealth(pid) + Config.PatHeal)
		StopAnimTask(pid, "machinic_loop_mechandplayer", "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", 0)
		ClearPedTasksImmediately(pid)
		Wait(3000)
	elseif IsEntityPlayingAnim(data.cat, "creatures@cat@move", "gallop", 3) then
		TaskTurnPedToFaceEntity(pid, Cat, 1200)
		Wait(1300)
		TaskStartScenarioInPlace(pid, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
		FreezeEntityPosition(pid, true)
		Wait(10000)
		FreezeEntityPosition(pid, false)
		TriggerServerEvent('hud:server:RelieveStress', Config.RelieveStress)
		SetEntityHealth(pid, GetEntityHealth(pid) + Config.PatHeal)
		TaskStartScenarioInPlace(pid, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
		Wait(2800)
		ClearPedTasksImmediately(pid)
	else
		ClearPedTasksImmediately(Cat)
		ClearPedSecondaryTask(Cat)
		TaskTurnPedToFaceEntity(pid, Cat, 1200)
		Wait(1300)
		TaskStartScenarioInPlace(pid, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
		FreezeEntityPosition(pid, true)
		FreezeEntityPosition(Cat, false)
		TaskTurnPedToFaceEntity(Cat, pid, 1000)
		Wait(1000)
		if math.random(1,2) == 2 then
			loadAnimDict("creatures@cat@player_action@")
			TaskPlayAnim(Cat, "creatures@cat@player_action@", "action_a", 2.0, 200.0, 0.3, 8, 0.2, 0, 0, 0)
		end
		Wait(4000)
		FreezeEntityPosition(pid, false)
		TriggerServerEvent('hud:server:RelieveStress', Config.RelieveStress)
		SetEntityHealth(pid, GetEntityHealth(pid) + Config.PatHeal)
		TaskStartScenarioInPlace(pid, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
		Wait(2800)
		ClearPedTasksImmediately(pid)
	end
	petting = false
	unloadAnimDict("creatures@cat@amb@world_cat_sleeping_ground@exit")
	unloadAnimDict("creatures@cat@amb@world_cat_sleeping_ground@enter")
	unloadAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
end)

-----------------------------------------------------------------
PedList = {
	--If Clickable = true this will add a third eye location based on their original coords
	--If frozen = true, the cats will be frozen in place
	--If Wander = true. the cats will wander around the shop.

	{ coords = vec4(-577.14, -1069.22, 22.99, 0), animDict = "creatures@cat@amb@world_cat_sleeping_ground@base", animName = "base", clickable = true, frozen = true },
	{ coords = vec4(-586.85, -1064.68, 23.35, 0), animDict = "creatures@cat@amb@world_cat_sleeping_ground@base", animName = "base", clickable = true, frozen = true },
	{ coords = vec4(-576.49, -1054.94, 22.42, 350.0), animDict = "creatures@cat@amb@world_cat_sleeping_ground@base", animName = "base", clickable = true, frozen = true },
	{ coords = vec4(-582.07, -1055.92, 22.43, 250.0), animDict = "creatures@cat@amb@world_cat_sleeping_ground@base", animName = "base", clickable = true, frozen = true },
	{ coords = vec4(-583.32, -1069.32, 22.99, 90.0), animDict = "creatures@cat@amb@world_cat_sleeping_ground@base", animName = "base", clickable = true, frozen = true },
	{ coords = vec4(-584.33, -1062.76, 23.40, 223.0), animDict = "creatures@cat@amb@world_cat_sleeping_ground@base", animName = "base", clickable = true, frozen = true, },
	{ coords = vec4(-575.53, -1049.41, 23.53, 90.0), animDict = "creatures@cat@amb@world_cat_sleeping_ground@base", animName = "base", clickable = true, frozen = true, },
	{ coords = vec4(-584.71, -1054.55, 23.33, 280.0), animDict = "creatures@cat@amb@world_cat_sleeping_ground@base", animName = "base", clickable = true, frozen = true },

	{ coords = vec4(-576.78, -1057.52, 25.15, 0.0), animDict = "creatures@cat@amb@world_cat_sleeping_ledge@base", animName = "base", clickable = false, frozen = true },
	{ coords = vec4(-583.55, -1048.88, 25.50, 240.0), animDict = "creatures@cat@amb@world_cat_sleeping_ledge@base", animName = "base", clickable = false, frozen = true },
	{ coords = vec4(-595.29, -1055.54, 22.43, 180.0), animDict = "creatures@cat@amb@world_cat_sleeping_ledge@base", animName = "base", clickable = false, frozen = true },
	{ coords = vec4(-587.4, -1059.6, 23.3, 180.0), animDict = "creatures@cat@amb@world_cat_sleeping_ledge@base", animName = "base", clickable = false, frozen = true },
	{ coords = vec4(-571.65, -1057.26, 22.54, 90.0), animDict = "creatures@cat@move", animName = "gallop", clickable = false, frozen = true },

	{ coords = vec4(-573.78, -1052.5, 22.34, 90.0), frozen = false },
	{ coords = vec4(-582.57, -1059.72, 22.34, 180.0), frozen = false },
	{ coords = vec4(-582.35, -1050.91, 22.34, 180.0), frozen = false },
	{ coords = vec4(-585.55, -1067.99, 22.34, 0.0), frozen = false },
	{ coords = vec4(-578.73, -1051.92, 22.35, 180.0), frozen = false },

}

AddEventHandler('onResourceStop', function(r) if r ~= GetCurrentResourceName() then return end
	if GetResourceState("qb-target") == "started" or GetResourceState("ox_target") == "started" then
		for k, v in pairs(PedList) do exports['qb-target']:RemoveZone(k) end
		for k, v in pairs(Cats) do unloadModel(GetEntityModel(v)) DeletePed(v) end
	end
end)