
--[[
  _____   ______  _____  _____  _____   ______   _____
 |  __ \ |  ____|/ ____||_   _||  __ \ |  ____| / ____|
 | |__) || |__  | |       | |  | |__) || |__   | (___
 |  _  / |  __| | |       | |  |  ___/ |  __|   \___ \
 | | \ \ | |____| |____  _| |_ | |     | |____  ____) |
 |_|  \_\|______|\_____||_____||_|     |______||_____/
-- This is where you can determine what your players can make with all your
farmed products!
This beginning part is if you want Rep Based crafting - this was decided back
at the top of the Config under FarmingRep option. If you do not want farming rep
crafted recipes scroll down to the else and use that table instead.

The recipes are completely changeable for whatever your heart desires
You can add as many recipes as you'd like!
--]]

Crafting = {
	Juicer = {
		{ ['applejuice'] = { ['apple'] = 2, }, rep = 0 },
		{ ['orangejuice'] = { ['orange'] = 2, }, rep = 0 },
		{ ['peachjuice'] = { ['peach'] = 2,  }, rep = 0 },
		{ ['tomatojuice'] = { ['tomato'] = 2,  }, rep = 0 },
		{ ['lemonjuice'] = { ['lemon'] = 2,  }, rep = 0 },
	},
	Processor = {
		{ ['tomatosauce'] = { ['basil'] = 1, ['tomatojuice'] = 1, ['oregano'] = 1, }, rep = 0 },
		{ ['strawberryjam'] = { ['strawberry'] = 1, ['sugar'] = 1, }, rep = 0 },
		{ ['salsa'] = { ['chilipepper'] = 1, ['tomato'] = 1, ['cilantro'] = 1, }, rep = 0 },
	},
	Pestle = {
		{ ['flour'] = { ['wheat'] = 1, }, rep = 0 },

	},
	MeatProcessor = {
		{ ['rawporkchops'] = { ['rawpork'] = 1,  }, rep = 0 },
		{ ['rawbacon'] = { ['rawpork'] = 1,  }, amount = 5, rep = 0, },
		{ ['rawgroundbeef'] = { ['rawbeef'] = 1, }, rep = 0 },
		{ ['rawsteak'] = { ['rawbeef'] = 1, }, rep = 0 },
	},
	ChickenProcess = {
		{ ['chickenbreast'] = { ['rawchicken'] = 1, }, rep = 0 },
		{ ['chickenwings'] = { ['rawchicken'] = 1, }, rep = 0 },
	},
	MilkProcess = {
		{ ['milk'] = { ['milkbucket'] = 1,}, amount = 2,  rep = 0 },
		{ ['butter'] = { ['milk'] = 1, },  amount = 2, rep = 0 },
		{ ['cheese'] = { ['milk'] = 1 ,}, amount = 3,  rep = 0 },
		{ ['foodpack_egg'] = { ['egg'] = 12 ,}, amount = 1,  rep = 0 },
	},
	Drying = {
		['driedtobaccoleaves'] = {
			amount = 1,
			item = {name= "pickedtobaccoleaves", amount = 1},
			dryingTime = 5,
			rep = 0
		},
	},
	Curing = {
		['curedtobaccoleaves'] = {
			amount = 1,
			item = {name= "driedtobaccoleaves", amount = 1},
			curingTime = 5,
			rep = 0
		},
	}
}

