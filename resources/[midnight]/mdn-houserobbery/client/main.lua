local QBCore = exports['qb-core']:GetCoreObject()

local MissionInProgress = false
local houseInfo = nil
local isLocked = true
local houseCoords
local items = {}
local hasJob = false
local interior = {}
local noiseLvl = 0
local isInside = false
local carrying = false
local heistFinished = false
local PlayerJob
local PedBoss
local bBlip, sBlip
local c = {}
local housePoints = {}
local currentLvl = 0
local doorPoint
local caught = false
local receivedNote = false
local televisionObj



RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	local pData = QBCore.Functions.GetPlayerData()
	local rep = pData.metadata.house_robbery_rep
	for k, v in ipairs(Config.Rep) do
		if rep > Config.Rep[k].rep and rep < Config.Rep[k+1].rep then currentLvl = k end
	end
	PlayerJob = pData.job
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		local pData = QBCore.Functions.GetPlayerData()
		local rep = pData.metadata.house_robbery_rep
		for k, v in ipairs(Config.Rep) do
			if rep > Config.Rep[k].rep and rep < Config.Rep[k+1].rep then currentLvl = k end
		end
	end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo) PlayerJob = JobInfo.name end)

--------------------
-- Util Functions --
--------------------
local function EnsurePedModel(pedModel) RequestModel(pedModel) while not HasModelLoaded(pedModel) do Wait(10) end end

local function CreatePedAtCoords(pedModel, coords)
    if type(pedModel) == "string" then pedModel = GetHashKey(pedModel) end
    EnsurePedModel(pedModel)
    local ped = CreatePed(0, pedModel, coords.x, coords.y, coords.z - 0.98, coords.w, false, false)
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, true)
    SetEntityInvincible(ped, true)
    PlaceObjectOnGroundProperly(ped)
    SetBlockingOfNonTemporaryEvents(ped, true)
    return ped
end

