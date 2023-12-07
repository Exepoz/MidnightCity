# Thank you for purchasing! The following is the installation guide to the script

### Features
- 1. Cows & Chickens
- 2. Chicken & Pigs game for catching
- 3. MeatSlaughter Interactions for chickens and pigs giving use to both factories.
- 4. Every Fruit Tree and Bush in Grapeseed and Paleto are pickable and divided into zones to give out configurable items
- 4a. Timer per Tree + Bush so players move around
- 3. Configurable Recipes
- 4. Configurable NPC Seller that buys the picked items - Prices change per restart (Snippet Provided in discord and o)
 - 5.  Every possible thing you could want to change is in the Config.lua

If you need more help check out our gitbook: https://jixelpatterns.gitbook.io/
or join our discord https://discord.gg/jixelpatterns

===============================
INSTALL|
===========================
​
1. Add the script to your server resources
We highly recommend putting jixel-farming in a new folder called [jixel]
NOTE: IF YOU ALREADY HAVE A [jim] or [jixel] FOLDER PUT IT IN THAT FOLDER YOU DO NOT NEED TO CREATE A NEW ONE.
Then add ensure [jim] or [jixel] after your other scripts have started in your server.cfg

2. Items
Add the images from the images folder in to your

`INVENTORY` > `HTML` > `IMAGES`

FOR OX



The following code block goes into your

`QB-CORE` > `SHARED` > `ITEMS.LUA`

2. Emotes
The following code block goes into your
If using  by DullPear
 `DPEMOTES` > `CLIENT` > `ANIMATIONLIST.LUA` in `DP.PropEmotes`
If using  by TayMcKenzie
`RPEMOTES` > `CLIENT` > `AnimationListCustom.lua `
If using scully by Scully
`custom_emotes.lua > PropEmotes `
```lua
    {
        Label = 'Stab With Knife',
        Command = 'stab',
        Animation = 'plyr_front_takedown_b',
        Dictionary = 'melee@hatchet@streamed_core_fps',
        Options = {
            Flags = {
                Loop = false,
                Move = false,
            },
            Props = {
                {
                    Bone = 57005,
                    Name = 'prop_knife',
                    Placement = {
                        vector3(0.16, 0.1, -0.01),
                        vector3(0,0,-45),
                    },
                },
            },
        },
    },
```

3. Job
Only applicable if you want the job - job locked
QB-CORE > SHARED > JOBS.LUA
['farmer'] = {
        label = 'Farmer',
        defaultDuty = false,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Farm Hand', payment = 100 },
        },
    }

4. Rep
Only applicable if you want recipes to be farmrep locked and for your players to earn farm rep
which you can turn on by turning on

`FarmingRep = false`
to
`FarmingRep = true`

Next in your

`QB-CORE` > `SERVER` > `PLAYER.LUA`

Find this line

PlayerData.metadata['phonedata'] = PlayerData.metadata['phonedata'] or {
        SerialNumber = QBCore.Player.CreateSerialNumber(),
        InstalledApps = {},
    } -- this line already exists

Add this

PlayerData.metadata['farmingrep'] = PlayerData.metadata['farmingrep'] or 0 -- add this line