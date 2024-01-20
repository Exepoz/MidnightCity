Config = {}
Config.CoordsWait = math.random(1,2) -- Time before you receive the house coords (1 - 2 minutes).
Config.Night = {12, 6} -- Players can rob only from 20:00 to 04:00, interiors doesn't look good with day light.
Config.Lockpick = true -- Use lockpick item for door?.
Config.LockpickName = 'lockpick' -- The lockpick item
Config.PoliceRaid = true -- Police can Raid houses?.
Config.PoliceJobName = 'police' -- Your Police job name.
Config.RandomPoliceCall = true -- Small chance to call cops when players uses the lockpick on door.
Config.PoliceRaidWithCommand = true -- Set false if you don't want a Police command to raid houses.
Config.PoliceRaidCommand = 'raid' -- Command por Police to raid the houses.
Config.CooldownTime = 20 -- minutes
Config.HighEndRepNeeded = 50
Config.Debug = false

Config.CopsNeeded = {
	['low'] = 0,
	['high'] = 0
}

Config.GroupSize = {
	['low'] = 2,
	['high'] = 4
}

Config.SafeChances = {
	['low'] = 30,
	['high'] = 70
}

Config.SpawnSafe = true -- Random chance to spawn a safe.

Config.RepGains = {
	doorUnlocked = 2.5,
}

Config.ItemsReward = {
    [1] = {item = "diamond_ring",                     	amt = {min = 1, max = 2}, probability = 1/15},
    [2] = {item = "pistol_ammo",            	amt = {min = 2, max = 5}, probability = 1/10},
    [3] = {item = "bandage",                 	amt = {min = 3, max = 6}, probability = 1/10},
    [4] = {item = "oxy",                     	amt = {min = 2, max = 3}, probability = 1/10},
    [5] = {item = "gratefuldead_tabs",        	amt = {min = 1, max = 4}, probability = 1/10},
    [6] = {item = "bong",                     	amt = {min = 1, max = 1}, probability = 1/10},
    [8] = {item = "tablet",                 	amt = {min = 1, max = 1}, probability = 1/15},
    [9] = {item = "joint",         		amt = {min = 5, max = 12}, probability = 1/10},
    [10] = {item = "shrooms",         	amt = {min = 3, max = 6}, probability = 1/10},
    [12] = {item = "10kgoldchain",             	amt = {min = 1, max = 1}, probability = 1/15},
    [13] = {item = "goldbar",            	amt = {min = 1, max = 1}, probability = 1/25},
    [14] = {item = "armor",                 	amt = {min = 1, max = 2}, probability = 1/8},
    [15] = {item = "heroin_ready",     	amt = {min = 2, max = 5}, probability = 1/7},
    [16] = {item = "lockpick",                 	amt = {min = 1, max = 5}, probability = 1/5},
    [17] = {item = "weapon_switchblade",     	amt = {min = 1, max = 1}, probability = 1/10},
   	[18] = {item = "cokebaggystagetwo",         	amt = {min = 4, max = 10}, probability = 1/10},
    [19] = {item = "cash",                     	amt = {min = 150, max = 600}, probability = 1/15},
    [20] = {item = "weapontint_mk2_14",            	amt = {min = 1, max = 1}, probability = 1/15},
    [21] = {item = "phone",         	amt = {min = 1, max = 1}, probability = 1/15},
    [22] = {item = "tab_paper",         	amt = {min = 1, max = 1}, probability = 1/13},
    [23] = {item = "samsungphone",             	amt = {min = 1, max = 1}, probability = 1/16},
    [24] = {item = "monitor",                	amt = {min = 1, max = 2}, probability = 1/10},
    [25] = {item = "rolex",                 	amt = {min = 1, max = 1}, probability = 1/10},
    [26] = {item = "laptop",                 	amt = {min = 1, max = 1}, probability = 1/10},
    [27] = {item = "captainskull",                 	amt = {min = 1, max = 1}, probability = 1/55},
    [28] = {item = "watch",                     	amt = {min = 1, max = 3}, probability = 1/5},
    [29] = {item = "xanax_prescription",                 	amt = {min = 1, max = 4}, probability = 1/5},
    [30] = {item = "vodka",                 	amt = {min = 1, max = 3}, probability = 1/5},
    [31] = {item = "toiletry",                	amt = {min = 1, max = 3}, probability = 1/5},
    [32] = {item = "toothpaste",             	amt = {min = 1, max = 2}, probability = 1/5},
    [33] = {item = "shoebox",                 	amt = {min = 1, max = 1}, probability = 1/5},
    [34] = {item = "dj_deck",                 	amt = {min = 1, max = 1}, probability = 1/10},
    [35] = {item = "earrings",                 	amt = {min = 1, max = 1}, probability = 1/5},
    [36] = {item = "console",                 	amt = {min = 1, max = 1}, probability = 1/5},
    [37] = {item = "hairdryer",             	amt = {min = 1, max = 1}, probability = 1/5},
    [38] = {item = "laptop",                 	amt = {min = 1, max = 1}, probability = 1/11},
    [39] = {item = "soap",                     	amt = {min = 1, max = 3}, probability = 1/5},
    [40] = {item = "whiskey",                	amt = {min = 2, max = 5}, probability = 1/5},
    [41] = {item = "iphone",                 	amt = {min = 1, max = 1}, probability = 1/5},
    [42] = {item = "cash",                     	amt = {min = 350, max = 900}, probability = 1/15},
    [43] = {item = "romantic_book",                     	amt = {min = 1, max = 3}, probability = 1/15},
    [44] = {item = "goldennugget",             	amt = {min = 1, max = 2},     probability = 1/35},
    [45] = {item = "burnerphone_wep",         	amt = {min = 1, max = 1}, probability = 1/50},
	[46] = {item = "notepad",                     	amt = {min = 350, max = 900}, probability = 1/15},
    [47] = {item = "telescope",                     	amt = {min = 1, max = 3}, probability = 1/15},
    [48] = {item = "pencil",             	amt = {min = 1, max = 2},     probability = 1/35},
    [49] = {item = "tapeplayer",         	amt = {min = 1, max = 1}, probability = 1/50},
	[50] = {item = "book",         	amt = {min = 1, max = 1}, probability = 1/50},
	[51] = {item = "skull",         	amt = {min = 1, max = 1}, probability = 1/50},
	

}

