Config = {}
-- Locales System Inspired by Code Design.
function Lcl(txt, ...) if SalvageLocales[txt] then return string.format(SalvageLocales[txt], ...) else print('Locale Error, Contact Server Admin. ('..txt..')') end end

Config.Framework = {
    Framework = "QBCore", --"QBCore" | "ESX"
    PolyZone = "PolyZone", -- "PolyZone" | "oxlib"
    Interaction = {
        UseTarget = GetConvar('UseTarget', 'false') == 'true', -- Leave true if you are using qb-target. Set to false to disable targetting and enable DrawText for all interactions
        Target = "oxtarget", -- "qb-target" ~ Requires PolyZone "PolyZone" ~ | "oxtarget" ~ Requires PolyZone "oxlib" ~
        OxLibDistanceCheck = false -- If true, most distance checks are done via oxlib, if false distance checks are done via built-in functions.
    },
    --Framework Overrides (You can change specific framework related functions to ones from other scripts.)
    UseOxInv = false, -- For ESX and QBCore. Lets ESX users have item metadata for the Power Saw and the Saw Blade Pack. Otherwise they'd have infinite use.
    Notifications = "qb", -- "okok" | "mythic" | "tnj" | "oxlib" | "qb" | "ESX" | "chat"
    Phone = "qs", -- "qb" | "gks" | "qs" | "npwd" (Notification instead of email) | ESX users may need to input their own phone system.
    Menu = "", -- 'oxlib' | 'nh-context' | Otherwise leave blank ("") to use Framework Settings.
    DrawText = "", -- "oxlib" | "okok" | "psui" | Otherwise leave blank ("") to use Framework Settings.
    Input = "", -- "oxlib" if using oxlib input, Otherwise leave blank ("") to use Framework Settings.
}

--General Config.
Config.Dev = false -- Set to 'true' if you are Testing the Resource (Only the FIRST wreck location spawns)
Config.Debug = false -- True = Enables Debug Prints
Config.DebugPoly = false -- True = Enable Green Polyzones
Config.Logs = false -- True = Logs Enabled | False = Logs Disabled
Config.InteractKey = "G" -- Key to press when interacting with things (Default : G | See Config.KeyList to know which string to change this value to.)
Config.ControlsDisabled = {36, 73, 322} -- Disable Controls when doing actions. Default : LEFT_CTRL, X, ESC
Config.EmailDataBase = true -- When true, fetches emails notifications data from SQL. Requires oxmysql and the 'player' needs to be altered with the provided SQL file.

--Notification Settings
Config.ShowMissingItem = true -- (ONLY WORKS FOR QBCORE) true : Shows Missing Item Image if player is missing an item.

-- Items
Config.PowerSawItem = "powersaw" -- Name for the Power Saw Item
Config.BrokenPowerSawItem = "brokenpowersaw" -- Name for the Bladeless Power Saw
Config.SawBladeItem = "sawblade" -- Name for a singular Saw Blade
Config.SawBladePackItem = "sawbladepack" -- Name for the saw blade pack

-- Power Saw Settings
Config.PowerSaw = {
    Durability = 50, -- Amount of Harvests a saw has before the blade breaks (Not counting SkillCheck Behaviour)
    BladesPerPack = 5 -- Amount of blades inside a Saw Blade Pack
    -- You can repair the saw by using a blade while having the broken saw in your inventory
}

Config.SalvageYardBlip = true

Config.SalvageBehaviour = "minigame" -- "minigame" : Uses custom-made blade heating minigame | "skillcheck" : Uses the skillcheck mechanic

Config.SalvageMinigame = {
    ProgressWhileIdle = true, -- if true, players can idle and still get materials.
    BladeHeatMultiplier = 3, -- How fast does blade heats up.
    BladeCoolingMultiplier = 1, -- How fast does the blade cools down
    MouseDownProgress = 5, -- "Progress" gained while holding down the mouse. Make this number higher if you want scraping to be faster when holding down the mouse button.
    Sweetspot = 7, -- Heat level where players can get bonus materials
    ShowSweetspot = true, -- Shows a prompt telling the player they're hitting the sweetspot
    BonusRollsSettings = {
        Notify = true, -- true : Notifies the player that they got bonus loot
        BonusAmount = {min = 1, max = 2} -- Players Receive X additional rolls when receiving items.
    },
    UIPosition = { -- Position for the UI
        Minigame = {scale = 0.8, x = 0.01, y = 0.6},
        Commands = {scale = 0.6, x = 0.01, y = 0.7}
    }
}

