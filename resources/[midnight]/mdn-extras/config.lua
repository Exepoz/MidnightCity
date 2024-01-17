Config = {}
Config.DebugPoly = false
Config.Uwu = {}

Config.Disposals = {
    ['fish'] = {d = vector3(-78.23, -2716.99, 5.92), p = vector4(-77.95, -2718.42, 4.93, 347.04), label = "Catch of The Day"},
    ['beef'] = {d = vector3(975.23, -2119.83, 31.39), p = vector4(973.27, -2120.91, 29.47, 203.1), label = "Hamburgers"},
    ['wood'] = {d = vector3(-531.29, 5338.68, 80.26), p = vector4(-531.16, 5337.27, 79.26, 311.56), label = "Venison Meatloaf"},
    ['fish2'] = {d = vector3(717.5, 4101.72, 35.82), p = vector4(717.5, 4101.72, 35.82, 311.56), label = "Fisherman's Special"}
}

-------------
-- Arcades --
-------------
Config.Items = {
    coins = "cyberbarcoin",
    --Coupons = "coupons"
}

Config.Arcades = {
    -- Main Arcades
    -- {coords = vector3(323.06, -919.95, 29.16), hash = -1991361770},
    -- {coords = vector3(323.03, -916.62, 29.16), hash = 1876055757},
    -- {coords = vector3(323.03, -915.67, 29.16), hash = -1502319666},
    -- {coords = vector3(323.03, -914.68, 29.16), hash = 815879628},
    -- {coords = vector3(324.92, -912.28, 29.16), hash = -1501557515},
    -- {coords = vector3(325.81, -912.28, 29.16), hash = 1301167921},
    -- {coords = vector3(326.67, -912.28, 29.16), hash = -538006270},
    -- -- Yugi-ho Room
    -- {coords = vector3(323.03, -916.62, 28.24), hash = 1876055757},
    -- {coords = vector3(323.03, -916.62, 28.24), hash = 1876055757},
    -- {coords = vector3(323.03, -916.62, 28.24), hash = 1876055757},
    -- {coords = vector3(323.03, -916.62, 28.24), hash = 1876055757},
    -- -- Dance Floor
    -- {coords = vector3(323.03, -916.62, 28.24), hash = 1876055757},
    -- {coords = vector3(323.03, -916.62, 28.24), hash = 1876055757},
    -- {coords = vector3(323.03, -916.62, 28.24), hash = 1876055757},
    -- {coords = vector3(323.03, -916.62, 28.24), hash = 1876055757},
    -- {coords = vector3(323.03, -916.62, 28.24), hash = 1876055757},
    -- {coords = vector3(323.03, -916.62, 28.24), hash = 1876055757},
    -- {coords = vector3(323.03, -916.62, 28.24), hash = 1876055757},
    {coords = vector3(152.03, -3016.23, 7.05), hash = -165961666},
}

Config.HackingMinigames = {
    NumberColor = {
        Name = "Number/Color Minigame",
        Icon = "fas fa-palette",
        Game = function() local p = promise.new() exports['hacking']:OpenHackingGame(10, 5, 5, function(success) p:resolve(success) end) return p end,
    },
    MemoryGame = {
        Name = "Memory Game",
        Icon = "fas fa-th",
        Game = function() local p = promise.new() exports['memorygame']:thermiteminigame(12, 3, 7, 12, function() p:resolve(true) end, function() p:resolve(false) end) return p end,
    },
    -- NumberMaze = {
    --     Name = "Number Maze Game",
    --     Icon = "far fa-question-circle",
    --     Game = function() local p = promise.new() exports['ps-ui']:Maze(function(success) p:resolve(success) end, 20) return p end,
    -- },
    Scrambler = {
        Name = "Scrambler Game",
        Icon = "fas fa-list-ol",
        Game = function() local p = promise.new() exports['ps-ui']:Scrambler(function(success) p:resolve(success) end, "numeric", 30, 0) return p end,
    },
    VAR = {
        Name = "Floating Numbers Game",
        Icon = "fas fa-braille",
        Game = function() local p = promise.new() exports['ps-ui']:VarHack(function(success) p:resolve(success) end, 8, 5) return p end,
    },
    HOWDY = {
        Name = "Howdy Hack",
        Icon = "fas fa-braille",
        Game = function() local p = promise.new() p:resolve(exports['howdy-hackminigame']:Begin(4, 5000)) return p end
    }
}