Config.Quests = {
	[1] = {item = 'microwave', amount = {1,2,3}},
	[2] = {item = 'tv', amount = {1}},
	[3] = {item = 'telescope', amount = {1,2,3}},
	[4] = {item = 'soap', amount = {3, 5}},
	[5] = {item = 'console', amount = {2, 3, 5}},
	[6] = {item = 'hairdryer', amount = {2, 3, 5}},
	[7] = {item = 'dj_deck', amount = {1, 3, 5}},
	[8] = {item = 'toothpaste', amount = {3, 5}},
	[9] = {item = 'shoebox', amount = {2, 3, 5}},
	[10] = {item = 'pencil', amount = {5, 7}},
	[11] = {item = 'book', amount = {3, 5, 7}},
	[12] = {item = 'laptop', amount = {2, 3, 5}},
	[13] = {item = 'monitor', amount = {2, 3, 5}},
	[14] = {item = 'tapeplayer', amount = {2, 3, 5}},
	[15] = {item = 'watch', amount = {2, 3, 5}},
	[16] = {item = 'romantic_book', amount = {3, 5, 7}},
	[17] = {item = 'skull', amount = {1, 3, 5}},
	[18] = {item = 'laptop', amount = {1}},
	[19] = {item = 'lootbag', amount = {1}},
	[20] = {item = 'coffeemaker', amount = {2,3,5}},
}

Config.CompletionRewards = {
	{t = 'item', r = 'advancedlockpick'},
	{t = 'item', r = 'advancedrepairkit'},
	{t = 'item', r = 'c4_bomb'},
	{t = 'item', r = 'weapon_bzgas'},
	{t = 'item', r = 'thermite'},
	{t = 'item', r = 'vpn'},
	{t = 'item', r = 'lime_hacking'},
	{t = 'xp', r = 4},
	{t = 'xp', r = 5},
	{t = 'xp', r = 6},
}

