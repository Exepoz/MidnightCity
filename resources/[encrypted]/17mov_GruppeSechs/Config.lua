Config = {}

Config.useModernUI = true               -- In March 2023 the jobs have passed huge rework, and the UI has been changed. Set it to false, to use OLD no longer supported UI.
    Config.splitReward = false          -- This option work's only when useModernUI is false. If this option is true, the payout is: (Config.OnePercentWorth * Progress ) / PartyCount, if false then: (Config.OnePercentWorth * Progress)
Config.UseBuiltInNotifications = false   -- Set to false if you want to use ur framework notification style. Otherwise, the built in modern notifications will be used.=

Config.letBossSplitReward = true                    -- If it's true, then boss can manage whole party rewards percent in menu. If you'll set it to false, then everybody will get same amount.
Config.multiplyRewardWhileWorkingInGroup = true     -- If it's false, then reward will stay by default. For example $1000 for completing whole job. If you'll set it to true, then the payout will depend on how many players is there in the group. For example, if for full job there's $1000, then if player will work in 4 member group, the reward will be $4000. (baseReward * partyCount)
Config.UseTarget = true                -- Change it to true if you want to use a target system. All setings about the target system are under target.lua file.
Config.RequiredJob = "none"             -- Set to "none" if you dont want using jobs. If you are using target, you have to set "job" parameter inside every export in target.lua
Config.RequireJobAlsoForFriends = true          -- If it's false, then only host needs to have the job, if it's true then everybody from group needs to have the Config.RequiredJob
Config.RequireOneFriendMinimum = false  -- Set to true if you want to force players to create teams
Config.Reward = 5000                    -- Complete transport will give the team this value. 
Config.GiveRewardAfterHeist = false      -- Set to false, if you don't want to give players money after they have got robbed.
Config.JobCooldown = 20 * 60 -- 10 * 60            -- 0 minutes cooldown between making jobs (in brackets there's example for 10 minutes)
Config.GiveKeysToAllLobby = true                -- Set to false if you want to give keys only for group creator while starting job
Config.ProgressBarOffset = "25px"                   -- Value in px of counter offset on screen
Config.ProgressBarAlign = "bottom-right"            -- Align of the progressbar

-- ^ Options: top-left, top-center, top-right, bottom-left, bottom-center, bottom-right

Config.RewardItemsToGive = {
    -- {
    --     item_name = "water",
    --     chance = 100,
    --     amount = 1,
    -- },
}

Config.RequiredItem = "none"                        -- Set it to anything you want, to require players to have some item in their inventory before they start the job
Config.RequireItemFromWholeTeam = true              -- If it's false, then only host needs to have the required item, otherwise all team needs it.

Config.EnableDeliveriesToNonVaultPlaces = true     -- Set to true, if you want script to be able to deliver money to places where isVault = false in Config.BankLocations
Config.EnableEnteringCodeAnim = true                -- Set to false if you're using some custom MLO, and the anim dosen't looks good for u
Config.EnableHighlightBags = true                   -- Set to false if you dont want bags to highlight.
Config.ReEnableEngineAfterBlockingTime = 10000      -- Time in ms. When criminals will block the truck engine, after this time the engine will be reenabled

Config.EnableVehicleTeleporting = true          -- If its true, then the script will teleport the host to the company vehicle. If its false, then the company vehicle will apeear, but the whole squad need to go enter the car manually
Config.JobVehicleModel = "stockade"             -- Model of the company car

Config.vehicleRearBagsOffsets = {               -- Here you can change offsets for bags inside job vehicle
    [1] = { xyz = vec3(0.12, -1.32, 0.75), rotation = vec3(0.0, 15.0, 90.0) },
    [2] = { xyz = vec3(0.46, -1.32, 0.75), rotation = vec3(0.0, 15.0, 90.0) },
    [3] = { xyz = vec3(0.46, -2.36, 0.75), rotation = vec3(0.0, 15.0, 90.0) },
    [4] = { xyz = vec3(0.12, -2.36, 0.75), rotation = vec3(0.0, 15.0, 90.0) }
}

Config.InteractionKey = {
    -- Key dedicated to interaction with vehicles, vault doors, trolleys etc. 
    keyIndex = 51,
    keyString = "~r~[E] | ~s~",
}

Config.OpenDoorsTextBackwardOffset = -3.5       -- Backward offset to draw "Open Doors" text. Leave default if you're using default stockade as job vehicle model
Config.OpenDoorTextUpDownOffset = 1.5           -- Backward offset to draw "Open Doors" text. Leave default if you're using default stockade as job vehicle model

Config.PenaltyAmount = 500                      -- Penalty that is levied when a player finishes work without a company vehicle or not completed
Config.DeleteVehicleWithPenalty = false         -- Delete Vehicle even if its not company veh, and player accepted the penalty

Config.TrolleyModel = "prop_tea_trolly"         -- Trolleys model inside vault
Config.CashModel = "prop_anim_cash_pile_02"     -- One pile that is being spawned on the trolley
Config.AttachSettings = {
    -- Piles attaching on the trolleys settings
    startingOffset = vector3(-0.43, -0.17, 0.38),
    totalLenght = 12,
    totalHeight = 1,
    totalRows = 3,
}

Config.AutoCashGrabbing = true

Config.TabletPassword = "password"              -- Password for tablet
Config.TabletItemName = "gruppesechstablet"     -- Item you need to use to open the tablet

Config.DefaultMessages = {
    -- Enter here any messages that you want to be displayed on the chat at the very beggining
    -- "First Message", "Second Message", "Third Message", "etc...",
}

Config.PossibleLoots = {
    -- Here you can change possible loots for crime. Remember that the loot is not the payout. Payout for crime is loot * (Config.PercentForCrimeFromWholeLoot / 100) (By default 15% of loot)
    [1] = { loot = 25000, chance = 100 },
    [2] = { loot = 50000, chance = 50 },
    [3] = { loot = 75000, chance = 25 },
    [4] = { loot = 100000, chance = 12.5 },
}

Config.PercentForCrimeFromWholeLoot = 15    -- How many % of the whole loot the crime player will get after heist complete
Config.splitCrimeReward = true             -- Decide if reward should be splitted among the whole party, or every party member should get 100% of the reward
Config.ZonesName = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }

