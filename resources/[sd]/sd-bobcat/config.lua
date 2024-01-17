Config = {}

-- Map Settings
Config.MLOType = 'nopixel' -- 'nopixel' = The preset coordinates for Nopixels (Tobii's) MLO, 'gabz' = The preset coordinates for Gabz's MLO

-- General Settings
Config.BobcatDebug = false -- Change to true to enable PolyZone DebugPoly's for testing. (Some Targeting Solutions, like ox_target might not display PZ's)

Config.MinimumPolice = 3 -- minimum police to start heist
Config.Cooldown = 60 -- minutes
Config.DoorLock = 'ox' -- qb/nui/ox/cd
Config.UseTargetForDoors = true -- Instead of using the item to plant the thermite, you'd use your target (3rd eye) to interact with the doors..

Config.Items = { -- The items used at each part of the robbery
    Thermite = 'thermite',
    Keycard = 'bobcatkeycard',
    Bomb = 'c4_bomb'
}

-- Hacking Item Settings
Config.RemoveKeyCardOnUse = true
Config.RemoveKeyCardOnFail = false
Config.RemoveThermiteOnFail = false

-- Misc Settings
Config.ExplosionType = 2 -- vault door explosion - reference this for all explosion types: https://docs.fivem.net/natives/?_0xE3AD2BDBAEE269AC 
Config.MaxBombTime = 90 -- Maximum duration (in seconds) the user can set for the C4 Charge to detonate.

-- Alarm Settings
Config.Alarm = {
    SoundAlarm = true, -- Enable or disable the alarm sound

    -- Specific alarm coordinates for 'gabz' and 'nopixel'
    Coordinates = {
        gabz = vector3(877.35, -2129.76, 31.92), -- Alarm Sound Location for Gabz
        nopixel = vector3(890.13, -2294.9, 31.17), -- Alarm Sound Location for nopixel
    },

    SoundSettings = {
        Name = "ALARMS_KLAXON_03_CLOSE", -- Sound Name
        Ref = "", -- Sound Reference
        Timeout = 2, -- Sound Timeout in minutes
    }
}

-- Blip Settings
Config.Blip = {
    Enable = true, -- Change to false to disable the Blip
    Sprite = 106,
    Display = 4,
    Scale = 0.6,
    Colour = 5,
    Name = "Bobcat Security", -- Change the name to your liking

    Locations = {
        gabz = vector3(905.75, -2121.06, 31.23), -- Blip coords for Gabz
        nopixel = vector3(881.36, -2266.83, 30.47), -- Blip coords for Tobii/NoPixel Version
    }
}

-- Locations & State Management Settings
Config.Locations = {
    gabz = {
        FirstDoor = {location = vector3(915.22, -2122.0, 31.23), busy = false, hacked = false},
        SecondDoor = {location = vector3(908.89, -2120.6, 31.23), busy = false, hacked = false},
        ThirdDoor = {location = vector3(905.01, -2121.11, 31.23), busy = false, hacked = false},
        VaultDoor = {location = vector3(888.47, -2129.88, 31.81), busy = false, hacked = false},
        SMGs = {location = vector3(890.81, -2120.93, 31.25), busy = false, looted = true},
        Explosives = {location = vector3(891.57, -2126.32, 31.21), busy = false, looted = true},
        Rifles = {location = vector3(887.31, -2125.31, 31.01), busy = false, looted = true},
        Ammo = {location = vector3(885.87, -2127.59, 30.92), busy = false, looted = true}
    },
    nopixel = {
        FirstDoor = {location = vector3(882.29, -2258.11, 30.47), busy = false, hacked = false},
        SecondDoor = {location = vector3(880.64, -2264.07, 30.47), busy = false, hacked = false},
        ThirdDoor = {location = vector3(881.33, -2268.24, 30.47), busy = false, hacked = false},
        VaultDoor = {location = vector3(890.27, -2284.61, 30.47), busy = false, hacked = false},
        SMGs = {location = vector3(881.45, -2282.61, 30.47), busy = false, looted = true},
        Explosives = {location = vector3(882.31, -2286.33, 30.47), busy = false, looted = true},
        Rifles = {location = vector3(886.86, -2281.74, 30.47), busy = false, looted = true},
        Ammo = {location = vector3(886.65, -2287.11, 30.47), busy = false, looted = true}
    }
}

-- Hacking Settings
Config.MainMinigame = 'ps-ui' -- Choose between 'memorygame' or 'ps-ui' for the first two doors
Config.EnableHacking = true -- for the third door
Config.KeycardMinigame = 'ps-ui' -- Choose between 'mhacking', 'hacking', or 'ps-ui' for the third door
Config.VaultHacking = false -- Enable or disable vault hacking
Config.VaultMinigame = 'memorygame' -- Choose between 'memorygame' or 'ps-ui' for the vault