Config.Rep = {
	[1] = {rep = 10, desc = '15% Chance to find 1 extra loot per spot', 					loot = 15},
	[2] = {rep = 25, desc = 'Interactions are 25% faster', 									loot = 15, inter = 25},
	[3] = {rep = 45, desc = 'Better grip on the TV', 										loot = 15, inter = 25, tv = 3000},

	[4] = {rep = 70, desc = 'Nothing Interesting Happens.', 								loot = 15, inter = 25, tv = 3000},

	[5] = {rep = 100 , desc = 'Less Chance to call cops when picking the lock', 			loot = 15, inter = 25, tv = 3000, cop = 30},
	[6] = {rep = 135, desc = 'Chance to find 1 extra loot per spot increase to 35%', 		loot = 35, inter = 25, tv = 3000, cop = 30},
	[7] = {rep = 175, desc = 'Unlocked High End Houses', 									loot = 35, inter = 25, tv = 3000, cop = 30, he = true},

	[8] = {rep = 220, desc = 'Nothing Interesting Happens.', 								loot = 35, inter = 25, tv = 3000, cop = 30, he = true},

	[9] = {rep = 270 , desc = 'Interactions are 40% faster', 								loot = 35, inter = 40, tv = 3000, cop = 30, he = true},
	[10] = {rep = 325, desc = 'Even better grip on the TV', 								loot = 35, inter = 40, tv = 5000, cop = 30, he = true},
	[11] = {rep = 385, desc = 'Even less chance to call cops when picking the lock', 		loot = 35, inter = 40, tv = 5000, cop = 15, he = true},

	[12] = {rep = 450, desc = 'Nothing Interesting Happens.',				 				loot = 35, inter = 40, tv = 5000, cop = 15, he = true},
	[13] = {rep = 520, desc = 'Nothing Interesting Happens.', 								loot = 35, inter = 40, tv = 5000, cop = 15, he = true},

	[14] = {rep = 595, desc = 'Chance to open the safe automatically', 						loot = 35, inter = 40, tv = 5000, cop = 15, he = true, autoSafe = true},
	[15] = {rep = 675, desc = 'Chance to find 1 extra loot per spot increase to 70%', 		loot = 70, inter = 40, tv = 5000, cop = 15, he = true, autoSafe = true},
	[16] = {rep = 760, desc = 'Chance to double Bounty Reputation Rewards', 				loot = 70, inter = 40, tv = 5000, cop = 15, he = true, autoSafe = true, double = true},

	[17] = {rep = 850, desc = 'Nothing Interesting Happens.', 								loot = 70, inter = 40, tv = 5000, cop = 15, he = true, autoSafe = true, double = true},
	[18] = {rep = 945, desc = 'Never Drop the TV.', 										loot = 70, inter = 40, tv = 9999, cop = 15, he = true, autoSafe = true, double = true},
	[19] = {rep = 1045, desc = 'Nothing Interesting Happens.', 								loot = 70, inter = 40, tv = 9999, cop = 15, he = true, autoSafe = true, double = true},

	[20] = {rep = 1150, desc = 'Unlock Strong Lockpick', 									loot = 70, inter = 40, tv = 9999, cop = 15, he = true, autoSafe = true, double = true, lp = true},
}

Config.Lang = {
	['search'] = 'Press [E] to search',
	['enter'] = 'Press [G] to enter',
	['exit'] = 'Press [G] to exit',
	['getjob'] = 'Get a job',
	['waitcall'] = 'The crew will find you a house, wait for their call.',
	['jobwait'] = 'Alright we got a house.. You\'ll recieve the location shortly.',
	['assigned'] = 'Here\'s their place.. You should do it when it\'s dark outside to not attract attention...',
	['wait'] = 'Come on man, be patient!',
	['cooldown'] = 'I don\'t have anything for you right now.. Come back later.',
	['alarm'] = 'You\'ve triggered the alarm, RUN!!!!',
	['lockpick'] = 'The door is locked.',
	['wrong_veh'] = "You can't use this vehicle",
	['putinveh'] = '[E] Place in vehicle',
	['police_alert'] = 'A House is currently being Robbed!',
	['safe_left'] = '[E] Turn left ',
	['safe_right'] = ' [F] Turn right ',
	['safe_confirm'] = ' [G] Confirm',
	['money_found'] = 'You found $'
}

