local Targets = {}
local Peds = {}
local Blip = {}

if Config.CoreOptions.Menu == "jim-menu" then Config.CoreOptions.img = "" end

--[[
  _____     ____
 |  __ \   / __ \
 | |  | | | |  | |
 | |  | | | |  | |
 | |__| | | |__| |
 |_____/   \____/  _______
 | \ | |  / __ \  |__   __|
 |  \| | | |  | |    | |
 | . ` | | |  | |    | |
 | |\  | | |__| |    | |
 |_|_\_|_ \____/_    |_|  _    _____   _    _
 |__   __|  / __ \  | |  | |  / ____| | |  | |
    | |    | |  | | | |  | | | |      | |__| |
    | |    | |  | | | |  | | | |      |  __  |
    | |    | |__| | | |__| | | |____  | |  | |
    |_|     \____/   \____/   \_____| |_|  |_|


--]]


CreateThread(function()
		for k, v in ipairs(Config.PedLocations) do
			Peds[#Peds+1] = makePed(v.model, v.coords, 1, 1, v.scenario)
			if v.blipTrue then Blip[#Blip+1] = makeBlip(v) end
			local options = {  }
			if v.farmsell then
				options[#options+1] = { job = Config.ScriptOptions.Job, event = "jixel-farming:FarmSell", icon = "fas fa-tractor", label = v.name, ped = Peds[#Peds], }
			end
			if Config.ScriptOptions.Job ~= nil then
				options[#options+1] = { event = "jixel-farming:client:JobMenu", icon = "fas fa-tractor", label = Loc[Config.CoreOptions.Lan].target["getjob"], ped = Peds[#Peds], }
			end
			if v.cayoped then
				options[#options+1] = { job = Config.ScriptOptions.Job, event = "jixel-farming:client:jobmenu", icon = "fas fa-tractor", label = v.name, ped = Peds[#Peds], }
			end
			if v.chickenped then
				options[#options+1] = { job = Config.ScriptOptions.Job, event = "jixel-farming:client:ChickyGameMenu", icon = "fas fa-tractor", label = v.name, ped = Peds[#Peds], }
			end
			if v.pigped then
				options[#options+1] = { job = Config.ScriptOptions.Job, event = "jixel-farming:client:PigGameMenu", icon = "fas fa-tractor", label = v.name, ped = Peds[#Peds], }
			end
			if v.cowped then
				options[#options+1] = { job = Config.ScriptOptions.Job, event = "jixel-farming:client:CowGameMenu", icon = "fas fa-tractor", label = v.name, ped = Peds[#Peds], }
			end
			Targets["Peds"..k] =
				exports['qb-target']:AddCircleZone("Peds"..k, v.coords.xyz, 1.2, { name="Peds"..k, debugPoly=Config.DebugOptions.Debug, useZ=true, },
			{ options = options, distance = 2.0 })
		end
end)

----Menu
RegisterNetEvent('jixel-farming:client:JobMenu', function()
	local JobMenu = {}
	if Config.CoreOptions.Menu ~= "ox" then
		JobMenu[#JobMenu+1] = { icon = "fas fa-tractor", header = Loc[Config.CoreOptions.Lan].menu["header_farm"], isMenuHeader = true, }
		JobMenu[#JobMenu+1] = { icon = "fas fa-circle-xmark", header = Loc[Config.CoreOptions.Lan].menu["close"], params = { event = "qb-menu:client:closeMenu" } }
	end
	JobMenu[#JobMenu+1] = { icon = "fab fa-hire-a-helper",
	header = Loc[Config.CoreOptions.Lan].menu["getjob"], txt = Loc[Config.CoreOptions.Lan].menutxt["farmer_help"], params = { isServer = true, event = "jixel-farming:server:GetJob", },
	title = Loc[Config.CoreOptions.Lan].menu["getjob"], description = Loc[Config.CoreOptions.Lan].menutxt["farmer_help"], serverEvent = "jixel-farming:server:GetJob",
	}
	JobMenu[#JobMenu+1] = { icon = "fas fa-clock",
	header = Loc[Config.CoreOptions.Lan].menu["clockon"], txt = Loc[Config.CoreOptions.Lan].menutxt["clock_on"], params = { isServer = true, event = "QBCore:ToggleDuty", },
	title = Loc[Config.CoreOptions.Lan].menu["clockon"], description = Loc[Config.CoreOptions.Lan].menutxt["clock_on"], serverEvent = "QBCore:ToggleDuty",
	}
	JobMenu[#JobMenu+1] = { icon = "fas fa-x",
		header = Loc[Config.CoreOptions.Lan].menu["quit"], txt = Loc[Config.CoreOptions.Lan].menutxt["farmer_quit"], params = { isServer = true , event = 'jixel-farming:server:RemoveJob', },
		title = Loc[Config.CoreOptions.Lan].menu["quit"], description = Loc[Config.CoreOptions.Lan].menutxt["farmer_quit"], serverEvent = 'jixel-farming:server:RemoveJob',
	}
	if Config.CoreOptions.Menu == "ox" then	exports.ox_lib:registerContext({id = 'Crafting', title = Loc[Config.CoreOptions.Lan].menu["header_farm"], position = 'top-right', options = JobMenu })	exports.ox_lib:showContext("Crafting")
	else exports['qb-menu']:openMenu(JobMenu) end
end)

RegisterNetEvent('jixel-farming:SellAnim', function(data)
	if not HasItem(data.item, 1) then triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["donthave"].." "..QBCore.Shared.Items[data.item].label, "error") return end
	loadAnimDict("mp_common")
	TriggerServerEvent('jixel-farming:Selling', data) -- Had to slip in the sell command during the animation command
	loadAnimDict("mp_common")
	lookEnt(data.ped)
	TaskPlayAnim(PlayerPedId(), "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 1, 0.2, 0, 0, 0)	--Start animations
	Wait(2000)
	StopAnimTask(PlayerPedId(), "mp_common", "givetake2_a", 1.0)
	unloadAnimDict("mp_common")
	if data.sub then TriggerEvent('jixel-farming:FarmSell:Sub', { sub = data.sub, ped = data.ped }) return
	else TriggerServerEvent('jixel-farming:Selling', data) return end
end)

RegisterNetEvent('jixel-farming:FarmSell', function(data)
    SellMain = {}
	if Config.CoreOptions.Menu ~= "ox" then
        SellMain[#SellMain+1] = { header = Loc[Config.CoreOptions.Lan].menu["Farm_Buyer"], txt = Loc[Config.CoreOptions.Lan].info["sell_items"], isMenuHeader = true }
        SellMain[#SellMain+1] = { icon = "fas fa-circle-xmark", header = Loc[Config.CoreOptions.Lan].menu["close"], txt = "", params = { event = "jixel-farming:CraftMenu:Close"} }
	end
    local categories = {}
    for item, details in pairs(SellItems) do if not categories[details.category] then categories[details.category] = {} end
	categories[details.category] = item
    end
    for category, items in pairs(categories) do
        SellMain[#SellMain+1] = {
            icon = "fas fa-angle-right",
            header = category, txt = Loc[Config.CoreOptions.Lan].info["see_options"],
            title = category, description = Loc[Config.CoreOptions.Lan].info["see_options"],
            params = { event = "jixel-farming:FarmSell:Sub", args = { sub = category, ped = data.ped } },
            event = "jixel-farming:FarmSell:Sub", args = { sub = category, ped = data.ped }
		}
    end
    if #SellMain == 2 then return end
	if Config.CoreOptions.Menu == "ox" then	exports.ox_lib:registerContext({id = 'Crafting', title = "Farm Job Menu", position = 'top-right', options = SellMain })	exports.ox_lib:showContext("Crafting")
	else exports['qb-menu']:openMenu(SellMain) end
end)


--FARM Selling - Sub Menu Controller
RegisterNetEvent('jixel-farming:FarmSell:Sub', function(data)
	local list = {}
	local sellMenu = {}
	if Config.CoreOptions.Menu ~= "ox" then
		sellMenu[#sellMenu+1] = { header = Loc[Config.CoreOptions.Lan].menu["Farm_Buyer"], txt = Loc[Config.CoreOptions.Lan].info["sell_items"], isMenuHeader = true }
	end

	sellMenu[#sellMenu+1] = { icon = "fas fa-circle-arrow-left",
		header = Loc[Config.CoreOptions.Lan].info["return"], params = { event = "jixel-farming:FarmSell", args = data },
		title = Loc[Config.CoreOptions.Lan].info["return"], event = "jixel-farming:FarmSell", args = data,
	}
	for item, details in pairs(SellItems) do if data.sub == details.category then list[#list+1] = item end end
	if #list == 0 then return end
	for _, v in pairs(list) do
		local disable = true
		local setheader = QBCore.Shared.Items[v].label
		if HasItem(v, 1) then setheader = setheader.." 💰" disable = false end
		sellMenu[#sellMenu+1] = {
			disabled = disable,
			icon = "nui://"..Config.CoreOptions.img..QBCore.Shared.Items[v].image, header = setheader,
			txt = Loc[Config.CoreOptions.Lan].info["sell_all"].." "..SellItems[v].price.." "..Loc[Config.CoreOptions.Lan].info["sell_each"],
			params = { event = "jixel-farming:SellAnim", args = { item = v, sub = data.sub, ped = data.ped } },
			title = QBCore.Shared.Items[v].label,
			description = Loc[Config.CoreOptions.Lan].info["sell_all"].." "..SellItems[v].price.." "..Loc[Config.CoreOptions.Lan].info["sell_each"],
			event = "jixel-farming:SellAnim", args = { item = v, sub = data.sub, ped = data.ped }
		}
		Wait(0)
	end
    if #sellMenu == 2 then return end
	if Config.CoreOptions.Menu == "ox" then	exports.ox_lib:registerContext({id = 'Crafting', title = "Farm Job Menu", position = 'top-right', options = sellMenu })	exports.ox_lib:showContext("Crafting")
	else exports['qb-menu']:openMenu(sellMenu) end
end)

AddEventHandler('onResourceStop', function(r) if r ~= GetCurrentResourceName() then return end
	for _, v in pairs(Peds) do unloadPed(GetEntityModel(v)) DeletePed(v) end
    for k in pairs(Targets) do exports['qb-target']:RemoveZone(k) end
    exports[Config.CoreOptions.CoreName]:HideText()
end)

