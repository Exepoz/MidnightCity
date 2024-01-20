Config = Config or {}
Config.Heists = {

    StoreRobbery = {
        label = "Store Robbery",
        ['Money'] = {Amount = {min = 1000, max = 5000}, MoneyInBags = true, BagAmount = {min = 3, max = 5}},
        ['SpecialLoot'] = {chance = 5, item = 'supplier_details', info = {}, amount = 1},
        ['Electronics'] = 'store',
    },

    houseRobbery = {
        label = "House Robbery",
        ['ChanceLoot'] = {
            rolls = {min = 1, max = 2},
            minLoot = 1,
            pool = {
                [1] = {item = "weapon_pistol",         amt = {min = 1, max = 1}, probability = 1/3},
                [2] = {item = "weapon_snspistol",    amt = {min = 1, max = 1}, probability = 1/3},
                [3] = {item = "heroin_readystagetwo",    amt = {min = 2, max = 3}, probability = 1/5},
                [4] = {item = "vicodinbottle",       amt = {min = 1, max = 2}, probability = 1/10},
                [5] = {item = "burnerphone_mat",          amt = {min = 1, max = 1}, probability = 1/7},
            },
        },
    },

    FleecaBankRobbery = { -- 3 bags per heist
        label = "Fleeca Bank Robbery",
        ['ChanceLoot'] = {
            rolls = {min = 2, max = 2},
            minLoot = 1,
            pool = {
                [1] = {item = "diamond_ring", amt = {min = 4, max = 5}, probability = 1/3},
                [2] = {item = "rolex",        amt = {min = 4, max = 5}, probability = 1/3},
                [3] = {item = "goldchain",    amt = {min = 4, max = 5}, probability = 1/3},
                [4] = {item = "10kgoldchain", amt = {min = 4, max = 5}, probability = 1/7},
                [5] = {item = "diamond",      amt = {min = 4, max = 5}, probability = 1/7},
            },
        },
        ['SpecialLoot'] = {chance = 5, item = 'blackmail_papers', info = {}},
        ['Electronics'] = 'fleeca',
    },

    PaletoBankRobbery = {
        label = "Paleto Bank Robbery",
        ['ChanceLoot'] = {
            rolls = {min = 3, max = 3},
            minLoot = 1,
            pool = {
                [1] = {item = "diamond_ring",  amt = {min = 8, max = 12}, probability = 1/3},
                [2] = {item = "rolex",         amt = {min = 8, max = 12}, probability = 1/3},
                [3] = {item = "goldchain",     amt = {min = 8, max = 12}, probability = 1/3},
                [4] = {item = "10kgoldchain",  amt = {min = 8, max = 12}, probability = 1/5},
                [5] = {item = "diamond",       amt = {min = 8, max = 12}, probability = 1/5},
                [6] = {item = "goldbar",       amt = {min = 1, max = 2}, probability = 1/10},
                [7] = {item = "sharp_diamond", amt = {min = 1, max = 2}, probability = 1/15},
            },
        },
        ['Electronics'] = 'paleto',
        ['SpecialLoot'] = {chance = 5, item = 'insider_information', info = {}},
    },

    -- TruckDelivery = {
    --     label = "Parked Armored Truck",
    --     ['Money'] = {Amount = {min = 25000, max = 40000}, MoneyInBags = true, BagAmount = {min = 3, max = 5}},
    --     ['SpecialLoot'] = {chance = 5, item = 'groupe6case', info = {}},
    --     ['Electronics'] = 'banktruck',
    -- },

    SignalTruck = {
        label = "Parked Armored Truck",
        ['Money'] = {Amount = {min = 25000, max = 40000}, MoneyInBags = true, BagAmount = {min = 3, max = 5}},
        --['SpecialLoot'] = {chance = 5, item = 'groupe6case', info = {}},
        ['GuarenteedLoot'] = {
            {item = 'crfleecacard', amount = 1, info = {}}
        },
        --['Electronics'] = 'banktruck',
    },

    RoamingTruck = {
        label = "Roaming Armored Truck",
        ['Money'] = {Amount = {min = 35000, max = 65000}, MoneyInBags = true, BagAmount = {min = 3, max = 5}},
        -- ['SpecialLoot'] = {chance = 40, item = 'crpaleto_keycard'},
        ['ChanceLoot'] = {
             pools = {
                ['groupe6'] = {
                    rolls = {min = 1, max = 1},
                    minLoot = 1,
                    pool = { -- Items received (Rolls = amount of different items someone can get)
                         [1] = {item = "paleto_codes", amt = {min = 1, max = 1}, probability = 1},
                    },
                },
                ['diamond'] = {
                    rolls = {min = 1, max = 1},
                    minLoot = 1,
                    pool = { -- Items received (Rolls = amount of different items someone can get)
                        [1] = {item = "casino_chips", amt = {min = 5000, max = 10000}, probability = 1/10},
                        [2] = {item = "casino_chips", amt = {min = 10000, max = 15000}, probability = 1/5},
                        [3] = {item = "casino_chips", amt = {min = 15000, max = 25000}, probability = 1/7},
                        [4] = {item = "casino_chips", amt = {min = 25000, max = 35000}, probability = 1/15},
                        [5] = {item = "casino_chips", amt = {min = 35000, max = 50000}, probability = 1/30},
                        [6] = {item = "casino_chips", amt = {min = 50000, max = 75000}, probability = 1/50},
                        [7] = {item = "diamond", amt = {min = 10, max = 20}, probability = 1/7},
                        [8] = {item = "diamond", amt = {min = 20, max = 30}, probability = 1/15},
                        [9] = {item = "yellow-diamond", amt = {min = 5, max = 10}, probability = 1/15},
                        [10] = {item = "casino_diamonds", amt = {min = 1, max = 1}, probability = 1/10},
                    },
                },
                ['lockloaded'] = {
                    rolls = {min = 1, max = 5},
                    minLoot = 3,
                    pool = { -- Items received (Rolls = amount of different items someone can get)
                        [1] = {item = "weapon_dp9", amt = {min = 1, max = 1}, probability = 1/20},
                        [2] = {item = "weapon_g19x", amt = {min = 1, max = 1}, probability = 1/20},
                        [3] = {item = "weapon_browning", amt = {min = 1, max = 1}, probability = 1/20},
                        [4] = {item = "weapon_m45A1fm", amt = {min = 1, max = 1}, probability = 1/20},
                        [5] = {item = "weapon_gs", amt = {min = 1, max = 1}, probability = 1/20},
                        [6] = {item = "weapon_tglock", amt = {min = 1, max = 1}, probability = 1/20},
                        [7] = {item = "weapon_pmr", amt = {min = 1, max = 1}, probability = 1/20},
                        [8] = {item = "weapon_sp320", amt = {min = 1, max = 1}, probability = 1/50},
                        [9] = {item = "weapon_de", amt = {min = 1, max = 1}, probability = 1/50},
                    },
                },
             },
         },
    },

    MearryweatherTrucks = {
        label = "Merryweather Truck",
        ['Money'] = {Amount = {min = 25000, max = 30000}, MoneyInBags = true, BagAmount = {min = 3, max = 5}},
        ['SpecialLoot'] = {chance = 10, item = 'bobcat_codes'},
        -- ['GuarenteedLoot'] = {
        --     {item = '', amount = 1}
        -- },
        ['ChanceLoot'] = {
            rolls = {min = 1, max = 3},
            pool = {
            [1] = {item = "bp_groza", amt = {min = 1, max = 1}, probability = 1/100},
            [2] = {item = "m9_barrel", amt = {min = 1, max = 3}, probability = 1/50},
            [3] = {item = "m9_slide", amt = {min = 1, max = 3}, probability = 1/75},
            [4] = {item = "m9_body", amt = {min = 1, max = 3}, probability = 1/75},
            [5] = {item = "m45_barrel", amt = {min = 1, max = 3}, probability = 1/5},
            [6] = {item = "m45_mag", amt = {min = 1, max = 3}, probability = 1/50},
            [7] = {item = "m45_slide", amt = {min = 1, max = 3}, probability = 1/25},
            [8] = {item = "bp_uzi", amt = {min = 1, max = 3}, probability = 1/300},
            [9] = {item = "weapon_uzi", amt = {min = 1, max = 3}, probability = 1/450},
            [10] = {item = "weapon_mac10", amt = {min = 1, max = 3}, probability = 1/500},
          },
        },
    },

    bobcat = {
        label = "Bobcat Robbery",
        --['Money'] = {Amount = {min = 25000, max = 30000}, MoneyInBags = true, BagAmount = {min = 3, max = 5}},
        ['SpecialLoot'] = {chance = 10, item = 'weapon_mossberg'},
        ['ChanceLoot'] = {
            pools = {
                ['ammo'] = {
                    rolls = {min = 1, max = 6},
                    minLoot = 4,
                    pool = { -- Items received (Rolls = amount of different items someone can get)
                        [1] = {item = "pistol_ammo", amt = {min = 4, max = 8}, probability = 1/5},
                        [2] = {item = "smg_ammo", amt = {min = 4, max = 8}, probability = 1/10},
                        [3] = {item = "shotgun_ammo", amt = {min = 4, max = 9}, probability = 1/15},
                        [4] = {item = "rifle_ammo", amt = {min = 5, max = 7}, probability = 1/20},
                    },
                },
                ['explosives'] = {
                   rolls = {min = 1, max = 6},
                   minLoot = 4,
                   pool = { -- Items received (Rolls = amount of different items someone can get)
                       [1] = {item = "thermite", amt = {min = 2, max = 3}, probability = 1/10},
                       [2] = {item = "c4_bomb", amt = {min = 1, max = 3}, probability = 1/25},
                       [3] = {item = "weapon_stickybomb", amt = {min = 1, max = 3}, probability = 1/50},
                       [4] = {item = "heavyarmor", amt = {min = 1, max = 4}, probability = 1/10},
                       [5] = {item = "weapon_molotov", amt = {min = 2, max = 4}, probability = 1/25},
                       [6] = {item = "nightvision", amt = {min = 1, max = 2}, probability = 1/50},
                   },
                },
                ['rifles'] = {
                   rolls = {min = 1, max = 3},
                   minLoot = 2,
                   pool = { -- Items received (Rolls = amount of different items someone can get)
                    [1] = {item = "weapon_mac10", amt = {min = 1, max = 1}, probability = 1/15},
                    [2] = {item = "weapon_l1a1", amt = {min = 1, max = 1}, probability = 1/15},
                    [3] = {item = "weapon_tuzi", amt = {min = 1, max = 1}, probability = 1/15},
                    [4] = {item = "weapon_p90", amt = {min = 1, max = 1}, probability = 1/15},
                    [5] = {item = "weapon_ak47", amt = {min = 1, max = 1}, probability = 1/15},
                    [6] = {item = "weapon_mcx", amt = {min = 1, max = 1}, probability = 1/40},
                    [7] = {item = "weapon_ia2", amt = {min = 1, max = 1}, probability = 1/50},
                    [8] = {item = "weapon_552", amt = {min = 1, max = 1}, probability = 1/90},
                    [9] = {item = "weapon_ddm4v7", amt = {min = 1, max = 1}, probability = 1/90},
                   },
                },
                ['smgs'] = {
                    rolls = {min = 1, max = 5},
                    minLoot = 3,
                    pool = { -- Items received (Rolls = amount of different items someone can get)
                        [1] = {item = "weapon_dp9", amt = {min = 1, max = 1}, probability = 1/20},
                        [2] = {item = "weapon_g19x", amt = {min = 1, max = 1}, probability = 1/20},
                        [3] = {item = "weapon_browning", amt = {min = 1, max = 1}, probability = 1/20},
                        [4] = {item = "weapon_m45A1fm", amt = {min = 1, max = 1}, probability = 1/20},
                        [5] = {item = "weapon_gs", amt = {min = 1, max = 1}, probability = 1/20},
                        [6] = {item = "weapon_tglock", amt = {min = 1, max = 1}, probability = 1/20},
                        [7] = {item = "weapon_pmr", amt = {min = 1, max = 1}, probability = 1/20},
                        [8] = {item = "weapon_sp320", amt = {min = 1, max = 1}, probability = 1/50},
                        [9] = {item = "weapon_de", amt = {min = 1, max = 1}, probability = 1/50},
                    },
                },
        },
    },
},

    UnderwaterDive = {
        label = "Underwater Dive",
        ['ChanceLoot'] = {
            rolls = {min = 6, max = 12},
            minLoot = 4,
            pool = {
                [1] = {item = "uzi_reciever", amt = {min = 1, max = 3}, probability = 1/75},
                [2] = {item = "ironsight", amt = {min = 1, max = 2}, probability = 1/15},
                [3] = {item = "m10_mag", amt = {min = 1, max = 3}, probability = 1/48},
                [4] = {item = "m10_barrel", amt = {min = 1, max = 2}, probability = 1/50},
                [5] = {item = "m10_reciever", amt = {min = 1, max = 2}, probability = 1/35},
                [6] = {item = "m10_stock", amt = {min = 1, max = 3}, probability = 1/45},
                [7] = {item = "m45_slide", amt = {min = 1, max = 2}, probability = 1/30},
                [8] = {item = "m45_body", amt = {min = 1, max = 3}, probability = 1/25},
                [9] = {item = "draco_body", amt = {min = 1, max = 2}, probability = 1/35},
                [10] = {item = "draco_reciever", amt = {min = 1, max = 3}, probability = 1/35},
                [11] = {item = "draco_mag", amt = {min = 1, max = 3}, probability = 1/35},
                [12] = {item = "m9_barrel", amt = {min = 1, max = 3}, probability = 1/25},
          },
        },
    },

    oilrig = {
        label = "Oil Rig",
        ['Money'] = {Amount = {min = 25000, max = 30000}, MoneyInBags = true, BagAmount = {min = 3, max = 5}},
        ['SpecialLoot'] = {chance = 20, item = 'casino_hdd2'},
        ['ChanceLoot'] = {
            rolls = {min = 1, max = 3},
            pool = {
            {[1] = {item = "diamond", amt = {min = 1, max = 3}, probability = 1/5},},
          },
        },
    },
}

