-- If you need support I now have a discord available, it helps me keep track of issues and give better support.

-- https://discord.gg/xKgQZ6wZvS


Config = {
	Debug = false, -- false to remove green boxes
	Lan = "en", -- Pick your language here
	img = "ps-inventory/html/images/", -- Change this to your inventory's name and image folder (SET TO "" IF YOU HAVE DOUBLE IMAGES)

	Core = "qb-core", -- set this to your core folder
	Inv = "qb", -- set to "ox" if using OX Inventory
	Menu = "ox", -- set to "ox" if using ox_lib context menus
	Notify = "ox",
	ProgressBar = "qb",

	MultiCraft = true,
	MultiCraftAmounts = { [1], [5], [10] },

	JimConsumables = true,
	JimShop = false, -- Enable this to use jim-shops for buying ingredients

	craftCam = true,		-- Disable this to stop crafting cameras

			--Simple Toy Reward Support
	RewardItem = "", --Set this to the name of an item
	RewardPool = { -- Set this to the list of items to be given out as random prizes when the item is used - can be more or less items in the list
		"",
		"",
		"",
	},

	Locations = {
		{	zoneEnable = true,
			job = "popsdiner", -- Set this to the required job
			label = "Pop's Diner",
			autoClock = { enter = false, exit = true },
			zones = {
				vec2(2557.83, 2611.83),
				vec2(2568.08, 2584.16),
				vec2(2560.08, 2574.20),
				vec2(2542.66, 2570.72),
				vec2(2517.87, 2574.77),
				vec2(2516.28, 2600.04),
				vec2(2545.29, 2606.90)
			},
			blip = vec3(2539.86, 2584.27, 38.24), blipcolor = 48, blipsprite = 267, blipdisp = 6, blipscale = 0.7, blipcat = nil,
			garage = { spawn = vec4(2524.05, 2583.8, 37.07, 157.27),
						out = vec4(2519.3, 2588.78, 36.95, 247.67),
						list = { "futo", } },
		},
	},
	FoodItems = {
		label = "Food Fridge Store",
		slots = 8,
		items = {
			-- name = "jimsausages", price = 0, amount = 50, info = {}, type = "item", slot = 1, },
			-- name = "jimeggs", price = 0, amount = 50, info = {}, type = "item", slot = 2, },
			-- name = "meat", price = 0, amount = 50, info = {}, type = "item", slot = 3, },
			-- name = "cheese", price = 0, amount = 50, info = {}, type = "item", slot = 4, },
			-- name = "chickenbreast", price = 0, amount = 50, info = {}, type = "item", slot = 5, },
			-- name = "ham", price = 0, amount = 50, info = {}, type = "item", slot = 6, },
			-- name = "lettuce", price = 0, amount = 50, info = {}, type = "item", slot = 7, },
			-- name = "fish", price = 0, amount = 50, info = {}, type = "item", slot = 8, },
		},
	},
	DessertItems = {
		label = "Dessert Counter",
		slots = 8,
		items = {
			{ name = "carrotcake", price = 0, amount = 50, info = {}, type = "item", slot = 1, },
			{ name = "cheesecake", price = 0, amount = 50, info = {}, type = "item", slot = 2, },
			{ name = "jelly", price = 0, amount = 50, info = {}, type = "item", slot = 3, },
			{ name = "chocpudding", price = 0, amount = 50, info = {}, type = "item", slot = 4, },
			{ name = "popdonut", price = 0, amount = 50, info = {}, type = "item", slot = 5, },
			{ name = "popicecream", price = 0, amount = 50, info = {}, type = "item", slot = 6, },
			{ name = "chocolate", price = 0, amount = 50, info = {}, type = "item", slot = 7, },
			{ name = "crisps", price = 0, amount = 50, info = {}, type = "item", slot = 8, }
		},
	},
}

Crafting = {
	Soda = {
		{ ["ecola"] = {}, },
		{ ["ecolalight"] = {}, },
		{ ["sprunk"] = {}, },
		{ ["sprunklight"] = {}, },
	},
	Oven = {
		{ ["baconeggs"] = { ["ham"] = 1, ["jimeggs"] = 1, }, },
		{ ["cheeseburger"] = { ["cheese"] = 1, ["meat"] = 1, }, },
		{ ["hamburger"] = { ["meat"] = 1, }, },
		{ ["sausageeggs"] = { ["jimsausages"] = 1, ["jimeggs"] = 1, }, },
		{ ["steakburger"] = { ["meat"] = 1, }, },
	},
	ChoppingBoard = {
		{ ["bltsandwich"] = { ["ham"] = 1, ["lettuce"] = 1, }, },
		{ ["cheesesandwich"] = { ["cheese"] = 1, }, },
		{ ["eggsandwich"] = { ["jimeggs"] = 1, }, },
		{ ["grilledwrap"] = { ["chickenbreast"] = 1, }, },
		{ ["hamcheesesandwich"] = { ["ham"] = 1, ["cheese"] = 1, }, },
		{ ["hamsandwich"] = { ["ham"] = 1, }, },
		{ ["ranchwrap"] = { ["chickenbreast"] = 1, }, },
		{ ["toastbacon"] = { ["ham"] = 1, }, },
		{ ["tunasandwich"] = { ["fish"] = 1, }, },
		{ ["veggiewrap"] = { ["lettuce"] = 1, }, },
		{ ['delivery_rexdiner'] = {
			['baconeggs'] = 1,
			['ranchwrap'] = 1,
			['sprunk'] = 1,
			['hamburger'] = 1,
		} },
	},
	Coffee = {
		{ ["coffee"] = {}, },
	},
}
QBCore = exports[Config.Core]:GetCoreObject()
Loc = {}