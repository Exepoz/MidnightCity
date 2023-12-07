Shared = {}

--- General Settings
Shared.Debug = true -- true | false, enable or disable debug mode
Shared.Enable = { -- true | false, enable or disable script components
    Druglabs = false,
    Drugruns = false,
    Missions = true,
    Cornerselling = true,
    Weedfarm = false,
    Methcamper = true
}

Shared.EmptyBagItem = 'emptybaggy'
Shared.EmptyBagAmount = 100 -- Amount of baggies made from one brick
Shared.BuffPurityRequired = 34 -- Minimum amount of purity required for buff to be active
Shared.BuffDuration = 8 -- Time in seconds for unlimited stamina and armour
Shared.BuffArmourPerSecond = 5 -- Amount of armour the player receives per second
Shared.BuffSprintMultiplier = 1.1 -- Sprint multiplier for cokebaggy

--- Druglabs related settings
Shared.PoliceRaid = true -- true | false, enable or disable the option for police to raid the lab
Shared.MinimumPurity = 34 -- Minimum purity that can be received from druglabs
Shared.Creation = {
    command = 'createlab', -- Name of the command
    rank = 'god' -- Permission level requirement
}

Shared.DrugLabs = {
    ['meth'] = {
        shell = `k4meth_shell`,
        POIOffsets = {
            exit = vector4(-11.2839, -2.4609, 9.3995, 270.0),
            supplies = vector4(-9.7706, 0.2913, 6.7987, 21.53),
            task1 = vector4(-2.1021, -2.3637, 7.2476, 180.0),
            task2 = vector4(3.4028, 0.934616, 6.7974, 180.0),
            task3 = vector4(2.2876, -1.6541, 6.7974, 0.0),
            curing = vector4(-3.3056, 3.1830, 6.7988, 0.0),
            reward = vector4(-1.2920, 0.4249, 6.7988, 265)
        },
        tasks = {
            [1] = {
                requiredIngredients = 6,
                duration = 60 -- Duration in seconds
            },
            [2] = {
                requiredIngredients = 4,
                duration = 120
            },
            [3] = {
                requiredIngredients = 2,
                duration = 120
            },
        },
        curing = {
            duration = 120
        },
        items = {
            supply = 'methylamine',
            batchItem = 'meth_batch',
            curedItem = 'meth_cured',
            bagItem = 'meth_baggy'
        }
    },
    ['coke'] = {
        shell = `k4coke_shell`,
        POIOffsets = {
            exit = vector4(-10.96, -2.44, 22.64, 270.0),
            supplies = vector4(-9.1652, 0.4929, 19.96, 224.53),
            task1 = vector4(-1.013, 0.422, 20.271, 0.0),
            task2 = vector4(4.173, 0.364, 20.271, 0.0),
            task3 = vector4(4.715, -4.0105, 20.271, 0.0),
            curing = vector4(-3.3424, 3.2900, 19.965, 0.0),
            reward = vector4(6.588, 3.755, 19.965, 0.0)
        },
        tasks = {
            [1] = {
                requiredIngredients = 6,
                duration = 60 -- Duration in seconds
            },
            [2] = {
                requiredIngredients = 4,
                duration = 120
            },
            [3] = {
                requiredIngredients = 2,
                duration = 120
            },
        },
        curing = {
            duration = 120
        },
        items = {
            supply = 'ecgonine',
            batchItem = 'coke_batch',
            curedItem = 'coke_cured',
            bagItem = 'coke_baggy'
        }
    },
    ['weed'] = {
        shell = `k4weed_shell`,
        POIOffsets = {
            exit = vector4(-10.9733, -2.5092, 20.9669, 270.0),
            supplies = vector4(-8.9604, 0.2647, 18.2908, 37.0),
            task1 = vector4(-3.767, 0.272, 18.41, 270.0),
            task2 = vector4(-1.867, 0.272, 18.41, 270.0),
            task3 = vector4(1.867, 0.272, 18.41, 270.0),
            curing = vector4(-3.3056, 3.1830, 18.29, 0.0),
            reward = vector4(2.6191, 3.923, 18.2974, 0.0)
        },
        tasks = {
            [1] = {
                requiredIngredients = 6,
                duration = 60 -- Duration in seconds
            },
            [2] = {
                requiredIngredients = 4,
                duration = 120
            },
            [3] = {
                requiredIngredients = 2,
                duration = 120
            },
        },
        curing = {
            duration = 120
        },
        items = {
            supply = 'weed_nutrition',
            batchItem = 'weed_batch',
            curedItem = 'weed_cured',
            bagItem = 'weed_baggy'
        }
    },
}

