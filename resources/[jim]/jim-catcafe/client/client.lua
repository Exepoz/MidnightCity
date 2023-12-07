local QBCore = exports[Config.Core]:GetCoreObject()
RegisterNetEvent('QBCore:Client:UpdateObject', function() QBCore = exports[Config.Core]:GetCoreObject() end)

local Targets, Props, Blips, CraftLock, alcoholCount = {}, {}, {}, false, 0
PlayerJob = {}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() QBCore.Functions.GetPlayerData(function(PlayerData) PlayerJob = PlayerData.job if PlayerData.job.onduty then if PlayerData.job.name == Config.Locations[1].job then TriggerServerEvent("QBCore:ToggleDuty") end end end) end)
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo) PlayerJob = JobInfo onDuty = PlayerJob.onduty end)
RegisterNetEvent('QBCore:Client:SetDuty', function(duty) onDuty = duty end)
AddEventHandler('onResourceStart', function(r) if GetCurrentResourceName() ~= r then return end
	QBCore.Functions.GetPlayerData(function(PlayerData) PlayerJob = PlayerData.job if PlayerData.job.onduty then if PlayerData.job.name == Config.Locations[1].job then TriggerServerEvent("QBCore:ToggleDuty") end end end)
end)


CreateThread(function()
	local loc = Config.Locations[1]
	local bossroles = {}
	if not QBCore.Shared.Jobs[loc.job] then print("^1Error^7: ^1Stopping Script^7. ^2Can't find the job ^7'^6"..loc.job.."^7' ^2in ^6QBCore^7.^6Shared^7.^6Jobs^7") return end
	for grade in pairs(QBCore.Shared.Jobs[loc.job].grades) do
		if QBCore.Shared.Jobs[loc.job].grades[grade].isboss == true then
			if bossroles[loc.job] then
				if bossroles[loc.job] > tonumber(grade) then bossroles[loc.job] = tonumber(grade) end
			else bossroles[loc.job] = tonumber(grade) end
		end
	end
	if loc.zoneEnable then
		JobLocation = PolyZone:Create(loc.zones, { name = loc.label, debugPoly = Config.Debug })
		JobLocation:onPlayerInOut(function(isPointInside)
			if PlayerJob.name == loc.job then
				if loc.autoClock and loc.autoClock.enter then if isPointInside and not onDuty then TriggerServerEvent("QBCore:ToggleDuty") end end
				if loc.autoClock and loc.autoClock.exit then if not isPointInside and onDuty then TriggerServerEvent("QBCore:ToggleDuty") end end
			end
		end)
	end

	if Config.Locations[1].blip then makeBlip({ coords = loc.blip, sprite = loc.blipsprite, col = loc.blipcolor, scale = loc.blipscale, disp = loc.blipdiosp, category = loc.blipcat, name = loc.label }) end

	--Stashes
	Targets["CatPrepared"] =
		exports['qb-target']:AddBoxZone("CatPrepared", vec3(-587.4, -1059.6, 23.45-2), 2.0, 2.5, { name="CatPrepared", heading = 270.0, debugPoly=Config.Debug, minZ=21.45, maxZ=23.45 },
			{ options = { {  event = "jim-catcafe:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["food"], job = loc.job, stash = "Shelf", coords = vec3(-587.4, -1059.6, 23.45), }, },  distance = 2.0 })
	--FRIDGE
	Targets["CatFridge"] =
		exports['qb-target']:AddBoxZone("CatFridge", vec3(-588.06, -1067.1, 22.34-1), 3.5, 1.0, { name="CatFridge", heading = 0, debugPoly=Config.Debug, minZ=19.84, maxZ=22.84 },
			{ options = { {  event = "jim-catcafe:Stash", icon = "fas fa-temperature-low", label = Loc[Config.Lan].target["fridge"], stash = "Fridge", job = loc.job, coords = vec3(-588.06, -1067.1, 22.34), }, }, distance = 1.0 })
	Targets["CatFridge2"] =
		exports['qb-target']:AddBoxZone("CatFridge2", vec3(-590.67, -1068.1, 22.34-1), 2.0, 0.6, { name="CatFridge2", heading = 0, debugPoly=Config.Debug, minZ=19.84, maxZ=22.84 },
			{ options = { {  event = "jim-catcafe:Stash", icon = "fas fa-temperature-low", label = Loc[Config.Lan].target["fridge"], stash = "Fridge2", job = loc.job, coords = vec3(-590.67, -1068.1, 22.34), }, }, distance = 1.0 })
	--WARESTORAGE
	Targets["CatStorage"] =
	exports['qb-target']:AddBoxZone("CatStorage", vec3(-598.0, -1068.47, 22.34-1), 4.0, 1.5, { name="CatStorage", heading = 90, debugPoly=Config.Debug, minZ=20.94, maxZ=24.94 },
		{ options = { {  event = "jim-catcafe:Shop", icon = "fas fa-box-open", label = Loc[Config.Lan].target["store"], job = loc.job, coords = vec3(-598.0, -1068.47, 22.34), }, }, distance = 2.0 })
	Targets["CatStorage2"] =
	exports['qb-target']:AddBoxZone("CatStorage2", vec3(-598.25, -1065.61, 22.34-1), 4.0, 1.5, { name="CatStorage2", heading = 90, debugPoly=Config.Debug, minZ=20.94, maxZ=24.94 },
		{ options = { {  event = "jim-catcafe:Shop", icon = "fas fa-box-open", label = Loc[Config.Lan].target["store"], job = loc.job, coords = vec3(-598.25, -1065.61, 22.34), }, }, distance = 2.0 })
	Targets["CatStorage3"] =
	exports['qb-target']:AddBoxZone("CatStorage3", vec3(-598.31, -1062.79, 22.34-1), 4.0, 1.5, { name="CatStorage3", heading = 90, debugPoly=Config.Debug, minZ=20.94, maxZ=24.94 },
		{ options = { {  event = "jim-catcafe:Shop", icon = "fas fa-box-open", label = Loc[Config.Lan].target["store"], job = loc.job, coords = vec3(-598.31, -1062.79, 22.34), }, }, distance = 2.0 })
	--Sinks
	Targets["CatWash1"] =
		exports['qb-target']:AddBoxZone("CatWash1", vec3(-587.89, -1062.58, 22.36-1), 0.7, 0.7, { name="CatWash1", heading = 0, debugPoly=Config.Debug, minZ=19.11, maxZ=23.11 },
			{ options = { { event = "jim-catcafe:washHands", icon = "fas fa-hand-holding-water", label = Loc[Config.Lan].target["hands"], coords = vec3(-587.89, -1062.58, 22.36), }, }, distance = 1.5	})
	Targets["CatWash2"] =
		exports['qb-target']:AddBoxZone("CatWash2", vec3(-570.23, -1051.41, 22.34-1), 0.5, 0.5, { name="CatWash2", heading = 0, debugPoly=Config.Debug, minZ=21.74, maxZ=22.94, },
			{ options = { { event = "jim-catcafe:washHands", icon = "fas fa-hand-holding-water", label = Loc[Config.Lan].target["hands"], coords = vec3(-570.23, -1051.41, 22.34), }, }, distance = 1.2	})
	Targets["CatWash3"] =
		exports['qb-target']:AddBoxZone("CatWash3", vec3(-570.25, -1056.98, 22.34-1), 0.5, 0.5, { name="CatWash3", heading = 0, debugPoly=Config.Debug, minZ=21.74, maxZ=22.94, },
			{ options = { { event = "jim-catcafe:washHands", icon = "fas fa-hand-holding-water", label = Loc[Config.Lan].target["hands"], coords = vec3(-570.25, -1056.98, 22.34), }, }, distance = 1.2 })
	--Oven
	Targets["CatOven"] =
		exports['qb-target']:AddBoxZone("CatOven", vec3(-590.66, -1059.13, 22.34-1), 2.5, 0.6, { name="CatOven", heading = 0, debugPoly=Config.Debug, minZ = 19.84, maxZ = 23.84, },
			{ options = { { event = "jim-catcafe:Crafting", icon = "fas fa-temperature-high", label = Loc[Config.Lan].target["oven"], job = loc.job, craftable = Crafting.Oven, header = Loc[Config.Lan].menu["header_oven"], coords = vec3(-590.66, -1059.13, 22.34), }, }, distance = 2.0 })
	--Hob
	Targets["CatHob"] =
		exports['qb-target']:AddBoxZone("CatHob", vec3(-591.02, -1056.56, 22.36-1), 1.5, 0.6, { name="CatHob", heading = 0, debugPoly=Config.Debug, minZ = 19.84, maxZ = 23.84, },
			{ options = { { event = "jim-catcafe:Crafting", icon = "fas fa-temperature-high", label = Loc[Config.Lan].target["hob"], job = loc.job, craftable = Crafting.Hob, header = Loc[Config.Lan].menu["header_hob"], coords = vec3(-591.02, -1056.56, 22.36), }, }, distance = 2.0 })
	--Trays
	Targets["CatCounter"] =
		exports['qb-target']:AddBoxZone("CatCounter", vec3(-584.01, -1059.27, 22.34-0.5), 0.6, 1.0, { name="CatCounter", heading = 0, debugPoly=Config.Debug, minZ=22.0, maxZ=23.04 },
			{ options = { { event = "jim-catcafe:Stash", icon = "fas fa-hamburger", label = Loc[Config.Lan].target["counter"], stash = "Counter", coords = vec3(-584.01, -1059.27, 22.34), }, }, distance = 2.0	})
	Targets["CatCounter2"] =
		exports['qb-target']:AddBoxZone("CatCounter2", vec3(-584.04, -1062.05, 22.34-0.5), 0.6, 1.0, { name="CatCounter2", heading = 0, debugPoly=Config.Debug, minZ=22.0, maxZ=23.04 },
			{ options = { { event = "jim-catcafe:Stash", icon = "fas fa-hamburger", label = Loc[Config.Lan].target["counter"], stash = "Counter2", coords = vec3(-584.04, -1062.05, 22.34), }, }, distance = 2.0	})
	--Payments
	Targets["CatReceipt1"] =
		exports['qb-target']:AddBoxZone("CatReceipt1", vec3(-584.07, -1058.69, 22.34-0.5), 0.5, 1.0, { name="CatReceipt1", heading = 0, debugPoly=Config.Debug, minZ = 22.0, maxZ = 23.04, },
			{ options = { { event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = Loc[Config.Lan].target["charge"], job = loc.job, coords = vec3(-584.07, -1058.69, 22.34),
							img = "<center><p><img src=https://i.imgur.com/03eA7N0.png width=100px></p>"
						}, }, distance = 2.0 })
	Targets["CatReceipt2"] =
		exports['qb-target']:AddBoxZone("CatReceipt2", vec3(-584.09, -1061.47, 22.34-0.5), 0.5, 1.0, { name="CatReceipt2", heading = 0, debugPoly=Config.Debug, minZ = 22.0, maxZ = 23.04, },
			{ options = { { event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = Loc[Config.Lan].target["charge"], job = loc.job, coords = vec3(-584.09, -1061.47, 22.34),
							img = "<center><p><img src=https://i.imgur.com/03eA7N0.png width=100px></p>"
						}, }, distance = 2.0 })
	--Coffee--
	Targets["CatCoffee"] =
	exports['qb-target']:AddBoxZone("CatCoffee", vec3(-586.8, -1061.89, 22.34-0.5), 0.7, 0.9, { name="CatCoffee", heading = 0, debugPoly=Config.Debug, minZ=21.99, maxZ=23.19 },
		{ options = { { event = "jim-catcafe:Crafting", icon = "fas fa-mug-hot", label = Loc[Config.Lan].target["coffee"], job = loc.job, craftable = Crafting.Coffee, header = Loc[Config.Lan].menu["header_coffee"], coords = vec3(-586.8, -1061.89, 22.34), }, }, distance = 2.0 })
	--Chopping Board--
	Targets["CatBoard"] =
	exports['qb-target']:AddBoxZone("CatBoard", vec3(-590.94, -1063.16, 22.36-1), 1.5, 0.6, { name="CatBoard", heading = 0, debugPoly=Config.Debug, minZ=18.96, maxZ=22.96, },
		{ options = { { event = "jim-catcafe:Crafting", icon = "fas fa-utensils", label = Loc[Config.Lan].target["chopping"], job = loc.job, craftable = Crafting.ChoppingBoard, header = Loc[Config.Lan].menu["header_chop"], coords = vec3(-590.94, -1063.16, 22.36), }, }, distance = 2.0 })
	--Tables--
	Targets["CatTable"] =
	exports['qb-target']:AddBoxZone("CatTable", vec3(-573.43, -1059.76, 22.49-1), 1.9, 1.0, { name="CatTable", heading = 91.0, debugPoly=Config.Debug, minZ=21.49, maxZ=22.89 },
		{ options = { {  event = "jim-catcafe:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["table"], stash = "Table_1" }, }, distance = 2.0 })
	Targets["CatTable2"] =
	exports['qb-target']:AddBoxZone("CatTable2", vec3(-573.44, -1063.45, 22.34-1), 1.9, 1.0, { name="CatTable2", heading = 91.0, debugPoly=Config.Debug, minZ=21.49, maxZ=22.89 },
		{ options = { {  event = "jim-catcafe:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["table"], stash = "Table_2" }, }, distance = 2.0 })
	Targets["CatTable3"] =
	exports['qb-target']:AddBoxZone("CatTable3", vec3(-573.41, -1067.09, 22.49-1), 1.9, 1.0, { name="CatTable3", heading = 91.0, debugPoly=Config.Debug, minZ=21.49, maxZ=22.89 },
		{ options = { {  event = "jim-catcafe:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["table"], stash = "Table_3" }, }, distance = 2.0 })
	Targets["CatTable4"] =
	exports['qb-target']:AddBoxZone("CatTable4", vec3(-578.68, -1051.09, 22.35-1), 1.2, 0.9, { name="CatTable4", heading = 91.0, debugPoly=Config.Debug, minZ=21.49, maxZ=22.89 },
		{ options = { {  event = "jim-catcafe:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["table"], stash = "Table_4" }, }, distance = 2.0 })
	--Clockin
	Targets["CatClockin"] =
	exports['qb-target']:AddBoxZone("CatClockin", vec3(-594.34, -1053.35, 22.34), 3.5, 0.5, { name="CatClockin", heading = 0, debugPoly=Config.Debug, minZ=22.19, maxZ=23.79 },
		{ options = { 	{ type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = Loc[Config.Lan].target["duty"], job = loc.job },
						{ event = "qb-bossmenu:client:OpenMenu", icon = "fas fa-list", label = Loc[Config.Lan].target["boss"], job = bossroles, },
							}, distance = 2.0 })
	--Bossmenu
	Targets["CatBoss1"] =
	exports['qb-target']:AddBoxZone("CatBoss1", vec3(-596.17, -1052.6, 22.34-0.5), 0.6, 0.6, { name="CatBoss1", heading = 0, debugPoly=Config.Debug, minZ=22.19, maxZ=23.79 },
		{ options = { { event = "qb-bossmenu:client:OpenMenu", icon = "fas fa-list", label = Loc[Config.Lan].target["boss"], job = bossroles, },
					}, distance = 2.0 })
	Targets["CatBoss2"] =
	exports['qb-target']:AddBoxZone("CatBoss2", vec3(-578.3, -1066.83, 26.61-0.5), 0.6, 0.6, { name="CatBoss2", heading = 0, debugPoly=Config.Debug, minZ=26.19, maxZ=27.79 },
		{ options = { { event = "qb-bossmenu:client:OpenMenu", icon = "fas fa-list", label = Loc[Config.Lan].target["boss"], job = bossroles, },
					}, distance = 2.0 })
	Targets["CatBoss3"] =
	exports['qb-target']:AddBoxZone("CatBoss3", vec3(-578.15, -1061.35, 26.61-0.5), 0.6, 0.6, { name="CatBoss3", heading = 0, debugPoly=Config.Debug, minZ=26.19, maxZ=27.79 },
		{ options = { { event = "qb-bossmenu:client:OpenMenu", icon = "fas fa-list", label = Loc[Config.Lan].target["boss"], job = bossroles, },
					}, distance = 2.0 })
end)

RegisterNetEvent('jim-catcafe:washHands', function(data)
	if progressBar({ label = Loc[Config.Lan].progressbar["progress_washing"], time = 5000, cancel = true, dict = "mp_arresting", anim = "a_uncuff", flag = 8, icon = "fas fa-hand-holding-droplet" }) then
		triggerNotify(nil, Loc[Config.Lan].success["washed_hands"], 'success')
	else
		TriggerEvent('inventory:client:busy:status', false) triggerNotify(nil, Loc[Config.Lan].error["cancel"], 'error')
	end
	ClearPedTasks(PlayerPedId())
end)

--[[ CRAFTING ]]--
RegisterNetEvent('jim-catcafe:Crafting:MakeItem', function(data)
	if not CraftLock then CraftLock = true else return end
	local bartime = 5000
	if (data.amount and data.amount ~= 1) then data.craft["amount"] = data.amount
		for k, v in pairs(data.craft[data.item]) do	data.craft[data.item][k] *= data.amount	end
		bartime *= data.amount bartime *= 0.9
	end
	if data.header == Loc[Config.Lan].menu["header_coffee"] then animDictNow = "mp_ped_interaction" animNow = "handshake_guy_a"
	elseif data.header == Loc[Config.Lan].menu["header_hob"] then animDictNow = "amb@prop_human_bbq@male@base" animNow = "base"
	elseif data.header == Loc[Config.Lan].menu["header_oven"] then animDictNow = "amb@prop_human_bbq@male@base" animNow = "base"
	elseif data.header == Loc[Config.Lan].menu["header_chop"] then animDictNow = "anim@heists@prison_heiststation@cop_reactions" animNow = "cop_b_idle"
	else animDictNow = "amb@prop_human_parking_meter@male@idle_a" animNow = "idle_a" end
	if progressBar({ label = Loc[Config.Lan].progressbar["progress_make"]..QBCore.Shared.Items[data.item].label, time = bartime, cancel = true, dict = animDictNow, anim = animNow, flag = 8, icon = data.item }) then
		CraftLock = false
		TriggerServerEvent('jim-catcafe:Crafting:GetItem', data.item, data.craft)
		Wait(500)
		TriggerEvent("jim-catcafe:Crafting", data)
	else
		CraftLock = false
		TriggerEvent('inventory:client:busy:status', false)
	end
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('jim-catcafe:Crafting', function(data)
	if CraftLock then return end
	if not jobCheck() then return end
	local Menu = {}
	if Config.Menu == "qb" then
		Menu[#Menu + 1] = { header = data.header, txt = "", isMenuHeader = true }
		Menu[#Menu + 1] = { icon = "fas fa-circle-xmark", header = "", txt = Loc[Config.Lan].menu["close"], params = { event = "" } }
	end
	for i = 1, #data.craftable do
		for k, v in pairs(data.craftable[i]) do
			if k ~= "amount" then
				local text = ""
				setheader = QBCore.Shared.Items[tostring(k)].label
				if data.craftable[i]["amount"] ~= nil then setheader = setheader.." x"..data.craftable[i]["amount"] end
				local disable = false
				local checktable = {}
				for l, b in pairs(data.craftable[i][tostring(k)]) do
					if b == 0 or b == 1 then number = "" else number = " x"..b end
					if not QBCore.Shared.Items[l] then print("^3Error^7: ^2Script can't find ingredient item in QB-Core items.lua - ^1"..l.."^7") return end
					if Config.Menu == "ox" then text = text..QBCore.Shared.Items[l].label..number.."\n" end
					if Config.Menu == "qb" then text = text.."- "..QBCore.Shared.Items[l].label..number.."<br>" end
					settext = text
					checktable[l] = HasItem(l, b)
				end
				for _, v in pairs(checktable) do if v == false then disable = true break end end
				if not disable then setheader = setheader.." ✔️" end
				local event = "jim-catcafe:Crafting:MakeItem"
                if Config.MultiCraft then event = "jim-catcafe:Crafting:MultiCraft" end
				Menu[#Menu + 1] = {
					disabled = disable,
					icon = "nui://"..Config.img..QBCore.Shared.Items[tostring(k)].image,
					header = setheader, txt = settext, --qb-menu
					title = setheader, description = settext, -- ox_lib
					event = event, args = { item = k, craft = data.craftable[i], craftable = data.craftable, header = data.header, }, -- ox_lib
					params = { event = event, args = { item = k, craft = data.craftable[i], craftable = data.craftable, header = data.header, } } -- qb-menu
				}
				settext, setheader = nil
			end
		end
	end
	if Config.Menu == "ox" then	exports.ox_lib:registerContext({id = 'Crafting', title = data.header, position = 'top-right', options = Menu })	exports.ox_lib:showContext("Crafting")
	elseif Config.Menu == "qb" then	exports['qb-menu']:openMenu(Menu) end
	lookEnt(data.coords)
end)

RegisterNetEvent('jim-catcafe:Crafting:MultiCraft', function(data)
    local success = Config.MultiCraftAmounts local Menu = {}
    for k in pairs(success) do success[k] = true
        for l, b in pairs(data.craft[data.item]) do
            local has = HasItem(l, (b * k)) if not has then success[k] = false break else success[k] = true end
		end end
    if Config.Menu == "qb" then Menu[#Menu + 1] = { header = data.header, txt = "", isMenuHeader = true } end
	Menu[#Menu + 1] = { icon = "fas fa-arrow-left", title = Loc[Config.Lan].menu["back"], header = "", txt = Loc[Config.Lan].menu["back"], params = { event = "jim-catcafe:Crafting", args = data }, event = "jim-catcafe:Crafting", args = data }
	for k in pairsByKeys(success) do
		Menu[#Menu + 1] = {
			disabled = not success[k],
			icon = "nui://"..Config.img..QBCore.Shared.Items[data.item].image, header = QBCore.Shared.Items[data.item].label.." [x"..k.."]", title = QBCore.Shared.Items[data.item].label.." [x"..k.."]",
			event = "jim-catcafe:Crafting:MakeItem", args = { item = data.item, craft = data.craft, craftable = data.craftable, header = data.header, anim = data.anim, amount = k },
			params = { event = "jim-catcafe:Crafting:MakeItem", args = { item = data.item, craft = data.craft, craftable = data.craftable, header = data.header, anim = data.anim, amount = k } }
		}
	end
	if Config.Menu == "ox" then	exports.ox_lib:registerContext({id = 'Crafting', title = data.header, position = 'top-right', options = Menu })	exports.ox_lib:showContext("Crafting")
	elseif Config.Menu == "qb" then	exports['qb-menu']:openMenu(Menu) end
end)

--[[STASH SHOPS]]--
RegisterNetEvent('jim-catcafe:Stash', function(data)
	if data.job and not jobCheck() then return end
	if Config.Inv == "ox" then exports.ox_inventory:openInventory('stash', "Catcafe_"..data.stash)
	else TriggerEvent("inventory:client:SetCurrentStash", "Catcafe_"..data.stash)
	TriggerServerEvent("inventory:server:OpenInventory", "stash", "Catcafe_"..data.stash) end
	lookEnt(data.coords)
end)
RegisterNetEvent('jim-catcafe:Shop', function(data)
	if not jobCheck() then return end
	local event = "inventory:server:OpenInventory"
	if Config.JimShop then event = "jim-shops:ShopOpen"
	elseif Config.Inv == "ox" then  exports.ox_inventory:openInventory('shop', { type = 'catcafeShop' }) end
	TriggerServerEvent(event, "shop", "catcafeShop", Config.Items)
	lookEnt(data.coords)
end)

-- [[CONSUME]] --
local function ConsumeSuccess(itemName, type)
	ExecuteCommand("e c")
	toggleItem(false, itemName, 1)
	if QBCore.Shared.Items[itemName].hunger then
		TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + QBCore.Shared.Items[itemName].hunger)
		--TriggerServerEvent("consumables:server:addHunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + QBCore.Shared.Items[itemName].hunger)
	end
	if QBCore.Shared.Items[itemName].thirst then
		TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + QBCore.Shared.Items[itemName].thirst)
		--TriggerServerEvent("consumables:server:addThirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + QBCore.Shared.Items[itemName].thirst)
	end
	if type == "alcohol" then alcoholCount += 1
		if alcoholCount > 1 and alcoholCount < 4 then TriggerEvent("evidence:client:SetStatus", "alcohol", 200)	elseif alcoholCount >= 4 then TriggerEvent("evidence:client:SetStatus", "heavyalcohol", 200) AlienEffect() end
	end
	if Config.RewardItem == itemName then toggleItem(true, Config.RewardPool[math.random(1, #Config.RewardPool)], 1) end
end

RegisterNetEvent('jim-catcafe:client:Consume', function(itemName, type)
	local emoteTable = {
		["sake"] = "flute",
		["bobatea"] = "uwu12", ["bbobatea"] = "uwu12", ["gbobatea"] = "uwu12", ["obobatea"] = "uwu12", ["pbobatea"] = "uwu12", ["nekolatte"] = "uwu2", ["mocha"] = "uwu1", ["catcoffee"] = "uwu4",
		["bmochi"] = "uwu13", ["gmochi"] = "uwu13", ["omochi"] = "uwu13", ["pmochi"] = "uwu13", ["miso"] = "uwu9", ["nekodonut"] = "uwu5", ["purrito"] = "uwu8", ["noodlebowl"] = "uwu9", ["ramen"] = "uwu9", ["bento"] = "uwu7", ["nekocookie"] = "uwu6",
	}
	local progstring, defaultemote = Loc[Config.Lan].progressbar["progress_drink"], "drink"
	if type == "food" then progstring = Loc[Config.Lan].progressbar["progress_eat"] defaultemote = "uwu3" end
	ExecuteCommand("e "..(emoteTable[itemName] or defaultemote))
	if progressBar({label = progstring..QBCore.Shared.Items[itemName].label.."..", time = math.random(3000, 6000), cancel = true, icon = itemName}) then
		ConsumeSuccess(itemName, type)
	else
		ExecuteCommand("e c")
	end
end)

AddEventHandler('onResourceStop', function(r) if r ~= GetCurrentResourceName() then return end
	if GetResourceState("qb-target") == "started" or GetResourceState("ox_target") == "started" then
		for k in pairs(Targets) do exports['qb-target']:RemoveZone(k) end
		exports['qb-menu']:closeMenu()
	end
end)