local QBCore = exports[Config.Core]:GetCoreObject()

AddEventHandler('onResourceStart', function(r) if GetCurrentResourceName() ~= r then return end
	for k, v in pairs(Crafting) do for i = 1, #v do
			for l, b in pairs(v[i]) do if not QBCore.Shared.Items[l] then print("^5Debug^7: ^6Crafting^7: ^2Missing Item from ^4QBCore^7.^4Shared^7.^4Items^7: '^6"..l.."^7'") end
				for j, c in pairs(b) do if not QBCore.Shared.Items[j] then print("^5Debug^7: ^6Crafting^7: ^2Missing Item from ^4QBCore^7.^4Shared^7.^4Items^7: '^6"..j.."^7'") end end end end end
	for i = 1, #Config.Items.items do
		if not QBCore.Shared.Items[Config.Items.items[i].name] then print("^5Debug^7: ^6Store^7: ^2Missing Item from ^4QBCore^7.^4Shared^7.^4Items^7: '^6"..Config.Items.items[i].name.."^7'") end
	end
	if not QBCore.Shared.Jobs[Config.Locations[1].job] then print("Error: Job role not found - '"..Config.Locations[1].job.."'") end
	TriggerEvent("jim-jobgarage:server:syncAddLocations", { job = Config.Locations[1].job, garage = Config.Locations[1].garage }) -- Job Garage creation
end)

if not Config.JimConsumables then
	-- Make Items Usable
	local food = { "bento", "blueberry", "cake", "nekocookie", "nekodonut", "riceball", "miso", "bmochi", "pmochi", "gmochi", "omochi", "strawberry", "rice", "cakepop", "pizza", "pancake", "purrito", "noodlebowl", "ramen" }
	for _, v in pairs(food) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('jim-catcafe:client:Consume', source, item.name, "food") end) end

	local drinks = { "bobatea", "bbobatea", "gbobatea", "pbobatea", "obobatea", "nekolatte", "mocha", "catcoffee" }
	for _, v in pairs(drinks) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('jim-catcafe:client:Consume', source, item.name, "drink") end) end

	local alcohol = { "sake" }
	for _, v in pairs(alcohol) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('jim-catcafe:client:Consume', source, item.name, "alcohol") end) end
