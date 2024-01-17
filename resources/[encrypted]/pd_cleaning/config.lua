Config = {}

Config.debug = false

Config.framework = 'qbcore' -- Options: 'esx' or 'qbcore'

Config.useNewESXExport = false

-- supported types: 'mysql', 'oxmysql' and 'ghmattimysql'
Config.sqlDriver = 'oxmysql'

Config.minCountPoliceNeeded = 6 -- Amount of police officers needed for the valuable to spawn

Config.shouldCopsGetNotified = true -- Should police get notified when player gets caught stealing

Config.subtitleShowLength = 10 -- in seconds, how long tutorial subtitles will show on player's screen

Config.bannedTime = 20 -- in minutes

-- If players should receive a notification telling how much they earned after cleaning an apartment
Config.sendSalaryNotification = true

--If fade in and fade out effects should appear when player enters/exits an apartment
Config.fadeEffect = true

--Properties for all drawn markers
Config.markers = {
    scaleX = 1.8,
    scaleY = 1.8,
    scaleZ = 0.7,
    type = 1,
    r = 220,
    g = 160,
    b = 20,
    alpha = 90,
    rotationX = 0.0, -- must be decimal
    rotationY = 0.0, -- must be decimal
    rotationZ = 0.0, -- must be decimal
    textureDictionary = nil,
    textureName = nil,
    bobUpAndDown = false,
    faceCamera = false
}

Config.target = {
    enabled = false,
    system = 'ox_target' -- 'qtarget' or 'qb-target' or 'ox_target'  (Other systems might work as well)
}

Config.cleanerJob = {
    jobOnly = false,
    jobNames = {
        'cleaner'
    }
}

Config.enableBlipRoute = true -- If player should get a route to the apartment

Config.bucketModel = 'prop_tool_mopbucket'

Config.useSellLocations = false -- if sell locations should be accessible to players

Config.payout_account = "bank"

Config.policeJobNames = {
    'police'
}

-- If player's experience should reset if they get caught stealing
Config.playerExpReset = true

-- Enable if you're using an older version of oxmysql
Config.oldOxmysql = false

Config.chanceOfValuableSpawning = 2 -- %

Config.chanceOfCaughtStealing = 69 -- %

-- If player should be able to leave an apartment without cleaning anything (player will receive no payout and no experience)
Config.exitApartmentWithoutCleaning = true

-- Time it takes for the player to receive a new order
Config.timeToFindNewOrder = {
    min = 15, -- in seconds
    max = 45-- in seconds
}

Config.keybinds = {
    collect = 'G',
    interactMop = 'E',
    interactTrashBag = 'E',
    enterAndExitApartment = 'E',
    startAndEndWork = 'E',
    sellItems = 'E',
    mopFloor = 'G',
    checkExperience = 'H'
}

Config.startJobLocation = {
    x = 707.7,
    y = -960.4,
    z = 30.3,
}
-- Chance of mop successfully cleaning a floor stain (per click)
Config.chanceOfCleaning = 100 -- %

Config.experience = {
    {
        minExp = 0,
        maxExp = 100,
        payBonus = 5, -- %
        name = 'Beginner cleaner',
    },
    {
        minExp = 101,
        maxExp = 200,
        payBonus = 7, -- %
        name = 'Amateur cleaner',
    },
    {
        minExp = 201,
        maxExp = 300,
        payBonus = 12, -- %
        name = 'Advanced cleaner',
    },
    {
        minExp = 301,
        maxExp = 99999,
        payBonus = 15, -- %
        name = 'Expert cleaner',
    },
    minExpGain = 10,
    maxExpGain = 30
}

