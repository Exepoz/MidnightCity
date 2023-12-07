local QBCore = exports['qb-core']:GetCoreObject()

local Winevats = {
	{coords = vector3(-1932.62, 2052.62, 140.75)},
	{coords = vector3(-1931.97, 2055.39, 140.76)},
	{coords = vector3(-1931.27, 2058.09, 140.76)}
}

local bigBarrels = {
	vector3(-1867.72, 2058.86, 141.0),
	vector3(-1867.65, 2055.97, 141.0)
}

Citizen.CreateThread(function()
	exports['qb-target']:AddBoxZone("lowMoonshine", vector3(-30.04, 3024.13, 39.86), 2.5, 2.0, {name = "lowMoonshine", heading = 229.0, debugPoly = false, minZ = 40.0, maxZ = 43.0},
	{ options = {{type = "client", event = "mdn-extras:client:checkLowMoonshine", icon = 'fas fa-user-secret', label = 'Check Moonshine'}}, distance = 2.0, })

	for k, v in pairs(Winevats) do
		local p = lib.points.new(v.coords.xyz, 1.0)
		function p:onEnter() exports['qb-core']:DrawText('[E] Check Wine Vat') end
		function p:nearby() if IsControlJustPressed(2, 38) then exports['qb-core']:HideText() TriggerEvent("mdn-extras:client:checkWineVat", {vat = k}) end end
		function p:onExit() exports['qb-core']:HideText() end
	end

	for k, v in pairs(bigBarrels) do
		local p = lib.points.new(v, 1.0)
		function p:onEnter() exports['qb-core']:DrawText('[E] Check Wine Barrel') end
		function p:nearby() if IsControlJustPressed(2, 38) then exports['qb-core']:HideText() TriggerEvent("mdn-extras:client:checkWineBarrel", {barrel = k}) end end
		function p:onExit() exports['qb-core']:HideText() end
	end
end)

RegisterNetEvent("mdn-extras:client:checkWineBarrel", function(data)
	local job = QBCore.Functions.GetPlayerData().job.name
	if job ~= "winery" then QBCore.Functions.Notify("You don't work here!") return end
    local amount = 0
	local wine = GlobalState.WineBarrels[data.barrel].wine ~= "None" and Config.Moonshine.WineRecipes[GlobalState.WineBarrels[data.barrel].wine].label or "None"
	amount = GlobalState.WineBarrels[data.barrel].amount
	lib.registerContext({
		id = 'winebarrel', title = 'Wine Serving Barrel', canClose = true, options = {
			{title = 'Current Wine', description = 'Wine : '..wine..'\nAmount Left : '.. amount, progress = amount, disabled = true},
			{title = 'Pour Bottle', disabled = amount == 0, description = "Pour a bottle of Los Santos\'s Finest Wine!", onSelect = function() TriggerServerEvent("mdn-extras:server:pourBottle", data.barrel) end},
			{title = 'Fill Barrel', disabled = amount ~= 0, description = "Fill the serving barrel with up to 10 small wine barrels.", onSelect = function() TriggerEvent("mdn-extras:client:fillBarrel", data.barrel) end},
			{title = 'Drain Barrel', disabled = amount == 0, description = "Empty the content of the barrel. You lose everything.", onSelect = function() TriggerServerEvent("mdn-extras:server:drainBarrel", data.barrel) end},
		}
	}) lib.showContext('winebarrel')
end)

