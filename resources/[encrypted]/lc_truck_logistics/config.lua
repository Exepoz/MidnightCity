Config = {}

Config.account = {								-- Account configs
	['trucker'] = 'bank',						-- Change here the account that should be used with trucker expenses
}

Config.job = {"trucker"}		-- Required jobs name to open the menu (set as {} to disable the permission)

Config.disable_loans = true					-- Set this to true if you want to disable the loans
Config.disable_drivers = false					-- Set this to true if you want to disable the NPC drivers

-- Here are the places where the person can open the trucker menu
-- You can add as many locations as you like, just use the location already created as an example
Config.trucker_locations = {
	["trucker_1"] = {															-- ID
		['menu_location'] = {1208.7689208984,-3114.9829101562,5.5403342247009},	-- Coordinate to open the menu (vector3)
		['garage_location'] = {													-- Garage coordinates, where the trucks will spawn (vector4)
			{1250.55,-3162.4,5.88,270.00},
			{1250.76,-3168.05,5.86,270.00},
			{1245.91,-3135.67,5.62,270.00},
			{1246.07,-3142.42,5.63,270.00},
			{1245.93,-3149.04,5.62,270.00},
			{1245.69,-3155.94,5.6,270.00},
		},
		['trailer_location'] = {												-- Trailer coordinates, where the trailers will spawn (vector4)
			{1274.21,-3186.43,5.91,90.00},
			{1274.21,-3186.43,5.91,90.00},
			{1272.53,-3097.32,5.91,90.00},
			{1273.55,-3088.39,5.91,90.00},
			{1273.47,-3123.78,5.91,90.00},
			{1272.68,-3159.19,5.91,90.00},
			{1275.37,-3174.52,5.91,90.00},
			{1275.04,-3168.83,5.91,90.00},
		},
		['blips'] = {							-- Create the blips on map
			['id'] = 599,						-- Blip ID [Set this value 0 to dont have blip]
			['name'] = "Truck Logistics",		-- Blip Name
			['color'] = 4,						-- Blip Color
			['scale'] = 0.5,					-- Blip Scale
		}
	}
}

