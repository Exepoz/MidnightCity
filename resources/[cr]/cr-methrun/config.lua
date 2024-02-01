Config = {}
function Lcl(txt, ...) if CRMethRunLocales[txt] then return string.format(CRMethRunLocales[txt], ...) else print('Locale Error, Contact Server Admin. ('..txt..')') end end

Config.DevMode = false -- Set to 'true' if you are Testing the Resource. Also enables the command '/testmethrun', which let's you start the run from anywhere on the map.
Config.Debug = false -- True = Debug Prints Enabled | false = Debug Prints Disabled
Config.UseTarget = GetConvar('UseTarget', 'false') == 'true' -- Should be changed in your server.cfg. Add `setr useTarget true` (or false) if you haven't already
Config.InteractKey = "G" -- Key to press when interacting with things (Default : G | See Config.KeyList to know which string to change this value to.)
Config.DrawText = 'qb' -- DrawText Script used (qb or okok)
Config.Notifications = "qb" --"qb" = Default (QBCore) OR tnj-notify* | "okok" = OkOkNotify | "mythic" = Mythic Notifications | "chat" = Simple Chat Message
-- *IMPORTANT : for tnj-notify, you should follow their readme file and implement their export into qb-core/client/functions. This way all of the default qb-core notifications will be routed to tnj-notify.
Config.Logs = false -- true = qb-logs Enabled | qb-logs Disabled

-- Run Configurations
Config.StartLocation = {coords = vector3(-106.61, -2234.44, 7.81), heading = 120.13} --Starter Ped Location & heading

Config.Phone = "qb" -- 'qb' : qb-phone | 'gks' : GKS Phone

Config.Police = { -- Police Configuration
    CopsNeeded = 0,
    CallCops = true,-- True = Enables Police Alerts | False = Disable Police Alers
    PoliceJobs = {"police"}, -- Name of the supported police jobs receiving calls (Default : "police")
    Dispatch = "ps-dispatch", -- "qb" = Default qb-policejob | "cd" = Code Design's Dispatch | "core" = Core Dispatch | "ps-dispatch" == Project Sloth's qb-dispatch | "other" == Any dispatch system you want to add (see cl_extras.lua)
    TenCode = "911", -- 10-code used for the stolen car call (CD Dispatch + Core Dispatch)
    DispatchMessageTitle = "Stolen Security Car", --Alert Title (CD Dispatch)
    DispatchMessage = "Security Car Automatic Distress Signal", --Alert Message
    BlipInterval = 30, -- Time in seconds between each blip (Dispatch calls goes every 3 blips)
    BlipType = "area" -- Type of blip for the tracker
}

Config.Countdown = { -- Time before getting the goods drop off location (In Minutes) (Police receive pings during that time.)
    MinTime = 7,
    MaxTime = 10
}

-- Tsunami Specific Configurations
Config.ServerStartCooldown = false -- true = Tsunami Cooldown Enabled | false = Tsunami Cooldown Disabled
Config.Cooldown = 60 -- Cooldown in which you wait in between each Run & at start of server if enabled | Time is set in Minutes

Config.MinStartRunWait = 60 -- Minimum Wait Time to receive vehicle location | Time is in Seconds
Config.MaxStartRunWait = 90 -- Maximum Wait Time to receive vehicle location | Time is in Seconds

Config.MethItem = "meth_batch" -- Meth Item
Config.SellAllMeth = false -- true = Sells all the meth a player is carrying. | false = Only sells a set amount of meth per run.
Config.MethAmount = 300 -- Min Amount of meth needed to start a run. If Config.SellAllMeth = false, this is the amount of meth required to do the run.
Config.MinGoods = 3 -- Minimum Items needed to be picked up during the run
Config.MaxGoods = 5 -- Maximum Items needed to be picked up during the run

Config.Reward = { --Reward at the end of the run
    MoneyType = "dirtymoney", --Type of money received after completing a run ("cash", "bank", "crypto", or any type of custom money you have)
    MoneyReward = 50000, -- Amount of money received at the end of a run
    MoneyRewardPerBag = { Min = 750, Max = 1000 },-- if Config.SellAllMeth = true, amount of $ received per bag.
    ItemReward = true, -- If true, has a chance to give a special item to the player
    Chance = 50, -- Special Item Chance (In %)
    Item = "diamond", -- Special Item
    Amount = 1 -- Item Amount if needed
}

-- Vehicle Configuration
Config.VehicleList =  {       -- All the different types of vehicles that can spawn. **Chosen from random every time you start a new job**
-- Defaults are armored cars, make sure they are not blocked by your anticheat.
    [1]  = {vehicle = "baller5"},
    [2]  = {vehicle = "baller6"},
    [3]  = {vehicle = "xls2"},
    [4]  = {vehicle = "cognoscenti2"},
    [5]  = {vehicle = "schafter5"},
    [6]  = {vehicle = "schafter6"},
}

