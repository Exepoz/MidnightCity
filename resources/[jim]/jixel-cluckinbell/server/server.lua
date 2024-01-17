local QBCore = exports['qb-core']:GetCoreObject()
AddEventHandler('onResourceStart', function(r) if GetCurrentResourceName() ~= r then return end
	if Config.Inv == "qb" then
		for _, Location in ipairs(Config.Locations) do
				for _, v in pairs(Crafting) do
					for i = 1, #v do
						for l, b in pairs(v[i]) do
							if not QBCore.Shared.Items[l] and l ~= "amount" then print("Crafting: Missing Item from QBCore.Shared.Items: '"..l.."'") end
							if type(b) == "table" then
								for j in pairs(b) do if not QBCore.Shared.Items[j] then print("Crafting: Missing Item from QBCore.Shared.Items: '"..j.."'")
								else
								end
							end
						end
					end
				end
			end
			for _, stores in pairs(Location.Items) do
				for _, item in ipairs(stores.items) do
					if not QBCore.Shared.Items[item.name] then
						print(string.format("^1Error^0: ^2Missing Item from QBCore.Shared.Items^0 `%s`", item.name))
					end
				end
			end
			if not QBCore.Shared.Jobs["cluckinbell"] then print("Error: Job role not found - 'cluckinbell'") end
		end
	elseif Config.Inv == "ox" then
		local items =  {}
		for _, v in pairs(exports.ox_inventory:Items()) do
			items[v.name] = v
		end
		for _, Location in ipairs(Config.Locations) do
			for _, v in pairs(Crafting) do
				for i = 1, #v do
					for l, b in pairs(v[i]) do
						if not items[l] and l ~= "amount" then print("Crafting: Missing Item from QBCore.Shared.Items: '"..l.."'") end
						if type(b) == "table" then
							for j in pairs(b) do if not items[j] then print("Crafting: Missing Item from QBCore.Shared.Items: '"..j.."'")
								else
								end
							end
						end
					end
				end
			end
		end
	end
end)

if not Config.JimConsumables then
	CreateThread(function()
        local drinks = {
            ["cbcoke"] = {thirst = 5},
            ["cborangesoda"] = {thirst = 5},
            ["cblemonlimesoda"] = {thirst = 5},
            ["cbrootbeer"] = {thirst = 5},
			["cbcoffee"] = {thirst = 5},
        }
        for itemName, stats in pairs(drinks) do
            QBCore.Functions.CreateUseableItem(itemName, function(source, item) TriggerClientEvent('jixel-cluckinbell:client:Consume', source, item.name, "drink", stats)
        end) end

        local foods = {
            ["fowlburger"] = {hunger = 5},
            ["cluckfries"] = {hunger = 5},
            ["clucknuggets"] = {hunger = 5},
            ["cluckrings"] = {hunger = 5},
            ["csalad"] = {hunger = 5},
            ["meatfree"] = {hunger = 5},
            ["mightyclucker"] = {hunger = 5},
            ["cbchickenwrap"] = {hunger = 5},
            ["cbucket"] = {hunger = 5},
            ["chocolatecone"] = {hunger = 5},
            ["strawberrycone"] = {hunger = 5},
            ["vanillacone"] = {hunger = 5},
			["cbdonut"] = {hunger = 5},
        }

        for itemName, stats in pairs(foods) do
            QBCore.Functions.CreateUseableItem(itemName, function(source, item)
                TriggerClientEvent('jixel-cluckinbell:client:Consume', source, item.name, "food", stats)
            end)
        end
    end)
end

CreateThread(function()
	QBCore.Functions.CreateUseableItem("clucktoy", function(source, item) TriggerClientEvent('jixel-cluckinbell:client:Open', source, item.name) end)
	QBCore.Functions.CreateUseableItem("littleclucker", function(source, item) TriggerClientEvent('jixel-cluckinbell:Stash', source, {}, item.info["id"], true) end)
	QBCore.Functions.CreateUseableItem("cluckmenu", function(source, item) TriggerClientEvent('jixel-cluckinbell:showMenu', source, Config.MenuImg) end)
end)

