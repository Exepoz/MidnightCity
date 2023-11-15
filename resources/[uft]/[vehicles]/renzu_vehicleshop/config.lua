Config = {}
Config.Locale = "en"
Config.Mysql = 'oxmysql' -- "ghmattisql", "mysql-async", "oxmysql"
Config.framework = 'QBCORE' -- ESX or QBCORE
Config.UsePopUI = true -- Create a Thread for checking playercoords and Use POPUI to Trigger Event, set this to false if using rayzone. Popui is originaly built in to RayZone -- DOWNLOAD https://github.com/renzuzu/renzu_popui
Config.Quickpick = false -- if false system will create a garage shell and spawn every vehicle you preview
Config.EnableTestDrive = true
Config.PlateSpace = true -- enable / disable plate spaces (compatibility with esx 1.1?)
Config.SaveJob = true -- this config is to save the value to owned_vehicles.job column
Config.Licensed = false -- Enable Driver Licensed Checker
Config.DisplayCars = true -- enable display of cars
Config.Marker = true -- use draw marker and Iscontrollpress native , popui will not work if this is true

-- VEHICLE THUMBNAILS IMAGE
-- this is standalone
Config.CustomImg = false -- if true your Config.CustomImgColumn IMAGE url will be used for each vehicles else, the imgs/uploads/MODEL.jpg
Config.CustomImgColumn = 'imglink' -- db column name
-- this is standalone
-- Config.use_renzu_vehthumb -- Config.CustomImg must be false
Config.use_renzu_vehthumb = false -- use vehicle thumb generation script
Config.RgbColor = true -- your framework or garage must support custom colors ex. https://github.com/renzuzu/renzu_garage

