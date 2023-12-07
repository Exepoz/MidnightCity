local QBCore = exports[Config.Core]:GetCoreObject()

local catseat = 0
local sitting = false
local Chairs = {}

CreateThread(function()
	for k, v in pairs(Config.Chairs) do
		Chairs["CatChair"..k] =
		exports['qb-target']:AddBoxZone("CatChair"..k, vec3(v.coords.x, v.coords.y, v.coords.z-1), 0.6, 0.6, { name="CatChair"..k, heading = v.coords.w, debugPoly=Config.Debug, minZ = v.coords.z-1.2, maxZ = v.coords.z+0.1, },
			{ options = { { event = "jim-catcafe:Chair", icon = "fas fa-chair", label = Loc[Config.Lan].target["sit"], loc = v.coords, stand = v.stand }, },
				distance = 2.2
		})
	end
end)

RegisterNetEvent('jim-catcafe:Chair', function(data)
	local canSit = true
	local sitting = false
	local ped = PlayerPedId()
	for _, v in pairs(QBCore.Functions.GetPlayersFromCoords(data.loc.xyz, 0.6)) do
		local dist = #(GetEntityCoords(GetPlayerPed(v)) - data.loc.xyz)
		if dist <= 0.4 then triggerNotify(nil, Loc[Config.Lan].error["someone_sitting_here"]) canSit = false end
	end
	if canSit then
		if not IsPedHeadingTowardsPosition(ped, data.loc.xyz, 20.0) then TaskTurnPedToFaceCoord(ped, data.loc.xyz, 1500) Wait(1500)	end
		if #(data.loc.xyz - GetEntityCoords(PlayerPedId())) > 1.5 then TaskGoStraightToCoord(ped, data.loc.xyz, 0.5, 1000, 0.0, 0) Wait(1100) end
		TaskStartScenarioAtPosition(PlayerPedId(), "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", data.loc.x, data.loc.y, data.loc.z-0.5, data.loc[4], 0, 1, true)
		catseat = data.stand
		sitting = true
	end
	while sitting do
		if sitting then
			if IsControlJustReleased(0, 202) and IsPedUsingScenario(ped, "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER") then
				sitting = false
				ClearPedTasks(ped)
				if catseat then SetEntityCoords(ped, catseat) end
				catseat = nil
			end
		end
		Wait(5) if not IsPedUsingScenario(ped, "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER") then sitting = false end
	end
end)


