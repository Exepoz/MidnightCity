local Targets, Props, Blips, PlayerJob, alcoholCount, CraftLock = {}, {}, {}, {}, 0, false

local function jobCheck()
	canDo = true
	if not onDuty then triggerNotify(nil, "triangle-exclamation",  Loc[Config.Lan].error["not_clocked_in"], 'error') canDo = false end
	return canDo
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData) PlayerJob = PlayerData.job
		if PlayerJob.onduty then for k, v in pairs(Config.Locations) do
			if PlayerData.job.name == v.job then TriggerServerEvent("QBCore:ToggleDuty") end end end end)
end)
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo) PlayerJob = JobInfo onDuty = PlayerJob.onduty end)
RegisterNetEvent('QBCore:Client:SetDuty', function(duty) onDuty = duty end)
AddEventHandler('onResourceStart', function(r) if GetCurrentResourceName() ~= r then return end
	QBCore.Functions.GetPlayerData(function(PlayerData)	PlayerJob = PlayerData.job for
		k, v in pairs(Config.Locations) do if PlayerData.job.name == v.job then
			onDuty = PlayerJob.onduty end end end)
end)

CreateThread(function()
	for locationName, Location in pairs(Config.Locations) do
		if Location.zoneEnabled then
			local bossroles = {}
			for grade in pairs(QBCore.Shared.Jobs[Location.job].grades) do
				if QBCore.Shared.Jobs[Location.job].grades[grade].isboss == true then
					if bossroles[Location.job] then
						if bossroles[Location.job] > tonumber(grade) then bossroles[Location.job] = tonumber(grade) end
					else bossroles[Location.job] = tonumber(grade)	end
				end
			end
			if Location.zones then
				JobLocation = PolyZone:Create(Location.zones,
				{ name = Location.Blip.label, debugPoly = Config.Debug })
				if Config.Debug then print("^7 Registering Zone:^3 "..Location.Blip.label) end
				JobLocation:onPlayerInOut(function(isPointInside)
					if PlayerJob.name == Location.job then
						if Location.autoClock and Location.autoClock.enter then if isPointInside and not onDuty then TriggerServerEvent("QBCore:ToggleDuty") end end
						if Location.autoClock and Location.autoClock.exit then if not isPointInside and onDuty then TriggerServerEvent("QBCore:ToggleDuty") end end
				end
			end)
			end
			if Location.Blip then
				Blips[#Blips+1] = makeBlip({coords = Location.Blip.coords, sprite = Location.Blip.sprite or 106, col = Location.Blip.color, scale = Location.Blip.scale, disp = nil, category = nil, name = Location.Blip.label})
			end
						local LocName = Location.Blip.label
						local Target = Location.Targets
						if Target.ChoppingBoard then
							for i, chop in ipairs(Target.ChoppingBoard) do
								if Config.Debug then
									print("^4"..locationName.."^7 Registering ChoppingBoard at: ^3"..chop.coords)
								end
								local targetName = LocName.."CluckinbellChopboard"..i

								local options = {
									{
										event = "jixel-cluckinbell:Crafting",
										icon = "fas fa-hamburger",
										label = Loc[Config.Lan].target["chopping_board"],
										header = Loc[Config.Lan].menu["header_choppingboard"],
										craftable = chop.craftable,
										job = Location.job,
										coords = chop.coords,
									}
								}

								if chop.craftable2 then
									table.insert(options, {
										event = "jixel-cluckinbell:Crafting",
										icon = "fas fa-hamburger",
										label = Loc[Config.Lan].target["prepare_food"],
										header = Loc[Config.Lan].menu["header_prepfood"],
										craftable = chop.craftable2,
									})
								end

								Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, chop.coords, chop.l, chop.w,
								{ name = targetName, heading = chop.heading, debugPoly = Config.Debug, minZ = chop.coords.z - 0.5, maxZ = chop.coords.z + 1, },
								{ options = options, distance = 2.0 })

								if chop.prop then
									Props[locationName.."CBChoppingboard"..i] = makeProp({ prop = "v_res_mchopboard", coords = vec4(chop.coords.xyz, chop.heading) }, 1, 0 )
								end
							end
						end
					if Target.Storage then
						for i, Stash in ipairs(Target.Storage) do
							local options = {}
							local targetName = "Stash"..i..locationName
							local type = Stash.type
							if Config.Debug then print("^4"..locationName.."^7 Registering Stash at: ^3"..Stash.coords.." type: ^4 "..type.."") end
							if type == "tray" then
								id = Location.job..type.." Tray"..i..locationName
								options[#options+1] = {
									event = "jixel-cluckinbell:Stash",
									icon = "fas fa-box-open",
									label = Loc[Config.Lan].target["open_tray"],
									id = id,
									coords = Stash.coords
								}
								if Config.Inv == "ox" then
									TriggerServerEvent("jixel-cluckinbell:makeOXStash", id, Location.Items.label.."Tray"..i )
								end
								if Stash.prop then
									Props[locationName.."Stash"..i] = makeProp({prop = Stash.prop, coords = vec4(Stash.propcoords.xyz, Stash.heading)}, 1, 0 )
								end
							elseif type == "personal" then
								job = nil
								id = Location.job..type.." Stash"..i..locationName
								options[#options+1] = {
									event = "jixel-cluckinbell:client:pstash",
									icon = "fas fa-box-open", label = Loc[Config.Lan].target["open_personal"],
									job = Location.job,
									id = id,
									coords = Stash.coords
								}
								if Config.Inv == "ox" then
									TriggerServerEvent("jixel-cluckinbell:makeOXStash", id, Location.Items.label.."Locker"..i )
								end
							else
								id = Location.job.." Stash"..i..locationName
								options[#options+1] = {
									event = "jixel-cluckinbell:Stash",
									icon = "fas fa-box-open",
									label = Loc[Config.Lan].target["open_shelves"],
									job = Location.job, id = id,
									coords = Stash.coords
								}
								if Config.Inv == "ox" then
									TriggerServerEvent("jixel-cluckinbell:makeOXStash", id, Location.Items.label.."Shelves"..i )
								end
							end
							if Stash.perlocker then
								type = "personal"
								job = nil
								id = Location.job..type.." Stash"..i..locationName
								options[#options+1] = {
									event = "jixel-cluckinbell:client:pstash",
									icon = "fas fa-box-open",
									label = Loc[Config.Lan].target["open_personal"],
									job = Location.job,
									id = id,
									coords = Stash.coords
								}
								if Config.Inv == "ox" then
									TriggerServerEvent("jixel-cluckinbell:makeOXStash", id, Location.Items.label.."Locker"..i )
								end
							end
							if Stash.boxgrab == true then
								options[#options+1] = {
									event = "jixel-cluckinbell:client:GrabBag",
									icon = "fas fa-bag-shopping",
									label = Loc[Config.Lan].target["grab_box"],
									job = Location.job,
									}
								options[#options+1] = {
									event = "jixel-cluckinbell:client:shop2",
									icon = "fas fa-bag-shopping",
									label = Loc[Config.Lan].target["grab_toy"],
									job = Location.job,
									items = Location.Toy,
									id = targetName
								}
								if Config.Inv == "ox" then
									TriggerServerEvent("jixel-cluckinbell:makeOXShop", targetName, "Toy Shelf", Location.Toy.items)
								end
							end
							Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, Stash.coords, Stash.l, Stash.w,
							{ name = targetName, heading = Stash.heading, debugPoly = Config.Debug, minZ = Stash.coords.z-0.5, maxZ = Stash.coords.z+0.8, },
							{ options = options, distance = 2.0 })
						end
					end
					if Target.Fridge then
						for i, fridge in ipairs(Target.Fridge) do
							id = Location.job.." Fridge "..i..locationName
							local options = {
								{
									event = "jixel-cluckinbell:Stash",
									icon = "fas fa-archive",
									label = Loc[Config.Lan].target["open_fridge"],
									shop = Location.Items,
									job = Location.job, id = id,
									coords = fridge.coords,
								}
							}

							if Config.Debug then print("^4"..locationName.."^7 Registering Fridge at: ^3"..fridge.coords.."") end

							if Config.Inv == "ox" then
								TriggerServerEvent("jixel-cluckinbell:makeOXShop", locationName.."CBFridge" .. i, Location.Items.label, Location.Items.items)
							end

							if fridge.prop then
								Props[locationName.."CBFridge"..i] = makeProp({prop = `prop_fridge_01`, coords = vec4(fridge.coords.xyz, fridge.heading)}, 1, 0 )
							end

							if fridge.IceCream then
								table.insert(options, {
									event = "jixel-cluckinbell:Crafting",
									icon = "fas fa-hamburger",
									label = Loc[Config.Lan].target["prepare_icecream"],
									header = Loc[Config.Lan].menu["header_icecream"],
									craftable = fridge.craftable,
								})
							end

							if fridge.Drink then
								table.insert(options, {
									event = "jixel-cluckinbell:Crafting",
									icon = "fas fa-hamburger",
									label = Loc[Config.Lan].target["prepare_drinks"],
									header = Loc[Config.Lan].menu["header_drink"],
									craftable = fridge.craftable2,
								})
							end
							local targetName = locationName.."CBFridge" .. i
							Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, fridge.coords, fridge.l, fridge.w,
								{
									name = targetName,
									heading = fridge.heading,
									debugPoly = Config.Debug,
									minZ = fridge.coords.z-0.5,
									maxZ = fridge.coords.z+1,
								},
								{ options = options, distance = 2.0 }
							)
						end
					end
					if Target.Sink then
						for i, sink in ipairs(Target.Sink) do
							if Config.Debug then print("^4"..locationName.."^7 Registering Sink at ^4"..sink.coords.."") end
							local targetName = locationName.."CBSink"..i
							Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, sink.coords, sink.l, sink.w,
							{ name = targetName, heading = sink.heading, debugPoly = Config.Debug, minZ = sink.coords.z-0.5, maxZ = sink.coords.z+1 },
							{ options = {
								{
									event = "jixel-cluckinbell:washHands", icon = "fas fa-hand-holding-water",
									label = Loc[Config.Lan].target["wash_hands"],
									coords = sink.coords,
								}
							}, distance = 2.0 })
						end
					end
					if Target.POS then
						for i, pos in ipairs(Target.POS) do
								local image = Location.POS.img
								local options = {
									{ type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = Loc[Config.Lan].target["clockin"], job = Location.job },
									{ event = "qb-bossmenu:client:OpenMenu", icon = "fas fa-list", label = Loc[Config.Lan].target["open_bossmenu"], job = bossroles },
									{ event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = Loc[Config.Lan].target["charge_customer"], job = Location.job,
										coords = pos.coords, img = "<center><p><img src="..image.." width=150px></p>" },
								}
								if Config.Debug then
									print("^4"..locationName.."^7 Registering POS at ^4"..pos.coords.."")
								end
								local targetName = locationName.."CBPOS"..i

								if pos.menu then
									print("^4"..locationName.."^7 Registering POS Menu at ^4"..pos.coords.." "..json.encode(pos.menu).." ")
									table.insert(options, {
										event = "jixel-cluckinbell:showMenu",
										type = "client",
										icon = "fas fa-hamburger",
										label = Loc[Config.Lan].target["open_menu"],
										img = Config.MenuImg,
									})
								end
								Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, pos.coords, pos.l, pos.w,
								{
									name = targetName,
									heading = pos.heading,
									debugPoly = Config.Debug,
									minZ = pos.coords.z - 0.5,
									maxZ = pos.coords.z + 1,
								},
								{ options = options, distance = 2.0 })

								if pos.prop then
									Props[locationName.."CBPOS"..i] = makeProp({ prop = pos.prop, coords = vec4(pos.propcoords.x, pos.propcoords.y, pos.propcoords.z, pos.propcoords.w) }, 1, 0 )
								end
							end
						end
					if Target.IceCream then
						for i, icecream in ipairs(Target.IceCream) do
							if Config.Debug then print("^4"..locationName.."^7 Registering IceCream at ^4"..icecream.coords.."") end
							local targetName = locationName.."CBIceCream"..i
							Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, icecream.coords, icecream.l, icecream.w,
							{ name = targetName, heading = icecream.heading, debugPoly = Config.Debug, minZ = icecream.coords.z-0.5, maxZ = icecream.coords.z+1 },
							{ options = {
								{
									event = "jixel-cluckinbell:Crafting",
									icon = "fas fa-hamburger",
									label = Loc[Config.Lan].target["prepare_icecream"],
									header = Loc[Config.Lan].menu["header_icecream"],
									job = Location.job,
									craftable = icecream.craftable,
									coords = icecream.coords
								},
							}, distance = 2.0 })
						end
					end
					if Target.Coffee then
						for i, coffee in ipairs(Target.Coffee) do
							if Config.Debug then print("^4"..locationName.."^7 Registering Coffee at ^4"..coffee.coords.."") end
							local targetName = locationName.."CBCoffee"..i
							Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, coffee.coords, coffee.l, coffee.w,
								{ name = targetName, heading = coffee.heading, debugPoly = Config.Debug, minZ = coffee.coords.z-0.5, maxZ = coffee.coords.z+1, },
								{ options = {
									{
										event = "jixel-cluckinbell:Crafting",
										icon = "fas fa-coffee", label = Loc[Config.Lan].target["prepare_coffee"],
										header = Loc[Config.Lan].menu["header_coffee"],
										job = Location.job,
										craftable = coffee.craftable,
										coords = coffee.coords
									}
								}, distance = 2.0, })
						end
					end
					if Target.Grill then
						for i, grill in ipairs(Target.Grill) do
							local options = {
								{
									event = "jixel-cluckinbell:Crafting",
									icon = "fas fa-utensils",
									label = Loc[Config.Lan].target["grill"],
									header = Loc[Config.Lan].menu["header_grill"],
									job = Location.job,
									craftable = grill.craftable,
									coords = grill.coords
								}
							}
							if Config.Debug then
								print("^4"..locationName.."^7 Registering Grill at ^4"..grill.coords.."")
							end
							local targetName = locationName.."CBGrill"..i
							if grill.fryer then
								table.insert(options, {
									event = "jixel-cluckinbell:Crafting",
									icon = "fas fa-utensils",
									label = Loc[Config.Lan].target["use_fryer"],
									header = Loc[Config.Lan].menu["header_fryer"],
									job = Location.job,
									craftable = grill.craftable2,
									coords = grill.coords,
								})
							end
							Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, grill.coords, grill.w, grill.l,
								{
									name = targetName,
									heading = grill.heading,
									debugPoly = Config.Debug,
									minZ = grill.coords.z-0.5,
									maxZ = grill.coords.z+1,
								},
								{ options = options, distance = 2.0 }
							)
						end
					end
					if Target.Fryer then
						for i, fryer in ipairs(Target.Fryer) do
							local options = {
								{
									event = "jixel-cluckinbell:Crafting",
									icon = "fas fa-utensils",
									label = Loc[Config.Lan].target["use_fryer"],
									header = Loc[Config.Lan].menu["header_fryer"],
									job = Location.job,
									craftable = fryer.craftable,
									coords = fryer.coords,
								}
							}
							if Config.Debug then
								print("^4"..locationName.."^7 Registering Fryer at ^4"..fryer.coords.."")
							end
							local targetName = locationName.."CBFryer"..i
							if fryer.grill then
								table.insert(options, {
									event = "jixel-cluckinbell:Crafting",
									icon = "fas fa-utensils",
									label = Loc[Config.Lan].target["grill"],
									header = Loc[Config.Lan].menu["header_grill"],
									job = Location.job,
									craftable = fryer.craftable2,
									coords = fryer.coords,
								})
							end
							Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, fryer.coords, fryer.w, fryer.l,
								{
									name = targetName,
									heading = fryer.heading,
									debugPoly = Config.Debug,
									minZ = fryer.coords.z-0.5,
									maxZ = fryer.coords.z+1,
								},
								{ options = options, distance = 2.0 }
							)
						end
					end
					if Target.Drink then
						for i, drink in ipairs(Target.Drink) do
							if Config.Debug then print("^4"..locationName.."^7 Registering Drink at ^4"..drink.coords.."") end
							local targetName = locationName.."CBDrink"..i
							Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, drink.coords, drink.l, drink.w,
								{ name = targetName, heading = drink.heading, debugPoly = Config.Debug, minZ = drink.coords.z-0.5, maxZ = drink.coords.z+1, },
								{ options = {
									{
										event = "jixel-cluckinbell:Crafting",
										icon = "fas fa-coffee",
										label = Loc[Config.Lan].target["prepare_drinks"],
										header = Loc[Config.Lan].menu["header_drinks"],
										job = Location.job, craftable = drink.craftable,
										coords = drink.coords
									}
								}, distance = 2.0, })
						end
					end
					if Target.Prepare then
						for i, prepare in ipairs(Target.Prepare) do
							local options = {
								{
									event = "jixel-cluckinbell:Crafting",
									icon = "fas fa-coffee",
									label = Loc[Config.Lan].target["prepare_food"],
									header = Loc[Config.Lan].menu["header_prepfood"],
									job = Location.job,
									craftable = prepare.craftable,
									coords = prepare.coords
								},
							}
							if Config.Debug then
								print("^4"..locationName.."^7 Registering Prepare at ^4"..prepare.coords.."")
							end
							local targetName = locationName.."CBPrepare"..i
							if prepare.chop then
								local chopOption = {
									event = "jixel-cluckinbell:Crafting",
									type = "client",
									icon = "fas fa-hamburger",
									label = Loc[Config.Lan].target["chopping_board"],
									header = Loc[Config.Lan].menu["header_choppingboard"],
									craftable = prepare.craftable2,
									job = Location.job,
									coords = prepare.coords,
								}
								table.insert(options, chopOption)
								print("[^5 Debug ^7] Registering and inserting Chop options at ^4"..prepare.coords.."")
							end
							Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, prepare.coords, prepare.l, prepare.w,
								{
									name = targetName,
									heading = prepare.heading,
									debugPoly = Config.Debug,
									minZ = prepare.coords.z-0.5,
									maxZ = prepare.coords.z+1,
								},
								{ options = options, distance = 2.0 }
							)
						end
					end
					if Target.Menu then
						for i, desk in ipairs(Target.Menu) do
							if Config.Debug then print("^4"..locationName.."^7 Registering Menu at ^4"..desk.coords.."") end
							if desk then
							local targetName = locationName.."CBMenu"..i
							Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, desk.coords, 0.6, 0.6,
								{ name = targetName, heading = desk.heading, debugPoly = Config.Debug, minZ = desk.coords.z-0.5, maxZ = desk.coords.z+1, },
								{ options = {
									{ event = "jixel-cluckinbell:showMenu", img = Config.MenuImg}
								}, distance = 2.0, })
							end
						end
					end
					--[[ 				for i, boss in ipairs(Location.BossTargets) do
						local targetName = LocName.."PKBoss"..i
						Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, boss.coords, boss.l, boss.w,
							{ name = targetName, heading = boss.heading, debugPoly = Config.Debug, minZ = boss.coords.z-0.5, maxZ = boss.coords.z+1, },
							{ options = {
								{ event = "qb-bossmenu:client:OpenMenu",
									icon = "fas fa-list", label = Loc[Config.Lan].target["boss"],
									job = bossroles,
									coords = boss.coords,
								}
							}, distance = 2.5, })
					end
	]]
			end
	end
