-- Config = Config or {}
-- Config.Merryweather = {}
Config.Merryweather.CopsRequired = 4
Config.Merryweather.ExoTimeOutTime = 15
Config.Merryweather.ThermiteHack = {CorrectBlocks = 12, IncorrectBlocks = 3, TimeToShow = 5, TimeToLose = 9}
Config.Merryweather.TimeToSpawn = {min = 1, max = 2}
Config.Merryweather.Guards = {
    Model = 's_m_y_blackops_01',
    Health = 500,
    Armor = 300,
    Accuracy = 90,
    Weapon = {
        'WEAPON_CARBINERIFLE',
        'WEAPON_ASSAULTSHOTGUN',
        'WEAPON_COMBATMG',
    }
}

Config.Merryweather.ExoSays = {Length = {2, 4, 6}}

Config.Merryweather.PhoneLocations = {
    ['MRPD'] = {
        PhoneCoords = vector3(372.29, -966.33, 29.43), -- The Payphone Coords
        MinZ = 29, -- MinZ for Box Zone
        Heading = 0, -- Heading of Box Zone
        SpawnCoords = vector3(438.21, -856.74, 30.13), -- Where the truck will Spawn
        Destination = vector3(340.29,-956.45,29.38), -- Where the truck will drive to
    },

    ['LegionFleeca'] = {
        PhoneCoords = vector3(140.18, -1033.16, 29.35), -- The Payphone Coords
        MinZ = 29,  -- MinZ for Box Zone
        Heading = 0, -- Heading of Box Zone
        SpawnCoords = vector3(119.56, -1131.78, 29.28), -- Where the truck will Spawn
        Destination = vector3(162.85, -1025.26, 29.38), -- Where the truck will drive to
    },

    ['AltaStreet'] = {
        PhoneCoords = vector3(-92.41, -694.11, 34.84), -- The Payphone Coords
        MinZ = 34, -- MinZ for Box Zone
        Heading = 0, -- Heading of Box Zone
        SpawnCoords = vector3(-228.87,-704.98,33.54), -- Where the truck will Spawn
        Destination = vector3(-79.58, -620.58, 36.32), -- Where the truck will drive to
    },

    ['HawickStreet'] = {
        PhoneCoords = vector3(121.24, -205.21, 54.58), -- The Payphone Coords
        MinZ = 54, -- MinZ for Box Zone
        Heading = 0, -- Heading of Box Zone
        SpawnCoords = vector4(280.46, -42.66, 71.25, 249.82), -- Where the truck will Spawn
        Destination = vector3(133.21, -192.07, 54.58), -- Where the truck will drive to
    },

    ['DelPerroPier'] = {
        PhoneCoords = vector3(-1569.22, -922.41, 13.02), -- The Payphone Coords
        MinZ = 13, -- MinZ for Box Zone
        Heading = 320, -- Heading of Box Zone
        SpawnCoords = vector3(-1468.01, -736.55, 24.71), -- Where the truck will Spawn
        Destination = vector3(-1613.49, -955.48, 13.02), -- Where the truck will drive to
    },

    ['DelPerroAmmunation'] = {
        PhoneCoords = vector3(-1318.16, -380.81, 36.6), -- The Payphone Coords
        MinZ = 36, -- MinZ for Box Zone
        Heading = 305, -- Heading of Box Zone
        SpawnCoords = vector3(-1391.43, -280.62, 43.32), -- Where the truck will Spawn
        Destination = vector3(-1321.27, -369.17, 36.65), -- Where the truck will drive to
    },

    ['WeazelDorset'] = {
        PhoneCoords = vector3(-468.2, -396.31, 33.93), -- The Payphone Coords
        MinZ = 33, -- MinZ for Box Zone
        Heading = 355, -- Heading of Box Zone
        SpawnCoords = vector3(-622.51,-452.43,34.77), -- Where the truck will Spawn
        Destination = vector3(-471.59, -387.3, 34.01), -- Where the truck will drive to
    },

    ['LegionGarage'] = {
        PhoneCoords = vector3(226.99, -728.66, 34.59), -- The Payphone Coords
        MinZ = 34, -- MinZ for Box Zone
        Heading = 345, -- Heading of Box Zone
        SpawnCoords = vector3(221.01, -717.49, 34.97), -- Where the truck will Spawn
        Destination = vector3(324.52, -732.87, 29.3), -- Where the truck will drive to
    },

    ['Vinewood'] = {
        PhoneCoords = vector3(138.48, 195.49, 106.71), -- The Payphone Coords
        MinZ = 106, -- MinZ for Box Zone
        Heading = 340, -- Heading of Box Zone
        SpawnCoords = vector3(90.19, 336.78, 112.5), -- Where the truck will Spawn
        Destination = vector3(182.01, 193.45, 105.56), -- Where the truck will drive to
    },

    ['LSI'] = {
        PhoneCoords = vector3(823.19, -1040.83, 26.53), -- The Payphone Coords
        MinZ = 26, -- MinZ for Box Zone
        Heading = 0, -- Heading of Box Zone
        SpawnCoords = vector3(877.88, -1080.63, 29.45), -- Where the truck will Spawn
        Destination = vector3(831.08, -1007.16, 26.67), -- Where the truck will drive to
    },

    ['MirrorPark'] = {
        PhoneCoords = vector3(1222.51, -397.24, 68.31), -- The Payphone Coords
        MinZ = 68, -- MinZ for Box Zone
        Heading = 345, -- Heading of Box Zone
        SpawnCoords = vector3(1299.15, -549.56, 70.74), -- Where the truck will Spawn
        Destination = vector3(1191.68, -434.78, 67.15), -- Where the truck will drive to
    },

    ['CrusadeRd'] = {
        PhoneCoords = vector3(296.67, -1359.76, 31.94), -- The Payphone Coords
        MinZ = 31, -- MinZ for Box Zone
        Heading = 320, -- Heading of Box Zone
        SpawnCoords = vector3(439.86, -1402.78, 29.34), -- Where the truck will Spawn
        Destination = vector3(301.7, -1369.61, 31.98), -- Where the truck will drive to
    },

    ['InnocenceBlvd'] = {
        PhoneCoords = vector3(779.83, -1755.38, 29.52), -- The Payphone Coords
        MinZ = 29, -- MinZ for Box Zone
        Heading = 0, -- Heading of Box Zone
        SpawnCoords = vector3(503.54, -1737.37, 28.99), -- Where the truck will Spawn
        Destination = vector3(787.31, -1751.28, 29.4), -- Where the truck will drive to
    },

    ['RoyLowen'] = {
        PhoneCoords = vector3(175.51, -2017.38, 18.23), -- The Payphone Coords
        MinZ = 18, -- MinZ for Box Zone
        Heading = 0, -- Heading of Box Zone
        SpawnCoords = vector3(423.35, -2116.18, 19.68), -- Where the truck will Spawn
        Destination = vector3(172.29, -2005.38, 18.33), -- Where the truck will drive to
    },

    ['MazeBank'] = {
        PhoneCoords = vector3(-233.8, -1991.42, 29.95), -- The Payphone Coords
        MinZ = 29, -- MinZ for Box Zone
        Heading = 355, -- Heading of Box Zone
        SpawnCoords = vector3(-311.47, -1842.25, 24.79), -- Where the truck will Spawn
        Destination = vector3(-192.51, -1992.17, 27.62), -- Where the truck will drive to
    },

    ['BusStation'] = {
        PhoneCoords = vector3(439.78, -606.65, 28.72), -- The Payphone Coords
        MinZ = 28, -- MinZ for Box Zone
        Heading = 355, -- Heading of Box Zone
        SpawnCoords = vector3(505.91, -785.32, 24.82), -- Where the truck will Spawn
        Destination = vector3(420.38, -610.62, 28.5), -- Where the truck will drive to
    },

    ['SeaFoodRest'] = {
        PhoneCoords = vector3(-1001.88, -1416.47, 5.19), -- The Payphone Coords
        MinZ = 5, -- MinZ for Box Zone
        Heading = 20, -- Heading of Box Zone
        SpawnCoords = vector3(-1004.39, -1550.23, 5.01), -- Where the truck will Spawn
        Destination = vector3(-1018.96, -1433.99, 5.05), -- Where the truck will drive to
    },
}

Config.Merryweather.Names = {
    "Emma",
    "Liam",
    "Olivia",
    "Noah",
    "Ava",
    "Ethan",
    "Sophia",
    "Logan",
    "Mia",
    "Lucas",
    "Isabella",
    "Jackson",
    "Charlotte",
    "Aiden",
    "Amelia",
    "Caden",
    "Harper",
    "Grayson",
    "Evelyn",
    "Mason",
    "Abigail",
    "Caleb",
    "Emily",
    "Elijah",
    "Elizabeth",
    "Oliver",
    "Avery",
    "Evelyn",
    "Ella",
    "Ezra",
    "Madison",
    "Levi",
    "Scarlett",
    "Nathan",
    "Victoria",
    "Isaac",
    "Aria",
    "Samuel",
    "Grace",
    "Luke",
    "Chloe",
    "Owen",
    "Sofia",
    "Daniel",
    "Aaliyah",
    "Matthew",
    "Lily",
    "Joseph",
    "Ellie",
    "Henry",
    "Nora",
    "Michael",
    "Hazel"
}