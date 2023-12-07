LocalPlayer.state:set('burnerphoneCooldown', false, true)
for k, _ in pairs(Config.Burnerphones) do
	LocalPlayer.state:set('burnerphoneCooldown_'..k, false, true)
end

--Phone Battery
local function PhoneBattery(item)
	if Config.Battery.BatteryType == "chance" or (Config.Framework.Framework == "ESX" and not Config.Framework.UseOxInv) then
		local chance = math.random(100)
		if chance <= Config.Burnerphones[item].BreakChance then
			TriggerServerEvent('cr-burnerphones:server:BatteryOut', item)
			BCUtils.Notif(3, Lcl("notif_BatteryOut"), Lcl("title_BatteryOut"))
		end
	else
		TriggerServerEvent('cr-burnerphones:server:Battery', item)
	end
end

-- Cancelling Call
local function CancellCall(notif)
	local ped = PlayerPedId()
	BCUtils.PlayEmote('c')
	ClearPedTasks(ped)
	if notif then BCUtils.Notif(3, Lcl("notif_Cancelled"), Lcl("title_Cancelled")) end
end

-- Chosing Drop Loc & Rewards
local function PrepareDrop(phone)
	local Phone = Config.Burnerphones[phone]
	local ranLoc = GlobalState.CRBurnerphones.Phones[phone].NextLoc
	local ranReward = GenerateLoot(phone)
	if not ranLoc then BCUtils.Notif(3, Lcl("notif_CooldownActive"), Lcl("title_CooldownActive")) return end
	BCUtils.Notif(1, Lcl("notif_OrderSuccessful"), Lcl("title_OrderSuccessful"))
	local coords = Phone.DropOffLocations[ranLoc]
	TriggerServerEvent('cr-burnerphones:server:GetNextLoc', phone)
	local waitTime = math.random((Config.MinWait * 1000), (Config.MaxWait * 1000))
	Wait(waitTime)
	SetNewWaypoint(coords)
	BCUtils.HasItem(Config.VPNItem):next(function(hasItem)
		if Phone.CallCops and not hasItem then
			local chance = math.random(100)
			if chance <= Config.Police.CallCopsChance then BCUtils.CallCops(phone, coords) end
		end
		TriggerServerEvent('cr-burnerphones:server:setUpDrop', phone, ranLoc, ranReward)
		BCUtils.Notif(2, Lcl("notif_LocSent"), Lcl("title_LocSent"))
	end)
end

-- Singular Player Cooldown
local function SetPlayerCooldown(phone)
	CreateThread(function()
		if Config.SharedCooldown then
			LocalPlayer.state:set('burnerphoneCooldown', true, true)
			Wait(Config.CooldownTime * 60000)
			LocalPlayer.state:set('burnerphoneCooldown', false, true)
		else
			LocalPlayer.state:set('burnerphoneCooldown_'..phone, true, true)
			Wait(Config.Burnerphones[phone].CooldownTime * 60000)
			LocalPlayer.state:set('burnerphoneCooldown_'..phone, false, true)
		end
	end)
end

-- Cooldown + Item Check
local function CallforDrop(item)
	LocalPlayer.state:set('inv_busy', false, true)
	if GlobalState.CRBurnerphones.GlobalCooldown or GlobalState.CRBurnerphones.Phones[item].onCooldown or LocalPlayer.state.burnerphoneCooldown or LocalPlayer.state['burnerphoneCooldown_'..item] then
		CancellCall()
		BCUtils.Notif(3, Lcl("notif_CooldownActive"), Lcl("title_CooldownActive"))
		if Config.Battery.UseBatteryWhenCooldownActive then PhoneBattery(item) end
	return end
	BCUtils.HasItem(item):next(function(hasItem)
		if hasItem then
			CancellCall()
			PhoneBattery(item)
			PrepareDrop(item)
			if Config.LocalCooldown then
				SetPlayerCooldown(item)
			else
				TriggerServerEvent('cr-burnerphones:server:SetCooldown')
			end
		else
			BCUtils.Notif(3, Lcl("notif_MissingPhone"), Lcl("title_Error"))
			if Config.LocalCooldown then
				SetPlayerCooldown(item)
			else
				TriggerServerEvent('cr-burnerphones:server:SetCooldown')
			end
		end
	end)
end

--Call function
local function PhoneCall(item)
	BCUtils.PlayEmote('phonecall')
	local onFinish = function() CallforDrop(item) end
	local onCancel = function() CancellCall(true) end
	BCUtils.ProgressUI(math.random(5000,15000), Lcl("progbar_calling"), onFinish, onCancel, true, false)
