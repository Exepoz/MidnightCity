--Create Usable Items
for k, v in pairs({
	["car_armor"] = 'jim-mechanic:client:applyArmour',
	["turbo"] = "jim-mechanic:client:applyTurbo",
	["headlights"] = "jim-mechanic:client:applyXenons",
	["underglow_controller"] = 'jim-mechanic:client:neonMenu',
	["mechanic_tools"] = 'jim-mechanic:client:Repair:Check',
	["rims"] = 'jim-mechanic:client:Rims:Check',
	["paintcan"] = 'jim-mechanic:client:Paints:Check',
	["tires"] = 'jim-mechanic:client:Tires:Check',
	["ducttape"] = "jim-mechanic:quickrepair",
	["bprooftires"] = "jim-mechanic:client:applyBulletProof",
	["drifttires"] = "jim-mechanic:client:applyDrift",
	["antilag"] = "jim-mechanic:client:applyAntiLag",
}) do
QBCore.Functions.CreateUseableItem(k, function(source, item) TriggerClientEvent(v, source) end) end

if not Config.Overrides.disableNos then
	QBCore.Functions.CreateUseableItem("nos", function(source, item) TriggerClientEvent("jim-mechanic:client:applyNOS", source) end)
end

for _, v in pairs({ "exhaust", "hood", "rollcage", "bumper", "externals", "livery", "internals", "roof", "spoiler", "skirts", "customplate", "seat", "tint_supplies", "horn" }) do
	QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent("jim-mechanic:client:Cosmetic:Check", source, item.name) end)
end

QBCore.Functions.CreateUseableItem("cleaningkit", function(source, item) TriggerClientEvent('jim-mechanic:client:cleanVehicle', source, true) end)

QBCore.Functions.CreateUseableItem("toolbox", function(source, item) TriggerClientEvent('jim-mechanic:client:Menu', source, true) end)

for i = 1, 5 do
	QBCore.Functions.CreateUseableItem("suspension"..i, function(source, item) TriggerClientEvent("jim-mechanic:client:applySuspension", source, i-1) end)
	QBCore.Functions.CreateUseableItem("engine"..i, function(source, item) TriggerClientEvent("jim-mechanic:client:applyEngine", source, i-1) end)
end
for i = 1, 4 do
	QBCore.Functions.CreateUseableItem("transmission"..i, function(source, item) TriggerClientEvent("jim-mechanic:client:applyTransmission", source, i-1) end)
end
for i = 1, 3 do
	QBCore.Functions.CreateUseableItem("brakes"..i, function(source, item) TriggerClientEvent("jim-mechanic:client:applyBrakes", source, i-1) end)
	QBCore.Functions.CreateUseableItem("oilp"..i, function(source, item) TriggerClientEvent("jim-mechanic:client:applyExtraPart", source, { level = i, mod = "oilp" }) end)
	if Config.Repairs.ExtraDamages then
		QBCore.Functions.CreateUseableItem("drives"..i, function(source, item) TriggerClientEvent("jim-mechanic:client:applyExtraPart", source, { level = i, mod = "drives" }) end)
		QBCore.Functions.CreateUseableItem("cylind"..i, function(source, item) TriggerClientEvent("jim-mechanic:client:applyExtraPart", source, { level = i, mod = "cylind" }) end)
		QBCore.Functions.CreateUseableItem("cables"..i, function(source, item) TriggerClientEvent("jim-mechanic:client:applyExtraPart", source, { level = i, mod = "cables" }) end)
		QBCore.Functions.CreateUseableItem("fueltank"..i, function(source, item) TriggerClientEvent("jim-mechanic:client:applyExtraPart", source, { level = i, mod = "fueltank" }) end)
	end
end

if Config.System.Inv == "ox" then
	--HasItem OX
	function HasItem(src, items, amount) local count = exports.ox_inventory:Search(src, 'count', items)
		if exports.ox_inventory:Search(src, 'count', items) >= (amount or 1) then if Config.System.Debug then print("^5Debug^7: ^3HasItem^7: ^5FOUND^7 x^3"..count.."^7 ^3"..tostring(items)) end return true
        else if Config.System.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items ^1NOT FOUND^7") end return false end
	end
