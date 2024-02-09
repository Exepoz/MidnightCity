Config = {}

-- General Settings
Config.OxyRunDebug = false -- Change to true to enable PolyZone DebugPoly's for testing.

Config.MinimumPolice = 0 -- Minimum Police Required to start a Run..
Config.RunCost = 500 -- How much it will cost to start the run..
Config.SendEmail = false -- The E-Mail received upon taking on a job (reference Config.Phone in sd_lib/sh_config.lua and the util function SendEmail in sd_lib/client/cl_utils.lua) if false, a notification will play instead

Config.CheckForItem = { Enable = false, Item = "vpn" } -- Check for Config.Items.Requirement in the players inventory before getting a run.
Config.Items = { Package = "package", } -- Items that given by the supplier and exchanged for Oxy.

-- Cooldown Settings
Config.Cooldown = {
    EnableTimeout = false, -- true = enable a timeout that'll end the run after Config.Timeout. false = won't start a Timeout
    Timeout = 30, -- Minutes (How long it takes for the entire run to Timeout.)
    BuyerTimeout = 5, -- Minutes (When you initially enter the selling zone, how long does it take upon leaving, before finishing the run and without re-entering, for the run to Reset)

    EnableGlobalCooldown = false, -- Global Cooldown for everyone.
    GlobalCooldown = 20, -- Minutes

    EnablePersonalCooldown = false, -- Cooldown before someone can start another run.
    PersonalCooldown = 20 -- Minutes
}

-- Starting (Boss) Ped
Config.Ped = {
    Location = {
        {x = 372.36, y = -1785.64,  z = 29.10, w = 151.02},
        {x = 143.38, y = -118.15, z = 54.80, w = 223.80},
        {x = 683.48, y = -789.34, z = 23.5, w = 0.13}
        -- Add more locations as needed (Will Randomize from available locations each script start)
    },
    Model = "a_m_m_mlcrisis_01",
    Interaction = {
        Icon = "fas fa-circle",
        Distance = 3.0,
    },
    Scenario = "WORLD_HUMAN_STAND_IMPATIENT" -- Full list of scenarios @ https://pastebin.com/6mrYTdQv
}

-- Blip Creation for Boss Peds
Config.Blip = {
    Enable = false, -- Change to false to disable blip creation
    Sprite = 480, -- Sprite/Icon
    Display = 4,
    Scale = 0.6,
    Colour = 1,
    Name = "Mysterious Person", -- Name of the blip
}

Config.Supplier = {
    Roaming = false, -- If true, the supplier will only give one package at a time and then you must go to a different location with a new supplier and get a new package until you have all the packages you need. If false, a single Supplier location will be picked and you can collect ALL packages from him.
    Peds = { 'a_m_y_skater_01', 'a_m_y_vinewood_03', 'a_m_y_soucent_02', 'a_m_y_soucent_03', 'a_m_y_methhead_01', 'a_m_m_eastsa_01', 'a_m_m_genfat_01', 'a_m_m_mexlabor_01', }, -- The peds that can spawn as the supplier.
    Locations = { -- The locations where the supplier can spawn.
        vector4(608.79, -459.17, 24.74, 181.92),
        vector4(1250.83, -2562.04, 42.71, 219.28),
        vector4(740.43, -2634.68, 6.47, 189.84),
        vector4(-1161.83, -1250.07, 6.8, 306.16),
        vector4(-2223.13, -365.75, 13.32, 260.99),
        vector4(-2982.84, 1585.71, 23.82, 359.91),
        vector4(-287.47, 2535.68, 75.47, 271.17),
        vector4(1583.08, 3620.96, 38.78, 134.18),
        vector4(-608.03, 3020.91, 19.34, 91.72),
        vector4(1571.72, 3576.83, 32.62, 119.89),
        vector4(939.59, -1490.99, 30.09, 179.24),
        vector4(208.83, -1991.16, 19.72, 229.42),
        vector4(-1359.84, -759.84, 22.3, 308.49)
    }
}

-- Moneywashing Settings
-- Configures item-based money laundering (1-1 ratio, e.g., 1 ItemName = $1).
-- Recommended to disable if you don't use marked money where 1 item = $1.
-- If you don't have a 1-1 ratio marked money item, you can configure tradtional moneywashing settings in Config.Levels
Config.MoneyWashing = {
    WashItem = { Enable = false, Chance = 33, ItemName = "", MinAmount = 500,  MaxAmount = 2500 }
} -- if Enabled, the 'Washing' settings in Config.Levels will be overridden (Levels.Tax still applies to Config.MoneyWashing)