-- If you're using 'memorygame' as the minigame for the first two doors.
if Config.MainMinigame == 'memorygame' then
-- First Door Settings
Config.Blocks = "12" -- Number of correct blocks the player needs to click
Config.Attempts = "3" -- Number of incorrect blocks after which the game will fail
Config.Show = "6" -- Time in secs for which the right blocks will be shown
Config.Time = "45" -- Maximum time after timetoshow expires for player to select the right blocks

-- Second Door Settings
Config.Blocks2 = "12" -- Number of correct blocks the player needs to click
Config.Attempts2 = "3" -- Number of incorrect blocks after which the game will fail
Config.Show2 = "6" -- Time in secs for which the right blocks will be shown
Config.Time2 = "45" -- Maximum time after timetoshow expires for player to select the right blocks

-- If you're using 'ps-ui' as the minigame for the first two doors.
elseif Config.MainMinigame == 'ps-ui' then
-- First Door Settings
Config.TimeP = "12" -- Time in Seconds
Config.GridP = "5" -- Grid Size of minigame - Supports 5 and Upwards

-- Second Door Settings
Config.TimeP2 = "12" -- Time in Seconds
Config.GridP2 = "5" -- Grid Size of minigame - Supports 5 and Upwards
end

-- Third Door Hacking
if Config.KeycardMinigame == 'mhacking' then
Config.MinChar = "5" -- Characters Minimum
Config.MaxChar = "6" -- Characters Maximum
Config.Time = "30" -- Time

elseif Config.KeycardMinigame == 'hacking' then
Config.BobTime = 15 -- How much time do they have to enter the hack?
Config.BobBlocks = 4 -- How many different blocks can the hack have?
Config.BobRepeat = 1 -- How many times in a row do they need to hack the system?

elseif Config.KeycardMinigame == 'ps-ui' then
Config.Type = 'numeric' -- (alphabet, numeric, alphanumeric, greek, braille, runes)
Config.TimeP3 = 30 -- Time in Seconds
Config.Mirrored = 0 -- (0: Normal, 1: Normal + Mirrored 2: Mirrored only )
end

-- Vault Hacking
if Config.VaultMinigame == 'memorygame' then
Config.Blocks3 = "12" -- Number of correct blocks the player needs to click
Config.Attempts3 = "3" -- Number of incorrect blocks after which the game will fail
Config.Show3 = "6" -- Time in secs for which the right blocks will be shown
Config.Time3 = "45" -- Maximum time after timetoshow expires for player to select the right blocks

elseif Config.VaultMinigame == 'ps-ui' then
Config.Blocks4 = 4 -- The amount of blocks 
Config.Time4 = 7 -- Time in Seconds
end

-- Rewards from the Crates
Config.Crates = {
    smgs = {
        Amount = {5, 8}, -- Amount is randomized between the 1st and 2nd number
        Items = {
            "weapon_smg",
            "weapon_microsmg",
            "weapon_machinepistol",
            "weapon_minismg",
            "weapon_pistol50"
        }
    },
    rifles = {
        Amount = {3, 6}, -- Amount is randomized between the 1st and 2nd number
        Items = {
            "weapon_assaultrifle", 
            "weapon_compactrifle",
            "weapon_mg",
            "weapon_pumpshotgun",
        }
    },
    explosives = {
        Amount = {2, 4}, -- Amount is randomized between the 1st and 2nd number
        Items = {
            "weapon_grenade",
            "weapon_molotov",
            "weapon_stickybomb",
        }
    },
    ammo = {
        Amount = {6, 8}, -- Amount is randomized between the 1st and 2nd number
        Items = {
            "mg_ammo",
            "shotgun_ammo",
            "smg_ammo",
            "rifle_ammo",
            "pistol_ammo",
        }
    }
}

-- Guards
Config.EnableGuards = true -- Enable NPC Guards for Bobcat

Config.PedParameters = { -- Guard Settings
    Ped = "s_m_m_prisguard_01",             -- The Model of the Ped, you'd like to use.
    Health = 200,                        -- The health of guards (both maximum and initial)
    Weapon = {"WEAPON_PISTOL", "WEAPON_SMG", "WEAPON_ASSAULTRIFLE"}, -- List of Weapons that the peds may have. (Randomized)
    MinArmor = 50,                       -- Minimum Amount of Armor the ped can have
    MaxArmor = 100,                      -- Maximum Amount of Armor the ped can have
    Headshots = true,                    -- Determines if guards can suffer critical hits (e.g., headshots)
    CombatAbility = 100,                 -- The combat ability of guards (0-100, 100 being the highest)
    Accuracy = 60,                       -- The accuracy of guards' shots (0-100, 100 being the highest)
    CombatRange = 2,                     -- The combat range of guards (0 = short, 1 = medium, 2 = long)
    CombatMovement = 2,                  -- The combat movement style of guards (0 = calm, 1 = normal, 2 = aggressive)
}

