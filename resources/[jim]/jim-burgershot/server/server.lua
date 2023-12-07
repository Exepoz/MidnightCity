AddEventHandler('onResourceStart', function(r) if GetCurrentResourceName() ~= r then return end
	for k, v in pairs(Config.Locations) do
		if not QBCore.Shared.Jobs[v.job] then print("Error: Job role not found - '"..v.job.."'") end
		if v.garage then
			TriggerEvent("jim-jobgarage:server:syncAddLocations", { job = v.job, garage = v.garage }) -- Job Garage creation
		end
	end
	for _, v in pairs(Crafting) do
		for i = 1, #v do
			for l, b in pairs(v[i]) do
				if not QBCore.Shared.Items[l] and l ~= "amount" then print("Crafting: Missing Item from QBCore.Shared.Items: '"..l.."'") end
				if type(b) == "table" then
					for j in pairs(b) do if not QBCore.Shared.Items[j] then print("Crafting: Missing Item from QBCore.Shared.Items: '"..j.."'") end end end end end end
	for i = 1, #Config.Items.items do
		if not QBCore.Shared.Items[Config.Items.items[i].name] then print("Store: Missing Item from QBCore.Shared.Items: '"..Config.Items.items[i].name.."'") end
	end
end)

if not Config.JimConsumables then
	CreateThread(function()
		local drinks = { "bscoke", "bscoffee", "milkshake", "milk", }
		for _, v in pairs(drinks) do  QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('jim-burgershot:client:Consume', source, item.name, "drink") end) end

		local food = { "heartstopper", "shotfries", "shotnuggets", "shotrings", "moneyshot", "meatfree", "bleeder", "torpedo", "rimjob", "creampie", "cheesewrap", "chickenwrap" }
		for _, v in pairs(food) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('jim-burgershot:client:Consume', source, item.name, "food") end) end
	end)
