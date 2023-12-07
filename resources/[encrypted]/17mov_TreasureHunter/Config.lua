Config = {}

Config.useModernUI = true               -- In March 2023 the jobs have passed huge rework, and the UI has been changed. Set it to false, to use OLD no longer supported UI.
    Config.splitReward = false          -- This option work's only when useModernUI is false. If this option is true, the payout is: (Config.OnePercentWorth * Progress ) / PartyCount, if false then: (Config.OnePercentWorth * Progress)
Config.UseBuiltInNotifications = false   -- Set to false if you want to use ur framework notification style. Otherwise, the built in modern notifications will be used.=

Config.letBossSplitReward = false                    -- If it's true, then boss can manage whole party rewards percent in menu. If you'll set it to false, then everybody will get same amount.
Config.multiplyRewardWhileWorkingInGroup = true     -- If it's false, then reward will stay by default. For example $1000 for completing whole job. If you'll set it to true, then the payout will depend on how many players is there in the group. For example, if for full job there's $1000, then if player will work in 4 member group, the reward will be $4000. (baseReward * partyCount)
Config.reward = 1500                    -- Reward for one treasure. If you want to use a item reward then modify Pay() function under /server/functions.lua

Config.UseTarget = true                    -- Change it to true if you want to use a target system. All setings about the target system are under target.lua file.


Config.SharedTreasureFeature = true             -- Set to false, to make every group have treasure in different location. 
Config.RequiredJob = "none"                     -- Set to "none" if you dont want using jobs. If you are using target, you have to set "job" parameter inside every export in target.lua
Config.RequireJobAlsoForFriends = true          -- If it's false, then only host needs to have the job, if it's true then everybody from group needs to have the Config.RequiredJob
Config.RequireOneFriendMinimum = false          -- Set to true if you want to force players to create teams
Config.JobVehicleModel = "17mov_TreasureBoat"   -- Job Boat model
Config.TreasureProp = `prop_box_wood01a`        -- Treasure Prop Model
Config.EasyMode = false                          -- Set to true if you want smaller radius on map, and display marker above treasure. Stay false for more immsersive searching :D
Config.EnableTrackerSound = true                -- Tracker Sound on idle
Config.TrakcerSoundMinimumDistance = 30.0       -- if Player Distance to treasure is smaller than this value, loop the tracker distance
Config.ShowBlipWhenNearby = false                -- Show blip on map when player is nearby, and play a sound. Set to false if you want more immersive seaarching :D
Config.TreaureBlipDistance = 15.0               -- If Player distance to the treasure is smaller than this value, then shut down the tracker sound, and show blip on map
Config.FakeLocationChance = 5                   -- Chance to randomize a location and not spawn any treasure. [FAKE LOCATION WITHOUT TREASURE]
Config.FakeRestart = 25000 * 60                 -- Restart location if treasure is fake after 45 seconds, if treasure is real, then location will be active as long as somebody will find it.
Config.AnchorBone = "bodyshell"                 -- Bone used only when Config.UseTarget == false. On coords of this bone script display a 3D Text.

Config.EnableCloakroom = true                       -- Hide cloakroom part from starting job UI 
Config.RequireWorkClothes = true                   -- Set it to true, to change players clothes everytime when they're starting job.
Config.RequiredItem = "none"                        -- Set it to anything you want, to require players to have some item in their inventory before they start the job
Config.RequireItemFromWholeTeam = true              -- If it's false, then only host needs to have the required item, otherwise all team needs it.

