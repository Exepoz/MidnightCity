Config = {}

-- NPC Vehicle Lock States
Config.LockNPCDrivingCars = true -- Lock state for NPC cars being driven by NPCs [true = locked, false = unlocked]
Config.LockNPCParkedCars = true -- Lock state for NPC parked cars [true = locked, false = unlocked]
Config.UseKeyfob = false -- you can set this true if you dont need ui
-- Lockpick Settings
Config.RemoveLockpickNormal = 0.5 -- Chance to remove lockpick on fail
Config.RemoveLockpickAdvanced = 0.2 -- Chance to remove advanced lockpick on fail
Config.LockPickDoorEvent = function(item) -- This function is called when a player attempts to lock pick a vehicle
    local attempts = 2
    if item == 'advanced-lockpick' then attempts = 3 end
    local s = exports["t3_lockpick"]:startLockpick(item, 1, 3, attempts)
    LockpickFinishCallback(s)
end

local buildDiff = function(item)
    local ran = math.random(3,6)
    local arr = {}
    for i = 1, ran do
        local c = math.random(100)
        if item == 'lockpick' and c < 60 then
            table.insert(arr, 'easy')
        elseif item == 'advanced-lockpick' then
            table.insert(arr, 'easy')
        else
            table.insert(arr, 'medium')
        end
    end
    return arr
end

Config.LockPickEngineEvent = function(item) -- This function is called when a player attempts to lock pick a vehicle
    Wait(500)
    local diff = buildDiff(item)
    local s = lib.skillCheck(diff, {'w', 'a', 's', 'd'})
    LockpickFinishCallback(s)
end


-- Carjack Settings
Config.CarJackEnable = true -- True allows for the ability to car jack peds.
Config.CarjackingTime = 7500 -- How long it takes to carjack
Config.DelayBetweenCarjackings = 10000 -- Time before you can carjack again
Config.CarjackChance = {
    ['2685387236'] = 0.0, -- melee
    ['416676503'] = 0.5, -- handguns
    ['-957766203'] = 0.75, -- SMG
    ['860033945'] = 0.90, -- shotgun
    ['970310034'] = 0.90, -- assault
    ['1159398588'] = 0.99, -- LMG
    ['3082541095'] = 0.99, -- sniper
    ['2725924767'] = 0.99, -- heavy
    ['1548507267'] = 0.0, -- throwable
    ['4257178988'] = 0.0, -- misc
}

-- Hotwire Settings
Config.HotwireChance = 0.5 -- Chance for successful hotwire or not
Config.TimeBetweenHotwires = 5000 -- Time in ms between hotwire attempts
Config.minHotwireTime = 20000 -- Minimum hotwire time in ms
Config.maxHotwireTime = 40000 --  Maximum hotwire time in ms

-- Police Alert Settings
Config.AlertCooldown = 10000 -- 10 seconds
Config.PoliceAlertChance = 0.75 -- Chance of alerting police during the day
Config.PoliceNightAlertChance = 0.50 -- Chance of alerting police at night (times:01-06)

-- Job Settings
Config.SharedKeys = { -- Share keys amongst employees. Employees can lock/unlock any job-listed vehicle
    ['police'] = { -- Job name
        requireOnduty = false,
        vehicles = {
	    'police', -- Vehicle model
	    'police2', -- Vehicle model
	}
    },

    ['mechanic'] = {
        requireOnduty = false,
        vehicles = {
            'towtruck',
	}
    }
}

-- These vehicles cannot be jacked
Config.ImmuneVehicles = {
    'stockade'
}

-- These vehicles will never lock
Config.NoLockVehicles = {}

-- These weapons cannot be used for carjacking
Config.NoCarjackWeapons = {
    "WEAPON_UNARMED",
    "WEAPON_Knife",
    "WEAPON_Nightstick",
    "WEAPON_HAMMER",
    "WEAPON_Bat",
    "WEAPON_Crowbar",
    "WEAPON_Golfclub",
    "WEAPON_Bottle",
    "WEAPON_Dagger",
    "WEAPON_Hatchet",
    "WEAPON_KnuckleDuster",
    "WEAPON_Machete",
    "WEAPON_Flashlight",
    "WEAPON_SwitchBlade",
    "WEAPON_Poolcue",
    "WEAPON_Wrench",
    "WEAPON_Battleaxe",
    "WEAPON_Grenade",
    "WEAPON_StickyBomb",
    "WEAPON_ProximityMine",
    "WEAPON_BZGas",
    "WEAPON_Molotov",
    "WEAPON_FireExtinguisher",
    "WEAPON_PetrolCan",
    "WEAPON_Flare",
    "WEAPON_Ball",
    "WEAPON_Snowball",
    "WEAPON_SmokeGrenade",
}