-- https://docs.fivem.net/docs/game-references/controls/
WheatZone = {
    Enabled = true,
	PickUpKey = 74, RepAmount = 2, WheatWait = 5,
	PickupDistance = 4.0,
	Minigame = {
		enabled = false, -- Dependancy PS-UI
		MinigameCircles = 2,
		MinigameTime = 10,
	},
	WheatPlant = "prop_veg_crop_04", -- You can change the prop if you have custom props
	Effect = "ent_brk_tree_trunk_bark", Scale = 4.0,
	TractorOptions = {
		vehDespawns = true, -- Sends the vehicle to hell
		Fuel = "cdn-fuel", -- Change this to whatever your fuel is: LegacyFuel is usually the standard default
		DepositNeeded = true,
		TractorRent = 1500,
		RakeNeeded = true, -- This is if you want players to have to attach a trailer before being able to harvest wheat
		RakeCoords =  {coords = vec3(2574.34, 4508.96, 36.32), name = ('Trailer Loc'), radius = 7.0}
	},
	Locations = {
		{ 	zoneEnable = true,
			job = Config.ScriptOptions.Job,
			garage = {
				BlipEnabled = false, BlipSpirte = 356, BlipColor = 3,
				BlipScale = 0.6, Disp = 6, BlipLabel = "Wheat Field",
				spawn = vec4(2614.98, 4517.17, 36.14, 145.1),  -- Where the car will spawn
				out = vec4(2618.38, 4513.67, 36.48, 71.25),	-- Where the parking stand is
				ped = {
					model = "A_M_M_Farmer_01", -- Farmer Ped
					scenario = "WORLD_HUMAN_CLIPBOARD" -- Coffee Scenario
				},
				list = { "tractor2"},
			},
		},
	},
	Zones = {
		WheatField = {coords = vector3(2534.32, 4353.35, 40.24), name = ('Wheat Farm'), radius = 45.5},
		TrailerLoc = {coords = vec3(2574.34, 4508.96, 36.32), name = ('Trailer Loc'), radius = 7.0},
	},
}