else
	--HasItem QB
	function HasItem(source, items, amount)
		local amount, count = amount or 1, 0
		local Player = QBCore.Functions.GetPlayer(source)
		if Config.System.Debug then print("^5Debug^7: ^3HasItem^7: ^2Checking if player has required item^7 '^3"..tostring(items).."^7'") end
		for _, itemData in pairs(Player.PlayerData.items) do
			if itemData and (itemData.name == items) then
				if Config.System.Debug then print("^5Debug^7: ^3HasItem^7: ^2Item^7: '^3"..tostring(items).."^7' ^2Slot^7: ^3"..itemData.slot.." ^7x(^3"..tostring(itemData.amount).."^7)") end
				count += itemData.amount
			end
		end
		if count >= amount then if Config.System.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items ^5FOUND^7 x^3"..count.."^7") end return true end
		if Config.System.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items ^1NOT FOUND^7") end	return false
	end
end

AddEventHandler('onResourceStart', function(r) if GetCurrentResourceName() ~= r then return end
local itemcheck = true
--Check crafting recipes and their ingredients
if Config.StoreCraft.Crafting then
	for k, v in pairs(Crafting) do for i = 1, #v do for l, b in pairs(v[i]) do if l ~= "amount" and l ~= "job" then
			if not QBCore.Shared.Items[l] then print("^5Debug^7: ^3onResourceStart^7: ^2Missing Item from ^4Shared^7.^4Items^7: '^6"..l.."^7'") itemcheck = false end
			for j in pairs(b) do if not QBCore.Shared.Items[j] then print("^5Debug^7: ^3onResourceStart^7: ^2Missing Item from ^4Shared^7.^4Items^7: '^6"..j.."^7'") itemcheck = false end	end	end	end	end
		end
	end
	-- Check Stores for missing items
	if Config.StoreCraft.Stores then
		for _, v in pairs(Stores) do
			for i = 1, #v.items do if not QBCore.Shared.Items[v.items[i].name] then print("^5Debug^7: ^3onResourceStart^7: ^2Missing Item from ^4Shared^7.^4Items^7: '^6"..v.items[i].name.."^7'") itemcheck = false end end
		end
	end
	-- Check if theres a missing item/mistake in the repair materials
	if not FreeRepair then
		if not QBCore.Shared.Items[Config.Repairs.Parts["engine"].part] then print("^5Debug^7: ^3onResourceStart^7: ^2Engine repair requested a item missing from the Shared^7: '"..Config.Repairs.Parts["engine"].part.."^7'") itemcheck = false end
		if not QBCore.Shared.Items[Config.Repairs.Parts["body"].part] then print("^5Debug^7: ^3onResourceStart^7: ^2Body repair requested a item missing from the Shared^7: '"..Config.Repairs.Parts["body"].part.."^7'") itemcheck = false end
		if Config.Repairs.ExtraDamages then
			if not QBCore.Shared.Items[Config.Repairs.Parts["oil"].part] then print("^5Debug^7: ^3onResourceStart^7: ^2Radiator repair requested a item missing from the Shared^7: '^6"..Config.Repairs.Parts["oil"].part.."^7'") itemcheck = false end
			if not QBCore.Shared.Items[Config.Repairs.Parts["axle"].part] then print("^5Debug^7: ^3onResourceStart^7: ^2Axle repair requested a item missing from the Shared^7: '^6"..Config.Repairs.Parts["axle"].part.."^7'") itemcheck = false end
			if not QBCore.Shared.Items[Config.Repairs.Parts["spark"].part] then print("^5Debug^7: ^3onResourceStart^7: ^2Brakes repair requested a item missing from the Shared^7: '^6"..Config.Repairs.Parts["spark"].part.."^7'") itemcheck = false end
			if not QBCore.Shared.Items[Config.Repairs.Parts["battery"].part] then print("^5Debug^7: ^3onResourceStart^7: ^2Clutch repair requested a item missing from the Shared^7: '^6"..Config.Repairs.Parts["battery"].part.."^7'") itemcheck = false end
			if not QBCore.Shared.Items[Config.Repairs.Parts["fuel"].part] then print("^5Debug^7: ^3onResourceStart^7: ^2FuelTank repair requested a item missing from the Shared^7: '^6"..Config.Repairs.Parts["fuel"].part.."^7'") itemcheck = false end
		end
	end
	-- Check for "mechboard" item
	if not QBCore.Shared.Items["mechboard"] then print("^5Debug^7: ^3onResourceStart^7: ^2Missing Item from ^4Shared^7.^4Items^7: '^6mechboard^7'") itemcheck = false end
	for k, v in pairs(Config.Main.JobRoles) do
		if not QBCore.Shared.Jobs[v] then print("^5Debug^7: ^3onResourceStart^7: ^4Config^7.^4Jobroles ^2tried to find the missing job^7: '^6"..v.."^7'") end
	end
	--Success message if all there.
	if Config.System.Debug and itemcheck then print("^5Debug^7: ^3onResourceStart^7: ^2All items found in the shared^7!") end
end)