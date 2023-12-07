# Dependencies
- QBCore (latest)
- qb-target https://github.com/qbcore-framework/qb-target
- ps-ui https://github.com/Project-Sloth/ps-ui
- ps-dispatch https://github.com/Project-Sloth/ps-dispatch
- ps-mdt https://github.com/Project-Sloth/ps-mdt
- ps-zones https://github.com/Project-Sloth/ps-zones
- polyzone 

# If you use ps-dispatch 
* ps-dispatch>client>cl_extraalerts.lua

```lua
local function BankTruckRobbery()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "banktruckrobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90",
        firstStreet = locationInfo,
        gender = gender,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = ('Fleeca Truck Robbery'), -- message
        job = {"police"} -- jobs that will get the alerts
    })
end exports('BankTruckRobbery', BankTruckRobbery)
```

* Go to ps-dispatch>server>sv_dispatchcodes.lua

```lua
["banktruckrobbery"] =  {displayCode = '10-90', description = "Fleeca Truck Robbery", radius = 0, recipientList = {'police'}, blipSprite = 67, blipColour = 2, blipScale = 1.5, blipLength = 2, sound = "robberysound", offset = "false"},
```
------------------------------------------------------------------------------------

* Add the images from the images file into your inventory html images
* Add the below lines into your qb-core>shared>item.lua at the bottom
```lua
["hacking-laptop"] 			     		 = {["name"] = "hacking-laptop",				    		["label"] = "Hacking Laptop",			   			["weight"] = 1500,    	["type"] = "item",		["image"] = "hacking-laptop.png",         			["unique"] = true,		["useable"] = true,	    ["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "",								["created"] = nil, 		["decay"] = 1.0 },
	["gps-device"] 			     		 = {["name"] = "gps-device",				    		["label"] = "Gps Device",			   			["weight"] = 1500,    	["type"] = "item",		["image"] = "gps-device.png",         			["unique"] = true,		["useable"] = true,	    ["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "",								["created"] = nil, 		["decay"] = 1.0 },
    
    	["kthermite"] 			 		 = {["name"] = "kthermite",						["label"] = "Thermite",					["weight"] = 500,    	["type"] = "item",		["image"] = "thermite.png",         		["unique"] = true,		["useable"] = true,	    ["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "",				["created"] = nil, 		["decay"] = 1.0 },

```