Config.interiors = {
    ['smallApartment'] = {
        minExpLvl = 1,
        ipl = 'small_apart',
        trashCount = 9,
        decalCount = 2,
        payoutMin = 60,
        payoutMax = 80,
        valuableSpawnLocation = {
            {
                x = -283.7,
                y = 1212.4,
                z = 275.8,
            },
            {
                x = -271.2,
                y = 1217.6,
                z = 276.3,
            }
        },
        playerSpawnLocation = {
            x = -277.1,
            y = 1204.2,
            z = 275.8,
        },
        mopSpawnLocation = {
            x = -273.1,
            y = 1208.8,
            z = 275.8,
        },
        bucketSpawnLocation = {
            x = -273.5,
            y = 1209.6,
            z = 275.8,
        },
        trashBagSpawnLocation = {
            x = -278.1,
            y = 1211.9,
            z = 275.5,
        },
        mainLocation = {
            x = -283.1,
            y = 1217.8,
            z = 275.8,
        },
        decalLocations = {
            {
                x = -279.1,
                y = 1220.5,
                z = 275.8,
            },
            {
                x = -276.2,
                y = 1222.5,
                z = 275.8,
            }
        },
        presetLocations = {
            {
                x = -273.95,
                y = 1220.1,
                z = 277.06,
            },
            {
                x = -273.9,
                y = 1208.9,
                z = 275.8,
            },
            {
                x = -281.8,
                y = 1222.2,
                z = 276.2,
            },
            {
                x = -276.4,
                y = 1221.1,
                z = 275.8,
            }
        }
    },
    ['lowEndApartment'] = {
        ipl = 'low_apartment',
        minExpLvl = 1,
        trashCount = 11,
        decalCount = 2,
        payoutMin = 70,
        payoutMax = 90,
        valuableSpawnLocation = {
            {
                x = 261.2,
                y = -1022.8,
                z = -98.4,
            },
            {
                x = 257.1,
                y = -1017.2,
                z = -98.5
            }
        },
        playerSpawnLocation = {
            x = 266.1,
            y = -1025.5,
            z = -101.0,
        },
        mopSpawnLocation = {
            x = 264.6,
            y = -1020.3,
            z = -99.0,
        },
        bucketSpawnLocation = {
            x = 264.8,
            y = -1021.5,
            z = -99.0,
        },
        trashBagSpawnLocation = {
            x = 265.5,
            y = -1017.7,
            z = -99.0,
        },
        mainLocation = {
            x = 259.2,
            y = -1016.2,
            z = -99.0,
        },
        decalLocations = {
            {
                x = 264.3,
                y = -1014.6,
                z = -99.0,
            },
            {
                x = 260.2,
                y = -1021.1,
                z = -99.0,
            }
        },
        presetLocations = {
            {
                x = 262.5,
                y = -1021.1,
                z = -99.0,
            },
            {
                x = 262.1,
                y = -1014.8,
                z = -99.0,
            },
            {
                x = 255.4,
                y = -1019.1,
                z = -99.0,
            },
            {
                x = 257.1,
                y = -1014.2,
                z = -99.0,
            }
        }
    },
    ['executive_office'] = {
        ipl = 'executive_dlc',
        minExpLvl = 3,
        trashCount = 14,
        decalCount = 5,
        payoutMin = 100,
        payoutMax = 200,
        valuableSpawnLocation = {
            {
                x = -1561.0,
                y = -572.6,
                z = 55.4,
            },
            {
                x = -1556.3,
                y = -576.7,
                z = 55.2,
            }
        },
        playerSpawnLocation = {
            x = -1580.9,
            y = -561.6,
            z = 54.4,
        },
        mopSpawnLocation = {
            x = -1579.5,
            y = -568.4,
            z = 54.4,
        },
        bucketSpawnLocation = {
            x = -1578.6,
            y = -569.8,
            z = 54.4,
        },
        trashBagSpawnLocation = {
            x = -1574.0,
            y = -565.4,
            z = 54.4,
        },
        mainLocation = {
            x = -1562.9,
            y = -579.6,
            z = 54.4,
        },
        decalLocations = {
            {
                x = -1575.8,
                y = -575.2,
                z = 54.4,
            },
            {
                x = -1573.9,
                y = -588.6,
                z = 54.4,
            },
            {
                x = -1569.6,
                y = -570.2,
                z = 54.4,
            },
            {
                x = -1565.0,
                y = -571.3,
                z = 54.4,
            },
            {
                x = -1562.1,
                y = -581.8,
                z = 54.4,
            },
            {
                x = -1567.0,
                y = -581.1,
                z = 54.4,
            },
            {
                x = -1567.1,
                y = -586.5,
                z = 54.4,
            },
            {
                x = -1571.5,
                y = -581.2,
                z = 54.4,
            },
            {
                x = -1576.0,
                y = -580.7,
                z = 54.4,
            },
            {
                x = -1575.4,
                y = -570.2,
                z = 54.4,
            },
            {
                x = -1571.3,
                y = -575.9,
                z = 54.4,
            },
            {
                x = -1582.6,
                y = -558.8,
                z = 54.4,
            },
        },
        presetLocations = {
            {
                x = -1581.7,
                y = -577.0,
                z = 54.4,
            },
            {
                x = -1561.1,
                y = -568.8,
                z = 54.4,
            },
            {
                x = -1564.0,
                y = -565.1,
                z = 54.4,
            },
            {
                x = -1570.2,
                y = -575.2,
                z = 54.4,
            }
        }
    },
    ['mediumGarage'] = {
        ipl = 'medium_garage',
        minExpLvl = 2,
        trashCount = 15,
        decalCount = 7,
        payoutMin = 150,
        payoutMax = 230,
        valuableSpawnLocation = {
            {
                x = 190.5,
                y = -920.9,
                z = -98.4,
            },
            {
                x = 206.9,
                y = -916.3,
                z = -97.9,
            }
        },
        playerSpawnLocation = {
            x = 198.3,
            y = -927.7,
            z = -98.9,
        },
        mopSpawnLocation = {
            x = 201.9,
            y = -927.6,
            z = -98.9,
        },
        bucketSpawnLocation = {
            x = 203.58,
            y = -927.8,
            z = -98.9,
        },
        trashBagSpawnLocation = {
            x = 195.2,
            y = -927.6,
            z = -98.9,
        },
        mainLocation = {
            x = 197.2,
            y = -919.3,
            z = -98.9,
        },
        decalLocations = {
            {
                x = 192.0,
                y = -916.2,
                z = -98.9,
            },
            {
                x = 192.1,
                y = -919.8,
                z = -98.9,
            },
            {
                x = 191.1,
                y = -927.0,
                z = -98.9,
            },
            {
                x = 198.2,
                y = -916.23,
                z = -98.9,
            },
            {
                x = 204.3,
                y = -916.3,
                z = -98.9,
            },
            {
                x = 201.7,
                y = -922.9,
                z = -98.9,
            },
            {
                x = 212.0,
                y = -919.5,
                z = -98.9,
            },
        },
        presetLocations = {
            {
                x = 205.7,
                y = -925.4,
                z = -98.9,
            },
            {
                x = 210.5,
                y = -919.3,
                z = -98.9,
            },
            {
                x = 205.6,
                y = -915.1,
                z = -98.9,
            }
        }
    },
}