RegisterNetEvent("mdn-extras:client:fillBarrel", function(barrel)
	local options = {}
	for k, v in pairs(Config.Moonshine.WineRecipes) do
		options[#options+1] = {value = k, label = v.label}
	end
	local input = lib.inputDialog('Wine Serving Barrel', {
		{type = 'slider', label = 'Amount of Wine Barrels to add', required = true, min = 1, max = 10},
		{type = 'select', label = 'Wine Type', required = true, options = options}
	})
	if not input then return end
	local a = tonumber(input[1])
	local w = input[2]
	TriggerServerEvent('mdn-extras:server:fillBarrel', barrel, a, w)
end)

RegisterNetEvent("mdn-extras:client:checkWineVat", function(data)
	local job = QBCore.Functions.GetPlayerData().job.name
	if job ~= "winery" then QBCore.Functions.Notify("You don't work here!") return end
    local progress = 0
	QBCore.Functions.TriggerCallback("mdn-extras:server:moonshineTime", function(time)
		if GlobalState.WineVats[data.vat].time ~= 0 then
			local timeRemaining = GlobalState.WineVats[data.vat].time+129600 - time --129600 (36 hours)
			if timeRemaining > 0 then progress = math.ceil(100 - ((timeRemaining / 129600) * 100)) else progress = 100 end
		end
		local wine = GlobalState.WineVats[data.vat].wine ~= "None" and Config.Moonshine.WineRecipes[GlobalState.WineVats[data.vat].wine].label or "None"
		lib.registerContext({
			id = 'winevat', title = 'Wine Fermentation Vat', canClose = true, options = {
				{title = 'Current Fermentation', description = 'Wine : '..wine..'\nProgress : '.. progress.."%", progress = progress, disabled = true},
				{title = 'Collect Wine', disabled = progress < 100, onSelect = function() TriggerServerEvent("mdn-extras:server:takeWine", data.vat) end},
				{title = 'Deposit Grapes', disabled = progress ~= 0, onSelect = function() TriggerEvent("mdn-extras:client:depoGrapes", data.vat) end},
			}
		}) lib.showContext('winevat')
	end)
end)

RegisterNetEvent("mdn-extras:client:depoGrapes", function(vat)
	local recipes = {}
	for k, v in pairs(Config.Moonshine.WineRecipes) do
		local dStr = (v['mplum'] and QBCore.Shared.Items['mplum'].label..' x'..v['mplum'] or
					v['mgrape'] and QBCore.Shared.Items['mgrape'].label..' x'..v['mgrape'] or
					v['mgrape2'] and QBCore.Shared.Items['mgrape2'].label..' x'..v['mgrape2'] or
					v['mgrape3'] and QBCore.Shared.Items['mgrape3'].label..' x'..v['mgrape3'] or
					v['mgrape4'] and QBCore.Shared.Items['mgrape4'].label..' x'..v['mgrape4'] ).." | Sugar x"..v['sugar'].." | Yeast x"..v['yeast']
		recipes[#recipes+1] = {title = v.label, description = dStr, onSelect = function() TriggerServerEvent("mdn-extras:server:depositGrapes", vat, k) end}
	end
	lib.registerContext({id = 'recipeSelection', title = 'Chose Wine Recipe', canClose = true, options = recipes })
	lib.showContext('recipeSelection')
end)

RegisterNetEvent("mdn-extras:client:checkLowMoonshine", function()
    local progress = 0
	QBCore.Functions.TriggerCallback("mdn-extras:server:moonshineTime", function(time)
		if GlobalState.LowMoonshine ~= 0 then
			local timeRemaining = GlobalState.LowMoonshine+3600 - time --3600
			if timeRemaining > 0 then progress = math.ceil(100 - ((timeRemaining / 3600) * 100)) else progress = 100 end
		end
		lib.registerContext({
			id = 'lowMooshine', title = 'Moonshine Barrel', canClose = true, options = {
				{title = 'Current Fermentation', description = 'Progress : '.. progress.."%", progress = progress, disabled = true},
				{title = 'Take Moonshine', disabled = progress < 100, onSelect = function() TriggerServerEvent("mdn-extras:client:takeLowMoonshine") end},
			}
		}) lib.showContext('lowMooshine')
	end)
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local d = false
local alienEffect = false
function AlienEffect(bool)
    if alienEffect then return else alienEffect = true end
	QBCore.Functions.Notify('You feel really drunk...', 'info', 2500)
    AnimpostfxPlay("DrugsMichaelAliensFightIn", 3.0, 0)
    Wait(math.random(5000, 8000))
    local Ped = PlayerPedId()
    local animDict = "MOVE_M@DRUNK@VERYDRUNK"
    loadAnimDict(animDict)
    SetPedCanRagdoll(Ped, true)
    ShakeGameplayCam('DRUNK_SHAKE', 2.80)
    SetTimecycleModifier("Drunk")
    SetPedMovementClipset(Ped, animDict, 1)
    SetPedMotionBlur(Ped, true)
    SetPedIsDrunk(Ped, true)
    Wait(1500)
    SetPedToRagdoll(Ped, 5000, 1000, 1, 0, 0, 0)
    Wait(13500)
    SetPedToRagdoll(Ped, 5000, 1000, 1, 0, 0, 0)
    Wait(30000)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(Ped, 0)
    SetPedIsDrunk(Ped, false)
    SetPedMotionBlur(Ped, false)
    AnimpostfxStopAll()
    ShakeGameplayCam('DRUNK_SHAKE', 0.0)
    AnimpostfxPlay("DrugsMichaelAliensFight", 3.0, 0)
    Wait(math.random(15000, 20000))
    AnimpostfxPlay("DrugsMichaelAliensFightOut", 3.0, 0)
    AnimpostfxStop("DrugsMichaelAliensFightIn")
    AnimpostfxStop("DrugsMichaelAliensFight")
    AnimpostfxStop("DrugsMichaelAliensFightOut")
    alienEffect = false
	if bool then
		Wait(math.random(10000,20000))
		AlienEffect()
	else d = false end
end

function TipsyEffect()
    if alienEffect then return else alienEffect = true end
	QBCore.Functions.Notify('You feel tipsy...', 'info', 2500)
    AnimpostfxPlay("DrugsMichaelAliensFightIn", 3.0, 0)
    Wait(math.random(1000, 2000))
    local Ped = PlayerPedId()
    local animDict = "MOVE_M@DRUNK@VERYDRUNK"
    loadAnimDict(animDict)
    SetPedCanRagdoll(Ped, true)
    ShakeGameplayCam('DRUNK_SHAKE', 2.80)
    SetTimecycleModifier("Drunk")
    SetPedMovementClipset(Ped, animDict, 1)
    SetPedMotionBlur(Ped, true)
    SetPedIsDrunk(Ped, true)
    Wait(8500)
    SetPedToRagdoll(Ped, 5000, 1000, 1, 0, 0, 0)
    Wait(10000)
    SetPedToRagdoll(Ped, 5000, 1000, 1, 0, 0, 0)
    Wait(6000)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(Ped, 0)
    SetPedIsDrunk(Ped, false)
    SetPedMotionBlur(Ped, false)
    AnimpostfxStopAll()
    ShakeGameplayCam('DRUNK_SHAKE', 0.0)
    AnimpostfxPlay("DrugsMichaelAliensFight", 3.0, 0)
    Wait(math.random(5000, 10000))
    AnimpostfxPlay("DrugsMichaelAliensFightOut", 3.0, 0)
    AnimpostfxStop("DrugsMichaelAliensFightIn")
    AnimpostfxStop("DrugsMichaelAliensFight")
    AnimpostfxStop("DrugsMichaelAliensFightOut")
    alienEffect = false
end

function isDead()
	if LocalPlayer.state.isDead then
		return true
	elseif IsPlayerDead(PlayerId()) then
		return true
	else return false end
end

-- RegisterCommand('setArmor', function()
-- 	SetPedArmour(PlayerPedId(), 0)
-- end)

local wines = {
	['cabalspec'] = function(t)
		if t == "i" then
			QBCore.Functions.Notify('You feel faster and hardened...', 'info', 2500)
			SetPedArmour(PlayerPedId(), (GetPedArmour(PlayerPedId()) + 6))
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.12)
		elseif t == "l" then
			SetPedArmour(PlayerPedId(), (GetPedArmour(PlayerPedId()) + 1))
		elseif t == "e" then
			SetPedArmour(PlayerPedId(), (GetPedArmour(PlayerPedId()) + 6))
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
			Wait(1000)
			print(GetPedArmour(PlayerPedId()))
			TipsyEffect()
		end
	end,
	['uncork'] = function(t)
		if t == "i" then
			QBCore.Functions.Notify('You feel relaxed and vigorous...', 'info', 2500)
			SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 6)
			TriggerServerEvent('hud:server:RelieveStress', 50)
		elseif t == "l" then
			local curHp = GetEntityHealth(PlayerPedId())
			if curHp > 100 and curHp < 200 then
				SetEntityHealth(PlayerPedId(), curHp + 1)
			end
		elseif t == "e" then
			if GetEntityHealth(PlayerPedId()) < 100 then
				SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 6)
			end
			TriggerServerEvent('hud:server:RelieveStress', 50)
			Wait(1000)
			TipsyEffect()
		end
	end,
	['wineotaur'] = function(t)
		if t == "i" then
			QBCore.Functions.Notify('You feel hardened...', 'info', 2500)
			SetPedArmour(PlayerPedId(), (GetPedArmour(PlayerPedId()) + 10))
		elseif t == "l" then
			--TriggerServerEvent('hospital:server:SetArmor', (GetPedArmour(PlayerPedId()) + 1.5))
			SetPedArmour(PlayerPedId(), (GetPedArmour(PlayerPedId()) + 2))
		elseif t == "e" then
			SetPedArmour(PlayerPedId(), (GetPedArmour(PlayerPedId()) + 5))
			Wait(1000)
			TipsyEffect()
		end
	end,
	['grapescape'] = function(t)
		if t == "i" then
			QBCore.Functions.Notify('You feel swift...', 'info', 2500)
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.17)
		elseif t == "e" then
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
			Wait(1000)
			TipsyEffect()
		end
	end,
	['sauvignon'] = function(t)
		if t == "l" then
			if math.random(20) == 1 then
				d = true
				AlienEffect(true)
			end
		elseif t == "e" and not d then
			d = true
			AlienEffect(true)
		end
	end,
}

