# Developed By Constant Development #

Direct Creators: xoraphox#2938 | SixGrams#0544

Constant Development Discord: https://discord.gg/gSQbshCNv4

Constant RolePlay Discord: https://discord.gg/constantroleplay

## Dependencies
- [qb-target](https://github.com/Renewed-Scripts/qb-target)

## Features
* Highly Configurable
* Planned Updates
* NoPixel Inspired Meth Run
* Deliver Goods
    - Bring Goods to a third party to help you bulk sell your meth
    - PickUp Vehicle
    - PickUp Meth Goods
    - Deliver Meth Goods
    - PickUp Reward

## Compatible Dispatch :
- CD Dispatch
- Core Dispatch
- Project Sloth's ps-dispatch
- qb-policecalls
- file is unencrypted, so can add whichever.

## Compatible Notifications :
- qb-notify
- okokNotify
- Mythic Notify
- tnj-notify (Implement their export in qb-core/client/lua by following their README.)
- Chat Messages
- file is unencrypted, so can add whichever.

## Compatible Phones :
- qs-phone
- qb-phone
- gks-phone

## Items Integration 
- qb-core/shared/items.lua | Insert the below snippet
```
    ["outdoorfurniturecleaner"] = {
        ["name"] = "outdoorfurniturecleaner",						
        ["label"] = "Furniture Cleaner",					
        ["weight"] = 150,		
        ["type"] = "item",		
        ["image"] = "outdoorfurniturecleaner.png",		
        ["unique"] = false, 	
        ["useable"] = true,	
        ["shouldClose"] = false,	
        ["combinable"] = nil,	
        ["description"] = "Outdoor Furniture Cleaner | Handle with Care" 
    },
```
- (qb/lj)-inventory/html/images | Insert the ```outdoorfurniturecleaner.png```

---------------------------------------------------------------------------------------------------

## Project Sloth Dispatch Integration
* If using ps-dispatch --> Add this function in 'ps-dispatch/client/cl_extraalerts.lua'
* You can change the information here to match the your desired configurations.
* If you have multiple police jobs, don't forget to add them all here too.
```
local function MethRun(vehicle, jobs)
    local vehdata = vehicleData(vehicle)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "crmethrun", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "911",
        firstStreet = locationInfo,
        gender = gender,
        model = vehdata.name,
        plate = vehdata.plate,
        priority = 2, -- priority
        firstColor = vehdata.colour,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Security Car Automatic Distress Signal", -- message
        job = jobs -- jobs that will get the alerts
    })
end exports('MethRun', MethRun)
```

* You also need to add this line in ps-dispatch/server/sv_dispatchcodes.lua

```
["crmethrun"] =  {displayCode = '911', description = "Stolen Security Car", radius = 0, recipientList = {'police'}, blipSprite = 676, blipColour = 2, blipScale = 1.5, blipLength = 2, sound = "robberysound"},
```