end)

RegisterNetEvent('jixel-cluckinbell:washHands', function(data)
    lookEnt(data.coords)
	QBCore.Functions.Progressbar('washing_hands', Loc[Config.Lan].progressbar["progress_washing"], 5000, false, false, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, },
		{ animDict = "mp_arresting", anim = "a_uncuff", flags = 8, }, {}, {}, function()
		triggerNotify(nil, Loc[Config.Lan].success["washed_hands"], 'success')
    end, function() -- Cancel
        TriggerEvent('inventory:client:busy:status', false)
		triggerNotify(nil, Loc[Config.Lan].error["cancel"], 'error')
    end, data.icon)
end)

--[[ RegisterNetEvent('jixel-cluckinbell:Stash', function(data)
	lookEnt(data.coords)
	if Config.Inv == "ox" then exports.ox_inventory:openInventory('stash', data.stashName)
	else
		TriggerEvent("inventory:client:SetCurrentStash", "cluckinbell_"..data.stash)
		TriggerServerEvent("inventory:server:OpenInventory", "stash", "cluckinbell_"..data.stash)
	end
end)
 ]]

RegisterNetEvent('jixel-cluckinbell:client:GrabBag', function(data)
	if progressBar({ label = Loc[Config.Lan].progressbar["grab_box"], time = 2000, useWhileDead = false, canCancel = true,
	anim = "cop_b_idle", animDict = "anim@heists@prison_heiststation@cop_reactions"}) then
		TriggerServerEvent("jixel-cluckinbell:server:GrabBag")
		ClearPedTasks(PlayerPedId())
	else -- Cancel
		TriggerEvent('inventory:client:busy:status', false)
		ClearPedTasks(PlayerPedId())
	end
end)