--- Mission related settings
Shared.MissionStartLocation = vector4(1211.39, 1857.52, 78.97, 55.59)
Shared.MissionStartBlip = false -- true | false, enable or disable the blip to start
Shared.MissionStartPedModel = 'ig_vagspeak'
Shared.MissionStartPrice = 5000
Shared.MissionStartMoneyType = 'cash' -- 'cash' | 'bank' | 'crypto'
Shared.MissionStartCopAmount = 0 -- Minimum amount of cops on duty required to start mission
Shared.MissionCoolDown = 60 -- Time in minutes for global cooldown, cooldown starts when started and will force clear the mission

Shared.Missions = {
    ['gang'] = {
        [1] = {
            coordinate = vector3(3584.9, 3666.32, 33.89), -- This coordinate is used to create the blip radius
            radius = 150.0, -- Distance from when the guards should spawn, in case you want this smaller.
            difficulty = 1, -- Difficulty decides the hp, armour and weaponry of the guards and reward
            crates = { -- You can always add more crates, but this will create more looting spots
                vector4(3594.81, 3664.50, 33.87, 350.0),
                vector4(3594.81, 3659.50, 33.87, 170.0),
            },
            guards = { -- You can always add more guards
                vector3(3601.19, 3662.35, 33.87),
                vector3(3600.22, 3660.32, 33.87),
                vector3(3583.02, 3661.74, 33.9),
                vector3(3571.96, 3677.3, 41.0),
                vector3(3583.33, 3682.04, 41.0),
                vector3(3585.6, 3665.31, 42.47),
                vector3(3589.73, 3644.89, 41.34),
                vector3(3577.36, 3644.97, 41.34)
            }
        },
        [2] = {
            coordinate = vector3(2671.73, 3927.3, 42.78),
            radius = 100.0,
            difficulty = 1,
            crates = {
                vector4(2670.25, 3927.3, 42.78, 262.29),
                vector4(2672.40, 3926.6, 42.78, 82.29),
            },
            guards = {
                vector3(2668.62, 3924.61, 42.57),
                vector3(2666.55, 3934.13, 42.41),
                vector3(2677.34, 3936.37, 43.07),
                vector3(2683.42, 3928.7, 43.62),
                vector3(2679.54, 3893.49, 41.74),
                vector3(2678.49, 3875.48, 49.44),
                vector3(2652.47, 3888.41, 55.18),
                vector3(2621.77, 3914.43, 52.49)
            }
        },
        [3] = {
            coordinate = vector3(202.66, 2796.2, 45.66),
            radius = 100.0,
            difficulty = 1,
            crates = {
                vector4(213.34, 2799.30, 45.66, 190.75),
                vector4(210.80, 2796.53, 45.66, 280.35)
            },
            guards = {
                vector3(209.88, 2803.08, 45.66),
                vector3(205.53, 2793.19, 45.66),
                vector3(205.85, 2800.91, 45.66),
                vector3(211.44, 2792.09, 45.66),
                vector3(184.31, 2777.85, 45.66),
                vector3(178.23, 2773.39, 45.7),
                vector3(181.02, 2793.86, 45.66),
                vector3(175.01, 2792.66, 49.81)
            }
        },
        [4] = {
            coordinate = vector3(722.13, 4177.1, 40.71),
            radius = 100.0,
            difficulty = 1,
            crates = {
                vector4(718.25, 4182.82, 40.71, 0.0),
                vector4(725.45, 4192.20, 40.71, 90.0)
            },
            guards = {
                vector3(723.05, 4186.34, 40.71),
                vector3(710.8, 4185.3, 41.08),
                vector3(702.82, 4182.99, 40.72),
                vector3(740.37, 4170.52, 41.09),
                vector3(741.72, 4170.13, 41.09),
                vector3(749.58, 4184.03, 41.09),
                vector3(775.78, 4184.07, 41.78),
                vector3(775.75, 4186.13, 41.78),
                vector3(721.29, 4158.19, 38.31),
                vector3(707.35, 4159.48, 37.39),
                vector3(685.16, 4184.76, 40.71)
            }
        },
        [5] = {
            coordinate = vector3(-414.55, -2274.88, 7.61),
            radius = 75.0,
            difficulty = 1,
            crates = {
                vector4(-409.89, -2300.59, 3.67, 80.0),
                vector4(-409.59, -2298.47, 3.67, 80.0)
            },
            guards = {
                vector3(-404.65, -2299.81, 3.67),
                vector3(-404.24, -2297.69, 3.67),
                vector3(-428.99, -2283.07, 7.61),
                vector3(-431.29, -2282.92, 7.61),
                vector3(-437.74, -2277.07, 7.61),
                vector3(-443.75, -2260.3, 7.41),
                vector3(-387.59, -2267.82, 7.61),
                vector3(-369.23, -2287.58, 7.61),
                vector3(-363.73, -2283.73, 7.61),
                vector3(-392.14, -2279.25, 26.13),
                vector3(-390.25, -2286.54, 26.13)
            }
        },
        [6] = {
            coordinate = vector3(1241.69, -2991.43, 12.16),
            radius = 75.0,
            difficulty = 1,
            crates = {
                vector4(1248.07, -3009.90, 9.32, 0.0),
                vector4(1238.37, -3011.40, 9.32, 180.0)

            },
            guards = {
                vector3(1232.9, -3010.78, 9.32),
                vector3(1231.83, -3022.56, 9.32),
                vector3(1243.43, -3002.59, 9.32),
                vector3(1252.66, -2996.47, 9.32),
                vector3(1252.6, -2980.02, 9.32),
                vector3(1252.59, -2966.29, 9.32),
                vector3(1244.86, -2969.9, 9.32),
                vector3(1233.89, -2969.4, 9.32),
                vector3(1228.72, -2976.92, 9.32),
                vector3(1231.06, -2985.98, 9.32),
                vector3(1234.24, -2987.91, 11.98),
                vector3(1244.86, -2993.22, 12.16)
            }
        },
        [7] = {
            coordinate = vector3(31.46, -2687.61, 12.01),
            radius = 40.0,
            difficulty = 1,
            crates = {
                vector4(31.00, -2686.62, 12.04, 0.0),
                vector4(31.40, -2684.37, 12.04, 180.0),
                vector4(32.50, -2686.62, 12.04, 0.0),
                vector4(32.90, -2684.37, 12.04, 180.0)
            },
            guards = {
                vector3(35.22, -2689.85, 12.01),
                vector3(29.1, -2691.41, 12.01),
                vector3(29.57, -2680.66, 12.04),
                vector3(21.81, -2675.91, 12.01),
                vector3(40.63, -2657.67, 12.04),
                vector3(42.71, -2674.85, 17.15),
                vector3(25.39, -2675.39, 17.15),
                vector3(20.5, -2677.39, 6.01),
                vector3(21.05, -2694.17, 6.01),
                vector3(49.06, -2710.84, 12.01),
                vector3(44.83, -2745.07, 13.46),
                vector3(48.75, -2743.1, 12.01),
                vector3(44.13, -2719.47, 13.51),
                vector3(29.73, -2719.11, 13.52),
                -- vector3(23.4, -2744.98, 13.53),
                -- vector3(19.08, -2741.0, 12.01),
                -- vector3(19.04, -2697.04, 12.01),
                -- vector3(47.38, -2689.32, 12.01),
                -- vector3(37.27, -2673.8, 12.05)
            }
        },
    },
}

