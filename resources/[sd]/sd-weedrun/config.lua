Config = {}

-- General Settings
Config.MinimumPolice = 2
Config.CallCopsChance = 50 -- %Chance to alert police
Config.RunCost = 500 

Config.ItemEvents = 'new' -- new/old - 'new' for users that use an inventory with exports, for things such as HasItem (Introduced roughly on the 26th of August 2022) / 'old' for users that still use old qb-core functions, such as QBCore.Functions.HasItem
Config.Inventory = 'ps-inventory' -- (qb-inventory/lj-inventory etc..)(The Name of your Inventory) IF Config.ItemEvents is set to 'old' this Config doesn't matter.

Config.EnableCooldown = false
Config.Cooldown = 600 -- Seconds * Recommended to have some form of cooldown!

Config.SendEmail = true
Config.EnableAnimation = true
Config.Animation = "argue" -- Full list of emotes from dpEmotes can be found on the forum release page.

Config.Item = 'weedpackage' -- You can change this..

-- Blip Creation
Config.Blip = {
    Enable = false, -- Change to false to disable blip creation
    Sprite = 480,
    Display = 4,
    Scale = 0.6,
    Colour = 1,
    Name = "Mysterious Person", -- Name of the blip
}

-- Packaging Settings
Config.Items = { -- Item/Amount
    ['weedbud'] = 10,
    ['weed_skunk'] = 10,
    ['weed_haze'] = 10,
    ['weed_purple-haze'] = 10,
    ['weed_og-kush'] = 10,
    ['weed_amnesia'] = 10,
    ['weed_white-widow'] = 10
}

-- Starting Ped
Config.BossPed = `a_m_y_eastsa_01`

Config.BossLocation = {
    [1] = vector4(-101.39, 6521.59, 29.75, 302.00),
    [2] = vector4(246.57, 376.73, 105.69, 337.71),
    [3] = vector4(1960.90, 3826.50, 32.21, 115.05),
    [4] = vector4(1431.08, 3637.24, 34.91, 318.89)
}

-- Money Reward per delievery.
Config.MinReward = 2500
Config.MaxReward = 4000

-- Special Reward Chance
Config.SpecialRewardChance = 5 --%
Config.SpecialItem = "advancedlockpick"
Config.MaxSpecialReward = 1
Config.MinSpecialReward = 1

-- Cleaning Money
Config.CleanMoney = true 

Config.Amount = 'one' -- random/one -- Either a randomized amount of marked money (rolls, bands etc.) will be taken and cleaned from your inventory, or only one (per wash)!

Config.BagChance = 33 -- Marked Bills

Config.BandMaxPayout = 2000
Config.BandMinPayout = 750
Config.BandChance = 33 

Config.RollMaxPayout = 750
Config.RollMinPayout = 250
Config.RollChance = 33

-- Selling Peds
Config.handoffPeds = {
	[1] = {
        coords = vector4(-601.6, -1027.08, 22.56, 83.88),
        available = true -- dont touch
    }, 
    [2] = {
        coords = vector4(-1564.32, -406.44, 42.4, 225.44),
        available = true -- dont touch
    },
    [3] = {
        coords = vector4(902.4, -2273.12, 32.56, 265.44),
        available = true -- dont touch
    }, 
    [4] = {
        coords = vector4(-1790.52, -369.36, 45.12, 323.96),
        available = true -- dont touch
    },
    [5] = {
        coords = vector4(-1344.8, -722.36, 24.96, 131.04),
        available = true -- dont touch
    }, 
    [6] = {
        coords = vector4(429.44, -1905.0, 25.96, 136.04),
        available = true -- dont touch
    },
    [7] = {
        coords = vector4(1217.64, -1498.2, 34.84, 187.44),
        available = true -- dont touch
    }, 
    [8] = {
        coords = vector4(453.08, -1305.52, 30.12, 317.68),
        available = true -- dont touch
    },
    [9] = {
        coords = vector4(-326.16, -1305.8, 31.4, 354.00),
        available = true -- dont touch
    }, 
    [10] = {
        coords = vector4(-740.44, -279.64, 36.96, 282.92),
        available = true -- dont touch
    },
    [11] = {
        coords = vector4(-465.48, -1079.68, 23.56, 67.04),
        available = true -- dont touch
    }, 
    [12] = {
        coords = vector4(3.88, -200.68, 52.76, 159.12),
        available = true -- dont touch
    },
    [13] = {
        coords = vector4(1154.36, -1300.32, 34.84, 81.52),
        available = true -- dont touch
    }, 
    [14] = {
        coords = vector4(-1439.96, -378.16, 37.12, 112.44),
        available = true -- dont touch
    },
    [15] = {
        coords = vector4(-45.53, -1290.03, 29.22, 279.37),
        available = true -- dont touch
    }, 
    [16] = {
        coords = vector4(115.66, -1685.73, 33.49, 284.37),
        available = true -- dont touch
    },
    [17] = {
        coords = vector4(191.95, -2226.57, 6.97, 91.11),
        available = true -- dont touch
    }, 
    [18] = {
        coords = vector4(-399.02, -1885.76, 21.73, 342.02),
        available = true -- dont touch
    },
    [19] = {
        coords = vector4(-1063.42, -2215.09, 9.07, 150.94),
        available = true -- dont touch
    }, 
    [20] = {
        coords = vector4(-684.17, -1170.92, 10.61, 311.55),
        available = true -- dont touch
    },
    [21] = {
        coords = vector4(-914.03, -1313.41, 6.2, 300.98),
        available = true -- dont touch
    }, 
    [22] = {
        coords = vector4(-1323.25, -1025.48, 7.75, 121.79),
        available = true -- dont touch
    },
    [23] = {
        coords = vector4(-813.55, -585.08, 30.67, 312.75),
        available = true -- dont touch
    },
    [24] = {
        coords = vector4(-51.01, -356.08, 42.29, 340.93),
        available = true -- dont touch
    }, 
    [25] = {
        coords = vector4(-153.57, -41.12, 54.4, 66.56),
        available = true -- dont touch
    },
    [26] = {
        coords = vector4(-583.22, 195.42, 71.44, 99.8),
        available = true -- dont touch
    }, 
    [27] = {
        coords = vector4(-773.42, -187.89, 37.28, 117.77),
        available = true -- dont touch
    },
    [28] = {
        coords = vector4(-861.29, -355.99, 38.68, 26.15),
        available = true -- dont touch
    }, 
    [29] = {
        coords = vector4(-44.58, -587.2, 38.16, 66.61),
        available = true -- dont touch
    },
}
