local QBCore = exports[Config.CoreOptions.CoreName]:GetCoreObject()
local picked = true
local killed = true


RegisterNetEvent('QBCore:Server:UpdateObject', function() if source ~= '' then  end QBCore = exports[Config.CoreOptions.CoreName]:GetCoreObject() end)

RegisterNetEvent('jixel-farming:server:GetJob', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
		Player.Functions.SetJob("farmer", 0)
		triggerNotify(nil, Loc[Config.CoreOptions.Lan].success["hired"], "success", src)
end)

RegisterNetEvent('jixel-farming:server:RemoveJob', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
		Player.Functions.SetJob("unemployed", 0)
		triggerNotify(nil, Loc[Config.CoreOptions.Lan].success["quit"], 'success', src)
end)



--[[
  _______   _____    ______   ______
 |__   __| |  __ \  |  ____| |  ____|
    | |    | |__) | | |__    | |__
    | |    |  _  /  |  __|   |  __|
    | |    | | \ \  | |____  | |____
  __|_|_  _|_|  \_\_|______| |______|  _______    _____
 |  ____| \ \    / / |  ____| | \ | | |__   __|  / ____|
 | |__     \ \  / /  | |__    |  \| |    | |    | (___
 |  __|     \ \/ /   |  __|   | . ` |    | |     \___ \
 | |____     \  /    | |____  | |\  |    | |     ____) |
 |______|     \/     |______| |_| \_|    |_|    |_____/
--]]

RegisterServerEvent("jixel-farming:getTree", function(amount, Zone)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player.Functions.AddItem(Zone.Item, amount) then
		TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Zone.Item], "add", amount)
		if Config.ScriptOptions.FarmingRep then
			Player.Functions.SetMetaData("farmingrep",  Player.PlayerData.metadata["farmingrep"] + Zone.RepAmount)
				if Config.ScriptOptions.FarmingRepNotifications then
					triggerNotify(nil, "You Received "..json.encode(Zone.RepAmount).." Rep", "success", src)
		  	end
		end
		picked = picked and true
	else
		triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["full"], "error", src)
		picked = picked and false
	end
end)

--[[
  _____    _                   _   _   _______
 |  __ \  | |          /\     | \ | | |__   __|
 | |__) | | |         /  \    |  \| |    | |
 |  ___/  | |        / /\ \   | . ` |    | |
 | |      | |____   / ____ \  | |\  |    | |
 |_|____  |______|_/_/____\_\ |_| \_|  __|_|__    _____
 |  ____| \ \    / / |  ____| | \ | | |__   __|  / ____|
 | |__     \ \  / /  | |__    |  \| |    | |    | (___
 |  __|     \ \/ /   |  __|   | . ` |    | |     \___ \
 | |____     \  /    | |____  | |\  |    | |     ____) |
 |______|     \/     |______| |_| \_|    |_|    |_____/


--]]

RegisterServerEvent("jixel-farming:getPlant", function(amount, Zone)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.AddItem(Zone.Item, amount) then
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Zone.Item], "add", amount)
    if Config.ScriptOptions.FarmingRep then
        Player.Functions.SetMetaData("farmingrep",  Player.PlayerData.metadata["farmingrep"] + Zone.RepAmount)
        if Config.ScriptOptions.FarmingRepNotifications then
			triggerNotify(nil, "You Received "..json.encode(Zone.RepAmount).." Rep", "success", src)
		end
    end
        picked = picked and true
    else
        triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["full"], "error", src)
        picked = picked and false
    end
end)


RegisterServerEvent('jixel-farming:Crafting:GetItem', function(ItemMake, craftable)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local amount = 1
	if craftable then
		if craftable["amount"] then amount = craftable["amount"] end
		for k, v in pairs(craftable[ItemMake]) do TriggerEvent("jixel-farming:server:toggleItem", false, tostring(k), v, src) end
	end
	TriggerEvent("jixel-farming:server:toggleItem", true, ItemMake, amount, src)
	local htmllist = {
        {["name"] = "Crafted Item", ["value"] = ItemMake, ["inline"] = true},
        {["name"] = "Amount Crafted", ["value"] = amount, ["inline"] = true},
    }
	for i, discord in ipairs(Discord.CraftingReports) do
	if discord then
    local info = { color = 1942002, htmllink = discord.link, thumbnail = "https://i.imgur.com/uj6elfl.png"}
		sendToDiscord(
			info.color,
			Loc[Config.CoreOptions.Lan].discord["craftingLog"],
			" ["..Player.PlayerData.citizenid.."] - "..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname.." - " ..Loc[Config.CoreOptions.Lan].discord["crafted"]..": ",
			Loc[Config.CoreOptions.Lan].discord["crafting_info"],
			htmllist,
			info
		)
		end
	end
end)

RegisterNetEvent("jixel-farming:server:toggleItem", function(give, item, amount, newsrc)

	local src = newsrc or source
	local Player = QBCore.Functions.GetPlayer(src)
	local amount = amount or 1
	local remamount = amount
	if not give then
		if Config.DebugOptions.Debug then print("^5Debug^7: ^1Removing ^2from Player^7(^2"..src.."^7)") end
		if HasItem(src, item, amount) then -- check if you still have the item
			while remamount > 0 do
				if Player.Functions.RemoveItem(item, 1) then
					remamount -= 1
					if Config.DebugOptions.Debug then print("^5Debug^7: ^1Removing ^2from Player^7(^2"..src.."^7) '^6"..QBCore.Shared.Items[item].label.."^7(^2x^6"..(amount or "1").."^7)'") end
				end
			end
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove", amount) -- Show removal item box when all are removed
		else TriggerEvent("jixel-farming:DupeWarn", item, src) end -- if not boot the player
	elseif give then
		if Player.Functions.AddItem(item, amount) then
			if Config.DebugOptions.Debug then print("^5Debug^7: ^4Giving ^2Player^7(^2"..src.."^7) '^6"..QBCore.Shared.Items[item].label.."^7(^2x^6"..(amount or "1").."^7)'") end
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount)
		end
	end
end)


if Config.CoreOptions.Inv == "ox" then
	function HasItem(src, items, amount)
		local count = exports.ox_inventory:Search(src, 'count', items)
		if count >= amount then if Config.DebugOptions.Debug then
			print("^5Debug^7: ^3HasItem^7: ^5FOUND^7 x^3"..count.."^7 ^3"..tostring(items))
		end return true
		else if Config.DebugOptions.Debug then
			print("^5Debug^7: ^3HasItem^7: ^2Items ^1NOT FOUND^7")
		end return false end
	end
else
	function HasItem(source, items, amount)
		local amount = amount or 1
		local Player = QBCore.Functions.GetPlayer(source)
		if not Player then return false end
		local count = 0
		for _, itemData in pairs(Player.PlayerData.items) do
			if itemData and (itemData.name == items) then
				if Config.DebugOptions.Debug then
					print("^5Debug^7: ^3HasItem^7: ^2Item^7: '^3"..tostring(items).."^7' ^2Slot^7: ^3"..itemData.slot.." ^7x(^3"..tostring(itemData.amount).."^7)")
				end
				count += itemData.amount
			end
		end
		if count >= amount then
			if Config.DebugOptions.Debug then
				print("^5Debug^7: ^3HasItem^7: ^2Items ^5FOUND^7 x^3"..count.."^7")
			end
			return true
		end
		if Config.DebugOptions.Debug then
			print("^5Debug^7: ^3HasItem^7: ^2Items ^1NOT FOUND^7")
		end
		return false
	end
end

RegisterNetEvent("jixel-farming:Selling", function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(data.item) ~= nil then
        local amount = Player.Functions.GetItemByName(data.item).amount
        local pay = amount * SellItems[data.item].price
        if Config.BankingOptions.RenewedBanking then
            Player.Functions.RemoveItem(data.item, amount)
            Player.Functions.AddMoney('bank', pay, 'FarmSeller')
            exports['Renewed-Banking']:handleTransaction(Player.PlayerData.citizenid, "Personal Account / "..Player.PlayerData.citizenid, pay, "You've been paid $"..pay.." for selling "..amount.." "..data.item.." to the Farm Shop", "Farm Broker", "Farm Store", 'deposit')
        else
            Player.Functions.RemoveItem(data.item, amount)
            Player.Functions.AddMoney('bank', pay, 'FarmSeller')
        end
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[data.item], 'remove', amount)
		for i, discord in ipairs(Discord.SellerReports) do
			if discord then
        TriggerEvent("jixel-farming:server:SellingDiscordLog",
		{colour = 1942002, htmllink = discord.link, shopName = "Farm Shop"}, data.item, pay, Player)
			end
		end
    else
        triggerNotify(src, Loc[Config.CoreOptions.Lan].error["donthave"].." "..QBCore.Shared.Items[data.item].label, "error")
    end
end)


RegisterNetEvent('jixel-farming:server:SlaughterDiscordLog', function(info, entity, amount)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local htmllist = {
		{["name"] = "Animal Type", ["value"] = entity, ["inline"] = true},
		{["name"] = "Meat Rewarded", ["value"] = amount, ["inline"] = true},
	}
	sendToDiscord(
		info.colour,
		Loc[Config.CoreOptions.Lan].discord["slaughterLog"],
		" ["..Player.PlayerData.citizenid.."] - "..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname.." "..Loc[Config.CoreOptions.Lan].discord["slaughtered"]..": ",
		Loc[Config.CoreOptions.Lan].discord["slaughter_info"],
		htmllist,
		info
	)
end)

RegisterNetEvent("jixel-farming:server:SlaughterRunDiscordLog", function(info, animalType, difficulty)
	local src = source
	local player = QBCore.Functions.GetPlayer(src)
	local RepAmount = player.PlayerData.metadata["farmingrep"]
	local htmllist = {
		{["name"] = "Animal Type", ["value"] = animalType, ["inline"] = true},
		{["name"] = "Difficulty", ["value"] = difficulty, ["inline"] = true},
		{["name"] = "Player", ["value"] = player.PlayerData.citizenid,  ["inline"] = true},
	}

	-- Insert rep amount into discord log if Config.ScriptOptions.FarmingRep is true
	if Config.ScriptOptions.FarmingRep then
		if RepAmount ~= nil then
		table.insert(htmllist, {["name"] = "Rep Amount Started", ["value"] = RepAmount, ["inline"] = true})
		else
		table.insert(htmllist, {["name"] = "Rep Amount Started", ["value"] = 0, ["inline"] = true})
		end
	end

	sendToDiscord(
		info.colour,
		Loc[Config.CoreOptions.Lan].discord["slaughterrun"],
		Loc[Config.CoreOptions.Lan].discord["slaughter_started"].." ["..player.PlayerData.citizenid.."] - "..player.PlayerData.charinfo.firstname.." "..player.PlayerData.charinfo.lastname,
		Loc[Config.CoreOptions.Lan].discord["animal_type"].." " .. animalType,
		htmllist,
		info
	)
end)


RegisterNetEvent("jixel-farming:server:SellingDiscordLog", function(info, item, pay, player)
    local htmllist = {
        {["name"] = "Sold Item", ["value"] = item, ["inline"] = true},
        {["name"] = "Amount Paid", ["value"] = "$"..pay, ["inline"] = true},
    }
    sendToDiscord(
        info.colour,
		Loc[Config.CoreOptions.Lan].discord["sellingLog"],
        Loc[Config.CoreOptions.Lan].discord["sold"].." ["..player.PlayerData.citizenid.."] - "..player.PlayerData.charinfo.firstname.." "..player.PlayerData.charinfo.lastname,
        Loc[Config.CoreOptions.Lan].discord["amount_paid"] ..pay,
        htmllist,
        info
    )
end)
