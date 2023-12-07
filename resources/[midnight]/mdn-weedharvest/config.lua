Config = {}

-- ███████ ██████   █████  ███    ███ ███████ ██     ██  ██████  ██████  ██   ██
-- ██      ██   ██ ██   ██ ████  ████ ██      ██     ██ ██    ██ ██   ██ ██  ██
-- █████   ██████  ███████ ██ ████ ██ █████   ██  █  ██ ██    ██ ██████  █████
-- ██      ██   ██ ██   ██ ██  ██  ██ ██      ██ ███ ██ ██    ██ ██   ██ ██  ██
-- ██      ██   ██ ██   ██ ██      ██ ███████  ███ ███   ██████  ██   ██ ██   ██

Config.Core = "QBCore"

Config.CoreFolderName = "qb-core"

Config.OldQBCore = false -- set to true if you are using old QBCore



-- ██████  ██       █████  ███    ██ ████████ ███████     ██████  ███████ ██       █████  ████████ ███████ ██████
-- ██   ██ ██      ██   ██ ████   ██    ██    ██          ██   ██ ██      ██      ██   ██    ██    ██      ██   ██
-- ██████  ██      ███████ ██ ██  ██    ██    ███████     ██████  █████   ██      ███████    ██    █████   ██   ██
-- ██      ██      ██   ██ ██  ██ ██    ██         ██     ██   ██ ██      ██      ██   ██    ██    ██      ██   ██
-- ██      ███████ ██   ██ ██   ████    ██    ███████     ██   ██ ███████ ███████ ██   ██    ██    ███████ ██████

--Config.RequiredRep = 0 -- reputation required to plant this seed

Config.RepGiven = 2 -- rep added after they harvest the plant

Config.Foldername = "malmo-weedharvest" -- folder name if you replicate the folder to make a new farming

--[[
    * Make sure the seeds you add here are present in shared.lua and are useable items.
    * ["seed_genericplant"] -> seed name (make sure its a useable item in shared.lua)
    * label = label that will be visible as 3d text on top of plant
    * returnItems = table of items that will be given when harvested
    * itemName = item name that will be given when harvested
    * amount = how much item will be given
    * probability - in percentage the chances of getting that item
    * basedOnHealth - based on plant health, the amount will be chosen (say plant health is 50%, you will get half of the amount)
]]--

