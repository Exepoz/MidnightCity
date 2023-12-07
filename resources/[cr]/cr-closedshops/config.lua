Config = {}

Config.Framework = {
    Notifications = 'QBCore',
    -- 'QBCore' = QBCoreNotify
    Logs = false, -- Currrently setup via QBCore Logs
    -- True = Logs Enabled
    -- False = Logs Disabled
    Debug = false,
    -- true = Poly's & Prints Enabled
    -- false = Poly's & Prints Disabled
}

Config.ClosedShops = {
    -- Template in the README
    ['digitalDen'] = {
        System = { SystemName = "digitalDen", JobNames = {"digitalden"}, ShopType = "ped",  coords = vector4(1133.36, -469.88, 66.72, 245.73)},
        PED = { Model = 'u_m_y_guido_01', Name = 'Andy', Scenario = "WORLD_HUMAN_STAND_IMPATIENT"},
        Prop = { Model = 'prop_vend_snak_01_tu'},
        Blip = { Enabled = false, Label = "SystemName", Coords = vector4(1133.36, -469.88, 66.72, 245.73), Sprite = 647,  Display = 4,  Scale = 0.5, Colour = 7},
        Shop = {
            label = "Digital Den's Shop",
            BankAccount = "digitalden",
            items = {
                [1] = { -- Slot #
                    name = 'classic_phone', price = 1000, -- Item's Price
                    info = {}, -- Item's Info (If Setup)
                    limit = 5 -- Amount that can be purchased by a single person per hour
                },
                [2] = { -- Slot #
                    name = 'radio',  price = 1000, -- Item's Price
                    info = {}, -- Item's Info (If Setup)
                    limit = 10 -- Amount that can be purchased by a single person per hour
                },
                -- [3] = {
                --     name = 'phone_module', price = 500,
                --     info = {},
                --     limit = 10
                -- },
                -- [4] = {
                --     name = 'sdcard', price = 20,
                --     info = {},
                --     limit = 10
                -- },
            }
        }
    },
    -- ['burgershot'] = {
    --     System = {
    --         SystemName = "Burgershot",
    --         JobNames = {"burgershot"},
    --         ShopType = "ped",
    --         coords = vector4(-1182.0186, -883.1359, 13.7921, 302.2321),
    --     },
    --     PED = {
    --         Model = 's_m_m_linecook',
    --         Name = 'Mino',
    --         Scenario = "WORLD_HUMAN_STAND_IMPATIENT",
    --     },
    --     Blip = {
    --         Enabled = true,
    --         Label = "Burgershot",
    --         Coords = vector4(-1182.0186, -883.1359, 13.7921, 302.2321),
    --         Sprite = 628,
    --         Display = 6,
    --         Scale = 0.5,
    --         Colour = 35,
    --     },
    --     Shop = {
    --         label = "Burgershot's Closed Shop",
    --         items = {
    --             [1] = { name = "shotnuggets", price = 8, info = {}, limit = 5 },
    --             [2] = { name = "shotrings", price = 6, info = {}, limit = 5 },
    --             [3] = { name = "shotfries", price = 5, info = {}, limit = 5 },
    --             [4] = { name = "heartstopper", price = 12, info = {}, limit = 5 },
    --             [5] = { name = "moneyshot", price = 11, info = {}, limit = 5 },
    --             [6] = { name = "meatfree", price = 9, info = {}, limit = 5 },
    --             [7] = { name = "bleeder", price = 10, info = {}, limit = 5 },
    --             [8] = { name = "rimjob", price = 8, info = {}, limit = 5 },
    --             [9] = { name = "torpedo", price = 9, info = {}, limit = 5 },
    --             [10] = { name = "creampie", price = 8, info = {}, limit = 5 },
    --             [11] = { name = "chickenwrap", price = 7, info = {}, limit = 5 },
    --             [12] = { name = "cheesewrap", price = 6, info = {}, limit = 5 },
    --             [13] = { name = "milkshake", price = 10, info = {}, limit = 5 },
    --             [14] = { name = "bscoffee", price = 8, info = {}, limit = 5 },
    --             [15] = { name = "bscoke", price = 6, info = {}, limit = 5 },
    --         }
    --     }
    -- },
    ['catcafe'] = {
        System = {
            SystemName = "catcafe",
            JobNames = {"catcafe"},
            ShopType = "ped",
            coords = vector4(-531.25, -1220.59, 18.45, 341.23),
        },
        PED = {
            Model = 's_m_m_linecook',
            Name = 'Timmy',
            Scenario = "WORLD_HUMAN_STAND_IMPATIENT",
        },
        Blip = {
            Enabled = true,
            Label = "uWu To Go!",
            Coords = vector4(-531.25, -1220.59, 18.45, 341.23),
            Sprite = 628,
            Display = 6,
            Scale = 0.5,
            Colour = 8,
        },
        Shop = {
            label = "uWu To Go!",
            BankAccount = 'catcafe',
            items = {
                [1] = { name = "ramen", price = 250, info = {}, limit = 5 },
                [2] = { name = "purrito", price = 250, info = {}, limit = 5 },
                [3] = { name = "nekocookie", price = 175, info = {}, limit = 5 },
                [4] = { name = "nekodonut", price = 175, info = {}, limit = 5 },
                [5] = { name = "obobatea", price = 175, info = {}, limit = 5 },
                [6] = { name = "mocha", price = 175, info = {}, limit = 5 },
            }
        }
    },
    -- ['pizzathis'] = {
    --     System = {
    --         SystemName = "pizzathis",
    --         JobNames = {"pizzathis"},
    --         ShopType = "ped",
    --         coords = vector4(793.3285, -758.2808, 26.7728, 88.4662),
    --     },
    --     PED = {
    --         Model = 's_m_m_linecook',
    --         Name = 'Andy',
    --         Scenario = "WORLD_HUMAN_STAND_IMPATIENT",
    --     },
    --     Blip = {
    --         Enabled = true,
    --         Label = "PizzaThis",
    --         Coords = vector4(793.3285, -758.2808, 26.7728, 88.4662),
    --         Sprite = 628,
    --         Display = 6,
    --         Scale = 0.5,
    --         Colour = 49,
    --     },
    --     Shop = {
    --         label = "PizzaThis's Closed Shop",
    --         items = {
    --             [1] = { name = "bolognese", price = 12, info = {}, limit = 5 },
    --             [2] = { name = "calamari", price = 18, info = {}, limit = 5 },
    --             [3] = { name = "meatball", price = 15, info = {}, limit = 5 },
    --             [4] = { name = "alla", price = 9, info = {}, limit = 5 },
    --             [5] = { name = "pescatore", price = 10, info = {}, limit = 5 },
    --             [6] = { name = "medfruits", price = 8, info = {}, limit = 5 },
    --             [7] = { name = "rosso", price = 15, info = {}, limit = 5 },
    --             [8] = { name = "housewhite", price = 15, info = {}, limit = 5 },
    --             [9] = { name = "housered", price = 15, info = {}, limit = 5 },
    --             [10] = { name = "dolceto", price = 15, info = {}, limit = 5 },
    --             [11] = { name = "barbera", price = 15, info = {}, limit = 5 },
    --             [12] = { name = "amarone", price = 15, info = {}, limit = 5 },
    --             [13] = { name = "vegetariana", price = 15, info = {}, limit = 5 },
    --             [14] = { name = "prosciuttio", price = 15, info = {}, limit = 5 },
    --             [15] = { name = "margherita", price = 15, info = {}, limit = 5 },
    --             [16] = { name = "marinara", price = 15, info = {}, limit = 5 },
    --             [17] = { name = "diavola", price = 15, info = {}, limit = 5 },
    --             [18] = { name = "capricciosa", price = 15, info = {}, limit = 5 },
    --         }
    --     }
    -- },
    -- ['vanillaunicorn'] = {
    --     System = {
    --         SystemName = "vanillaunicorn",
    --         JobNames = {"vu"},
    --         ShopType = "ped",
    --         coords = vector4(129.5623, -1299.7252, 29.2327, 204.8498),
    --     },
    --     PED = {
    --         Model = 's_m_m_linecook',
    --         Name = 'Myles',
    --         Scenario = "WORLD_HUMAN_STAND_IMPATIENT",
    --     },
    --     Blip = {
    --         Enabled = true,
    --         Label = "VanillaUnicorn",
    --         Coords = vector4(129.5623, -1299.7252, 29.2327, 204.8498),
    --         Sprite = 628,
    --         Display = 6,
    --         Scale = 0.5,
    --         Colour = 7,
    --     },
    --     Shop = {
    --         label = "VanillaUnicorn's Closed Shop",
    --         items = {
    --             [1] = { name = "crisps", price = 5, info = {}, limit = 5 },
    --             [2] = { name = "vusliders", price = 10, info = {}, limit = 5 },
    --             [3] = { name = "vutacos", price = 12, info = {}, limit = 5 },
    --             [4] = { name = "tots", price = 7, info = {}, limit = 5 },
    --             [5] = { name = "dusche", price = 20, info = {}, limit = 5 },
    --             [6] = { name = "pisswasser3", price = 18, info = {}, limit = 5 },
    --             [7] = { name = "pisswasser2", price = 16, info = {}, limit = 5 },
    --         }
    --     }
    -- },
    -- ['whitewidow'] = {
    --     System = {
    --         SystemName = "whitewidow",
    --         JobNames = {"weedshop"},
    --         ShopType = "ped",
    --         coords = vector4(202.5010, -239.0545, 53.9683, 288.3420),
    --     },
    --     PED = {
    --         Model = 's_m_m_linecook',
    --         Name = 'Jacob',
    --         Scenario = "WORLD_HUMAN_STAND_IMPATIENT",
    --     },
    --     Blip = {
    --         Enabled = true,
    --         Label = "WhiteWidow",
    --         Coords = vector4(202.5010, -239.0545, 53.9683, 288.3420),
    --         Sprite = 628,
    --         Display = 6,
    --         Scale = 0.5,
    --         Colour = 2,
    --     },
    --     Shop = {
    --         label = "WhiteWidow's Closed Shop",
    --         items = {
    --             [1] = { name = "weapon_poolcue", price = 95, info = {}, limit = 1 },
    --             [2] = { name = "hybridjoint", price = 165, info = {}, limit = 3 },
    --             [3] = { name = "blunt", price = 185, info = {}, limit = 3 },
    --             [4] = { name = "cigar", price = 300, info = {}, limit = 3 },
    --             [5] = { name = "weed_nutrition", price = 150, info = {}, limit = 5 },
    --             [6] = { name = "weed_insecticide", price = 175, info = {}, limit = 5 },
    --             [7] = { name = "alkaline_bottle", price = 125, info = {}, limit = 5 },
    --             [8] = { name = "acid_bottle", price = 150, info = {}, limit = 5 },
    --             [9] = { name = "empty_weed_bag", price = 2, info = {}, limit = 50 },
    --             [10] = { name = "rolling_paper", price = 3, info = {}, limit = 25 },
    --             [11] = { name = "blunt_paper", price = 5, info = {}, limit = 15 },
    --             [12] = { name = "cigarwrap", price = 6, info = {}, limit = 10 },
    --         }
    --     }
    -- },
    -- ['yellowjack'] = {
    --     System = {
    --         SystemName = "yellowjack",
    --         JobNames = {"yellowjack"},
    --         ShopType = "ped",
    --         coords = vector4(1990.8673, 3053.9331, 47.2150, 325.1093),
    --     },
    --     PED = {
    --         Model = 's_m_m_linecook',
    --         Name = 'Mayers',
    --         Scenario = "WORLD_HUMAN_STAND_IMPATIENT",
    --     },
    --     Blip = {
    --         Enabled = true,
    --         Label = "YellowJack",
    --         Coords = vector4(1990.8673, 3053.9331, 47.2150, 325.1093),
    --         Sprite = 628,
    --         Display = 6,
    --         Scale = 0.5,
    --         Colour = 5,
    --     },
    --     Shop = {
    --         label = "YellowJack's Closed Shop",
    --         items = {
    --             [1] = { name = "cheesynachos", price = 5, info = {}, limit = 5 },
    --             [2] = { name = "yellowjackburger", price = 8, info = {}, limit = 5 },
    --             [3] = { name = "yellowjackrum", price = 18, info = {}, limit = 3 },
    --             [4] = { name = "fourbikers", price = 12, info = {}, limit = 8 },
    --             [5] = { name = "crashdummy", price = 12, info = {}, limit = 8 },
    --             [6] = { name = "tittyshow", price = 12, info = {}, limit = 8 },
    --         }
    --     }
    -- }
}