Config.Blueprints = {
    ['bpcase_pistols'] = {
        lab = 'Pistols',
        pool = {
            [1] = {item = "weapon_dp9",         probability = 1/3},
            [2] = {item = "weapon_browning",    probability = 1/3},
            [3] = {item = "malmocoke_brick",    probability = 1/5},
            [4] = {item = "malmo_laptop",       probability = 1/10},
            [5] = {item = "decrypter",          probability = 1/7},
        }
    }
}

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------


-- TEMPLATE
    -- Example = {
    --     ['Money'] = {Amount = {min = 25000, max = 30000}, MoneyInBags = true, BagAmount = {min = 3, max = 5}},
    --     ['SpecialLoot'] = {chance = 10, item = 'bobcatkeycard', info = {}},
    --     ['GuarenteedLoot'] = {
    --         {item = '', amount = 1, info = {}}
    --     },
    -- EITHER
    --     ['ChanceLoot'] = {
    --         rolls = {min = 1, max = 3},
    --         pool = { -- Items received (Rolls = amount of different items someone can get)
    --         [1] = {item = "diamond", amt = {min = 1, max = 3}, info = {}, probability = 40},
    --       },
    --     },
    --- OR
        -- ['ChanceLoot'] = {
        --      pools = {
        --          ['pool1'] = {
        --              rolls = {min = 1, max = 3},
        --              pool = { -- Items received (Rolls = amount of different items someone can get)
        --                  [1] = {item = "diamond", amt = {min = 1, max = 3}, probability = 1/5},
        --                  [2] = {item = "", amt = {min = 1, max = 3}, probability = 1/5}, -- This is for 'nothing/empty' rolls
        --              },
        --          },
        --      },
        --  },
    -- },
