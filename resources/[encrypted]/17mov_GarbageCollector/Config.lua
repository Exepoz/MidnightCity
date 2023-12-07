Config = {}

Config.useModernUI = true               -- In March 2023 the jobs have passed huge rework, and the UI has been changed. Set it to false, to use OLD no longer supported UI.
    Config.splitReward = false          -- This option work's only when useModernUI is false. If this option is true, the payout is: (Config.OnePercentWorth * Progress ) / PartyCount, if false then: (Config.OnePercentWorth * Progress)

Config.UseBuiltInNotifications = false   -- Set to false if you want to use ur framework notification style. Otherwise, the built in modern notifications will be used.=
Config.letBossSplitReward = false                    -- If it's true, then boss can manage whole party rewards percent in menu. If you'll set it to false, then everybody will get same amount.
Config.multiplyRewardWhileWorkingInGroup = true     -- If it's false, then reward will stay by default. For example $1000 for completing whole job. If you'll set it to true, then the payout will depend on how many players is there in the group. For example, if for full job there's $1000, then if player will work in 4 member group, the reward will be $4000. (baseReward * partyCount)
Config.Price = 2            -- Price per one bag inside trashmaster. 100 is maximum so full trash = 200$ / partyCount

Config.UseTarget = true                 -- Change it to true if you want to use a target system. All setings about the target system are under target.lua file.
Config.RequiredJob = "none"             -- Set to "none" if you dont want using jobs. If you are using target, you have to set "job" parameter inside every export in target.lua
Config.RequireJobAlsoForFriends = true          -- If it's false, then only host needs to have the job, if it's true then everybody from group needs to have the Config.RequiredJob
Config.RequireOneFriendMinimum = false  -- Set to true if you want to force players to create teams
Config.EnableGamePoolDeleting = true    -- Set to false only when using old versions of FXServer. May cause bag removal errors

