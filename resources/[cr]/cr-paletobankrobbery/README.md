# Developed By Constant Development

Direct Creators: xoraphox#2938

Constant Development Discord : https://discord.gg/5Trc4nEuga

# Supports :
- QBCORE, ESX, (Open Framework Files, can be fully customized)
- OxLib, OxInv, OxTarget
- Target & Non-Target (TextUI/DrawText, Requires ox_lib) Versions
- Languages : Locales folder. Feel free to send yours! 
- Notifications : qbNotify / okokNotify / OxLib / ESX Mythic / Chat message (File Unencrypted so any custom can be set)
- DrawText : qb-core (native) & okokDrawText / OxLib / ESX (File Unencrypted so any custom can be set)
- QBCore Logs (File Unencrypted so any custom can be set)
- Open to any requests for additional supports.

# Dependencies
* Either QBCore or ESX Extended
    - [qb-core](https://github.com/qbcore-framework/qb-core)
    - [esx_core](https://github.com/esx-framework/esx_core)
* xSound ['xsound'](https://github.com/Xogy/xsound)
* oxlib [ox_lib](https://github.com/overextended/ox_lib)
* K4MB1's Free Drills (https://www.k4mb1maps.com/package/5043926)
* One of 4 :
    - NoPixel Inspired Bank Hack (https://github.com/Nathan-FiveM/NoPixel-minigame/tree/main/fivem-script/hacking) <- Recommended (With Configuration) (https://github.com/Jesper-Hustad/NoPixel-minigame)
    - NoPixel Inspired VAR HAck (https://github.com/JoeSzymkowiczFiveM/varhack) or PS-UI (https://github.com/Project-Sloth/ps-ui) 
    - Dimbo Pass Hack (https://dimbo-scripts.tebex.io/package/4616362)
    - mHacking (https://github.com/justgreatgaming/FiveM-Scripts-2)
    - You can use any hack that you want, just need to be added in the framework file
Every single resource dependent function & event are accessible through the framework and extras files.

* ESX Requires either PS-UI or ox_lib to function. You can also change any external resource dependant function

# Commands
Commands (When Config.DevMode is set to true)
- `/setuppaletobank` Used to Spawn the loot inside the Bank Vault
- `/resetpaletobank` Use to manually reset the bank

---

Credits to meta-hub for the drilling.lua file. They made the mixture of:
- meta_libs - https://github.com/meta-hub/meta_libs/releases
- fivem-drilling - https://github.com/meta-hub/fivem-drilling

I'd also like to thank Renewed Scripts for they have inspired me to make bank robberies and some of the code used in this resource is inspired by their bank robberies.

The Locales Configuration has also been inspired from CodeDesign, with our own small change.

## Installation Instructions:

# Xsound Changes
- Add the `phoneringing.ogg` file from the sounds folder and place it in `xsound/html/sounds` (If the folder doesn't exist, simply create it)

# Inventory Changes
- Add Proper PNGs within "Images" to qb-inventory/html/imgaes
    - Whatever Inventory you use, is where you'd place the Images into

- Add the following snippet in your qb/lj-inventory\html\js\app.js in the FormatItemInfo() function. (Search for "harness" and place it below it.)
- Make sure you don't already have them.

* For qb-inventory :
```
else if (itemData.name == "printed_document") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html("<p>" + itemData.info.label + "</p>");
}   else if (itemData.name == "stickynote") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html("<p>" + itemData.info.label + "</p>");
}
```
* For lj-inventory :
```
else if (itemData.name == "printed_document") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html("<p>" + itemData.info.label + "</p><p style=\"font-size:11px\"><b>Weight: </b>" + itemData.weight + " | <b>Amount: </b> " + itemData.amount + " | <b>Quality: </b> " + "<a style=\"font-size:11px;color:green\">" + Math.floor(itemData.info.quality) + "</a>");
}   else if (itemData.name == "stickynote") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html("<p>" + itemData.info.label + "</p><p style=\"font-size:11px\"><b>Weight: </b>" + itemData.weight + " | <b>Amount: </b> " + itemData.amount + " | <b>Quality: </b> " + "<a style=\"font-size:11px;color:green\">" + Math.floor(itemData.info.quality) + "</a>");
}
        
```   

# Add the Following Items to qb-core/shared/items.lua (Some might be duplicates that you already have)

```
    ['drill'] = { ['name'] = 'drill', ['label'] = 'Drill', ['weight'] = 2000, ['type'] = 'item', ['ammotype'] = nil, ['image'] = 'drill.png', ['unique'] = true, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'The real deal...' },

    ['printed_document'] = { ['name'] = 'printed_document', ['label'] = 'Printed Document', ['weight'] = 850, ['type'] = 'item', ['ammotype'] = nil, ['image'] = 'printed_document.png', ['unique'] = true, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'A printed paper with some writing on it' },

    ['crpaleto_usb'] = { ['name'] = 'crpaleto_usb', ['label'] = 'Paleto Bank USB', ['weight'] = 650, ['type'] = 'item', ['ammotype'] = nil, ['image'] = 'crpaleto_usb.png', ['unique'] = true, ['useable'] = true, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'USB Device with the Blain County Bank logo.' },

    ['crpaleto_officekey'] = { ['name'] = 'crpaleto_officekey', ['label'] = 'Office Key', ['weight'] = 850, ['type'] = 'item', ['ammotype'] = nil, ['image'] = 'crpaleto_key.png', ['unique'] = true, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'A key to some office.' },

    ['crpaleto_managerkey'] = { ['name'] = 'crpaleto_managerkey', ['label'] = 'Managers Key', ['weight'] = 850, ['type'] = 'item', ['ammotype'] = nil, ['image'] = 'crpaleto_key.png', ['unique'] = true, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'A key to some office.' },

    ['crpaleto_keycard'] = { ['name'] = 'crpaleto_keycard', ['label'] = 'Paleto Bank Keycard', ['weight'] = 850, ['type'] = 'item', ['ammotype'] = nil, ['image'] = 'crpaleto_keycard.png', ['unique'] = true, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'A key to some office.' },

    ['crpaleto_explosives'] = { ['name'] = 'crpaleto_explosives', ['label'] = 'Homemade Explosives', ['weight'] = 850, ['type'] = 'item', ['ammotype'] = nil, ['image'] = 'crpaleto_explosives.png', ['unique'] = true, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'Some hand-crafted low-yield explosive.' },

    ['powersaw'] = {    ['name'] = 'powersaw',    ['label'] = 'Power Saw',    ['weight'] = 150,    ['type'] = 'item',    ['image'] = 'powersaw.png',    ['unique'] = true,    ['useable'] = true,    ['shouldClose'] = false,    ['combinable'] = nil,    ['description'] = 'Great Quality Saw for all purposes'},

    ['brokenpowersaw'] = {    ['name'] = 'brokenpowersaw',    ['label'] = 'Bladeless Power Saw',    ['weight'] = 150,    ['type'] = 'item',    ['image'] = 'brokenpowersaw.png',    ['unique'] = true,    ['useable'] = true,    ['shouldClose'] = false,    ['combinable'] = {accept = {'sawblade'}, reward = 'powersaw', anim = {['dict'] = 'anim@amb@business@weed@weed_inspecting_high_dry@', ['lib'] = 'weed_inspecting_high_base_inspector', ['text'] = 'Installing New Blade..', ['timeOut'] = 10000}},    ['description'] = 'A Power Saw, but without the Saw Blade...'},

    ['sawblade'] = {    ['name'] = 'sawblade',    ['label'] = 'Saw Blade',    ['weight'] = 150,    ['type'] = 'item',    ['image'] = 'sawblade.png',    ['unique'] = false,    ['useable'] = true,    ['shouldClose'] = false,    ['combinable'] = nil,    ['description'] = 'A singular Saw Blade'},

    ['crpaleto_mounteddrill'] = {    ['name'] = 'crpaleto_mounteddrill',    ['label'] = 'Mounted Drill',    ['weight'] = 10000,    ['type'] = 'item',    ['image'] = 'mounteddrill.png',    ['unique'] = false,    ['useable'] = true,    ['shouldClose'] = false,    ['combinable'] = nil,    ['description'] = 'You can pierce through pretty heavy stuff with this'},


```

# DoorLocks
* You can use the provided doorlock configs.
* If you do not wish to use the provided config file, you need to add the appropriate door hash to the Config.

# Items needed for the heists.
* You will need to provide your players with a way to acquire these items in order to complete the heist :
    - `crpaleto_usb` ~ Used to hack into the computers to receive the vault codes (Usually received from fleeca banks rewards)
    - `crpaleto_keycard`  ~ Used to access the side/back corridor in order to start the second heist.
    - `powersaw` ~ Used to break the deposit boxes in the corridor. (Item also used in my cr_salvage script)
    - `sawblade` ~ Used to repair the powersaw in case it breaks. (Item also used in my cr_salvage script)
    - `crpaleto_mounteddrill` ~ Used to break into the safe for the second.
    - `crpaleto_explosives` ~ (K4MB1 Extended Only) Used to access the safe for the second heist.

---
# Optional Stuff :

##  If using qb-logs, add the Following to qb-smallresources/server/logs.lua

['paletobankrobbery'] = 'Your_Webhook_Here', -- Change "Your_Webhook_Here" to your Proper Discord Webhook

## If you are using qb-scoreboard, add this in qb-scoreboard/config.lua
  
["paletobankrobbery"] = {
        minimumPolice = 3, -- Set this as the desired police amount you have set in the config file.
        busy = false, -- Do not touch this
        label = "Paleto Bank Robbery"
    },

---

## Project Sloth Dispatch Integration
* If using ps-dispatch --> Add this function in 'ps-dispatch/client/cl_extraalerts.lua'
* You can change the information here to match the your desired configurations.
* If you have multiple police jobs, don't forget to add them all here too.

```
local function CRPaletoBankRobbery(tenCode, message, policeJobs, camId)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "crpaletobankrobbery",
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
end exports('CRPaletoBankRobbery', CRPaletoBankRobbery)
```

* You also need to add these lines in ps-dispatch/server/sv_dispatchcodes.lua
    - Be sure to add all of your police jobs in the table.

```
["crpaletobankrobbery"] =  {displayCode = '10-90', description = "Paleto Bank Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 108, blipColour = 2, blipScale = 1.5, blipLength = 2, sound = "robberysound"},

```

---

# NoPixel Hacking Minigame Installation.
* You should use Nathan's Fork to Jesper-Hustad's NoPixel Number/Color minigame. It allows for easy configuration of the hack difficulty.


