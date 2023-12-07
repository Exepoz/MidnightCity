Config.Locations["AMB"] = {
    zoneEnabled = false,
    chairsEnabled = false,
    tablesEnabled = false,
    MLO = "AMB",
    job = "cluckinbell",
    zones = {
        vector2(-134.79, -252.31),
        vector2(-153.85, -244.97),
        vector2(-182.0075378418, -280.62149047852),
        vector2(-148.93226623535, -292.44454956055)
    },
    autoClock = { enter = false, exit = false, }, -- Turning these on will detect if the person has the job and auto clock them on or off
    Blip = {
        label = "Cluckin Bell - Las Lagunas",
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
            { coords = vec3(-151.91, -260.43, 43.67), l = 1.5, w = 1.5, heading = 70, type = "employee", boxgrab = true},
            { coords = vec3(-151.25, -258.94, 43.67), l = 1.5, w = 1.5, heading = 70, type = "employee", boxgrab = true},
            { coords = vec3(-152.29, -261.81, 43.67), l = 1.5, w = 1.5, heading = 70, type = "employee", boxgrab = true},
            { coords = vec3(-148.96, -260.49, 43.67),  w = 0.6, l = 0.6, heading = 250, type = "tray", prop = "prop_food_cb_tray_02", propcoords = vec3(-148.96, -260.49, 44.74) },
            { coords = vec3(-148.4, -258.95, 43.67),  w = 0.6, l = 0.6, heading = 250, type = "tray", prop = "prop_food_cb_tray_02", propcoords = vec3(-148.4, -258.95, 44.74) },
        },
        Fridge = {
            { coords = vec3(-153.42, -261.74, 43.67), l = 1.0, w = 0.9, heading = 160, prop = true, propcoords = vec3(-153.42, -261.74, 43.67) },
        },
        Coffee = {
            { coords = vec3(-155.15, -258.83, 43.60), l = 0.6, w = 0.6, heading = 340, craftable = Crafting.Coffee, prop = true, propcoords = vec3(-155.15, -258.83, 44.60) },
        },
        POS = {
            { coords = vec3(-149.26, -261.31, 43.67), l = 0.6, w = 0.6, heading = 152},
            { coords = vec3(-148.73, -259.74, 43.67), l = 0.6, w = 0.6, heading = 152},
            { coords = vec3(-148.17, -258.15, 43.67), l = 0.6, w = 0.6, heading = 152},
        },
        Drink = {
            { coords = vec3(-157.47, -257.63, 43.67), l = 0.75, w = 0.75, heading = 70.0, craftable = Crafting.Drink },
        },
        Grill = {
            { coords = vec3(-156.177124, -254.049606, 43.674792), l = 1.6, w = 0.6, heading = 70.0, craftable = Crafting.Grill, prop = true, propcoords = vec3(-156.177124, -254.049606, 43.674792) },
        },
        Prepare = {
            { coords = vec3(-157.8, -258.74, 43.67), l = 0.6, w = 0.6, heading = 229.6, craftable = Crafting.Prepare },
        },
        IceCream = {
            { coords = vec3(-154.39, -259.08, 43.67), l = 0.6, w = 0.6, heading = 152, craftable = Crafting.IceCream },
        },
        Fryer = {
            { coords = vec3(-156.73, -255.6, 43.67),  l = 2.0, w = 0.9, heading = 70.0, craftable = Crafting.Fryer, prop = true, propcoords = vec3(-156.73, -255.6, 43.67) },
        },
        ChoppingBoard = {
            { coords = vec3(-154.49, -256.66, 43.67), l = 0.6, w = 0.6, heading = 250.0, prop = true, propcoords = vec3(-154.49, -256.66, 44.60), craftable = Crafting.ChopBoard },
        },
        --[[ Sink = { }, ]]
    },
}


