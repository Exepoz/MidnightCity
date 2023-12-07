Thank you for your purchase <3 I hope you have fun with this script and that it brings jobs and RP to your server

If you need support I now have a discord available, it helps me keep track of issues and give better support.

https://discord.gg/xKgQZ6wZvS

-------------------------------------------------------------------------------------------------
# Installation
THESE GO IN YOUR SHARED .LUA IN qb-core:

Under the QBShared.Items

--Jim-Lumberjack
  ["powersaw"] 		= {["name"] = "powersaw",       	["label"] = "Power Saw", 		["weight"] = 1000,  ["type"] = "item",  ["image"] = "powersaw.png",	["unique"] = true,	["useable"] = false,     ["shouldClose"] = false, ["description"] = ""},

  ["log"] 	    	= {["name"] = "log",				["label"] = "Log",	 			["weight"] = 2000,  ["type"] = "item",  ["image"] = "log.png",			["unique"] = false, 	["useable"] = false,     ["shouldClose"] = false, ["description"] = ""},
  ["bark"] 			= {["name"] = "bark",       		["label"] = "Tree Bark", 		["weight"] = 100,   ["type"] = "item",  ["image"] = "bark.png",			["unique"] = false, 	["useable"] = false,     ["shouldClose"] = false, ["description"] = ""},
  ["debarkedlog"]		= {["name"] = "debarkedlog",		["label"] = "Debarked Log", 	["weight"] = 100,   ["type"] = "item",  ["image"] = "debarkedlog.png",	["unique"] = false, 	["useable"] = false,     ["shouldClose"] = false, ["description"] = ""},
  ["wood"]        	= {["name"] = "wood", 				["label"] = "Wood Planks", 		["weight"] = 100,   ["type"] = "item",  ["image"] = "woodplank.png",	["unique"] = false, 	["useable"] = false,     ["shouldClose"] = false, ["description"] = ""},

  ["paper"]       	= {["name"] = "paper",      		["label"] = "Roll of Paper",	["weight"] = 100,   ["type"] = "item",  ["image"] = "paperroll.png",	["unique"] = false, 	["useable"] = false,     ["shouldClose"] = false, ["description"] = ""},
  ["cardhat"]    	 	= {["name"] = "cardhat",    		["label"] = "Cardboard Box",	["weight"] = 100,   ["type"] = "item",  ["image"] = "cardhat.png",		["unique"] = true,	["useable"] = true,     ["shouldClose"] = false,        ["description"] = ""},

  ["fakecash"]    	= {["name"] = "fakecash",   		["label"] = "Fake Cash",		["weight"] = 100,   ["type"] = "item",  ["image"] = "fakecash.png",		["unique"] = false, 	["useable"] = false,     ["shouldClose"] = false, ["description"] = ""},
  ["fakecert"]    	= {["name"] = "fakecert",   		["label"] = "Fake Certificate",	["weight"] = 100,	["type"] = "item",  ["image"] = "fakecert.png",		["unique"] = false, 	["useable"] = false,     ["shouldClose"] = false, ["description"] = ""},
  ["fakeweaplicence"]	= {["name"] = "fakeweaplicence",   	["label"] = "Fake Weapon Licence",["weight"] = 100, ["type"] = "item",  ["image"] = "fakeweap.png",		["unique"] = false, 	["useable"] = false,     ["shouldClose"] = false, ["description"] = ""},
  ["fakedrivelicence"]= {["name"] = "fakedrivelicence",   ["label"] = "Fake Drivers Licence",["weight"] = 100,["type"] = "item",  ["image"] = "fakedriver.png",	["unique"] = false, 	["useable"] = false,     ["shouldClose"] = false, ["description"] = ""},
  ["fakelawyer"]		= {["name"] = "fakelawyer",   		["label"] = "Fake Laywer Pass",	["weight"] = 100,	["type"] = "item",  ["image"] = "fakelawyer.png",	["unique"] = false, 	["useable"] = false,     ["shouldClose"] = false, ["description"] = ""},

  ["charcoal"] 	    = {["name"] = "charcoal",			["label"] = "Charcoal",	 		["weight"] = 100,  ["type"] = "item",  ["image"] = "charcoal.png",		["unique"] = false, 	["useable"] = false,     ["shouldClose"] = false, ["description"] = ""},
  ["hammerhandle"] 	= {["name"] = "hammerhandle",		["label"] = "Hammer Handle",	["weight"] = 100,  ["type"] = "item",  ["image"] = "hammerhandle.png",	["unique"] = false, 	["useable"] = false,     ["shouldClose"] = false, ["description"] = ""},
  ["axehandle"] 		= {["name"] = "axehandle",			["label"] = "Axe Handle",		["weight"] = 100,  ["type"] = "item",  ["image"] = "axehandle.png",		["unique"] = false, 	["useable"] = false,     ["shouldClose"] = false, ["description"] = ""},
  ["batbase"] 		= {["name"] = "batbase",			["label"] = "Bat Base",			["weight"] = 100,  ["type"] = "item",  ["image"] = "batbase.png",		["unique"] = false, 	["useable"] = false,     ["shouldClose"] = false, ["description"] = ""},

  ["origami1"]    	= {["name"] = "origami1",    		["label"] = "Origami Scorpion",	["weight"] = 100,  ["type"] = "item",  ["image"] = "origami1.png",		["unique"] = true, 	["useable"] = true,     ["shouldClose"] = true,       ["description"] = ""},
  ["origami2"]    	= {["name"] = "origami2",    		["label"] = "Origami Spider",	["weight"] = 100,  ["type"] = "item",  ["image"] = "origami2.png",		["unique"] = true, 	["useable"] = true,     ["shouldClose"] = true,       ["description"] = ""},
  ["origami3"]    	= {["name"] = "origami3",    		["label"] = "Origami Poop",		["weight"] = 100,  ["type"] = "item",  ["image"] = "origami3.png",		["unique"] = true, 	["useable"] = true,     ["shouldClose"] = true,       ["description"] = ""},
  ["origami4"]    	= {["name"] = "origami4",    		["label"] = "Origami Dragon",	["weight"] = 100,  ["type"] = "item",  ["image"] = "origami4.png",		["unique"] = true, 	["useable"] = true,     ["shouldClose"] = true,       ["description"] = ""},
  ["origami5"]    	= {["name"] = "origami5",    		["label"] = "Origami Unicorn",	["weight"] = 100,  ["type"] = "item",  ["image"] = "origami5.png",		["unique"] = true, 	["useable"] = true,     ["shouldClose"] = true,       ["description"] = ""},
  ["origami6"]    	= {["name"] = "origami6",    		["label"] = "Origami Pig",		["weight"] = 100,  ["type"] = "item",  ["image"] = "origami6.png",		["unique"] = true, 	["useable"] = true,     ["shouldClose"] = true,       ["description"] = ""},
  ["origami7"]    	= {["name"] = "origami7",    		["label"] = "Origami Phoenix",	["weight"] = 100,  ["type"] = "item",  ["image"] = "origami7.png",		["unique"] = true, 	["useable"] = true,     ["shouldClose"] = true,       ["description"] = ""},
  ["origami8"]    	= {["name"] = "origami8",    		["label"] = "Origami Plane",	["weight"] = 100,  ["type"] = "item",  ["image"] = "origami8.png",		["unique"] = true, 	["useable"] = true,     ["shouldClose"] = true,       ["description"] = ""},
  ["origami9"]    	= {["name"] = "origami9",    		["label"] = "Origami Whale",	["weight"] = 100,  ["type"] = "item",  ["image"] = "origami9.png",		["unique"] = true, 	["useable"] = true,     ["shouldClose"] = true,       ["description"] = ""},
  ["origami10"]    	= {["name"] = "origami10",    		["label"] = "Origami Dolphin",	["weight"] = 100,  ["type"] = "item",  ["image"] = "origami10.png",		["unique"] = true, 	["useable"] = true,     ["shouldClose"] = true,       ["description"] = ""},
  ["origami11"]    	= {["name"] = "origami11",    		["label"] = "Origami Bunny",	["weight"] = 100,  ["type"] = "item",  ["image"] = "origami11.png",		["unique"] = true, 	["useable"] = true,     ["shouldClose"] = true,       ["description"] = ""},
  ["origami12"]    	= {["name"] = "origami12",    		["label"] = "Origami Lion",		["weight"] = 100,  ["type"] = "item",  ["image"] = "origami12.png",		["unique"] = true, 	["useable"] = true,     ["shouldClose"] = true,       ["description"] = ""},
  ["origami13"]    	= {["name"] = "origami13",    		["label"] = "Origami Turkey",	["weight"] = 100,  ["type"] = "item",  ["image"] = "origami13.png",		["unique"] = true, 	["useable"] = true,     ["shouldClose"] = true,       ["description"] = ""},
  ["origami14"]    	= {["name"] = "origami14",    		["label"] = "Origami Eagle",	["weight"] = 100,  ["type"] = "item",  ["image"] = "origami14.png",		["unique"] = true, 	["useable"] = true,     ["shouldClose"] = true,       ["description"] = ""},
  ["origami15"]    	= {["name"] = "origami15",    		["label"] = "Origami Dinosaur",	["weight"] = 100,  ["type"] = "item",  ["image"] = "origami15.png",		["unique"] = true, 	["useable"] = true,     ["shouldClose"] = true,       ["description"] = ""},
  ["origami16"]    	= {["name"] = "origami16",    		["label"] = "Origami Butterfly",["weight"] = 100,  ["type"] = "item",  ["image"] = "origami16.png",		["unique"] = true, 	["useable"] = true,     ["shouldClose"] = true,       ["description"] = ""},
  ["origami17"]    	= {["name"] = "origami17",    		["label"] = "Origami Monkey",	["weight"] = 100,  ["type"] = "item",  ["image"] = "origami17.png",		["unique"] = true, 	["useable"] = true,     ["shouldClose"] = true,       ["description"] = ""},
  ["origami18"]    	= {["name"] = "origami18",    		["label"] = "Origami Mouse",	["weight"] = 100,  ["type"] = "item",  ["image"] = "origami18.png",		["unique"] = true, 	["useable"] = true,     ["shouldClose"] = true,       ["description"] = ""},
  ["origami19"]    	= {["name"] = "origami19",    		["label"] = "Origami Cockatiel",["weight"] = 100,  ["type"] = "item",  ["image"] = "origami19.png",		["unique"] = true, 	["useable"] = true,     ["shouldClose"] = true,       ["description"] = ""},
  ["origami20"]    	= {["name"] = "origami20",    		["label"] = "Origami Squirrel",	["weight"] = 100,  ["type"] = "item",  ["image"] = "origami20.png",		["unique"] = true, 	["useable"] = true,     ["shouldClose"] = true,       ["description"] = ""},
  ["origami21"]    	= {["name"] = "origami21",    		["label"] = "Origami Wolf",		["weight"] = 100,  ["type"] = "item",  ["image"] = "origami21.png",		["unique"] = true, 	["useable"] = true,     ["shouldClose"] = true,       ["description"] = ""},