end

-- Delete Prop
RegisterNetEvent('cr-burnerphones:client:deleteBox')
AddEventHandler('cr-burnerphones:client:deleteBox', function(phone, loc, obj)
	local Phone = Config.Burnerphones[phone]
	local coords = Phone.DropOffLocations[loc]
	local drop = GetClosestObjectOfType(coords, 2.0, GetHashKey(Phone.Rewards[obj].prop), true, true, true)
	if DoesEntityExist(drop) then DeleteEntity(drop) end
	DeleteZones(phone, loc)
end)

-- Picking up Drop
RegisterNetEvent('cr-burnerphones:client:PickUpDrop')
AddEventHandler('cr-burnerphones:client:PickUpDrop', function(data)
	local Phone = Config.Burnerphones[data.phone]
	if not GlobalState.CRBurnerphones.Locations[Phone.DropOffLocations[data.loc]] then BCUtils.Notif(3, Lcl("notif_Empty"), Lcl("title_EmptyBox")) return end
	local ped = PlayerPedId()
	TaskTurnPedToFaceEntity(ped, data.box, -1)
	Wait(1000)
	BCUtils.PlayEmote(Phone.Rewards[data.reward].emote)
	BCUtils.Notif(2, Lcl("notif_Searching"), Lcl("title_Searching"))
	local onFinish = function()
		TriggerServerEvent("cr-burnerphones:server:BurnerPhoneReward", data.phone, data.reward, data.loc)
		BCUtils.Notif(1, Lcl("notif_ItemFound"), Lcl("title_ItemFound"))
		ClearPedTasks(ped)
	end
	local onCancel = function()
		ClearPedTasks(ped)
		BCUtils.Notif(3, Lcl("notif_Cancelled"), Lcl("title_Cancelled"))
	end
	BCUtils.ProgressUI(math.random(3000,7500), Lcl("progbar_searchingpackage"), onFinish, onCancel, true, true)
end)

-- Using Burnerphone
RegisterNetEvent('cr-burnerphones:client:BurnerPhoneUse')
AddEventHandler('cr-burnerphones:client:BurnerPhoneUse', function(item)
	local ped = PlayerPedId()
	local Phone = Config.Burnerphones[item]
	BCUtils.GetCurrentCops():next(function(amount)
		if amount < Phone.CopsNeeded then BCUtils.Notif(3, Lcl("notif_CooldownActive"), Lcl("title_CooldownActive")) return end
		LocalPlayer.state:set('inv_busy', true, true)
		if not Phone.VPNEnabled then PhoneCall(item) return end
		BCUtils.HasItem(Config.VPNItem):next(function(hasItem)
			if not hasItem then PhoneCall(item) return end
			BCUtils.PlayEmote('texting')
			local onCancel = function()
				CancellCall(true)
			end
			local connectFinish = function()
				ClearPedTasks(ped) PhoneCall(item)
			end
			local onFinish = function()
				BCUtils.PlayEmote('phone')
				BCUtils.ProgressUI(math.random(1500,3000), Lcl("progbar_network"), connectFinish, onCancel, true, false)
			end
			BCUtils.ProgressUI(math.random(7000,15000), Lcl("progbar_vpnconnect"), onFinish, onCancel, true, false)
		end)
	end)
end)

-- Drop Distance Check
RegisterNetEvent('cr-burnerphones:client:setUpDrop')
AddEventHandler('cr-burnerphones:client:setUpDrop', function(phone, drop, reward)
	Wait(math.random(1000,3000))
	CreateThread(function()
		while true do
			local ped = PlayerPedId()
			local pos = GetEntityCoords(ped)
			local Phone = Config.Burnerphones[phone]
			local coords = Phone.DropOffLocations[drop]
			local dist = #(pos - coords)
			if not GlobalState.CRBurnerphones.Locations[coords] then break end
			if dist <= 50 then
				local model = GetHashKey(Phone.Rewards[reward].prop)
				RequestModel(model) while not HasModelLoaded(model) do Wait(1) end
				local box = GetClosestObjectOfType(coords, 1.5, model, 0, 0, 0)
				if not box or box == 0 then
					box = CreateObject(model, coords, true, true)
					PlaceObjectOnGroundProperly(box)
					SetEntityInvincible(box, true)
				end
				SetupDropTarget(phone, box, reward, drop)
				break
			end
			Wait(5000)
		end
	end)
end)