-- SkillCheck Option
Config.SkillCheck = {
    Enabled = true, -- If set to false, players simply receive materials overtime
    Repetition = {min = 1, max = 3}, -- Amount of repetition the skillcheck has.
    Duration = {min = 10, max = 10}, -- Duration for the SkillCheck (Seconds)
    Behaviour = {
        Type = "break", -- "break" Sawblade has a chance to break when failing the skillcheck | "bonusrolls" Get Bonus loot if the player succeeds the skillcheck | "stop" Player simply stops salvaging if failing the skillcheck.
        BreakSettings = {
            ChanceOfBreaking = 30 -- Chance of the Power Saw Breaking
        },
        BonusRollsSettings = {
            Notify = true, -- true : Notifies the player that they got bonus loot
            BonusAmount = {min = 1, max = 2} -- Players Receive X additional rolls when receiving items.
        }
    }
}

-- Scrapyard Ped Config
Config.ScrapyardPed = {
    Model = 'cs_floyd', -- Model Hash for the ped
    Coords = vector4(-433.15, -1713.92, 19.02, 294.73), -- Vector 4 (Position + Heading)
    Shop = true, -- Enables a shop for the ped to sell things (You can add as many items by following the template)
    ShopItems = {
        [1] = {
            name = 'powersaw',
            itemlabel = "Power Saw",
            price = 1000,
            stock = 10,
            info = {},
        },
        [2] = {
            name = 'sawbladepack',
            itemlabel = "Saw Blade Pack",
            price = 500,
            stock = 100,
            info = {}
        },
        [3] = {
            name = 'sawblade',
            itemlabel = "Saw Blade",
            price = 100,
            stock = 100,
            info = {},
        },
    }
}

Config.YardWrecks = {
    Blip = true, -- Shows a small offset circle on the minimap where the wreck spawns
    TruckChance = 10, -- Chance of the spawned wreck being a truck, doubling the rewards received, and stays twice longer.
    TimeBetweenSpawns = {min = 30, max = 60}, -- Time in seconds for an other wreck to spawn after the current one has depleted.
    HarvestsPerWrecks = {min = 20, max = 30}, -- Global amount of "harvests" a singular wreck has before depleting.
    ScrapTime = {min = 15, max = 25}, -- Time for players to harvest 1 set of materials.
    HarvestRolls = {min = 3, max = 4}, -- Number of material stacks given per harvests.
    HarvestMaterials = { -- Rarity gets rolled first, and then a random item from that rarity is selected.

        [1] = {item = "metalscrap",      amt = {min = 1, max = 3},    probability = 1/5},
        [2] = {item = "aluminum",        amt = {min = 1, max = 3},    probability = 1/5},
        [3] = {item = "steel",           amt = {min = 1, max = 3},    probability = 1/5},
        [4] = {item = "plastic",         amt = {min = 1, max = 3},    probability = 1/5},
        [5] = {item = "glass",           amt = {min = 1, max = 3},    probability = 1/5},
        [6] = {item = "rubber",          amt = {min = 1, max = 3},    probability = 1/5},
        [7] = {item = "carbon",          amt = {min = 1, max = 3},    probability = 1/5},
        [8] = {item = "iron",            amt = {min = 1, max = 3},    probability = 1/5},

        [9] = {item = "metalscrap",       amt = {min = 5, max = 10},    probability = 1/12},
        [10] = {item = "aluminum",        amt = {min = 5, max = 10},    probability = 1/12},
        [11] = {item = "steel",           amt = {min = 5, max = 10},    probability = 1/12},
        [12] = {item = "plastic",         amt = {min = 5, max = 10},    probability = 1/12},
        [13] = {item = "glass",           amt = {min = 5, max = 10},    probability = 1/12},
        [14] = {item = "rubber",          amt = {min = 5, max = 10},    probability = 1/12},
        [15] = {item = "carbon",          amt = {min = 5, max = 10},    probability = 1/12},
        [16] = {item = "iron",            amt = {min = 5, max = 10},    probability = 1/12},

        [17] = {item = "metalscrap",      amt = {min = 10, max = 20},    probability = 1/30},
        [18] = {item = "aluminum",        amt = {min = 10, max = 20},    probability = 1/30},
        [19] = {item = "steel",           amt = {min = 10, max = 20},    probability = 1/30},
        [20] = {item = "plastic",         amt = {min = 10, max = 20},    probability = 1/30},
        [21] = {item = "glass",           amt = {min = 10, max = 20},    probability = 1/30},
        [22] = {item = "rubber",          amt = {min = 10, max = 20},    probability = 1/30},
        [23] = {item = "carbon",          amt = {min = 10, max = 20},    probability = 1/30},
        [24] = {item = "iron",            amt = {min = 10, max = 20},    probability = 1/30},
    },
}