-- CARKEYS -- -- you need to replace the event
Config.Carkeys = function(plate,source) TriggerClientEvent('vehiclekeys:client:SetOwner',source,plate) -- THIS EVENT IS QBCORE CAR KEYS!, replace the event name to your carkeys event
end
-- CARKEYS --
--EXTRA
Config.UseArenaSpawn = true -- will use custom location for spawning vehicle in quickpick == false
-- MAIN
VehicleShop = {
    ['pdm'] = { -- same with name
        name = "pdm", --LEGION
        title = "PDM Vehicle Shop",
        icon = 'https://i.imgur.com/05SLYUP.png',
        type = 'car',
        job = 'all',
        default_garage = 'Alta Apartments',
        Dist = 4, -- distance (DEPRECATED)
        Blip = {color = 12, sprite = 595, scale = 0.6},
        shop_x = -33.46,
        shop_y = -1098.12,
        shop_z = 27.00, -- coordinates for this garage
        spawn_x = -23.42,
        spawn_y = -1093.54,
        spawn_z = 27.31,
        heading = 340.17, -- Vehicle spawn location,
        displaycars = {
            [1] = {model = 'dominator8', value = 100000, coord = vector4(-42.4, -1101.4, 27.3, 84.44)},
            [2] = {model = 'fmj', value = 175000, coord = vector4(-47.57, -1092.02, 27.3, 286.25)},
            [3] = {model = 'coquette4', value = 175000, coord = vector4(-36.9, -1093.06, 27.3, 29.86)},
            [4] = {model = 'granger', value = 22000, coord = vector4(-49.81, -1083.61, 27.3, 296.26)},
            [5] = {model = 'buffalo2', value = 40000, coord = vector4(-54.7, -1097.09, 27.3, 242.18)},
        }
    },
    ['rising'] = { -- same with name
        name = "rising", --LEGION
        title = "Rising Sun Vehicle Shop",
        icon = 'https://i.imgur.com/LVtfMEl.png',
        type = 'car',
        job = 'all',
        default_garage = 'Alta Apartments',
        Dist = 4, -- distance (DEPRECATED)
        Blip = {color = 1, sprite = 595, scale = 0.6},
        shop_x = -342.65,
        shop_y = -112.18,
        shop_z = 45.5, -- coordinates for this garage
        spawn_x = -330.09,
        spawn_y = -107.12,
        spawn_z = 45.00,
        heading = 69.00, -- Vehicle spawn location,
        displaycars = {
            [1] = {model = 'jester3', value = 100000, coord = vector4(-336.57, -113.05, 46.05, 120.53)},
            [2] = {model = 'sultan3', value = 100000, coord = vector4(-342.35, -128.58, 46.05, 42.44)},
            [3] = {model = 'elegy', value = 80000, coord = vector4(-331.86, -132.69, 45.50, 342.55)},
            [4] = {model = 'futo', value = 25000, coord = vector4(-325.8, -117.16, 45.50, 150.61)},
        }
    },
    ['luxury'] = { -- same with name
        name = "luxury", --LEGION
        title = "Luxury Vehicle Shop",
        icon = 'https://i.imgur.com/JHqpH09.jpg',
        type = 'car',
        job = 'all',
        default_garage = 'Alta Apartments',
        Dist = 4, -- distance (DEPRECATED)
        Blip = {color = 46, sprite = 595, scale = 0.6},
        shop_x = -921.34,
        shop_y = -2027.51,
        shop_z = 8.75, -- coordinates for this garage
        spawn_x = -980.93,
        spawn_y = -2077.98,
        spawn_z = 9.5,
        heading = 135.00, -- Vehicle spawn location,
        displaycars = {
            [1] = {model = 'ignus', value = 250000, coord = vector4(-910.1, -2032.31, 8.9, 200.00)},
            [2] = {model = 'jugular', value = 80000, coord = vector4(-928.77, -2027.91, 8.9, 315.00)},
            [3] = {model = 'astron', value = 125000, coord = vector4(-918.66, -2018.06, 8.9, 165.00)},
            [4] = {model = 'growler', value = 100000, coord = vector4(-923.66, -2022.74, 8.9, 135.00)},
            [5] = {model = 'italirsx', value = 225000, coord = vector4(-906.51, -2028.73, 8.9, 200.00)},
        }
    },
    ['sandersbikes'] = { -- same with name
        name = "sandersbikes", --LEGION
        title = "Sanders Motorcycles",
        icon = 'https://cdn.discordapp.com/attachments/1052127605916188742/1093749420245401601/Western-Motorcycle-Company-Logo.png',
        type = 'car',
        job = 'all',
        default_garage = 'Alta Apartments',
        Dist = 4, -- distance (DEPRECATED)
        Blip = {color = 11, sprite = 226, scale = 0.6},
        shop_x = 305.61,
        shop_y = -1162.9221826172,
        shop_z = 29.29, -- coordinates for this garage
        spawn_x = 299.05,
        spawn_y = -1182.23,
        spawn_z = 29.39,
        heading = 91.51, -- Vehicle spawn location,
        displaycars = {
            [1] = {model = 'hakuchou ', value = 35000, coord = vector4(315.44, -1166.49, 30.29, 325.94)},
            [2] = {model = 'zombiea ', value = 35000, coord = vector4(313.01, -1166.43, 29.29, 323.72)},
            [3] = {model = 'sanchez2 ', value = 10000, coord = vector4(310.23, -1166.97, 29.29, 329.52)},
            [4] = {model = 'faggio', value = 2000, coord = vector4(307.46, -1166.68, 29.29, 340.17)},
        }
    },
    ['police'] = { -- same with name vector3(461.53, -956.8, 23.94),vector3(449.95, -958.17, 23.94)
        name = "police", --MRPD police shop
        title = "Police Vehicle Shop",
        icon = 'https://i.imgur.com/t1OPuVL.png',
        job = 'police',
        type = 'car',
        default_garage = 'MCPD (Lot)',
        Dist = 2, -- distance (DEPRECATED)
        Blip = {color = 63, sprite = 662, scale = 0.0},
        shop_x = 461.53,
        shop_y = -956.8,
        shop_z = 23.94, -- coordinates for this garage
        spawn_x = 449.95,
        spawn_y = -958.17,
        spawn_z = 23.94,
        heading = 179.53, -- Vehicle spawn location
        plateprefix = 'MCPD', -- carefull using this, maximum should be 4, recommended is 3, use this only for limited vehicles, if you use this parameter in other shop, you might have a limited plates available, ex. LSPD1234 (max char of plate is 8) it means you only have 9999 vehicles possible with this LSPD
    },

    ['motorhomes'] = { -- same with name
        name = "motorhomes", --LEGION
        title = "Larry\'s RVs",
        icon = 'https://static.wikia.nocookie.net/degta/images/a/ad/Larry’s-RV-Sales-Logo.png/revision/latest?cb=20160325225409',
        type = 'car',
        job = 'all',
        default_garage = 'Alta Apartments',
        Dist = 4, -- distance (DEPRECATED)
        Blip = {color = 60, sprite = 513, scale = 0.6},
        shop_x = 1224.92,
        shop_y = 2725.11,
        shop_z = 38.0, -- coordinates for this garage
        spawn_x = 1235.37,
        spawn_y = 2727.61,
        spawn_z = 38.01,
        heading = 180.96, -- Vehicle spawn location,
        displaycars = {
            [1] = {model = 'sandroamer', value = 500000, coord = vector4(1230.89, 2697.44, 37.01, 89.31)},
            [2] = {model = 'cararv', value = 550000, coord = vector4(1216.96, 2697.44, 37.01, 89.31)},
            --[3] = {model = 'guardianrv', value = 750000, coord = vector4(1222.17, 2706.91, 37.01, 89.31)},
            --[4] = {model = 'sandkingrv', value = 1000000, coord = vector4(1222.17, 2716.48, 37.01, 89.31)},
        }
    },

     -- BOAT shop
     ['boats'] = { -- same with name
     name = "boats", --LEGION
     type = 'boat', -- type of shop
     title = "Yacht Club Boat Shop",
     icon = 'https://i.imgur.com/62bRdH6.png',
     job = 'all',
     default_garage = 'Boats',
     Dist = 7, -- distance (DEPRECATED)
     Blip = {color = 38, sprite = 410, scale = 0.6},
     shop_x = -785.93,
     shop_y = -1356.1,
     shop_z = 5.0005192756653, -- coordinates for this garage
     spawn_x = -818.69775390625,
     spawn_y = -1420.5775146484,
     spawn_z = 0.12045155465603,
     heading = 178.27006530762, -- Vehicle spawn location
     shop = { -- if not vehicle is setup in Database SQL, we will use this
          {shop='boats',brand='Normal Boat',stock=999,price=60000,model='squalo',name="Squalo"},
          {shop='boats',brand='Normal Boat',stock=999,price=100000,model='marquis',name="Marquis"},
          {shop='boats',brand='Normal Boat',stock=999,price=25000,model='seashark',name="Seashark"},
          {shop='boats',brand='Normal Boat',stock=999,price=40000,model='seashark3',name="Seashark Deluxe"},
          {shop='boats',brand='Normal Boat',stock=999,price=80000,model='jetmax',name="Jetmax"},
          {shop='boats',brand='Normal Boat',stock=999,price=75000,model='tropic2',name="Tropic"},
          {shop='boats',brand='Normal Boat',stock=999,price=45000,model='dinghy4',name="Dinghy"},
          {shop='boats',brand='Normal Boat',stock=999,price=55000,model='suntrap',name="Suntrap"},
          {shop='boats',brand='Normal Boat',stock=999,price=80000,model='speeder',name="Speeder"},
          {shop='boats',brand='Normal Boat',stock=999,price=95000,model='speeder2',name="Speeder Deluxe"},
          {shop='boats',brand='Normal Boat',stock=999,price=130000,model='longfin',name="Longfin"},
          {shop='boats',brand='Normal Boat',stock=999,price=95000,model='toro',name="Toro"},
          {shop='boats',brand='Normal Boat',stock=999,price=110000,model='toro2',name="Toro Deluxe"},
        },
    }
}

Config.EnableVehicleSelling = true -- allow your user to sell the vehicle and deletes it from database
Config.RefundPercent = 25 -- 70% (percentage from original value)
Refund = {
    ['pdm'] = { -- same with name
        name = "pdm", --LEGION
        job = 'all',
        Dist = 7, -- distance
        Blip = {color = 38, sprite = 219, scale = 0.6},
        shop_x = 0,
        shop_y = 0,
        shop_z = 0, -- coordinates for selling / refunding the vehicle
    },
}

lib = nil

function TryOxLib(file)
    local fcall = function()
        local name = ('%s.lua'):format(file)
        local content = LoadResourceFile('ox_lib',name)
        local f, err = load(content)
        return f()
    end
    _, ret = pcall(fcall,false)
    return ret
end