--All decal types: https://imgur.com/a/fxXTiCC
Config.decal = {
    types = {
        1020,
        1010,
        4100
    },

    colorVariants = {
        {
            r = 0.427,
            g = 0.37,
            b = 0.29
        },
        {
            r = 0.4,
            g = 0.2,
            b = 0.0
        },
        {
            r = 0.2,
            g = 0.6,
            b = 0.2
        }
    },
    --The size of the decal (only integer numbers)
    minScale = 1,
    maxScale = 3
}

Config.locations = {
    {
        interiorKey = 'smallApartment',
        coords = {
            x = -1566.5,
            y = -404.0,
            z = 42.3,
        }
    },
    {
        interiorKey = 'smallApartment',
        coords = {
            x = -201.7,
            y = 186.2,
            z = 80.3,
        }
    },
    {
        interiorKey = 'smallApartment',
        coords = {
            x = 3.7,
            y = -201.1,
            z = 52.7,
        }
    },
    {
        interiorKey = 'smallApartment',
        coords = {
            x = 254.3,
            y = 25.22,
            z = 88.1,
        }
    },
    {
        interiorKey = 'executive_office',
        coords = {
            x = -185.5,
            y = -760.1,
            z = 30.4,
        }
    },
    {
        interiorKey = 'executive_office',
        coords = {
            x = 5.3,
            y = -707.1,
            z = 45.9,
        }
    },
    {
        interiorKey = 'executive_office',
        coords = {
            x = -81.8,
            y = -836.6,
            z = 40.5,
        }
    },
    {
        interiorKey = 'executive_office',
        coords = {
            x = -914.5,
            y = -455.6,
            z = 39.5,
        }
    },
    {
        interiorKey = 'lowEndApartment',
        coords = {
            x = -216.5,
            y = -1649.3,
            z = 34.4,
        }
    },
    {
        interiorKey = 'lowEndApartment',
        coords = {
            x = 431.1,
            y = -1559.4,
            z = 32.7,
        }
    },
    {
        interiorKey = 'lowEndApartment',
        coords = {
            x = 331.2,
            y = -2071.8,
            z = 20.2,
        }
    },
    {
        interiorKey = 'lowEndApartment',
        coords = {
            x = -1102.2,
            y = -1493.0,
            z = 4.8,
        }
    },
    {
        interiorKey = 'lowEndApartment',
        coords = {
            x = -1114.7,
            y = -1068.5,
            z = 2.15,
        }
    },
    {
        interiorKey = 'smallApartment',
        coords = {
            x = 254.3,
            y = 25.22,
            z = 88.1,
        }
    },
    {
        interiorKey = 'mediumGarage',
        coords = {
            x = 468.4,
            y = -1594.0,
            z = 29.2,
        }
    },
    {
        interiorKey = 'mediumGarage',
        coords = {
            x = 1219.5,
            y = -3234.3,
            z = 5.5,
        }
    },
    {
        interiorKey = 'mediumGarage',
        coords = {
            x = 1063.6,
            y = -2410.4,
            z = 29.9,
        }
    },
    {
        interiorKey = 'mediumGarage',
        coords = {
            x = -521.2,
            y = -2900.5,
            z = 6.0,
        }
    },
}

