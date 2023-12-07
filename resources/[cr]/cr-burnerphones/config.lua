Config = {}
-- Locales System Inspired by Code Design.
function Lcl(txt, ...) if BurnerPhonesLocales[txt] then return string.format(BurnerPhonesLocales[txt], ...) else print('Locale Error, Contact Server Admin. ('..txt..')') end end

Config.Framework = {
    Framework = "QBCore", --"QBCore" | "ESX"
    Interaction = {
        UseTarget = GetConvar('UseTarget', 'false') == 'true', -- Leave true if you are using qb-target. Set to false to disable targetting and enable DrawText for all interactions
        Target = "qb-target", -- "qb-target" | "oxtarget" | "meta-target"
        OxLibDistanceCheck = false -- If true, most distance checks are done via oxlib, if false distance checks are done via built-in functions.
    },
    --Framework Overrides (You can change specific framework related functions to ones from other scripts.)
    UseOxInv = false, -- For ESX and QBCore. Lets ESX users utilize the battery usage configuration (Uses Item Metadata).
    Notifications = "qb", -- "okok" | "mythic" | "tnj" | "oxlib" | "qb" | "ESX" | "chat" | NEEDS TO BE SPECIFIED
    ProgressUI = "", -- "oxlib" | "mythic" | "rprogress" (Custom Settings at the bottom) |  Otherwise leave blank ("") to use Framework Settings.
    DrawText = "", -- "oxlib" | "okok" | "psui" | Otherwise leave blank ("") to use Framework Settings.
}

--General Config.
Config.DevMode = false -- Set to 'true' if you are Testing the Resource (Resets local cooldowns and other StateBags)
Config.Debug = false -- Prints Debug Lines in the console
Config.Logs = true -- True = Logs Enabled | False = Logs Disabled
Config.InteractKey = "G" -- Key to press when interacting with things (Default : G | See Config.KeyList to know which string to change this value to.)

-- VPN Item (Stops police from being called if option enabled)
Config.VPNItem = "vpn" -- Item used for the VPN (If not wanting to use the provided VPN)

-- Tsunami Specific Configurations
Config.ServerStartCooldown = true -- true = Cooldown Enabled On Server Start | false = Cooldown Disabled On Server Start
Config.ServerStartCooldownTime = 15 -- Server Start Specific Cooldown (Time Is In Minutes | Cooldown is GLOBAL)

--Police & Dispatch Settings
Config.Police = {
    PoliceJobs = {"police"}, -- Name of the police jobs| Can support multiple jobs
    Dispatch = "ps-dispatch", -- "qb-policejob" = qb-policeJob | "cd" = Code Design's Dispatch | "core" = Core Dispatch | "ESX" = ESX
    CallCopsChance = 100, --Chance for the police to be called when using a burnerphone without a VPN.
    TenCode = "911", -- 10-code used for the robbery call (CD Dispatch + Core Dispatch)
}

-- Cooldown Configuration
Config.CooldownTime = 20 --Time in minutes to place a call (if Config.SharedCooldown = true)
Config.LocalCooldown = true -- When true, the cooldown is unique to the player who orders. (Multiple people can order at the same time)
Config.SharedCooldown = true -- All Types of burnerphone share the same cooldown. (Works both for local and global cooldowns)

Config.MinWait = 30 --Min Wait Time before receiving the drop location after ordering an item (Seconds)
Config.MaxWait = 60 --Max Wait Time before receiving the drop location after ordering an item (Seconds)

-- Phone Battery Configuration
Config.Battery = {
    BatteryType = "uses", -- "chance" = Phones has a random chance to die everytime it's used | "uses" = (FOR QBCORE OR OXINV ONLY) Phone has a predetermined amount of uses
    UseBatteryWhenCooldownActive = false -- When true, uses phone battery even if the cooldown is active.
}

