Config.Locations["KAMRAD"] = {
    zoneEnabled = true,
    chairsEnabled = true,
    tablesEnabled = true,
    MLO = "KAM",
    job = "cluckinbell",
    zones = {
        vector2(-134.79, -252.31),
        vector2(-163.87, -243.35),
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
    RewardItem = "clucktoy", --Set this to the name of your empty toy item eg "cattoy"
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
            { coords = vec3(-145.68, -258.63, 43.64), l = 0.6, w = 1.5, heading = 248, type = "employee", boxgrab = true,},
            { coords = vec3(-145.08, -263.09, 43.64),   l = 0.6, w = 0.6, heading = 60, type = "tray"},
            { coords = vec3(-144.75, -262.15, 43.64), l = 0.6, w = 0.6, heading = 152, type = "tray"},
        },
        Fridge = {
            { coords = vector3(-146.89, -253.98, 43.64), l = 1.2, w = 1.2, heading = 75, prop = true, propcoords = vector3(-146.89, -253.98, 43.64), },
        },
        Drink = {
            { coords = vec3(-145.47, -264.35, 43.64), l = 0.6, w = 0.6, heading = 152, craftable = Crafting.Drink },
        },
        POS = {
            { coords = vec3(-142.97, -258.25, 43.64), l = 0.6, w = 0.6, heading = 152, menu = true },
            { coords = vec3(-143.41, -259.48, 43.64), l = 0.6, w = 0.6, heading = 152, menu = true },
        },
        Grill = {
            { coords = vec3(-148.64, -258.26, 43.64), l = 0.6, w = 1.6, heading = 152, craftable = Crafting.Grill },
            { coords = vec3(-145.33, -256.01, 43.64), l = 0.6, w = 1.6, heading = 152, craftable = Crafting.Grill },
        },
        Fryer = {
            { coords = vec3(-148.97, -259.31, 43.64),  w = 0.6, l = 0.6, heading = 70, craftable = Crafting.Fryer },
            { coords = vec3(-148.18, -257.18, 43.64), l = 0.6, w = 0.6, heading = 70, craftable = Crafting.Fryer },
        },
        Prepare = {
            { coords = vec3(-185.45, -1431.53, 31.54), l = 0.6, w = 0.6, heading = 152, craftable = Crafting.Prepare },
        },
        IceCream = {
            { coords = vec3(-1844.89, -1195.06, 14), l = 0.6, w = 0.6, heading = 152, craftable = Crafting.IceCream },
        },
        ChoppingBoard = {
            { coords = vec3(-147.61, -255.65, 43.64), l = 0.6, w = 0.6, heading = 70, craftable = Crafting.ChopBoard, prop = true, propcoords = vec3(-147.61, -255.65, 44.58), },
        },
        Coffee = {
            { coords = vec3(-147.12, -261.36, 43.64), l = 0.6, w = 0.6, heading = 152, craftable = Crafting.Coffee },
        },
         --[[ Sink = { }, ]]
    },
}


