if not Config.Overrides.disableNos then
--========================================================== NOS
--Leave alone--
local nosColour = {}
local soundId = GetSoundId()
manualPurgeLoc = {}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() GetNos() GetNosColour() end)

AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() == resource then GetNos() GetNosColour() end end)

function GetNos()
	local p = promise.new() QBCore.Functions.TriggerCallback('jim-mechanic:GetNosLoaded', function(vehs) p:resolve(vehs) end) VehicleNitrous = Citizen.Await(p)
	for plate in pairs(VehicleNitrous) do
		if Config.System.Debug then print("^5Debug^7: ^3VehicleNitrous^7[^6"..tostring(plate).."^7] = { ^2level^7: ^4"..tonumber(VehicleNitrous[plate].level).."^7, ^2hasnitro^7: ^4"..tostring(VehicleNitrous[plate].hasnitro).."^7, ^2turbo_uses^7: ^4"..tostring(VehicleNitrous[plate].turbo_uses).."^7  }") end
	end
end

function GetNosColour()
	local p = promise.new() QBCore.Functions.TriggerCallback('jim-mechanic:GetNosColour', function(vehs) p:resolve(vehs) end) nosColour = Citizen.Await(p)
	for plate in pairs(nosColour) do
		if Config.System.Debug then print("^5Debug^7: ^3nosColour^7[^6"..tostring(plate).."^7] = { ^2RBG^7: ^4"..nosColour[plate][1].."^7, ^4"..nosColour[plate][2].."^7, ^4"..nosColour[plate][3].." ^7}") end
	end
end

local function nosEngineAdd(ped, vehicle, plate) local item = QBCore.Shared.Items["modified_turbo"]
	stopTempCam()
	local emote = { anim = "fixing_a_ped", dict = "mini@repair", flag = 16 }
	triggerNotify(nil, Loc[Config.Lan]["common"].installing..item.label, "success")
	if progressBar({label = Loc[Config.Lan]["common"].installing..item.label, time = math.random(7000,10000), anim = emote.anim, dict = emote.dict, flag = emote.flag, cancel = true }) then SetVehicleModKit(vehicle, 0)
		--if VehicleNitrous[trim(GetVehicleNumberPlateText(vehicle))] then toggleItem(true, "noscan", 1) end
		local turbo_uses = math.random(8, 12)
		TriggerServerEvent('jim-mechanic:database:installModifiedNOSEngine', plate, turbo_uses)
		TriggerEvent("QBCore:Notify", "Sucesfully installed the Modified Turbo on the vehicle", "success")

		updateCar(vehicle)
		toggleItem(false, "modified_turbo", 1)
		triggerNotify(nil, item.label.." "..Loc[Config.Lan]["common"].installed, "success")
	else
		triggerNotify(nil, item.label..Loc[Config.Lan]["common"].instfail, "error")
	end
end

-- Add nirous can to vehicle?
local function nosAdd(ped, vehicle) local item = QBCore.Shared.Items["nos"]
	stopTempCam()
	local emote = { anim = "fixing_a_ped", dict = "mini@repair", flag = 16 }
	triggerNotify(nil, Loc[Config.Lan]["common"].installing..item.label, "success")
	if progressBar({label = Loc[Config.Lan]["common"].installing..item.label, time = math.random(7000,10000), anim = emote.anim, dict = emote.dict, flag = emote.flag, cancel = true }) then SetVehicleModKit(vehicle, 0)
		--if VehicleNitrous[trim(GetVehicleNumberPlateText(vehicle))] then toggleItem(true, "noscan", 1) end
		TriggerServerEvent('jim-mechanic:server:LoadNitrous', trim(GetVehicleNumberPlateText(vehicle)))
		TriggerServerEvent('jim-mechanic:server:DamageModifiedTurbo', Plate)
		updateCar(vehicle)
		toggleItem(false, "nos", 1)
		triggerNotify(nil, item.label.." "..Loc[Config.Lan]["common"].installed, "success")
	else
		triggerNotify(nil, item.label..Loc[Config.Lan]["common"].instfail, "error")
	end
	if Config.Overrides.DoorAnimations then SetVehicleDoorsShut(vehicle, 4, false) end
	ClearPedTasks(ped)
	emptyHands(ped)
end

local function nosFail(ped, vehicle)
	stopTempCam()
	triggerNotify(nil, QBCore.Shared.Items["nos"].label..Loc[Config.Lan]["common"].instfail, "error")
	if Config.Overrides.DoorAnimations then SetVehicleDoorShut(vehicle, 4, false) end
	emptyHands(ped)
	if Config.NOS.explosiveFail then
		local chance = math.random(1,10)
		if not Config.NOS.explosiveFailJob then
			if not jobChecks() then
				if chance == 10 then
					SetVehicleDoorBroken(vehicle, 4, 0) -- Rip Hood off
					Wait(100)
					AddExplosion(GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 1.6, 1.0), 2, 0.8, 1, 0, 1.0, true)
					toggleItem(false, "nos", 1)
				end
			end
		elseif Config.NOS.explosiveFailJob then
			if chance == 10 then
				SetVehicleDoorBroken(vehicle, 4, 0) -- Rip Hood off
				Wait(100)
				AddExplosion(GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 1.6, 1.0), 2, 0.8, 1, 0, 1.0, true)
				toggleItem(false, "nos", 1)
			end
		end
	end
end

RegisterNetEvent('jim-mechanic:client:applyNOSEngine', function() local Ped = PlayerPedId()
	local coords = GetEntityCoords(Ped)
	if Config.NOS.JobOnly then
		if not jobChecks() then return end
		if not locationChecks() then return end
	end
	if not inCar() then return end
	if not nearPoint(coords) then return end
	if IsPedInAnyVehicle(Ped, false) then return end
	vehicle = getClosest(coords) pushVehicle(vehicle)
	--if lockedCar(vehicle) then return end
	if DoesEntityExist(vehicle) then
		if not IsToggleModOn(vehicle, 18) then TriggerEvent("QBCore:Notify", "The car needs a regular turbo to do this...", "error") return end
		local Plate = trim(GetVehicleNumberPlateText(vehicle))
		local stop
		QBCore.Functions.TriggerCallback('jim-mechanic:checkNOSEngine', function(hasEngine)
			if hasEngine == 1 and VehicleNitrous[Plate] and VehicleNitrous[Plate].turbo_uses > 0 then TriggerEvent("QBCore:Notify", "There is already a modified turbo installed!", "error") return end
			local cam = createTempCam(vehicle, Ped)
			if not lookAtEngine(vehicle) then return end
			SetVehicleEngineOn(vehicle, false, false, false)
			Wait(1000)
			startTempCam(cam)
			if VehicleNitrous[Plate] and VehicleNitrous[Plate].turbo_uses <= 0 then
				local time = math.random(7000,10000)
				playAnim("mini@repair", "fixing_a_ped", time, 16)
				QBCore.Functions.Progressbar("drink_something", "Removing Broken Modifed Turbo..", time, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = false, },
				{ animDict = "mini@repair", anim = "fixing_a_ped", flags = 16, }, {}, {}, function()
					ClearPedTasks(playerPed)
					TriggerEvent("QBCore:Notify", "Succesfully removed the broken Modified Turbo", "success")
				end, function() -- Cancel
					TriggerEvent("QBCore:Notify", "Failed to remove the broken Modified Turbo", "error")
					emptyHands(playerPed)
					stop = true
				end)
				Wait(time + 1000)
			end
			if stop then return end
			playAnim("mini@repair", "fixing_a_ped", 35000, 16)
			if Config.Overrides.DoorAnimations then SetVehicleDoorOpen(vehicle, 4, false, false) end
			if Config.NOS.skillcheck == "qb-lock" then
				local Skillbar = exports['qb-lock']:StartLockPickCircle(math.random(2,4), math.random(7,10), success)
				if Skillbar then nosAdd(Ped, vehicle) else nosFail(Ped, vehicle) end
			elseif Config.NOS.skillcheck == "ps-ui" then
				exports['ps-ui']:Circle(function(Skillbar)
					if Skillbar then nosAdd(Ped, vehicle) else nosFail(Ped, vehicle) end
				end, 2, 20)
			elseif Config.NOS.skillcheck == "qb-skillbar" then
				local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
				Skillbar.Start({ duration = math.random(2500,5000), pos = math.random(10, 30), width = math.random(10, 20),	},	function() -- On success
					nosEngineAdd(Ped, vehicle, Plate)
				end, function() -- On fail
					stopTempCam()
					triggerNotify(nil, QBCore.Shared.Items["modified_turbo"].label..Loc[Config.Lan]["common"].instfail, "error")
					if Config.Overrides.DoorAnimations then SetVehicleDoorShut(vehicle, 4, false) end
					emptyHands(ped)
				end)
			elseif Config.NOS.skillcheck == "ox_lib" then
				local Skillbar = exports.ox_lib:skillCheck({'easy', 'easy', 'easy' }, {'1', '2', '3', '4'})
				if Skillbar then nosEngineAdd(Ped, vehicle, Plate)
				else
					stopTempCam()
					triggerNotify(nil, QBCore.Shared.Items["modified_turbo"].label..Loc[Config.Lan]["common"].instfail, "error")
					if Config.Overrides.DoorAnimations then SetVehicleDoorShut(vehicle, 4, false) end
					emptyHands(ped)
				end
			else
				nosEngineAdd(Ped, vehicle, Plate)
			end
		end, Plate)
	end
