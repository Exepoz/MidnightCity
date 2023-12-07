Config = {
	Debug = true,  -- True to show debug boxes
	PrintDebug = false, -- True to show debug prints
	EmoteMenu = "default",
	Core = "qb-core", -- put your core name here if you chose for some reason to rename your qb-core core. Trust me I will judge you.
	Lan = "en", -- Pick your language here (English only at the moment, feel free to submit your own translations)
	img = "ps-inventory/html/images/", -- Change this to your inventory's name and image folder (SET TO "" IF YOU HAVE DOUBLE IMAGES)
	MenuImg = "https://i.imgur.com/eEsiWGn.png", -- this is a placeholder  use the psd
	MultiCraft = false, -- This will allow you to multicraft items
	MultiCraftAmounts = { [1], [5], [10] },
	Inv = "qb", -- change to ox if using ox inventory
	ProgressBar = "qb", --hange to ox if using ox lib
	Notify = "ox", -- change to qb if using qb-notify
	Menu = "ox", -- change to qb if using qb-menu
	JimShop = false, 		-- Enable this to use jim-shops for buying ingredients
	CheckMarks = true, -- If true this will show the player if they have the correct items to be able to craft the items
	JimConsumables = false,
}

Crafting = {
	ChopBoard = {
		{ ['slicedonions'] = { ['onion'] = 1, },
			['amount'] = 3 },
		{ ['slicedpotatoes'] = { ['potato'] = 1, },
			['amount'] = 3 },
		{ ['slicedtomatoes'] = { ['tomato'] = 1, },
			['amount'] = 3 },
	},
	Fryer = {
		{ ['cluckfries'] = { ['slicedpotatoes'] = 3, } },
		{ ['cluckrings'] = { ['slicedonions'] = 4, } },
		{ ['clucknuggets'] = { ['frozennugget'] = 3, } },
		{ ['friedchicken'] = { ['rawchickenwing'] = 4, }, ['amount'] = 4 },
		{ ["cbdonut"] = {}},
	},
	Grill = {
		{ ['chickenpatty'] = { ['rawchickenbreast'] = 1, } },
	},
	Prepare = {
		{ ['mightyclucker'] = { ['burgerbun'] = 1, ['cheese'] = 2, ['lettuce'] = 1, ['chickenpatty'] = 2, ['slicedonions'] = 1, } },
		{ ['fowlburger'] = { ['burgerbun'] = 1, ['cheese'] = 1, ['lettuce'] = 1, ['chickenpatty'] = 1, ['slicedtomatoes'] = 1, } },
		{ ['meatfree'] = { ['burgerbun'] = 1, ['cheese'] = 1, ['lettuce'] = 1, ['slicedtomatoes'] = 1, ['slicedonions'] = 1, } },
		{ ['cbchickenwrap'] = { ['clucknuggets'] = 1, ['lettuce'] = 1, } },
		{ ['csalad'] = { ['clucknuggets'] = 1, ['lettuce'] = 1, ['slicedtomatoes'] = 1, } },
		{ ['cbucket'] = { ['friedchicken'] = 4, } },
	},
	Drink = {
		{ ['water_bottle'] = { } },
		{ ['cbcoke'] = { } },
		{ ['cborangesoda'] = { } },
		{ ['cblemonlimesoda'] = { } },
		{ ['cbrootbeer'] = { } },
	},
	Coffee = {
		{ ['cbcoffee'] = {} },
	},
	IceCream = {
		{ ["chocolatecone"] = { ['chocolate'] = 1,} },
		{ ["strawberrycone"] = { ['strawberry'] = 1,} },
	},
}

Config.Locations = {}
Loc = {}