Config.MinimunFriendsToStartHeist = 2           -- Set Minimum friends count required to start the heist. 
Config.MinimumCopsToStartHeist = 2              -- Set Minimum cops on duty count required to start heist
Config.RequiredSecondsToFetch = 120              -- The time in seconds that is required to take control of a cash transport

Config.HeistVehBlipSettings = {
    -- Cash Transport truck blip settings, used in cops notification, and for crime after heist start.
    sprite = 477,
    color = 43,
    scale = 1.2,
    label = "Target Heist Truck",
    labelForCops = "Cash Transport Heist",
}

Config.AtmsLocations = {
    [1] = { coords = vector4(-56.94, -1751.34, 28.42, 230.3) },
    [2] = { coords = vector4(146.83, -1035.4, 28.34, 338.79) },
    [3] = { coords = vector4(25.34, -946.29, 28.36, 159.95)  },
    [4] = { coords = vector4(-204.95, -861.83, 29.27, 200.8) },
    [5] = { coords = vector4(-718.2, -914.85, 18.22, 263.38) },
    [6] = { coords = vector4(-820.93, -1081.14, 10.13, 207.38) },
    [7] = { coords = vector4(-1572.16, -547.39, 33.96, 4.1)  },
    [8] = { coords = vector4(1153.06, -326.29, 68.21, 276.57)},
    [9] = { coords = vector4(-165.42, 233.71, 93.92, 272.27) },
} 

Config.enableAtmsFillingUp = true               -- Set it to false, if you want to make script just source -> target transportation. When it's true, you also need to fill out some atms around the city, only then deliver the money to target
Config.howMuchAtmFillWillRemoveFromLoot = 5000  -- The heist loot will be smaller every ATM filling, here you can change this value
Config.neededAtms = 5                           -- Set how many ATM's you need to fill up
Config.AtmGuardModel = `s_m_m_prisguard_01`     -- Model of ped that will be spawned near the ATM