local function GetHouse()
	local index = math.random(#Config.Houses)
	local house = Config.Houses[index]
	if not Config.Rep[currentLvl] or not Config.Rep[currentLvl].he then
		while house.model == 'HighEnd' do
			index = math.random(#Config.Houses)
			house = Config.Houses[index]
			if house.model ~= 'HighEnd' then break end
		end
	end
	return house
end

local function isVehicleWL(vehicle)
	local vehModel = GetEntityModel(vehicle)
	if vehicle then
		if not IsThisModelABike(vehModel) then
			SetVehicleDoorOpen(vehicle,GetNumberOfVehicleDoors(vehicle)-1,false,false)
			return true
		end
	else
		QBCore.Functions.Notify(Config.Lang['wrong_veh'], 'error')
	end
	return false
end

local function GetTrunkSlots(vehicle)
	local vehicleClass = GetVehicleClass(vehicle)
	local maxweight = 0
	local slots = 0
	if vehicleClass == 0 then
		maxweight = 100000
		slots = 350
	elseif vehicleClass == 1 then
		maxweight = 100000
		slots = 350
	elseif vehicleClass == 2 then
		maxweight = 700000
		slots = 1200
	elseif vehicleClass == 3 then
		maxweight = 100000
		slots = 350
	elseif vehicleClass == 4 then
		maxweight = 100000
		slots = 300
	elseif vehicleClass == 5 then
		maxweight = 90000
		slots = 550
	elseif vehicleClass == 6 then
		maxweight = 90000
		slots = 550
	elseif vehicleClass == 7 then
		maxweight = 90000
		slots = 550
	elseif vehicleClass == 8 then
		maxweight = 15000
		slots = 10000
	elseif vehicleClass == 9 then
		maxweight = 300000
		slots = 750
	elseif vehicleClass == 12 then
		maxweight = 700000
		slots = 750
	elseif vehicleClass == 13 then
		maxweight = 0
		slots = 0
	elseif vehicleClass == 14 then
		maxweight = 500000
		slots = 1000
	elseif vehicleClass == 15 then
		maxweight = 120000
		slots = 1200
	elseif vehicleClass == 16 then
		maxweight = 120000
		slots = 1200
	elseif vehicleClass == 18 then
		maxweight = 500000
		slots = 1200
	else
		maxweight = 60000
		slots = 1000
	end
	local other = {
		maxweight = maxweight,
		slots = slots,
	}
	return other
end

local function RequestWalking(set)
	RequestAnimSet(set)
	while not HasAnimSetLoaded(set) do
		Citizen.Wait(1)
	end
end

local function LoadAnim(animDict)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(10)
	end
end

local function GrabAnim()
	local playerPed = PlayerPedId()
	LoadAnim('anim@heists@ornate_bank@ig_4_grab_gold')
	local fwd, _, _, pos = GetEntityMatrix(playerPed)
	local newPos = (fwd * 0.8) + pos
	SetEntityCoords(playerPed, newPos.xy, newPos.z - 1.5)
	local rot, pos = GetEntityRotation(playerPed), GetEntityCoords(playerPed)
	SetPedComponentVariation(playerPed, 5, -1, 0, 0)
	local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), pos.x, pos.y, pos.z,  true,  true, false)
	local entrada = NetworkCreateSynchronisedScene(pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, 2, false, false, 1065353216, 0, 1.3)
	local salida = NetworkCreateSynchronisedScene(pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, 2, false, false, 1065353216, 0, 1.3)
	SetEntityCollision(bag, 0, 1)
	NetworkAddPedToSynchronisedScene(playerPed, entrada, "anim@heists@ornate_bank@ig_4_grab_gold", "enter", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, entrada, "anim@heists@ornate_bank@ig_4_grab_gold", "enter_bag", 4.0, -8.0, 1)
	NetworkAddPedToSynchronisedScene(playerPed, salida, "anim@heists@ornate_bank@ig_4_grab_gold", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, salida, "anim@heists@ornate_bank@ig_4_grab_gold", "exit_bag", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(entrada)
	Citizen.Wait(1500)
	NetworkStartSynchronisedScene(salida)
	Citizen.Wait(1500)
	DeleteEntity(bag)
	SetPedComponentVariation(playerPed, 5, 45, 0, 0)
	NetworkStopSynchronisedScene(entrada)
	NetworkStopSynchronisedScene(salida)
	FreezeEntityPosition(playerPed, false)
end

local function ResetRobbery()
	isLocked = true
	MissionInProgress = false
	hasJob = false
	isInside = false
	noiseLvl = 0
	if doorPoint then doorPoint:remove() end
	heistFinished = true
	for _, v in pairs(housePoints) do if v then v:remove() end end
	if DoesBlipExist(sBlip) then RemoveBlip(sBlip) end
	if DoesBlipExist(bBlip) then RemoveBlip(bBlip) end
	if #items > 0 then for i = 1, #items do DeleteEntity(items[i].object) end end
	if #interior > 0 then for i = 1, #interior do DeleteEntity(interior[i]) end end
	SendNUIMessage({closeProgress = true})
	DeleteEntity(televisionObj)
	caught = false
end

local function IsNight()
	local hora = GetClockHours()
	if hora > Config.Night[1] or hora < Config.Night[2] then
		return true
	end
	return false
end
-----------------
-- Heist Start --
-----------------
-- Check Requirement, Generating house, Get Blip + Waypoint
local function checkReqs()
	QBCore.Functions.TriggerCallback('av_houserobbery:CheckStartReqs', function(cantRob)
		if cantRob then QBCore.Functions.Notify(Config.Lang['cooldown'], 'error') return end
		if hasJob then QBCore.Functions.Notify(Config.Lang['wait'], 'error') return end
		ResetRobbery()
		heistFinished = false
		hasJob = true
		houseInfo = GetHouse()
		QBCore.Functions.Notify(Config.Lang['waitcall'], 'info')
		Citizen.Wait(Config.CoordsWait * 60000)
		PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Default", true)
		SetNewWaypoint(houseInfo.x,houseInfo.y)

		bBlip = AddBlipForRadius(houseInfo.x,houseInfo.y, 25.0)
        SetBlipColour(bBlip, 1)
        SetBlipAlpha(bBlip, 128)
        sBlip = AddBlipForCoord(houseInfo.x,houseInfo.y, 30)
        SetBlipSprite(sBlip, 40)
        SetBlipColour(sBlip, 1)
		SetBlipAsShortRange(sBlip, true)
		SetBlipScale(sBlip, 0.8)

		QBCore.Functions.Notify(Config.Lang['assigned'], 'info')
		Wait(500)
		c = {math.random(0,99), math.random(0,99), math.random(0,99)}
		ClosebyHouseLoop()
	end)
end

local function loadBounties()
	local pData = QBCore.Functions.GetPlayerData()
	local options = {}
	for k, v in ipairs(GlobalState.CurrentHRQuests) do
		local repAmount, add = 1, ''
		if v.item == 'malmo_laptop' then repAmount = 3 add = ' (Purple)' end
		if v.item == 'lootbag' then repAmount = 3 add = ' (House Robbery)' end
		if v.item == 'tv' then repAmount = 2 end
		options[#options+1] = {title = 'x'..v.amount.." "..QBCore.Shared.Items[v.item].label..add, disabled = GlobalState.CompHRQuests[k][pData.citizenid] == true,
		onSelect = function() TriggerServerEvent('av_houserobbery:server:HandInBounty', k, currentLvl) end, description = 'Hand in for '..repAmount..' rep'}
	end
	local rew = GlobalState.CompletionRewards
	local lab = ''
	if rew.t == 'item' then lab = QBCore.Shared.Items[rew.r].label
	elseif rew.t == 'xp' then lab = rew.r..' Additional Rep'
	elseif rew.t == 'cash' then lab = "$"..rew.r
	end
	options[#options+1] = {title = "Today's Completion Reward : ", description = lab, disabled = true}
	-- Context Menu
	lib.registerContext({ id = 'houseRobQuests', title = 'Today\'s Bounties', menu = 'houseRobBoss',
		options = options }
	) lib.showContext('houseRobQuests')
end

local function checkLvl()
	local pData = QBCore.Functions.GetPlayerData()
	local options = {}
	options[1] = {'used'}
	local rep = pData.metadata.house_robbery_rep
	for k, v in ipairs(Config.Rep) do
		if rep > Config.Rep[k].rep and rep < Config.Rep[k+1].rep then currentLvl = k end
		options[#options+1] = {title = 'Level '..k , description = v.desc, disabled = rep < v.rep}
	end
	local mprogress = Config.Rep[currentLvl+1].rep - (Config.Rep[currentLvl] and Config.Rep[currentLvl].rep or 0)
	local progress = rep - (Config.Rep[currentLvl] and Config.Rep[currentLvl].rep or 0)
	local p = (progress/mprogress)*100
	options[1] = {title = 'Current Level : '..currentLvl, description = "Progress to Level "..currentLvl+1, progress = p}
	lib.registerContext({ id = 'checkHRLvl', title = 'Current Reputation', menu = 'houseRobBoss', options = options})
	lib.showContext('checkHRLvl')
end

-- Context Menu
lib.registerContext({ id = 'houseRobBoss', title = 'The Boss',
	options = {
			{title = "Get House", description = 'Get a contract for a house robbery.', icon = 'house', onSelect = function() checkReqs() end},
			{title = "Check Bounties", description = 'Look at which items the boss is looking for today.', icon = 'clipboard-list', onSelect = function() loadBounties() end},
			{title = "Check Reputation & Rewards", description = 'Take a look at your rep and it\'s benefits.', icon = 'chart-line', onSelect = function() checkLvl() end}
		}
	}
) RegisterNetEvent('av_houserobbery:BurglaryStart', function() lib.showContext('houseRobBoss') end)

-- Spawn Boss ped when closeby
Citizen.CreateThread(function()
	local bossPoint = lib.points.new(vector4(-593.07, -1766.56, 23.18, 277.37), 60) --vector4(-591.87, -1766.64, 23.18, 273.99)
	function bossPoint:onEnter()
		if not DoesEntityExist(PedBoss) then
			PedBoss = CreatePedAtCoords('cs_chengsr', vector4(-593.07, -1766.56, 23.18, 277.37))
			while not PedBoss do Wait(1000) end
			local options = {{name = "HouseStart", type = "client", event = "av_houserobbery:BurglaryStart", icon = "fas fa-hand", label = "Talk to Jhonny"}}
			exports['qb-target']:AddEntityZone("HouseStart", PedBoss, { name= "HouseStart", heading = GetEntityHeading(PedBoss), debugPoly = false}, {options = options, distance = 1.5})
		end
	end
	function bossPoint:onExit() if PedBoss and DoesEntityExist(PedBoss) then DeleteEntity(PedBoss) end PedBoss = nil end

	local oldBoss = lib.points.new(vector4(197.4477, -1496.3062, 29.1416, 132.6553), 2)
	function oldBoss:onEnter() if receivedNote then return end
		QBCore.Functions.Notify("You find a Sticky Note...")
		receivedNote = true TriggerServerEvent('houseRob-receivenote')
	end
end)

-----------------------
-- Outside The House --
-----------------------

local function EnterHouse(police)
	if not MissionInProgress then
		if houseInfo.model == 'HighEnd' then houseCoords, heading, items, interior = HighEnd(houseInfo)
		elseif houseInfo.model == 'MidApt' then houseCoords, heading, items, interior = MidApt(houseInfo) end
		ClearAreaOfPeds(houseCoords.x,houseCoords.y,houseCoords.z, 100.0, 1)
		MissionInProgress = true
		if not police then TriggerEvent('av_houserobbery:noiseLvl') end
	else
		DoScreenFadeOut(1000)
		Citizen.Wait(1500)
		SetEntityCoords(PlayerPedId(),houseCoords.x,houseCoords.y,houseCoords.z)
		SetEntityHeading(PlayerPedId(),heading)
		Citizen.Wait(2500)
		DoScreenFadeIn(1500)
	end
	isInside = true
end

local function usingLockpick()
	local ped = PlayerPedId()
	LoadAnim('veh@break_in@0h@p_m_one@')
	TaskPlayAnim(ped, "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0, 1.0, 1.0, 16, 0.0, 0, 0, 0)
	local success = exports['lockpick']:startLockpick()
	if not success then TriggerServerEvent('av_houserobbery:server:lockpickFailed') return end
	TriggerServerEvent('av_houserobbery:server:InitCooldown')
	Citizen.Wait(1500) ClearPedTasks(ped)
	isLocked = false
	local copChance = Config.Rep[currentLvl] and Config.Rep[currentLvl].cop or 50
	if math.random(100) <= copChance then exports['ps-dispatch']:HouseRobbery() end
	EnterHouse()
end

function ClosebyHouseLoop()
	doorPoint = lib.points.new(vector3(houseInfo.x, houseInfo.y, houseInfo.z), 1.5)
	function doorPoint:onEnter()
		if not hasJob or carrying or caught then return end
		lib.showTextUI(Config.Lang['enter'])
	end
	function doorPoint:onExit()
		if not hasJob or carrying or caught then return end
		lib.hideTextUI()
	end
	function doorPoint:nearby()
		if not hasJob or caught then return end
		if IsControlJustReleased(0, 47) and not isInside then
			lib.hideTextUI()
			if not IsNight() then QBCore.Functions.Notify('You can\'t do this right now! Come back when it\'s night time..', 'error') return end
			if not isLocked then EnterHouse() return end
			if not QBCore.Functions.HasItem('advancedlockpick') then QBCore.Functions.Notify(Config.Lang['lockpick'], 'error') return end
			usingLockpick()
		end
	end
end

-----------------------
-- Inside The House --
-----------------------

local function takeAnim()
    local ped = PlayerPedId()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Wait(100)
    end
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 50, 0, false, false, false)
    Wait(2500)
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "exit", 8.0, 8.0, -1, 50, 0, false, false, false)
end

-- Inside House Thread
local function InsideHouse()
	if PlayerJob ~= Config.PoliceJobName then
		for k, v in ipairs(items) do
			local ocoords = GetEntityCoords(v.object)
			local p = lib.points.new(ocoords, v.dist)
			function p:onEnter()
				if not self.isClosest or v.robbed then return end
				SetEntityDrawOutline(v.object, true)
				SetEntityDrawOutlineColor(16, 218, 232, 255)
				lib.showTextUI(Config.Lang['search'])
			end
			function p:nearby()
				if not self.isClosest or v.robbed then return end
				if IsControlJustPressed(0,38) and not carrying then
					v.robbed = true
					lib.hideTextUI()
					if v.anim == 'safe' then
						if Config.Rep[currentLvl] and Config.Rep[currentLvl].autoSafe and math.random(100) <= 20 then
							QBCore.Functions.Progressbar('openSafe', 'Opening Safe', 5000, false, true,
							{ disableMovement = freezeplayer, disableCarMovement = freezeplayer, disableMouse = false, disableCombat = true },
							{}, {}, {}, function()
								takeAnim()
								TriggerServerEvent('av_houserobbery:item','safe')
								SetEntityDrawOutline(v.object, false)
								p:remove()
							end, function() v.robbed = false end)
						else
							local res = exports["pd-safe"]:createSafe(c)
							if res then SetEntityDrawOutline(v.object, false) TriggerServerEvent('av_houserobbery:item','safe')
							else v.robbed = false end
						end
					else
						TriggerEvent('av_houserobbery:anim', v.anim, v.deleteObj, k)
						SetEntityDrawOutline(v.object, false)
					end
				end
			end
			function p:onExit()
				if not self.isClosest or carrying then return end
				SetEntityDrawOutline(v.object, false)
				lib.hideTextUI()
			end
			housePoints[#housePoints+1] = p
		end
	end
	local p = lib.points.new(houseCoords.xyz, 1.5)
	function p:onEnter() lib.showTextUI(Config.Lang['exit']) end
	function p:onExit() lib.hideTextUI() end
	function p:nearby()
		if IsControlJustPressed(0, 47) then
			if PlayerJob ~= Config.PoliceJobName then
				if IsNight() then LeaveHouse() else LeaveHouse(true) end
			else LeaveHouse(true) end
		end
	end
	housePoints[#housePoints+1] = p
end

local function noiseNUI(progress) SendNUIMessage({runProgress = true, Length = progress}) end
RegisterNetEvent('av_houserobbery:noiseLvl', function()
	local ped = PlayerPedId()
	InsideHouse()
	while true do
		if isInside then
			noiseNUI(noiseLvl)
			if IsPedShooting(ped) then noiseLvl = noiseLvl + 20 end
			if GetEntitySpeed(ped) > 1.7 then noiseLvl = noiseLvl + 10
				if GetEntitySpeed(ped) > 2.5 then noiseLvl = noiseLvl + 15 end
				if GetEntitySpeed(ped) > 3.0 then noiseLvl = noiseLvl + 20 end
				Citizen.Wait(300)
			else
				noiseLvl = noiseLvl - 2
				if noiseLvl < 0 then noiseLvl = 0 end
				Citizen.Wait(1000)
			end
			noiseNUI(noiseLvl)
			if noiseLvl > 100 then
				caught = true
				QBCore.Functions.Notify(Config.Lang['alarm'], 'error')
				exports['ps-dispatch']:HouseRobbery()
				MissionInProgress = false
				LeaveHouse()
				Citizen.Wait(5000)
				ResetRobbery()
			end
		end
		if #(GetEntityCoords(ped) - vector3(houseCoords.xyz)) > 300 then ResetRobbery() end
		Citizen.Wait(5)
		if heistFinished then break end
	end
end)

local props = {
	['prop_micro_01'] = true,
	['prop_micro_02'] = true,
	['prop_coffee_mac_02'] = false,
	['Prop_Tapeplayer_01'] = true
}

RegisterNetEvent('av_houserobbery:anim', function(anim, deleteObj, i, ground)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	LoadAnim('mp_common_heist')
	LoadAnim("anim@heists@box_carry@")
	if anim == 'tv' then
		if not ground then
			FreezeEntityPosition(ped, true)
			TaskPlayAnim(ped, "mp_common_heist", 'use_terminal_loop', 2.0, 2.0, -1, 1, 0, true, true, true)
			local waitTime, reduction = 10000, 0
			if Config.Rep[currentLvl] and Config.Rep[currentLvl].inter then reduction = Config.Rep[currentLvl].inter*100 end
			waitTime = waitTime - reduction
			Citizen.Wait(waitTime)
			ClearPedTasksImmediately(ped)
			FreezeEntityPosition(ped, false)
		end
		televisionObj = CreateObject(GetHashKey("prop_tv_flat_01"), coords.x, coords.y, coords.z,  true,  true, false)
		AttachEntityToEntity(televisionObj, ped, GetPedBoneIndex(ped, 57005), 0.0, 0.0, 0.0, 0.0, 20.0, 0.0, true, true, false, true, 1, true)
		RequestWalking('anim_group_move_ballistic')
		SetPedMovementClipset(ped, 'anim_group_move_ballistic', 0.2)
		DeleteEntity(items[i].object)
		carrying = true
		local ui = false
		lib.showTextUI('[X] Drop Item')
		while true do
			local w = 1
			if not IsEntityPlayingAnim(ped, "anim@heists@box_carry@", "walk", 3) then TaskPlayAnim(ped, 'anim@heists@box_carry@', "walk", 8.0, -8, -1, 49, 0, 0, 0, 0) end
			local pcoords = GetEntityCoords(PlayerPedId())
			local chance = Config.Rep[currentLvl] and Config.Rep[currentLvl].tv or 2000
			local stumbleChance = math.random(chance)
			if stumbleChance == 250 and chance ~= 9999 then
				lib.hideTextUI()
				DetachEntity(televisionObj, 1, 1)
				FreezeEntityPosition(televisionObj, false)
				ActivatePhysics(televisionObj)
				ClearPedTasksImmediately(ped)
				RemoveAnimSet('anim_group_move_ballistic')
				ResetPedMovementClipset(ped)
				SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
				QBCore.Functions.Notify('You stumbled and broke the TV!', 'error')
				carrying = false
				break
			end

			local vehicle = lib.getClosestVehicle(pcoords, 5.0, false)
			if vehicle then
				local d1 = GetModelDimensions(GetEntityModel(vehicle))
				local vehicleCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d1["y"]+0.60,0.0)
				local Distance = #(vehicleCoords - pcoords)

				if Distance < 3 and not IsInside then
					w = 1
					if not ui then lib.showTextUI(Config.Lang['putinveh']) ui = true end
				elseif Distance > 3 and Distance < 5 and not InInside and ui then lib.hideTextUI() end

				if IsControlJustReleased(0, 38) then
					if isVehicleWL(vehicle) then
						lib.hideTextUI()
						Citizen.Wait(400)
						DetachEntity(televisionObj, 1, 0)
						DeleteEntity(televisionObj)
						televisionObj = nil
						ClearPedTasksImmediately(ped)
						RemoveAnimSet('anim_group_move_ballistic')
						ResetPedMovementClipset(ped)
						local trunkInfo = GetTrunkSlots(vehicle)
						trunkInfo.plate = GetVehicleNumberPlateText(vehicle)
						TriggerServerEvent('av_houserobbery:item','tv', trunkInfo)
						carrying = false
						break
					end
				end
			end

			if IsControlJustReleased(0, 73) then
				lib.hideTextUI()
				DetachEntity(televisionObj, 1, 1)
				FreezeEntityPosition(televisionObj, false)
				ActivatePhysics(televisionObj)
				ClearPedTasksImmediately(ped)
				RemoveAnimSet('anim_group_move_ballistic')
				ResetPedMovementClipset(ped)
				carrying = false
				QBCore.Functions.Notify('You stumbled and broke the TV!', 'error')
				break
			end
			Citizen.Wait(w)
		end
	elseif anim == 'telescope' then
		LoadAnim("anim@heists@narcotics@trash")
		if not ground then
			FreezeEntityPosition(ped,true)
			TaskPlayAnim(ped, "mp_common_heist", 'use_terminal_loop', 2.0, 2.0, -1, 1, 0, true, true, true)
			local waitTime, reduction = 2000, 0
			if Config.Rep[currentLvl] and Config.Rep[currentLvl].inter then reduction = Config.Rep[currentLvl].inter*20 end
			waitTime = waitTime - reduction
			Citizen.Wait(waitTime)
			ClearPedTasksImmediately(ped)
			FreezeEntityPosition(ped, false)
		end
		local telescopeObj = CreateObject(GetHashKey("prop_t_telescope_01b"), coords.x, coords.y, coords.z,  true,  true, false)
		AttachEntityToEntity(telescopeObj, ped, GetPedBoneIndex(ped, 57005), -0.06, 0.0, -0.31, 0.0, 20.0, 0.0, true, true, false, true, 1, true)
		DeleteEntity(items[i].object)
		carrying = true
		lib.showTextUI('[X] Drop Item')
		while true do
			local w = 1
			if not IsEntityPlayingAnim(ped, "anim@heists@narcotics@trash", "walk", 3) then TaskPlayAnim(ped, "anim@heists@narcotics@trash", "walk", 8.0, 8.0, -1, 50, 0, false, false, false) end
			local pcoords = GetEntityCoords(PlayerPedId())

			local vehicle = lib.getClosestVehicle(pcoords, 5.0, false)
			if vehicle then
				local d1 = GetModelDimensions(GetEntityModel(vehicle))
				local vehicleCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d1["y"]+0.60,0.0)
				local Distance = #(vehicleCoords - pcoords)

				if Distance < 3 and not IsInside then
					w = 1
					if not ui then lib.showTextUI(Config.Lang['putinveh']) ui = true end
				elseif Distance > 3 and Distance < 5 and not InInside and ui then lib.hideTextUI() end

				if IsControlJustReleased(0, 38) then
					if isVehicleWL(vehicle) then
						lib.hideTextUI()
						DetachEntity(telescopeObj, 1, 0)
						DeleteEntity(telescopeObj)
						telescopeObj = nil
						ClearPedTasksImmediately(ped)
						local trunkInfo = GetTrunkSlots(vehicle)
						trunkInfo.plate = GetVehicleNumberPlateText(vehicle)
						TriggerServerEvent('av_houserobbery:item','telescope', trunkInfo)
						carrying = false
						break
					end
				end
			end
			if IsControlJustReleased(0, 73) then
				lib.hideTextUI()
				Citizen.Wait(400)
				DetachEntity(telescopeObj, 1, 0)
				FreezeEntityPosition(telescopeObj, false)
				ActivatePhysics(telescopeObj)
				ClearPedTasksImmediately(ped)
				carrying = false
				local options = {{name = "droppedObject", type = "client", action = function() DeleteEntity(telescopeObj) TriggerEvent('av_houserobbery:anim', anim, deleteObj, i, true) end, icon = "fas fa-hand", label = "Pick Up"}}
				exports['qb-target']:AddEntityZone("droppedObject", telescopeObj, { name= "droppedObject", droppedObject = GetEntityHeading(telescopeObj), debugPoly = false}, {options = options, distance = 2.0})
				break
			end
			Citizen.Wait(w)
		end
	elseif anim == 'painting' then
		FreezeEntityPosition(ped,true)
		TaskPlayAnim(ped, "mp_common_heist", 'use_terminal_loop', 2.0, 2.0, -1, 1, 0, true, true, true)

		local waitTime, reduction = 2000, 0
		if Config.Rep[currentLvl] and Config.Rep[currentLvl].inter then reduction = Config.Rep[currentLvl].inter*20 end
		waitTime = waitTime - reduction
		Citizen.Wait(waitTime)
		ClearPedTasksImmediately(ped)
		Citizen.Wait(250) GrabAnim()
		DeleteEntity(items[i].object)
		TriggerServerEvent('av_houserobbery:item','art', currentLvl)
	elseif anim == 'search' then
		FreezeEntityPosition(ped,true)
		LoadAnim('missexile3')
		TaskPlayAnim(ped, "missexile3", 'ex03_dingy_search_case_b_michael', 2.0, 2.0, -1, 1, 0, true, true, true)

		local waitTime, reduction = 5000, 0
		if Config.Rep[currentLvl] and Config.Rep[currentLvl].inter then reduction = Config.Rep[currentLvl].inter*20 end
		waitTime = waitTime - reduction
		Citizen.Wait(waitTime)
		ClearPedTasksImmediately(ped)
		FreezeEntityPosition(ped,false)
		TriggerServerEvent('av_houserobbery:item','random', currentLvl)
	elseif anim == 'normal' then
		FreezeEntityPosition(ped,true)
		GrabAnim() TriggerServerEvent('av_houserobbery:item','random', currentLvl)
		if deleteObj then DeleteEntity(items[i].object) end
	elseif anim == 'mesa' then
		FreezeEntityPosition(ped,true)
		local waitTime, reduction = 1000, 0
		if Config.Rep[currentLvl] and Config.Rep[currentLvl].inter then reduction = Config.Rep[currentLvl].inter*10 end
		waitTime = waitTime - reduction
		GrabAnim() Citizen.Wait(waitTime)
		ClearPedTasksImmediately(ped)
		FreezeEntityPosition(ped,false)
		TriggerServerEvent('av_houserobbery:item','random', currentLvl)
		if deleteObj then DeleteEntity(items[i].object) end
	elseif anim == 'laptop' then
		FreezeEntityPosition(ped,true)
		GrabAnim() DeleteEntity(items[i].object)
		TriggerServerEvent('av_houserobbery:item','laptop')
	else
		LoadAnim("anim@heists@box_carry@")
		if not ground then
			FreezeEntityPosition(ped, true)
			TaskPlayAnim(ped, "mp_common_heist", 'use_terminal_loop', 2.0, 2.0, -1, 1, 0, true, true, true)
			local waitTime, reduction = 5000, 0
			if Config.Rep[currentLvl] and Config.Rep[currentLvl].inter then reduction = Config.Rep[currentLvl].inter*500 end
			waitTime = waitTime - reduction
			Citizen.Wait(waitTime)
			ClearPedTasksImmediately(ped)
			FreezeEntityPosition(ped,false)
		end
		local object = CreateObject(GetHashKey(anim), coords.x, coords.y, coords.z,  true,  true, false)
		local rot = 90.0
		if props[anim] then rot = 0.0 end
		AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, 28422), 0.0, -0.1, -0.08, 0.0, rot, 0.0, true, true, false, true, 1, true)
		DeleteEntity(items[i].object)
		carrying = true
		lib.showTextUI('[X] Drop Item')
		while true do
			local w = 1
			if not IsEntityPlayingAnim(ped, "anim@heists@box_carry@", "idle", 3) then TaskPlayAnim(ped, "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false) end
			local pcoords = GetEntityCoords(PlayerPedId())

			local vehicle = lib.getClosestVehicle(pcoords, 5.0, false)
			if vehicle then
				local d1 = GetModelDimensions(GetEntityModel(vehicle))
				local vehicleCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d1["y"]+0.60,0.0)
				local Distance = #(vehicleCoords - pcoords)

				if Distance < 3 and not IsInside then
					w = 1
					if not ui then lib.showTextUI(Config.Lang['putinveh']) ui = true end
				elseif Distance > 3 and Distance < 5 and not InInside and ui then lib.hideTextUI() end

				if IsControlJustReleased(0, 38) then
					if isVehicleWL(vehicle) then
						lib.hideTextUI()
						DetachEntity(object, 1, 0)
						DeleteEntity(object)
						object = nil
						ClearPedTasksImmediately(ped)
						local trunkInfo = GetTrunkSlots(vehicle)
						trunkInfo.plate = GetVehicleNumberPlateText(vehicle)
						TriggerServerEvent('av_houserobbery:item', anim, trunkInfo)
						carrying = false
						break
					end
				end
			end

			if IsControlJustReleased(0, 73) then
				lib.hideTextUI()
				Citizen.Wait(400)
				DetachEntity(object, 1, 0)
				FreezeEntityPosition(object, false)
				ActivatePhysics(object)
				ClearPedTasksImmediately(ped)
				carrying = false
				local options = {{name = "droppedObject", type = "client", action = function() DeleteEntity(object) TriggerEvent('av_houserobbery:anim', anim, deleteObj, i, true) end, icon = "fas fa-hand", label = "Pick Up"}}
				exports['qb-target']:AddEntityZone("droppedObject", object, { name= "droppedObject", droppedObject = GetEntityHeading(object), debugPoly = false}, {options = options, distance = 2.0})
				FreezeEntityPosition(object, false)
				ActivatePhysics(object)
				break
			end
			Citizen.Wait(w)
		end
	end
end)