-- Here is the definition of the contracts that are generated for the players to deliver
Config.jobs = {
	['cancel_job'] = 167,						-- Key to cancel the active job (167 = F6) [Hold key 2 seconds]
	['cooldown'] = 1, 							-- Cooldown time (in minutes) to generate a new contract
	['price_per_km_min'] = 100,				-- Minimum price per kilometer of the contract
	['price_per_km_max'] = 200,				-- Maximum price per kilometer of the contract
	['freight_job_mutiplier'] = 1.2,			-- Multiplier applied when generating FREIGHT loads
	['probability_urgent_cargo'] = 10,			-- The urgent load is generated randomly, here you can configure the probability (%)
	['max_contratos_ativos'] = 60,				-- Maximum of contracts that can be active, this means that when generating a contact that exceeds this number, the oldest contract will be deleted
	['available_trucks'] = {					-- List of trucks that are generated in contracts
		"hauler","packer"
	},
	['must_bring_truck_back'] = true,			-- true: Payment will only be made when bringing the truck back to the garage (except with own truck) | false: Payment will be made upon delivery of the cargo
	['available_loads'] = {
		--[[
			List of cargo types generated in contracts.
			'trailer': refers to the trailer spawn name.
			'name': is the displayed name for players to select from.
			'def': defines the cargo attributes, including ADR certification type, fragility, and value.
			'def' consists of 3 values:
			'def' = {
				0,  -- [First value]: ADR certificate type. 0 = None, 1 = Explosives, 2 = Flammable gases, 3 = Flammable liquids, 4 = Flammable solids, 5 = Toxic substances, 6 = Corrosive substances
				0,  -- [Second value]: Fragile cargo. 0 = Not fragile, 1 = Fragile
				0   -- [Third value]: Valuable cargo. 0 = Not valuable, 1 = Valuable
			}
		]]
		{ trailer = "armytanker", name = "Army fuel tank", def = {3,0,0}},
		{ trailer = "armytanker", name = "Army water supply", def = {0,0,0}},
		{ trailer = "armytanker", name = "Army Corrosive Materials Tank", def = {6,0,1}},
		{ trailer = "armytanker", name = "Army flammable gas tank", def = {2,0,0}},
		{ trailer = "armytanker", name = "Army toxic gas tank", def = {5,0,0}},
		{ trailer = "armytanker", name = "Army secret materials", def = {0,0,1}},

		{ trailer = "tanker", name = "Potassium hydroxide", def = {6,0,0}},
		{ trailer = "tanker", name = "Nitrogen", def = {2,0,1}},
		{ trailer = "tanker", name = "Potassium chloride", def = {5,0,0}},
		{ trailer = "tanker", name = "Poison", def = {5,0,0}},
		{ trailer = "tanker", name = "Pesticide", def = {5,0,0}},

		{ trailer = "armytrailer", name = "Empty army trailer", def = {0,0,0}},

		{ trailer = "armytrailer2", name = "Heavy machinery transport", def = {0,1,1}},
		{ trailer = "armytrailer2", name = "Tunneling machine transport", def = {0,1,1}},

		{ trailer = "trailers", name = "Furniture transport", def = {0,0,0}},
		{ trailer = "trailers", name = "Refrigerator transport", def = {0,1,0}},
		{ trailer = "trailers", name = "Brick transport", def = {0,0,0}},
		{ trailer = "trailers", name = "Transport of imported products", def = {0,0,1}},
		{ trailer = "trailers", name = "Transport of plastics", def = {0,0,0}},
		{ trailer = "trailers", name = "Clothing transport", def = {0,0,0}},
		{ trailer = "trailers", name = "Chair transport", def = {0,0,0}},
		{ trailer = "trailers", name = "Appliance transport", def = {0,0,0}},
		{ trailer = "trailers", name = "Transport of cleaning supplies", def = {0,0,0}},
		{ trailer = "trailers", name = "Refined timber transport", def = {0,0,0}},
		{ trailer = "trailers", name = "Stone transport", def = {0,0,0}},
		{ trailer = "trailers", name = "Transport of jewels", def = {0,1,1}},
		{ trailer = "trailers", name = "Glass transport", def = {0,1,0}},
		{ trailer = "trailers", name = "Ammo transport", def = {1,0,0}},

		{ trailer = "tr2", name = "Car trailer empty", def = {0,0,0}},

		{ trailer = "trailers4", name = "Naval articles trailer", def = {0,0,0}},
		{ trailer = "trailers4", name = "Boat trailer", def = {0,1,1}},

		{ trailer = "tr4", name = "Stork", def = {0,1,1}},

		{ trailer = "tvtrailer", name = "Transport of materials for shows", def = {0,0,1}},
		{ trailer = "tvtrailer", name = "Transport of event materials", def = {0,1,1}},

		{ trailer = "tanker", name = "Fuel tank with additives", def = {3,0,0}},
		{ trailer = "tanker2", name = "Common fuel tank", def = {3,0,0}},
		{ trailer = "tanker2", name = "Kerosene tank", def = {3,0,0}},
		{ trailer = "tanker2", name = "Oil tank", def = {3,0,0}},

		{ trailer = "trailers3", name = "Transport of exotic materials", def = {0,1,1}},
		{ trailer = "trailers3", name = "Transport of rare materials", def = {0,1,1}},
		{ trailer = "trailers3", name = "Transport of armaments", def = {0,0,1}},

		{ trailer = "trailerlogs", name = "Log transportation", def = {0,0,0}},

		{ trailer = "trailers", name = "Transport of construction materials", def = {0,0,0}},
		{ trailer = "trailers", name = "Rubber transport", def = {0,0,0}},
		{ trailer = "trailers", name = "Appliance transportation", def = {0,1,0}},
		{ trailer = "trailers", name = "Transport of vaccines", def = {0,1,0}},
		{ trailer = "trailers", name = "Transport of explosives", def = {1,1,0}},
		{ trailer = "trailers", name = "Sawdust transport", def = {0,0,0}},

		{ trailer = "trailers2", name = "Grape transport", def = {0,0,0}},
		{ trailer = "trailers2", name = "Pork transport", def = {0,0,0}},
		{ trailer = "trailers2", name = "Transport of beef", def = {0,0,0}},
		{ trailer = "trailers2", name = "Carrot transport", def = {0,0,0}},
		{ trailer = "trailers2", name = "Potato transport", def = {0,0,0}},
		{ trailer = "trailers2", name = "Milk transport", def = {0,0,0}},
		{ trailer = "trailers2", name = "Transport of canned goods", def = {0,0,0}},
		{ trailer = "trailers2", name = "Frozen meat transport", def = {0,0,0}},
		{ trailer = "trailers2", name = "Bean transport", def = {0,0,0}},
		{ trailer = "trailers2", name = "Vinegar transport", def = {0,0,0}},
		{ trailer = "trailers2", name = "Lemonade transport", def = {0,0,0}},
		{ trailer = "trailers2", name = "Bottled water transport", def = {0,0,0}},
		{ trailer = "trailers2", name = "Cheese transport", def = {0,0,0}},

		{ trailer = "trailers3", name = "Tile transport", def = {0,0,0}},
		{ trailer = "trailers3", name = "Rail transport", def = {0,0,0}},
		{ trailer = "trailers3", name = "Transport of used packaging", def = {0,0,0}},
		{ trailer = "trailers3", name = "Floor plate transport", def = {0,0,0}},
		{ trailer = "trailers3", name = "Ceramic transport", def = {0,1,0}},
		{ trailer = "trailers3", name = "Scrap transport", def = {0,0,0}},

		{ trailer = "trailers4", name = "Transport of fireworks", def = {1,1,0}},
		{ trailer = "trailers4", name = "Transport of explosives", def = {1,1,0}},
		{ trailer = "trailers4", name = "Dynamite transport", def = {1,1,0}},
		{ trailer = "trailers4", name = "White phosphorus transport", def = {4,1,0}},
	}
}

