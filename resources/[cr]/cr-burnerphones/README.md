# Features
- Order Items with a disposable burner-phone.
- The phone only has a few uses, gets destroyed after 1 / couple of uses.
- The Item received is randomized from a list of items.
- Configurable Cooldown (Global & Local)
- Supports Multiple Phones with their own configurations
- Orders are synced, meaning someone could steal someone else's order.
- Config option to send a suspicious package alert to the police.
- VPN Item to suppress police alert.
- Highly customizable (Pickup location, Picked up Item, Item Prop & Much more)
- Supports Core Dispatch & CD Dispatch
- Supports OkOkNotify & Mythic Notify
- Target & Non Target Version
- Locales File (Complete Translations)
- Supports Multiple Police Jobs

# Dependencies
Either
- [qb-core](https://github.com/qbcore-framework/qb-core)
Or
- [ESX Legacy](https://github.com/esx-framework/esx-legacy)

One version of dpemotes (Not required, but used for the animations)

# Optional Supports
- [ps-ui](https://github.com/Project-Sloth/ps-ui)
- [qb-target](https://github.com/berkiebb/qb-target)
- [okokDrawText] & [okokNotify](https://okok.tebex.io/)
- [mythic_notify](https://github.com/JayMontana36/mythic_notify)
- [nh-context](https://github.com/nerohiro/nh-context)
- [rprogress](https://github.com/Mobius1/rprogress)
- [mythic_progbar](https://github.com/HalCroves/mythic_progbar)
- [oxlib], [ox_inventory], [ox_target](https://github.com/overextended)

# Installation #
-- Add the following code snippets to the files mentionned above them.

## QBCcore Inventories Instalation (qb/lj-inventory)
- Add the following items in `qb-core/shared/items.lua`
- Add the item images in your inventory's `hmtl/images` folder. 

```
	['burnerphone'] = {    ['name'] = 'burnerphone',    ['label'] = 'Burner Phone',    ['weight'] = 150,    ['type'] = 'item',    ['image'] = 'burnerphone.png',    ['unique'] = true,    ['useable'] = true,    ['shouldClose'] = false,    ['combinable'] = nil,    ['description'] = 'Somekind of lost Phone?'},

    ['burnerphonevpn'] = {    ['name'] = 'burnerphonevpn',    ['label'] = 'Soleware VPN',    ['weight'] = 250,    ['type'] = 'item',    ['image'] = 'burnerphonevpn.png',    ['unique'] = true,    ['useable'] = true,    ['shouldClose'] = false,    ['combinable'] = nil,    ['description'] = 'Somekind of lost VPN from Soleware?'},
```

## Ox_Inventory Instalation
- Add the following items in `ox_inventory/data/items.lua`
- Add the item images in `ox_inventory/web/images.lua`.

```
['burnerphone'] = { label = 'Burner Phone', weight = 150, stack = false, close = true, description = 'Somekind of lost Phone?' },

['burnerphonevpn'] = { label = 'Soleware VPN', weight = 250, stack = false, close = true, description = 'Somekind of lost VPN from Soleware?' },
```

## Default ESX Instalation
- Add the items to the database by inserting the items.sql file accordingly

# If using ox_lib | Open the fxmanifest.lua and remove the comments on line 11 to enable ox_lib

# (QBCore) If using Logs --> qb-smallresources/server/logs.lua | Add the following within ```local Webhooks {}```

```
    ['burnerphone'] = 'YOUR_WEBHOOK_HERE',
```

## DPEmotes
- You can change the name of the emote script in cl_framework.lua to your desired script. (All the ones that branch from DPEmotes should be working as intended)

## Project Sloth Dispatch Integration
* If using ps-dispatch --> Add this function in 'ps-dispatch/client/cl_extraalerts.lua'
* You can change the information here to match the your desired configurations.
* If you have multiple police jobs, don't forget to add them all here too.

```
local function CRBurnerphones(coords, tenCode, message, policejobs)

    local currentPos = coords
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "crburnerphones",
        dispatchCode = tenCode,
        firstStreet = locationInfo,
        gender = gender,
        camId = 0,
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
        dispatchMessage = message, -- message
        job = policeJobs -- jobs that will get the alerts
    })
end exports('CRBurnerphones', CRBurnerphones)
```

* You also need to add these lines in ps-dispatch/server/sv_dispatchcodes.lua
    - Be sure to add all of your police jobs in the table.

```
["CRBurnerphones"] =  {displayCode = '911', description = "Suspicious Package Drop Off", radius = 0, recipientList = {'police'}, blipSprite = 207, blipColour = 2, blipScale = 1.5, blipLength = 2, sound = "robberysound"},

```