function LeaveHouse(d)
	isInside = false
	DoScreenFadeOut(1000)
	Citizen.Wait(1500)
	SetEntityCoords(PlayerPedId(), houseInfo.x, houseInfo.y, houseInfo.z)
	TriggerEvent('qb-weathersync:client:EnableSync')
	Citizen.Wait(800)
	DoScreenFadeIn(2600)
	if d then ResetRobbery()
	else local allRobbed = true for _, v in pairs(items) do
		if not v.robbed then allRobbed = false break end end
		if allRobbed then TriggerServerEvent('av_houserobbery:server:extraRep') end
	end
	SendNUIMessage({closeProgress = true})
	Citizen.Wait(1500)
	if carrying then lib.showTextUI('[X] Drop Item') end
end

------------------
-- Police Stuff --
------------------

if Config.PoliceRaidWithCommand then
	RegisterCommand(Config.PoliceRaidCommand, function()
		if QBCore.Functions.GetPlayerData().job.name == Config.PoliceJobName then
			TriggerEvent('av_houserobbery:policeRaid')
		end
	end)
end

RegisterNetEvent('av_houserobbery:policeRaid', function()
	if QBCore.Functions.GetPlayerData().job.name == Config.PoliceJobName then
		local pcoords = GetEntityCoords(PlayerPedId())
		for _, v in pairs(Config.Houses) do if #(pcoords - vector3(v.x, v.y, v.z)) < 5 then houseCoords = vector3(v.x, v.y, v.z) houseInfo = v EnterHouse(true) InsideHouse() end end
	end
end)
