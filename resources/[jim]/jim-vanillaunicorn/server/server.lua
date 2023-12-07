local QBCore = exports[Config.Core]:GetCoreObject()
local WashTimes = {}
GlobalState.VUBusinessMeeting = false

AddEventHandler('onResourceStart', function(r) if GetCurrentResourceName() ~= r then return end
	for i = 1, #Config.Locations do
		if Config.Locations[i].zoneEnable then
			if not QBCore.Shared.Jobs[Config.Locations[i].job] then print("^5Debug^7: ^1Error^7: ^2Job role not found ^7- '^6"..Config.Locations[i].job.."^7'") end
			TriggerEvent("jim-jobgarage:server:syncAddLocations", { job = Config.Locations[i].job, garage = Config.Locations[i].garage }) -- Job Garage creation
			TriggerEvent("jim-djbooth:server:AddLocation", { -- DJ Booth Creation
				job = Config.Locations[i].job,
				enableBooth = Config.Locations[i].Booth.enableBooth,
				DefaultVolume = Config.Locations[i].Booth.DefaultVolume,
				radius = Config.Locations[i].Booth.radius,
				coords = Config.Locations[i].Booth.coords,
				soundLoc = Config.Locations[i].Booth.soundLoc or nil
			})
		end
	end
	for k, v in pairs(Crafting) do for i = 1, #v do
			for l, b in pairs(v[i]) do if not QBCore.Shared.Items[l] then print("^5Debug^7: ^6Crafting^7: ^2Missing Item from ^4QBCore^7.^4Shared^7.^4Items^7: '^6"..l.."^7'") end
				for j in pairs(b) do if not QBCore.Shared.Items[j] then print("^5Debug^7: ^6Crafting^7: ^2Missing Item from ^4QBCore^7.^4Shared^7.^4Items^7: '^6"..j.."^7'") end end end end end
	for i = 1, #Config.DrinkItems.items do
		if not QBCore.Shared.Items[Config.DrinkItems.items[i].name] then print("^5Debug^7: ^6Store^7: ^2Missing Item from ^4QBCore^7.^4Shared^7.^4Items^7: '^6"..Config.DrinkItems.items[i].name.."^7'") end
	end
	for i = 1, #Config.FoodItems.items do
		if not QBCore.Shared.Items[Config.FoodItems.items[i].name] then print("^5Debug^7: ^6Store^7: ^2Missing Item from ^4QBCore^7.^4Shared^7.^4Items^7: '^6"..Config.FoodItems.items[i].name.."^7'") end
	end
end)

--Consumables
if not Config.JimConsumables then
	local cocktails = { "gin", "rum", "amaretto", "amarettosour", "bellini", "bloodymary", "cosmopolitan", "longisland", "margarita", "pinacolada", "sangria", "screwdriver", "strawdaquiri", "strawmargarita", "midori", "prosecco", "tequila", "triplsec" }
	for _, v in pairs(cocktails) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('jim-vanillaunicorn:client:Consume', source, item.name, "alcohol") end) end

	local beers = { "ambeer", "dusche", "logger", "pisswasser", "pisswasser2", "pisswasser3" }
	for _, v in pairs(beers) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('jim-vanillaunicorn:client:Consume', source, item.name, "alcohol") end) end

	local drinks = { "sprunk", "sprunklight", "ecola", "ecolalight", "cranberry", "pinejuice" }
	for _, v in pairs(drinks) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('jim-vanillaunicorn:client:Consume', source, item.name, "drink") end) end

	local food = { "chocolate", "vusliders", "vutacos", "nplate", "tots", "nachos", "crisps" }
	for _,v in pairs(food) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('jim-vanillaunicorn:client:Consume', source, item.name, "food") end) end
