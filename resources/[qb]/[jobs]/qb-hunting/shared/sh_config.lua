Config = {}

--- Compatibility settings

Config.Resource = GetCurrentResourceName()
Config.Notify = 'qb' -- 'ox' for ox_lib or 'qb' for QBCore.Functions.Notify
Config.Inventory = 'qb' -- 'ox_inventory' or 'qb'
Config.Target = 'qb' -- 'ox' or 'qb'
Config.Log = 'qb' -- 'ox' or 'qb'

--- Hunting Script Settings
Config.Huntingrifle = `weapon_huntingrifle`

Config.Area = vector3(-1367.81, 4594.12, 133.65) -- Blip location
Config.Sell = vector4(1708.68, 4727.69, 42.16, 118.91) -- Taxidermist

Config.Hunting = 'all' -- 'bait' if you only want to hunt baited animals or 'all' if you want to skin all dead animals
Config.OnlyHuntingRifle = true -- Setting this to true only allows players to skin the animal if the animal was killed by a huntingrifle

--- Script

Config.Prices = { -- Item sale prices
	carcass = 115,
	carcass2 = 120,
	carcass3 = 135,
	redcarcass = 195,
	redcarcass2 = 200,
	redcarcass3 = 230,
	deerhide = 40,
	antlers = 350,
	mtlionpelt = 410,
	mtlionfang = 410,
	coyotepelt = 160,
	boarmeat = 150
}

HuntingZone = lib.zones.poly({ -- Hunting Zone
    points = {
        vector3(-168.67, 4255.11, 95.0),
		vector3(-296.78, 4406.97, 95.0),
		vector3(-503.53, 4448.28, 95.0),
		vector3(-680.52, 4491.64, 95.0),
		vector3(-915.48, 4472.81, 95.0),
		vector3(-1072.28, 4445.11, 95.0),
		vector3(-1293.32, 4400.86, 95.0),
		vector3(-1395.00, 4372.83, 95.0),
		vector3(-1539.59, 4400.51, 95.0),
		vector3(-1619.01, 4495.31, 95.0),
		vector3(-1698.68, 4534.41, 95.0),
		vector3(-1757.90, 4636.74, 95.0),
		vector3(-1657.64, 4766.45, 95.0),
		vector3(-1355.90, 5062.56, 95.0),
		vector3(-1271.89, 5170.53, 95.0),
		vector3(-885.60, 5142.22, 95.0),
		vector3(-679.49, 5077.44, 95.0),
		vector3(-527.89, 5047.42, 95.0),
		vector3(-366.11, 4969.13, 95.0),
		vector3(-264.01, 4902.57, 95.0),
		vector3(-88.94, 4800.97, 95.0),
		vector3(143.84, 4650.47, 95.0)
	},
    thickness = 200.0,
    debug = false,
})