RegisterNetEvent('jixel-cluckinbell:Stash', function(data, id)
	if id then -- If it has a bag ID then open the limited stash (doens't work with ox yet, not sure how to make a stash on the fly that isn't exploitable)
		TriggerServerEvent("inventory:server:OpenInventory", "stash", "cluckinbell_"..id, { maxweight = 2000000, slots = 6, })
		TriggerEvent("inventory:client:SetCurrentStash", "cluckinbell_"..id)
	else
		if data.job and not jobCheck() then return end
		if Config.Inv == "ox" then exports.ox_inventory:openInventory('stash', tostring(data.id))
		else TriggerEvent("inventory:client:SetCurrentStash", tostring(data.id))
		TriggerServerEvent("inventory:server:OpenInventory", "stash", tostring(data.id)) end
	end
	lookEnt(data.coords)
end)

RegisterNetEvent('jixel-cluckinbell:locker', function()
	if not jobCheck() then return end
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "cbellemployee_"..QBCore.Functions.GetPlayerData().citizenid, { maxweight = Config.LockerWeight * 1000, slots = 15,})
    TriggerEvent("inventory:client:SetCurrentStash", "cbellemployee_"..QBCore.Functions.GetPlayerData().citizenid)
end)

RegisterNetEvent('jixel-cluckinbell:client:shop', function(data)
	if Config.Debug then print(json.encode(data)) end
	if not jobCheck() then return end
	lookEnt(data.coords)
	if Config.Inv == "ox" and not Config.JimShop then exports.ox_inventory:openInventory('shop', { type = data.shopname }) else
	TriggerServerEvent(((Config.JimShop) and "jim-shops:ShopOpen" or "inventory:server:OpenInventory"), "shop", "cluckinbell", data.shop) end
end)