Config.WorldWrecks = { --Options for wrecks that spawn randomly on the island
    TimeBetweenWrecks = {min = 45, max = 60}, -- Time in minutes in between wreck spawns.
    DespawnTime = 60,-- Time in minutes for the wreck to despawn after spawning in. (Timer Resets every time a player has interacted with/receives materials from the wreck) (Checks every 5 minutes)
    ScrapTime = {min = 20, max = 30}, -- Time is seconds to harvest 1 set of materials
    Scenarios = { 'plane' }, -- Currently Only Supports 1 secnario (more to come)
    PreciseBlipDistance = 50,
    ['plane'] = { -- Setting for the crashed plane
        onGenerationEvent = false,
        onSpawnEvent = true, -- Spawns a Flight Recoder Box near the plane whihc can be excahnged for rewards
        health = {min = 50, max = 75}, -- Plane Wreck Health (Amount of Haversts before the plane depletes)
        HarvestRolls = {min = 3, max = 4}, -- Number of materials stacks given per harvests.
        WreckHash = 2710556893,
        HarvestMaterials = { -- Rarity gets rolled first, and then a random item from that rarity is selected.

            [1] = {item = "metalscrap",      amt = {min = 2, max = 6},    probability = 1/5},
            [2] = {item = "aluminum",        amt = {min = 2, max = 6},    probability = 1/5},
            [3] = {item = "steel",           amt = {min = 2, max = 6},    probability = 1/5},
            [4] = {item = "plastic",         amt = {min = 2, max = 6},    probability = 1/5},
            [5] = {item = "glass",           amt = {min = 2, max = 6},    probability = 1/5},
            [6] = {item = "rubber",          amt = {min = 2, max = 6},    probability = 1/5},
            [7] = {item = "carbon",          amt = {min = 2, max = 6},    probability = 1/5},
            [8] = {item = "iron",            amt = {min = 2, max = 6},    probability = 1/5},

            [9] = {item = "metalscrap",      amt = {min = 8, max = 15},    probability = 1/10},
            [10] = {item = "aluminum",       amt = {min = 8, max = 15},    probability = 1/10},
            [11] = {item = "steel",          amt = {min = 8, max = 15},    probability = 1/10},
            [12] = {item = "plastic",        amt = {min = 8, max = 15},    probability = 1/10},
            [13] = {item = "glass",          amt = {min = 8, max = 15},    probability = 1/10},
            [14] = {item = "rubber",         amt = {min = 8, max = 15},    probability = 1/10},
            [15] = {item = "carbon",         amt = {min = 8, max = 15},    probability = 1/10},
            [16] = {item = "iron",           amt = {min = 8, max = 15},    probability = 1/10},

            [17] = {item = "metalscrap",      amt = {min = 15, max = 30},    probability = 1/25},
            [18] = {item = "aluminum",        amt = {min = 15, max = 30},    probability = 1/25},
            [19] = {item = "steel",           amt = {min = 15, max = 30},    probability = 1/25},
            [20] = {item = "plastic",         amt = {min = 15, max = 30},    probability = 1/25},
            [21] = {item = "glass",           amt = {min = 15, max = 30},    probability = 1/25},
            [22] = {item = "rubber",          amt = {min = 15, max = 30},    probability = 1/25},
            [23] = {item = "carbon",          amt = {min = 15, max = 30},    probability = 1/25},
            [24] = {item = "iron",            amt = {min = 15, max = 30},    probability = 1/25},

            -- ['common'] = { -- Comon Rolls have a 40% chance of being selected
            --     {item = 'carbon', minQty = 3, maxQty = 5},
            --     {item = 'metalscrap', minQty = 3, maxQty = 6},
            --     {item = 'aluminum', minQty = 3, maxQty = 5},
            --     {item = 'steel', minQty = 3, maxQty = 5},
            --     {item = 'plastic', minQty = 3, maxQty = 6},
            --     {item = 'glass', minQty = 3, maxQty = 5},
            --     {item = 'rubber', minQty = 3, maxQty = 5},
            --     {item = 'iron', minQty = 7, maxQty = 9},
            -- },
            -- ['uncommon'] = { -- Uncommon roles have 30% chance of being selected
            --     {item = 'carbon', minQty = 4, maxQty =6},
            --     {item = 'metalscrap', minQty = 4, maxQty = 7},
            --     {item = 'aluminum', minQty = 4, maxQty = 6},
            --     {item = 'steel', minQty = 4, maxQty = 6},
            --     {item = 'plastic', minQty = 4, maxQty = 7},
            --     {item = 'glass', minQty = 4, maxQty = 6},
            --     {item = 'rubber', minQty = 4, maxQty = 6},
            --     {item = 'iron', minQty = 5, maxQty = 7},
            -- },
            -- ['rare'] = { -- Rare rolls have 15% chance of being selected
            --     {item = 'carbon', minQty = 2, maxQty = 3},
            --     {item = 'metalscrap', minQty = 5, maxQty = 8},
            --     {item = 'aluminum', minQty = 5, maxQty = 7},
            --     {item = 'steel', minQty = 5, maxQty = 7},
            --     {item = 'plastic', minQty = 5, maxQty = 8},
            --     {item = 'glass', minQty = 3, maxQty = 4},
            --     {item = 'rubber', minQty = 3, maxQty = 4},
            --     {item = 'iron', minQty = 7, maxQty = 9},

            -- },
            -- ['super-rare'] = { -- super-rare rolls have a 10% chance of being selected
            --     {item = 'bp_m45', minQty = 1, maxQty = 1},
            -- },
            -- ['special'] = { -- Spcial rolls have 5% chance of being selected
            --     {item = 'm9_mag', minQty = 1, maxQty = 1},
            --     {item = 'm9_barrel', minQty = 1, maxQty = 1},
            --     {item = 'm9_slide', minQty = 1, maxQty = 1},
            --     {item = 'm9_body', minQty = 1, maxQty = 1},
            --     {item = 'm45_barrel', minQty = 1, maxQty = 1},
            --     {item = 'm45_mag', minQty = 1, maxQty = 1},
            --     {item = 'g18_mag', minQty = 1, maxQty = 1},
            --     {item = 'g18_barrel', minQty = 1, maxQty = 1},
            --     {item = 'g18_slide', minQty = 1, maxQty = 1},
            -- }
        },
        Locations = { --posOverride is a position offset (if needed) | rotOverride is an override to the wreck rotation (if needed). Leave both at vector3(0,0,0) if they're not being used.
            { coords = vector4(-2499.19, 829.63, 282.54, 48.00), posOverride = vector3(0,0,0), rotOverride = vector3(0,0,0)},
            { coords = vector4(1472.84, -2689.45, 37.4, 187.35), posOverride = vector3(0,0,0), rotOverride = vector3(0,0,0)},
            { coords = vector4(1897.11, -1938.0, 171.19, 321.52), posOverride = vector3(0,0,0), rotOverride = vector3(0,0,0)},
            { coords = vector4(2096.06, -1258.34, 170.02, 135.49), posOverride = vector3(0,0,0), rotOverride = vector3(0,0,0)},
            { coords = vector4(2368.66, -562.87, 79.11, 211.35), posOverride = vector3(0,0,0), rotOverride = vector3(0,0,0)},
            { coords = vector4(2929.49, 511.06, 38.12, 254.97), posOverride = vector3(0,0,0), rotOverride = vector3(0,0,0)},
            { coords = vector4(2497.04, 1168.27, 77.99, 343.39), posOverride = vector3(0,0,0), rotOverride = vector3(0,0,0)},
            { coords = vector4(3461.25, 2792.16, 12.32, 281.3), posOverride = vector3(0,0,0), rotOverride = vector3(0,0,0)},
            { coords = vector4(3549.26, 2583.63, 8.19, 329.81), posOverride = vector3(0,0,0), rotOverride = vector3(0,0,0)},
            { coords = vector4(3700.15, 3091.56, 12.23, 212.1), posOverride = vector3(0,0,0), rotOverride = vector3(0,0,0)},
            { coords = vector4(3936.56, 3690.0, 20.98, 339.01), posOverride = vector3(0,0,-0.5), rotOverride = vector3(0,0,0)},
            { coords = vector4(2288.07, 6704.15, 24.9, 356.01), posOverride = vector3(0,0,0), rotOverride = vector3(0,0,0)},
            { coords = vector4(-1121.4, 4706.58, 238.84, 169.11), posOverride = vector3(0,0,0), rotOverride = vector3(0,0,0)},
            { coords = vector4(-1975.32, 2519.53, 0.88, 33.47), posOverride = vector3(0,0,0), rotOverride = vector3(0,0,0)},
            { coords = vector4(-697.17, 1394.82, 305.46, 165.59), posOverride = vector3(0,0,0), rotOverride = vector3(0,0,0)},
        }
    },
}

