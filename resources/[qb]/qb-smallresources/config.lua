Config = {}

Config.UseTarget = GetConvar('UseTarget', 'false') == 'true' -- Use qb-target interactions (don't change this, go to your server.cfg and add `setr UseTarget true` to use this and just that from true to false or the other way around)
Config.PauseMapText = 'Midnight City Roleplay' -- Text shown above the map when ESC is pressed. If left empty 'FiveM' will appear
Config.HarnessUses = 20
Config.DamageNeeded = 100.0 -- amount of damage till you can push your vehicle. 0-1000

Config.AFK = {
    ignoredGroups = {
        ['mod'] = true,
        ['admin'] = true,
        ['god'] = true
    },
    secondsUntilKick = 1800, -- AFK Kick Time Limit (in seconds)
    kickInCharMenu = false -- Set to true if you want to kick players for being AFK even when they are in the character menu.
}


Config.AIResponse = {
    wantedLevels = false, -- if true, you will recieve wanted levels
    dispatchServices = { -- AI dispatch services
        [1] = false, -- Police Vehicles
        [2] = false, -- Police Helicopters
        [3] = false, -- Fire Department Vehicles
        [4] = false, -- Swat Vehicles
        [5] = false, -- Ambulance Vehicles
        [6] = false, -- Police Motorcycles
        [7] = false, -- Police Backup
        [8] = false, -- Police Roadblocks
        [9] = false, -- PoliceAutomobileWaitPulledOver
        [10] = false, -- PoliceAutomobileWaitCruising
        [11] = false, -- Gang Members
        [12] = false, -- Swat Helicopters
        [13] = false, -- Police Boats
        [14] = false, -- Army Vehicles
        [15] = false -- Biker Backup
    }
}

-- To Set This Up visit https://forum.cfx.re/t/how-to-updated-discord-rich-presence-custom-image/157686
Config.Discord = {
    isEnabled = false, -- If set to true, then discord rich presence will be enabled
    applicationId = '00000000000000000', -- The discord application id
    iconLarge = 'logo_name', -- The name of the large icon
    iconLargeHoverText = 'This is a Large icon with text', -- The hover text of the large icon
    iconSmall = 'small_logo_name', -- The name of the small icon
    iconSmallHoverText = 'This is a Small icon with text', -- The hover text of the small icon
    updateRate = 60000, -- How often the player count should be updated
    showPlayerCount = true, -- If set to true the player count will be displayed in the rich presence
    maxPlayers = 48, -- Maximum amount of players
    buttons = {
        {
            text = 'First Button!',
            url = 'fivem://connect/localhost:30120'
        },
        {
            text = 'Second Button!',
            url = 'fivem://connect/localhost:30120'
        }
    }
}

Config.Density = {
    parked = 0.8,
    vehicle = 0.5,
    multiplier = 0.5,
    peds = 0.5,
    scenario = 0.4
}

Config.Disable = {
    hudComponents = {1, 2,  4, 7, 9, 13, 14, 19, 20, 21, 22}, -- Hud Components: https://docs.fivem.net/natives/?_0x6806C51AD12B83B8
    controls = {37}, -- Controls: https://docs.fivem.net/docs/game-references/controls/
    displayAmmo = true, -- false disables ammo display
    ambience = false, -- disables distance sirens, distance car alarms, flight music, etc
    idleCamera = true, -- disables the idle cinematic camera
    vestDrawable = true, -- disables the vest equipped when using heavy armor
    pistolWhipping = true, -- disables pistol whipping
}

Config.Consumables = {
    eat = { -- default food items
        ['sandwich'] = math.random(5,8),
        ['tosti'] = math.random(5,8),
        ['twerks_candy'] = math.random(5,8),
        ['snikkel_candy'] = math.random(5,8)
    },
    drink = { -- default drink items
        ['water_bottle'] = math.random(5,8),
        ['kurkakola'] = math.random(5,8),
        ['coffee'] = math.random(5,8)
    },
    alcohol = { -- default alcohol items
        ['whiskey'] = math.random(5,8),
        ['beer'] = math.random(5,8),
        ['vodka'] = math.random(5,8),
    },
    custom = { -- put any custom items here
    -- ['newitem'] = {
    --     progress = {
    --         label = 'Using Item...',
    --         time = 5000
    --     },
    --     animation = {
    --         animDict = 'amb@prop_human_bbq@male@base',
    --         anim = 'base',
    --         flags = 8,
    --     },
    --     prop = {
    --         model = false,
    --         bone = false,
    --         coords = false, -- vector 3 format
    --         rotation = false, -- vector 3 format
    --     },
    --     replenish = {'''
    --         type = 'Hunger', -- replenish type 'Hunger'/'Thirst' / false
    --         replenish = math.random(20, 40),
    --         isAlcohol = false, -- if you want it to add alcohol count
    --         event = false, -- 'eventname' if you want it to trigger an outside event on use useful for drugs
    --         server = false -- if the event above is a server event
    --     }
    -- }
    }
}

Config.Fireworks = {
    delay = 5, -- time in s till it goes off
    items = { -- firework items
        'firework1',
        'firework2',
        'firework3',
        'firework4'
    }
}

Config.BlacklistedScenarios = {
    types = {
        'WORLD_VEHICLE_MILITARY_PLANES_SMALL',
        'WORLD_VEHICLE_MILITARY_PLANES_BIG',
        'WORLD_VEHICLE_AMBULANCE',
        'WORLD_VEHICLE_POLICE_NEXT_TO_CAR',
        'WORLD_VEHICLE_POLICE_CAR',
        'WORLD_VEHICLE_POLICE_BIKE'
    },
    groups = {
        2017590552,
        2141866469,
        1409640232,
        `ng_planes`
    }
}

Config.BlacklistedVehs = {
    [`shamal`] = true,
    [`luxor`] = true,
    [`luxor2`] = true,
    [`jet`] = true,
    [`lazer`] = true,
    [`buzzard`] = true,
    [`buzzard2`] = true,
    [`annihilator`] = true,
    [`savage`] = true,
    [`titan`] = true,
    [`rhino`] = true,
    [`firetruck`] = true,
    --[`mule`] = true,
    [`maverick`] = true,
    [`blimp`] = true,
    [`airtug`] = true,
    [`camper`] = true,
    [`hydra`] = true,
    [`oppressor`] = true,
    [`technical3`] = true,
    [`insurgent3`] = true,
    [`apc`] = true,
    [`tampa3`] = true,
    [`trailersmall2`] = true,
    [`halftrack`] = true,
    [`hunter`] = true,
    [`vigilante`] = true,
    [`akula`] = true,
    [`barrage`] = true,
    [`khanjali`] = true,
    [`caracara`] = true,
    [`blimp3`] = true,
    [`menacer`] = true,
    [`oppressor2`] = true,
    [`scramjet`] = true,
    [`strikeforce`] = true,
    [`cerberus`] = true,
    [`cerberus2`] = true,
    [`cerberus3`] = true,
    [`scarab`] = true,
    [`scarab2`] = true,
    [`scarab3`] = true,
    [`rrocket`] = true,
    [`ruiner2`] = true,
    [`deluxo`] = true,
    [`cargoplane2`] = true,
    [`voltic2`] = true
}

Config.BlacklistedWeapons = {
    [`WEAPON_RAILGUN`] = true,
}

Config.BlacklistedPeds = {
    [`s_m_y_ranger_01`] = true,
    [`s_m_y_sheriff_01`] = true,
    [`s_m_y_cop_01`] = true,
    [`s_f_y_sheriff_01`] = true,
    [`s_f_y_cop_01`] = true,
    [`s_m_y_hwaycop_01`] = true
}

Config.WeapDraw = {
    variants = {},--{130, 122, 3, 6, 8},
    weapons = {
        --'WEAPON_STUNGUN',
        'WEAPON_PISTOL',
        'WEAPON_PISTOL_MK2',
        'WEAPON_COMBATPISTOL',
        'WEAPON_APPISTOL',
        'WEAPON_PISTOL50',
        'WEAPON_REVOLVER',
        'WEAPON_SNSPISTOL',
        'WEAPON_HEAVYPISTOL',
        'WEAPON_VINTAGEPISTOL'
    }
}

-- Removing Entities
Config.Objects = { -- for object removal
    {coords = vector3(266.09, -349.35, 44.74), heading = 0, length = 200, width = 200, model = 'prop_sec_barier_02b'},
    {coords = vector3(285.28, -355.78, 45.13), heading = 0, length = 200, width = 200, model = 'prop_sec_barier_02a'},
}

Config.Coffees = {
    ['coffee'] = 20,
    ['macchiato'] = 20,
  }




-- -- You may add more than 2 selections and it will bring up a menu for the player to select which floor be sure to label each section though
-- Config.Teleports = {
--     [1] = { -- Elevator @ labs
--         [1] = { -- up
--             poly = {coords = vector3(3540.74, 3675.59, 20.99), heading = 167.5, length = 2, width = 2},
--             allowVeh = false, -- whether or not to allow use in vehicle
--             label = false -- set this to a string for a custom label or leave it false to keep the default. if more than 2 options, label all options

--         },
--         [2] = { -- down
--             poly = {coords = vector3(3540.74, 3675.59, 28.11), heading = 172.5, length = 2, width = 2},
--             allowVeh = false,
--             label = false
--         }
--     },
--     [2] = { --Coke Processing Enter/Exit
--         [1] = {
--             poly = {coords = vector3(909.49, -1589.22, 30.51), heading = 92.24, length = 2, width = 2},
--             allowVeh = false,
--             label = '[E] Enter Coke Processing'
--         },
--         [2] = {
--             poly = {coords = vector3(1088.81, -3187.57, -38.99), heading = 181.7, length = 2, width = 2},
--             allowVeh = false,
--             label = '[E] Leave'
--         }
--     },
--     [3] = { --PD
--         [1] = {
--             poly = {coords = vector3(463.4, -978.13, 30.99), heading = 92.24, length = 2, width = 2},
--             allowVeh = false,
--             label = '[E] 1'
--         },
--         [2] = {
--             poly = {coords = vector3(463.37, -978.26, 35), heading = 181.7, length = 2, width = 2},
--             allowVeh = false,
--             label = '[E] 2'
--         }
--     }
-- }

Config.Elevators = {
    --Elevator @ labs
    ['labs'] = {
        --Group = {"police", "ambulance"},                                -- Leave blank if you don't want to use Player Job - You can add jobs or gangs groups
        Sound = "liftSoundBellRing",                                                -- Leave blank if you don't want to use Custom Sound
        Name = "Humane Labs Elevator",
        Floors = {
            [1] = {
                Label = "Top Floor",
                FloorDesc = "Take The Elevator up",
                Restricted = false,
                Coords = vector3(3540.74, 3675.59, 28.11),
                ExitHeading = 172.5
            },
            [2] = {
                Label = "Bottom Floor",
                FloorDesc = "Take The Elevator down",
                Restricted = false,
                Coords = vector3(3540.74, 3675.59, 20.99),
                ExitHeading = 165.5
            },
        }
    },
    ['arcadius'] = {
        --Group = {"police", "ambulance"},                                -- Leave blank if you don't want to use Player Job - You can add jobs or gangs groups
        Sound = "liftSoundBellRing",                                                -- Leave blank if you don't want to use Custom Sound
        Name = "Arcadius Center Elevator",
        Floors = {
            [1] = {
                Label = "Office",
                FloorDesc = "Take The Elevator to the office",
                Restricted = false,
                Coords = vector3(-139.75, -617.4, 168.82),
                ExitHeading = 98.64
            },
            [2] = {
                Label = "Garage",
                FloorDesc = "Take The Elevator to the garage",
                Restricted = false,
                Coords = vector3(-143.95, -575.91, 32.42),
                ExitHeading = 157.59
            },
        }
    },
    ['eclipse'] = {
        --Group = {"police", "ambulance"},                                -- Leave blank if you don't want to use Player Job - You can add jobs or gangs groups
        Sound = "liftSoundBellRing",                                                -- Leave blank if you don't want to use Custom Sound
        Name = "Eclipse Nightclub Elevator",
        Floors = {
            [1] = {
                Label = "Eclipse Night Club",
                FloorDesc = "Where the Light and Dark Collide",
                Restricted = false,
                Coords = vector3(-815.63, -683.37, 123.42),
                ExitHeading = 275.00
            },
            [2] = {
                Label = "Ground Level",
                FloorDesc = "Leaving so soon?",
                Restricted = false,
                Coords = vector3(-814.4, -692.57, 28.06),
                ExitHeading = 275.00
            },
        }
    },
    ['midnight'] = {
        Group = {""},                                -- Leave blank if you don't want to use Player Job - You can add jobs or gangs groups
        Sound = "liftSoundBellRing",                                                -- Leave blank if you don't want to use Custom Sound
        Name = "Midnight Compound Elevator",
        Floors = {
            [1] = {
                Label = "3rd Floor",
                FloorDesc = "Studio",
                Restricted = true,
                Coords = vector3(-613.37, -1627.48, 37.01),
                ExitHeading = 171.73
            },
            [2] = {
                Label = "2nd Floor",
                FloorDesc = "Conference Room",
                Restricted = true,
                Coords = vector3(-613.54, -1627.5, 33.01),
                ExitHeading = 169.16
            },
            [3] = {
                Label = "1st Floor",
                FloorDesc = "Warehouse",
                Restricted = true,
                Coords = vector3(-595.07, -1612.7, 26.75),
                ExitHeading = 355.00
            },
        }
    },
    ['midnight2'] = {
        Group = nil,                                -- Leave blank if you don't want to use Player Job - You can add jobs or gangs groups
        Sound = "liftSoundBellRing",                                                -- Leave blank if you don't want to use Custom Sound
        Name = "Midnight Compound Elevator",
        Floors = {
            [1] = {
                Label = "3rd Floor",
                FloorDesc = "Planning Room",
                Restricted = true,
                Coords = vector3(-575.43, -1623.43, 33.01),
                ExitHeading = 183.7
            },
            [2] = {
                Label = "2nd Floor",
                FloorDesc = "Storage Room",
                Restricted = true,
                Coords = vector3(-595.07, -1612.7, 26.75),
                ExitHeading = 355.00
            },
            [3] = {
                Label = "1st Floor",
                FloorDesc = "Warehouse",
                Restricted = true,
                Coords = vector3(-580.22, -1613.84, 27.01),
                ExitHeading = 351.89
            },
            [4] = {
                Label = "Basement",
                FloorDesc = "Workshop",
                Restricted = true,
                Coords = vector3(-576.29, -1614.35, 19.32),
                ExitHeading = 176.82
            },
        }
    },
    -- ['bruceyapt'] = {
    --     --Group = {""},                                -- Leave blank if you don't want to use Player Job - You can add jobs or gangs groups
    --     Sound = "liftSoundBellRing",                                                -- Leave blank if you don't want to use Custom Sound
    --     Name = "Brucey Apartment",
    --     Floors = {
    --         [1] = {
    --             Label = "Main Floor",
    --             FloorDesc = "Take The Elevator up",
    --             Restricted = false,
    --             Coords = vector3(-778.86, 313.14, 85.7),
    --             ExitHeading = 355.00
    --         },
    --         [2] = {
    --             Label = "Apartment Access",
    --             FloorDesc = "Take The Elevator down",
    --             Restricted = false,
    --             Coords = vector3(-787.33, 315.74, 187.91),
    --             ExitHeading = 355.00
    --         },
    --     }
    -- },
    -- ['tequilala'] = {
    --     Group = {"tequilala"},                                -- Leave blank if you don't want to use Player Job - You can add jobs or gangs groups
    --     Sound = "liftSoundBellRing",                                                -- Leave blank if you don't want to use Custom Sound
    --     Name = "Tequilala Stairs",
    --     Floors = {
    --         [1] = {
    --             Label = "VIP Bar",
    --             FloorDesc = "Take The Stairs up",
    --             Restricted = true,
    --             Coords = vector3(-565.27, 284.64, 85.38),
    --             ExitHeading = 350.00
    --         },
    --         [2] = {
    --             Label = "Main Floor",
    --             FloorDesc = "Take The Stairs down",
    --             Restricted = true,
    --             Coords = vector3(-561.79, 289.82, 82.18),
    --             ExitHeading = 179.00
    --         },
    --     }
    -- },
    ['mrpd'] = {
        Group = {"police"},                                -- Leave blank if you don't want to use Player Job - You can add jobs or gangs groups
        Sound = "liftSoundBellRing",                                                -- Leave blank if you don't want to use Custom Sound
        Name = "Main Elevator",
        Floors = {
            [1] = {
                Label = "Roof / Helipad",
                FloorDesc = "Helipad & Roof Access",
                Restricted = true,
                Coords = vector3(467.07, -975.9, 43.7),
                ExitHeading = 175.92
            },
            [2] = {
                Label = "2nd Floor / Offices",
                FloorDesc = "Main Floor Mezzanine Access",
                Restricted = true,
                Coords = vector3(465.13, -975.99, 39.42),
                ExitHeading = 83.15
            },
            [3] = {
                Label = "1st Floor / Locker Rooms",
                FloorDesc = "Captains Officer & Locker Rooms",
                Restricted = true,
                Coords = vector3(465.42, -975.95, 35.06),
                ExitHeading = 84.56
            },
            [4] = {
                Label = "0 Main Entrance",
                FloorDesc = "Front Entrance Floor",
                Restricted = true,
                Coords = vector3(465.4, -975.86, 30.72),
                ExitHeading = 85.95
            },
            [5] = {
                Label = " -1 Garage",
                FloorDesc = "Garage & Other Facilities Access",
                Restricted = true,
                Coords = vector3(467.06, -975.76, 25.47),
                ExitHeading = 176.32
            },
        }
    },
}