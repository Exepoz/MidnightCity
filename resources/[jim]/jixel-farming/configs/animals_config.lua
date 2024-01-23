--[[
             _   _   _____   __  __              _         _____
     /\     | \ | | |_   _| |  \/  |     /\     | |       / ____|
    /  \    |  \| |   | |   | \  / |    /  \    | |      | (___
   / /\ \   | . ` |   | |   | |\/| |   / /\ \   | |       \___ \
  / ____ \  | |\  |  _| |_  | |  | |  / ____ \  | |____   ____) |
 /_/    \_\ |_| \_| |_____| |_|  |_| /_/    \_\ |______| |_____/

   In this section is all the Animal Settings
   -> You can like above turn off all blips, turn on blips, and change rep amounts
--]]
AnimalSettings = {
	AnimalFrozen = false, -- Do you want the Animals to Move?
	CatchingChance = 25,
	LeaveZoneGracePeriod = 5, -- This is in seconds
	RespawnTime = 1, -- This is time in minutes for cows to respawn
	CollectWaitTime = 30, -- This is in minutes your player must wait to Collect Eggs or Milk Again!
	KillingWaitTime = 1,
	KnifeBreak = true,
	KnifeBreakChance = 10, -- change to 0 for no chance of breaking
	StressWhenKilling = false,
	Doors = {
		{
			name  = "PigDoor",
			coords = vector3(2188.6394042969, 4981.2802734375, 41.481075286865),
			objHash = 1911284463,
		}
	},
	Cows = {
		Enabled = true,
		Target = true,
		MilkKey = 74,
		KillKey = 38,
		Price = 2000,
		BlipSettings = {
			Enabled = true,
			Label = "Cow Farm",
			BlipLoc = vec3(2267.09, 4925.94, 40.93),
			BlipSprite = 537, BlipColor = 28,
		},
		Setup = {
			KillRepAmount = 2, MilkRepAmount = 2,
			MeatAmount =function() return math.random(7, 10) end,
			StressPerKill = function() return math.random(5, 10) end,
			wanderarea = vector3(2257.88, 4928.65, 40.97),
		},
		CowZone = {
			Zone = {
				vector2(2320.8940429688, 4933.1606445312),
				vector2(2245.7358398438, 4859.5444335938),
				vector2(2188.5236816406, 4914.9638671875),
				vector2(2266.7468261719, 4992.455078125)
			},
			minZ = 35, maxZ = 42.9
		},
		SlaughterZone = {
			Zone = {
				vector3(940.08, -2100.41, 30.6),
				vector3(1013.95, -2099.6, 31.1),
				vector3(1003.84, -2198.45, 30.6),
				vector3(931.93, -2194.66, 30.5)
			},
			MeatReward = function() return math.random(5, 10) end,
			helpermarker = vector3(991.29, -2184.16, 30.68),
			minZ = 35, maxZ = 42.9
		},
		otherCowZone = {
			Zone = {
				vector3(953.05, -2200.81, 30.55),
				vector3(962.11, -2201.98, 30.58),
				vector3(958.84, -2252.34, 30.58),
				vector3(948.31, -2252.95, 30.47)

			},
			minz = 30.0, maxz = 33.0,
			Doors = {
				{
					name = "cowdoor1",
					coords = vector3(960.34, -2244.83, 30.55),
					objHash = 1846022663,
				},
				{
					name = "cowdoor2",
					coords = vector3(961.23, -2234.63, 30.55),
					objHash = 1846022663,
				},
				{
					name = "cowdoor3",
					coords = vector3(962.48, -2218.49, 30.55),
					objHash = 1846022663,
				},
				{
					name = "cowdoor4",
					coords = vector3(963.52, -2208.11, 30.55),
					objHash = 1846022663,
				}
			}
		}
	},
	Pigs = {
		Enabled = true,
		CatchKey = 38,
		Price = 1000,
		BlipSettings = {
			Enabled = true,
			Label = "Pig Farm",
			BlipLoc = vec3(2170.37, 4963.35, 41.36),
			BlipSprite = 537, BlipColor = 28,
		},
		Setup = {
			KillRepAmount = 2,
			MeatAmount = function() return math.random(6, 10) end,
			StressPerKill = function() return math.random(5, 10) end
		},
		PigZone = {
			vector2(2201.2897949219, 4966.8383789063),
			vector2(2189.4172363281, 4978.4379882813),
			vector2(2186.5124511719, 4978.5712890625),
			vector2(2187.1435546875, 4981.6450195313),
			vector2(2175.9663085938, 4993.2368164063),
			vector2(2147.6401367188, 4965.3818359375),
			vector2(2173.42578125, 4938.5825195313)
		  },
		  minZ = 35, maxZ = 42.9,
		Doors = {
			{
				name  = "PigDoor",
				coords = vector3(2188.6394042969, 4981.2802734375, 41.481075286865),
				objHash = 1911284463,
			}
		}
	},
	Chickens = {
		Enabled = true,
		Target = true,
		InteractionKey = 38,
		Price = 1000,
		BlipSettings = {
			Enabled = true,
			Label = "Chicken Farm",
			BlipLoc = vec3(2378.22, 5054.29, 46.44),
			BlipSprite = 537, BlipColor = 28,
		},
		Setup = {
			KillRepAmount = 2, EggCollectRepAmount = 2,
			EggReward = function() return math.random(12, 21) end,
			StressPerKill = function() return math.random(5, 10) end
		},
		ChickenZone = vector3(2378.39, 5053.22, 46.44),
		radius = 10.0,
		minZ = 45, maxZ = 46.9,
		EggZone = {
			vector2(2118.720703125, 4993.6577148438),
			vector2(2107.6721191406, 5005.6533203125),
			vector2(2133.2326660156, 5029.4907226563),
			vector2(2142.4353027344, 5017.7817382813)
		},
		EggminZ = 41, EggmaxZ = 42.9,
		SlaughterZone = {
			Zone = {
				vector3(-73.75, 6283.21, 31.49),
				vector3(-16.27, 6243.47, 31.6),
				vector3(-151.76, 6121.93, 31.62),
				vector3(-195.77, 6167.93, 31.26),
			},
			zonemaxZ = 32.28, zoneMinz = 30.5,
		},
	},
}


Config.CowSetup = {
-- DO NOT TOUCH THE HANDLE
	[1] = { coords = vec4(2257.18, 4906.95, 40.78, 306.4), animDict = "creatures@cow@move", animName = "move", frozen = false, handle = 0 },
	[2] = { coords = vec4(2277.97, 4912.17, 41.01, 84.64), animDict = "creatures@cow@move", animName = "move", frozen = false, handle = 0 },
	[3] = { coords = vec4(2272.46, 4935.68, 41.34, 42.3), animDict = "creatures@cow@amb@world_cow_grazing@base", animName = "base", frozen = true, handle = 0},
	[4] = { coords = vec4(2292.59, 4934.26, 41.43, 228.16), animDict = "creatures@cow@amb@world_cow_grazing@base", animName = "base", frozen = true, handle = 0 },
	[5] = { coords = vec4(2272.83, 4921.62, 41.05, 10.77), animDict = "creatures@cow@move", animName = "base", frozen = false, handle = 0 },
	[6] = { coords = vec4(2249.26, 4914.11, 40.74, 342.34), animDict = "creatures@cow@move", animName = "base", frozen = false, handle = 0 },
	[7] = { coords = vec4(2241.48, 4919.24, 40.77, 286.81), animDict = "creatures@cow@move", animName = "base", frozen = false, handle = 0 },
	[8] = { coords = vec4(2237.38, 4935.5, 40.86, 325.79), animDict = "creatures@cow@move", animName = "base", frozen = false, handle = 0 },
}

Config.ChickenSetup = {
	[1] = { coords = vec4(2377.56, 5054.84, 46.44, 307.01), animDict = "creatures@hen@move", animName = "move",  handle = 0 },
	[2] = { coords = vec4(2383.52, 5051.96, 46.44, 194.91), animDict = "creatures@hen@move", animName = "move", handle = 0 },
	[3] = { coords = vec4(2374.36, 5049.59, 46.44, 116.17), animDict = "creatures@hen@move", animName = "move",  handle = 0 },
	[4] = { coords = vec4(2378.21, 5046.29, 46.44, 229.59), animDict = "creatures@hen@move", animName = "move", handle = 0 },
	[5] = { coords = vec4(2372.12, 5053.71, 46.44, 135.18), animDict = "creatures@hen@move", animName = "move", handle = 0 },
	-- [6] = { coords = vec4(2378.99, 5052.77, 46.44, 94.8), animDict = "creatures@hen@move", animName = "move",  handle = 0 },
	-- [7] = { coords = vec4(2382.76, 5053.41, 46.44, 181.55), animDict = "creatures@hen@move", animName = "move", handle = 0 },
	-- [8] = { coords = vec4(2381.65, 5058.99, 46.44, 285.09), animDict = "creatures@hen@move", animName = "move",  handle = 0 },
}

Config.PigSetup = {
	[1] = { coords = vec4(2188.31, 4962.0, 41.27, 40.9), animDict = "creatures@pig@move", animName = "gallop",  handle = 0 },
	[2] = { coords = vec4(2167.56, 4969.03, 41.4, 109.81), animDict = "creatures@pig@move", animName = "gallop", handle = 0  },
	[3] = { coords = vec4(2159.0, 4963.67, 41.4, 38.75), animDict = "creatures@pig@move", animName = "gallop", handle = 0  },
	-- [4] = { coords = vec4(2172.09, 4949.11, 41.35, 225.39), animDict = "creatures@pig@move", animName = "move", handle = 0  },
	-- [5] = { coords = vec4(2177.12, 4952.44, 41.3, 228.85), animDict = "creatures@pig@move", animName = "move", handle = 0  },
	-- [6] = { coords = vec4(2183.22, 4965.77, 41.32, 288.53), animDict = "creatures@pig@move", animName = "move",  handle = 0  },
	-- [7] = { coords = vec4(2178.39, 4979.12, 41.44, 6.39), animDict = "creatures@pig@move", animName = "move",   handle = 0  },
	-- [8] = { coords = vec4(2162.7, 4961.69, 41.44, 168.05), animDict = "creatures@pig@move", animName = "move",  handle = 0  },
	-- [9] = { coords = vec4(2166.21, 4950.55, 41.48, 221.84), animDict = "creatures@pig@move", animName = "move", handle = 0  },
}

Config.EggSetup = {
	[1] = { coords = vector4(2129.59, 5016.33, 41.52, 306.49), animDict = "creatures@hen@move", animName = "move", frozen = AnimalSettings.AnimalFrozen, handle = 0 },
	[2] = { coords = vector4(2130.54, 5021.06, 41.7, 348.49), animDict = "creatures@hen@move", animName = "move", frozen = AnimalSettings.AnimalFrozen, handle = 0 },
	[3] = { coords = vector4(2135.79, 5017.96, 41.53, 241.5), animDict = "creatures@hen@move", animName = "move", frozen = AnimalSettings.AnimalFrozen, handle = 0 },
	[4] = { coords = vector4(2122.42, 5015.27, 41.51, 137.99), animDict = "creatures@hen@move", animName = "move", frozen = AnimalSettings.AnimalFrozen, handle = 0 },
	[5] = { coords = vector4(2120.37, 5011.83, 41.35, 148.03), animDict = "creatures@hen@move", animName = "move", frozen = AnimalSettings.AnimalFrozen, handle = 0 },
	[6] = { coords = vector4(2120.01, 5005.43, 41.15, 178.14), animDict = "creatures@hen@move", animName = "move", frozen = AnimalSettings.AnimalFrozen, handle = 0 },
	[7] = { coords = vector4(2119.09, 4999.29, 41.18, 170.67), animDict = "creatures@hen@move", animName = "move", frozen = AnimalSettings.AnimalFrozen, handle = 0 },
	[8] = { coords = vector4(2128.32, 5010.36, 41.32, 318.89), animDict = "creatures@hen@move", animName = "move", frozen = AnimalSettings.AnimalFrozen, handle = 0 },
}

Config.CowTagSetup = {
	[1] = { coords = vector4(953.79, -2222.44, 30.59, 173.02), animDict = "creatures@cow@move", animName = "base", handle = 0 },
	[2] = { coords = vector4(955.87, -2210.67, 30.61, 39.78), animDict = "creatures@cow@move", animName = "base", handle = 0 },
}
Config.GameSetups = {
	["chickens"] = {
		{
			model = "a_c_hen",
			animalGroup = "Chicken",
			setups = Config.ChickenSetup,
			teleportCoords = vector4(2386.5480957031, 5045.9619140625, 46.406230926514, 43.617202758789),
			wanderarea = vector3(2378.39, 5053.22, 46.44),
			zoneRadius = 11.0,
		}
	},
	["pigs"] = {
		{
			model = "a_c_pig",
			animalGroup = "Pigs",
			giveItem = "",
			setups = Config.PigSetup,
			teleportCoords = vector4(2187.94, 4979.62, 41.45, 0.0),
			wanderarea = vector3(2173.72, 4966.63, 41.33),
			zoneRadius = 11.0,

		}
	},
	["cows"] = {
		{
			model = "a_c_cow",
			animalGroup = "Cows",
			giveItem = "",
			setups = Config.CowTagSetup,
			teleportCoords = vector4(962.39, -2210.18, 30.61, 79.16),
			wanderarea = vector4(953.97, -2220.55, 30.59, 177.18),
			zoneRadius = 11.0,
		}
	}


}