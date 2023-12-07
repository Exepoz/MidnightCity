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
    [1] = {name = "DMcVeeStash1", maxWeight = 4000000, slots = 50, coords = vector3(-1479.55, -46.7, 54.59), w = 1.8, l = 2.9, h = 120.0, minz = 53.73, maxz = 55.73, cids = {'CEZ24004'}, jobs = nil},
    [2] = {name = "DMcVeeStash2", maxWeight = 4000000, slots = 50, coords = vector3(-1475.68, -34.12, 57.01), w = 1.8, l = 2.9, h = 130.0, minz = 56.73, maxz = 58.73, cids = {'CEZ24004'}, jobs = nil},
    [3] = {name = "Midnight Manor", maxWeight = 4000000, slots = 50, coords = vector3(-1789.5, 427.57, 128.51), w = 2.0, l = 0.5, h = 270.0, minz = 125.00, maxz = 132.00, cids = nil, jobs = nil, gangs = {'midnight'}}, -- Midnight Manor Stash
    [4] = {name = "Greg", maxWeight = 4000000, slots = 50, coords = vector3(-1819.12, 435.25, 132.31), w = 1.0, l = 1.0, h = 270.0, minz = 131.00, maxz = 136.00, cids = {'RQN37448'}, jobs = nil, gangs = nil}, -- Midnight Manor Stash
    [5] = {name = "Craig", maxWeight = 4000000, slots = 50, coords = vector3(-1813.75, 445.33, 132.34), w = 0.5, l = 2.0, h = 270.0, minz = 131.00, maxz = 136.00, cids = {'NWP17570'}, jobs = nil, gangs = nil}, -- Midnight Manor Stash
    [6] = {name = "Andrew", maxWeight = 4000000, slots = 50, coords = vector3(-1800.18, 439.3, 132.35), w = 2.0, l = 0.5, h = 270.0, minz = 131.00, maxz = 136.00, cids = {'UPY10832'}, jobs = nil, gangs = nil}, -- Midnight Manor Stash
    [7] = {name = "Eric", maxWeight = 4000000, slots = 50, coords = vector3(-2584.58, 1872.65, 163.77), w = 2.0, l = 0.5, h = 41.0, minz = 162.00, maxz = 164.00, cids = {'QHH59113'}, jobs = nil, gangs = nil}, -- Eric Slaughter House Stash
    [8] = {name = "Eric2", maxWeight = 4000000, slots = 50, coords = vector3(-2585.25, 1906.99, 163.47), w = 2.0, l = 0.5, h = 276.0, minz = 162.00, maxz = 164.00, cids = {'QHH59113'}, jobs = nil, gangs = nil}, -- Eric Slaughter House Stash
    [9] = {name = "Midnight Armory", maxWeight = 4000000, slots = 50, coords = vector3(-566.52, -1625.81, 33.01), w = 0.5, l = 2.5, h = 270.0, minz = 31.00, maxz = 38.00, cids = nil, jobs = nil, gangs = {'midnight'}}, -- Midnight Compound Stash
    [10] = {name = "Midnight Storage", maxWeight = 4000000, slots = 50, coords = vector3(-598.70, -1604.35, 26.8), w = 2.0, l = 2.0, h = 350.0, minz = 26.00, maxz = 27.60, cids = nil, jobs = nil, gangs = {'midnight'}}, -- Midnight Compound Stash
    [11] = {name = "Fox", maxWeight = 4000000, slots = 50, coords = vector3(-609.65, -1634.23, 36.62), w = 0.7, l = 0.75, h = 270.0, minz = 35.00, maxz = 36.70, cids = {'UPY10832'}, jobs = nil, gangs = nil}, -- Midnight Compound Stash
    [12] = {name = "Talos Safe", maxWeight = 4000000, slots = 50, coords = vector3(-1501.76, 43.72, 48.35), w = 0.7, l = 0.75, h = 99.93, minz = 46.00, maxz = 50.00, cids = {'JDX37675'}, jobs = nil, gangs = nil},
    [13] = {name = "ItemsCaseDD1", maxWeight = 4000000, slots = 50, coords = vector3(390.21, -821.27, 29.3), w = 1.0, l = 1.00, h = 99.93, minz = 28.00, maxz = 30.00, cids = nil, jobs = {'digitalden'}, gangs = nil},
    [14] = {name = "ItemsCaseDD2", maxWeight = 4000000, slots = 50, coords = vector3(388.06, -821.28, 29.29), w = 1.0, l = 1.00, h = 99.93, minz = 28.00, maxz = 30.00, cids = nil, jobs = {'digitalden'}, gangs = nil},
    [15] = {name = "CountersDD1", maxWeight = 4000000, slots = 50, coords = vector3(384.85, -830.66, 29.76), w = 1.0, l = 1.00, h = 99.93, minz = 28.00, maxz = 30.00, cids = nil, jobs = nil, gangs = nil},
    [16] = {name = "EclipseStash", maxWeight = 4000000, slots = 50, coords = vector3(-816.8, -688.90, 122.9), w = 1.3, l = 0.85, h = 0.00, minz = 122.45, maxz = 123.4, cids = nil, jobs = {'eclipse'}, gangs = nil},
    [17] = {name = "ComicStoreStash", maxWeight = 4000000, slots = 50, coords = vector3(-152.75, 224.35, 94.4), w = 1.15, l = 1.00, h = 0.00, minz = 93.90, maxz = 94.90, cids = nil, jobs = {'comic'}, gangs = nil},
    [18] = {name = "AmmunationCounter", maxWeight = 250000, slots = 25, coords = vector3(16.60, -1108.30, 29.9), w = 1.20, l = 2.45, h = 340.00, minz = 29.5, maxz = 30.00, cids = nil, jobs = nil, gangs = nil},
    [19] = {name = "AmmunationStash", maxWeight = 4000000, slots = 50, coords = vector3(16.60, -1105.00, 29.4), w = 0.5, l = 5.95, h = 340.00, minz = 28.80, maxz = 33.70, cids = nil, jobs = {'ammunation'}, gangs = nil},
    [20] = {name = "Cabal Stash", maxWeight = 4000000, slots = 50, coords = vector3(-96.5, 829.35, 231.4), w = 0.6, l = 0.2, h = 100.0, minz = 230.7, maxz = 232.1, cids = nil, jobs = nil, gangs = {'cabal'}},
    [21] = {name = "RisingBarStash", maxWeight = 500000, slots = 50, coords = vector3(-345.25, -151.70, 38.55), w = 0.5, l = 2.6, h = 70.00, minz = 38.00, maxz = 39.00, cids = nil, jobs = {'rising'}, gangs = nil},
    [22] = {name = "TequilalaStash", maxWeight = 4000000, slots = 50, coords = vector3(-563.0, 285.50, 82.0), w = 1.50, l = 0.75, h = 355.00, minz = 81.20, maxz = 82.15, cids = nil, jobs = {'tequilala'}, gangs = nil},
    [23] = {name = "TequilalaVIPStash", maxWeight = 500000, slots = 25, coords = vector3(-566.0, 286.50, 84.9), w = 1.50, l = 0.75, h = 355.00, minz = 84.40, maxz = 85.30, cids = nil, jobs = {'tequilala'}, gangs = nil},
    [24] = {name = "PopsIngredients", maxWeight = 2000000, slots = 50, coords = vector3(1593.1, 6454.0, 25.55), w = 0.60, l = 1.60, h = 335.00, minz = 25.05, maxz = 25.95, cids = nil, jobs = {'popsdiner'}, gangs = nil},
    [25] = {name = "GambinoStash", maxWeight = 4000000, slots = 50, coords = vector3(249.4, -3156.22, 3.37), w = 0.75, l = 0.75, h = 47.00, minz = 1.37, maxz = 5.37, cids = nil, jobs = nil, gangs = {'gambino'}},
    [26] = {name = "MarabuntaStash", maxWeight = 4000000, slots = 50, coords = vector3(1254.34, -1571.33, 58.75), w = 2.60, l = 1.60, h = 335.00, minz = 56.05, maxz = 60.95, cids = nil, jobs = nil, gangs = {'marabunta'}},
    [27] = {name = "PeakyStash", maxWeight = 4000000, slots = 50, coords = vector3(-776.65, 813.5, 217.5), w = 1.0, l = 1.0, h = 17.0, minz = 216.6, maxz = 218.35, cids = nil, jobs = nil, gangs = {'peakyboys'}},
    [28] = {name = "DDStash", maxWeight = 4000000, slots = 50, coords = vector3(1133.95, -476.2, 65.71), w = 2.60, l = 1.60, h = 107.0, minz = 63.05, maxz = 67.95, cids = nil, jobs = {'digitalden'}, gangs = nil,},
    [29] = {name = "MisfitsStash", maxWeight = 4000000, slots = 50, coords = vector3(-666.73, -885.74, 39.16), w = 2.0, l = 2.0, h = 270.0, minz = 39.00, maxz = 41.00, cids = nil, jobs = nil, gangs = {'misfits'}}, -- misfits Stashes
    [30] = {name = "CasinoCartel", maxWeight = 5000000, slots = 50, coords = vector3(977.33, 46.96, 116.03), w = 2.0, l = 2.0, h = 270.0, minz = 114.00, maxz = 118.00, cids = nil, jobs = nil, gangs = {'cartel'}}, -- cartel Stashes
    [31] = {name = "Cartel", maxWeight = 5000000, slots = 50, coords = vector3(1393.6, -608.54, 73.03), w = 5.0, l = 5.0, h = 319.0, minz = 71.00, maxz = 76.00, cids = nil, jobs = nil, gangs = {'cartel'}}, -- cartel Stashes
    [32] = {name = "MidnightPaint", maxWeight = 50, slots = 1, coords = vector3(-567.4, -1615.21, 20.63), w = 1.0, l = 2.0, h = 354.25, minz = 18.5, maxz = 20.35, cids = nil, jobs = nil, gangs = {'midnight'}}, -- Midnight Paint Stash
    [33] = {name = "LostMCBoss", maxWeight = 5000000, slots = 50, coords = vector3(1442.81, -2595.76, 50.82), w = 1.5, l = 0.85, h = 346.25, minz = 48.5, maxz = 52.35, cids = nil, jobs = nil, gangs = {'lostmc'}}, -- boss office safe
    [34] = {name = "MidnightCash", maxWeight = 5000000, slots = 50, coords = vector3(-580.23, -1599.02, 26.75), w = 1.5, l = 0.85, h = 84.0, minz = 25.75, maxz = 27.75, cids = nil, jobs = nil, gangs = {'midnight'}}, -- Midnight Cash Safe
    [35] = {name = "LostMCGangSafe", maxWeight = 5000000, slots = 50, coords = vector3(1423.8, -2631.83, 48.66), w = 1.5, l = 0.85, h = 76.25, minz = 46.5, maxz = 50.35, cids = nil, jobs = nil, gangs = {'lostmc'}}, -- boss office safe
    [36] = {name = "LostMCGunRack", maxWeight = 5000000, slots = 50, coords = vector3(1426.34, -2630.86, 47.86), w = 1.5, l = 0.85, h = 346.25, minz = 45.5, maxz = 49.35, cids = nil, jobs = nil, gangs = {'lostmc'}}, -- boss office safe
    [37] = {name = "LostMCGunParts", maxWeight = 5000000, slots = 50, coords = vector3(1423.75, -2630.97, 47.87), w = 1.5, l = 1.85, h = 346.25, minz = 45.5, maxz = 49.35, cids = nil, jobs = nil, gangs = {'lostmc'}}, -- boss office safe
    [38] = {name = "LostMCDrugs", maxWeight = 5000000, slots = 50, coords = vector3(1426.84, -2634.85, 48.87), w = 1.5, l = 1.85, h = 177.25, minz = 46.5, maxz = 50.35, cids = nil, jobs = nil, gangs = {'lostmc'}}, -- boss office safe
    [39] = {name = "VUPhoneStash", maxWeight = 25000, slots = 25, coords = vector3(107.15, -1293.1, 21.0), w = 1.5, l = 0.65, h = 30.00, minz = 20.4, maxz = 21.75, cids = nil, jobs = nil, gangs = nil},
    [40] = {name = "VUPoolBar", maxWeight = 100000, slots = 25, coords = vector3(112.17, -1301.84, 21.65), w = 5.1, l = 0.75, h = 30.00, minz = 21.35, maxz = 21.95, cids = nil, jobs = nil, gangs = nil},
    [41] = {name = "VUVIPBar1", maxWeight = 100000, slots = 25, coords = vector3(112.85, -1299.37, 21.65), w = 3.0, l = 0.85, h = 30.00, minz = 21.25, maxz = 22.35, cids = nil, jobs = nil, gangs = nil},
    [42] = {name = "VUVIPBar2", maxWeight = 100000, slots = 25, coords = vector3(127.74, -1290.67, 21.65), w = 3.0, l = 0.85, h = 30.00, minz = 21.25, maxz = 22.35, cids = nil, jobs = nil, gangs = nil},
    [43] = {name = "VUVIPBar3", maxWeight = 100000, slots = 25, coords = vector3(123.7, -1283.73, 21.65), w = 2.85, l = 0.85, h = 30.00, minz = 21.25, maxz = 22.35, cids = nil, jobs = nil, gangs = nil},
    [44] = {name = "VUVIPBar4", maxWeight = 100000, slots = 25, coords = vector3(108.78, -1292.4, 21.65), w = 2.85, l = 0.85, h = 30.00, minz = 21.25, maxz = 22.35, cids = nil, jobs = nil, gangs = nil},
    [45] = {name = "VUVIPBar5", maxWeight = 1000000, slots = 25, coords = vector3(109.91, -1280.97, 29.62), w = 2.85, l = 0.85, h = 30.00, minz = 27.62, maxz = 31.62, cids = nil, jobs = {'vanilla'}, gangs = nil},
    [46] = {name = "WineryEmptyBarrels", maxWeight = 100000, slots = 1, coords = vector3(-1937.06, 2042.47, 140.81), w = 3.00, l = 2.0, h = 30.00, minz = 139.25, maxz = 141.35, cids = nil, jobs = {'winery'}, gangs = nil},
    [47] = {name = "WineryWines", maxWeight = 1000000, slots = 20, coords = vector3(-1865.23, 2066.79, 143.11), w = 2.00, l = 12.0, h = 177.51, minz = 139.25, maxz = 143.35, cids = nil, jobs = {'winery'}, gangs = nil},
    [48] = {name = "WineryShelf1", maxWeight = 250000, slots = 30, coords = vector3(-1876.0, 2058.6, 141.0), w = 3.6, l = 1.0, h = 339.0, minz = 140.40, maxz = 142.20, cids = nil, jobs = {'winery'}, gangs = nil},
    [49] = {name = "WineryShelf2", maxWeight = 250000, slots = 30, coords = vector3(-1877.5, 2054.6, 141.0), w = 0.9, l = 3.6, h = 430.0, minz = 140.3, maxz = 142.2, cids = nil, jobs = {'winery'}, gangs = nil},
    [50] = {name = "WineryShelf3", maxWeight = 250000, slots = 30, coords = vector3(-1893.5, 2060.5, 141.0), w = 0.75, l = 3.75, h = 430.0, minz = 140.25, maxz = 142.2, cids = nil, jobs = {'winery'}, gangs = nil},
    [51] = {name = "club77bar", maxWeight = 500000, slots = 25, coords = vector3(249.43, -3160.52, -0.3), w = 1.0, l = 1.0, h = 30.0, minz = -2.0, maxz = 0.0, cids = nil, jobs = {'club77'}, gangs = nil},
    [52] = {name = "club77storage1", maxWeight = 1500000, slots = 40, coords = vector3(258.34, -3160.67, 0.11), w = 0.75, l = 0.75, h = 40.0, minz = -2.11, maxz = 2.11, cids = nil, jobs = {'club77'}, gangs = nil},
    [53] = {name = "club77storage2", maxWeight = 1500000, slots = 40, coords = vector3(256.34, -3157.44, 0.11), w = 0.75, l = 0.75, h = 40.0, minz = -2.11, maxz = 2.11, cids = nil, jobs = {'club77'}, gangs = nil},
    [54] = {name = "club77vip1", maxWeight = 200000, slots = 10, coords = vector3(255.91, -3177.38, 3.24), w = 0.75, l = 0.75, h = 40.0, minz = 1.24, maxz = 5.24, cids = nil, jobs = nil, gangs = nil},
    [55] = {name = "club77vip2", maxWeight = 200000, slots = 25, coords = vector3(242.64, -3159.52, 2.77), w = 0.75, l = 0.75, h = 40.0, minz = 0.77, maxz = 4.77, cids = nil, jobs = nil, gangs = nil},
    [56] = {name = "gambinosafe", maxWeight = 5000000, slots = 50, coords = vector3(248.18, -3144.08, 3.32), w = 1.5, l = 1.5, h = 40.0, minz = 1.32, maxz = 5.32, cids = nil, jobs = nil, gangs = {"gambino"}},
    [57] = {name = "gambinoguns", maxWeight = 5000000, slots = 50, coords = vector3(242.24, -3141.91, 3.32), w = 1.5, l = 1.5, h = 40.0, minz = 1.32, maxz = 5.32, cids = nil, jobs = nil, gangs = {"gambino"}},
    [58] = {name = "gambinolockers", maxWeight = 5000000, slots = 50, coords = vector3(246.61, -3144.85, 3.32), w = 1.5, l = 1.5, h = 40.0, minz = 1.32, maxz = 5.32, cids = nil, jobs = nil, gangs = {"gambino"}},
}

