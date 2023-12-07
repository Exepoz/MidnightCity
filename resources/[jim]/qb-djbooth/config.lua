print("QB-DJBooth v1.1 by Jimathy")

Config = {
	Lan = "en",
	Debug = false, -- Set to true to show target locations
	Locations = {
		{ -- Cyberbar Top Floor DJ Booth
			job = "cyberbar", -- Set this to required job role
			enableBooth = false, -- option to disable rather than deleting code
			DefaultVolume = 0.1, -- 0.01 is lowest, 1.0 is max
			radius = 30, -- The radius of the sound from the booth
			coords = vector3(333.95, -911.99, 29.46), -- Where the booth is located
		},
		{ -- Henhouse (smokeys MLO coords)
			job = "henhouse",
			enableBooth = false,
			DefaultVolume = 0.1,
			radius = 30,
			coords = vector3(-311.35, 6265.18, 32.06),
		},
		{ -- LS Mech
			job = "lsemech",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 40,
			coords = vector3(555.99, -180.45, 54.51),
		},
		{ -- Real Estate Office
			job = "realestate",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 30,
			coords = vector3(-128.13, -638.62, 168.82),
		},
		{ -- Ottos
			job = "ottos",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 30,
			coords = vector3(836.46, -817.23, 26.33),
		},
		{ -- Leilas House
			--job = "realestate",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 30,
			coords = vector3(-1988.13, -508.83, 25.74)
		},
		{ -- Hayes
			job = "hayes",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 30,
			coords = vector3(-1422.36, -457.0, 37.72),
		},
		{ -- Vanilla Unicorn DJ Booth
			job = "vanilla", -- Set this to required job role
			enableBooth = true, -- option to disable rather than deleting code
			DefaultVolume = 0.1, -- 0.01 is lowest, 1.0 is max
			radius = 50, -- The radius of the sound from the booth
			coords = vector3(119.03, -1299.53, 29.2), -- Where the booth is located
		},
		{ -- Sisyphus Theater
			job = "public", -- "public" makes it so anyone can add music.
			enableBooth = true,
			DefaultVolume = 0.15,
			radius = 200,
			coords = vector3(206.9, 1181.04, 226.51),
			soundLoc = vector3(212.32, 1155.87, 227.01), -- Add sound origin location if you don't want the music to play from the dj booth
		},
		{ -- Tequilala bar (ingame mlo)
			job = "tequilala",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 30,
			coords = vector3(-560.02, 280.7, 85.53),
		},
		{ -- Tequilala bar (ingame mlo)
			job = "tequilala",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 30,
			coords = vector3(-570.97, 288.99, 79.47),
		},
		{ -- GabzTuners Radio Prop
			job = "midnightmotors",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 30,
			coords = vector3(127.85, -3030.65, 6.81),
			heading = 110.0,
			prop = 'prop_speaker_06' -- Prop to spawn at location, if the location doesn't have one already
								   -- (can be changed to any prop, coords determine wether its placed correctly)
		},
		{ -- Gabz Popsdiner Radio Prop
			job = "popsdiner",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 30,
			coords = vector3(1581.65, 6459.25, 25.0),
			heading = 65.0,
			prop = 'bkr_prop_clubhouse_jukebox_01b'
		},
		{ -- LostMC compound next to Casino
			RequireGang = "lostmc",
			enableBooth = false,
			DefaultVolume = 0.1,
			radius = 20,
			coords = vector3(983.14, -133.17, 79.59),
			soundLoc = vector3(988.79, -131.62, 78.89), -- Add sound origin location if you don't want the music to play from the dj booth
		},
		{ -- Bike Garage Bar 2048
			job = "bikegaragebar",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 50,
			coords = vector3(2523.75, 4100.75, 38.50),
			heading = 245.0,
			prop = 'bkr_prop_clubhouse_jukebox_01a'
		},
		{ -- Bike Garage 2048
			job = "bikegarage",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 50,
			coords = vector3(2523.75, 4100.75, 38.50),
		},
		{ -- Gurnville
			RequireGang = "serpents",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 50,
			coords = vector3(1529.55, 3784.45, 34.75),
			heading = 210.0,
			prop = 'sm_prop_smug_wall_radio_01'
		},
		{ -- Midnight Manor
			RequireGang = "midnight",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 80,
			coords = vector3(-1792.15, 428.95, 128.80),
			heading = 180.0,
			prop = 'sm_prop_smug_wall_radio_01'
		},
		{ -- Burgershot
			job = "burgershot",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 35,
			coords = vector3(-1194.79, -893.25, 13.75),
			heading = 300.0,
			prop = 'v_res_mm_audio'
		},
		{ -- Playboy Mansion
			RequireGang = "lostmc",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 50,
			coords = vector3(1424.14, -2628.84, 47.23),
			heading = 160.0,
			prop = 'sf_prop_sf_speaker_l_01a'
		},
		{ -- Playboy Mansion
			RequireGang = "lostmc",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 50,
			coords = vector3(1454.95, -2630.000, 48.54),
			heading = 255.0,
			prop = 'v_ilev_mm_screen2'
		},
		{ -- Slime
			RequireGang = "slimegang",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 35,
			coords = vector3(-161.2, -1622.40, 33.575),
			heading = 15.0,
			prop = 'prop_speaker_05'
		},
		{ -- UwU
			job = "catcafe",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 35,
			coords = vector3(-586.9, -1058.1, 22.25),
			heading = 50.0,
			prop = 'v_res_fh_speakerdock'
		},
		{ -- Eclipse
			job = "eclipse",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 75,
			coords = vector3(-812.00, -706.85, 126.35),
			heading = 230.0,
			prop = 'sf_prop_sf_dj_desk_01a'
		},
		{ -- ComicShop
			job = "comic",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 35,
			coords = vector3(-150.40, 219.75, 94.875),
			heading = 135.00,
			prop = 'prop_speaker_08'
		},
		{ -- Cowboys
			job = "cowboy",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 50,
			coords = vector3(113.0, 6629.75, 30.775),
			heading = 315.00,
			prop = 'h4_prop_battle_club_speaker_large'
		},
		{ -- Rising Sun
			job = "rising",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 60,
			coords = vector3(-334.00, -125.20, 38.065),
			heading = 275.00,
			prop = 'h4_prop_battle_club_speaker_large'
		},
		{ -- New Bennys
			job = "bennys",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 60,
			coords = vector3(-961.25, -2034.75, 9.15),
			heading = 0.00,
			prop = 'h4_prop_battle_club_speaker_small'
		},
		{ -- Pizza This
			job = "pizzathis",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 40,
			coords = vector3(811.50, -751.40, 26.31),
			heading = 90.0,
			prop = 'v_res_fh_speakerdock'
		},
		{ -- White Widow
			job = "whitewidow",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 40,
			coords = vector3(201.30, -244.20, 54.140),
			heading = 351.0,
			prop = 'v_res_fh_speakerdock'
		},
		{ -- Bean Machine
			job = "beanmachine",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 40,
			coords = vector3(-632.14, 232.16, 81.65),
			heading = 351.0,
		},
		{ -- East Customs
			job = "eastcustoms",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 65,
			coords = vector3(870.65, -2119.25, 29.45),
			heading = 85.0,
			prop = 'ba_prop_battle_club_speaker_large'
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
		{ -- Cabal
			RequireGang = "Cabal",
			enableBooth = true,
			DefaultVolume = 0.1,
			radius = 65,
			coords = vector3(-1893.92, 2063.75, 141.23), -- vector3(-1893.92, 2063.75, 141.23)coords for juke box vector3(-1872.665, 2066.25, 140.00) vector3(-1878.45, 2068.30, 141.25)
			heading = 00.0, --250 jukebox heading
			--prop = 'prop_50s_jukebox'
		},
		{ -- club77
			job = "club77",
			enableBooth = true,
			DefaultVolume = 0.3,
			radius = 45,
			coords = vector3(247.22, -3187.06, 0.31), Rotation = vector3(0.0, 0.0, 0.92),heading = 309.7,
		},
	},
}

Loc = {}
