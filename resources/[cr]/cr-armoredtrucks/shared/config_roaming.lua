-- Config = Config or {}
Config.Roaming = {}

Config.Roaming.PedModels = "s_m_m_armoured_02"
Config.Roaming.ThermiteHack = {CorrectBlocks = 12, IncorrectBlocks = 3, TimeToShow = 5, TimeToLose = 9}
Config.Roaming.BombTimer = 2
Config.Roaming.Cooldown = 60
Config.Roaming.Cops = 4

Config.Roaming.Guards = {
    Health = 500,
    Armor = 300,
    Weapon = 'WEAPON_SMG',--`WEAPON_AR15`
    Accuracy = 90,
}

Config.Roaming.TruckLocations = {
    vector4(-1254.56, -860.71, 12.35, 213.6),
    vector4(1204.67, 2725.37, 38.0, 247.17),
    vector4(140.35, 6352.0, 31.34, 30.49),
    vector4(-2940.91, 491.52, 15.28, 81.89),
    vector4(-2940.42, 491.48, 15.28, 85.01),
    vector4(970.74, -72.91, 75.21, 85.4),
    vector4(-160.33, -160.39, 43.62, 67.12),
    vector4(1248.65, -341.43, 69.08, 75.66),
    vector4(797.25, -1798.29, 29.32, 221.76),
    vector4(-1327.53, -84.74, 49.27, 359.58),
    vector4(-2074.82, -233.11, 21.18, 24.16),
    vector4(-971.48, -1532.17, 4.97, 111.63),
}

Config.Roaming.TruckTypes = {
    -- Humane labs
        --money?
        --speial = biohazard container
    -- Diamond Casino
        -- money
        -- casino chips
    -- Ammunation
        -- pistols?
        -- ammo
        -- melee weapons?
    [1] = {
        company = "groupe6",
        colors = {primary = 0, secondary = 50, int = 50},
        livery = 2,
        hacks = 3
    },
    [2] = {
        company = "diamond",
        colors = {primary = 111, secondary = 0, int = 0},
        livery = 7,
        hacks = 3
    },
    [3] = {
        company = "lockloaded",
        colors = {primary = 32, secondary = 32, int = 0},
        livery = 9,
        hacks = 3
    },
}