end)

RegisterNetEvent('jim-mechanic:client:applyNOS', function() local Ped = PlayerPedId()
	local coords = GetEntityCoords(Ped)
	-- if Config.NOS.JobOnly then
	-- 	if not jobChecks() then return end
	-- 	if not locationChecks() then return end
	-- end
	if not outCar() then return end
	if not nearPoint(coords) then return end
	vehicle = getClosest(coords) pushVehicle(vehicle)
	--if lockedCar(vehicle) then return end
	if DoesEntityExist(vehicle) then
		--local above = isVehicleLift(vehicle)
		--if not IsToggleModOn(vehicle, 18) then triggerNotify(nil, Loc[Config.Lan]["nos"].notinstalled, "error") return end
		local Plate = trim(GetVehicleNumberPlateText(vehicle))
		if not VehicleNitrous[Plate] then TriggerEvent("QBCore:Notify", "There is no way to fit this bottle here, you might need a special modified turbo...", "error") return end
		if VehicleNitrous[Plate].hasnitro and VehicleNitrous[Plate].hasnitro == 1 then TriggerEvent("QBCore:Notify", "There is already a bottle installed!", "error") return end
		if VehicleNitrous[Plate].turbo_uses <= 0 then TriggerEvent("QBCore:Notify", "It seems like your modified turbo is too damaged to accept any more NOS...", "error") return end

		local cam = createTempCam(vehicle, Ped)
		--if not lookAtEngine(vehicle) then return end
		SetVehicleEngineOn(vehicle, false, false, false)
		Wait(1000)
		playAnim("mini@repair", "fixing_a_ped", 35000, 16)
		startTempCam(cam)
		if Config.Overrides.DoorAnimations then SetVehicleDoorOpen(vehicle, 4, false, false) end
		if Config.NOS.skillcheck == "qb-lock" then
			local Skillbar = exports['qb-lock']:StartLockPickCircle(math.random(2,4), math.random(7,10), success)
			if Skillbar then nosAdd(Ped, vehicle) else nosFail(Ped, vehicle) end
		elseif Config.NOS.skillcheck == "ps-ui" then
			exports['ps-ui']:Circle(function(Skillbar)
				if Skillbar then nosAdd(Ped, vehicle) else nosFail(Ped, vehicle) end
			end, 2, 20)
		elseif Config.NOS.skillcheck == "qb-skillbar" then
			local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
			Skillbar.Start({ duration = math.random(2500,5000), pos = math.random(10, 30), width = math.random(10, 20),	},	function() -- On success
				nosAdd(Ped, vehicle)
			end, function() -- On fail
				nosFail(Ped, vehicle)
			end)
        elseif Config.NOS.skillcheck == "ox_lib" then
            local Skillbar = exports.ox_lib:skillCheck({'easy', 'easy', 'easy' }, {'1', '2', '3', '4'})
            if Skillbar then nosAdd(Ped, vehicle)
            else nosFail(Ped, vehicle) end
        else
			nosAdd(Ped, vehicle)
		end
	end
end)

RegisterNetEvent('jim-mechanic:client:UpdateNitroLevel', function(Plate, level) VehicleNitrous[Plate] = { hasnitro = true, level = level } end)
RegisterNetEvent('jim-mechanic:client:DamageModifiedTurbo', function(Plate, uses) if not VehicleNitrous[Plate] then VehicleNitrous[Plate] = {hasnitro = false, turbo_uses = uses, level = 0}
else VehicleNitrous[Plate].turbo_uses = uses end end)


RegisterNetEvent('jim-mechanic:client:LoadNitrous', function(Plate)
    VehicleNitrous[Plate] = { hasnitro = true, level = 100, }
    local CurrentVehicle = getClosest(GetEntityCoords(PlayerPedId())) pushVehicle(vehicle)
    local CPlate = trim(GetVehicleNumberPlateText(CurrentVehicle))
    if CPlate == Plate then TriggerEvent('hud:client:UpdateNitrous', VehicleNitrous[Plate].hasnitro, VehicleNitrous[Plate].level, false) end
end)

RegisterNetEvent('jim-mechanic:client:UnloadNitrous', function(Plate)
	if not LocalPlayer.state.isLoggedIn then return end
    --VehicleNitrous[Plate] = nil
	VehicleNitrous[Plate].hasnitro = false VehicleNitrous[Plate].level = 0
    local CPlate = trim(GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId())))
    if CPlate == Plate then NitrousActivated = false TriggerEvent('hud:client:UpdateNitrous', false, nil, false) end
end)

local boosting, CurrentVehicle, CurrentTopSpeed, Plate = false, false, 0, nil, nil

RegisterKeyMapping('levelUP', 'Boost/Purge lvl Up', 'keyboard', 'PRIOR')
RegisterCommand('levelUP', function()
	local Plate = trim(GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId())))
	if VehicleNitrous[Plate] and VehicleNitrous[Plate].hasnitro and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
		if purgemode and purgeSize < 1.0 then
			purgeSize += 0.1
			if purgeSize >= 1.0 then purgeSize = 1.0 end
			if purgeSize > 0.1 then
				if not ShowOdo then	triggerNotify(nil, Loc[Config.Lan]["nos"].spray..math.floor(purgeSize*10)) end
			end
		end
		if not purgemode and boostLevel < 3 and not NitrousActivated then
			boostLevel += 1
			if boostLevel > 3 then boostLevel = 3 end
			if boostLevel <= 3 then
				if not ShowOdo then	triggerNotify(nil, Loc[Config.Lan]["nos"].boost..boostLevel) end
			end
		end
	end
end)

RegisterKeyMapping('levelDown', 'Boost/Purge lvl Down', 'keyboard', 'NEXT')
RegisterCommand('levelDown', function()
	local Plate = trim(GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId())))
	if VehicleNitrous[Plate] and VehicleNitrous[Plate].hasnitro and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
		if purgemode and purgeSize > 0.1 then
			purgeSize -= 0.1
			if purgeSize < 0.1 then purgeSize = 0.1 end
			if purgeSize > 0.1 then
				if not ShowOdo then	triggerNotify(nil, Loc[Config.Lan]["nos"].spray..math.floor(purgeSize*10)) end
			end
		end
		if not purgemode and boostLevel > 1 and not NitrousActivated then
			boostLevel -= 1
			if boostLevel < 1 then boostLevel = 1 end
			if not ShowOdo then	triggerNotify(nil, Loc[Config.Lan]["nos"].boost..boostLevel) end
		end
	end