else
	local foodTable = {
		["midori"] = { emote = "beer3", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(10, 20), canOD = true }},
		["prosecco"] = { emote = "beer3", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(10, 20), canOD = true }},
		["tequila"] = { emote = "beer3", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(10, 20), canOD = true }},
		["triplsec"] = { emote = "beer3", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(10, 20), canOD = true }},
		["gin"] = { emote = "ginb", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(10, 20), canOD = true }},
		["rum"] = { emote = "rumb", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(10, 20), canOD = true }},
		["amaretto"] = { emote = "whiskey", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(10, 20), canOD = true }},
		["amarettosour"] = { emote = "whiskey", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(40, 50), canOD = true }},
		["bellini"] = { emote = "whiskey", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(40, 50), canOD = true }},
		["cosmopolitan"] = { emote = "whiskey", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(40, 50), canOD = true }},
		["longisland"] = { emote = "whiskey", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(40, 50), canOD = true }},
		["margarita"] = { emote = "whiskey", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(40, 50), canOD = true }},
		["pinacolada"] = { emote = "whiskey", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(40, 50), canOD = true }},
		["sangria"] = { emote = "whiskey", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(40, 50), canOD = true }},
		["screwdriver"] = { emote = "whiskey", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(40, 50), canOD = true }},
		["strawdaquiri"] = { emote = "whiskey", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(40, 50), canOD = true }},
		["strawmargarita"] = { emote = "whiskey", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(40, 50), canOD = true }},
		["ambeer"] = { emote = "beer3", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(10, 20), canOD = true }},
		["dusche"] = { emote = "beer1", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(10, 20), canOD = true }},
		["logger"] = { emote = "beer2", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(10, 20), canOD = true }},
		["pisswasser"] = { emote = "beer4", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(10, 20), canOD = true }},
		["pisswasser2"] = { emote = "beer5", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(10, 20), canOD = true }},
		["pisswasser3"] = { emote = "beer6", canRun = true,  time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(10, 20), canOD = true }},
		["cranberry"] = { emote = "wine", canRun = true, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = math.random(20, 20), }},
		["pinejuice"] = { emote = "wine", canRun = true, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = math.random(40, 50), }},
		["ecola"] = { emote = "ecola", canRun = true, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = math.random(10, 20), }},
		["ecolalight"] = { emote = "ecola", canRun = true, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = math.random(10, 20), }},
		["sprunk"] = { emote = "sprunk", canRun = true, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = math.random(10, 20), }},
		["sprunklight"] = { emote = "sprunk", canRun = true, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = math.random(10, 20), }},
		["chocolate"] = { emote = "egobar", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(10, 20), }},
		["crisps"] = { emote = "crisps", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		["cubasil"] = { emote = "burger", canRun = true, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		["mintleaf"] = { emote = "burger", canRun = true, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		["peach"] = { emote = "burger", canRun = true, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		["strawberry"] = { emote = "burger", canRun = true, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		["chocolate"] = { emote = "egobar", canRun = true, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
		["nplate"] = { emote = "burger", canRun = true, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(40, 50), }},
		["vusliders"] = { emote = "burger", canRun = true, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(40, 50), }},
		["vutacos"] = { emote = "burger", canRun = true, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(40, 50), }},
		["tots"] = { emote = "burger", canRun = true, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(40, 50), }},
		["nachos"] = { emote = "burger", canRun = true, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(40, 50), }},
	}
	local emoteTable = {
		["whiskeyb"] = {"mp_player_intdrink", "loop_bottle", "(Don't Use) Whiskey Bottle", AnimationOptions = { Prop = "prop_cs_whiskey_bottle", PropBone = 60309, PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0}, EmoteMoving = true, EmoteLoop = true }},
		["rumb"] = {"mp_player_intdrink", "loop_bottle", "(Don't Use) Rum Bottle", AnimationOptions = { Prop = "prop_rum_bottle", PropBone = 18905, PropPlacement = {0.03, -0.18, 0.10, 240.0, -60.0}, EmoteMoving = true, EmoteLoop = true }},
		["icream"] = {"mp_player_intdrink", "loop_bottle", "Irish Cream Bottle", AnimationOptions = { Prop = "prop_bottle_brandy", PropBone = 18905, PropPlacement = {0.00, -0.26, 0.10, 240.0, -60.0},	EmoteMoving = true, EmoteLoop = true }},
		["ginb"] =  {"mp_player_intdrink", "loop_bottle", "(Don't Use) Gin Bottle", AnimationOptions = { Prop = "prop_tequila_bottle", PropBone = 18905, PropPlacement = {0.00, -0.26, 0.10, 240.0, -60.0},	EmoteMoving = true, EmoteLoop = true }},
		["vodkab"] = {"mp_player_intdrink", "loop_bottle", "(Don't Use) Vodka Bottle", AnimationOptions = { Prop = 'prop_vodka_bottle', PropBone = 18905, PropPlacement = {0.00, -0.26, 0.10, 240.0, -60.0}, EmoteMoving = true, EmoteLoop = true }},
		["crisps"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Chrisps", AnimationOptions = { Prop = 'v_ret_ml_chips2', PropBone = 28422, PropPlacement = {0.01, -0.05, -0.1, 0.0, 0.0, 90.0}, EmoteLoop = true, EmoteMoving = true, }},
		["beer1"] = {"mp_player_intdrink", "loop_bottle", "Dusche", AnimationOptions = { Prop = "prop_beerdusche", PropBone = 18905, PropPlacement = {0.04, -0.14, 0.10, 240.0, -60.0}, EmoteMoving = true, EmoteLoop = true, }},
		["beer2"] = {"mp_player_intdrink", "loop_bottle", "Logger", AnimationOptions = { Prop = "prop_beer_logopen", PropBone = 18905, PropPlacement = {0.03, -0.18, 0.10, 240.0, -60.0}, EmoteMoving = true, EmoteLoop = true, }},
		["beer3"] = {"mp_player_intdrink", "loop_bottle", "AM Beer", AnimationOptions = { Prop = "prop_beer_amopen", PropBone = 18905, PropPlacement = {0.03, -0.18, 0.10, 240.0, -60.0}, EmoteMoving = true, EmoteLoop = true, }},
		["beer4"] = {"mp_player_intdrink", "loop_bottle", "Pisswasser1", AnimationOptions = { Prop = "prop_beer_pissh", PropBone = 18905, PropPlacement = {0.03, -0.18, 0.10, 240.0, -60.0}, EmoteMoving = true, EmoteLoop = true, }},
		["beer5"] = {"mp_player_intdrink", "loop_bottle", "Pisswasser2", AnimationOptions = { Prop = "prop_amb_beer_bottle", PropBone = 18905, PropPlacement = {0.12, 0.008, 0.03, 240.0, -60.0}, EmoteMoving = true, EmoteLoop = true, }},
		["beer6"] = {"mp_player_intdrink", "loop_bottle", "Pisswasser3", AnimationOptions = { Prop = "prop_cs_beer_bot_02", PropBone = 18905, PropPlacement = {0.12, 0.008, 0.03, 240.0, -60.0}, EmoteMoving = true, EmoteLoop = true, }},
		["ecola"] = {"mp_player_intdrink", "loop_bottle", "E-cola", AnimationOptions = { Prop = "prop_ecola_can", PropBone = 18905, PropPlacement = {0.12, 0.008, 0.03, 240.0, -60.0}, EmoteMoving = true, EmoteLoop = true, }},
		["sprunk"] = {"mp_player_intdrink", "loop_bottle", "Sprunk", AnimationOptions = { Prop = "v_res_tt_can03", PropBone = 18905, PropPlacement = {0.12, 0.008, 0.03, 240.0, -60.0}, EmoteMoving = true, EmoteLoop = true, }},
	}
	for k, v in pairs(foodTable) do TriggerEvent("jim-consumables:server:syncAddItem", k, v) end
	for k, v in pairs(emoteTable) do TriggerEvent("jim-consumables:server:syncAddEmote", k, v) end
