Config = {}
Config.Debug = false
Config.DebugPoly = false

Config.SafeJobs = {
    ['police'] = true,
    ['ambulance'] = true,
}

Config.GreenZones = {
    [1] = { name = 'crimHub',
        center = vector3(-590.68, -1620.83, 37.85),
        thickness = 40,
        points = {
            vector3(-628.41, -1674.72, 37.0),
            vector3(-637.80, -1669.44, 37.0),
            vector3(-644.12, -1658.31, 37.0),
            vector3(-637.23, -1646.00, 37.0),
            vector3(-654.62, -1635.74, 37.0),
            vector3(-624.16, -1587.87, 37.0),
            vector3(-611.50, -1581.81, 37.0),
            vector3(-597.52, -1580.22, 37.0),
            vector3(-581.79, -1581.55, 37.0),
            vector3(-553.61, -1596.57, 37.0),
            vector3(-556.63, -1629.21, 37.0),
            vector3(-557.96, -1638.95, 37.0),
            vector3(-568.62, -1657.34, 37.0),
            vector3(-605.84, -1635.78, 37.0),
        },
        lights = {
            -- Back
            {coords = vector3(-562.37, -1648.25, 24.13), dir = vector3(5.0, -2.7, -10.0), d = 15.0, b = 1.0, h = 0.9, r = 25.0, f = 0.95},
            {coords = vector3(-565.52, -1652.66, 24.36), dir = vector3(5.8, -3.3, -10.0), d = 15.0, b = 1.0, h = 0.9, r = 25.0, f = 0.95},
            {coords = vector3(-565.54, -1652.28, 24.49), dir = vector3(2.5, 2.2, -10.0), d = 15.0, b = 1.0, h = 0.9, r = 25.0, f = 0.95},
            -- Front Entrance
            {coords = vector3(-651.82, -1639.15, 33.21), dir = vector3(-1.9, -1.8, -10.0), d = 25.0, b = 1.0, h = 0.9, r = 30.0, f = 0.95},
            {coords = vector3(-648.03, -1641.57, 33.3), dir = vector3(-1.9, -1.8, -10.0), d = 25.0, b = 1.0, h = 0.9, r = 30.0, f = 0.95},
        }
    },
    [2] = { name = 'burgershot',
        center = vector3(-1183.83, -886.43, 13.89),
        thickness = 40,
        points = {
            vector3(-1171.20, -867.10, 15.14),
            vector3(-1187.49, -877.73, 13.83),
            vector3(-1214.81, -895.62, 18.40),
            vector3(-1199.23, -916.33, 14.09),
            vector3(-1185.38, -907.33, 15.40),
            vector3(-1183.91, -909.47, 15.42),
            vector3(-1154.62, -892.11, 15.41),
            vector3(-1158.19, -885.91, 15.42),
        },
        lights = {
            {coords = vector3(-1186.82, -877.12, 21.11), dir = vector3(4.0, 3.0, -10.0), d = 15.0, b = 1.0, h = 0.9, r = 30.0, f = 0.95},
            {coords = vector3(-1208.56, -891.68, 21.11), dir = vector3(-3.0, -1.0, -10.0), d = 15.0, b = 1.0, h = 0.9, r = 20.0, f = 0.95},
        }
    },
    [3] = { name = 'thedistrict',
        center = vector3(988.66, -2327.82, 30.59),
        thickness = 40,
        points = {
            vector3(1028.43, -2353.66, 30.51),
            vector3(1011.61, -2361.91, 41.98),
            vector3(1007.05, -2365.27, 41.59),
            vector3(956.66, -2360.38, 41.59),
            vector3(956.82, -2352.05, 41.59),
            vector3(953.11, -2352.11, 41.59),
            vector3(947.03, -2351.22, 36.72),
            vector3(949.74, -2312.03, 41.59),
            vector3(948.53, -2310.56, 40.55),
            vector3(950.22, -2293.78, 40.55),
            vector3(959.93, -2294.63, 41.98),
            vector3(962.30, -2296.99, 41.98),
            vector3(977.23, -2297.03, 41.98),
            vector3(977.58, -2297.37, 34.68),
            vector3(980.80, -2297.67, 41.98),
            vector3(1001.25, -2299.26, 41.98),
            vector3(1003.94, -2278.87, 34.60),
            vector3(1017.22, -2279.78, 32.18),
            vector3(1019.29, -2281.14, 31.78),
            vector3(1019.32, -2286.06, 31.67),
            vector3(1019.95, -2288.44, 31.66),
            vector3(1021.92, -2289.82, 31.71),
            vector3(1034.52, -2289.88, 29.51),
            vector3(1032.88, -2309.49, 31.43),
            vector3(1031.92, -2316.21, 31.42),
        },
        lights = {
            {coords = vector3(1022.22, -2321.78, 38.52), dir = vector3(10.0, 9.0, -10.0), d = 25.0, b = 1.0, h = 0.9, r = 15.0, f = 0.95},
            {coords = vector3(992.94, -2297.48, 39.0), dir = vector3(9.0, 5.0, -10.0), d = 20.0, b = 1.0, h = 0.9, r = 25.0, f = 0.95},
            {coords = vector3(951.1, -2293.95, 33.88), dir = vector3(6.0, -1.0, -10.0), d = 20.0, b = 1.0, h = 0.9, r = 35.0, f = 0.95},
        }
    },
    [4] = { name = 'fence',
    center = vector3(-283.89, -2223.61, 8.96),
    thickness = 40,
    points = {
        vector3(-292.41, -2205.03, 15.97),
        vector3(-303.69, -2200.37, 15.92),
        vector3(-316.11, -2198.88, 15.84),
        vector3(-327.09, -2213.44, 15.80),
        vector3(-316.03, -2222.23, 15.20),
        vector3(-318.80, -2226.83, 15.19),
        vector3(-302.67, -2238.21, 15.19),
        vector3(-301.34, -2236.22, 15.19),
        vector3(-291.31, -2242.53, 15.19),
        vector3(-289.66, -2240.89, 15.27),
        vector3(-286.29, -2241.57, 15.04),
        vector3(-279.73, -2246.79, 15.95),
        vector3(-275.76, -2231.52, 15.60),
        vector3(-274.30, -2213.61, 15.08),
        vector3(-246.09, -2213.00, 15.31),
        vector3(-246.24, -2206.30, 15.31),
        vector3(-282.18, -2206.04, 15.13),
    },
    lights = {
        {coords = vector3(-285.49, -2205.59, 14.17), dir = vector3(-4.0, 5.0, -10.0), d = 10.0, b = 1.0, h = 0.9, r = 30.0, f = 0.95},
        {coords = vector3(-317.98, -2209.95, 15.55), dir = vector3(-4.0, 5.0, -10.0), d = 30.0, b = 1.0, h = 0.9, r = 15.0, f = 0.95},
        {coords = vector3(-282.18, -2240.53, 15.38), dir = vector3(4.0, -4.0, -9.0), d = 20.0, b = 1.0, h = 0.9, r = 15.0, f = 0.95},
        {coords = vector3(-276.12, -2219.98, 15.11), dir = vector3(4.0, 4.0, -9.0), d = 20.0, b = 1.0, h = 0.9, r = 25.0, f = 0.95},
        {coords = vector3(-300.92, -2233.43, 5.83), dir = vector3(-3.0, -1.5, -9.0), d = 20.0, b = 1.0, h = 0.9, r = 25.0, f = 0.95},
    }
    },
    [5] = { name = 'uwu',
        center = vector3(-580.96, -1073.29, 22.33),
        thickness = 40,
        points = {
            vector3(-565.6, -1169.7, 17.88),
            vector3(-556.89, -1124.03, 21.33),
            vector3(-554.81, -1104.17, 21.17),
            vector3(-556.21, -1073.05, 22.51),
            vector3(-556.65, -975.65, 23.13),
            vector3(-560.01, -972.29, 23.13),
            vector3(-618.92, -971.27, 21.57),
            vector3(-619.55, -987.43, 21.55),
            vector3(-620.07, -992.79, 20.17),
            vector3(-622.42, -1005.48, 20.04),
            vector3(-625.84, -1018.37, 21.69),
            vector3(-637.23, -1045.85, 20.99),
            vector3(-635.61, -1048.74, 21.82),
            vector3(-624.56, -1055.38, 21.69),
            vector3(-624.44, -1168.13, 21.69),
            vector3(-572.52, -1168.18, 21.69),
            vector3(-567.68, -1169.97, 18.5),

        },
        lights = {
            {coords = vector3(-555.7, -1104.86, 28.15), dir = vector3(-3.589993, -10.0, -9.0), d = 25.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
            {coords = vector3(-558.68, -991.01, 30.24), dir = vector3(-2.589993, -8.0, -11.0), d = 30.0, b =2.0, h = 0.9, r = 25.0, f = 1.95},
            {coords = vector3(-626.7, -989.67, 29.02), dir = vector3(1.679993, -7.0, -8.0), d = 25.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
        }
    },
    [6] = { name = 'pillbox',
        center = vector3(332.94, -583.77, 43.27),
        thickness = 60,
        points = {
            vector3(280.56, -597.05, 55.00),
            vector3(294.04, -599.05, 55.00),
            vector3(311.43, -605.63, 55.00),
            vector3(313.27, -600.44, 55.00),
            vector3(330.03, -606.4, 55.00),
            vector3(334.03, -596.43, 55.00),
            vector3(342.06, -599.3, 55.00),
            vector3(345.13, -605.77, 55.00),
            vector3(355.38, -608.81, 55.00),
            vector3(369.97, -599.72, 55.00),
            vector3(373.95, -588.75, 55.00),
            vector3(371.72, -574.14, 55.00),
            vector3(375.39, -561.31, 55.00),
            vector3(347.52, -559.59, 55.00),
            vector3(344.42, -566.44, 55.00),
            vector3(322.95, -558.21, 55.00),
            vector3(316.48, -561.16, 55.00),
            vector3(308.18, -557.78, 55.00),
            vector3(302.21, -555.64, 55.00),
            vector3(294.75, -558.17, 55.00),
            vector3(280.63, -596.8, 55.00),
        },
        lights = {
            {coords = vector3(355.46, -610.12, 33.33), dir = vector3(2.274780, -3.788940, -4.438404), d = 10.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
            {coords = vector3(365.57, -602.43, 32.93), dir = vector3(3.386932, -4.995605, -4.188934), d = 10.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
            {coords = vector3(372.4, -586.76, 33.96), dir = vector3(5.850769, 0.989990, -4.336390), d = 10.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
            {coords = vector3(361.09, -605.32, 32.97), dir = vector3(3.737030, -5.759583, -4.1186249), d = 10.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
            {coords = vector3(372.99, -581.32, 32.87), dir = vector3(5.209412, 1.145447, -4.171268), d = 10.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
            {coords = vector3(372.3, -577.25, 33.0), dir = vector3(5.275665, 1.307800, -4.155745), d = 10.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
            {coords = vector3(290.5, -601.31, 46.39), dir = vector3(-1.690369, -4.053772, -3.068203), d = 10.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
            {coords = vector3(287.03, -599.97, 46.39), dir = vector3(-1.031097, -3.863831, -3.202503), d = 10.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
            {coords = vector3(282.81, -598.5, 46.39), dir = vector3(1.016205, -4.362305, -3.271069), d = 10.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
            {coords = vector3(287.94, -576.32, 46.59), dir = vector3(-4.950134, 2.144775, -3.457996), d = 10.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
            {coords = vector3(289.45, -572.15, 46.61), dir = vector3(-4.159698, 1.027161, -3.451870), d = 10.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
            {coords = vector3(291.25, -567.21, 46.53), dir = vector3(-4.125732, 0.524109, -3.415451), d = 10.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
            {coords = vector3(346.02, -564.14, 31.66), dir = vector3(-4.233612, 1.940186, -2.916557), d = 10.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
            {coords = vector3(347.42, -560.27, 31.91), dir = vector3(-4.042664, 1.423218, -3.166557), d = 10.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
        }
    },
    [7] = { name = 'LosSantos',
        center = vector3(-360.82, -116.98, 38.70),
        thickness = 40,
        points = {
            vector3(-350.79, -178.81, 45.00),
            vector3(-337.15, -174.36, 45.00),
            vector3(-309.36, -166.15, 45.00),
            vector3(-306.07, -160.94, 45.00),
            vector3(-301.74, -133.47, 45.00),
            vector3(-303.45, -130.83, 45.00),
            vector3(-303.48, -129.97, 45.00),
            vector3(-306.1, -121.78, 45.00),
            vector3(-302.15, -110.96, 45.00),
            vector3(-299.49, -111.69, 45.00),
            vector3(-295.63, -100.01, 45.00),
            vector3(-293.79, -96.53, 45.00),
            vector3(-394.82, -61.47, 45.00),
            vector3(-399.38, -67.78, 45.00),
            vector3(-408.48, -75.04, 45.00),
            vector3(-416.66, -83.29, 45.00),
            vector3(-360.49, -183.16, 45.00),
            vector3(-350.83, -178.79, 45.00),


        },
        lights = {
            {coords = vector3(-351.21, -178.71, 44.39), dir = vector3(-8.164795, -5.353760, -6.881954), d = 25.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
            {coords = vector3(-360.78, -182.34, 39.9), dir = vector3(5.240906, 2.131729, -2.095371), d = 30.0, b =2.0, h = 0.9, r = 25.0, f = 1.95},
            {coords = vector3(-411.23, -78.14, 49.4), dir = vector3(-10.360016, -4.184280, -7.766975), d = 25.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
            {coords = vector3(-399.11, -67.27, 48.99), dir = vector3(-3.715759, 4.653893, -4.565784), d = 25.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
            {coords = vector3(-394.79, -61.49, 48.86), dir = vector3(-5.592133, 0.384701, -4.308826), d = 25.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
            {coords = vector3(-295.52, -100.05, 50.09), dir = vector3(3.121155, 1.548538, -3.024342), d = 25.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
        }
    },
    [8] = { name = 'bowling',
        center = vector3(739.97, -774.49, 26.45),
        thickness = 10,
        points = {
            vector3(759.08, -782.92, 26.2),
            vector3(727.59, -783.52, 26.2),
            vector3(727.53, -765.87, 26.2),
            vector3(758.8, -766.11, 26.2)
        },
        lights = {
            {coords = vector3(758.8, -777.87, 28.3), dir = vector3(1.5, -0.0, -3.0), d = 5.0, b = 2.0, h = 1.9, r = 30.0, f = 1.95},
        }
    },
    -- [8] = { name = 'TunerShop',
    --    center = vector3 (139.47, -3030.19, 7.04),
    --    thickness = 40,
    --    points = {
    --        vector3(158.48, -3049.55, 6.03),
    --        vector3(158.25, -3005.64, 6.03),
    --        vector3(118.19, -3005.08, 9.54),
    --         vector3(119.04, -3049.2, 5.27),
    --        vector3(158.08, -3049.36, 6.03),
    -- },
    -- lights = {
    --       {coords = vector3(155.47, -3038.75, 10.68), dir = vector3(4.752563, 1.575195, -3.836580), d = 15.0, b = 1.0, h = 0.9, r = 30.0, f = 0.95},
    --       {coords = vector3(155.09, -3019.62, 10.64), dir = vector3(4.593170, -1.497559, -3.518834), d = 15.0, b = 1.0, h = 0.9, r = 30.0, f = 0.95},

    --     }
    -- },
}