else
	local foodTable = {
		["bscoffee"] = { emote = "bscoffee", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = math.random(55,65), }},
		["bscoke"] = { emote = "bscoke", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = math.random(55,65), }},
		["heartstopper"] = { emote = "burger", canRun = false, 	time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(55,65), }},
		["torpedo"] = {	emote = "torpedo", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(55,65), }},
		["shotfries"] = { emote = "bsfries", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(55,65), }},
		["meatfree"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(55,65), }},
		["shotnuggets"] = {	emote = "bsfries", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(55,65), }},
		["shotrings"] = { emote = "bsfries", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(55,65), }},
		["moneyshot"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(55,65), }},
		["bleeder"] = {	emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(55,65), }},
		["rimjob"] = { emote = "donut", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(55,65), }},
		["creampie"] = { emote = "donut", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(55,65), }},
		["cheesewrap"] = { emote = "sandwich", canRun = false, 	time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(55,65), }},
		["chickenwrap"] = {	emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(55,65), }},
	}
	local emoteTable = {
		["milk"] = {"mp_player_intdrink", "loop_bottle", "Milk", AnimationOptions = { Prop = "v_res_tt_milk", PropBone = 18905, PropPlacement = {0.10, 0.008, 0.07, 240.0, -60.0}, EmoteMoving = true, EmoteLoop = true, }},
		["bscoke"] = {"mp_player_intdrink", "loop_bottle", "BS Coke", AnimationOptions = { Prop = "prop_food_bs_juice01", PropBone = 18905, PropPlacement = {0.04, -0.10, 0.10, 240.0, -60.0},  EmoteMoving = true, EmoteLoop = true, }},
		["bscoffee"] = {"mp_player_intdrink", "loop_bottle", "BS Coffee", AnimationOptions = { Prop = "prop_food_bs_coffee", PropBone = 18905, PropPlacement = {0.08, -0.10, 0.10, 240.0, -60.0}, EmoteMoving = true, EmoteLoop = true, }},
		["glass"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Tall Glass", AnimationOptions = { Prop = 'prop_wheat_grass_glass', PropBone = 28422, PropPlacement = {0.0, 0.0, -0.1, 0.0, 0.0, 0.0}, EmoteLoop = true, EmoteMoving = true, }},
		["torpedo"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger_fp", "Torpedo", AnimationOptions = { Prop = "prop_food_bs_burger2", PropBone = 18905, PropPlacement = {0.10, -0.07, 0.091, 15.0, 135.0}, EmoteMoving = true, EmoteLoop = true, }},
		["bsfries"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger_fp", "Fries", AnimationOptions = { Prop = "prop_food_bs_chips", PropBone = 18905, PropPlacement = {0.09, -0.06, 0.05, 300.0, 150.0}, EmoteMoving = true, EmoteLoop = true, }},
		["donut2"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Donut2", AnimationOptions = { Prop = 'prop_donut_02', PropBone = 18905, PropPlacement = {0.13, 0.05, 0.02, -50.0, 100.0, 270.0}, EmoteMoving = true, EmoteLoop = true, }},
	}
	for k, v in pairs(foodTable) do TriggerEvent("jim-consumables:server:syncAddItem", k, v) end
	for k, v in pairs(emoteTable) do TriggerEvent("jim-consumables:server:syncAddEmote", k, v) end
end
QBCore.Functions.CreateUseableItem("murderbag", function(source, item) TriggerClientEvent('jim-burgershot:Stash', source, {}, item.info["id"], true) end)

RegisterServerEvent("jim-burgershot:server:GrabBag", function()
	local src = source local Player = QBCore.Functions.GetPlayer(src)
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["murderbag"], "add", 1)
	Player.Functions.AddItem("murderbag", 1, false, { ["id"] = math.random(1, 9999999) })
end)

---Crafting
RegisterServerEvent('jim-burgershot:Crafting:GetItem', function(ItemMake, craftable)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	--This grabs the table from client and removes the item requirements
	local amount = 1
	if craftable then
		if craftable["amount"] then amount = craftable["amount"] end
		for k, v in pairs(craftable[ItemMake]) do TriggerEvent("jim-burgershot:server:toggleItem", false, tostring(k), v, src) end
	end
	--This should give the item, while the rest removes the requirements
	TriggerEvent("jim-burgershot:server:toggleItem", true, ItemMake, amount, src)
end)

local function dupeWarn(src, item)
	local P = QBCore.Functions.GetPlayer(src)
	print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Tried to remove item ^7('^3"..item.."^7')^2 but it wasn't there^7")
	if not Config.Debug then DropPlayer(src, "^1Kicked for attempting to duplicate items") end
	print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Dropped from server for item duplicating^7")
end

RegisterNetEvent('jim-burgershot:server:toggleItem', function(give, item, amount, newsrc)
	local src = newsrc or source
	local Player = QBCore.Functions.GetPlayer(src)
	local remamount = (amount or 1)
	if give == 0 or give == false then
		if HasItem(src, item, amount or 1) then -- check if you still have the item
			while remamount > 0 do if Player.Functions.RemoveItem(item, 1) then end remamount -= 1 end
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove", amount or 1)
			if Config.Debug then print("^5Debug^7: ^1Removing ^2from Player^7(^2"..src.."^7) '^6"..QBCore.Shared.Items[item].label.."^7(^2x^6"..(amount or "1").."^7)'") end
		else dupeWarn(src, item) end -- if not boot the player
	else
		if Player.Functions.AddItem(item, amount or 1) then
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount or 1)
			if Config.Debug then print("^5Debug^7: ^4Giving ^2Player^7(^2"..src.."^7) '^6"..QBCore.Shared.Items[item].label.."^7(^2x^6"..(amount or "1").."^7)'") end
		end
	end
end)

if Config.Inv == "ox" then
	--Default Loc
	exports.ox_inventory:RegisterStash("BSShelf", "BurgerShot Shelf", 20, 400000)
	exports.ox_inventory:RegisterStash("BSFridge", "BurgerShot Fridge", 20, 400000)
	exports.ox_inventory:RegisterStash("BSTray1", "BurgerShot Tray 1", 20, 400000)
	exports.ox_inventory:RegisterStash("BSTray2",  "BurgerShot Tray 2", 20, 400000)
	exports.ox_inventory:RegisterStash("BSTray3", "BurgerShot Tray 3", 20, 400000)
	exports.ox_inventory:RegisterStash("BSTray4", "BurgerShot Tray 3", 20, 400000)
	exports.ox_inventory:RegisterShop("BSShop", { name = Config.Items.label, inventory = Config.Items.items })

	--Mirror park
	exports.ox_inventory:RegisterStash("BSMShelf", "BurgerShot Shelf", 20, 400000)
	exports.ox_inventory:RegisterStash("BSMFridge", "BurgerShot Fridge", 20, 400000)
	exports.ox_inventory:RegisterStash("BSMTray1", "BurgerShot Tray 1", 20, 400000)
	exports.ox_inventory:RegisterStash("BSMTray2",  "BurgerShot Tray 2", 20, 400000)
	exports.ox_inventory:RegisterStash("BSMTray3", "BurgerShot Tray 3", 20, 400000)
	exports.ox_inventory:RegisterShop("BSMShop", { name = Config.Items.label, inventory = Config.Items.items })

	--Sandy
	exports.ox_inventory:RegisterStash("BSSShelf", "BurgerShot Shelf", 20, 400000)
	exports.ox_inventory:RegisterStash("BSSFridge", "BurgerShot Fridge", 20, 400000)
	exports.ox_inventory:RegisterStash("BSSTray1", "BurgerShot Tray 1", 20, 400000)
	exports.ox_inventory:RegisterStash("BSSTray2",  "BurgerShot Tray 2", 20, 400000)
	exports.ox_inventory:RegisterStash("BSSTray3", "BurgerShot Tray 3", 20, 400000)
	exports.ox_inventory:RegisterShop("BSSShop", { name = Config.Items.label, inventory = Config.Items.items })
	function HasItem(src, items, amount) local count = exports.ox_inventory:Search(src, 'count', items)
		if exports.ox_inventory:Search(src, 'count', items) >= (amount or 1) then if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^5FOUND^7 x^3"..count.."^7 ^3"..tostring(items)) end return true
        else if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items ^1NOT FOUND^7") end return false end
	end
else
	function HasItem(source, items, amount)
		local amount, count = amount or 1, 0
		local Player = QBCore.Functions.GetPlayer(source)
		if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Checking if player has required item^7 '^3"..tostring(items).."^7'") end
		for _, itemData in pairs(Player.PlayerData.items) do
			if itemData and (itemData.name == items) then
				if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Item^7: '^3"..tostring(items).."^7' ^2Slot^7: ^3"..itemData.slot.." ^7x(^3"..tostring(itemData.amount).."^7)") end
				count += itemData.amount
			end
		end
		if count >= amount then if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items ^5FOUND^7 x^3"..count.."^7") end return true end
		if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items ^1NOT FOUND^7") end	return false
	end
end

local function CheckVersion()
	PerformHttpRequest('https://raw.githubusercontent.com/jimathy/UpdateVersions/master/jim-burgershot.txt', function(err, newestVersion, headers)
		local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
		if not newestVersion then print("Currently unable to run a version check.") return end
		local advice = "^1You are currently running an outdated version^7, ^1please update^7"
		if newestVersion:gsub("%s+", "") == currentVersion:gsub("%s+", "") then advice = '^6You are running the latest version.^7'
		else print("^3Version Check^7: ^2Current^7: "..currentVersion.." ^2Latest^7: "..newestVersion) end
		print(advice)
	end)
end
CheckVersion()