end

QBCore.Functions.CreateCallback('jim-vanillaunicorn:GetCash', function(source, cb)
	cb(QBCore.Functions.GetPlayer(source).Functions.GetMoney("cash"))
end)

QBCore.Functions.CreateCallback('jim-vanillaunicorn:GetMarkedCash', function(source, cb)
	local Player = QBCore.Functions.GetPlayer(source)
	if WashTimes[Player.PlayerData.citizenid] == nil or WashTimes[Player.PlayerData.citizenid] == 0 or os.time() >= WashTimes[Player.PlayerData.citizenid]+3600 then
		if not Player.Functions.GetItemByName('markedbills') then
			TriggerClientEvent('QBCore:Notify', source, "You don't have any marked bills on you...", "error")
			cb(false)
		else cb(true) end
	else
		TriggerClientEvent('QBCore:Notify', source, "You just gave me some money, give me some time to wash it! Come back in an hour.", "error")
		cb(false)
	end
end)

RegisterServerEvent("jim-vanillaunicorn:sPresentPlayer", function(target)
	local src = source
	local Player = QBCore.Functions.GetPlayer(target)
	if not Player then return end
	Player.Functions.SetMetaData("canVUWash", true)
	TriggerClientEvent('QBCore:Notify', target, "Well hello "..Player.PlayerData.charinfo.firstname..", nice to meet you!.", "success")
	TriggerClientEvent('QBCore:Notify', src, Player.PlayerData.charinfo.firstname.." has been acquainted.", "success")
end)

RegisterServerEvent("jim-vanillaunicorn:StrepTip", function()
	QBCore.Functions.GetPlayer(source).Functions.RemoveMoney("cash", Config.TipCost)
	exports['qb-management']:AddMoney('vanilla', math.floor(Config.TipCost/3))
end)