Shared.Barrels = {
    ['methy'] = {
        [1] = {
            door = vector4(822.78, -2338.56, 30.47, 351.09),
            zone = {
                vector3(820.44, -2439.48, 30.00),
                vector3(884.34, -2447.04, 30.00),
                vector3(899.3, -2318.88, 30.00),
                vector3(867.24, -2316.25, 30.00),
                vector3(871.17, -2263.12, 30.00),
                vector3(805.05, -2257.49, 30.00),
                vector3(788.4, -2370.98, 30.00)
            }
        },
        [2] = {
            door = vector4(-121.45, 6204.61, 32.38, 34.16),
            zone = {
                vector3(-145.52, 6217.39, 25.00),
                vector3(-124.3, 6239.77, 25.00),
                vector3(-104.04, 6213.61, 25.00),
                vector3(-109.68, 6188.55, 25.00),

            }
         },
        [3] = {
        door = vector4(1092.59, -2251.7, 31.23, 273.49),
        zone = {
            vector3(1061.82, -2272.78, 27.00),
            vector3(1065.39, -2204.86, 27.00),
            vector3(1103.93, -2208.2, 27.00),
            vector3(1104.54, -2277.48, 27.00),

            }
        },
        [4] = {
        door = vector4(844.84, -902.86, 25.25, 269.7),
        zone = {
            vector3(798.11, -929.96, 25.61),
            vector3(793.86, -860.84, 25.27),
            vector3(911.38, -860.96, 26.11),
            vector3(910.99, -876.43, 26.11),
            vector3(897.67, -925.03, 27.86)

            }
         },
    }
}

