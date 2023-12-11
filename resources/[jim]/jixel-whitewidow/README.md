# Jixel-WhiteWidow

Thank you for your purchase <3 I hope you have fun with this script and that it brings jobs and RP to your server

If you need support I now have a discord available, it helps me keep track of issues and give better support.

https://discord.gg/jixelpatterns

-------------------------------------------------------------------------------------------------

# INSTALLATION

## Inventory Images

Add the item images to your inventory script

`[qb]` > `qb-inventory` > `html` > `images`

## Items.lua

If you'd like one of the items to make the person hungry add effect to items below on joints, edibles, or bud ['hunger'] = math.random(-10, -20) or -123

Under the QBShared.Items = {

		-- whitewidow
	-- Tools
	['trimmers'] 			    	= {['name'] = 'trimmers', 		        		['label'] = 'Trimming Shears', 			['weight'] = 200, 		['type'] = 'item', 		['image'] = 'ww_shears.png', 			['unique'] = false,    	['useable'] = true, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'High quality trimming shears.'},
	['grinder'] 			    	= {['name'] = 'grinder', 		        		['label'] = 'Grinder', 		    		['weight'] = 100, 		['type'] = 'item', 		['image'] = 'ww_grinder.png', 			['unique'] = false,    	['useable'] = true, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'A Grinder'},
	['rollingpapers'] 				= {['name'] = 'rollingpapers', 					['label'] = 'Rolling Papers', 			['weight'] = 50, 		['type'] = 'item', 		['image'] = 'ww_rollingpapers.png', 	['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'Roll em up'},
	['lighter'] 			 		= {['name'] = 'lighter', 						['label'] = 'Lighter', 					['weight'] = 100, 		['type'] = 'item', 		['image'] = 'ww_lighter.png', 			['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'Please dont light anything on fire'},
	['emptybaggy'] 					= {['name'] = 'emptybaggy', 			    	['label'] = 'Resealable Bag', 			['weight'] = 1, 		['type'] = 'item', 		['image'] = 'ww_baggie.png', 			['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'A small empty bag'},
	['gummymould'] 					= {['name'] = 'gummymould', 			    	['label'] = 'Gummy Mould', 				['weight'] = 100, 		['type'] = 'item', 		['image'] = 'ww_gummymould.png', 		['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'A mould for candy making'},

	-- Edible Ingredients
	['gelatine'] 					= {['name'] = 'gelatine', 			    		['label'] = 'Gelatine', 			['weight'] = 100, 		['type'] = 'item', 		['image'] = 'ww_gelatine.png', 					['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'You could make some jello out of this'},
	['cereal'] 						= {['name'] = 'cereal', 			    		['label'] = 'Cereal', 				['weight'] = 100, 		['type'] = 'item', 		['image'] = 'ww_cereal.png', 					['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'Yum! Cereal'},
	['cannabutter'] 				= {['name'] = 'cannabutter', 			    	['label'] = 'Cannabutter', 			['weight'] = 100, 		['type'] = 'item', 		['image'] = 'ww_cannabutter.png', 				['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'This butter sure do smell funny'},
	['butter']						= {['name'] = 'butter', 			    		['label'] = 'Butter', 				['weight'] = 100, 		['type'] = 'item', 		['image'] = 'ww_butter.png', 					['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'Butter full of carbs'},
	['sugar']						= {['name'] = 'sugar', 			    			['label'] = 'Sugar', 				['weight'] = 100, 		['type'] = 'item', 		['image'] = 'ww_sugar.png', 					['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'Sweeter than you'},
	['flour']						= {['name'] = 'flour', 			    			['label'] = 'Flour', 				['weight'] = 100, 		['type'] = 'item', 		['image'] = 'ww_flour.png', 					['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'Butter full of carbs'},
	['egg']							= {['name'] = 'egg', 			    			['label'] = 'Egg', 					['weight'] = 100, 		['type'] = 'item', 		['image'] = 'ww_egg.png', 					['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'Sweeter than you'},
	['milk']						= {['name'] = 'milk', 			    			['label'] = 'Milk', 				['weight'] = 100, 		['type'] = 'item', 		['image'] = 'ww_milk.png', 					['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'Sweeter than you'},
	['peanutbutter']				= {['name'] = 'peanutbutter', 			    	['label'] = 'Peanut Butter', 			['weight'] = 100, 		['type'] = 'item', 		['image'] = 'ww_peanutbutter.png', 					['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'Creamy Goodness'},
	['chocolatechips']				= {['name'] = 'chocolatechips', 			    ['label'] = 'Chocolate Chips', 			['weight'] = 100, 		['type'] = 'item', 		['image'] = 'ww_chocolatechips.png', 					['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'Creamy Goodness'},

	-- Crops
	['afghankush_crop'] 	 	= {['name'] = 'afghankush_crop', 		['label'] = 'Afghan Crop', 			['weight'] = 1200, 		['type'] = 'item', 		['image'] = 'ww_afghankush_crop.png', 		['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'Afghan Kush Crop'},
	['bluedream_crop'] 	 		= {['name'] = 'bluedream_crop', 		['label'] = 'Blue Dream Crop', 		['weight'] = 1200, 		['type'] = 'item', 		['image'] = 'ww_bluedream_crop.png', 		['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'Blue Dream Crop'},
	['granddaddypurple_crop'] 	= {['name'] = 'granddaddypurple_crop',  	['label'] = 'Grand Daddy Purple Crop', 	['weight'] = 1200, 	['type'] = 'item', 		['image'] = 'ww_granddaddypurple_crop.png', 		['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'Grand Daddy Purple Crop'},
	['greencrack_crop'] 		= {['name'] = 'greencrack_crop', 	    ['label'] = 'Green Crack Crop', 	['weight'] = 1200, 		['type'] = 'item', 		['image'] = 'ww_greencrack_crop.png', 		['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'Green Crack Crop'},
	['jackherrer_crop'] 			= {['name'] = 'jackherrer_crop',  		['label'] = 'Jack Herer Crop', 		['weight'] = 1200, 		['type'] = 'item', 		['image'] = 'ww_jackherrer_crop.png', 		['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'Jack Herrer Crop'},
	['sourdiesel_crop'] 		= {['name'] = 'sourdiesel_crop', 	    ['label'] = 'Sour Diesel Crop', 	['weight'] = 1200, 		['type'] = 'item', 		['image'] = 'ww_sourdiesel_crop.png', 		['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'Sour Diesel Crop'},
	['weddingcake_crop'] 		= {['name'] = 'weddingcake_crop',  		['label'] = 'Wedding Cake Crop', 	['weight'] = 1200, 		['type'] = 'item', 		['image'] = 'ww_weddingcake_crop.png', 		['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'Wedding Cake Crop'},
	['whitewidow_crop'] 		= {['name'] = 'whitewidow_crop',  		['label'] = 'White Widow Crop', 	['weight'] = 1200, 		['type'] = 'item', 		['image'] = 'ww_whitewidow_crop.png', 		['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'White Widow Crop'},

	-- Bud
	['afghankush_bud'] 			= {['name'] = 'afghankush_bud', 					['label'] = 'Afghan Kush Bud', 			['weight'] = 2, 		['type'] = 'item', 		['image'] = 'ww_afghankush_bud.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'Afghan Kush Bud'},
	['bluedream_bud'] 		 	= {['name'] = 'bluedream_bud', 						['label'] = 'Blue Dream Bud', 			['weight'] = 2, 		['type'] = 'item', 		['image'] = 'ww_bluedream_bud.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'Blue Dream Bud'},
	['granddaddypurple_bud'] 	= {['name'] = 'granddaddypurple_bud', 	    		['label'] = 'Grand Daddy Purple Bud', 	['weight'] = 2, 		['type'] = 'item', 		['image'] = 'ww_granddaddypurple_bud.png', 		['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'Grand Daddy Purple Bud'},
	['greencrack_bud'] 			= {['name'] = 'greencrack_bud', 					['label'] = 'Green Crack Bud', 			['weight'] = 2, 		['type'] = 'item', 		['image'] = 'ww_greencrack_bud.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'Green Crack Bud'},
	['jackherrer_bud'] 			= {['name'] = 'jackherrer_bud',  					['label'] = 'Jack Herrer Bud', 			['weight'] = 2, 		['type'] = 'item', 		['image'] = 'ww_jackherrer_bud.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'Jack Herrer Bud'},
	['sourdiesel_bud'] 			= {['name'] = 'sourdiesel_bud', 	    			['label'] = 'Sour Diesel Bud', 			['weight'] = 2, 		['type'] = 'item', 		['image'] = 'ww_sourdiesel_bud.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'Sour Diesel Bud'},
	['weddingcake_bud'] 		= {['name'] = 'weddingcake_bud',  					['label'] = 'Wedding Cake Bud', 		['weight'] = 2, 		['type'] = 'item', 		['image'] = 'ww_weddingcake_bud.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'Wedding Cake Bud'},
	['whitewidow_bud'] 			= {['name'] = 'whitewidow_bud',  					['label'] = 'White Widow Bud', 			['weight'] = 2, 		['type'] = 'item', 		['image'] = 'ww_whitewidow_bud.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'White Widow Bud'},

	-- Joints
	['afghankush_joint'] 			= {['name'] = 'afghankush_joint', 			['label'] = 'Afghan Kush Joint', 			['weight'] = 2, 		['type'] = 'item', 		['image'] = 'ww_afghankush_joint.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'Afghan Kush Joint'},
	['bluedream_joint'] 		 	= {['name'] = 'bluedream_joint', 			['label'] = 'Blue Dream Joint', 			['weight'] = 2, 		['type'] = 'item', 		['image'] = 'ww_bluedream_joint.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'Grand Daddy Purple Joint'},
	['granddaddypurple_joint'] 	 	= {['name'] = 'granddaddypurple_joint', 	['label'] = 'Grand Daddy Purple Joint', 	['weight'] = 2, 		['type'] = 'item', 		['image'] = 'ww_granddaddypurple_joint.png', 	['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'Grand Daddy Purple Joint'},
	['greencrack_joint'] 			= {['name'] = 'greencrack_joint', 			['label'] = 'Green Crack Joint', 			['weight'] = 2, 		['type'] = 'item', 		['image'] = 'ww_greencrack_joint.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'Green Crack Joint'},
	['jackherrer_joint'] 			= {['name'] = 'jackherrer_joint',  			['label'] = 'Jack Herrer Joint', 			['weight'] = 2, 		['type'] = 'item', 		['image'] = 'ww_jackherrer_joint.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'Jack Herrer Joint'},
	['sourdiesel_joint'] 			= {['name'] = 'sourdiesel_joint', 	    	['label'] = 'Sour Diesel Joint', 			['weight'] = 2, 		['type'] = 'item', 		['image'] = 'ww_sourdiesel_joint.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'Sour Diesel Joint'},
	['weddingcake_joint'] 			= {['name'] = 'weddingcake_joint',  		['label'] = 'Wedding Cake Joint', 			['weight'] = 2, 		['type'] = 'item', 		['image'] = 'ww_weddingcake_joint.png', 		['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'Wedding Cake Joint'},
	['whitewidow_joint'] 			= {['name'] = 'whitewidow_joint',  			['label'] = 'White Widow Joint', 			['weight'] = 2, 		['type'] = 'item', 		['image'] = 'ww_whitewidow_joint.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   		['combinable'] = nil,   ['description'] = 'White Widow Joint'},

	-- Edibles
	['gummy_rasberry'] 				= {['name'] = 'gummy_rasberry', 			    ['label'] = 'Rasberry Kush Gummy', 			['weight'] = 4, 		['type'] = 'item', 		['image'] = 'ww_rasberrygummies.png', 				['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'A Rashberry Kush Gummy - Not Safe for Kids!'},
	['gummy_blueberry'] 			= {['name'] = 'gummy_blueberry', 			    ['label'] = 'Blue Dream Gummy', 			['weight'] = 4, 		['type'] = 'item', 		['image'] = 'ww_blueberrygummies.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'A hazy Blue Dream Gummy'},
	['gummy_grape'] 				= {['name'] = 'gummy_grape', 					['label'] = 'Grand Daddy Purp Gummy', 		['weight'] = 4, 		['type'] = 'item', 		['image'] = 'ww_grapegummies.png', 		['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'Grand Daddy of Gummies'},
	['gummy_applering'] 			= {['name'] = 'gummy_applering', 				['label'] = 'Green Crack Gummy', 			['weight'] = 4, 		['type'] = 'item', 		['image'] = 'ww_greenapplegummies.png', 		['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'There is no Crack in this Gummy stop asking'},
	['edible_ricecrispy'] 			= {['name'] = 'edible_ricecrispy', 			    ['label'] = 'Buddy Crocker Crispy', 		['weight'] = 4, 		['type'] = 'item', 		['image'] = 'ww_crispytreat.png', 				['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'Buddy Crockers Homemade Goods'},
	['gummy_belt'] 					= {['name'] = 'gummy_belt', 			    	['label'] = 'Herrer Belts', 				['weight'] = 4, 		['type'] = 'item', 		['image'] = 'ww_rainbowbelts.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'Sour Belts with a Twist'},
	['edible_snickerdoodle'] 		= {['name'] = 'edible_snickerdoodle', 			['label'] = 'Buddy Crocker Doodle', 		['weight'] = 4, 		['type'] = 'item', 		['image'] = 'ww_snickerdoodle.png', 		['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'Buddy Crockers Homemade Goods'},
	['edible_peanutcookie'] 		= {['name'] = 'edible_peanutcookie', 			['label'] = 'Buddy Peanutbutter Cookie',	['weight'] = 4, 		['type'] = 'item', 		['image'] = 'ww_peanutbuttercookie.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'Buddy Crockers Homemade Goods'},
	['edible_cchip'] 				= {['name'] = 'edible_cchip', 					['label'] = 'Buddy Crocker Chip', 			['weight'] = 4, 		['type'] = 'item', 		['image'] = 'ww_chocochip.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'Buddy Crockers Homemade Goods'},
	['bong'] 						= {['name'] = 'bong', 					['label'] = 'Bong', 			['weight'] = 4, 		['type'] = 'item', 		['image'] = 'ww_bong.png', 			['unique'] = true, 	['useable'] = true, 	['shouldClose'] = true,	   		['combinable'] = nil,   ['description'] = 'This is a bong'},


# Jobs
Under the QBShared.Jobs = {

	['whitewidow'] = {
		label = 'White Widow',
		defaultDuty = true,
		grades = {
            ['0'] = { name = 'Recruit', payment = 50 },
			['1'] = { name = 'Novice', payment = 75 },
			['2'] = { name = 'Experienced', payment = 100 },
			['3'] = { name = 'Advanced', payment = 125 },
			['4'] = { name = 'Manager', isboss = true, payment = 150 },
			['5'] = { name = 'Owner', isboss = true, payment = 150 },
        },
	},
	['bestbuds'] = {
		label = 'Best Buds',
		defaultDuty = true,
		grades = {
            ['0'] = { name = 'Recruit', payment = 50 },
			['1'] = { name = 'Novice', payment = 75 },
			['2'] = { name = 'Experienced', payment = 100 },
			['3'] = { name = 'Advanced', payment = 125 },
			['4'] = { name = 'Manager', isboss = true, payment = 150 },
			['5'] = { name = 'Owner', isboss = true, payment = 150 },
        },
	},
		['weedclinic'] = {
		label = 'Weed Clinic',
		defaultDuty = true,
		grades = {
            ['0'] = { name = 'Recruit', payment = 50 },
			['1'] = { name = 'Novice', payment = 75 },
			['2'] = { name = 'Experienced', payment = 100 },
			['3'] = { name = 'Advanced', payment = 125 },
			['4'] = { name = 'Manager', isboss = true, payment = 150 },
			['5'] = { name = 'Owner', isboss = true, payment = 150 },
        },
	},

# Payment Systems
	The payment system that is being used is my free script, jim-payments

	This system supports receipts being handed out to wokers who are clocked in and working
	They can then trade this in at the bank for rewards

	Grab it at: https://github.com/jimathy/jim-payments

# QB-Management:

	Update to the latest github version
	Make sure the job "whitewidow" has been added to the database
	The menu's targets should be accessible to bosses at clockin areas

# Jim-Consuambles item setup
- In Jixel-WhiteWidow `config.lua` set `JimConsumables` to true
- Add the emotes above to Jim-Consumables `config.lua` under the `Emotes = {` section
- Add these lines to Jim-Consumables `config.lua` under the `Consumables = {` section
- Restart your server

		["afghankush_joint"] = {	emote = "joint",	time = math.random(5000, 6000), stress = math.random(1, 24), heal = 20, armor = 10, type = "drug", stats = { screen = "weed", effect = "armor", widepupils = false, canOD = false } },
		["bluedream_joint"] = { 	emote = "joint",	time = math.random(5000, 6000), stress = math.random(1, 10), heal = 0, armor = 10, type = "drug", stats = { screen = "weed", effect = "armor", widepupils = false, canOD = false } },
		["granddaddypurple_joint"] = { emote = "joint",	time = math.random(5000, 6000), stress = math.random(1, 10), heal = 0, armor = 10, type = "drug", stats = { screen = "weed", effect = "armor", widepupils = false, canOD = false } },
		["greencrack_joint"] = { 	emote = "joint",	time = math.random(5000, 6000), stress = math.random(1, 10), heal = math.random(1, 10), armor = 10, type = "drug", stats = { screen = "weed", effect = "armor", widepupils = false, canOD = false } },
		["jackherrer_joint"] = { 	emote = "joint",	time = math.random(5000, 6000), stress = math.random(1, 10), heal = 0, armor = 10, type = "drug", stats = { screen = "weed", effect = "armor", widepupils = false, canOD = false } },
		["sourdiesel_joint"] = { 	emote = "joint",	time = math.random(5000, 6000), stress = math.random(1, 10), heal = 0, armor = 10, type = "drug", stats = { screen = "weed", effect = "armor", widepupils = false, canOD = false } },
		["weddingcake_joint"] = { 	emote = "joint",	time = math.random(5000, 6000), stress = math.random(1, 10), heal = 0, armor = 10, type = "drug", stats = { screen = "weed", effect = "armor", widepupils = false, canOD = false } },
		["whitewidow_joint"] = { 	emote = "joint",	time = math.random(5000, 6000), stress = math.random(1, 10), stamina = 10, heal = 0, armor = 10, type = "drug", stats = { screen = "weed", effect = "armor", widepupils = false, canOD = false } },

		["gummy_rasberry"] = {		emote = "oxy",	time = math.random(5000, 6000), stress = math.random(1, 24), heal = 20, armor = 10, type = "drug", stats = { screen = "weed", effect = "armor", widepupils = false, canOD = false } },
		["gummy_blueberry"] = {		emote = "oxy",	time = math.random(5000, 6000), stress = math.random(1, 10), heal = 0, armor = 10, type = "drug", stats = { screen = "weed", effect = "armor", widepupils = false, canOD = false } },
		["gummy_grape"] = {			emote = "oxy",	time = math.random(5000, 6000), stress = math.random(1, 10), heal = 0, armor = 10, type = "drug", stats = { screen = "weed", effect = "armor", widepupils = false, canOD = false } },
		["gummy_applering"] = {		emote = "oxy",	time = math.random(5000, 6000), stress = math.random(1, 10), heal = math.random(1, 10), armor = 10, type = "drug", stats = { screen = "weed", effect = "armor", widepupils = false, canOD = false } },
		["edible_ricecrispy"] = {	emote = "oxy",	time = math.random(5000, 6000), stress = math.random(1, 10), heal = 0, armor = 10, type = "drug", stats = { screen = "weed", effect = "armor", widepupils = false, canOD = false } },
		["gummy_belt"] = {			emote = "oxy",	time = math.random(5000, 6000), stress = math.random(1, 10), heal = 0, armor = 10, type = "drug", stats = { screen = "weed", effect = "armor", widepupils = false, canOD = false } },
		["edible_snickerdoodle"] = {	emote = "oxy",	time = math.random(5000, 6000), stress = math.random(1, 10), heal = 0, armor = 10, type = "drug", stats = { screen = "weed", effect = "armor", widepupils = false, canOD = false } },
		["edible_peanutcookie"] = {	emote = "oxy",	time = math.random(5000, 6000), stress = math.random(1, 10), stamina = 10, heal = 0, armor = 10, type = "drug", stats = { screen = "weed", effect = "armor", widepupils = false, canOD = false } },
		["edible_cchip"] = {	emote = "oxy",	time = math.random(5000, 6000), stress = math.random(1, 10), stamina = 10, heal = 0, armor = 10, type = "drug", stats = { screen = "weed", effect = "armor", widepupils = false, canOD = false } },


This part goes in the Emotes part of the `Jim-Consumables` Config.lua



	["joint"] = {"timetable@gardener@smoking_joint", "smoke_idle", "Drug", AnimationOptions =
		{ Prop = "prop_sh_joint_01", PropBone = 57005, PropPlacement = {0.12, 0.03, -0.05, 240.0, -60.0},
			EmoteMoving = true, EmoteLoop = true, }},


--------------------------------------------------------------------------------------------------

If you wish to add a Job Required Personal Garage to the side of the building, add this under JobGarages = {

	["whitewidow"] = {
        label = "WhiteWidow",
        takeVehicle = vector3(-312.72, 6270.2, 31.49),
        spawnPoint = vector4(-315.29, 6272.87, 31.21, 135.33),
        putVehicle = vector3(-315.29, 6272.87, 31.21),
        job = "whitewidow"
    },

---------------------------------------------------------------------------------------------------

## Changelog

### v1.1
	- Fix for `ox_target` job garage spawning car in the wrong place
	- Multiple MLO/Location support at the same time
	- Bestbuds MLO support:
		- Fixed ox_target support
		- Added ox_inventory support
	- Jen Creations White Widow MLO Support:
		- Added ox_inventory support
		- Added ox_target support
	- TheSupreme WeedShop v2 Support
		- Added ox_inventory support
		- Added ox_target support
	- Locations that require "trimmers" now won't show if you don't have any trimmers on you
	- `Config.MultiCraft`
		- If you want to show extra crafting options
		- Such as Craft x1, Craft x5, Craft x10, Craft All
	- `Config.TrimmerRemove`
		- Enabling this, the trimmers are used up each recipe
	- Fixed some spelling errors

### v1.0
	- Initial Release