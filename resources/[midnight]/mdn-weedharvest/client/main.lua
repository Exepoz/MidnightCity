local QBCore = exports['qb-core']:GetCoreObject()
Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

IsInsideGrowLab = false
GrowLabs, LabsData, WeedPlants, DryingZones, WeedTables, Planters, WWPlanters = {}, {}, {}, {}, {}, {}, {}
local nearRack = 0
inRange = false
local nearestPlant = nil
PlayerData = {}
local isSpawned = false
local currentPlantId = 0
local currentObj = nil
Planters, Lights = {}, {}
local showingDetail = false
local r_props, b_props = {}, {}
local Padlocks = {}

local HikerLocations = {
    vector4(-754.69, 4780.39, 231.83, 7.53),
    vector4(1280.95, 5805.96, 482.58, 257.12),
    vector4(2582.63, 6166.27, 164.99, 120.65)
}

---------------------------
-- Start/Stop Behaviours --
---------------------------

local function SecondsToClock(seconds)
	seconds = tonumber(seconds)
	if seconds <= 0 then
	  return "00:00:00";
	else
	  hours = string.format("%02.f", math.floor(seconds/3600));
	  mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
	  --secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
	  local time = ""
	  if tonumber(hours) > 0 then time = time..hours.." hours and " end
	  time = time..mins.." minute"
	  if tonumber(mins) > 1 then time = time.."s" end
	  return time
	end
end

local function TogglePadLock(lab)
	local ped = PlayerPedId()
	LocalPlayer.state.inv_busy = true
	TaskTurnPedToFaceCoord(ped, Config.GrowLabs[lab].p, 1500) Wait(1500)
	FreezeEntityPosition(ped, true)
	TriggerEvent('animations:client:EmoteCommandStart', {"uncuff"})
	Wait(3000)
	ClearPedTasks(ped)
	TriggerEvent('animations:client:EmoteCancel')
	FreezeEntityPosition(ped, false)
	LocalPlayer.state.inv_busy = false
	TriggerServerEvent('malmo-weedharvest:server:brokenLock', lab)
end

local function BreakPadLock(lab, door, obj)
	if not QBCore.Functions.HasItem('anglegrinder') then QBCore.Functions.Notify('You don\'t have the tool to do this!', 'error') return end
	QBCore.Functions.TriggerCallback('malmo-weedharvest:server:gangOnline', function(canBreak)
		if not canBreak then QBCore.Functions.Notify('There isn\'t enough rival gang members around to do this...', 'error') return end
		local ped = PlayerPedId()
		local pos, entpos, dest = GetEntityCoords(ped), GetEntityCoords(door), GetOffsetFromEntityInWorldCoords(door, 0.0, 3.5, 0.0)
		local lockOffset, standOffset = nil, nil
		local dict, anim = 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle'

		TaskTurnPedToFaceCoord(GetEntityCoords(obj), 1500) Wait(1500)

		while (not HasAnimDictLoaded(dict)) do
			RequestAnimDict(dict)
			Wait(10)
		end

		local grinder = CreateObject(`tr_prop_tr_grinder_01a`, pos.x, pos.y, pos.z - 2.0, true, false, false)
		TaskPlayAnim(ped, 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle', 2.0, 2.0, -1, 1, 0, false, false, false)
		AttachEntityToEntity(grinder, ped, GetPedBoneIndex(ped, 57005), 0.22, -0.02, -0.04, 77.5, 90.5, -153.5, true, true, false, true, 1, true)

		Wait(500)

		local inProgress = true
		--TriggerServerEvent('malmo-weedharvest:server:breakingLock', lab)
		CreateThread(function()
			while inProgress do
				--TriggerServerEvent('r14-obj:server:syncsparks', NetworkGetNetworkIdFromEntity(grinder), pos)

				TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "anglegrinder", 0.5)
				TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 20, "anglegrinder", 0.3)
				TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30, "anglegrinder", 0.1)

				Wait(5000)
			end
		end)

		QBCore.Functions.Progressbar("cutlock", "Cutting lock...", 300000, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {
			animDict = animdict,
			anim = anim,
			flags = nil,
		}, {}, {}, function() -- Done
			StopParticleFxLooped(sparks, 1)
			ClearPedTasks(ped)
			Wait(300)
			DeleteEntity(grinder)
			inProgress = false
			TriggerServerEvent('malmo-weedharvest:server:brokenLock', lab)
			--TriggerServerEvent('r14-obj:server:cutdoorlock', data)
		end, function() -- Cancel
			inProgress = false
			ClearPedTasks(ped)
			Wait(300)
			DeleteEntity(grinder)
		end)
	end, lab)
end