Shared.Quarry = {
    ['alluminum'] = {
        [1] = {
            route = {

            },
        }
    }
}

Shared.QuarryShacks = {
    vector4(2707.4, 2776.68, 38.0, 212.04),
    vector4(2746.14, 2787.91, 35.54, 214.12),
    vector4(2832.61, 2799.93, 57.47, 280.6),
    vector4(2663.58, 2891.3, 36.93, 196.45),
    vector4(2601.11, 2804.44, 33.82, 10.66),
    vector4(2569.31, 2720.33, 42.96, 34.0)
}

Shared.QuarrySpotLights = {
    [1] = {
        loc = vector3(2663.386474609375, 2733.72900390625, 39.15681838989258),
        lightPath = {
            {coords = vector3(2692.36, 2722.77, 40.89), wait = 3000, timeToNext = 3000, timeToPrev = 3000}, -- ttPrev not used on First
            {coords = vector3(2643.21, 2733.55, 40.57), wait = 5000, timeToNext = 5000, timeToPrev = 3000},
            {coords = vector3(2672.93, 2744.95, 38.14), wait = 3000, timeToNext = 3000, timeToPrev = 8000}, -- ttNext not used on Last
        }
    },
    [2] = {
        loc = vector3(2748.902099609375, 2736.087646484375, 40.51273727416992),
        lightPath = {
            {coords = vector3(2774.48, 2762.31, 44.76), wait = 3000, timeToNext = 3000, timeToPrev = 5000}, -- ttPrev not used on First
            {coords = vector3(2751.52, 2752.22, 42.75), wait = 0, timeToNext = 5000, timeToPrev = 5000},
            {coords = vector3(2716.56, 2733.49, 40.85), wait = 3000, timeToNext = 5000, timeToPrev = 5000},
            {coords = vector3(2726.42, 2750.55, 40.71), wait = 0, timeToNext = 2000, timeToPrev = 2000},
            {coords = vector3(2747.88, 2765.31, 39.83), wait = 3000, timeToNext = 3000, timeToPrev = 5000}, -- ttNext not used on Last
        }
    },
    [3] = {
        loc = vector3(2614.443115234375, 2793.2666015625, 32.4632453918457),
        lightPath = {
            {coords = vector3(2633.59, 2771.47, 33.94), wait = 3000, timeToNext = 3000, timeToPrev = 3000}, -- ttPrev not used on First
            {coords = vector3(2612.51, 2773.94, 33.63), wait = 0, timeToNext = 3000, timeToPrev = 3000},
            {coords = vector3(2598.9, 2779.54, 33.41), wait = 0, timeToNext = 3000, timeToPrev = 3000},
            {coords = vector3(2590.11, 2796.84, 34.09), wait = 0, timeToNext = 3000, timeToPrev = 3000},
            {coords = vector3(2590.36, 2812.78, 33.86), wait = 3000, timeToNext = 3000, timeToPrev = 3000}, -- ttNext not used on Last
        }
    },
    [4] = {
        loc = vector3(2584.967041015625, 2739.977783203125, 41.52592086791992),
        lightPath = {
            {coords = vector3(2615.17, 2731.95, 40.86), wait = 0, timeToNext = 3000, timeToPrev = 3000}, -- ttPrev not used on First
            {coords = vector3(2586.97, 2722.57, 42.65), wait = 0, timeToNext = 3000, timeToPrev = 3000},
            {coords = vector3(2577.35, 2742.46, 42.67), wait = 0, timeToNext = 3000, timeToPrev = 3000},
            {coords = vector3(2564.48, 2751.72, 42.47), wait = 0, timeToNext = 3000, timeToPrev = 3000}, -- ttNext not used on Last
        }
    },
    [5] = {
        loc = vector3(2790.83251953125, 2850.651611328125, 35.25838470458984),
        lightPath = {
            {coords = vector3(2815.69, 2850.86, 41.68), wait = 0, timeToNext = 4000, timeToPrev = 4000}, -- ttPrev not used on First
            {coords = vector3(2801.8, 2883.16, 39.7), wait = 0, timeToNext = 4000, timeToPrev = 4000},
            {coords = vector3(2776.85, 2917.09, 37.17), wait = 0, timeToNext = 4000, timeToPrev = 4000},
            {coords = vector3(2745.46, 2938.43, 35.99), wait = 0, timeToNext = 4000, timeToPrev = 4000}, -- ttNext not used on Last
        }
    },
    [6] = {
        loc = vector3(2788.761962890625, 2799.446533203125, 39.3626823425293),
        lightPath = {
            {coords = vector3(2754.83, 2769.85, 39.95), wait = 0, timeToNext = 3000, timeToPrev = 3000}, -- ttPrev not used on First
            {coords = vector3(2794.28, 2796.39, 40.94), wait = 0, timeToNext = 3000, timeToPrev = 3000},
            {coords = vector3(2806.91, 2822.65, 41.94), wait = 3000, timeToNext = 3000, timeToPrev = 3000},
            {coords = vector3(2815.69, 2850.86, 41.68), wait = 0, timeToNext = 3000, timeToPrev = 3000}, -- ttNext not used on Last
        }
    },
    [7] = {
        loc = vector3(2744.64, 2896.1, 36.43),
        lightPath = {
            {coords = vector3(2704.23, 2919.07, 36.41), wait = 0, timeToNext = 3000, timeToPrev = 3000}, -- ttPrev not used on First
            {coords = vector3(2729.71, 2918.6, 36.32), wait = 0, timeToNext = 3000, timeToPrev = 3000},
            {coords = vector3(2747.53, 2906.9, 36.36), wait = 0, timeToNext = 3000, timeToPrev = 3000},
            {coords = vector3(2752.45, 2893.91, 36.41), wait = 0, timeToNext = 3000, timeToPrev = 3000},
            {coords = vector3(2751.19, 2863.15, 37.55), wait = 0, timeToNext = 3000, timeToPrev = 3000},
            {coords = vector3(2743.11, 2850.02, 38.07), wait = 0, timeToNext = 3000, timeToPrev = 3000}, -- ttNext not used on Last
        }
    },
    [8] = {
        loc = vector3(2712.2578125, 2769.00927734375, 35.44647598266601),
        lightPath = {
            {coords = vector3(2734.68, 2782.54, 35.9), wait = 3000, timeToNext = 10000, timeToPrev = 100}, -- ttPrev not used on First
            {coords = vector3(2695.71, 2750.36, 37.57), wait = 0, timeToNext = 5000, timeToPrev = 10000},
            {coords = vector3(2685.58, 2767.65, 37.88), wait = 3000, timeToNext = 3000, timeToPrev = 5000}, -- ttNext not used on Last
        }
    },
    [9] = {
        loc = vector3(2839.019775390625, 2801.73291015625, 56.47531127929687),
        lightPath = {
            {coords = vector3(2805.03, 2779.19, 52.82), wait = 3000, timeToNext = 5000, timeToPrev = 0}, -- ttPrev not used on First
            {coords = vector3(2826.95, 2788.98, 57.65), wait = 3000, timeToNext = 1000, timeToPrev = 5000},
            {coords = vector3(2849.02, 2834.74, 51.94), wait = 3000, timeToNext = 5000, timeToPrev = 1000}, -- ttNext not used on Last
            {coords = vector3(2834.48, 2867.81, 48.51), wait = 3000, timeToNext = 0, timeToPrev = 5000}, -- ttNext not used on Last
        }
    },
    [10] = {
        loc = vector3(2642.6728515625, 2943.192626953125, 36.24665069580078),
        lightPath = {
            {coords = vector3(2706.37, 2948.22, 36.48), wait = 3000, timeToNext = 3000, timeToPrev = 0}, -- ttPrev not used on First
            {coords = vector3(2683.61, 2955.46, 36.52), wait = 3000, timeToNext = 3000, timeToPrev = 3000},
            {coords = vector3(2655.41, 2942.05, 36.48), wait = 0, timeToNext = 3000, timeToPrev = 3000},
            {coords = vector3(2638.32, 2924.12, 36.48), wait = 0, timeToNext = 3000, timeToPrev = 3000},
            {coords = vector3(2619.01, 2892.85, 36.58), wait = 3000, timeToNext = 0, timeToPrev = 3000}, -- ttNext not used on Last
        }
    },
    [11] = {
        loc = vector3(2689.850341796875, 2922.545166015625, 35.27943420410156),
        lightPath = {
            {coords = vector3(2704.23, 2919.07, 36.41), wait = 0, timeToNext = 3000, timeToPrev = 0}, -- ttPrev not used on First
            {coords = vector3(2675.41, 2902.62, 36.35), wait = 0, timeToNext = 3000, timeToPrev = 3000},
            {coords = vector3(2641.67, 2897.7, 36.39), wait = 0, timeToNext = 2000, timeToPrev = 3000},
            {coords = vector3(2619.01, 2892.85, 36.58), wait = 0, timeToNext = 0, timeToPrev = 2000}, -- ttNext not used on Last
        }
    },
    [12] = {
        loc = vector3(2611.6220703125, 2857.07275390625, 34.48604202270508),
        lightPath = {
            {coords = vector3(2605.29, 2875.33, 36.4), wait = 0, timeToNext = 3000, timeToPrev = 0}, -- ttPrev not used on First
            {coords = vector3(2602.85, 2849.95, 36.28), wait = 0, timeToNext = 3000, timeToPrev = 3000},
            {coords = vector3(2621.43, 2844.8, 36.56), wait = 0, timeToNext = 3000, timeToPrev = 3000},
            {coords = vector3(2647.53, 2851.45, 38.32), wait = 0, timeToNext = 3000, timeToPrev = 2000}, -- ttNext not used on Last
            {coords = vector3(2671.87, 2844.68, 39.91), wait = 0, timeToNext = 0, timeToPrev = 2000}, -- ttNext not used on Last
        }
    },
    [13] = {
        loc = vector3(2712.43994140625, 2836.094970703125, 37.62372207641601),
        lightPath = {
            {coords = vector3(2710.2, 2825.73, 39.81), wait = 3000, timeToNext = 2000, timeToPrev = 0}, -- ttPrev not used on First
            {coords = vector3(2734.2, 2844.92, 38.49), wait = 0, timeToNext = 3000, timeToPrev = 3000},
            {coords = vector3(2688.98, 2845.77, 39.73), wait = 0, timeToNext = 1000, timeToPrev = 3000},
            {coords = vector3(2679.89, 2836.03, 40.18), wait = 0, timeToNext = 1750, timeToPrev = 2000}, -- ttNext not used on Last
            {coords = vector3(2683.11, 2819.16, 40.41), wait = 3000, timeToNext = 0, timeToPrev = 2000}, -- ttNext not used on Last
        }
    },
    [14] = {
        loc = vector3(2685.41, 2874.86, 35.91),
        lightPath = {
            {coords = vector3(2705.26, 2860.06, 38.03), wait = 3000, timeToNext = 3000, timeToPrev = 0}, -- ttPrev not used on First
            {coords = vector3(2698.65, 2897.12, 36.81), wait = 3000, timeToNext = 3000, timeToPrev = 3000},
            {coords = vector3(2673.03, 2884.73, 36.04), wait = 0, timeToNext = 3000, timeToPrev = 3000},
            {coords = vector3(2644.43, 2884.12, 36.14), wait = 3000, timeToNext = 0, timeToPrev = 3000}, -- ttNext not used on Last
        }
    },
    [15] = {
        loc = vector3(2639.02, 2812.18, 33.48),
        lightPath = {
            {coords = vector3(2657.82, 2827.78, 34.67), wait = 3000, timeToNext = 3000, timeToPrev = 0}, -- ttPrev not used on First
            {coords = vector3(2621.76, 2830.43, 34.01), wait = 3000, timeToNext = 3500, timeToPrev = 3000},
            {coords = vector3(2666.69, 2802.42, 33.45), wait = 0, timeToNext = 3000, timeToPrev = 3500},
            {coords = vector3(2652.05, 2779.27, 33.65), wait = 3000, timeToNext = 0, timeToPrev = 3000}, -- ttNext not used on Last
        }
    },

}

