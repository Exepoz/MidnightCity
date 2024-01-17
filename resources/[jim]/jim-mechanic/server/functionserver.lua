local Previewing, xenonColour, VehicleNitrous, nosColour, DutyList = {}, {}, {}, {}, {}

---==[[ SLASH COMMANDS ]]==---
	QBCore.Commands.Add("preview", Loc[Config.Lan]["servfunction"].checkmods, {}, false, function(source) TriggerClientEvent("jim-mechanic:client:Preview:Menu", source) end)
	QBCore.Commands.Add("checkveh", "Check Performance", {}, false, function(source) TriggerClientEvent("jim-mechanic:client:Menu", source, false) end)
	QBCore.Commands.Add("showodo", "Odometer", {}, false, function(source) TriggerClientEvent("jim-mechanic:ShowOdo", source) end)
	QBCore.Commands.Add("checkdamage", Loc[Config.Lan]["servfunction"].checkdamage, {}, false, function(source) TriggerClientEvent("jim-mechanic:client:Repair:Check", source) end)
	QBCore.Commands.Add("checkmods", Loc[Config.Lan]["servfunction"].checkmods, {}, false, function(source) TriggerClientEvent("jim-mechanic:client:Menu:List", source) end)
	QBCore.Commands.Add("flipvehicle", Loc[Config.Lan]["servfunction"].flipvehicle, {}, false, function(source)	TriggerClientEvent("jim-mechanic:flipvehicle", source) end)
	QBCore.Commands.Add("togglesound", Loc[Config.Lan]["servfunction"].togglesound, {}, false, function(source)	TriggerClientEvent("jim-mechanic:togglesound", source) end)
	QBCore.Commands.Add("cleancar", Loc[Config.Lan]["servfunction"].cleancar, {}, false, function(source) TriggerClientEvent("jim-mechanic:client:cleanVehicle", source, true) end)
	QBCore.Commands.Add("hood", Loc[Config.Lan]["servfunction"].hood, {}, false, function(source) TriggerClientEvent("jim-mechanic:client:openDoor", source, 4) end)
	QBCore.Commands.Add("trunk", Loc[Config.Lan]["servfunction"].trunk, {}, false, function(source) TriggerClientEvent("jim-mechanic:client:openDoor", source, 5) end)
	QBCore.Commands.Add("door", Loc[Config.Lan]["servfunction"].door, {{name="0-3", help="Door ID"}}, false, function(source, args) TriggerClientEvent("jim-mechanic:client:openDoor", source, args[1]) end)
	QBCore.Commands.Add("seat", Loc[Config.Lan]["servfunction"].seat, {{name="id", help="Seat ID"}}, false, function(source, args) TriggerClientEvent("jim-mechanic:seat", source, args[1]) end)

