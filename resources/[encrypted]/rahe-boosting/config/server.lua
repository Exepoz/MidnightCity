svConfig = {
    -- The currency settings which are used to display money amount in the tablet's HTML.
    -- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/toLocaleString
    -- The first variable (currencyLocale) defines how the number is formatted. For example in 'en-US': '$60,890.00', 'et': '60 890,00 $'
    -- The second variable (currency) defines the symbol which is used - €/$ or whatever you wish.
    currencyLocale = 'en-us',
    currency = 'USD',

    -- Time between boosting contract loop executions. If the default value (15) is used, then every 15 minutes (4 times per hour), contracts will be
    -- generated for the players who are queued. The chances of receiving a contract in that loop execution are defined in vehicle class configs, the
    -- 'generationPercentage' value. For example, if the 'D' class has a generationPercentage value of 70, then every 15 minutes there is a 70% chance
    -- that you will receive a D class boosting contract.
    minutesBetweenGenerations = 15,

    -- The amount of contracts that player will be given when he opens the tablet for the very first time (to get him started).
    initialContractAmount = 5,

    -- The amount of online police required for people to get important (A / S class) contracts. This will be applied to classes which have the 'isImportant' as true.
    requiredPoliceAmount = 4,

    --  Define the principal which will be given the ACE permission to use the in-game admin panel. If you don't wish to use this, set it to false.
    -- In order for this to work, make sure you allow ox_lib to grant permissions (https://overextended.dev/ox_lib) ('You'll also need to grant ace permissions to the resource.')
    adminPrincipal = 'group.admin',

    -- A comma separated list of player identifiers (strings) that are allowed to access the admin panel (in addition to those allowed by ACE permissions).
    -- Examples for different frameworks:
    --
    -- QB: adminIdentifiers = {'RKDJ2732', 'MNSU0922'},
    -- ESX: adminIdentifiers = {'char1:17beaa0fce04fd5d7e8571a6a1b51f172e7c4457', 'char1:17beaa0fce04fd5d7e8571a6a1b51f172e7c4457'},
    adminIdentifiers = {},

    -- If the player should be penalized during delivery for having an engine whose health is below 80%.
    penalizeForDamagedEngine = true,

    -- The amount in dollars that's the maximum penalty for having a damaged engine when dropping off.
    maximumEngineDamagePenalty = 500,

    -- If the vehicle were in the center of the indicated area, it would be found instantly. To prevent this, an offset is used. This value determines
    -- the min/max offset of the x and y axis (randomly generated between 0 and this value) from the vehicle spawn point (in meters).
    -- Related client-side config values: vehicleCreationDistance, vehicleAreaRadius
    vehicleAreaMaximumOffset = 145.0,

    -- An option to enable / disable VIN scratching. If disabled, then the player will get an error message when trying to VIN scratch a vehicle.
    vinScratchingEnabled = true,

    -- Determine whether experience should be distributed among group members when performing a contract with a group.
    -- Set to 'true' for experience to be shared among group members.
    -- Set to 'false' for experience to be given only to the contract owner.
    splitExperienceInGroups = true,

    -- If all group members must enter the red pick up area at least once to get any kind of rewards (money, crypto, XP) in the end.
    -- This can be used to prevent abuse situations where people are group boosting and some of the members are just AFKing along to get XP.
    groupActivityCheck = true,

    -- A list of conditions for different vehicle classes
    -- The list must be ordered by their 'xpRequired' value (high -> low)

    -- Class parameters explained:
    -- @class: the main identifier, used for displaying and getting a vehicles class
    -- @xpRequired: experience required for a player to receive a contract of this class
    -- @generationPercentage: the probability of a player getting this class when a generation occurs (0-100%)
    -- @timeBetweenGenerations: the time in minutes that has to be passed since the last generation of this class
    -- @isImportant: if a class is important, then it needs police presence for it to be generated (svConfig.requiredPoliceAmount) and has a GPS tracker.
    -- @gpsHacksRequired: if the class is marked is important, then it will have a GPS tracker which has to be hacked this many times.
    -- @gpsHackMinTime: the minimum amount of time the player has to complete the GPS hacking mini game.
    -- @gpsHackMaxTime: the maximum amount of time the player has to complete the GPS hacking mini game.
    -- @maxContractsOfType: how many contracts of this type can be available at once
    -- @maxContactsPerSession: how many contracts of this type can one player receive per restart
    -- @priceMin: the minimum crypto price needed to accept the contract
    -- @priceMax: the maximum crypto price needed to accept the contract
    -- @minScratchPrice = the minimum crypto price needed to VIN scratch (take it yourself) the vehicle
    -- @maxScratchPrice = the maximum crypto price needed to VIN scratch (take it yourself) vehicle
    -- @rewardCashMin: the minimum cash reward
    -- @rewardCashMax: the maximum cash reward
    -- @rewardCryptoMin: the minimum crypto reward
    -- @rewardCryptoMax: the maximum crypto reward
    -- @experiencePerJob: amount of experience points received when the contract is successful
    -- @bonusExperienceMultiplier: the multiplier by which 'experiencePerJob' will be multiplied with when 'bonusExperienceMinimumMembers' is reached. Used only when 'splitExperienceInGroups' is true.
    -- @bonusExperienceMinimumMembers: the minimum number of members required within a group for the bonus 'bonusExperienceMultiplier' to take effect. Used only when 'splitExperienceInGroups' is true.
    -- @tuningChance: the probability of the vehicle being tuned (0-100%)
    -- @riskChances: the probability of different risks on the vehicle
        -- @doorsLocked: the probability that vehicle doors are locked
        -- @advancedLockChance: the probability that vehicle doors are locked with an advanced lock (must use a better lock pick than the bad one)
        -- @advancedSystemChance: the probability that vehicle doors are locked with an high-tech system (must use a hacking device)
        -- @npcChance: the probability (percentage 0-100) that killer NPCs will spawn when you try to hack the vehicle.
            -- npcChance can only be higher than 0 on classes that have isImportant = true. This is because isImportant boosts use different spawns that
            -- have npc spawn locations built in (shared.lua advancedVehicleCoords). DO NOT use this variable on lower, non-important boosts.

    vehicleClasses = {
        [1] = {
            class = "X",
            xpRequired = 3000,
            generationPercentage = 1,
            timeBetweenGenerations = 180,
            isImportant = true,
            gpsHacksRequired = 25,
            gpsHackMinTime = 25,
            gpsHackMaxTime = 25,
            maxContractsOfType = 1,
            maxContractsPerSession = 1,
            priceMin = 500,
            priceMax = 900,
            minScratchPrice = 7000,
            maxScratchPrice = 11000,
            rewardCashMin = 50000,
            rewardCashMax = 80000,
            rewardCryptoMin = 1000,
            rewardCryptoMax = 1400,
            experiencePerJob = 12,
            bonusExperienceMultiplier = 4,
            bonusExperienceMinimumMembers = 4,
            tuningChance = 25,
            riskChances = {
                doorsLocked = 100,
                advancedLockChance = 0,
                advancedSystemChance = 100,
                npcChance = 100
            }
        },
        [1] = {
            class = "S",
            xpRequired = 2500,
            generationPercentage = 1,
            timeBetweenGenerations = 120,
            isImportant = true,
            gpsHacksRequired = 20,
            gpsHackMinTime = 20,
            gpsHackMaxTime = 25,
            maxContractsOfType = 1,
            maxContractsPerSession = 1,
            priceMin = 500,
            priceMax = 900,
            minScratchPrice = 7000,
            maxScratchPrice = 11000,
            rewardCashMin = 50000,
            rewardCashMax = 80000,
            rewardCryptoMin = 1000,
            rewardCryptoMax = 1400,
            experiencePerJob = 12,
            bonusExperienceMultiplier = 4,
            bonusExperienceMinimumMembers = 4,
            tuningChance = 25,
            riskChances = {
                doorsLocked = 100,
                advancedLockChance = 0,
                advancedSystemChance = 100,
                npcChance = 100
            }
        },
        [2] = {
            class = "A",
            xpRequired = 1000,
            generationPercentage = 30,
            timeBetweenGenerations = 30,
            isImportant = true,
            gpsHacksRequired = 10,
            gpsHackMinTime = 25,
            gpsHackMaxTime = 30,
            maxContractsOfType = 1,
            maxContractsPerSession = 2,
            priceMin = 250,
            priceMax = 450,
            minScratchPrice = 2500,
            maxScratchPrice = 4500,
            rewardCashMin = 27500,
            rewardCashMax = 37500,
            rewardCryptoMin = 500,
            rewardCryptoMax = 700,
            experiencePerJob = 8,
            bonusExperienceMultiplier = 4,
            bonusExperienceMinimumMembers = 4,
            tuningChance = 25,
            riskChances = {
                doorsLocked = 100,
                advancedLockChance = 0,
                advancedSystemChance = 100,
                npcChance = 100
            }
        },
        [3] = {
            class = "B",
            xpRequired = 100,
            generationPercentage = 35,
            timeBetweenGenerations = 0,
            isImportant = false,
            maxContractsOfType = 1,
            maxContractsPerSession = 0,
            priceMin = 40,
            priceMax = 60,
            minScratchPrice = 400,
            maxScratchPrice = 600,
            rewardCashMin = 2500,
            rewardCashMax = 3500,
            rewardCryptoMin = 60,
            rewardCryptoMax = 90,
            experiencePerJob = 3,
            bonusExperienceMultiplier = 4,
            bonusExperienceMinimumMembers = 3,
            tuningChance = 25,
            riskChances = {
                doorsLocked = 100,
                advancedLockChance = 50,
                advancedSystemChance = 0,
                npcChance = 0
            }
        },
        [4] = {
            class = "C",
            xpRequired = 6,
            generationPercentage = 45,
            timeBetweenGenerations = 0,
            isImportant = false,
            maxContractsOfType = 2,
            maxContractsPerSession = 0,
            priceMin = 3,
            priceMax = 6,
            minScratchPrice = 30,
            maxScratchPrice = 60,
            rewardCashMin = 1300,
            rewardCashMax = 2300,
            rewardCryptoMin = 6,
            rewardCryptoMax = 9,
            experiencePerJob = 2,
            bonusExperienceMultiplier = 3,
            bonusExperienceMinimumMembers = 2,
            tuningChance = 25,
            riskChances = {
                doorsLocked = 100,
                advancedLockChance = 0,
                advancedSystemChance = 0,
                npcChance = 0
            }
        },
        [5] = {
            xpRequired = 0,
            class = "D",
            generationPercentage = 70,
            timeBetweenGenerations = 0,
            isImportant = false,
            maxContractsOfType = 3,
            maxContractsPerSession = 0,
            priceMin = 0,
            priceMax = 0,
            minScratchPrice = 20,
            maxScratchPrice = 40,
            rewardCashMin = 700,
            rewardCashMax = 1500,
            rewardCryptoMin = 1,
            rewardCryptoMax = 1,
            experiencePerJob = 1,
            bonusExperienceMultiplier = 2,
            bonusExperienceMinimumMembers = 2,
            tuningChance = 25,
            riskChances = {
                doorsLocked = 0,
                advancedLockChance = 0,
                advancedSystemChance = 0,
                npcChance = 0
            }
        }
    },

    storeItems = {
        ['racingtablet'] = {
            cashRequired = 1500,
            cryptoRequired = 300,
            availablePerRestart = 5,
            isSoldOut = false,
            title = "Racing tablet",
            description = "Lets you compete and start different races.",
            iconFile = 'racingtablet.png',
            receiveItemIds = {
                [1] = 'racingtablet'
            }
        },
        ['lockpick'] = {
            cashRequired = 50,
            cryptoRequired = 10,
            availablePerRestart = 5,
            isSoldOut = false,
            title = "Lockpick",
            description = "A low-quality lockpick which will get the job done.",
            iconFile = 'lockpick.png',
            receiveItemIds = {
                [1] = 'lockpick'
            }
        },
        ['repairkit'] = {
            cashRequired = 100,
            cryptoRequired = 20,
            availablePerRestart = 5,
            isSoldOut = false,
            title = "Repair kit",
            description = "Will get your car moving when you break down.",
            iconFile = 'repair-kit.png',
            receiveItemIds = {
                [1] = 'repairkit'
            }
        }
    }
}

-- Feel free to add your own vehicles here. Most of the default cars are here, modded cars have to be added!
supportedVehicles = {
    { name = "Grotti Brioso R/A", model = "brioso", class = "A" },
    { name = "BF Club", model = "club", class = "B" },
    { name = "Dinka Blista", model = "blista", class = "B" },
    { name = "Dinka Sugoi", model = "sugoi", class = "B" },
    { name = "Bollokon Prairie", model = "prairie", class = "B" },
    { name = "Weeny Issi Sport", model = "issi7", class = "B" },
    { name = "Vapid Flash GT", model = "flashgt", class = "B" },
    { name = "Dinka Blista Compact", model = "blista2", class = "C" },
    { name = "Weeny Issi", model = "issi2", class = "C" },
    { name = "Benefactor Panto", model = "panto", class = "C" },
    { name = "Declasse Rhapsody", model = "rhapsody", class = "C" },
    { name = "Asbo", model = "asbo", class = "C" },
    { name = "Weeny Issi Classic", model = "issi3", class = "C" },

    { name = "Declasse Emperor (Rusty)", model = "emperor2", class = "D" },
    { name = "Dundreary Regina", model = "regina", class = "D" },
    { name = "Declasse Asea", model = "asea", class = "D" },
    { name = "Declasse Emperor", model = "emperor", class = "D" },
    { name = "Karin Dilettante", model = "dilettante", class = "D" },
    { name = "Benefactor Schwartzer", model = "schwarzer", class = "A" },
    { name = "Vulcar Nebula Turbo", model = "nebula", class = "A" },
    { name = "Enus Stafford", model = "stafford", class = "A" },
    { name = "Lampadati Komoda", model = "komoda", class = "B" },
    { name = "Albany VSTR", model = "vstr", class = "B" },
    { name = "Enus Windsor Drop", model = "windsor2", class = "B" },
    { name = "Karin Kuruma", model = "kuruma", class = "B" },
    { name = "Karin Sultan", model = "sultan", class = "B" },
    { name = "Ubermacht Revolter", model = "revolter", class = "B" },
    { name = "Ubermacht Schafter", model = "schafter2", class = "B" },
    { name = "Ubermacht Schafter V12", model = "schafter3", class = "B" },
    { name = "Ubermacht Schafter V12 LWB", model = "schafter4", class = "B" },
    { name = "Enus Cognoscenti", model = "cognoscenti", class = "B" },
    { name = "Enus Cognoscenti 55", model = "cog55", class = "B" },
    { name = "Cheval Fugitive", model = "fugitive", class = "B" },
    { name = "Karin Intruder", model = "intruder", class = "B" },
    { name = "Declasse Premier", model = "premier", class = "B" },
    { name = "Zirconium Stratum", model = "stratum", class = "B" },
    { name = "Enus Super Diamond", model = "superd", class = "B" },
    { name = "Obey Tailgater", model = "tailgater", class = "B" },
    { name = "Ocelot Jackal", model = "jackal", class = "B" },
    { name = "Ubermacht Oracle", model = "oracle", class = "B" },
    { name = "Ubermacht Oracle XS", model = "oracle2", class = "B" },
    { name = "Lampadati Felon", model = "felon", class = "B" },
    { name = "Coil Raiden", model = "raiden", class = "B" },
    { name = "Cheval Surge", model = "surge", class = "B" },
    { name = "Cheburek", model = "cheburek", class = "B" },
    { name = "Glendale Custom", model = "glendale2", class = "C" },
    { name = "Karin Asterope", model = "asterope", class = "C" },
    { name = "Vulcar Ingot", model = "ingot", class = "C" },
    { name = "Albany Primo", model = "primo", class = "C" },
    { name = "Albany Primo Custom", model = "primo2", class = "C" },
    { name = "Vapid Stanier", model = "stanier", class = "C" },
    { name = "Vapid Taxi", model = "taxi", class = "C" },
    { name = "Dundreary Stretch", model = "stretch", class = "C" },
    { name = "Vulcar Warrener", model = "warrener", class = "C" },
    { name = "Albany Washington", model = "washington", class = "C" },
    { name = "Vulcar Fagaloa", model = "fagaloa", class = "C" },

    { name = "Bravado Banshee", model = "banshee", class = "A" },
    { name = "Ubermacht Sentinel SG4", model = "sentinelsg4", class = "A" },
    { name = "Invetero Coquette", model = "coquette", class = "A" },
    { name = "Obey 9F", model = "ninef", class = "A" },
    { name = "Obey 9F Cabrio", model = "ninef2", class = "A" },
    { name = "Obey 8F Drafter", model = "drafter", class = "A" },
    { name = "Albany Alpha", model = "alpha", class = "A" },
    { name = "Grotti Bestia GTS", model = "bestiagts", class = "A" },
    { name = "Grotti Carbonizzare", model = "carbonizzare", class = "A" },
    { name = "Pfister Comet", model = "comet2", class = "A" },
    { name = "Pfister Comet Retro", model = "comet3", class = "A" },
    { name = "Pfister Comet SR", model = "comet5", class = "A" },
    { name = "Dinka Jester Retro", model = "jester3", class = "A" },
    { name = "Dinka Kanjo", model = "kanjo", class = "A" },
    { name = "Annis Elegy RH8", model = "elegy2", class = "A" },
    { name = "Benefactor Feltzer", model = "feltzer2", class = "A" },
    { name = "Lampadati Furore GT", model = "furoregt", class = "A" },
    { name = "Dinka Jester", model = "jester", class = "A" },
    { name = "Ocelot Jugular", model = "jugular", class = "A" },
    { name = "Ocelot Lynx", model = "lynx", class = "A" },
    { name = "Dewbauchee Massacro", model = "massacro", class = "A" },
    { name = "Ocelot Pariah", model = "pariah", class = "A" },
    { name = "Maibatsu Penumbra", model = "penumbra", class = "A" },
    { name = "Maibatsu Penumbra FF", model = "penumbra2", class = "A" },
    { name = "Dewbauchee Rapid GT", model = "rapidgt", class = "A" },
    { name = "Dewbauchee Rapid GT Cabrio", model = "rapidgt2", class = "A" },
    { name = "Hijak Ruston", model = "ruston", class = "A" },
    { name = "Dewbauchee Seven-70", model = "seven70", class = "A" },
    { name = "Dewbauchee Specter", model = "specter", class = "A" },
    { name = "Dewbauchee Specter Custom", model = "specter2", class = "A" },
    { name = "Benefactor Surano", model = "surano", class = "A" },
    { name = "Enus Cognoscenti Cabrio", model = "cogcabrio", class = "A" },
    { name = "Ocelot F620", model = "f620", class = "A" },
    { name = "Lampadati Felon GT", model = "felon2", class = "A" },
    { name = "Ubermacht Zion", model = "zion", class = "A" },
    { name = "Ubermacht Zion Cabrio", model = "zion2", class = "A" },
    { name = "Enus Paragon", model = "paragon", class = "A" },
    { name = "Enus Windsor", model = "windsor", class = "A" },
    { name = "Coil Voltic", model = "voltic", class = "A" },
    { name = "Ubermacht Sentinel", model = "sentinel", class = "B" },
    { name = "Ubermacht Sentinel XS", model = "sentinel2", class = "B" },
    { name = "Shyster Fusilade", model = "fusilade", class = "B" },
    { name = "Karin Futo", model = "futo", class = "B" },
    { name = "Karin Sultan Classic", model = "sultan2", class = "B" },
    { name = "Ubermacht Sentinel Classic", model = "sentinel3", class = "B" },
    { name = "Dewbauchee Exemplar", model = "exemplar", class = "B" },
    { name = "Pfister Neon", model = "neon", class = "B" },
    { name = "Annis Elegy Retro", model = "elegy", class = "S" },
    { name = "Bravado Banshee 900R", model = "banshee2", class = "S" },
    { name = "Sultan RS", model = "sultanrs", class = "S" },

    { name = "Karin 190z", model = "z190", class = "A" },
    { name = "Ubermacht Zion Classic", model = "zion3", class = "B" },
    { name = "Annis Savestra", model = "savestra", class = "B" },
    { name = "Grotti Stinger", model = "stinger", class = "B" },
    { name = "Grotti Stinger GT", model = "stingergt", class = "B" },
    { name = "Declasse Vigero", model = "vigero", class = "B" },
    { name = "Cheval Picador", model = "picador", class = "B" },
    { name = "Imponte Phoenix", model = "phoenix", class = "B" },
    { name = "Albany Buccaneer", model = "buccaneer", class = "B" },
    { name = "Declasse Stallion", model = "stalion", class = "B" },
    { name = "Dewbauchee Rapid GT Classic", model = "rapidgt3", class = "B" },
    { name = "Benefactor Stirling GT", model = "feltzer3", class = "B" },
    { name = "Lampadati Casco", model = "casco", class = "B" },
    { name = "Ocelot Swinger", model = "swinger", class = "B" },
    { name = "Lampadati Viseris", model = "viseris", class = "B" },
    { name = "Invetero Coquette Classic", model = "coquette2", class = "B" },
    { name = "Invetero Coquette Blackfin", model = "coquette3", class = "B" },
    { name = "Grotti GT500", model = "gt500", class = "B" },
    { name = "Obey Omnis", model = "omnis", class = "B" },
    { name = "Lampadati Tropos Rallye", model = "tropos", class = "B" },
    { name = "Vapid GB200", model = "gb200", class = "B" },
    { name = "Lampadati Michelli GT", model = "michelli", class = "B" },
    { name = "Vapid Retinue", model = "retinue", class = "B" },
    { name = "Vapid Retinue MkII", model = "retinue2", class = "B" },
    { name = "Grotti Cheetah Classic", model = "cheetah2", class = "S" },
    { name = "Pegassi Infernus Classic", model = "infernus2", class = "S" },
    { name = "Pegassi Torero", model = "torero", class = "S" },

    { name = "Zentorno", model = "zentorno", class = "A" },
    { name = "Grotti Turismo R", model = "turismor", class = "A" },
    { name = "Infernus", model = "infernus", class = "A" },
    { name = "Bullet", model = "bullet", class = "A" },
    { name = "Grotti Furia", model = "furia", class = "S" },
    { name = "Coquette D10", model = "coquette4", class = "S" },

    { name = "Declasse Tornado", model = "tornado", class = "D" },
    { name = "Declasse Tornado Cabrio", model = "tornado2", class = "D" },
    { name = "Declasse Voodoo", model = "voodoo2", class = "D" },
    { name = "Declasse Voodoo Custom", model = "voodoo", class = "D" },
    { name = "Albany Hermes", model = "hermes", class = "D" },
    { name = "Vapid Hustler", model = "hustler", class = "D" },
    { name = "Declasse Tornado (Rusty)", model = "tornado3", class = "D" },
    { name = "Vapid Peyote", model = "peyote", class = "D" },
    { name = "Albany Virgo Custom", model = "virgo2", class = "D" },
    { name = "Albany Virgo Classic", model = "virgo3", class = "D" },
    { name = "Chariot Romero Hearse", model = "romero", class = "D" },
    { name = "Weeny Dynasty", model = "dynasty", class = "D" },
    { name = "Manana Custom", model = "manana2", class = "D" },
    { name = "Lampadati Pigalle", model = "pigalle", class = "D" },
    { name = "Declasse Tornado Custom", model = "tornado5", class = "D" },
    { name = "Vapid Dominator", model = "dominator", class = "A" },
    { name = "Vapid Dominator GTX", model = "dominator3", class = "A" },
    { name = "Bravado Gauntlet", model = "gauntlet", class = "A" },
    { name = "Vapid Blade", model = "blade", class = "A" },
    { name = "Imponte Dukes", model = "dukes", class = "A" },
    { name = "Declasse Vamos", model = "vamos", class = "A" },
    { name = "Vapid Ellie ", model = "ellie", class = "A" },
    { name = "Imponte Ruiner", model = "ruiner", class = "A" },
    { name = "Declasse Sabre Turbo", model = "sabregt", class = "A" },
    { name = "Vapid Slamvan", model = "slamvan", class = "A" },
    { name = "Vapid Slamvan Custom", model = "slamvan3", class = "A" },
    { name = "Declasse Tampa", model = "tampa", class = "A" },
    { name = "Declasse Yosemite", model = "yosemite", class = "A" },
    { name = "Declasse Tornado Rat", model = "tornado6", class = "A" },
    { name = "Bravado Buffalo", model = "buffalo", class = "B" },
    { name = "Bravado Buffalo S", model = "buffalo2", class = "B" },
    { name = "Albany Virgo", model = "virgo", class = "B" },
    { name = "Declasse Sabre Turbo Custom", model = "sabregt2", class = "B" },
    { name = "Willard Faction", model = "faction", class = "B" },
    { name = "Willard Faction Custom", model = "faction2", class = "B" },
    { name = "Albany Buccaneer Custom", model = "buccaneer2", class = "B" },
    { name = "Declasse Tulip", model = "tulip", class = "B" },
    { name = "Declasse Impaler", model = "impaler", class = "B" },
    { name = "Vapid Clique", model = "clique", class = "B" },
    { name = "Bravado Rat-Truck", model = "ratloader2", class = "B" },
    { name = "Declasse Mamba", model = "mamba", class = "B" },
    { name = "Imponte Nightshade", model = "nightshade", class = "B" },
    { name = "Bravado Rat-Loader", model = "ratloader", class = "C" },
    { name = "Truffade Z-Type", model = "ztype", class = "C" },
    { name = "Vapid Hotknife ", model = "hotknife", class = "C" },
    { name = "Benefactor Glendale", model = "glendale", class = "C" },
    { name = "Vapid Chino", model = "chino", class = "C" },
    { name = "Willard Faction Donk", model = "faction3", class = "C" },
    { name = "Vapid Chino Custom", model = "chino2", class = "C" },
    { name = "Bravado Gauntlet Classic", model = "gauntlet3", class = "S" },
    { name = "Bravado Gauntlet Hellfire", model = "gauntlet4", class = "S" },
    { name = "Declasse Hotring Sabre", model = "hotring", class = "S" },
    { name = "Schyster Deviant", model = "deviant", class = "S" },
    { name = "Beater Dukes", model = "dukes3", class = "S" },

    { name = "Nagasaki Blazer", model = "blazer", class = "D" },
    { name = "Nagasaki Outlaw", model = "outlaw", class = "B" },
    { name = "Maxwell Vagrant", model = "vagrant", class = "B" },
    { name = "Karin Everon", model = "everon", class = "B" },
    { name = "Annis Hellion", model = "hellion", class = "B" },
    { name = "Vapid Trophy Truck", model = "trophytruck", class = "B" },
    { name = "Vapid Desert Raid", model = "trophytruck2", class = "B" },
    { name = "Nagasaki Street Blazer", model = "blazer4", class = "C" },
    { name = "Benefactor Dubsta 6x6", model = "dubsta3", class = "C" },
    { name = "BF Bifta", model = "bifta", class = "C" },
    { name = "Vapid Contender", model = "contender", class = "C" },
    { name = "Coil Brawler", model = "brawler", class = "C" },
    { name = "Vapid Guardian", model = "guardian", class = "C" },
    { name = "Canis Freecrawler", model = "freecrawler", class = "C" },

    { name = "Canis Bodhi", model = "bodhi2", class = "D" },
    { name = "Declasse Rancher XL", model = "rancherxl", class = "D" },
    { name = "Bravado Duneloader", model = "dloader", class = "D" },
    { name = "Vapid Sadler", model = "sadler", class = "D" },
    { name = "Vapid Sandking XL", model = "sandking", class = "D" },
    { name = "Vapid Sandking", model = "sandking2", class = "D" },
    { name = "Canis Kalahari", model = "kalahari", class = "D" },
    { name = "Pegassi Toros", model = "toros", class = "A" },
    { name = "Ubermacht Rebla GTS", model = "rebla", class = "B" },
    { name = "Lampadati Novak", model = "novak", class = "B" },
    { name = "Gallivanter Baller LE", model = "baller3", class = "B" },
    { name = "Benefactor Dubsta Mandem", model = "dubsta2", class = "B" },
    { name = "Benefactor Dubsta", model = "dubsta", class = "B" },
    { name = "Bravado Gresley", model = "gresley", class = "B" },
    { name = "Enus Huntley S", model = "huntley", class = "B" },
    { name = "Obey Rocoto", model = "rocoto", class = "B" },
    { name = "Benefactor Serrano", model = "serrano", class = "B" },
    { name = "Benefactor XLS", model = "xls", class = "B" },
    { name = "Landstalker XL", model = "landstalker2", class = "C" },
    { name = "Gallivanter Baller", model = "baller", class = "C" },
    { name = "Gallivanter Baller", model = "baller2", class = "C" },
    { name = "Karin BeeJay XL", model = "bjxl", class = "C" },
    { name = "Albany Cavalcade", model = "cavalcade", class = "C" },
    { name = "Albany Cavalcade", model = "cavalcade2", class = "C" },
    { name = "Fathom FQ-2", model = "fq2", class = "C" },
    { name = "Declasse Granger", model = "granger", class = "C" },
    { name = "Emperor Habanero", model = "habanero", class = "C" },
    { name = "Dundreary Landstalker", model = "landstalker", class = "C" },
    { name = "Mammoth Patriot", model = "patriot", class = "C" },
    { name = "Mammoth Patriot WCR", model = "patriot2", class = "C" },
    { name = "Vapid Radius", model = "radi", class = "C" },
    { name = "Canis Seminole", model = "seminole", class = "C" },
    { name = "Vapid Caracara", model = "caracara2", class = "C" },
    { name = "Vapid Bobcat XL", model = "bobcatxl", class = "C" },
    { name = "BF Injection", model = "bfinjection", class = "C" },
    { name = "Karin Rebel", model = "rebel", class = "C" },
    { name = "Karin Rebel", model = "rebel2", class = "C" },
    { name = "Bravado Bison", model = "bison", class = "C" },
    { name = "Benefactor Streiter", model = "streiter", class = "C" },
    { name = "Vapid Riata", model = "riata", class = "C" },
    { name = "Canis Kamacho", model = "kamacho", class = "C" },
    { name = "Canis Mesa", model = "mesa", class = "C" },
    { name = "Pfister Comet Safari", model = "comet4", class = "C" },

    { name = "Bravado Paradise", model = "paradise", class = "D" },
    { name = "Flatbed", model = "flatbed", class = "C" },
    { name = "Brute Pony", model = "pony", class = "D" },
    { name = "Manana", model = "manana", class = "D" },
    { name = "Bravado Rumpo News", model = "rumpo", class = "D" },
    { name = "Vapid Speedo", model = "speedo", class = "D" },
    { name = "Declasse Burrito", model = "burrito3", class = "D" },
    { name = "Zirconium Journey", model = "journey", class = "D" },
    { name = "BF Surfer", model = "surfer", class = "D" },
    { name = "BF Surfer Kona", model = "surfer2", class = "D" },
    { name = "Bravado Youga Classic", model = "youga2", class = "D" },
    { name = "Vapid Minivan", model = "minivan", class = "D" },
    { name = "Declasse Burrito G", model = "gburrito", class = "D" },
    { name = "Brute Camper", model = "camper", class = "D" },
    { name = "Minivan Custom", model = "minivan2", class = "B" },
    { name = "Bravado Youga", model = "youga", class = "C" },
    { name = "Bravado Rumpo Custom", model = "rumpo3", class = "C" },
    { name = "Declasse Moonbeam", model = "moonbeam", class = "C" },
    { name = "Declasse Moonbeam Custom", model = "moonbeam2", class = "C" },

    { name = "Ratbike", model = "ratbike", class = "C" },
    { name = "Akuma", model = "AKUMA", class = "C" },
    { name = "Bagger", model = "bagger", class = "C" },
    { name = "Bati 801", model = "bati", class = "C" },
    { name = "Bati 801RR", model = "bati2", class = "C" },
    { name = "BF400", model = "bf400", class = "C" },
    { name = "Carbon RS", model = "carbonrs", class = "C" },
    { name = "Cliffhanger", model = "cliffhanger", class = "C" },
    { name = "Daemon", model = "daemon", class = "C" },
    { name = "Double T", model = "double", class = "C" },
    { name = "Enduro", model = "enduro", class = "C" },
    { name = "Faggio", model = "faggio2", class = "C" },
    { name = "Gargoyle", model = "gargoyle", class = "C" },
    { name = "Hakuchou", model = "hakuchou", class = "C" },
    { name = "Hexer", model = "hexer", class = "C" },
    { name = "Innovation", model = "innovation", class = "C" },
    { name = "Lectro", model = "lectro", class = "C" },
    { name = "Nemesis", model = "nemesis", class = "C" },
    { name = "PCJ-600", model = "pcj", class = "C" },
    { name = "Ruffian", model = "ruffian", class = "C" },
    { name = "Sanchez", model = "sanchez", class = "C" },
    { name = "Manchez", model = "manchez", class = "C" },
    { name = "Sovereign", model = "sovereign", class = "C" },
    { name = "Thrust", model = "thrust", class = "C" },
    { name = "Shotaro", model = "SHOTARO", class = "C" },
    { name = "Vindicator", model = "vindicator", class = "C" },
    { name = "Zombiea", model = "zombiea", class = "C" },
    { name = "Zombieb", model = "zombieb", class = "C" },
    { name = "Wolfsbane", model = "wolfsbane", class = "C" },
    { name = "Nightblade", model = "nightblade", class = "C" },

    { name = "Faggio Custom", model = "faggio3", class = "C" },
    { name = "Cliffhanger", model = "Cliffhanger", class = "C" },
    { name = "Daemon Custom", model = "daemon2", class = "C" },
    { name = "Faggio", model = "faggio", class = "C" },

    { name = "BMX", model = "bmx", class = "C" },
    { name = "Cruiser", model = "cruiser", class = "C" },
    { name = "Fixter", model = "fixter", class = "C" },
    { name = "Scorcher", model = "scorcher", class = "C" },
    { name = "Pro 1", model = "tribike", class = "C" },
    { name = "Pro 2", model = "tribike2", class = "C" },
    { name = "Pro 3", model = "tribike3", class = "C" },

    { name = "Grotti Itali RSX", model = "italirsx", class = "S" },
    { name = "Mammoth Squaddie", model = "squaddie", class = "B" },
    { name = "Maibatsu Manchez Scout", model = "manchez2", class = "B" },
    { name = "Brioso Classic", model = "brioso2", class = "C" },
    { name = "BF Weevil", model = "weevil", class = "C" },
    { name = "Vapid Winky", model = "winky", class = "C" },
}