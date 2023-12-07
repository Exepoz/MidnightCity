# cr-closedshops

## Simple Closed Business Shop System

[Constant Development Discord](https://discord.gg/gSQbshCNv4)
[Constant Development Tebex](https://constant-development.tebex.io/)
[Constant RolePlay Discord](https://discord.gg/constantroleplay)

This Resource is based upon you having a Shop for your Business's that is available when Employee's aren't Available.
Employee's will have the 'Ability' to Stock-Up the Shop and or remove a certain Stock. With this, they can set a Price
and Quantity for each Stock within the Shop. Each Shop is entirely Configurable and same with many other Factors. Another
Note, you are able to select between a 'Prop' or 'PED' for the System towards the Closed Shop. You as well are allowed a
Blip with your Shop. Each of these are Configurable within the Shop's System. Please Note, you want to pay attention to
any sort of Details listed within the Configuration to keep track of things you may need for something else, and such.

## Optionals:

### Optional Targets:

- [qb-target](https://github.com/Renewed-Scripts/qb-target)
- [qtarget](https://github.com/overextended/qtarget)

### Optional Notifications:

- [QBCore:Notify](https://github.com/qbcore-framework/qb-core)
- [okokNotify](https://okok.tebex.io/package/4724993)
- [mythic_notify](https://github.com/wowpanda/mythic_notify)
- [tnj-notify](https://github.com/tnj-development/tnj-notify)
- [Chat-Notification]

## Installation

* If you encounter any issues whilst Installing or Using/Enforcing this Resource, please feel free to Open a Ticket within the [Constant Development Discord](https://discord.gg/gSQbshCNv4).

### qb-smallresources/server/logs.lua
* If using Logs --> qb-smallresources/server/logs.lua | Add the following within ```local Webhooks {}```
```
    ['constantdevelopmentclosedshops'] = 'YOUR_WEBHOOK_HERE',
```

###
    --[[
        ['SystemName'] = {
            System = {
                SystemName = "SystemName",
                JobNames = {"JobName"}, -- Either JobName or GangName must be entered | Other can be set to 'nil'
                ShopType = "ped", -- ped or prop
                coords = vector4(-1182.0186, -883.1359, 13.7921, 302.2321), -- Target's Coorindates
            },
            PED = {
                Model = 's_m_m_linecook', -- PED's Model | https://docs.fivem.net/docs/game-references/ped-models/
                Name = 'Andy', -- PED's Name
                Scenario = "WORLD_HUMAN_STAND_IMPATIENT", -- PED's Tasked Scenario | https://gtaforums.com/topic/796181-list-of-scenarios-for-peds/ | Standing Recommended due to Target
            },
            Prop = {
                Model = 'prop_vend_snak_01_tu', -- Should be a (Vending)'Machine' | https://gta-objects.xyz/
            },
            Blip = { -- https://docs.fivem.net/docs/game-references/blips/
                Enabled = true,
                Label = "SystemName", -- Best Kept as Burgershot due to Prefix Standards | Prefix Standard: "'s Closed Shop"
                Coords = vector4(-1182.0186, -883.1359, 13.7921, 302.2321), -- Realistically should be the PED Coordinates.
                Sprite = 628, -- Blip's Sprite
                Display = 4, -- Blip's Display
                Scale = 0.5, -- Blip's Scale
                Colour = 49, -- Blip's Colour
            },
            Shop = {
                label = "SystemName's Closed Shop",
                items = {
                    [1] = { -- Slot #
                        name = 'weapon_poolcue', -- Item Name
                        price = 500, -- Item's Price
                        info = {}, -- Item's Info(If Setup)
                        limit = 5 -- Amount that can be purchased by a single person per hour
                    },
                }
            }
        },
    ]]