Shared.DifficultySettings = {
    [1] = {
        health = 200,
        armor = 100,
        weapon = `WEAPON_PISTOL`,
        reward = 20
    },
    [2] = {
        health = 300,
        armor = 150,
        weapon = `WEAPON_SMG`,
        reward = 30
    },
    [3] = {
        health = 400,
        armor = 200,
        weapon = `WEAPON_CARBINERIFLE`,
        reward = 40
    },
}

--- Drugrun related settings
Shared.DrugrunStartLocation = vector4(82.37, -1615.62, 29.59, 195.23)
Shared.DrugrunStartBlip = false -- true | false, enable or disable the blip to start
Shared.DrugrunStartPedModel = 'a_m_y_breakdance_01'
Shared.DrugrunPackageItem = 'suspicious_package'
Shared.DrugrunPackageTime = 1 -- Time in minutes
Shared.DrugrunPackageProp = `prop_mp_drug_package`

Shared.DeliveryWaitTime = {8, 12} -- Time in seconds (min, max) the player has to wait to receive a new delivery location
Shared.DrugrunCallCopsChance = 20 -- 20%
Shared.PayOut = { -- Payout settings for delivering a package
    baseMin = 4000,
    baseMax = 6000,
    copMultiplier = 400, -- Amount added per on duty cop
    purityMultiplier = 50, -- Amount added per % of purity
    copCap = 10, -- Max amount of cops, this stop insane values if you have large amounts of cops on
}

