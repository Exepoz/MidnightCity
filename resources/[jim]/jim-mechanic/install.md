If you purchased this anywhere other than my Tebex page you have purchased a leak and supported thieves.

If you need support I now have a discord available, it helps me keep track of issues and give better support.

https://discord.gg/xKgQZ6wZvS

Full Credit to wildbrick142 for the inclusion of the Chameleon Paint Mod

# INSTALLATION

## Add the script to the server resources
- I highly recommend putting the `jim-mechanic` folder in a new folder called `[jim]`
- Then add `ensure [jim]` AFTER your other scripts in your server.cfg

---
# Item installation
- Add the image files from the zip to your `qb-inventory > html > images` folder

- Add these lines to your qb-core > shared lua under the Items section
```lua
--Jim-Mechanic Vehicles
	["mechanic_tools"] =    {["name"] = "mechanic_tools",   ["label"] = "Mechanic tools",		["weight"] = 0, ["type"] = "item",  ["image"] = "mechanic_tools.png",   ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "Needed for vehicle repairs"},
	["toolbox"] =           {["name"] = "toolbox",          ["label"] = "Toolbox",				["weight"] = 0, ["type"] = "item",  ["image"] = "toolbox.png",          ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "Needed for Performance part removal"},
	["ducttape"] =          {["name"] = "ducttape",         ["label"] = "Duct Tape",			["weight"] = 0, ["type"] = "item",  ["image"] = "bodyrepair.png",       ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "Good for quick fixes"},
	["mechboard"] =         {["name"] = "mechboard",        ["label"] = "Mechanic Sheet",		["weight"] = 0, ["type"] = "item",  ["image"] = "mechboard.png",        ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},

	--Performance
	["turbo"] =             {["name"] = "turbo",            ["label"] = "Supercharger Turbo",	["weight"] = 0, ["type"] = "item",  ["image"] = "turbo.png",            ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "Who doesn't need a 65mm Turbo??"},
	["car_armor"]=          {["name"] = "car_armor",		["label"] = "Vehicle Armor",		["weight"] = 0, ["type"] = "item",  ["image"] = "car_armour.png",           ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},

	["nos"]=                {["name"] = "nos",				["label"] = "NOS Bottle",			["weight"] = 0, ["type"] = "item",  ["image"] = "nos.png",              ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "A full bottle of NOS"},
	["noscan"]=             {["name"] = "noscan",			["label"] = "Empty NOS Bottle",		["weight"] = 0, ["type"] = "item",  ["image"] = "noscan.png",           ["unique"] = false, ["useable"] = true, ["shouldClose"] = true, ["description"] = "An Empty bottle of NOS"},
	["noscolour"]=          {["name"] = "noscolour",		["label"] = "NOS Colour Injector",	["weight"] = 0, ["type"] = "item",  ["image"] = "noscolour.png", 		["unique"] = false, ["useable"] = true, ["shouldClose"] = true, ["description"] = "Make that purge spray"},

	["engine1"]=            {["name"] = "engine1",			["label"] = "Tier 1 Engine",		["weight"] = 0, ["type"] = "item",  ["image"] = "engine1.png",          ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["engine2"]=            {["name"] = "engine2",			["label"] = "Tier 2 Engine",		["weight"] = 0, ["type"] = "item",  ["image"] = "engine2.png",          ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["engine3"]=            {["name"] = "engine3",			["label"] = "Tier 3 Engine",		["weight"] = 0, ["type"] = "item",  ["image"] = "engine3.png",          ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["engine4"]=            {["name"] = "engine4",			["label"] = "Tier 4 Engine",		["weight"] = 0, ["type"] = "item",  ["image"] = "engine4.png",          ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["engine5"]=            {["name"] = "engine5",			["label"] = "Tier 5 Engine",		["weight"] = 0, ["type"] = "item",  ["image"] = "engine5.png",          ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},

	["transmission1"]=      {["name"] = "transmission1",    ["label"] = "Tier 1 Transmission",	["weight"] = 0, ["type"] = "item",  ["image"] = "transmission1.png",    ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["transmission2"]=      {["name"] = "transmission2",	["label"] = "Tier 2 Transmission",	["weight"] = 0, ["type"] = "item",  ["image"] = "transmission2.png",    ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["transmission3"]=      {["name"] = "transmission3",    ["label"] = "Tier 3 Transmission",	["weight"] = 0, ["type"] = "item",  ["image"] = "transmission3.png",    ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["transmission4"]=      {["name"] = "transmission4",	["label"] = "Tier 4 Transmission",	["weight"] = 0, ["type"] = "item",  ["image"] = "transmission4.png",    ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},

	["brakes1"]=            {["name"] = "brakes1",			["label"] = "Tier 1 Brakes",		["weight"] = 0, ["type"] = "item",  ["image"] = "brakes1.png",          ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["brakes2"]=            {["name"] = "brakes2",			["label"] = "Tier 2 Brakes",		["weight"] = 0, ["type"] = "item",  ["image"] = "brakes2.png",          ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["brakes3"]=            {["name"] = "brakes3",			["label"] = "Tier 3 Brakes",		["weight"] = 0, ["type"] = "item",  ["image"] = "brakes3.png",          ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},

	["suspension1"]=        {["name"] = "suspension1",		["label"] = "Tier 1 Suspension",	["weight"] = 0, ["type"] = "item",  ["image"] = "suspension1.png",      ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["suspension2"]=        {["name"] = "suspension2",		["label"] = "Tier 2 Suspension",	["weight"] = 0, ["type"] = "item",  ["image"] = "suspension2.png",      ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["suspension3"]=        {["name"] = "suspension3",		["label"] = "Tier 3 Suspension",	["weight"] = 0, ["type"] = "item",  ["image"] = "suspension3.png",      ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["suspension4"]=        {["name"] = "suspension4",		["label"] = "Tier 4 Suspension",	["weight"] = 0, ["type"] = "item",  ["image"] = "suspension4.png",      ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["suspension5"]=        {["name"] = "suspension5",		["label"] = "Tier 5 Suspension",	["weight"] = 0, ["type"] = "item",  ["image"] = "suspension5.png",      ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},

	["bprooftires"]=        {["name"] = "bprooftires",		["label"] = "Bulletproof Tires",	["weight"] = 0, ["type"] = "item",  ["image"] = "bprooftires.png",      ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["drifttires"]=         {["name"] = "drifttires",		["label"] = "Drift Tires",			["weight"] = 0, ["type"] = "item",  ["image"] = "drifttires.png",       ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},

	["oilp1"]=              {["name"] = "oilp1",			["label"] = "Tier 1 Oil Pump",		["weight"] = 0, ["type"] = "item",  ["image"] = "oilp1.png",            ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["oilp2"]=              {["name"] = "oilp2",			["label"] = "Tier 2 Oil Pump",		["weight"] = 0, ["type"] = "item",  ["image"] = "oilp2.png",            ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["oilp3"]=              {["name"] = "oilp3",			["label"] = "Tier 3 Oil Pump",		["weight"] = 0, ["type"] = "item",  ["image"] = "oilp3.png",            ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},

	["drives1"]=            {["name"] = "drives1",			["label"] = "Tier 1 Drive Shaft",	["weight"] = 0, ["type"] = "item",  ["image"] = "drives1.png",          ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["drives2"]=            {["name"] = "drives2",			["label"] = "Tier 2 Drive Shaft",	["weight"] = 0, ["type"] = "item",  ["image"] = "drives2.png",          ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["drives3"]=            {["name"] = "drives3",			["label"] = "Tier 3 Drive Shaft",	["weight"] = 0, ["type"] = "item",  ["image"] = "drives3.png",          ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},

	["cylind1"]=            {["name"] = "cylind1",			["label"] = "Tier 1 Cylinder Head",	["weight"] = 0, ["type"] = "item",  ["image"] = "cylind1.png",          ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["cylind2"]=            {["name"] = "cylind2",			["label"] = "Tier 2 Cylinder Head",	["weight"] = 0, ["type"] = "item",  ["image"] = "cylind2.png",          ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["cylind3"]=            {["name"] = "cylind3",			["label"] = "Tier 3 Cylinder Head",	["weight"] = 0, ["type"] = "item",  ["image"] = "cylind3.png",          ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},

	["cables1"]=            {["name"] = "cables1",			["label"] = "Tier 1 Battery Cables",["weight"] = 0, ["type"] = "item",  ["image"] = "cables1.png",          ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["cables2"]=            {["name"] = "cables2",			["label"] = "Tier 2 Battery Cables",["weight"] = 0, ["type"] = "item",  ["image"] = "cables2.png",          ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["cables3"]=            {["name"] = "cables3",			["label"] = "Tier 3 Battery Cables",["weight"] = 0, ["type"] = "item",  ["image"] = "cables3.png",          ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},

	["fueltank1"]=          {["name"] = "fueltank1",		["label"] = "Tier 1 Fuel Tank",     ["weight"] = 0, ["type"] = "item",  ["image"] = "fueltank1.png",        ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["fueltank2"]=          {["name"] = "fueltank2",		["label"] = "Tier 2 Fuel Tank",     ["weight"] = 0, ["type"] = "item",  ["image"] = "fueltank2.png",        ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["fueltank3"]=          {["name"] = "fueltank3",		["label"] = "Tier 3 Fuel Tank",     ["weight"] = 0, ["type"] = "item",  ["image"] = "fueltank3.png",        ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},

	["antilag"]=            {["name"] = "antilag",		    ["label"] = "AntiLag",              ["weight"] = 0, ["type"] = "item",  ["image"] = "antiLag.png",          ["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},

	--Cosmetics
	["underglow_controller"]={["name"] = "underglow_controller",["label"] = "Neon Controller",	["weight"] = 0, ["type"] = "item",  ["image"] = "underglow_controller.png", ["unique"] = false, ["useable"] = true, ["shouldClose"] = true, ["description"] = "RGB LED Vehicle Remote"},
	["headlights"]=         {["name"] = "headlights",       ["label"] = "Xenon Headlights",		["weight"] = 0, ["type"] = "item",  ["image"] = "headlights.png",       ["unique"] = true, 	["useable"] = true, ["shouldClose"] = true, ["description"] = "8k HID headlights"},
	--["underglow"]=          {["name"] = "underglow",        ["label"] = "Vehicle Underglow",    ["weight"] = 0, ["type"] = "item",  ["image"] = "underglow.png",       ["unique"] = true, 	["useable"] = true, ["shouldClose"] = true, ["description"] = ""},

	["tint_supplies"]=      {["name"] = "tint_supplies",    ["label"] = "Tint Supplies",		["weight"] = 0, ["type"] = "item",  ["image"] = "tint_supplies.png",    ["unique"] = false, ["useable"] = true, ["shouldClose"] = true, ["description"] = "Supplies for window tinting"},

	["customplate"]=        {["name"] = "customplate",      ["label"] = "Customized Plates",	["weight"] = 0, ["type"] = "item",  ["image"] = "plate.png", 			["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["hood"]=               {["name"] = "hood",             ["label"] = "Vehicle Hood",			["weight"] = 0, ["type"] = "item",  ["image"] = "hood.png", 			["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["roof"]=               {["name"] = "roof",             ["label"] = "Vehicle Roof",			["weight"] = 0, ["type"] = "item",  ["image"] = "roof.png", 			["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["spoiler"]=            {["name"] = "spoiler",          ["label"] = "Vehicle Spoiler",		["weight"] = 0, ["type"] = "item",  ["image"] = "spoiler.png", 			["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["bumper"]=             {["name"] = "bumper",           ["label"] = "Vehicle Bumper",		["weight"] = 0, ["type"] = "item",  ["image"] = "bumper.png", 			["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["skirts"]=             {["name"] = "skirts",           ["label"] = "Vehicle Skirts",		["weight"] = 0, ["type"] = "item",  ["image"] = "skirts.png", 			["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["exhaust"]=            {["name"] = "exhaust",          ["label"] = "Vehicle Exhaust",		["weight"] = 0, ["type"] = "item",  ["image"] = "exhaust.png", 			["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["seat"]=               {["name"] = "seat",             ["label"] = "Seat Cosmetics",		["weight"] = 0, ["type"] = "item",  ["image"] = "seat.png", 			["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["rollcage"]=           {["name"] = "rollcage",         ["label"] = "Roll Cage",			["weight"] = 0, ["type"] = "item",  ["image"] = "rollcage.png", 		["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},

	["rims"]=               {["name"] = "rims",             ["label"] = "Custom Wheel Rims",	["weight"] = 0, ["type"] = "item",  ["image"] = "rims.png", 			["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},

	["livery"]=             {["name"] = "livery",           ["label"] = "Livery Roll",			["weight"] = 0, ["type"] = "item",  ["image"] = "livery.png", 			["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["paintcan"]=           {["name"] = "paintcan",         ["label"] = "Vehicle Spray Can",	["weight"] = 0, ["type"] = "item",  ["image"] = "spraycan.png", 		["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["tires"]=              {["name"] = "tires",            ["label"] = "Drift Smoke Tires",	["weight"] = 0, ["type"] = "item",  ["image"] = "tires.png", 	  		["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},

	["horn"]=               {["name"] = "horn",             ["label"] = "Custom Vehicle Horn",	["weight"] = 0, ["type"] = "item",  ["image"] = "horn.png", 			["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},

	["internals"] =         {["name"] = "internals",        ["label"] = "Internal Cosmetics",	["weight"] = 0, ["type"] = "item",  ["image"] = "internals.png", 		["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["externals"] =         {["name"] = "externals",        ["label"] = "Exterior Cosmetics",	["weight"] = 0, ["type"] = "item",  ["image"] = "mirror.png", 			["unique"] = true,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},

	--Repair Parts
	["newoil"] =            {["name"] = "newoil",           ["label"] = "Car Oil",				["weight"] = 0, ["type"] = "item",  ["image"] = "caroil.png",           ["unique"] = false, ["useable"] = false,["shouldClose"] = false,["description"] = ""},
	["sparkplugs"]=         {["name"] = "sparkplugs",       ["label"] = "Spark Plugs",			["weight"] = 0, ["type"] = "item",  ["image"] = "sparkplugs.png",       ["unique"] = false, ["useable"] = false,["shouldClose"] = false,["description"] = ""},
	["carbattery"]=         {["name"] = "carbattery",       ["label"] = "Car Battery",			["weight"] = 0, ["type"] = "item",  ["image"] = "carbattery.png",       ["unique"] = false, ["useable"] = false,["shouldClose"] = false,["description"] = ""},
	["axleparts"]=          {["name"] = "axleparts",        ["label"] = "Axle Parts",			["weight"] = 0, ["type"] = "item",  ["image"] = "axleparts.png",        ["unique"] = false, ["useable"] = false,["shouldClose"] = false,["description"] = ""},
	["sparetire"]=          {["name"] = "sparetire",        ["label"] = "Spare Tire",			["weight"] = 0, ["type"] = "item",  ["image"] = "sparetire.png",        ["unique"] = true,  ["useable"] = false,["shouldClose"] = false,["description"] = ""},
	["enginekit"]=          {["name"] = "enginekit",        ["label"] = "Engine Parts",			["weight"] = 0, ["type"] = "item",  ["image"] = "enginekit.png",        ["unique"] = true,  ["useable"] = false,["shouldClose"] = false,["description"] = ""},
	["bodykit"]=          {["name"] = "bodykit",        ["label"] = "Body Parts",			    ["weight"] = 0, ["type"] = "item",  ["image"] = "bodykit.png",        ["unique"] = true,  ["useable"] = false,["shouldClose"] = false,["description"] = ""},
```