-- Here is the definition of the drivers that are generated for the players to hire
Config.drivers = {
	['cooldown'] = 60,							-- Cooldown time (in minutes) to generate a new driver

	['hiring_costs'] = {						-- Cost of hiring the driver (this amount will only be paid at the time of hiring)
		['min'] = 20000,							-- This is the minimum base cost of hiring the employee
		['max'] = 30000,							-- This is the maximum base cost of hiring the employee (this amount will increase according to the employee's skills)
		['percentage_skills'] = 25,				-- This is the % cost that each skill will add to the cost of hiring the driver. That is, for each skill level the driver has, this percentage will increase. (In this case, each skill will increase the cost by 25%)
	},

	['available_drivers'] = {
		-- List of drivers that are randomly generated to be hired
		{img = "img/avatar/avatar8.png", names = {"Pedro Aquino","Jorge Fernandes","Lucas Silva","Cochran Hicks","Shirley Austin","Grimes Williamson","Kirk Cook","Davis Guerrero","Rocha Good","Hatfield Clarke","Norton Anthony","Parks Dale","Ellison Harrison","Rojas Boyd","Moon Acevedo","Carole Rivas","Wells Wyatt","Beasley Griffith","Jordan Hyde","Holman Dixon","Holden Lynch","Mckenzie Wilkerson","Chapman Preston","Christian Green","Blake Stuart","Paulette Atkinson","Dollie Lane","Castaneda Browning","Baldwin Blankenship","Russell Bowen","Madge Boyle","Nanette Cummings","Brooke Spence","Whitfield Berg","Angie Gonzales","Johanna Mercer","Terrell Mcmillan","Gilmore Quinn","Kenya Pittman","Hurley Black","Shanna Ortega","Logan Sharpe","Mari Brady","Mendoza Wilkinson","Stacie Sanford","Polly Acosta","Stone Robinson","Claudette Bartlett","Young Hines","Potter Wagner","Reilly Callahan","Kerr Kemp","Goff Raymond"}},
		{img = "img/avatar/avatar7.png", names = {"Ivan Noleto Sequeira","Kim Wolfe","Laura Logan","Bruce Craft","Compton Luna","Randolph Callahan","Mccray Brock","Sybil Miles","Hendricks Henry","Tina Compton","Phelps Hunter","Jones Russo","Esmeralda Banks","Reid Dean","Parrish Cole","Carlson Gilbert","Jackie Macias","Liza Morse","Mclean Warner","Winnie Lopez","Katheryn Valenzuela","Wade Mccoy","Acosta Mays","Valeria Witt","Elnora Howard","Bernadette Dawson","Rivera Casey","Little Sanford","Deanna Petty","Leonard Blackwell","Payne Leblanc","Tammy Murphy","Sargent Donaldson","Colon Carey","Janis Roth","Lidia Higgins","Lakisha Whitaker","Adrian Mcbride","Maria Forbes","Daisy Mason","Pittman Curtis","Ladonna Bryan","Gaines Hogan","Powers Rodriquez","Donna Hopper","Kristi Livingston","Chelsea Bauer","Gray Fleming","Contreras Mcdonald","Vilma Potts","Guadalupe Mullins"}},
		{img = "img/avatar/avatar6.png", names = {"Kenya Mullen","Castaneda Colon","Judy Mckay","Taylor Kerr","Hurst Roy","Owens Vaughan","Vanessa Cline","Bertie Edwards","Flynn Frank","Burks Sutton","Randi Meadows","Tessa Gentry","Lowery Wooten","Acosta Harper","Georgette Cooley","Candice Patterson","Kirsten Daniels","Blake West","Alexandria Pope","Lena Forbes","Morton Snyder","Tara Bradford","Selena Sykes","Tameka Atkinson","Fowler Walker","Gena Ortega","Sheppard Navarro","Imelda Duncan","Christina Bowers","Aline Haynes","Benita Bright","Boyd Mccall","Sandra Weaver","Melissa Wells","Graham Gilmore","Katrina Oliver","Ginger Larson","Griffith Bishop","Barbara Washington","Iris Christensen","Bauer Gay","Hays Vega","Valarie Booth","Kitty Crane","Carmella Torres","Angelina Puckett","Stone Cabrera","Brock Humphrey","Hillary Houston","Callie Robles"}},
		{img = "img/avatar/avatar5.png", names = {"Rocha Harrell","Gilliam Thomas","Osborne Blevins","Elba Chambers","Heath Price","Melinda Maynard","Ashlee Johns","Shelton Petty","Carey Mcclain","Blackwell Horne","Deborah Gonzalez","Buck Faulkner","Celina Chang","Kennedy Patrick","Atkinson Sherman","Janelle Tyson","Noelle Vincent","Leah Barron","Angeline Sellers","Trudy Murray","Contreras Hardy","Fletcher Todd","Benson Singleton","Sanford Dean","Hartman Wilkinson","Harriet Robinson","Vivian Osborn","Ida Simmons","Tamara Merrill","Esmeralda Baird","Maynard Oneal","Brianna Greene","Pat Stewart","Tate Wood","French Farrell","Jolene Calderon","Irene Roth","Dina Waller","Gonzalez Alvarez","Leigh Durham","Eve Moody","Lydia Hewitt","Price Summers","Duran Schultz","Rena Williamson","Meagan Shaffer","Angelique Dennis","Graham Love","Sheree Lynn","Church Golden"}},
		{img = "img/avatar/avatar4.png", names = {"Cecelia Carson","Rivas Kelly","Green Johnson","Jill Buck","Maddox Leblanc","Hope Aguirre","Aguilar Diaz","Valerie Wiggins","Crystal Sweeney","Sharlene Davidson","Ruthie Valdez","Allyson Haney","Bridgett Wright","Cooke Vargas","Hopkins Neal","Deloris Curry","Alba Warren","Lynette Preston","Candace Britt","Phyllis Mayer","Bailey Stephenson","Meredith Harrell","Conner Heath","Kelly Lynch","Kelli Salinas","Tamara Tran","Boone Sosa","Cora Barrera","John Francis","Tammi Parsons","Natalie Travis","Ivy Mccoy","William Nash","Reba Dillon","Kimberley Whitney","Karen Ellis","Alison Padilla","Spencer Camacho","Blackwell Mccray","Mcgowan Castaneda","Kent Thomas","Lauri Wiley","Atkins Lowery","Janell Hancock","Mosley Carney","Mason Clay","Pat Mercer","Frances Oneal","Brandy Strong","Elvira Houston"}},
		{img = "img/avatar/avatar3.png", names = {"Joice Campos","Mélanie Rebotim","Berenice Holanda","Maitê Lage","Eduarda Barbosa","Livia Martins","Melissa Fernandes","Isabela Castro","Leila Fernandes","Letícia Correia","Melissa Cunha","Gabriela Azevedo"}},
		{img = "img/avatar/avatar2.png", names = {"Howell Dickerson","Carlson Kerr","Kitty Moody","Malinda Richards","Craig Watts","Alana Ratliff","Mindy Patton","Kelly Stone","Beasley Stark","Perez Mercer","Janell Norris","Angela Mayer","Opal Orr","Charity Lamb","Ford Castaneda","Mitzi Nelson","Corrine Morris","Nanette Cervantes","Evelyn Burton","Giles Fletcher","Franklin Hahn","Ruiz Simmons","Selena Murphy","Mccoy Clarke","Skinner Sanford","Lea Oneill","Williamson Rosales","Katharine Hendricks","Dillon Nguyen","Cannon Fulton","Sharp Mccray","Billie Schultz","Flora Griffith","Russell Beasley","Sampson Forbes","Duran Moore","Leach Todd","Henrietta Bowman","Margie Solomon","Mcdonald Collins","Willis Pratt","Britney Dixon","Mcleod Mejia","Salinas Albert","Padilla Lynn","Natalia Garrett","Lynnette Savage","Fleming Keith","Johnston Carrillo","Whitney Gomez"}},
		{img = "img/avatar/avatar1.png", names = {"Bennett Stevens","Mcmillan Calhoun","Paula Blanchard","Roberson Holman","Frost Woods","Drake Boyd","Maricela Long","Hess Guerrero","Martha Adams","Simmons Ramsey","Medina Pitts","Hazel Tyson","Mia Nguyen","Clare Shannon","Kristy Dorsey","Hilda Cochran","Sandy Zimmerman","Petra Lowery","Opal Collier","Velez Terry","Mccormick Hewitt","Weeks Garner","Ashley Byers","Guzman Blackburn","Ramona Stanley","Delia Ratliff","Talley Rodriquez","Ochoa Hayden","Thelma Stout","Lloyd Clarke","Gordon Gould","Aida Noel","Corinne Richmond","Malone Walls","Shields Bowen","Howell Harper","Figueroa Schwartz","Rachel Delgado","Debora Chaney","Chen Avery","Kidd Fitzgerald","Aguirre Park","Combs Cruz","Huff Thompson","Munoz Crosby","Whitaker Mason","Oneil York","Francis Houston","Prince White","Cornelia Bell"}}
	},
	['max_active_drivers'] = 20,				-- Maximum number of drivers that can be active, this means that when generating a driver that exceeds this number, the oldest driver will be deleted
	['max_drivers_per_player'] = 5				-- Maximum number of drivers the player can hire
}

-- Here is the definition of the contracts that are generated for drivers to carry out
Config.driver_jobs = {
	['cooldown'] = 60,							-- Cooldown time (in minutes) for drivers to make contracts and generate money for the company

	['profit'] = {								-- These are the drivers' earnings for each contract, a random value is generated for each contract
		['min'] = 300,							-- Minimum base profit, this will be the minimum money this driver can generate
		['max'] = 650,							-- Maximum base profit, this will be the maximum amount of money this driver can generate (this amount will increase according to the driver's skills)
		['percentage_skills'] = 2,				-- This is the % value that each skill will add to the driver's final profit. That is, the more skills he has, the greater the profit.
	},
	['fuel_consumption'] = {					-- Fuel consumption for each delivery
		['min'] = 4,							-- Minimum % amount consumed
		['max'] = 10								-- Maximum % amount consumed
	},

	['generate_money_offline'] = false 			-- true: drivers will generate money all the time / false: drivers will generate money only if the owner is online
}

Config.sell_price_multiplier = 0.7				-- Value you receive when selling the used truck
Config.dealership = {							-- Truck dealership vehicles
	-- Here you can configure the vehicles of the dealership
	['hauler'] = { 								-- Vehicle spawn name
		['name'] = 'JoBuilt Hauler',		-- Truck name
		['price'] = 310000,						-- Value
		['engine'] = "12.0 L MB OM 457 LA I6",	-- Engine configuration
		['transmission'] = "12-Speed",			-- Transmission configuration
		['hp'] = '450',							-- Horsepower
		['img'] = 'https://cdn.discordapp.com/attachments/533398980428693550/1161272801056002099/Hauler.png',				-- Vehicle image
		['driver_bonus'] = 4 					-- This percentage represents the additional earnings a driver receives when using this specific truck
	},
	-- The other vehicles follow the same pattern as the vehicle above
	['phantom'] = {
		['name'] = 'JoBuilt Phantom',
		['price'] = 600000,
		['engine'] = "15.0 Cummins ISX I6",
		['transmission'] = "10-Speed",
		['hp'] = '550',
		['img'] = 'https://cdn.discordapp.com/attachments/533398980428693550/1161273449721896981/Phantom.png',
		['driver_bonus'] = 10
	},
	['phantom3'] = {
		['name'] = 'JoBuilt Phantom Custom',
		['price'] = 650000,
		['engine'] = "15.0 Cummins ISX I6",
		['transmission'] = "12-Speed",
		['hp'] = '590',
		['img'] = 'https://cdn.discordapp.com/attachments/533398980428693550/1161277185676562462/phantom3.png',
		['driver_bonus'] = 12
	},
	['packer'] = {
		['name'] = 'MTL Packer',
		['price'] = 500000,
		['engine'] = "13.0 D13TC I6",
		['transmission'] = "12-Speed",
		['hp'] = '535',
		['img'] = 'https://cdn.discordapp.com/attachments/533398980428693550/1161273462648745995/packer.png',
		['driver_bonus'] = 8
	}
}
Config.repair_price = { -- Cost to repair 1% damage for each part (For example: if a part is 40% damaged, the cost to repair will be multiplied by 40)
	['engine'] = 150,
	['body'] = 75,
	['transmission'] = 100,
	['wheels'] = 50,
	['fuel'] = 10
}

--[[
	Experience required to reach each level
	Example:
	[1] = 100,
	[2] = 200,
	This indicates that to reach level 1, you need 100 EXP; to reach level 2, you need 200 EXP.
	Upon leveling up, the player receives 1 skill point.
	Level 30 represents the maximum achievable level.
]]
Config.required_xp_to_levelup = {
	[1] = 1000,
	[2] = 2000,
	[3] = 3000,
	[4] = 4000,
	[5] = 5000,
	[6] = 6000,
	[7] = 7000,
	[8] = 8000,
	[9] = 9000,
	[10] = 10000,
	[11] = 11000,
	[12] = 12000,
	[13] = 13000,
	[14] = 14000,
	[15] = 16000,
	[16] = 18000,
	[17] = 20000,
	[18] = 22000,
	[19] = 24000,
	[20] = 26000,
	[21] = 28000,
	[22] = 30000,
	[23] = 35000,
	[24] = 40000,
	[25] = 45000,
	[26] = 50000,
	[27] = 55000,
	[28] = 60000,
	[29] = 65000,
	[30] = 100000 -- Maximum
}

--[[
	Maximum loan amount available per level (loan size increases with higher levels)
	Example:
	[0] = 40000,
	[10] = 100000,
	[20] = 250000
	This indicates that from level 0 to level 10, players can take out a maximum loan of 40 000. From level 10 to 20, the maximum loan amount increases to 100 000...
]]
Config.max_loan_per_level = {
	[0] = 0,
	[10] =0,
	[20] =0,
	[30] =0
}

-- Loan amounts and daily interest charges
Config.loans = {
	['cooldown'] = 86400, -- Time (in seconds) before daily charges are applied (86400 = 24 hours)
	['amount'] = {
		--[[
		You can configure up to 4 loan options, each with its own settings.
		Example:
		[1] = {
			20000,  -- Loan amount: $20,000
			400,    -- Daily payment amount: This should be higher than the following amount; in this case, upon completing all payments, the player will pay $24,000 (including $4,000 in interest)
			200     -- Base amount for calculating interest: The difference between the above value and this (400 - 200) will be the interest amount, which is $200 per day
		},
		]]
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
	}
}

--[[
	Skill level and max travel distance at each level
	Example:
	[0] = 6,
	[1] = 6.5,
	This indicates that at level 0, players can take contracts with a maximum distance of 6 km. At level 1, they can take contracts with a maximum distance of 6.5 km.
	Level 6 represents the maximum skill level attainable.
]]
Config.distance_skill = {
	[0] = 6,
	[1] = 6.5,
	[2] = 7,
	[3] = 7.5,
	[4] = 8,
	[5] = 8.5,
	[6] = 99 -- Maximum
}

--[[
	EXP gain in %
	XP is calculated based on the distance of the delivery. For instance, if they drive 2km in one delivery and Config.exp_gain = 0.5, they will earn 10 XP
	This XP can be increased based on the bonuses configured below
]]
Config.exp_gain = 0.1

-- EXP bonuses and money each skill gives
Config.bonus = {
	-- This bonus will be applied according to the level and requirements of the load. Then, when transporting a fragile cargo, he will receive the fragile cargo bonus (these values ​​are in%)
	['distance'] = {
		['money_bonus_percentage'] = {
			[1] = 2,
			[2] = 4,
			[3] = 6,
			[4] = 8,
			[5] = 10,
			[6] = 12
		},
		['exp_bonus_percentage'] = {
			[1] = 5,
			[2] = 5,
			[3] = 5,
			[4] = 5,
			[5] = 5,
			[6] = 5
		}
	},
	['valuable'] = {
		['money_bonus_percentage'] = {
			[1] = 2,
			[2] = 4,
			[3] = 6,
			[4] = 8,
			[5] = 10,
			[6] = 12
		},
		['exp_bonus_percentage'] = {
			[1] = 10,
			[2] = 10,
			[3] = 10,
			[4] = 10,
			[5] = 10,
			[6] = 10
		}
	},
	['fragile'] = {
		['money_bonus_percentage'] = {
			[1] = 2,
			[2] = 4,
			[3] = 6,
			[4] = 8,
			[5] = 10,
			[6] = 12
		},
		['exp_bonus_percentage'] = {
			[1] = 10,
			[2] = 10,
			[3] = 10,
			[4] = 10,
			[5] = 10,
			[6] = 10
		}
	},
	['fast'] = {
		['money_bonus_percentage'] = {
			[1] = 2,
			[2] = 4,
			[3] = 6,
			[4] = 8,
			[5] = 10,
			[6] = 12
		},
		['exp_bonus_percentage'] = {
			[1] = 10,
			[2] = 10,
			[3] = 10,
			[4] = 10,
			[5] = 10,
			[6] = 10
		}
	}
}

Config.party = {
	['price_to_create'] = 5000,		-- Price to create a party
	['price_per_member'] = 1000, 	-- Cost of each additional member
	['max_members'] = 10,			-- Maximum number of members of each group
	['party_money_bonus'] = 5,		-- Bonus money (in %) that each party member receives upon completing a delivery
	['party_exp_bonus'] = 5,		-- Bonus xp (in %) that each party member receives when completing a delivery
	['only_leader_can_start'] = true-- true: Only the group leader can start a delivery | false: Any member can start a delivery
}

-- Cargo delivery locations (vector4)
Config.delivery_locations = {
	{-758.14,5540.96,33.49,110.53},
	{-3046.19,143.27,11.6,11.14},
	{-1153.01,2672.99,18.1,312.25},
	{622.67,110.27,92.59,340.75},
	{-574.62,-1147.27,22.18,177.7},
	{376.31,2638.97,44.5,286.38},
	{1738.32,3283.89,41.13,16.24},
	{1419.98,3618.63,34.91,195.33},
	{1452.67,6552.02,14.89,138.69},
	{3472.4,3681.97,33.79,76.44},
	{2485.73,4116.13,38.07,66.71},
	{65.02,6345.89,31.22,206.64},
	{-303.28,6118.17,31.5,135.24},
	{-63.41,-2015.25,18.02,299.48},
	{-46.35,-2112.38,16.71,290.84},
	{-746.6,-1496.67,5.01,28.08},
	{369.54,272.07,103.11,247.94},
	{907.61,-44.12,78.77,323.08},
	{-1517.31,-428.29,35.45,55.77},
	{235.04,-1520.18,29.15,316.76},
	{34.8,-1730.13,29.31,226.06},
	{350.4,-2466.9,6.4,169.38},
	{1213.97,-1229.01,35.35,270.74},
	{1395.7,-2061.38,52.0,135.81},
	{729.09,-2023.63,29.31,268.75},
	{840.72,-1952.59,28.85,81.46},
	{551.76,-1840.26,25.34,40.72},
	{723.78,-1372.08,26.29,106.65},
	{-339.92,-1284.25,31.32,89.06},
	{1137.23,-1285.05,34.6,189.65},
	{466.93,-1231.55,29.95,267.14},
	{442.28,-584.28,28.5,252.12},
	{1560.52,888.69,77.46,19.02},
	{2561.78,426.67,108.46,301.57},
	{569.21,2730.83,42.07,91.35},
	{2665.4,1700.63,24.49,269.33},
	{1120.1,2652.5,38.0,181.77},
	{2004.23,3071.87,47.06,237.58},
	{2038.78,3175.7,45.09,140.47},
	{1635.54,3562.84,35.23,296.61},
	{2744.55,3412.43,56.57,247.48},
	{1972.17,3839.16,32.0,304.36},
	{1980.59,3754.65,32.18,211.64},
	{1716.0,4706.41,42.69,91.44},
	{1691.36,4918.42,42.08,57.29},
	{1970.3,5177.39,47.83,318.89},
	{1908.78,4932.06,48.97,340.08},
	{140.79,-1077.85,29.2,262.4},
	{-323.98,-1522.86,27.55,258.59},
	{-1060.53,-221.7,37.84,299.01},
	{2471.47,4463.07,35.3,277.56},
	{2699.47,3444.81,55.8,153.49},
	{2651.19,3252.42,54.93,232.7},
	{2730.39,2778.2,36.01,134.51},
	{-2966.68,363.37,14.77,359.8},
	{2788.89,2816.49,41.72,296.22},
	{-604.45,-1212.24,14.95,227.43},
	{2534.83,2589.08,37.95,2.48},
	{-143.31,205.88,92.12,86.41},
	{2381.84,2594.34,46.66,192.86},
	{860.47,-896.87,25.53,181.8},
	{973.34,-1038.19,40.84,272.3},
	{-409.04,1200.44,325.65,164.59},
	{-1664.81,3076.59,31.23,229.86},
	{-71.8,-1089.98,26.56,339.06},
	{1246.34,1860.78,79.47,315.78},
	{-1777.63,3082.36,32.81,236.17},
	{-1775.87,3088.13,32.81,239.97},
	{-1827.5,2934.11,32.82,59.53},
	{-2123.69,3270.14,32.82,145.14},
	{-2444.59,2981.63,32.82,283.55},
	{-2448.59,2962.8,32.82,333.19},
	{-2277.86,3176.57,32.81,236.61},
	{-2969.0,366.46,14.77,292.99},
	{-1637.61,-814.53,10.17,139.15},
	{-1494.72,-891.67,10.11,73.06},
	{-902.27,-1528.42,5.03,106.23},
	{-1173.93,-1749.87,3.97,211.53},
	{-1087.8,-2047.55,13.23,314.93},
	{-1108.63,-2026.09,13.24,308.01},
	{-1828.58,-2823.35,13.95,155.0},
	{-1025.97,-2223.62,8.99,224.96},
	{850.42,2197.69,51.93,243.19},
	{42.61,2803.45,57.88,145.49},
	{-1193.54,-2155.4,13.2,138.82},
	{-1184.37,-2185.67,13.2,336.13},
	{2041.76,3172.26,44.98,155.2},
	{-477.44,-2166.87,9.59,121.48},
	{-3189.8,1078.75,20.85,154.85},
	{-433.69,-2277.29,7.61,268.97},
	{-395.18,-2182.97,10.29,94.54},
	{-3029.7,591.68,7.79,199.33},
	{-1007.29,-3021.72,13.95,65.31},
	{-61.32,-1832.75,26.8,227.87},
	{822.72,-2134.28,29.29,349.36},
	{942.22,-2487.76,28.34,89.41},
	{279.31,-2078.18,16.83,28.94},
	{783.08,-2523.98,20.51,5.67},
	{720.61,-2128.76,29.22,87.12},
	{787.05,-1612.38,31.17,48.33},
	{913.52,-1556.87,30.74,272.14},
	{777.64,-2529.46,20.13,96.09},
	{843.82,-2474.47,25.3,87.54},
	{711.79,-1395.19,26.35,103.31},
	{723.38,-1286.3,26.3,90.13},
	{983.0,-1230.77,25.38,121.4},
	{818.01,-2422.85,23.6,174.28},
	{885.53,-1166.38,24.99,94.77},
	{700.85,-1106.93,22.47,163.11},
	{882.26,-2384.1,28.0,179.16},
	{1003.55,-1860.27,30.89,268.33},
	{-1138.73,-759.77,18.87,234.36},
	{938.71,-1154.36,25.38,178.46},
	{973.0,-1156.18,25.43,267.36},
	{689.41,-963.48,23.49,178.61},
	{140.72,-375.29,43.26,336.19},
	{-497.09,-62.13,39.96,353.27},
	{-606.34,187.43,70.01,270.65},
	{117.12,-356.15,42.59,252.09},
	{53.91,-1571.07,29.47,137.1},
	{1528.1,1719.32,109.97,34.6},
	{1411.29,1060.33,114.34,269.14},
	{1145.76,-287.73,68.96,284.29},
	{-441.96,-1704.7,18.89,250.12},
	{874.28,-949.16,26.29,358.46},
	{829.28,-874.08,25.26,270.18},
	{725.37,-874.53,24.67,265.96},
	{693.66,-1090.43,22.45,174.62},
	{1210.33,-1076.89,39.96,304.44},
	{945.1,-1163.54,25.68,270.98},
	{911.7,-1258.04,25.58,33.69},
	{847.06,-1397.72,26.14,151.79},
	{852.32,-1393.03,26.14,151.28},
	{130.47,-1066.12,29.2,160.09},
	{-52.79,-1078.65,26.93,67.2},
	{-131.74,-1097.38,21.69,335.25},
	{-621.47,-1106.05,22.18,1.07},
	{-668.65,-1182.07,10.62,208.79},
	{-111.84,-956.71,27.27,339.83},
	{-1359.83,-1144.35,4.26,6.03},
	{-1190.55,-2057.76,14.33,4.39},
	{-1169.18,-1768.78,3.87,306.82},
	{-1343.38,-744.02,22.28,309.26},
	{-1532.84,-578.16,33.63,304.2},
	{-1461.4,-362.39,43.89,219.06},
	{-1457.25,-384.15,38.51,114.12},
	{-1544.42,-411.45,41.99,226.04},
	{-1432.72,-250.32,46.37,130.83},
	{-1040.24,-499.88,36.07,118.78},
	{346.43,-1107.19,29.41,177.11},
	{523.99,-2112.7,5.99,182.08},
	{977.19,-2539.34,28.31,353.75,357.42},
	{1101.01,-2405.39,30.76,259.61},
	{1591.9,-1714.0,88.16,120.75},
	{1693.41,-1497.45,113.05,66.92},
	{1029.44,-2501.31,28.43,149.34},
	{2492.55,-320.89,93.0,82.83},
	{2846.31,1463.1,24.56,74.93},
	{3631.05,3768.61,28.52,320.0},
	{3572.5,3665.53,33.9,75.93},
	{2919.03,4337.85,50.31,203.77},
	{2521.47,4203.47,39.95,327.93},
	{2926.2,4627.28,48.55,143.26},
	{3808.59,4463.22,4.37,87.61},
	{2802.35,4838.31,44.99,118.49},
	{2133.06,4789.57,40.98,26.62},
	{1900.83,4913.82,48.87,154.21},
	{381.06,3591.37,33.3,82.49},
	{642.8,3502.47,34.09,95.04},
	{277.33,2884.71,43.61,296.91},
	{-60.3,1961.45,190.19,294.86},
	{225.63,1244.33,225.46,194.24},
	{-513.24,5257.73,80.62,159.3},
	{-519.96,5243.84,79.95,72.76},
	{-602.87,5326.63,70.46,168.65},
	{-797.95,5400.61,34.24,86.78},
	{-776.0,5579.11,33.49,167.58},
	{-704.2,5772.55,17.34,68.44},
	{-299.24,6300.27,31.5,134.2},
	{402.52,6619.61,28.26,357.71},
	{-247.72,6205.46,31.49,45.5},
	{-326.49,6104.64,31.49,46.83},
	{-64.73,6553.21,31.5,41.71},
	{2204.73,5574.04,53.74,351.31},
	{1638.98,4840.41,42.03,185.92},
	{1961.26,4640.93,40.71,293.6},
	{1776.61,4584.67,37.65,181.45},
	{137.29,281.73,109.98,335.6},
	{607.49,165.2,98.24,341.06},
	{212.28,2789.95,45.66,276.37},
	{708.58,-295.1,59.19,277.93},
	{581.28,2799.43,42.1,1.52},
	{1296.73,1424.35,100.45,178.89},
	{955.85,-22.89,78.77,147.51}
}

Config.create_table = true				-- Keep this true please