local popseat, sitting, Chairs = nil, false, {}

CreateThread(function()
	for k, v in pairs(Config.Chairs) do
		Chairs["PopChair"..k] =
		exports['qb-target']:AddBoxZone("PopChair"..k, vec3(v.coords.x, v.coords.y, v.coords.z-1), 0.7, 0.7, { name="PopChair"..k, heading = v.coords.w, debugPoly=Config.Debug, minZ = v.coords.z-1.2, maxZ = v.coords.z+0.1, },
			{ options = { { event = "jim-popsdiner:Chair", icon = "fas fa-chair", label = Loc[Config.Lan].targetinfo["Sit Down"], loc = v.coords, stand = v.stand }, },
				distance = 2.2
		})
	end
end)

RegisterNetEvent('jim-popsdiner:Chair', function(data)
	local canSit = true
	local sitting = false
	local ped = PlayerPedId()
	for _, v in pairs(QBCore.Functions.GetPlayersFromCoords(data.loc.xyz, 0.6)) do
		local dist = #(GetEntityCoords(GetPlayerPed(v)) - data.loc.xyz
	)
		if dist <= 0.4 then triggerNotify(nil, Loc[Config.Lan].error["someone_sitting"]) canSit = false end
	end
	if canSit then
		if not IsPedHeadingTowardsPosition(ped, data.loc.xyz, 20.0) then TaskTurnPedToFaceCoord(ped, data.loc.xyz, 1500) Wait(1500)	end
		if #(data.loc.xyz - GetEntityCoords(ped)) > 1.5 then TaskGoStraightToCoord(ped, data.loc.xyz, 0.5, 1000, 0.0, 0) Wait(1100) end
		TaskStartScenarioAtPosition(ped, "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", data.loc.x, data.loc.y, data.loc.z-0.5, data.loc[4], 0, 1, true)
		popseat = data.stand
		sitting = true
	end
	while sitting do
		if sitting then
			if IsControlJustReleased(0, 202) and IsPedUsingScenario(ped, "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER") then
				sitting = false
				ClearPedTasks(ped)
				if popseat then SetEntityCoords(ped, popseat) end
				popseat = nil
			end
		end
		Wait(5) if not IsPedUsingScenario(ped, "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER") then sitting = false end
	end
end)

