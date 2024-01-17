Config = {}

Config.FuelExport = 'cdn-fuel'

Config.Locations = {
    vehicle = {
        coords = vector4(1014.45, -2319.86, 31.26, 355.38),
        pedhash = `a_m_y_business_03`,
        spawnpoint = vector4(1019.75, -2307.30, 30.51, 268.36),
    },

    aircraft = {
        coords = vector4(-293.31, -987.30, 31.18, 73.30),
        pedhash = `s_m_y_airworker`,
        spawnpoint = vector4(-287.10, -984.30, 31.08, 252.78),
    },

    --boat = {
    --    coords = vector4(-753.5, -1512.27, 4.02, 25.61),
    --    pedhash = `mp_m_boatstaff_01`,
    --    spawnpoint = vector4(-794.95, -1506.27, 1.08, 107.79),
    --},
}

Config.Blips = {
    {title= Lang:t("info.land_veh"), colour= 50, id= 56, x= 1014.45, y= -2319.86, z= 31.26},
    {title= Lang:t("info.land_veh"), colour= 32, id= 56, x= -293.31, y= -987.30, z= 73.30},
    --{title= Lang:t("info.sea_veh"), colour= 42, id= 410, x= -753.55, y= -1512.24, z= 5.02}, 
}

Config.Vehicles = {
    land = {
        [1] = {
            model = 'futo',
            money = 800,
        },
        [2] = {
            model = 'bmx',
            money = 300,
        },
        [3] = {
            model = 'faggio',
            money = 550,
        },
    },
    air = {
       [1] = {
           model = 'futo',
           money = 800,
       },
       [2] = {
           model = 'bmx',
           money = 300,
       },
       [3] = {
           model = 'faggio',
           money = 550,
       },
    },
    sea = {
        --[1] = {
        --    model = 'futo',
        --    money = 800,
        --},
        --[2] = {
        --    model = 'bmx',
        --    money = 300,
        --},
        --[3] = {
        --    model = 'faggio',
        --    money = 550,
        --},
    }
}