Shared.DropOffLocations = { -- Drop-off locations
    vector4(74.5, -762.17, 31.68, 160.98),
    vector4(100.58, -644.11, 44.23, 69.11),
    vector4(175.45, -445.95, 41.1, 92.72),
    vector4(130.3, -246.26, 51.45, 219.63),
    vector4(198.1, -162.11, 56.35, 340.09),
    vector4(341.0, -184.71, 58.07, 159.33),
    vector4(-26.96, -368.45, 39.69, 251.12),
    vector4(-155.88, -751.76, 33.76, 251.82),
    vector4(-305.02, -226.17, 36.29, 306.04),
    vector4(-347.19, -791.04, 33.97, 3.06),
    vector4(-703.75, -932.93, 19.22, 87.86),
    vector4(-659.35, -256.83, 36.23, 118.92),
    vector4(-934.18, -124.28, 37.77, 205.79),
    vector4(-1214.3, -317.57, 37.75, 18.39),
    vector4(-822.83, -636.97, 27.9, 160.23),
    vector4(308.04, -1386.09, 31.79, 47.23),
    vector4(-1041.13, -392.04, 37.81, 25.98),
    vector4(-731.69, -291.67, 36.95, 330.53),
    vector4(-835.17, -353.65, 38.68, 265.05),
    vector4(-1062.43, -436.19, 36.63, 121.55),
    vector4(-1147.18, -520.47, 32.73, 215.39),
    vector4(-1174.68, -863.63, 14.11, 34.24),
    vector4(-1688.04, -1040.9, 13.02, 232.85),
    vector4(-1353.48, -621.09, 28.24, 300.64),
    vector4(-1029.98, -814.03, 16.86, 335.74),
    vector4(-893.09, -723.17, 19.78, 91.08),
    vector4(-789.23, -565.2, 30.28, 178.86),
    vector4(-345.48, -1022.54, 30.53, 341.03),
    vector4(218.9, -916.12, 30.69, 6.56),
    vector4(57.66, -1072.3, 29.45, 245.38),
}

