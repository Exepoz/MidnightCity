Config = {}

Config.MinimumStoreRobberyPolice = 1
Config.resetTime = (60 * 1000) * 60
Config.tickInterval = 1000
Config.RareSafeItems = {
    [1] = {item = "diamond", amount = {Min = 1, Max = 2}, weight = 55}, --35%
    [3] = {item = "goldchain", amount = {Min = 1, Max = 2}, weight = 50}, --35%
    [2] = {item = "rolex", amount = {Min = 1, Max = 2}, weight = 50}, --31%
    [4] = {item = "data_burnerphone", amount = {Min = 1, Max = 1}, weight = 20}, --28%
    [6] = {item = "data_banktruck", amount = {Min = 1, Max = 1}, weight = 15},  --21%
    [5] = {item = "data_fleeca", amount = {Min = 1, Max = 1}, weight = 15}, --10%
}

Config.Registers = {
    [1] = {vector3(-47.24,-1757.65, 29.53), robbed = false, time = 0, safeKey = 1, camId = 4},
    [2] = {vector3(-48.58,-1759.21, 29.59), robbed = false, time = 0, safeKey = 1, camId = 4},
    [3] = {vector3(-1486.26,-378.0,  40.16), robbed = false, time = 0, safeKey = 2, camId = 5},
    [4] = {vector3(-1222.03,-908.32, 12.32), robbed = false, time = 0, safeKey = 3, camId = 6},
    [5] = {vector3(-706.08, -915.42, 19.21), robbed = false, time = 0, safeKey = 4, camId = 7},
    [6] = {vector3(-706.16, -913.5, 19.21), robbed = false, time = 0, safeKey = 4, camId = 7},
    [7] = {vector3( 24.47, -1344.99, 29.49), robbed = false, time = 0, safeKey = 5, camId = 8},
    [8] = {vector3(24.45, -1347.37, 29.49), robbed = false, time = 0, safeKey = 5, camId = 8},
    [9] = {vector3(1134.15, -982.53, 46.41), robbed = false, time = 0, safeKey = 6, camId = 9},
    [10] = {vector3(1165.05, -324.49, 69.2), robbed = false, time = 0, safeKey = 7, camId = 10},
    [11] = {vector3(1164.7, -322.58, 69.2), robbed = false, time = 0, safeKey = 7, camId = 10},
    [12] = {vector3(373.14, 328.62, 103.56), robbed = false, time = 0, safeKey = 8, camId = 11},
    [13] = {vector3(372.57, 326.42, 103.56), robbed = false, time = 0, safeKey = 8, camId = 11},
    [14] = {vector3(-1818.9, 792.9, 138.08), robbed = false, time = 0, safeKey = 9, camId = 12},
    [15] = {vector3(-1820.17, 794.28, 138.08), robbed = false, time = 0, safeKey = 9, camId = 12},
    [16] = {vector3(-2966.46, 390.89, 15.04), robbed = false, time = 0, safeKey = 10, camId = 13},
    [17] = {vector3(-3041.14, 583.87, 7.9), robbed = false, time = 0, safeKey = 11, camId = 14},
    [18] = {vector3(-3038.92, 584.5, 7.9), robbed = false, time = 0, safeKey = 11, camId = 14},
    [19] = {vector3(-3244.56, 1000.14, 12.83), robbed = false, time = 0, safeKey = 12, camId = 15},
    [20] = {vector3(-3242.24, 999.98, 12.83), robbed = false, time = 0, safeKey = 12, camId = 15},
    [21] = {vector3(549.42, 2669.06, 42.15), robbed = false, time = 0, safeKey = 13, camId = 16},
    [22] = {vector3(549.05, 2671.39, 42.15), robbed = false, time = 0, safeKey = 13, camId = 16},
    [23] = {vector3(1165.9, 2710.81, 38.15), robbed = false, time = 0, safeKey = 14, camId = 17},
    [24] = {vector3(2676.02, 3280.52, 55.24), robbed = false, time = 0, safeKey = 15, camId = 18},
    [25] = {vector3(2678.07, 3279.39, 55.24), robbed = false, time = 0, safeKey = 15, camId = 18},
    [26] = {vector3(1958.96, 3741.98, 32.34), robbed = false, time = 0, safeKey = 16, camId = 19},
    [27] = {vector3(1960.13, 3740.0, 32.34), robbed = false, time = 0, safeKey = 16, camId = 19},
    [28] = {vector3(1728.86, 6417.26, 35.03), robbed = false, time = 0, safeKey = 17, camId = 20},
    [29] = {vector3(1727.85, 6415.14, 35.03), robbed = false, time = 0, safeKey = 17, camId = 20},
    [30] = {vector3(160.52, 6641.74, 31.6), robbed = false, time = 0, safeKey = 18, camId = 28},
    [31] = {vector3(162.16, 6643.22, 31.6), robbed = false, time = 0, safeKey = 18, camId = 29},
    [32] = {vector3(1697.87, 4922.98, 42.06), robbed = false, time = 0, safeKey = 19, camId = 35},
    [33] = {vector3(1696.58, 4923.89, 42.06), robbed = false, time = 0, safeKey = 19, camId = 35}, --vector3(1696.91, 4924.38, 42.91)
}

