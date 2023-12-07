Config = {}

Config.Mysql = 'oxmysql'
Config.IsBoss = false -- if u want only the boss to swap engines (true/false)
Config.DrawText = "qb-core" -- Define the export resource accordingly | qb-core, qb-drawtext, ps-ui
Config.engineLocations = {
  ["rising"] = { -- THis name should be unique no duplicates
    ["coords"] = vector3(-344.87, -114.64, 39.06), -- The coords of the zone
    ["size"] = 2.0, -- How big is the zone?
    ["heading"] = 0.0, -- Heading
    ["debug"] = false, -- Should zone be debugged?
    ["authorizedJob"] = "rising", -- job authorized to engine swap
    ["inVehicle"] = "Press E to engineswap", -- The name if a user is in a vehicle
    ["outVehicle"] = "You need to be in a vehicle!", -- Message if user is not in a vehicle
  },
    ["tunershop"] = { -- THis name should be unique no duplicates
    ["coords"] = vector3(125.47, -3023.28, 6.75), -- The coords of the zone
    ["size"] = 2.0, -- How big is the zone?
    ["heading"] = 0.0, -- Heading
    ["debug"] = false, -- Should zone be debugged?
    ["authorizedJob"] = "midnightmotors", -- job authorized to engine swap
    ["inVehicle"] = "Press E to Swap the Engine", -- The name if a user is in a vehicle
    ["outVehicle"] = "You need to be in a vehicle!", -- Message if user is not in a vehicle
  },
}
Config.custom_engine = {
  [`r34sound`] = { 	custom = true, 	label = 'RB26DE Twin Turbo', 	soundname = 'r34sound', },
  [`f20c`] = { 	custom = true, 	label = 'Civic f20c', 	soundname = 'f20c', },
  [`aq2jzgterace`] = { 	custom = true, 	label = 'Supra 2JZ GTE Twin Turbo', 	soundname = 'aq2jzgterace', },
  [`rotary7`] = { 	custom = true, 	label = 'RX7 13B-REW twin-rotor Twin Turbo', 	soundname = 'rotary7', },
  [`fordvoodoo`] = {   	custom = true, 	label = 'Ford voodoo',   	soundname = 'fordvoodoo',    },
  [`musv8`] = {   	custom = true, 	label = 'ford Mustang v8',   	soundname = 'musv8',    },
  [`f10m5`] = {   	custom = true, 	label = 'BMW M5 f10 ',   	soundname = 'f10m5',    },
  [`lfasound`] = {   	custom = true,  	label = 'LFA V10',   	soundname = 'lfasound',    },
  [`elegyx`] = {   	custom = true,   	turboinstall = true,  	label = 'GTR R35',   	soundname = 'elegyx',    },
  [`ta028viper`] = {   	custom = true, 	label = 'Viper V10',   	soundname = 'ta028viper',    },
  [`porsche57v10`] = {   	custom = true,   	label = 'porsche57 v10',   	soundname = 'porsche57v10',    },
  [`s15sound`] = {   	custom = true, 	label = 'S15 SR20',   	soundname = 's15sound',    },
  [`gt3rstun`] = {   	custom = true, 	label = 'Flat 6',   	soundname = 'gt3rstun',    },
  [`m297zonda`] = {   	custom = true,  	label = 'Zonda V12',   	soundname = 'm297zonda',    },
  [`aq06nhonc30a`] = {   	custom = true,   	turboinstall = true,   	label = 'NSX',   	soundname = 'aq06nhonc30a',    },
  [`p60b40`] = {   	custom = true, 	label = 'Bmw Engine M3',   	soundname = 'p60b40',    },
  [`aqls7raceswap`] = {   	custom = true, 	label = 'C7 v8',   	soundname = 'aqls7raceswap',    },
  [`aqtoy2jzstock`] = {   	custom = true,   	turboinstall = true,   	label = 'Supra 2JZ GTE',   	soundname = 'aqtoy2jzstock',    },
  [`bgw16`] = {   	custom = true, 	label = 'Bugatti W16',   	soundname = 'bgw16',    },
  [`cvpiv8`] = {   	custom = true, 	label = 'cvpi v8',   	soundname = 'cvpiv8',    },
  [`cw2019`] = {   	custom = true,  	label = 'Senna engine',   	soundname = 'cw2019',    },
  [`ea888`] = {   	custom = true, 	label = 'VW ea888',   	soundname = 'ea888',    },
  [`ecoboostv6`] = {   	custom = true, 	label = 'Ford explorer V6',   	soundname = 'ecoboostv6',    },
  [`ftypesound`] = {   	custom = true,  	label = 'Ftype engine',   	soundname = 'ftypesound',    },
  [`hemisound`] = {   	custom = true, 	label = 'Hemi V8 engine',   	soundname = 'dodgehemihellcat',    },
  [`lambov10`] = {   	custom = true,   	turboinstall = true,   	label = 'lambo v10',   	soundname = 'lambov10',    },
  [`lgcy04murciv12`] = {   	custom = true, 	label = 'Lambo v12',   	soundname = 'lgcy04murciv12',    },
  [`mbnzc63eng`] = {   	custom = true, 	label = 'Mercedes c63 V8',   	soundname = 'mbnzc63eng',    },
  [`n4g63t`] = {   	custom = true, 	label = 'Evo engine',   	soundname = 'n4g63t',    },
  [`npcul`] = {   	custom = true,   	turboinstall = true,   	label = 'RRoyce',   	soundname = 'npcul',    },
  [`npolchar`] = {   	custom = true, 	label = 'charger v8',   	soundname = 'npolchar',    },
  [`s85b50`] = {   	custom = true,   	turboinstall = true,   	label = 'Victor v8',   	soundname = 's85b50',    },
  [`subaruej20`] = {   	custom = true, 	label = 'subaru boxer',   	soundname = 'subaruej20',    },
  [`ta488f154`] = {   	custom = true, 	label = 'F488 V8',   	soundname = 'ta488f154',    },
  [`taaud40v8`] = {   	custom = true, 	label = 'Audi v8',   	soundname = 'taaud40v8',    },
  [`trumpetzr`] = {   	custom = true, 	label = 'VQ Straight 6',   	soundname = 'trumpetzr',    },
  [`sultanrsv8`] = {   	custom = true, 	label = 'sultanrsv8',   	soundname = 'sultanrsv8',    },
  [`RX8`] = {   	custom = true, 	label = 'RX7 13B Rotary',   	soundname = 'rx7bpeng',    },
  [`hachurac`] = {   	custom = true, 	label = 'Hachura C',   	soundname = 'hachura',    },
  [`tampax`] = {   	custom = true, 	label = 'Tampa X',   	soundname = 'tampax',    },
  [`demonv8`] = {   	custom = true, 	label = 'Demon V8',   	soundname = 'demonv8',    },
  [`aq42chedrag427`] = {   	custom = true, 	label = 'Chevy 427 Drag',   	soundname = 'aq42chedrag427',    },
  [`bnr34ffeng`] = {   	custom = true, 	label = 'R34',   	soundname = 'bnr34ffeng',    },
  [`chevroletlt4`] = {   	custom = true, 	label = 'Chevy LT4',   	soundname = 'chevroletlt4',    },
  [`cummins5924v`] = {   	custom = true, 	label = 'Cummins',   	soundname = 'cummins5924v',    },
  [`dghmieng`] = {   	custom = true, 	label = 'dghmieng',   	soundname = 'dghmieng',    },
  [`m158huayra`] = {   	custom = true, 	label = 'Huayra',   	soundname = 'm158huayra',    },
  [`nisgtr35`] = {   	custom = true, 	label = 'GTR35',   	soundname = 'nisgtr35',    },
  [`nsr2teng`] = {   	custom = true, 	label = 'nsr2teng',   	soundname = 'nsr2teng',    },
  [`predatorv8`] = {   	custom = true, 	label = 'Predator v8',   	soundname = 'predatorv8',    },
  [`tagt3flat6`] = {   	custom = true, 	label = 'Porsche GT3R',   	soundname = 'tagt3flat6',    },
  [`aq07powerstroke67`] = {   	custom = true, 	label = 'Powerstroke',   	soundname = 'aq07powerstroke67',    },
  [`aq14nisvq37vhrt`] = {   	custom = true, 	label = 'vq37',   	soundname = 'aq14nisvq37vhrt',    },
  [`ta011mit4g63`] = {   	custom = true, 	label = 'Mitsubishi 4g63',   	soundname = 'ta011mit4g63',    },
  [`lg18bmwm4`] = {   	custom = true, 	label = 'BMW M4',   	soundname = 'lg18bmwm4',    },
  [`lamavgineng`] = {   	custom = true, 	label = 'Lamborghini Countach',   	soundname = 'lamavgineng',    },
  [`aq35ferf154cd`] = {   	custom = true, 	label = 'Ferrari F154',   	soundname = 'aq35ferf154cd',    },
  
  -- bikes
  [`suzukigsx`] = {   	custom = true,  	label = 'Bike Suzuki GSXR',   	soundname = 'suzukigsxr1k',    },
  [`tayamahar1`] = {   	custom = true, 	label = 'Bike Yamaha R1',   	soundname = 'tayamahar1',    },
  [`s1000rr`] = {   	custom = true, 	label = 'Bike BMW S1000rr',   	soundname = 'bmws1krreng',    },
  [`mt09eng`] = {   	custom = true, 	label = 'Bike Yamaha MT09',   	soundname = 'mt09eng',    },
  [`ta103ninjah2r`] = {   	custom = true, 	label = 'Bike Kawasaki H2R',   	soundname = 'ta103ninjah2r',    },
}