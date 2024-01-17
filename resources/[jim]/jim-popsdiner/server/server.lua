AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
	for k, v in pairs(Crafting) do for i = 1, #v do
			for l, b in pairs(v[i]) do if not QBCore.Shared.Items[l] then print("^5Debug^7: ^6Crafting^7: ^2Missing Item from ^4QBCore^7.^4Shared^7.^4Items^7: '^6"..l.."^7'") end
				for j in pairs(b) do if not QBCore.Shared.Items[j] then print("^5Debug^7: ^6Crafting^7: ^2Missing Item from ^4QBCore^7.^4Shared^7.^4Items^7: '^6"..j.."^7'") end end end end end
	for i = 1, #Config.DessertItems.items do
		if not QBCore.Shared.Items[Config.DessertItems.items[i].name] then print("^5Debug^7: ^6Store^7: ^2Missing Item from ^4QBCore^7.^4Shared^7.^4Items^7: '^6"..Config.DessertItems.items[i].name.."^7'") end
	end
	for i = 1, #Config.FoodItems.items do
		if not QBCore.Shared.Items[Config.FoodItems.items[i].name] then print("^5Debug^7: ^6Store^7: ^2Missing Item from ^4QBCore^7.^4Shared^7.^4Items^7: '^6"..Config.FoodItems.items[i].name.."^7'") end
	end
	if not QBCore.Shared.Jobs[Config.Locations[1].job] then print("Error: Job role not found - '"..Config.Locations[1].job.."'") end
	TriggerEvent("jim-jobgarage:server:syncAddLocations", { job = Config.Locations[1].job, garage = Config.Locations[1].garage }) -- Job Garage creation
end)

if not Config.JimConsumables then
	local drinks = { "sprunk", "sprunklight", "ecola", "ecolalight", }
    for k,v in pairs(drinks) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('jim-popsdiner:client:Consume', source, item.name, "drink") end) end

	local food = { "crisps", "carrotcake", "cheesecake", "jelly", "chocpudding", "popdonut", "popicecream", "chocolate",
					"baconeggs", "bltsandwich", "cheeseburger", "cheesesandwich", "eggsandwich", "grilledwrap", "hamburger",
					"hamcheesesandwich", "hamsandwich", "ranchwrap", "sausageeggs", "steakburger", "toastbacon", "tunasandwich", "veggiewrap" }
    for k,v in pairs(food) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('jim-popsdiner:client:Consume', source, item.name, "food") end) end
