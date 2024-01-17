print("QB-DJBooth v1.1 by Jimathy")

Config = {
	Lan = "en",
	Debug = false, -- Set to true to show target locations
	Locations = {
		
		{ -- UwU
			job = "catcafe",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 35,
			coords = vector3(-586.9, -1058.1, 22.25),
			heading = 50.0,
			prop = 'v_res_fh_speakerdock'
		},
	
		{ -- Rising Sun
			job = "lscustoms",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 60,
			coords = vector3(-336.22, -126.26, 38.01),
			heading = 250.00,
			prop = 'h4_prop_battle_club_speaker_large'
		},
		{ -- Bean Machine
			job = "beanmachine",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 40,
			coords = vector3(-632.14, 232.16, 81.65),
			heading = 351.0,
		},
		{ -- Ammunation
			job = "ammunation",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 30,
			coords = vector3(20.00, -1106.7, 29.915),
			heading = 320.0,
			prop = 'prop_speaker_06'
		},
	},
}

Loc = {}
