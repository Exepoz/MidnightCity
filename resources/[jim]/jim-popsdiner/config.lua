-- If you need support I now have a discord available, it helps me keep track of issues and give better support.

-- https://discord.gg/xKgQZ6wZvS


Config = {
	Debug = true, -- false to remove green boxes
	Lan = "en", -- Pick your language here
	img = "ps-inventory/html/images/", -- Change this to your inventory's name and image folder (SET TO "" IF YOU HAVE DOUBLE IMAGES)

	Core = "qb-core", -- set this to your core folder
	Inv = "qb", -- set to "ox" if using OX Inventory
	Menu = "ox", -- set to "ox" if using ox_lib context menus
	Notify = "ox",
	ProgressBar = "qb",

	MultiCraft = true,
	MultiCraftAmounts = { [1], [5], [10] },

	JimConsumables = false,
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
				vec2(1558.0170898438, 6442.4106445312),
				vec2(1601.52734375, 6424.2348632812),
				vec2(1610.9509277344, 6449.2001953125),
				vec2(1613.7552490234, 6464.6137695312),
				vec2(1575.8428955078, 6482.0229492188)
			},
			blip = vec3(1583.98, 6449.49, 25.18), blipcolor = 48, blipsprite = 267, blipdisp = 6, blipscale = 0.7, blipcat = nil,
			garage = { spawn = vec4(1600.34, 6446.77, 24.75, 157.27),
						out = vec4(1597.81, 6446.65, 25.23, 247.67),
						list = { "futo", } },
		},
	},
	FoodItems = {
		label = "Food Fridge Store",
		slots = 8,
		items = {
			{ name = "jimsausages", price = 0, amount = 50, info = {}, type = "item", slot = 1, },
			{ name = "jimeggs", price = 0, amount = 50, info = {}, type = "item", slot = 2, },
			{ name = "meat", price = 0, amount = 50, info = {}, type = "item", slot = 3, },
			{ name = "cheddar", price = 0, amount = 50, info = {}, type = "item", slot = 4, },
			{ name = "chickenbreast", price = 0, amount = 50, info = {}, type = "item", slot = 5, },
			{ name = "ham", price = 0, amount = 50, info = {}, type = "item", slot = 6, },
			{ name = "lettuce", price = 0, amount = 50, info = {}, type = "item", slot = 7, },
			{ name = "fish", price = 0, amount = 50, info = {}, type = "item", slot = 8, },
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
		{ ["cheeseburger"] = { ["cheddar"] = 1, ["meat"] = 1, }, },
		{ ["hamburger"] = { ["meat"] = 1, }, },
		{ ["sausageeggs"] = { ["jimsausages"] = 1, ["jimeggs"] = 1, }, },
		{ ["steakburger"] = { ["meat"] = 1, }, },
	},
	ChoppingBoard = {
		{ ["bltsandwich"] = { ["ham"] = 1, ["lettuce"] = 1, }, },
		{ ["cheesesandwich"] = { ["cheddar"] = 1, }, },
		{ ["eggsandwich"] = { ["jimeggs"] = 1, }, },
		{ ["grilledwrap"] = { ["chickenbreast"] = 1, }, },
		{ ["hamcheesesandwich"] = { ["ham"] = 1, ["cheddar"] = 1, }, },
		{ ["hamsandwich"] = { ["ham"] = 1, }, },
		{ ["ranchwrap"] = { ["chickenbreast"] = 1, }, },
		{ ["toastbacon"] = { ["ham"] = 1, }, },
		{ ["tunasandwich"] = { ["fish"] = 1, }, },
		{ ["veggiewrap"] = { ["lettuce"] = 1, }, },
	},
	Coffee = {
		{ ["coffee"] = {}, },
	},
}
QBCore = exports[Config.Core]:GetCoreObject()
Loc = {}