Config.VaultDoorsModels = {

    -- Add here some models of doors that you're using in your banks. Here's some of the defaults ones.

    `v_ilev_gb_vauldr`,
    `hei_prop_heist_sec_door`,
    `prop_ld_vault_door`,
    `reh_prop_reh_door_vault_01a`,
    `ch_prop_ch_vault_d_door_01a`,

    -- For k4mb1 Map:
    `k4mb1_genbank_framedoor`,
}

Config.DeliveryLocations = {
    -- Locations where bags have to delivered after complete heist
    { coords = vec3(459.810852, -546.846252, 27.2276749), rotation = vec3(0.0, -15.0, 0.0) },
    { coords = vec3(-92.62852, -73.6846161, 57.55671), rotation = vec3(0.0, 15.0, -120.0) },
    { coords = vec3(-212.200363, -1364.79993, 29.9253143), rotation = vec3(0.0, 15.0, -25.0) },
    { coords = vec3(-1296.69287, -1249.671, 3.1778616), rotation = vec3(0.0, -15.0, 0.0) },
}

Config.RestrictBlipToRequiredJob = false            -- Set to true, to hide job blip for players, who dont have RequiredJob. If requried job is "none", then this option will not have any effect.
Config.Blips = { -- Here you can configure Company blip.
    [1] = {
        Sprite = 460,
        Color = 69,
        Scale = 0.8,
        Pos = vector3(-195.32, -835.13, 30.73),
        Label = 'Gruppe Sechs Job'
    },
}

Config.MarkerSettings = {   -- used only when Config.UseTarget = false. Colors of the marker. Active = when player stands inside the marker.
    Active = {
        r = 129, 
        g = 214,
        b = 0,
        a = 200,
    },
    UnActive = {
        r = 65,
        g = 107,
        b = 0,
        a = 200,
    }
}

Config.Locations = {       -- Here u can change all of the base job locations. 
    DutyToggle = {
        Coords = {
            vector3(-195.32, -835.13, 30.73),
        },
        CurrentAction = 'open_dutyToggle',
        CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to ~y~start/finish~s~ work.',
        type = 'duty',
        scale = {x = 1.0, y = 1.0, z = 1.0}
    },
    FinishJob = {
        Coords = {
            vector3(-143.95, -822.31, 31.44),
        },
        CurrentAction = 'finish_job',
        CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to ~y~end ~s~working.',
        scale = {x = 3.0, y = 3.0, z = 3.0}
    },

}

Config.SpawnPoint = vector4(-143.95, -822.31, 30.89, 69.7)    -- Company car spawn point

Config.EnableClothesChange = true
Config.Clothes = {
    male = {
        ["mask"] = {clotheId = 0, variation = 0},
        ["arms"] = {clotheId = 1, variation = 0},
        ["pants"] = {clotheId = 24, variation = 0},
        ["bag"] = {clotheId = 45, variation = 0},
        ["shoes"] = {clotheId = 61, variation = 0},
        ["t-shirt"] = {clotheId = 58, variation = 0},
        ["torso"] = {clotheId = 139, variation = 7},
        ["kevlar"] = {clotheId = 11, variation = 1},
        ["decals"] = {clotheId = 0, variation = 0},
    },
    
    female = {
        ["mask"] = {clotheId = 0, variation = 0},
        ["arms"] = {clotheId = 17, variation = 0},
        ["pants"] = {clotheId = 34, variation = 0},
        ["bag"] = {clotheId = 45, variation = 0},
        ["shoes"] = {clotheId = 101, variation = 0},
        ["t-shirt"] = {clotheId = 35, variation = 0},
        ["torso"] = {clotheId = 136, variation = 7},
        ["kevlar"] = {clotheId = 9, variation = 1},
        ["decals"] = {clotheId = 0, variation = 0},
    }
}