--------------------------------------------------------------------------------------------------

## Changelog

### v1.2.4
  - Reduced memory usage
  - Optimized ProgressBar creation, inv is locked better when needed
  - Added toggle for SawSounds
  - Fixed missing ox event support
  - Fixed SellStock menu ox support
  - Added extra checks so users shouldn't be kicked when debarking or sawing

### v1.2.3
  - Split-Stack item exploit fix
  - Fix crafting menus not working in qb-menu

### v1.2.2
  - Reset debug to default
  - Added more options to blip creation

### v1.2.1
  - Support for `ox_lib` progressbars
  - Support for `ox_lib` Context menus
  - Fix for players facing the wrong way when cutting
  - Fix `ox_target` location for debarking
  - Fix `ox_target` location for pulping + pulplog spawn coords
	- Improved `OX_Inv` support
	- Added Version Update check

### v1.2
  - Support for changing Core name
  - Support added for OX_Target
  - Support added for OX_Inventory
  - *Basic* Support added for Ox_Lib's Notifications

### v1.1.6
  - Updated shared.lua to be more detailed
  - Stopped fallen logs being network synced as this was causing exploits
    - Meaning fallen logs from cutting are now client sided

### v1.1.5
  - Add Crafting menu lock so players can't craft multiple items at once

### v1.1.4
  - Workaround for the `HasItem()` allowing crafting when items aren't there