else
	local foodTable = {
		["sake"] = { emote = "flute", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = 30, canOD = true }},
		["bobatea"] = { emote = "uwu12", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = 75, }},
		["bbobatea"] = { emote = "uwu12", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = 75, }},
		["gbobatea"] = { emote = "uwu12", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = 75, }},
		["obobatea"] = { emote = "uwu12", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = 75, }},
		["pbobatea"] = { emote = "uwu12", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = 75, }},
		["nekolatte"] = { emote = "uwu2", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = 75, }},
		["mocha"] = { emote = "uwu1", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = 75, }},
		["catcoffee"] = { emote = "uwu4", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = 75, }},
		["bento"] = { emote = "uwu7", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["blueberry"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 20, }},
		["cake"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 20, }},
		["nekocookie"] = { emote = "uwu6", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 20, }},
		["nekodonut"] = { emote = "uwu5", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 20, }},
		["riceball"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 20, }},
		["miso"] = { emote = "uwu9", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 50, }},
		["bmochi"] = { emote = "uwu13", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 20, }},
		["pmochi"] = { emote = "uwu13", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 20, }},
		["gmochi"] = { emote = "uwu13", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 20, }},
		["omochi"] = { emote = "uwu13", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 20, }},
		["strawberry"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 20, }},
		["rice"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 50, }},
		["cakepop"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 20, }},
		["pizza"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["pancake"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["purrito"] = { emote = "uwu8", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["noodlebowl"] = { emote = "uwu9", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["ramen"] = { emote = "uwu9", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
	}
	local emoteTable = {
		["uwu1"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "", AnimationOptions = { Prop = 'uwu_sml_drink', PropBone = 28422, PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 130.0}, EmoteLoop = true, EmoteMoving = true, }},
		["uwu2"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "", AnimationOptions = { Prop = 'uwu_lrg_drink', PropBone = 28422, PropPlacement = {0.03, 0.0, -0.08, 0.0, 0.0, 130.0}, EmoteLoop = true, EmoteMoving = true, }},
		["uwu3"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "", AnimationOptions = { Prop = 'uwu_cup_straw', PropBone = 28422, PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 130.0}, EmoteLoop = true, EmoteMoving = true, }},
		["uwu4"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "", AnimationOptions = { Prop = 'uwu_mug', PropBone = 28422, PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 130.0}, EmoteLoop = true, EmoteMoving = true, }},
		["uwu5"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "", AnimationOptions = { Prop = 'uwu_pastry', PropBone = 18905, PropPlacement = {0.16, 0.06, -0.03, -50.0, 16.0, 60.0}, EmoteMoving = true, }},
		["uwu6"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "", AnimationOptions = { Prop = 'uwu_cookie', PropBone = 18905, PropPlacement = {0.16, 0.08, -0.01, -225.0, 20.0, 60.0}, EmoteMoving = true, }},
		["uwu7"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "", AnimationOptions = { Prop = 'uwu_sushi', PropBone = 18905, PropPlacement = {0.18, 0.03, 0.02, -50.0, 16.0, 60.0}, EmoteMoving = true, }},
		["uwu8"] = {"amb@world_human_seat_wall_eating@male@both_hands@idle_a", "idle_c", "", AnimationOptions = { Prop = 'uwu_eggroll', PropBone = 60309, PropPlacement = {0.10, 0.03, 0.08, -95.0, 60.0, 0.0}, EmoteMoving = true, }},
		["uwu9"] = {"anim@scripted@island@special_peds@pavel@hs4_pavel_ig5_caviar_p1", "base_idle", "", AnimationOptions = { Prop = "uwu_salad_bowl", PropBone = 60309, PropPlacement = {0.0, 0.0300, 0.0100, 0.0, 0.0, 0.0}, SecondProp = 'uwu_salad_spoon', SecondPropBone = 28422, SecondPropPlacement = {0.0, 0.0 ,0.0, 0.0, 0.0, 0.0}, EmoteLoop = true, EmoteMoving = true, }},
		["uwu10"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "", AnimationOptions = { Prop = 'uwu_sandy', PropBone = 18905, PropPlacement = {0.16, 0.08, 0.05, -225.0, 20.0, 60.0}, EmoteMoving = true, }},
		["uwu11"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "", AnimationOptions = { Prop = 'uwu_cupcake', PropBone = 28422, PropPlacement = {0.0, 0.0, -0.03, 0.0, 0.0, 130.0}, EmoteLoop = true, EmoteMoving = true, }},
		["uwu12"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "", AnimationOptions = { Prop = 'uwu_btea', PropBone = 28422, PropPlacement = {0.02, 0.0, -0.05, 0.0, 0.0, 130.0}, EmoteLoop = true, EmoteMoving = true, }},
		["uwu13"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "", AnimationOptions = { Prop = 'uwu_gdasik', PropBone = 18905, PropPlacement = {0.16, 0.08, 0.02, -225.0, 20.0, 60.0}, EmoteMoving = true, }},
		["flute"] = { "anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Flute", AnimationOptions = { Prop = 'prop_champ_flute', PropBone = 18905, PropPlacement = {0.10,-0.03,0.03,-100.0,0.0,-10.0}, EmoteMoving = true, EmoteLoop = true}},
	}
	for k, v in pairs(foodTable) do TriggerEvent("jim-consumables:server:syncAddItem", k, v) end
	for k, v in pairs(emoteTable) do TriggerEvent("jim-consumables:server:syncAddEmote", k, v) end
end

---Crafting
---Crafting
RegisterServerEvent('jim-catcafe:Crafting:GetItem', function(ItemMake, craftable)
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

local function dupeWarn(src, item)
	local P = QBCore.Functions.GetPlayer(src)
	print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Tried to remove item ^7('^3"..item.."^7')^2 but it wasn't there^7")
	if not Config.Debug then DropPlayer(src, "^1Kicked for attempting to duplicate items") end
	print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Dropped from server for item duplicating^7")
end
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
            info = HighQuality[item] and {highQuality = true, buffJob = 'catcafe'} or {organic = true}
        end
        if player.Functions.AddItem(item, amount or 1, false, info) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount or 1)
            if Config.Debug then print("^5Debug^7: ^4Giving ^2Player^7(^2"..src.."^7) '^6"..QBCore.Shared.Items[item].label.."^7(^2x^6"..(amount or "1").."^7)'") end
        end
    end
end
RegisterNetEvent('jim-catcafe:server:toggleItem', function(give, item, amount, newsrc)
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
	local stashtable = { ["Catcafe_Fridge"] = "Cold Storage", ["Catcafe_Fridge2"] = "Cold Storage", ["Catcafe_Shelf"] = "Prepared Food", ["Catcafe_Counter"] = "Tray", ["Catcafe_Counter2"] = "Tray", }
	for k, v in pairs(stashtable) do exports.ox_inventory:RegisterStash(k, v, 20, 400000) end
	for i = 1, 4 do exports.ox_inventory:RegisterStash("Catcafe_Table_"..i, "Cat Cafe Table "..i, 20, 400000) end
	exports.ox_inventory:RegisterShop("catcafeShop", { name = Config.Items.label, inventory = Config.Items.items })
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
			if itemData and (itemData.name == items) and (itemData.info.quality > 0) then
				if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Item^7: '^3"..tostring(items).."^7' ^2Slot^7: ^3"..itemData.slot.." ^7x(^3"..tostring(itemData.amount).."^7)") end
				count += itemData.amount
			end
		end
		if count >= amount then if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items ^5FOUND^7 x^3"..count.."^7") end return true end
		if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items ^1NOT FOUND^7") end	return false
	end
end

local function CheckVersion()
	PerformHttpRequest('https://raw.githubusercontent.com/jimathy/UpdateVersions/master/jim-catcafe.txt', function(err, newestVersion, headers)
		local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
		if not newestVersion then print("Currently unable to run a version check.") return end
		local advice = "^1You are currently running an outdated version^7, ^1please update^7"
		if newestVersion:gsub("%s+", "") == currentVersion:gsub("%s+", "") then advice = '^6You are running the latest version.^7'
		else print("^3Version Check^7: ^2Current^7: "..currentVersion.." ^2Latest^7: "..newestVersion) end
		print(advice)
	end)
end
CheckVersion()