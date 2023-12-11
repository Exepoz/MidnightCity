Thank you for your purchase <3 I hope you have fun with this script and that it brings jobs and RP to your server

If you need support I now have a discord available, it helps me keep track of issues and give better support.

https://discord.gg/xKgQZ6wZvS

-------------------------------------------------------------------------------------------------

# INSTALLATION

Add the item images to your inventory script

`[qb]` > `qb-inventory` > `html` > `images`

THESE GO IN YOUR SHARED .LUA IN qb-core:

Under the QBShared.Items

	--Jim-Popsdiner
	["baconeggs"] 					= {["name"] = "baconeggs",  	    		["label"] = "Bacon and Eggs",			["weight"] = 100, 		["type"] = "item", 		["image"] = "baconeggs.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["bltsandwich"] 				= {["name"] = "bltsandwich",  	    		["label"] = "BLT Sandwich",				["weight"] = 100, 		["type"] = "item", 		["image"] = "bltsandwich.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["cheeseburger"] 				= {["name"] = "cheeseburger",  	    		["label"] = "Cheese Burger",			["weight"] = 100, 		["type"] = "item", 		["image"] = "cheeseburger.png", 	["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["cheesesandwich"] 				= {["name"] = "cheesesandwich",  	    	["label"] = "Cheese Sandwich",			["weight"] = 100, 		["type"] = "item", 		["image"] = "cheesesandwich.png", 	["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["eggsandwich"] 				= {["name"] = "eggsandwich",  	    		["label"] = "Eggs Sandwich",			["weight"] = 100, 		["type"] = "item", 		["image"] = "eggsandwich.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["grilledwrap"] 				= {["name"] = "grilledwrap",  	    		["label"] = "Grilled Wrap",				["weight"] = 100, 		["type"] = "item", 		["image"] = "grilledwrap.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["hamburger"] 					= {["name"] = "hamburger",  	    		["label"] = "Hamburger",				["weight"] = 100, 		["type"] = "item", 		["image"] = "hamburger.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["hamcheesesandwich"] 			= {["name"] = "hamcheesesandwich",  	    ["label"] = "Ham and Cheese Sandwich",	["weight"] = 100, 		["type"] = "item", 		["image"] = "hamcheesesandwich.png",["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["hamsandwich"] 				= {["name"] = "hamsandwich",  	    		["label"] = "Ham Sandwich",				["weight"] = 100, 		["type"] = "item", 		["image"] = "hamsandwich.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["ranchwrap"] 					= {["name"] = "ranchwrap",  	    		["label"] = "Ranch Wrap",				["weight"] = 100, 		["type"] = "item", 		["image"] = "ranchwrap.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["sausageeggs"] 				= {["name"] = "sausageeggs",  	    		["label"] = "Sausage and Eggs",			["weight"] = 100, 		["type"] = "item", 		["image"] = "sausageeggs.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["steakburger"] 				= {["name"] = "steakburger",  	    		["label"] = "Steak Burger",				["weight"] = 100, 		["type"] = "item", 		["image"] = "steakburger.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["toastbacon"] 					= {["name"] = "toastbacon",  	    		["label"] = "Bacon and Toast",			["weight"] = 100, 		["type"] = "item", 		["image"] = "toastbacon.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["tunasandwich"] 				= {["name"] = "tunasandwich",  	    		["label"] = "Tuna Sandwich",			["weight"] = 100, 		["type"] = "item", 		["image"] = "tunasandwich.png", 	["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["veggiewrap"] 					= {["name"] = "veggiewrap",  	    		["label"] = "Veggie Wrap",				["weight"] = 100, 		["type"] = "item", 		["image"] = "veggiewrap.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },

	["carrotcake"] 					= {["name"] = "carrotcake",  	    		["label"] = "Carrot Cake",				["weight"] = 100, 		["type"] = "item", 		["image"] = "carrotcake.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["cheesecake"] 					= {["name"] = "cheesecake",  	    		["label"] = "Cheese Cake",				["weight"] = 100, 		["type"] = "item", 		["image"] = "cheesecake.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["chocpudding"] 				= {["name"] = "chocpudding",  	    		["label"] = "Chocolate Pudding",		["weight"] = 100, 		["type"] = "item", 		["image"] = "chocpudding.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["jelly"] 						= {["name"] = "jelly",  	    			["label"] = "Jelly",					["weight"] = 100, 		["type"] = "item", 		["image"] = "jelly.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["popdonut"] 					= {["name"] = "popdonut",  	    			["label"] = "Donut",					["weight"] = 100, 		["type"] = "item", 		["image"] = "popdonut.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["popicecream"] 				= {["name"] = "popicecream",  	    		["label"] = "Ice Cream",				["weight"] = 100, 		["type"] = "item", 		["image"] = "popicecream.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },

	["crisps"] 						= {["name"] = "crisps",  	    			["label"] = "Crisps",					["weight"] = 100, 		["type"] = "item", 		["image"] = "chips.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },

	--Ingredients
	["chickenbreast"] 				= {["name"] = "chickenbreast",  	    	["label"] = "Chicken Breast",			["weight"] = 100, 		["type"] = "item", 		["image"] = "chickenbreast.png", 	["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["jimsausages"] 				= {["name"] = "jimsausages",  	    		["label"] = "Sausages",					["weight"] = 100, 		["type"] = "item", 		["image"] = "jimsausages.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["jimeggs"] 					= {["name"] = "jimeggs",  	    			["label"] = "Eggs",						["weight"] = 100, 		["type"] = "item", 		["image"] = "jimeggs.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['hunger'] = math.random(20, 30) },
	["ham"] 						= {["name"] = "ham",  	     				["label"] = "Ham",						["weight"] = 100, 		["type"] = "item", 		["image"] = "ham.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", },
	["fish"] 						= {["name"] = "fish",  	     				["label"] = "CatFish",	 				["weight"] = 200, 		["type"] = "item", 		["image"] = "fish.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = "A Catfish", ['hunger'] = math.random(40, 50) },
	["meat"] 						= {["name"] = "meat",  	     				["label"] = "Meat",	 					["weight"] = 200, 		["type"] = "item", 		["image"] = "meat.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "A slab of Meat", ['hunger'] = math.random(40, 50) },
	["chocolate"] 				 	= {["name"] = "chocolate",  		     	["label"] = "Chocolate",	 			["weight"] = 200, 		["type"] = "item", 		["image"] = "chocolate.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = "Chocolate Bar", ['hunger'] = math.random(20, 30) },
	["lettuce"] 	 			 	 = {["name"] = "lettuce",       			["label"] = "Lettuce",	 				["weight"] = 100, 		["type"] = "item", 		["image"] = "lettuce.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = "Some big taco brother"},
	["cheddar"] 					 = {["name"] = "cheddar",					["label"] = "Cheddar Slice",			["weight"] = 500,		["type"] = "item",		["image"] = "cheddar.png",				["unique"] = false, 	["useable"] = false,	["shouldClose"] = false,	["combinable"] = nil,	["description"] = "Slice of Cheese"},

	--SODA
	["sprunk"] 						= {["name"] = "sprunk",  	    	 		["label"] = "Sprunk",		 			["weight"] = 100, 		["type"] = "item", 		["image"] = "sprunk.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['thirst'] = math.random(20, 30) },
	["sprunklight"] 				= {["name"] = "sprunklight",  	    	 	["label"] = "Sprunk Light",		 		["weight"] = 100, 		["type"] = "item", 		["image"] = "sprunklight.png", 	["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['thirst'] = math.random(20, 30) },
	["ecola"] 						= {["name"] = "ecola",  	    	 		["label"] = "eCola",		 			["weight"] = 100, 		["type"] = "item", 		["image"] = "ecola.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['thirst'] = math.random(20, 30) },
	["ecolalight"] 					= {["name"] = "ecolalight",  	    	 	["label"] = "eCola Light",		 		["weight"] = 100, 		["type"] = "item", 		["image"] = "ecolalight.png", 	["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "", ['thirst'] = math.random(20, 30) },

Under the QBShared.Jobs = {

	['popsdiner'] = {
		label = "Pop's Diner",
		defaultDuty = false,
		grades = {
            ['0'] = { name = 'Recruit', payment = 50 },
			['1'] = { name = 'Novice', payment = 75 },
			['2'] = { name = 'Experienced', payment = 100 },
			['3'] = { name = 'Advanced', payment = 125 },
			['4'] = { name = 'Manager', isboss = true, payment = 150 },
        },
	},

---------------------------------------------------------------------------------------------------

To make use of a payment system with rewards I recommend my own free billing script:

https://github.com/jimathy/jim-payments

---------------------------------------------------------------------------------------------------

## QB-Management:

	- Update to the latest github version
	- Make sure the job "popsdiner" has been added to the database
	- The menu's targets should be accessible to bosses from the clock in spot

--------------------------------------------------------------------------------------------------

## Emotes:

Custom emotes currently run through dpemotes, its the easier option and adds extra emotes for you to use :)

These go in your `[standalone]` > `dpemotes` > `client` > `AnimationList.lua`

Place these under DP.PropEmotes = {

	--Jim-popsdiner
   ["ecola"] = {"mp_player_intdrink", "loop_bottle", "E-cola", AnimationOptions =
   {    Prop = "prop_ecola_can", PropBone = 18905, PropPlacement = {0.12, 0.008, 0.03, 240.0, -60.0},
        EmoteMoving = true, EmoteLoop = true, }},
   ["sprunk"] = {"mp_player_intdrink", "loop_bottle", "Sprunk", AnimationOptions =
   {    Prop = "v_res_tt_can03", PropBone = 18905, PropPlacement = {0.12, 0.008, 0.03, 240.0, -60.0},
        EmoteMoving = true, EmoteLoop = true, }},

--------------------------------------------------------------------------------------------------

## Jim-Consuambles item setup (THIS IS OPTIONAL)
- In Jim-Popsdiner `config.lua` set `JimConsumables` to true
- Add the emotes above to Jim-Consumables `config.lua` under the `Emotes = {` section
- Add these lines to Jim-Consumables `config.lua` under the `Consumables = {` section

	--Soda's
	["ecola"] = { emote = "ecola", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = math.random(20,30), }},
	["ecolalight"] = { emote = "ecola", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = math.random(20,30), }},
	["sprunk"] = { emote = "sprunk", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = math.random(20,30), }},
	["sprunklight"] = { emote = "sprunk", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "drink", stats = { thirst = math.random(20,30), }},

	--Food
	["crisps"] = { emote = "crisps", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},

	["carrotcake"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	["cheesecake"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	["jelly"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	["chocpudding"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	["popdonut"] = { emote = "donut", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	["popicecream"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	["chocolate"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	["baconeggs"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	["bltsandwich"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	["cheeseburger"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	["cheesesandwich"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	["eggsandwich"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	["grilledwrap"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	["hamburger"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	["hamcheesesandwich"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	["hamsandwich"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	["ranchwrap"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	["sausageeggs"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	["steakburger"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	["toastbacon"] = { emote = "burger", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	["tunasandwich"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},
	["veggiewrap"] = { emote = "sandwich", canRun = false, time = math.random(5000, 6000), stress = math.random(2, 4), heal = 0, armor = 0, type = "food", stats = { hunger = math.random(20, 30), }},

- Restart Jim-Consumables

--------------------------------------------------------------------------------------------------

## Changelog

### v1.6.5
	- Tidy up and minor fixes
	- Better handling of adding jim-consumables items though server events
	- Improved startup event to detect missing jobs better
	- Improved Crafting Events
		- Handle missing items better
		- Inventory's now lock and unlock when crafting
		- Lock players in place when crafting
		- Make animation loop to get around animations ending before progressbars
	- Added crafting camera, toggle this in the config
	- Fixed/Removed last debug duty print

### v1.6.4
	- Optimizations, less memory usage
	- `GetCoreObject()` removed from every file and moved to bottom of config.lua to optimise memory usage
	- Tidied and optimized crafting events
	- Removed true/false console print on duty change

### v1.6.3
	- Add "Multi-Craft" option in the config.lua
	- Split-Stack item exploit fix
	- Change/Add support for creating jobGarages in (https://github.com/jimathy/jim-jobgarage)
	- Optional: Support for new `Jim-Consumables` automated item adding events
		- (Start `jim-consumables` BEFORE this script and set `Config.JimConsumables` to `true` for it to work)
		- (https://github.com/jimathy/jim-consumables)

### v1.6.2
	- Fix consume locale for eating with ox_inv

### v1.6.1
	- Improved `OX_Lib` Context support (better layout for ingredients)
	- Added image icons to `OX_Lib` menus
	- Added Version Update check
	- Added more options to blip creation
	- Fix mis-named event breaking consume event
	- Locale fixes

### v1.6:
	- Added info for JimConsumables support
	- Support for changing Core folder name
	- Added 7 table stashes inside the MLO
	- Support added for `OX_Target`
	- Support added for `OX_Inventory`
	- Support added for `OX_Lib` Context Menus
	- *Basic* `OX_Lib` notification support (Set `Config.Notify = "ox"`)
	- Added autoClock variable to locations config
		- This helps define if leaving or entering the zone clocks in or out

### v1.5:
	- Core name change support in config
	- Updated install.md
	- Updated built-in client and server Hasitem events to be more accurate

### v1.4.3:
    - Locale support thanks to Dafke

### v1.4.2:
    - Workaround for the HasItem() allowing crafting when items aren't there

### v1.4.1:
	- Fix parsing error because of a fullstop instead of a comma
	- Fix error when cancelling eating and drinking
	- Add item duping protection to item crafting

### v1.4:
	- Add support for ps progressbar images
	- Add built in HasItem Event, including optimizations to checks for if you can craft or not

### v1.3:
	- New shared file for all the functions
	- Optimized how props are made and handled
	- Optimized and improved chair code
	- Fix being able to craft while off duty
	- Removed `coffee` from usable items to stop it breaking

### v1.2:
	- Improved Checkmark issues causing script to break when crafting
		- This is a toggle in the config, if it causes issues(like lag) disable it
	- Added Support for Jim-Shops
	- Added support for new qb-menu icons
	- Added Job Garages for deliveries to both default locations
	- QoL fixes
		- Improved and optimized loading of targets and props
	- Upgraded Crafting systems to be more optimised and use crafting recipes
	- Added simple support for Toys/Prizes
	- Separate Food Store to make a "Dessert Counter"
	- Added QB-Management bossmenu target location to clockin

### v1.1:
	- Optimzation update
		- Script now uses polyzones and better loops to lower idle times
		- Runs at 0.00ms idle
	- Inventory images added to qb-menu

-------------------------------------------------------------------------------------------------