Shared.DropOffPeds = { -- Drop-off ped models
	'a_m_y_stwhi_02',
	'a_m_y_stwhi_01',
	'a_f_y_genhot_01',
	'a_f_y_vinewood_04',
	'a_m_m_golfer_01',
	'a_m_m_soucent_04',
	'a_m_o_soucent_02',
	'a_m_y_epsilon_01',
	'a_m_y_epsilon_02',
	'a_m_y_mexthug_01',
}

--- Cornerselling related settings
Shared.CornerSellingCops = 0 -- Cops required to start cornering
Shared.CornerCallCopsChance = 15 -- %Chance to call cops when selling to a ped
Shared.CornerSellZoneRadius = 75 -- Zone Radius where the player has to stay during cornerselling
Shared.CornerSellPedInterval = 10 -- Times in seconds to spawn a ped
Shared.CornerSellSuccessChance = 40 -- %Chance that a spawned ped will approach you to sell to
Shared.CornerSellZonedBasedPayout = true -- true | false, enable or disable zone based payout (see sv_cornerselling for payout table)
Shared.CornerSellBags = { -- Amount of bags to be sold per deal
    min = 1,
    max = 10
}

Shared.CornerSellPeds = { -- List of ped models for cornerselling
    `a_f_o_genstreet_01`,
    `a_m_o_genstreet_01`,
    `a_m_y_genstreet_01`,
    `a_m_y_genstreet_02`,
}

