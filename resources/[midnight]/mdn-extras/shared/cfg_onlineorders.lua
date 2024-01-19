Config = Config or {}
Config.OnlineOrders = {}

Config.OnlineOrders.RestockTime = 5

-- Custom Shop (Not an actual job in shared/jobs.lua)

-- KEY                      = Name of the shop/job you order from (NEEDS TO BE THE SAME AS Config.OnlineOrders.jobs)
    -- label                = Name of the Job
    -- bankAccount          = name of the account to withdraw the money from (Society account or Gang account)
    -- isGang (optional)    = If the account is a Gang, set true
    -- coords               = coords where the order option is displayed in the radial menu
    -- cids                 = CIDs that have access to order items for that job. (Leave nil if you want to use Shared.Jobs.canOrderOnline, only works for real jobs)
Config.OnlineOrders.CustomJobs = {
    ['tunershop'] = {
        label = "Tuner Shop",
        bankAccount = 'tunershop',
        coords = vector3(128.21, -3011.18, 7.04),
        --cids = {['UPY10832'] = true, ['RQN37448'] = true}
    },
    ['lscustoms'] = {
        label = "Los Santos Customs",
        bankAccount = 'lscustoms',
        coords = vector3(-349.22, -129.06, 39.01),
        --cids = {['UPY10832'] = true}
    },
    ['catcafe'] = {
        label = "UwU Cafe",
        bankAccount = 'catcafe',
        coords = vector3(-585.38, -1055.96, 22.34),
        --cids = {['UPY10832'] 
    },
    -- ['vubar'] = {
    --     label = "Vanilla Unicorn Bar",
    --     bankAccount = 'vanilla',
    --     isGang = false,
    --     isJob = true,
    --     coords = vector3(-345.45, -127.06, 39.01),
    --     cids = {},
    --     jobs = {'vanilla'}
    -- },

}


-- Categories & Items available

-- OPTIONS
    -- header   = Category Displayed Name
    -- icon     = fontAwesome icon.

-- ITEMS
    -- item             = Name of the Item
    -- price            = price in $
    -- stock            = Stock on startup
    -- loc              = location to go get the item (See Config.OnlineOrders.ShopLocations)
    -- max              = max amount that someone can order at a time.
    -- exl (optional)   = Shops that DO NOT have this item
    -- jobs (optional)  = REQUIRED job for the item to be available.
Config.OnlineOrders.Shops = {
    -- Mechanics
    ['tools'] = {
        options = {header = "Tools", icon = 'toolbox'},
        items = {
            [1] = {item = "underglow_controller",   price = 1500,   stock = 25, 	loc = 3, max = 10},
            [2] = {item = "paintcan",               price = 100,    stock = 100, 	loc = 2, max = 25},
            [3] = {item = "cleaningkit",            price = 20,     stock = 100, 	loc = 2, max = 25},
            [4] = {item = "harness",                price = 500,    stock = 25, 	loc = 15, max = 25, exl = {"lscustoms"}  },
            [5] = {item = "noscan",                 price = 500,    stock = 25, 	loc = 15, max = 25, },
            [6] = {item = "horn",                   price = 500,    stock = 25, 	loc = 4, max = 10,},
            [7] = {item = "ducttape",               price = 25,     stock = 100, 	loc = 2, max = 25},
            [8] = {item = "newoil",                 price = 1500,   stock = 25, 	loc = 3, max = 10},
            [9] = {item = "sparkplugs",             price = 100,    stock = 100, 	loc = 2, max = 25},
            [10] = {item = "carbattery",            price = 20,     stock = 100, 	loc = 2, max = 25},
            [11] = {item = "axleparts",             price = 500,    stock = 25, 	loc = 15, max = 25, },
            [12] = {item = "sparetire",             price = 500,    stock = 25, 	loc = 15, max = 25, },
            [13] = {item = "enginekit",             price = 500,    stock = 25, 	loc = 4, max = 10,},
            [14] = {item = "bodykit",               price = 25,     stock = 100, 	loc = 2, max = 25},

        }
    },
    ['performance'] = {
        options = {header = "Performance Items", icon = 'gear'},
        items = {
            [1] = {item = "engine1",          price = 12500,   	stock = 50,  loc = 1, max = 15, },
            [2] = {item = "engine2",          price = 17500,    	stock = 50,  loc = 1, max = 15, },
            [3] = {item = "engine3",          price = 25000,     stock = 50,  loc = 1, max = 15, },
            [4] = {item = "engine4",          price = 35000,    	stock = 50,  loc = 1, max = 15, },
            [5] = {item = "transmission1",    price = 12500,    	stock = 50,  loc = 1, max = 15, },
            [6] = {item = "transmission2",    price = 17500,    	stock = 50,  loc = 1, max = 15, },
            [7] = {item = "transmission3",    price = 25000,    	stock = 50,  loc = 1, max = 15, },
            [8] = {item = "brakes1",          price = 12500,   	stock = 50,  loc = 3, max = 15, },
            [9] = {item = "brakes2",          price = 17500,    	stock = 50,  loc = 3, max = 15, },
            [10] = {item = "brakes3",         price = 25000,     stock = 50,  loc = 3, max = 15, },
            [11] = {item = "suspension1",     price = 12500,    	stock = 50,  loc = 3, max = 15, },
            [12] = {item = "suspension2",     price = 17500,    	stock = 50,  loc = 3, max = 15, },
            [13] = {item = "suspension3",     price = 25000,    	stock = 50,  loc = 3, max = 15, },
            [14] = {item = "suspension4",     price = 35000,    	stock = 50,  loc = 3, max = 15, },
            [15] = {item = "turbo",           price = 50000,    	stock = 25,  loc = 1, max = 5, exl = {"lscustoms"} },
            [16] = {item = "oilp1",           price = 12500,   	stock = 50,  loc = 1, max = 15, },
            [17] = {item = "oilp2",           price = 17500,    	stock = 50,  loc = 1, max = 15, },
            [18] = {item = "oilp3",           price = 25000,     stock = 50,  loc = 1, max = 15, },
            [19] = {item = "drives1",         price = 35000,    	stock = 50,  loc = 1, max = 15, },
            [20] = {item = "drives2",         price = 12500,    	stock = 50,  loc = 1, max = 15, },
            [21] = {item = "drives3",         price = 17500,    	stock = 50,  loc = 1, max = 15, },
            [22] = {item = "cylind1",         price = 25000,    	stock = 50,  loc = 1, max = 15, },
            [23] = {item = "cylind2",         price = 12500,   	stock = 50,  loc = 3, max = 15, },
            [24] = {item = "cylind3",         price = 17500,    	stock = 50,  loc = 3, max = 15, },
            [25] = {item = "fueltank1",       price = 25000,    	stock = 50,  loc = 1, max = 15, },
            [26] = {item = "fueltank2",       price = 12500,   	stock = 50,  loc = 3, max = 15, },
            [27] = {item = "fueltank3",       price = 17500,    	stock = 50,  loc = 3, max = 15, },
            [28] = {item = "cables1",         price = 25000,     stock = 50,  loc = 3, max = 15, },
            [29] = {item = "cables2",         price = 12500,    	stock = 50,  loc = 3, max = 15, },
            [30] = {item = "cables3",         price = 17500,    	stock = 50,  loc = 3, max = 15, },
            [31] = {item = "antilag",         price = 25000,    	stock = 50,  loc = 3, max = 15, },
            [32] = {item = "modified_turbo",  price = 60000,    	stock = 25,  loc = 1, max = 5, exl = {"lscustoms"} },
        },
    },
    ['cosmetics'] = {
        options = {header = "Cosmetic Items", icon = 'palette'},
        items = {
            [1] = {item = "tint_supplies",  price = 1500,   	stock = 50, 	loc = 2, max = 15},
            [2] = {item = "tires",          price = 5000,    stock = 50, 	loc = 2, max = 15},
            [3] = {item = "roof",           price = 3000,    stock = 50, 	loc = 1, max = 15, },
            [4] = {item = "internals",      price = 2500,    stock = 100, 	loc = 2, max = 25, },
            [5] = {item = "customplate",    price = 1000,    stock = 50, 	loc = 2, max = 15, },
            [6] = {item = "seat",           price = 3500,    stock = 50, 	loc = 4, max = 15, },
            [7] = {item = "rims",           price = 5000,    stock = 50, 	loc = 4, max = 15, },
            [8] = {item = "hood",           price = 3500,   	stock = 50, 	loc = 5, max = 15, },
            [9] = {item = "skirts",         price = 2500,    stock = 50, 	loc = 5, max = 15, },
            [10] = {item = "bumper",        price = 3000,    stock = 50, 	loc = 5, max = 15, },
            [11] = {item = "externals",     price = 4000,    stock = 100, 	loc = 5, max = 25, },
            [12] = {item = "headlights",    price = 5000,    stock = 50, 	loc = 5, max = 15, },
            [13] = {item = "spoiler",       price = 3500,    stock = 50, 	loc = 5, max = 15, },
            [14] = {item = "rollcage",      price = 3500,    stock = 50, 	loc = 5, max = 15, },
            [15] = {item = "exhaust",       price = 3500,    stock = 25, 	loc = 4, max = 15, },
            [16] = {item = "livery",        price = 5000,    stock = 10, 	loc = 2, max = 15},
            [17] = {item = "noscolour",     price = 5000,    stock = 25, 	loc = 15, }, --
        },
    },

    -- Restaurents & Bars
    ['fish'] = {
        options = {header = "Sea Products", icon = 'fish'},
        items = {
            [1] = {item = "oystershell",    price = 55, stock = 300, loc = 10, max = 100},
            [2] = {item = "squid",          price = 55, stock = 300, loc = 10, max = 100},
            [3] = {item = "fish",           price = 55, stock = 300, loc = 10, max = 100},
        }
    },
    ['meats'] = {
        options = {header = "Butchery", icon = 'drumstick-bite'},
        items = {
            [1] = {item = "chickenbreast",  price = 45, stock = 300, loc = 9, max = 100},
            [2] = {item = "burgerpatty",    price = 45, stock = 300, loc = 9, max = 100},
            [3] = {item = "meat",           price = 45, stock = 300, loc = 9, max = 100},
            [4] = {item = "ham",            price = 45, stock = 300, loc = 9, max = 100},
            [5] = {item = "jimsausages",    price = 45, stock = 300, loc = 9, max = 100},
            [6] = {item = "egg",            price = 45, stock = 300, loc = 9, max = 100},
            [7] = {item = "frozennugget",   price = 45, stock = 300, loc = 9, max = 100},
        }
    },
    ['fruits'] = {
        options = {header = "Fruits", icon = 'apple-whole'},
        items = {
            [1] = {item = "orange",     price = 30, stock = 300, loc = 8, max = 100},
            [2] = {item = "peach",      price = 30, stock = 300, loc = 8, max = 100},
            [3] = {item = "strawberry", price = 30, stock = 300, loc = 8, max = 100},
            [4] = {item = "blueberry",  price = 30, stock = 300, loc = 8, max = 100},
            [5] = {item = "lime",       price = 30, stock = 300, loc = 8, max = 100},
            [6] = {item = "lemon",      price = 30, stock = 300, loc = 8, max = 100},
            [7] = {item = "medfruits",  price = 30, stock = 300, loc = 8, max = 100, jobs = {['pizzathis'] = true}},
            [8] = {item = "watermelon", price = 30, stock = 300, loc = 8, max = 100, jobs = {['beanmachine'] = true}},
            [9] = {item = "cherry",     price = 30, stock = 300, loc = 8, max = 100, jobs = {['vanilla'] = true}},
        }
    },
    ['veggies'] = {
        options = {header = "Vegetables & Fine Herbs", icon = 'carrot'},
        items = {
            [1] = {item = "potato",         price = 30, stock = 300, loc = 8, max = 100},
            [2] = {item = "onion",          price = 30, stock = 300, loc = 8, max = 100},
            [3] = {item = "lettuce",        price = 30, stock = 300, loc = 8, max = 100},
            [4] = {item = "olives",         price = 30, stock = 300, loc = 8, max = 100},
            [5] = {item = "pizzmushrooms",  price = 30, stock = 300, loc = 8, max = 100},

            [6] = {item = "basil",          price = 27, stock = 300, loc = 8, max = 100},
            [7] = {item = "cubasil",        price = 27, stock = 300, loc = 8, max = 100},
            [8] = {item = "mintleaf",       price = 27, stock = 300, loc = 8, max = 100},
        }
    },
    ['dairy'] = {
        options = {header = "Dairy", icon = 'cow'},
        items = {
            [1] = {item = "milk",        price = 42, stock = 300, loc = 8, max = 100},
            [2] = {item = "cheese",      price = 40, stock = 300, loc = 8, max = 100},
            [3] = {item = "mozz",        price = 40, stock = 300, loc = 8, max = 100},
            [4] = {item = "gelato",      price = 42, stock = 300, loc = 11, max = 100, },
            [5] = {item = "popicecream", price = 42, stock = 300, loc = 11, max = 100, },
            [6] = {item = "icecream",    price = 42, stock = 300, loc = 11, max = 100, },
        }
    },
    ['desserts'] = {
        options = {header = "Premade Desserts", icon = 'cake-candles'},
        items = {
            [1] = {item = "tiramisu",     price = 45, stock = 300, loc = 11, max = 100,}, -- +pizza
            [2] = {item = "cheesecake",   price = 45, stock = 300, loc = 11, max = 100,}, -- +pops +beanmachine
            [3] = {item = "carrotcake",   price = 45, stock = 300, loc = 11, max = 100,},
            [4] = {item = "jelly",        price = 45, stock = 300, loc = 7, max = 100, },
            [5] = {item = "chocpudding",  price = 45, stock = 300, loc = 7, max = 100, },
            [6] = {item = "popdonut",     price = 45, stock = 300, loc = 7, max = 100, },
        }
    },
    ['processed'] = {
        options = {header = "Processed Goods", icon = 'industry'},
        items = {
            [1] = {item = "cranberry",      price = 27, stock = 300, loc = 7, max = 100, },
            [2] = {item = "pinejuice",      price = 27, stock = 300, loc = 7, max = 100, },
            [3] = {item = "sprunk",         price = 27, stock = 300, loc = 7, max = 100, },
            [4] = {item = "sprunklight",    price = 27, stock = 300, loc = 7, max = 100, },
            [5] = {item = "ecola",          price = 27, stock = 300, loc = 7, max = 100, },
            [6] = {item = "ecolalight",     price = 27, stock = 300, loc = 7, max = 100, },
            [7] = {item = "crisps",         price = 27, stock = 300, loc = 7, max = 100, },
            [8] = {item = "chocolate",      price = 27, stock = 300, loc = 7, max = 100},
        }
    },
    ['baking'] = {
        options = {header = "Baking Ingredients", icon = 'cookie-bite'},
        items = {
            [1] = {item = "sugar",          price = 32, stock = 250, loc = 7, max = 100},
            [2] = {item = "flour",          price = 32, stock = 300, loc = 7, max = 100},
            [3] = {item = "butter",         price = 32, stock = 300, loc = 7, max = 100},
            [4] = {item = "gelatine",       price = 32, stock = 300, loc = 7, max = 100},
            [5] = {item = "chocolatechips", price = 32, stock = 300, loc = 7, max = 100},
            [6] = {item = "peanutbutter",   price = 32, stock = 300, loc = 7, max = 100},
            [7] = {item = "gummymould",     price = 500, stock = 10, loc = 7, max = 100, },
            [8] = {item = "egg",            price = 35, stock = 100, loc = 9, max = 100, },
            --[9] = {item = "yeast",          price = 100, stock = 100, loc = 7, max = 100,},
        }
    },
    ['gengoods'] = {
        options = {header = "General Goods", icon = 'basket-shopping'},
        items = {
            [1] =  {item = "water_bottle",  price = 37, stock = 300, loc = 7, max = 100, exl = {['whitewidow'] = true, ['vanilla'] = true}},
            [2] = {item = "tosti",          price = 37, stock = 300, loc = 7, max = 100, exl = {['whitewidow'] = true, ['vanilla'] = true}},
            [3] = {item = "burgerbun",      price = 37, stock = 300, loc = 7, max = 100, exl = {['club77'] = true}},
            [4] = {item = "tofu",           price = 37, stock = 300, loc = 7, max = 100, exl = {['club77'] = true}},
            [5] = {item = "rice",           price = 37, stock = 300, loc = 7, max = 100, exl = {['club77'] = true}},
            [6] = {item = "sauce",          price = 37, stock = 300, loc = 7, max = 100, exl = {['club77'] = true}},
            [7] = {item = "pasta",          price = 37, stock = 300, loc = 7, max = 100, exl = {['club77'] = true}},
            [8] = {item = "nachos",         price = 37, stock = 300, loc = 7, max = 100, exl = {['club77'] = true}},
            [9] = {item = "cereal",         price = 37, stock = 300, loc = 7, max = 100, exl = {['club77'] = true}},
        }
    },
    ['alcohol'] = {
        options = {header = "Alcohol", icon = 'martini-glass'},
        items = {
            [1] = {item = "schnapps",    price = 72, stock = 200, loc = 12, max = 100, exl = {['vanilla'] = true, ['pizzathis'] = true, ['catcafe'] = true}},
            [2] = {item = "gin",         price = 72, stock = 200, loc = 12, max = 100, exl = {['pizzathis'] = true, ['catcafe'] = true}},
            [3] = {item = "scotch",      price = 72, stock = 200, loc = 12, max = 100, exl = {['vanilla'] = true, ['pizzathis'] = true, ['catcafe'] = true}},
            [4] = {item = "rum",         price = 72, stock = 200, loc = 12, max = 100, exl = {['pizzathis'] = true, ['catcafe'] = true}},
            [5] = {item = "amaretto",    price = 72, stock = 200, loc = 12, max = 100, exl = {['pizzathis'] = true, ['catcafe'] = true}},
            [6] = {item = "curaco",      price = 72, stock = 200, loc = 12, max = 100, exl = {['vanilla'] = true, ['pizzathis'] = true, ['catcafe'] = true}},
            [7] = {item = "icream",      price = 72, stock = 200, loc = 12, max = 100, exl = {['vanilla'] = true, ['pizzathis'] = true, ['catcafe'] = true}},
            [8] = {item = "vodka",       price = 72, stock = 200, loc = 12, max = 100, exl = {['catcafe'] = true}},
            [9] = {item = "sake",        price = 72, stock = 200, loc = 12, max = 100, jobs = {['catcafe'] = true}},
            [10] = {item = "amarone",    price = 75, stock = 200, loc = 12, max = 100, jobs = {['pizzathis'] = true}},
            [11] = {item = "barbera",    price = 75, stock = 200, loc = 12, max = 100, jobs = {['pizzathis'] = true}},
            [12] = {item = "dolceto",    price = 75, stock = 200, loc = 12, max = 100, jobs = {['pizzathis'] = true}},
            [13] = {item = "housered",   price = 75, stock = 200, loc = 12, max = 100, jobs = {['pizzathis'] = true}},
            [14] = {item = "housewhite", price = 75, stock = 200, loc = 12, max = 100, jobs = {['pizzathis'] = true}},
            [15] = {item = "rosso",      price = 75, stock = 200, loc = 12, max = 100, jobs = {['pizzathis'] = true}},
            [16] = {item = "midori",     price = 75, stock = 200, loc = 12, max = 100, jobs = {['vanilla'] = true}},
            [17] = {item = "prosecco",   price = 75, stock = 200, loc = 12, max = 100, jobs = {['vanilla'] = true}},
            [18] = {item = "tequila",    price = 72, stock = 200, loc = 12, max = 100, jobs = {['vanilla'] = true, ['club77'] = true}},
            [19] = {item = "triplsec",   price = 72, stock = 200, loc = 12, max = 100, jobs = {['vanilla'] = true, ['club77'] = true}},
            [20] = {item = "whiskey",    price = 72, stock = 200, loc = 12, max = 100, jobs = {['vanilla'] = true, ['club77'] = true}},
            [21] = {item = "champagnebottle",    price = 75, stock = 200, loc = 12, max = 100, jobs = {['vanilla'] = true}},
        }
    },
    ['beanmachine'] = {
        options = {header = "Bean Machine Exclusives", icon = 'pagelines'},
        items = {
            [1] = {item = "beancoffee", price = 45, stock = 300, loc = 13, max = 100},
            [2] = {item = "beandonut",  price = 42, stock = 300, loc = 13, max = 100},
            [3] = {item = "rhinohorn",  price = 42, stock = 300, loc = 13, max = 100},
        }
    },
    ['catcafe'] = {
        options = {header = "Cat Cafe Exclusives", icon = 'cat'},
        items = {
            [1] = {item = "nori",       price = 42, stock = 300, loc = 13, max = 100},
            [2] = {item = "boba",       price = 45, stock = 300, loc = 13, max = 100},
            [3] = {item = "noodles",    price = 40, stock = 300, loc = 13, max = 100},
        }
    },
    ['whitewidow'] = {
        options = {header = "Stoner's Delights", icon = 'cannabis'},
        items = {
            [1] = {item = "trimmers",       price = 150, stock = 15, loc = 13, max = 15},
            [2] = {item = "grinder",        price = 250, stock = 25, loc = 13, max = 25},
            [3] = {item = "rollingpapers",  price = 10, stock = 500, loc = 13, max = 100},
            [4] = {item = "emptybaggy",     price = 5, stock = 500, loc = 13, max = 100},
            [5] = {item = "empty_weed_jar",  price = 20, stock = 100, loc = 13, max = 100},
            [6] = {item = "bong",           price = 500, stock = 25, loc = 13, max = 25},
            [7] = {item = "lighter",        price = 10, stock = 100, loc = 13, max = 100},
            [8] = {item = "weedgrowlight",  price = 500, stock = 100, loc = 13, max = 100},
            [9] = {item = "emptyprerollpack", price = 20, stock = 100, loc = 13, max = 100},
            [10] = {item = "weed_nutrition",  price = 100, stock = 500, loc = 13, max = 100},
            [11] = {item = "seedpack",      price = 1000, stock = 50, loc = 13, max = 50,
                    subt = {{value = 'skunk_seed', label = "Skunk"}, {value = 'zkittles_seed', label = "zKittles"},
                    {value = 'trainwreck_seed', label = "Trainwreck"}, {value = 'garliccookies_seed', label = "Garlic Cookies"},  {value = 'malmokush_seed', label = "Malmo Kush"
                }},
            }
        },
    },

    -- Ammunation
    --['ammo'] = {
    --    options = {header = "Ammunition", icon = 'ellipsis'},
    --    items = {
    --        [1] = {item = "pistol_ammo",  price = 100, stock = 500, loc = 6, max = 100},
    --        [2] = {item = "smg_ammo",  price = 300, stock = 500, loc = 6, max = 100},
    --        [3] = {item = "shotgun_ammo",  price = 250, stock = 500, loc = 6, max = 100},
    --        [4] = {item = "hunting_ammo",  price = 250, stock = 500, loc = 6, max = 100},
    --    }
    --},
    --['pistols'] = {
    --    options = {header = "Pistols", icon = 'gun'},
    --    items = {
    --        [1] = {item = "weapon_dp9",  price = 3250, stock = 25, loc = 6, max = 25},
    --        [2] = {item = "weapon_fnx45",  price = 4500, stock = 25, loc = 6, max = 25},
    --        [3] = {item = "weapon_m1911",  price = 5200, stock = 25, loc = 6, max = 25},
    --        [4] = {item = "weapon_browning",  price = 9375, stock = 25, loc = 6, max = 25},
    --        [5] = {item = "weapon_de",  price = 14650, stock = 25, loc = 6, max = 25},
    --    }
    --},
    --['smgs'] = {
    --    options = {header = "SMGs", icon = 'bars-staggered'},
    --    items = {
    --        [1] = {item = "weapon_mp5",  price = 18350, stock = 25, loc = 6, max = 25},
    --        [2] = {item = "weapon_mp9",  price = 24650, stock = 25, loc = 6, max = 25},
    --    }
    --},
    --['hunting'] = {
    --    options = {header = "Hunting", icon = 'bullseye'},
    --    items = {
    --        [1] = {item = "weapon_huntingrifle",  price = 500, stock = 25, loc = 6, max = 25},
    --    }
    --},
    --['shotguns'] = {
    --     options = {header = "Shotguns", icon = 'gun'},
    --     items = {
    --         [1] = {item = "weapon_mossberg",  price = 15275, stock = 25, loc = 6, max = 25},
    --         --[2] = {item = "weapon_doublebarrel",  price = 82000, stock = 25, loc = 6, max = 25}, NOT A WEAPON
    --     }
    --},
    --['protection'] = {
    --    options = {header = "Self Protection", icon = 'shield'},
    --    items = {
    --        [1] = {item = "armor",  price = 500, stock = 50, loc = 6, max = 25},
    --        [2] = {item = "heavyarmor",  price = 1000, stock = 25, loc = 6, max = 15},
    --    }
    --},
    --['melee'] = {
    --    options = {header = "Melee Weapon", icon = 'shield'},
    --    items = {
    --        [1] = {item = "weapon_knife",  price = 100, stock = 75, loc = 6, max = 25},
    --        [2] = {item = "weapon_bat",  price = 100, stock = 75, loc = 6, max = 25},
    --        [3] = {item = "weapon_hatchet",  price = 100, stock = 75, loc = 6, max = 25},
    --        [4] = {item = "weapon_crowbar",  price = 100, stock = 75, loc = 6, max = 25},
    --    }
    --},
--
    ---- digital den
    --['electronics'] = {
    --    options = {header = "Electronics", icon = 'wifi'},
    --    items = {
    --        [1] = {item = "electronickit",  price = 200, stock = 50, loc = 14, max = 25},
    --        [2] = {item = "speakerparts",  price = 400, stock = 25, loc = 14, max = 15},
    --        [3] = {item = "phone_module",  price = 250, stock = 50, loc = 14, max = 15},
    --        [4] = {item = "glue",  price = 150, stock = 50, loc = 14, max = 25},
    --        [5] = {item = "pd_screwdriver",  price = 150, stock = 10, loc = 14, max = 10},
    --        [6] = {item = "pd_scanner",  price = 5500, stock = 2, loc = 14, max = 1},
    --    }
    --},

    -- Winery
    ['wine_equipment'] = {
        options = {header = "Winery Equipment", icon = 'wine-bottle'},
        items = {
            [1] = {item = "empty_barrel",  price = 200, stock = 50, loc = 14, max = 25},
        }
    },
}

-- Jobs & Which category do they have access to
Config.OnlineOrders.jobs = {
    ["tunershop"]  = {AvailableShops = {'tools', 'performance', 'cosmetics'}, loc = vector3(127.32, -3011.33, 7.04)},
	["lscustoms"]       = {AvailableShops = { 'tools','performance', 'cosmetics'}},
	["lostmcmotor"]     = {AvailableShops = {'tools', 'performance', 'cosmetics'}},
	["bennys"]          = {AvailableShops = {'tools', 'performance', 'cosmetics'}},
	["eastcustoms"]     = {AvailableShops = {'tools', 'performance', 'cosmetics'}},
	["hayes"]           = {AvailableShops = {'tools', 'performance', 'cosmetics'}},
	["lsemech"]         = {AvailableShops = {'tools', 'performance', 'cosmetics'}},
	["bikegarage"]      = {AvailableShops = {'tools', 'performance', 'cosmetics'}},
	["flywheel"]        = {AvailableShops = {'tools', 'performance', 'cosmetics'}},
	["cowboy"]          = {AvailableShops = {'tools', 'performance', 'cosmetics'}},

    ["whitewidow"]      = {AvailableShops = {'baking', 'gengoods', 'whitewidow', 'dairy'}},
    ["vanilla"]         = {AvailableShops = {'meats', 'dairy', 'fruits', 'veggies','processed', 'alcohol', 'gengoods'}},
    ["tequilala"]       = {AvailableShops = {'dairy', 'fruits', 'processed', 'alcohol'}},
    ["popsdiner"]       = {AvailableShops = {'meats', 'fish', 'dairy', 'veggies', 'desserts'}},
    ["pizzathis"]       = {AvailableShops = {'meats', 'fish', 'dairy', 'fruits', 'veggies', 'desserts', 'gengoods', 'alcohol',  'processed'}},
    ["catcafe"]         = {AvailableShops = {'dairy', 'fruits', 'veggies', 'baking', 'gengoods', 'alcohol', 'catcafe'}},
    ["burgershot"]      = {AvailableShops = {'meats','dairy','veggies', 'gengoods'}},
    ["cluckinbell"]      = {AvailableShops = {'meats','dairy','veggies', 'gengoods'}},
    ["beanmachine"]     = {AvailableShops = {'meats', 'fish', 'dairy', 'fruits', 'baking', 'desserts', 'processed', 'gengoods', 'beanmachine',}},
    -- (jim bars) Bars
    ["eclipse"]         = {AvailableShops = {'fruits', 'processed', 'alcohol'}},
    ["risingbar"]       = {AvailableShops = {'fruits', 'processed', 'alcohol'}},
    ["bikegaragebar"]   = {AvailableShops = {'fruits', 'processed', 'alcohol'}},
    ["mirror"]          = {AvailableShops = {'fruits', 'processed', 'alcohol'}},
    ["club77"]          = {AvailableShops = {'fruits', 'processed', 'alcohol', 'gengoods'}},

    ["ammunation"]      = {AvailableShops = {'ammo', 'pistols', 'smgs', 'shotguns', 'hunting', 'melee', 'protection'}},
    ["digitalden"]      = {AvailableShops = {'electronics'}},
    ["winery"]          = {AvailableShops = {'baking', 'wine_equipment'}},
}

Config.Foodpacks = {
    'foodpack_egg'
}

-- Locations to go pick up the order
-- ped      = ped hash
-- coords   = ped coords (v4 for heading)
-- name     = Name of the shop
Config.OnlineOrders.ShopLocations = {
    [1] = {
		ped = 'mp_m_waremech_01',
        coords = vector4(967.56, -1828.71, 31.24, 351.21),
		name = 'Orachardvile Autoshop',
    },
    [2] = {
		ped = 's_m_m_autoshop_02',
        coords = vector4(704.0, -1136.88, 23.72, 41.67),
		name = 'Red Car City Paints',
    },
    [3] = {
		ped = 's_m_y_winclean_01',
        coords = vector4(923.62, -1134.6, 25.94, 353.97),
		name = 'Popular Car Parts',
    },
    [4] = {
		ped = 'u_m_y_smugmech_01',
        coords = vector4(925.14, -2350.21, 31.82, 48.5),
		name = 'The Automobile Wareohouse'
    },
	[5] = {
		ped = 's_m_m_ccrew_01',
        coords = vector4(-155.96, -1348.57, 29.92, 264.8),
		name = 'Innocence Auoto Parts'
    },
	[6] = { -- Docks (Ammunation) -- vector4(800.89, -902.94, 25.24, 103.01)
		ped = 'a_m_y_busicas_01',
        coords = vector4(858.64, -3204.1, 5.99, 207.64),
        name = 'Bilgeco Shipping'
    },
	[7] = { -- Near Pizzathis & Ottos (Ammunation)
		ped = 's_m_m_strvend_01',
        coords = vector4(800.89, -902.94, 25.24, 103.01),
        name = 'Big Goods General Store'
    },
	[8] = { -- Fridgit (Ammunation)
		ped = 'mp_f_meth_01',
        coords = vector4(868.4, -1639.9, 30.34, 104.43),
        name = 'Wholesale Veggies'
    },
	[9] = { -- Near Pizzathis & Ottos (Ammunation)
		ped = 's_m_m_migrant_01',
        coords = vector4(961.7, -2189.42, 30.51, 88.41),
        name = 'The General Store'
    },
    [10] = { -- Fish Store @ Docks
        ped = 's_m_m_migrant_01',
        coords = vector4(-68.97, -2655.59, 6.0, 0.77),
        name = 'The Ocean Store'
    },
    [11] = { -- Fridgit Frezers (Alleyway)
        ped = 's_m_m_migrant_01',
        coords = vector4(1004.53, -1572.29, 30.81, 5.29),
        name = 'Freezing Goods'
    },
    [12] = { -- Airport (Near Depot)
        ped = 's_m_m_migrant_01',
        coords = vector4(-863.43, -2717.93, 13.94, 75.09),
        name = 'Alcoholic\'s Imports'
    },
    [13] = { -- Airport (Near Beannys)
        ped = 's_m_m_migrant_01',
        coords = vector4(-1067.43, -2082.72, 13.29, 298.16),
        name = 'Speciality Goods'
    },
    [14] = { -- Larss & Elbow
        ped = 's_m_m_migrant_01',
        coords = vector4(126.51, -126.47, 54.83, 89.21),
        name = 'Electronic Goods'
    },
    [15] = { -- Illegal Mech Parts
    ped = 'MP_M_WareMech_01',
    coords = vector4(1080.49, -2412.81, 30.17, 266.3),
    name = 'Tuner Parts'
},

}