AddEventHandler('onResourceStart', function(resource)
	if (GetCurrentResourceName() ~= resource) then return end
	Wait(1000)
	-- Fetching Weed Plants
	local p = promise.new()
	QBCore.Functions.TriggerCallback(Config.Foldername..':server:getTables', function(plantsTable) p:resolve(plantsTable) end)
	WeedPlants = Citizen.Await(p)
	for _, v in pairs(WeedPlants) do
		v.textH = vector3(v.coords[1], v.coords[2], v.coords[3]+1.5)	--health status text
		v.textP = vector3(v.coords[1], v.coords[2], v.coords[3]+1.7)	--progress status text
		v.textN = vector3(v.coords[1], v.coords[2], v.coords[3]+1.9)	--label status text
	end

	-- Fetching Labs
	local p2 = promise.new()
	QBCore.Functions.TriggerCallback(Config.Foldername..':server:getLabTables', function(LabTable) p2:resolve(LabTable) end)
	LabsData = Citizen.Await(p2)

	-- Fetching Drying Plants
	Wait(500)
	local p3 = promise.new()
	QBCore.Functions.TriggerCallback(Config.Foldername..':server:getDryZones', function(Racks) p3:resolve(Racks) end)
	DryingZones = Citizen.Await(p3)

	local p4 = promise.new()
	QBCore.Functions.TriggerCallback(Config.Foldername..':server:getPadlocks', function(PL) p4:resolve(PL) end)
	PadlockData = Citizen.Await(p4)

	for k, v in pairs(PadlockData) do
		Padlocks[k] = {}
		local point = lib.points.new(Config.GrowLabs[k].p.xyz, 35.0)
		local obj
		local door
		function point:onEnter()
			QBCore.Functions.LoadModel('prop_cs_padlock')
			obj = CreateObject('prop_cs_padlock', Config.GrowLabs[k].p.xyz, 0, 0, 0)
			FreezeEntityPosition(obj, true)
			door = GetClosestObjectOfType(Config.GrowLabs[k].p.xyz, 1.0, -1989119929, 0, 0, 0)
			FreezeEntityPosition(door, true)
			SetEntityHeading(obj, Config.GrowLabs[k].p[4])
			local options =  {{icon = "fa-solid fa-lock", label = 'Check Lock', action =
			function()
				QBCore.Functions.TriggerCallback('malmo-weedharvest:server:getOsTime2', function(time)
					local timeRemaining = LabsData[k].Padlock.time+259200 - time --3600
					local timeLeft = SecondsToClock(timeRemaining)
					local progress
					if timeRemaining > 0 then progress = math.ceil(100 - ((timeRemaining / 259200) * 100)) else progress = 0 end
					local options = {{title = 'Information', description = 'Time Left : '..timeLeft, progress = progress, onSelect = function() TriggerServerEvent('malmo-weedharvest:server:toggleWildPlantEmails') end }}
					local pData = QBCore.Functions.GetPlayerData()
					if pData.gang.name ~= LabsData[k].Padlock.gang or pData.job.name == 'police' and progress ~= 0 then options[#options+1] = {title = 'Break Locks', onSelect = function() BreakPadLock(k, door) end}
					elseif pData.gang.name == LabsData[k].Padlock.gang or progress == 0 then options[#options+1] = {title = 'Remove Lock', onSelect = function() TogglePadLock(k) end} end
					lib.registerContext({id = 'padlock', title = 'Padlock', options = options})
					lib.showContext('padlock')
				end)
			end
			}}
			exports['qb-target']:AddTargetEntity(obj, {options = options, distance = 2.0})
		end
		function point:onExit()
			if DoesEntityExist(obj) then DeleteEntity(obj) end
			obj = nil
		end
		Padlocks[k].point = point
	end

	local Hiker
	local HikerPoint = lib.points.new(HikerLocations[GlobalState['wildPlant:hiker']], 50.0)
	function HikerPoint:onEnter() if not DoesEntityExist(Hiker) then Hiker = CreatePedAtCoords('a_m_y_hiker_01', HikerLocations[GlobalState['wildPlant:hiker']]) end end
	function HikerPoint:onExit() if DoesEntityExist(Hiker) then DeleteEntity(Hiker) end Hiker = nil end

	local SeedExchange
	local SeedExchangeP = lib.points.new(vector3(204.37, -242.33, 53.96), 50.0)
	function SeedExchangeP:onEnter() if not DoesEntityExist(SeedExchange) then SeedExchange = CreatePedAtCoords('a_m_y_hippy_01', vector4(204.37, -242.33, 53.96, 306.24)) end end
	function SeedExchangeP:onExit() if DoesEntityExist(SeedExchange) then DeleteEntity(SeedExchange) end SeedExchange = nil end


	isSpawned = true
end)

function CreatePedAtCoords(pedModel, coords)
    if type(pedModel) == "string" then pedModel = GetHashKey(pedModel) end
    QBCore.Functions.LoadModel(pedModel)
    local ped = CreatePed(0, pedModel, coords.x, coords.y, coords.z - 0.98, coords.w, false, false)
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, true)
    SetEntityInvincible(ped, true)
    PlaceObjectOnGroundProperly(ped)
    SetBlockingOfNonTemporaryEvents(ped, true)
	if pedModel == GetHashKey('a_m_y_hippy_01') then
		local options =  {
			{icon = "fa-solid fa-cannabis", label = 'Exchange Old Seeds (10:1)', action = function() TriggerServerEvent('malmo-weedharvest:server:exchangeSeeds') end},
			{icon = "fa-solid fa-cannabis", label = 'Exchange Old Buds (15:1)', action = function() TriggerServerEvent('malmo-weedharvest:server:exchangeBuds') end}
		}
		exports['qb-target']:AddTargetEntity(ped, {options = options, distance = 2.0})
	else
		lib.registerContext({
			id = 'hikerTalk',
			title = 'Friendly Hiker',
			options = {
			  {title = '_Call of the Wild_',
			  description = 'I come accross various plants while I hike. Finding new species and documenting them is my favourite passtime! ' ..
			  'I often come across some of those wild cannabis plants.. Those aren\'t really my thing, but if you\'re interested, I can send you an email when I spot one...',
			  onSelect = function() TriggerServerEvent('malmo-weedharvest:server:toggleWildPlantEmails') end }
			}
		})
		local options =  {{icon = "fa-solid fa-comments", label = 'Speak with hiker', action = function() lib.showContext('hikerTalk') end}}
		exports['qb-target']:AddTargetEntity(ped, {options = options, distance = 2.0})
	end
    return ped
end

RegisterNetEvent(Config.Core..":Client:OnPlayerLoaded" , function()
	-- Fetching Weed Plants
	local p = promise.new()
	QBCore.Functions.TriggerCallback(Config.Foldername..':server:getTables', function(plantsTable) p:resolve(plantsTable) end)
	WeedPlants = Citizen.Await(p)
	for _, v in pairs(WeedPlants) do
		v.textH = vector3(v.coords[1], v.coords[2], v.coords[3]+1.5)	--health status text
		v.textP = vector3(v.coords[1], v.coords[2], v.coords[3]+1.7)	--progress status text
		v.textN = vector3(v.coords[1], v.coords[2], v.coords[3]+1.9)	--label status text
	end

	-- Fetching Labs
	local p2 = promise.new()
	QBCore.Functions.TriggerCallback(Config.Foldername..':server:getLabTables', function(LabTable) p2:resolve(LabTable) end)
	LabsData = Citizen.Await(p2)

	-- Fetching Drying Plants
	Wait(500)
	local p3 = promise.new()
	QBCore.Functions.TriggerCallback(Config.Foldername..':server:getDryZones', function(Racks) p3:resolve(Racks) end)
	DryingZones = Citizen.Await(p3)

	local p4 = promise.new()
	QBCore.Functions.TriggerCallback(Config.Foldername..':server:getPadlocks', function(PL) p4:resolve(PL) end)
	PadlockData = Citizen.Await(p4)

	for k, v in pairs(PadlockData) do
		Padlocks[k] = {}
		local point = lib.points.new(Config.GrowLabs[k].p.xyz, 35.0)
		local obj, door
		function point:onEnter()
			QBCore.Functions.LoadModel('prop_cs_padlock')
			obj = CreateObject('prop_cs_padlock', Config.GrowLabs[k].p.xyz, 0, 0, 0)
			FreezeEntityPosition(obj, true)
			door = GetClosestObjectOfType(Config.GrowLabs[k].p.xyz, 1.0, -1989119929, 0, 0, 0)
			FreezeEntityPosition(door, true)
			SetEntityHeading(obj, Config.GrowLabs[k].p[4])
			local options =  {{icon = "fa-solid fa-lock", label = 'Check Lock', action =
			function()
				QBCore.Functions.TriggerCallback('malmo-weedharvest:server:getOsTime2', function(time)
					local timeRemaining = LabsData[k].Padlock.time+259200 - time --3600
					local timeLeft = SecondsToClock(timeRemaining)
					local progress
					if timeRemaining > 0 then progress = math.ceil(100 - ((timeRemaining / 259200) * 100)) else progress = 0 end
					local options = {{title = 'Information', description = 'Time Left : '..timeLeft, progress = progress, onSelect = function() TriggerServerEvent('malmo-weedharvest:server:toggleWildPlantEmails') end }}
					local pData = QBCore.Functions.GetPlayerData()
					if pData.gang.name ~= LabsData[k].Padlock.gang or pData.job.name == 'police' and progress ~= 0 then options[#options+1] = {title = 'Break Locks', onSelect = function() BreakPadLock(k, door) end}
					elseif pData.gang.name == LabsData[k].Padlock.gang or progress == 0 then options[#options+1] = {title = 'Remove Lock', onSelect = function() TogglePadLock(k) end} end
					lib.registerContext({id = 'padlock', title = 'Padlock', options = options})
					lib.showContext('padlock')
				end)
			end
			}}
			exports['qb-target']:AddTargetEntity(obj, {options = options, distance = 2.0})
		end
		function point:onExit()
			if DoesEntityExist(obj) then DeleteEntity(obj) end
			obj = nil
		end
		Padlocks[k].point = point
	end

	local Hiker
	local HikerPoint = lib.points.new(HikerLocations[GlobalState['wildPlant:hiker']], 50.0)
	function HikerPoint:onEnter() if not DoesEntityExist(Hiker) then Hiker = CreatePedAtCoords('a_m_y_hiker_01', HikerLocations[GlobalState['wildPlant:hiker']]) end end
	function HikerPoint:onExit() if DoesEntityExist(Hiker) then DeleteEntity(Hiker) end Hiker = nil end

	local SeedExchange
	local SeedExchangeP = lib.points.new(vector3(204.37, -242.33, 53.96), 50.0)
	function SeedExchangeP:onEnter() if not DoesEntityExist(SeedExchange) then SeedExchange = CreatePedAtCoords('a_m_y_hippy_01', vector4(204.37, -242.33, 53.96, 306.24)) end end
	function SeedExchangeP:onExit() if DoesEntityExist(SeedExchange) then DeleteEntity(SeedExchange) end SeedExchange = nil end

	isSpawned = true
	Wait(2000) CheckInsideLab()
end)

RegisterNetEvent('malmo-weedharvest:client:installPadlock' , function(loc)
	local ped = PlayerPedId()
	LocalPlayer.state.inv_busy = true
	TaskTurnPedToFaceCoord(ped, Config.GrowLabs[loc].p, 1500) Wait(1500)
	FreezeEntityPosition(ped, true)
	TriggerEvent('animations:client:EmoteCommandStart', {"uncuff"})
	Wait(3000)
	ClearPedTasks(ped)
	TriggerEvent('animations:client:EmoteCancel')
	FreezeEntityPosition(ped, false)
	LocalPlayer.state.inv_busy = false
end)

RegisterNetEvent('malmo-weedharvest:client:removeSyncedPadlock' , function(loc, labs)
	if Padlocks[loc] and Padlocks[loc].point then Padlocks[loc].point:remove() end
	local door = GetClosestObjectOfType(Config.GrowLabs[loc].p.xyz, 1.0, Config.GrowLabs[loc].door, 0, 0, 0)
	if door ~= 0 then FreezeEntityPosition(door, false) end
	local lockObj = GetClosestObjectOfType(Config.GrowLabs[loc].p.xyz, 1.0, 'prop_cs_padlock', 0, 0, 0)
	if lockObj ~= 0 then DeleteEntity(lockObj) end
	Padlocks[loc] = nil
	LabsData = labs
end)

RegisterNetEvent('malmo-weedharvest:client:padlockAlert' , function(loc)
	local coords = Config.GrowLabs[loc].p
	local b = AddBlipForCoord(coords.xyz)
    local b2 = AddBlipForCoord(coords.xyz)
    SetBlipSprite(b, 469)
    SetBlipSprite(b2, 161)
    SetBlipColour(b, 2)
    SetBlipColour(b2, 1)
    SetBlipScale(b, 1.0)
    SetBlipScale(b2, 2.0)
    PulseBlip(b2)
	for _ = 1, 5 do
		PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1) Wait(200)
		PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1) Wait(200)
		PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
		Wait(30000)
	end
	RemoveBlip(b)
	RemoveBlip(b2)
end)


RegisterNetEvent('malmo-weedharvest:client:syncPadlocks' , function(PL, labs, loc)
	PadlockData = PL
	Padlocks[loc] = {}
	LabsData = labs
	local point = lib.points.new(Config.GrowLabs[loc].p.xyz, 35.0)
	local obj, door
	function point:onEnter()
		QBCore.Functions.LoadModel('prop_cs_padlock')
		obj = CreateObject('prop_cs_padlock', Config.GrowLabs[loc].p.xyz, 0, 0, 0)
		FreezeEntityPosition(obj, true)
		door = GetClosestObjectOfType(Config.GrowLabs[loc].p.xyz, 1.0, Config.GrowLabs[loc].door, 0, 0, 0)
		FreezeEntityPosition(door, true)
		SetEntityHeading(obj, Config.GrowLabs[loc].p[4])
		local options =  {{icon = "fa-solid fa-lock", label = 'Check Lock', action =
		function()
			QBCore.Functions.TriggerCallback('malmo-weedharvest:server:getOsTime2', function(time)
				local timeRemaining = LabsData[loc].Padlock.time+259200 - time --3600
				local timeLeft = SecondsToClock(timeRemaining)
				local progress
				if timeRemaining > 0 then progress = math.ceil(100 - ((timeRemaining / 259200) * 100)) else progress = 0 end
				local options = {{title = 'Information', description = 'Time Left : '..timeLeft, progress = progress, onSelect = function() TriggerServerEvent('malmo-weedharvest:server:toggleWildPlantEmails') end }}
				local pData = QBCore.Functions.GetPlayerData()
				if pData.gang.name ~= LabsData[loc].Padlock.gang or pData.job.name == 'police' and progress ~= 0 then options[#options+1] = {title = 'Break Locks', onSelect = function() BreakPadLock(loc, door) end}
			elseif pData.gang.name == LabsData[loc].Padlock.gang or progress == 0 then options[#options+1] = {title = 'Remove Lock', onSelect = function() TogglePadLock(loc) end} end
		lib.registerContext({id = 'padlock', title = 'Padlock', options = options})
				lib.showContext('padlock')
			end)
		end
		}}
		exports['qb-target']:AddTargetEntity(obj, {options = options, distance = 2.0})
	end
	function point:onExit()
		if DoesEntityExist(obj) then DeleteEntity(obj) end
		obj = nil
	end
	Padlocks[loc].point = point
end)

RegisterNetEvent(Config.Core..':Client:OnPlayerUnload' , function()
	isSpawned = false
    if WeedPlants then for _, v in pairs(WeedPlants) do DeleteEntity(v.obj) v.obj = nil end end
	if Planters then for _, v in pairs(Planters) do DeleteEntity(v.e) v.e = nil end end
	if Lights then for _, v in pairs(Lights) do DeleteEntity(v.e) v.e = nil end end
end)

AddEventHandler('onResourceStop', function(resource)
	if (GetCurrentResourceName() ~= resource) then return end
	if WeedPlants then for _, v in pairs(WeedPlants) do DeleteEntity(v.obj) v.obj = nil end end
	if Planters then for _, v in pairs(Planters) do DeleteEntity(v.e) v.e = nil end end
	if WWPlanters then for _, v in pairs(WWPlanters) do DeleteEntity(v.e) v.e = nil end end
	if Lights then for _, v in pairs(Lights) do DeleteEntity(v.e) v.e = nil end end
	if r_props[1] then for _, v_ in pairs(r_props) do DeleteEntity(v_) v_ = nil end end
	for _, v_ in pairs(b_props) do DeleteEntity(v_) v_ = nil end
	for _, v in pairs(WeedTables) do  DeleteEntity(v) v = nil end
end)

-----------
-- Utils --
-----------

function LoadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

RegisterNUICallback("FocusOff" , function(data , cb) SetNuiFocus(false , false) showingDetail = false end)

RegisterNUICallback("OptionHandler" , function(data , cb)
    if showingDetail then
        SendNUIMessage({action = "hide"})
        SetNuiFocus(false , false)
		showingDetail = false
    end
    if data.action == "harvest-option" then
		if WeedPlants[currentPlantId].progress >= 100 then HarvestWeed(currentPlantId, currentObj)
		else ShowNotification(Config.Locale["plant_not_ready"], "error") end
	elseif data.action == "insecticide-option" then TriggerEvent(Config.Foldername..":client:giveInsecticide")
	elseif data.action == "fertilize-option" then TriggerEvent(Config.Foldername..":client:giveFertilizer")
	elseif data.action == "water-option" then TriggerEvent(Config.Foldername..":client:giveWater")
    end
end)
-----------------------------
-- Lab Interior Generation --
-----------------------------
local LightLocs = {
	[1] = {ofs = {-2.2, -4.5, -2.5}, r = 270},
	[2] = {ofs = {-2.2, -6.5, -2.5}, r = 270},

	[3] = {ofs = {-5.0, -8.15, -2.5}, r = 180},
	[4] = {ofs = {-7.0, -8.15, -2.5}, r = 180},

	--[5] = {ofs = {-9.0, -8.15, -2.5}, r = 180},

	[5] = {ofs = {-11.0, -8.15, -2.5}, r = 180},
	[6] = {ofs = {-13.0, -8.15, -2.5}, r = 180},
	[7] = {ofs = {-15.5, -8.15, -2.5}, r = 180},

	[8] = {ofs = {-19.325, -7.0, -2.5}, r = 90},
	[9] = {ofs = {-19.325, -5.3, -2.5}, r = 90},
	[10] = {ofs = {-19.325, -3.6, -2.5}, r = 90},
}
-- Planters Offset
local PlanterLocs = {
	[1] = {ofs = {-5.0, -6.0, -3.0}},
	[2] = {ofs = {-8.0, -6.0, -3.0}},
	[3] = {ofs = {-11.0, -6.0, -3.0}},
	[4] = {ofs = {-14.0, -6.0, -3.0}},
	[5] = {ofs = {-17.0, -6.0, -3.0}},

	[6] = {ofs = {-5.0, -5.0, -3.0}},
	[7] = {ofs = {-8.0, -5.0, -3.0}},
	[8] = {ofs = {-11.0, -5.0, -3.0}},
	[9] = {ofs = {-14.0, -5.0, -3.0}},
	[10] = {ofs = {-17.0, -5.0, -3.0}},

	[11] = {ofs = {-5.0, -4.0, -3.0}},
	[12] = {ofs = {-8.0, -4.0, -3.0}},
	[13] = {ofs = {-11.0, -4.0, -3.0}},
	[14] = {ofs = {-14.0, -4.0, -3.0}},
	[15] = {ofs = {-17.0, -4.0, -3.0}},
}

local DryerLocs = {
	[1] = {ofs = {-9.75, -0.8, -1.6}},
	[2] = {ofs = {-9.75, 1.2, -1.6}},
	[3] = {ofs = {-9.75, 3.3, -1.6}},

	[4] = {ofs = {-12.65, -0.8, -1.8}},
	[5] = {ofs = {-12.65, 1.2, -1.8}},
	[6] = {ofs = {-12.65, 3.3, -1.8}},

	[7] = {ofs = {-15.30, -0.8, -1.8}},
	[8] = {ofs = {-15.30, 1.2, -1.8}},
	[9] = {ofs = {-15.30, 3.3, -1.8}},

	[10] = {ofs = {-16.30, -0.8, -1.8}},
	[11] = {ofs = {-16.30, 1.2, -1.8}},
	[12] = {ofs = {-16.30, 3.3, -1.8}},

	[13] = {ofs = {-17.13, -0.8, -1.8}},
	[14] = {ofs = {-17.13, 1.2, -1.8}},
	[15] = {ofs = {-17.13, 3.3, -1.8}},
}
-- On Lab Enter
local function onEnter(coords, lab)
	CurrentLab = lab
	IsInsideGrowLab = true
	local baseLamp = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.0, 1614163124, 0, 0, 0)
	local baseHeading = GetEntityHeading(baseLamp)
	for i = 1, 10 do
		local plant = GetClosestObjectOfType(coords.x, coords.y, coords.z, 25.0, 716763602, 0, 0, 0)
		SetEntityCoords(plant, coords.x, coords.y, coords.z-30.0, 0.0, 0.0, 0.0, 0)
		Wait(10)
	end
	local ofs = GetOffsetFromEntityInWorldCoords(baseLamp, -2.0, 0.0, -1.0)
	SetEntityCoords(GetClosestObjectOfType(ofs.x, ofs.y, ofs.z, 2.0, -1685625437, 0, 0, 0), ofs.x, ofs.y, ofs.z-30.0, 0.0, 0.0, 0.0, 0)
	SetEntityCoords(GetClosestObjectOfType(coords.x, coords.y, coords.z, 25.0, -1322183878, 0, 0, 0), coords.x, coords.y, coords.z-30.0, 0.0, 0.0, 0.0, 0)
	SetEntityCoords(GetClosestObjectOfType(coords.x, coords.y, coords.z, 25.0, 661161633, 0, 0, 0), coords.x, coords.y, coords.z-30.0, 0.0, 0.0, 0.0, 0)

	exports['qb-target']:RemoveZone("WeedWaterVat")
	local vatLoc = GetOffsetFromEntityInWorldCoords(baseLamp, -5.0, 5.5, -2.5)
	local Options =  {{name = "WeedWaterVat", event = Config.Foldername..':client:CheckVat', icon = "fa-solid fa-droplet", label = 'Check Water Settings'}}
	exports['qb-target']:AddBoxZone("WeedWaterVat", vatLoc, 1, 1, {name = "WeedWaterVat", heading = 0.0, debugPoly = false, minZ = vatLoc.z-1.0, maxZ = vatLoc.z+1.0}, {options = Options, distance = 1.5})

	exports['qb-target']:RemoveZone("WeedElectPanel")
	local panelLoc = GetOffsetFromEntityInWorldCoords(baseLamp, -16.85, -8.2, -2.5)
	local Options2 =  {{name = "WeedElectPanel", event = Config.Foldername..':client:CheckLightsInt', icon = "fa-solid fa-lightbulb", label = 'Check Lights Settings'}}
	exports['qb-target']:AddBoxZone("WeedElectPanel", panelLoc, 0.7, 0.65, {name = "WeedElectPanel", heading = baseHeading, debugPoly = false, minZ = panelLoc.z-0.5, maxZ = panelLoc.z+0.8}, {options = Options2, distance = 1.5})

	exports['qb-target']:RemoveZone("WeedHumidPanel")
	local humLoc = GetOffsetFromEntityInWorldCoords(baseLamp, -18.0, -8.2, -2.9)
	local Options3 =  {{name = "WeedHumidPanel", event = Config.Foldername..':client:CheckHumidity', icon = "fa-solid fa-sliders", label = 'Check Humidity'}}
	exports['qb-target']:AddBoxZone("WeedHumidPanel", humLoc, 0.7, 0.7, {name = "WeedHumidPanel", heading = baseHeading, debugPoly = false, minZ = humLoc.z-0.5, maxZ = humLoc.z+0.5}, {options = Options3, distance = 1.5})

	exports['qb-target']:RemoveZone("TrimTable")
	local trimLoc = GetOffsetFromEntityInWorldCoords(baseLamp, -14.2, 1.4, -3.0)
	local trimO =  {{name = "TrimTable", event = Config.Foldername..':client:TrimTable', icon = "fa-solid fa-scissors", label = 'Trim & Scale Weed'}}
	exports['qb-target']:AddBoxZone("TrimTable", trimLoc, 2.1, 1.1, {name = "TrimTable", heading = baseHeading, debugPoly = false, minZ = trimLoc.z-0.2, maxZ = trimLoc.z+0.2}, {options = trimO, distance = 1.5})

	local lighHash = GetHashKey('bzzz_plants_weed_light')
	for k, v in ipairs(LightLocs) do
		local loc = GetOffsetFromEntityInWorldCoords(baseLamp, v.ofs[1], v.ofs[2], v.ofs[3])
		local p = CreateObject(lighHash, loc.x, loc.y, loc.z, 0, 0, 1)
		SetEntityHeading(p, baseHeading+v.r)
		FreezeEntityPosition(p, true)
		local installed = true
		if LabsData[CurrentLab] and LabsData[CurrentLab].GrowLights then
			local digit = LabsData[CurrentLab].GrowLights[k] or false
			if not digit then installed = false SetEntityAlpha(p, 60) end
		else installed = false SetEntityAlpha(p, 60) end
		Entity(p).state.Installed = installed
		local Options4 =  {
			{event = Config.Foldername..':client:InstallLight', icon = "fa-solid fa-sun", label = 'Install Grow Light', Status = not Entity(p).state.Installed, CurrentLab = CurrentLab, Light = k, canInteract = function(e) return not Entity(e).state.Installed end},
			{event = Config.Foldername..':client:RemovingLight', icon = "fa-regular fa-sun", label = 'Remove Grow Light', Status = Entity(p).state.Installed, CurrentLab = CurrentLab, Light = k, canInteract = function(e) return Entity(e).state.Installed end}
		} exports['qb-target']:AddTargetEntity(p, {options = Options4, distance = 2.0})

		Lights[k] = {e = p}
	end

	for k, v in ipairs(PlanterLocs) do
		local loc = GetOffsetFromEntityInWorldCoords(baseLamp, v.ofs[1], v.ofs[2], v.ofs[3])
		local p = CreateObject(1389759868, loc.x, loc.y, loc.z, 0, 0, 1)
		SetEntityHeading(p, baseHeading)
		PlaceObjectOnGroundProperly(p)
		FreezeEntityPosition(p, true)
		--local p1 = GetClosestObjectOfType(loc.x+0.7, loc.y, loc.z, 0.2, modelHash, isMission, p6, p7)
		local pLocs = {}
		if WeedPlants then
			for k_, v_ in pairs(WeedPlants) do
				if v_.planterID == k then pLocs[v_.planterSpot] = true end
			end
		end
		local pOptions = {}
		for k_, v_ in pairs(Config.Seed) do
			pOptions[#pOptions+1] = {
				event = Config.Foldername..":client:placePlanterPlant",
				seed = k_,
				planterID = k,
				slabel = v_.label,
				icon = "fas fa-cannabis",
				item = k_,
				label = "Plant "..v_.label,
			}
		end
		exports['qb-target']:AddTargetEntity(p, {options = pOptions, distance = 2.5})
		Planters[k] = {e = p, pLocs = pLocs}
	end

	for k, v in ipairs(DryerLocs) do
		exports['qb-target']:RemoveZone("DryWeedPlant_"..CurrentLab.."_"..k)
		local pLoc = GetOffsetFromEntityInWorldCoords(baseLamp, v.ofs[1], v.ofs[2], v.ofs[3])
		local dOptions =  {
			{event = Config.Foldername..':client:CheckPlant', icon = "fa-solid fa-hand", label = 'Check Plant Hook', CurrentLab = CurrentLab, DryHook = tostring(k), hookCoords = pLoc},
		}
		exports['qb-target']:AddBoxZone("DryWeedPlant_"..CurrentLab.."_"..k, pLoc, 0.5, 0.5, {name = "DryWeedPlant_"..CurrentLab.."_"..k, heading = baseHeading, debugPoly = false, minZ = pLoc.z-0.5, maxZ = pLoc.z+0.6}, {options = dOptions, distance = 2.0})
	end
end
-- On Lab Exit
local function onExit()
	IsInsideGrowLab = false
	if Planters then for _, v in pairs(Planters) do DeleteEntity(v.e) v.e = nil end end
	if Lights then for _, v in pairs(Lights) do DeleteEntity(v.e) v.e = nil end end
	Planters = {}
	Lights = {}
	exports['qb-target']:RemoveZone("WeedWaterVat")
	exports['qb-target']:RemoveZone("WeedHumidPanel")
	exports['qb-target']:RemoveZone("WeedElectPanel")
end

function CheckInsideLab()
	local pcoords = GetEntityCoords(PlayerPedId())
	for k, v in pairs(Config.GrowLabs) do
		if GrowLabs[k]:isPointInside(pcoords) then SetEntityCoords(PlayerPedId(), v.entrance, 1, 0 ,0 ,0) onEnter(v.loc.coords, k) break end
	end
end

-----------------------
-- Weed Drying Racks --
-----------------------
local WhiteWidowP = lib.points.new(vector3(179.85, -250.83, 53.31), 30.0)
function WhiteWidowP:onEnter()
	for k, v in pairs(Config.WhiteWidow.RemoveProps) do
		local plant = GetClosestObjectOfType(v.coords.x, v.coords.y, v.coords.z, 25.0, v.hash, 0, 0, 0)
		SetEntityCoords(plant, v.coords.x, v.coords.y, v.coords.z-30.0, 0.0, 0.0, 0.0, 0)
		Wait(10)
	end
	for k, v in pairs(Config.WhiteWidow.Planters) do
		QBCore.Functions.LoadModel(1389759868)
		local p = GetClosestObjectOfType(v.coords.x,  v.coords.y,  v.coords.z, 0.2, 1389759868, 0, 0, 0)
		if not p or p == 0 then p = CreateObject(1389759868,  v.coords.x,  v.coords.y,  v.coords.z, 0, 0, 1) end
		--local p = CreateObject(1389759868,  v.coords.x,  v.coords.y,  v.coords.z, 0, 0, 1)
		SetEntityHeading(p, v.coords[4])
		PlaceObjectOnGroundProperly(p)
		FreezeEntityPosition(p, true)

		local pLocs = {}
		if WeedPlants then
			for k_, v_ in pairs(WeedPlants) do
				if v_.ww_planterID == k then pLocs[v_.planterSpot] = true end
			end
		end
		local pOptions = {}
		for k_, v_ in pairs(Config.Seed) do
			pOptions[#pOptions+1] = {
				event = Config.Foldername..":client:placePlanterPlant",
				seed = k_,
				ww_planterID = k,
				slabel = v_.label,
				icon = "fas fa-cannabis",
				item = k_,
				label = "Plant "..v_.label,
			}
		end
		exports['qb-target']:AddTargetEntity(p, {options = pOptions, distance = 2.5})
		WWPlanters[k] = {e = p, pLocs = pLocs}
	end
end

Citizen.CreateThread(function()
	Wait(10000)
	while not isSpawned do Wait(0) end
	for k, v in ipairs(Config.Tables) do
		local obj = CreateObject('bkr_prop_weed_table_01a', v.coords.x, v.coords.y, v.coords.z, false, false, true)
		--SetEntityLodDist(obj, 50)
		SetEntityHeading(obj, v.coords[4])
		PlaceObjectOnGroundProperly(obj)
		FreezeEntityPosition(obj, true)
		local options =  {{event = Config.Foldername..':client:TrimTable', icon = "fa-solid fa-scissors", label = 'Trim & Scale Weed'}}
		exports['qb-target']:AddTargetEntity(obj, {options = options, distance = 2.5})
		WeedTables[#WeedTables+1] = obj
	end

	for k, v in ipairs(Config.DryingZones) do
		local point = lib.points.new(v[1].coords.xyz, 50.0)
		function point:onEnter()
			QBCore.Functions.LoadModel('v_club_rack')
			nearRack = k
			for i = 1, 3 do
				local obj = CreateObject('v_club_rack', v[i].coords.x, v[i].coords.y, v[i].coords.z, false, false, true)
				SetEntityLodDist(obj, 50)
				SetEntityHeading(obj, v[i].coords[4])
				PlaceObjectOnGroundProperly(obj)
				FreezeEntityPosition(obj, true)
				r_props[i] = obj
				for i_ = 1, 3 do
					local offset
					if i_ == 1 then offset = 0 elseif i_ == 2 then offset = 0.6 elseif i_ == 3 then offset = -0.6 end
					local pOffset = GetOffsetFromEntityInWorldCoords(obj, offset, 0.0, 0.48)
					local obj_ = CreateObject(GetHashKey("bkr_prop_weed_drying_02a"), pOffset.x, pOffset.y, pOffset.z-1.075, false, true, true)
					SetEntityHeading(obj_, v[i].coords[4]+90.0)
					SetEntityAlpha(obj_, DryingZones[k][i][i_].state == 'hooked' and 255 or 120)
					FreezeEntityPosition(obj_, true)
					b_props[i..i_] = obj_
					local options =  {
						{event = Config.Foldername..':client:InspectBud', icon = "fa-solid fa-cannabis", label = 'Inspect Drying Plant', zone = k, rack = i, pos = i_},
					}
					exports['qb-target']:AddTargetEntity(obj_, {options = options, distance = 2.5})
				end
			end
		end
		function point:onExit()
			nearRack = 0
			for _, v_ in pairs(r_props) do DeleteEntity(v_) v_ = nil end
			for _, v_ in pairs(b_props) do DeleteEntity(v_) v_ = nil end
		end
	end
end)

-- Hooking Animation
local function HookThePlant_rack(data, plant)
	local ped = PlayerPedId()
	QBCore.Functions.Progressbar("dryplants", "Attaching Weed Plant...", 4000, false, true,
	{disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
	{animDict = "anim@gangops@facility@servers@", anim = "hotwire", flags = 1},
	{}, {}, function()
		ClearPedTasks(ped)
		TriggerServerEvent(Config.Foldername..':server:PlaceDryPlant_rack', data.zone, data.rack, data.pos, 'hooked', plant)
	end, function() ClearPedTasks(ped) end)
end

-- Strain Selection when hooking
local function HookPlant_rack(data)
	local options = {}
	for k, v in pairs(Config.Seed) do
		if QBCore.Functions.HasItem(v.finalItem) then
			options[#options + 1] = {title = 'Hook '..v.label, onSelect = function() HookThePlant_rack(data, k) end}
		end
	end
	if #options < 1 then QBCore.Functions.Notify('You don\'t have any fresh plants to hook!', 'error') return end
	lib.registerContext({ id = 'DryPlantToHook', title = 'Dry Hook', canClose = true, options = options })
	lib.showContext('DryPlantToHook')
end

-- Garbbing Final product animation
local function TakeDryPlant_rack(data)
	local ped = PlayerPedId()
	QBCore.Functions.Progressbar("dryplants", "Grabbing Dry Weed Plant...", 4000, false, true,
	{disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
	{animDict = "anim@gangops@facility@servers@", anim = "hotwire", flags = 1},
	{}, {}, function()
		ClearPedTasks(ped)
		TriggerServerEvent(Config.Foldername..':server:TakeDryPlant_rack', data.zone, data.rack, data.pos)
	end, function() ClearPedTasks(ped) end)
end

-- Garbbing Final product animation
local function DestroyPlant_rack(data)
	local ped = PlayerPedId()
	QBCore.Functions.Progressbar("dryplants", "Destroying Weed Plant...", 6000, false, true,
	{disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
	{animDict = "anim@gangops@facility@servers@", anim = "hotwire", flags = 1},
	{}, {}, function()
		ClearPedTasks(ped)
		TriggerServerEvent(Config.Foldername..':server:DestroyPlant_rack', data.zone, data.rack, data.pos)
	end, function() ClearPedTasks(ped) end)
end

-- Drying Zones Menu
RegisterNetEvent(Config.Foldername..':client:InspectBud', function(data)
	local ped = PlayerPedId()
	local progress = 0
	local currDryPlant = DryingZones[data.zone][data.rack][data.pos]
	local pData = QBCore.Functions.GetPlayerData()
	QBCore.Functions.TriggerCallback(Config.Foldername..':server:getOsTime2', function(time)
		local timeRemaining = (currDryPlant.time and currDryPlant.time+21600 - time) or 0 --21600
		if timeRemaining > 0 then progress = math.ceil(100 - ((timeRemaining / 21600) * 100)) else progress = 100 end
		if currDryPlant.state == 'empty' or not currDryPlant.state then progress = 0 end
		local options = {}
		local strainStr = currDryPlant.strain and Config.Seed[currDryPlant.strain].label or "None"
		local knowInfo = pData.citizenid == currDryPlant.owner or data.zone == 9
		local progressStr = (knowInfo and progress.."%") or "Unknown"
		local purityStr = (knowInfo and currDryPlant.purity and currDryPlant.purity.."%") or "Unknown"
		local pbar = (knowInfo and progress) or nil
		options[#options + 1] = {title = 'Current Hooked Plant', description = 'Strain : '..strainStr.." | Purity : "..purityStr..'\nProgress : '.. progressStr, progress = pbar, disabled = true}
		if progress == 0 then options[#options + 1] = {title = 'Hook Plant', onSelect = function() HookPlant_rack(data) end}
		elseif progress >= 100 then options[#options + 1] = {title = 'Take Dry Plant', onSelect = function() TakeDryPlant_rack(data) end} end
		if pData.job.name == 'police' and strainStr ~= 'None' then options[#options + 1] = {title = 'Destroy Plant', description = 'Police Action', onSelect = function() DestroyPlant_rack(data) end} end
		lib.registerContext({id = 'dryHook', title = 'Dry Hook', canClose = true, options = options })
		lib.showContext('dryHook')
	end)
end)

RegisterNetEvent(Config.Foldername..':client:syncPlantRack', function(bool, zone, rack, pos)
	DryingZones[zone][rack][pos].occupied = bool
	if nearRack ~= zone then return end
	local alpha = bool and 255 or 120
	SetEntityAlpha(b_props[rack..pos], alpha)
end)
-------------------------
-- Weed Trim & Scaling --
-------------------------
local CurrentSelectedPlant = 0

-- Confirmation & Animation
local function TrimWeed(amount, slot, small)
	local pData = QBCore.Functions.GetPlayerData()
	local data = ""
	local am = 0
	if amount == 28.0 then am = small and 4 or 8 if not QBCore.Functions.HasItem('empty_weed_jar', am) then QBCore.Functions.Notify('You don\'t have enough jars with you!') return end
		data = "8 jars of 28gs."
	elseif amount == 7.0 then am = small and 16 or 32 if not QBCore.Functions.HasItem('emptybaggy', am) then QBCore.Functions.Notify('You don\'t have enough baggies with you!') return end
		data = "32 quarter-ounce baggies."
	elseif amount == 3.5 then am = small and 32 or 64 if not QBCore.Functions.HasItem('emptybaggy', am) then QBCore.Functions.Notify('You don\'t have enough baggies with you!') return end
		data = "64 1/8oz baggies."
	elseif amount == 112.0 then
		data = "2 1/4 pound bricks."
	elseif amount == 224.0 then
		data = "1 1/2 pound brick."
	end
	local sString = small and '\n\n(Wild Plant only yield half the amount)' or ''
	while not CurrentSelectedPlant do Wait(0) end
	local plant = pData.items[slot]
	local alert = lib.alertDialog({
		header = 'Trim & Scale Table\n\n**Dry '..Config.Seed[plant.info.strain].label.."**\n\n"..plant.info.purity.."% Purity",
		content = 'Trim & Scale Plant Into '..data..sString,
		centered = true,
		cancel = true
	}) if alert ~= "confirm" then return end
	LocalPlayer.state:set('inv_busy', true, true)
	local ped = PlayerPedId()
	local x, y, z = table.unpack(GetEntityCoords(ped))
	ExecuteCommand('e mechanic') Wait(3500)
	local weedBudObj = CreateObject(GetHashKey('bkr_prop_weed_bud_02a'), x, y, z ,  true,  true, true)
	SetEntityCollision(weedBudObj, false, true)
	AttachEntityToEntity(weedBudObj, ped, GetPedBoneIndex(ped, 4153), 0, -0.05, -0.1, 0, 0, 0, false, false, false, false, 2, true)--right bone:28422
	Wait(200)
	local cissorsObj = CreateObject(GetHashKey('prop_cs_scissors'), x, y, z ,  true,  true, true)
	SetEntityCollision(cissorsObj, false, true)
	AttachEntityToEntity(cissorsObj, ped, GetPedBoneIndex(ped, 64016), 0, -0.04, 0.02, 0, 0, 0, false, false, false, false, 2, true)--right bone:28422
	LoadAnimDict('mp_arresting')
	ClearPedTasks(ped)
	Wait(200)
	TaskPlayAnim(ped, 'mp_arresting', 'a_uncuff', 8.0, 8.0, -1, 17, 1.0, false, false, false)
	Wait(23400) DeleteObject(weedBudObj) Wait(700)
	LoadAnimDict('pickup_object') TaskPlayAnim(ped,'pickup_object', 'putdown_low', 5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
	Wait(1000) DeleteObject(cissorsObj) Wait(500)
	ClearPedTasks(ped)
	LocalPlayer.state:set('inv_busy', false, true)
	FreezeEntityPosition(PlayerPedId(), false)
	TriggerServerEvent(Config.Foldername..':server:TrimWeed', amount, slot)
end

-- Size Selection
local function TrimSelectedStrain(selected, small)
	local sString = small and '\n(Wild Plant only yield half the amount)' or ''
	local options = {
		{title = "Scale Into : 3.5g", description = "Trim & Pack into 64 baggies x 3.5gs"..sString, onSelect = function() TrimWeed(3.5, selected, small) end},
		{title = "Scale Into : 7g", description = "Trim & Pack into 32 baggies x 7gs"..sString, onSelect = function() TrimWeed(7.0, selected, small) end},
		{title = "Scale Into : Ounce", description = "Trim & Pack into 8 jars x 28gs"..sString, onSelect = function() TrimWeed(28.0, selected, small) end},
	}
	if IsInsideGrowLab and not small then
		options[#options+1] = {title = "Scale Into : 1/4 Pound", description = "Trim & Pack into 2 small quarter pound bricks.", onSelect = function() TrimWeed(112.0, selected, small) end}
		options[#options+1] = {title = "Scale Into : 1/2 Pound", description = "Trim & Pack into 1 half pound brick", onSelect = function() TrimWeed(224.0, selected, small) end}
	end
	lib.registerContext({ id = 'scaleSelection', title = 'Select Scaling Size', canClose = true, options = options}) lib.showContext('scaleSelection')
end

-- Trim Table Main Menu
RegisterNetEvent(Config.Foldername..':client:TrimTable', function(data)
	local ped = PlayerPedId()
	local pData = QBCore.Functions.GetPlayerData()
	local options = {}
	for k, v in pairs(pData.items) do
		if v.name == "malmo_dry_weed" then
			options[#options + 1] = {title = "Dry "..Config.Seed[v.info.strain].label.." plant", description = v.info.purity.."% Purity", onSelect = function() TrimSelectedStrain(v.slot, v.info.small) end}
		end
	end
	if #options < 1 then QBCore.Functions.Notify('You don\'t have any dry plants on you!', 'error') return end
	lib.registerContext({ id = 'WeedTrimTable', title = 'Select Plant to Trim', canClose = true, options = options })
	lib.showContext('WeedTrimTable')
end)

-----------------------
-- Weed Drying (Lab) --
-----------------------

-- Hooking Animation
local function HookThePlant(data, plant)
	local ped = PlayerPedId()
	QBCore.Functions.Progressbar("dryplants", "Attaching Weed Plant...", 4000, false, true,
	{disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
	{animDict = "amb@prop_human_movie_bulb@idle_a", anim = "idle_b", flags = 1},
	{}, {}, function()
		ClearPedTasks(ped)
		TriggerServerEvent(Config.Foldername..':server:PlaceDryPlant', data.CurrentLab, data.DryHook, 'hooked', plant)
	end, function() ClearPedTasks(ped) end)
end

-- Strain Selection when hooking
local function HookPlant(data)
	local options = {}
	for k, v in pairs(Config.Seed) do
		if QBCore.Functions.HasItem(v.finalItem) then
			options[#options + 1] = {title = 'Hook '..v.label, onSelect = function() HookThePlant(data, k) end}
		end
	end
	if #options < 1 then QBCore.Functions.Notify('You don\'t have any fresh plants to hook!', 'error') return end
	lib.registerContext({ id = 'DryPlantToHook', title = 'Dry Hook', canClose = true, options = options })
	lib.showContext('DryPlantToHook')
end

-- Garbbing Final product animation
local function TakeDryPlant(data)
	local ped = PlayerPedId()
	QBCore.Functions.Progressbar("dryplants", "Grabbing Dry Weed Plant...", 4000, false, true,
	{disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
	{animDict = "amb@prop_human_movie_bulb@idle_a", anim = "idle_b", flags = 1},
	{}, {}, function()
		ClearPedTasks(ped)
		TriggerServerEvent(Config.Foldername..':server:TakeDryPlant', data.CurrentLab, data.DryHook, 'empty')
	end, function() ClearPedTasks(ped) end)
end

-- Main Lab Drying Hook Menu
RegisterNetEvent(Config.Foldername..':client:CheckPlant', function(data)
	local ped = PlayerPedId()
	local progress = 0
	local currHook = {}
	local pLoc = data.hookCoords
	local pData = QBCore.Functions.GetPlayerData()
	TaskLookAtCoord(ped, pLoc.x, pLoc.y, pLoc.z, -1, 0, 0)

	QBCore.Functions.TriggerCallback(Config.Foldername..':server:getOsTime2', function(time)
		if data.WW then data.CurrentLab = 999 end
		if not LabsData[data.CurrentLab] or not LabsData[data.CurrentLab].DryHooks or not LabsData[data.CurrentLab].DryHooks[data.DryHook] then
			LabsData[data.CurrentLab].DryHooks[data.DryHook] = {}
			progress = 0
		end
		if LabsData[data.CurrentLab].DryHooks then currHook = LabsData[data.CurrentLab].DryHooks[data.DryHook] end
		local timeRemaining = (currHook.time and currHook.time+10800 - time) or 0 --10800
		if timeRemaining > 0 then progress = math.ceil(100 - ((timeRemaining / 10800) * 100)) else progress = 100 end
		if currHook.state == 'empty' or not currHook.state then progress = 0 end
		local options = {}
		local strainStr = currHook.strain and Config.Seed[currHook.strain].label or "None"
		local progressStr = (pData.gang.name == currHook.gang and progress.."%") or "Unknown"
		local purityStr = (pData.gang.name == currHook.gang and currHook.purity and currHook.purity.."%") or "Unknown"
		options[#options + 1] = {title = 'Current Hooked Plant', description = 'Strain : '..strainStr.." | Purity : "..purityStr..'\nProgress : '.. progressStr, progress = (pData.gang.name == currHook.gang and progress) or nil, disabled = true}
		if progress == 0 then options[#options + 1] = {title = 'Hook Plant', onSelect = function() HookPlant(data) end}
		elseif progress >= 100 then options[#options + 1] = {title = 'Take Dry Plant', onSelect = function() TakeDryPlant(data) end} end
		lib.registerContext({ id = 'dryHook_'..data.CurrentLab..data.DryHook, title = 'Dry Hook', canClose = true, options = options })
		lib.showContext('dryHook_'..data.CurrentLab..data.DryHook)
	end)
end)
----------------------
-- Outside Specific --
----------------------
RegisterNetEvent(Config.Foldername..':client:placeWeedPlant', function(seed, label) if IsInsideGrowLab then return end checkPlantingSurface(seed, label) end)

------------------
-- Lab Specific --
------------------
RegisterNetEvent(Config.Foldername..':client:placePlanterPlant', function(args)
	local pData = QBCore.Functions.GetPlayerData()
	local goodSeed, wwSeed = false, false
	QBCore.Functions.TriggerCallback('malmo-weedharvest:server:getOsTime2', function(time)
		for _, v in pairs(pData.items) do
			if v.name == args.seed and v.info.decay and v.creation then
				if v.info.fromWW then wwSeed = true end
				local timeDiff = (v.creation + v.info.decay) - time
				if timeDiff <= 0 then QBCore.Functions.Notify('The seed turned bad already!', 'error') return
				else goodSeed = true end
			end
		end
		if not goodSeed then return end
		if args.ww_planterID then
			if WWPlanters[args.ww_planterID].pLocs[1] and WWPlanters[args.ww_planterID].pLocs[2] then QBCore.Functions.Notify('The planter is full!', 'error') return end
			if not WWPlanters[args.ww_planterID].pLocs[1] then
				checkPlantingSurface(args.seed, args.slabel, false, 1, GetOffsetFromEntityInWorldCoords(args.entity, 0.6, 0.0, 0), args.ww_planterID, true)
			elseif not WWPlanters[args.ww_planterID].pLocs[2] then
				checkPlantingSurface(args.seed, args.slabel, false, 2, GetOffsetFromEntityInWorldCoords(args.entity, -0.6, 0.0, 0), args.ww_planterID, true)
			end
		else
			if wwSeed then QBCore.Functions.Notify('You should store your White Widow seeds before trying to plant illegal plants...') return end
			if Planters[args.planterID].pLocs[1] and Planters[args.planterID].pLocs[2] then QBCore.Functions.Notify('The planter is full!', 'error') return end
			if not Planters[args.planterID].pLocs[1] then
				checkPlantingSurface(args.seed, args.slabel, true, 1, GetOffsetFromEntityInWorldCoords(args.entity, 0.6, 0.0, 0), args.planterID)
			elseif not Planters[args.planterID].pLocs[2] then
				checkPlantingSurface(args.seed, args.slabel, true, 2, GetOffsetFromEntityInWorldCoords(args.entity, -0.6, 0.0, 0), args.planterID)
			end if not args.ww_planterID then return end
		end
	end)
end)

------------------
-- Plants Stuff --
------------------

-- Targeting PLant & Operning Menu
RegisterNetEvent(Config.Foldername..":client:checkClosestPlant", function(data)
	local index = 0
	if WeedPlants then
		for k, v in pairs(WeedPlants) do if v.obj == data.entity then index = k end end
		if index == 0 then ShowNotification(Config.Locale["invalid_plant"], "error") return
		else TriggerEvent(Config.Foldername..":client:OpenOptions", index) end
	end
end)

-- NUI Menu Opening
RegisterNetEvent(Config.Foldername..":client:OpenOptions", function(id)
	currentPlantId = id
	nearestPlant = id
	currentObj = WeedPlants[id].obj
	if not showingDetail then
        showingDetail = true
        SendNUIMessage({
            action = "show",
            Label = WeedPlants[id].label,
            Progress = WeedPlants[id].progress,
            Health = WeedPlants[id].health,
			State = WeedPlants[id].state,
			Water = WeedPlants[id].water,
            ShowOptions = true,
			FertilizeOptions = true,
        })
    end
	SetNuiFocus(true, true)
end)

-- Burn / Destroy Targetted plant
RegisterNetEvent(Config.Foldername..":client:burnClosestPlant", function(data)
	local index = 0
	if WeedPlants then
		for k, v in pairs(WeedPlants) do if v.obj == data.entity then index = k end end
		if index == 0 then ShowNotification(Config.Locale["invalid_plant"], "error") return
		else burnWeedPlants(index, WeedPlants[index].coords) end
	end
end)

function HarvestWeed(id, obj)
	local loc = WeedPlants[id].coords
	local pData = QBCore.Functions.GetPlayerData()
	if pData.metadata['farmingrep'] >= Config.Seed[WeedPlants[id].seed].rep then ProgressBar("harvest", id, loc, obj)
	else ShowNotification(Config.Locale["need_rep_harvest"], "error") end
end

------------------
-- Plants Stuff --
------------------

-- Plant Update Thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if isSpawned and WeedPlants then
			inRange = false
			local ped = PlayerPedId()
			local pos = GetEntityCoords(ped)
			for k,v in pairs(WeedPlants) do
				local dist = #(pos - v.coords)
				if dist <= 150.0 then
					if v.obj == nil then
						local zOffset = 1.0
						for a, b in pairs(Config.Stages) do
							if v.progress >= b.min and v.progress <= b.max then
								local obj = CreateObject(GetHashKey(Config.Seed[v.seed].stages[a]), vector3(v.coords.x, v.coords.y, v.coords.z + b.offset), false)
								FreezeEntityPosition(obj, true)
								zOffset = 0.5
								v.obj = obj
							end
						end
						if v.insects and not v.insectsPfx then
							local dict = 'core'
							local pfx = 'ent_amb_moths_swarm'
							RequestNamedPtfxAsset(dict)
							while not HasNamedPtfxAssetLoaded(dict) do Citizen.Wait(0) end
							UseParticleFxAssetNextCall(dict)
							local effect = StartParticleFxLoopedAtCoord("ent_amb_fly_swarm", v.coords.x, v.coords.y, v.coords.z + zOffset, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							v.insectsPfx = effect
						end
					end
				else
					if v.obj then
						DeleteEntity(v.obj)
						StopParticleFxLooped(v.insectsPfx, 0)
						v.insectsPfx = nil
						v.obj = nil
					end
				end

				if Config.CanBurnPlants then
					if v.obj and IsEntityOnFire(v.obj) and v.IsBurning==nil then
						v.IsBurning = true
						burnWeedPlants(k, v.coords)
					end
				end
			end
		end

		if not inRange then
			Citizen.Wait(500)
		end
	end
end)

-- Watering Plant
RegisterNetEvent(Config.Foldername..':client:giveWater', function()
	local p = promise.new()
	QBCore.Functions.TriggerCallback(Config.Foldername..":server:hasWateringCan", function(result) p:resolve(result) end)
	local result = Citizen.Await(p)
	if not result then ShowNotification(Config.Locale["no_water"], "error") return end

	local pos = GetEntityCoords(PlayerPedId())
	if currentPlantId and #(pos - WeedPlants[currentPlantId].coords)<=2.5 then
		local plantID = currentPlantId
		local plantLoc = WeedPlants[currentPlantId].coords
		local ped = PlayerPedId()

		local input = lib.inputDialog('Amount of Water to Add', {
			{type = 'slider', label = 'Amount.', required = true, min = 1, max = 50, default = 25},
		})
		if not input or not input[1] then return end
		ProgressBar("giving-water", plantID, plantLoc, input[1])
	else
		ShowNotification(Config.Locale["no_plant_nearby"], "error")
	end
end)

-- Spraying Plant w Insecticide
RegisterNetEvent(Config.Foldername..':client:giveInsecticide', function()
	local p = promise.new()
	QBCore.Functions.TriggerCallback(Config.Foldername..":server:hasItem", function(result) p:resolve(result) end, Config.Items["insecticide"])
	local result = Citizen.Await(p)
	if not result then ShowNotification(Config.Locale["no_insecticide"], "error") return end

	local pos = GetEntityCoords(PlayerPedId())
	if currentPlantId and #(pos - WeedPlants[currentPlantId].coords)<=2.5 then
		local plantID = currentPlantId
		local plantLoc = WeedPlants[currentPlantId].coords
		local ped = PlayerPedId()
		ProgressBar("giving-insecticide", plantID, plantLoc, nil)
	else
		ShowNotification(Config.Locale["no_plant_nearby"], "error")
	end
end)

-- Fertilizing Plant
RegisterNetEvent(Config.Foldername..':client:giveFertilizer', function()
	local p = promise.new()
	QBCore.Functions.TriggerCallback(Config.Foldername..":server:hasItem", function(result) p:resolve(result) end, Config.Items["fertilizer"])
	local result = Citizen.Await(p)
	if not result then ShowNotification(Config.Locale["no_fertilizer"], "error") return end

	local pos = GetEntityCoords(PlayerPedId())
	if currentPlantId and #(pos - WeedPlants[currentPlantId].coords)<=2.5 then
		local plantID = currentPlantId
		local plantLoc = WeedPlants[currentPlantId].coords
		local ped = PlayerPedId()
		ProgressBar("giving-fertilizer", plantID, plantLoc, nil)
	else
		ShowNotification(Config.Locale["no_plant_nearby"], "error")
	end
end)

------------------
-- Data Syncing --
------------------

-- Updating Lab Data
RegisterNetEvent(Config.Foldername..':client:updateLabsData', function(data) LabsData = data end)
RegisterNetEvent(Config.Foldername..':client:updateDryZones', function(data) DryingZones = data end)

-- Syncing Planters States
RegisterNetEvent(Config.Foldername..':client:syncPlanterPos', function(planterId, planterSpot, WW)
	if not WW then
		if not Planters[planterId] then return end
		Planters[planterId].pLocs[planterSpot] = true
	else
		if not WWPlanters[planterId] then return end
		WWPlanters[planterId].pLocs[planterSpot] = true
	end
end)

-- Updating PLant Health
RegisterNetEvent(Config.Foldername..':client:updatePlantHealth', function(coords, data) for _,v in pairs(WeedPlants) do if v.coords == coords then v.health = data.health end end end)

-- Updating Plant Water
RegisterNetEvent(Config.Foldername..':client:updatePlantWater', function(coords, data) for _,v in pairs(WeedPlants) do if v.coords == coords then v.water = data.water v.waterTime = data.waterTime end end end)

-- Synced New Weed Plant Data
RegisterNetEvent(Config.Foldername..':client:addWeedPlant', function(data, id)
	local plant = data
	if #(GetEntityCoords(PlayerPedId()) - data.coords) <= 150.0 then
		local obj = CreateObject(GetHashKey(Config.Seed[data.seed].stages[1]), vector3(data.coords.x, data.coords.y, data.coords.z + Config.Stages[1].offset), false)
		FreezeEntityPosition(obj, true)
		plant.obj = obj
	end
	WeedPlants[id] = plant
	--table.insert(WeedPlants, plant)
end)

-- Updating Existing Plant Data
RegisterNetEvent(Config.Foldername..':client:updatePlantStatus', function(data)
	for k,v in pairs(WeedPlants) do
		v.health = data[k].health
		v.progress = data[k].progress
		v.water = data[k].water
		v.insects = data[k].insects
		local zOffset = 1.0
		if v.state ~= Config.HarvestingState then
			zOffset = 0.5
			for a, b in pairs(Config.Stages) do
				if v.progress >= b.min and v.progress <= b.max and v.state ~= b.state then
					DeleteEntity(v.obj)
					local obj = CreateObject(GetHashKey(Config.Seed[v.seed].stages[a]), vector3(v.coords.x, v.coords.y, v.coords.z + b.offset), false)
					FreezeEntityPosition(obj, true)
					v.obj = obj
				end
			end
		elseif v.insects and v.insectsPfx then StopParticleFxLooped(v.insectsPfx, 0) v.insectsPfx = nil end
		if v.insects and not v.insectsPfx then
			local dict = 'core'
			local pfx = 'ent_amb_moths_swarm'
			RequestNamedPtfxAsset(dict)
			while not HasNamedPtfxAssetLoaded(dict) do Citizen.Wait(0) end
			UseParticleFxAssetNextCall(dict)
			local effect = StartParticleFxLoopedAtCoord("ent_amb_fly_swarm", v.coords.x, v.coords.y, v.coords.z + zOffset, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
			v.insectsPfx = effect
		end
		v.state = data[k].state
	end
end)

-- Updating Insects
RegisterNetEvent(Config.Foldername..':client:updatePlantInsects', function(coords, data)
	for k,v in pairs(WeedPlants) do
		if v.coords == coords then
			v.health = data.health v.insects = data.insects
			if data.insects == false then StopParticleFxLooped(v.insectsPfx, 0) v.insectsPfx = nil end
		end
	end
end)

-- Deleting PLant Data & Prop
RegisterNetEvent(Config.Foldername..':client:deleteWeedPlant', function(plantID, action)
	if WeedPlants[plantID] then
		DeleteEntity(WeedPlants[plantID].obj)
		StopParticleFxLooped(WeedPlants[plantID].insectsPfx, 0)
		WeedPlants[plantID].insectsPfx = nil
		WeedPlants[plantID] = nil
		--table.remove(WeedPlants, plantID)
		if nearestPlant==plantID then nearestPlant = nil end
	end
end)

-- Removing Growing Light Sync (Alpha Change)
RegisterNetEvent(Config.Foldername..':client:deleteGrowLight', function(lab, light)
	if CurrentLab ~= lab then return end
	if Lights[light] then SetEntityAlpha(Lights[light].e, 60) Entity(Lights[light].e).state.Installed = false end
end)

-- Installing Growing Light Sync (Alpha Change)
RegisterNetEvent(Config.Foldername..':client:SyncGrowLight', function(lab, light)
	if CurrentLab ~= lab then return end
	if Lights[light] then SetEntityAlpha(Lights[light].e, 255) Entity(Lights[light].e).state.Installed = true end
end)

------------
-- Others --
-------------
function checkPlantingSurface(seed, label, lab, planterSpot, planterCoords, planterID, WW)
	Citizen.CreateThread(function()
		local ped = PlayerPedId()
		local coordA = GetEntityCoords(ped)
		local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, -3.0)
		local testRay = StartExpensiveSynchronousShapeTestLosProbe(coordA, coordB, 17, ped, 7)
		local _, hit, endCoords, surfaceNormal, materialHash, _ = GetShapeTestResultIncludingMaterial(testRay)
		if Config.ShowSoilHash then print("Soil-Hash : ", materialHash) end

		if hit and not lab and not WW then
			if exports['qb-drugsystem']:CheckInsideNoGoZone() then QBCore.Functions.Notify('This place is too populated to plant here!', 'error') return end
			materialHash = tostring(materialHash)
			if Config.Soil[materialHash] == nil then ShowNotification(Config.Locale["not_suitable_soil"], "error") return end
			if surfaceNormal.z < 0.7 then ShowNotification(Config.Locale["slant_surface_notify"], "error") return end
				local soil_nature, item = Config.Soil[materialHash].ph, nil
				if soil_nature == "acidic" then item = Config.Items["acidic_soil_item"]
				elseif soil_nature == "basic" then item = Config.Items["alkaline_soil_item"] end

				local result = false
				if item ~= nil then
					local p = promise.new()
					QBCore.Functions.TriggerCallback(Config.Foldername..":server:hasItem", function(result) p:resolve(result) end, item)
					result = Citizen.Await(p)
				else result = true end

				if result or soil_nature == "neutral" then ProgressBarPlant(endCoords, materialHash, seed, label)
				else
					if soil_nature == "acidic" then ShowNotification(Config.Locale["soil_acidity_notify"], "error")
					elseif soil_nature == "basic" then ShowNotification(Config.Locale["soil_alkaline_notify"], "error") end
				end
		elseif lab or WW then
			ProgressBarPlant(planterCoords, 'InsideLab', seed, label, planterID, planterSpot, CurrentLab, WW)
		else
			ShowNotification(Config.Locale["no_surface_notify"], "error")
		end
	end)
end

function burnWeedPlants(id, loc) ProgressBar("destroy-plant", id, loc, nil) end



------------------------
-- Lab Humidity Settings --
------------------------

-- Checking Humidity Settings
RegisterNetEvent(Config.Foldername..':client:CheckHumidity')
AddEventHandler(Config.Foldername..':client:CheckHumidity', function()
	local input = lib.inputDialog('Humidity Settings', {
		{type = 'slider', label = 'Air Humidity %', required = true, min = 0, max = 100, default = LabsData[CurrentLab].Humidity or 0},
	}) if not input then return end
	QBCore.Functions.Notify('Humidity set to '..input[1]..'%', 'success')
	TriggerServerEvent(Config.Foldername..':server:SetupHumidity', CurrentLab, input[1])
end)

------------------------
-- Lab Light Settings --
------------------------

-- Checking Lights Settings
RegisterNetEvent(Config.Foldername..':client:CheckLightsInt')
AddEventHandler(Config.Foldername..':client:CheckLightsInt', function()
	QBCore.Functions.TriggerCallback(Config.Foldername..':server:getOsTime', function(diff)
		local timeLeft = SecondsToClock(diff*-1)
		if diff < 0 then QBCore.Functions.Notify('The controls are locked! They will be unlocked in '..timeLeft..".", 'error') return end
		local input = lib.inputDialog('Light Intensity Settings', {
			{type = 'slider', label = 'Intensity', required = true, min = 0, max = 100, default = LabsData[CurrentLab] and LabsData[CurrentLab].LightItensity or 0},
		}) if not input then return end
		local alert = lib.alertDialog({header = 'Light Settings Confirmation', content = 'Set the light intensity at '..input[1].."% for 12 hours?", centered = true, cancel = true})
		if alert ~= "confirm" then return end

		TriggerServerEvent(Config.Foldername..':server:SetupLightInt', CurrentLab, input[1])
	end, CurrentLab)
end)

------------------------
-- Lab Water Settings --
------------------------

-- Changing Water Vat Settings
local function CheckVatRecipe()
	local input = lib.inputDialog('Watering System Settings', {
		{type = 'slider', label = 'Acid', required = true, min = 0, max = 10, default = LabsData[CurrentLab].WaterSettings.acid or 0, disabled = not QBCore.Functions.HasItem('acid_bottle')},
		{type = 'slider', label = 'Alkaline', required = true, min = 0, max = 10, default = LabsData[CurrentLab].WaterSettings.alka or 0, disabled = not QBCore.Functions.HasItem('alkaline_bottle')},
		{type = 'slider', label = 'Fertilizer', required = true, min = 0, max = 10, default = LabsData[CurrentLab].WaterSettings.fert or 0, disabled = not QBCore.Functions.HasItem('weed_nutrition')},
	})
	if not input then return end
	TriggerServerEvent(Config.Foldername..':server:SetupVat', CurrentLab, input[1], input[2], input[3])
end

-- Checking Water Vat Settings
RegisterNetEvent(Config.Foldername..':client:CheckVat')
AddEventHandler(Config.Foldername..':client:CheckVat', function()
	local w = string.format("%.2f %%", (LabsData[CurrentLab] and LabsData[CurrentLab].WaterSettings and LabsData[CurrentLab].WaterSettings.waterLvl or 0)/30*100)
	local ac = LabsData[CurrentLab] and LabsData[CurrentLab].WaterSettings and LabsData[CurrentLab].WaterSettings.acid or 0
	local al = LabsData[CurrentLab] and LabsData[CurrentLab].WaterSettings and LabsData[CurrentLab].WaterSettings.alka or 0
	local f = LabsData[CurrentLab] and LabsData[CurrentLab].WaterSettings and LabsData[CurrentLab].WaterSettings.fert or 0
	local string = 'Water : '..w.."\nAcid : "..ac.."L | Alkaline : "..al.."L | Fertilizer : "..f.."L"
	lib.registerContext({
		id = 'checkVatVenu',
		title = 'Watering System Settings',
		options = {
			{
				title = 'Current Settings :',
				description = string,
				icon = 'vial-circle-check',
				disabled = LabsData[CurrentLab] and LabsData[CurrentLab].WaterSettings and LabsData[CurrentLab].WaterSettings.waterLvl >= 0,
			},
			{
				title = 'Add Water',
				description = 'Add a full watering can\'s water to the vat.',
				icon = 'droplet',
				disabled = LabsData[CurrentLab] and LabsData[CurrentLab].WaterSettings and LabsData[CurrentLab].WaterSettings.waterLvl >= 6,
				onSelect = function() TriggerServerEvent(Config.Foldername..':server:FillVatWater', CurrentLab) end,
			},
			{
				title = 'Add Modifiers',
				description = 'Setup your recipe.',
				disabled = not LabsData[CurrentLab] or not LabsData[CurrentLab].WaterSettings or LabsData[CurrentLab].WaterSettings.waterLvl < 0,
				onSelect = function() CheckVatRecipe() end,
				icon = 'flask-vial'
			},
		}
	})
	lib.showContext('checkVatVenu')
end)

-----------------
-- Grow Lights --
-----------------
-- Checking Water Vat Settings
RegisterNetEvent(Config.Foldername..':client:InstallLight')
AddEventHandler(Config.Foldername..':client:InstallLight', function(data)
	if not QBCore.Functions.HasItem('weedgrowlight') then QBCore.Functions.Notify('You don\'t have a growing light with you...', 'error') return end
	local ped = PlayerPedId()
	TaskTurnPedToFaceEntity(ped, data.entity, 1000) Wait(1000)
	QBCore.Functions.Progressbar("installLight", "Installing Light", 2000, false, true,
	{disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
	{animDict = "anim@gangops@facility@servers@", anim = "hotwire", flags = 1},
	{}, {}, function()
		ClearPedTasks(ped)
		TriggerServerEvent(Config.Foldername..':server:InstallGrowLight', data.CurrentLab, data.Light, true)
	end, function() ClearPedTasks(ped) end)
end)

-- Checking Water Vat Settings
RegisterNetEvent(Config.Foldername..':client:RemovingLight')
AddEventHandler(Config.Foldername..':client:RemovingLight', function(data)
	local ped = PlayerPedId()
	TaskTurnPedToFaceEntity(ped, data.entity, 1000) Wait(1000)
	QBCore.Functions.Progressbar("installLight", "Removing Light", 2000, false, true,
	{disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
	{animDict = "anim@gangops@facility@servers@", anim = "hotwire", flags = 1},
	{}, {}, function()
		ClearPedTasks(ped)
		TriggerServerEvent(Config.Foldername..':server:InstallGrowLight', data.CurrentLab, data.Light, false)
	end, function() ClearPedTasks(ped) end)
end)

---------------------
-- Lab Generation --
---------------------

-- Polyzone Thread
Citizen.CreateThread(function()
	Wait(5000)
	for k, v in ipairs(Config.GrowLabs) do
		GrowLabs[k] = BoxZone:Create(v.loc.coords, 25.0, 15.0, {name = "WeedGrowLab_"..k, debugPoly = false, heading = v.loc.h, minZ = v.loc.coords.z-4.92, maxZ = v.loc.coords.z+3.28,
		offset = {0.0,15.0,0}}) GrowLabs[k]:onPlayerInOut(function(isPointInside) if isPointInside then onEnter(v.loc.coords, k) else onExit() end end)
	end
end)

function ShowNotification(msg, type)
    if Config.QBCoreNotify then
		QBCore.Functions.Notify(msg, type)
	elseif Config.okokNotify then
		exports['okokNotify']:Alert(Config.OkOkNotifyTitle, msg,  5000, type)
	elseif Config.pNotify then
		exports.pNotify:SendNotification({text = msg, type = type,layout = Config.pNotifyLayout, timeout = 5000})
	end
end

Citizen.CreateThread(function()
	local Plants = {}

	for k, _ in pairs(Config.Stages) do
		for _, v in pairs(Config.Seed) do
			table.insert(Plants, v.stages[k])
		end
	end
	if Config.EnableTargetExports then
		exports[Config.Target]:AddTargetModel(Plants, {
			options = {
				{
					type = "client",
					event = Config.Foldername..":client:checkClosestPlant",
					icon = "fas fa-cannabis",
					label = "Check Plant",
					canInteract = function(entity) return not Entity(entity).state.isWildPlant end
				},
				{
					type = "client",
					event = Config.Foldername..":client:burnClosestPlant",
					icon = "fas fa-fire",
					label = "Burn Plant",
					canInteract = function(entity) return not Entity(entity).state.isWildPlant end
				},
				{
					type = "client",
					event = Config.Foldername..":client:checkWildPlant",
					icon = "fas fa-cannabis",
					label = "Check Wild Plant",
					canInteract = function(entity) return Entity(entity).state.isWildPlant end
				},
			},
			distance = 2.5
		})
	end

end)

-- for the ps-progressbar
local ProgressBarIcon = {
    ["harvesting_weed"] = "fa-solid fa-user-secret",
    ["planting_weed"] = "fa-solid fa-user-secret",
    ["destroy_weed"] = "fa-solid fa-user-secret",
    ["giving_insecticide"] = "fa-solid fa-user-secret",
	["giving_fertilizer"] = "fa-solid fa-seedling",
    ["giving_water"] = "fa-solid fa-user-secret",
}

function ProgressBar(type, id, coords, obj) -- do not change these parameters
	local ped = PlayerPedId()
	if type == "giving-water" then
		TaskTurnPedToFaceCoord(ped, coords.x, coords.y, coords.z, 1000)
		Wait(1000)
		QBCore.Functions.Progressbar("harvesting_weed", "Giving Water", 5000, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {
			animDict = "bz@watercan@animation",
			anim = "bz_watercan",
			flags = 49,
		}, {
			model = 'prop_wateringcan002',
			bone = 57005,
			coords = { x = 0.27, y = 0.0, z = -0.23 },
			rotation = { x = -75.0, y = 41.0, z = 36.0 },
		}, {}, function()
			ClearPedTasks(ped)
			ClearPedSecondaryTask(ped)
			TriggerServerEvent(Config.Foldername..":server:removeWateringcanUse")  -- do not touch this
			TriggerServerEvent(Config.Foldername..":server:updateWeedPlantWater", id, coords, obj)  -- do not touch this
			Wait(500)
			TriggerEvent(Config.Foldername..":client:OpenOptions", id)
		end, function()	--cancel
			ClearPedTasks(ped)
			ClearPedSecondaryTask(ped)
		end, ProgressBarIcon["giving_water"])
	elseif type == "destroy-plant" then
		QBCore.Functions.Progressbar("harvesting_weed", Config.Locale["destroying_plant"], 8000, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {
			animDict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
			anim = "plant_floor",
			flags = 49,
		}, {}, {}, function() -- Done
			ClearPedTasks(ped)
			ClearPedSecondaryTask(ped)
			TriggerServerEvent(Config.Foldername..":server:deleteWeedPlant", id, coords)  -- do not touch this
		end, function()	--cancel
			ClearPedTasks(ped)
			ClearPedSecondaryTask(ped)
		end, ProgressBarIcon["destroy_weed"])
	elseif type == "giving-insecticide" then
		TaskTurnPedToFaceCoord(ped, coords.x, coords.y, coords.z, 1000)
		Wait(1000)
		local r = GetEntityRotation(ped)
		QBCore.Functions.Progressbar("harvesting_weed", "Giving Insecticide", 5000, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {
			animDict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@",
			anim = "weed_spraybottle_crouch_spraying_03_inspector",
			flags = 64,
		}, {
			model = 'bkr_prop_weed_spray_01a',
			bone = 57005,
			coords = { x = 0.1, y = -0.06, z = -0.14 },
			rotation = { x = -45.0, y = 0.0, z = 0.0 },
		}, {}, function() -- Done
			ClearPedTasks(ped)
			ClearPedSecondaryTask(ped)
			SetEntityRotation(ped, r[1], r[2], r[3], 2, true)
			TriggerServerEvent(Config.Foldername..":server:removeItem", Config.Items["insecticide"])  -- do not touch this
			TriggerServerEvent(Config.Foldername..":server:updateWeedPlantInsects", id, coords)  -- do not touch this
			TriggerEvent(Config.Foldername..":client:OpenOptions", id)
		end, function()	--cancel
			ClearPedTasks(ped)
			ClearPedSecondaryTask(ped)
		end, ProgressBarIcon["giving_insecticide"])
	elseif type == "giving-fertilizer" then
		TaskTurnPedToFaceCoord(ped, coords.x, coords.y, coords.z, 1000)
		Wait(1000)
		QBCore.Functions.Progressbar("harvesting_weed", "Giving Fertilizer", 2000, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {
			animDict = "pickup_object",
			anim = "putdown_low",
			flags = 49,
		}, {}, {}, function() -- Done
			ClearPedTasks(ped)
			ClearPedSecondaryTask(ped)
			TriggerServerEvent(Config.Foldername..":server:removeItem", Config.Items["fertilizer"])  -- do not touch this
			TriggerServerEvent(Config.Foldername..":server:updateWeedPlantHealth", id, coords)  -- do not touch this
			Wait(500)
			TriggerEvent(Config.Foldername..":client:OpenOptions", id)
		end, function()	--cancel
			ClearPedTasks(ped)
			ClearPedSecondaryTask(ped)
		end, ProgressBarIcon["giving_insecticide"])
	elseif type == "harvest" then
		QBCore.Functions.Progressbar("harvesting_weed", Config.Locale["harvesting_weed_progressbar"], 8000, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
			}, {
				task = "WORLD_HUMAN_GARDENER_PLANT",
			}, {}, {}, function() -- Done
			ClearPedTasks(ped)
			ClearPedSecondaryTask(ped)
			if DoesEntityExist(obj) then
				TriggerServerEvent(Config.Foldername..":server:harvestWeed", id, coords) -- do not touch this
				currentObj = nil  -- do not touch this
			end
		end, function()	--cancel
			ClearPedTasks(ped)
			ClearPedSecondaryTask(ped)
		end, ProgressBarIcon["harvesting_weed"])
	end
end

function ProgressBarPlant(a, b, c, d, planterID, planterSpot, lab, WW) -- do not change the parameters
	local ped = PlayerPedId()
	TaskTurnPedToFaceCoord(ped, a.x, a.y, a.z, 1000) Wait(1000)
	QBCore.Functions.Progressbar("adding_weedplant", Config.Locale["plant_weed_progressbar"], 8000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
		}, {
			task = "WORLD_HUMAN_GARDENER_PLANT",
		}, {}, {}, function() -- Done
		ClearPedTasks(ped)
		ClearPedSecondaryTask(ped)
		TriggerServerEvent(Config.Foldername..":server:addWeedPlant", a, b, c, d, planterID, planterSpot, lab, WW) -- do not touch this
	end, function()	--cancel
		ClearPedTasks(ped)
		ClearPedSecondaryTask(ped)
	end, ProgressBarIcon["planting_weed"])
end

RegisterNetEvent(Config.Foldername..':client:fillWateringCan', function(item)
	local ped = PlayerPedId()
	if not IsEntityInWater(ped) then return end
	QBCore.Functions.Progressbar('fillcan', "Filling Up Watering Can...", math.random(15000, 20000), true, true,
    { disableMovement = true, disableCarMovement = true, isableMouse = false, disableCombat = true, },
    { animDict = "move_crouch_proto", anim = "idle", flags = 1 },
	{ model = 'prop_wateringcan002', bone = 57005, coords = { x = 0.27, y = 0.0, z = -0.23 }, rotation = { x = -75.0, y = 41.0, z = 36.0 }},
	{}, function() ClearPedTasks(ped) TriggerServerEvent(Config.Foldername..':server:fillWateringCan', item) end, function() ClearPedTasks(ped) end)
end)

local hitting = false
local function hitTheBong(slot)
	TriggerServerEvent(Config.Foldername..':server:hitTheBong', slot)
	ExecuteCommand('e bong') hitting = true Wait(10000) hitting = false ExecuteCommand('emotecancel')
end

RegisterNetEvent(Config.Foldername..':client:HitTheBong', function(item)
	if hitting then QBCore.Functions.Notify('You are already hitting the bong!', 'error') return end
	local ped = PlayerPedId()
	local options = {}
	local pData = QBCore.Functions.GetPlayerData()
	for k, v in pairs(pData.items) do
		if v.name == "malmo_weed_35g" then
			options[#options + 1] = {title = 'Hit '..v.label, description = "Strain : "..v.info.strainlbl.." | Purity : "..v.info.purity, onSelect = function() hitTheBong(v.slot) end}
		end
	end
	lib.registerContext({ id = 'grindingWeed', title = 'Grind & Roll Weed', canClose = true, options = options })
	lib.showContext('grindingWeed')
end)

RegisterNetEvent(Config.Foldername..':client:UsePrerollPack', function(Pack)
    local ped = PlayerPedId()
    TriggerEvent('animations:client:EmoteCommandStart', {"uncuff"})
    TriggerServerEvent('consumables:server:RemovePrerollPackUse', Pack)
    Wait(2000)
    ClearPedTasks(ped)
end)

local function grindWeed(slot, item, preroll)
	local ped = PlayerPedId()
	local a = item.name == 'malmo_weed_oz' and 4 or item.name == 'malmo_weed_7g' and 2 or item.name == 'malmo_weed_35g' and 1
	if not QBCore.Functions.HasItem('rollingpapers', a) then QBCore.Functions.Notify('You don\'t have enough rolling papers!', 'error') return end
	if preroll and not QBCore.Functions.HasItem('emptyprerollpack', 1) then QBCore.Functions.Notify('You don\'t have enough empty packs!', 'error') return end
	QBCore.Functions.Progressbar("rollingWeed", "Grinding Bud...", 3800, false, true,
	{disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
	{animDict = "mp_arresting", anim = "a_uncuff", flags = 17},
	{}, {}, function()
		QBCore.Functions.Progressbar("rollingWeed", "Rolling Joint...", 6200, false, true,
		{disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
		{animDict = "anim@amb@business@weed@weed_inspecting_high_dry@", anim = "weed_inspecting_high_base_inspector", flags = 49},
		{}, {}, function()
			ClearPedTasks(ped)
			TriggerServerEvent(Config.Foldername..':server:grindWeed', slot, a, item.name, preroll)
		end, function() ClearPedTasks(ped) end)
	end, function() ClearPedTasks(ped) end)
end

local preRolls = function()
	local options = {}
	local pData = QBCore.Functions.GetPlayerData()
	for k, v in pairs(pData.items) do
		if v.name == "malmo_weed_oz" then
			options[#options + 1] = {title = 'Grind '..v.label, description = "Strain : "..v.info.strainlbl.." | Purity : "..v.info.purity.."\n_Makes 1 Pre-Roll Pack_", onSelect = function() grindWeed(v.slot, pData.items[v.slot], true) end}
		end
	end
	lib.registerContext({ id = 'grindingWeed', title = 'Grind & Roll Weed', canClose = true, options = options })
	lib.showContext('grindingWeed')
end

RegisterNetEvent(Config.Foldername..':client:grindWeed', function(WW)
	local options = {}
	local pData = QBCore.Functions.GetPlayerData()
	if WW and WW.WW then options[#options+1] = {title = "Make PreRoll Packs", description = "Make Pre-Roll Packs of 8 joints with an ounce.", onSelect = preRolls} end
	for k, v in pairs(pData.items) do
		if v.name == "malmo_weed_oz" or v.name == "malmo_weed_7g" or v.name == "malmo_weed_35g" then
			local jAmount = v.name == 'malmo_weed_oz' and "2x 4 joints._" or v.name == 'malmo_weed_7g' and "2 joints._" or v.name == 'malmo_weed_35g' and "1 joint._"
			options[#options + 1] = {title = 'Grind '..v.label, description = "Strain : "..v.info.strainlbl.." | Purity : "..v.info.purity.."\n_Makes "..jAmount, onSelect = function() grindWeed(v.slot, pData.items[v.slot]) end}
		end
	end
	if #options < 1 then QBCore.Functions.Notify('You don\'t have any weed to grind!', 'error') return end
	lib.registerContext({ id = 'grindingWeed', title = 'Grind & Roll Weed', canClose = true, options = options })
	lib.showContext('grindingWeed')
end)

RegisterNetEvent(Config.Foldername..':client:checkWildPlant', function()
    local progress = 0
	QBCore.Functions.TriggerCallback(Config.Foldername..":server:getOsTime2", function(time)
		if not GlobalState['wildPlant:strain'] then QBCore.Functions.Notify('Something went wrong...', 'error') return end
		if GlobalState['wildPlant:time'] then
			local timeRemaining = GlobalState['wildPlant:time']+GlobalState['wildPlant:ripe'] - time --3600
			if timeRemaining > 0 then progress = 100-math.floor(timeRemaining/GlobalState['wildPlant:ripe']*100) else progress = 100 end
		end
		lib.registerContext({
			id = 'wildPlant', title = 'Wild '..Config.Seed[GlobalState['wildPlant:strain']].label.." Plant", canClose = true, options = {
				{title = 'Current Growth', description = 'Progress : '.. progress.."%", progress = progress, disabled = true},
				{title = 'Take Plant', disabled = progress < 100, onSelect = function() TriggerServerEvent(Config.Foldername..':server:takeWildPlant') end},
			}
		}) lib.showContext('wildPlant')
	end)
end)

local WPPoint
local WildPlant
RegisterNetEvent(Config.Foldername..':client:generateWildPlant', function()
	local coords = GlobalState['wildPlant:coords']
	WPPoint = lib.points.new(coords, 100)
	function WPPoint:onEnter()
		WildPlant = CreateObject(GetHashKey(Config.Seed[GlobalState['wildPlant:strain']].stages[5]), vector3(coords.x, coords.y, coords.z-1.1), false)
		Entity(WildPlant).state.isWildPlant = true
		FreezeEntityPosition(WildPlant, true)
		--exports['qb-target']:AddTargetEntity(obj, {options = {action = CheckWildPlant, icon = "fa-solid fa-cannabis", label = 'Check Wild Plant'}, distance = 2.0})
	end
	function WPPoint:nearby()
		if self.currentDistance < 50.0 then
			DrawLightWithRange(coords.x, coords.y, coords.z-0.5, 0, 255, 0, 3.0, 2.0)
		end
	end
	function WPPoint:onExit() if DoesEntityExist(WildPlant) then DeleteEntity(WildPlant) end WildPlant = nil end
end)

local WildPing
RegisterNetEvent(Config.Foldername..':client:wildPing', function()
	if not GlobalState['wildPlant:emailLoc'] then QBCore.Functions.Notify('Attachment not available', 'error') return end
	WildPing = AddBlipForRadius(GlobalState['wildPlant:emailLoc'], 200.0)
	SetBlipColour(WildPing, 25)
	SetBlipAlpha(WildPing, 128)
end)

RegisterNetEvent(Config.Foldername..':client:clearWildPlant', function()
	if WPPoint then WPPoint:remove() end
	if DoesEntityExist(WildPlant) then DeleteEntity(WildPlant) end
	WPPoint, WildPlant = nil, nil
end)

RegisterNetEvent(Config.Foldername..':client:clearWildPing', function()
	if DoesBlipExist(WildPing) then RemoveBlip(WildPing) end
	WildPing = nil
end)

local jEffects = {
	['skunk_seed'] = {stress = 20, hp = 5},
	['zkittles_seed'] = {stress = 30, hp = 10},
	['trainwreck_seed'] = {stress = 40, hp = 15},
	['garlicc_seed'] = {stress = 50, hp = 20},
	['malmo_kush_seed'] = {stress = 60, hp = 30},
}

local currentJoint = ''
RegisterNetEvent(Config.Foldername..':client:smokeJoint', function(strain, purity)
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		TriggerEvent('animations:client:EmoteCommandStart', {"smoke3"})
	else
		TriggerEvent('animations:client:EmoteCommandStart', {"smokeweed"})
	end
    QBCore.Functions.Progressbar("smoke_joint", "Smoking joint..", 15000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function()
		if jEffects[currentJoint] then QBCore.Functions.Notify('You are already under the influence of an earlier joint...', 'error') return end
		currentJoint = strain
		local purEffect = purity / 100
        TriggerEvent("evidence:client:SetStatus", "weedsmell", 1800)
		if not exports['ps-buffs']:HasBuff('super-health') then  exports['ps-buffs']:AddBuff('super-health', 20*60000) end
		if not exports['ps-buffs']:HasBuff('super-stress') then  exports['ps-buffs']:AddBuff('super-health', 20*60000) end
		Citizen.CreateThread(function()
			for _ = 1, 20 do
				TriggerServerEvent('hud:server:RelieveStress', (jEffects[currentJoint].stress*purEffect))
				QBCore.Functions.Notify('The weed destresses a bit...', 'info', 2500)
				Wait(2000)
				SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + (math.ceil(jEffects[currentJoint].hp*purEffect)))
				QBCore.Functions.Notify('The weed makes you feel a little better...', 'success', 2500)
				Wait(58000)
			end
			currentJoint = ''
		end)
    end)
end)