Config.Lang = {

    -- Here you can changea all translations used in client.lua, and server.lua. Dont forget to translate it also under the HTML and JS file.

    -- Client
    ["no_permission"] = "Only the party owner can do that!",
    ["keybind"] = 'Marker Interaction',
    ["too_far"] = "Your party has started work, but you are too far from headquarters.",
    ["kicked"] = "You kicked %s out of the party",
    ["alreadyWorking"] = "First, complete the previous order",
    ["quit"] = "You have left the Team",
    ["wrongCar"] = "This is not your company vehicle",
    ["CarNeeded"] = "You need your company vehicle to finish the job.",
    ["nobodyNearby"] = "There is no one around",
    ["cantInvite"] = "To be able to invite more people, you must first finish the job",
    ["cantInviteCrime"] = "To be able to invite more people, you must first finish the heist",
    ["inviteSent"] = "Invite Sent!",
    ["spawnpointOccupied"] = "The car's spawn site is occupied",
    ["enterCode"] = "Enter Code",
    ["grabMoney"] = "Start grabbing",
    ["srcBank"] = "Source Bank",
    ["targetBank"]  = "Target Bank",
    ["notAllBags"] = "Your team didn't deliver all bags!",
    ["throwBag"] = "Throw Bag",
    ["notEverythingDone"] = "You didn't grab all the money!",
    ["someonesInside"] = "Someone is inside the vault! You cant lock him",
    ["startingTutorial"] = "The job involves transporting cash from the source bank or location, to the destination bank. Head to the designated location for more information. Remember that this is a dangerous job, you can expect numerous robbery attempts.",
    ["beforeMoneyGrabInBank"] =   "Your first step is to collect cash from the carts in the safe. You can't miss a single bill, nor can you leave anyone locked in the safe. Don't forget to close the vault door when you leave",
    ["beforeMoneyGrab"] =   "Your first step is to collect cash from the carts. You can't miss a single bill, after you'll collect all, the next steps will be explained",
    ["afterMoneyGrabTutorialInBank"] = "You took all the cash from the safe. Now close the vault door and then pack the bags of money on the car's trunk. Follow the procedures, if you don't put the bags down, you won't be able to move the car.",
    ["afterMoneyGrabTutorial"] = "You took all the cash from the carts. Now pack the bags of money on the car's trunk. Follow the procedures, if you don't put the bags down, you won't be able to move the car.",
    ["afterBagLoadingTutorial"] = "Bags loaded. From now on you can move the vehicle. Go to the marked place to deliver the bags!",
    ["afterDeliveringBagsTutorial"] = "You delivered the bags to the safe. This is where your work ends. Close the door to the safe and head to the base to get paid",
    ["AfterArrivalToTargetBank"] = "You approached the target bank, we unlocked the possibility of opening the back door. Go to the back of the cart to open the door and take your bags and go to the safe",
    ["afterAttack"] = "You have been attacked. Your cash will probably be stolen. Do not continue work, return to base",
    ["notReadyWarning"] = "The work is not completed. You can leave the service now but you will be charged a penalty and your paycheck will not be paid.",
    ["wrongCarWarning"] = "This is not your company car. You can still finish the job, but you will be charged a penalty",
    ["cantOpenTabletWhileOnDuty"] = "You cannot open this tablet while in transit",
    ["alreadyBusy"] = "You can't start a robbery because you're on duty or you're already running a robbery", 
    ["tooLate"] = "Transport with cash arrived at the site. You were late",
    ["endJob"] = "End Job",
    ["afterStartingHeist"] = "Your team has launched a heist on a cash shipment. Those with a tablet can now open it, there are written out all the steps you need to take to rob the truck. You have to hurry, once the truck approaches the bank, your chance is gone.",
    ["startingFetching"] = "Tablet is now connecting to the truck.. Please do not move away from the truck to avoid breaking the connection",
    ["deliveryLocation"] = "Deliver Bags Here",
    ["copsNotification"] = "Suspicious activity around the transportation of cash was detected. Check it out - location marked on the GPS",
    ["didntMakeThirdStep"] = "You Didn't take a bag from the truck",
    ["notADriver"] = "You need to be a driver of vehicle to end the job",
    ["atmBlip"] = "Fill the ATM",
    ["deliverCash"] = "Deliver Cash To Guard",
    ["partyIsFull"] = "Failed to send an invite, your group is full",
    ["wrongReward1"] = "The payout percentage should be between 0 and 100",
    ["wrongReward2"] = "The total percentage of all payouts exceeded 100%",
    ["dontForgetDoors"] = "Don't forget to close vault doors!",
    ["cantLeaveLobby"] = "You can't leave the lobby while you're working. First, end the job.",
    
    -- Server
    ["isAlreadyHost"] = "This player leads his team.",
    ["isBusy"] = "This player already belongs to another team.", 
    ["hasActiveInvite"] = "This Player already has an active invitation from someone.",
    ["HaveActiveInvite"] = "You already have an active invitation to join the team.",
    ["InviteDeclined"] = "Your invitation has been declined.",
    ["InviteAccepted"] = "Your invitation has been accepted!",
    ["error"] = "There was a Problem joining a team. Please try again later.",
    ["kickedOut"] = "You've been kicked out of the team!",
    ["reward"] = "You have received a payout of $",
    ["RequireOneFriend"] = "This job requires at least one team member",
    ["penalty"] = "You paid a fine in the amount of $",
    ["clientsPenalty"] = "The team's host accepted the punishment. You have not received the payment",
    ["noFreeLocations"] = "We currently have no orders for you",
    ["notEnoughClients"] = "You don't have enough team members to launch a heist",
    ["notEnoughPolice"] = "There are not enough officers on duty in the city",
    ["dontHaveReqItem"] = "You or someone from your team do not have the required item to start work",
    ["notEverybodyHasRequiredJob"] = "Not every of your friends have the required job",
    ["alreadyInLegalParty"] = "This player is already working somewhere else",
    ["someoneIsOnCooldown"] = "You or someone from your team can't make the job now (cooldown: %s)",
    ["hours"] = "h",
    ["minutes"] = "m",
    ["seconds"] = "s",
    ["newBoss"] = "The previous lobby boss has left the server. You are now the team leader",
}

