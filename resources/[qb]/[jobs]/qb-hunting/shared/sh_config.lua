Config = {}

--- Compatibility settings

Config.Resource = GetCurrentResourceName()
Config.Notify = 'ox' -- 'ox' for ox_lib or 'qb' for QBCore.Functions.Notify
Config.Inventory = 'qb' -- 'ox_inventory' or 'qb'
Config.Target = 'ox' -- 'ox' or 'qb'
Config.Log = 'qb' -- 'ox' or 'qb'

--- Hunting Script Settings
Config.Huntingrifle = `weapon_huntingrifle`

Config.Area = vector3(-1367.81, 4594.12, 133.65) -- Blip location
Config.Sell = vector4(0,0,0,0) -- Taxidermist

Config.Hunting = 'all' -- 'bait' if you only want to hunt baited animals or 'all' if you want to skin all dead animals
Config.OnlyHuntingRifle = true -- Setting this to true only allows players to skin the animal if the animal was killed by a huntingrifle

--- Script

Config.Prices = { -- Item sale prices
	carcass = math.random(30,55),
	carcass2 = math.random(40,80),
	carcass3 = math.random(100,125),
	redcarcass = math.random(195,224),
	redcarcass2 = math.random(195,230),
	redcarcass3 = math.random(195,234),
	deerhide = math.random(25,50),
	antlers = math.random(120,170),
	mtlionpelt = math.random(400,420),
	mtlionfang = math.random(400,420),
	coyotepelt = math.random(100,150),
	boarmeat = math.random(100,150),
	fish = math.random(25,50),
	stripedbass = math.random(30,55),
    bluefish = math.random(40,80),
    redfish= math.random(100,150),
    goldfish = math.random(100,125),
    largemouthbass = math.random(150,170),
    swordfish = math.random(150,170),
   	salmon = math.random(150,170),
    catfish = math.random(150,170),
	rainbowtrout = math.random(300,360),
	tigershark =   math.random(300,360),
	stingraymeat = math.random(400,420),
	tunafish =     math.random(355,420),
	killerwhale =  math.random(330,350),


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