Shared.CornerSellDrugs = { -- This table defines the price paid per bag of drugs when cornerselling
    -- Heroin
    ['malmo_heroinsyringe'] = {
        baseMin = 300, -- base minimum payout
        baseMax = 440, -- base maximum payout
        copMultiplier = 15, -- Amount added per on duty cop (no purity multiplier with this drug)
        purityMultiplier = 1, -- Amount added per % of purity
        copCap = 10 -- Max amount of cops, this stop insane values if you have large amounts of cops on
    },
    --Coke (future coke)
    ['lq_coke_baggy'] = {
        baseMin = 100,
        baseMax = 200,
        copMultiplier = 15,-- Amount added per on duty cop (no purity multiplier with this drug)
        purityMultiplier = 1,
        copCap = 8
    },
    --(Methcamper & Meth lab)
    ['meth'] = {
        baseMin = 250,
        baseMax = 300,
        copMultiplier = 10,
        purityMultiplier = 3,
        copCap = 10
    },
    --Weed
    ['malmo_weed_35g'] = {
        baseMin = 80,
        baseMax = 140,
        copMultiplier = 10,
        purityMultiplier = 3,
        copCap = 10,
        Strains = {
            ['skunk_seed'] = 10,
            ['zkittles_seed'] = 12,
            ['trainwreck_seed'] = 15,
            ['garliccookies_seed'] = 17,
            ['malmokush_seed'] = 20,
        }
    },
    ['malmo_weed_7g'] = {
        baseMin = 200,
        baseMax = 240,
        copMultiplier = 10,
        purityMultiplier = 3,
        copCap = 10,
        Strains = {
            ['skunk_seed'] = 10,
            ['zkittles_seed'] = 12,
            ['trainwreck_seed'] = 15,
            ['garliccookies_seed'] = 17,
            ['malmokush_seed'] = 20,
        }
    },
    ['malmo_weed_oz'] = {
        baseMin = 500,
        baseMax = 600,
        copMultiplier = 10,
        purityMultiplier = 3,
        copCap = 10,
        Strains = {
            ['skunk_seed'] = 10,
            ['zkittles_seed'] = 12,
            ['trainwreck_seed'] = 15,
            ['garliccookies_seed'] = 17,
            ['malmokush_seed'] = 20,
        }
    },
}

Shared.MaleGasMasks = {
    [38] = true, [46] = true, [175] = true
}

Shared.FemaleGasMasks = {
    [38] = true, [46] = true
}


--- Methcamper related settings
Shared.MethcamperSpawn = vector4(-446.13, -2282.97, 7.61, 264.5)
Shared.MethcamperPed = vector4(-465.05, -2275.57, 8.52, 143.5)
Shared.MethcamperMinCops = 0
Shared.MethcamperCopChance = 10 -- %
Shared.MethcamperPortableItem = 'portable_methlab'
Shared.MethcamperRewardItem = 'meth'
Shared.MethcamperRewardAmount = 25 -- Amount of meth bags added per cook
Shared.MethcamperRequiredItem = 'pseudoephedrine'

--- Weedfarming related settings
Shared.WeedFarmingBlip = true -- true | false, enable or disable the blip for the weedfarming location
Shared.WeedFarmingCoords = vector3(2223.41, 5577.31, 53.84)
Shared.WeedFarmingDuration = 12 -- Time in seconds between minigames to receive weed buds
Shared.WeedFarmingBudsItem = 'weed_buds'
Shared.WeedFarmingBagsItem = 'weed'
Shared.WeedFarmingBaggingAmount = 4 -- Amount of buds that get processed into one bug
Shared.WeedFarmingReceive = { -- Amount of weed buds received every interval
    min = 4,
    max = 7
}

Shared.MethLabs = {
    -- Boxes
    [1] = {loc = {coords = vector3(2531.47, 2611.2, 23.58), h = 270.0}, fumes = vector3(2518.85, 2608.57, 39.1)}, -- Near 3056
    -- [2] = {loc = {coords = vector3(-442.21, 5592.79, 53.91), h = 182.99}},-- Near Sawmill
    -- [3] = {loc = {coords = vector3(-334.38, 3750.17, 55.57), h = 298.47}}, -- Near Stab City
    -- [4] = {loc = {coords = vector3(2967.86, 3769.13, 40.27), h = 81.49}}, -- Xoras first weed lab loc
    -- [5] = {loc = {coords = vector3(2858.17, 3437.74, 36.49), h = 250.59}}, -- Near Hardware store sandy
    -- [6] = {loc = {coords = vector3(2662.91, 1694.17, 10.25), h = 269.2}},-- Near 3062
    -- [7] = {loc = {coords = vector3(2467.94, 1473.13, 21.83), h = 180.0}}, -- near 3061
    -- [8] = {loc = {coords = vector3(2128.19, 1935.34, 79.41), h = 90.0}}, -- near 3060
    -- [1] = {loc = {coords = vector3(1403.75, 2114.15, 90.57), h = 181.18}}, -- Near 4001 (Used during testing)
}

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