print("^2Jim^7-^2Consumables ^7v^41^7.^45 ^7- ^2Consumables Script by ^1Jimathy^7")
local QBCore = exports['qb-core']:GetCoreObject()

-- If you need support I now have a discord available, it helps me keep track of issues and give better support.

-- https://discord.gg/xKgQZ6wZvS

StaminaInjector = function()
	QBCore.Functions.Notify('speeeeed')
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.5)
	Wait(30000)
	print(2)
	SetRunSprintMultiplierForPlayer(PlayerId(), 0.7)
	Wait(5000)
	print(3)
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

Config = {
	Debug = false,
	Core = "qb-core",

	Inv = "qb", -- set to "ox" if using ox_inventory
	Notify = "qb",  -- set to "ox" if using ox_lib

	UseProgbar = true,
	ProgressBar = "qb", -- set to "ox" if using ox_lib

	FoodBuffs = {
		-- greasy hands
		['burgershot'] = function()
			if LocalPlayer.state.foodBuff ~= nil then return end
			LocalPlayer.state:set('foodBuff', 'greasy', true)
			QBCore.Functions.Notify('Your hands get greasy...', 'success')
			TriggerEvent('debuffs:startEffect', "buff_greasy", 30*60000)
			-- for i = 1, 6 do
			-- 	QBCore.Functions.Notify('Your hands are greasy...\n('..((6-i)*5)..' minutes left)')
			-- 	Wait(5*60000)
			-- end
			-- QBCore.Functions.Notify('Your hands aren\'t greasy anymore...', 'error')
			-- LocalPlayer.state:set('foodBuff', nil, true)
			-- LocalPlayer.state:set('greasyUncuff', nil, true)
		end,
		-- loot luck
		['cluckinbell'] = function()
			if LocalPlayer.state.foodBuff ~= nil then return end
			LocalPlayer.state:set('foodBuff', 'luck', true)
			LocalPlayer.state:set('foodBuff', 'greasy', true)
			QBCore.Functions.Notify('You feel lucky...', 'success')
			TriggerEvent('debuffs:startEffect', "buff_luck", 30*60000)
			-- for i = 1, 6 do
			-- 	Wait(5*60000)
			-- end
			-- QBCore.Functions.Notify('You don\'t feel lucky anymore...', 'error')
			-- LocalPlayer.state:set('foodBuff', nil, true)
		end,
		-- easier hacking
		['catcafe'] = function()
			if LocalPlayer.state.foodBuff ~= nil then return end
			LocalPlayer.state:set('foodBuff', 'hacking', true)
			QBCore.Functions.Notify('You feel more focused...', 'success')
			TriggerEvent('debuffs:startEffect', "buff_easyhack", 30*60000)
			-- for i = 1, 6 do
			-- 	QBCore.Functions.Notify('You feel more focused...\n('..((7-i)*5)..' minutes left)')
			-- 	Wait(5*60000)
			-- end
			-- QBCore.Functions.Notify('Your focus is back to normal...', 'error')
			-- LocalPlayer.state:set('foodBuff', nil, true)
		end,
		-- faster progress bar
		['beanmachine'] = function()
			if LocalPlayer.state.foodBuff ~= nil then return end
			LocalPlayer.state:set('foodBuff', 'progress', true)
			QBCore.Functions.Notify('You feel you have better dexterity...', 'success')
			TriggerEvent("progressbar:client:toggleFaster", true)
			TriggerEvent('debuffs:startEffect', "buff_easyhack", 30*60000)
			-- for i = 1, 6 do
			-- 	QBCore.Functions.Notify('You feel you have better dexterity...\n('..((6-i)*5)..' minutes left)')
			-- 	Wait(5*60000)
			-- end
			-- LocalPlayer.state:set('foodBuff', nil, true)
			-- TriggerEvent("progressbar:client:toggleFaster", false)
		end,
		-- sneaky (sound minigame, sounds, etc)
		['popsdiner'] = function()
			if LocalPlayer.state.foodBuff ~= nil then return end
			LocalPlayer.state:set('foodBuff', 'sneaky', true)
			QBCore.Functions.Notify('You feel sneaky...', 'success')
			TriggerEvent('debuffs:startEffect', "buff_sneaky", 30*60000)
			-- for i = 1, 6 do
			-- 	QBCore.Functions.Notify('You feel sneaky...\n('..((6-i)*5)..' minutes left)')
			-- 	Wait(5*60000)
			-- end
			-- QBCore.Functions.Notify('You\'re are not sneaky anymore...', 'error')
			-- LocalPlayer.state:set('foodBuff', nil, true)
		end,
	},

	Consumables = {
		-- Default QB food and drink item override

		--Effects can be applied here, like stamina on coffee for example
		["vodka"] = { 			emote = "vodkab", 		canRun = false, 	time = math.random(5000, 6000), stress = 0, heal = 0, armor = 0, type = "alcohol", stats = { effect = "stress", time = 5000, amount = 2, thirst = math.random(10,20), canOD = true }},
		["beer"] = { 			emote = "beer", 		canRun = false, 	time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(3,7), canOD = true }},
		["whiskey"] = { 		emote = "whiskey",  	canRun = false, 	time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "alcohol", stats = { thirst = math.random(3,7), canOD = true }},

		["sandwich"] = { 		emote = "sandwich", 	canRun = false, 	time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(3,7), }},
		["twerks_candy"] = { 	emote = "egobar", 		canRun = true, 		time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(3,7), }},
		["snikkel_candy"] = { 	emote = "egobar", 		canRun = true, 		time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(3,7), }},
		["tosti"] = { 			emote = "sandwich", 	canRun = false, 	time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(3,7), }},

		["coffee"] = { 			emote = "coffee", 		canRun = false, 	time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = math.random(3,7), }},
		["water_bottle"] = { 	emote = "drink", 		canRun = false, 	time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = math.random(3,7), }},
		["kurkakola"] = { 		emote = "ecola", 		canRun = false, 	time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = math.random(3,7), }},

		--[[----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Items that effect status changes, like bleeding can cause problems as they are all handled in their own scripts
		-- Testing these but they may be best left handled by default scripts
		["ifaks"] = { 			emote = "oxy", 		time = math.random(5000, 6000), stress = math.random(12, 24), heal = 10, armor = 0, type = "drug", stats = { effect = "heal", amount = 6, widepupils = false, canOD = false } },
		["bandage"] = { 		emote = "oxy", 		time = math.random(5000, 6000), stress = 0, heal = 10, armor = 0, type = "drug", stats = { effect = "heal", amount = 3, widepupils = false, canOD = false } }, },
		]]

		--Testing effects & armor with small functionality to drugs - This may be another one left to default scripts
		["joint"] = { 			emote = "smoke3",	time = math.random(5000, 6000), stress = math.random(12, 24), heal = 0, armor = 10, type = "drug", stats = { screen = "weed", effect = "armor", widepupils = false, canOD = false } },

		["cokebaggy"] = { 		emote = "coke",		time = math.random(5000, 6000), stress = math.random(12, 24), heal = 0, armor = 0, type = "drug", stats = { screen = "focus", effect = "stamina", widepupils = false, canOD = true } },
		--["crackbaggy"] = { 		emote = "coke",		time = math.random(5000, 6000), stress = math.random(12, 24), heal = 0, armor = 0, type = "drug", stats = { effect = "heal", widepupils = false, canOD = true } },
		["xtcbaggy"] = { 		emote = "oxy",		time = math.random(5000, 6000), stress = math.random(12, 24), heal = 0, armor = 10, type = "drug", stats = { effect = "strength", widepupils = true, canOD = true } },
		["oxy"] = { 			emote = "oxy",		time = math.random(5000, 6000), stress = math.random(12, 24), heal = 0, armor = 0, type = "drug", stats = { effect = "heal", widepupils = false, canOD = false } },
		["methbags"] = { 		emote = "coke",		time = math.random(5000, 6000), stress = math.random(12, 24), heal = 0, armor = 10, type = "drug", stats = { effect = "stamina", widepupils = false, canOD = true } },
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		--CluckinBell - Drinks
		["cbcoffee"] = { emote = "cbcoffee", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = 50, }},
		["cbcoke"] = { emote = "cbsoda", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = 75, }},
		["cborangesoda"] = { emote = "cbsoda", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = 75, }},
		["cblemonlimesoda"] = { emote = "cbsoda", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = 75, }},
		["cbrootbeer"] = { emote = "cbsoda", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = 75, }},

		--CluckinBell-Food
		["cbchickenwrap"] = { emote = "cbburger", canRun = false, 	time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["cbucket"] = {	emote = "cbburger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["csalad"] = { emote = "cbburger", canRun = false, time = math.random(5000, 6000), stress = math.random(2,4), heal = 0, armor = 0, type = "food", stats = { hunger = 50,}},
		["friedchicken"] = { emote = "cbfries", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["clucknuggets"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 50, }},
		["cluckrings"] = {	emote = "cbfries", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 50, }},
		["cluckfries"] = { emote = "cbfries", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 50, }},
		["fowlburger"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["mightyclucker"] = {	emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["chocolatecone"] = { emote = "donut", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 20, }},
		["strawberrycone"] = { emote = "donut", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 20, }},
		["vanillacone"] = { emote = "donut", canRun = false, 	time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 20, }},
		["cbdonut"] = {	emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 20, }},
		["meatfree"] = {	emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},

		--Pops Diner Drinks
		["ecola"] = { emote = "ecola", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = 75, }},
		["ecolalight"] = { emote = "ecola", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = 75, }},
		["sprunk"] = { emote = "sprunk", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = 75, }},
		["sprunklight"] = { emote = "sprunk", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = 75, }},

		--Pops Diner Food
		["crisps"] = { emote = "crisps", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 30, }},
		["carrotcake"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 30, }},
		["cheesecake"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 30, }},
		["jelly"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 30, }},
		["chocpudding"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 30, }},
		["popdonut"] = { emote = "donut", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 30, }},
		["popicecream"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 30, }},
		["chocolate"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 30, }},
		["baconeggs"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["bltsandwich"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["cheeseburger"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["cheesesandwich"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["eggsandwich"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["grilledwrap"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["hamburger"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["hamcheesesandwich"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["hamsandwich"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["ranchwrap"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["sausageeggs"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["steakburger"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["toastbacon"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["tunasandwich"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},
		["veggiewrap"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = 100, }},

		["speed_injector"] = { emote = "inject", nightOnly = true, canRun = false, time = math.random(5000, 6000), stress = 0, heal = 0, armor = 0, type = "injector", stats = { hunger = -10, thirst = -10, screen = "focus", time = 35000 }, action = StaminaInjector },
		["health_injector"] = { emote = "inject", nightOnly = true, canRun = false, time = math.random(5000, 6000), stress = 0, heal = 50, armor = 0, type = "injector", stats = { hunger = -10, thirst = -10, screen = "focus", time = 35000 }, action = nil },
		["armor_injector"] = { emote = "inject", nightOnly = true, canRun = false, time = math.random(5000, 6000), stress = 0, heal = 0, armor = 100, type = "injector", stats = { hunger = -10, thirst = -10, screen = "focus", time = 35000 }, action = nil },

		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		["bandage"] 	= { emote = "cuff", 	time = math.random(10000, 12000), stress = 0, heal = 20, armor = 0, type = "drug", stats = { effect = "bleeding", amount = 3, widepupils = false, canOD = false } },
		["ifaks"] 		= { emote = "cuff", 	time = math.random(15000, 20000), stress = 0, heal = 35, armor = 0, type = "drug", stats = { effect = "heavybleeding", amount = 6, widepupils = false, canOD = false } },
		["splint"] 		= { emote = "cuff", 	time = math.random(15000, 20000), stress = 0, heal = 0, armor = 0, type = "drug", stats = { effect = "bone", amount = 6, widepupils = false, canOD = false } },
		["medkit"] 		= { emote = "cuff", 	time = math.random(30000, 45000), stress = 0, heal = 30, armor = 0, type = "drug", action = function() TriggerEvent("debuffs:healAllEffects") end },
		["burncream"] 	= { emote = "cuff", 	time = math.random(7500, 10000), stress = 0, heal = 0, armor = 0, type = "drug", stats = { effect = "burnt", amount = 6, widepupils = false, canOD = false } },

		["painkillers"] 	= { emote = "oxy", 	time = 5000, stress = 0, heal = 0, armor = 0, type = "drug", stats = { effect = "pain", time = 180000, amount = 6, widepupils = true, canOD = true } },
		["vicodin"] 		= { emote = "oxy", 	time = 5000, stress = 0, heal = 0, armor = 0, type = "drug", stats = { effect = "pain", time = 300000, amount = 6, widepupils = true, canOD = true } },
		["morphine"] 		= { emote = "oxy", 	time = 5000, stress = 0, heal = 0, armor = 30, type = "drug", stats = { effect = "pain", time = 300000, amount = 6, widepupils = true, canOD = true } },

		["adderal"] 		= { emote = "oxy", 	time = 5000, stress = 0, heal = 0, armor = 0, type = "drug", stats = { effect = "hacking", time = 360000, amount = 6, widepupils = false, canOD = false } },

		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		--[[Example item
		["heartstopper"] = {
			emote = "burger", 							-- Select an emote from below, it has to be in here
			time = math.random(5000, 6000),				-- Amount of time it takes to consume the item
			stress = math.random(1,2),					-- Amount of stress relief, can be 0
			heal = 0, 									-- Set amount to heal by after consuming
			armor = 5,									-- Amount of armor to add
			type = "food",								-- Type: "alcohol" / "drink" / "food"

			action = function() end						-- Custom function being triggered after eating.

			stats = {
				screen = "thermal",						-- The screen effect to be played when after consuming the item "rampage" "turbo" "focus" "weed" "trevor" "nightvision" "thermal"
				effect = "heal", 						-- The status effect given by the item, "heal" / "stamina"
														-- "pain" "bone" "bleeding" "heavybleeding" "burnt" "armor" "stress" "swimming" "hacking" "intelligence" "luck" "strength"
				time = 60000,							-- How long the effect should last (if not added it will default to 1 minute)
				amount = 6,								-- How much the value is changed by per second
				hunger = math.random(10, 20),			-- The hunger/thirst stats of the item, if not found in the items.lua
				thirst = math.random(10, 20),			-- The hunger/thirst stats of the item, if not found in the items.lua
			},
			--Reward Items Variables
														-- These can be the only thing in a consumable table and the item will still work
			amounttogive = 3,							-- Used for "RewardItems", tells the script how many to give
			rewards = {
				[1] = {
					item = "plastic", 					-- prize item name
					max = 10,							-- max amount to give (this is put into math.random(1, max) )
					rarity = 1,							-- the rarity system, 1 being rarest, 4 being most common
				},
			},
		},]]

	},
	Emotes = {
		["inject"] = {"anim@amb@business@weed@weed_inspecting_high_dry@", "weed_inspecting_high_base_inspector", "Inject", AnimationOptions =
		{ Prop = "prop_syringe_01", PropBone = 18905, PropPlacement = {0.12, 0.008, 0.03, 240.0, -60.0},
			EmoteMoving = true, EmoteLoop = true, }},

		["drink"] = {"mp_player_intdrink", "loop_bottle", "Drink", AnimationOptions =
			{ Prop = "prop_ld_flow_bottle", PropBone = 18905, PropPlacement = {0.12, 0.008, 0.03, 240.0, -60.0},
				EmoteMoving = true, EmoteLoop = true, }},
		["coffee"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Coffee", AnimationOptions =
			{ Prop = 'p_amb_coffeecup_01', PropBone = 28422, PropPlacement = {0.0,0.0,0.0,0.0,0.0,0.0},
				EmoteLoop = true, EmoteMoving = true }},
		["burger"] = { "mp_player_inteat@burger", "mp_player_int_eat_burger", "Burger",	AnimationOptions =
			{ Prop = 'prop_cs_burger_01', PropBone = 18905, PropPlacement = {0.13,0.05,0.02,-50.0,16.0,60.0},
				EmoteMoving = true }},
		["beer"] = {"amb@world_human_drinking@beer@male@idle_a", "idle_c", "Beer", AnimationOptions =
			{ Prop = 'prop_amb_beer_bottle', PropBone = 28422, PropPlacement = {0.0,0.0,0.06,0.0,15.0,0.0},
				EmoteLoop = true, EmoteMoving = true }},
		["egobar"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger","Ego Bar", AnimationOptions =
			{ Prop = 'prop_choc_ego', PropBone = 60309, PropPlacement ={0.0,0.0,0.0,0.0,0.0,0.0},
				EmoteMoving = true }},
		["sandwich"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Sandwich", AnimationOptions =
			{ Prop = 'prop_sandwich_01', PropBone = 18905, PropPlacement = {0.13,0.05,0.02,-50.0,16.0,60.0},
				EmoteMoving = true }},
		["smoke3"] = { "amb@world_human_aa_smoke@male@idle_a", "idle_b", "Smoke 3", AnimationOptions =
			{ Prop = 'prop_cs_ciggy_01', PropBone = 28422, PropPlacement = {0.0,0.0,0.0,0.0,0.0,0.0},
				EmoteLoop = true, EmoteMoving = true }},
		["whiskey"] = { "amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Whiskey", AnimationOptions =
			{ Prop = 'prop_drink_whisky', PropBone = 28422, PropPlacement = {0.01,-0.01,-0.06,0.0,0.0,0.0},
				EmoteLoop = true, EmoteMoving = true } },
		["vodkab"] = {"mp_player_intdrink", "loop_bottle", "(Don't Use) Vodka Bottle", AnimationOptions =
			{ Prop = 'prop_vodka_bottle', PropBone = 18905, PropPlacement = {0.00, -0.26, 0.10, 240.0, -60.0},
				EmoteMoving = true, EmoteLoop = true }},
		["ecola"] = {"mp_player_intdrink", "loop_bottle", "E-cola", AnimationOptions =
			{ Prop = "prop_ecola_can", PropBone = 18905, PropPlacement = {0.12, 0.008, 0.03, 240.0, -60.0},
				EmoteMoving = true, EmoteLoop = true, }},
		["crisps"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Chrisps", AnimationOptions =
			{ Prop = 'v_ret_ml_chips2', PropBone = 28422, PropPlacement = {0.01, -0.05, -0.1, 0.0, 0.0, 90.0},
				EmoteLoop = true, EmoteMoving = true, }},
		--Drugs
		["coke"] = { "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", "Coke", AnimationOptions =
			{ EmoteLoop = true, EmoteMoving = true, }},
		["oxy"] = { "mp_suicide", "pill", "Oxy", AnimationOptions =
			{ EmoteLoop = false, EmoteMoving = true, EmoteDuration = 2600 }},
		["cigar"] = {"amb@world_human_smoking@male@male_a@enter", "enter", "Cigar", AnimationOptions =
			{ Prop = 'prop_cigar_02', PropBone = 47419, PropPlacement = {0.010, 0.0, 0.0, 50.0, 0.0, -80.0},
				EmoteMoving = true, EmoteDuration = 2600 }},
		["cigar2"] = {"amb@world_human_smoking@male@male_a@enter", "enter", "Cigar 2", AnimationOptions =
			{ Prop = 'prop_cigar_01', PropBone = 47419, PropPlacement = {0.010, 0.0, 0.0, 50.0, 0.0, -80.0},
				EmoteMoving = true, EmoteDuration = 2600 }},
		["joint"] = {"amb@world_human_smoking@male@male_a@enter", "enter", "Joint", AnimationOptions =
			{ Prop = 'p_cs_joint_02', PropBone = 47419, PropPlacement = {0.015, -0.009, 0.003, 55.0, 0.0, 110.0},
				EmoteMoving = true, EmoteDuration = 2600 }},
		["cig"] = {"amb@world_human_smoking@male@male_a@enter", "enter", "Cig", AnimationOptions =
			{ Prop = 'prop_amb_ciggy_01', PropBone = 47419, PropPlacement = {0.015, -0.009, 0.003, 55.0, 0.0, 110.0}, -- animDict, anim, flag = 'mp_arresting', 'a_uncuff', 17 end
			EmoteMoving = true, EmoteDuration = 2600 }},
		["cuff"] = {"mp_arresting", "a_uncuff", "Hands", AnimationOptions =
			{ Prop = 'v_ret_hd_prod1_', PropBone = 47419, PropPlacement = {0.015, -0.009, 0.003, 55.0, 0.0, 110.0},
				EmoteMoving = true }},

	},

}
