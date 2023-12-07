Config = {}
Config.Debug = true

Config.Framework = {
    -- Framework = "QBCore", --"QBCore" | "ESX"
    Interaction = {
        UseTarget = true, -- Leave true if you are using qb-target. Set to false to disable targetting and enable DrawText for all interactions
        Target = "qb-target", -- "qb-target" | "oxtarget"
        OxLibDistanceCheck = false -- Distance Checks are done via oxlib points instead of a loop.
    },
    Menu = 'ox',
    Input = 'ox',

    --Framework Overrides (You can change specific framework related functions to ones from other scripts.)
    UseOxInv = false, -- For ESX and QBCore. Lets ESX users utilize the "uses" configuration on the usb (Uses Item Metadata)
    Doorlocks = 'qb', --  'qb' = qb-doorlock | 'nui' = nui-doorlock | 'ox' = ox_doorlocks
    Skillbar = "qb-skillbar", -- "qb-skillbar" | "custom" (See cl_framework)
    CircleMinigame = "ps-ui", -- "ps-ui" | "qb-lock" | "oxlib" | (You can use your own (See cl_framework)
    Notifications = "qb", -- "okok" | "mythic" | "tnj" | "oxlib" | "qb" | "ESX" | "chat" |
    ProgressUI = "", -- "oxlib" | "mythic" | "rprogress" (Custom Settings at the bottom) |  Otherwise leave blank ("") to use Framework Settings.
    DrawText = "", -- "oxlib" | "okok" | "psui" | Otherwise leave blank ("") to use Framework Settings.
    -- *Important* All oxlib option requires oxlib to be enabled in the fxmanifest *Important*
  }



function Lcl(txt, ...) if CRForgeryLocales[txt] then return string.format(CRForgeryLocales[txt], ...) else print('Locale Error, Contact Server Admin. ('..txt..')') end end

Config.Logs = true -- True = Logs Enabled | False = Logs Disabled
Config.Notifications = 'okok' -- 'qb' = QBCoreNotify | okok' = OKOKNotify | 'mythic' = Mythic Notify | 'chat' = Chat Messages
Config.Menu = 'nh' -- 'qb' = "qb-menu" | "nh" = "nh-context"
Config.ForgeTime = 15 -- Time Is In Seconds vector4(-143.85, -833.3, 31.12, 248.83) ACTUAL -> vector3(459.79, -1869.56, 27.11)
Config.OutsideCoords = {coords = vector3(-143.85, -833.3, 31.12), heading = 248.83 } -- If you wish to change the Entrance, make sure this is changed to the Outside Location where you'd want the user Teleported if they Left the Building.
Config.InteractKey = "G" -- Key to press when interacting with things (Default : G | See Config.KeyList to know which string to change this value to.)
Config.UseTarget = true

Config.Licences = {
    ["ID Card"] = {
        ForgingCost = 0, -- Leave at 0 for free, or set a price.
        MoneyType = "cash", -- If payment is required, money type used to forge a card ("cash, crypto, bank, or any custom currency")
        RequiredItems = { -- List of items required to craft a card.
        -- Leave the table empty if you don't want to require items to forge.
        -- You can add as many items as wanted by following the template
        -- [ITEM_NUMBER] = {item = "ITEM_HASH", amount = "AMOUNT_REQUIRED"}
            [1] = {item = "plastic", amount = 2},
            --[2] = {item = "dye", amount = 1}
        },
        Card = "id_card", --Card Item Given ("item hash")
        --Description = "IDENTIFICATION CARD" -- Card Description if it requires one
        ShownOptions = {
            ['Name'] = true,
            ['DOB'] = true,
            ['Gender'] = true,
            ['Nat'] = true,
        }
    },
    ["Drivers License"] = {
        ForgingCost = 5000, -- Leave at 0 for free, or set a price.
        MoneyType = "cash", -- If payment is required, money type used to forge a card ("cash, crypto, bank, or any custom currency")
        RequiredItems = { -- List of items required to craft a card.
        -- Leave the table empty if you don't want to require items to forge.
        -- You can add as many items as wanted by following the template
        -- [ITEM_NUMBER] = {item = "ITEM_HASH", amount = "AMOUNT_REQUIRED"}
            -- [1] = {item = "plastic", amount = 2},
            -- [2] = {item = "dye", amount = 1}
        },
        Card = "driver_license", --Card Item Given ("item hash")
        Description = "CLASS G DRIVERS LICENSE", -- Card Description if it requires one
        ShownOptions = {
            ['Name'] = true,
            ['DOB'] = true,
            ['Gender'] = false,
            ['Nat'] = false,
        }
    },
    -- ["Weapon License"] = {
    --     Pay = true,
    --     MoneyType = "cash",
    --     Cost = 18500,
    --     Item = true,
    --     RequiredItems = {
    --     [1] = {item = "plastic", amount = 2},
    --     [2] = {item = "dye", amount = 1}
    --     },
    --     Card = "weaponlicense",
    --     Description = "CLASS ONE WEAPON LICENSE"
    -- },
    -- ["Hunting License"] = {
    --     Pay = true,
    --     MoneyType = "cash",
    --     Cost = 6500,
    --     Item = true,
    --     RequiredItems = {
    --     [1] = {item = "plastic", amount = 2},
    --     [2] = {item = "dye", amount = 1}
    --     },
    --     Card = "huntinglicense",
    --     Description = "HUNTING LICENSE"
    -- },
    -- ["Waters License"] = {
    --     Pay = true,
    --     MoneyType = "cash",
    --     Cost = 12500,
    --     Item = true,
    --     RequiredItems = {
    --     [1] = {item = "plastic", amount = 2},
    --     [2] = {item = "dye", amount = 1}
    --     },
    --     Card = "waterslicense",
    --     Description = "WATERS LICENSE"
    -- },
    -- ["Fishing License"] = {
    --     Pay = true,
    --     MoneyType = "cash",
    --     Cost = 8500,
    --     Item = true,
    --     RequiredItems = {
    --     [1] = {item = "plastic", amount = 2},
    --     [2] = {item = "dye", amount = 1},
    --     },
    --     Card = "fishinglicense",
    --     Description = "DEEP SEA FISHING LICENSE"
    -- },
}

-- Evidence Drop Config

Config.DropFingerPrintEvidence = true -- True = Will Drop | False = Won't Drop

Config.FingerPrintDropChanceSet = true -- True = Set via Percentage | False = Isn't set via Percentage

Config.FingerPrintDropChance = 50 -- Max # = 100 |  Percentage to Drop Fingerprint on Forge | 1 = 100% & 100 = 1%

Config.MaleNoHandshoes = {
    [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [14] = true, [15] = true, [18] = true, [26] = true, [52] = true, [53] = true, [54] = true, [55] = true, [56] = true, [57] = true, [58] = true, [59] = true, [60] = true, [61] = true, [62] = true, [112] = true, [113] = true, [114] = true, [118] = true, [125] = true, [132] = true,
}
Config.FemaleNoHandshoes = {
    [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [14] = true, [15] = true, [19] = true, [59] = true, [60] = true, [61] = true, [62] = true, [63] = true, [64] = true, [65] = true, [66] = true, [67] = true, [68] = true, [69] = true, [70] = true, [71] = true, [129] = true, [130] = true, [131] = true, [135] = true, [142] = true, [149] = true, [153] = true, [157] = true, [161] = true, [165] = true,
}

Config.GenderOptions = {
    [1] = 'Female',
    [2] = 'Male',
    --[3] = 'Other',
}

Config.KeyList = {
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