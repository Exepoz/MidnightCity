Config = Config or {}

-- Compatibility settings
Config.Resource = GetCurrentResourceName()
Config.Notify = 'qb' -- 'ox' for ox_lib or 'qb' for QBCore.Functions.Notify
Config.Inventory = 'qb' -- 'ox_inventory' or 'qb'
Config.ThermiteItem = 'thermite'

-- Script settings
Config.MinimumPolice = 0 -- Required amount of cops to be able to hit the powerplant stations

-- Minigame Settings
Config.ThermiteSettings = {
    correctBlocks = 14, -- Number of correct blocks the player needs to click
    incorrectBlocks = 4, -- Number of incorrect blocks after which the game will fail
    timetoShow = 12, -- Time in seconds for which the right blocks will be shown
    timetoLose = 24 -- Maximum time after timetoshow seconds for player to select the right blocks
}

-- Powerplant interaction location data
Config.Locations = {
    [1] = { -- East Power Plant 1
        coords = vector3(2835.17, 1505.23, 24.6),
        animation = vector3(2835.14, 1505.48, 24.72),
        ptfx = vector3(2835.24, 1506.26, 24.72),
        hit = false
    },
    [2] = { -- East Power Plant 2
        coords = vector3(2811.83, 1501.10, 24.74),
        animation = vector3(2811.86, 1500.8, 24.72),
        ptfx = vector3(2811.76, 1501.8, 24.72),
        hit = false
    },
    [3] = { -- East Power Plant 3
        coords = vector3(2734.54, 1475.55, 44.80),
        animation = vector3(2734.4275, 1475.87, 45.29),
        ptfx = vector3(2734.4275, 1476.87, 45.29),
        hit = false
    },
    [4] = { -- East Power Plant 4
        coords = vector3(2742.6606, 1505.82, 44.80),
        animation = vector3(2742.5206, 1505.82, 45.45),
        ptfx = vector3(2742.3606, 1506.82, 45.45),
        hit = false
    },
    [5] = { -- Powerplant City 1
        coords = vector3(708.81, 117.01, 80.97),
        animation = vector3(708.92, 117.24, 81.05),
        ptfx = vector3(708.92, 118.24, 80.95),
        hit = false
    },
    [6] = { -- Powerplant City 2
        coords = vector3(670.26, 128.6, 80.97),
        animation = vector3(670.43, 128.34, 81.05),
        ptfx = vector3(670.23, 129.39, 80.95),
        hit = false
    },
    [7] = { -- Powerplant City 3
        coords = vector3(692.09, 159.97, 80.97),
        animation = vector3(692.17, 159.94, 81.04),
        ptfx = vector3(692.17, 160.89, 80.94),
        hit = false
    }
}
