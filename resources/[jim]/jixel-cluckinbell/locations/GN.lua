Config.Locations["GN"] = {
    zoneEnabled = true,
    chairsEnabled = true,
    tablesEnabled = true,
    MLO = "GN",
    job = "cluckinbell",
    zones = {
        vector2(-134.79, -252.31),
        vector2(-163.87, -243.35),
        vector2(-182.0075378418, -280.62149047852),
        vector2(-148.93226623535, -292.44454956055)
    },
    autoClock = { enter = false, exit = false, }, -- Turning these on will detect if the person has the job and auto clock them on or off
    Blip = {
        label = "Cluckin Bell - Rockford Plaza",
        coords = vector3(-152.52, -267.16, 43.60),
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
    Menu = {
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
            { coords = vec3(-153.13, -268.78, 43.6), l = 1.0, w = 1.0, heading = 162, type = "employee", boxgrab = true,},
            { coords = vec3(-151.86, -269.33, 43.6), l = 1.0, w = 1.0, heading = 162, type = "employee", boxgrab = true},
            { coords = vec3(-153.71, -265.92, 43.69),  w = 0.6, l = 0.6, heading = 164, type = "tray", prop = "prop_food_cb_tray_02", propcoords = vec3(-153.71, -265.92, 44.71),},
            { coords = vec3(-151.94, -266.56, 43.6),  w = 0.6, l = 0.6, heading = 164, type = "tray", },
            { coords = vec3(-149.29, -267.17, 43.6),  w = 1.0, l = 1.0, heading = 164, type = "tray", },
        },
        Fridge = {
            { coords = vec3(-158.32, -274.89, 42.6), l = 2.6, w = 0.6, heading = 160,},
        },
        POS = {
            { coords = vec3(-154.56, -265.7, 43.6), l = 0.6, w = 0.6, heading = 152},
            { coords = vec3(-152.91, -266.26, 43.6), l = 0.6, w = 0.6, heading = 152},
            { coords = vec3(-151.14, -266.86, 43.6), l = 0.6, w = 0.6, heading = 152},
        },
        Drink = {
            { coords = vec3(-157.01, -271.09, 42.6), l = 0.6, w = 0.6, heading = 160, craftable = Crafting.Drink },
        },
        Grill = {
            { coords = vec3(-150.53, -273.36, 42.6), l = 1.6, w = 0.6, heading = 252, craftable = Crafting.Grill },
        },
        Prepare = {
            { coords = vec3(-152.51, -271.08, 42.6), l = 0.6, w = 0.6, heading = 72.0, craftable = Crafting.Prepare },
        },
        IceCream = {
            { coords = vec3(-156.59, -270.25, 42.6), l = 1.2, w = 0.6, heading = 340, craftable = Crafting.IceCream },
        },
        Coffee = {
            { coords = vec3(-157.28, -272.04, 43.6), l = 0.75, w = 0.75, heading = 252, craftable = Crafting.Coffee },
        },
        Fryer = {
            { coords = vec3(-149.4, -270.51, 42.6),  l = 2.0, w = 0.9, heading = 252, craftable = Crafting.Fryer },
        },
        ChoppingBoard = {
            { coords = vec3(-153.77, -270.76, 42.6), l = 0.6, w = 0.6, heading = 341, prop = true, propzoffset = 30.30, craftable = Crafting.ChopBoard },
        },
        Sink = {
            { coords = vec3(-156.58, -272.79, 42.6), l = 0.6, w = 0.6, heading = 155.7},
            { coords = vec3(-165.6, -254.15, 44.18),  l = 2.0, w = 0.9, heading = 251,},
            { coords = vec3(-165.38, -253.37, 44.18),  l = 2.0, w = 0.9, heading = 251,},
        },
    },
}


