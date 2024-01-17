Config = {}

Config.debug = false


--- SETTINGS FOR ESX
Config.esxSettings = {
    enabled = false,
    -- Whether or not to use the new ESX export method
    useNewESXExport = false,
    
    -- Money account used when picking up cash or selling off items
    moneyAccount = 'cash',
    
    -- Whether or not the server is using old esx inventory system
    oldEsx = false,
}

--- SETTINGS FOR QBCORE
Config.qbSettings = {
    enabled = true,
    useNewQBExport = true, -- Make sure to uncomment the old export inside fxmanifest.lua if you're still using it
    
    -- Money account used when picking up cash or selling off items
    moneyAccount = 'cash',
}

-- List of police jobs
Config.policeJobs = {
    'police',
    'lspd',
    'bcso',
}

-- The minimum amount of officers online needed for the loot to spawn
-- Set it to 0 to skip the check. This will improve server performance on very large servers
Config.minimumPoliceOnline = 0


-- Looting duration in ms
Config.lootingDuration = 7000

-- Whether or not to lock vehicles which have loot inside them
Config.lockVehicles = true

-- Font used for the 3d text
Config.textFont = 4

-- Scale used for the 3d text
Config.textScale = 1

-------------------------------------------------
--- DISPATCH
-------------------------------------------------
Config.dispatch = {
    enabled =true, -- Whether to enable the dispatch

    alertChance = 60, -- chance in %, how often smash n grab events get called

    system = 'ps-dispatch',  -- Setting for the dispatch system to use ('default' for the built-in system or 'cd-dispatch', 'core-dispatch-old', 'core-dispatch-new' or 'ps-dispatch' for external systems)
    policeCode = '10-31',  -- Police code for the smash n grab
    eventName = 'Smash and grab',  -- Name of the theft event
    description = 'Vehicle broken into. Possible theft',  -- Description of the theft event

    blip = {
        sprite = 380,  -- Sprite for the smash 'n grab blip
        color = 59,  -- Color for the smash 'n grab blip
        scale = 1.0,  -- Scale for the smash 'n grab blip

        timeout = 60,  -- Time in seconds for the blip to disappear after the smash 'n grab event is over

        showRadar = true,  -- Setting to show the smash 'n grab blip on the radar
    },
}

-------------------------------------------------

-- Odds of loot spawning inside a parked npc vehicle by class given in percentage (0-100) (can use decimal values)
Config.odds = {
    [0] = 5, -- Compacts
    [1] = 15, -- Sedans
    [2] = 17.5, -- SUVs
    [3] = 7, -- Coupes
    [4] = 9, -- Muscle
    [5] = 17.5, -- Sports Classics
    [6] = 15, -- Sports
    [7] = 20, -- Super
    [8] = 0, -- Motorcycles
    [9] = 12, -- Off-road
    [10] = 0, -- Industrial
    [11] = 0, -- Utility
    [12] = 5, -- Vans
    [13] = 0, -- Cycles
    [14] = 0, -- Boats
    [15] = 0, -- Helicopters
    [16] = 0, -- Planes
    [17] = 0, -- Service
    [18] = 0, -- Emergency
    [19] = 0, -- Military
    [20] = 0, -- Commercial
    [21] = 0, -- Trains
}

Config.loot = {
    {
        model = 'prop_michael_backpack',
        offset = vector3(0.0, -0.05, 0.05),
        loot = 'electronics',
        lootChance = 40,
    },
    {
        model = 'prop_michael_backpack',
        offset = vector3(0.0, -0.05, 0.05),
        loot = 'clothes',
        lootChance = 50,
    },
    {
        model = 'bkr_prop_duffel_bag_01a',
        offset = vector3(0.0, -0.05, 0.1),
        loot = 'electronics',
        lootChance = 60,
    },
    {
        model = 'prop_cs_heist_bag_02',
        offset = vector3(0.0, -0.05, 0.12),
        loot = 'electronics',
        lootChance = 70,
    },
    {
        model = 'v_club_vu_djbag',
        offset = vector3(0.0, 0.01, -0.18),
        loot = 'electronics',
        lootChance = 90,
    },
    {
        model = 'prop_cs_heist_bag_02',
        offset = vector3(0.0, -0.05, 0.12),
        loot = 'clothes',
        lootChance = 50,
    },
    {
        model = 'prop_cs_heist_bag_02',
        offset = vector3(0.0, -0.05, 0.12),
        loot = 'cash',
        lootChance = 50,
    },
    {
        model = 'prop_cs_shopping_bag',
        offset = vector3(0.0, 0.05, 0.3),
        loot = 'clothes',
        lootChance = 70,
    },
    {
        model = 'prop_nigel_bag_pickup',
        offset = vector3(0.0, -0.05, 0.12),
        loot = 'clothes',
        lootChance = 30,
    },
    {
        model = 'prop_stat_pack_01',
        offset = vector3(0.0, -0.07, -0.07),
        loot = 'cash',
        lootChance = 80,
    },
    {
        model = 'hei_heist_acc_box_trinket_02',
        offset = vector3(0.0, -0.05, 0.05),
        loot = 'electronics',
        lootChance = 60,
    },
    {
        model = 'prop_cs_cardbox_01',
        offset = vector3(0.0, 0.01, 0.03),
        loot = 'clothes',
        lootChance = 30,
    },
    {
        model = 'prop_cs_cardbox_01',
        offset = vector3(0.0, 0.01, 0.03),
        loot = 'electronics',
        lootChance = 30,
    },
}

Config.lootTypes = {
    ['cash'] = {
        money = {
            chance = 100,
            amount = {
                min = 50,
                max = 1000,
            }
        }
    },
    ['electronics'] = {
        items = {
            'kq_expensive_laptop',
            'kq_expensive_watch',
        },
        money = {
            chance = 30,
            amount = {
                min = 50,
                max = 500,
            }
        }
    },
    ['clothes'] = {
        items = {
            'kq_expensive_bag',
            'kq_expensive_sneakers',
        },
        money = {
            chance = 70,
            amount = {
                min = 100,
                max = 500,
            }
        }
    },
}

-- https://docs.fivem.net/docs/game-references/controls/
-- Use the input index for the "input" value
Config.keybinds = {
    loot = {
        label = 'E',
        name = 'INPUT_PICKUP',
        input = 38,
    },
}
