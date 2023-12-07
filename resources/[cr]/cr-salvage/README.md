# Features
- New Interactive & Social way for gathering materials. 
- Scrap Down old cars, machinery & others using a power saw to get crafting materials. 
- Wrecks Spawn inside the city scrapyard and players can salvage them with a Power Saw.
- A Big Wreck Can Spawn, with doubled health and loot.
- Wrecks are Synced & their "health" is controlled server-side, so they behave the same for everyone.
- Custom Made Salvaging Minigame.
- SkillCheck with Fully Configurable Behavior (Boosts Item Yield / Chance to break saw / Simply stops salvaging / Open Function for Full Customization)
- The Power Saw has a configurable amount of uses before breaking, requiring replacing the blade.
- 1 Wreck spawns at a time, multiple players can salvage the same wreck, which contributes to socialization. 
- Once per hour (Configurable), a World Wreck can spawn and alert people who subscribed to the email notifications. 
- Players must find the wreck, which gives better materials and special items (Different 'Scenario' / Wreck Type). 
- Custom Scenarios
- Configurable Shop & Tutorial
- Highly Configurable. 

# Supports
- QBCORE, ESX, (Open Framework Files, can be fully customized)
- OxLib, OxInv, OxTarget
- Target & Non-Target (TextUI/DrawText) Versions
- Languages : Locales folder. Initially comes in English, feel free to send yours! 
- Notifications : qbNotify / okokNotify / OxLib / ESX Mythic / Chat message (File Unencrypted so any custom can be set)
- Phone : qb-phone / GKS Phone / qs-phone / NDWP / (File Unencrypted so any custom can be set)
- DrawText : qb-core (native) & okokDrawText / OxLib / ESX (File Unencrypted so any custom can be set)
- Menu : qb-menu / nh-context / OxLib / ESX
- SQL Databse : Saves Email Notification Toggle Option in your Database.
- Open to any requests for additional supports.