---==[[ CALLBACKS ]]==---
	QBCore.Functions.CreateCallback("jim-mechanic:checkVehicleOwner", function(source, cb, plate)
		local result = IsVehicleOwned(plate)
		if result then cb(true) else cb(false) end
	end)

	QBCore.Functions.CreateCallback("jim-mechanic:distGrab", function(source, cb, plate)
		if IsVehicleOwned(plate) then
			local result = MySQL.scalar.await('SELECT traveldistance FROM player_vehicles WHERE plate = ?', {plate})
			if result then cb(result) else cb("") end
		else cb("") end
	end)

	QBCore.Functions.CreateCallback("jim-mechanic:checkWax", function(source, cb, plate)
		if VehicleStatus and plate then
			if VehicleStatus[plate] then
				VehicleStatus[plate]["carwax"] = VehicleStatus[plate]["carwax"] or 0
					if VehicleStatus[plate]["carwax"] < os.time() then VehicleStatus[plate]["carwax"] = 0 -- if the the has ran out, set to 0 (off)
						TriggerClientEvent("jim-mechanic:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
					end
				cb(VehicleStatus[plate]["carwax"])
			end
		else cb(0) end
	end)

	QBCore.Functions.CreateCallback("jim-mechanic:checkDefVehStats", function(source, cb, plate)
		if defVehStats and plate then
			if defVehStats[plate] then cb(defVehStats[plate]) else cb(0) end
		else cb(0) end
	end)

---==[[ UPDATE DATABASE MILAGE ]]==---
	RegisterNetEvent('jim-mechanic:server:UpdateDrivingDistance', function(plate, DistAdd)
		local result = MySQL.scalar.await('SELECT traveldistance FROM player_vehicles WHERE plate = ?', {plate})
		if result then
			if Config.System.Debug then print("^5Debug^7: ^3UpdateDrivingDistance^7: ^2Travel distance ^7- [^6"..plate.."^7]: ^6"..((result or 0) + DistAdd).."^7") end
			MySQL.Async.execute('UPDATE player_vehicles SET traveldistance = ? WHERE plate = ?', {((result or 0) + DistAdd), plate})
		end
	end)

---==[[ SAVE EXTRA DAMAGES ]]==---
	RegisterNetEvent("jim-mechanic:updateVehicle", function(props, plate)
		if IsVehicleOwned(plate) then
			if Config.System.Debug then print("^5Debug^7: ^3updateVehicle^7: ^2Vehicle Mods^7 - [^6"..plate.."^7]: ^4"..json.encode(props).."^7")
			else print("^5Debug^7: ^3updateVehicle^7: ^2Vehicle Mods^7 - [^6"..plate.."^7]") end
			MySQL.Async.execute('UPDATE player_vehicles SET mods = ? WHERE plate = ?', { json.encode(props), plate })
		end
	end)

	RegisterNetEvent('jim-mechanic:server:saveStatus', function(mechDamages, plate, engine, body)
		if IsVehicleOwned(plate) then
			if Config.System.Debug then print("^5Debug^7: ^3saveStatus^7: ^2Save Extra Damages^7 - [^6"..plate.."^7]: ^4"..json.encode(mechDamages).."^7") end
			MySQL.Async.execute('UPDATE player_vehicles SET status = ?, engine = ?, body = ? WHERE plate = ?', {json.encode(mechDamages), engine, body, plate})
		end
	end)

	-- For qb-garages
	RegisterNetEvent('qb-vehicletuning:server:SaveVehicleProps', function(vehicleProps)
		if IsVehicleOwned(vehicleProps.plate) then
			MySQL.update('UPDATE player_vehicles SET mods = ? WHERE plate = ?', {json.encode(vehicleProps), vehicleProps.plate})
		end
	end)


---==[[ LOAD VALUES WHEN CAR IS SPAWNED ]] ==---
	RegisterNetEvent('jim-mechanic:server:loadStatus', function(props, vehicle)
		if props and type(props.headlightColor) == "table" then TriggerEvent("jim-mechanic:server:ChangeXenonColour", vehicle, { props.headlightColor[1], props.headlightColor[2], props.headlightColor[3] }) end
		local result = MySQL.Sync.fetchAll('SELECT status FROM player_vehicles WHERE plate = ?', { props.plate })
		if result[1] and tostring(result[1].status) ~= "null" and tostring(result[1].status) ~= "0" and tostring(result[1].status) ~= "1" then
			local status = json.decode(result[1].status) or {}
			if Config.Repairs.ExtraDamages then
				for _, v in pairs({"oil", "axle", "spark", "battery", "fuel"}) do
					if Config.System.Debug then print("^5Debug^7: ^3loadStatus^7: [^6"..props.plate.."^7] ^2Setting damage of ^6"..v.."^2 to^7: ^4"..(status[v] or 100).."^7") end
					TriggerEvent("jim-mechanic:server:updatePart", props.plate, v, (status[v] or 100))
				end
			end
			for _, v in pairs({"harness", "antiLag", "carwax"}) do
				if Config.System.Debug then print("^5Debug^7: ^3loadStatus^7: [^6"..props.plate.."^7] ^2Setting ^6"..v.."^2 to^7: ^4"..(status[v] or 0).."^7") end
				TriggerEvent("jim-mechanic:server:updatePart", props.plate, v, (status[v] or 0))
			end
		end
	end)

---==[[ MANUALLY SAVE STASH STUFF ]]==---
	RegisterNetEvent('jim-mechanic:server:saveStash', function(stashId, items)
		if items then
			if Config.System.Debug then print("^5Debug^7: ^3saveStash^7: ^2Saving stash ^7'^6"..stashId.."^7'") end
			if Config.System.Inv == "qs" then
				TriggerEvent("qs-inventory:SetStashItems", stashId, items)
			else
				MySQL.Async.insert('INSERT INTO stashitems (stash, items) VALUES (:stash, :items) ON DUPLICATE KEY UPDATE items = :items', { ['stash'] = stashId, ['items'] = json.encode(items) })
			end
		end
	end)

---==[[ DUPE EXPLOIT KICK ]]==---
	RegisterNetEvent("jim-mechanic:server:DupeWarn", function(item, newsrc)
		local src = newsrc or source
		local P = QBCore.Functions.GetPlayer(src)
		print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Tried to remove ^7('^3"..item.."^7')^2 but it wasn't there^7")
		if not Config.System.Debug then DropPlayer(src, "Attempting to duplicate items") end
		print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Dropped from server for item duplicating^7")
	end)

---==[[ PREVIEW FUNCTIONS AND EXPLOIT FIX ]]==---
	RegisterNetEvent("jim-mechanic:server:preview", function(active, vehicle, plate)
		local src = source
		if active then
			if Config.System.Debug then print("^5Debug^7: ^3Preview: ^2Player^7(^4"..src.."^7)^2 Started previewing^7") end
			Previewing[src] = { active = active, vehicle = vehicle, plate = plate }
		else
			if Config.System.Debug then print("^5Debug^7: ^3Preview: ^2Player^7(^4"..src.."^7)^2 Stopped previewing^7") end
			Previewing[src] = nil
		end
	end)

	AddEventHandler('playerDropped', function()
		local src = source
		if Previewing[src] then
			if Config.System.Debug then print("^5Debug^7: ^3Preview: ^2Player dropped while previewing^7, ^2resetting vehicle properties^7") end
			local properties = {}
			local result = MySQL.query.await('SELECT mods FROM player_vehicles WHERE plate = ?', { Previewing[src].plate })
			if result[1] then TriggerClientEvent("jim-mechanic:preview:exploitfix", -1, Previewing[src].vehicle, json.decode(result[1].mods)) end
			print("Resetting Vehicles Properties")
		end
		Previewing[src] = nil
	end)

---==[[ PREVIEW BOARD ITEM ]]==---
	RegisterNetEvent("jim-mechanic:server:giveList", function(info, modlist)
		local src = source
		local Player = QBCore.Functions.GetPlayer(src)
		local metadata = { description = string.format('Model: %s\nPlate: %s\n\nChanges: %s', info.veh, info.vehplate, #info.vehlist), info = info }
		if Config.System.Inv == "ox" then
			exports.ox_inventory:AddItem(src, "mechboard", 1, metadata)
		else
			if modlist and modlist[1] then info.modlist = modlist end
			Player.Functions.AddItem("mechboard", 1, nil, info)
			if Config.Overrides.showItemBox then TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["mechboard"], "add", 1) end
		end
	end)

	QBCore.Functions.CreateUseableItem("mechboard", function(source, item)
		if Config.System.Inv == "ox" then item.info = item.metadata["info"]	end
		if item.info["vehlist"] == nil then
			triggerNotify("MechBoard", "The board is empty, don't spawn this item", "error", source)
		else
			TriggerClientEvent("jim-mechanic:client:giveList", source, item)
		end
	end)

---==[[ CHECK CASH FOR REPAIRS ]]==---
	QBCore.Functions.CreateCallback("jim-mechanic:checkCash", function(source, cb)
		local P = QBCore.Functions.GetPlayer(source)
		if Config.System.Debug then print("^5Debug^7: ^3checkCash^7: ^2Player^7(^6"..source.."^7) ^2cash ^7- $^6"..P.Functions.GetMoney("cash").."^7") end
		cb(P.Functions.GetMoney("cash"))
	end)

	RegisterNetEvent('jim-mechanic:chargeCash', function(cost, society)
		QBCore.Functions.GetPlayer(source).Functions.RemoveMoney("cash", cost)

		if Config.System.Debug then print("^5Debug^7: ^3chargeCash^7: ^2Adding ^7$^6"..(math.ceil(cost - (cost / 4))).." ^2to account ^7'^6"..society.."^7'") end

		if Config.System.RenewedBanking then
			exports['Renewed-Banking']:addAccountMoney(society, math.ceil(cost - (cost / 4)))
		else
			exports["qb-management"]:AddMoney(society, math.ceil(cost - (cost / 4)))
		end
	end)

---==[[ DUTY DETECTION FOR BENCHES ]]==---
	QBCore.Functions.CreateCallback('jim-mechanic:mechCheck', function(source, cb)
		local dutyList = {}
		--Make list and set them all to false
		for _, v in pairs(Config.Main.JobRoles) do dutyList[tostring(v)] = false end

		for _, v in pairs(QBCore.Functions.GetPlayers()) do
			local Player = QBCore.Functions.GetPlayer(v)
			for l, b in pairs(Config.Main.JobRoles) do
				if Player.PlayerData.job.name == b and Player.PlayerData.job.onduty then dutyList[tostring(b)] = true end
			end
		end
		local result = false
		for _, v in pairs(dutyList) do if v then result = true end end
		cb(result)
	end)

	RegisterServerEvent("jim-mechanic:mechCheck:updateList", function(job, duty)
		DutyList[tostring(job)] = duty
		for _, v in pairs(QBCore.Functions.GetPlayers()) do
			local Player = QBCore.Functions.GetPlayer(v)
			if Player then
				TriggerClientEvent("jim-mechanic:mechCheck:forceList", Player.PlayerData.source, DutyList)
			end
		end
	end)

---==[[ SEND TO DISCORD LOG STUFF ]]==---
	function sendToDiscord(color, name, message, footer, htmllist, info)
		local embed = { { ["color"] = color, ["thumbnail"] = { ["url"] = info.thumb }, ["title"] = "**".. name .."**", ["description"] = message, ["footer"] = { ["text"] = footer }, ["fields"] = htmllist, } }
		PerformHttpRequest(info.htmllink, function(err, text, headers) end, 'POST', json.encode({username = info.shopName:sub(4), embeds = embed}),	{ ['Content-Type'] = 'application/json' })
	end

	RegisterNetEvent("jim-mechanic:server:discordLog", function(info)
		local src = source
		local Player = QBCore.Functions.GetPlayer(src)
		local htmllist = {}
		local count = 0
		for i = 1, #info["modlist"] do
			htmllist[#htmllist+1] = {
				["name"] = info["modlist"][i]["item"],
				["value"]= info["modlist"][i]["type"],
				["inline"] = true
			}
			count = count +1
			if count == 25 then
				sendToDiscord(
					info.colour,
					"New Order".." - "..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname,
					info["veh"]:gsub('%<br>', '').." - "..info["vehplate"],
					"Preview Report"..info.shopName,
					htmllist,
					info
				)
				htmllist = {}
				count = 0
			elseif count == #info["modlist"] - 25 then
				sendToDiscord(
					info.colour,
					"Continued".." - "..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname,
					info["veh"]:gsub('%<br>', '').." - "..info["vehplate"],
					"Preview Report"..info.shopName,
					htmllist,
					info
				)
			end
		end
		if #info["modlist"] <= 25 then
			sendToDiscord(
				info.colour,
				"New Order".." - "..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname,
				info["veh"]:gsub('%<br>', '').." - "..info["vehplate"],
				"Preview Report"..info.shopName,
				htmllist,
				info
			)
		end
	end)

---==[[ XENON SERVER STUFF ]]==---
	QBCore.Functions.CreateCallback('jim-mechanic:GetXenonColour', function(source, cb) cb(xenonColour) end)

	RegisterNetEvent('jim-mechanic:server:ChangeXenonColour', function(vehicle, newColour) xenonColour[vehicle] = newColour
		TriggerClientEvent('jim-mechanic:client:ChangeXenonColour', -1, vehicle, newColour)
	end)

	RegisterNetEvent('jim-mechanic:server:ChangeXenonStock', function(vehicle) xenonColour[vehicle] = nil
		TriggerClientEvent('jim-mechanic:client:ChangeXenonStock', -1, vehicle)
	end)

---==[[ CRAFTING SERVER STUFF ]]==---
	if Config.System.Inv == "ox" then
		for k, v in pairs(Config.Main.JobRoles) do
			exports.ox_inventory:RegisterStash(v.."Safe", "Stash", 50, 4000000)
		end
		exports.ox_inventory:RegisterShop("nosShop", { name = Loc[Config.Lan]["stores"].nos, inventory = Stores.NosItems.items })
		exports.ox_inventory:RegisterShop("toolShop", { name = Loc[Config.Lan]["stores"].tools, inventory = Stores.ToolItems.items })
		exports.ox_inventory:RegisterShop("repairShop", { name = Loc[Config.Lan]["stores"].repairs, inventory = Stores.RepairItems.items })
		exports.ox_inventory:RegisterShop("performShop", { name = Loc[Config.Lan]["stores"].perform, inventory = Stores.PerformItems.items })
		exports.ox_inventory:RegisterShop("cosmeticShop", { name = Loc[Config.Lan]["stores"].cosmetic, inventory = Stores.CosmeticItems.items })
	end

	local function GetStashItems(stashId)
		local result, items = nil, {}
		if Config.System.Inv == "ox" then
			result = exports.ox_inventory:GetInventory(stashId)
		elseif Config.System.Inv == "qs" then
			result = MySQL.Sync.fetchScalar('SELECT items FROM inventory_stash WHERE stash = ?', { stashId })
		elseif Config.System.Inv == "qb" then
			result = MySQL.Sync.fetchScalar('SELECT items FROM stashitems WHERE stash = ?', { stashId })
		end
		if result then
			local stashItems = {}
			if Config.System.Inv == "ox" then stashItems = result.items else stashItems = json.decode(result) end
			if stashItems then
				for k, item in pairs(stashItems) do
					local itemInfo = QBCore.Shared.Items[item.name:lower()]
					if itemInfo then
						items[item.slot] = {
							name = itemInfo["name"],
							amount = tonumber(item.amount) or tonumber(item.count),
							info = item.info ~= nil and item.info or "",
							label = itemInfo["label"],
							description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
							weight = itemInfo["weight"],
							type = itemInfo["type"],
							unique = itemInfo["unique"],
							useable = itemInfo["useable"],
							image = itemInfo["image"],
							slot = item.slot,
						}
					end
				end
			end
		end
		if Config.System.Debug then print("^5Debug^7: ^3GetStashItems^7: ^2Stash information for ^7'^6"..stashId.."^7' ^2retrieved^7") end
		return items
	end

	QBCore.Functions.CreateCallback('jim-mechanic:server:GetStashItems', function(source, cb, stashName) local stash = GetStashItems(stashName) cb(stash) end)

	---Crafting
	RegisterServerEvent('jim-mechanic:Crafting:GetItem', function(ItemMake, craftable)
		local src = source
		local Player = QBCore.Functions.GetPlayer(src)
		if craftable["amount"] then amount = craftable["amount"] else amount = 1 end
		if Config.StoreCraft.StashCraft then
			local stashItems = GetStashItems(Player.PlayerData.job.name .. "Safe")
			for k, v in pairs(craftable[ItemMake]) do
				if Config.System.Inv == "ox" then TriggerEvent("jim-mechanic:server:OX:ChangeStash", Player.PlayerData.job.name.."Safe", k, v) else
					for l, b in pairs(stashItems) do
						if k == b.name then
							stashItems[l].amount = stashItems[l].amount - v
							if stashItems[l].amount <= 0 then stashItems[l] = nil end
							if Config.Overrides.showItemBox then TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[k], "use", v) end
							TriggerEvent('jim-mechanic:server:saveStash', Player.PlayerData.job.name .. "Safe", stashItems)
							if Config.System.Debug then print("^5Debug^7: ^3Crafting^7: ^2Removing ^6"..QBCore.Shared.Items[k].label.." ^2x^6"..v.." ^2from stash^7: '^6"..Player.PlayerData.job.name.."Safe^7'") end
						end
					end
				end
			end
		else
			for k, v in pairs(craftable[ItemMake]) do TriggerEvent("jim-mechanic:server:toggleItem", false, k, v, src) end
		end
		--This should give the item, while the rest removes the requirements
		TriggerEvent("jim-mechanic:server:toggleItem", true, ItemMake, amount, src)
	end)

	RegisterNetEvent("jim-mechanic:server:OX:CheckStash", function(stashName, item, amount) if (exports.ox_inventory:GetItem(stashName, item, amount).count >= amount) then return true else return false end end)

	RegisterNetEvent("jim-mechanic:server:OX:ChangeStash", function(stashName, item, amount) exports.ox_inventory:RemoveItem(stashName, item, amount) end)

---==[[ NOS SERVER STUFF ]]==---

if not Config.Overrides.disableNos then
	--These events sync the VehicleNitrous table with the server, making them able to be synced with the players
	RegisterNetEvent('jim-mechanic:server:LoadNitrous', function(Plate) VehicleNitrous[Plate] = { hasnitro = 1, level = 100 }
		TriggerClientEvent('jim-mechanic:client:LoadNitrous', -1, Plate)
		TriggerEvent("jim-mechanic:database:UpdateNitrous", Plate, VehicleNitrous[Plate].level, VehicleNitrous[Plate].hasnitro)
	end)

	RegisterNetEvent('jim-mechanic:server:UnloadNitrous', function(Plate)
		--VehicleNitrous[Plate] = nil
			--Xora Added
			VehicleNitrous[Plate].hasnitro = 0
			VehicleNitrous[Plate].level = 0
		TriggerClientEvent('jim-mechanic:client:UnloadNitrous', -1, Plate)
		TriggerEvent("jim-mechanic:database:UpdateNitrous", Plate, VehicleNitrous[Plate].level, VehicleNitrous[Plate].hasnitro)
	end)

	RegisterNetEvent('jim-mechanic:server:UpdateNitroLevel', function(Plate, level)
			--Xora Added
			VehicleNitrous[Plate].hasnitro = 0
		VehicleNitrous[Plate].level = level
		TriggerClientEvent('jim-mechanic:client:UpdateNitroLevel', -1, Plate, level)
		TriggerEvent("jim-mechanic:database:UpdateNitrous", Plate, VehicleNitrous[Plate].level, VehicleNitrous[Plate].hasnitro)
	end)

		-- Xora Added
		RegisterNetEvent('jim-mechanic:server:DamageModifiedTurbo', function(Plate)
			VehicleNitrous[Plate].turbo_uses = VehicleNitrous[Plate].turbo_uses - 1
			if VehicleNitrous[Plate].turbo_uses <= 0 then
				TriggerClientEvent('QBCore:Notify', source, "Your modified turbo broke after prolonged usage!", 'error')
			end
			TriggerClientEvent('jim-mechanic:client:DamageModifiedTurbo', -1, Plate, VehicleNitrous[Plate].turbo_uses)
			TriggerEvent('jim-mechanic:database:updateModifiedTurboUses', Plate, VehicleNitrous[Plate].turbo_uses)
		end)

	--Event called on script start to grab Database info about nos
	function getNosUpdate()
		local result = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE nosengine = ?', {1})
		if result and result[1] then
			for _, v in pairs(result) do
				if Config.System.Debug then print("^5Debug^7: ^3GetNosUpdate^7: ^2VehicleNitrous^7[^6"..tostring(v["plate"]).."^7] = { ^2nosengine ^7= ^6"..tostring(v["nosengine"]).."^7, ^2level ^7= ^6"..tonumber(v["noslevel"]).."^7, ^2hasnitro ^7= ^6"..tostring(v["hasnitro"]).."^7, ^2turbo_uses ^7= ^6"..tonumber(v["turbo_uses"]).."^7 }") end
				VehicleNitrous[v["plate"]] = { hasnitro = v["hasnitro"], level = tonumber(v["noslevel"]), turbo_uses = tonumber(v['turbo_uses']) }
			end
			if Config.System.Debug then print("^5Debug^7: ^3GetNosUpdate^7: ^2VehicleNitrous Results Found^7: ^6"..#result.."^7") end
		else if Config.System.Debug then print("^5Debug^7: ^3GetNosUpdate^7: ^2Checked Database and found no vehicles with NOS^7") end end
	end

	RegisterNetEvent('jim-mechanic:database:installModifiedNOSEngine', function(plate, turbo_uses) VehicleNitrous[plate] = {turbo_uses = turbo_uses, hasnitro = false, level = 0}
		MySQL.Async.execute('UPDATE player_vehicles SET nosengine = ?, turbo_uses = ? WHERE plate = ?', {true, turbo_uses, plate})
		TriggerClientEvent('jim-mechanic:client:DamageModifiedTurbo', -1, plate, turbo_uses) end)
	RegisterNetEvent('jim-mechanic:database:updateModifiedTurboUses', function(plate, turbo_uses) MySQL.Async.execute('UPDATE player_vehicles SET turbo_uses = ? WHERE plate = ?', {turbo_uses, plate}) end)

	--Callback to send Database info to Client
	QBCore.Functions.CreateCallback('jim-mechanic:GetNosLoaded', function(source, cb) cb(VehicleNitrous) end)

		-- Xora Stuff
		QBCore.Functions.CreateCallback('jim-mechanic:checkNOSEngine', function(source, cb, plate)
			local result = MySQL.query.await('SELECT * FROM player_vehicles WHERE plate = ?', {plate})
			if result and result[1] then
				local hasEngine = json.decode(result[1].nosengine)
				cb(hasEngine)
			else
				cb(false)
			end
		end)

	--[[function GetNearbyPeds(netId, distance) local nearbyList = {}
		local carCoords = GetEntityCoords(netId)
		local Players = QBCore.Functions.GetQBPlayers()
		for _, v in pairs(Players) do
			local ped = GetPlayerPed(v.PlayerData.source)
			if #(carCoords - GetEntityCoords(ped)) <= distance then	nearbyList[#nearbyList+1] = v.PlayerData.source	end
		end
		return nearbyList
	end]]

	--Syncing stuff
	RegisterNetEvent('jim-mechanic:server:SyncPurge', function(netId, enabled, size, coords)
		if not enabled then
			TriggerClientEvent('jim-mechanic:client:SyncPurge', -1, netId, false, size, coords)
		else
			local nearbyList = {}
			local Players = QBCore.Functions.GetQBPlayers()
			for _, v in pairs(Players) do
				if #(coords - GetEntityCoords(GetPlayerPed(v.PlayerData.source))) <= (Config.NOS.PurgeDis or 30.0) then
					nearbyList[#nearbyList+1] = v.PlayerData.source
				end
			end
			for i = 1, #nearbyList do
				TriggerClientEvent('jim-mechanic:client:SyncPurge', nearbyList[i], netId, enabled, size, coords)
			end
		end
	end)
	RegisterNetEvent('jim-mechanic:server:SyncTrail', function(netId, enabled, coords)
		if not enabled then
			TriggerClientEvent('jim-mechanic:client:SyncTrail', -1, netId, false, coords)
		else
			local nearbyList = {}
			local Players = QBCore.Functions.GetQBPlayers()
			for _, v in pairs(Players) do
				if #(coords - GetEntityCoords(GetPlayerPed(v.PlayerData.source))) <= (Config.NOS.TrailsDis or 30.0) then
					nearbyList[#nearbyList+1] = v.PlayerData.source
				end
			end
			for i = 1, #nearbyList do
				TriggerClientEvent('jim-mechanic:client:SyncTrail', nearbyList[i], netId, enabled, coords)
			end
		end
	end)
	RegisterNetEvent('jim-mechanic:server:SyncFlame', function(netId, enabled, antilag, level, coords)
		if not enabled then
			local nearbyList = {}
			local Players = QBCore.Functions.GetQBPlayers()
			for _, v in pairs(Players) do
				if #(coords - GetEntityCoords(GetPlayerPed(v.PlayerData.source))) <= (Config.NOS.FlameDis or 30.0) then
					nearbyList[#nearbyList+1] = v.PlayerData.source
				end
			end
			TriggerClientEvent('jim-mechanic:client:SyncFlame', -1, netId, false, antilag, level, coords)
		else
			local nearbyList = {}
			local Players = QBCore.Functions.GetQBPlayers()
			for _, v in pairs(Players) do
				if #(coords - GetEntityCoords(GetPlayerPed(v.PlayerData.source))) <= (Config.NOS.FlameDis or 30.0) then
					nearbyList[#nearbyList+1] = v.PlayerData.source
				end
			end
			for i = 1, #nearbyList do
				TriggerClientEvent('jim-mechanic:client:SyncFlame', nearbyList[i], netId, enabled, antilag, level, coords)
			end
		end
	end)

---==[[ PURGE COLOUR SERVER STUFF ]]==---

	QBCore.Functions.CreateUseableItem("noscolour", function(source, item) TriggerClientEvent("jim-mechanic:client:NOS:rgbORhex", source) end)

	--Event called on script start to grab Database info about nos
	function getNosColourUpdate()
		local result = MySQL.Sync.fetchAll("SELECT `nosColour`, `plate` FROM `player_vehicles` WHERE 1")
		if result and result[1] then
			for _, v in pairs(result) do
				if v["nosColour"] then
					local newColour = json.decode(v["nosColour"])
					if Config.System.Debug then print("^5Debug^7: ^3nosColour^7[^6"..tostring(v["plate"]).."^7] = { ^2RBG^7: ^6"..newColour[1].."^7, ^6"..newColour[2].."^7, ^6"..newColour[3].." ^7}") end
					nosColour[v["plate"]] = newColour
				end
			end
		end
	end

	--Callback to send Database info to Client
	QBCore.Functions.CreateCallback('jim-mechanic:GetNosColour', function(source, cb) cb(nosColour) end)

	-- This event is to make it so every car's purge colour is synced
	-- If you change the colour of the purge on a car, everyone who gets in THAT car will spray this colour
	RegisterNetEvent('jim-mechanic:server:ChangeColour', function(Plate, newColour)
		nosColour[Plate] = newColour -- Update server side
		TriggerClientEvent('jim-mechanic:client:ChangeColour', -1, Plate, newColour) -- Sync the colour per car between players
		TriggerEvent('jim-mechanic:database:ChangeColour', Plate, newColour) -- Update Database with new colour
	end)

	RegisterNetEvent('jim-mechanic:database:ChangeColour', function(plate, newColour)
		--if Config.System.Debug then print("Update Purge Colour: "..plate) end
		MySQL.Async.execute('UPDATE player_vehicles SET nosColour = ? WHERE plate = ?', { json.encode(newColour), plate })
	end)

		-- Xora Stuff
		QBCore.Functions.CreateUseableItem("modified_turbo", function(source, item) TriggerClientEvent('jim-mechanic:client:applyNOSEngine', source) end)
end
---==[[ VEHICLE DAMAGES SERVER STUFF ]]==---
	VehicleStatus = VehicleStatus or {}

	AddEventHandler('onResourceStart', function(r) if GetCurrentResourceName() ~= r then return end
		local result = MySQL.Sync.fetchAll("SELECT `status`, `plate` FROM `player_vehicles` WHERE 1")
		for _, v in pairs(result) do
			if type(json.decode(v.status)) == "table" then
				if Config.System.Debug then print("^5Debug^7: ^2Found vehicleStatus ^7- '^6"..v.plate.."^7'", "'^3"..type(json.decode(v.status)).."^7'")
					print("^1"..v.status.."^7")
				end
				VehicleStatus[v.plate] = json.decode(v.status)
				--Create a table and apply values at the same time, this will help if its retreived errornous info from database
				for _, name in pairs({"oillevel", "shaftlevel", "cylinderlevel", "cablelevel", "fuellevel", "harness", "antiLag", "carwax"}) do
					VehicleStatus[v.plate][name] = VehicleStatus[v.plate][name] or 0
				end
				for _, name in pairs({"oil", "axle", "spark", "battery", "fuel"}) do
					VehicleStatus[v.plate][name] = VehicleStatus[v.plate][name] or 100
				end
				-- Convert old status to new status
				for _, name in pairs(VehicleStatus[v.plate]) do
					if name == "radiator" then VehicleStatus[v.plate]["oil"] = VehicleStatus[v.plate]["radiator"] VehicleStatus[v.plate]["radiator"] = nil end
					if name == "brakes" then VehicleStatus[v.plate]["spark"] = VehicleStatus[v.plate]["brakes"] VehicleStatus[v.plate]["brakes"] = nil end
					if name == "clutch" then VehicleStatus[v.plate]["battery"] = VehicleStatus[v.plate]["clutch"] VehicleStatus[v.plate]["clutch"] = nil end
				end
			end
		end
	end)

	QBCore.Functions.CreateCallback('jim-mechanic:server:GetStatus', function(_, cb, plate)
		if VehicleStatus[plate] and next(VehicleStatus[plate]) then cb(VehicleStatus[plate]) else cb(nil) end
	end)

	RegisterNetEvent('jim-mechanic:server:setupVehicleStatus', function(plate, engineHealth, bodyHealth) local defaultStatus = {}
		if plate == nil or plate == 0 then return end
		defaultStatus["engine"] = (engineHealth or 1000.0) defaultStatus["body"] = (bodyHealth or 1000.0)
		for _, name in pairs({"oil", "axle", "spark", "battery", "fuel"}) do defaultStatus[name] = 100.0 end
		for _, name in pairs({"oillevel", "shaftlevel", "cylinderlevel", "cablelevel", "fuellevel"}) do defaultStatus[name] = 0 end
		defaultStatus["harness"] = 0 defaultStatus["antiLag"] = 0 defaultStatus["carwax"] = 0
		if IsVehicleOwned(plate) then
			VehicleStatus[plate] = GetVehicleStatus(plate) or defaultStatus
			for k in pairs(defaultStatus) do
				VehicleStatus[plate][k] = VehicleStatus[plate][k] or defaultStatus[k]
			end
		else
			VehicleStatus[plate] = defaultStatus
		end
		TriggerClientEvent("jim-mechanic:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
	end)

	RegisterNetEvent('jim-mechanic:server:updatePart', function(plate, part, level, all) local src = source
		if VehicleStatus[plate] then
			local partValue = level
			if partValue < 0 then partValue = 0
			elseif partValue > ((part == "engine" or part == "body") and 1000.0 or 100) then
				partValue = ((part == "engine" or part == "body") and 1000.0 or 100)
			end
			if part == "carwax" then if level ~= 0 then partValue = os.time() + level end end
			VehicleStatus[plate][part] = partValue
			if all then
				TriggerClientEvent("jim-mechanic:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
			end
		end
	end)

	RegisterNetEvent('jim-mechanic:server:fixAllPart', function(plate) local src = source
		if VehicleStatus[plate] then
			VehicleStatus[plate]["oil"] = 100
			VehicleStatus[plate]["axle"] = 100
			VehicleStatus[plate]["battery"] = 100
			VehicleStatus[plate]["fuel"] = 100
			VehicleStatus[plate]["spark"] = 100
		end
		TriggerClientEvent("jim-mechanic:client:setVehicleStatus", src, plate, VehicleStatus[plate])
	end)


	RegisterNetEvent("jim-mechanic:server:getStatusList", function(player, plate) local src = source
		if plate then -- if receive a plate, only send this to the player
			TriggerClientEvent("jim-mechanic:client:setVehicleStatus", src, plate, VehicleStatus[plate])
		else
			TriggerClientEvent("jim-mechanic:client:getStatusList", player and src or -1, VehicleStatus)
		end
	end)

	--- HARNESS Stuff --
	if Config.Harness.HarnessControl == true then
		QBCore.Functions.CreateUseableItem("harness", function(source, item) TriggerClientEvent('jim-mechanic:client:applyHarness', source) end)
	end

---==[[ ON RESOURCE START ]]==---
	AddEventHandler('onResourceStart', function(r) if GetCurrentResourceName() ~= r then return end
		if not Config.Overrides.disableNos then
			getNosUpdate()
			getNosColourUpdate()
		end
		for _, v in pairs(Config.Main.JobRoles) do DutyList[tostring(v)] = false end
		for _, v in pairs(QBCore.Functions.GetPlayers()) do
			local Player = QBCore.Functions.GetPlayer(v)
			if Player then
				for _, b in pairs(Config.Main.JobRoles) do
					if Player.PlayerData.job.name == b and Player.PlayerData.job.onduty then DutyList[tostring(b)] = true end end end end
	end)

RegisterNetEvent('jim-mechanic:server:updateDefVehStats', function(plate, props)
	if not defVehStats[plate] then
		defVehStats[plate] = props
	else
		for k, v in pairs(props) do
			if defVehStats[plate][k] ~= v then defVehStats[plate][k] = v end
		end
	end
end)

RegisterNetEvent('jim-mechanic:server:updateCar', function(netId, props)
	TriggerClientEvent("jim-mechanic:forceProperties", -1, netId, props)
end)

RegisterNetEvent("jim-mechanic:server:changePlate", function(vehicle, plate) SetVehicleNumberPlateText(NetworkGetEntityFromNetworkId(vehicle), plate) end)