Config.HintNotifications = {
    Grabbing = "~INPUT_FRONTEND_PAUSE_ALTERNATE~ Stop Grabbing~n~~INPUT_SKIP_CUTSCENE~ Grab pile",
    GrabbingAuto = "~INPUT_FRONTEND_PAUSE_ALTERNATE~ Stop Grabbing",
    Throwing = "~INPUT_CONTEXT~ Throw bag", 
    OpenDoors = "~INPUT_CONTEXT~ Open Doors",
    GrabBag = "~INPUT_CONTEXT~ Grab Bag"
}

Config.BankLocations = {

    -- [enterHereIndex] = {
    --     rewardBonus = 0,
    --     isVault = true,                                          -- Set to true if you want to make this place not as Bank. So you'll not need to open bank doors 
    --     DriverCoords = vec3(147.2554, -1046.259, 29.56812),      -- Not required when isVault = false, Coords of the driver where player is entering code
    --     DoorsCoords = vec3(148.0266, -1044.364, 29.50693),       -- Not required when isVault = false, Coords of target doors
    --     ObjectsToDelete = {
    --          Add here what props you want to delete from ur interior, for example some locked doors or somehting
                -- [`v_ilev_gb_vaubar`] = true,
                -- For k4mb1 Map:
                -- [-2075524880] = true,
                -- For gabz map:
                -- [-2018598162] = true,
                -- [-1645229742] = true,
                -- [-1474093263] = true,
    --     },
    --     TrolleysCoords = {                                       -- Coords where trolleys will be spawned, you can add here as much trolleys as you want
    --         { coords = vec3(149.109924, -1051.03772, 28.9334488), rotation = vec3(0.0, 0.0, -20.0)},
    --         { coords = vec3(146.926346, -1050.24292, 28.9334488), rotation = vec3(0.0, 0.0, -20.0)},
    --         { coords = vec3(150.20076, -1050.78345, 28.8059521), rotation = vec3(0.0, 0.0, 69.5)},
    --         { coords = vec3(150.8953, -1048.87512, 28.8059521), rotation = vec3(0.0, 0.0, 69.5)},
    --     },
    --     DeliveryLocations = {                                    -- Coords of bags while delivering at the end
    --         { coords = vec3(148.499268, -1049.23865, 29.1391388), rotation = vec3(0, 15.0, -110.0)},
    --         { coords = vec3(148.277466, -1049.15784, 29.1391388), rotation = vec3(0, 15.0, -110.0)},
    --         { coords = vec3(148.066849, -1049.0813, 29.1391388), rotation = vec3(0, 15.0, -110.0)},
    --         { coords = vec3(147.838135, -1048.998, 29.1391388), rotation = vec3(0, 15.0, -110.0)},
    --     }, 
    --     BlipCoords = vector3(150.75, -1037.82, 29.38),           -- Place blip
    -- },

    [1] = {
        rewardBonus = 0,
        isVault = true,
        DriverCoords = vec3(147.2554, -1046.259, 29.56812),
        DoorsCoords = vec3(148.0266, -1044.364, 29.50693),
        ObjectsToDelete = {
            -- Add here what props you want to delete from ur interior, for example some locked doors or somehting
            [`v_ilev_gb_vaubar`] = true,
            -- For k4mb1 Map:
            -- [-2075524880] = true,
            -- For gabz map:
            -- [-2018598162] = true,
            [-1645229742] = true,
            [-1474093263] = true,
        },
        TrolleysCoords = {
            { coords = vec3(150.924408, -1048.90723, 28.8212528), rotation = vec3(0.0, 0.0, 70.0)},
            { coords = vec3(149.543655, -1051.25586, 28.7651482), rotation = vec3(0.0, 0.0, -20.0)},
            { coords = vec3(146.855759, -1050.27759, 28.7651482), rotation = vec3(0.0, 0.0, -20.0)},
            { coords = vec3(147.128189, -1047.69653, 28.7403049), rotation = vec3(0.0, 0.0, -110.0)},
        },
        DeliveryLocations = {
            { coords = vec3(148.499268, -1049.23865, 29.1391388), rotation = vec3(0, 15.0, -110.0)},
            { coords = vec3(148.277466, -1049.15784, 29.1391388), rotation = vec3(0, 15.0, -110.0)},
            { coords = vec3(148.066849, -1049.0813, 29.1391388), rotation = vec3(0, 15.0, -110.0)},
            { coords = vec3(147.838135, -1048.998, 29.1391388), rotation = vec3(0, 15.0, -110.0)},
        }, 
        BlipCoords = vector3(150.75, -1037.82, 29.38),
    },

    [2] = {
        rewardBonus = 0,
        isVault = true,
        DriverCoords = vec3(-353.474, -55.48119, 49.23662),
        DoorsCoords = vec3(-352.7365, -53.57248, 49.175433),
        ObjectsToDelete = {
            -- Add here what props you want to delete from ur interior, for example some locked doors or somehting
            [`v_ilev_gb_vaubar`] = true,
            -- For k4mb1 Map:
            -- [-2075524880] = true,
            -- For gabz map:
            -- [-2018598162] = true,
            [-1645229742] = true,
            [-1474093263] = true,
        },
        TrolleysCoords = {
            { coords = vec3(-349.764832, -58.0917549, 48.4574), rotation = vec3(0.0, 0.0, 70.0)},
            { coords = vec3(-351.1456, -60.4404144, 48.4012947), rotation = vec3(0.0, 0.0, -20.0)},
            { coords = vec3(-353.833466, -59.4621239, 48.4012947), rotation = vec3(0.0, 0.0, -20.0)},
            { coords = vec3(-353.561066, -56.88106, 48.3764534), rotation = vec3(0.0, 0.0, -110.0)},
        },
        DeliveryLocations = {
            { coords = vec3(-352.172363, -58.40994, 48.7834831), rotation = vec3(0, 15.0, -110.0)},
            { coords = vec3(-352.394165, -58.32913, 48.7834831), rotation = vec3(0, 15.0, -110.0)},
            { coords = vec3(-352.6048, -58.25259, 48.7834831), rotation = vec3(0, 15.0, -110.0)},
            { coords = vec3(-352.8335, -58.16934, 48.7834831), rotation = vec3(0, 15.0, -110.0)},
        }, 
        BlipCoords = vector3(-350.04, -47.05, 49.05),
    },

    [3] = {
        rewardBonus = 0,
        isVault = true,
        DriverCoords = vec3(-2956.5, 482.06, 15.9),
        DoorsCoords = vec3(-2958.54, 482.27, 15.84),
        ObjectsToDelete = {
            -- Add here what props you want to delete from ur interior, for example some locked doors or somehting
            [`v_ilev_gb_vaubar`] = true,
            -- For k4mb1 Map:
            -- [-2075524880] = true,
            -- For gabz map:
            -- [-2018598162] = true,
            [-1645229742] = true,
            [-1474093263] = true,
        },
        TrolleysCoords = {
            { coords = vec3(-2955.12622, 486.408966, 15.1709127), rotation = vec3(0, 0, 177.0)},
            { coords = vec3(-2952.41943, 485.874878, 15.1148062), rotation = vec3(0, 0, 87.0)},
            { coords = vec3(-2952.54541, 482.923065, 15.1148062), rotation = vec3(0, 0, 87.0)},
            { coords = vec3(-2955.144, 482.438446, 15.0899649), rotation = vec3(0, 0, -3.0)},
        },
        DeliveryLocations = {
            { coords = vec3(-2954.10059, 484.204254, 15.4159752), rotation = vec3(-1.71, 15.00, 4.70)},
            { coords = vec3(-2954.10059, 483.979553, 15.4159752), rotation = vec3(-1.71, 15.00, 4.70)},
            { coords = vec3(-2954.10059, 483.749084, 15.4159752), rotation = vec3(-1.71, 15.00, 4.70)},
            { coords = vec3(-2954.10059, 483.523346, 15.4159752), rotation = vec3(-1.71, 15.00, 4.70)},
        }, 
        BlipCoords = vector3(-2965.96, 482.54, 15.69),
    },

    [4] = {
        rewardBonus = 0,
        isVault = true,
        DriverCoords = vec3(311.5875, -284.6258, 54.36483),
        DoorsCoords = vec3(312.358, -282.7301, 54.30365),
        ObjectsToDelete = {
            -- Add here what props you want to delete from ur interior, for example some locked doors or somehting
            [`v_ilev_gb_vaubar`] = true,
            -- For k4mb1 Map:
            -- [-2075524880] = true,
            -- For gabz map:
            -- [-2018598162] = true,
            [-1645229742] = true,
            [-1474093263] = true,
        },
        TrolleysCoords = {
            { coords = vec3(315.23996, -287.29422, 53.5966225), rotation = vec3(0, 0, 70.0)},
            { coords = vec3(313.8656, -289.6253, 53.5405159), rotation = vec3(0, 0, -20.0)},
            { coords = vec3(311.191254, -288.609863, 53.5405159), rotation = vec3(0, 0, -20.0)},
            { coords = vec3(311.443726, -286.083557, 53.5156746), rotation = vec3(0, 0, -110.0)},
        },
        DeliveryLocations = {
            { coords = vec3(312.9261, -287.529877, 53.877153), rotation = vec3(-1.71, 15.00, -120.0)},
            { coords = vec3(312.714935, -287.452972, 53.877153), rotation = vec3(-1.71, 15.00, -120.0)},
            { coords = vec3(312.4982, -287.374268, 53.877153), rotation = vec3(-1.71, 15.00, -120.0)},
            { coords = vec3(312.2861, -287.297, 53.877153), rotation = vec3(-1.71, 15.00, -120.0)},
        }, 
        BlipCoords = vector3(314.81, -276.68, 54.17),
    },

    [5] = {
        rewardBonus = 0,
        isVault = true,
        DriverCoords = vec3(-1210.4, -336.416, 37.98108),
        DoorsCoords = vec3(-1211.261, -334.5596, 37.91989),
        ObjectsToDelete = {
            -- Add here what props you want to delete from ur interior, for example some locked doors or somehting
            [`v_ilev_gb_vaubar`] = true,
            -- For k4mb1 Map:
            -- [-2075524880] = true,
            -- For gabz map:
            -- [-2018598162] = true,
            [-1645229742] = true,
            [-1474093263] = true,
        },
        TrolleysCoords = {
            { coords = vec3(-1205.96338, -335.5423, 37.21599), rotation = vec3(0, 0, 117.0)},
            { coords = vec3(-1205.1311, -338.12915, 37.1598969), rotation = vec3(0, 0, 27.0)},
            { coords = vec3(-1207.77271, -339.463623, 37.1598969), rotation = vec3(0, 0, 27.0)},
            { coords = vec3(-1209.46716, -337.4054, 37.1350555), rotation = vec3(0, 0, -63.0)},
        },
        DeliveryLocations = {
            { coords = vec3(-1207.42114, -337.468658, 37.48839), rotation = vec3(-1.71, 15.00, -70.0)},
            { coords = vec3(-1207.61621, -337.581, 37.48839), rotation = vec3(-1.71, 15.00, -70.0)},
            { coords = vec3(-1207.81543, -337.69693, 37.48839), rotation = vec3(-1.71, 15.00, -70.0)},
            { coords = vec3(-1208.01123, -337.80896, 37.48839), rotation = vec3(-1.71, 15.00, -70.0)},
        }, 
        BlipCoords = vector3(-1214.06, -328.07, 37.79),
    },

    [6] = {
        rewardBonus = 0,
        isVault = true,
        DriverCoords = vec3(1175.613, 2712.906, 38.28807),
        DoorsCoords = vec3(1175.542, 2710.861, 38.22689),
        ObjectsToDelete = {
            -- Add here what props you want to delete from ur interior, for example some locked doors or somehting
            [`v_ilev_gb_vaubar`] = true,
            -- For k4mb1 Map:
            -- [-2075524880] = true,
            -- For gabz map:
            -- [-2018598162] = true,
            [-1645229742] = true,
            [-1474093263] = true,
        },
        TrolleysCoords = {
            { coords = vec3(1174.62415, 2716.81348, 37.5136948), rotation = vec3(0, 0, -180.0)},
            { coords = vec3(1171.91992, 2716.82251, 37.5136948), rotation = vec3(0, 0, -180.0)},
            { coords = vec3(1175.241, 2714.23267, 37.5136948), rotation = vec3(0, 0, 90.0)},
            { coords = vec3(1171.26721, 2714.09155, 37.50979), rotation = vec3(0, 0, -90.0)},
        },
        DeliveryLocations = {
            { coords = vec3(1173.39636, 2715.13159, 37.79924), rotation = vec3(-1.71, 15.00, 70.0)},
            { coords = vec3(1173.62061, 2715.151, 37.79924), rotation = vec3(-1.71, 15.00, 70.0)},
            { coords = vec3(1173.851, 2715.17236, 37.79924), rotation = vec3(-1.71, 15.00, 70.0)},
            { coords = vec3(1174.0752, 2715.19067, 37.79924), rotation = vec3(-1.71, 15.00, 70.0)},
        }, 
        BlipCoords = vector3(1175.02, 2703.78, 38.1),
    },

    [7] = {
        rewardBonus = 0,
        isVault = false,
        ObjectsToDelete = {
            -- Add here what props you want to delete from ur interior, for example some locked doors or somehting
        },
        TrolleysCoords = {
            { coords = vector3(30.87, -1339.92, 28.5), rotation = vec3(0, 0, -270.0)},
        },
        DeliveryLocations = {
            { coords = vec3(31.1991444, -1339.87488, 28.3114), rotation = vec3(0.0, 15.00, 0.0)},
            { coords = vec3(31.1991444, -1340.13428, 28.3114), rotation = vec3(0.0, 15.00, 0.0)},
            { coords = vec3(31.1991444, -1340.39746, 28.3114), rotation = vec3(0.0, 15.00, 0.0)},
            { coords = vec3(31.1991444, -1340.65442, 28.3114), rotation = vec3(0.0, 15.00, 0.0)},
        },
        BlipCoords = vector3(29.32, -1346.2, 29.5),
    },
}