else
	local foodTable = {
		-- ["ecola"] = { emote = "ecola", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = math.random(20,30), }},
		-- ["ecolalight"] = { emote = "ecola", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = math.random(20,30), }},
		-- ["sprunk"] = { emote = "sprunk", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = math.random(20,30), }},
		-- ["sprunklight"] = { emote = "sprunk", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = math.random(20,30), }},
		-- ["crisps"] = { emote = "crisps", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["carrotcake"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["cheesecake"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["jelly"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["chocpudding"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["popdonut"] = { emote = "donut", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["popicecream"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["chocolate"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["baconeggs"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["bltsandwich"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["cheeseburger"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["cheesesandwich"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["eggsandwich"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["grilledwrap"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["hamburger"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["hamcheesesandwich"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["hamsandwich"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["ranchwrap"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["sausageeggs"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["steakburger"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["toastbacon"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["tunasandwich"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		-- ["veggiewrap"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	}
	local emoteTable = {
		["ecola"] = {"mp_player_intdrink", "loop_bottle", "E-cola", AnimationOptions = { Prop = "prop_ecola_can", PropBone = 18905, PropPlacement = {0.12, 0.008, 0.03, 240.0, -60.0}, EmoteMoving = true, EmoteLoop = true, }},
		["sprunk"] = {"mp_player_intdrink", "loop_bottle", "Sprunk", AnimationOptions = { Prop = "v_res_tt_can03", PropBone = 18905, PropPlacement = {0.12, 0.008, 0.03, 240.0, -60.0}, EmoteMoving = true, EmoteLoop = true, }},
		["donut"] = { "mp_player_inteat@burger", "mp_player_int_eat_burger", "Donut", AnimationOptions = { Prop = 'prop_amb_donut', PropBone = 18905, PropPlacement = {0.13,0.05,0.02,-50.0,16.0,60.0 }, EmoteMoving = true }},
	}
	AddEventHandler('onResourceStart', function(r)
		while GetResourceState("jim-consumables") == "starting" do Wait(10) end
		if GetResourceState("jim-consumables") == "started" then
			for k, v in pairs(foodTable) do TriggerEvent("jim-consumables:server:syncAddItem", k, v) end
			for k, v in pairs(emoteTable) do TriggerEvent("jim-consumables:server:syncAddEmote", k, v) end
		end
	end)
end

---Crafting
-- RegisterServerEvent('jim-popsdiner:Crafting:GetItem', function(ItemMake, craftable)
-- 	local src = source
-- 	local amount = 1
-- 	if craftable then
-- 		if craftable["amount"] then amount = craftable["amount"] end
-- 		for k, v in pairs(craftable[ItemMake]) do TriggerEvent("jim-popsdiner:server:toggleItem", false, tostring(k), v, src) end
-- 	end
-- 	TriggerEvent("jim-popsdiner:server:toggleItem", true, ItemMake, amount, src)
-- end)

---Crafting
RegisterServerEvent('jim-popsdiner:Crafting:GetItem', function(ItemMake, craftable)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    --This grabs the table from client and removes the item requirements
    local amount = 1
    local oNeeded, oAmount = 0, 0
    if craftable then
        if craftable["amount"] then amount = craftable["amount"] end
        for k, v in pairs(craftable[ItemMake]) do
            oNeeded, oAmount = cookItem(false, tostring(k), v, src, oNeeded, oAmount)
            --TriggerEvent("jim-burgershot:server:toggleItem", false, tostring(k), v, src)
        end
    end
    --This should give the item, while the rest removes the requirements
    cookItem(true, ItemMake, amount, src, oNeeded, oAmount)
    --TriggerEvent("jim-burgershot:server:toggleItem", true, ItemMake, amount, src)
end)

function cookItem(give, item, amount, newsrc, oNeeded, oAmount)
    local organicNeeded = oNeeded or 0
    local organicAmount = oAmount or 0
    local src = newsrc
    local player = QBCore.Functions.GetPlayer(src)
    local remamount = (amount or 1)
    if give == 0 or give == false then
        if HasItem(src, item, amount or 1) then -- check if you still have the item
            if Organic[item] then organicNeeded += amount end
            local items = player.Functions.GetItemsByName(item)
            for _,v in pairs(items) do
                if remamount < 0 then break end
                if v.amount < remamount then
                    for i = 1, v.amount do
                        if player.PlayerData.items[v.slot].info.organic then organicAmount += 1 end
                        player.Functions.RemoveItem(item, 1, v.slot)
                        remamount -= 1
                    end
                else
                    while remamount > 0 do
                        if player.PlayerData.items[v.slot].info.organic then organicAmount += 1 end
                        print(item, v.slot)
                        player.Functions.RemoveItem(item, 1, v.slot)
                        remamount -= 1
                    end
                end
            end
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove", amount or 1)
            if Config.Debug then print("^5Debug^7: ^1Removing ^2from Player^7(^2"..src.."^7) '^6"..QBCore.Shared.Items[item].label.."^7(^2x^6"..(amount or "1").."^7)'") end
            return organicNeeded, organicAmount
        else dupeWarn(src, item) end -- if not boot the player
    else
        local info = {}
        if oNeeded > 0 and oAmount >= oNeeded then
            info = HighQuality[item] and {highQuality = true, buffJob = 'popsdiner'} or {organic = true}
        end
        if player.Functions.AddItem(item, amount or 1, false, info) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount or 1)
            if Config.Debug then print("^5Debug^7: ^4Giving ^2Player^7(^2"..src.."^7) '^6"..QBCore.Shared.Items[item].label.."^7(^2x^6"..(amount or "1").."^7)'") end
        end
    end
end

local function dupeWarn(src, item)
	local P = QBCore.Functions.GetPlayer(src)
	print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Tried to remove item ^7('^3"..item.."^7')^2 but it wasn't there^7")
	if not Config.Debug then DropPlayer(src, "^1Kicked for attempting to duplicate items") end
	print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Dropped from server for item duplicating^7")
end

RegisterNetEvent('jim-popsdiner:server:toggleItem', function(give, item, amount, newsrc)
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
	exports.ox_inventory:RegisterStash("popsdiner_".."PopCounter1", "PopsDiner Counter 1", 20, 400000)
	exports.ox_inventory:RegisterStash("popsdiner_".."PopCounter2", "PopsDiner Counter 2", 20, 400000)
	exports.ox_inventory:RegisterStash("popsdiner_".."PopCounter3", "PopsDiner Counter 3", 20, 400000)
	for i = 1, 9 do exports.ox_inventory:RegisterStash("popsdiner_".."Table"..i, "PopsDiner Table "..i, 20, 400000) end
	exports.ox_inventory:RegisterShop("popsdessert", { name = Config.DessertItems.label, inventory = Config.DessertItems.items })
	exports.ox_inventory:RegisterShop("popfood", { name = Config.FoodItems.label, inventory = Config.FoodItems.items })
	function HasItem(src, items, amount)
		local count = exports.ox_inventory:Search(src, 'count', items)
		if exports.ox_inventory:Search(src, 'count', items) >= (amount or 1) then
			if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^5FOUND^7 ^3"..count.."^7/^3"..(amount or 1).." "..tostring(items)) end return true
        else
			if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2"..tostring(items).." ^1NOT FOUND^7") end return false
		end
	end
else
	function HasItem(source, items, amount)
		local amount, count = amount or 1, 0
		local Player = QBCore.Functions.GetPlayer(source)
		if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Checking if player has required item^7 '^3"..tostring(items).."^7'") end
		for _, itemData in pairs(Player.PlayerData.items) do
			if itemData and (itemData.name == items) and (itemData.info.quality > 0) then
				if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Item^7: '^3"..tostring(items).."^7' ^2Slot^7: ^3"..itemData.slot.." ^7x(^3"..tostring(itemData.amount).."^7)") end
				count += itemData.amount
			end
		end
		if count >= amount then if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^5FOUND^7 ^3"..count.."^7/^3"..(amount or 1).." "..tostring(items)) end return true end
		if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2"..tostring(items).." ^1NOT FOUND^7") end	return false
	end
end

local function CheckVersion()
	PerformHttpRequest('https://raw.githubusercontent.com/jimathy/UpdateVersions/master/jim-popsdiner.txt', function(err, newestVersion, headers)
		local currentVersion = "^3"..GetResourceMetadata(GetCurrentResourceName(), 'version'):gsub("%.", "^7.^3").."^7"
		newestVersion = "^3"..newestVersion:sub(1, -2):gsub("%.", "^7.^3").."^7"
		if not newestVersion then print("Currently unable to run a version check.") return end
		print("^6Version Check^7: ^2Running^7: "..currentVersion.." ^2Latest^7: "..newestVersion)
		print(newestVersion == currentVersion and '^6You are running the latest version.^7 ('..currentVersion..')' or "^1You are currently running an outdated version^7, ^1please update^7!")
	end)
end
CheckVersion()