Config.Chairs = {
	--Booth 1
	{ coords = vec4(1593.25, 6450.03, 26.01, 65.0), stand = vec3(1593.93, 6451.63, 26.01-0.5) },
	{ coords = vec4(1593.57, 6450.74, 26.01, 65.0), stand = vec3(1593.93, 6451.63, 26.01-0.5) },

	{ coords = vec4(1591.93, 6450.64, 26.01, 245.0), stand = vec3(1592.65, 6452.07, 26.01-0.5) },
	{ coords = vec4(1592.28, 6451.36, 26.01, 245.0), stand = vec3(1592.65, 6452.07, 26.01-0.5) },
	--Booth 2
	{ coords = vec4(1591.42, 6450.89, 26.01, 65.0), stand = vec3(1592.09, 6452.27, 26.01-0.5) },
	{ coords = vec4(1591.75, 6451.59, 26.01, 65.0), stand = vec3(1592.09, 6452.27, 26.01-0.5) },

	{ coords = vec4(1590.15, 6451.5, 26.01, 245.0), stand = vec3(1590.93, 6452.8, 26.01-0.5) },
	{ coords = vec4(1590.47, 6452.21, 26.01, 245.0), stand = vec3(1590.93, 6452.8, 26.01-0.5) },
	--Booth 3
	{ coords = vec4(1589.61, 6451.71, 26.01, 65.0), stand = vec3(1590.28, 6453.06, 26.01-0.5) },
	{ coords = vec4(1589.93, 6452.44, 26.01, 65.0), stand = vec3(1590.28, 6453.06, 26.01-0.5) },

	{ coords = vec4(1588.32, 6452.35, 26.01, 245.0), stand = vec3(1589.06, 6453.71, 26.01-0.5) },
	{ coords = vec4(1588.67, 6453.08, 26.01, 245.0), stand = vec3(1589.06, 6453.71, 26.01-0.5) },
	--Booth 4
	{ coords = vec4(1587.82, 6452.59, 26.01, 65.0), stand = vec3(1588.43, 6454.06, 26.01-0.5) },
	{ coords = vec4(1588.14, 6453.29, 26.01, 65.0), stand = vec3(1588.43, 6454.06, 26.01-0.5) },

	{ coords = vec4(1586.52, 6453.2, 26.01, 245.0), stand = vec3(1587.29, 6454.5, 26.01-0.5) },
	{ coords = vec4(1586.83, 6453.91, 26.01, 245.0), stand = vec3(1587.29, 6454.5, 26.01-0.5) },
	--Booth 5
	{ coords = vec4(1586.0, 6453.43, 26.01, 65.0), stand = vec3(1586.58, 6454.88, 26.01-0.5) },
	{ coords = vec4(1586.33, 6454.15, 26.01, 65.0), stand = vec3(1586.58, 6454.88, 26.01-0.5) },

	{ coords = vec4(1584.7, 6454.06, 26.01, 245.0), stand = vec3(1585.42, 6455.34, 26.01-0.5) },
	{ coords = vec4(1585.03, 6454.77, 26.01, 245.0), stand = vec3(1585.42, 6455.34, 26.01-0.5) },
	--Booth 6
	{ coords = vec4(1584.17, 6454.27, 26.01, 65.0), stand = vec3(1584.83, 6455.58, 26.01-0.5) },
	{ coords = vec4(1584.51, 6454.99, 26.01, 65.0), stand = vec3(1584.83, 6455.58, 26.01-0.5) },

	{ coords = vec4(1582.87, 6454.9, 26.01, 245.0), stand = vec3(1584.83, 6455.58, 26.01-0.5) },
	{ coords = vec4(1583.22, 6455.63, 26.01, 245.0), stand = vec3(1584.83, 6455.58, 26.01-0.5) },
	--Booth 7
	{ coords = vec4(1582.38, 6455.12, 26.01, 65.0), stand = vec3(1582.9, 6456.53, 26.01-0.5) },
	{ coords = vec4(1582.73, 6455.85, 26.01, 65.0), stand = vec3(1582.9, 6456.53, 26.01-0.5) },

	{ coords = vec4(1581.06, 6455.75, 26.01, 245.0), stand = vec3(1581.86, 6457.11, 26.01-0.5) },
	{ coords = vec4(1581.39, 6456.45, 26.01, 245.0), stand = vec3(1581.86, 6457.11, 26.01-0.5) },

	--STOOLS
	{ coords = vec4(1583.35, 6459.67, 26.01+0.36, 284.0), stand = vec3(1582.95, 6459.58, 26.01-0.5) },
	{ coords = vec4(1583.67, 6458.75, 26.01+0.36, 288.0), stand = vec3(1583.37, 6458.66, 26.01-0.5) },
	{ coords = vec4(1584.02, 6457.82, 26.01+0.36, 303.0), stand = vec3(1583.76, 6457.69, 26.01-0.5) },
	{ coords = vec4(1584.8, 6457.06, 26.01+0.36, 319.0), stand = vec3(1584.61, 6456.82, 26.01-0.5) },
	{ coords = vec4(1585.75, 6456.6, 26.01+0.36, 336.0), stand = vec3(1585.66, 6456.33, 26.01-0.5) },
	{ coords = vec4(1586.67, 6456.17, 26.01+0.36, 336.0), stand = vec3(1586.59, 6455.9, 26.01-0.5) },
	{ coords = vec4(1589.98, 6454.62, 26.01+0.36, 336.0), stand = vec3(1589.88, 6454.4, 26.01-0.5) },
	{ coords = vec4(1590.89, 6454.19, 26.01+0.36, 336.0), stand = vec3(1590.83, 6453.95, 26.01-0.5) },
	{ coords = vec4(1592.75, 6453.48, 26.01+0.36, 336.0), stand = vec3(1592.58, 6453.13, 26.01-0.5) },
	{ coords = vec4(1593.77, 6452.84, 26.01+0.36, 336.0), stand = vec3(1593.69, 6452.59, 26.01-0.5) },
	{ coords = vec4(1594.82, 6452.35, 26.01+0.36, 336.0), stand = vec3(1594.73, 6452.12, 26.01-0.5) },

}

AddEventHandler('onResourceStop', function(r) if r ~= GetCurrentResourceName() then return end
	if GetResourceState("qb-target") == "started" or GetResourceState("ox_target") == "started" then
		for k in pairs(Chairs) do exports['qb-target']:RemoveZone(k) end
	end
end)