Config.sellLocations = {
    {
        locations = {
            --{
            --    x = 189.6,
            --    y = -14.5,
            --    z = 73.2
            --},
            --{
            --    x = 189.6,
            --    y = -14.5,
            --    z = 73.2
            --}
        },
        name = 'Valuable Buyer',
        showOnMap = false,
        useAccount = 'bank',
        blipIcon = 617,
        blipColor = 46,
        blipScale = 0.8,
        items = {
            {
                item = 'pd_watch',
                label = 'Exquisite watch',
                price = 5000,
            },
            {
                item = 'pd_ringset',
                label = 'Set of rings',
                price = 9000,
            },
            {
                item = 'pd_laptop',
                label = 'Laptop',
                price = 2400,
            },
            {
                item = 'pd_necklace',
                label = 'Pearl necklace',
                price = 6000,
            }
        },
    }
}



--Item models that spawn in interiors.
--To make interior specific models, create sub-table with interior key as the name
--IMPORTANT! If you want to add your own models, select non-breakable models as otherwise the trash might break!!!
Config.itemModels = {
    ['lowEndApartment'] = {
        'v_ret_247_ketchup2',
        'v_ret_fh_noodle',
        'ng_proc_sodacan_02b',
        'ng_proc_litter_plasbot2',
        'ng_proc_coffee_02a',
        'v_ret_247_noodle1',
        'v_ret_247_soappowder2',
        'prop_pizza_box_01',
        'prop_old_boot',
    },
    ['mediumGarage'] = {
        'prop_cardbordbox_01a',
        'prop_wheel_rim_05',
        'prop_oilcan_02a',
        'prop_oilcan_01a',
        'ng_proc_litter_plasbot2',
        'p_cs_bottle_01',
        'prop_ld_flow_bottle'
    },
    ['default'] = {
        'v_ret_247_ketchup2',
        'v_ret_fh_noodle',
        'ng_proc_sodacan_02b',
        'ng_proc_litter_plasbot2',
        'ng_proc_coffee_02a',
        'v_ret_247_noodle1',
        'v_ret_247_soappowder2',
        'prop_pizza_box_01',
        'prop_old_boot',
        'p_cs_bottle_01',
        'prop_ld_flow_bottle'
    },
}

Config.valuableItems = {
    {
        model = 'prop_jewel_pickup_new_01',
        item = 'pd_ringset',
        label = 'Set of rings'
    },
    {
        model = 'prop_jewel_02b',
        item = 'pd_watch',
        label = 'Exquisite watch'
    },
    {
        model = 'prop_jewel_04b',
        item = 'pd_ringset',
        label = 'Set of rings'
    },
    {
        model = 'prop_laptop_02_closed',
        item = 'pd_laptop',
        label = 'Laptop'
    },
    {
        model = 'p_jewel_necklace_02',
        item = 'pd_necklace',
        label = 'Pearl necklace'
    }
}

Config.blips = {
    locationBlip = {
        blipIcon = 40,
        blipColor = 26,
        blipScale = 1.0
    },
    HQBlip = {
        blipIcon = 480,
        blipColor = 26,
        blipScale = 1.3,
        blipName = "Cleaning services"
    },
    policeBlip = {
        sprite = 161,
        color = 47,
        scale = 2.0,
        alpha = 150,
        shortRange = false,
    },
}