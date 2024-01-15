Config = {}
Config.UsingTarget = GetConvar('UseTarget', 'false') == 'true'
Config.Commission = 0.10                              -- Percent that goes to sales person from a full car sale 10%
Config.FinanceCommission = 0.05                       -- Percent that goes to sales person from a finance sale 5%
Config.FinanceZone = vector3(-29.53, -1103.67, 26.42) -- Where the finance menu is located
Config.PaymentWarning = 10                            -- time in minutes that player has to make payment before repo
Config.PaymentInterval = 24                           -- time in hours between payment being due
Config.MinimumDown = 100                               -- minimum percentage allowed down
Config.MaximumPayments = 24                           -- maximum payments allowed
Config.PreventFinanceSelling = true                  -- allow/prevent players from using /transfervehicle if financed
Config.FilterByMake = false                           -- adds a make list before selecting category in shops
Config.SortAlphabetically = true                      -- will sort make, category, and vehicle selection menus alphabetically
Config.HideCategorySelectForOne = true                -- will hide the category selection menu if a shop only sells one category of vehicle or a make has only one category
Config.Shops = {
    ['pdm'] = {
        ['Type'] = 'free-use', -- no player interaction is required to purchase a car
        ['Zone'] = {
            ['Shape'] = {      --polygon that surrounds the shop
                vector2(-56.727394104004, -1086.2325439453),
                vector2(-60.612808227539, -1096.7795410156),
                vector2(-58.26834487915, -1100.572265625),
                vector2(-35.927803039551, -1109.0034179688),
                vector2(-34.427627563477, -1108.5111083984),
                vector2(-32.02657699585, -1101.5877685547),
                vector2(-33.342102050781, -1101.0377197266),
                vector2(-31.292987823486, -1095.3717041016)
            },
            ['minZ'] = 25.0,                                         -- min height of the shop zone
            ['maxZ'] = 28.0,                                         -- max height of the shop zone
            ['size'] = 2.75                                          -- size of the vehicles zones
        },
        ['Job'] = 'none',                                            -- Name of job or none
        ['ShopLabel'] = 'Premium Deluxe Motorsport',                 -- Blip name
        ['showBlip'] = true,                                         -- true or false
        ['blipSprite'] = 326,                                        -- Blip sprite
        ['blipColor'] = 3,                                           -- Blip color
        ['TestDriveTimeLimit'] = 0.5,                                -- Time in minutes until the vehicle gets deleted
        ['Location'] = vector3(-45.67, -1098.34, 26.42),             -- Blip Location
        ['ReturnLocation'] = vector3(-44.74, -1082.58, 26.68),       -- Location to return vehicle, only enables if the vehicleshop has a job owned
        ['VehicleSpawn'] = vector4(-56.79, -1109.85, 26.43, 71.5),   -- Spawn location when vehicle is bought
        ['TestDriveSpawn'] = vector4(-56.79, -1109.85, 26.43, 71.5), -- Spawn location for test drive
        ['ShowroomVehicles'] = {
            [1] = {
                coords = vector4(-45.65, -1093.66, 25.44, 69.5), -- where the vehicle will spawn on display
                defaultVehicle = 'ardent',                       -- Default display vehicle
                chosenVehicle = 'ardent',                        -- Same as default but is dynamically changed when swapping vehicles
            },
            [2] = {
                coords = vector4(-48.27, -1101.86, 25.44, 294.5),
                defaultVehicle = 'schafter2',
                chosenVehicle = 'schafter2'
            },
            [3] = {
                coords = vector4(-39.6, -1096.01, 25.44, 66.5),
                defaultVehicle = 'coquette',
                chosenVehicle = 'coquette'
            },
            [4] = {
                coords = vector4(-51.21, -1096.77, 25.44, 254.5),
                defaultVehicle = 'vigero',
                chosenVehicle = 'vigero'
            },
            [5] = {
                coords = vector4(-40.18, -1104.13, 25.44, 338.5),
                defaultVehicle = 'rhapsody',
                chosenVehicle = 'rhapsody'
            },
            [6] = {
                coords = vector4(-43.31, -1099.02, 25.44, 52.5),
                defaultVehicle = 'bati',
                chosenVehicle = 'bati'
            },
            [7] = {
                coords = vector4(-50.66, -1093.05, 25.44, 222.5),
                defaultVehicle = 'bati',
                chosenVehicle = 'bati'
            },
            [8] = {
                coords = vector4(-44.28, -1102.47, 25.44, 298.5),
                defaultVehicle = 'bati',
                chosenVehicle = 'bati'
            }
        },
    },
    ['luxury'] = {
        ['Type'] = 'free-use', -- meaning a real player has to sell the car
        ['Zone'] = {
            ['Shape'] = {
                vector2(91.16, -156.32),
                vector2(148.25, -177.05),
                vector2(167.43, -128.05),
                vector2(105.72, -107.62),

            },
            ['minZ'] = 36.646457672119,
            ['maxZ'] = 37.516143798828,
            ['size'] = 2.75    -- size of the vehicles zones
        },
        ['Job'] = 'none', -- Name of job or none
        ['ShopLabel'] = 'Luxury Vehicle Shop',
        ['showBlip'] = true,   -- true or false
        ['blipSprite'] = 326,  -- Blip sprite
        ['blipColor'] = 46,     -- Blip color
        ['TestDriveTimeLimit'] = 0.5,
        ['Location'] = vector3(128.24, -153.03, 54.80),
        ['ReturnLocation'] = vector3(110.79, -137.78, 54.53),
        ['VehicleSpawn'] = vector4(116.15, -140.79, 54.80, 335.59),
        ['TestDriveSpawn'] = vector4(110.96, -131.08, 54.75, 68.83), -- Spawn location for test drive
        ['ShowroomVehicles'] = {
            [1] = {
                coords = vector4(131.77, -160.07, 53.86, 207.17),
                defaultVehicle = 'italirsx',
                chosenVehicle = 'italirsx'
            },
            [2] = {
                coords = vector4(137.35, -162.30, 53.86, 207.94),
                defaultVehicle = 'italigtb',
                chosenVehicle = 'italigtb'
            },
            [3] = {
                coords = vector4(142.84, -164.15, 53.86, 204.49),
                defaultVehicle = 'nero',
                chosenVehicle = 'nero'
            },
            [4] = {
                coords = vector4(126.20, -158.44, 53.86, 207.11),
                defaultVehicle = 'zr350',
                chosenVehicle = 'zr350'
            },
            [5] = {
                coords = vector4(120.69, -156.57, 53.86, 204.33),
                defaultVehicle = 'stingertt',
                chosenVehicle = 'stingertt'
            },
            [6] = {
                coords = vector4(138.23, -149.68, 54.05, 11.78),
                defaultVehicle = 'buffalo5',
                chosenVehicle = 'buffalo5'
            },
        }
    },                         -- Add your next table under this comma
    ['boats'] = {
        ['Type'] = 'free-use', -- no player interaction is required to purchase a vehicle
        ['Zone'] = {
            ['Shape'] = {      --polygon that surrounds the shop
                vector2(-729.39, -1315.84),
                vector2(-766.81, -1360.11),
                vector2(-754.21, -1371.49),
                vector2(-716.94, -1326.88)
            },
            ['minZ'] = 0.0,                                            -- min height of the shop zone
            ['maxZ'] = 5.0,                                            -- max height of the shop zone
            ['size'] = 6.2                                             -- size of the vehicles zones
        },
        ['Job'] = 'none',                                              -- Name of job or none
        ['ShopLabel'] = 'Marina Shop',                                 -- Blip name
        ['showBlip'] = true,                                           -- true or false
        ['blipSprite'] = 410,                                          -- Blip sprite
        ['blipColor'] = 3,                                             -- Blip color
        ['TestDriveTimeLimit'] = 1.5,                                  -- Time in minutes until the vehicle gets deleted
        ['Location'] = vector3(-738.25, -1334.38, 1.6),                -- Blip Location
        ['ReturnLocation'] = vector3(-714.34, -1343.31, 0.0),          -- Location to return vehicle, only enables if the vehicleshop has a job owned
        ['VehicleSpawn'] = vector4(-727.87, -1353.1, -0.17, 137.09),   -- Spawn location when vehicle is bought
        ['TestDriveSpawn'] = vector4(-722.23, -1351.98, 0.14, 135.33), -- Spawn location for test drive
        ['ShowroomVehicles'] = {
            [1] = {
                coords = vector4(-727.05, -1326.59, 0.00, 229.5), -- where the vehicle will spawn on display
                defaultVehicle = 'seashark',                      -- Default display vehicle
                chosenVehicle = 'seashark'                        -- Same as default but is dynamically changed when swapping vehicles
            },
            [2] = {
                coords = vector4(-732.84, -1333.5, -0.50, 229.5),
                defaultVehicle = 'dinghy',
                chosenVehicle = 'dinghy'
            },
            [3] = {
                coords = vector4(-737.84, -1340.83, -0.50, 229.5),
                defaultVehicle = 'speeder',
                chosenVehicle = 'speeder'
            },
            [4] = {
                coords = vector4(-741.53, -1349.7, -2.00, 229.5),
                defaultVehicle = 'marquis',
                chosenVehicle = 'marquis'
            },
        },
    },
    ['sanders'] = {
        ['Type'] = 'free-use', -- no player interaction is required to purchase a vehicle
        ['Zone'] = {
            ['Shape'] = {      --polygon that surrounds the shop
                vector2(266.37, -1147.22),
                vector2(264.34, -1179.35),
                vector2(310.53, -1168.04),
                vector2(312.20, -1144.96)
            },
            ['minZ'] = 12.99,                                            -- min height of the shop zone
            ['maxZ'] = 16.99,                                            -- max height of the shop zone
            ['size'] = 7.0,                                              -- size of the vehicles zones
        },
        ['Job'] = 'none',                                                -- Name of job or none
        ['ShopLabel'] = 'Sanders Motorcycle',                                      -- Blip name
        ['showBlip'] = true,                                             -- true or false
        ['blipSprite'] = 226,                                            -- Blip sprite
        ['blipColor'] = 51,                                               -- Blip color
        ['TestDriveTimeLimit'] = 0.5,                                    -- Time in minutes until the vehicle gets deleted
        ['Location'] = vector3(294.59, -1154.51, 29.29),                -- Blip Location
        ['ReturnLocation'] = vector3(298.80, -1158.83, 29.29),          -- Location to return vehicle, only enables if the vehicleshop has a job owned
        ['VehicleSpawn'] = vector4(308.64, -1163.28, 29.29, 272.33),    -- Spawn location when vehicle is bought
        ['TestDriveSpawn'] = vector4(315.81, -1153.35, 29.29, 354.12), -- Spawn location for test drive
        ['ShowroomVehicles'] = {
            [1] = {
                coords = vector4(297.36, -1153.25, 28.55, 19.90), -- where the vehicle will spawn on display
                defaultVehicle = 'stryder',                          -- Default display vehicle
                chosenVehicle = 'stryder'                            -- Same as default but is dynamically changed when swapping vehicles
            },
            [2] = {
                coords = vector4(303.32, -1158.77, 28.59, 346.37),
                defaultVehicle = 'akuma',
                chosenVehicle = 'akuma'
            },
            [3] = {
                coords = vector4(303.20, -1155.41, 28.59, 342.53),
                defaultVehicle = 'bati2',
                chosenVehicle = 'bati2'
            },
            [4] = {
                coords = vector4(303.21, -1152.09, 28.59, 341.86),
                defaultVehicle = 'hakuchou2',
                chosenVehicle = 'hakuchou2'
            },
            [5] = {
                coords = vector4(280.35, -1151.10, 28.29, 343.33), 
                defaultVehicle = 'pcj',                  
                chosenVehicle = 'pcj'                       
            },
            [6] = {
                coords = vector4(278.39, -1151.10, 28.29, 337.21),
                defaultVehicle = 'akuma',
                chosenVehicle = 'akuma'
            },
            [7] = {
                coords = vector4(276.37, -1151.00, 28.29, 344.38),
                defaultVehicle = 'bati2',
                chosenVehicle = 'bati2'
            },
            [8] = {
                coords = vector4(274.44, -1151.26, 28.29, 345.84),
                defaultVehicle = 'hakuchou',
                chosenVehicle = 'hakuchou'
            },
            [9] = {
                coords = vector4(278.24, -1155.29, 28.29, 339.47),
                defaultVehicle = 'akuma',
                chosenVehicle = 'akuma'
            },
            [10] = {
                coords = vector4(275.44, -1155.41, 28.29, 336.81),
                defaultVehicle = 'bati',
                chosenVehicle = 'bati'
            },
        },
    },
    ['police'] = {
        ['Type'] = 'free-use', -- no player interaction is required to purchase a car
        ['Zone'] = {
            ['Shape'] = {      --polygon that surrounds the shop
                vector2(458.70, -1010.03),
                vector2(459.03, -1023.17),
                vector2(465.89, -1023.41),
                vector2(466.00, -1012.96),
            
            },
            ['minZ'] = 23.0,                                         -- min height of the shop zone
            ['maxZ'] = 28.0,                                         -- max height of the shop zone
            ['size'] = 5.75                                          -- size of the vehicles zones
        },
        ['Job'] = 'police',                                            -- Name of job or none
        ['ShopLabel'] = 'police',                          -- Blip name
        ['showBlip'] = false,                                         -- true or false
        ['blipSprite'] = 477,                                        -- Blip sprite
        ['blipColor'] = 2,                                           -- Blip color
        ['TestDriveTimeLimit'] = 0.5,                                -- Time in minutes until the vehicle gets deleted
        ['Location'] = vector3(900.47, -1155.74, 25.16),             -- Blip Location
        ['ReturnLocation'] = vector3(900.47, -1155.74, 25.16),       -- Location to return vehicle, only enables if the vehicleshop has a job owned
        ['VehicleSpawn'] = vector4(453.81, -1024.89, 28.50, 4.17), -- Spawn location when vehicle is bought
        ['TestDriveSpawn'] = vector4(446.56, -1018.98, 28.58, 97.43), -- Spawn location for test drive
        ['ShowroomVehicles'] = {
            [1] = {
                coords = vector4(463.79, -1015.51, 28.08, 86.73), -- where the vehicle will spawn on display
                defaultVehicle = 'police3',                         -- Default display vehicle
                chosenVehicle = 'police3',                          -- Same as default but is dynamically changed when swapping vehicles
            },
            
        },
    },
}
