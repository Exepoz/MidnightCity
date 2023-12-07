Config.Locations["SweToon"] = {
    zoneEnabled = false,
    chairsEnabled = false,
    tablesEnabled = false,
    MLO = "SW",
    job = "cluckinbell",
    zones = {
         vector2(163.27714538574, -1473.0974121094),
        vector2(146.00456237793, -1491.8996582031),
        vector2(117.10803985596, -1469.3209228516),
        vector2(134.8695526123, -1448.2275390625)
    },
    autoClock = { enter = false, exit = false, }, -- Turning these on will detect if the person has the job and auto clock them on or off
    Blip = {
        label = "Cluckin Bell - Davis",
        coords = vector3(137.74, -1466.71, 29.36),
        sprite = 89,
        color = 5,
    },
    garage = {
        spawn = vector4(145.04, -1458.43, 29.09, 47.86),
        out = vector4(141.2, -1462.71, 29.36, 319),
        list = {  "burrito3", }
    },
    POS = {
        img = "https://i.imgur.com/QUY50UF.png",
    },
    Booth = {
        enableBooth = false,
        DefaultVolume = 0.1, -- 0.01 is lowest, 1.0 is max
        radius = 30, -- The radius of the sound from the booth
        coords = vec3(120.0, -1281.72, 29.48), -- Where the booth is located
    },
    Toy = {
        label = "Toys",
        slots = 1,
        items = {
            { name = 'clucktoy', price = 0, amount = 10, info = {}, type = 'item', slot = 1, },
        },
    },
    RewardItem = "clucktoy2", --Set this to the name of your empty toy item eg "cattoy"
    RewardPool = { -- Set this to the list of items to be given out as random prizes when the item is used - can be more or less items in the list
        {"cluckinbell-bell", rarity = 90},
        {"cluckinbell-figure", rarity = 10},
        {"cluckinbell-plushie1", rarity = 10},
        {"cluckinbell-plushie2", rarity = 10},
        {"cluckinbell-plushie3", rarity = 10},
        {"cluckinbell-plushie4", rarity = 10},
    },
    Items = {
        label = "Storage",
        slots = 12,
        items = {
            { name = 'tomato', price = 0, amount = 200, info = {}, type = 'item', slot = 1, },
            { name = 'potato', price = 0, amount = 200, info = {}, type = 'item', slot = 2, },
            { name = 'onion', price = 0, amount = 200, info = {}, type = 'item', slot = 3, },
            { name = 'lettuce', price = 0, amount = 200, info = {}, type = 'item', slot = 4, },
            { name = 'cheese', price = 0, amount = 200, info = {}, type = 'item', slot = 5, },
            { name = 'rawchickenbreast', price = 0, amount = 200, info = {}, type = 'item', slot = 6, },
            { name = 'frozennugget', price = 0, amount = 200, info = {}, type = 'item', slot = 7, },
            { name = 'rawchickenwing', price = 0, amount = 200, info = {}, type = 'item', slot = 8, },
            { name = 'burgerbun', price = 0, amount = 200, info = {}, type = 'item', slot = 9, },
            { name = 'strawberry', price = 0, amount = 200, info = {}, type = 'item', slot = 10, },
            { name = 'chocolate', price = 0, amount = 200, info = {}, type = 'item', slot = 11, },
            { name = 'icecream', price = 0, amount = 200, info = {}, type = 'item', slot = 12, },
        },
    },
    Targets = {
        Storage = {
            { coords = vec3(146.78, -1470.48, 29.36), l = 1.5, w = 1.5, heading = 233, type = "employee", boxgrab = true},
            { coords = vec3(145.7, -1471.61, 29.36),  l = 1.5, w = 1.5, heading = 233, type = "employee", boxgrab = true},
            { coords = vec3(147.78, -1469.32, 29.36), l = 1.5, w = 1.5,heading = 233, type = "employee", boxgrab = true},
            { coords = vec3(145.63, -1468.33, 29.36),  w = 0.6, l = 0.6, heading = 60, type = "tray"},
            { coords = vec3(142.99, -1471.51, 29.36),  w = 0.6, l = 0.6, heading = 60, type = "tray"},
        },
        Fridge = {
            { coords = vec3(148.63, -1469.86, 29.36), l = 0.9, w = 0.9, heading = 322, prop = true, propcoords = vec4(148.87, -1469.69, 29.36, 320) },
        },
        POS = {
            { coords = vec3(145.2, -1468.86, 29.36), l = 0.6, w = 0.6, heading = 152},
            { coords = vec3(143.35, -1471.03, 29.36), l = 0.6, w = 0.6, heading = 152},
        },
        Drink = {
            { coords = vec3(148.17, -1473.88, 29.36), l = 1.0, w = 2.0, heading = 230, craftable = Crafting.Drink },
        },
        Grill = {
            { coords = vec3(150.17, -1477.0, 29.36), l = 1.6, w = 0.6, heading = 229.6, craftable = Crafting.Grill },
        },
        Prepare = {
            { coords = vec3(150.25, -1473.01, 29.36), l = 0.6, w = 0.6, heading = 229.6, craftable = Crafting.Prepare },
        },
        IceCream = {
            { coords = vec3(149.04, -1472.88, 29.36), l = 0.6, w = 0.6, heading = 152, craftable = Crafting.IceCream },
        },
        Fryer = {
            { coords = vec3(151.7, -1475.53, 29.36),  l = 2.0, w = 0.9, heading = 229.6, craftable = Crafting.Fryer },
        },
        ChoppingBoard = {
            { coords = vec3(152.82, -1474.18, 29.36), l = 0.6, w = 0.6, heading = 229.6, prop = true, propcoords = vector3(152.82, -1474.18, 29.36), craftable = Crafting.ChopBoard },
        },
        --[[         Sink = {}, ]]
    },
}