Config.Seed = {
    ["skunk_seed"] = {
        oldName = 'malmo_skunk_seed',
        oldBud = 'malmo_skunk',
        label = "Skunk Weed",
        rep = 0,
        stages = {
            [1] = 'bzzz_plants_weed_green_small', --seed
            [2] = 'bzzz_plants_weed_green_medium', --small
            [3] = 'bzzz_plants_weed_green_big', --medium
            [4] = 'bzzz_plants_weed_green_bud', --big
            [5] = 'bzzz_plants_weed_green_bud_big', --mature
        },
        finalItem = "malmo_skunk_plant",
        jointItem = 'skunk_joint',
        h = 21,
        wildPlants = {
            vector3(1266.37, 3615.3, 33.18),
            vector3(1388.11, 3267.35, 39.01),
            vector3(1588.08, 2920.96, 57.02),
            vector3(1841.23, 3117.58, 45.56),
            vector3(2193.33, 3495.44, 45.42),
            vector3(2404.04, 3733.89, 41.15),
            vector3(2686.15, 3577.23, 51.48),
            vector3(1946.05, 5204.17, 53.51),
            vector3(1605.04, 5292.47, 186.95),
            vector3(1797.57, 4770.36, 34.71),
        }
    },
    ["zkittles_seed"] = {
        oldName = 'malmo_zkittles_seed',
        oldBud = 'malmo_zkittles',
        label = "Zkittles",
        rep = 0,
        stages = {
            [1] = 'bzzz_plants_weed_purple_small', --seed
            [2] = 'bzzz_plants_weed_purple_medium', --small
            [3] = 'bzzz_plants_weed_purple_big', --medium
            [4] = 'bzzz_plants_weed_purple_bud', --big
            [5] = 'bzzz_plants_weed_purple_bud_big', --mature
        },
        finalItem = "malmo_zkittles_plant",
        jointItem = 'zkittles_joint',
        h = 40,
        wildPlants = {
            vector3(2744.84, 1998.43, 76.53),
            vector3(2895.83, 1895.69, 26.31),
            vector3(3197.0, 4229.42, 102.9),
            vector3(3058.74, 2195.92, 54.2),
            vector3(2998.4, 2520.1, 153.41),
            vector3(3300.62, 2720.69, 13.89),
            vector3(3294.14, 3391.01, 111.19),
            vector3(3237.95, 3517.43, 69.94),
            vector3(3460.99, 3308.03, 167.59),
            vector3(3664.57, 4028.12, 43.89),
        }
    },
    ["trainwreck_seed"] = {
        oldName = 'malmo_trainwreck_seed',
        oldBud = 'malmo_trainwreck',
        label = "Trainwreck",
        rep = 0,
        stages = {
            [1] = 'bzzz_plants_weed_red_small', --seed
            [2] = 'bzzz_plants_weed_red_medium', --small
            [3] = 'bzzz_plants_weed_red_big', --medium
            [4] = 'bzzz_plants_weed_red_bud', --big
            [5] = 'bzzz_plants_weed_red_bud_big', --mature
        },
        finalItem = "malmo_trainwreck_plant",
        jointItem = 'trainwreck_joint',
        h = 77,
        wildPlants = {
            vector3(511.57, 5522.25, 775.41),
            vector3(141.22, 5991.85, 217.38),
            vector3(176.14, 6264.64, 89.97),
            vector3(688.35, 6323.48, 87.86),
            vector3(-112.28, 4580.85, 112.06),
            vector3(-827.09, 4530.11, 88.6),
            vector3(-1303.23, 4473.69, 18.99),
            vector3(-1498.89, 4257.67, 46.13),
            vector3(-1988.02, 3556.43, 69.16),
            vector3(-2352.64, 3498.43, 40.34),

        }
    },
    ["garliccookies_seed"] = {
        oldName = 'malmo_garliccookies_seed',
        oldBud = 'malmo_garliccookies',
        label = "Garlic Cookies",
        rep = 0,
        stages = {
            [1] = 'bzzz_plants_weed_yellow_small', --seed
            [2] = 'bzzz_plants_weed_yellow_medium', --small
            [3] = 'bzzz_plants_weed_yellow_big', --medium
            [4] = 'bzzz_plants_weed_yellow_bud', --big
            [5] = 'bzzz_plants_weed_yellow_bud_big', --mature
        },
        finalItem = "malmo_garliccookies_plant",
        jointItem = 'garliccookies_joint',
        h = 30,
        wildPlants = {
            vector3(2310.0, 928.07, 113.24),
            vector3(2290.97, 1114.29, 61.91),
            vector3(2180.92, 1219.75, 79.68),
            vector3(1988.68, 1014.12, 223.18),
            vector3(1692.85, 164.48, 211.29),
            vector3(1511.7, -30.75, 124.07),
            vector3(1480.76, -451.13, 145.14),
            vector3(1697.29, -530.8, 153.88),
            vector3(1820.55, -765.18, 91.25),
            vector3(1963.49, -12.72, 189.75)
        }
    },
    ["malmokush_seed"] = {
        oldName = 'malmo_malmokush_seed',
        oldBud = 'malmo_malmok',
        label = "Malmo Kush",
        rep = 0,
        stages = {
            [1] = 'bzzz_plants_weed_blue_small', --seed
            [2] = 'bzzz_plants_weed_blue_medium', --small
            [3] = 'bzzz_plants_weed_blue_big', --medium
            [4] = 'bzzz_plants_weed_blue_bud', --big
            [5] = 'bzzz_plants_weed_blue_bud_big', --mature
        },
        finalItem = "malmo_malmokush_plant",
        jointItem = 'malmok_joint',
        h = 49,
        wildPlants = {
            vector3(1394.96, 6348.38, 27.7),
            vector3(1782.18, 5975.19, 202.9),
            vector3(2551.43, 6570.47, 19.58),
            vector3(2639.73, 6274.42, 131.68),
            vector3(2449.23, 6160.76, 179.93),
            vector3(1813.1, 6215.54, 134.83),
            vector3(415.31, 5064.07, 390.01),
            vector3(293.8, 4536.24, 57.35),
            vector3(246.44, 4296.61, 42.15),
            vector3(-1124.1, 4914.79, 218.96),

        }
    },
}


