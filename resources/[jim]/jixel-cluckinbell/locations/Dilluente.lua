Config.Locations["Dilluente"] = {
    zoneEnabled = false,
    chairsEnabled = false,
    tablesEnabled = false,
    MLO = "DI",
    job = "cluckinbell",
    zones = {
        vector2(-177.68255615234, -1431.4500732422),
        vector2(-187.87971496582, -1444.0834960938),
        vector2(-196.00355529785, -1436.2691650391),
        vector2(-182.60960388184, -1424.2900390625)
    },
    autoClock = { enter = false, exit = false, }, -- Turning these on will detect if the person has the job and auto clock them on or off
    Blip = {
        label = "Cluckin Bell - Carson",
        coords = vector3(-184.49, -1427.66, 31.47),
        sprite = 89,
        color = 5,
    },
    garage = {
        spawn = vector4(-1173.0, -899.68, 13.58, 324.91),
        out = vector4(-1170.47, -900.8, 13.81, 29.65),
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
            { coords = vec3(-182.2, -1431.7, 31.54), l = 0.6, w = 1.4, heading = 32, type = "employee", boxgrab = true},
            { coords = vec3(-184.54, -1428.8, 31.3),  w = 0.6, l = 1.0, heading = 45, type = "tray"},
        },
        Fridge = {
            { coords = vec3(-181.12, -1430.97, 31.54), l = 0.8, w = 0.8, heading = 120, },
        },
        POS = {
            { coords = vec3(-183.43, -1428.12, 31.5), l = 0.6, w = 0.6, heading = 152},
        },
        Grill = {
            { coords = vec3(-183.53, -1432.65, 31.54), l = 0.7, w = 1.4, heading = 301, craftable = CombineTables(Crafting.Grill, Crafting.Fryer) },
        },
        Prepare = {
            { coords = vec3(-185.45, -1431.53, 31), l = 0.7, w = 2.0, heading = 122, craftable = Crafting.Prepare },
        },
        IceCream = {
            -- { coords = vec3(-1844.89, -1195.06, 14), l = 0.6, w = 0.6, heading = 152, craftable = Crafting.IceCream },
        },
        Fryer = {
            { coords = vec3(-1848.05,-1195.53, 14),  w = 0.6, l = 1.4, heading = 60, craftable = Crafting.Fryer },
        },
        ChoppingBoard = {
        },
        --[[ Sink = { }, ]]
        --[[ Coffee = {} ]]
    },
}