----------------------
# Dependancies

`jim-payments`
- This script is designed to use `jim-payments` (https://github.com/jimathy/jim-payments) for charging customs and sending money to the society accounts

`jim-jobgarage`
- This script makes us of `jim-jobgarage` (https://github.com/jimathy/jim-jobgarage) for creating temporary vehicles for job roles


----------------------
## NOS + Odometer

There are expanded features included in this scripts with SQL
The included .SQL file needs to be imported into your player_vehicles database to add the appropriate columns (traveldistance, hasnitro, noslevel)

The `hasnitro` and `noslevel` columns being added enables the of saving Nitrous levels through server restarts

The `traveldistance` column adds an Odometer to the toolbox/mechanic_tools menus, this this can retrieved in miles or kilometers.

----------------------
# Extra Damages and Upgrades

**As of v3.0 you no longer need `qb-mechanicjob` to use any of this script**

Extra Damages and their upgrades can be enabled in the config with `Config.Repairs.ExtraDamages = true`

If you wish to enable this you need to go to `qb-vehiclefailure > client.lua` and replace `DamageRandomComponent()` with this event.

```lua
-- Functions
local function DamageRandomComponent()
    exports['jim-mechanic']:DamageRandomComponent(QBCore.Functions.GetPlate(vehicle))
end
```
This will make `jim-mechanic` control the saving and handling of damage values

----------------------
# Harness Item

The script can take control of the already in place `harness` item

This can be enabled or disabled in the config with `Config.Harness.HarnessControl == true`

If you enable this, there are a few steps you need to take as this is handled in `jim-mechanic`.

1. Delete the file `seatbelt.lua` from `qb-smallresources > client`
2. REMOVE these 3 events from `qb-smallresources > server > main.lua`:

```lua
QBCore.Functions.CreateUseableItem("harness", function(source, item)
    TriggerClientEvent('seatbelt:client:UseHarness', source, item)
end)

RegisterNetEvent('equip:harness', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    if not Player.PlayerData.items[item.slot].info.uses then
        Player.PlayerData.items[item.slot].info.uses = Config.HarnessUses - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    elseif Player.PlayerData.items[item.slot].info.uses == 1 then
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items['harness'], "remove")
        Player.Functions.RemoveItem('harness', 1)
    else
        Player.PlayerData.items[item.slot].info.uses -= 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

RegisterNetEvent('seatbelt:DoHarnessDamage', function(hp, data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    if hp == 0 then
        Player.Functions.RemoveItem('harness', 1, data.slot)
    else
        Player.PlayerData.items[data.slot].info.uses -= 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)
```

To make your hud not complain about the harness export you will need to change the name of the export to jim-mechanic
--PS-HUD--
`ps-hud` > `client.lua` > line 80
change:
```lua
    local hasHarness = exports['qb-smallresources']:HasHarness()
```
to:
```lua
    local hasHarness = exports['jim-mechanic']:HasHarness()
```

--QB-HUD--
change:
```lua
local function hasHarness(items)
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then return end

    local _harness = false
    if items then
        for _, v in pairs(items) do
            if v.name == 'harness' then
                _harness = true
            end
        end
    end

    harness = _harness
end
```
to:
```lua
local function hasHarness(items) harness = exports["jim-mechanic"]:HasHarness() end
```


----------------------
## Creating new polyzone for a new location

How do I create PolyZones for a new job location?

These locations determine where a person will be put on duty or taken off duty, and the places where items can be used, if you set them to be restricted to zones.

To start you need to be near the building you want to add.

Type `/pzcreate poly` to start creating a PolyZone. Pick a name, this doesn't matter as you can set this later in locations.lua
You will then get a red line right where you are standing.

Use your ARROW keys to move this around to the first corner/point you want to place.
When its in the correct place, type `/pzadd` and this will lock the current point and allow you to create another

Repeat this until your last corner/point where you will type `/pzfinish`.

This will save all the vectors of the points you have chosen and place them in a file called: `polyzone_created_zones.txt`

In this file is the vectors that you need to copy over to my scripts.

----------------------
## "mechboard" item

**This isn't fully required but helps organise multiples of the "mechboard"**

The MechBoard item is an item given to the person who uses the preview menu and makes changes

To make full use of this item you need to add the ability for the item to show item info in your inventory system

I have only done this with `qb-inventory` and `lj-inventory` as they are similar

`qb-inventory/html/js/app.js`

- Search for "harness" or Scroll down until you find:
```js
} else if (itemData.name == "harness") {
    $(".item-info-title").html("<p>" + itemData.label + "</p>");
    $(".item-info-description").html(
        "<p>" + itemData.info.uses + " uses left.</p>"
    );
```
- Directly underneath this add:
```js
} else if (itemData.name == "mechboard") {
    $(".item-info-title").html("<p>" + itemData.label + "</p>");
    $(".item-info-description").html(
        "<p>" + itemData.info.vehplate + "</p>" +
        "<p>" + itemData.info.veh + "</p>"
    );
```
When successfully added the mechboards will show the vehicle and plate number

----------------------

## Updating core events

To add the ability to save RGB paints, their colour finishes and drift/bulletproof tires you need to change two functions in your qb-core/client/functions.lua

Replace GetVehicleProperties and SetVehicleProperties functions with these:
```lua
function QBCore.Functions.GetVehicleProperties(vehicle)
    if DoesEntityExist(vehicle) then
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)

        if GetVehicleXenonLightsCustomColor(vehicle) == 1 then
            local _, r, g, b = GetVehicleXenonLightsCustomColor(vehicle)
            headlightColor = { r, g, b }
        else
            headlightColor = GetVehicleHeadlightsColour(vehicle)
        end
        if GetIsVehiclePrimaryColourCustom(vehicle) then
            local r, g, b = GetVehicleCustomPrimaryColour(vehicle)
            colorPrimary = { r, g, b, colorPrimary }
        end
        if GetIsVehicleSecondaryColourCustom(vehicle) then
            local r, g, b = GetVehicleCustomSecondaryColour(vehicle)
            colorSecondary = { r, g, b, colorSecondary }
        end

        local extras = {}
        for i = 1, 15 do
            if DoesExtraExist(vehicle, i) then extras[i] = IsVehicleExtraTurnedOn(vehicle, i) and 0 or 1 end
        end

        local modLivery = GetVehicleLivery(vehicle)
        if GetVehicleLiveryCount(vehicle) == -1 or modLivery == -1 then modLivery = GetVehicleMod(vehicle, 48) end

        local tireHealth = {}
        local tireBurstState = {}
        local tireBurstCompletely = {}
        for _, id in pairs({0, 1, 2, 3, 4, 5, 45, 47}) do
            tireHealth[id] = GetVehicleWheelHealth(vehicle, id, false)
            tireBurstState[id] = IsVehicleTyreBurst(vehicle, id, false)
            tireBurstCompletely[id] = IsVehicleTyreBurst(vehicle, id, true)
        end
        local windowStatus = {}
        for i = 0, 7 do windowStatus[i] = IsVehicleWindowIntact(vehicle, i) == 1 end
        local doorStatus = {}
        for i = 0, 5 do doorStatus[i] = IsVehicleDoorDamaged(vehicle, i) == 1 end
        return {
            model = GetEntityModel(vehicle),
            plate = QBCore.Functions.GetPlate(vehicle),
            plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
            bodyHealth = QBCore.Shared.Round(GetVehicleBodyHealth(vehicle), 0.1),
            engineHealth = QBCore.Shared.Round(GetVehicleEngineHealth(vehicle), 0.1),
            tankHealth = QBCore.Shared.Round(GetVehiclePetrolTankHealth(vehicle), 0.1),
            fuelLevel = QBCore.Shared.Round(GetVehicleFuelLevel(vehicle), 0.1),
            dirtLevel = QBCore.Shared.Round(GetVehicleDirtLevel(vehicle), 0.1),
            oilLevel = QBCore.Shared.Round(GetVehicleOilLevel(vehicle), 0.1),
            color1 = colorPrimary,
            color2 = colorSecondary,
            pearlescentColor = pearlescentColor,
            dashboardColor = GetVehicleDashboardColour(vehicle),
            wheelColor = wheelColor,
            wheels = GetVehicleWheelType(vehicle),
            wheelSize = GetVehicleWheelSize(vehicle),
            wheelWidth = GetVehicleWheelWidth(vehicle),
            tireHealth = tireHealth,
            tireBurstState = tireBurstState,
            tireBurstCompletely = tireBurstCompletely,
            windowTint = GetVehicleWindowTint(vehicle),
            windowStatus = windowStatus,
            doorStatus = doorStatus,
            headlightColor = headlightColor,
            neonEnabled = {
                IsVehicleNeonLightEnabled(vehicle, 0),
                IsVehicleNeonLightEnabled(vehicle, 1),
                IsVehicleNeonLightEnabled(vehicle, 2),
                IsVehicleNeonLightEnabled(vehicle, 3)
            },
            neonColor = table.pack(GetVehicleNeonLightsColour(vehicle)),
            interiorColor = GetVehicleInteriorColour(vehicle),
            extras = extras,
            tyreSmokeColor = table.pack(GetVehicleTyreSmokeColor(vehicle)),
            modSpoilers = GetVehicleMod(vehicle, 0),
            modFrontBumper = GetVehicleMod(vehicle, 1),
            modRearBumper = GetVehicleMod(vehicle, 2),
            modSideSkirt = GetVehicleMod(vehicle, 3),
            modExhaust = GetVehicleMod(vehicle, 4),
            modFrame = GetVehicleMod(vehicle, 5),
            modGrille = GetVehicleMod(vehicle, 6),
            modHood = GetVehicleMod(vehicle, 7),
            modFender = GetVehicleMod(vehicle, 8),
            modRightFender = GetVehicleMod(vehicle, 9),
            modRoof = GetVehicleMod(vehicle, 10),
            modEngine = GetVehicleMod(vehicle, 11),
            modBrakes = GetVehicleMod(vehicle, 12),
            modTransmission = GetVehicleMod(vehicle, 13),
            modHorns = GetVehicleMod(vehicle, 14),
            modSuspension = GetVehicleMod(vehicle, 15),
            modArmor = GetVehicleMod(vehicle, 16),
            modKit17 = GetVehicleMod(vehicle, 17),
            modTurbo = IsToggleModOn(vehicle, 18),
            modKit19 = GetVehicleMod(vehicle, 19),
            modSmokeEnabled = IsToggleModOn(vehicle, 20),
            modKit21 = GetVehicleMod(vehicle, 21),
            modXenon = IsToggleModOn(vehicle, 22),
            modFrontWheels = GetVehicleMod(vehicle, 23),
            modBackWheels = GetVehicleMod(vehicle, 24),
            modCustomTiresF = GetVehicleModVariation(vehicle, 23),
            modCustomTiresR = GetVehicleModVariation(vehicle, 24),
            modPlateHolder = GetVehicleMod(vehicle, 25),
            modVanityPlate = GetVehicleMod(vehicle, 26),
            modTrimA = GetVehicleMod(vehicle, 27),
            modOrnaments = GetVehicleMod(vehicle, 28),
            modDashboard = GetVehicleMod(vehicle, 29),
            modDial = GetVehicleMod(vehicle, 30),
            modDoorSpeaker = GetVehicleMod(vehicle, 31),
            modSeats = GetVehicleMod(vehicle, 32),
            modSteeringWheel = GetVehicleMod(vehicle, 33),
            modShifterLeavers = GetVehicleMod(vehicle, 34),
            modAPlate = GetVehicleMod(vehicle, 35),
            modSpeakers = GetVehicleMod(vehicle, 36),
            modTrunk = GetVehicleMod(vehicle, 37),
            modHydrolic = GetVehicleMod(vehicle, 38),
            modEngineBlock = GetVehicleMod(vehicle, 39),
            modAirFilter = GetVehicleMod(vehicle, 40),
            modStruts = GetVehicleMod(vehicle, 41),
            modArchCover = GetVehicleMod(vehicle, 42),
            modAerials = GetVehicleMod(vehicle, 43),
            modTrimB = GetVehicleMod(vehicle, 44),
            modTank = GetVehicleMod(vehicle, 45),
            modWindows = GetVehicleMod(vehicle, 46),
            modKit47 = GetVehicleMod(vehicle, 47),
            modLivery = modLivery,
            modKit49 = GetVehicleMod(vehicle, 49),
            liveryRoof = GetVehicleRoofLivery(vehicle),
			modDrift = GetDriftTyresEnabled(vehicle),
			modBProofTires = not GetVehicleTyresCanBurst(vehicle),
        }
    else
        return
    end
end

function QBCore.Functions.SetVehicleProperties(vehicle, props)
    if DoesEntityExist(vehicle) then
        if props.extras then
            for id, disable in pairs(props.extras) do
                SetVehicleExtra(vehicle, tonumber(id), disable == 1)
            end
        end
        local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
        SetVehicleModKit(vehicle, 0)
        if props.plate then SetVehicleNumberPlateText(vehicle, props.plate) end
        if props.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
        if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
        if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
        if props.tankHealth then SetVehiclePetrolTankHealth(vehicle, props.tankHealth) end
        if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end
        if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
        if props.oilLevel then SetVehicleOilLevel(vehicle, props.oilLevel) end
        if props.color1 then
			if type(props.color1) == "number" then
				colorPrimary = props.color1
				SetVehicleColours(vehicle, colorPrimary, colorSecondary)
			else
				colorPrimary = props.color1[4]
				SetVehicleCustomPrimaryColour(vehicle, props.color1[1], props.color1[2], props.color1[3])
				SetVehicleColours(vehicle, props.color1[4], colorSecondary)
            end
        end
        if props.color2 then
            if type(props.color2) == "number" then
				SetVehicleColours(vehicle, colorPrimary, props.color2)
			else
                SetVehicleCustomSecondaryColour(vehicle, props.color2[1], props.color2[2], props.color2[3])
				SetVehicleColours(vehicle, colorPrimary, props.color2[4])
            end
        end
        if props.pearlescentColor then SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor) end
        if props.interiorColor then SetVehicleInteriorColor(vehicle, props.interiorColor) end
        if props.dashboardColor then SetVehicleDashboardColour(vehicle, props.dashboardColor) end
        if props.wheelColor then SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor) end
        if props.wheels then SetVehicleWheelType(vehicle, props.wheels) end
        if props.tireHealth then
            for wheelIndex, health in pairs(props.tireHealth) do
                SetVehicleWheelHealth(vehicle, wheelIndex, health)
            end
        end
        if props.tireBurstState then
            for wheelIndex, burstState in pairs(props.tireBurstState) do
                if burstState then
                    SetVehicleTyreBurst(vehicle, tonumber(wheelIndex), false, 1000.0)
                end
            end
        end
        if props.tireBurstCompletely then
            for wheelIndex, burstState in pairs(props.tireBurstCompletely) do
                if burstState then
                    SetVehicleTyreBurst(vehicle, tonumber(wheelIndex), true, 1000.0)
                end
            end
        end
        if props.windowTint then SetVehicleWindowTint(vehicle, props.windowTint) end
        if props.windowStatus then
			for windowIndex, smashWindow in pairs(props.windowStatus) do
                if not smashWindow then SmashVehicleWindow(vehicle, windowIndex) end
            end
        end
		if props.doorStatus then
            for doorIndex, breakDoor in pairs(props.doorStatus) do
                if breakDoor then
                    SetVehicleDoorBroken(vehicle, tonumber(doorIndex), true)
                end
            end
        end
        if props.neonEnabled then
            SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
            SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
            SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
            SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
        end
		if props.neonColor then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
        if props.headlightColor then
            if type(props.headlightColor) == "number" then ClearVehicleXenonLightsCustomColor(vehicle) SetVehicleXenonLightsColor(vehicle, props.headlightColor)
            else SetVehicleXenonLightsCustomColor(vehicle, props.headlightColor[1], props.headlightColor[2], props.headlightColor[3]) SetVehicleXenonLightsColor(vehicle, -1) end
        end
        if props.interiorColor then SetVehicleInteriorColour(vehicle, props.interiorColor) end
        if props.wheelSize then SetVehicleWheelSize(vehicle, props.wheelSize) end
        if props.wheelWidth then SetVehicleWheelWidth(vehicle, props.wheelWidth) end
        if props.tyreSmokeColor then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end
        if props.modSpoilers then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end
        if props.modFrontBumper then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end
        if props.modRearBumper then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end
        if props.modSideSkirt then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end
        if props.modExhaust then SetVehicleMod(vehicle, 4, props.modExhaust, false) end
        if props.modFrame then SetVehicleMod(vehicle, 5, props.modFrame, false) end
        if props.modGrille then SetVehicleMod(vehicle, 6, props.modGrille, false) end
        if props.modHood then SetVehicleMod(vehicle, 7, props.modHood, false) end
        if props.modFender then SetVehicleMod(vehicle, 8, props.modFender, false) end
        if props.modRightFender then SetVehicleMod(vehicle, 9, props.modRightFender, false) end
        if props.modRoof then SetVehicleMod(vehicle, 10, props.modRoof, false) end
        if props.modEngine then SetVehicleMod(vehicle, 11, props.modEngine, false) end
        if props.modBrakes then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
		if props.modTransmission then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
        if props.modHorns then SetVehicleMod(vehicle, 14, props.modHorns, false) end
        if props.modSuspension then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
        if props.modArmor then SetVehicleMod(vehicle, 16, props.modArmor, false) end
        if props.modKit17 then SetVehicleMod(vehicle, 17, props.modKit17, false) end
        if props.modTurbo then ToggleVehicleMod(vehicle, 18, props.modTurbo) end
        if props.modKit19 then SetVehicleMod(vehicle, 19, props.modKit19, false) end
        if props.modSmokeEnabled then ToggleVehicleMod(vehicle, 20, props.modSmokeEnabled) end
        if props.modKit21 then SetVehicleMod(vehicle, 21, props.modKit21, false) end
        if props.modXenon then ToggleVehicleMod(vehicle, 22, props.modXenon) end
        if props.modFrontWheels then SetVehicleMod(vehicle, 23, props.modFrontWheels, false) end
        if props.modBackWheels then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end
        if props.modCustomTiresF then SetVehicleMod(vehicle, 23, props.modFrontWheels, props.modCustomTiresF) end
        if props.modCustomTiresR then SetVehicleMod(vehicle, 24, props.modBackWheels, props.modCustomTiresR) end
		if props.modPlateHolder then SetVehicleMod(vehicle, 25, props.modPlateHolder, false) end
        if props.modVanityPlate then SetVehicleMod(vehicle, 26, props.modVanityPlate, false) end
        if props.modTrimA then SetVehicleMod(vehicle, 27, props.modTrimA, false) end
        if props.modOrnaments then SetVehicleMod(vehicle, 28, props.modOrnaments, false) end
        if props.modDashboard then SetVehicleMod(vehicle, 29, props.modDashboard, false) end
        if props.modDial then SetVehicleMod(vehicle, 30, props.modDial, false) end
        if props.modDoorSpeaker then SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false) end
        if props.modSeats then SetVehicleMod(vehicle, 32, props.modSeats, false) end
        if props.modSteeringWheel then SetVehicleMod(vehicle, 33, props.modSteeringWheel, false) end
        if props.modShifterLeavers then SetVehicleMod(vehicle, 34, props.modShifterLeavers, false) end
        if props.modAPlate then SetVehicleMod(vehicle, 35, props.modAPlate, false) end
        if props.modSpeakers then SetVehicleMod(vehicle, 36, props.modSpeakers, false) end
        if props.modTrunk then SetVehicleMod(vehicle, 37, props.modTrunk, false) end
        if props.modHydrolic then SetVehicleMod(vehicle, 38, props.modHydrolic, false) end
        if props.modEngineBlock then SetVehicleMod(vehicle, 39, props.modEngineBlock, false) end
        if props.modAirFilter then SetVehicleMod(vehicle, 40, props.modAirFilter, false) end
        if props.modStruts then SetVehicleMod(vehicle, 41, props.modStruts, false) end
        if props.modArchCover then SetVehicleMod(vehicle, 42, props.modArchCover, false) end
        if props.modAerials then SetVehicleMod(vehicle, 43, props.modAerials, false) end
        if props.modTrimB then SetVehicleMod(vehicle, 44, props.modTrimB, false) end
        if props.modTank then SetVehicleMod(vehicle, 45, props.modTank, false) end
        if props.modWindows then SetVehicleMod(vehicle, 46, props.modWindows, false) end
        if props.modKit47 then SetVehicleMod(vehicle, 47, props.modKit47, false) end
        if props.modLivery then SetVehicleMod(vehicle, 48, props.modLivery, false) SetVehicleLivery(vehicle, props.modLivery) end
        if props.modKit49 then SetVehicleMod(vehicle, 49, props.modKit49, false) end
        if props.liveryRoof then SetVehicleRoofLivery(vehicle, props.liveryRoof) end
		if props.modDrift then SetDriftTyresEnabled(vehicle, true) end
		SetVehicleTyresCanBurst(vehicle, not props.modBProofTires)
		TriggerServerEvent('jim-mechanic:server:loadStatus', props, VehToNet(vehicle))
    end
end
```

# Changelog:

## 3.2.3:
    Fix:
        - Seatbelt logic fixes - `extras.lua`
        - Workaround to stop doubling up the `toggleseatbelt` event - `extras.lua`
        - Fix possible Mod check claiming cars how more mods than they should - `check_tunes.lua`, `shared.lua`
        - Make sure odometer doesn't spam and lag clients when using `checkHSWMods()` - `extras.lua`
        - Fix some cosmetic items claiming there is no options available - `cosmetics.lua`
        - default romanian locale having whong variables, breaking rgb menu's - `ro.lua`
    New:
        - Added config toggle for if crashing and ejecting kills/hurts the player - `extras.lua`, `config.lua`
        - Added config toggle for loading the toolbox prop or not as some users games are hanging trying to load - `check_tunes.lua`, `config.lua`
    Changes:
        - Change around the `extras` loops to reduce ms while keeping same functionality - `extras.lua`
        - Optimize `SeatBeltLoop` to help reduce ms when using a seatbelt - `extras.lua`
        - Move carwax check to not require HarnessControl to be true... -`extras.lua`
        - Changed milage calculation to be more accurate to gta distances (number up slower now) - `extras.lua` - `functions.lua`
        - Optimize a few server/database events
            - `isVehicleOwned` now caches info of owned vehicles into the server to retrieve instead of checking database every time
            - other database now use `isVehicleOwned()` to reduce the amount of sql checks
            - This involves changes to `encfunctionserver.lua` and `functionserver.lua`

## 3.2.2:
    Fix:
        - Add check for if in preview for saving a vehicle on exit - `extras.lua`
        - Hopefully fix the repeating cleaning animation issue - `extras.lua`
        - Preview paints install checks for dashboard/interior paints wrong way round - `previews.lua`
        - Titles for paint previews now show to help keep track of which section you are in - `previews.lua`
        - Interior and Dashboard paint cams disabled as you couldn't see anything - `paint.lua`
        - Add check for duct tape item to stop being able to double up and trigger dupewarn - `extras.lua`
    New:
        - Add odometer option for showing SeatBelt icon - `extras.lua`
            - New image added to html folder for this - `html/img`
        - Added new function `checkHSWMods` to detect HSW mods that won't install on pc.
            - `shared.lua`, `check_tunes.lua`, `emergency.lua`, `performance.lua`
    Changes:
        - Change targets to use `action = function()` - `locfunctions.lua`
        - Updated target and prop creation to help optimize prop loading - `locfunctions.lua`
        - Progressbars no longer stop user input by default (you can now drive and put harness on) - `functions.lua`
        - Changed rpemotes cancel emote event to `ExectueCommand` to help compatability - `functions.lua`
        - Debug mode odometer now shows wether a boat can be anchored or plane is in the air (helpful for `jim-parking`) - `extras.lua`

## 3.2.1 (hotfix):
    New:
        - Added a toggle to forcibly save the vehicle mods to database when player exits it - `extras.lua`, `config.lua`
            - This will cause extra strain on server/database, but makes sure cars are saved more often
    Fix:
        - Missing "repair cost" line when using `mechanic_tools` - `repairs.lua`
        - Antilag effects/sounds - `encfunctionserver.lua`, `extras.lua`
        - Nos Flame + Trails + Purge effects not showing - `functionserver.lua`, `nos.lua`

## 3.2:
    Changes:
        - Version bump to signify the amount of code changes.
        - Pretty big rewrite of the menu creation in the script using a new shared file `wrapper.lua`
        - This adds forced support progress bars in `qb-menu` *Experimental*
        - Better integration of both `ox_lib` context menus and `qb-menu`
        - This includes alot fixes and better oraganisation
        - Tidier code, no uncessessary duplicate code for every time a menu is created
        - Better look for both menus...if you look closely
        - I could make a list of changed files...but its every single file that makes a menu
    Fixes:
        - Some mispellings of `isMenuHeader`
        - "List of cosmetics" menu showing internal and external mods when there weren't any
        - added an event from `qb-mechanicjob` to help saving properties when parking with `qb-garages` - `functionserver.lua`
        - Manual Repair Banch now resets vehicle update timer to stop change of vehicle returning to previous damaged state - `manualrepair.lua`
        - Hopefully fixed the `qs-inventory stash` not saving
        - Added "mail" image for gks phone's preview mails
        - Stop server console complaining about `GetNearbyPeds`
            - Also hopefully less `GetNetworkObject` client spam
## 3.1.2:
    Hotfixes:
        - Fix horn item giving duplicate buttons - `cosmetics.lua`
        - Fix flames causing a `GetNetworkObject` spam warning message - `nos.lua`
        - Attempted to reduce netowrk object spam from trails - `nos.lua`
        - Fix previews requiring you to leave the zone and come back in - `preview.lua`
        - Fix left over `nil` value from testing sparetires in the config - `config.lua`
            - Should fix the compare number with bool error

## 3.1.1
    Hotfixes:
        - Fixed items claiming you were previewing if `Config.Previews.PreviewLocation` was enabled `shared.lua`
        - Fixed missing preview livery locale `/locales`
        - Removed distance print when a vehicle was higher than you `shared.lua`
        - Corrected horrible typo in config for `modCam` description - `config.lua`
        - Raised nos cool down time to be closer to actual seconds - `nos.lua`

## 3.1
    Changes:
        - Adjustments to debug odometer - `extras.lua`
            - Remove street name
            - ReAdd speed information
            - Add some handling info
        - Added option to disable all handling changes to NOS `config.lua`, `extras.lua`, `nos.lua`
        - Increased distace of `lookWheel` event so you don't need to be AS close to a wheel - `functions.lua`
        - Add different cameras angles per repair choice - `repairs.lua`
        - NOS Flame effects now run a loop on client, but are triggered through server - `nos.lua`, `functionserver.lua`
        - Adjusted some server side database events - `functionserver.lua`
            - This MAY help with garages coming out with modifications removed
            - Stops an database check for unowned vehicles
        - Upgraded Rims Menu - `rims.lua`, `preview.lua`
            - Changed Rims menu "Stock" button, now appears only in the main menu for cars instead of every section
            - Shows what category of wheels what are currently set
    Fixes:
        - Added small wait for ExteredVehicle event to delay info loading
            - This should help with garage spawning systems lagging behind
        - Addressed an exploit, when using an item like paintcan while in the car allowed saving
            - The items now check if you are in preview mode
        - `/ShowOdo` not removing the odometer when told to - `extras.lua`
        - Fix previews not giving emails or mechboard items - `previews.lua`
        - Fix machine gun fire antilag explosions - `extras.lua`
        - Actually fix Duct tape item not removing - `extras.lua`
        - Added missing option to disable modCam - `config.lua`
        - Fix repair animations ending early - `repairs.lua`
        - If missing a job, it will now let you know instead of erroring out - `locfunctions.lua`
        - Crafting Menu remembers location restrictions - `locfunctions.lua`
        - Better handling and detection of missing shared items when crafting - `locfunctions.lua`
        - Hex code Paints now work again when using qb-menu - `paint.lua`
        - Notification added for when lockEmergency is enabled - `locales`, `emergency.lua`
        - Fix typo allowing motorcycles to use seatbelts and harnesses - `extras.lua`
        - Suspension and Transmission shouldn't throw item exisiting errors after installing from default - `performance.lua`

## 3.0.7.1
    - Fix cam breaking on when adding nos to a car - `nos.lua`
    - Seatbelts can no longer be used on `motorcycles` or `bicycles` - `extras.lua`
    - Nos should no longer show if moving from one that has it to one that doesn't `extras.lua`
    - Fix duct tape item not being removed - `extras.lua`
    - Fix drift tires not being removed on use for some users - `performance.lua`
    - Change `/preview` plate changing to a server based event - `extras.lua`, `functionserver.lua`
        - This may help with persistant vehicle scripts duping the car

## 3.0.7
    - Jim Learned how to cam
        - `functions.lua`, `performance.lua`, `cosmetics.lua`, `locfunctions.lua`, `manualrepair.lua`, `nos.lua`, `rims.lua`, `xenons.lua`
        - New togglable cam for when editing vehicles
        - Camera is created either side of the vehicle
        - This is partly built into the `progressBar` event (`cam = cam`)
    - New event added to help optimize: `jim-mechanic:Client:ExitVehicle` - `extras.lua`, `encfunctionserver.lua`
        - This stops the need to check for if players in vehicle as its handled by `baseevents` now
    - Added new config options - `config.lua`
        - Distance options for NOS/Purge effects
        - AntiLag has its own section for more options
        - Added config option to add seatbelt notification
        - Added config table of "phones" for /preview to check for when finishing - `previews.lua`
    - Added some alternative sounds for antilag explosions - `extras.lua`, `shared.lua`, `html folder`
    - Added distance options for NOS Effects - `functionserver.lua`
    - NOS now automatically shuts off if travelling too slow - `nos.lua`
    - Changes to nos boost functions in attempt to fix old issues - `nos.lua`
    - Odometer changes - `extras.lua` / `html folder`
        - Smaller text to fit all the info on
        - Updated/Improved the odometer icon files - `html folder`
        - Fix Nos/Purge not showing on odometer hud - `extras.lua`
        - Increased the refresh speed of the odometer - `extras.lua`
        - Added harness icon option to odometer - `extras.lua` / `config.lua`
    - Added option to toggle itemboxes when items are given or removed - `config.lua`, `encfunctionserver.lua`, `functionserver.lua`
    - Fix only front wheel changing on bikes in previews - `preview.lua`
    - Fixes to RGB paint when using qb-menu - `paints.lua`
    - Better handling of engine + lights when changing xenon/underglow - `xenon.lua`

## 3.0.6.2
    - Added extra debug message for toggleItem to help debug issues with inventories - `encfunctionserver.lua`
    - Changed how the vehicleStatus is retreived from the database and added debug prints to help fix bugs - `functionserver.lua`
    - Added distance check to carlift audio, had reports of it being heard on other side of map - `shared.lua`

## 3.0.6.1
    - ExtraDamages fixes - `extras.lua` / `shared.lua` / `functionserver.lua` / `encfunctionserver.lua`
        - CarWax now load and saves properly
        - Fixed harness, antilag and carwax not saving if you had ExtraDamages disabled
    - Had a request to open `jim-mechanic:server:updateCar` - `encfunctionserver.lua` / `functionserver.lua`

## 3.0.6
    - UPDATED: Yet again.. updated the `GetVehicleProperties` and `SetVehicleProperties` functions - `install.md`
        - This should hopefully fix issues with liveries and extras disappearing
    - UPDATED: Car Wax features - `extras.lua` / `functionsserver.lua`
        - Now persistant on owned vehicles for days (saves to database)
        - The default times for each option are 1, 2 and 3 days.
        - This removes the `WaxActivator` server loop and greatly reduces server stress
    - Change carlifts to only sync the ones you are in the polyzone of - `shared.lua` / `locfunctions.lua`
    - Fix extras removing doors - `functions.lua`
    - Preview menu doesn't allow extras changes if vehicle is damaged - `preview.lua`
    - Fix the possibility of new targets being made every time you enter a polyzone - `locfunctions.lua`
    - Adjust ox_inv item image rerouting to fix a mispelling - `shared.lua`
    - Attempt to fix issues with toggleItem() not removing or throwing errors on use
        - `cosmetics.lua` / `extras.lua` / `nos.lua` / `paint.lua` / `performance.lua` / `rims.lua` / `xenons.lua`
    - Attempt to reduce server traffic for pop servers
        - Reduce amount of times events are called
        - Made events not send to all players as much to lessen the load
        - `emergency.lua` / `damages.lua` / `performance.lua` / `manualrepair.lua` /
        - `repair.lua` / `extras.lua` / `functionserver.lua`
    - Added server side checks for nos effects for nearby players - `functionserver.lua`
        - This SHOULD reduce strain on high pop servers sending info to all players too often
    - Nos Boost now only updates client info, then updates server when leaving the drivers seat - `nos.lua` / `extras.lua`
        - This will greatly reduce the amount of server calls when boosting
    - Added a config toggle for AntiLag explosions - `coinfig.lua` / `extras.lua`
        - NO THERE ISNT A WAY TO TURN IT DOWN THE SOUND
        - If its too loud turn down game audio or disable this for now until i find an alternative.
    - Fix starting preview with harness attached would beak the previews - `extras.lua`
    - Fix qb-target only changing the front rims on bikes - `rims.lua`
    - Attempt to fix formatting of emails - `previews.lua`
    - Attempt to fix line 460 table nil for some users - `functionserver.lua`

## 3.0.5
    - Better mechboard item support for "ox_inv", now shows vehicle in its dscription - `previews.lua`
    - Added `previewJobChecks()` to keep the preview system separate from normal job restrcitions - `previews.lua` / `function.lua`
    - Remove check for stashes needing `ItemRequiresJob` to be true to show up - `locfunctions.lua`
    - Continue upgrading polzyone and job logic - `functions.lua`
    - Reformat of manual repair menu - now slightly pretier for both qb and ox - `manualrepair.lua`
    - Missspelling making `ManualRepairBased` not do anything at all - `manualrepair.lua`
    - Fix `repairEngine = false` not working correctly and allowing engine to repair - `manualrepair.lua`
    - Added the ability to completely disable NOS in the script to allow use other scripts for nos usage
        - `nos.lua` / `check_tunes.lua` / `locfunctions.lua` / `extras.lua` / `encfunctionserver.lua`
    - Change how colour is detected for the paintcan and change animation if vehicle is lifted - `paint.lua`
    - Fix duplicate/broken "extras" button in cosmetics menu - `cosmetics.lua`
    - Fix incorrect extras being applied - `cosmetics.lua`
    - Attempt to improve extras `doCarDamage` effect
        - `functions.lua` / `emergency.lua` / `cosmetics.lua` / `preview.lua`
    - Made new events due to QBCore:Client:EnteredVehicle not working - `encfunctionserver.lua` / `extras.lua`
        - This will fix missing with Odometer + Seatbelt control, Extra Damages and Antilag not working

## 3.0.4
    - FIX CHAMELEON PAINTS - `fxmanifest.lua`
    - Update ox items rerouting to take into account missing set item images - `shared.lua`
    - Add workaround for `mechboard` item created with ox exports - `functionserver.lua`/`previews.lua`
    - Change how location is detected for checking resrtictions - `locfunctions.lua`
        - This fixes trying to edit vehicles error "unsupported operation"
    - Re-write of the polyzone creation to help define each section - `locfunctions.lua`
    - Fix incorrect variable allowing bypass of `ItemRequiresJob` items - `functions.lua`
    - Rewrite of a couple check functions, should now be more logical - `functions.lua`
    - Fix some progressbars not stopping animations - `functions.lua`
    - Add Interior and Dashboard paints to emergency bench - `emergency.lua`
    - Fix for cars with only one livery - `emergency.lua`
    - Fixed `fr.lua` causing errors in repair.lua
        - ANY HELP WITH LOCALES IS GREATLY APPRECIATED

## 3.0.3
    - Added info to `install.md` on how to make harness state show up in `qb-hud`
    - Fix "qs" not saving to stash - `functionsserver.lua`
    - Fix incorrect locale for suspension - `performance.lua`
    - Made the extra damage related items unusable if Config.Repairs.ExtraDamages is false
        - Sorry for the confusion
    - Fix cosmetics not showing on items if there was only 1 available - `cosmetics.lua`
    - Updated `nl.lua`
    - If you use `ox_inv`, the script now reroutes to use `exports.ox_inventory:Items()`
    - Added Harness section to Config - `config.lua` / `check_tunes.lua` / `extras.lua` / `functionserver.lua`
        - HarnessControl variable move to `Config.Harness` to keep it grouped together
        - This controls:
            - Leaving vehicle without removing harness or seatbelt
            - Wether a progressbar will show when removing the harness
    - Fix harness and antiLag saving/loading - `functionserver.lua`
    - Fix harness progressbar animations - `extras.lua`
        - Fixes rare crash if restarting the script
    - Fix passengers not being affected by crashing - `extras.lua`
    - Added check to detect wether player is loaded in before loading zones - `locfunctions.lua`
    - Fix mispellings making emergency bench paints not work for qb-target - `emergency.lua`
    - Fix for `Config.Emergency.requireDutyCheck` - `emergency.lua`
    - Fix emergency bench suspension trying to change spoilers - `emergency.lua`
    - Fix nosrefill vec4 error with ox_target - `locfunctions.lua`
    - Added check to previews.lua for if you have a phone or not when using `PreviewPhone = true` - `previews.lua`
    - Added check for if a location has a blip or not - `previews.lua`

## 3.0.2
    - Add extra check for "null" results in database to stop errors - `functionserver.lua`
    - Fix `qb-target` not being able to open `ox_inv` shops - `locfunctions.lua`
    - Fix performance parts not installing/uninstalling correctly - `performance.lua`
        - It should no longer complain about missing items when sucessfully installing
        - Antilag isntall now waits for info instead of throwing an error
        - this should stop the nil `level` error too
    - Fix extradamage upgrades not installing/uninstalling correctly - `damages.lua`+ `main.lua`
    - Shut up the `Shut` error in nos.lua
    - `HasHarness` nil error should no longer show up if jim-mechanic doesn't control harnesses
    - Added `exports["jim-mechanic"]:updateVehicle(vehicle)` - `shared.lua`
        - This can be added to a garage script to save all the jim-mech damages
    - Updated saveStatus server event to save engine and body damage to stop possibility of setting to "null" - `extras.lua` + `functionserver.lua` + `functions.lua`
    - Added `RFC LS CUSTOMS`, `RFC Redline`, `Rising Sun` and `flyWheels` locations - `locations.lua` + `config.lua`
    - Update Ducttape repair event to new format - `extras.lua`

## 3.0.1
    - Fix fueltanks kicking players/not installing
    - Repair clipboards remove after 4 seconds
    - Doors close when progressbars are finished when checking damages
    - Fix extra damage upgrades not showing in the `toolbox` menu
    - Fix issue with ox_target not telling shops what job you have
    - ACTUALLY fix qs stash support..
    - Fix polyzone creation repeating the wrong info
    - Removed fuel exports infavour of Default GTA Natives

## 3.0
    Disclaimer:
        This is a full re-write, many files have changed.
        You will NEED to completely replace the script for it to function correctly.
        There are alot of changes over a long period of time, so there may be more than I've listed here.

    - New Features:
        - Seatbelt and Harness control
            - Now players get harness prop attached to them when use a vehicle harness
            - These are persistant on each vehicle and can only be removed with the toolbox
        - Extra Damages are now integrated into the script
            - No need for `qb-mechanicjob` to be running aswell anymore
            - This allows for better control and less errors related to damages
            - Allows for new upgrades and items to be added related
        - Support for `OX_Target`, `OX_Lib Context Menus`, `OX_Lib ProgressBars`, `OX_Inventory`, `OX_Lib's Notifications`
        - Added new Item + Feature `AntiLag` (2step)
            - For the boy racers
        - Added usable `Car Lifts` to the script
            - Specify each location in locations.lua
            - Can take control of carlifts in locations, as long as they are two separate models eg. Gabz Tuners
            - Server Synced
    Changes:
    - More Chameleon paints!
    - Fix `SetXenon` warning Spam (hopefully)
    - Slight change to `GetVehicleProperties` function
        - Hopefully fixed livery issues for people
    - Update location support for Gabz Benny's MLO
    - Update `qs-inventory` sql support
    - Completely Reorganised the `config.lua`
        - Better readability and more toggles
    - Completely rewrote `repair.lua`
        - More Optimized, Fixed animations
        - Removed tyre change animations as it wasn't playing well with other scripts
        - Added an attempt to reduce `qb-mechanicjob` related spam
        - Greatly improved stash removal of items, no more "tidyStash" exploits!
    - Compeletly re-wrote `check_tunes.lua`
        - Alot more optimzied and now supports `ox_lib` context menus
        - More organised and smarterer
    - Rewrite of `paint.lua`
        - General Optimizations
        - Redesign of the RGB/HEX Picker menus to accomodate `ox_lib`
        - This merges hex and rgb menus together but adds more behind the scenes functionality
    - Refactored and Optimized `nos.lua`
        - General Optimizations
        - Redesign of the RGB/HEX Picker menus to accomodate `ox_lib`
        - This merges hex and rgb menus together but adds more behind the scenes functionality
        - New sputtering `nos` effect for when boosting too long
    - Refactored and Optimized `xenons.lua`
    - Moved and refactored the `Config.Locations` to `shared/locations.lua`
        - Moved and refactored functions from `locations.lua` to `client/locfunctions.lua`
        - Added the ability to add certain vehicle or modification restrictions for each location
        - eg. set a location to ONLY be able to for repairs
    - Greatly reduced the amount of files in the script
        - cosmetic based events all run from `cosmetics.lua`
        - Vehicle extras are now available through `externals` item by default
    - Added support for roof liveries, used with the livery item
    - `police.lua` is completely replaced by a new file `emergency.lua`
        - This is a rewrite making it possible to add any cosmetic to the emergency mech bench
        - Locations are now kept in the config with the toggles for what should be changeable
        - Added every possible cosmetic and several performance upgrades
        - Added config option `LockEmergency` to lock bench to only Emergency Class vehicles
    - Rewrote how `manualrepair.lua` benches handle calculcations
        - You can repair vehicles with a value of $0
    - Improved `preview.lua` functions, more optimized
        - Exploit prevention, the plate now changes when previewing
            - When you stop, it resets their plate
            - This stops players saving their previewed vehicles
        - Extras now available in the preview menu
        - Added "Stop Previewing" button for the people who cba getting out of their car
        - Support for RoadPhone `/preview` mail messages
        - Fixes to preview printouts, some item names were wrong

---