-- ████████  █████  ██████   ██████  ███████ ████████
--    ██    ██   ██ ██   ██ ██       ██         ██
--    ██    ███████ ██████  ██   ███ █████      ██
--    ██    ██   ██ ██   ██ ██    ██ ██         ██
--    ██    ██   ██ ██   ██  ██████  ███████    ██
--[[
    * The script will only work if you are using qb-target
    * Script doesnt support bt-target because bt-target lacks functionality that is needed to check the plants
    * only change this if you have renamed qb-target to something else for the exports to work fine
]]--
Config.Target = "qb-target"

--[[
    The EnableTargetExports config value is for those who want to add targets from outside the script.
    The event for target is

    --type = "client",
	--event = "qb-farming:client:checkClosestPlant", -- this event will change if you create a new folder so qb-farming will be replaced with Config.Foldername

    You will need to add this in config for qb-target.
]]--

Config.EnableTargetExports = true


-- ███████  ██████  ██ ██          ██████  ███████ ██       █████  ████████ ███████ ██████
-- ██      ██    ██ ██ ██          ██   ██ ██      ██      ██   ██    ██    ██      ██   ██
-- ███████ ██    ██ ██ ██          ██████  █████   ██      ███████    ██    █████   ██   ██
--      ██ ██    ██ ██ ██          ██   ██ ██      ██      ██   ██    ██    ██      ██   ██
-- ███████  ██████  ██ ███████     ██   ██ ███████ ███████ ██   ██    ██    ███████ ██████

--[[
    * ph decides the acidic and alkaline nature of the soil
    * fertility decides growth rate of the crop (between 0 to 1.0)
    * if Fertility is 0.5, the plant will take double the time to grow
]]--
Config.Soil = {
    ["1109728704"]  = { ph="acidic", fertility=1.0 },
    ["-1942898710"] = { ph="acidic", fertility=1.0 },
    ["-1286696947"] = { ph="basic", fertility=1.0 },
    ["-1885547121"] = { ph="basic", fertility=1.0 },
    ["312396330"]   = { ph="acidic", fertility=1.0 },
    ["1288448767"]  = { ph="basic", fertility=1.0 },
    ["-1595148316"] = { ph="basic", fertility=1.0 },
    ["510490462"]   = { ph="basic", fertility=1.0},
    ["1333033863"]  = { ph="acidic", fertility=1.0 },
    ["1144315879"]  = { ph="neutral", fertility=1.0 },
    ['InsideLab']   = { ph="neutral", fertility=1.0 },
}

Config.CanBurnPlants = true --True if you want anyone to burn down and destroy the plants.
Config.DestroyOptions = true --True if you want to display the destroy option on nui.


Config.InfectionProbability = 2    --between 1 to 100
Config.InsecticideEffect = 9        --Health increament of plant / insecticide
--0.463 for around 3 hours?
Config.ProgressPerCycle = 0.695      --Progress per cycle (this is only when the fertility of soil is 1.0. If its 0.5, Progress will 5. This value is multiplied by the Fertility of the soil.)
Config.CycleTime = 10           --Cycle time in minutes
-- So every 5 minutes, the plant will grow by 4.2%.

Config.WaterProbability = 100       --between 1 to 100 (this is 30% chance of water level dropping)
Config.WaterDepletion = 1           --Decrease in water level of plant / cycle time
Config.WaterEffect = 2              --Health decrement of plant when the water level is 0
Config.WaterIncreaseLevel = 15      --Increase in water level of plant when water is added
Config.StartingWaterLevel = 65      --Starting water level of plant

Config.Items = {
    ["acidic_soil_item"] = "alkaline_bottle", --item required if soil is acidic
    ["alkaline_soil_item"] = "acid_bottle", --item required if soil is basic/alkaline
    ["insecticide"] = "weed_insecticide", --insecticide item name
    ["water"] = "water_bottle",
    ["fertilizer"] = "weed_nutrition",
}

Config.ShowSoilHash = true -- this will print soil hash in F8 if true. You can turn it off on live if you dont want the spam


-- ███    ██  ██████  ████████ ██ ███████ ██    ██      █████  ███    ██ ██████      ██       ██████   ██████  █████  ██      ███████
-- ████   ██ ██    ██    ██    ██ ██       ██  ██      ██   ██ ████   ██ ██   ██     ██      ██    ██ ██      ██   ██ ██      ██
-- ██ ██  ██ ██    ██    ██    ██ █████     ████       ███████ ██ ██  ██ ██   ██     ██      ██    ██ ██      ███████ ██      █████
-- ██  ██ ██ ██    ██    ██    ██ ██         ██        ██   ██ ██  ██ ██ ██   ██     ██      ██    ██ ██      ██   ██ ██      ██
-- ██   ████  ██████     ██    ██ ██         ██        ██   ██ ██   ████ ██████      ███████  ██████   ██████ ██   ██ ███████ ███████