Config.Burnerphones = {
    ['burnerphone_wep'] = { -- Item used to call
        CallCops = true, -- When true, has a chance to call cops when ordering with this phone
        CopsNeeded = 1, -- Cops needed to be on duty to be able to order from this phone
        VPNEnabled = false, -- Set true if you want the VPN Item to work with this phone, disabling the cop call.

        BreakChance = 50, -- if BatteryType == "chance, chance of the phone breaking after using it (is a %)
        Uses = {min = 3, max = 5}, -- if BatteryType == "uses", number of uses the phone can have before breaking.
        CooldownTime = 20, -- Cooldown time for this specific phone

        DropOffLocations = {
            --You can add as many pickup locations as you want.
            vector3(-2176.83, 4275.75, 49.1),
            vector3(-1472.19, -150.21, 48.82),
            vector3(167.96, 2231.09, 90.79),
            vector3(-567.95, 5244.17, 70.47),
            -- vector3(2541.52, 2596.85, 37.94),
            vector3(2545.1, 364.02, 108.61),
            vector3(501.39, -656.02, 24.75),
            vector3(-543.51, 1983.62, 127.03),
            vector3(412.84, -339.29, 46.99),
            vector3(-310.73, 2793.12, 59.48),
            vector3(2288.1, 2074.51, 122.89),
            vector3(2408.68, 3031.7, 48.15),
            vector3(1522.48, 3917.22, 31.67),
            vector3(3336.16, 5164.48, 18.3),
            vector3(2913.33, 4293.5, 50.41),
            vector3(2511.7, 3777.37, 52.97),
            vector3(523.5, 200.99, 104.74),
            vector3(-40.91, 369.07, 112.43),
            vector3(-621.11, 326.89, 82.26),
            vector3(-895.29, -777.94, 15.91),
            vector3(-849.56, -1102.94, 2.16),
            vector3(1138.34, -2344.15, 31.35),
            vector3(1455.27, -1662.46, 66.06),
            vector3(1113.07, -647.58, 56.82),
            vector3(-859.9, -354.12, 38.68)
        },
        Rewards = {
            [1] = {item = 'm9_mag',          qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [2] = {item = 'm9_barrel',         qty = {min = 1, max = 1}, weight = 50, prop = "ba_prop_battle_bag_01b", emote = "mechanic4"},
            [3] = {item = 'm9_slide',         qty = {min = 1, max = 1}, weight = 50, prop = "ba_prop_battle_bag_01b", emote = "mechanic4"},
            [4] = {item = 'm9_body',         qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [5] = {item = 'm45_barrel',      qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [6] = {item = 'm45_mag',        qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [7] = {item = 'm45_slide',       qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [8] = {item = 'm45_body',     qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [9] = {item = 'g18_mag',        qty = {min = 1, max = 1}, weight = 25, prop = "prop_cs_package_01", emote = "mechanic4"},
            [10] = {item = 'g18_barrel', qty = {min = 1, max = 1}, weight = 25, prop = "ba_prop_battle_bag_01b", emote = "mechanic4"},
            [11] = {item = 'g18_slide',        qty = {min = 1, max = 1}, weight = 40, prop = "ba_prop_battle_bag_01b", emote = "mechanic4"},
            [12] = {item = 'g18_body',          qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [13] = {item = 'g18_switch',          qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [14] = {item = 'uzi_mag',             qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [15] = {item = 'uzi_barrel',        qty = {min = 1, max = 1}, weight = 25, prop = "prop_cs_package_01", emote = "mechanic4"},
            [16] = {item = 'uzi_reciever', qty = {min = 1, max = 1}, weight = 25, prop = "ba_prop_battle_bag_01b", emote = "mechanic4"},
            [17] = {item = 'm10_mag',        qty = {min = 1, max = 1}, weight = 40, prop = "ba_prop_battle_bag_01b", emote = "mechanic4"},
            [18] = {item = 'm10_barrel',          qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [19] = {item = 'm10_reciever',          qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [20] = {item = 'm10_stock',             qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [21] = {item = 'ironsight',             qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [22] = {item = 'bp_m9',             qty = {min = 1, max = 1}, weight = 20, prop = "prop_cs_package_01", emote = "mechanic4"},
            [23] = {item = 'bp_m45',             qty = {min = 1, max = 1}, weight = 20, prop = "prop_cs_package_01", emote = "mechanic4"},
            [24] = {item = 'bp_g18',             qty = {min = 1, max = 1}, weight = 20, prop = "prop_cs_package_01", emote = "mechanic4"},
            [25] = {item = 'bp_uzi',             qty = {min = 1, max = 1}, weight = 20, prop = "prop_cs_package_01", emote = "mechanic4"},
            [26] = {item = 'bp_m10',             qty = {min = 1, max = 1}, weight = 20, prop = "prop_cs_package_01", emote = "mechanic4"},

        }
    },
    ['burnerphone_mat'] = {
        CallCops = true,
        CopsNeeded = 1,
        VPNEnabled = true,

        BreakChance = 50,
        Uses = {min = 2, max = 3},
        CooldownTime = 20,

        DropOffLocations = {
            --You can add as many pickup locations as you want.
            vector3(-2176.83, 4275.75, 49.1),
            vector3(-1472.19, -150.21, 48.82),
            vector3(167.96, 2231.09, 90.79),
            vector3(-567.95, 5244.17, 70.47),
            -- vector3(2541.52, 2596.85, 37.94),
            vector3(2545.1, 364.02, 108.61),
            vector3(501.39, -656.02, 24.75),
            vector3(-543.51, 1983.62, 127.03),
            vector3(412.84, -339.29, 46.99),
            vector3(-310.73, 2793.12, 59.48),
            vector3(2288.1, 2074.51, 122.89),
            vector3(2408.68, 3031.7, 48.15),
            vector3(1522.48, 3917.22, 31.67),
            vector3(3336.16, 5164.48, 18.3),
            vector3(2913.33, 4293.5, 50.41),
            vector3(2511.7, 3777.37, 52.97),
            vector3(523.5, 200.99, 104.74),
            vector3(-40.91, 369.07, 112.43),
            vector3(-621.11, 326.89, 82.26),
            vector3(-895.29, -777.94, 15.91),
            vector3(-849.56, -1102.94, 2.16),
            vector3(1138.34, -2344.15, 31.35),
            vector3(1455.27, -1662.46, 66.06),
            vector3(1113.07, -647.58, 56.82),
            vector3(-859.9, -354.12, 38.68)
        },
        Rewards = {
            [1] = {item = 'plastic',        qty = {min = 10, max = 25}, weight = 60, prop = "v_serv_abox_1", emote = "mechanic4"},
            [2] = {item = 'plastic',        qty = {min = 25, max = 75}, weight = 50, prop = "v_serv_abox_1", emote = "mechanic4"},
            [3] = {item = 'plastic',        qty = {min = 100, max = 150}, weight = 40, prop = "v_serv_abox_1", emote = "mechanic4"},
            [4] = {item = 'metalscrap',     qty = {min = 10, max = 25}, weight = 60, prop = "v_serv_abox_1", emote = "mechanic4"},
            [5] = {item = 'metalscrap',     qty = {min = 25, max = 75}, weight = 50, prop = "v_serv_abox_1", emote = "mechanic4"},
            [6] = {item = 'metalscrap',     qty = {min = 100, max = 150}, weight = 40, prop = "v_serv_abox_1", emote = "mechanic4"},
            [7] = {item = 'copper',         qty = {min = 10, max = 25}, weight = 60, prop = "v_serv_abox_1", emote = "mechanic4"},
            [8] = {item = 'copper',         qty = {min = 25, max = 75}, weight = 50, prop = "v_serv_abox_1", emote = "mechanic4"},
            [9] = {item = 'copper',         qty = {min = 100, max = 150}, weight = 40, prop = "v_serv_abox_1", emote = "mechanic4"},
            [10] = {item = 'aluminum',      qty = {min = 10, max = 25}, weight = 60, prop = "v_serv_abox_1", emote = "mechanic4"},
            [11] = {item = 'aluminum',      qty = {min = 25, max = 75}, weight = 50, prop = "v_serv_abox_1", emote = "mechanic4"},
            [12] = {item = 'aluminum',      qty = {min = 100, max = 150}, weight = 40, prop = "v_serv_abox_1", emote = "mechanic4"},
            [13] = {item = 'iron',          qty = {min = 10, max = 25}, weight = 60, prop = "v_serv_abox_1", emote = "mechanic4"},
            [14] = {item = 'iron',          qty = {min = 25, max = 75}, weight = 50, prop = "v_serv_abox_1", emote = "mechanic4"},
            [15] = {item = 'iron',          qty = {min = 100, max = 150}, weight = 40, prop = "v_serv_abox_1", emote = "mechanic4"},
            [16] = {item = 'steel',         qty = {min = 10, max = 25}, weight = 60, prop = "v_serv_abox_1", emote = "mechanic4"},
            [17] = {item = 'steel',         qty = {min = 25, max = 75}, weight = 50, prop = "v_serv_abox_1", emote = "mechanic4"},
            [18] = {item = 'steel',         qty = {min = 100, max = 150}, weight = 40, prop = "v_serv_abox_1", emote = "mechanic4"},
            [19] = {item = 'rubber',        qty = {min = 10, max = 25}, weight = 60, prop = "v_serv_abox_1", emote = "mechanic4"},
            [20] = {item = 'rubber',        qty = {min = 25, max = 75}, weight = 50, prop = "v_serv_abox_1", emote = "mechanic4"},
            [21] = {item = 'rubber',        qty = {min = 100, max = 150}, weight = 40, prop = "v_serv_abox_1", emote = "mechanic4"},
            [22] = {item = 'glass',         qty = {min = 10, max = 25}, weight = 60, prop = "v_serv_abox_1", emote = "mechanic4"},
            [23] = {item = 'glass',         qty = {min = 25, max = 75}, weight = 50, prop = "v_serv_abox_1", emote = "mechanic4"},
            [24] = {item = 'glass',         qty = {min = 100, max = 150}, weight = 40, prop = "v_serv_abox_1", emote = "mechanic4"},
            [25] = {item = 'electronics',   qty = {min = 5, max = 20}, weight = 60, prop = "v_serv_abox_1", emote = "mechanic4"},
            [26] = {item = 'electronics',   qty = {min = 20, max = 50}, weight = 50, prop = "v_serv_abox_1", emote = "mechanic4"},
            [27] = {item = 'electronics',   qty = {min = 50, max = 100}, weight = 40, prop = "v_serv_abox_1", emote = "mechanic4"},
        }
    },
    -- ['burnerphone_hei'] = {
    --     CallCops = true,
    --     CopsNeeded = 1,
    --     VPNEnabled = true,

    --     BreakChance = 50,
    --     Uses = {min = 1, max = 1},
    --     CooldownTime = 60,

    --     DropOffLocations = {
    --         --You can add as many pickup locations as you want.
    --         vector3(-2176.83, 4275.75, 49.1),
    --         vector3(-1472.19, -150.21, 48.82),
    --         vector3(167.96, 2231.09, 90.79),
    --         vector3(-567.95, 5244.17, 70.47),
            -- -- vector3(2541.52, 2596.85, 37.94),
    --         vector3(2545.1, 364.02, 108.61),
    --         vector3(501.39, -656.02, 24.75),
    --         vector3(-543.51, 1983.62, 127.03),
    --         vector3(412.84, -339.29, 46.99),
    --         vector3(-310.73, 2793.12, 59.48),
    --         vector3(2288.1, 2074.51, 122.89),
    --         vector3(2408.68, 3031.7, 48.15),
    --         vector3(1522.48, 3917.22, 31.67),
    --         vector3(3336.16, 5164.48, 18.3),
    --         vector3(2913.33, 4293.5, 50.41),
    --         vector3(2511.7, 3777.37, 52.97),
    --         vector3(523.5, 200.99, 104.74),
    --         vector3(-40.91, 369.07, 112.43),
    --         vector3(-621.11, 326.89, 82.26),
    --         vector3(-895.29, -777.94, 15.91),
    --         vector3(-849.56, -1102.94, 2.16),
    --         vector3(1138.34, -2344.15, 31.35),
    --         vector3(1455.27, -1662.46, 66.06),
    --         vector3(1113.07, -647.58, 56.82),
    --         vector3(-859.9, -354.12, 38.68)
    --     },
    --     Rewards = {
    --         [1] = {item = 'lockpick', qty = {min = 10, max = 20}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
    --         [2] = {item = 'electronickit', qty = {min = 1, max = 3}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
    --         [3] = {item = 'drill', qty = {min = 1, max = 1}, weight = 60, prop = "prop_cs_package_01", emote = "mechanic4"},
    --         [4] = {item = 'security_card_01', qty = {min = 1, max = 1}, weight = 60, prop = "prop_cs_package_01", emote = "mechanic4"},
    --         [5] = {item = 'security_card_02', qty = {min = 1, max = 1}, weight = 60, prop = "prop_cs_package_01", emote = "mechanic4"},
    --         [6] = {item = 'security_card_03', qty = {min = 1, max = 1}, weight = 60, prop = "prop_cs_package_01", emote = "mechanic4"},
    --         [7] = {item = 'security_card_04', qty = {min = 1, max = 1}, weight = 60, prop = "prop_cs_package_01", emote = "mechanic4"},
    --         [8] = {item = 'security_card_oil', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
    --         [9] = {item = 'hackingdevice', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
    --         [10] = {item = 'gpshackingdevice', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
    --         [11] = {item = 'data_burnerphone', qty = {min = 1, max = 1}, weight = 40, prop = "prop_cs_package_01", emote = "mechanic4"},
    --         [12] = {item = 'data_fleeca', qty = {min = 1, max = 1}, weight = 60, prop = "prop_cs_package_01", emote = "mechanic4"},
    --         [13] = {item = 'data_paleto', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
    --         [14] = {item = 'data_vault', qty = {min = 1, max = 1}, weight = 40, prop = "prop_cs_package_01", emote = "mechanic4"},
    --         [15] = {item = 'data_banktruck', qty = {min = 1, max = 1}, weight = 60, prop = "prop_cs_package_01", emote = "mechanic4"},
    --         [16] = {item = 'data_bobcat', qty = {min = 1, max = 1}, weight = 40, prop = "prop_cs_package_01", emote = "mechanic4"},
    --         [17] = {item = 'data_oilrig', qty = {min = 1, max = 1}, weight = 35, prop = "prop_cs_package_01", emote = "mechanic4"},
    --         [18] = {item = 'data_jewellery', qty = {min = 1, max = 1}, weight = 60, prop = "prop_cs_package_01", emote = "mechanic4"},
    --     }
    -- },
    ['burnerphone_ran'] = {
        CallCops = true,
        CopsNeeded = 0,
        VPNEnabled = true,

        BreakChance = 50,
        Uses = {min = 1, max = 3},
        CooldownTime = 20,

        DropOffLocations = {
            --You can add as many pickup locations as you want.
            vector3(-2176.83, 4275.75, 49.1),
            vector3(-1472.19, -150.21, 48.82),
            vector3(167.96, 2231.09, 90.79),
            vector3(-567.95, 5244.17, 70.47),
            -- vector3(2541.52, 2596.85, 37.94),
            vector3(2545.1, 364.02, 108.61),
            vector3(501.39, -656.02, 24.75),
            vector3(-543.51, 1983.62, 127.03),
            vector3(412.84, -339.29, 46.99),
            vector3(-310.73, 2793.12, 59.48),
            vector3(2288.1, 2074.51, 122.89),
            vector3(2408.68, 3031.7, 48.15),
            vector3(1522.48, 3917.22, 31.67),
            vector3(3336.16, 5164.48, 18.3),
            vector3(2913.33, 4293.5, 50.41),
            vector3(2511.7, 3777.37, 52.97),
            vector3(523.5, 200.99, 104.74),
            vector3(-40.91, 369.07, 112.43),
            vector3(-621.11, 326.89, 82.26),
            vector3(-895.29, -777.94, 15.91),
            vector3(-849.56, -1102.94, 2.16),
            vector3(1138.34, -2344.15, 31.35),
            vector3(1455.27, -1662.46, 66.06),
            vector3(1113.07, -647.58, 56.82),
            vector3(-859.9, -354.12, 38.68)
        },
        Rewards = {
            [1] = {item = 'advancedrepairkit', qty = {min = 1, max = 5}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [2] = {item = 'heavyarmor', qty = {min = 1, max = 3}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [3] = {item = 'armor', qty = {min = 1, max = 3}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [4] = {item = 'skateboard', qty = {min = 1, max = 1}, weight = 40, prop = "prop_cs_package_01", emote = "mechanic4"},
            [5] = {item = 'racingtablet', qty = {min = 1, max = 1}, weight = 40, prop = "prop_cs_package_01", emote = "mechanic4"},
            [6] = {item = 'nikon', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [7] = {item = 'nos', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [8] = {item = 'malmo_laptop', qty = {min = 1, max = 1}, weight = 10, prop = "prop_cs_package_01", emote = "mechanic4"},
            [9] = {item = 'anglegrinder', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [10] = {item = 'powersaw', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [11] = {item = 'flightbox', qty = {min = 1, max = 1}, weight = 40, prop = "prop_cs_package_01", emote = "mechanic4"},
            [12] = {item = 'origami1', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [13] = {item = 'origami2', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [14] = {item = 'origami3', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [15] = {item = 'origami4', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [16] = {item = 'origami5', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [17] = {item = 'origami6', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [18] = {item = 'origami7', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [19] = {item = 'origami8', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [20] = {item = 'origami9', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [21] = {item = 'origami10', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [22] = {item = 'origami11', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [23] = {item = 'origami12', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [24] = {item = 'origami13', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [25] = {item = 'origami14', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [26] = {item = 'origami15', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [27] = {item = 'origami16', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [28] = {item = 'origami17', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [29] = {item = 'origami18', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [30] = {item = 'origami19', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [31] = {item = 'origami20', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [32] = {item = 'origami21', qty = {min = 1, max = 1}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
        }
    },
    ['burnerphone_loot'] = {
        CallCops = true,
        CopsNeeded = 1,
        VPNEnabled = true,

        BreakChance = 50,
        Uses = {min = 1, max = 3},
        CooldownTime = 20,

        DropOffLocations = {
            --You can add as many pickup locations as you want.
            vector3(-2176.83, 4275.75, 49.1),
            vector3(-1472.19, -150.21, 48.82),
            vector3(167.96, 2231.09, 90.79),
            vector3(-567.95, 5244.17, 70.47),
            -- vector3(2541.52, 2596.85, 37.94),
            vector3(2545.1, 364.02, 108.61),
            vector3(501.39, -656.02, 24.75),
            vector3(-543.51, 1983.62, 127.03),
            vector3(412.84, -339.29, 46.99),
            vector3(-310.73, 2793.12, 59.48),
            vector3(2288.1, 2074.51, 122.89),
            vector3(2408.68, 3031.7, 48.15),
            vector3(1522.48, 3917.22, 31.67),
            vector3(3336.16, 5164.48, 18.3),
            vector3(2913.33, 4293.5, 50.41),
            vector3(2511.7, 3777.37, 52.97),
            vector3(523.5, 200.99, 104.74),
            vector3(-40.91, 369.07, 112.43),
            vector3(-621.11, 326.89, 82.26),
            vector3(-895.29, -777.94, 15.91),
            vector3(-849.56, -1102.94, 2.16),
            vector3(1138.34, -2344.15, 31.35),
            vector3(1455.27, -1662.46, 66.06),
            vector3(1113.07, -647.58, 56.82),
            vector3(-859.9, -354.12, 38.68)
        },
        Rewards = {
            [1] = {item = 'rolex',         qty = {min = 3, max = 8}, weight = 40, prop = "prop_cs_package_01", emote = "mechanic4"},
            [2] = {item = 'diamond_ring',  qty = {min = 3, max = 8}, weight = 40, prop = "prop_cs_package_01", emote = "mechanic4"},
            [3] = {item = 'diamond',       qty = {min = 3, max = 8}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [4] = {item = 'goldchain',     qty = {min = 3, max = 8}, weight = 40, prop = "prop_cs_package_01", emote = "mechanic4"},
            [5] = {item = '10kgoldchain',  qty = {min = 3, max = 8}, weight = 40, prop = "prop_cs_package_01", emote = "mechanic4"},
            [6] = {item = 'goldbar',       qty = {min = 3, max = 8}, weight = 40, prop = "prop_cs_package_01", emote = "mechanic4"},
            [7] = {item = 'red_diamond',   qty = {min = 3, max = 8}, weight = 40, prop = "prop_cs_package_01", emote = "mechanic4"},
            [8] = {item = 'emerald',       qty = {min = 3, max = 8}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [9] = {item = 'sapphire',      qty = {min = 3, max = 8}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [10] = {item = 'ruby',          qty = {min = 3, max = 8}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
        }
    },
    ['burnerphone_drugs'] = {
        CallCops = true,
        CopsNeeded = 0,
        VPNEnabled = true,

        BreakChance = 50,
        Uses = {min = 1, max = 3},
        CooldownTime = 20,

        DropOffLocations = {
            --You can add as many pickup locations as you want.
            vector3(-2176.83, 4275.75, 49.1),
            vector3(-1472.19, -150.21, 48.82),
            vector3(167.96, 2231.09, 90.79),
            vector3(-567.95, 5244.17, 70.47),
            -- vector3(2541.52, 2596.85, 37.94),
            vector3(2545.1, 364.02, 108.61),
            vector3(501.39, -656.02, 24.75),
            vector3(-543.51, 1983.62, 127.03),
            vector3(412.84, -339.29, 46.99),
            vector3(-310.73, 2793.12, 59.48),
            vector3(2288.1, 2074.51, 122.89),
            vector3(2408.68, 3031.7, 48.15),
            vector3(1522.48, 3917.22, 31.67),
            vector3(3336.16, 5164.48, 18.3),
            vector3(2913.33, 4293.5, 50.41),
            vector3(2511.7, 3777.37, 52.97),
            vector3(523.5, 200.99, 104.74),
            vector3(-40.91, 369.07, 112.43),
            vector3(-621.11, 326.89, 82.26),
            vector3(-895.29, -777.94, 15.91),
            vector3(-849.56, -1102.94, 2.16),
            vector3(1138.34, -2344.15, 31.35),
            vector3(1455.27, -1662.46, 66.06),
            vector3(1113.07, -647.58, 56.82),
            vector3(-859.9, -354.12, 38.68)
        },
        Rewards = {
            [1] = {item = 'ifaks', qty = {min = 1, max = 5}, weight = 40, prop = "prop_cs_package_01", emote = "mechanic4"},
            [2] = {item = 'oxy', qty = {min = 1, max = 15}, weight = 40, prop = "prop_cs_package_01", emote = "mechanic4"},
            [3] = {item = 'lq_coke_baggy', qty = {min = 10, max = 20}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [4] = {item = 'malmoheroin_syringe', qty = {min = 5, max = 20}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [5] = {item = 'malmo_dirtymeth', qty = {min = 5, max = 30}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [6] = {item = 'trainwreck_joint', qty = {min = 5, max = 20}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [7] = {item = 'malmok_joint', qty = {min = 5, max = 20}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [8] = {item = 'poppy_seed', qty = {min = 2, max = 8}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [8] = {item = 'lq_coke_seed', qty = {min = 2, max = 8}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [8] = {item = 'malmo_malmokush_seed', qty = {min = 5, max = 10}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [9] = {item = 'rolling_paper', qty = {min = 40 , max = 100}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [10] = {item = 'malmoheroin_base', qty = {min = 20 , max = 40}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [11] = {item = 'plastic_bag', qty = {min = 40 , max = 100}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [12] = {item = 'malmometh_sacid', qty = {min = 30 , max = 70}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
            [13] = {item = 'syringe', qty = {min = 40 , max = 100}, weight = 50, prop = "prop_cs_package_01", emote = "mechanic4"},
        }
    },
}

Config.KeyList = { -- List of usable keys
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

-- Options for custom progress bar if using RProgress
Config.RProgressUI = {
    Async = true,
    cancelKey = 178,        -- Custom cancel key
    x = 0.5,                -- Position on x-axis
    y = 0.5,                -- Position on y-axis
    Radius = 60,            -- Radius of the dial
    Stroke = 10,            -- Thickness of the progress dial
    Cap = 'butt',           -- or 'round'
    Padding = 0,            -- Padding between the progress dial and the background dial
    MaxAngle = 360,         -- Maximum sweep angle of the dial in degrees
    Rotation = 0,           -- 2D rotation of the dial in degrees
    Width = 300,            -- Width of bar in px if Type = 'linear'
    Height = 40,            -- Height of bar in px if Type = 'linear'
    ShowTimer = true,       -- Shows the timer countdown within the radial dial
    ShowProgress = false,   -- Shows the progress % within the radial dial
    Easing = "easeLinear",
    LabelPosition = "right",
    Color = "rgba(255, 255, 255, 1.0)",
    BGColor = "rgba(0, 0, 0, 0.4)",
    ZoneColor = "rgba(51, 105, 30, 1)",
}