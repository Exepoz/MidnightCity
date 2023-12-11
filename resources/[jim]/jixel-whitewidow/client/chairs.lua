local QBCore = exports[Config.Core]:GetCoreObject()

local wwseat = nil
local sitting = false
local Chairs = {}

CreateThread(function()
	for _, v in pairs(Config.Locations) do
		local chairlist = {}
		local i = 0
		if v.zoneEnable then
		if v.MLO == 'mosbaek' then chairlist = Config.WWChairs elseif v.MLO == "bestbuds" then chairlist = Config.BBChairs elseif v.MLO == "jenww" then chairlist = Config.JCChairs elseif v.MLO == "supreme" then chairlist = Config.WCChairs end
		for _, v in pairs(chairlist) do i += 1
			Chairs["WhiteWidowChair"..i] =
			exports['qb-target']:AddBoxZone("WhiteWidowChair"..i, vec3(v.coords.x, v.coords.y , v.coords.z-1.03), 0.7, 0.7, { name= "WhiteWidowChair"..i, heading = v.coords[4], debugPoly=Config.Debug, minZ = v.coords.z-1.2, maxZ = v.coords.z+0.2, },
				{ options = { { event = "jixel-whitewidow:Chair", icon = "fas fa-chair", label = Loc[Config.Lan].target["sit"], loc = v.coords, stand = v.stand }, },
					distance = 2.2 })
			end
		end
	end
end)

RegisterNetEvent('jixel-whitewidow:Chair', function(data)
	local canSit = true
	local sitting = false
	local ped = PlayerPedId()
	for _, v in pairs(QBCore.Functions.GetPlayersFromCoords(data.loc.xyz, 0.6)) do
		local dist = #(GetEntityCoords(GetPlayerPed(v)) - data.loc.xyz)
		if dist <= 0.4 then TriggerEvent("QBCore:Notify", Loc[Config.Lan].error["seat_taken"]) canSit = false end
	end
	if canSit then
		if not IsPedHeadingTowardsPosition(ped, data.loc.xyz, 20.0) then TaskTurnPedToFaceCoord(ped, data.loc.xyz, 1500) Wait(1500)	end
		if #(data.loc.xyz - GetEntityCoords(PlayerPedId())) > 1.5 then TaskGoStraightToCoord(ped, data.loc.xyz, 0.5, 1000, 0.0, 0) Wait(1100) end
		TaskStartScenarioAtPosition(PlayerPedId(), "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", data.loc.x, data.loc.y, data.loc.z, data.loc.w, 0, 1, true)
		wwseat = data.stand
		sitting = true
	end
	while sitting do
		if sitting then
			if IsControlJustReleased(0, 202) and IsPedUsingScenario(ped, "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER") then
				sitting = false
				ClearPedTasks(ped)
				if wwseat then SetEntityCoords(ped, wwseat) end
				wwseat = nil
			end
		end
		Wait(5) if not IsPedUsingScenario(ped, "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER") then sitting = false end
	end
end)

