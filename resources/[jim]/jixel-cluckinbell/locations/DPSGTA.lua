Config.Locations["DPSGTA"] = {
    zoneEnabled = false,
    chairsEnabled = false,
    tablesEnabled = false,
    MLO = "DP",
    job = "cluckinbell",
    zones = {
        vector2(-525.15362548828, -723.3271484375),
        vector2(-498.12759399414, -717.52618408203),
        vector2(-498.52734375, -676.10968017578),
        vector2(-535.41394042969, -675.9716796875),
        vector2(-534.63262939453, -699.64251708984)
    },
    autoClock = { enter = false, exit = false, }, -- Turning these on will detect if the person has the job and auto clock them on or off
    Blip = {
        label = "Cluckin Bell - San Andreas",
        coords = vector3(-511.96, -685.77, 33.18),
        sprite = 89,
        color = 5,
    },
    garage = {
        spawn = vector4(-1173.0, -899.68, 13.58, 324.91),
        out = vector4(-1170.47, -900.8, 13.81, 29.65),
        list = {  "burrito3", },
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
            { coords = vec3(-518.55, -699.97, 33.17), l = 1.0, w = 1.0, heading = 180, type = "employee", boxgrab = true,},
            { coords = vec3(-519.41, -697.61, 33.17),  w = 0.6, l = 0.6, heading = 0, type = "tray",},
            { coords = vec3(-517.79, -697.65, 33.17),  w = 0.6, l = 0.6, heading = 0, type = "tray", },
            { coords = vec3(-516.04, -697.75, 33.17),  w = 0.6, l = 0.6, heading = 0, type = "tray", },
        },
        Fridge = {
            { coords = vec3(-510.23, -702.64, 33.17), l = 1.1, w = 0.9, heading = 180, prop = true, propcoords = vec3(-510.23, -702.64, 33.17), craftable = Crafting.Fridge },
        },
        POS = {
            { coords = vec3(-516.96, -697.6, 33.17), l = 0.6, w = 0.6, heading = 0},
            { coords = vec3(-518.61, -697.57, 33.17), l = 0.6, w = 0.6, heading = 0},
            { coords = vec3(-520.26, -697.62, 33.17), l = 0.6, w = 0.6, heading = 0},
            { coords = vec3(-515.31, -697.59, 33.17), l = 0.6, w = 0.6, heading = 0},
        },
        Drink = {
            { coords = vec3(-514.46, -699.18, 33.17), l = 1.0, w = 1.0, heading = 180, craftable = Crafting.Drink },
        },
        Grill = {
            { coords = vec3(-516.39, -700.19, 33.17), l = 1.6, w = 0.6, heading = 352, craftable = Crafting.Grill },
        },
        Coffee = {
            { coords = vec3(-517.79, -702.66, 33.17), l = 0.75, w = 0.75, heading = 180, craftable = Crafting.Coffee },
        },
        Fryer = {
            { coords = vec3(-521.18, -701.36, 33.17),  l = 1.75, w = 0.9, heading = 90, craftable = Crafting.Fryer },
        },
        ChoppingBoard = {
            { coords = vec3(-521.3, -699.78, 33.17), l = 0.6, w = 1.5, heading = 90, prop = true, propcoords = vec3(-521.3, -699.78, 34.10), craftable = Crafting.ChopBoard, craftable2 = Crafting.Prepare },
        },
         Sink = {
            { coords = vec3(-512.68, -702.74, 33.17), l = 0.6, w = 0.6, heading = 180},
        },
       --[[  IceCream = {}, ]]
       --[[  Prepare = {}, ]]
    },
}