Config.Guards = { -- Map Specific Guard Settings
    gabz = { -- GABZ Map Settings (if Config.MLOType = 'GABZ')
        {
            coords = { -- Coordinates for each Ped Spawn
            vector4(898.9, -2124.34, 31.23, 350.39),
            vector4(895.61, -2129.21, 31.23, 344.53),
            vector4(898.04, -2134.72, 31.23, 355.54),
            vector4(890.74, -2135.87, 31.23, 338.76),
            vector4(883.63, -2135.02, 31.23, 261.97),
            vector4(877.78, -2132.36, 31.23, 248.4)
            }
        },
    },
    nopixel = { -- NoPixel Map Settings (if Config.MLOType = 'nopixel')
        {
            coords = { -- Coordinates for each Ped Spawn
            vector4(889.25, -2277.2, 30.47, 45.51),
            vector4(894.96, -2275.74, 30.47, 76.28),
            vector4(895.44, -2279.01, 30.47, 68.48),
            vector4(893.06, -2289.42, 30.47, 18.59),
            vector4(895.49, -2288.31, 30.47, 8.73),
            vector4(892.22, -2287.31, 30.47, 354.18)
            }
        },
    },
}

Config.EnableLooting = true -- Do you want to be able to Loot the Guards.

-- Rewards from Looting Peds
-- Note that 'chance' does not need to add up to 100 across all categories. It's a weight indicating the likelihood of a particular category being chosen relative to others. So, a category with chance 20 is twice as likely to be chosen as a category with chance 10.
-- Only ONE 'isGunReward' can be chosen for each loot. This means that even if the 'itemRange' allows for 4 items, only 3 items will be chosen if all the 'isGunReward' are set to true, as only one gun reward can be given per loot. If you want the users to have a chance to receive multiple weapons from different categories per loot, you need to set 'isGunReward' to false for the additional weapon categories.
-- For example, if 'itemRange' is set to 4, and Pistol, Rare, SMG & Shotgun all have 'isGunReward' set to true, then a max of 3 items will be given (one of which is a weapon). To potentially get 4 items with more than one weapon, at least one of these categories must have 'isGunReward' set to false.
Config.Rewards = {
    weaponChance = 60, -- overall chance of getting any gun-related reward
    itemRange = {min = 2, max = 3}, -- 'itemRange' determines the minimum and maximum number of items a player can get from each loot
    PistolRewards = {
        items = {"weapon_heavypistol", "weapon_pistol", "weapon_pistol_mk2"}, -- 'items' is the list of possible rewards
        chance = 37, -- 'chance' is the percentage probability of getting a reward
        isGunReward = true -- 'isGunReward' indicates whether this category is gun-related. If true, only one item from this category will be chosen per loot, even if 'itemRange' allows for more items.
    },
    RareRewards = {
        items = {"weapon_assaultrifle", "weapon_compactrifle", "weapon_mg"}, -- Items
        chance = 15, -- %
        isGunReward = true -- 'isGunReward' indicates whether this category is gun-related. If true, only one item from this category will be chosen per loot, even if 'itemRange' allows for more items.
    },
    SMGRewards = {
        items = {"weapon_assaultsmg", "weapon_minismg", "weapon_combatpdw"}, -- Items
        chance = 32, -- %
        isGunReward = true -- 'isGunReward' indicates whether this category is gun-related. If true, only one item from this category will be chosen per loot, even if 'itemRange' allows for more items.
    },
    ShotgunRewards = {
        items = {"weapon_sawnoffshotgun", "weapon_pumpshotgun", "weapon_dbshotgun"}, -- Items
        chance = 25, -- %
        isGunReward = true -- 'isGunReward' indicates whether this category is gun-related. If true, only one item from this category will be chosen per loot, even if 'itemRange' allows for more items.
    },
    AmmoRewards = {
        items = {"pistol_ammo", "shotgun_ammo", "rifle_ammo", "smg_ammo"}, -- Items
        chance = 45, -- %
        amount = {min = 1, max = 2} -- specifying amount that can be given if AmmoRewards is picked.
    },
    MedicRewards = {
        items = {"bandage"}, -- Items
        chance = 45, -- %
        amount = {min = 1, max = 2} -- specifying amount that can be given if MedicRewards is picked.
    },
}