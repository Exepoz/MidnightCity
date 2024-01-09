Config = {
	DebugOptions = {
		Debug = true, -- This turns on boxes if true
		DiscordLog = true, -- This is for Discord logs
	},
	CoreOptions = {
		Lan = "en",
		Menu = "ox", -- ox, qb, or jim-menu
		Notify = "ox", -- qb, t, rr, ox
		Inv = "qb", -- qb or ox
		ProgressBar = "qb", -- qb or ox
		CoreName = "qb-core", -- for your custom core named frameworks
		EmoteMenu = "rp", -- rp, dp, scully, default are supported
		img = "ps-inventory/html/images/", -- lj-inventory/html/images/ change this to whatever your inventory is or leave blank if getting double images
	},
	BankingOptions = {
		RenewedBanking = true,
	},
	ScriptOptions = {
		Job = 'all', -- put whatever your farming job is called or leave "all" for everyone can use this
		FarmingRep = false, -- turns on rep being given and requires rep for crafting
		FarmingRepNotifications = false, -- turns on rep notifications
		ParticleFXEnabled = true, -- Turns on Particle FX this helps if you're using a AC that has issues with Particle FX
		StressRelief = false, -- Turns on Stress Relief while picking
		StressReliefAmount = function() return math.random(5, 10) end, -- Stress Relief from picking fruit and veggies
		WaitTimes = {
			PickWait = 1,
		},
		Minigame = {
			Enabled = false, -- Dependancy PS-UI
			MinigameCircles = 2,
			MinigameTime = 10,
		},
		DLC = {
			jixelcigarbar = false,
		}
	},
	PedLocations =  {
			{ name = "Adam - The Produce Buyer", coords = vec4(1675.96, 4883.44, 42.03, 55.83), sprite = 108, col = 5, blipTrue = true, farmsell = true, model = "a_m_m_farmer_01", scenario = "WORLD_HUMAN_AA_COFFEE", },
			--{ name = "Jorge -  The Tobacco Foreman", coords = vector4(5299.84, -5271.32, 32.16, 224.54), sprite = 108, col = 5, blipTrue = true, cayoped = true, model = "a_m_m_farmer_01", scenario = "WORLD_HUMAN_AA_COFFEE", },
			{ name = "Bob - The Chicken Man", coords = vector4(2386.29, 5042.57, 46.28, 216.86), sprite = 108, col = 5, blipTrue = true, chickenped = true, model = "a_m_m_farmer_01", scenario = "WORLD_HUMAN_AA_COFFEE", },
			{ name = "Angelo - The Pig Man", coords = vector4(2191.5, 4979.6, 41.51, 316.56), sprite = 108, col = 5, blipTrue = true, pigped = true, model = "a_m_m_farmer_01", scenario = "WORLD_HUMAN_AA_COFFEE", },
			{ name = "Frank - The Cow Man", coords = vector4(953.38, -2198.86, 30.55, 357), sprite = 108, col = 5, blipTrue = true, cowped = true, model = "a_m_m_farmer_01", scenario = "WORLD_HUMAN_AA_COFFEE", },
		},
}