Config.JobVehicleModel = "trash"                -- Model of the company car
Config.VehicleBackBone = "seat_dside_r1"        -- Bone used only when Config.UseTarget = false. 3D text is displayed on the coordinates of this bone telling us to put the bag in the trunk
Config.VehicleBackBoneCenter = "brakelight_l"   -- Bone used only when Config.UseTarget = false. On the cords of this bone, a player walks up to throw the bag
Config.PenaltyAmount = 500                      -- Penalty that is levied when a player finishes work without a company vehicle
Config.DeleteVehicleWithPenalty = false         -- Delete Vehicle even if its not company veh
Config.DontPayRewardWithoutVehicle = true      -- Set to true if you want to dont pay reward to players who want's to end without company vehicle (accepting the penalty)
Config.EnableVehicleTeleporting = true          -- If its true, then the script will teleport the host to the company vehicle. If its false, then the company vehicle will apeear, but the whole squad need to go enter the car manually
Config.JobCooldown = 10 * 60 -- 10 * 60            -- 0 minutes cooldown between making jobs (in brackets there's example for 10 minutes)
Config.GiveKeysToAllLobby = true                -- Set to false if you want to give keys only for group creator while starting job
Config.ProgressBarOffset = "25px"                   -- Value in px of counter offset on screen
Config.ProgressBarAlign = "bottom-right"            -- Align of the progressbar

-- ^ Options: top-left, top-center, top-right, bottom-left, bottom-center, bottom-right

Config.RewardItemsToGive = {
     {
         item_name = "rubber",
         chance = 100,
         amountPerBag = 4,
     },
     {
        item_name = "plastic",
        chance = 100,
        amountPerBag = 3,
    },
    {
        item_name = "aluminum",
        chance = 100,
        amountPerBag = 2,
    },
    {
        item_name = "iron",
        chance = 100,
        amountPerBag = 1,
    },
}

Config.EnableExploitFix = false                     -- If somebody is close to you, you'll not able to pick up bag. This will prevent exploit of copying bugs but will be also annoying
Config.RequiredItem = "none"                        -- Set it to anything you want, to require players to have some item in their inventory before they start the job
Config.RequireItemFromWholeTeam = true              -- If it's false, then only host needs to have the required item, otherwise all team needs it.

Config.RequireFullJob = false                       -- Set it to true, if you want players first to have 100% of progress, otherwise they'll not be able to end job.
Config.RequireWorkClothes = true                   -- Set it to true, to change players clothes everytime when they're starting job.

Config.RestrictBlipToRequiredJob = false            -- Set to true, to hide job blip for players, who dont have RequiredJob. If requried job is "none", then this option will not have any effect.
Config.Blips = { -- Here you can configure Company blip.
    [1] = {
        Sprite = 318,
        Color = 52,
        Scale = 0.8,
        Pos = vector3(-321.56, -1545.74, 30.01),
        Label = 'Garbage Job'
    },
}

Config.PropsHashes = {      -- Hashes of bags that we can pick up
    `bkr_prop_fakeid_binbag_01`,
	`hei_prop_heist_binbag`,
	`prop_cs_rub_binbag_01`,
	`prop_cs_street_binbag_01`,
	`prop_ld_rub_binbag_01`,
	`prop_rub_binbag_01`,
	`prop_rub_binbag_04`,
	`prop_rub_binbag_05`,
	`prop_rub_binbag_sd_01`,
	`prop_rub_binbag_sd_02`,
	`p_binbag_01_s`,
    `p_rub_binbag_test`,
    `prop_rub_binbag_06`,
	`prop_rub_binbag_08`, 
    `prop_rub_binbag_01b`,
	`prop_rub_binbag_03`,
	`prop_rub_binbag_03b`,
}

Config.Rotations = {       -- Used with the AttachEntityToEntity() function, when you pick up a bag, it will hook onto the specified values:
    [`bkr_prop_fakeid_binbag_01`] = { boneIndex = 6286, xPos = 0.0, yPos = 0, zPos = -0.6, xRot = -90, yRot = 0, zRot = 0, p9 = true, useSoft = true, collision = false, isPed = true, vertexIndex = 1, fixedRot = false, counterValue = 1},
	[`hei_prop_heist_binbag`] = { boneIndex = 6286, xPos = 0.0, yPos = 0, zPos = -0.05, xRot = -90, yRot = 0, zRot = 0, p9 = true, useSoft = true, collision = false, isPed = true, vertexIndex = 1, fixedRot = false, counterValue = 1},
	[`prop_cs_rub_binbag_01`] = { boneIndex = 6286, xPos = 0.0, yPos = 0, zPos = -0.04, xRot = -90, yRot = 0, zRot = 0, p9 = true, useSoft = true, collision = false, isPed = true, vertexIndex = 1, fixedRot = false, counterValue = 1},
	[`prop_cs_street_binbag_01`] = { boneIndex = 6286, xPos = 0.0, yPos = 0, zPos = -0.44, xRot = -90, yRot = 0, zRot = 0, p9 = true, useSoft = true, collision = false, isPed = true, vertexIndex = 1, fixedRot = false, counterValue = 1},
	[`prop_ld_rub_binbag_01`] = { boneIndex = 6286, xPos = 0.0, yPos = 0, zPos = -0.44, xRot = -90, yRot = 0, zRot = 0, p9 = true, useSoft = true, collision = false, isPed = true, vertexIndex = 1, fixedRot = false, counterValue = 1},
	[`prop_rub_binbag_01`] = { boneIndex = 6286, xPos = 0.0, yPos = -0.18, zPos = -0.44, xRot = -90, yRot = 0, zRot = 0, p9 = true, useSoft = true, collision = false, isPed = true, vertexIndex = 1, fixedRot = false, counterValue = 1},
	[`prop_rub_binbag_04`] = { boneIndex = 6286, xPos = 0.0, yPos = 0, zPos = -1.0, xRot = -90, yRot = 0, zRot = 0, p9 = true, useSoft = true, collision = false, isPed = true, vertexIndex = 1, fixedRot = false, counterValue = 1},
	[`prop_rub_binbag_05`] = { boneIndex = 6286, xPos = 0.0, yPos = 0, zPos = -0.64, xRot = -90, yRot = 0, zRot = 0, p9 = true, useSoft = true, collision = false, isPed = true, vertexIndex = 1, fixedRot = false, counterValue = 1},
	[`prop_rub_binbag_sd_01`] = { boneIndex = 6286, xPos = 0.0, yPos = 0, zPos = -0.44, xRot = -90, yRot = 0, zRot = 0, p9 = true, useSoft = true, collision = false, isPed = true, vertexIndex = 1, fixedRot = false, counterValue = 1},
	[`prop_rub_binbag_sd_02`] = { boneIndex = 6286, xPos = 0.0, yPos = -0.12, zPos = -0.44, xRot = -90, yRot = 0, zRot = 0, p9 = true, useSoft = true, collision = false, isPed = true, vertexIndex = 1, fixedRot = false, counterValue = 1},
	[`p_binbag_01_s`] = { boneIndex = 6286, xPos = 0.0, yPos = 0, zPos = -0.44, xRot = -90, yRot = 0, zRot = 0, p9 = true, useSoft = true, collision = false, isPed = true, vertexIndex = 1, fixedRot = false, counterValue = 1},
    [`p_rub_binbag_test`] = { boneIndex = 6286, xPos = 0.0, yPos = 0, zPos = -0.44, xRot = -90, yRot = 0, zRot = 0, p9 = true, useSoft = true, collision = false, isPed = true, vertexIndex = 1, fixedRot = false, counterValue = 1},
    [`prop_rub_binbag_06`] = { boneIndex = 6286, xPos = 0, yPos = -0.10, zPos = -0.44, xRot = -90, yRot = 0, zRot = 0, p9 = true, useSoft = true, collision = false, isPed = true, vertexIndex = 1, fixedRot = false, counterValue = 1},
	[`prop_rub_binbag_08`] = { boneIndex = 6286, xPos = 0, yPos = -0.10, zPos = -0.44, xRot = -90, yRot = 0, zRot = 0, p9 = true, useSoft = true, collision = false, isPed = true, vertexIndex = 1, fixedRot = false, counterValue = 1},
    [`prop_rub_binbag_01b`] = { boneIndex = 6286, xPos = 0, yPos = -0.10, zPos = -0.44, xRot = -90, yRot = 0, zRot = 0, p9 = true, useSoft = true, collision = false, isPed = true, vertexIndex = 1, fixedRot = false, counterValue = 1},
	[`prop_rub_binbag_03`] = { boneIndex = 6286, xPos = 0, yPos = -0.10, zPos = -0.44, xRot = -90, yRot = 0, zRot = 0, p9 = true, useSoft = true, collision = false, isPed = true, vertexIndex = 1, fixedRot = false, counterValue = 1},
	[`prop_rub_binbag_03b`] = { boneIndex = 6286, xPos = 0, yPos = -0.10, zPos = -0.44, xRot = -90, yRot = 0, zRot = 0, p9 = true, useSoft = true, collision = false, isPed = true, vertexIndex = 1, fixedRot = false, counterValue = 1},
}

Config.MarkerSettings = {   -- used only when Config.UseTarget = false. Colors of the marker. Active = when player stands inside the marker.
    Active = {
        r = 89, 
        g = 198,
        b = 100,
        a = 200,
    },
    UnActive = {
        r = 34,
        g = 117,
        b = 42,
        a = 200,
    }
}

Config.Locations = {       -- Here u can change all of the base job locations. 
    DutyToggle = {
        Coords = {
            vector3(-321.64309692383,-1545.8939208984,31.019908905029),
        },
        CurrentAction = 'open_dutyToggle',
        CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to ~y~start/finish~s~ work.',
        type = 'duty',
        scale = {x = 1.0, y = 1.0, z = 1.0}
    },
    FinishJob = {
        Coords = {
            vector3(-329.48321533203,-1522.9837646484,27.534698486328),
        },
        CurrentAction = 'finish_job',
        CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to ~y~end ~s~working.',
        scale = {x = 3.0, y = 3.0, z = 3.0}
    },

}

Config.SpawnPoint = vector4(-316.98, -1537.58, 26.64, 338.0)  -- Company car spawn point
Config.EnableCloakroom = true                                 -- if false, then you can't see the Cloakroom button under Work Menu
Config.Clothes = {

    -- Here you can configure clothes. More information on: https://docs.fivem.net/natives/?_0xD4F7B05C. Under this link you can see what id means what component.

    male = {
        ["mask"] = {clotheId = 0, variation = 0},
        ["arms"] = {clotheId = 30, variation = 0},
        ["pants"] = {clotheId = 36, variation = 0},
        ["bag"] = {clotheId = 0, variation = 0},
        ["shoes"] = {clotheId = 56, variation = 1},
        ["t-shirt"] = {clotheId = 59, variation = 1},
        ["torso"] = {clotheId = 56, variation = 0},
        ["decals"] = {clotheId = 0, variation = 0},
        ["kevlar"] = {clotheId = 0, variation = 0},
    },

    female = {
        ["mask"] = {clotheId = 0, variation = 0},
        ["arms"] = {clotheId = 57, variation = 0},
        ["pants"] = {clotheId = 35, variation = 0},
        ["bag"] = {clotheId = 0, variation = 0},
        ["shoes"] = {clotheId = 59, variation = 1},
        ["t-shirt"] = {clotheId = 36, variation = 1},
        ["torso"] = {clotheId = 49, variation = 1},
        ["decals"] = {clotheId = 0, variation = 0},
        ["kevlar"] = {clotheId = 0, variation = 0},
    }
}

Config.Lang = {

    -- Here you can changea all translations used in client.lua, and server.lua. Dont forget to translate it also under the HTML and JS file.

    -- Client
    ["no_permission"] = "Only the party owner can do that!",
    ["keybind"] = 'Garbage Marker Interaction',
    ["too_far"] = "Your party has started work, but you are too far from headquarters. You can still join them.",
    ["kicked"] = "You kicked %s out of the party",
    ["alreadyWorking"] = "First, complete the previous order.",
    ["quit"] = "You have left the Team",
    ["pickGarbage"] = "Pick up the trash",
    ["putGarbage"] = "Put the garbage in",
    ["cantSpawnVeh"] = "The truck spawn site is occupied.",
    ["full"] = "The garbage truck is already full!",
    ["wrongCar"] = "This is not your garbage truck",
    ["CarNeeded"] = "You need your garbage truck to finish the job.",
    ["nobodyNearby"] = "There is no one around",
    ["cantInvite"] = "To be able to invite more people, you must first finish the job",
    ["inviteSent"] = "Invite Sent!",
    ["spawnpointOccupied"] = "The car's spawn site is occupied",
    ["notFullJob"] = "You have to make 100% progress before ending a job",
    ["notADriver"] = "You need to be a driver of vehicle to end the job",
    ["wrongReward1"] = "The payout percentage should be between 0 and 100",
    ["wrongReward2"] = "The total percentage of all payouts exceeded 100%",
    ["tutorial"] = "The job involves collecting garbage from the city. You can collect any bag of garbage that lies on the ground. After picking up the bag, put it into the garbage truck. You can finish the job at any time, when you decide you want to finish, just return to the base and stow the vehicle. The payout depends on the number of bags collected. Some bags may be out of sync between certain players",  
    ["partyIsFull"] = "Failed to send an invite, your group is full",
    ["exploit"] = "You can't grab bag while somebody is nearby", -- Only if Config.EnableExploitFix is true
    ["cantLeaveLobby"] = "You can't leave the lobby while you're working. First, end the job.",

    -- Server
    ["isAlreadyHost"] = "This player leads his team.",
    ["isBusy"] = "This player already belongs to another team.", 
    ["hasActiveInvite"] = "This Player already has an active invitation from someone.",
    ["HaveActiveInvite"] = "You already have an active invitation to join the team.",
    ["InviteDeclined"] = "Your invitation has been declined.",
    ["InviteAccepted"] = "Your invitation has been accepted!",
    ["error"] = "There was a Problem joining a team. Please try again later.",
    ["kickedOut"] = "You've been kicked out of the garbage team!",
    ["reward"] = "You have received a payout of $",
    ["RequireOneFriend"] = "This job requires at least one team member",
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