RegisterServerEvent("jixel-cluckinbell:server:GrabBag", function()
	local src = source local Player = QBCore.Functions.GetPlayer(src)
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["littleclucker"], "add", 1)
	Player.Functions.AddItem("littleclucker", 1, false, { ["id"] = math.random(1, 9999999) })
end)

---Crafting

-- RegisterServerEvent('jixel-cluckinbell:Crafting:GetItem', function(ItemMake, craftable, amount)
-- 	local src = source
-- 	amount = amount or 1
-- 	if craftable then
-- 		for item, itemAmount in pairs(craftable[ItemMake]) do
-- 			--remove crafting ingredients
-- 			TriggerEvent("jixel-cluckinbell:server:toggleItem", false, tostring(item), itemAmount * amount, src)
-- 		end

-- 		amount = craftable["amount"] and craftable["amount"] * amount or amount
-- 	end
-- 	--gives item
-- 	TriggerEvent("jixel-cluckinbell:server:toggleItem", true, ItemMake, amount or 1, src)
-- end)

---Crafting
RegisterServerEvent('jixel-cluckinbell:Crafting:GetItem', function(ItemMake, craftable)
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
            info = HighQuality[item] and {highQuality = true, buffJob = 'cluckinbell'} or {organic = true}
        end
        if player.Functions.AddItem(item, amount or 1, false, info) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount or 1)
            if Config.Debug then print("^5Debug^7: ^4Giving ^2Player^7(^2"..src.."^7) '^6"..QBCore.Shared.Items[item].label.."^7(^2x^6"..(amount or "1").."^7)'") end
        end
    end
end

RegisterNetEvent('jixel-cluckinbell:server:toggleItem', function(give, item, amount, newsrc)
	local src = newsrc or source
	local amount = amount or 1
	local remamount = amount
	if not give then
		if HasItem(src, item, amount) then -- check if you still have the item
			if QBCore.Functions.GetPlayer(src).Functions.GetItemByName(item).unique then -- If unique item, keep removing until gone
				while remamount > 0 do
					QBCore.Functions.GetPlayer(src).Functions.RemoveItem(item, 1)
					remamount -= 1
				end
				TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove", amount) -- Show removal item box when all are removed
				return
			end
			if QBCore.Functions.GetPlayer(src).Functions.RemoveItem(item, amount) then
				if Config.Debug then print("^5Debug^7: ^1Removing ^2from Player^7(^2"..src.."^7) '^6"..QBCore.Shared.Items[item].label.."^7(^2x^6"..(amount or "1").."^7)'") end
				TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove", amount)
			end
		else TriggerEvent("jixel-cluckinbell:server:DupeWarn", item, src) end -- if not boot the player
	elseif give then
		if QBCore.Functions.GetPlayer(src).Functions.AddItem(item, amount) then
			if Config.Debug then print("^5Debug^7: ^4Giving ^2Player^7(^2"..src.."^7) '^6"..QBCore.Shared.Items[item].label.."^7(^2x^6"..(amount or "1").."^7)'") end
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount)
		end
	end
end)

RegisterNetEvent("jixel-cluckinbell:server:DupeWarn", function(item, newsrc)
	local src = newsrc or source
	local P = QBCore.Functions.GetPlayer(src)
	print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Tried to remove item ^7('^3"..item.."^7')^2 but it wasn't there^7")
	DropPlayer(src, "Kicked for attempting to duplicate items")
	print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Dropped from server for item duplicating^7")
end)


if Config.Inv == "ox" then
	RegisterNetEvent("jixel-cluckinbell:makeOXShop", function(id, label, items)
        exports.ox_inventory:RegisterShop(id, { name = label, inventory = items})
		if Config.Debug then print("^5Debug^7: ^3Registering ^Shop^7: ^3", id, label) end
    end)
    RegisterNetEvent("jixel-cluckinbell:makeOXStash", function(id, label)
        exports.ox_inventory:RegisterStash(id, label, 20, 400000, nil)
       if Config.Debug then print("^5Debug^7: ^3Registering ^2Stash^7: ^3", id, label) end
    end)
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