---------------------
-- Stash & Clothes --
---------------------
Config.Stashes = {
    --[1] = {name = "vbhLeilaStash", maxWeight = 4000000, slots = 50, coords = vector3(-1986.66, -498.59, 20.73), w = 0.8, l = 2.9, h = 320.0, minz = 19.73, maxz = 22.73, cids = {'OFT03862'}, jobs = nil}, -- VBH Leila's
    --[2] = {name = "vbhCharlieStash", maxWeight = 4000000, slots = 50, coords = vector3(-1989.23, -500.23, 12.19), w = 4.0, l = 1.2, h = 320.0, minz = 11.19, maxz = 12.79, cids = {'HWQ96961'}, jobs = nil}, -- VBH Charlies

}

Config.ClothingMenus = {
   -- [1] = {name = "vbhclothing", coords = vector3(-1979.58, -501.65, 20.73), w = 2.4, l = 1.0, h = 320.0, minz = 19.73, maxz = 22.73, cids = {'OFT03862', 'HWQ96961'}, jobs = nil, gangs = nil}, -- VBH Clothing

}

Config.Clockins = {
    ['winery'] = {coords = vector3(-1878.65, 2069.25, 141.01), r = 1.0, t= 200.0, zone = {
        vector3(-1954.43, 2053.71, 100.65),
        vector3(-1944.98, 2017.29, 100.56),
        vector3(-2013.91, 1970.24, 100.06),
        vector3(-1974.19, 1920.12, 100.79),
        vector3(-1948.35, 1892.26, 100.74),
        vector3(-1998.46, 1849.21, 100.59),
        vector3(-2032.82, 1792.06, 100.0),
        vector3(-1997.48, 1742.05, 100.6),
        vector3(-1875.25, 1740.94, 100.53),
        vector3(-1734.5, 1835.06, 100.78),
        vector3(-1648.31, 1920.18, 100.24),
        vector3(-1656.55, 2129.09, 100.23),
        vector3(-1576.7, 2169.88, 100.31),
        vector3(-1524.93, 2219.46, 100.48),
        vector3(-1547.41, 2358.96, 100.32),
        vector3(-1716.02, 2406.35, 100.78),
        vector3(-1991.63, 2339.18, 100.81)
    }},
    ['ammunation'] = {coords = vector3(15.32, -1106.99, 29.8), r = 1.0, t= 50.0, zone = {
        vector3(-26.29, -1124.83, 26.79),
        vector3(-12.07, -1086.14, 27.04),
        vector3(-39.76, -1078.41, 27.04),
        vector3(-66.59, -1066.49, 27.42),
        vector3(-25.21, -958.36, 29.35),
        vector3(105.23, -1005.12, 29.36),
        vector3(63.01, -1125.33, 29.34),
        vector3(-0.8, -1140.77, 28.17),
        vector3(-21.36, -1135.79, 27.11)
    }},
    ['digitalden'] = {coords = vector3(1132.94, -475.65, 66.72), r = 1.0, t= 50.0, zone = {
        vector3(1170.8, -512.31, 65.12),
        vector3(1128.86, -513.89, 65.12),
        vector3(1091.3, -516.58, 65.12),
        vector3(1126.27, -360.29, 65.12),
        vector3(1209.75, -371.84, 65.12)
    }},
}