-- Example Scenario: With 1000 'ItemName' units, the script checks for a minimum of 500 ('MinAmount').
-- If met, a random quantity between 'MinAmount' and the lower of your quantity or 'MaxAmount' is selected for laundering.

-- Level Settings
-- 'Robbery': Enables a minigame with a failure penalty (no oxy from package). The amount of entries in 'Difficulty' determines the number of skill checks.
-- 'Delay' sets the time before the minigame starts (milliseconds). Requires ox_lib for the skillcheck minigame.
-- 'Washing': 'markedbills' max and min payouts will only be applied if the 'markedbills' don't have a 'worth' as metadata. (In a players inventory for example 1 'markedbills' could equal $5000)
Config.Levels = {
    GiveItem = true, -- Give the player an item reward each delievery (eg. Config.Levels[1-3].ItemReward). If false, script will solely act as a moneywash.
    [1] = {
        -- No XP Threshold here is required, due to 1 being the starting level.
        XPPerDelivery = 1, -- XP per delivery (package) for Level 1
        CallCopsChance = 33, -- Chance for the cops to be called when a player delivers a package.
        ItemReward = { Item = "oxy", Min = 1, Max =2 }, -- Rewards for Level 1
        Washing = { Enable = true, Bills = { min = 750, max = 2000, chance = 20 }, Bands = { min = 750, max = 2000, chance = 15 }, Rolls = { min = 250, max = 750, chance = 25 } }, -- Settings for the money washing, Level 1 (enable, min/max payouts, etc)
        Tax = { Enable = true, Percentage = 25 }, -- Tax settings on all money washing for Level 1
        RareItem = { Enable = true, Chance = 3, Reward = { Items = { "advancedlockpick",  }, Min = 1, Max = 1 } }, -- Rare Item Reward for Level 1
        Robbery = { Enable = true, Delay = 1000, Difficulty = {'easy', 'medium', 'medium', 'hard'}, Chance = 25, Inputs = {'1', '2', '3', '4'} } -- Settings for the robbery minigame, Level 3 (enable, difficulty, chance of it occuring, etc)
    },
    [2] = {
        XPThreshold = 150, -- XP threshold for Level 2
        XPPerDelivery = 1, -- XP per delivery (package) for Level 2
        CallCopsChance = 25, -- Chance for the cops to be called when a player delivers a package.
        ItemReward = { Item = "oxy", Min = 1, Max = 3 }, -- Adjusted Rewards for Level 2
        Washing = { Enable = true, Bills = { min = 750, max = 2000, chance = 25 }, Bands = { min = 750, max = 2000, chance = 20 }, Rolls = { min = 250, max = 750, chance = 40 } },
        Tax = { Enable = true, Percentage = 15 }, -- Tax settings on all money washing for Level 2
        RareItem = { Enable = true, Chance = 2, Reward = { Items = { "advancedlockpick", "ifaks" }, Min = 1, Max = 1 } }, -- Rare Item Reward for Level 2
        Robbery = { Enable = true, Delay = 1000, Difficulty = {'easy', 'medium', 'medium'}, Chance = 18, Inputs = {'1', '2', '3', '4'} }, -- Settings for the robbery minigame, Level 2 (enable, difficulty, chance of it occuring, etc)
    },
    [3] = {
        XPThreshold = 300, -- XP threshold for Level 3
        XPPerDelivery = 1, -- XP per delivery (package) for Level 3
        CallCopsChance = 10, -- Chance for the cops to be called when a player delivers a package.
        ItemReward = { Item = "oxy", Min = 1, Max = 4 }, -- Adjusted Rewards for Level 3
        Washing = { Enable = true, Bills = { min = 750, max = 2000, chance = 40 }, Bands = { min = 750, max = 2000, chance = 45 }, Rolls = { min = 250, max = 750, chance = 55 } }, -- Settings for the money washing, Level 1 (enable, min/max payouts, etc)
        Tax = { Enable = false, Percentage = 0 }, -- Tax settings on all money washing for Level 3
        RareItem = { Enable = true, Chance = 2, Reward = { Items = { "armor_injector", "health_injector" }, Min = 1, Max = 1 } }, -- Rare Item Reward for Level 3
        Robbery = { Enable = true, Delay = 1500, Difficulty = {'easy', 'easy', 'easy'}, Chance = 7, Inputs = {'1', '2', '3', '4'} }, -- Settings for the robbery minigame, Level 3 (enable, difficulty, chance of it occuring, etc)
    }
}