Config.WWChairs = {
	--CENTER
	--Table 1
	{ coords = vec4(201.5, -247.13, 53.57, 74.77), stand = vec3(200.86, -246.94, 54.07) },
	{ coords = vec4(201.07, -248.46, 53.57, 78.59), stand = vec3(200.42, -248.31, 54.07) },
	{ coords = vec4(199.49, -249.03, 53.57, 343.25), stand = vec3(199.49, -249.03, 53.57) },
	{ coords = vec4(198.04, -248.53, 53.57, 340.98), stand = vec3(198.04, -248.53, 53.57) },
	--Ottomans--
	{ coords = vec4(200.48, -245.14, 53.57, 164.34), stand = vec3(200.08, -245.58, 54.07) },
	{ coords = vec4(198.86, -245.22, 53.57, 215.03), stand = vec3(198.96, -245.75, 54.07) },
	{ coords = vec4(197.86, -246.33, 53.57, 248.45), stand = vec3(197.8, -246.43, 53.57) },
	--Table 2
	{ coords = vec4(197.37, -250.74, 53.57, 159.62), stand = vec3(197.12, -251.36, 54.07) },
	{ coords = vec4(199.03, -251.4, 53.57, 162.49), stand = vec3(198.81, -252.03, 54.07) },
	{ coords = vec4(199.5, -252.64, 53.57, 69.33), stand = vec3(199.09, -252.42, 54.07) },
	{ coords = vec4(198.86, -254.27, 53.57, 77.35), stand = vec3(198.22, -254.11, 54.07) },
	--Ottomans--
	{ coords = vec4(196.81, -254.81, 53.57, 347.73), stand = vec3(196.97, -254.17, 54.08) },
	{ coords = vec4(195.55, -253.75, 53.57, 298.89), stand = vec3(196.14, -253.45, 54.08) },
	{ coords = vec4(195.73, -252.11, 53.57, 263.58), stand = vec3(196.39, -252.2, 54.07) },
	--Table 3
	{ coords = vec4(197.83, -257.35, 53.57, 67.2), stand = vec3(197.22, -257.07, 54.07) },
	{ coords = vec4(197.26, -258.92, 53.57, 66.85), stand = vec3(196.66, -258.64, 54.07) },
	{ coords = vec4(196.0, -259.39, 53.57, 339.41), stand = vec3(196.25, -258.77, 54.07) },
	{ coords = vec4(194.21, -258.75, 53.57, 342.17), stand = vec3(194.43, -258.13, 54.08) },
	--Table 4
	{ coords = vec4(193.7, -260.85, 53.57, 172.6), stand = vec3(193.61, -261.4, 54.07) },
	{ coords = vec4(195.21, -261.42, 53.57, 171.48), stand = vec3(195.11, -261.97, 54.07) },
	{ coords = vec4(195.93, -262.56, 53.57, 72.64), stand = vec3(195.4, -262.37, 54.08) },
	{ coords = vec4(195.2, -264.45, 53.57, 70.55), stand = vec3(194.68, -264.24, 54.08) },
	--Table 5
	{ coords = vec4(194.13, -267.34, 53.57, 73.91), stand = vec3(193.6, -267.16, 54.07) },
	{ coords = vec4(193.51, -269.07, 53.57, 67.08), stand = vec3(193.0, -268.83, 54.08) },
	{ coords = vec4(192.48, -269.64, 53.57, 351.85), stand = vec3(192.58, -269.09, 54.08) },
	{ coords = vec4(190.5, -268.98, 53.57, 342.9), stand = vec3(190.69, -268.45, 54.07) },
	--Table 6
	{ coords = vec4(183.89, -266.46, 53.57, 340.3), stand = vec3(184.1, -265.93, 54.08) },
	{ coords = vec4(182.24, -265.93, 53.57, 339.99), stand = vec3(182.45, -265.41, 54.08) },
	{ coords = vec4(182.0, -264.49, 53.57, 259.0), stand = vec3(182.55, -264.62, 54.07) },
	{ coords = vec4(182.5, -263.07, 53.57, 251.85), stand = vec3(183.03, -263.26, 54.07) },
	--Ottomans--
	{ coords = vec4(185.52, -265.07, 53.57, 117.71), stand = vec3(185.02, -265.32, 54.08) },
	{ coords = vec4(184.3, -262.76, 53.57, 175.17), stand = vec3(184.23, -263.32, 54.07) },
	--Table 7
	{ coords = vec4(184.19, -258.52, 53.57, 255.72), stand = vec3(184.73, -258.68, 54.07) },
	{ coords = vec4(184.68, -256.99, 53.57, 257.15), stand = vec3(185.22, -257.14, 54.07) },
	{ coords = vec4(185.99, -256.32, 53.57, 166.02), stand = vec3(185.84, -256.86, 54.07) },
	{ coords = vec4(187.55, -256.92, 53.57, 165.47), stand = vec3(187.38, -257.45, 54.07) },
	--Ottomans--
	{ coords = vec4(187.72, -258.98, 53.57, 84.66), stand = vec3(187.17, -258.91, 54.08) },
	{ coords = vec4(186.84, -260.12, 53.57, 27.75), stand = vec3(186.41, -259.78, 54.07) },
	{ coords = vec4(185.31, -260.1, 53.57, 352.44), stand = vec3(185.55, -259.54, 54.07) },
	--Table 8
	{ coords = vec4(188.34, -254.99, 53.57, 345.64), stand = vec3(188.51, -254.46, 54.07) },
	{ coords = vec4(186.6, -254.37, 53.57, 347.38), stand = vec3(186.75, -253.83, 54.07) },
	{ coords = vec4(186.15, -253.03, 53.57, 259.37), stand = vec3(186.7, -253.16, 54.07) },
	{ coords = vec4(186.68, -251.44, 53.57, 254.0), stand = vec3(187.21, -251.62, 54.07) },
	--Ottomans--
	{ coords = vec4(188.73, -250.55, 53.57, 160.0), stand = vec3(188.59, -251.5, 54.07) },
	{ coords = vec4(189.87, -251.72, 53.57, 121.07), stand = vec3(189.34, -252.19, 54.08) },
	{ coords = vec4(189.88, -253.19, 53.57, 87.17), stand = vec3(189.32, -253.14, 54.07) },
	--Boss Office
	{ coords = vec4(179.61, -249.63, 53.61, 344.44), stand = vec3(179.78, -249.1, 54.12) },
	{ coords = vec4(178.68, -247.94, 53.61, 251.97), stand = vec3(179.04, -248.11, 54.15) },
	{ coords = vec4(179.09, -246.61, 53.61, 247.96), stand = vec3(179.6, -246.84, 54.11) },
	{ coords = vec4(180.41, -245.58, 53.61, 196.65), stand = vec3(180.55, -246.12, 54.11) },
	{ coords = vec4(182.13, -246.33, 53.61, 149.7), stand = vec3(181.83, -246.8, 54.11) },
}

Config.BBChairs = {
	{ coords = vec4(380.65, -830.63, 28.8, 273.55), },
	{ coords = vec4(380.65, -831.67, 28.8, 273.55), },
}

Config.JCChairs = {
	{ coords = vec4(196.1, -237.26, 53.6, 76.37), },
	{ coords = vec4(196.4, -236.43, 53.6, 68.66), },
	{ coords = vec4(196.69, -235.53, 53.6, 70.79), },
	{ coords = vec4(193.45, -237.32, 53.6, 310.73), },
	{ coords = vec4(193.52, -234.25, 53.6, 256.35), },
}

Config.WCChairs = {
	{ coords = vec4(353.95, -1022.83, 28.9, 270.89), },
	{ coords = vec4(354.03, -1022.18, 28.9, 270.89), },
	{ coords = vec4(354.0, -1021.47, 28.9, 270.89), },
}

AddEventHandler('onResourceStop', function(r) if r ~= GetCurrentResourceName() or not LocalPlayer.state.isLoggedIn then return end
	for k in pairs(Chairs) do exports['qb-target']:RemoveZone(k) end
end)