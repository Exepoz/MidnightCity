local QBCore = exports[Config.Core]:GetCoreObject()
local saveInfo = {}

AddEventHandler('onResourceStart', function(r) if GetCurrentResourceName() ~= r then return end
	for k, v in pairs(Crafting) do for i = 1, #v do
			for l, b in pairs(v[i]) do if not QBCore.Shared.Items[l] then print("^5Debug^7: ^6Crafting^7: ^2Missing Item from ^4QBCore^7.^4Shared^7.^4Items^7: '^6"..l.."^7'") end
				for j, c in pairs(b) do if not QBCore.Shared.Items[j] then print("^5Debug^7: ^6Crafting^7: ^2Missing Item from ^4QBCore^7.^4Shared^7.^4Items^7: '^6"..j.."^7'") end end end end end
	for i = 1, #Config.Items.items do
		if not QBCore.Shared.Items[Config.Items.items[i].name] then print("^5Debug^7: ^6Store^7: ^2Missing Item from ^4QBCore^7.^4Shared^7.^4Items^7: '^6"..Config.Items.items[i].name.."^7'") end
	end
	if not QBCore.Shared.Jobs["whitewidow"] then print("Error: Job role not found - 'whitewidow'") end
end)

local nonConsumable = {
	['gummymould'] = true,
	['grinder'] = true,
	['trimmers'] = true,
}
RegisterServerEvent('jixel-whitewidow:Crafting:GetItem', function(ItemMake, craftable)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	--This grabs the table from client and removes the item requirements
	local amount = 1
	if craftable then
		if craftable["amount"] then amount = craftable["amount"] end
		for k, v in pairs(craftable[ItemMake]) do if not nonConsumable[tostring(k)] then TriggerEvent("jixel-whitewidow:server:toggleItem", false, tostring(k), v, src) end end
	end
	local info
	local i = string.find(ItemMake, "cannabutter") or string.find(ItemMake, "gummy_") or string.find(ItemMake, "edible_")
	if i == 1 then amount, info = 4, saveInfo end
	TriggerEvent("jixel-whitewidow:server:toggleItem", true, ItemMake, amount, src, info)
	saveInfo = {}
end)

RegisterNetEvent('jixel-whitewidow:server:toggleItem', function(give, item, amount, newsrc, info)
	local src = newsrc or source
	local Player = QBCore.Functions.GetPlayer(src)
	if give == 0 or give == false then
		if HasItem(src, item, amount or 1) then -- check if you still have the item
			if item == 'malmo_weed_oz' or item == 'cannabutter' then
				local i = 'malmo_weed_oz' and Player.Functions.GetItemByName('malmo_weed_oz') or 'cannabutter' and Player.Functions.GetItemByName('cannabutter')
				print(Player.PlayerData.items[i.slot].info)
				saveInfo = Player.PlayerData.items[i.slot].info
			end
			if Player.Functions.RemoveItem(item, amount or 1) then
				TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove", amount or 1)
				if Config.Debug then print("^5Debug^7: ^1Removing ^2from Player^7(^2"..src.."^7) '^6"..QBCore.Shared.Items[item].label.."^7(^2x^6"..(amount or "1").."^7)'") end
			end
		else TriggerEvent("jixel-whitewidow:server:DupeWarn", item, src) end -- if not boot the player
	else
		print_table(info)
		if Player.Functions.AddItem(item, amount or 1, false, info) then
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount or 1)
			if Config.Debug then print("^5Debug^7: ^4Giving ^2Player^7(^2"..src.."^7) '^6"..QBCore.Shared.Items[item].label.."^7(^2x^6"..(amount or "1").."^7)'") end
		end
	end
end)

RegisterNetEvent("jixel-whitewidow:server:DupeWarn", function(item, newsrc)
	local src = newsrc or source
	local P = QBCore.Functions.GetPlayer(src)
	print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Tried to remove item ^7('^3"..item.."^7')^2 but it wasn't there^7")
	if not Config.Debug then DropPlayer(src, "^1Kicked for attempting to duplicate items") end
	print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Dropped from server for item duplicating^7")
end)

if Config.Inv == "ox_inv" then
	--Create ox_inv based shop using qb-core versions in config.lua

	for k, v in pairs(Config.Locations) do
		if v.zoneEnable then exports.ox_inventory:RegisterShop(v.job.."ingredients", { name = Config.Items.label, inventory = Config.Items.items, locations = { v.Targets.StoreLoc.xyz, } })	end
	end
	for i = 1, 8 do exports.ox_inventory:RegisterStash("WWTable_"..i, "Whitewidow Table"..i, 20, 400000, nil) end
	for i = 1, 8 do exports.ox_inventory:RegisterStash("WWTray_"..i, "Whitewidow Tray"..i, 20, 400000, nil) end
	for i = 1, 3 do exports.ox_inventory:RegisterStash("WWShelf_"..i, "Whitewidow Shelf"..i, 20, 400000, nil, { ["whitewidow"] = 0, }) end

	for i = 1, 8 do exports.ox_inventory:RegisterStash("BBTable_"..i, "BestBuds Table"..i, 20, 400000, nil) end
	for i = 1, 8 do exports.ox_inventory:RegisterStash("BBTray_"..i, "BestBuds Tray"..i, 20, 400000, nil) end
	for i = 1, 3 do exports.ox_inventory:RegisterStash("BBShelf_"..i, "BestBuds Shelf"..i, 20, 400000, nil, { ["whitewidow"] = 0, }) end


	for i = 1, 8 do exports.ox_inventory:RegisterStash("WCTable_"..i, "Weed Clinic Table"..i, 20, 400000, nil) end
	for i = 1, 8 do exports.ox_inventory:RegisterStash("WCTray_"..i, "Weed Clinic Tray"..i, 20, 400000, nil) end
	for i = 1, 3 do exports.ox_inventory:RegisterStash("WCShelf_"..i, "Weed Clinic Shelf"..i, 20, 400000, nil, { ["whitewidow"] = 0, }) end
	function HasItem(src, items, amount)
		local count = exports.ox_inventory:Search(src, 'count', items)
		if count >= amount then if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^5FOUND^7 x^3"..count.."^7 ^3"..tostring(items)) end return true
        else if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items ^1NOT FOUND^7") end return false end
	end
else
	function HasItem(source, items, amount)
		local amount = amount or 1
		local Player = QBCore.Functions.GetPlayer(source)
		if not Player then return false end
		local count = 0
		for _, itemData in pairs(Player.PlayerData.items) do
			if itemData and (itemData.name == items) then
				if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Item^7: '^3"..tostring(items).."^7' ^2Slot^7: ^3"..itemData.slot.." ^7x(^3"..tostring(itemData.amount).."^7)") end
				count += itemData.amount
			end
		end
		if count >= amount then
			if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items ^5FOUND^7 x^3"..count.."^7") end
			return true
		end
		if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items ^1NOT FOUND^7") end
		return false
	end
end

-- EATY/SMOKEYSMOKEY FUNCTION WOOO -- make sure to put support for Jim Consumables
if not Config.JimConsumables then
	CreateThread(function()
		for _, v in pairs(Joints) do QBCore.Functions.CreateUseableItem(v.Name, function(source, item) TriggerClientEvent('jixel-whitewidow:client:UseDroog', source, item.name) end) end
		for _, v in pairs(Edibles) do QBCore.Functions.CreateUseableItem(v.Name, function(source, item) TriggerClientEvent('jixel-whitewidow:client:UseDroog', source, item.name) end) end
	end)
end