--[[
    * Notify Config
    * Set only one to true
    * Config.QBCoreNotify - Uses default QBCore notify system
    * Config.okokNotify - Uses OkOkNotify system
    * Config.pNotify - Uses pNotify system

    * Config.pNotifyLayout - set layout of where the notification will show. Check the layouts below.
    * Layouts:
                top
                topLeft
                topCenter
                topRight
                center
                centerLeft
                centerRight
                bottom
                bottomLeft
                bottomCenter
                bottomRight

    * Config.OkOkNotifyTitle - Title to show on okokNotify
]]--

Config.QBCoreNotify = true --Set to true if you are using base QBCore notify system
Config.okokNotify = false -- Set to true if you are using base OKOK notify system
Config.pNotify = false

Config.pNotifyLayout = "centerRight" --more options can be found in pNotify Readme. Make sure you put the right layout name.
Config.OkOkNotifyTitle = "Farming" --Title that displays on okoknotify

--Format of Config.Locale
--[[
    * name = label
    * Do not alter the name (for eg. ["health_label"] -> do not change this)
    * change the label (for eg. "Health" can be changed to whatever you want.)
]]--
Config.Locale = {
    ["health_label"] = "Health",
    ["collect_weed"] = "Collecting",
    ["harvesting_weed_progressbar"] = "Harvesting Leaves",
    ["not_suitable_soil"] = "Soil not Suitable",
    ["near_another_plant"] = "Near another Plant, choose another location.",
    ["plant_weed_progressbar"] = "Planting plants",
    ["soil_acidity_notify"] = "Soil is acidic, need bottle of alkaline to make it neutral",
    ["soil_alkaline_notify"] = "Soil is alkaline, need bottle of acid to make it neutral",
    ["slant_surface_notify"] = "Surface is slanted",
    ["no_surface_notify"] = "No Surface Found",
    ["no_plant_nearby"] = "No Plant Nearby!",
    ["near_another_plant_error"] = "Near another plant!",
    ["inventory_full_error"] = "Not enough space to carry!",
    ["no_insecticide"] = "You dont have insecticide",
    ["plant_not_ready"] = "Plant is not ready yet!",
    ["invalid_plant"] = "Not the right plant!",
    ["destroying_plant"] = "Destroying Plant!",
    ["need_reputation"] = "Need 100-300 Rep to Plant",
    ["need_rep_harvest"] = "You are not experienced enough to harvest!",
    ["no_water"] = "You do not have water",
    ["no_fertilizer"] = "You do not have fertilizer",
}


-- ██████  ██       █████  ███    ██ ████████     ███    ███  ██████  ██████  ███████ ██      ███████
-- ██   ██ ██      ██   ██ ████   ██    ██        ████  ████ ██    ██ ██   ██ ██      ██      ██
-- ██████  ██      ███████ ██ ██  ██    ██        ██ ████ ██ ██    ██ ██   ██ █████   ██      ███████
-- ██      ██      ██   ██ ██  ██ ██    ██        ██  ██  ██ ██    ██ ██   ██ ██      ██           ██
-- ██      ███████ ██   ██ ██   ████    ██        ██      ██  ██████  ██████  ███████ ███████ ███████

--[[
    These are the list with offset for some plant models that I tested that spawn. There are several plant models that don't spawn
    There are more plant objects other than this as well.
    You can also create your own props but if the prop size is too large, the server might lag due to spawning of high texture props
]]--

--[[
    1. p_int_jewel_plant_01 , Zoffset = 0.0
    2. p_int_jewel_plant_02 , Zoffset = 0.0
    3. prop_fbibombplant , Zoffset = -1.0
    4. v_ret_gc_plant1 , Zoffset = 0.0
    5. v_res_rubberplant , Zoffset = 0.0
    6. v_res_tre_plant , Zoffset = 0.0
    7. v_res_fa_plant01 , Zoffset = 0.0
    8. v_res_mplanttongue , Zoffset = 0.0
    9. v_res_m_bananaplant , Zoffset = -2.0
    10. prop_plant_fern_02a , Zoffset = 0.0
    11. prop_plant_palm_01b , Zoffset = -1.0
    12. prop_plant_palm_01a, Zoffset = -1.0
    13. prop_plant_int_01a , Zoffset = 0.0
    14. prop_plant_int_01b , Zoffset = 0.0
    15. prop_plant_int_02b , Zoffset = 0.0
    16. prop_plant_int_03a , Zoffset = 0.0
    17. prop_plant_int_03b , Zoffset = 0.0
    18. prop_plant_int_03c , Zoffset = 0.0
    19. prop_plant_int_04a , Zoffset = 0.0
    20. prop_plant_int_04b , Zoffset = 0.0
    21. prop_plant_int_04c , Zoffset = -1.0
]]--

