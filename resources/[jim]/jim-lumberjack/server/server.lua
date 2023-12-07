QBCore.Functions.CreateUseableItem("cardhat", function(source, item) TriggerClientEvent("jim-mechanic:carboardHat", source) end)
QBCore.Functions.CreateUseableItem("walkstick", function(source, item) TriggerClientEvent("jim-lumberjack:walkstick", source) end)
for i = 1, 21 do QBCore.Functions.CreateUseableItem("origami"..i, function(source, item) TriggerClientEvent("jim-lumberjack:origamiani", source) end) end

local function dupeWarn(src, item)
	local P = QBCore.Functions.GetPlayer(src)
	print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Tried to remove item ^7('^3"..item.."^7')^2 but it wasn't there^7")
	if not Config.Debug then DropPlayer(src, "^1Kicked for attempting to duplicate items") end
	print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Dropped from server for item duplicating^7")
end

RegisterNetEvent('jim-lumberjack:server:toggleItem', function(give, item, amount, newsrc)
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

---Crafting
RegisterServerEvent('jim-lumberjack:GetItem', function(data)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	--This grabs the table from client and removes the item requirements
	if Player.Functions.AddItem(data.item, data.craftable[data.tablenumber]["amount"] or 1) then
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[data.item], "add", data.craftable[data.tablenumber]["amount"] or 1)
		if Config.Debug then print("^5Debug^7: ^4Giving ^2Player^7(^2"..src.."^7) '^6"..QBCore.Shared.Items[data.item].label.."^7(^2x^6"..(data.craftable[data.tablenumber]["amount"] or 1).."^7)'") end
		for k, v in pairs(data.craftable[data.tablenumber][data.item]) do
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[tostring(k)], "remove", v)
			Player.Functions.RemoveItem(tostring(k), v)
			if Config.Debug then print("^5Debug^7: ^1Removing ^2from Player^7(^2"..src.."^7) '^6"..QBCore.Shared.Items[k].label.."^7(^2x^6"..v.."^7)'") end
		end
	end
	--Try to send back to craftmenu
	TriggerClientEvent("jim-lumberjack:CraftMenu", src, data)
end)

RegisterNetEvent("jim-lumberjack:Selling", function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(data.item) ~= nil then
        local amount = (Player.Functions.GetItemByName(data.item).amount or Player.Functions.GetItemByName(data.item).count)
        local pay = (amount * Config.SellItems[data.item])
        Player.Functions.RemoveItem(data.item, amount)
        Player.Functions.AddMoney('cash', pay)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[data.item], 'remove', amount)
    else
        TriggerClientEvent("QBCore:Notify", src, Loc[Config.Lan].error["dont_have"].." "..QBCore.Shared.Items[data.item].label, "error")
    end
end)

if Config.Inv == "ox" then
	exports.ox_inventory:RegisterShop("lumberjack", { name = Config.Items.label, inventory = Config.Items.items })
	for i = 1, 4 do exports.ox_inventory:RegisterStash("Bakery_Table"..i, "Bakery Table"..i, 20, 400000) end
	exports.ox_inventory:RegisterShop("bakeShop", { name = Config.Items.label, inventory = Config.Items.items })
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
	PerformHttpRequest('https://raw.githubusercontent.com/jimathy/UpdateVersions/master/jim-lumberjack.txt', function(err, newestVersion, headers)
		local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
		if not newestVersion then print("Currently unable to run a version check.") return end
		local advice = "^1You are currently running an outdated version^7, ^1please update^7"
		if newestVersion:gsub("%s+", "") == currentVersion:gsub("%s+", "") then advice = '^6You are running the latest version.^7'
		else print("^3Version Check^7: ^2Current^7: "..currentVersion.." ^2Latest^7: "..newestVersion:sub(1, -2)) end
		print(advice)
	end)
end
CheckVersion()