end)
RegisterKeyMapping('nosSwitch', 'Boost/Purge Switch', 'keyboard', 'LCONTROL')
RegisterCommand('nosSwitch', function()
	local Plate = trim(GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId())))
	if VehicleNitrous[Plate] and VehicleNitrous[Plate].hasnitro and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
		if purgemode then purgemode = false
			if not ShowOdo then	triggerNotify(nil, Loc[Config.Lan]["nos"].boostmode, "success") end
		else purgemode = true
			if not ShowOdo then triggerNotify(nil, Loc[Config.Lan]["nos"].purgemode, "success") end
		end
	end
end)

RegisterKeyMapping('+nosBoost', 'Boost', 'keyboard', 'LSHIFT')
RegisterCommand('+nosBoost', function()
	local Ped = PlayerPedId()
	CurrentVehicle = GetVehiclePedIsIn(Ped)
	if tonumber(CurrentVehicle) == 0 or DoesEntityExist(CurrentVehicle) == false then return end
	if IsPedInAnyVehicle(Ped) then
		Plate = trim(GetVehicleNumberPlateText(CurrentVehicle))
		if VehicleNitrous[Plate] and VehicleNitrous[Plate].hasnitro and (GetVehicleWheelieState(CurrentVehicle) ~= 129 and GetVehicleWheelieState(CurrentVehicle) ~= 65 and not IsEntityInAir(CurrentVehicle)) and GetPedInVehicleSeat(CurrentVehicle, -1) == Ped and VehicleNitrous[Plate].level ~= 0 then
			TriggerEvent('hud:client:UpdateNitrous', VehicleNitrous[Plate].hasnitro, VehicleNitrous[Plate].level, false)
			if purgemode then
				TriggerServerEvent('jim-mechanic:server:SyncPurge', VehToNet(CurrentVehicle), true, purgeSize, GetEntityCoords(CurrentVehicle))
				CreateThread(function()	while boosting do purgeCool += 1 Wait(500) end end)
			end
			if not purgemode then
				if (GetEntitySpeed(CurrentVehicle) * 2.236936) < 120.0 and not boosting then
					boosting = true
					ApplyForceToEntity(CurrentVehicle, 3, 0, Config.NOS.NosBoostPower[boostLevel], 0, 0.0, -1.2, 0.0, 0, true, true, true, false, true)
					NitrousActivated = true
					if Config.NOS.EnableScreen then
						SetNitroBoostScreenEffectsEnabled(true)
					end
					if Config.NOS.EnableTrails then
						TriggerServerEvent('jim-mechanic:server:SyncTrail', VehToNet(CurrentVehicle), true, GetEntityCoords(CurrentVehicle))
					end
					if Config.NOS.EnableFlame then
						TriggerServerEvent('jim-mechanic:server:SyncFlame', VehToNet(CurrentVehicle), true, false, boostLevel, GetEntityCoords(CurrentVehicle))
					end
					SetVehicleBoostActive(CurrentVehicle, 1)
					CreateThread(function()
						while NitrousActivated and Config.NOS.HandlingChange do
							if boostLevel == 1 then
								SetVehicleCheatPowerIncrease(CurrentVehicle, 1.25)
								SetVehicleTurboPressure(CurrentVehicle, 1.25 * GetVehicleCurrentRpm(CurrentVehicle))
								SetVehicleHandlingFloat(CurrentVehicle, "CHandlingData", "fMass", defVehStats[Plate]["hFloat"] + 30.0)
							end
							if boostLevel == 2 then
								SetVehicleCheatPowerIncrease(CurrentVehicle, 1.5)
								SetVehicleTurboPressure(CurrentVehicle, 1.5 * GetVehicleCurrentRpm(CurrentVehicle))
								SetVehicleHandlingFloat(CurrentVehicle, "CHandlingData", "fMass", defVehStats[Plate]["hFloat"] + 60.0)
							end
							if boostLevel == 3 then
								SetVehicleCheatPowerIncrease(CurrentVehicle, 2.2)
								SetVehicleTurboPressure(CurrentVehicle, 2.2 * GetVehicleCurrentRpm(CurrentVehicle))
								SetVehicleHandlingFloat(CurrentVehicle, "CHandlingData", "fMass", defVehStats[Plate]["hFloat"] + 90.0)
							end
							ModifyVehicleTopSpeed(CurrentVehicle, Config.NOS.NosBoostPower[boostLevel])
							Wait(0)
						end
					end)
					-- Boosting Effects
					CreateThread(function()
						while NitrousActivated do
							if VehicleNitrous[Plate].level - 1 >= 0 then
								local nitrousUseRate = boostLevel == 1 and Config.NOS.NitrousUseRate[1] or boostLevel == 2 and Config.NOS.NitrousUseRate[2] or boostLevel == 3 and Config.NOS.NitrousUseRate[3]
								-- if boostLevel == 1 then	nitrousUseRate -= (Config.NOS.NitrousUseRate / 2) end
								-- if boostLevel == 3 then	nitrousUseRate += (Config.NOS.NitrousUseRate / 2) end
								TriggerEvent('jim-mechanic:client:UpdateNitroLevel', Plate, (VehicleNitrous[Plate].level - nitrousUseRate)) -- update client with new level / this is now only server synced when leaving the vehicle
								TriggerEvent('hud:client:UpdateNitrous', VehicleNitrous[Plate].hasnitro,  VehicleNitrous[Plate].level, true)

							elseif VehicleNitrous[Plate].level - 1 <= 0 then
								TriggerServerEvent('jim-mechanic:server:UpdateNitroLevel', Plate, 0)
								TriggerServerEvent('jim-mechanic:database:UpdateNitroLevel', Plate, 0)
								--TriggerServerEvent('jim-mechanic:server:UnloadNitrous', Plate)
								--toggleItem(true, "noscan", 1)
								if Config.NOS.EnableScreen then SetNitroBoostScreenEffectsEnabled(false) end
								if Config.NOS.EnableTrails then	TriggerServerEvent('jim-mechanic:server:SyncTrail', VehToNet(CurrentVehicle), false, GetEntityCoords(CurrentVehicle)) end
								if Config.NOS.EnableFlame then TriggerServerEvent('jim-mechanic:server:SyncFlame', VehToNet(CurrentVehicle), false, nil, nil, GetEntityCoords(CurrentVehicle)) end
								NitrousActivated = false
								boosting = false
								SetVehicleBoostActive(CurrentVehicle, false)
								--Reset veh modifiers
								if Config.NOS.HandlingChange then
									SetVehicleCheatPowerIncrease(CurrentVehicle, defVehStats[Plate]["pIncrease"])
									SetVehicleHandlingFloat(CurrentVehicle, "CHandlingData", "fMass", defVehStats[Plate]["hFloat"])
									ModifyVehicleTopSpeed(CurrentVehicle, defVehStats[Plate]["speedMod"])
								end
							end

							Wait(100)
							if IsVehicleStopped(CurrentVehicle) or (GetEntitySpeed(CurrentVehicle) * 3.6) < 20.0 then ExecuteCommand("-nosBoost") end
						end
					end)
					CreateThread(function()
						while NitrousActivated do
							damageTimer += 1
							local engDamage = math.random(14, 19)
							local dmgFctr = (math.random(40, 60) / 10)
							if damageTimer > 7 then
								CreateThread(function()
									RequestAmbientAudioBank("DLC_sum20_Open_Wheel_Racing_Sounds", 0)
									PlaySoundFromEntity(soundId, "tyre_health_warning", CurrentVehicle, "DLC_sum20_Open_Wheel_Racing_Sounds", 1, 0)
									Wait(1000)
									StopSound(soundId)
								end)
								if boostLevel == 1 then engDamage = math.random(0, 13) dmgFctr = (math.random(10, 20) / 10)
								elseif boostLevel == 3 then engDamage = math.random(19, 25) dmgFctr = (math.random(40, 70) / 10) end
								SetVehicleEngineHealth(CurrentVehicle, (GetVehicleEngineHealth(CurrentVehicle) - engDamage))
								if Config.Repairs.ExtraDamages == true then
									DamageRandomComponent(trim(GetVehicleNumberPlateText(CurrentVehicle)), GetVehicleEngineHealth(CurrentVehicle), GetVehicleBodyHealth(CurrentVehicle))
								end
							end
							if damageTimer >= 14  then damageTimer = 14
								if boostLevel == 3 and Config.NOS.boostExplode then
									forceStopNos()
									AddExplosion(GetOffsetFromEntityInWorldCoords(CurrentVehicle, 0.0, 1.6, 1.0), 23, 0.8, 1, 0, 1.0, true)
									TriggerServerEvent('jim-mechanic:server:UnloadNitrous', Plate)
									if Config.NOS.EnableScreen then SetNitroBoostScreenEffectsEnabled(false) end
									if Config.NOS.EnableTrails then TriggerServerEvent('jim-mechanic:server:SyncTrail', VehToNet(CurrentVehicle), false, GetEntityCoords(CurrentVehicle)) end
									NitrousActivated = false
									boosting = not boosting
									SetVehicleBoostActive(CurrentVehicle, false, 0.0, 0.0, 0.0, false)
									CreateThread(function()
										if Config.NOS.EnableFlame then
											for i = 0, 10 do
												TriggerServerEvent('jim-mechanic:server:SyncFlame', VehToNet(CurrentVehicle), true, nil, nil, GetEntityCoords(CurrentVehicle))
												Wait(math.random(200,500))
												TriggerServerEvent('jim-mechanic:server:SyncFlame', VehToNet(CurrentVehicle), false, nil, nil, GetEntityCoords(CurrentVehicle))
												Wait(math.random(0,100))
											end
										end
									end)
									boostLevel = 1
									damageTimer = 0
								end
							end
							Wait(1000)
						end
					end)
				end
			end
		end
	end
end)