-- ███████ ████████  █████   ██████  ███████ ███████
-- ██         ██    ██   ██ ██       ██      ██
-- ███████    ██    ███████ ██   ███ █████   ███████
--      ██    ██    ██   ██ ██    ██ ██           ██
-- ███████    ██    ██   ██  ██████  ███████ ███████

Config.Stages = {
    [1] = {
        min = 0,
        max = 20,
        state = "Seedling",
        model = "bkr_prop_weed_01_small_01c",
        offset = 0.0,
    },
    [2] = {
        min = 21,
        max = 40,
        state = "Small",
        model = "bkr_prop_weed_01_small_01a",
        offset = 0.0,
    },
    [3] = {
        min = 41,
        max = 60,
        state = "Medium",
        model = "bkr_prop_weed_med_01b",
        offset = 0,
    },
    [4] = {
        min = 61,
        max = 80,
        state = "Big",
        model = "bkr_prop_weed_lrg_01a",
        offset = 0,
    },
    [5] = {
        min = 81,
        max = 100,
        state = "Mature",
        model = "bkr_prop_weed_lrg_01b",
        offset = 0,
    },
}

Config.GrowLabs = {
    -- Vehicles
    --[0] = {loc = {coords = vector3(1605.16, 3774.0, 20.61), h = 130.0}, p = vector4(1616.54, 3780.76, 35.07, 316.9), door = -1989119929}, -- Sandy Near MC MLO (test)
    [1] = {loc = {coords = vector3(517.68, 3082.74, 26.39), h = 150.0}, p = vector4(526.07, 3092.98, 40.89, 270), door = -1989119929, entrance = vector3(527.36, 3093.08, 40.47)},-- Sandy Oil Field
    --[2] = {loc = {coords = vector3(2444.55, 4020.91, 22.68), h = 270.0}, p = vector4(2431.47, 4023.03, 37.15, 270), door = -1989119929}, -- Sandy Not far from Biker Garage
    --[3] = {loc = {coords = vector3(2328.0, 3329.67, 32.07), h = 100.0}, p = vector4(2431.24, 3329.84, 46.54, 100), door = -1989119929}, -- Sandy behind tool store / Not far from laptop bm spot
    --[4] = {loc = {coords = vector3(256.02, 3201.56, 28.68), h = 355.0}, p = vector4(252.76, 3188.71, 43.14, 355), door = -1989119929}, -- Sandy Near River
    --[5] = {loc = {coords = vector3(-196.8, 6520.17, -3.02), h = 220.0}, p = vector4(-203.55, 6531.56, 11.45, 220), door = -1989119929}, -- Paleto Pier
    --[6] = {loc = {coords = vector3(1523.66, 6356.7, 9.87), h = 5.0}, p = vector4(1522.66, 6343.48, 24.36, 5), door = -1989119929}, -- Paleto Crack
    --[7] = {loc = {coords = vector3(2535.84, 4978.72, 30.3), h = 320.0}, p = vector4(2525.79, 4970.07, 44.78, 320), door = -1989119929}, -- Grandma
    --[8] = {loc = {coords = vector3(296.96, 3381.37, 22.29), h = 110.0}, p = vector4(309.97, 3383.85, 36.77, 110), door = -1989119929}, -- ???

    -- Containers
    --[10] = {loc = {coords = vector3(892.05, -3021.67, -8.49), h = 90.0}}, -- Docks near trucking
    --[11] = {loc = {coords = vector3(668.6, -2740.34, -8.37), h = 90.0}}, -- Docks near merryweather
    --[12] = {loc = {coords = vector3(1067.91, -2323.35, 15.84), h = 85.0}}, -- Warehouses near oil fields
    --[13] = {loc = {coords = vector3(2881.09, 4375.84, 36.01), h = 115.0}}, -- Union Grains (bad)
    --[14] = {loc = {coords = vector3(1659.65, 4703.07, 28.73), h = 5.0}}, -- Grapeseed house
    --[15] = {loc = {coords = vector3(1336.22, 6405.31, 18.85), h = 0.0}}, -- Pops Diner
    --[16] = {loc = {coords = vector3(184.38, 6437.93, 16.77), h = 45.0}}, -- Paleto Chickens
    --[17] = {loc = {coords = vector3(2971.09, 3497.87, 57.06), h = 7.0}}, -- Humane Labs
    --[18] = {loc = {coords = vector3(2821.71, 1460.47, 10.19), h = 76.0}}, -- Power Plant
    --[19] = {loc = {coords = vector3(1749.83, -1591.02, 98.23), h = 194.0}}, -- Oil Field Factory

    -- Boxes
    --[20] = {loc = {coords = vector3(1403.75, 2114.15, 90.57), h = 181.18}}, -- Near 4001
}

