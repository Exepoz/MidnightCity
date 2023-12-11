Made by Lionh34rt
Discord: https://discord.gg/AWyTUEnGeN
Tebex: https://lionh34rt.tebex.io/

# Description
* **This script allows players to place bait to lure animals. If the player comes too close to the animal it will flee. After eating the bait, the animal will spot the player and flee. After processing the animal, players gain antlers, carcass and hides that they can sell at the taxidermist. The hunting rifle is blocked to shoot at players or random npc's. You can only shoot animals or when you're not aiming at something. The hunting rifle cannot be shot without scoping in**

# Dependencies
* [QBCore Framework](https://github.com/qbcore-framework)
* [ox_lib by overextended](https://github.com/overextended/ox_lib)
* [huntingrifle](https://nl.gta5-mods.com/weapons/sauer-101-hunting-rifle-animated-4k) -- optional

# Installation
* **Add the items to your shared**
* *Add the images to your inventory*
* **Add the reset hunting to the radialmenu**
* *If you want to use the huntingrifle you need to add the huntingrifle resource to your server as well as make changes to your smallresources and qb-weapons*

# Items for shared
```lua
-- Weapons
['weapon_huntingrifle'] 		 = {['name'] = 'weapon_huntingrifle', 	 	  	['label'] = 'Hunting Rifle', 			['weight'] = 10000, 	['type'] = 'weapon', 	['image'] = 'huntingrifle.png', 		['unique'] = true, 			['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'A rifle made for hunting.'},

-- Ammo
['hunting_ammo'] 				 = {['name'] = 'hunting_ammo', 			  	  	['label'] = 'Hunting ammo', 			['weight'] = 1000, 		['type'] = 'item', 		['image'] = 'hunting_ammo.png', 		['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,   ['description'] = 'Ammo for Hunting Rifle'},

-- Hunting
['hunting_bait'] 				 = {['name'] = 'hunting_bait', 			  	  	['label'] = 'Hunting Bait', 			['weight'] = 200, 		['type'] = 'item', 		['image'] = 'hunting_bait.png', 		['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	    ['combinable'] = nil,   ['description'] = 'Animals Love this stuff...'},
['deerhide'] 					 = {['name'] = 'deerhide', 			  			['label'] = 'Deer Hide', 				['weight'] = 1500, 		['type'] = 'item', 		['image'] = 'deerhide.png', 		    ['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,	['combinable'] = nil,   ['description'] = 'Deer Hide'},
['antlers'] 					 = {['name'] = 'antlers', 			  			['label'] = 'Antlers', 					['weight'] = 1000, 		['type'] = 'item', 		['image'] = 'antlers.png', 		    	['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,	['combinable'] = nil,   ['description'] = 'Antlers from a deer.'},
['carcass']						 = {['name'] = 'carcass', 			  			['label'] = 'Carcass', 					['weight'] = 1500, 		['type'] = 'item', 		['image'] = 'carcass.png', 		    	['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,	['combinable'] = nil,   ['description'] = 'Animal carcass.'},
['carcass2']					 = {['name'] = 'carcass2', 			  			['label'] = 'Carcass', 					['weight'] = 1500, 		['type'] = 'item', 		['image'] = 'carcass2.png', 		    ['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,	['combinable'] = nil,   ['description'] = 'Animal carcass.'},
['carcass3']					 = {['name'] = 'carcass3', 			  			['label'] = 'Carcass', 					['weight'] = 1000, 		['type'] = 'item', 		['image'] = 'carcass3.png', 		    ['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,	['combinable'] = nil,   ['description'] = 'Animal carcass.'},
['redcarcass']					 = {['name'] = 'redcarcass', 			  		['label'] = 'Carcass', 					['weight'] = 1500, 		['type'] = 'item', 		['image'] = 'redcarcass.png', 		    ['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,	['combinable'] = nil,   ['description'] = 'Animal carcass of poached animal.'},
['redcarcass2']					 = {['name'] = 'redcarcass2', 			  		['label'] = 'Carcass', 					['weight'] = 1500, 		['type'] = 'item', 		['image'] = 'redcarcass2.png', 		    ['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,	['combinable'] = nil,   ['description'] = 'Animal carcass of poached animal.'},
['redcarcass3']					 = {['name'] = 'redcarcass3', 			  		['label'] = 'Carcass', 					['weight'] = 1000, 		['type'] = 'item', 		['image'] = 'redcarcass3.png', 		    ['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,	['combinable'] = nil,   ['description'] = 'Animal carcass of poached animal.'},
['mtlionpelt'] 					 = {['name'] = 'mtlionpelt', 			  		['label'] = 'Mtlion Pelt', 				['weight'] = 1500, 		['type'] = 'item', 		['image'] = 'mtlionpelt.png', 		    ['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,	['combinable'] = nil,   ['description'] = 'Pelt of a mountain lion'},
['mtlionfang'] 					 = {['name'] = 'mtlionfang', 			  		['label'] = 'Mtlion Fang', 				['weight'] = 1000, 		['type'] = 'item', 		['image'] = 'mtlionfang.png', 		    ['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,	['combinable'] = nil,   ['description'] = 'The fang of the mighty lion.'},
['coyotepelt'] 					 = {['name'] = 'coyotepelt', 			  		['label'] = 'Coyote Pelt', 				['weight'] = 1500, 		['type'] = 'item', 		['image'] = 'coyotepelt.png', 		    ['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,	['combinable'] = nil,   ['description'] = 'The pelt of a coyote'},
['boarmeat'] 					 = {['name'] = 'boarmeat', 			  			['label'] = 'Boar Meat', 				['weight'] = 1000, 		['type'] = 'item', 		['image'] = 'boarmeat.png', 		    ['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,	['combinable'] = nil,   ['description'] = 'Boar Meat.'},
```

# Weapon for shared
```lua
[`weapon_huntingrifle`] 		= {['name'] = 'weapon_huntingrifle', 	 	['label'] = 'Hunting Rifle', 			['weapontype'] = 'Miscellaneous',	['ammotype'] = 'AMMO_HUNTING',			['damagereason'] = 'Hunting ammo impact.'},
```

# Hunting Ammo useable item in qb-weapons/server/main.lua
```lua
QBCore.Functions.CreateUseableItem('hunting_ammo', function(source, item)
    TriggerClientEvent('weapons:client:AddAmmo', source, 'AMMO_HUNTING', 12, item)
end)
```

# Durability and repair for huntingrifle: qb-weapons/config.lua: 
1) Config.DurabilityMultiplier
```lua
['weapon_huntingrifle']         = 0.08,
```

2) Config.WeaponRepairCotsts
```lua
['hunting'] = 1000,
```

# Weapondraw: qb-smallresources/client/weapdraw.lua:
```lua
'WEAPON_HUNTINGRIFLE',
```

# Recoil: qb-smallresources/client/recoil.lua
```lua
[-1327835241] = 1.0, -- hunting rifle
```

# Radialmenu: add to your Config.MenuItems at the desired location.
```lua
{
    id = 'resethunting',
    title = 'Reset Hunting',
    icon = 'icon', -- change the icon to your liking
    type = 'client',
    event = 'qb-hunting:client:Reset',
    shouldClose = true
},
```

# Add a log for 'hunting' to your logs
```lua
['hunting'] = '',
```

# Weapons for ox_inventory
```lua
['WEAPON_HUNTINGRIFLE'] = {
    label = 'Hunting Rifle',
    weight = 5000,
    durability = 0.5,
    ammoname = 'ammo-hunting'
},
```

# Ammo for ox_inventory
```lua
['ammo-hunting'] = {
    label = '7.62x51 Bonded',
    weight = 9,
},
```