function forceStopNos() local Ped = PlayerPedId()
	if Config.System.Debug then print("^5Debug^7: ^3forceStopNos^7: ^4Driver left vehicle, resetting NOS effects") end
	SetVehicleBoostActive(GetVehiclePedIsIn(Ped, true), false, 0.0, 0.0, 0.0, false)
	TriggerServerEvent('jim-mechanic:server:SyncPurge', VehToNet(GetVehiclePedIsIn(Ped, true)), false, nil, GetEntityCoords(GetVehiclePedIsIn(Ped, true)))
	if Config.NOS.EnableFlame then
		TriggerServerEvent('jim-mechanic:server:SyncFlame', VehToNet(GetVehiclePedIsIn(Ped, true)), false, nil, nil, GetEntityCoords(GetVehiclePedIsIn(Ped, true)))
	end
	if Config.NOS.EnableTrails then TriggerServerEvent('jim-mechanic:server:SyncTrail', VehToNet(GetVehiclePedIsIn(Ped, true)), false, GetEntityCoords(GetVehiclePedIsIn(Ped, true))) end
	if Config.NOS.EnableScreen then SetNitroBoostScreenEffectsEnabled(false) end
	local Plate = trim(GetVehicleNumberPlateText(GetVehiclePedIsIn(Ped, true)))
	if VehicleNitrous[Plate] then
		TriggerEvent('hud:client:UpdateNitrous', VehicleNitrous[Plate].hasnitro, VehicleNitrous[Plate].level, false)
	else
		TriggerEvent('hud:client:UpdateNitrous', false, 0, false)
	end

	--Reset veh modifiers
	if Config.NOS.HandlingChange and CurrentVehicle then
		if DoesEntityExist(veh) and veh ~= 0 and veh ~= nil and defVehStats[Plate] ~= nil then
			SetVehicleCheatPowerIncrease(CurrentVehicle, defVehStats[Plate]["pIncrease"])
			SetVehicleHandlingFloat(CurrentVehicle, "CHandlingData", "fMass", defVehStats[Plate]["hFloat"])
			ModifyVehicleTopSpeed(CurrentVehicle, defVehStats[Plate]["speedMod"])
		end
	end

	NitrousActivated = false
	boostLevel = 1
	damageTimer = 0
	purgeCool = 0
	boosting = false
	CurrentVehicle = nil
	Plate = nil
	Wait(1500)
	StopSound(soundId)
end

RegisterCommand('-nosBoost', function()
	local Ped = PlayerPedId()
	if tonumber(CurrentVehicle) == 0 or DoesEntityExist(CurrentVehicle) == false then return end
	TriggerServerEvent('jim-mechanic:server:SyncPurge', VehToNet(CurrentVehicle), false, nil, GetEntityCoords(CurrentVehicle))
	if NitrousActivated then
		StopSound(soundId)
		SetVehicleBoostActive(CurrentVehicle, 0)
		if Config.NOS.EnableFlame then TriggerServerEvent('jim-mechanic:server:SyncFlame', VehToNet(CurrentVehicle), false, nil, nil, GetEntityCoords(CurrentVehicle)) end
		TriggerEvent('hud:client:UpdateNitrous', VehicleNitrous[Plate].hasnitro, VehicleNitrous[Plate].level, false)
		NitrousActivated = not NitrousActivated

		--Reset veh modifiers
		if Config.NOS.HandlingChange and CurrentVehicle then
			SetVehicleCheatPowerIncrease(CurrentVehicle, defVehStats[Plate]["pIncrease"])
			SetVehicleHandlingFloat(CurrentVehicle, "CHandlingData", "fMass", defVehStats[Plate]["hFloat"])
			ModifyVehicleTopSpeed(CurrentVehicle, defVehStats[Plate]["speedMod"])
		end

		if Config.NOS.EnableTrails then TriggerServerEvent('jim-mechanic:server:SyncTrail', VehToNet(CurrentVehicle), false, GetEntityCoords(CurrentVehicle)) end
		if Config.NOS.EnableScreen then SetNitroBoostScreenEffectsEnabled(false) end
		if VehicleNitrous[Plate] then
			CreateThread(function()
				while boosting do
					Wait(1200)
					purgeCool += 1
					if purgeCool >= Config.NOS.NitrousCoolDown then
						if Config.NOS.CooldownConfirm and boosting then
							RequestAmbientAudioBank("dlc_xm_heists_fm_uc_sounds", 0)
							PlaySoundFromEntity(soundId, "download_complete", GetVehiclePedIsIn(Ped), "dlc_xm_heists_fm_uc_sounds", 1, 0)
							Wait(200)
						end
						purgeCool = 0
						damageTimer = 0
						boosting = false
					end
				end
			end)
		end
		CurrentVehicle = nil
		Plate = nil
	end
end)

--For testing Purge locations
--[[CreateThread(function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())
	while true do
		if DoesEntityExist(vehicle) then
			SetVehicleNitroPurgeEnabled(vehicle, true, 1.0)
			Wait(1000)
			SetVehicleNitroPurgeEnabled(vehicle, false)
			Wait(1000)
		end
		Wait(0)
	end
end)]]

--Purge Effects
local vehiclePurge, vehicleTrails = {}, {}

RegisterNetEvent('jim-mechanic:client:SyncPurge', function(netid, enabled, size, coords)
	if coords and #(coords - GetEntityCoords(PlayerPedId())) <= (Config.NOS.PurgeDis or 30.0) then
		if not NetworkDoesEntityExistWithNetworkId(netid) then return end
		if #(GetEntityCoords(NetToVeh(netid)) - GetEntityCoords(PlayerPedId())) >= 200 then return end
		if DoesEntityExist(NetToVeh(netid)) then SetVehicleNitroPurgeEnabled(NetToVeh(netid), enabled, size) end
	end
end)