Config.Houses = { -- Houses entry and model
	['low'] = {
		{x = 31.492990493774, y = 6596.619140625, z = 32.81018447876, model = 'MidApt'},
		{x = 11.572845458984, y = 6578.3662109375, z = 33.060623168945, model = 'MidApt'},
		{x = -15.09232711792, y = 6557.7416992188, z = 33.240436553955, model = 'MidApt'},
		{x = -41.538372039795, y = 6637.4028320312, z = 31.08752822876, model = 'MidApt'},
		{x = -9.6467323303223, y = 6654.1987304688, z = 31.712518692017, model = 'MidApt'},
		{x = 1.7621871232986, y = 6612.5390625, z = 32.109931945801, model = 'MidApt'},
		{x = -26.635080337524, y = 6597.27734375, z = 31.860597610474, model = 'MidApt'},
		{x = 35.366596221924, y = 6662.84765625, z = 32.190341949463, model = 'MidApt'},
		{x = -356.76190185547, y = 6207.3330078125, z = 31.91400718689, model = 'MidApt'},
		{x = -374.45736694336, y = 6191.0849609375, z = 31.72954750061, model = 'MidApt'},
		{x = -245.86965942383, y = 6414.3569335938, z = 31.460599899292, model = 'MidApt'},
		{x = 495.17916870117, y = -1823.2989501953, z = 28.869707107544, model = 'MidApt'},
		{x = 489.60406494141, y = -1714.0977783203, z = 29.706550598145, model = 'MidApt'},
		{x = 500.58831787109, y = -1697.1359863281, z = 29.787733078003, model = 'MidApt'},
		{x = 419.07574462891, y = -1735.4970703125, z = 29.607694625854, model = 'MidApt'},
		{x = 431.14743041992, y = -1725.3588867188, z = 29.601457595825, model = 'MidApt'},
		{x = 443.34533691406, y = -1707.3347167969, z = 29.70036315918, model = 'MidApt'},
		{x = 368.80645751953, y = -1895.8767089844, z = 25.178525924683, model = 'MidApt'},
		{x = 385.10110473633, y = -1881.580078125, z = 26.031482696533, model = 'MidApt'},
		{x = 399.43417358398, y = -1865.1263427734, z = 26.715923309326, model = 'MidApt'},
		{x = 412.32699584961, y = -1856.2395019531, z = 27.323152542114, model = 'MidApt'},
		{x = 427.44403076172, y = -1842.3278808594, z = 28.462642669678, model = 'MidApt'},
		{x = 312.01104736328, y = -1956.1602783203, z = 24.625070571899, model = 'MidApt'},
		{x = 324.36328125, y = -1937.5997314453, z = 25.018976211548, model = 'MidApt'},
		{x = 295.92004394531, y = -1971.8889160156, z = 22.80372428894, model = 'MidApt'},
		{x = 291.58758544922, y = -1980.515625, z = 21.600521087646, model = 'MidApt'},
		{x = 279.71060180664, y = -1993.9146728516, z = 20.805452346802, model = 'MidApt'},
		{x = 256.4538269043, y = -2023.3701171875, z = 19.266801834106, model = 'MidApt'},
		{x = 236.01176452637, y = -2046.3182373047, z = 18.379932403564, model = 'MidApt'},
		{x = 148.76959228516, y = -1904.4891357422, z = 23.517498016357, model = 'MidApt'},
		{x = 128.07450866699, y = -1897.0458984375, z = 23.674228668213, model = 'MidApt'},
		{x = 115.33438110352, y = -1887.7604980469, z = 23.927993774414, model = 'MidApt'},
		{x = 103.993019104, y = -1885.2415771484, z = 24.304039001465, model = 'MidApt'},

		{x = -1049.10, y = -1581.06, z = 4.98, model = 'MidApt'}, --vespucci
		{x = -1029.77, y = -1504.26, z = 4.90, model = 'MidApt'}, --vespucci
		{x = -957.80,  y = -1420.01, z = 7.68, model = 'MidApt'}, --vespucci
		{x = -1030.03, y = -1604.29, z = 4.96, model = 'MidApt'}, --vespucci
		{x = -1078.76, y = -1616.39, z = 4.43, model = 'MidApt'}, --vespucci
		{x = -1306.39, y = -1226.58, z = 8.98, model = 'MidApt'}, --vespucci 2nd story 8215 may have issues
		{x = -1135.49, y = -1153.35, z = 2.74, model = 'MidApt'}, --vespucci canals may cause issues
		{x = -1111.50, y = -902.13,  z = 3.79, model = 'MidApt'}, --vespucci canals may cause issues
		{x = -1791.21, y = -683.01,  z = 10.64,model = 'MidApt'}, --vespucci
		{x = -1473.64, y = -645.92,  z = 29.58,model = 'MidApt'}, --delperro
		{x = -1706.84, y = -453.34,  z = 42.65,model = 'MidApt'}, --delperro
		{x = -1788.58, y = -403.04,  z = 46.47,model = 'MidApt'}, --delperro
		{x = -102.26,  y =  2.18,    z = 70.43,model = 'MidApt'}, --spanishave
		{x = -22.41,   y = -21.23,   z = 69.00,model = 'MidApt'}, --spanishave
		{x = -412.00,  y =  152.86,  z = 65.53,model = 'MidApt'}, --spanishave
		{x = -422.13,  y =  71.78,   z = 64.26,model = 'MidApt'}, --spanishave
		{x =  113.36,  y = -277.79,  z = 46.33,model = 'MidApt'}, --spanishave
		{x = -360.46,  y =  20.96,   z = 47.86,model = 'MidApt'}, --spanishave
	},
	['high'] = {
		{x = 216.33517456055, y = 620.27862548828, z = 187.75686645508, model = 'HighEnd'},
		{x = -912.25305175781, y = 777.16571044922, z = 187.01055908203, model = 'HighEnd'},
		{x = -762.17169189453, y = 430.80480957031, z = 100.17984771729, model = 'HighEnd'},
		{x = -679.01800537109, y = 512.04656982422, z = 113.52597808838, model = 'HighEnd'},
		{x = -640.71325683594, y = 520.20758056641, z = 110.06629943848, model = 'HighEnd'},
		{x = -595.52197265625, y = 530.25726318359, z = 108.06629943848, model = 'HighEnd'},
		{x = -526.93499755859, y = 517.22058105469, z = 113.1662979126, model = 'HighEnd'},
		{x = -459.220703125, y = 536.86401367188, z = 121.36630249023, model = 'HighEnd'},
		{x = -417.94924926758, y = 569.06427001953, z = 125.1662979126, model = 'HighEnd'},
		{x = -311.78060913086, y = 474.95440673828, z = 111.96630096436, model = 'HighEnd'},
		{x = -304.98672485352, y = 431.05224609375, z = 110.6662979126, model = 'HighEnd'},
		{x = -72.793998718262, y = 428.53192138672, z = 113.36630249023, model = 'HighEnd'},
		{x = -66.838043212891, y = 490.05136108398, z = 144.86483764648, model = 'HighEnd'},
		{x = -110.07062530518, y = 501.92742919922, z = 143.45491027832, model = 'HighEnd'},
		{x = -174.52659606934, y = 502.4521484375, z = 137.42042541504, model = 'HighEnd'},
		{x = -230.21437072754, y = 487.83517456055, z = 128.76806640625, model = 'HighEnd'},
		{x = -907.65112304688, y = 544.91998291016, z = 100.36024475098, model = 'HighEnd'},
		{x = -904.60345458984, y = 588.14251708984, z = 101.12745666504, model = 'HighEnd'},
		{x = -974.55877685547, y = 581.84942626953, z = 103.14652252197, model = 'HighEnd'},
		{x = -1022.719909668, y = 586.90777587891, z = 103.4294052124, model = 'HighEnd'},
		{x = -1107.4542236328, y = 594.22204589844, z = 104.45043945312, model = 'HighEnd'},
		{x = -1125.4201660156, y = 548.62109375, z = 102.56945037842, model = 'HighEnd'},
		{x = -1146.5546875, y = 545.87408447266, z = 101.89562988281, model = 'HighEnd'},
		{x = -595.67047119141, y = 393.24130249023, z = 101.88217926025, model = 'HighEnd'},
		{x = 84.95435333252, y = 561.70123291016, z = 182.73361206055, model = 'HighEnd'},
		{x = 232.20700073242, y = 672.14221191406, z = 189.97434997559, model = 'HighEnd'},
	},
}