RegisterNetEvent('jixel-cluckinbell:client:shop2', function(data)
	if not jobCheck() then return end
	lookEnt(data.coords)
	--[[ if Config.JimShop then event = "jim-shops:ShopOpen" end
	TriggerServerEvent(event, "shop", "cluckinbell", Config.Toy) ]]
	if Config.Inv == "ox" and not Config.JimShop then exports.ox_inventory:openInventory('shop', { type = data.id }) else
	TriggerServerEvent(((Config.JimShop) and "jim-shops:ShopOpen" or "inventory:server:OpenInventory"), "shop", "cluckinbell", data.items) end
end)

RegisterNetEvent('jixel-cluckinbell:Crafting:MakeItem', function(data)
	CraftLock = true
	if data.header == Loc[Config.Lan].menu["header_coffee"] then
		animDictNow = "mp_ped_interaction"
		animNow = "handshake_guy_a"
		bartime = 6000
	elseif data.header == Loc[Config.Lan].menu["header_grill"] then
		animDictNow = "amb@prop_human_bbq@male@base"
		animNow = "base"
		bartime = 6000
	elseif data.header == Loc[Config.Lan].menu["header_oven"] then
		animDictNow = "amb@prop_human_bbq@male@base"
		animNow = "base"
		bartime = 6000
	elseif data.header == Loc[Config.Lan].menu["header_chop"] then
		animDictNow = "anim@heists@prison_heiststation@cop_reactions"
		animNow = "cop_b_idle"
		bartime = 6000
	else
		animDictNow = "amb@prop_human_parking_meter@male@idle_a"
		animNow = "idle_a"
		bartime = 9000
	end
	if progressBar({ label = bartext, time = bartime, canel = true, dict = animDictNow, anim = animNow, flag = 1, icon = data.item}) then
		TriggerServerEvent("jixel-cluckinbell:Crafting:GetItem", data.item, data.craft)
		ClearPedTasks(PlayerPedId())
		Wait(500)
		CraftLock = false
	else
		TriggerEvent("inventory:client:busy:status", false)
		ClearPedTasks(PlayerPedId())
		CraftLock = false
	end
end)