Config.PenaltyAmount = 500                      -- Penalty that is levied when a player finishes work without a company vehicle
Config.EnableVehicleTeleporting = true      -- If its true, then the script will teleport the host to the company vehicle. If its false, then the company vehicle will apeear, but the whole squad need to go enter the car manually
Config.DontPayRewardWithoutVehicle = true      -- Set to true if you want to dont pay reward to players who want's to end without company vehicle (accepting the penalty)
Config.DeleteVehicleWithPenalty = false         -- Delete Vehicle even if its not company veh
Config.JobCooldown = 10 * 60 -- 10 * 60            -- 0 minutes cooldown between making jobs (in brackets there's example for 10 minutes)
Config.GiveKeysToAllLobby = true                -- Set to false if you want to give keys only for group creator while starting job
Config.ProgressBarOffset = "25px"                   -- Value in px of counter offset on screen
Config.ProgressBarAlign = "bottom-right"            -- Align of the progressbar

-- ^ Options: top-left, top-center, top-right, bottom-left, bottom-center, bottom-right

Config.RewardItemsToGive = {
    -- {
    --     item_name = "water",
    --     chance = 100,
    --     amountPerTreasure = 1,
    -- },
}

Config.RestrictBlipToRequiredJob = false            -- Set to true, to hide job blip for players, who dont have RequiredJob. If requried job is "none", then this option will not have any effect.
Config.Blips = {                        -- Here you can configure Company blip.
    [1] = {
        Sprite = 366,
        Color = 50,
        Scale = 0.8,
        Pos = vector3(167.82, -2222.7, 7.24),
        Label = 'Treasure Hunter'
    },
}

Config.MarkerSettings = {               -- used only when Config.UseTarget = false. Colors of the marker. Active = when player stands inside the marker.
    Active = {
        r = 255, 
        g = 0,
        b = 0,
        a = 200,
    },
    UnActive = {
        r = 140,
        g = 10,
        b = 10,
        a = 200,
    }
}

Config.Locations = {                    -- Here u can change all of the base job locations. 
    DutyToggle = {
        Coords = {
            vector3(167.82, -2222.7, 7.24),
        },
        CurrentAction = 'open_dutyToggle',
        CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to ~y~start/finish~s~ work.',
        type = 'duty',
        scale = {x = 1.0, y = 1.0, z = 1.0}
    },
    FinishJob = {
        Coords = {
            vector3(163.3, -2263.33, 1.5),
        },
        CurrentAction = 'finish_job',
        CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to ~y~end ~s~working.',
        scale = {x = 3.0, y = 3.0, z = 3.0}
    },

}

Config.SpawnPoint = vector4(163.3, -2263.33, 0.11, 268.86)  -- Vehicle spawn point

Config.Clothes = {
    male = {
        ["mask"] = {clotheId = 0, variation = 0},
        ["arms"] = {clotheId = 8, variation = 0},
        ["pants"] = {clotheId = 94, variation = 0},
        ["bag"] = {clotheId = 0, variation = 0},
        ["shoes"] = {clotheId = 67, variation = 0},
        ["t-shirt"] = {clotheId = 15, variation = 0},
        ["torso"] = {clotheId = 243, variation = 0},
        ["decals"] = {clotheId = 0, variation = 0},
        ["kevlar"] = {clotheId = 0, variation = 0},
    },
    
    female = {
        ["mask"] = {clotheId = 0, variation = 0},
        ["arms"] = {clotheId = 3, variation = 0},
        ["pants"] = {clotheId = 97, variation = 0},
        ["bag"] = {clotheId = 0, variation = 0},
        ["shoes"] = {clotheId = 70, variation = 0},
        ["t-shirt"] = {clotheId = 15, variation = 0},
        ["torso"] = {clotheId = 251, variation = 0},
        ["decals"] = {clotheId = 0, variation = 0},
        ["kevlar"] = {clotheId = 0, variation = 0},
    }
}

Config.Lang = {

    -- Here you can changea all translations used in client.lua, and server.lua. Dont forget to translate it also under the HTML and JS file.

    -- Client
    ["no_permission"] = "Only the party owner can do that!",
    ["keybind"] = 'Diving Marker Interaction',
    ["too_far"] = "Your party has started work, but you are too far from headquarters. You can still join them.",
    ["kicked"] = "You kicked %s out of the party",
    ["alreadyWorking"] = "First, complete the previous order.",
    ["quit"] = "You have left the Team",
    ["cantSpawnVeh"] = "The boat spawn site is occupied.",
    ["nobodyNearby"] = "There is no one around",
    ["newTarget"] = "The treasure has been found or the boss has indicated a new location",
    ["treasureBlipName"] = "Treasure Location",
    ["collectTreasure"] = "Collect Treasure",
    ["dropAnchor"] = "Drop or Lift Anchor",
    ["anchorNotifytrue"] = "The anchor has been dropped",
    ["anchorNotifyfalse"] = "The anchor has been raised",
    ["wrongCar"] = "This is not ur starting boat!",
    ["treasure"] = "Treasure Location",
    ["spawnpointOccupied"] = "The car's spawn site is occupied",
    ["CarNeeded"] = "Need a company boat to finish the job",
    ["notADriver"] = "You need to be a driver of vehicle to end the job",
    ["cantInvite"] = "To be able to invite more people, you must first finish the job",
    ["wrongReward1"] = "The payout percentage should be between 0 and 100",
    ["wrongReward2"] = "The total percentage of all payouts exceeded 100%",
    ["tutorial"] = "The job involves treasure hunting. The boss will assign you the location of the potential treasure when you start work. You share one spot with all other teams, so hurry to find it before everyone else. However, when someone gets ahead of you, another location will be designated, and you will be informed. Don't forget to wear your work wear to dive longer and to drop the anchor when you get there, you'll find it on the front of the boat",
    ["inviteSent"] = "Invite Sent!",
    ["partyIsFull"] = "Failed to send an invite, your group is full",
    ["cantLeaveLobby"] = "You can't leave the lobby while you're working. First, end the job.",

    -- Server
    ["isAlreadyHost"] = "This player leads his team.",
    ["isBusy"] = "This player already belongs to another team.", 
    ["hasActiveInvite"] = "This Player already has an active invitation from someone.",
    ["HaveActiveInvite"] = "You already have an active invitation to join the team.",
    ["InviteDeclined"] = "Your invitation has been declined.",
    ["InviteAccepted"] = "Your invitation has been accepted!",
    ["error"] = "There was a Problem joining a team. Please try again later.",
    ["kickedOut"] = "You've been kicked out of the divers team!",
    ["reward"] = "You have received a payout of $",
    ["RequireOneFriend"] = "This job requires at least one team member",
    ["yourTeamWon"] = "Your team has found a treasure. Head to the base and complete the work to get paid, or keep searching!",
    ["penalty"] = "You paid a fine in the amount of ",
    ["clientsPenalty"] = "The team's host accepted the punishment. You have not received the payment",
    ["dontHaveReqItem"] = "You or someone from your team do not have the required item to start work",
    ["notEverybodyHasRequiredJob"] = "Not every of your friends have the required job",
    ["someoneIsOnCooldown"] = "You or someone from your team can't make the job now (cooldown: %s)",
    ["hours"] = "h",
    ["minutes"] = "m",
    ["seconds"] = "s",
    ["newBoss"] = "The previous lobby boss has left the server. You are now the team leader",
}

Config.TreasureLocations = { 

    -- Here you can modify/add some treasure coords.

    vector3(1815.49768, -2954.997, -45.5570831),
    vector3(1864.00513, -2943.36328, -45.1559143),
    vector3(2087.157, -3039.93726, -47.4239426),
    vector3(2193.7627, -3127.48364, -94.57767),
    vector3(2378.85034, -2499.71631, -35.8349953),
    vector3(2627.7478, -2413.352, -54.75626),
    vector3(2626.367, -2423.33521, -55.3033142),
    vector3(2846.15332, -2222.815, -41.333744),
    vector3(2859.74365, -1891.47119, -34.197506),
    vector3(2984.12964, -1498.41418, -27.9075184),
    vector3(3177.29468, -581.065247, -127.739563),
    vector3(3281.40527, -402.4866, -117.204651),
    vector3(3299.69238, -406.8575, -124.827339),
    vector3(3299.3125, -397.5286, -116.688576),
    vector3(3256.39038, -420.755249, -77.03309),
    vector3(3201.50244, -402.942261, -25.67505),
    vector3(3412.09766, -74.54607, -140.977844),
    vector3(3460.43457, 378.9865, -122.711594),
    vector3(3422.76685, 965.6635, -128.906647),
    vector3(3317.28442, 1120.36389, -112.818596),
    vector3(3355.995, 1508.01233, -139.310776),
    vector3(3410.40137, 1958.86682, -51.6830864),
    vector3(3902.61035, 3058.50049, -29.4393253),
    vector3(3883.802, 3039.01636, -25.3941383),
    vector3(3583.80859, 2718.93262, -27.3160973),
}