Config = Config or {}

Config.RenewedFuel = false


Config.CoreName = "qb-core"

Config.Menu = "qb-menu" -- Change this to whatever you use, some use qb-menu, others use ps-ui etc. just make sure they are compatible with qb-menu

Config.GarbageVehicle = "trash"

Config.Route = {
    ["small"] = 0,
    ["medium"] = 75,
    ["large"] = 150,
}

Config.StopsAmt = {
    ["small"] = {min = 1, max = 2},
    ["medium"] = {min = 2, max = 3},
    ["large"] = {min = 3, max = 5},
}

Config.MaterialTicket = true -- Enable or disable MaterialTickets and trades
Config.Trade = {
    ["metalscrap"] = math.random(15,18), -- Name of the material, the amount of materials the player will get for 1 ticket
    ["steel"] = math.random(10,12),
    ["glass"] = math.random(20,23),
    ["rubber"] = math.random(12,16)
}

Config.PedLocation = vector4(-322.25, -1545.78, 30.02, 270.41)
Config.Ped = "s_m_y_garbage"


-- All the possibly locations the garbage truck can spawn --
Config.CarSpawns = {
    vector4(-327.6, -1524.25, 27.25, 267.9),
    vector4(-312.48, -1529.22, 27.27, 263.87),
    vector4(-310.77, -1520.05, 27.4, 261.97),
    vector4(-345.13, -1530.91, 27.42, 269.2)
}


-- Add more stops here if u wish more stops --
Config.Stops = {
    vector3(304.99, 263.64, 105.28),
    vector3(-1517.52, 50.77, 55.38),
    vector3(-1101.48, -1630.69, 4.4),
    vector3(-652.63, 493.34, 109.44),
    vector3(-1567.97, -906.07, 9.32),
    vector3(346.03, -952.61, 29.46),
    vector3(1069.83, -478.64, 64.01),
    vector3(93.77, -1931.76, 20.8),
    vector3(1258.99, -1596.78, 53.06),
    vector3(1173.36, -1319.56, 34.84),
    vector3(127.17, -1318.48, 29.2),
    vector3(1139.78, -404.94, 67.05),
}

-- Add more Target options here if u use custom bins or dumpsters for your server --
Config.Target = {
    "prop_snow_dumpster_01",
    "prop_dumpster_4a",
    "prop_cs_dumpster_01a",
    "p_dumpster_t",
    "prop_dumpster_3a",
    "prop_dumpster_4b",
    "prop_dumpster_01a",
    "prop_dumpster_02b",
    "prop_dumpster_02a",
    "prop_bin_01a",
    "prop_bin_07b",
    "prop_bin_07c",
    "prop_bin_08a"
}