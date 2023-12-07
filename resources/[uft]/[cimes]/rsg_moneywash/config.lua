-- Config = {}

-- Config.Image = "lj-inventory/html/images/" -- image folder for your inventory
-- Config.MoneyType = 'markedbills' -- type example 'dirtymoney' or 'markedbills'
-- Config.CutPercentage = 90 -- percentage of cash player gets when washed : example 10 = 10% / 50 = 50% / 100 = 100%  / 200 = 200% (double)
-- Config.MinAmount = 0 -- minimum amount of dirty money you set to wash
-- Config.CheckTime = 30000 -- amount of time in milliseconds needed to check your dirty money

-- Config.TokensNeeded = 0 -- amount of tokens needed to wash money
-- -- NPC SETTINGS --

-- Config.Invincible = true -- Is the ped going to be invincible?
-- Config.Frozen = true -- Is the ped frozen in place?
-- Config.Stoic = true -- Will the ped react to events around them?
-- Config.FadeIn = true -- Will the ped fade in and out based on the distance. (Looks a lot better.)
-- Config.DistanceSpawn = 20.0 -- Distance before spawning/despawning the ped. (GTA Units.)

-- Config.MinusOne = true -- Leave this enabled if your coordinates grabber does not -1 from the player coords.

-- Config.GenderNumbers = { -- No reason to touch these.
-- 	['male'] = 4,
-- 	['female'] = 5
-- }

-- Config.MoneywashPedList = { -- ped used to start the weedrun

-- 	{
--         model = `s_m_m_dockwork_01`,
--         coords = vector4(1118.7757, -3193.39, -40.39196, 178.332), -- moneywash inside
--         gender = 'male',
--         scenario = 'WORLD_HUMAN_CLIPBOARD'
--     },

-- 	{
--         model = `s_m_m_dockwork_01`,
--         coords = vector4(1135.8205, -3232.052, 5.8982782, 16.234655), -- moneywash outside
--         gender = 'male',
--         scenario = 'WORLD_HUMAN_CLIPBOARD'
--     },

-- }

-- Config.Machines = {
--     [1] = {coords = vector3(1122.37, -3193.47, -41.4), w = 1.35, l = 1.8, h = 0.0, minz = -41.3, maxz = -39.0},
-- }



--==================--
-- Money Laundering --
--==================--
Config = {}
Config.entry = {
    vector3(-301.45, -2611.88, 17.1)
}

-- Set to true if you want players to enter using an item, otherwise players need to gues the code
Config.useItem = true
Config.item = 'moneywashkey' -- The name of the item in the shared.lua
Config.code = 'StrongPassword123' -- Can only be 40 characters long
Config.WashingItem = "cleaningkit"

Config.Machines = {
    [1] = {
        coords = vector3(1126.95, -3193.31, -40.4),
        hash = 769275872,
        inUse = false,
        worth = nil
    },
    [2] = {
        coords = vector3(1125.53, -3193.31, -40.4),
        hash = 769275872,

        inUse = false,
        worth = nil
    },
    [3] = {
        coords = vector3(1123.75, -3193.35, -40.4),
        hash = 769275872,

        inUse = false,
        worth = nil
    },
    [4] = {
        coords = vector3(1122.37, -3193.47, -40.4),
        hash = 769275872,

        inUse = false,
        worth = nil
    }
}

Config.timer = 1800 -- seconds
Config.percentage = { -- % that gets lost when laundering
    min = 10,
    max = 20
}
