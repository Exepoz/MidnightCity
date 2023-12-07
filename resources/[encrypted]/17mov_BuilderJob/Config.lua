Config = {}

Config.useModernUI = true               -- In March 2023 the jobs have passed huge rework, and the UI has been changed. Set it to false, to use OLD no longer supported UI.
    Config.splitReward = false          -- This option work's only when useModernUI is false. If this option is true, the payout is: (Config.OnePercentWorth * Progress ) / PartyCount, if false then: (Config.OnePercentWorth * Progress)
Config.UseTarget = true                -- Change it to true if you want to use a target system. All setings about the target system are under target.lua file.
Config.UseBuiltInNotifications = false   -- Set to false if you want to use ur framework notification style. Otherwise, the built in modern notifications will be used. Avalible only with modern UI
Config.RequiredJob = "none"             -- Set to "none" if you dont want using jobs. If you are using target, you have to set "job" parameter inside every export in target.lua
Config.RequireJobAlsoForFriends = true          -- If it's false, then only host needs to have the job, if it's true then everybody from group needs to have the Config.RequiredJob
Config.RequireOneFriendMinimum = false  -- Set to true if you want to force players to create teams
Config.OnePercentWorth = 25            -- Means that 1% progress will reward players with $100

Config.letBossSplitReward = false                   -- If it's true, then boss can manage whole party rewards percent in menu. If you'll set it to false, then everybody will get same amount. Avalible only in modern UI
Config.multiplyRewardWhileWorkingInGroup = true     -- If it's false, then reward will stay by default. For example $1000 for completing whole job. If you'll set it to true, then the payout will depend on how many players is there in the group. For example, if for full job there's $1000, then if player will work in 4 member group, the reward will be $4000. (baseReward * partyCount)