Config.ClothingMenus = {
    [1] = {name = "vbhclothing", coords = vector3(-1979.58, -501.65, 20.73), w = 2.4, l = 1.0, h = 320.0, minz = 19.73, maxz = 22.73, cids = {'OFT03862', 'HWQ96961'}, jobs = nil, gangs = nil}, -- VBH Clothing
    [2] = {name = "midnightclothing", coords = vector3(918.14, -1797.16, 22.14), w = 4.6, l = 2.0, h = 355.0, minz = 18.73, maxz = 24.73, cids = nil, jobs = nil, gangs = {"midnight"}}, -- Midnight Hideout
    [3] = {name = "MMclothing", coords = vector3(-1797.31, 424.91, 128.51), w = 0.5, l = 2.0, h = 50.0, minz = 127, maxz = 130, cids = nil, jobs = nil, gangs = {"midnight"}}, -- Midnight Manor
    [4] = {name = "MidnightClothes", coords = vector3(-619.46, -1617.35, 33.01), w = 2.5, l = 0.5, h = 50.0, minz = 31, maxz = 38, cids = nil, jobs = nil, gangs = {"midnight"}}, -- Midnight Manor
    [5] = {name = "ComicClothing", coords = vector3(-143.95, 216.65, 95.00), w = 2.15, l = 0.65, h = 0.00, minz = 94, maxz = 96, cids = nil, jobs = {"comic"}, gangs = nil}, -- Comic Shop
    [6] = {name = "CasinoClothing", coords = vector3(997.48, -1.94, 70.46), w = 2.15, l = 0.65, h = 0.00, minz = 68, maxz = 72, cids = nil, jobs = {"casino"}, gangs = nil}, -- Comic Shop
    [7] = {name = "midnightmotorsclothes", coords = vector3(-578.65, -1616.44, 20.02), w = 0.8, l = 1.8, h = 355.0, minz = 18.80, maxz = 21.00, cids = nil, jobs = nil, gangs = {"midnight"}}, -- Midnight Compound Basement
    [8] = {name = "club77", coords = vector3(251.74, -3150.86, -0.19), w = 0.8, l = 1.8, h = 355.0, minz = -2.19, maxz = 2.19, cids = nil, jobs = {"club77"}, gangs = nil}, -- Club77 Changing Room
    [9] = {name = "club77gambino", coords = vector3(254.62, -3151.79, -0.19), w = 0.8, l = 1.8, h = 355.0, minz = -2.19, maxz = 2.19, cids = nil, jobs = nil, gangs = {"gambino"}}, -- Club77 / Gambino Changing Room
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