-- Car Crushing
Config.Classes = {
    [0] = {-- Compacts
        ['plastic'] = math.random(25,75),
        ['metalscrap'] = math.random(25,75),
        ['copper'] = math.random(25,75),
        ['aluminum'] = math.random(25,75),
        ['iron'] = math.random(25,75),
        ['steel'] = math.random(25,75),
        ['rubber'] = math.random(25,75),
        ['glass'] = math.random(25,75),
    },
    [1] = { -- Sedans
        ['plastic'] = math.random(25,75),
        ['metalscrap'] = math.random(25,75),
        ['copper'] = math.random(25,75),
        ['aluminum'] = math.random(25,75),
        ['iron'] = math.random(25,75),
        ['steel'] = math.random(25,75),
        ['rubber'] = math.random(25,75),
        ['glass'] = math.random(25,75),
    },
    [2] = { -- SUVs
        ['plastic'] = math.random(25,75),
        ['metalscrap'] = math.random(25,75),
        ['copper'] = math.random(25,75),
        ['aluminum'] = math.random(25,75),
        ['iron'] = math.random(25,75),
        ['steel'] = math.random(25,75),
        ['rubber'] = math.random(25,75),
        ['glass'] = math.random(25,75),
    },
    [3] = { -- Coupes
        ['plastic'] = math.random(25,75),
        ['metalscrap'] = math.random(25,75),
        ['copper'] = math.random(25,75),
        ['aluminum'] = math.random(25,75),
        ['iron'] = math.random(25,75),
        ['steel'] = math.random(25,75),
        ['rubber'] = math.random(25,75),
        ['glass'] = math.random(25,75),
    },
    [4] = { -- Muscle
        ['plastic'] = math.random(25,75),
        ['metalscrap'] = math.random(25,75),
        ['copper'] = math.random(25,75),
        ['aluminum'] = math.random(25,75),
        ['iron'] = math.random(25,75),
        ['steel'] = math.random(25,75),
        ['rubber'] = math.random(25,75),
        ['glass'] = math.random(25,75),
    },
    [5] = { -- Sports Classics
        ['plastic'] = math.random(25,75),
        ['metalscrap'] = math.random(25,75),
        ['copper'] = math.random(25,75),
        ['aluminum'] = math.random(25,75),
        ['iron'] = math.random(25,75),
        ['steel'] = math.random(25,75),
        ['rubber'] = math.random(25,75),
        ['glass'] = math.random(25,75),
    },
    [6] = { -- Sports
        ['plastic'] = math.random(25,75),
        ['metalscrap'] = math.random(25,75),
        ['copper'] = math.random(25,75),
        ['aluminum'] = math.random(25,75),
        ['iron'] = math.random(25,75),
        ['steel'] = math.random(25,75),
        ['rubber'] = math.random(25,75),
        ['glass'] = math.random(25,75),
    },
    [7] = { -- Super
        ['plastic'] = math.random(25,75),
        ['metalscrap'] = math.random(25,75),
        ['copper'] = math.random(25,75),
        ['aluminum'] = math.random(25,75),
        ['iron'] = math.random(25,75),
        ['steel'] = math.random(25,75),
        ['rubber'] = math.random(25,75),
        ['glass'] = math.random(25,75),
    },
    [8] = { -- Motorcycles
        ['plastic'] = math.random(25,75),
        ['metalscrap'] = math.random(25,75),
        ['copper'] = math.random(25,75),
        ['aluminum'] = math.random(25,75),
        ['iron'] = math.random(25,75),
        ['steel'] = math.random(25,75),
        ['rubber'] = math.random(25,75),
        ['glass'] = math.random(25,75),
    },
    [9] = { -- Off-road
        ['plastic'] = math.random(25,75),
        ['metalscrap'] = math.random(25,75),
        ['copper'] = math.random(25,75),
        ['aluminum'] = math.random(25,75),
        ['iron'] = math.random(25,75),
        ['steel'] = math.random(25,75),
        ['rubber'] = math.random(25,75),
        ['glass'] = math.random(25,75),
    },
    [10] = { -- Industrial
        ['plastic'] = math.random(25,75),
        ['metalscrap'] = math.random(25,75),
        ['copper'] = math.random(25,75),
        ['aluminum'] = math.random(25,75),
        ['iron'] = math.random(25,75),
        ['steel'] = math.random(25,75),
        ['rubber'] = math.random(25,75),
        ['glass'] = math.random(25,75),
    },
    [11] = { -- Utility
        ['plastic'] = math.random(25,75),
        ['metalscrap'] = math.random(25,75),
        ['copper'] = math.random(25,75),
        ['aluminum'] = math.random(25,75),
        ['iron'] = math.random(25,75),
        ['steel'] = math.random(25,75),
        ['rubber'] = math.random(25,75),
        ['glass'] = math.random(25,75),
    },
    [12] = { -- Vans
        ['plastic'] = math.random(25,75),
        ['metalscrap'] = math.random(25,75),
        ['copper'] = math.random(25,75),
        ['aluminum'] = math.random(25,75),
        ['iron'] = math.random(25,75),
        ['steel'] = math.random(25,75),
        ['rubber'] = math.random(25,75),
        ['glass'] = math.random(25,75),
    },
    [18] = { -- Emergency
        ['plastic'] = math.random(25,75),
        ['metalscrap'] = math.random(25,75),
        ['copper'] = math.random(25,75),
        ['aluminum'] = math.random(25,75),
        ['iron'] = math.random(25,75),
        ['steel'] = math.random(25,75),
        ['rubber'] = math.random(25,75),
        ['glass'] = math.random(25,75),
    },
    [20] = { -- Commercial
        ['plastic'] = math.random(25,75),
        ['metalscrap'] = math.random(25,75),
        ['copper'] = math.random(25,75),
        ['aluminum'] = math.random(25,75),
        ['iron'] = math.random(25,75),
        ['steel'] = math.random(25,75),
        ['rubber'] = math.random(25,75),
        ['glass'] = math.random(25,75),
    },
}
