Config = {}
Config.DebugPoly = false

Config.ShopOrder = {'ammo', 'protection', 'medical', 'cleanweapon', 'scratchedweapon',}
Config.Shop = {
    -- Ammunation
    ['ammo'] = {
        options = {header = "Ammo", icon = 'ellipsis'},
        items = {
            [1] = {item = "pistol_ammo",  price = 100, stock = 50, loc = 6, max = 100},
            [2] = {item = "smg_ammo",  price = 300, stock = 50, loc = 6, max = 100},
            [3] = {item = "shotgun_ammo",  price = 850, stock = 50, loc = 6, max = 100},
            --[4] = {item = "hunting_ammo",  price = 250, stock = 500, loc = 6, max = 100},
        }
    },
    ['protection'] = {
        options = {header = "Protection", icon = 'shield'},
        items = {
            [1] = {item = "armor",  price = 100, stock = 10, loc = 6, max = 100},
            [2] = {item = "heavyarmor",  price = 1000, stock = 5, loc = 6, max = 100},
            --[4] = {item = "hunting_ammo",  price = 250, stock = 500, loc = 6, max = 100},
        }
    },
    ['cleanweapon'] = {
        options = {header = "Clean Weapons", icon = 'gun'},
        items = {
            [1] = {item = "weapon_pistol",  price = 1300, stock = 10, loc = 6, max = 100},
            [2] = {item = "case_recoil",  price = 25000, stock = 5, loc = 6, max = 100},
        }
    },
    ['scratchedweapon'] = {
        options = {header = "Scratched Weapons", icon = 'gun'},
        -- Add `scratched = true` to all these weapons
        items = {
            [1] = {item = "weapon_pistol",  price = 5700, stock = 15, loc = 6, max = 100, scratched = true},
            --[4] = {item = "hunting_ammo",  price = 250, stock = 500, loc = 6, max = 100},
        }
    },
    ['medical'] = {
        options = {header = "Medical", icon = 'kit-medical'},
        -- Add `scratched = true` to all these weapons
        items = {
            [1] = {item = "bandage",  price = 300, stock = 50, loc = 6, max = 3},
            [2] = {item = "ifaks",  price = 800, stock = 50, loc = 6, max = 3},
            [3] = {item = "speed_injector",  price = 5000, stock = 5, loc = 6, max = 3},
            [4] = {item = "health_injector",  price = 5000, stock = 5, loc = 6, max = 3},
            [5] = {item = "armor_injector",  price = 5000, stock = 5, loc = 6, max = 3},
        }
    },

}

-- @Price : Base price of the item
-- @devStep : Amout in stock needed to deviate the price (Each x amount deviates 1 time.)
-- @devAmount : % from price removed for each x Items items in stock.
-- @removed : Amount of stock removed every *Cron Time* <-- Default is 3 hours in the server.lua
-- @stock : Don't touch, leave it to 0
Config.FenceItems = {
    ['vpn'] = {price = 30, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['tablet'] = {price = 40, devStep = 5, devAmount = 0.05, removed = 10, stock = 0,},
    ['tenkgoldchain'] = {price = 30, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['goldbar'] = {price = 150, devStep = 5, devAmount = 0.05, removed = 10, stock = 0,},
    ['samsungphone'] = {price = 30, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['monitor'] = {price = 50, devStep = 5, devAmount = 0.05, removed = 10, stock = 0,},
    ['rolex'] = {price = 70, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['laptop'] = {price = 50, devStep = 5, devAmount = 0.05, removed = 10, stock = 0,},
    ['captainskull'] = {price = 90, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['watch'] = {price = 30, devStep = 5, devAmount = 0.05, removed = 10, stock = 0,},
    ['toiletry'] = {price = 10, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['toothpaste'] = {price = 10, devStep = 5, devAmount = 0.05, removed = 10, stock = 0,},
    ['shoebox'] = {price = 15, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['dj_deck'] = {price = 70, devStep = 5, devAmount = 0.05, removed = 10, stock = 0,},
    ['earrings'] = {price = 30, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['console'] = {price = 50, devStep = 5, devAmount = 0.05, removed = 10, stock = 0,},
    ['hairdryer'] = {price = 30, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['soap'] = {price = 5, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['iphone'] = {price = 40, devStep = 5, devAmount = 0.05, removed = 10, stock = 0,},
    ['diamond_ring'] = {price = 30, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['coffeemaker'] = {price = 20, devStep = 5, devAmount = 0.05, removed = 10, stock = 0,},
    ['romantic_book'] = {price = 12, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['yellow-diamond'] = {price = 50, devStep = 5, devAmount = 0.05, removed = 10, stock = 0,},
    ['telescope'] = {price = 33, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['microwave'] = {price = 22, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['tv'] = {price = 44, devStep = 5, devAmount = 0.05, removed = 10, stock = 0,},
    ['pencil'] = {price = 2, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['book'] = {price = 12, devStep = 5, devAmount = 0.05, removed = 10, stock = 0,},
    ['skull'] = {price = 21, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['kq_expensive_laptop'] = {price = 33, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['kq_expensive_sneakers'] = {price = 22, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['kq_expensive_bag'] = {price = 44, devStep = 5, devAmount = 0.05, removed = 10, stock = 0,},
    ['kq_expensive_watch'] = {price = 44, devStep = 5, devAmount = 0.05, removed = 10, stock = 0,},
    ['pd_laptop'] = {price = 20, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['pd_necklace'] = {price = 12, devStep = 5, devAmount = 0.05, removed = 10, stock = 0,},
    ['pd_ringset'] = {price = 21, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['pd_watch'] = {price = 21, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['bong'] = {price = 8, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
    ['tapeplayer'] = {price = 21, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
}

-- Price is needed if the item is not in Config.FenceItems OR if you want to override the default 1.5x hot value.
Config.Quests = {
	['vpn'] = {price = 30},
	['lime_electronics_1'] = {price = 100},
	['advancedlockpick'] = {price = 20},
    ['green_electronics_2'] = {price = 120},
    ['supplier_details'] = {price = 80},
    ['blackmail_papers'] = {price = 100},
}

Config.Deliveries = {

}