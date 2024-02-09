Config = {}

Config.FuelExport = 'cdn-fuel'

Config.Locations = {
    {
        coords = vector4(1015.89, -2319.89, 29.51, 279.91),
        pedhash = `a_m_y_business_03`,
        spawnpoint = vector4(1022.42, -2326.17, 30.51, 354.09),
        blip = {title= Lang:t("info.land_veh"), colour= 50, id= 56, x= 1014.45, y= -2319.86, z= 31.26},
        shop = 'land',
        licenseNeeded = false,
    },

    {
        coords = vector4(-220.64, -1167.85, 22.01, 80.02),
        pedhash = `a_m_y_business_03`,
        spawnpoint = vector4(-235.43, -1163.74, 22.97, 268.14),
        blip = {title= Lang:t("info.land_veh"), colour= 50, id= 56, x= 1014.45, y= -2319.86, z= 31.26},
        shop = 'land',
        licenseNeeded = false,
    },

    {
        coords = vector4(1852.88, 2582.35, 44.67, 277.06),
        pedhash = `a_m_y_business_03`,
        spawnpoint = vector4(1855.21, 2592.49, 45.67, 358.74),
        blip = {title= Lang:t("info.land_veh"), colour= 50, id= 56, x= 1014.45, y= -2319.86, z= 31.26},
        shop = 'land',
        licenseNeeded = false,
    },

    {
        coords = vector4(-589.42, -1605.46, 27.01, 24.27),
        pedhash = `a_m_y_business_03`,
        spawnpoint = vector4(-594.07, -1606.20, 27.01, 354.02),
        blip = nil,
        crumbs = true,
        shop = 'hub',
        licenseNeeded = false,
    },

}

Config.VehicleTypes = {
    land = 'Vehicle',
    sea = 'Boat',
    air = 'Aircraft',
    hub = 'Vehicle',
}

Config.Blips = {
    {title= Lang:t("info.land_veh"), colour= 50, id= 56, x= 1014.45, y= -2319.86, z= 31.26},
    {title= Lang:t("info.land_veh"), colour= 50, id= 56, x= -220.64, y= -1167.85, z= 23.01},
    {title= Lang:t("info.land_veh"), colour= 50, id= 56, x= 1852.88, y= 2582.35, z= 44.67},
}

Config.Vehicles = {
    land = {
        [1] = {
            model = 'bmx',
            money = 250,
        },
        [2] = {
            model = 'faggio',
            money = 750,
        },
        [3] = {
            model = 'futo',
            money = 1000,
        },
    },
    air = {
        [1] = {
            model = 'bmx',
            money = 250,
        },
        [2] = {
            model = 'faggio',
            money = 750,
        },
        [3] = {
            model = 'futo',
            money = 1000,
        },
    },
    sea = {
        [1] = {
            model = 'bmx',
            money = 250,
        },
        [2] = {
            model = 'faggio',
            money = 750,
        },
        [3] = {
            model = 'futo',
            money = 1000,
        },
    },
    hub = {
        [1] = {
            model = 'bmx',
            money = 50,
        },
        [2] = {
            model = 'faggio',
            money = 250,
        },
        [3] = {
            model = 'futo',
            money = 400,
        },
        [4] = {
            model = 'sultan',
            money = 1000,
        },
    }

}