RegisterServerEvent("jim-vanillaunicorn:BusinessMeeting", function()
	local str = GlobalState.VUBusinessMeeting and 'ended' or 'started'
	TriggerClientEvent('QBCore:Notify', source, "You have "..str.." the business meeting.", "info")
	GlobalState.VUBusinessMeeting = not GlobalState.VUBusinessMeeting
end)

RegisterServerEvent("jim-vanillaunicorn:StrepWash", function()
	local src = source
	local worth, remAmount = 0, 0
	local Player = QBCore.Functions.GetPlayer(src)
	local marked = Player.Functions.GetItemsByName("markedbills")
	for _,v in pairs(marked) do
		for i = 1, v.amount do
			if worth >= 25000 then break end
			worth = worth + Player.PlayerData.items[v.slot].info.worth
			Player.Functions.RemoveItem('markedbills', 1, v.slot)
			remAmount = remAmount + 1
		end
	end
	WashTimes[Player.PlayerData.citizenid] = os.time()
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "remove", remAmount)
	local VUAmount = 0.2 * worth
	local girlAmount = VUAmount/2
	local playerAmount = worth - VUAmount - girlAmount
	exports['qb-management']:AddMoney('vanilla', math.floor(VUAmount))
	Player.Functions.AddMoney("cash", math.floor(playerAmount))
end)

---Crafting
RegisterServerEvent('jim-vanillaunicorn:Crafting:GetItem', function(ItemMake, craftable)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local amount = 1
	if craftable then
		if craftable["amount"] then amount = craftable["amount"] end
		for k, v in pairs(craftable[ItemMake]) do TriggerEvent("jim-vanillaunicorn:server:toggleItem", false, tostring(k), v, src) end
	end
	TriggerEvent("jim-vanillaunicorn:server:toggleItem", true, ItemMake, amount, src)
end)

RegisterServerEvent("jim-vanillaunicorn:server:Urinal", function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local thirstamt = math.random(10,30)
	local getthirsty = Player.PlayerData.metadata.thirst - thirstamt
	Player.Functions.SetMetaData('thirst', getthirsty)
	TriggerClientEvent("hud:client:UpdateNeeds", src, getthirsty, Player.PlayerData.metadata.thirst)
end)

RegisterServerEvent("jim-vanillaunicorn:server:Potty", function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local thirstamt = math.random(10,30)
	local getthirsty = Player.PlayerData.metadata.thirst - thirstamt
	Player.Functions.SetMetaData('thirst', getthirsty)
	TriggerClientEvent("hud:client:UpdateNeeds", src, getthirsty, Player.PlayerData.metadata.thirst)
end)

local function dupeWarn(src, item)
	local P = QBCore.Functions.GetPlayer(src)
	print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Tried to remove item ^7('^3"..item.."^7')^2 but it wasn't there^7")
	if not Config.Debug then DropPlayer(src, "^1Kicked for attempting to duplicate items") end
	print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Dropped from server for item duplicating^7")
end

RegisterNetEvent('jim-vanillaunicorn:server:toggleItem', function(give, item, amount, newsrc)
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
	local stashtable = { ["UniStorage"] = "VU Storage", ["UniCounter"] = "Tray", ["BMStorage"] = "BM Storage", ["BahaCounter"] = "Tray", ["BahaCounter2"] = "Tray", }
	for k, v in pairs(stashtable) do exports.ox_inventory:RegisterStash(k, v, 20, 400000) end

	local tabletable = 19
	for i = 1, 19 do exports.ox_inventory:RegisterStash("Bahama_Table"..i, "Bahama Mama Table "..i, 20, 400000) end

	local shoptable = { ["UniFoodfrige"] = Config.FoodItems, ["UniDrinkfrige"] = Config.DrinkItems, }
	for k, v in pairs(shoptable) do exports.ox_inventory:RegisterShop(k, { name = v.label, inventory = v.items }) end
	function HasItem(src, items, amount)
		local count = exports.ox_inventory:Search(src, 'count', items)
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
	PerformHttpRequest('https://raw.githubusercontent.com/jimathy/UpdateVersions/master/jim-vanillaunicorn.txt', function(err, newestVersion, headers)
		local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
		if not newestVersion then print("Currently unable to run a version check.") return end
		local advice = "^1You are currently running an outdated version^7, ^1please update^7"
		if newestVersion:gsub("%s+", "") == currentVersion:gsub("%s+", "") then advice = '^6You are running the latest version.^7'
		else print("^3Version Check^7: ^2Current^7: "..currentVersion.." ^2Latest^7: "..newestVersion) end
		print(advice)
	end)
end
CheckVersion()