Config.EnableVehicleTeleporting = true          -- If its true, then the script will teleport the host to the company vehicle. If its false, then the company vehicle will apeear, but the whole squad need to go enter the car manually
Config.JobVehicleModel = "17mov_BuilderCar"               -- Model of the company car
Config.PenaltyAmount = 500                      -- Penalty that is levied when a player finishes work without a company vehicle
Config.DontPayRewardWithoutVehicle = true      -- Set to true if you want to dont pay reward to players who want's to end without company vehicle (accepting the penalty)
Config.DeleteVehicleWithPenalty = false         -- Delete Vehicle even if its not company veh
Config.MixerModel = "17mov_Mixer"                     -- Model of concrete mixer used for pouring concrete  
Config.PipeModel = "17mov_pipe"
Config.PipeInstallingTime = 10000
Config.WallBuildingTime = 15000 
Config.WeldingTime = 12500
Config.wearingAnimation = { dict = "anim@heists@box_carry@", name = "idle"}
Config.installingBlockToFrameScenario = "WORLD_HUMAN_HAMMERING"
Config.JobCooldown = 10 * 60 -- 10 * 60            -- 0 minutes cooldown between making jobs (in brackets there's example for 10 minutes)
Config.GiveKeysToAllLobby = true                    -- Set to false if you want to give keys only for group creator while starting job
Config.EnableWaypoint = true                       -- Set to true if you want to enable the waypoint for ur current job location

Config.ProgressBarOffset = "25px"                   -- Value in px of counter offset on screen
Config.ProgressBarAlign = "bottom-right"            -- Align of the progressbar

-- ^ Options: top-left, top-center, top-right, bottom-left, bottom-center, bottom-right

Config.RewardItemsToGive = {
    -- {
    --     item_name = "water",
    --     chance = 100,
    --     minimumProgressPercent = 25,
    --     amount = 1,
    -- },
}

Config.RequireFullJob = false                       -- Set it to true, if you want players first to have 100% of progress, otherwise they'll not be able to end job.
Config.RequireWorkClothes = true                   -- Set it to true, to change players clothes everytime when they're starting job.
Config.RequiredItem = "none"                        -- Set it to anything you want, to require players to have some item in their inventory before they start the job
Config.RequireItemFromWholeTeam = true              -- If it's false, then only host needs to have the required item, otherwise all team needs it.

Config.RestrictBlipToRequiredJob = false            -- Set to true, to hide job blip for players, who dont have RequiredJob. If requried job is "none", then this option will not have any effect.
Config.Blips = { -- Here you can configure Company blip.
    [1] = {
        Sprite = 801,
        Color = 69,
        Scale = 0.8,
        Pos = vector3(926.47, -1560.25, 30.74),
        Label = 'Builder Job'
    },
}

Config.MarkerSettings = {   -- used only when Config.UseTarget = false. Colors of the marker. Active = when player stands inside the marker.
    Active = {
        r = 232, 
        g = 111,
        b = 12,
        a = 200,
    },
    UnActive = {
        r = 176, 
        g = 36,
        b = 11,
        a = 200,
    }
}

Config.ArrowMarkerColor = {
    r = 194, 
    g = 194,
    b = 194,
    a = 200,
}

Config.Locations = {       -- Here u can change all of the base job locations. 
    DutyToggle = {
        Coords = {
            vector3(926.47, -1560.25, 30.74),
        },
        CurrentAction = 'open_dutyToggle',
        CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to ~y~start/finish~s~ work.',
        type = 'duty',
        scale = {x = 1.0, y = 1.0, z = 1.0}
    },
    FinishJob = {
        Coords = {
            vector3(923.85, -1563.85, 30.73),
        },
        CurrentAction = 'finish_job',
        CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to ~y~end ~s~working.',
        scale = {x = 3.0, y = 3.0, z = 3.0}
    },

}

Config.SpawnPoint = vector4(923.85, -1563.85, 30.73, 94.1)      -- Company car spawn point
Config.MixerSpawnPoint = vector4(921.05, -1568.3, 30.7, 91.05)  -- Company Mixer Spawn Point
Config.EnableCloakroom = true                                   -- if false, then you can't see the Cloakroom button under Work Menu
Config.Clothes = {

    male = {
        ["mask"] = {clotheId = 0, variation = 0},
        ["arms"] = {clotheId = 0, variation = 0},
        ["pants"] = {clotheId = 9, variation = 4},
        ["bag"] = {clotheId = 0, variation = 0},
        ["shoes"] = {clotheId = 25, variation = 0},
        ["t-shirt"] = {clotheId = 59, variation = 1},
        ["torso"] = {clotheId = 226, variation = 0},
        ["decals"] = {clotheId = 0, variation = 0},
        ["kevlar"] = {clotheId = 0, variation = 0},
    },

    maleHelmet = { clotheId = 145, variation = 1},
    
    female = {
        ["mask"] = {clotheId = 0, variation = 0},
        ["arms"] = {clotheId = 0, variation = 0},
        ["pants"] = {clotheId = 109, variation = 15},
        ["bag"] = {clotheId = 0, variation = 0},
        ["shoes"] = {clotheId = 25, variation = 0},
        ["t-shirt"] = {clotheId = 36, variation = 1},
        ["torso"] = {clotheId = 236, variation = 0},
        ["decals"] = {clotheId = 0, variation = 0},
        ["kevlar"] = {clotheId = 0, variation = 0},
    },

    femaleHelmet = { clotheId = 144, variation = 1},
}

Config.Lang = {

    -- Here you can changea all translations used in client.lua, and server.lua. Dont forget to translate it also under the HTML and JS file.

    -- Client
    ["no_permission"] = "Only the party owner can do that!",
    ["keybind"] = 'Construction Job Marker Interaction',
    ["too_far"] = "Your party has started work, but you are too far from headquarters",
    ["kicked"] = "You kicked %s out of the party",
    ["alreadyWorking"] = "First, complete the previous order",
    ["quit"] = "You have left the Team",
    ["wrongCar"] = "This is not your company vehicle",
    ["CarNeeded"] = "You need your company vehicle to finish the job.",
    ["nobodyNearby"] = "There is no one around",
    ["cantInvite"] = "To be able to invite more people, you must first finish the job",
    ["inviteSent"] = "Invite Sent!",
    ["spawnpointOccupied"] = "The car's or mixer truck spawn site is occupied",
    ["pipesNotReady"] = "Before pouring the concrete, first you have to install the pipes",
    ["clickToPour"] = "~INPUT_CONTEXT~ to pour concrete",
    ["installPipe"] = "Install pipe",
    ["pickupBlock"] = "Pickup Block",
    ["tutorialAfterMixerPickup"] = "You just picked up your boss's designated concrete mixer. Drive it to the construction site, then pour the concrete in the designated areas. The Construction Site is marked on the GPS",
    ["startingTutorial"] = "Welcome to the work of the builder. A variety of tasks await you on site, from welding, to building walls, making drains, or pouring concrete. If you're working in a group, you'll now have to split up, one person have to be dropped off at the concrete mixer pick-up point and then transport the concrete mixer to the construction site. Every single activity, will be explained when you first approach it. You have the locations of the tasks marked on the map. If you work alone, then you have to complete each task by yourself, if you work in groups - you decide how you want to divide. You don't have to do all the tasks, you can finish when you want, and your payment depends on how many % of the tasks you do. We wish you good luck!",
    ["installBlock"] = "Build a wall",
    ["tutorialWallBuilding"] = "You are next to the wall frame, your task is to build it using concrete blocks. The concrete blocks are near the frame, and are marked on the GPS. Walk up to the pile with the blocks, pick one up, and then mount it to the wall",
    ["tutorialAboutPipes"] = "You are next to a hole overlooking sewer pipes. Your task is to install the pipes in the right places. After installing the pipes, you must pour concrete over the hole using a concrete mixer. ",
    ["tutorialWelding"] = "You are next to the place where the boss told you to weld something. The job is very simple, requiring no further explanation",
    ["startWelding"] = "Start Welding",
    ["workstationOccupied"] = "This workstation is occupied",
    ["notFullJob"] = "You have to make 100% progress before ending a job",
    ["notADriver"] = "You need to be a driver of vehicle to end the job",
    ["partyIsFull"] = "Failed to send an invite, your group is full",
    ["wrongReward1"] = "The payout percentage should be between 0 and 100",
    ["wrongReward2"] = "The total percentage of all payouts exceeded 100%",
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
    ["penalty"] = "You paid a fine in the amount of ",
    ["clientsPenalty"] = "The team's host accepted the punishment. You have not received the payment",
    ["noMixerStatus"] = "Currently, we do not have any free concrete mixer for u. Please try again later",
    ["dontHaveReqItem"] = "You or someone from your team do not have the required item to start work",
    ["notEverybodyHasRequiredJob"] = "Not every of your friends have the required job",
    ["someoneIsOnCooldown"] = "You or someone from your team can't make the job now (cooldown: %s)",
    ["hours"] = "h",
    ["minutes"] = "m",
    ["seconds"] = "s",
    ["newBoss"] = "The previous lobby boss has left the server. You are now the team leader",
}

Config.JobBlipsStyle = {
    ["mixerSpawnLocation"] = {
        color = 47,
        string = "~o~[BUILDER]~s~ Concrete mixer for pickup",
        sprite = 800,
    },
    ["mixerTargetLocation"] = {
        color = 47,
        string = "~o~[BUILDER]~s~ Concrete Mixer Delivery Location",
        sprite = 652,
    },
    ["installPipe"] = {
        color = 47,
        string = "[BUILDER] Install pipe",
        sprite = nil,
    },
    ["blockPickup"] = {
        color = 47,
        string = "~o~[BUILDER]~s~ Pickup Blocks for wall building",
        sprite = 655, 
    },
    ["buildWall"] = {
        color = 47,
        string = "~o~[BUILDER]~s~ Build a wall",
        sprite = 285, 
    },

    ["welding"] = {
        color = 47,
        string = "~o~[BUILDER]~s~ Welding",
        sprite = 468, 
    },
}

Config.JobLocations = {
    [1] = {
        paymentMultipler = 1.0,
        enableConcretePouring = true,
        mixerSpawnLocation = vector4(1005.7, -1868.33, 30.89, 359.32),

        customTasks = {

            -- === IMPORTANT ===
            -- This task at the bottom, will not work. It's just sample for devs to copy and make their own custom tasks! :D
            -- === IMPORTANT ===

            -- [1] = {
            --     blipName = "Build Chair",
            --     blipSprite = 306,
            --     blipColor = 1,

            --     drawingText = "Build Chair",                                        -- This string will be drawed above coords in this Style: [E] | *text*
            --     coordsToDrawText = vector3(110.76, -398.65, 41.26),                 -- On this coords the text will be drawed
            --     pedInteractionCoords = vector4(111.58, -398.76, 41.26, 81.93),      -- After hitting E in the text, ped coords will be set to this
            --     animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",              -- Dict of anim that ped will play
            --     animName = "machinic_loop_mechandplayer",                           -- Anim Name to play
            --     TimeToBuild = 2000,                                                 -- How long the process will be?
            --     progressValue = 0,                                                  -- How much progress script should add for players after properly done task?

            --     spawnPropAfter = true,                                              -- Spawn any prop after task done?
            --     propSpawnCoords = vector3(109.04, -398.39, 41.27),                  -- If spawn, then on which coords?
            --     propSpawnRotation = vector3(0.0, 0.0, 0.0),                         -- If spawn, then on what rotation?
            --     propSpawnName = "v_corp_bk_chair1",                                 -- what prop name we should spawn? :D
            -- },
        },

        welding = {
            [1] = { coords = vector4(-447.98, -941.33, 28.3, 179.4), ready = false, progressValue = 3},
            [2] = { coords = vector4(-463.27, -973.94, 22.5, 227.44), ready = false, progressValue = 3},
            [3] = { coords = vector4(-485.93, -1038.39, 27.80, 221.44), ready = false, progressValue = 3},
            [4] = { coords = vector4(-490.39, -1020.14, 27.80, 87.4), ready = false, progressValue = 3},
            [5] = { coords = vector4(-441.26, -865.06, 24.8, 266.5), ready = false, progressValue = 3},
        },

        walls = {
            [1] = {
                frame = {
                    coords = vector3(-483.455017, -1001.37152, 39.7722481),
                    rotation = vector3(0.0, 0.0, 90.0),
                    interactionCoords = vector4(-484.27, -1000.93, 41.81, 270.01),
                },
                blocksSpawnLocation = vector3(-495.74, -1012.81, 50.7),
                blocksSpawnRotation = vector3(-90.0, 0.0, 0.0),
                blocksInFrameLocations = {
                    [1] = { coords = vector3(-483.4619, -1005.03796, 42.7), ready = false, progressValue = 1.5},
                    [2] = { coords = vector3(-483.4619, -1003.22589, 42.7), ready = false, progressValue = 1.5},
                    [3] = { coords = vector3(-483.4619, -1001.30255, 42.7), ready = false, progressValue = 1.5},
                    [4] = { coords = vector3(-483.4619, -999.3389, 42.7), ready = false, progressValue = 1.5},
                    [5] = { coords = vector3(-483.4619, -997.3471, 42.7), ready = false, progressValue = 1.5},
                    [6] = { coords = vector3(-483.4619, -997.355957, 41.2), ready = false, progressValue = 1.5},
                    [7] = { coords = vector3(-483.4619, -999.346558, 41.2), ready = false, progressValue = 1.5},
                    [8] = { coords = vector3(-483.4619, -1001.29645, 41.2), ready = false, progressValue = 1.5},
                    [9] = { coords = vector3(-483.4619, -1003.23535, 41.2), ready = false, progressValue = 1.5},
                    [10] = { coords = vector3(-483.4619, -1005.07739, 41.2), ready = false, progressValue = 1.5},
                    [11] = { coords = vector3(-483.4619, -997.355957, 39.8), ready = false, progressValue = 1.5},
                    [12] = { coords = vector3(-483.4619, -999.358948, 39.8), ready = false, progressValue = 1.5},
                    [13] = { coords = vector3(-483.4619, -1001.27496, 39.8), ready = false, progressValue = 1.5},
                    [14] = { coords = vector3(-483.4619, -1003.21967, 39.8), ready = false, progressValue = 1.5},
                    [15] = { coords = vector3(-483.4619, -1005.15955, 39.8), ready = false, progressValue = 1.5},
                }
            },
            [2] = {
                frame = {
                    coords = vector3(-504.926544, -1021.82452, 39.7722481),
                    rotation = vector3(0.0, 0.0, 90.0),
                    interactionCoords = vector4(-504.27, -1023.6, 41.81, 90.59),
                },
                blocksSpawnLocation = vector3(-501.55, -980.13, 27.50),
                blocksSpawnRotation = vector3(-90.0, 0.0, 0.0),
                blocksInFrameLocations = {
                    [1] = { coords = vector3(-504.933441, -1025.49109, 42.7), ready = false, progressValue = 1.5},
                    [2] = { coords = vector3(-504.933441, -1023.67896, 42.7), ready = false, progressValue = 1.5},
                    [3] = { coords = vector3(-504.933441, -1021.73981, 42.7), ready = false, progressValue = 1.5},
                    [4] = { coords = vector3(-504.933441, -1019.80756, 42.7), ready = false, progressValue = 1.5},
                    [5] = { coords = vector3(-504.933441, -1017.81091, 42.7), ready = false, progressValue = 1.5},
                    [6] = { coords = vector3(-504.933441, -1017.81091, 41.2), ready = false, progressValue = 1.5},
                    [7] = { coords = vector3(-504.933441, -1019.80426, 41.2), ready = false, progressValue = 1.5},
                    [8] = { coords = vector3(-504.933441, -1021.73926, 41.2), ready = false, progressValue = 1.5},
                    [9] = { coords = vector3(-504.933441, -1023.66089, 41.2), ready = false, progressValue = 1.5},
                    [10] = { coords = vector3(-504.933441, -1025.49573, 41.2), ready = false, progressValue = 1.5},
                    [11] = { coords = vector3(-504.933441, -1025.61267, 39.8), ready = false, progressValue = 1.5},
                    [12] = { coords = vector3(-504.933441, -1023.67694, 39.8), ready = false, progressValue = 1.5},
                    [13] = { coords = vector3(-504.933441, -1021.75873, 39.8), ready = false, progressValue = 1.5},
                    [14] = { coords = vector3(-504.933441, -1019.80054, 39.8), ready = false, progressValue = 1.5},
                    [15] = { coords = vector3(-504.933441, -1017.81006, 39.8), ready = false, progressValue = 1.5},
                }
            },
        },

        mixerTargetLocations = {
            [1] = {
                pipes = {
                    [1] = {
                        coords = vector3(-460.884, -1011.73645, 21.3466549),
                        pedInstallingCoords = vector4(-460.884, -1010.94, 22.42, 179.6),
                        rotation = vector3(0, -90.0, -180),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [2] = {
                        coords = vector3(-459.017, -1011.73645, 21.3466549),
                        pedInstallingCoords = vector4(-459.017, -1010.94, 22.42, 179.6),
                        rotation = vector3(0, -90.0, -180),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [3] = {
                        coords = vector3(-457.16098, -1011.73645, 21.3466549),
                        pedInstallingCoords = vector4(-457.16098, -1010.94, 22.42, 179.6),
                        rotation = vector3(0, -90.0, -180),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    }, 
                    [4] = {
                        coords = vector3(-455.331, -1011.73645, 21.3466549),
                        pedInstallingCoords = vector4(-455.331, -1010.94, 22.42, 179.6),
                        rotation = vector3(0, -90.0, -180),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    }, 
                    [5] = {
                        coords = vector3(-453.482574, -1011.73645, 21.3466549),
                        pedInstallingCoords = vector4(-453.482574, -1010.94, 22.42, 179.6),
                        rotation = vector3(0, -90.0, -180),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    }, 
                    [6] = {
                        coords = vector3(-451.621643, -1011.73645, 21.3466549),
                        pedInstallingCoords = vector4(-452.621643, -1010.94, 22.42, 179.6),
                        rotation = vector3(0, -90.0, -180),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    }, 

                    [7] = {
                        coords = vector3(-460.9309, -1011.04742, 21.6506386),
                        pedInstallingCoords = vector4(-460.0, -1011.89, 22.44, 354.83),
                        rotation = vector3(0, -90.0, -180),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },

                    [8] = {
                        coords = vector3(-459.078583, -1011.04742, 21.6506386),
                        pedInstallingCoords = vector4(-459.078583, -1011.89, 22.44, 354.83),
                        rotation = vector3(0, -90.0, -180),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    }, 

                    [9] = {
                        coords = vector3(-457.2134, -1011.04742, 21.6506386),
                        pedInstallingCoords = vector4(-457.2134, -1011.89, 22.44, 354.83),
                        rotation = vector3(0, -90.0, -180),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    }, 

                    [10] = {
                        coords = vector3(-455.3443, -1011.04742, 21.6506386),
                        pedInstallingCoords = vector4(-455.3443, -1011.89, 22.44, 354.83),
                        rotation = vector3(0, -90.0, -180),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    }, 

                    [11] = {
                        coords = vector3(-453.492371, -1011.04742, 21.6506386),
                        pedInstallingCoords = vector4(-453.492371, -1011.89, 22.44, 354.83),
                        rotation = vector3(0, -90.0, -180),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    }, 

                    [12] = {
                        coords = vector3(-451.621643, -1011.04742, 21.6506386),
                        pedInstallingCoords = vector4(-451.621643, -1011.89, 22.44, 354.83),
                        rotation = vector3(0, -90.0, -180),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    }, 
                },
                targetLocation = vector3(-461.95, -1011.5, 25.0),
                mixerFixedTargetLocation = vector4(-461.4, -1007.88, 23.38, 357.65),
                concreteSettings = {
                    startingLoc = vector3(-454.819977, -1011.89429, 19.04825),
                    rotation = vec3(0,0,-90),
                    maxZ = 22.4906921,
                    model = "concrete",
                    progressValue = 8,
                },
                concreteReady = false,
            },
        },
    },

    [2] = {
        paymentMultipler = 1.0,
        enableConcretePouring = true,
        welding = {
            [1] = { coords = vector4(46.82, -463.71, 39.18, 356.54), ready = false, progressValue = 2},
            [2] = { coords = vector4(131.29, -347.38, 42.32, 93.31), ready = false, progressValue = 2},
            [3] = { coords = vector4(40.48, -355.53, 41.52, 68.07), ready = false, progressValue = 2},
            [4] = { coords = vector4(89.89, -345.36, 41.28, 74.04), ready = false, progressValue = 2},
            [5] = { coords = vector4(8.44, -437.23, 44.56, 341.76), ready = false, progressValue = 2},
        },

        customTasks = {

            -- === IMPORTANT ===
            -- This task at the bottom, will not work. It's just sample for devs to copy and make their own custom tasks! :D
            -- === IMPORTANT ===

            [1] = {
                blipName = "Build Ramp",
                blipSprite = 306,
                blipColor = 1,

                drawingText = "Build Ramp for Mixer",                                        -- This string will be drawed above coords in this Style: [E] | *text*
                coordsToDrawText = vector3(61.3191, -439.025757, 36.5744156),                 -- On this coords the text will be drawed
                pedInteractionCoords = vector4(61.41, -438.78, 36.55, 70.48),      -- After hitting E in the text, ped coords will be set to this
                animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",              -- Dict of anim that ped will play
                animName = "machinic_loop_mechandplayer",                           -- Anim Name to play
                TimeToBuild = 10000,                                                 -- How long the process will be?
                progressValue = 5,                                                  -- How much progress script should add for players after properly done task?

                spawnPropAfter = true,                                              -- Spawn any prop after task done?
                propSpawnCoords = vector3(58.9023, -438.183838, 36.4505447),                  -- If spawn, then on which coords?
                propSpawnRotation = vector3(0.0, 0.0, 70.0),                         -- If spawn, then on what rotation?
                propSpawnName = "prop_mp_ramp_03",                                 -- what prop name we should spawn? :D
            },
        },

        walls = {
            [1] = {
                frame = {
                    coords = vector3(59.0604858, -373.857361, 72.82836),
                    rotation = vector3(0.0, 0.0, 160.0),
                    interactionCoords = vector4(58.94, -375.1, 74.94, 345.52),
                },
                blocksSpawnLocation = vector3(42.9049072, -379.303864, 72.31141),
                blocksSpawnRotation = vector3(-90.0, 0.0, 0.0),
                blocksInFrameLocations = {
                    [1] = { coords = vector3(55.28341, -372.487457, 75.67078), ready = false, progressValue = 1.5},
                    [2] = { coords = vector3(57.14642, -373.165558, 75.67078), ready = false, progressValue = 1.5},
                    [3] = { coords = vector3(58.967598, -373.8284, 75.67078), ready = false, progressValue = 1.5},
                    [4] = { coords = vector3(60.7907562, -374.491943, 75.67078), ready = false, progressValue = 1.5},
                    [5] = { coords = vector3(62.56657, -375.138275, 75.67078), ready = false, progressValue = 1.5},
                    [6] = { coords = vector3(55.28341, -372.487457, 74.31403), ready = false, progressValue = 1.5},
                    [7] = { coords = vector3(55.28341, -372.487457, 72.9129858), ready = false, progressValue = 1.5},
                    [8] = { coords = vector3(57.164505, -373.172119, 72.75803), ready = false, progressValue = 1.5},
                    [9] = { coords = vector3(58.98718, -373.8355, 72.8806143), ready = false, progressValue = 1.5},
                    [10] = { coords = vector3(60.8195038, -374.502441, 72.87756), ready = false, progressValue = 1.5},
                    [11] = { coords = vector3(62.6300163, -375.1614, 72.88511), ready = false, progressValue = 1.5},
                    [12] = { coords = vector3(62.6232147, -375.1589, 74.298934), ready = false, progressValue = 1.5},
                    [13] = { coords = vector3(57.14916, -373.1665, 74.22659), ready = false, progressValue = 1.5},
                    [14] = { coords = vector3(58.98452, -373.834564, 74.31092), ready = false, progressValue = 1.5},
                    [15] = { coords = vector3(60.8101273, -374.499023, 74.2679), ready = false, progressValue = 1.5},
                }
            },
            [2] = {
                frame = {
                    coords = vector3(58.9437981, -323.99234, 66.00681),
                    rotation = vector3(0.0, 0.0, 70.0),
                    interactionCoords = vector4(59.82, -323.57, 68.14, 65.55),
                },
                blocksSpawnLocation = vector3(86.00881, -334.252075, 65.57404),
                blocksSpawnRotation = vector3(-90.0, 0.0, 0.0),
                blocksInFrameLocations = {
                    [1] = { coords = vector3(60.30995, -320.212921, 68.88242), ready = false, progressValue = 1.5},
                    [2] = { coords = vector3(59.6319122, -322.075836, 68.88242), ready = false, progressValue = 1.5},
                    [3] = { coords = vector3(58.9690361, -323.897064, 68.88242), ready = false, progressValue = 1.5},
                    [4] = { coords = vector3(58.30544, -325.720276, 68.88242), ready = false, progressValue = 1.5},
                    [5] = { coords = vector3(57.6591034, -327.496063, 68.88242), ready = false, progressValue = 1.5},
                    [6] = { coords = vector3(60.30995, -320.212921, 67.52567), ready = false, progressValue = 1.5},
                    [7] = { coords = vector3(60.30995, -320.212921, 66.1246252), ready = false, progressValue = 1.5},
                    [8] = { coords = vector3(59.6252975, -322.094, 65.96967), ready = false, progressValue = 1.5},
                    [9] = { coords = vector3(58.96191, -323.916626, 66.09225), ready = false, progressValue = 1.5},
                    [10] = { coords = vector3(58.29498, -325.749, 66.0892), ready = false, progressValue = 1.5},
                    [11] = { coords = vector3(57.63599, -327.55957, 66.09675), ready = false, progressValue = 1.5},
                    [12] = { coords = vector3(57.63849, -327.5527, 67.51057), ready = false, progressValue = 1.5},
                    [13] = { coords = vector3(59.63089, -322.078644, 67.43823), ready = false, progressValue = 1.5},
                    [14] = { coords = vector3(58.9628525, -323.914032, 67.52256), ready = false, progressValue = 1.5},
                    [15] = { coords = vector3(58.2983932, -325.739624, 67.47954), ready = false, progressValue = 1.5},                   
                }
            },
        },

        mixerTargetLocations = {
            [1] = {
                pipes = {
                    [1] = {
                        coords = vector3(88.08839, -430.978638, 35.6299438),
                        pedInstallingCoords = vector4(88.08839, -435.9, 35.0, 247.03),
                        rotation = vector3(0, -90.0, -110.0),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [2] = {
                        coords = vector3(87.44169, -432.755432, 35.6299438),
                        pedInstallingCoords = vector4(86.7, -432.55, 35.0, 250.86),
                        rotation = vector3(0, -90.0, -110.0),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [3] = {
                        coords = vector3(86.8037643, -434.508118, 35.6299438),
                        pedInstallingCoords = vector4(86.1, -434.22, 35.0, 247.47),
                        rotation = vector3(0, -90.0, -110.0),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    }, 
                    [4] = {
                        coords = vector3(86.17395, -436.238525, 35.6299438),
                        pedInstallingCoords = vector4(85.5, -436.02, 35.0, 248.15),
                        rotation = vector3(0, -90.0, -110.0),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    }, 
                    [5] = {
                        coords = vector3(85.54622, -437.9632, 35.6299438),
                        pedInstallingCoords = vector4(85.05, -437.28, 35.0, 214.36),
                        rotation = vector3(0, -90.0, -110.0),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    }, 
                    [6] = {
                        coords = vector3(84.90408, -439.727448, 35.6299438),
                        pedInstallingCoords = vector4(86.7484344, -435.94, 35.0, 69.66),
                        rotation = vector3(0, -90.0, -110.0),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    }, 

                    [7] = {
                        coords = vector3(86.74678, -430.490326, 35.6299438),
                        pedInstallingCoords = vector4(87.46, -430.97, 35.0, 58.98),
                        rotation = vector3(0, -90.0, -110.0),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },

                    [8] = {
                        coords = vector3(86.10856, -432.2438, 35.6299438),
                        pedInstallingCoords = vector4(86.83, -432.4, 35.0, 71.49),
                        rotation = vector3(0, -90.0, -110.0),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    }, 

                    [9] = {
                        coords = vector3(85.47532, -433.9836, 35.6299438),
                        pedInstallingCoords = vector4(86.19, -434.22, 35.0, 72.15),
                        rotation = vector3(0, -90.0, -110.0),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    }, 

                    [10] = {
                        coords = vector3(84.8484344, -435.705963, 35.6299438),
                        pedInstallingCoords = vector4(85.54, -435.91, 35.0, 76.73),
                        rotation = vector3(0, -90.0, -110.0),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    }, 

                    [11] = {
                        coords = vector3(84.22275, -437.425018, 35.6299438),
                        pedInstallingCoords = vector4(85.01, -437.43, 35.0, 94.13),
                        rotation = vector3(0, -90.0, -110.0),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    }, 

                    [12] = {
                        coords = vector3(83.59078, -439.161346, 35.6299438),
                        pedInstallingCoords = vector4(85.01, -437.43, 35.0, 94.13),
                        rotation = vector3(0, -90.0, -110.0),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    }, 
                },
                targetLocation = vector3(84.2, -439.01, 39.17),
                mixerFixedTargetLocation = vector4(81.02, -438.06, 37.17, 66.73),
                concreteSettings = {
                    startingLoc = vector3(86.2268143, -434.039948, 34.7336655),
                    rotation = vec3(0,0,-90),
                    maxZ = 36.3285942,
                    model = "concrete",
                    progressValue = 8,
                },
                concreteReady = false,
            },
        },
    },

    -- BEACH HOUSE
    [3] = {
        paymentMultipler = 1.0,
        enableConcretePouring = false,
        mixerSpawnLocation = vector4(1005.7, -1868.33, 30.89, 359.32),

        customTasks = {

            -- === IMPORTANT ===
            -- This task at the bottom, will not work. It's just sample for devs to copy and make their own custom tasks! :D
            -- === IMPORTANT ===

            [1] = {
                blipName = "Install Sink",
                blipSprite = 306,
                blipColor = 1,

                drawingText = "Install Sink",                                        -- This string will be drawed above coords in this Style: [E] | *text*
                coordsToDrawText = vector3(-1096.68, -1660.53, 10.18),                 -- On this coords the text will be drawed
                pedInteractionCoords = vector4(-1096.68, -1660.53, 9.18, 220.11),      -- After hitting E in the text, ped coords will be set to this
                animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",              -- Dict of anim that ped will play
                animName = "machinic_loop_mechandplayer",                           -- Anim Name to play
                TimeToBuild = 2000,                                                 -- How long the process will be?
                progressValue = 2.5,                                                  -- How much progress script should add for players after properly done task?

                spawnPropAfter = true,                                              -- Spawn any prop after task done?
                propSpawnCoords = vector3(-1095.96, -1661.119, 9.19179),                  -- If spawn, then on which coords?
                propSpawnRotation = vector3(0.0, 0.0, 215.0),                         -- If spawn, then on what rotation?
                propSpawnName = "prop_ff_sink_02",                                 -- what prop name we should spawn? :D
            },
            [2] = {
                blipName = "Install Fusebox",
                blipSprite = 306,
                blipColor = 1,

                drawingText = "Install Fusebox",                                        -- This string will be drawed above coords in this Style: [E] | *text*
                coordsToDrawText = vector3(-1099.74, -1658.63, 4.45),                 -- On this coords the text will be drawed
                pedInteractionCoords = vector4(-1099.86, -1658.5, 3.45, 213.56),      -- After hitting E in the text, ped coords will be set to this
                animDict = "gestures@f@standing@casual",              -- Dict of anim that ped will play
                animName = "gesture_point",                             -- Anim Name to play
                TimeToBuild = 5000,                                                 -- How long the process will be?
                progressValue = 2.5,                                                  -- How much progress script should add for players after properly done task?

                spawnPropAfter = true,                                              -- Spawn any prop after task done?
                propSpawnCoords = vector3(-1099.374, -1659.146, 4.70),                  -- If spawn, then on which coords?
                propSpawnRotation = vector3(0.0, 0.0, 215.0),                         -- If spawn, then on what rotation?
                propSpawnName = "ch_prop_ch_fuse_box_01a",                                 -- what prop name we should spawn? :D
            },
            
        },

        welding = {
            [1] = { coords = vector4(-1093.28, -1652.46, 6.35, 42.01), ready = false, progressValue = 4},
            [2] = { coords = vector4(-1098.16, -1657.23, 9.18, 301.95), ready = false, progressValue = 4},
            [3] = { coords = vector4(-1104.48, -1660.08, 9.16, 106.65), ready = false, progressValue = 4},
            [4] = { coords = vector4(-1096.98, -1657.37, 3.4, 202.48), ready = false, progressValue = 4},
            [5] = { coords = vector4(-1095.26, -1653.9, 3.4, 276.74), ready = false, progressValue = 4},
        },

        walls = {
            [1] = {
                frame = {
                    coords = vector3(-1101.30, -1665.7899, 6.37),
                    rotation = vector3(0.0, 0.0, 35.0),
                    interactionCoords = vector4(-1101.41, -1664.85, 8.34, 206.66),
                },
                blocksSpawnLocation = vector3(-1096.9, -1649.2, 2.8),
                blocksSpawnRotation = vector3(-90.0, 0.0, 35.0),
                blocksInFrameLocations = {
                    [2] = { coords = vector3(-1101.25, -1665.70, 6.37), ready = false, progressValue = 1.0},
                    [1] = { coords = vector3(-1101.25, -1665.70, 7.87), ready = false, progressValue = 1.0},
                    [3] = { coords = vector3(-1101.25, -1665.70, 9.37), ready = false, progressValue = 1.0},

                    [10] = { coords = vector3(-1102.86, -1666.84, 6.37), ready = false, progressValue = 1.0}, -- LEFT
                    [11] = { coords = vector3(-1102.86, -1666.84, 7.87), ready = false, progressValue = 1.0},
                    [12] = { coords = vector3(-1102.86, -1666.84, 9.37), ready = false, progressValue = 1.0},

                    [7] = { coords = vector3(-1099.64, -1664.59, 6.37), ready = false, progressValue = 1.0},
                    [8] = { coords = vector3(-1099.64, -1664.59, 7.87), ready = false, progressValue = 1.0},
                    [9] = { coords = vector3(-1099.64, -1664.59, 9.37), ready = false, progressValue = 1.0},

                    [4] = { coords = vector3(-1098.07, -1663.478, 6.37), ready = false, progressValue = 1.0},
                    [5] = { coords = vector3(-1098.07, -1663.478, 7.87), ready = false, progressValue = 1.0},
                    [6] = { coords = vector3(-1098.07, -1663.478, 9.37), ready = false, progressValue = 1.0},

                    [13] = { coords = vector3(-1104.36, -1667.90, 6.37), ready = false, progressValue = 1.0},
                    [14] = { coords = vector3(-1104.36, -1667.90, 7.87), ready = false, progressValue = 1.0},
                    [15] = { coords = vector3(-1104.36, -1667.90, 9.37), ready = false, progressValue = 1.0},
                }
            },
            [2] = {
                frame = {
                    coords = vector3(-1093.51, -1660.31, 6.36),
                    rotation = vector3(0.0, 0.0, 35.0),
                    interactionCoords = vector4(-1092.6, -1658.8, 8.34, 220.08),
                },
                blocksSpawnLocation = vector3(-1106.44, -1662.16, 5.70),
                blocksSpawnRotation = vector3(-90.0, 0.0, 35.0),
                blocksInFrameLocations = {
                    [2] = { coords = vector3(-1091.89, -1659.14, 6.36), ready = false, progressValue = 1.0},
                    [1] = { coords = vector3(-1091.89, -1659.14, 7.87), ready = false, progressValue = 1.0},
                    [3] = { coords = vector3(-1091.89, -1659.14, 9.37), ready = false, progressValue = 1.0},

                    [4] = { coords = vector3(-1095.02, -1661.32, 6.37), ready = false, progressValue = 1.0},
                    [5] = { coords = vector3(-1095.0, -1661.32, 7.87), ready = false, progressValue = 1.0},
                    [6] = { coords = vector3(-1095.0, -1661.32, 9.37), ready = false, progressValue = 1.0},

                    [7] = { coords = vector3(-1096.56, -1662.415, 6.37), ready = false, progressValue = 1.0},
                    [8] = { coords = vector3(-1096.56, -1662.415, 7.87), ready = false, progressValue = 1.0},
                    [9] = { coords = vector3(-1096.56, -1662.415, 9.37), ready = false, progressValue = 1.0},

                    [10] = { coords = vector3(-1093.45, -1660.23, 6.37), ready = false, progressValue = 1.0},
                    [11] = { coords = vector3(-1093.45, -1660.23, 7.87), ready = false, progressValue = 1.0},
                    [12] = { coords = vector3(-1093.45, -1660.23, 9.37), ready = false, progressValue = 1.0},

                    [13] = { coords = vector3(-1090.24, -1657.97, 6.37), ready = false, progressValue = 1.0},
                    [14] = { coords = vector3(-1090.24, -1657.97, 7.87), ready = false, progressValue = 1.0},
                    [15] = { coords = vector3(-1090.24, -1657.97, 9.37), ready = false, progressValue = 1.0},
                }
            },
            [3] = {
                frame = {
                    coords = vector3(-1106.25, -1666.75, 5.0),
                    rotation = vector3(90.0, 90.0, 35.0),
                    interactionCoords = vector4(-1105.35, -1666.73, 8.34, 128.37),
                },
                blocksSpawnLocation = vector3(-1091.18, -1654.61, 5.70),
                blocksSpawnRotation = vector3(-90.0, 0.0, 305.0),
                blocksInFrameLocations = {
                    [1] = { coords = vector3(-1107.11,  -1665.45, 6.46), ready = false, progressValue = 1.0},
                    [2] = { coords = vector3(-1107.095,  -1665.48, 8.36), ready = false, progressValue = 1.0},
                    [3] = { coords = vector3(-1107.11,  -1665.48, 10.26), ready = false, progressValue = 1.0},

                
                    [4] = { coords = vector3(-1106.19, -1666.77, 6.46), ready = false, progressValue = 1.0},
                    [5] = { coords = vector3(-1106.19, -1666.77, 8.36), ready = false, progressValue = 1.0},
                    [6] = { coords = vector3(-1106.21, -1666.77, 10.26), ready = false, progressValue = 1.0},

                    [7] = { coords = vector3(-1105.42, -1667.86, 6.46), ready = false, progressValue = 1.0},
                    [8] = { coords = vector3(-1105.44, -1667.86, 8.36), ready = false, progressValue = 1.0},
                    [9] = { coords = vector3(-1105.44, -1667.86, 10.26), ready = false, progressValue = 1.0},

                    
                }
            },
            [4] = {
                frame = {
                    coords =vector3(-1107.82, -1664.54, 5.0),
                    rotation = vector3(90.0, 90.0, 35.0),
                    interactionCoords = vector4(-1107.71, -1663.4, 8.34, 128.01),
                },
                blocksSpawnLocation = vector3(-1098.85, -1662.88, 5.70),
                blocksSpawnRotation = vector3(-90.0, 0.0, 35.0),
                blocksInFrameLocations = {
                    [1] = { coords = vector3(-1108.67, -1663.26, 6.46), ready = false, progressValue = 1.0},
                    [2] = { coords = vector3(-1108.67, -1663.26, 8.36), ready = false, progressValue = 1.0},
                    [3] = { coords = vector3(-1108.69, -1663.27, 10.26), ready = false, progressValue = 1.0},

                    [4] = { coords = vector3(-1107.84, -1664.45, 6.46), ready = false, progressValue = 1.0},
                    [5] = { coords = vector3(-1107.84, -1664.45, 8.36), ready = false, progressValue = 1.0},
                    [6] = { coords = vector3(-1107.86, -1664.46, 10.26), ready = false, progressValue = 1.0},
                    
                }
            },
        },


        mixerTargetLocations = {
            [1] = {
                pipes = {
                    [1] = {
                        coords = vector3(-1096.19, -1661.21, 5.00),
                        pedInstallingCoords = vector4(-1096.38, -1660.93, 3.46, 222.91),
                        rotation = vector3(0, 180.0, -150),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [2] = {
                        coords = vector3(-1096.19, -1661.21, 5.00),
                        pedInstallingCoords = vector4(-1096.38, -1660.93, 3.46, 222.91),
                        rotation = vector3(0, 360.0, -300),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 10,
                        animDict = "amb@prop_human_movie_bulb@idle_a",
                        animName = "idle_b",
                    },
                    [3] = {
                        coords = vector3(-1096.19, -1661.21, 6.8),
                        pedInstallingCoords = vector4(-1096.95, -1660.9, 6.34, 245.78),
                        rotation = vector3(0, 360.0, -300),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 10,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [4] = {
                        coords = vector3(-1096.19, -1661.21, 7.9),
                        pedInstallingCoords = vector4(-1096.48, -1661.06, 6.34, 249.49),
                        rotation = vector3(0, 360.0, -300),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 10,
                        animDict = "amb@prop_human_movie_bulb@idle_a",
                        animName = "idle_b",
                    },
                },
                targetLocation = vector3(-461.95, -1011.5, 25.0),
                mixerFixedTargetLocation = vector4(-461.4, -1007.88, 23.38, 357.65),
                concreteSettings = {
                    startingLoc = vector3(-454.819977, -1011.89429, 19.04825),
                    rotation = vec3(0,0,-90),
                    maxZ = 22.4906921,
                    model = "concrete",
                    progressValue = 8,
                },
                concreteReady = false,
            },
        },
    },

    -- STREET REPAIR
    [4] = {
        paymentMultipler = 1.0,
        enableConcretePouring = true,
        mixerSpawnLocation = vector4(1005.7, -1868.33, 30.89, 359.32),
        customTasks = {

            -- === IMPORTANT ===
            -- This task at the bottom, will not work. It's just sample for devs to copy and make their own custom tasks! :D
            -- === IMPORTANT ===

            [1] = {
                blipName = "Install Switch",
                blipSprite = 306,
                blipColor = 1,

                drawingText = "Install Switch",                                     -- This string will be drawed above coords in this Style: [E] | *text*
                coordsToDrawText = vector3(-1149.59, -1413.49, 4.82),               -- On this coords the text will be drawed
                pedInteractionCoords = vector4(-1149.59, -1413.49, 3.82, 210.74),   -- After hitting E in the text, ped coords will be set to this
                animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",              -- Dict of anim that ped will play
                animName = "machinic_loop_mechandplayer",                           -- Anim Name to play
                TimeToBuild = 5000,                                                 -- How long the process will be?
                progressValue = 2.5,                                                  -- How much progress script should add for players after properly done task?

                spawnPropAfter = true,                                              -- Spawn any prop after task done?
                propSpawnCoords = vector3(-1149.17, -1414.22, 4.89),                -- If spawn, then on which coords?
                propSpawnRotation = vector3(0.0, 0.0, 212.84),                      -- If spawn, then on what rotation?
                propSpawnName = "h4_prop_h4_engine_fusebox_01a",                    -- what prop name we should spawn? :D
            },
            

        },

        welding = {
            [1] = { coords = vector4(-1143.66, -1388.22, 4.04, 85.66), ready = false, progressValue = 2.5},
        },

        walls = {
            [1] = {
                frame = {
                    coords = vector3(-1136.49, -1408.56, 4.15),
                    rotation = vector3(90.0, 90.0, 28.0),
                    interactionCoords = vector4(-1135.83, -1408.2, 5.82, 114.49),
                },
                blocksSpawnLocation = vector3(-1133.53, -1410.88, 3.55),
                blocksSpawnRotation = vector3(-90.0, 0.0, 35.0),
                blocksInFrameLocations = {
                    [2] = { coords = vector3(-1136.5, -1408.5, 3.65), ready = false, progressValue = 2.5},
                    [1] = { coords = vector3(-1136.5, -1408.5, 5.60), ready = false, progressValue = 2.5},
                    [3] = { coords = vector3(-1136.5, -1408.5, 7.55), ready = false, progressValue = 2.5},

                    [4] = { coords = vector3(-1137.16, -1407.22, 3.65), ready = false, progressValue = 2.5},
                    [5] = { coords = vector3(-1137.16, -1407.22, 5.60), ready = false, progressValue = 2.5},
                    [6] = { coords = vector3(-1137.16, -1407.22, 7.55), ready = false, progressValue = 2.5},

                    [7] = { coords = vector3(-1135.8, -1409.81, 3.65), ready = false, progressValue = 2.5},
                    [8] = { coords = vector3(-1135.8, -1409.81, 5.60), ready = false, progressValue = 2.5},
                    [9] = { coords = vector3(-1135.8, -1409.81, 7.55), ready = false, progressValue = 5.0},

                    
                }
            },
            [2] = {
                frame = {
                    coords = vector3(-1139.32, -1407.90, 4.13),
                    rotation = vector3(90.0, 90.0, 125.0),
                    interactionCoords = vector4(-1139.66, -1407.24, 5.82, 210.03),
                },
                blocksSpawnLocation = vector3(-1146.54, -1408.96, 3.31),
                blocksSpawnRotation = vector3(-90.0, 0.0, 35.0),
                blocksInFrameLocations = {
                    [2] = { coords = vector3(-1139.32, -1407.90, 3.65), ready = false, progressValue = 2.5},
                    [1] = { coords = vector3(-1139.32, -1407.90, 5.60), ready = false, progressValue = 2.5},
                    [3] = { coords = vector3(-1139.32, -1407.90, 7.55), ready = false, progressValue = 2.5},

                    [4] = { coords = vector3(-1138.26, -1407.12, 3.65), ready = false, progressValue = 2.5},
                    [5] = { coords = vector3(-1138.26, -1407.12, 5.60), ready = false, progressValue = 2.5},
                    [6] = { coords = vector3(-1138.26, -1407.12, 7.55), ready = false, progressValue = 2.5},
                    
                    [7] = { coords = vector3(-1140.55, -1408.74, 3.65), ready = false, progressValue = 2.5},
                    [8] = { coords = vector3(-1140.55, -1408.74, 5.60), ready = false, progressValue = 2.5},
                    [9] = { coords = vector3(-1140.55, -1408.74, 7.55), ready = false, progressValue = 5.0},
                }
            },
        },

        mixerTargetLocations = {
            [1] = {
                pipes = {
                    [1] = {
                        coords = vector3(-1144.86, -1406.91, 3.59),
                        pedInstallingCoords = vector4(-1143.03, -1406.33, 3.36, 26.08),
                        rotation = vector3(0, -90.0, -150),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 5,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [2] = {
                        coords = vector3(-1143.46, -1406.095, 3.59),
                        pedInstallingCoords = vector4(-1143.03, -1406.33, 3.36, 26.08),
                        rotation = vector3(0, -90.0, -150),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 5,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [3] = {
                        coords = vector3(-1141.99, -1405.24, 3.59),
                        pedInstallingCoords = vector4(-1141.53, -1405.56, 3.39, 35.49),
                        rotation = vector3(0, -90.0, -150),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 5,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [4] = {
                        coords = vector3(-1140.6, -1404.43, 3.59),
                        pedInstallingCoords = vector4(-1140.03, -1404.82, 3.48, 40.35),
                        rotation = vector3(0, -90.0, -150),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 5,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    }, 
                    [5] = {
                        coords = vector3(-1139.12, -1403.58, 3.59),
                        pedInstallingCoords = vector4(-1139.11, -1403.55, 3.59, 15.03),
                        rotation = vector3(0, -90.0, -150),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 5,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                }, 
                [6] = {
                    coords = vector3(-1144.72, -1409.45, 3.59),
                    pedInstallingCoords = vector4(-1143.44, -1407.94, 4.44, 218.18),
                    rotation = vector3(0, -90.0, -150),
                    spawnByDefault = true,
                    ready = true,
                    progressValue = 5,
                    animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                    animName = "machinic_loop_mechandplayer",
                },
                [7] = {
                    coords =vector3(-1143.19, -1408.57, 3.59),
                    pedInstallingCoords = vector4(-1143.44, -1407.94, 3.55, 218.18),
                    rotation = vector3(0, -90.0, -150),
                    spawnByDefault = false,
                    ready = false,
                    progressValue = 5,
                    animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                    animName = "machinic_loop_mechandplayer",
                },
                [8] = {
                    coords =vector3(-1141.71, -1407.71, 3.59),
                    pedInstallingCoords = vector4(-1141.04, -1406.54, 3.44, 206.45),
                    rotation = vector3(0, -90.0, -150),
                    spawnByDefault = false,
                    ready = false,
                    progressValue = 5,
                    animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                    animName = "machinic_loop_mechandplayer",
                },
                [9] = {
                    coords =vector3(-1140.27, -1406.88, 3.59),
                    pedInstallingCoords = vector4(-1139.29, -1405.14, 3.55, 202.28),
                    rotation = vector3(0, -90.0, -150),
                    spawnByDefault = true,
                    ready = true,
                    progressValue = 5,
                    animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                    animName = "machinic_loop_mechandplayer",
                },
                [10] = {
                    coords =vector3(-1138.79, -1406.03, 3.59),
                    pedInstallingCoords = vector4(-1139.29, -1405.14, 3.55, 202.28),
                    rotation = vector3(0, -90.0, -150),
                    spawnByDefault = true,
                    ready = true,
                    progressValue = 5,
                    animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                    animName = "machinic_loop_mechandplayer",
                },
                
                
                },
                targetLocation = vector3(-1137.0, -1403.57, 5.08),
                mixerFixedTargetLocation = vector4(-1134.81, -1404.15, 5.13, 251.71),
                concreteSettings = {
                    startingLoc = vector3(-1140.52, -1406.9, 2.18),
                    rotation = vec3(-0.5,-2.25,120.0),
                    maxZ = 3.74,
                    model = "concrete",
                    progressValue = 20,
                },
                concreteReady = false
            },
        },
    },
    --Small Building Construction
    [5] = {
        paymentMultipler = 1.0,
        enableConcretePouring = true,
        mixerSpawnLocation = vector4(-812.66, -812.58, 19.53, 350.23),
    

        customTasks = {

            -- === IMPORTANT ===
            -- This task at the bottom, will not work. It's just sample for devs to copy and make their own custom tasks! :D
            -- === IMPORTANT ===

            -- [1] = {
            --     blipName = "Build Chair",
            --     blipSprite = 306,
            --     blipColor = 1,

            --     drawingText = "Build Chair",                                        -- This string will be drawed above coords in this Style: [E] | *text*
            --     coordsToDrawText = vector3(110.76, -398.65, 41.26),                 -- On this coords the text will be drawed
            --     pedInteractionCoords = vector4(111.58, -398.76, 41.26, 81.93),      -- After hitting E in the text, ped coords will be set to this
            --     animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",              -- Dict of anim that ped will play
            --     animName = "machinic_loop_mechandplayer",                           -- Anim Name to play
            --     TimeToBuild = 2000,                                                 -- How long the process will be?
            --     progressValue = 0,                                                  -- How much progress script should add for players after properly done task?

            --     spawnPropAfter = true,                                              -- Spawn any prop after task done?
            --     propSpawnCoords = vector3(109.04, -398.39, 41.27),                  -- If spawn, then on which coords?
            --     propSpawnRotation = vector3(0.0, 0.0, 0.0),                         -- If spawn, then on what rotation?
            --     propSpawnName = "v_corp_bk_chair1",                                 -- what prop name we should spawn? :D
            -- },
        },

        welding = {
            [1] = { coords = vector4(-838.14, -799.87, 18.45, 162.51), ready = false, progressValue = 5},
            [2] = { coords = vector4(-838.18, -786.86, 18.45, 69.70), ready = false, progressValue = 5},
            [3] = { coords = vector4(-826.15, -786.96, 18.45, 328.89), ready = false, progressValue = 5},
            [4] = { coords = vector4(-825.99, -799.79, 18.45, 240.74), ready = false, progressValue = 5},
        },
    
        walls = {
            [1] = {
                frame = {
                    coords = vector3(-811.3546, -806.3386, 18.53),
                    rotation = vector3(0.0, 0.0, 450.0),
                    interactionCoords = vector4(-812.02, -806.24, 20.33, 278.73),
                },
                blocksSpawnLocation = vector3(-815.83, -803.05, 17.90),
                blocksSpawnRotation = vector3(-90.0, 0.0, 0.0),
                blocksInFrameLocations = {
                    [1] = { coords = vector3(-811.37, -806.25, 18.65), ready = false, progressValue = 1.5},
                    [6] = { coords = vector3(-811.37, -806.25, 20.0), ready = false, progressValue = 1.5},
                    [11] = { coords = vector3(-811.37, -806.25, 21.5), ready = false, progressValue = 1.5},
                
                    [2] = { coords = vector3(-811.39, -804.30, 18.65), ready = false, progressValue = 1.5},
                    [7] = { coords = vector3(-811.39, -804.30, 20.0), ready = false, progressValue = 1.5},
                    [12] = { coords = vector3(-811.39, -804.30, 21.5), ready = false, progressValue = 1.5},
                    
                    [3] = { coords = vector3(-811.38, -802.32, 18.65), ready = false, progressValue = 1.5},
                    [8] = { coords = vector3(-811.38, -802.32, 20.0), ready = false, progressValue = 1.5},
                    [13] = { coords = vector3(-811.38, -802.32, 21.5), ready = false, progressValue = 1.5},
                    
                    [4] = { coords = vector3(-811.36, -808.2, 18.65), ready = false, progressValue = 1.5},
                    [9] = { coords = vector3(-811.36, -808.2, 20.0), ready = false, progressValue = 1.5},
                    [14] = { coords = vector3(-811.36, -808.2, 21.5), ready = false, progressValue = 1.5},
                    
                    [5] = { coords = vector3(-811.36, -810.12, 18.65), ready = false, progressValue = 1.5},
                    [10] = { coords = vector3(-811.36, -810.12, 20.0), ready = false, progressValue = 1.5},
                    [15] = { coords = vector3(-811.36, -810.12, 21.5), ready = false, progressValue = 1.5},
                }
            },
            [2] = {
                frame = {
                    coords = vector3(-825.54, -806.0, 18.53),
                    rotation = vector3(0.0, 0.0, 269.5),
                    interactionCoords = vector4(-824.82, -805.99, 20.33, 93.81),
                },
                blocksSpawnLocation = vector3(-822.3, -802.93, 17.90),
                blocksSpawnRotation = vector3(-90.0, 0.0, 0.0),
                blocksInFrameLocations = {
                    [1] = { coords = vector3(-825.53, -806.08, 18.65), ready = false, progressValue = 1.5},
                    [6] = { coords = vector3(-825.53, -806.08, 20.0), ready = false, progressValue = 1.5},
                    [11] = { coords = vector3(-825.53, -806.08, 21.5), ready = false, progressValue = 1.5},
                    
                    [2] = { coords = vector3(-825.52, -804.13, 18.65), ready = false, progressValue = 1.5},
                    [7] = { coords = vector3(-825.52, -804.13, 20.0), ready = false, progressValue = 1.5},
                    [12] = { coords = vector3(-825.52, -804.13, 21.5), ready = false, progressValue = 1.5},
    
                    [3] = { coords = vector3(-825.52, -802.23, 18.65), ready = false, progressValue = 1.5},
                    [8] = { coords = vector3(-825.52, -802.23, 20.0), ready = false, progressValue = 1.5},
                    [13] = { coords = vector3(-825.52, -802.23, 21.5), ready = false, progressValue = 1.5},
    
                    [4] = { coords = vector3(-825.56, -808.03, 18.65), ready = false, progressValue = 1.5},
                    [9] = { coords = vector3(-825.56, -808.03, 20.0), ready = false, progressValue = 1.5},
                    [14] = { coords = vector3(-825.56, -808.03, 21.5), ready = false, progressValue = 1.5},
                    
                    [5] = { coords = vector3(-825.57, -810.02, 18.65), ready = false, progressValue = 1.5},
                    [10] = { coords = vector3(-825.57, -810.02, 20.0), ready = false, progressValue = 1.5},
                    [15] = { coords = vector3(-825.57, -810.02, 21.5), ready = false, progressValue = 1.5},
                    
                }
            },
            
        },
    
        mixerTargetLocations = {
            [1] = {
                pipes = {
                    [1] = {
                        coords = vector3(-818.23, -811.73, 18.25),
                        pedInstallingCoords = vector4(-1117.52, -973.34, 1.75, 222.91),
                        rotation = vector3(0, 90.0, 90.0),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [2] = {
                        coords = vector3(-818.23, -809.97, 18.25),
                        pedInstallingCoords = vector4(-819.06, -810.11, 18.17, 272.55),
                        rotation = vector3(0, 90.0, 90.0),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [3] = {
                        coords = vector3(-818.23, -808.13, 18.25),
                        pedInstallingCoords = vector4(-818.95, -808.22, 18.17, 269.49),
                        rotation = vector3(0, 90.0, 90.0),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [4] = {
                        coords = vector3(-818.23, -806.36, 18.25),
                        pedInstallingCoords = vector4(-818.95, -806.35, 18.17, 281.48),
                        rotation = vector3(0, 90.0, 90.0),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [5] = {
                        coords = vector3(-818.23, -804.73, 18.25),
                        pedInstallingCoords = vector4(-1117.52, -973.34, 1.75, 222.91),
                        rotation = vector3(0, 90.0, 90.0),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
    
    
                    [6] = {
                        coords = vector3(-819.9, -810.32, 18.25),
                        pedInstallingCoords = vector4(-819.9, -810.32, 1.75, 222.91),
                        rotation = vector3(0, 90.0, 270.0),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [7] = {
                        coords = vector3(-819.9, -810.32, 18.25),
                        pedInstallingCoords = vector4(-819.17, -810.14, 18.17, 103.5),
                        rotation = vector3(0, 90.0, 90.0),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [8] = {
                        coords = vector3(-819.90, -808.57, 18.25),
                        pedInstallingCoords = vector4(-819.11, -808.26, 18.17, 95.77),
                        rotation = vector3(0, 90.0, 90.0),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [9] = {
                        coords = vector3(-819.905, -806.76, 18.25),
                        pedInstallingCoords = vector4(-819.08, -806.56, 18.17, 93.45),
                        rotation = vector3(0, 90.0, 90.0),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [10] = {
                        coords = vector3(-819.905, -804.99, 18.25),
                        pedInstallingCoords = vector4(-819.9, -810.32, 1.75, 222.91),
                        rotation = vector3(0, 90.0, 90.0),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 4,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
    
                },
                targetLocation = vector3(-819.42, -812.28, 19.53),
                mixerFixedTargetLocation = vector4(-822.51, -812.74, 19.19, 89.59),
                concreteSettings = {
                    startingLoc = vector3(-819.07, -807.89, 17.0),
                    rotation = vec3(0,0,-90),
                    maxZ = 18.3,
                    model = "concrete",
                    progressValue = 11,
                },
                concreteReady = false,
            },
        },
    },
    
    -- Large House Construction
    [6] = {
        paymentMultipler = 1.0,
        enableConcretePouring = false,
        mixerSpawnLocation = vector4(1005.7, -1868.33, 30.89, 359.32),

        customTasks = {

            -- === IMPORTANT ===
            -- This task at the bottom, will not work. It's just sample for devs to copy and make their own custom tasks! :D
            -- === IMPORTANT ===

            -- [1] = {
            --     blipName = "Build Chair",
            --     blipSprite = 306,
            --     blipColor = 1,

            --     drawingText = "Build Chair",                                        -- This string will be drawed above coords in this Style: [E] | *text*
            --     coordsToDrawText = vector3(110.76, -398.65, 41.26),                 -- On this coords the text will be drawed
            --     pedInteractionCoords = vector4(111.58, -398.76, 41.26, 81.93),      -- After hitting E in the text, ped coords will be set to this
            --     animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",              -- Dict of anim that ped will play
            --     animName = "machinic_loop_mechandplayer",                           -- Anim Name to play
            --     TimeToBuild = 2000,                                                 -- How long the process will be?
            --     progressValue = 0,                                                  -- How much progress script should add for players after properly done task?

            --     spawnPropAfter = true,                                              -- Spawn any prop after task done?
            --     propSpawnCoords = vector3(109.04, -398.39, 41.27),                  -- If spawn, then on which coords?
            --     propSpawnRotation = vector3(0.0, 0.0, 0.0),                         -- If spawn, then on what rotation?
            --     propSpawnName = "v_corp_bk_chair1",                                 -- what prop name we should spawn? :D
            -- },
        },

        welding = {
            [1] = { coords = vector4(-1123.78, -976.37, 1.15, 113.44), ready = false, progressValue = 4},
            [2] = { coords = vector4(-1133.39, -959.85, 5.63, 112.6), ready = false, progressValue = 4},
            [3] = { coords = vector4(-1127.99, -969.01, 5.63, 169.07), ready = false, progressValue = 4},
            [4] = { coords = vector4(-1125.44, -954.52, 1.15, 282.43), ready = false, progressValue = 4},
            [5] = { coords = vector4(-1124.96, -948.32, 1.15, 125.73), ready = false, progressValue = 4},
        },

        walls = {
            [1] = {
                frame = {
                    coords = vector3(-1116.45, -969.0, 1.0),
                    rotation = vector3(0.0, 0.0, 300.0),
                    interactionCoords = vector4(-1114.94, -970.06, 3.1, 115.28),
                },
                blocksSpawnLocation = vector3(-1110.49, -970.11, 0.55),
                blocksSpawnRotation = vector3(-90.0, 0.0, 35.0),
                blocksInFrameLocations = {
                    [1] = { coords = vector3(-1118.3, -965.78, 1.05), ready = false, progressValue = 1},
                    [2] = { coords = vector3(-1118.3, -965.78, 2.45), ready = false, progressValue = 1},
                    [3] = { coords = vector3(-1118.3, -965.78, 3.95), ready = false, progressValue = 1},

                    [4] = { coords = vector3(-1117.37, -967.33, 1.05), ready = false, progressValue = 1},
                    [5] = { coords = vector3(-1117.37, -967.33, 2.45), ready = false, progressValue = 1},
                    [6] = { coords = vector3(-1117.37, -967.33, 3.95), ready = false, progressValue = 1},

                    [7] = { coords = vector3(-1116.39, -969.08, 1.05), ready = false, progressValue = 1},
                    [8] = { coords = vector3(-1116.39, -969.08, 2.45), ready = false, progressValue = 1},
                    [9] = { coords = vector3(-1116.39, -969.08, 3.95), ready = false, progressValue = 1},

                    [10] = { coords = vector3(-1115.4, -970.77, 1.05), ready = false, progressValue = 1},
                    [11] = { coords = vector3(-1115.4, -970.77, 2.45), ready = false, progressValue = 1},
                    [12] = { coords = vector3(-1115.4, -970.77, 3.95), ready = false, progressValue = 1},

                    [13] = { coords = vector3(-1114.42, -972.44, 1.05), ready = false, progressValue = 1},
                    [14] = { coords = vector3(-1114.42, -972.44, 2.45), ready = false, progressValue = 1},
                    [15] = { coords = vector3(-1114.42, -972.44, 3.95), ready = false, progressValue = 1},
                
                }
            },
            [2] = {
                frame = {
                    coords = vector3(-1121.35, -960.53, 1.0),
                    rotation = vector3(0.0, 0.0, 300.0),
                    interactionCoords = vector4(-1120.65, -960.23, 3.1, 120.05),
                },
                blocksSpawnLocation = vector3(-1125.12, -953.2, 0.55),
                blocksSpawnRotation = vector3(-90.0, 0.0, 35.0),
                blocksInFrameLocations = {
                    [1] = { coords = vector3(-1121.26, -960.60, 1.05), ready = false, progressValue = 1},
                    [2] = { coords = vector3(-1121.26, -960.60, 2.45), ready = false, progressValue = 1},
                    [3] = { coords = vector3(-1121.26, -960.60, 3.95), ready = false, progressValue = 1},

                    [4] = { coords = vector3(-1122.26, -958.89, 1.05), ready = false, progressValue = 1},
                    [5] = { coords = vector3(-1122.26, -958.89, 2.45), ready = false, progressValue = 1},
                    [6] = { coords = vector3(-1122.26, -958.89, 3.95), ready = false, progressValue = 1},

                    [7] = { coords = vector3(-1123.23, -957.3, 1.05), ready = false, progressValue = 1},
                    [8] = { coords = vector3(-1123.23, -957.3, 2.45), ready = false, progressValue = 1},
                    [9] = { coords = vector3(-1123.23, -957.3, 3.95), ready = false, progressValue = 1},

                    [10] = { coords = vector3(-1120.34, -962.27, 1.05), ready = false, progressValue = 1},
                    [11] = { coords = vector3(-1120.34, -962.27, 2.45), ready = false, progressValue = 1},
                    [12] = { coords = vector3(-1120.34, -962.27, 3.95), ready = false, progressValue = 1},

                    [13] = { coords = vector3(-1119.34, -964.0, 1.05), ready = false, progressValue = 1},
                    [14] = { coords = vector3(-1119.34, -964.0, 2.45), ready = false, progressValue = 1},
                    [15] = { coords = vector3(-1119.34, -964.0, 3.95), ready = false, progressValue = 1},
                }
            },
            [3] = {
                frame = {
                    coords = vector3(-1131.60, -951.9, 1.0),
                    rotation = vector3(0.0, 0.0, 210.0),
                    interactionCoords = vector4(-1131.36, -952.65, 3.1, 32.71),
                },
                blocksSpawnLocation = vector3(-1120.0, -954.14, 0.55),
                blocksSpawnRotation = vector3(-90.0, 0.0, 35.0),
                blocksInFrameLocations = {
                    [1] = { coords = vector3(-1135.08, -953.92, 1.05), ready = false, progressValue = 1},
                    [2] = { coords = vector3(-1135.08, -953.92, 2.45), ready = false, progressValue = 1},
                    [3] = { coords = vector3(-1135.08, -953.92, 3.95), ready = false, progressValue = 1},

                    [4] = { coords = vector3(-1133.35, -952.93, 1.05), ready = false, progressValue = 1},
                    [5] = { coords = vector3(-1133.35, -952.93, 2.45), ready = false, progressValue = 1},
                    [6] = { coords = vector3(-1133.35, -952.93, 3.95), ready = false, progressValue = 1},

                    [7] = { coords = vector3(-1131.65, -951.98, 1.05), ready = false, progressValue = 1},
                    [8] = { coords = vector3(-1131.65, -951.98, 2.45), ready = false, progressValue = 1},
                    [9] = { coords = vector3(-1131.65, -951.98, 3.95), ready = false, progressValue = 1},

                    [10] = { coords = vector3(-1129.98, -951.0, 1.05), ready = false, progressValue = 1},
                    [11] = { coords = vector3(-1129.98, -951.0, 2.45), ready = false, progressValue = 1},
                    [12] = { coords = vector3(-1129.98, -951.0, 3.95), ready = false, progressValue = 1},

                    [13] = { coords = vector3(-1128.39, -950.075, 1.05), ready = false, progressValue = 1},
                    [14] = { coords = vector3(-1128.39, -950.075, 2.45), ready = false, progressValue = 1},
                    [15] = { coords = vector3(-1128.39, -950.075, 3.95), ready = false, progressValue = 1},
                    
                }
            },
            [4] = {
                frame = {
                    coords = vector3(-1125.65, -962.19, 1.0),
                    rotation = vector3(0.0, 0.0, 300.0),
                    interactionCoords = vector4(-1124.99, -961.65, 3.2, 167.23),
                },
                blocksSpawnLocation = vector3(-1112.34, -967.8, 0.55),
                blocksSpawnRotation = vector3(-90.0, 0.0, 35.0),
                blocksInFrameLocations = {
                    [1] = { coords = vector3(-1125.59, -962.23, 1.05), ready = false, progressValue = 1},
                    [2] = { coords = vector3(-1125.59, -962.23, 2.45), ready = false, progressValue = 1},
                    [3] = { coords = vector3(-1125.59, -962.23, 3.95), ready = false, progressValue = 1},

                    [4] = { coords = vector3(-1126.57, -960.54, 1.05), ready = false, progressValue = 1},
                    [5] = { coords = vector3(-1126.57, -960.54, 2.45), ready = false, progressValue = 1},
                    [6] = { coords = vector3(-1126.57, -960.54, 3.95), ready = false, progressValue = 1},

                    [7] = { coords = vector3(-1127.5, -958.99, 1.05), ready = false, progressValue = 1},
                    [8] = { coords = vector3(-1127.5, -958.99, 2.45), ready = false, progressValue = 1},
                    [9] = { coords = vector3(-1127.5, -958.99, 3.95), ready = false, progressValue = 1},

                    [10] = { coords = vector3(-1124.6, -963.94, 1.05), ready = false, progressValue = 1},
                    [11] = { coords = vector3(-1124.6, -963.94, 2.45), ready = false, progressValue = 1},
                    [12] = { coords = vector3(-1124.6, -963.94, 3.95), ready = false, progressValue = 1},

                    [13] = { coords = vector3(-1123.63, -965.68, 1.05), ready = false, progressValue = 1},
                    [14] = { coords = vector3(-1123.63, -965.68, 2.45), ready = false, progressValue = 1},
                    [15] = { coords = vector3(-1123.63, -965.68, 3.95), ready = false, progressValue = 1},
                
                }
            },
            [5] = {
                frame = {
                    coords = vector3(-1133.564, -958.3983, 1.0),
                    rotation = vector3(0.0, 0.0, 300.0),
                    interactionCoords = vector4(-1132.73, -958.24, 3.2, 126.76),
                },
                blocksSpawnLocation = vector3(-1129.49, -955.44, 0.45),
                blocksSpawnRotation = vector3(-90.0, 0.0, 35.0),
                blocksInFrameLocations = {
                    [1] = { coords = vector3(-1133.50, -958.45, 1.05), ready = false, progressValue = 1},
                    [2] = { coords = vector3(-1133.51, -958.45, 2.45), ready = false, progressValue = 1},
                    [3] = { coords = vector3(-1133.51, -958.45, 3.95), ready = false, progressValue = 1},

                    [4] = { coords = vector3(-1134.49, -956.75, 1.05), ready = false, progressValue = 1},
                    [5] = { coords = vector3(-1134.49, -956.75, 2.45), ready = false, progressValue = 1},
                    [6] = { coords = vector3(-1134.49, -956.75, 3.95), ready = false, progressValue = 1},
                
                    [7] = { coords = vector3(-1135.375, -955.21, 1.05), ready = false, progressValue = 1},
                    [8] = { coords = vector3(-1135.375, -955.21, 2.45), ready = false, progressValue = 1},
                    [9] = { coords = vector3(-1135.375, -955.21, 3.95), ready = false, progressValue = 1},
                
                    [10] = { coords = vector3(-1132.51, -960.15, 1.05), ready = false, progressValue = 1},
                    [11] = { coords = vector3(-1132.51, -960.15, 2.45), ready = false, progressValue = 1},
                    [12] = { coords = vector3(-1132.51, -960.15, 3.95), ready = false, progressValue = 1},

                    [13] = { coords = vector3(-1131.58, -961.77, 1.05), ready = false, progressValue = 1},
                    [14] = { coords = vector3(-1131.58, -961.77, 2.45), ready = false, progressValue = 1},
                    [15] = { coords = vector3(-1131.58, -961.77, 3.95), ready = false, progressValue = 1},
                }
            },
        },

        mixerTargetLocations = {
            [1] = {
                pipes = {
                    [1] = {
                        coords = vector3(-1117.43, -974.66, 2.5),
                        pedInstallingCoords = vector4(-1117.52, -973.34, 1.75, 222.91),
                        rotation = vector3(0, 180.0, -300),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 1,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [2] = {
                        coords = vector3(-1117.43, -974.66, 3.3),
                        pedInstallingCoords = vector4(-1117.52, -973.34, 1.75, 222.91),
                        rotation = vector3(0, 180.0, -300),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 1,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [3] = {
                        coords = vector3(-1117.43, -974.66, 3.3),
                        pedInstallingCoords = vector4(-1117.43, -974.66, 1.15, 146.38),
                        rotation = vector3(0, 360.0, -300),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 1,
                        animDict = "amb@prop_human_movie_bulb@idle_a",
                        animName = "idle_b",
                    },
                    [4] = {
                        coords = vector3(-1117.43, -974.66, 4.0),
                        pedInstallingCoords = vector4(-1117.52, -973.34, 2.50, 222.91),
                        rotation = vector3(0, 360.0, -300),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 1,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    



                    [5] = {
                        coords = vector3(-1138.35, -951.22, 1.3),
                        pedInstallingCoords = vector4(-1117.52, -973.34, 2.50, 222.91),
                        rotation = vector3(0, -90.0, 120.0),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 1,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [6] = {
                        coords = vector3(-1137.47, -952.75, 1.3),
                        pedInstallingCoords = vector4(-1117.52, -973.34, 2.50, 222.91),
                        rotation = vector3(0, -90.0, 120.0),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 1,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [7] = {
                        coords = vector3(-1136.58, -954.27, 1.3),
                        pedInstallingCoords = vector4(-1136.13, -955.17, 1.15, 19.38),
                        rotation = vector3(0, -90.0, 120.0),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 1,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [8] = {
                        coords = vector3(-1135.75, -955.7, 1.3),
                        pedInstallingCoords = vector4(-1135.21, -956.56, 1.15, 29.91),
                        rotation = vector3(0, -90.0, 120.0),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 1,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [9] = {
                        coords = vector3(-1134.91, -957.14, 1.3),
                        pedInstallingCoords = vector4(-1134.39, -957.99, 1.15, 29.76),
                        rotation = vector3(0, -90.0, 120.0),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 1,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [10] = {
                        coords = vector3(-1134.045, -958.64, 1.3),
                        pedInstallingCoords = vector4(-1117.52, -973.34, 2.50, 222.91),
                        rotation = vector3(0, -90.0, 120.0),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 1,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [11] = {
                        coords = vector3(-1133.21, -960.09, 1.3),
                        pedInstallingCoords = vector4(-1117.52, -973.34, 2.50, 222.91),
                        rotation = vector3(0, -90.0, 120.0),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 1,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [12] = {
                        coords = vector3(-1132.32, -961.63, 1.3),
                        pedInstallingCoords = vector4(-1117.52, -973.34, 2.50, 222.91),
                        rotation = vector3(0, -90.0, 120.0),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 1,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [13] = {
                        coords = vector3(-1131.38, -963.25, 2.0),
                        pedInstallingCoords = vector4(-1130.54, -963.39, 2.15, 77.02),
                        rotation = vector3(0, 180.0, 120.0),
                        spawnByDefault = true,
                        ready = true,
                        progressValue = 1,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [14] = {
                        coords = vector3(-1131.38, -963.25, 2.0),
                        pedInstallingCoords = vector4(-1130.54, -963.39, 1.15, 77.02),
                        rotation = vector3(0, 360.0, 120.0),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 1,
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        animName = "machinic_loop_mechandplayer",
                    },
                    [15] = {
                        coords = vector3(-1131.38, -963.25, 3.6),
                        pedInstallingCoords = vector4(-1130.99, -963.27, 1.15, 99.34),
                        rotation = vector3(0, 360.0, 120.0),
                        spawnByDefault = false,
                        ready = false,
                        progressValue = 1,
                        animDict = "amb@prop_human_movie_bulb@idle_a",
                        animName = "idle_b",
                    },

                
                },
                targetLocation = vector3(-461.95, -1011.5, 25.0),
                mixerFixedTargetLocation = vector4(-461.4, -1007.88, 23.38, 357.65),
                concreteSettings = {
                    startingLoc = vector3(-454.819977, -1011.89429, 19.04825),
                    rotation = vec3(0,0,-90),
                    maxZ = 22.4906921,
                    model = "concrete",
                    progressValue = 10,
                },
                concreteReady = false,
            },
        },
    },
}