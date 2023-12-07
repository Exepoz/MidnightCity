Config = {}
Config.DebugPoly = false

Config.Shop = {
    -- Ammunation
    ['ammo'] = {
        options = {header = "Ammo", icon = 'ellipsis'},
        items = {
            [1] = {item = "pistol_ammo",  price = 100, stock = 500, loc = 6, max = 100},
            [2] = {item = "smg_ammo",  price = 300, stock = 500, loc = 6, max = 100},
            [3] = {item = "shotgun_ammo",  price = 250, stock = 500, loc = 6, max = 100},
            --[4] = {item = "hunting_ammo",  price = 250, stock = 500, loc = 6, max = 100},
        }
    },
}

-- @Price : Base price of the item
-- @devStep : Amout in stock needed to deviate the price (Each x amount deviates 1 time.)
-- @devAmount : % from price removed for each x Items items in stock.
-- @removed : Amount of stock removed every *Cron Time* <-- Default is 3 hours in the server.lua
-- @stock : Don't touch, leave it to 0
Config.FenceItems = {
    ['phone'] = {price = 50, devStep = 5, devAmount = 0.05, removed = 10, stock = 0,},
    ['vpn'] = {price = 30, devStep = 3, devAmount = 0.03, removed = 10, stock = 0,},
}

-- Price is needed if the item is not in Config.FenceItems OR if you want to override the default 1.5x hot value.
Config.Quests = {
	['tosti'] = {price = 50},
	['water_bottle'] = {price = 50},
	['phone'] = {},
}

Config.Deliveries = {
    
}