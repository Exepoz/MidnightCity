Config = Config or {}

Config.Electronics = {
    -- banks
    ['store'] = {item = 'lime_electronics_1',       min = 10, max = 20}, -- 1 bag per heist
    ['fleeca'] = {item = 'green_electronics_2',     min = 10, max = 20, bp = 'lime_hacking',   needed = 'supplier_details',     crumbs = 5000, buy = {c = 200, e = 200}}, -- 3 bags per heist
    ['banktruck'] = {item = 'blue_electronics_3',   min = 10, max = 20, bp = 'green_hacking',  needed = 'blackmail_papers',     crumbs = 5000, buy = {c = 200, e = 200}}, -- 1 bag per heist
    ['paleto'] = {item = 'cyan_electronics_4',      min = 10, max = 20, bp = 'blue_hacking',   needed = 'groupe6case',          crumbs = 5000, buy = {c = 200, e = 200}}, -- 3 bags per heist
    ['paleto2'] = {item = 'yellow_electronics_5',   min = 10, max = 20, bp = 'cyan_hacking',   needed = 'insider_information',  crumbs = 5000, buy = {c = 200, e = 200}}, -- 1 bag ? NEED TO MAK SAFE BAG
    ['vault'] = {item = 'orange_electronics_6',     min = 10, max = 20, bp = 'yellow_hacking', needed = 'money_orders',         crumbs = 5000, buy = {c = 200, e = 200}}, -- ?
    ['vault2'] = {item = 'orange_electronics_6',    min = 10, max = 20, bp = 'orange_hacking', needed = 'trade_secrets',        crumbs = 5000, buy = {c = 200, e = 200}}, -- ?

    -- --art
    -- ['madrazo'] = {item = 'yellow_electronics_1', min = 10, max = 20},
    -- ['vangellico'] = {item = 'yellow_electronics_2', min = 10, max = 20},
    -- ['artvan'] = {item = 'yellow_electronics_3', min = 10, max = 20},
    -- ['artgallery'] = {item = 'yellow_electronics_4', min = 10, max = 20},
    -- ['casino'] = {item = 'yellow_electronics_5', min = 10, max = 20},
} Config.BPOrder = {'store', 'fleeca', 'banktruck', 'paleto', 'paleto2', 'vault', 'vault2'}

Config.HeistEquip = {
    {item = 'drill', i_cost = 200, bp_cost = 9800},
    {item = 'cutter', i_cost = 500, bp_cost = 10700},
    {item = 'thermite', i_cost = 500, bp_cost = 8600},
    {item = 'camera_looper', i_cost = 500, bp_cost = 5500},
}

Config.CrimHub = {
    BHExchangeRate = 500, -- Crumbs received for every Bounty Points Redeemed
    CurrencyExchange = {
        ['cash'] = {
            rec = 1000, -- Amount of cash received
            ['crumbs'] = 500, -- Amount of crumbs to receive `rec`
            ['scoins'] = 25 -- Amount of sCoins to receive `rec`
        },
        ['crumbs'] = {
            rec = 50, -- Amount of crumbs received
            ['cash'] = 1000,  -- Amount of cash to receive `rec`
            ['scoins'] = 1  -- Amount of sCoins to receive `rec`
        },
        ['scoins'] = {
            rec = 5, -- Amount of sCoins received
            ['crumbs'] = 700,  -- Amount of crumbs to receive `rec`
            ['cash'] = 6000  -- Amount of cash to receive `rec`
        },
        moneyBagsRatio = 0.4,
    },
    Vendors = {
        [1] = {
            ped = 'a_m_y_business_02', coords = vector4(-591.02, -1627.87, 33.01, 312.78),
            targetLabel = 'The Blueprint Guy', menuLabel = 'Purchase Heist Equipment',
            icon = 'fas fa-cart-shopping', shopId = 'heistItemsGuy',
            --categories = {'heist_equip', 'heist_equip_bp', 'illegal_electronics', 'illegal_electronics_BP',
            categories = {'heist_equip', 'illegal_electronics',}
        },
        -- [2] = {
        --     ped = 'mp_m_waremech_01', coords = vector4(-584.24, -1619.84, 19.32, 218.64),
        --     targetLabel = 'The Car Guy', menuLabel = 'Purchase Illegal Vehicle Equipment',
        --     icon = 'fas fa-cart-shopping', shopId = 'carItemsGuy',
        --     --categories = {'heist_equip', 'heist_equip_bp', 'illegal_electronics', 'illegal_electronics_BP',
        --     categories = {'racing_items'}
        -- },
    },
    ShopCategories = {
        ['heist_equip'] = {
            label = 'Heist Equipment',
            description = 'Thinking of doing some big crime? I might have some useful stuff for you.',
            items = {
                {item = 'drill', cost = 200},
                {item = 'cutter', cost = 500},
                {item = 'thermite', cost = 500},
                {item = 'camera_looper', cost = 500},
            }
        },
        ['heist_equip_bp'] = {
            label = 'Heist Equipment Blueprints',
            description = 'Good at tinkering? I can sell you some blueprints.',
            items = {
                {item = 'drill', isBP = true, cost = 1000},
                {item = 'cutter', isBP = true, cost = 2500},
                {item = 'thermite', isBP = true, cost = 2500},
                {item = 'camera_looper', isBP = true, cost = 2500},
            }
        },
        ['illegal_electronics'] = {
            label = 'Rare Electronic Devices',
            description = 'Got some electronics? I\'ll sell you some rare devices...',
            items = {
                {item = 'lime_hacking', cost = 200, needed = {{'lime_electronics_1', 200}}},
                {item = 'green_hacking', cost = 200, needed = {{'green_electronics_2', 250}}},
                {item = 'blue_hacking', cost = 200, needed = {{'blue_electronics_3', 300}}},
                {item = 'cyan_hacking', cost = 200, needed = {{'cyan_electronics_4', 350}}},
                {item = 'yellow_hacking', cost = 200, needed = {{'yellow_electronics_5', 400}}},
                {item = 'orange_hacking', cost = 200, needed = {{'orange_electronics_6', 500}}},
            }
        },
        ['illegal_electronics_BP'] = {
            label = 'Rare Devices Blueprints',
            description = 'Got some rare items from your heists? I can sell you some rare blueprints...',
            items = {
                {item = 'lime_hacking', cost = 200, isBP = true, needed = {{'supplier_details', 1}}},
                {item = 'green_hacking', cost = 200,isBP = true,  needed = {{'blackmail_papers', 1}}},
                {item = 'blue_hacking', cost = 200, isBP = true, needed = {{'groupe6case', 1}}},
                {item = 'cyan_hacking', cost = 200, isBP = true, needed = {{'insider_information', 1}}},
                {item = 'yellow_hacking', cost = 200, isBP = true, needed = {{'money_orders', 1}}},
                {item = 'orange_hacking', cost = 200, isBP = true, needed = {{'trade_secrets', 1}}},
            }
        },
        ['racing_items'] = {
            label = 'Illegal Vehicle Items',
            description = 'Think you\'re ready for the big leagues?', -- change this plz lmao (i could hear this being said in a NFS/Fastfurious trailer lol)
            items = {
                {item = 'racingtablet',     cost = 500, },
                {item = 'boostingtablet',   cost = 500, },
                {item = 'hackingdevice',    cost = 200, },
                {item = 'gpshackingdevice', cost = 200, },
                {item = 'harness',          cost = 200, },
                {item = 'noscan',        cost = 200, },
            }
        },
    },
}