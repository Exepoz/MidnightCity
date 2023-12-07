# Pug Ownable Coke Business.
For any questions please contact me here: here https://discord.gg/jYZuWYjfvq.
For any of my other scripts you can purchase here: https://pug-webstore.tebex.io/
--

--
# Installation
Run the pug_cokebusiness.sql before doing anything else.
Make sure you have the dependencies installed. (qb-target OR ox_target, qb-inventory OR ox_inventory, qb-menu OR ps-ui OR ox_lib, qb-input OR ps-ui OR ox_lib)
Read through the config.lua thoroughly and adjust everything to match your server. (VERY IMPORTANT)
Adjust the DrugJobNotification() function in open.lua to fit your server (defualt is already setup for base qb-core and esx).
Adjust the DrugJobDrawText() and DrugJobHideText() functions in open.lua to fit your server (defualt is already setup for base qb-core and esx).
Adjust the CallPoliceForDrugPlaneTooHigh() function in open.lua to fit your server.
--

--
# (QBCORE) Add this item to your qb-core/shared/items.lua
['cokelabnote']                        = {['name'] = 'cokelabnote',                          ['label'] = 'Lab Note',           ['weight'] = 1000,          ['type'] = 'item',    ['image'] = 'cokelabnote.png',                ['unique'] = true,          ['useable'] = true,      ['shouldClose'] = true,      ['combinable'] = nil,   ['description'] = 'A Useable note that has some information on it...'},
--
# (ESX) Add this item to your ox_inventory
['cokelabnote'] = {
    label = 'Lab Note',
    weight = 100,
},
--

--
# (ps-dispatch) If you are using ps-dispatch place this in ps-dispatch/client/cl_extraalerts.lua at the very bottom.
local function PlaneTooHigh(vehicle)
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    if vehicle then
        local vehdata = vehicleData(vehicle)
        local currentPos = GetEntityCoords(PlayerPedId())
        local locationInfo = getStreetandZone(currentPos)
        local gender = GetPedGender()
        TriggerServerEvent("dispatch:server:notify",{
            dispatchcodename = "planetoohigh", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
            dispatchCode = "10-60",
            firstStreet = locationInfo,
            gender = gender,
            model = vehdata.name,
            plate = vehdata.plate,
            priority = 2,
            firstColor = vehdata.colour,
            automaticGunfire = false,
            origin = {
                x = currentPos.x,
                y = currentPos.y,
                z = currentPos.z
            },
            dispatchMessage = "Plane flying low and dropping packages...", -- message
            job = {"LEO", "police"} -- type or jobs that will get the alerts
        })
    end
end exports('PlaneTooHigh', PlaneTooHigh)

# (ps-dispatch) If you are using ps-dispatch place this in ps-dispatch/server/sv_dispatchcodes.lua under dispatchCodes.
["planetoohigh"] =  {displayCode = '10-60', description = "Suspicious flight activity", radius = 120.0, recipientList = {'LEO', 'police'}, blipSprite = 307, blipColour = 45, blipScale = 0, blipLength = 2, sound = "Lose_1st", sound2 = "GTAO_FM_Events_Soundset", offset = "true", blipflash = "false"},
--

# Ownable Coke Business. For any questions please contact me here: here https://discord.gg/jYZuWYjfvq.
Ownable Coke Business 1.0.0 release!

PREVIEW HERE: https://youtu.be/iJnzHxUKRv0

​Full QBCore & ESX Compatibility. (supports custom qb-core names and all qb custom file dependency names)

This script is partially locked using escrow encryption. 40% of the script is accessible in client/open.lua, server/server.lua, and config.lua

Readme: 
https://i.imgur.com/Hn9I9Qz.png

Config: 
https://i.imgur.com/wKbcEvJ.png
https://i.imgur.com/0z1KG1S.png

This completely configurable script consist of:
● Full development support and custom script adjustment request support.
● Ownable coke lab and business.
● Every door is a unique laboratory that can be owned by only the first buyer.
● Police raidable coke lab and business.
● Very advanced coke plane drug runs (full coke plane run job).
● Upgradable coke planes with progression (3 planes pre configured).
● Upgradable product creation employees with progression (3 upgrades pre configured).
● Upgradable member slots.
● Multple members can run the business together.
● Custom Laboratory passwords.
● Advanced checks for every feature.
● Passive income/drug production.
● Option to do multiple drug runs at a time.
● Advanced animations and network syncing.
● 30 preconfigured lab location doors already placed around the map and very easily changeable.
● Database table storing and keeping track of important data and information.
● Very extensive config.lua with options to customize everything.
● Custom configurable lang system to support multiple languages.
● Support for other core names, other target systems and any resource name changes.
● Runs at 0.0 ms resmon

Requirements consist of:
QBCore OR ESX (other frameworks will work but not supported)
qb-menu OR ox_lib (ps-ui or any qb-menu resource name changed will work)
qb-target OR ox_target (any qb-inventory resource name changed will work)
qb-inventory OR ox_inventory OR qs-inventory (any qb-inventory resource name changed will work)
OLD (ESX FRAMEWORKS) ARE NOT SUPPORTED (NO REFUNDS WILL BEGRANTED ON THIS SCRIPT)

4,400 LINES OF CODE