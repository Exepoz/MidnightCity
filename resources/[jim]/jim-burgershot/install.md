Thank you for your purchase <3 I hope you have fun with this script and that it brings jobs and RP to your server

If you need support I now have a discord available, it helps me keep track of issues and give better support.

https://discord.gg/xKgQZ6wZvS

-------------------------------------------------------------------------------------------------

# Installation

Add the item images to your inventory script
For Example:
	`[qb]` > `qb-inventory` > `html` > `images`

THESE GO IN YOUR SHARED.LUA IN qb-core:

Under the QBShared.Items in items.lua

	--BurgerShot
	["potato"] 						 = {["name"] = "potato",					["label"] = "Potatoes",					["weight"] = 500,		["type"] = "item",		["image"] = "potatoes.png",				["unique"] = false, 	["useable"] = false,	["shouldClose"] = false,	["combinable"] = nil,	["description"] = "Bag of Potatos"},
	["slicedpotato"] 				 = {["name"] = "slicedpotato",				["label"] = "Sliced Potatoes",			["weight"] = 500,		["type"] = "item",		["image"] = "burger-slicedpotato.png",	["unique"] = false, 	["useable"] = false,	["shouldClose"] = false,	["combinable"] = nil,	["description"] = "Sliced Potato"},
	["slicedonion"] 				 = {["name"] = "slicedonion",				["label"] = "Sliced Onions",			["weight"] = 500,		["type"] = "item",		["image"] = "burger-slicedonion.png",	["unique"] = false, 	["useable"] = false,	["shouldClose"] = false,	["combinable"] = nil,	["description"] = "Sliced Onion"},
	["icecream"] 					 = {["name"] = "icecream",					["label"] = "Ice Cream",				["weight"] = 500,		["type"] = "item",		["image"] = "burger-icecream.png",		["unique"] = false, 	["useable"] = false,	["shouldClose"] = false,	["combinable"] = nil,	["description"] = "Ice Cream."},
	["milk"] 						 = {["name"] = "milk",						["label"] = "Milk",						["weight"] = 500,		["type"] = "item",		["image"] = "burger-milk.png",			["unique"] = false, 	["useable"] = true,		["shouldClose"] = true,		["combinable"] = nil,	["description"] = "Carton of Milk", ['thirst'] = math.random(35, 54) },
	["lettuce"] 	 			 	 = {["name"] = "lettuce",       			["label"] = "Lettuce",	 				["weight"] = 100, 		["type"] = "item", 		["image"] = "lettuce.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = "Some big taco brother"},
	["onion"] 						 = {["name"] = "onion",						["label"] = "Onion",					["weight"] = 500,		["type"] = "item",		["image"] = "burger-onion.png",			["unique"] = false, 	["useable"] = false,	["shouldClose"] = false,	["combinable"] = nil,	["description"] = "An onion"},
	["frozennugget"] 				 = {["name"] = "frozennugget",				["label"] = "Frozen Nuggets",			["weight"] = 500,		["type"] = "item",		["image"] = "burger-frozennugget.png",	["unique"] = false, 	["useable"] = false,	["shouldClose"] = false,	["combinable"] = nil,	["description"] = "Bag of Frozen Nuggets"},
	["cheddar"] 					 = {["name"] = "cheddar",					["label"] = "Cheddar Slice",			["weight"] = 500,		["type"] = "item",		["image"] = "cheddar.png",				["unique"] = false, 	["useable"] = false,	["shouldClose"] = false,	["combinable"] = nil,	["description"] = "Slice of Cheese"},
	["burgerbun"] 		 			 = {["name"] = "burgerbun",       		    ["label"] = "Burger Bun",	 			["weight"] = 100, 		["type"] = "item", 		["image"] = "burgerbun.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,    ["combinable"] = nil,   ["description"] = "Some big burger brother"},
	["burgerpatty"] 				 = {["name"] = "burgerpatty",				["label"] = "Burger Patty",				["weight"] = 500,		["type"] = "item",		["image"] = "burgerpatty.png",			["unique"] = false, 	["useable"] = false,	["shouldClose"] = false,	["combinable"] = nil,	["description"] = "Raw Patty"},
	["burgermeat"] 				 	 = {["name"] = "burgermeat",				["label"] = "Burger Meat",				["weight"] = 500,		["type"] = "item",		["image"] = "burgermeat.png",			["unique"] = false, 	["useable"] = false,	["shouldClose"] = false,	["combinable"] = nil,	["description"] = "Cooked Burger Meat"},
	["milkshake"] 					 = {["name"] = "milkshake",					["label"] = "Milkshake",				["weight"] = 500,		["type"] = "item",		["image"] = "burger-milkshake.png",		["unique"] = false, 	["useable"] = true,		["shouldClose"] = true,	 	["combinable"] = nil,	["description"] = "BurgerShot Milkshake", ['thirst'] = math.random(35, 54) },
	["shotnuggets"] 				 = {["name"] = "shotnuggets", 			  	["label"] = "Shot Nuggets", 			["weight"] = 200, 		["type"] = "item", 		["image"] = "burger-shotnuggets.png", 	["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   	["combinable"] = nil,   ["description"] = "Burgershot Nuggets", ['hunger'] = math.random(40, 50) },
	["shotrings"] 				 	 = {["name"] = "shotrings", 			  	["label"] = "Ring Shots", 				["weight"] = 200, 		["type"] = "item", 		["image"] = "burger-shotrings.png", 	["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   	["combinable"] = nil,   ["description"] = "Burgershot Onion Rings", ['hunger'] = math.random(40, 50) },
	["heartstopper"] 			 	 = {["name"] = "heartstopper",       		["label"] = "HeartStopper",	 			["weight"] = 200, 		["type"] = "item", 		["image"] = "burger-heartstopper.png", 	["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "Heartstopper", ['hunger'] = math.random(50, 60) },
	["shotfries"] 		 			 = {["name"] = "shotfries",       			["label"] = "Shot Fries",	 			["weight"] = 200, 		["type"] = "item", 		["image"] = "burger-fries.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "Shot Fries", ['hunger'] = math.random(40, 50) },
	["moneyshot"] 		 			 = {["name"] = "moneyshot",       			["label"] = "Money Shot",	 			["weight"] = 200, 		["type"] = "item", 		["image"] = "burger-moneyshot.png", 	["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "Money Shot", ['hunger'] = math.random(40, 50) },
	["meatfree"] 		 			 = {["name"] = "meatfree",       			["label"] = "Meat Free",	 			["weight"] = 200, 		["type"] = "item", 		["image"] = "burger-meatfree.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "Meat Free", ['hunger'] = math.random(40, 50) },
	["bleeder"] 		 			 = {["name"] = "bleeder",       			["label"] = "The Bleeder",	 			["weight"] = 200, 		["type"] = "item", 		["image"] = "burger-bleeder.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "The Bleeder", ['hunger'] = math.random(40, 50) },
	["bscoffee"] 		 			 = {["name"] = "bscoffee",       			["label"] = "BurgerShot Coffee",	 	["weight"] = 200, 		["type"] = "item", 		["image"] = "burger-coffee.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "BurgerShot Coffee", ['thirst'] = math.random(35, 54) },
	["bscoke"] 		 				 = {["name"] = "bscoke",       				["label"] = "BurgerShot Coke",	 		["weight"] = 200, 		["type"] = "item", 		["image"] = "burger-softdrink.png", 	["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "BurgerShot Cola", ['thirst'] = math.random(35, 54) },
	["torpedo"] 		 			 = {["name"] = "torpedo",       			["label"] = "Torpedo",	 				["weight"] = 200, 		["type"] = "item", 		["image"] = "burger-torpedo.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "BurgerShot Torpedo", ['hunger'] = math.random(40, 50) },
	["rimjob"] 		 				 = {["name"] = "rimjob",  	     			["label"] = "Rim Job",	 				["weight"] = 200, 		["type"] = "item", 		["image"] = "burger-rimjob.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "BurgerShot Donut", ['hunger'] = math.random(40, 50) },
	["creampie"] 		 			 = {["name"] = "creampie",  	     		["label"] = "Creampie",	 				["weight"] = 200, 		["type"] = "item", 		["image"] = "burger-creampie.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "BurgerShot Apple Pie", ['hunger'] = math.random(40, 50) },
	["cheesewrap"] 					 = {["name"] = "cheesewrap", 				["label"] = "BS Cheese Wrap", 	     	["weight"] = 150, 		["type"] = "item", 		["image"] = "burger-chickenwrap.png", 	["unique"] = false,   	["useable"] = true,   	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "BurgerShot Cheese Wrap", ['hunger'] = math.random(40, 50) },
	["chickenwrap"] 				 = {["name"] = "chickenwrap", 				["label"] = "BS Goat Cheese Wrap", 	    ["weight"] = 150, 		["type"] = "item", 		["image"] = "burger-goatwrap.png", 		["unique"] = false,   	["useable"] = true,   	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "BurgerShot Goat Cheese Wrap", ['hunger'] = math.random(40, 50)},
	["murderbag"] 					 = {["name"] = "murderbag", 				["label"] = "Murder Bag", 	   			["weight"] = 0, 		["type"] = "item", 		["image"] = "burgerbag.png", 			["unique"] = true,   	["useable"] = true,   	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "Grab a Murder Bag of Burgers", },

Under the QBShared.Jobs in jobs.lua

	['burgershot'] = {
		label = 'BurgerShot',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = { name = 'Recruit', payment = 50 },
			['1'] = { name = 'Novice', payment = 75 },
			['2'] = { name = 'Experienced', payment = 100 },
			['3'] = { name = 'Advanced', payment = 125 },
			['4'] = { name = 'Manager', isboss = true, payment = 150 },
        },
	},

--------------------------------------------------------------------------------------------------

## QB-Management:

	- Update to the latest github version
	- Make sure the job "burgershot" has been added to the database
	- The menu's targets should be accessible to bosses from the clock in spot

--------------------------------------------------------------------------------------------------

## Emotes:

Custom emotes currently run through dpemotes, its the easier option and adds extra emotes for you to use :)

These go in your `[standalone]` > `dpemotes` > `client` > `AnimationList.lua`

Place these under DP.PropEmotes = {

    --Jim-BurgerShot
   ["milk"] = {"mp_player_intdrink", "loop_bottle", "Milk", AnimationOptions =
   {    Prop = "v_res_tt_milk", PropBone = 18905, PropPlacement = {0.10, 0.008, 0.07, 240.0, -60.0},
        EmoteMoving = true, EmoteLoop = true, }},
   ["bscoke"] = {"mp_player_intdrink", "loop_bottle", "BS Coke", AnimationOptions =
   {    Prop = "prop_food_bs_juice01", PropBone = 18905, PropPlacement = {0.04, -0.10, 0.10, 240.0, -60.0},
        EmoteMoving = true, EmoteLoop = true, }},
   ["bscoffee"] = {"mp_player_intdrink", "loop_bottle", "BS Coffee", AnimationOptions =
   {    Prop = "prop_food_bs_coffee", PropBone = 18905, PropPlacement = {0.08, -0.10, 0.10, 240.0, -60.0},
        EmoteMoving = true, EmoteLoop = true, }},
   ["glass"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Tall Glass", AnimationOptions =
   {   Prop = 'prop_wheat_grass_glass', PropBone = 28422, PropPlacement = {0.0, 0.0, -0.1, 0.0, 0.0, 0.0},
       EmoteLoop = true, EmoteMoving = true, }},

   ["torpedo"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger_fp", "Torpedo", AnimationOptions =
   {    Prop = "prop_food_bs_burger2", PropBone = 18905, PropPlacement = {0.10, -0.07, 0.091, 15.0, 135.0},
        EmoteMoving = true, EmoteLoop = true, }},
   ["bsfries"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger_fp", "Fries", AnimationOptions =
   {    Prop = "prop_food_bs_chips", PropBone = 18905, PropPlacement = {0.09, -0.06, 0.05, 300.0, 150.0},
        EmoteMoving = true, EmoteLoop = true, }},
   ["donut2"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Donut2", AnimationOptions =
   {   Prop = 'prop_donut_02', PropBone = 18905, PropPlacement = {0.13, 0.05, 0.02, -50.0, 100.0, 270.0},
       EmoteMoving = true, EmoteLoop = true, }},

--------------------------------------------------------------------------------------------------

## Jim-Consumables item setup - (Optional) - (https://github.com/jimathy/jim-consumables)
- Support for new `Jim-Consumables` automated adding of items and emotes
- Start `jim-consumables` BEFORE this script and set `Config.JimConsumables` to `true` for it to work
- In Jim-Burgershot's `config.lua` set `JimConsumables` to true
- Restart/Ensure Jim-Burgershot

- Restart Jim-Consumables

--------------------------------------------------------------------------------------------------

## Changelog

### 2.6:
	- Rewrite to tidy up and streamline the location code
	 - (support for 6 mlos in one spot gets messy)
	 - If you have a custom MLO layout they WILL still work
	 - just copy into if statement like before
	 - The MLO's I've personally added support for will be a different format from now on
	- Optimizations, less memory usage
	 - `GetCoreObject()` removed from every file and moved to bottom of config.lua to reduce memory usage
	- Added uNiqx Burgershot MLO Support
	- Added usable toilets to all possible MLO's

### 2.5:
	- Added GABZ Bugershot MLO Support
	- Fixed "undefined" target for chairs
	- Optimized script to reduce memory usage

### 2.4.9.1:
	- Added french locale `fr.lua`
	- Fixed a couple shop targets breaking
	- Fixed RZ Burgershot location opening stash instead the shop
	- Fixed broken locale for "sit down" targets

### 2.4.9:
	- Fix blips now showing on the map for all locations
	- Fix progressbar stopping movement

### 2.4.8:
	- Fix deep frier animation (Don't put your hands in a fryer kids)
	- Fix for possiblity of locations overriding each other
	- Fix Prepared/Chopping Board Headers in certain locations

### 2.4.7:
	- Add "Multi-Craft" option in the config.lua
	- Split-Stack item exploit fix
	- Change/Add support for creating jobGarages in (https://github.com/jimathy/jim-jobgarage)
	- Optional: Support for new `Jim-Consumables` automated item adding events
		- (Start `jim-consumables` BEFORE this script and set `Config.JimConsumables` to `true` for it to work)
		- (https://github.com/jimathy/jim-consumables)
	- Fix murder bags not working on ox
	- Support added for RZ's free burgershot MLO (https://github.com/rz4never/rz-burgershot/tree/main/burgershot-map)
	- Fix looking in the wrong direction when crafting

### 2.4.6
	- Reset default settings to "qb"
	- Fix crafting animations not working for other languages
	- Fix crafting menus sometimes not showing a title

### 2.4.5
	- Added image icons to ox_lib menus
	- Added Version Update check
	- Fix ox stores possibly breaking on opening

### 2.4.4
	- Improved `OX_Lib` Context support (better layout for ingredients)
	- Improved `OX_Inv` support
	- Added `OX_Lib` Progressbar support
	- Improved script stopping/restarting events
	- Added more options to blip creation
	- Locale fixes
	- Updated shared functions to give more info and be more optimized

### 2.4.3
	- Improved locations of targets in Smallo's free MLO
	- Improved blip customisablilty
	- Update Built-in Consume event to be more optimized and easier to read
	- Fix install.md to re-add missing emotes
	- a
	- **Basic** OX_Lib notification support (Set `Config.Notify = "ox"`)
	- Updated shared functions to give more info and be more optimized

### 2.4.2
	- Fix lookEnt() event
	- Fix Murderbags not opening (these won't work with ox_inventory)

### 2.4.1
	- Fix stores not being able to open for qb-inventory
	- Updated emote code in built-in consumable events

### 2.4
	- Support for changing Core name
	- Support added for OX_Target
	- Support added for OX_Inventory
	- Support added for OX_Lib Context Menus
	- Add Support for GNMods Sandy Shores
	- Add Support for GNMods Mirror Park
	- Added autoClock variable to locations config
		- This helps define if leaving or entering the zone clocks in or out
	- Add Support for multiple locations at once
		- Small change in the config as the MLO option is now tied to the one zone as it made more sense

### v2.3.7
	- Updated install.md
		- Included instructions to make use of Jim-Consuambles if wanted
	- Updated built-in client and server `Hasitem` events to be more accurate

### v2.3.6
	- Forgot to swap and old event, it was still trying to check for items incorrectly

### v2.3.5
    - Workaround for the `HasItem()` allowing crafting when items aren't there

### v2.3.4
	- Made the `HasItem` functions built in, so no edits to core needed
		- This allows optimizations + makes crafting menus open/load much faster
	- Add item duping protection to item crafting

### v2.3.3
	- Add "cn" locale
	- Add item duping protection

### v2.3.1
	- Fixes to QBCore item Changes
	- Greatly reduced the size of MurderBag stashes

### v2.3
	- New shared file with all the functions in
	- Optimised Chair code
	- Optimized spawning of props

### v2.2.1
	- Fixed built in job garage not being selectable
	- Optimisations
		- Did some tidying up of code
		- Worked in some unloading of props and such to help reduce memory usage

### v2.2
	- Added full support for NoPixels MLO
		- All Chairs usable
		- All Locations usable
		- DUI changing support
		- Interior and External DUI's are linked as the textures use the same names
		- Notes: Come collisions are a bit off so you have to aim at very specific places a lot of the time
	- Dui Fixes
		- Optimizations: Unless you manually set the image in dui.lua or in game, it wont try load a DUI
		- Support for NoPixels internal Images, which changes the external ones too

### v2.1.1
	- Hotfix for wrong events left in for Smallo's MLO

### v2.1
	- Added support for changing the DUI images above the counters
		- Support for both GN Mods and Smallo's MLO
	- Fixed Burger Grill checkmarks not working at all
	- Added Support for ps-progressbar
	- Finally caved in and moved the config.lua based locations over to client.lua
	- Introduced new item, the "Murder Bag". Grab these from their pickup locations and put your items inside.
		- Don't forget to add the new item and image.

### v2.0
	- Added Support for CheckMarks
		- This is a toggle in the config, if it causes issues(like lag) disable it
	- Added Support for Jim-Shops
	- Added support for new Qb-Menu icons
	- Finally fixed missing missing tray in GN mods MLO
		- It was always there but had to be moved slightly to the side for it to actually not be invisible
	- Added missing ATM to other entrance under the 2nd "ATM Machine" sign
	- Added Job Garage for delivery vehicles
	- QoL Fixes and Optimizations
	- Added simple support for Toys/Prizes
	- BossMenu is now accessible from the same areas as clock in targets

----------------------------------------------------------------------------------------------------