-- Flight Box Settings
Config.FlightBox = {
    HandInCoords = vector4(-894.05, -2401.67, 14.02, 152.58),
    Hash = 3705876410,
    Item = "flightbox",
    Reward = {
        Cash = {
            Enabled = true,
            Currency = "cash",
            Amount = {min = 3000, max = 5000}
        },
        Items = {
            Enabled = true,
            Items = {
                {item = "diamond", min = 2, max = 4}
            }
        }
    }
}

Config.WreckHash = { -- Model Hash for the wrecks spawning in the scrapyard.
    ['scrapyardsmall'] = {1434516869, 1069797899, 1487505949, 311860131, 2542644197, 865942478, 1120812170, 10106915, -1748303324}, -- Small Objects
    ['scrapyardbig'] = {04202418026}, -- Big Objects (Double Health)
}

Config.YardLocations = { -- Possible Spawn locations inside the scrapyard.
    vector4(-454.43, -1720.11, 18.71, 134.4),
    vector4(-422.59, -1678.5, 19.03, 258.18),
    vector4(-457.26, -1664.02, 19.03, 103.49),
    vector4(-507.18, -1657.97, 18.93, 126.07),
    vector4(-531.37, -1713.86, 19.26, 87.1),
    vector4(-497.3, -1753.6, 18.32, 264.4),
    vector4(-554.35, -1658.09, 19.22, 6.96),
    --vector4(-576.54, -1641.61, 19.43, 357.99),--Behind Gate
    vector4(-588.56, -1662.05, 19.36, 72.43),
    vector4(-580.59, -1694.05, 19.1, 163.91),
    vector4(-559.73, -1689.72, 19.27, 208.93),
    vector4(-475.03, -1708.7, 18.7, 76.33),
    vector4(-469.54, -1687.64, 18.94, 218.24),
    vector4(-492.87, -1647.36, 17.8, 239.4),
    vector4(-531.48, -1623.2, 17.8, 9.86)
}

Config.ScrapyardArea = { -- Coords for the Scrapyard PolyZone.
    label = 'scrapyardarea',
    minZ = 15.0,
    maxZ = 70.0,
    PolyZoneArea = {
        vector2(-383.72491455078, -1792.2681884766),
        vector2(-376.26303100586, -1717.1789550782),
        vector2(-334.90795898438, -1638.8327636718),
        vector2(-623.97625732422, -1572.728149414),
        vector2(-682.8568725586, -1663.0009765625),
        vector2(-519.31811523438, -1794.8049316406)
    },
    OxLibArea = {
		vec(-384.0, -1792.0, 0),
		vec(-376.0, -1717.0, 0),
		vec(-335.0, -1639.0, 0),
		vec(-624.0, -1573.0, 0),
		vec(-683.0, -1663.0, 0),
		vec(-519.0, -1795.0, 0),
    }
}

Config.KeyList = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}