local WineLoop = function(wine)
	Citizen.CreateThread(function()
		wines[wine]("i")
		Citizen.Wait(500)
		while true do
			wines[wine]("l")
			if not exports['ps-buffs']:HasBuff('wine') then
				Citizen.Wait(500)
				wines[wine]("e")
				break
			end
			if isDead() then break end
			Citizen.Wait(1000)
		end
	end)
end


RegisterNetEvent("mdn-extras:client:drinkWine", function(wine)
	local emote = 'redwineglass'
	if wine == 'uncork' then emote = 'redwineglass'
	elseif wine == 'cabalspec' then emote = 'rosewineglass'
	elseif wine == 'wineotaur' then emote = 'redwineglass'
	elseif wine == 'grapescape' then emote = 'redwineglass'
	elseif wine == 'sauvignon' then emote = 'whitewineglass' end
	ExecuteCommand('e '..emote)
	QBCore.Functions.Progressbar('drinking_wine', 'Drinking Wine', 10000, false, false, { -- 1
	disableMovement = false, disableCarMovement = false, disableMouse = false, disableCombat = true,
	}, {}, {}, {},
	function()
		TriggerEvent("evidence:client:SetStatus", "alcohol", 200)
		DeleteEntity(carry)
		ExecuteCommand('e c')
		--ClearPedTasks(PlayerPedId())
		if not exports['ps-buffs']:HasBuff('wine') then
			exports['ps-buffs']:AddBuff('wine', 100000)
			WineLoop(wine)
		end
	end)
end)


-- Halloween Candies

RegisterNetEvent("mdn-extras:client:eatCandy", function(candy)
	TriggerEvent('animations:client:EmoteCommandStart', {"uncuff"})
	QBCore.Functions.Progressbar('unwrapping', 'Unwrapping Candy...', 1000, false, false, { -- 1
	disableMovement = false, disableCarMovement = false, disableMouse = false, disableCombat = true,
	}, {}, {}, {},
	function()
		ExecuteCommand('e c')
		ClearPedTasks()
		--ClearPedTasks(PlayerPedId())
		if candy == 'hard_candyr' then
			TriggerServerEvent('hud:server:RelieveStress', 8)
		elseif candy == 'hard_candyg' then
			SetPedArmour(PlayerPedId(), (GetPedArmour(PlayerPedId()) + 3))
		elseif candy == 'candy_corn' then
			exports['ps-buffs']:AddBuff('stamina', 1500)
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
			Wait(1500)
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
		elseif candy == 'purple_sweets' then
			SetPlayerStamina(PlayerId(), GetPlayerStamina(PlayerId()) + 10)
			SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId())+ math.random(1,3))
		end
	end)
end)