RegisterNetEvent('jixel-cluckinbell:client:Menu:Close', function() exports['qb-menu']:closeMenu() end)


RegisterNetEvent('jixel-cluckinbell:Crafting', function(data)
	if CraftLock then return end
	if not jobCheck() then return end
	local Menu = {}
	if Config.Menu == "qb" then
		Menu[#Menu + 1] = { header = data.header, txt = "", isMenuHeader = true }
		Menu[#Menu + 1] = { icon = "fas fa-circle-xmark", header = "", txt = Loc[Config.Lan].menu["close"], params = { event = "" } }
	end
	for i = 1, #data.craftable do
		for k, v in pairs(data.craftable[i]) do
			if k ~= "amount" then
				local text = ""
				setheader = QBCore.Shared.Items[tostring(k)].label
				if data.craftable[i]["amount"] ~= nil then setheader = setheader.." x"..data.craftable[i]["amount"] end
				local disable = false
				local checktable = {}
				for l, b in pairs(data.craftable[i][tostring(k)]) do
					if b == 0 or b == 1 then number = "" else number = " x"..b end
					if not QBCore.Shared.Items[l] then print("^3Error^7: ^2Script can't find ingredient item in QB-Core items.lua - ^1"..l.."^7") return end
					if Config.Menu == "ox" then text = text..QBCore.Shared.Items[l].label..number.."\n" end
					if Config.Menu == "qb" then text = text.."- "..QBCore.Shared.Items[l].label..number.."<br>" end
					settext = text
					checktable[l] = HasItem(l, b)
				end
				for _, v in pairs(checktable) do if v == false then disable = true break end end
				if not disable then setheader = setheader.." ✔️" end
				local event = "jixel-cluckinbell:Crafting:MakeItem"
                if Config.MultiCraft then event = "jixel-cluckinbell:Crafting:MultiCraft" end
				Menu[#Menu + 1] = {
					disabled = disable,
					icon = "nui://"..Config.img..QBCore.Shared.Items[tostring(k)].image,
					header = setheader, txt = settext, --qb-menu
					title = setheader, description = settext, -- ox_lib
					event = event, args = { item = k, craft = data.craftable[i], craftable = data.craftable, header = data.header, }, -- ox_lib
					params = { event = event, args = { item = k, craft = data.craftable[i], craftable = data.craftable, header = data.header, } } -- qb-menu
				}
				settext, setheader = nil
			end
		end
	end
	if Config.Menu == "ox" then	exports.ox_lib:registerContext({id = 'Crafting', title = data.header, position = 'top-right', options = Menu })	exports.ox_lib:showContext("Crafting")
	elseif Config.Menu == "qb" then	exports['qb-menu']:openMenu(Menu) end
	lookEnt(data.coords)
end)


RegisterNetEvent('jixel-cluckinbell:Crafting:MultiCraft', function(data)
    local success = Config.MultiCraftAmounts local Menu = {}
    for k in pairs(success) do success[k] = true
        for l, b in pairs(data.craft[data.item]) do
            local has = HasItem(l, (b * k)) if not has then success[k] = false break else success[k] = true end
		end end
    if Config.Menu == "qb" then Menu[#Menu + 1] = { header = data.header, txt = "", isMenuHeader = true } end
	Menu[#Menu + 1] = { icon = "fas fa-arrow-left", title = Loc[Config.Lan].menu["back"], header = "", txt = Loc[Config.Lan].menu["back"], params = { event = "jixel-cluckinbell:Crafting", args = data }, event = "jixel-cluckinbell:Crafting", args = data }
	for k in pairsByKeys(success) do
		Menu[#Menu + 1] = {
			disabled = not success[k],
			icon = "nui://"..Config.img..QBCore.Shared.Items[data.item].image, header = QBCore.Shared.Items[data.item].label.." [x"..k.."]", title = QBCore.Shared.Items[data.item].label.." [x"..k.."]",
			event = "jixel-cluckinbell:Crafting:MakeItem", args = { item = data.item, craft = data.craft, craftable = data.craftable, header = data.header, anim = data.anim, amount = k },
			params = { event = "jixel-cluckinbell:Crafting:MakeItem", args = { item = data.item, craft = data.craft, craftable = data.craftable, header = data.header, anim = data.anim, amount = k } }
		}
	end
	if Config.Menu == "ox" then	exports.ox_lib:registerContext({id = 'Crafting', title = data.header, position = 'top-right', options = Menu })	exports.ox_lib:showContext("Crafting")
	elseif Config.Menu == "qb" then	exports['qb-menu']:openMenu(Menu) end
end)

RegisterNetEvent('jixel-cluckinbell:client:Consume', function(itemName, type)
	local emoteTable = {
		--[[ Food ]]
		["fowlburger"] = "cbburger", ["mightyclucker"] = "cbburger", ["friedchicken"] = "cbburger", ["meatfree"] = "cbburger", ["csalad"] = "cbburger",
		["cluckrings"] = "cbburger", ["cluckfries"] = "cbburger", ["clucknuggets"] = "cbburger",
		["strawberrycone"] = "donut3", ["chocolatecone"] = "donut3",
		["cbdonut"] = "donut3",
		--[[ Drinks ]]
		["cbcoke"] = "cbcoke", ["cbcoffee"] = "cbcoffee", ["milkshake"] = "glass",
		["cbrootbeer"] = "cbcoke", ["cborangesoda"] = "cbcoke", ["cblemonlimesoda"] = "cbcoke",
	}
	local progstring, defaultemote = Loc[Config.Lan].progressbar["progress_drink"], "drink"
	if type == "food" then progstring = Loc[Config.Lan].progressbar["progress_eat"] defaultemote = "uwu3" end
	ExecuteCommand("e "..(emoteTable[itemName] or defaultemote))
	if progressBar({label = progstring..QBCore.Shared.Items[itemName].label.."..", time = math.random(3000, 6000), cancel = true, icon = itemName}) then
		ConsumeSuccess(itemName, type)
	else
		ExecuteCommand("e c")
	end
end)

RegisterNetEvent('jixel-cluckinbell:client:Open', function(itemName)
	EmoteStart({emoteName = "cbtoy"})
	if progressBar({ label = Loc[Config.Lan].progressbar["opening"], time = 2500, cancel = true, icon = itemName }) then
		ExecuteCommand("e c")
		local toy = getRandomToy(itemName)
		toggleItem(true, toy, 1)
	else
		ExecuteCommand("e c")
	end
end)

AddEventHandler('onResourceStop', function(r) if r ~= GetCurrentResourceName() then return end
	for k in pairs(Targets) do exports['qb-target']:RemoveZone(k) end
	for _, v in pairs(Props) do unloadModel(v) DeleteEntity(v) end
end)



