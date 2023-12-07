local QBCore = exports[Config.Core]:GetCoreObject()

local Strepper = {}
local Targets = {}
local PedList = {}
local WashStripper, Bouncer, Bouncer2

for _, v in pairs(Config.Locations) do
	if v.zoneEnable then
			if v.MLO == "gabz" then
				--PedList[#PedList+1] = vec4(117.69, -1295.76, 29.27, 319.17)
				PedList[#PedList+1] = vec4(107.71, -1291.65, 29.25, 214.09)
				PedList[#PedList+1] = vec4(108.7, -1282.8, 28.26, 208.82)
				PedList[#PedList+1] = vec4(114.02, -1291.89, 28.26, 28.57)
				PedList[#PedList+1] = vec4(123.99, -1289.42, 30.38, 200.33)
				PedList[#PedList+1] = vec4(119.23, -1283.81, 28.26, 123.1)
				PedList[#PedList+1] = vec4(113.24, -1304.33, 29.29, 351.54)
				PedList[#PedList+1] = vec4(112.27, -1302.71, 29.29, 255.14)
				PedList[#PedList+1] = vec4(117.99, -1299.24, 29.27, 125.51)
			elseif v.MLO == "van" then
				PedList[#PedList+1] = vec4(115.96, -1299.53, 29.02, 302.23)
				PedList[#PedList+1] = vec4(117.34, -1292.64, 28.26, 29.26)
				PedList[#PedList+1] = vec4(117.69, -1295.76, 29.27, 319.17)
				PedList[#PedList+1] = vec4(110.23, -1289.44, 28.86, 237.82)
				PedList[#PedList+1] = vec4(106.68, -1289.48, 28.86, 32.73)
				PedList[#PedList+1] = vec4(108.7, -1282.8, 28.26, 208.82)
				PedList[#PedList+1] = vec4(114.02, -1291.89, 28.26, 28.57)
				PedList[#PedList+1] = vec4(123.99, -1289.42, 30.38, 200.33)
				PedList[#PedList+1] = vec4(119.23, -1283.81, 28.26, 123.1)
			elseif v.MLO == "gabzbm" then
				PedList[#PedList+1] = vec4(-1407.26, -609.67, 31.10, 298.64)
				PedList[#PedList+1] = vec4(-1402.08, -618.03, 31.10, 301.4)
				PedList[#PedList+1] = vec4(-1376.45, -609.13, 32.24, 158.47)
			elseif v.MLO == "fiv3devs" then

		end
	end
end

-- Wash Stripper

local canVUWash = function()
	return (QBCore.Functions.GetPlayerData().metadata.canVUWash or false)
end
local outsideLocations = {
	vector3(125.69, -1225.64, 29.42),
	vector3(124.82, -1215.64, 29.33),
	vector3(127.0, -1206.03, 29.3),
	vector3(147.93, -1193.98, 29.42),
	vector3(161.81, -1197.08, 29.33),
	vector3(171.18, -1204.57, 29.3),
	vector3(159.27, -1213.0, 29.3)

}
local sendOutside = function()
	local ped = PlayerPedId()
	triggerNotify(nil, "Bouncer : Hey what are you doing here!", "error")
	SetPedToRagdollWithFall(ped, 2500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	DoScreenFadeOut(3000)
	Wait(4000)
	SetEntityCoords(ped, outsideLocations[math.random(#outsideLocations)])
	SetPedToRagdollWithFall(ped, 10000, 3000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	Wait(2000)
	DoScreenFadeIn(3000)
end

if Config.Strippers then
	CreateThread(function()
		local i = 0
		for k, v in pairs(PedList) do i += 1
			local rand = math.random(1,3)local randped = math.random(1,2)
			Strepper[#Strepper+1] = makePed("CSB_Stripper_0"..randped, v, true, true, nil, { "mini@strip_club@private_dance@part"..rand, "priv_dance_p"..rand })
			Targets["Strep"..i] =
				exports['qb-target']:AddBoxZone("Strep"..i, vec3(v.x, v.y, v.z-1.3), 0.8, 0.8, { name="Strep"..i, heading = v.w, debugPoly=Config.Debug, minZ = v.z-1.0, maxZ=v.z+1.0 },
					{ options = { { event = "jim-vanillaunicorn:PayStrep", icon = "fas fa-money-bill-1-wave", label = Loc[Config.Lan].info["tip"]..Config.TipCost, ped = Strepper[#Strepper] }, },
					distance = 1.5 })
			Wait(100)
		end
		local randped = math.random(1,2)
		WashStripper = makePed("CSB_Stripper_0"..randped, vector4(107.85, -1306.0, 35.59, 149.57), true, true, nil, { "amb@world_human_smoking@female@idle_a", "idle_c" })
		Targets["WashStripper"] =
			exports['qb-target']:AddBoxZone("WashStripper", vector4(107.85, -1306.0, 35.59, 149.57), 0.8, 0.8, { name="Strep"..i, heading = 104.56, debugPoly=Config.Debug, minZ = 35.27-1.0, maxZ=35.27+1.0 },
				{ options = {
					{ event = "jim-vanillaunicorn:WashMoney", icon = "fas fa-money-bill-1-wave", label = 'Tip Marked Bills', ped = WashStripper, canInteract = function() return QBCore.Functions.GetPlayerData().metadata.canVUWash end },
					{ event = "jim-vanillaunicorn:PresentCustomer", icon = "fa-solid fa-user-group", label = 'Present Customer', ped = WashStripper, canInteract = function() return GlobalState.VUBusinessMeeting and QBCore.Functions.GetPlayerData().job.name == 'vanilla' and QBCore.Functions.GetPlayerData().job.isboss end },
				},
				distance = 1.5 })

		Bouncer = makePed("s_m_m_bouncer_01", vector4(105.41, -1289.92, 29.22, 334.36), true, true, nil, { "amb@world_human_stand_guard@male@idle_b", "idle_d" })
		Targets["VUBouncer"] =
			exports['qb-target']:AddBoxZone("VUBouncer", vec3(105.41, -1289.92, 29.22), 0.6, 0.6, { name="VUBouncer", heading = 334.36, debugPoly=Config.Debug, minZ = 29.27-1.0, maxZ=29.27+1.0 },
				{ options = {
					{ event = "jim-vanillaunicorn:ShowMembership", icon = "fa-solid fa-comments", label = 'Ask to see Kelly.', ped = Bouncer, canInteract = function() return QBCore.Functions.GetPlayerData().metadata.canVUWash end },
					{ event = "jim-vanillaunicorn:EnableMeeting", icon = "fa-solid fa-business-time", label = 'Toggle Business Meeting', ped = Bouncer, canInteract = function() return QBCore.Functions.GetPlayerData().job.name == 'vanilla' and QBCore.Functions.GetPlayerData().job.isboss end },
				},
				distance = 1.5 })

		Bouncer2 = makePed("s_m_m_bouncer_01", vector4(104.64, -1290.74, 29.22, 120.2), true, true, nil, { "amb@world_human_stand_guard@male@idle_b", "idle_d" })
		Targets["VUBouncer2"] =
			exports['qb-target']:AddBoxZone("VUBouncer2", vec3(104.64, -1290.74, 29.22), 0.6, 0.6, { name="VUBouncer2", heading = 120.2, debugPoly=Config.Debug, minZ = 29.27-1.0, maxZ=29.27+1.0 },
				{ options = {
					{ event = "jim-vanillaunicorn:leave", icon = "fa-solid fa-door-open", label = 'Ask to open the door.', ped = Bouncer2},
				},
				distance = 1.5 })

		local loungePoint = lib.points.new(vector4(102.75, -1315.48, 31.85, 26.83), 1.0)
		function loungePoint:onEnter() if not GlobalState.VUBusinessMeeting and QBCore.Functions.GetPlayerData().job.name ~= 'vanilla' and not canVUWash() then sendOutside() end end

		if Config.PrintDebug then print("^5Debug^7: ^2Created ^6"..i.."^2 strippers^7.") end
	end)
end

RegisterNetEvent('jim-vanillaunicorn:EnableMeeting', function() TriggerServerEvent('jim-vanillaunicorn:BusinessMeeting') end)
RegisterNetEvent('jim-vanillaunicorn:leave', function()
	TriggerServerEvent('qb-doorlock:server:updateState', 'VU-Employee', false, false, true, true, false, false)
	Wait(3000)
	TriggerServerEvent('qb-doorlock:server:updateState', 'VU-Employee', true, false, true, true, false, false)
end)

RegisterNetEvent('jim-vanillaunicorn:PresentCustomer', function()
	local c, d = QBCore.Functions.GetClosestPlayer()
	if not c then return end
	local customer = GetPlayerServerId(c)
	if not customer or customer == 0 or d >= 3.0 then triggerNotify(nil, "There is no one nearby...", "error") end
	TriggerServerEvent('jim-vanillaunicorn:sPresentPlayer', customer)
end)


RegisterNetEvent('jim-vanillaunicorn:ShowMembership', function()
	if GlobalState.VUBusinessMeeting then triggerNotify(nil, "There is a business meeting right now, come back later.", "error") return end
	if canVUWash() then
		TriggerServerEvent('qb-doorlock:server:updateState', 'VU-Employee', false, false, true, true, false, false)
		Wait(3000)
		TriggerServerEvent('qb-doorlock:server:updateState', 'VU-Employee', true, false, true, true, false, false)
	end
end)

RegisterNetEvent("jim-vanillaunicorn:PayStrep", function(data)
	local p = promise.new()	QBCore.Functions.TriggerCallback("jim-vanillaunicorn:GetCash", function(cb) p:resolve(cb) end)
	if Citizen.Await(p) >= Config.TipCost then TriggerServerEvent("jim-vanillaunicorn:StrepTip")
	else triggerNotify(nil, "Not Enough Cash", "error") return end
	--Spawn money and hand to ped
	loadAnimDict("mp_common")
	loadModel(`prop_anim_cash_note`)
	if prop == nil then prop = CreateObject(`prop_anim_cash_note`, 0.0, 0.0, 0.0, true, false, false) end
	AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.1, -0.0, 0.0, -180.0, 0.0, 0.0, true, true, false, true, 1, true)
	TaskPlayAnim(data.ped, "mp_common", "givetake2_b", 3.0, 3.0, 0.3, 16, 0.2, 0, 0, 0)
	TaskPlayAnim(PlayerPedId(), "mp_common", "givetake2_a", 3.0, 3.0, -1, 16, 0.1, 0, 0, 0)
	--Take Money and stop animiation
	Wait(1000)
	AttachEntityToEntity(prop, data.ped, GetPedBoneIndex(v, 57005), 0.1, -0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
	Wait(1000)
	StopAnimTask(PlayerPedId(), "mp_common", "givetake2_b", 1.0)
	StopAnimTask(data.ped, "mp_common", "givetake2_a", 1.0)
	destroyProp(prop) unloadModel(`prop_anim_cash_note`)
	unloadAnimDict("mp_common")
	prop = nil
	CreateThread(function()
		FreezeEntityPosition(data.ped, false)
		if not IsPedHeadingTowardsPosition(data.ped, GetEntityCoords(PlayerPedId()), 20.0) then TaskTurnPedToFaceCoord(data.ped, GetEntityCoords(PlayerPedId()), 1500) Wait(1600) end
		--Blow kiss
		loadAnimDict("anim@mp_player_intselfieblow_kiss")
		TaskPlayAnim(data.ped, "anim@mp_player_intselfieblow_kiss", "exit", 3.0, 3.0, -1, 16, 0.1, 0, 0, 0)
		Wait(3000)
		--Relieve stress and heal 2hp
		TriggerServerEvent('hud:server:RelieveStress', Config.TipStress)
		unloadAnimDict("anim@mp_player_intselfieblow_kiss")
		local rand = math.random(1,3)
		loadAnimDict("mini@strip_club@private_dance@part"..rand)
		TaskPlayAnim(data.ped, "mini@strip_club@private_dance@part"..rand, "priv_dance_p"..rand, 1.0, 1.0, -1, 1, 0.2, 0, 0, 0)
		FreezeEntityPosition(data.ped, true)
	end)
end)

RegisterNetEvent("jim-vanillaunicorn:WashMoney", function(data)
	if not QBCore.Functions.GetPlayerData().metadata.canVUWash then triggerNotify(nil, "I don't know you...", "error") return end
	local p = promise.new()	QBCore.Functions.TriggerCallback("jim-vanillaunicorn:GetMarkedCash", function(cb) p:resolve(cb) end)
	if Citizen.Await(p) then
		TriggerServerEvent("jim-vanillaunicorn:StrepWash")
	else
		return
	end
	--Spawn money and hand to ped
	loadAnimDict("mp_common")
	loadModel(`prop_anim_cash_note`)
	if prop == nil then prop = CreateObject(`prop_anim_cash_note`, 0.0, 0.0, 0.0, true, false, false) end
	AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.1, -0.0, 0.0, -180.0, 0.0, 0.0, true, true, false, true, 1, true)
	TaskPlayAnim(data.ped, "mp_common", "givetake2_b", 3.0, 3.0, 0.3, 16, 0.2, 0, 0, 0)
	TaskPlayAnim(PlayerPedId(), "mp_common", "givetake2_a", 3.0, 3.0, -1, 16, 0.1, 0, 0, 0)
	--Take Money and stop animiation
	Wait(1000)
	AttachEntityToEntity(prop, data.ped, GetPedBoneIndex(v, 57005), 0.1, -0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
	Wait(1000)
	StopAnimTask(PlayerPedId(), "mp_common", "givetake2_b", 1.0)
	StopAnimTask(data.ped, "mp_common", "givetake2_a", 1.0)
	destroyProp(prop) unloadModel(`prop_anim_cash_note`)
	unloadAnimDict("mp_common")
	prop = nil
	CreateThread(function()
		FreezeEntityPosition(data.ped, false)
		if not IsPedHeadingTowardsPosition(data.ped, GetEntityCoords(PlayerPedId()), 20.0) then TaskTurnPedToFaceCoord(data.ped, GetEntityCoords(PlayerPedId()), 1500) Wait(1600) end
		--Blow kiss
		loadAnimDict("anim@mp_player_intselfieblow_kiss")
		TaskPlayAnim(data.ped, "anim@mp_player_intselfieblow_kiss", "exit", 3.0, 3.0, -1, 16, 0.1, 0, 0, 0)
		Wait(3000)
		--Relieve stress and heal 2hp
		TriggerServerEvent('hud:server:RelieveStress', Config.TipStress)
		unloadAnimDict("anim@mp_player_intselfieblow_kiss")

		loadAnimDict("amb@world_human_smoking@female@idle_a")
		TaskPlayAnim(data.ped, "amb@world_human_smoking@female@idle_a", "idle_c", 1.0, 1.0, -1, 1, 0.2, 0, 0, 0)
		FreezeEntityPosition(data.ped, true)
	end)
end)

AddEventHandler('onResourceStop', function(r) if r ~= GetCurrentResourceName() then return end
	if GetResourceState("qb-target") == "started" or GetResourceState("ox_target") == "started" then
		for k in pairs(Targets) do exports["qb-target"]:RemoveZone(k) end
		for _, v in pairs(Strepper) do DeleteEntity(v) end
	end
end)