Config.Chairs = {
	--Downstairs--
	--Booth1
	{ coords = vec4(-573.04, -1058.81, 22.5, 180.75), stand = vec3(-575.37, -1059.79, 22.34-0.5) },
	{ coords = vec4(-573.92, -1058.82, 22.5, 180.75), stand = vec3(-575.37, -1059.79, 22.34-0.5) },
	{ coords = vec4(-573.06, -1060.7, 22.5, 0.75), stand = vec3(-575.37, -1059.79, 22.34-0.5)},
	{ coords = vec4(-573.91, -1060.72, 22.5, 0.75), stand = vec3(-575.37, -1059.79, 22.34-0.5) },
	--Booth2
	{ coords = vec4(-572.98, -1062.46, 22.5, 180.75), stand = vec3(-575.34, -1063.39, 22.34-0.5) },
	{ coords = vec4(-573.84, -1062.45, 22.5, 180.75), stand = vec3(-575.34, -1063.39, 22.34-0.5) },
	{ coords = vec4(-573.05, -1064.37, 22.5, 0.75), stand = vec3(-575.34, -1063.39, 22.34-0.5) },
	{ coords = vec4(-573.89, -1064.37, 22.5, 0.75), stand = vec3(-575.34, -1063.39, 22.34-0.5) },
	--Booth3
	{ coords = vec4(-573.0, -1066.11, 22.5, 180.75), stand = vec3(-575.49, -1067.04, 22.34-0.5) },
	{ coords = vec4(-573.9, -1066.1, 22.5, 180.75), stand = vec3(-575.49, -1067.04, 22.34-0.5) },
	{ coords = vec4(-573.07, -1068.03, 22.5, 0.75), stand = vec3(-575.49, -1067.04, 22.34-0.5) },
	{ coords = vec4(-573.87, -1068.01, 22.5, 0.75), stand = vec3(-575.49, -1067.04, 22.34-0.5) },
	--Fireside
	{ coords = vec4(-580.84, -1051.22, 22.35, 277.75) },
	{ coords = vec4(-579.78, -1052.51, 22.35, 329.75) },
	{ coords = vec4(-577.61, -1052.6, 22.35, 35.75) },
	{ coords = vec4(-576.86, -1051.03, 22.35, 108.75) },
	--Center
	{ coords = vec4(-579.72, -1062.12, 22.35, 0.75) },
	{ coords = vec4(-580.7, -1062.55, 22.35, 45.75) },
	{ coords = vec4(-581.02, -1063.46, 22.35, 90.75) },
	{ coords = vec4(-580.64, -1064.45, 22.35, 135.75) },
	{ coords = vec4(-579.71, -1064.79, 22.35, 180.75) },
	{ coords = vec4(-578.67, -1064.47, 22.35, 225.75) },
	{ coords = vec4(-578.33, -1063.39, 22.35, 270.75) },
	{ coords = vec4(-578.76, -1062.34, 22.35, 315.75) },
	--Stools
	{ coords = vec4(-586.18, -1064.68, 22.6, 90.75), stand = vec3(-585.72, -1064.75, 22.34) },
	{ coords = vec4(-586.17, -1065.69, 22.6, 90.75), stand = vec3(-585.75, -1065.69, 22.34) },
	{ coords = vec4(-586.15, -1066.68, 22.6, 90.75), stand = vec3(-585.84, -1066.7, 22.34) },
	{ coords = vec4(-586.17, -1067.69, 22.6, 90.75), stand = vec3(-585.79, -1067.64, 22.34) },
	--Boss sofa
	{ coords = vec4(-591.21, -1049.06, 22.35, 180.75) },
	{ coords = vec4(-589.95, -1049.06, 22.35, 180.75) },
	--Boss Room1
	{ coords = vec4(-598.44, -1050.99, 22.35, 270.0) },
	{ coords = vec4(-598.45, -1050.1, 22.35, 270.0) },
	{ coords = vec4(-596.26, -1053.52, 22.35, 0.0) },
	--Upstairs
	--Sofa1
	{ coords = vec4(-573.72, -1052.29, 26.61, 270.0) },
	{ coords = vec4(-573.73, -1053.45, 26.61, 270.0) },
	--Corner Sofa
	{ coords = vec4(-569.68, -1066.56, 26.62, 90.0) },
	{ coords = vec4(-569.7, -1068.13, 26.62, 90.0) },
	{ coords = vec4(-570.97, -1069.42, 26.62, 0) },
	{ coords = vec4(-572.61, -1069.4, 26.62, 0) },
	--Boss Room 2
	{ coords = vec4(-577.09, -1065.14, 26.61, 165.0) },
	{ coords = vec4(-578.82, -1065.24, 26.61, 200.0) },
	{ coords = vec4(-578.24, -1067.83, 26.61, 0) },
	--Boss Room 3
	{ coords = vec4(-577.0, -1062.6, 26.61, 0) },
	{ coords = vec4(-579.1, -1061.28, 26.61, 270.0) },
	{ coords = vec4(-577.39, -1057.87, 26.61, 180.0) },
	{ coords = vec4(-578.59, -1057.9, 26.61, 180.0) },
}
AddEventHandler('onResourceStop', function(r) if r ~= GetCurrentResourceName() then return end
	if GetResourceState("qb-target") == "started" or GetResourceState("ox_target") == "started" then
		for k in pairs(Chairs) do exports['qb-target']:RemoveZone(k) end
	end
end)