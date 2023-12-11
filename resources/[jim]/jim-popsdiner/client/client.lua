local Targets, Props, Blips, CraftLock, Ped = {}, {}, {}, false, nil

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() QBCore.Functions.GetPlayerData(function(PlayerData) PlayerJob = PlayerData.job onDuty = PlayerJob.onduty end) Ped = PlayerPedId() end)
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo) PlayerJob = JobInfo onDuty = PlayerJob.onduty end)
RegisterNetEvent('QBCore:Client:SetDuty', function(duty) onDuty = duty end)
AddEventHandler('onResourceStart', function(r) if GetCurrentResourceName() ~= r then return end QBCore.Functions.GetPlayerData(function(PlayerData) PlayerJob = PlayerData.job onDuty = PlayerJob.onduty end) Ped = PlayerPedId() end)

CreateThread(function()
	local loc = Config.Locations[1]
	local bossroles = {}
	if not QBCore.Shared.Jobs[loc.job] then print("^1Error^7: ^1Stopping Script^7. ^2Can't find the job ^7'^6"..loc.job.."^7' ^2in ^6QBCore^7.^6Shared^7.^6Jobs^7") return end
	for grade in pairs(QBCore.Shared.Jobs[loc.job].grades) do
		if QBCore.Shared.Jobs[loc.job].grades[grade].isboss == true then
			if bossroles[loc.job] ~= nil then
				if bossroles[loc.job] > tonumber(grade) then bossroles[loc.job] = tonumber(grade) end
			else bossroles[loc.job] = tonumber(grade) end
		end
	end
	if loc.zoneEnable then
		if loc.zones then
			JobLocation = PolyZone:Create(loc.zones, { name = loc.label, debugPoly = Config.Debug })
			JobLocation:onPlayerInOut(function(isPointInside)
				if PlayerJob.name == loc.job then
					if loc.autoClock and loc.autoClock.enter then if isPointInside and not onDuty then TriggerServerEvent("QBCore:ToggleDuty") end end
					if loc.autoClock and loc.autoClock.exit then if not isPointInside and onDuty then TriggerServerEvent("QBCore:ToggleDuty") end end
				end
			end)
		end
	end
	if loc.blip then Blips[#Blips+1] = makeBlip({ coords = loc.blip, sprite = loc.blipsprite, col = loc.blipcolor, scale = loc.blipscale, disp = loc.blipdisp, category = loc.blipcat, name = loc.label }) end

	Props[#Props+1] = makeProp({prop = "prop_atm_01", coords = vec4(1580.31, 6455.34, 24.29, 335.0)}, 1, 0)
	Props[#Props+1] = makeProp({prop = "bkr_prop_fakeid_clipboard_01a", coords = vec4(1594.12, 6456.05, 26.01+0.07, 314.0)}, 1, 0)

	CreateModelHide(vec3(1593.85, 6455.37, 26.01), 1.5, 1251246798, true)
	
	Targets["PopCounter"] =
		exports['qb-target']:AddBoxZone("PopCounter", vector3(2533.91, 2586.92, 38.71), 0.4, 0.6, { name="PopCounter", heading = 331.0, debugPoly=Config.Debug, minZ = 36.01, maxZ = 38.51, },
			{ options = { { event = "jim-popsdiner:Stash", icon = "fas fa-hamburger", label = Loc[Config.Lan].targetinfo["open_counter"], stash = "RexCounter1" }, }, distance = 2.0 })
	--Targets["PopCounter2"] =
	--	exports['qb-target']:AddBoxZone("PopCounter2", vec3(1590.37, 6455.31, 26.01), 0.4, 0.6, { name="PopCounter2", heading = 336.0, debugPoly=Config.Debug, minZ = 26.01, maxZ = 26.51, },
	--		{ options = { { event = "jim-popsdiner:Stash", icon = "fas fa-hamburger", label = Loc[Config.Lan].targetinfo["open_counter"], stash = "PopCounter2" }, }, distance = 2.0 })
	--Targets["PopCounter3"] =
	--	exports['qb-target']:AddBoxZone("PopCounter3", vec3(1593.6, 6453.82, 26.01), 0.4, 0.6, { name="PopCounter3", heading = 336.0, debugPoly=Config.Debug, minZ = 26.01, maxZ = 26.51, },
	--		{ options = { { event = "jim-popsdiner:Stash", icon = "fas fa-hamburger", label = Loc[Config.Lan].targetinfo["open_counter"], stash = "PopCounter3" }, },  distance = 2.0 })


	Targets["PopTable1"] =
		exports['qb-target']:AddBoxZone("PopTable1", vector3(2533.66, 2593.07, 38.31), 1.5, 0.7, { name="PopTable1", heading = 335.0, debugPoly=Config.Debug, minZ = 36.81, maxZ = 38.61, },
			{ options = { { event = "jim-popsdiner:Stash", icon = "fas fa-hamburger", label = Loc[Config.Lan].targetinfo["open_counter"], stash = "Table1" }, },  distance = 2.0 })
	Targets["PopTable2"] =
		exports['qb-target']:AddBoxZone("PopTable2", vec3(1591.0, 6451.68, 25.61), 1.5, 0.7, { name="PopTable2", heading = 335.0, debugPoly=Config.Debug, minZ = 25.81, maxZ = 26.61, },
			{ options = { { event = "jim-popsdiner:Stash", icon = "fas fa-hamburger", label = Loc[Config.Lan].targetinfo["open_counter"], stash = "Table2" }, },  distance = 2.0 })
	Targets["PopTable3"] =
		exports['qb-target']:AddBoxZone("PopTable3", vec3(1589.18, 6452.53, 25.61), 1.5, 0.7, { name="PopTable3", heading = 335.0, debugPoly=Config.Debug, minZ = 25.81, maxZ = 26.61, },
			{ options = { { event = "jim-popsdiner:Stash", icon = "fas fa-hamburger", label = Loc[Config.Lan].targetinfo["open_counter"], stash = "Table3" }, },  distance = 2.0 })
	Targets["PopTable4"] =
		exports['qb-target']:AddBoxZone("PopTable4", vec3(1587.39, 6453.38, 25.61), 1.5, 0.7, { name="PopTable4", heading = 335.0, debugPoly=Config.Debug, minZ = 25.81, maxZ = 26.61, },
			{ options = { { event = "jim-popsdiner:Stash", icon = "fas fa-hamburger", label = Loc[Config.Lan].targetinfo["open_counter"], stash = "Table4" }, },  distance = 2.0 })
	Targets["PopTable5"] =
		exports['qb-target']:AddBoxZone("PopTable5", vec3(1585.58, 6454.25, 25.61), 1.5, 0.7, { name="PopTable5", heading = 335.0, debugPoly=Config.Debug, minZ = 25.81, maxZ = 26.61, },
			{ options = { { event = "jim-popsdiner:Stash", icon = "fas fa-hamburger", label = Loc[Config.Lan].targetinfo["open_counter"], stash = "Table5" }, },  distance = 2.0 })
	Targets["PopTable6"] =
		exports['qb-target']:AddBoxZone("PopTable6", vec3(1585.58, 6454.25, 25.61), 1.5, 0.7, { name="PopTable6", heading = 335.0, debugPoly=Config.Debug, minZ = 25.81, maxZ = 26.61, },
			{ options = { { event = "jim-popsdiner:Stash", icon = "fas fa-hamburger", label = Loc[Config.Lan].targetinfo["open_counter"], stash = "Table6" }, },  distance = 2.0 })
	Targets["PopTable7"] =
		exports['qb-target']:AddBoxZone("PopTable7", vec3(1581.95, 6455.93, 25.61), 1.5, 0.7, { name="PopTable7", heading = 335.0, debugPoly=Config.Debug, minZ = 25.81, maxZ = 26.61, },
			{ options = { { event = "jim-popsdiner:Stash", icon = "fas fa-hamburger", label = Loc[Config.Lan].targetinfo["open_counter"], stash = "Table7" }, },  distance = 2.0 })


	Targets["PopReceipt"] =
		exports['qb-target']:AddBoxZone("PopReceipt", vector3(2536.76, 2586.91, 37.88), 0.6, 0.6, { name="PopReceipt", heading = 180.0, debugPoly=Config.Debug, minZ = 36.01, maxZ = 37.81, },
			{ options = {
				{ event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = Loc[Config.Lan].targetinfo["charge_customer"], job = loc.job },
				{ type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = Loc[Config.Lan].targetinfo["toggle_duty"], job = loc.job },
				{ event = "qb-bossmenu:client:OpenMenu", icon = "fas fa-list", label = Loc[Config.Lan].targetinfo["open_bossmenu"], job = bossroles }, },
					distance = 2.0 })
	--Targets["PopReceipt2"] =
	--	exports['qb-target']:AddBoxZone("PopReceipt2", vec3(1595.32, 6455.37, 26.01), 0.6, 0.6, { name="PopReceipt2", heading = 50.0, debugPoly=Config.Debug, minZ = 26.01, maxZ = 26.81, },
	--		{ options = {
	--			{ event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = Loc[Config.Lan].targetinfo["charge_customer"], job = loc.job },
	--			{ type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = Loc[Config.Lan].targetinfo["toggle_duty"], job = loc.job },
	--			{ event = "qb-bossmenu:client:OpenMenu", icon = "fas fa-list", label = Loc[Config.Lan].targetinfo["open_bossmenu"], job = bossroles }, },
	--				distance = 2.0 })

	Targets["PopCoffee"] =
	exports['qb-target']:AddBoxZone("PopCoffee", vector3(2534.22, 2584.68, 38.5), 0.6, 1.4, { name="PopCoffee", heading = 180.0, debugPoly=Config.Debug, minZ = 36.01, maxZ = 38.01, },
		{ options = { { event = "jim-popsdiner:Crafting", icon = "fas fa-mug-hot", label = Loc[Config.Lan].targetinfo["pour_coffee"], job = loc.job, craftable = Crafting.Coffee, header = Loc[Config.Lan].menu["coffee_menu"], coords = vec3(1592.6, 6456.8, 26.01),
		}, }, distance = 2.0 })

	--Targets["PopClockin"] =
	--exports['qb-target']:AddBoxZone("PopClockin", vec3(1594.12, 6456.05, 26.01), 0.6, 0.6, { name="PopClockin", heading = 325.0, debugPoly=Config.Debug, minZ = 25.81, maxZ = 26.61, },
	--	{ options = { { type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = Loc[Config.Lan].targetinfo["toggle_duty"], job = loc.job },
	--				{ event = "qb-bossmenu:client:OpenMenu", icon = "fas fa-list", label = Loc[Config.Lan].targetinfo["open_bossmenu"], job = bossroles },
	--				}, distance = 2.0 })
	Targets["PopOven"] =
		exports['qb-target']:AddBoxZone("PopOven", vector3(2540.91, 2582.33, 37.45), 0.6, 0.8, { name="PopOven", heading = 266.0, debugPoly=Config.Debug, minZ = 36.81, maxZ = 38.61, },
			{ options = { { event = "jim-popsdiner:Crafting", icon = "fas fa-temperature-high", label = Loc[Config.Lan].targetinfo["use_griddle"], job = loc.job, craftable = Crafting.Oven, header = Loc[Config.Lan].menu["griddle_menu"], coords = vec3(1587.94, 6459.02, 26.01)
		}, }, distance = 2.0 })
		Targets["PopOven"] =
		exports['qb-target']:AddBoxZone("PopOven", vector3(2540.82, 2581.39, 38.00), 0.6, 0.8, { name="PopOven", heading = 267.0, debugPoly=Config.Debug, minZ = 36.81, maxZ = 38.0, },
			{ options = { { event = "jim-popsdiner:Crafting", icon = "fas fa-temperature-high", label = Loc[Config.Lan].targetinfo["use_griddle"], job = loc.job, craftable = Crafting.Oven, header = Loc[Config.Lan].menu["griddle_menu"], coords = vec3(1587.94, 6459.02, 26.01)
		}, }, distance = 2.0 })
	Targets["PopBoard"] =
		exports['qb-target']:AddBoxZone("PopBoard", vector3(2537.4, 2580.77, 37.47), 0.4, 0.6, { name="PopBoard", heading = 155.0, debugPoly=Config.Debug, minZ = 36.81, maxZ = 38.61, },
			{ options = { { event = "jim-popsdiner:Crafting", icon = "fas fa-utensils", label = Loc[Config.Lan].targetinfo["use_chopping_board"], job = loc.job, craftable = Crafting.ChoppingBoard, header = Loc[Config.Lan].menu["chopping_board"], coords = vector3(2540.91, 2582.33, 38.45),
		}, }, distance = 2.0 })
	Targets["PopDrinks"] =
		exports['qb-target']:AddBoxZone("PopDrinks", vector3(2536.02, 2584.73, 38.59), 0.6, 1.1, { name="PopDrinks", heading = 360.0, debugPoly=Config.Debug, minZ = 36.01, maxZ = 38.01, },
			{ options = { { event = "jim-popsdiner:Crafting", icon = "fas fa-beer", label = Loc[Config.Lan].targetinfo["use_drinks_machine"], job = loc.job, craftable = Crafting.Soda, header = Loc[Config.Lan].menu["drinks_dispenser"], coords = vec3(1586.03, 6459.62, 26.01),
		}, }, distance = 2.0 })
end)

RegisterNetEvent('jim-popsdiner:Crafting:MakeItem', function(data)
	if not CraftLock then CraftLock = true else return end
	local bartext = ""
	if data.header == Loc[Config.Lan].menu["griddle_menu"] then
		bartext = Loc[Config.Lan].progress["making"] bartime = 7000 animDictNow = "anim@heists@prison_heiststation@cop_reactions" animNow = "cop_b_idle"
	elseif data.header == Loc[Config.Lan].menu["chopping_board"] then
		bartext = Loc[Config.Lan].progress["pouring"] bartime = 5000 animDictNow = "amb@prop_human_bbq@male@base" animNow = "base"
	elseif data.header == Loc[Config.Lan].menu["drinks_dispenser"] or data.header == Loc[Config.Lan].menu["coffee_menu"] then
		bartext = Loc[Config.Lan].progress["pouring"] bartime = 3000
		animDictNow = "mp_ped_interaction" animNow = "handshake_guy_a"
	end
	if (data.amount and data.amount ~= 1) then data.craft["amount"] = data.amount
		for k, v in pairs(data.craft[data.item]) do	data.craft[data.item][k] *= data.amount	end
		bartime *= data.amount bartime *= 0.9
	end
	local cam = createTempCam(PlayerPedId(), data.coords)
	CreateThread(function() while CraftLock do playAnim(animDictNow, animNow, bartime, 32) Wait(GetAnimDuration(animDictNow, animNow)*1000) end stopAnim(animDictNow, animNow) end)
	if progressBar({ label = bartext..QBCore.Shared.Items[data.item].label, time = bartime, cancel = true, dict = animDictNow, anim = animNow, flag = 32, icon = data.item, cam = cam }) then
		CraftLock = false
		TriggerServerEvent('jim-popsdiner:Crafting:GetItem', data.item, data.craft)
		Wait(500)
		TriggerEvent("jim-popsdiner:Crafting", data)
	else
		CraftLock = false
		TriggerEvent('inventory:client:busy:status', false)
	end
	ClearPedTasks(Ped)
end)

RegisterNetEvent('jim-popsdiner:Crafting', function(data)
	if CraftLock then return end
	if not jobCheck() then return end
	local Menu = {}
	if Config.Menu == "qb" then
		Menu[#Menu + 1] = { header = data.header, txt = "", isMenuHeader = true }
		Menu[#Menu + 1] = { icon = "fas fa-circle-xmark", header = "", txt = Loc[Config.Lan].menu["close"], params = { event = "" } }
	end
	for i = 1, #data.craftable do
		for k, v in pairs(data.craftable[i]) do
			if not QBCore.Shared.Items[k] then print("^5Debug^7: ^2Item not found in server^7: '^6"..k.."^7'") else
				if k ~= "amount" then
					local canShow, disable, setheader, settext, checktable = true, false, "", "", {}
					for l, b in pairs(data.craftable[i][tostring(k)]) do
						if not QBCore.Shared.Items[l] then
							print("^5Debug^7: ^3Ingredient Item^2 not found in server^7: '^6"..l.."^7'") canShow = false
						else
							settext = settext..QBCore.Shared.Items[l].label..(b > 1 and " x"..b or "")..(Config.Menu == "ox" and "\n" or "<br>")
							checktable[l] = HasItem(l, b)
						end
					end
					if canShow then
						for _, v in pairs(checktable) do if v == false then disable = true break end end
						setheader = QBCore.Shared.Items[k].label..(not disable and " ✔️" or "")
						local event = "jim-popsdiner:Crafting:MakeItem"
						if Config.MultiCraft then event = "jim-popsdiner:Crafting:MultiCraft" end
						Menu[#Menu + 1] = {
							disabled = disable,
							icon = "nui://"..Config.img..QBCore.Shared.Items[tostring(k)].image,
							header = setheader, txt = settext, --qb-menu
							params = { event = event, args = { item = k, craft = data.craftable[i], craftable = data.craftable, header = data.header, coords = data.coords } }, -- qb-menu
							title = setheader, description = settext, -- ox_lib
							event = event, args = { item = k, craft = data.craftable[i], craftable = data.craftable, header = data.header, coords = data.coords }, -- ox_lib
						}
					end
				end
			end
		end
	end
	if Config.Menu == "ox" then exports.ox_lib:registerContext({id = 'Crafting', title = data.header, position = 'top-right', options = Menu }) exports.ox_lib:showContext("Crafting")
	elseif Config.Menu == "qb" then exports['qb-menu']:openMenu(Menu) end
	lookEnt(data.coords)
end)

RegisterNetEvent('jim-popsdiner:Crafting:MultiCraft', function(data)
    local success = Config.MultiCraftAmounts local Menu = {}
    for k in pairs(success) do success[k] = true
        for l, b in pairs(data.craft[data.item]) do
            local has = HasItem(l, (b * k)) if not has then success[k] = false break else success[k] = true end
		end end
    if Config.Menu == "qb" then Menu[#Menu + 1] = { header = data.header, txt = "", isMenuHeader = true } end
	Menu[#Menu + 1] = { icon = "fas fa-arrow-left", title = Loc[Config.Lan].menu["back"], header = "", txt = Loc[Config.Lan].menu["back"], params = { event = "jim-popsdiner:Crafting", args = data }, event = "jim-popsdiner:Crafting", args = data }
	for k in pairsByKeys(success) do
		Menu[#Menu + 1] = {
			disabled = not success[k],
			icon = "nui://"..Config.img..QBCore.Shared.Items[data.item].image, header = QBCore.Shared.Items[data.item].label.." [x"..k.."]", title = QBCore.Shared.Items[data.item].label.." [x"..k.."]",
			event = "jim-popsdiner:Crafting:MakeItem", args = { item = data.item, craft = data.craft, craftable = data.craftable, header = data.header, anim = data.anim, amount = k, coords = data.coords },
			params = { event = "jim-popsdiner:Crafting:MakeItem", args = { item = data.item, craft = data.craft, craftable = data.craftable, header = data.header, anim = data.anim, amount = k, coords = data.coords } }
		}
	end
	if Config.Menu == "ox" then exports.ox_lib:registerContext({id = 'Crafting', title = data.header, position = 'top-right', options = Menu })	exports.ox_lib:showContext("Crafting")
	elseif Config.Menu == "qb" then exports['qb-menu']:openMenu(Menu) end
end)

--[[STASH SHOPS]]--
RegisterNetEvent('jim-popsdiner:Shop', function(data)
	if not jobCheck() then return end
	local event = "inventory:server:OpenInventory"
	if Config.JimShop then event = "jim-shops:ShopOpen"
	elseif Config.Inv == "ox" then exports.ox_inventory:openInventory('shop', { type = data.shopname }) end
	TriggerServerEvent(event, "shop", "popsdiner", data.shop)
	lookEnt(data.coords)
end)

RegisterNetEvent('jim-popsdiner:Stash', function(data)
	if data.job and not jobCheck() then return end
	if Config.Inv == "ox" then exports.ox_inventory:openInventory('stash', "popsdiner_"..data.stash)
	else TriggerEvent("inventory:client:SetCurrentStash", "popsdiner_"..data.stash)
	TriggerServerEvent("inventory:server:OpenInventory", "stash", "popsdiner_"..data.stash)	end
	lookEnt(data.coords)
end)

-- [[CONSUME]] --
local function ConsumeSuccess(itemName, type)
    ExecuteCommand("e c")
    toggleItem(false, itemName, 1)
	local change = { thirst = QBCore.Shared.Items[itemName].thirst, hunger = QBCore.Shared.Items[itemName].hunger }
    if change.hunger then
        TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + change.hunger)
        TriggerServerEvent("consumables:server:addHunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + change.hunger)
    end
    if change.thirst then
        TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + change.thirst)
        TriggerServerEvent("consumables:server:addThirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + change.thirst)
    end
    if type == "alcohol" then alcoholCount += 1
        if alcoholCount > 1 and alcoholCount < 4 then TriggerEvent("evidence:client:SetStatus", "alcohol", 200) elseif alcoholCount >= 4 then TriggerEvent("evidence:client:SetStatus", "heavyalcohol", 200) AlienEffect() end
    end
    if Config.RewardItem == itemName then toggleItem(true, Config.RewardPool[math.random(1, #Config.RewardPool)], 1) end
end

RegisterNetEvent('jim-popsdiner:client:Consume', function(itemName, type)
	local emoteTable = {
		["sprunk"] = "sprunk", ["sprunklight"] = "sprunk",
		["ecola"] = "ecola", ["ecolalight"] = "ecola",
		["bltsandwich"] = "sandwich", ["cheesesandwich"] = "sandwich", ["eggsandwich"] = "sandwich", ["grilledwrap"] = "sandwich", ["hamcheesesandwich"] = "sandwich",
		["hamsandwich"] = "sandwich", ["ranchwrap"] = "sandwich", ["tunasandwich"] = "sandwich", ["veggiewrap"] = "sandwich",
		["popdonut"] = "donut",
	}
	local progstring, defaultemote = Loc[Config.Lan].progress["drinking"], "drink"
	if type == "food" then progstring = Loc[Config.Lan].progress["eating"] defaultemote = "burger" end
	ExecuteCommand("e "..(emoteTable[itemName] or defaultemote))
	if progressBar({label = progstring..QBCore.Shared.Items[itemName].label.."..", time = math.random(3000, 6000), cancel = true, icon = itemName}) then
		ConsumeSuccess(itemName, type)
	else
		ExecuteCommand("e c")
	end
end)

AddEventHandler('onResourceStop', function(r) if r ~= GetCurrentResourceName() then return end
	if GetResourceState("qb-target") == "started" or GetResourceState("ox_target") == "started" then
		for _, v in pairs(Props) do	DeleteEntity(v) end
		for k in pairs(Targets) do exports['qb-target']:RemoveZone(k) end
	end
end)