# Developed By Constant Development

Direct Creators: xoraphox#2938

Constant Development Discord : https://discord.gg/5Trc4nEuga

# Supports
- QBCORE, ESX, (Open Framework Files, can be fully customized)
- OxLib, OxInv, OxTarget
- Target & Non-Target (TextUI/DrawText) Versions
- Languages : Locales folder. Feel free to send yours! 
- Notifications : qbNotify / okokNotify / OxLib / ESX Mythic / Chat message (File Unencrypted so any custom can be set)
- DrawText : qb-core (native) & okokDrawText / OxLib / ESX (File Unencrypted so any custom can be set)
- Menu : qb-menu / nh-context / OxLib / ESX
- Logs.
- Open to any requests for additional supports.

# Dependencies
Either QBCore or ESX Extended
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [esx_core](https://github.com/esx-framework/esx_core)
* One of 4 :
    - NoPixel Inspired Bank Hack (https://github.com/Nathan-FiveM/NoPixel-minigame/tree/main/fivem-script/hacking) <- Recommended (With Configuration) (https://github.com/Jesper-Hustad/NoPixel-minigame)
    - NoPixel Inspired VAR HAck (https://github.com/JoeSzymkowiczFiveM/varhack) or PS-UI (https://github.com/Project-Sloth/ps-ui) 
    - Dimbo Pass Hack (https://dimbo-scripts.tebex.io/package/4616362)
    - mHacking (https://github.com/justgreatgaming/FiveM-Scripts-2)
    - You can use any hack that you want, just need to be added in the framework file
Every single resource dependent function & event are accessible through the framework and extras files.

* ESX Requires either PS-UI or ox_lib to function. You can also change any external resource dependant function 

# Optional Supports
- [ps-ui](https://github.com/Project-Sloth/ps-ui)
- [qb-target](https://github.com/berkiebb/qb-target)
- [okokDrawText] & [okokNotify](https://okok.tebex.io/)
- [mythic_notify](https://github.com/JayMontana36/mythic_notify)
- [oxlib], [ox_inventory], [ox_target](https://github.com/overextended)

## Commands
- Commands (When Config.DevMode is set to true)
* `/setupbank` Used to Spawn the loot inside the closest bank
* `/resetbanks` Use to manually reset the banks (Cops don't need to)

## Additional Info
- This script uses LocalPlayer.state.inv_busy to check if the player is busy. You can add a check to your scripts to check this player state and stop your players from doing unintended actions when they're robbing a bank (ie. Put their handsup with qb-smallresources/handsup)

---

Credits to meta-hub for the drilling.lua file. They made the mixture of:
- meta_libs - https://github.com/meta-hub/meta_libs/releases
- fivem-drilling - https://github.com/meta-hub/fivem-drilling

I'd also like to thank Renewed Scripts for they have inspired me to make bank robberies.

The Locales Configuration & Version Checker has also been inspired from CodeDesign, with our own small changes.

# Installation Instructions:
- Drag the cr-fleecabankrobbery folder in your server's `/resources` fodler.
- Ensure cr-fleecabankrobbery in your server.cfg

## QBCcore Inventories Instalation (qb/lj-inventory)
- Add the item images in your inventory's `hmtl/images` folder. 
- Add the following items in `qb-core/shared/items.lua`
    ```
        ['drill'] = { ['name'] = 'drill', ['label'] = 'Drill', ['weight'] = 2000, ['type'] = 'item', ['ammotype'] = nil, ['image'] = 'drill.png', ['unique'] = true, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'The real deal...' },

        ['usb_fleeca'] = { ['name'] = 'usb_fleeca', ['label'] = 'Fleeca Bank USB', ['weight'] = 650, ['type'] = 'item', ['ammotype'] = nil, ['image'] = 'usb_fleeca.png', ['unique'] = true, ['useable'] = true, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'USB Device containing malicious codes...' },

        ['crfleecacard'] = { ['name'] = 'crfleecacard', ['label'] = 'Fleeca Bank Security Card', ['weight'] = 850, ['type'] = 'item', ['ammotype'] = nil, ['image'] = 'crfleecacard.png', ['unique'] = true, ['useable'] = true, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'A security card relating to Fleeca Banks.' },

        ['printed_document'] = { ['name'] = 'printed_document', ['label'] = 'Printed Document', ['weight'] = 850, ['type'] = 'item', ['ammotype'] = nil, ['image'] = 'printed_document.png', ['unique'] = true, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'A printed paper with some writing on it' },

        (For Gabz MLO Only)
        	['powersaw'] = {    ['name'] = 'powersaw',    ['label'] = 'Power Saw',    ['weight'] = 150,    ['type'] = 'item',    ['image'] = 'powersaw.png',    ['unique'] = true,    ['useable'] = true,    ['shouldClose'] = false,    ['combinable'] = nil,    ['description'] = 'Great Quality Saw for all purposes'},
    ```

- Add the following snippet in your qb/lj-inventory\html\js\app.js in the FormatItemInfo() function. (Search for "stickynote" and place it below it.)
* For qb-inventory :
    ```
    }  else if (itemData.name == "printed_document") {
                $(".item-info-title").html("<p>" + itemData.label + "</p>");
                $(".item-info-description").html("<p>" + itemData.info.label + "</p>");
            }
    ```
* For lj-inventory :
    ```
    } else if (itemData.name == "printed_document") {
                $(".item-info-title").html("<p>" + itemData.label + "</p>");
                $(".item-info-description").html("<p>" + itemData.info.label + "</p><p style=\"font-size:11px\"><b>Weight: </b>" + itemData.weight + " | <b>Amount: </b> " + itemData.amount + " | <b>Quality: </b> " + "<a style=\"font-size:11px;color:green\">" + Math.floor(itemData.info.quality) + "</a>");
            
    ```

## Ox_Inventory Instalation
- Add the item images in `ox_inventory/web/images.lua`.
- Add the following items in `ox_inventory/data/items.lua`
    ```
    ['drill'] = { label = 'Drill', weight = 2000, stack = false, close = true, description = 'The real deal...' },

    ['usb_fleeca'] = { label = 'Fleeca Bank USB', weight = 650, stack = false, close = true, description = 'USB Device containing malicious codes...' },

    ['crfleecacard'] = { label = 'Fleeca Bank Security Card', weight = 850, stack = false, close = true, description = 'A security card relating to Fleeca Banks.' },

    ['printed_document'] = { label = 'Printed Document', weight = 200, stack = false, close = true, description = 'A printed paper with some writing on it' },

    (For Gabz MLO Only)
        ['powersaw'] = { label = 'Power Saw', weight = 150, stack = false, close = true, description = 'Great Quality Saw for all purposes' },
    ```

## Default ESX Instalation
- Add the items to the database by inserting the items.sql file accordingly
- While All the framework dependent functions are open, you may need to edit them to suit your own version of ESX and or your own resources. This is NOT a drag & drop resource!

## DoorLocks
* You can use the provided doorlock configs.
* If you do not wish to use the provided config file, you need to add the appropriate door hash to the Config.
* ox_doorlocks : You need to input your own door ids in the configuration to for it to work. 

## Player Busy Export
* !!! THE EXPORT IS NOT USED ANYMORE. YOU CAN SIMPLY USE `LocalPlayer.state.inv_busy` INSTEAD OF THE EXPORT AND IT WILL DO THE SAME THING. !!!
* !!! IF YOU STILL HAVE THE EXPORT WITHIN QB-SMALLRESOURCES, IT WILL CAUSE ERRORS!
* If your players can press keybinds which activate a certain animation or event (ie. Handsup (x), you can use this export to stop the specific action from happening)
    - Example for qb-smallresources/client/handsup.lua (Around line 8, at the begginging of the RegisterCommand)
    - DO NOT USE THIS ` if exports['cr-fleecabankrobbery']:isPlayerBusy() then return end ` THIS IS DEPRECATED
    - USE THIS : `LocalPlayer.state.inv_busy`

---
# Optional Stuff :

##  If using qb-logs, add the Following to qb-smallresources/server/logs.lua

['fleecabankrobbery'] = 'Your_Webhook_Here', -- Change "Your_Webhook_Here" to your Proper Discord Webhook

## If you are using qb-scoreboard, add this in qb-scoreboard/config.lua
  
["fleecabanks"] = {
        minimumPolice = 3, -- Set this as the desired police amount you have set in the config file.
        busy = false, -- Do not touch this
        label = "Fleeca Banks Robbery"
    },

---

## Project Sloth Dispatch Integration
* If using ps-dispatch --> Add this function in 'ps-dispatch/client/cl_extraalerts.lua'
* You can change the information here to match the your desired configurations.
* If you have multiple police jobs, don't forget to add them all here too.

```
local function CRFleecaBankRobbery(tenCode, message, policeJobs, camId)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "crfleecabankrobbery",
        dispatchCode = tenCode,
        firstStreet = locationInfo,
        gender = gender,
        camId = camId,
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
end exports('CRFleecaBankRobbery', CRFleecaBankRobbery)
```

* You also need to add these lines in ps-dispatch/server/sv_dispatchcodes.lua
    - Be sure to add all of your police jobs in the table.

```
["crfleecabankrobbery"] =  {displayCode = '10-90', description = "Fleeca Bank Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 108, blipColour = 2, blipScale = 1.5, blipLength = 2, sound = "robberysound"},

```

---

# NoPixel Hacking Minigame Installation.
* You should use Nathan's Fork to Jesper-Hustad's NoPixel Number/Color minigame. It allows for easy configuration of the hack difficulty.