Config.DryingZones = {
    [1] = {
        [1] = {coords = vector4(2193.44, 5604.33, 53.63, 298.46)},
        [2] = {coords = vector4(2193.44, 5606.6, 53.64, 254.08)},
        [3] = {coords = vector4(2194.58, 5608.81, 53.62, 225.34)}
    },
    [2] = {
        [1] = {coords = vector4(3820.71, 4436.68, 2.57, 232.54)},
        [2] = {coords = vector4(3823.9, 4437.13, 2.4, 180.61)},
        [3] = {coords = vector4(3826.78, 4436.56, 2.54, 137.21)}
    },
    [3] = {
        [1] = {coords = vector4(-295.2, 2527.45, 74.57, 233.42)},
        [2] = {coords = vector4(-291.93, 2527.83, 74.57, 181.54)},
        [3] = {coords = vector4(-296.8, 2523.3, 74.58, 315.11)}
    },
    [4] = {
        [1] = {coords = vector4(-37.74, 1901.34, 195.36, 271.69)},
        [2] = {coords = vector4(-37.57, 1905.25, 195.37, 261.64)},
        [3] = {coords = vector4(-37.45, 1898.0, 195.36, 287.12)}
    },
    [5] = {
        [1] = {coords = vector4(481.2, -2172.56, 5.92, 332.9)},
        [2] = {coords = vector4(481.44, -2170.15, 5.92, 253.22)},
        [3] = {coords = vector4(484.82, -2172.61, 5.92, 4.46)}
    },
    [6] = {
        [1] = {coords = vector4(930.12, -2532.07, 28.3, 196.23)},
        [2] = {coords = vector4(935.49, -2529.12, 28.3, 204.35)},
        [3] = {coords = vector4(933.82, -2531.72, 28.3, 244.68)}
    },
    [7] = {
        [1] = {coords = vector4(1498.9, -2130.6, 76.15, 199.59)},
        [2] = {coords = vector4(1498.36, -2133.82, 76.26, 283.47)},
        [3] = {coords = vector4(1501.87, -2131.89, 76.22, 150.29)}
    },
    [8] = {
        [1] = {coords = vector4(-190.52, 6150.13, 36.86, 174.69)},
        [2] = {coords = vector4(-194.39, 6147.13, 36.86, 242.24)},
        [3] = {coords = vector4(-188.37, 6147.51, 36.86, 112.88)}
    },
    [9] = {
        [1] = {coords = vector4(178.25, -252.19, 52.31, 338.44)},
        [2] = {coords = vector4(176.26, -251.41, 52.31, 338.44)},
        [3] = {coords = vector4(184.62, -252.50, 52.31, 70.16)}
    },
}

Config.Tables = {
    [1] = {coords = vector4(2198.06, 5599.88, 52.67, 253.87)}
}

Config.WhiteWidow = {
    RemoveProps = {
        {hash = -928937343, coords = vector3(181.65, -251.093, 52.34)},
        {hash = -928937343, coords = vector3(182.47, -252.38, 52.34)},
        {hash = -928937343, coords = vector3(183.47, -252.71, 52.34)},
    },
    Planters = {
        {coords = vector4(184.48, -250.70, 53.31, 158.53)},
        {coords = vector4(182.4, -249.9, 53.31, 158.53)},
        {coords = vector4(183.18, -253.80, 53.31, 338.60)},
        {coords = vector4(180.92, -252.90, 53.31, 338.60)},
    },
    Hooks = {
        {coords = vector4(177.58, -252.93, 54.14, 344.63)},
    }
}

Config.HarvestingState = "Harvesting"

function print_table(node)
    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)

    print(output_str)
end