Config.Safes = {
    [1] = {coords = vector3(-43.9, -1747.98, 28.5), heading = 320, minZ = 28.47, maxZ = 29.32,     type = "keypad", robbed = false, camId = 4},
    [2] = {coords = vector3(-1478.44, -375.91, 38.16), heading = 46, minZ = 36.6, maxZ = 38.1,     type = "big", robbed = false, camId = 5},
    [3] = {coords = vector3(-1221.47, -916.42, 10.20), heading = 34, minZ = 10.23, maxZ = 11.83,    type = "big", robbed = false, camId = 6},
    [4] = {coords = vector3(-710.38, -904.16, 18.16), heading = 0, minZ = 18.22, maxZ = 19.16,      type = "keypad", robbed = false, camId = 7},
    [5] = {coords = vector3(28.20, -1338.60, 28.50), heading = 0, minZ = 28.5, maxZ = 29.4,          type = "keypad", robbed = false, camId = 8},
    [6] = {coords = vector3(1126.68, -979.46, 44.30), heading = 8, minZ = 44.32, maxZ = 45.92,      type = "big", robbed = false, camId = 9},
    [7] = {coords = vector3(1158.85, -314.16, 68.10), heading = 10, minZ = 68.11, maxZ = 69.11,     type = "keypad", robbed = false, camId = 10},
    [8] = {coords = vector3(378.35, 334.00, 102.55), heading = 345.5, minZ = 102.60, maxZ = 103.45,  type = "keypad", robbed = false, camId = 11},
    [9] = {coords = vector3(-1829.68, 798.32, 137.18), heading = 312, minZ = 137.08, maxZ = 138.00, type = "keypad", robbed = false, camId = 12},
    [10] = {coords = vector3(-2959.66, 386.4, 12.90), heading = 357, minZ = 12.94, maxZ = 14.54,    type = "big", robbed = false, camId = 13},
    [11] = {coords = vector3(-3048.45, 585.40, 6.90), heading = 17.5, minZ = 6.9, maxZ = 7.8,       type = "keypad", robbed = false, camId = 14},
    [12] = {coords = vector3(-3250.70, 1004.45, 11.80), heading = 356, minZ = 11.8, maxZ = 12.7,      type = "keypad", robbed = false, camId = 15},
    [13] = {coords = vector3(546.55, 2662.2, 41.05), heading = 7.5, minZ = 41.1, maxZ = 42.1,        type = "keypad", robbed = false, camId = 16},
    [14] = {coords = vector3(1169.99, 2717.83, 36.05), heading = 0, minZ = 36.06, maxZ = 37.66,     type = "big", robbed = false, camId = 17},
    [15] = {coords = vector3(2672.2, 3286.9, 54.2), heading = 330, minZ = 54.20, maxZ = 55.15,      type = "keypad", robbed = false, camId = 18},
    [16] = {coords = vector3(1958.95, 3749.50, 31.30), heading = 302, minZ = 31.30, maxZ = 32.25,    type = "keypad", robbed = false, camId = 19},
    [17] = {coords = vector3(1735.1, 6421.45, 34.00), heading = 333, minZ = 34.00, maxZ = 34.95,    type = "keypad", robbed = false, camId = 20},
    [18] = {coords = vector3(169.3, 6645.15, 31.15), heading = 315, minZ = 30.7, maxZ = 31.6,       type = "keypad", robbed = false, camId = 30}, -- this aint even inside an MLO
    [19] = {coords = vector3(1708.27, 4921.0, 41.05), heading = 55, minZ = 41.05, maxZ = 41.95,     type = "keypad", robbed = false, camId = 31},
}

Config.MaleNoHandshoes = {
    [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [14] = true, [15] = true, [18] = true, [26] = true, [52] = true, [53] = true, [54] = true, [55] = true, [56] = true, [57] = true, [58] = true, [59] = true, [60] = true, [61] = true, [62] = true, [112] = true, [113] = true, [114] = true, [118] = true, [125] = true, [132] = true,
}
Config.FemaleNoHandshoes = {
    [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [14] = true, [15] = true, [19] = true, [59] = true, [60] = true, [61] = true, [62] = true, [63] = true, [64] = true, [65] = true, [66] = true, [67] = true, [68] = true, [69] = true, [70] = true, [71] = true, [129] = true, [130] = true, [131] = true, [135] = true, [142] = true, [149] = true, [153] = true, [157] = true, [161] = true, [165] = true,
}