function SetVehicleNitroPurgeEnabled(vehicle, enabled, size)
	local bonnet = nil
	if enabled and DoesEntityExist(vehicle) then
		RequestAmbientAudioBank("CARWASH_SOUNDS", 0)
		PlaySoundFromEntity(soundId, "SPRAY", vehicle, "CARWASH_SOUNDS", 1, 0)
		local off = GetOffsetFromEntityGivenWorldCoords(vehicle, GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, 'engine')))
		local ptfxs = {}
		local manFound = false
		for i = 0,3 do
			if IsThisModelABike(GetEntityModel(vehicle)) then
				ptfxs[#ptfxs+1] = CreateVehiclePurgeSpray(vehicle, off.x - 0.1, off.y-0.2, off.z, 40.0, -90.0, 70.0, size) -- Left
				ptfxs[#ptfxs+1] = CreateVehiclePurgeSpray(vehicle, off.x + 0.1, off.y-0.2, off.z, 40.0, 90.0, -70.0, size)	--Right
			else
				for k in pairs(manualPurgeLoc) do
					if GetEntityModel(vehicle) == k then
						manFound = true
						for _, v in pairs(manualPurgeLoc[k]) do
							ptfxs[#ptfxs+1] = CreateVehiclePurgeSpray(vehicle, off.x + v[1], off.y + v[2], off.z + v[3], v[4], v[5], v[6], size)
						end
					end
				end
				if not manFound then
					off = GetOffsetFromEntityGivenWorldCoords(vehicle, GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, 'bonnet')))
					ptfxs[#ptfxs+1] = CreateVehiclePurgeSpray(vehicle, off.x - 0.2, off.y + 0.5, off.z, 40.0, -20.0, 0.0, size)
					ptfxs[#ptfxs+1] = CreateVehiclePurgeSpray(vehicle, off.x + 0.2, off.y + 0.5, off.z, 40.0, 20.0, 0.0, size)
				end
			end
			if nosColour[trim(GetVehicleNumberPlateText(vehicle))] then
				for i=1, #ptfxs do
					SetParticleFxLoopedColour(ptfxs[i],
					nosColour[trim(GetVehicleNumberPlateText(vehicle))][1]/255,
					nosColour[trim(GetVehicleNumberPlateText(vehicle))][2]/255,
					nosColour[trim(GetVehicleNumberPlateText(vehicle))][3]/255)
				end
			else
				for i=1, #ptfxs do
					SetParticleFxLoopedColour(ptfxs[i],	255/255, 255/255, 255/255)
				end
			end
		end
			vehiclePurge[vehicle] = ptfxs
	else
		StopSound(soundId)
		if vehiclePurge[vehicle] and #vehiclePurge[vehicle] > 0 then
			for _, v in ipairs(vehiclePurge[vehicle]) do
				StopParticleFxLooped(v)
			end
		end
		vehiclePurge[vehicle] = nil
	end
end
function CreateVehiclePurgeSpray(vehicle, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale)
	if not LocalPlayer.state.isLoggedIn then return end
	if DoesEntityExist(vehicle) then UseParticleFxAssetNextCall('core')
	return StartParticleFxLoopedOnEntity('ent_sht_steam', vehicle, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale, 0, 0, 0) end
end

--[[TRAIL EFFECTS]]--
local trailTable = {}
RegisterNetEvent('jim-mechanic:client:SyncTrail', function(netid, enabled, coords)
	if coords and #(coords - GetEntityCoords(PlayerPedId())) <= (Config.NOS.TrailsDis or 30.0) then
		local vehEntity = NetToVeh(netid)
		if not NetworkDoesEntityExistWithNetworkId(netid) then return end
		if vehEntity ~= 0 and DoesEntityExist(vehEntity) and IsEntityAVehicle(vehEntity) then
			SetVehicleLightTrailEnabled(vehEntity, enabled)
		end
	end
end)

function SetVehicleLightTrailEnabled(vehicle, enabled)
	if enabled then
		vehicleTrails[vehicle] = {
			CreateVehicleLightTrail(vehicle, GetEntityBoneIndexByName(vehicle, "taillight_l"), 1.0),
			CreateVehicleLightTrail(vehicle, GetEntityBoneIndexByName(vehicle, "taillight_r"), 1.0), }
	else
		if vehicleTrails[vehicle] and #vehicleTrails[vehicle] > 0 then
			for _, particleId in ipairs(vehicleTrails[vehicle]) do StopVehicleLightTrail(particleId, 500) end
		end
		vehicleTrails[vehicle] = nil
	end
end
function CreateVehicleLightTrail(vehicle, bone, scale)
	if DoesEntityExist(vehicle) then UseParticleFxAssetNextCall('core')
	local ptfx = StartParticleFxLoopedOnEntityBone('veh_light_red_trail', vehicle, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, bone, scale, false, false, false)
	SetParticleFxLoopedEvolution(ptfx, "speed", 1.0, false)
	return ptfx end
end
function StopVehicleLightTrail(ptfx, duration)
	CreateThread(function()
		local endTime = GetGameTimer() + duration
		while GetGameTimer() < endTime do
			local scale = (endTime - GetGameTimer()) / duration
			SetParticleFxLoopedScale(ptfx, scale)
			SetParticleFxLoopedAlpha(ptfx, scale)
			Wait(0)
		end
		StopParticleFxLooped(ptfx)
	end)
end

--[[FLAME EFFECTS]]--
local flameTable = {}
RegisterNetEvent('jim-mechanic:client:SyncFlame', function(netid, enable, antilag, level, coords)
	if enable then
		if coords and #(coords - GetEntityCoords(PlayerPedId())) <= (Config.NOS.FlameDis or 30.0) then
			local vehEntity = NetToVeh(netid)
			if DoesEntityExist(NetToVeh(netid)) and IsEntityAVehicle(NetToVeh(netid)) then
				if antilag then
					CreateVehicleExhaustBackfire(vehEntity)
				else
					startFlame(netid, level)
				end
			end
		end
	else
		stopFlame(netid)
	end
end)

function startFlame(netid, level) --starts a flame effect loop on client instead of asking server to send over and over
	flameTable[netid] = true local wait = 0
	CreateThread(function()
		local vehEntity = NetToVeh(netid)
		while flameTable[netid] do
			if not NetworkDoesEntityExistWithNetworkId(netid) then break end
			if vehEntity ~= 0 and DoesEntityExist(vehEntity) then wait = 0
				if level == 1 then
					CreateVehicleExhaustBackfire(vehEntity)
					--unloadPtfxDict("veh_xs_vehicle_mods")
				end
				if level == 2 then
					loadPtfxDict("veh_xs_vehicle_mods")
				end
				if level == 3 then
					loadPtfxDict("veh_xs_vehicle_mods")
				end
				SetVehicleNitroEnabled(vehEntity, true, 2.0, 5.0, 0.1, true)
				Wait(10)
				SetVehicleBoostActive(vehEntity, 1)
			else wait = 1000
			end
			Wait(wait)
		end
		SetVehicleNitroEnabled(vehEntity, false)
		SetVehicleBoostActive(vehEntity, false, 0.0, 0.0, 0.0, false)
	end)
end

function stopFlame(netid) flameTable[netid] = nil end

--Exhaust Fires
function CreateVehicleExhaustBackfire(vehicle)
	local exhaustNames = { "exhaust", }
	for i = 2, 16 do exhaustNames[#exhaustNames+1] = "exhaust_"..i end
	loadPtfxDict("core")
	for _, exhaustName in ipairs(exhaustNames) do
		local boneIndex = GetEntityBoneIndexByName(vehicle, exhaustName)
		if boneIndex ~= -1 then
			SetPtfxAssetNextCall("core")
			UseParticleFxAssetNextCall("core")
			StartParticleFxNonLoopedOnEntity("veh_backfire" , vehicle, GetOffsetFromEntityGivenWorldCoords(vehicle, GetWorldPositionOfEntityBone(vehicle, boneIndex)), 0.0, 0.0, 0.0, 1.25, false, false, false)
		end
	end
end

function SetNitroBoostScreenEffectsEnabled(enabled)
	if enabled then
		StopScreenEffect('RaceTurbo')
		StartScreenEffect('RaceTurbo', 0, false)
		SetTimecycleModifier('rply_motionblur')
		ShakeGameplayCam('SKY_DIVING_SHAKE', 0.25)
	else
		StopGameplayCamShaking(true)
		SetTransitionTimecycleModifier('default', 0.35)
	end
end

RegisterCommand('takeNos', function() TriggerEvent('jim-mechanic:client:giveNOS') end)

-- Mechanic Remove NOS
RegisterNetEvent('jim-mechanic:client:giveNOS', function() local item = QBCore.Shared.Items["nos"]

	--if not jobChecks() then return end
	local Ped = PlayerPedId()
	local coords = GetEntityCoords(Ped)
	local vehicle = getClosest(coords) pushVehicle(vehicle) --local above = isVehicleLift(vehicle)

	local Plate = trim(GetVehicleNumberPlateText(vehicle))
	if not VehicleNitrous[Plate].hasnitro then QBCore.Functions.Notify('This vehicle doesn\'t have a NOS bottle!') return end


	--if lockedCar(vehicle) then return end
	--TaskTurnPedToFaceEntity(Ped, vehicle, 1000)
	Wait(1000)
	local emote = { anim = "fixing_a_ped", dict = "mini@repair", flag = 16 }
	if Config.Overrides.DoorAnimations then SetVehicleDoorOpen(vehicle, 4, false, false) end
	if progressBar({label = Loc[Config.Lan]["common"].removing..item.label, time = math.random(7000,10000), anim = emote.anim, dict = emote.dict, flag = emote.flag, icon = "mechanic_tools"}) then
		if Config.Overrides.DoorAnimations then SetVehicleDoorShut(vehicle, 4, false) end
		--SetVehicleMod(vehicle, 16, -1) is this used?
		updateCar(vehicle)
		TriggerServerEvent('jim-mechanic:server:UnloadNitrous', trim(GetVehicleNumberPlateText(vehicle)))
		toggleItem(true, "noscan", 1)
		triggerNotify(nil, item.label.." "..Loc[Config.Lan]["common"].removed, "success")
	else
		triggerNotify(nil, item.label..Loc[Config.Lan]["common"].remfail, "error")
	end
	emptyHands(Ped)
end)

RegisterNetEvent('jim-mechanic:client:ChangeColour', function(Plate, newColour)
	if not LocalPlayer.state.isLoggedIn then return end
	nosColour[Plate] = newColour
	if Config.System.Debug then print("^5Debug^7: ^2Recieving new ^3nosColour^7[^6"..tostring(Plate).."^7] = { ^2RBG: ^7= ^6"..nosColour[Plate][1].."^7, ^6"..nosColour[Plate][2].."^7, ^6"..nosColour[Plate][3].." ^7}") end
end)

RegisterNetEvent('jim-mechanic:client:NOS:RGBApply', function(data) local Ped = PlayerPedId() local coords = GetEntityCoords(Ped)
	local vehicle = getClosest(coords) local above = isVehicleLift(vehicle)
	local emote = { anim = above and "idle_b" or "fixing_a_ped", dict = above and "amb@prop_human_movie_bulb@idle_a" or "mini@repair", flag = above and 1 or 16 }
	lookVeh(vehicle)
	loadPtfxDict("scr_recartheft")
	UseParticleFxAssetNextCall("scr_recartheft")
	SetParticleFxNonLoopedColour(data[1] / 255, data[2] / 255, data[3] / 255)
	SetParticleFxNonLoopedAlpha(1.0)
	local spray = StartNetworkedParticleFxNonLoopedAtCoord("scr_wheel_burnout", GetOffsetFromEntityInWorldCoords(Ped, 0.0, 0.6, 0.8), 0.0, 0.0, GetEntityHeading(vehicle), 0.5, 0.0, 0.0, 0.0)

	if progressBar({label = Loc[Config.Lan]["common"].installing, time = math.random(5000,8000), cancel = true, anim = emote.anim, dict = emote.dict, flag = emote.flag, icon = "noscolour",}) then
		TriggerServerEvent("jim-mechanic:server:ChangeColour", trim(GetVehicleNumberPlateText(vehicle)), data)
		if Config.Overrides.CosmeticItemRemoval then toggleItem(false, "noscolour", 1) end
		triggerNotify(nil, Loc[Config.Lan]["nos"].nosColour.." "..Loc[Config.Lan]["common"].installed, "success")
		qblog("`noscolour` installed [**"..trim(GetVehicleNumberPlateText(vehicle)).."**]")
	end
	emptyHands(PlayerPedId())
	local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetOffsetFromEntityInWorldCoords(vehicle, 1.8, -3.5, 2.5), 0.0, 0.0, 0.0, 60.00, false, 0) PointCamAtEntity(cam, vehicle)
	startTempCam(cam)
	Wait(300)
	TriggerServerEvent('jim-mechanic:server:SyncPurge', VehToNet(vehicle), true, 1.0, GetEntityCoords(vehicle))
	Wait(2000)
	stopTempCam()
	TriggerServerEvent('jim-mechanic:server:SyncPurge', VehToNet(vehicle), false, nil, GetEntityCoords(vehicle))
end)

RegisterNetEvent('jim-mechanic:client:NOS:RGBHexMenu', function(data)
	local coords = GetEntityCoords(PlayerPedId())
	local vehicle = getClosest(coords)
	local plate = trim(GetVehicleNumberPlateText(vehicle))
	local r, g, b = table.unpack(data.currentCol)
	if Config.System.Menu == "ox" then
		if data.hex then format = { type = 'color', label = "HEX:", format = "hex", default = "#"..rgbToHex(r, g, b):upper() }
		else format = { type = 'color', label = "RGB:", format = "rgb", default = "rgb("..r..", "..g..", "..b..")" } end
		dialog = exports.ox_lib:inputDialog(
			Loc[Config.Lan]["nos"].nosColour.." - "..(data.hex and Loc[Config.Lan]["paintrgb"].hexP or Loc[Config.Lan]["paintrgb"].rgbP).."\n"..(data.hex and "#"..rgbToHex(r, g, b):upper() or "["..r..", "..g..", "..b.."]"), { format })
		if dialog then
			if data.hex then dialog[1] = dialog[1]:gsub("#", "") r, g, b = HexTorgb(dialog[1])
			else dialog[1] = convertOxRGB(dialog[1]) r, g, b = tonumber(dialog[1][1]) or r, tonumber(dialog[1][2]) or g, tonumber(dialog[1][3]) or b end
		end
	else
		if data.hex then format = { { type = 'text', name = 'hex', text = "#"..rgbToHex(r, g, b):upper() } }
		else format = { { type = 'number', name = 'Red', text = 'R - '..r }, { type = 'number', name = 'Green', text = 'G - '..g }, { type = 'number', name = 'Blue', text = 'B - '..b } }
		end
			dialog = exports['qb-input']:ShowInput({
				header = "<center>"..Loc[Config.Lan]["nos"].nosColour
						.."<br>"..(data.hex and Loc[Config.Lan]["paintrgb"].hexP or Loc[Config.Lan]["paintrgb"].rgbP)
						.."<br><br>- "..Loc[Config.Lan]["common"].current.." -<br>"..(data.hex and "#"..rgbToHex(r, g, b):upper() or "["..r..", "..g..", "..b.."]"),
				submitText = Loc[Config.Lan]["xenons"].customconfirm,
				inputs = format }
			)
		if dialog then
			if data.hex then
				local hex = dialog.hex:gsub("#","")
				while string.len(hex) < 6 do hex = hex.."0"	Wait(10) end
				r, g, b = HexTorgb(hex)
			else
				r, g, b = tonumber(dialog.Red or r), tonumber(dialog.Green or g), tonumber(dialog.Blue or b)
			end
		end
	end
	if dialog then
		if r > 255 then r = 255 end if g > 255 then g = 255 end if b > 255 then b = 255 end
		TriggerEvent('jim-mechanic:client:NOS:RGBApply', { r, g,b })
	else
		TriggerEvent("jim-mechanic:client:NOS:rgbORhex")
	end
end)

RegisterNetEvent('jim-mechanic:client:NOS:rgbORhex', function() local Ped = PlayerPedId()
	local coords = GetEntityCoords(Ped)
	local vehicle = getClosest(coords)
	if not inCar() then return end
	local plate = trim(GetVehicleNumberPlateText(vehicle))
	local r, g, b = nil
	if nosColour[plate] then
		r, g, b = table.unpack(nosColour[plate])
		currentRBGCol = Config.System.Menu == "ox" and r..", "..g..", "..b or "[<span style='color:#"..rgbToHex(table.unpack(nosColour[plate])):upper().."; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black, 0em 0em 0.5em white, 0em 0em 0.5em white'> "..r.." "..g.." "..b.." </span>]<br>"
		currentHEXCol = Config.System.Menu == "ox" and rgbToHex(table.unpack(nosColour[plate])):upper() or "[#<span style='color:#"..rgbToHex(table.unpack(nosColour[plate])):upper().."; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black, 0em 0em 0.5em white, 0em 0em 0.5em white'>"..rgbToHex(r, g, b):upper().." </span>]<br>"
	else
		r, g, b = table.unpack({ 255, 255, 255 })
		currentRBGCol = Config.System.Menu == "ox" and "255, 255, 255" or "[<span style='color:#FFFFFF; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black, 0em 0em 0.5em white, 0em 0em 0.5em white'> 255 255 255 </span>]<br>"
		currentHEXCol = Config.System.Menu == "ox" and "#FFFFFF" or "[#<span style='color:#FFFFFF; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black, 0em 0em 0.5em white, 0em 0em 0.5em white'>FFFFFF </span>]<br>"
	end
	if DoesEntityExist(vehicle) then
		local PaintMenu = {}
		PaintMenu[#PaintMenu+1] = {
			header = Loc[Config.Lan]["paintrgb"].hexP, text = Loc[Config.Lan]["common"].current..":<br>"..currentHEXCol, params = { event = "jim-mechanic:client:NOS:RGBHexMenu", args = { hex = true, currentCol = { r, g, b } }, },
			title = Loc[Config.Lan]["paintrgb"].hexP, description = Loc[Config.Lan]["common"].current..": \n"..currentHEXCol, event = "jim-mechanic:client:NOS:RGBHexMenu", args = { hex = true, currentCol = { r, g, b } }
		}
		PaintMenu[#PaintMenu+1] = {
			header = Loc[Config.Lan]["paintrgb"].rgbP, text = Loc[Config.Lan]["common"].current..":<br>"..currentRBGCol, params = { event = "jim-mechanic:client:NOS:RGBHexMenu", args = { hex = false, currentCol = { r, g, b } } },
			title = Loc[Config.Lan]["paintrgb"].rgbP, description = Loc[Config.Lan]["common"].current..": \n"..currentRBGCol, event = "jim-mechanic:client:NOS:RGBHexMenu", args = { hex = false, currentCol = { r, g, b } }
		}
		openMenu(PaintMenu, {
			header = Loc[Config.Lan]["nos"].nosColour,
			headertxt = Loc[Config.Lan]["paintrgb"].customheader,
			canClose = true,
		})
	end
end)

manualPurgeLoc = {
	--SUPER CARS--
	[`autarch`] = {
		{ 0.25, -0.6, -0.2, 40.0, -80.0, 90.0 }, --Left
		{ -0.25, -0.6, -0.2, 40.0, 80.0, -90.0 }, --Right
	},
	[`bullet`] = {
		{ 0.60, -1, 0.25, 40.0, 20.0, 0.0 }, --Left
		{ -0.60, -1, 0.25, 40.0, -20.0, 0.0 }, --Right
	},
	[`banshee2`] = {
		{ 0.40, 0.15, 0.25, 75.0, 20.0, 0.0 }, --Left
		{ -0.40, 0.15, 0.25, 75.0, -20.0, 0.0 }, --Right
	},
	[`cheetah`] = {
		{ 0.40, 0.15, 0.25, 75.0, 20.0, 0.0 }, --Left
		{ -0.40, 0.15, 0.25, 75.0, -20.0, 0.0 }, --Right
	},
	[`cyclone`] = {
		{ 0.40, -0.55, 0.05, 75.0, 20.0, 0.0 }, --Left
		{ -0.40, -0.55, 0.05, 75.0, -20.0, 0.0 }, --Right
	},
	[`deveste`] = {
		{ 0.20, 0.0, 0.19, 75.0, 20.0, 0.0 }, --Left
		{ 0.17, -0.15, 0.17, 75.0, 20.0, 0.0 }, --Left
		{ 0.15, -0.30, 0.15, 75.0, 20.0, 0.0 }, --Left
		{ -0.20, 0.0, 0.19, 75.0, -20.0, 0.0 }, --Right
		{ -0.17, -0.15, 0.17, 75.0, -20.0, 0.0 }, --Right
		{ -0.15, -0.30, 0.15, 75.0, -20.0, 0.0 }, --Right
	},
	[`emerus`] = {
		{ 0.50, 0, 0.19, 60.0, 20.0, 0.0 }, --Left
		{ -0.50, 0, 0.19, 60.0, -20.0, 0.0 }, --Right
	},
	[`entity2`] = {
		{ 0.60, 0.2, 0.10, 75.0, 20.0, 0.0 }, --Left
		{ -0.60, 0.2, 0.10, 75.0, -20.0, 0.0 }, --Right
	},
	[`entityxf`] = {
		{ 0.60, 0.2, 0.20, 40.0, 20.0, 0.0 }, --Left
		{ -0.60, 0.2, 0.20, 40.0, -20.0, 0.0 }, --Right
	},
	[`fmj`] = {
		{ 0.25, -0.6, 0.15, 75.0, 20.0, 0.0 }, --Left
		{ -0.25, -0.6, 0.15, 75.0, -20.0, 0.0 }, --Right
	},
	[`furia`] = {
		{ 0.40, -0.55, 0.05, 75.0, 20.0, 0.0 }, --Left
		{ -0.40, -0.55, 0.05, 75.0, -20.0, 0.0 }, --Right
	},
	[`gp1`] = {
		{ 0.25, -0.70, 0.25, 20.0, 20.0, 0.0 }, --Left
		{ 0.25, -0.80, 0.25, 20.0, 20.0, 0.0 }, --Left
		{ 0.25, -0.90, 0.25, 20.0, 20.0, 0.0 }, --Left

		{ -0.25, -0.70, 0.25, 20.0, -20.0, 0.0 }, --Right
		{ -0.25, -0.80, 0.25, 20.0, -20.0, 0.0 }, --Right
		{ -0.25, -0.90, 0.25, 20.0, -20.0, 0.0 }, --Right
	},
	[`ignus`] = {
		{ 0.80, 0.45, 0.15, 75.0, 20.0, 0.0 }, --Left
		{ -0.80, 0.45, 0.15, 75.0, -20.0, 0.0 }, --Right
	},
	[`infernus`] = {
		{ 0.50, 0.3, 0.45, 50.0, 20.0, 0.0 }, --Left
		{ -0.50, 0.3, 0.45, 50.0, -20.0, 0.0 }, --Right
	},
	[`italigtb`] = {
		{ 0.30, 2.3, 0.05, 40.0, 30.0, 0.0 }, --Left
		{ -0.30, 2.3, 0.05, 40.0, -30.0, 0.0 }, --Right
	},
	[`italigtb2`] = {
		{ 0.30, 2.3, 0.05, 40.0, 30.0, 0.0 }, --Left
		{ -0.30, 2.3, 0.05, 40.0, -30.0, 0.0 }, --Right
	},
	[`krieger`] = {
		{ 0.30, 2.3, 0.05, 40.0, 30.0, 0.0 }, --Left
		{ -0.30, 2.3, 0.05, 40.0, -30.0, 0.0 }, --Right
	},
	[`le7b`] = {
		{ 0.30, 2.3, 0.05, 40.0, 30.0, 0.0 }, --Left
		{ -0.30, 2.3, 0.05, 40.0, -30.0, 0.0 }, --Right
	},
	[`nero`] = {
		{ 0.30, 2.2, 0.0, 40.0, 30.0, 0.0 }, --Left
		{ -0.30, 2.2, 0.0, 40.0, -30.0, 0.0 }, --Right
	},
	[`nero2`] = {
		{ 0.40, -0.5, 0.16, 60.0, 20.0, 0.0 }, --Left
		{ -0.40, -0.5, 0.16, 60.0, -20.0, 0.0 }, --Right
	},
	[`osiris`] = {
		{ 0.35, -0.4, 0.12, 60.0, 20.0, 0.0 }, --Left
		{ -0.35, -0.4, 0.12, 60.0, -20.0, 0.0 }, --Right
	},
	[`penetrator`] = {
		{ 0.35, -0.6, 0.12, 60.0, 20.0, 0.0 }, --Left
		{ -0.35, -0.6, 0.12, 60.0, -20.0, 0.0 }, --Right
	},
	[`pfister811`] = {
		{ 0.0, 0.35, 0.28, 0.0, 0.0, 0.0 },
		{ 0.0, 0.15, 0.25, 10.0, 0.0, 0.0 },
		{ 0.0, -0.05, 0.20, 20.0, 0.0, 0.0 },
		{ 0.0, -0.25, 0.15, 30.0, 0.0, 0.0 },
		{ 0.0, -0.50, 0.11, 40.0, 0.0, 0.0 },
	},
	[`prototipo`] = {
		{ 0.30, -0, 0.05, 40.0, 30.0, 0.0 }, --Left
		{ -0.30, -0, 0.05, 40.0, -30.0, 0.0 }, --Right
	},
	[`sc1`] = {
		{ 0.30, -0.65, 0.05, 40.0, 30.0, 0.0 }, --Left
		{ -0.30, -0.65, 0.05, 40.0, -30.0, 0.0 }, --Right
	},
	[`t20`] = {
		{ 0.25, -0.65, 0.10, 40.0, 10.0, 0.0 }, --Left
		{ -0.25, -0.65, 0.10, 40.0, -10.0, 0.0 }, --Right
	},
	[`taipan`] = {
		{ 0.32, 2.3, 0.00, 40.0, 30.0, 0.0 }, --Left
		{ -0.32, 2.3, 0.00, 40.0, -30.0, 0.0 }, --Right
	},
	[`tempesta`] = {
		{ 0.50, -0.65, 0.60, 40.0, 10.0, 0.0 }, --Left
		{ -0.50, -0.65, 0.60, 40.0, -10.0, 0.0 }, --Right
	},
	[`tezeract`] = {
		{ 0.50, -0.65, 0.60, 40.0, 10.0, 0.0 }, --Left
		{ -0.50, -0.65, 0.60, 40.0, -10.0, 0.0 }, --Right
	},
	[`thrax`] = {
		{ 0.50, -0.65, 0.10, 40.0, 10.0, 0.0 }, --Left
		{ -0.50, -0.65, 0.10, 40.0, -10.0, 0.0 }, --Right
	},
	[`tigon`] = {
		{ 0.50, -0.65, 0.20, 40.0, 10.0, 0.0 }, --Left
		{ -0.50, -0.65, 0.20, 40.0, -10.0, 0.0 }, --Right
	},
	[`turismor`] = {
		{ 0.50, -0.65, 0.17, 90.0, 10.0, 0.0 }, --Left
		{ -0.50, -0.65, 0.17, 90.0, -10.0, 0.0 }, --Right
	},
	[`tyrant`] = {
		{ 0.32, 2.8, 0.25, 40.0, 30.0, 0.0 }, --Left
		{ -0.32, 2.8, 0.25, 40.0, -30.0, 0.0 }, --Right
	},
	[`vagner`] = {
		{ 0.50, -0.65, 0.10, 40.0, 10.0, 0.0 }, --Left
		{ -0.50, -0.65, 0.10, 40.0, -10.0, 0.0 }, --Right
	},
	[`voltic`] = {
		{ 0.50, -0.65, 0.10, 40.0, 10.0, 0.0 }, --Left
		{ -0.50, -0.65, 0.10, 40.0, -10.0, 0.0 }, --Right
	},
	[`voltic2`] = {
		{ 0.50, -0.65, 0.10, 40.0, 10.0, 0.0 }, --Left
		{ -0.50, -0.65, 0.10, 40.0, -10.0, 0.0 }, --Right
	},
	[`xa21`] = {
		{ 0.50, -0.55, 0.00, 40.0, 10.0, 0.0 }, --Left
		{ -0.50, -0.55, 0.00, 40.0, -10.0, 0.0 }, --Right
	},
	[`zentorno`] = {
		--Left
		{ -0.12, 0.28, 0.28, 0.0, -10.0, 0.0 },
		{ -0.12, 0.05, 0.25, 10.0, -10.0, 0.0 },
		{ -0.12, -0.18, 0.20, 20.0, -10.0, 0.0 },
		{ -0.12, -0.40, 0.15, 30.0, -10.0, 0.0 },
		{ -0.12, -0.60, 0.11, 40.0, -10.0, 0.0 },
		{ -0.12, -0.82, 0.05, 50.0, -10.0, 0.0 },
		--Right
		{ 0.12, 0.28, 0.28, 0.0, 10.0, 0.0 },
		{ 0.12, 0.05, 0.25, 10.0, 10.0, 0.0 },
		{ 0.12, -0.18, 0.20, 20.0, 10.0, 0.0 },
		{ 0.12, -0.40, 0.15, 30.0, 10.0, 0.0 },
		{ 0.12, -0.60, 0.11, 40.0, 10.0, 0.0 },
		{ 0.12, -0.82, 0.05, 50.0, 10.0, 0.0 },
	},
	[`zorrusso`] = {
		--Left
		{ -0.20, -0.2, 0.0, 40.0, -20.0, 0.0 },
		{ -0.20, 0.0, 0.0, 10.0, -20.0, 0.0 },
		--Right
		{ 0.20, -0.2, 0.0, 40.0, 20.0, 0.0 },
		{ 0.20, 0.0, 0.0, 10.0, 20.0, 0.0 },
	},
	---DLC 2699
	[`brioso3`] = {
		{ 0.50, -0.30, -0.10, 40.0, 10.0, 0.0 }, --Left
		{ -0.50, -0.30, -0.10, 40.0, -10.0, 0.0 }, --Right
	},
	[`corsita`] = {
		{ 0.30, 2.3, 0.05, 40.0, 30.0, 0.0 }, --Left
		{ -0.30, 2.3, 0.05, 40.0, -30.0, 0.0 }, --Right
	},
	[`draugur`] = {
		{ 0.50, -0.55, 0.30, 40.0, 10.0, 0.0 }, --Left
		{ -0.50, -0.55, 0.30, 40.0, -10.0, 0.0 }, --Right
	},
	[`kanjosj`] = {
		{ 0.30, -0.50, 0.15, 40.0, 30.0, 0.0 }, --Left
		{ -0.30, -0.50, 0.15, 40.0, -30.0, 0.0 }, --Right
	},
	[`lm87`] = {
		{ 0.30, 2.3, -0.15, 40.0, 30.0, 0.0 }, --Left
		{ -0.30, 2.3, -0.15, 40.0, -30.0, 0.0 }, --Right
	},
	[`postlude`] = {
		{ 0.60, -0.35, 0.20, 40.0, 10.0, 0.0 }, --Left
		{ -0.60, -0.35, 0.20, 40.0, -10.0, 0.0 }, --Right
	},
	[`sentinel4`] = {
		{ 0.50, -0.55, 0.20, 40.0, 10.0, 0.0 }, --Left
		{ -0.50, -0.55, 0.20, 40.0, -10.0, 0.0 }, --Right
	},
	[`sm722`] = {
		{ 0.50, -0.55, 0.15, 40.0, 30.0, 0.0 }, --Left
		{ -0.50, -0.55, 0.15, 40.0, -30.0, 0.0 }, --Right
	},
	[`tenf2`] = {
		{ 0.30, -0.80, 0.15, 40.0, 30.0, 0.0 }, --Left
		{ -0.30, -0.80, 0.15, 40.0, -30.0, 0.0 }, --Right
	},
	[`torero2`] = {
		{ 0.30, -0.80, 0.15, 40.0, 30.0, 0.0 }, --Left
		{ -0.30, -0.80, 0.15, 40.0, -30.0, 0.0 }, --Right
	},
	[`weevil2`] = {
		{ 0.50, -0.25, 0.20, 40.0, 40.0, 0.0 }, --Left
		{ -0.50, -0.25, 0.20, 40.0, -40.0, 0.0 }, --Right
	},
}
end