Config.VehicleModifications = { --Vehicle Performance Upgrades Configuation. (-1 is standart, default/No upgrades)
    Engine = 0, -- Possible options : (-1, 0, 1 , 2, 3)
    Breaks = 0, -- Possible options : (-1, 0, 1 , 2)
    Armor = -1, -- Possible options : (-1, 0, 1 , 2, 3, 4)
    Transmission = 0, -- Possible options : (-1, 0, 1 , 2)
    Suspension = 0, -- Possible options : (-1, 0, 1 , 2, 3)
    Turbo = 0, -- Possible options : 0 (No Turbo), 1 (Turbo active)
}

Config.VehicleNeons = { -- If true, sets the turns on Neon lights and sets them to a random color in the list. You can add custom colors.
    Enabled = true,
    Color = {
        { r = 222, g = 222, b = 255 }, --White
        { r = 2, g = 21, b = 255 }, --Blue
        { r = 3, g = 83, b = 255 }, --Electric Blue
        { r = 0, g = 255, b = 140 }, --Mint Green
        { r = 94, g = 255, b = 1 }, --Lime Green
        { r = 255, g = 255, b = 0 }, --Yellow
        { r = 255, g = 150, b = 0 }, --Golden
        { r = 255, g = 62, b = 0 }, --Orange
        { r = 255, g = 1, b = 1 }, --Red
        { r = 255, g = 50, b = 100 }, --Pony Pinkß
        { r = 255, g = 5, b = 190 }, --Hot Pink
        { r = 35, g = 1, b = 255 }, --Purple
        { r = 15, g = 3, b = 255 }, --Blacklight
    }
}

-- Locations Configuration
Config.VehicleCoords = { -- Locations of where the vehicle can spawn **Chosen from random every time you start a new job**
    [1] = {coords = vector3(-114.9003, -2526.6394, 5.3918), heading = 51.12},
    [2] = {coords = vector3(-1187.52, 325.56, 70.57), heading = 17.8},
    [3] = {coords = vector3(-1090.84, -460.09, 35.93), heading = 296.07},
    [4] = {coords = vector3(-443.71, 175.15, 75.13), heading = 175.78},
    [5] = {coords = vector3(-54.24, 338.76, 111.82), heading = 336.06},
    [6] = {coords = vector3(284.8, 77.63, 99.81), heading = 339.26},
    [7] = {coords = vector3(-536.81, -905.07, 23.79), heading = 240.62},
    [8] = {coords = vector3(-801.8, -1298.65, 4.92), heading = 169.88},
    [9] = {coords = vector3(-636.54, -2112.62, 5.92), heading = 181.99},
    [10] = {coords = vector3(840.28, -2336.51, 30.26), heading = 356.08},

}

--Guards Configuration
Config.Guards = {
    [1] = {
        pos = {2, 2, 2, 0}, -- Spawned Coords (Offset from the car)
        ped = 's_m_m_highsec_01', -- Ped Hash (https://docs.fivem.net/docs/game-references/ped-models/)
        weapon = 'WEAPON_HEAVYPISTOL', -- Weapon Used
        health = 2000, -- Health Amount
        armor = 100, -- Armor Amount
        accuracy = 50, -- Accuracy (in %)
    },
    [2] = {
        pos = {-2, 2, 2, 0},
        ped = 's_m_m_highsec_01',
        weapon = 'WEAPON_HEAVYPISTOL',
        health = 2000,
        armor = 100,
        accuracy = 50,
    },
    [3] = {
        pos = {2, -2, 2, 0},
        ped = 's_m_m_highsec_02',
        weapon = 'WEAPON_HEAVYPISTOL',
        health = 2000,
        armor = 100,
        accuracy = 50,
    },
    [4] = {
        pos = {-2, -2, 2, 0},
        ped = 's_m_m_highsec_02',
        weapon = 'WEAPON_HEAVYPISTOL',
        health = 2000,
        armor = 100,
        accuracy = 50,
    },
}

Config.GoodsPickupLocation = { --Locations of where the peds to pick up the goods at can spawn **Chosen from random every time you start a new job**
    [1] = { coords = vector3(-233.5, -1491.86, 31.96), heading = 280.96},
}

Config.DropOffLocations = { -- Possible drop off location, you can put as many as you want.
    [1] = {coords = vector3(516.58, -543.91, 24.73)},
    [2] = {coords = vector3(756.07, -1678.21, 29.28)},
    [3] = {coords = vector3(8.53, -1809.99, 25.34)},
    [4] = {coords = vector3(-451.07, -1682.67, 19.03)},
}

Config.FuelSystem = 'cdn-fuel'
-- 'LegacyFuel' = LegacyFuel
-- 'lj-fuel' = LJ Fuel
-- 'cc-fuel' = CC Fuel
Config.FuelLevel = 75.0
-- 100.0 is the Max
-- 0.0 is 0

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