# Dependencies
Either QBCore or ESX Extended
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [es_extended](https://github.com/mitlight/es_extended)
And Either PolyZone or OxLib
- [PolyZone](https://github.com/mkafrin/PolyZone)
- [ox_lib](https://github.com/overextended/ox_lib)

# Optional Supports
- [ps-ui](https://github.com/Project-Sloth/ps-ui)
- [qb-target](https://github.com/berkiebb/qb-target)
- [gks-phone](https://gkshop.org/)
- [qs-phone](https://www.quasar-store.com/package/4861393)
- [ndwp](https://github.com/project-error/npwd)
- [okokDrawText] & [okokNotify](https://okok.tebex.io/)
- [mythic_notify](https://github.com/JayMontana36/mythic_notify)
- [nh-context](https://github.com/nerohiro/nh-context)
- [oxmysql], [oxlib], [ox_inventory], [ox_target](https://github.com/overextended)

# Useful Exports :
- `StopSalvage` : Makes the player stop Salvaging.

# Statebags :
- `LocalPlayer.state['IsSalvaging']` : Used to know if a player is a player is salvaging.  Useful to stop other scripts animations, phone etc from working when someone is salvaging

# Installation
- Drag the cr-salvage folder in your server's `/resources` fodler.
- Ensure cr-salvage in your server.cfg

## QBCcore Inventories Instalation (qb/lj-inventory)
- Add the following items in `qb-core/shared/items.lua`
- Add the item images in your inventory's `hmtl/images` folder. 

```
	['powersaw'] = {    ['name'] = 'powersaw',    ['label'] = 'Power Saw',    ['weight'] = 150,    ['type'] = 'item',    ['image'] = 'powersaw.png',    ['unique'] = true,    ['useable'] = true,    ['shouldClose'] = false,    ['combinable'] = nil,    ['description'] = 'Great Quality Saw for all purposes'},
    
    ['brokenpowersaw'] = {    ['name'] = 'brokenpowersaw',    ['label'] = 'Bladeless Power Saw',    ['weight'] = 150,    ['type'] = 'item',    ['image'] = 'brokenpowersaw.png',    ['unique'] = true,    ['useable'] = true,    ['shouldClose'] = false,    ['combinable'] = {accept = {'sawblade'}, reward = 'powersaw', anim = {['dict'] = 'anim@amb@business@weed@weed_inspecting_high_dry@', ['lib'] = 'weed_inspecting_high_base_inspector', ['text'] = 'Installing New Blade..', ['timeOut'] = 10000}},    ['description'] = 'A Power Saw, but without the Saw Blade...'},

    ['sawbladepack'] = {    ['name'] = 'sawbladepack',    ['label'] = 'Saw Blade Pack',    ['weight'] = 150,    ['type'] = 'item',    ['image'] = 'sawbladepack.png',    ['unique'] = true,    ['useable'] = true,    ['shouldClose'] = false,    ['combinable'] = nil,    ['description'] = 'A Box full of Saw Blades'},

    ['sawblade'] = {    ['name'] = 'sawblade',    ['label'] = 'Saw Blade',    ['weight'] = 150,    ['type'] = 'item',    ['image'] = 'sawblade.png',    ['unique'] = false,    ['useable'] = true,    ['shouldClose'] = false,    ['combinable'] = nil,    ['description'] = 'A singular Saw Blade'},

    ['flightbox'] = {    ['name'] = 'flightbox',    ['label'] = 'Flight Box',    ['weight'] = 150,    ['type'] = 'item',    ['image'] = 'flightbox.png',    ['unique'] = true,    ['useable'] = false,    ['shouldClose'] = false,    ['combinable'] = nil,    ['description'] = 'A box containing the last momments of a plane\'s flight.'},

```
## Ox_Inventory Instalation
- Add the following items in `ox_inventory/data/items.lua`
- Add the item images in `ox_inventory/web/images.lua`.

```
['powersaw'] = { label = 'Power Saw', weight = 150, stack = false, close = true, description = 'Great Quality Saw for all purposes' },

['brokenpowersaw'] = { label = 'Bladeless Power Saw', weight = 150, stack = false, close = true, description = 'A Power Saw, but without the Saw Blade...' },

['sawbladepack'] = { label = 'Saw Blade Pack', weight = 150, stack = false, close = true, description = 'A Box full of Saw Blades' },

['sawblade'] = { label = 'Saw Blade', weight = 150, stack = false, close = true, description = 'A singular Saw Blade' },

['flightbox'] = { label = 'Flight Box', weight = 150, stack = false, close = true, description = 'A box containing the last momments of a plane\'s flight.' },
```
## Default ESX Instalation
- Add the items to the database by inserting the items.sql file accordingly

# Email DataBase
- If you want the email notifications to be persistent over restarts, you need to run 'cr-salvage.sql' on your database.
- After that, set Config.EmailDataBase to 'true' and players wont have to toggle the notifications every restart.

# If using Logs --> qb-smallresources/server/logs.lua | Add the following within ```local Webhooks {}```
```
    ['crsalvage'] = 'YOUR_WEBHOOK_HERE',
```

# Custom Scenario Guide
- You can now create custom scenarios with custom event!
- Steps :
    1. Copy the plane scenario config and paste it right below it.
    2. Rename the scenario, and change all the configuration to your custom creation.
    3. Do the same for Config.WorldWreckSnenarios and input your own locations.
    4.  - If you want something to happen as soon as the wreck get generated by the server, set OnGenerationEvent to true.
        - Add your own function/code, in either cl_extras.lua or sv_extras.lua. Follow the template given.
    5.  - If you want something to happen as soon as the player get close enough and the wreck spawns, set OnSpawnEvent to true.
        - Add your own function/code, in either cl_extras.lua or sv_extras.lua. Follow the template given.
    6. Add your scenario to Config.WorldWrecks.Scenarios to enable it.