### v1.1.3
  - Fix the tree respawn not being linked to the timing in config.lua
  - Fix fxmanifest not loading the server file

### v1.1.2
  - Change HasItem to built in event and optimize events
  - Add check to when too close to the tree, so the play does try to run towards it
  - Add Config option to toggle wether the saw can break or not
  - Spawned trees now have randomly adjusted rotations so they aren't all perfectly vertical

### v1.1.1
  - Change HasItem callback to `QBCore.Functions.HasItem`
  - Made use of lookEnt() more when interacting with peds

### v1.1
  - Added powersaw as an item, players need this in their inventory to cut trees now
    - This item has a 10% chance of breaking when cutting trees/logs
  - Simple store added to purchase saw + provisions
  - Added ability to job lock the entire job
    - Change Config.Job to the required job name
  - Added Origiami items to be crafted
    - Use them for an animation
  - Crafting bench now, if an item isn't found in items.lua, skips showing the recipe instead of breaking the script

### v1.0.1
  - Removed Testing prints
  - Added timeout to model loading event to help prevent script hangs
  - Added PowerSaw prop to load when entering polyzone
  - Changed PowerSaw Prop and adjusted attach locations
  - Better removal of qb-target of fallen logs to prevent targets being carried over to other entities
  - Added missing locales to client.lua