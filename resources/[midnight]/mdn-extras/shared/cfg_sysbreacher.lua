--------------
-- Heisting --
--------------
Config = Config or {}
Config.SysBreacher = {}

local FleecaCoords = {
    vector3(150.88, -1042.59, 29.37),
    vector3(315.24, -281.07, 54.16),
    vector3(-349.83, -51.84, 49.04),
    vector3(-1210.55, -331.24, 37.78),
    vector3(-2961.0, 484.52, 15.7),
    vector3(1173.4, 2708.3, 38.09)
}

Config.SysBreacher.Heists = {
    ['fleeca'] =     {bank = true,  Header = "Fleeca Banks",                    icon = "fa-solid fa-building-columns", minCops = 4, onCooldown = false, dongle = 'usb_fleeca',        tries = 3, m_coords = true, coords = FleecaCoords, event = 'cr-fleecabankrobbery:client:FleecaBankUSBUsage'},

    ['paleto'] =     {bank = true,  Header = "Paleto Bank (Teller Computer)",   icon = "fa-solid fa-building-columns", minCops = 5, onCooldown = false, dongle = 'crpaleto_usb',      tries = 3, coords = vector3(-106.79, 6474.23, 31.63), event = 'cr-paletobankrobbery:client:VaultComputer'},
    ['paleto2'] =    {bank = true,  Header = "Paleto Bank (Side Door Keypad)",  icon = "fa-solid fa-building-columns", minCops = 5, onCooldown = false, dongle = 'paleto_codes',      tries = 1, coords = vector3(-115.74, 6480.39, 31.46), event = 'cr-paletobankrobbery:client:OutsideKeypad'},

    ['pacific'] =    {bank = true,  Header = "Pacific Bank",                    icon = "fa-solid fa-building-columns", minCops = 7, onCooldown = false, dongle = 'usb_red',           tries = 3, coords = vector3(252.88, 228.55, 101.68), event = 'qb-bankrobbery:client:UseRedLaptop'},
    ['pacific2'] =   {bank = true,  Header = "Pacific Bank (Lower Vault)",      icon = "fa-solid fa-building-columns", minCops = 8, onCooldown = false, dongle = 'usb_gold',          tries = 3, coords = vector3(257.60, 228.20, 101.68), event = 'qb-bankrobbery:client:UseGoldLaptop'},

    ['bobcat'] =     {bank = false, Header = "Bobcat Security",                 icon = "fas fa-user-shield",           minCops = 6, onCooldown = false, dongle = 'bobcat_codes',      tries = 3, coords = vector3(875.08, -2263.35, 30.54), event = 'sd-bobcat:openThirdDoor'},
    ['artgallery'] = {bank = false, Header = "Art Gallery",                     icon = "fa-solid fa-palette",          minCops = 6, onCooldown = false, dongle = 'gallery_codes',     tries = 3, coords = vector3(15.15, 144.60, 93.79), event = 'qb-artgalleryheist:OutsideHack'},
    ['oilrig'] =     {bank = true,  Header = "Oil Rig",                         icon = "fa-solid fa-oil-well",         minCops = 6, onCooldown = false, dongle = 'security_card_oil', tries = 3, coords = vector3(-2723.67, 6600.28, 16.1), event = 'sd-oilrig:client:StartPuzzle'},
} Config.SysBreacher.Order = {'fleeca', 'paleto', 'paleto2', 'pacific', 'pacific2', 'bobcat', 'artgallery', 'oilrig'}