-- Example of a custom difficulty setting that can be implemented into Config.Levels[PlayerLevel].Robbery.Difficulty
--[[
        -- Custom difficulty setting
        {
            areaSize = 35,         -- Custom size of the success area
            speedMultiplier = 1.25 -- Custom speed multiplier for the indicator
        },
]]

-- NPC Route Spawn
Config.DriveStyle = 39 -- THIS CAN BE CHANGED AT https://www.vespura.com/fivem/drivingstyle/
Config.Deliveries = { Min = 4, Max = 6 } -- Min and Max amount of deliveries per run.
Config.Cars = {"glendale", "ingot", "buccaneer2", 'dominator', 'dukes', 'ruiner', 'tampa', 'futo', 'brioso', 'rocoto', 'serrano', 'buffalo', 'exemplar', 'felon'} -- Vehicle models that can be used for the deliveries.
Config.TimeBetweenCars = { Min = 15, Max = 30 } -- Min and Max amount of time between each car spawn. (In Seconds)
Config.DriverPed = { "s_m_m_gentransport", "a_m_m_eastsa_01", "s_m_m_trucker_01" } -- Ped models for the driver.

Config.Routes = {
    [1] = { -- Level 1
        {
            info = {
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 121.76 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(-691.34, -1058.22, 14.5), stop = false }, -- SPAWN POINT
                { pos = vector3(-742.16, -1047.58, 12.3), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(-745.23, -915.48, 19.34), stop = false }, -- DESPAWN POINT
            }
        },
        {
            info = {
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 12.72 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(-1950.15, 291.84, 86.95), stop = false }, -- SPAWN POINT
                { pos = vector3(-1909.73, 332.67, 88.31), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(-1878.72, 338.47, 88.02), stop = false }, -- DESPAWN POINT
            }
        },
        {
            info = {
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 216.91 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(-1600.32, -158.58, 54.82), stop = false }, -- SPAWN POINT
                { pos = vector3(-1615.28, -220.87, 53.82), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(-1623.21, -251.5, 53.02), stop = false }, -- DESPAWN POINT
            }
        },
        {
            info = {
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 319.39 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(327.17, -1970.03, 23.37), stop = false }, -- SPAWN POINT
                { pos = vector3(403.87, -1992.61, 22.41), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(436.31, -2023.77, 22.72), stop = false }, -- DESPAWN POINT
            }
        },
        {
            info = {
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 230.89 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(31.74, -1486.05, 28.78), stop = false }, -- SPAWN POINT
                { pos = vector3(19.75, -1533.61, 28.56), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(-2.92, -1564.18, 29.27), stop = false }, -- DESPAWN POINT
            }
        },
        {
            info = {  -- University 2
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 254.35 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(-1511.3, 232.9, 60.46), stop = false }, -- SPAWN POINT
                { pos = vector3(-1603.57, 163.06, 59.49), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(-1661.02, 89.28, 63.91), stop = false }, -- DESPAWN POINT
            }
        },
        {
            info = {  -- University 3
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 41.97 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(-1821.65, 123.34, 75.96), stop = false }, -- SPAWN POINT
                { pos = vector3(-1740.53, 250.09, 65.23), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(-1616.84, 297.69, 58.74), stop = false }, -- DESPAWN POINT
            }
        },
    },
    [2] = { -- Level 2
        {
            info = {
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 46.79 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(-166.94, -1700.22, 31.75), stop = false }, -- SPAWN POINT FORUM DRIVE
                { pos = vector3(-118.38, -1610.66, 31.4), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(-51.5, -1601.91, 28.71), stop = false }, -- DESPAWN POINT
            }
        },
        {
            info = {
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 115.98 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(-1234.55, -1159.09, 7.07), stop = false }, -- SPAWN POINT
                { pos = vector3(-1281.39, -1155.42, 5.19), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(-1292.56, -1135.32, 5.35), stop = false }, -- DESPAWN POINT
            }
        },
        {
            info = {
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 21.37 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(299.77, 2606.65, 44.07), stop = false }, -- SPAWN POINT
                { pos = vector3(323.26, 2640.98, 43.97), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(346.47, 2650.71, 44.18), stop = false }, -- DESPAWN POINT
            }
        },
        {
            info = {
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 353.19 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(1058.02, 2676.97, 38.68), stop = false }, -- SPAWN POINT
                { pos = vector3(1137.97, 2679.15, 37.7), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(1188.94, 2679.3, 37.22), stop = false }, -- DESPAWN POINT
            }
        },
        {
            info = {
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 31.3 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(1902.48, 3819.1, 31.75), stop = false }, -- SPAWN POINT
                { pos = vector3(1961.1, 3853.16, 31.39), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(2000.25, 3823.83, 32.27), stop = false }, -- DESPAWN POINT
            }
        },
        {
            info = {  -- Paleto ParkingLot
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 221.71 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(-253.17, 6175.55, 31.36), stop = false }, -- SPAWN POINT
                { pos = vector3(-284.75, 6055.43, 31.51), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(-399.18, 6031.27, 31.42), stop = false }, -- DESPAWN POINT
            }
        },
        {
            info = {  -- Kortz center
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 99.51 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(-2236.76, 575.3, 167.52), stop = false }, -- SPAWN POINT
                { pos = vector3(-2306.26, 378.11, 174.47), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(-2269.93, 549.64, 171.97), stop = false }, -- DESPAWN POINT
            }
        },
        {
            info = {  -- City LOST
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 77.72 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(1102.28, -227.73, 69.19), stop = false }, -- SPAWN POINT
                { pos = vector3(957.21, -145.89, 74.34), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(888.02, -80.81, 78.76), stop = false }, -- DESPAWN POINT
            }
        },
    },
    [3] = { -- Level 3
        {
            info = {
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 159.00 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(253.96, -141.63, 64.63), stop = false }, -- SPAWN POINT ALTA PLACE
                { pos = vector3(220.58, -166.64, 56.64), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(18.89, -90.41, 58.64), stop = false }, -- DESPAWN POINT
            }
        },
        {
            info = {
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 214.17 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(2468.72, 2826.39, 47.74), stop = false }, -- SPAWN POINT
                { pos = vector3(2564.95, 2633.94, 37.3), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(2597.8, 2536.67, 30.64), stop = false }, -- DESPAWN POINT
            }
        },
        {
            info = {
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 200.91 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(1280.59, -1538.3, 45.25), stop = false }, -- SPAWN POINT
                { pos = vector3(1251.51, -1598.78, 52.31), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(1154.46, -1700.67, 34.91), stop = false }, -- DESPAWN POINT
            }
        },
        {
            info = {
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 34.45 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(-1200.46, -1408.23, 3.53), stop = false }, -- SPAWN POINT
                { pos = vector3(-1190.09, -1369.01, 4.01), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(-1131.28, -1337.85, 4.53), stop = false }, -- DESPAWN POINT
            }
        },
        {
            info = {  -- Vinewood Bowl
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 64.7 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(765.28, 618.28, 125.78), stop = false }, -- SPAWN POINT
                { pos = vector3(709.75, 661.28, 128.91), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(655.52, 667.96, 128.91), stop = false }, -- DESPAWN POINT
            }
        },
        {
            info = {  -- Balla Gang 2
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 145.55 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(113.99, -1833.06, 25.91), stop = false }, -- SPAWN POINT
                { pos = vector3(45.15, -1819.64, 24.46), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(-14.15, -1789.68, 27.86), stop = false }, -- DESPAWN POINT
            }
        },
        {
            info = {  -- GlobeOil
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 263.7 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(1717.27, 6397.4, 33.94), stop = false }, -- SPAWN POINT
                { pos = vector3(1867.26, 6408.16, 46.54), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(1775.73, 6402.06, 36.38), stop = false }, -- DESPAWN POINT
            }
        },
        {
            info = {  -- University
                occupied = false,
                hash = "", -- DON'T TOUCH
                startHeading = 347.59 -- HEADING OF CAR WHEN IT SPAWNS IN
            },
            locations = {
                { pos = vector3(-1604.2, 46.6, 61.1), stop = false }, -- SPAWN POINT
                { pos = vector3(-1680.06, 62.25, 63.98), stop = true }, -- WAIT FOR DELIVER
                { pos = vector3(-1743.3, 59.6, 67.91), stop = false }, -- DESPAWN POINT
            }
        },
    },
}

