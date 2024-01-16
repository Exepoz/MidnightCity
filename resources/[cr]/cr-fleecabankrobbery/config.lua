Config = {}
-- Locales System Inspired by Code Design.
function Lcl(txt, ...) if CRFleecaLocales[txt] then return string.format(CRFleecaLocales[txt], ...) else print('Locale Error, Contact Server Admin. ('..txt..')') end end

Config.Framework = {
  MLO = "K4MB1", -- "K4MB1" for K4MB1's Fleecas | "Gabz" for Gabz's Fleecas |
  Framework = "QBCore", --"QBCore" | "ESX"
  Interaction = {
      UseTarget = GetConvar('UseTarget', 'false') == 'true', -- Leave true if you are using qb-target. Set to false to disable targetting and enable DrawText for all interactions
      Target = "oxtarget", -- "qb-target" | "oxtarget"
      OxLibDistanceCheck = false -- If true, most distance checks are done via oxlib, if false distance checks are done via built-in functions.
  },
  --Framework Overrides (You can change specific framework related functions to ones from other scripts.)
  UseOxInv = false, -- For ESX and QBCore. Lets ESX users utilize the "uses" configuration on the usb (Uses Item Metadata)
  Doorlocks = 'qb', --  'qb' = qb-doorlock | 'nui' = nui-doorlock | 'ox' = ox_doorlocks
  Skillbar = "qb-skillbar", -- "qb-skillbar" | "custom" (See cl_framework)
  CircleMinigame = "oxlib", -- "ps-ui" | "qb-lock" | "oxlib" | (You can use your own (See cl_framework)
  Notifications = "oxlib", -- "okok" | "mythic" | "tnj" | "oxlib" | "qb" | "ESX" | "chat" |
  ProgressUI = "", -- "oxlib" | "mythic" | "rprogress" (Custom Settings at the bottom) |  Otherwise leave blank ("") to use Framework Settings.
  DrawText = "oxlib", -- "oxlib" | "okok" | "psui" | Otherwise leave blank ("") to use Framework Settings.
  -- *Important* All oxlib option requires oxlib to be enabled in the fxmanifest *Important*
}

Config.DevMode = false -- Set to 'true' if you are Testing the Resource
Config.Debug = false -- True = Debug Prints Enabled | false = Debug Prints Disabled
Config.DebugPoly = false -- true = Visible Polyzones Enabled | fase = Visible Polyzones Disabled
Config.InteractKey = "G" -- Key to press when interacting with things (Default : G | See Config.KeyList to know which string to change this value to.)
Config.Scoreboard = true -- true = qb-scoreboard Enabled | false = qb-scoreboard disabled (See cl_framework to change scoreboard trigger)
Config.Logs = true -- true = qb-logs Enabled | qb-logs Disabled
Config.ControlsDisabled = {36, 73, 322} -- Disable Controls when doing actions. Default : LEFT_CTRL, X, ESC
Config.HeistTimer = 10 -- Time for the players to complete the heist before cooldown starts
Config.Cooldown = {
  Type = "global", -- "global" means only 1 bank can be done per cooldown interval | "unique" means each banks has their own coolodwn
  Time = 60 -- Minutes
}

-- Server Restarts / Script Restart Specific Configurations
Config.ServerStartCooldown = false -- true = Bank Cooldown on Server Start Enabled | false =  Bank Cooldown on Server Start Disabled
Config.ServerStartCooldownTime = 45 -- Time Is In Minutes | Cooldown is GLOBAL

Config.Police = {
  CopsNeeded = 0, -- Amount of Cops needed to be online for the robbery to start
  CallCops = true,-- True = Enables Police Alerts | False = Disable Police Alers
  PoliceJobs = {"police"}, -- Name of the police jobs | You can add as many jobs in the table.
  Dispatch = "ps-dispatch", -- "qb" = Default (qb-policejob) | "cd" = Code Design's Dispatch | "core" = Core Dispatch | "ps-dispatch" = Project Sloth Dispatch | "other" = custom (see client/cl_extras.lua)
  ServerSideDispatch = false, -- Set true if using a dispatch system which needs to call the dispatch server-side.
  TenCode = "10-90", -- 10-code used for the robery call (CD Dispatch + Core Dispatch)
  DispatchMessageTitle = "Bank Robbery", --Alert Title (CD Dispatch)
  DispatchMessage = "Fleeca Bank Robbery in Progress!", --Alert Message
}

Config.Items = {
  Lockpick = {item = 'lockpick', name = "lockpick"},
  ComputerHackItem = {item = "lime_hacking", name = "Password Cracker"},
  VaultCardItem = {item = "crfleecacard", name = "Fleeca Bank Security Card"},
  DrillingItem = {item = "drill", name = "drill"},
  PowerSaw = {item = "powersaw", name = "power saw"},
  BrokePowerSaw = {item = "brokenpowersaw", name = "broken power saw"},
  GoldBar = {item = "goldbar", name = "gold bar"},
  BaggedMoney = {item = "markedbills", name = "marked money"},
  PrintedDocument = {item = "printed_document", name = "printed document"},
}

Config.Difficulties = {
  TellerDoor = {
    RemoveLockpick = true, -- Sets if there
    LockpickRemovalChance = 100, -- Chance to remove the lockpick if enabled
    CircleAmount = {min = 5, max = 8}, -- Amount of circles for the lockpick minigame
    CircleMinigameTimeDifficulty = {min = 7, max = 15}, -- Difficulty for the Teller door lockpicking
    OxLibDifficulty = "easy", -- 'easy' | 'medium' | 'hard' Oxlib difficulty for the teller door lockpicking
  },
  ComputerHack = {
    RemoveItem = true, -- true/false if the hacking item can get removed
    RemovalType = "uses", -- "uses" the hacking item has a certain amount of uses | "chance" the hacking item has a chance of being removed on use
    ItemUses = 3, -- if RemovalType == "uses" the # of uses the item has
    RemovalChance = 100,  -- if RemovalType == "chance" the % chance the item has of being removed
    Hack = "Custom", -- "NumberColor" | "VAR" | "Dimbo" | "mHacking" | "Custom" (You can replace the hack by any that you want, see cl_framework l.63)
    NumberColor = { -- Difficulty Settings for the Number/Color Minigame
      Script = 'nathan', -- jesper = Jespers's NoPixel Number Color Hack | nathan = nathan's fork which include hack configuration
      -- Configuration (If using Nathan's)
      TimeToType = 7, -- (If using Nathan's) Time in Seconds to remember the information shown
      Amount = 4, -- Amount of blocks shown on screen
      Repeats = 4, --Amount of correct answers needed to complete the hack
    },
    Dimbo = { -- Difficulty Settings for the Dimbo PassHack
      Difficulty = 4 -- Chose Between (1-8) (The higher the difficulty, the more numbers have to be remembered)
    },
    Var = { -- Difficulty Settings for the VAR-Hack
      Script = "psui", -- "psui" or "standalone"
      Blocks = 5, -- Blocks Needed to be found
      TimeToShow = 3 -- Time in seconds for the player to memorize the blocks
    },
    mHacking = { -- Difficulty Settings for mHacking
      NumberAmount = 3, -- Amount of digit per "set" needed to be found
      TimeToHack = 10 -- Time in seconds to finish the hack
    }
  },
  Safecracking = {
    CircleAmount = {min = 1, max = 8}, -- Amount of circles to complete to find 1 number of the safe combination
    CircleMinigameTimeDifficulty = {min = 5, max = 12}, -- Circle Minigame Difficulty (Not oxlib)
    OxLibDifficulty = "medium", -- oxlib circle minigame difficulty
    AddSkillbar = true, -- Add a skillbar after the circle minigame to "lock" the number
    SkillbarDifficulty = {
      Duration = {min = 1, max = 2}, -- qb-skillbar bar duration
      Width = {min = 10, max = 20} -- qb-skillbar bar width
    }
  },
  VaultDoor = {
    CodesNeeded = true, -- When true, player needs to input the vault code found in the safe.
    DoorTimer = 2, -- Time (in Minutes) it takes to open the vault door after successfuly entering the code.
    Card = "crfleecacard", -- Card used to open the Vault Door
    CardRemoval = true -- Set True to remove the Card after succesfully oppening the door
  },
  DrillingMinigame = {
    Type = "custom", -- "custom" for custom-made drilling | "fivem-drilling" if you want to use default GTA Style drilling. (GTA Style gives less loot overall.)
    DrillCanBreak = true, -- True = Drill has a chance to break when failing the Deposit Boxes Minigame | False = Disables the feature.
    DrillBreakChance = 30, -- If above true, % chance for the drill to break when failing the Deposit Boxes Minigame (Custom drilling minigame has 100% chance of breaking the blade if overheated).
    BladeHealth = 750, -- Deposit Boxes Drill Bit Health (Loses health when overheating)
    UIPosition = { -- Position for the UI
      Text = {scale = 0.8, x = 0.01, y = 0.6},
      Commands = {scale = 0.6, x = 0.01, y = 0.7}
    }
  }
}

Config.SawMiningame = { -- Gabz Safe/Deposit Box Saw Minigame Configuration
  ProgressSpeedMultiplier = 2, -- How fast does the progress goes
  BladeHeatMultiplier = 3, -- How fast does the heat accumulates
  UIPosition = { -- Position for the UI
    Text = {scale = 0.8, x = 0.01, y = 0.6},
    Commands = {scale = 0.6, x = 0.01, y = 0.7}
  },
}

Config.Rewards = {
  Safe = {
    CardChance = 100, -- Chance of finding a security card in the Safe (K4MB1)/Deposit Box (Gabz)
    Loot = { -- Possible Loot in the safe (Marked Bills & Money Not Supported Yet)
    -- Uses Weight system. Higher weight = higher chance of giving the item
      [1] = {item = "diamond", amount = {Min = 1, Max = 2}, weight = 50},
      [2] = {item = "goldbar", amount = {Min = 1, Max = 2}, weight = 50},
      [3] = {item = "goldchain", amount = {Min = 2, Max = 3}, weight = 50}
    },
  },
  Trays = {
    MaxTrayAmount = 4, -- Max Amount of Trays that can spawn (Do not put higher than 5)
    MoneyWorth = {Min = 5000, Max = 6500}, -- Amount of Money Per Bags
    MoneyBagAmount = {Min = 5, Max = 6}, -- Amount of Money Bags received per trays.
    GoldChance = 40, --Chance for a Tray to contain gold bars.
    GoldAmount = {Min = 3, Max = 6}, -- Amount of Gold Bars per Trays
    MoneyInBags = true, --If False, receives the entire amount directly in cash ('MoneyBagAmount' times 'MoneyWorth')
  },
  DepositBoxes = {
    BoxAmount = {Min = 1, Max = 2}, -- Amount of Boxes/Rolls per Walls.
    EmptyChance = 10, -- % Chance of a "Box" being empty
  -- The config above is only used if you use the custom drilling. If you chose to use FieM-Drilling, you should up the MinAmount and MaxAmount, as players only receive 1 set of loot and not multiple.
    Loot = {
      -- Uses Weight system. Higher weight = higher chance of giving the item
      [1] = {item = "diamond_ring", amount = {Min = 8, Max = 10}, weight = 50},
      [2] = {item = "rolex", amount = {Min = 8, Max = 10}, weight = 50},
      [3] = {item = "goldchain", amount = {Min = 8, Max = 10}, weight = 50},
      [4] = {item = "10kgoldchain", amount = {Min = 8, Max = 10}, weight = 25},
      [5] = {item = "diamond", amount = {Min = 8, Max = 10}, weight = 20}, --
      --[6] = {item = "crpaleto_usb", amount = {Min = 8, Max = 10}, weight = 10} -- "Rare" Item
    }
  },
  Table = {
    GoldChance = 25, -- Chance of the table pile being gold.
    GoldAmount = {Min = 3, Max = 6}, -- Amount of gold bars in the table gold pile.
    MoneyWorth = {Min = 9000, Max = 12000}, -- Worth of the money in each bags received from the table.
    BagAmount = {Min = 4, Max = 5}, -- Amount of Money Item received from the table.
    MoneyInBags = true, -- If False, receives the entire amount directly in cash ('MoneyBagAmount' times 'MoneyWorth')
  }
}

--DOOR CONFIGURATION
--If not using the provided doorlock config file, place your door ids here.
--#1 ~ Legion Square
--#2 ~ Pink Cage
--#3 ~ Hawick Ave
--#4 ~ Del Perro Av
--#5 ~ Harmony
--#6 ~ Great Ocean

-- You will need to add you own door IDs if you use ox_doorlocks!

--~ Teller Doors
Config.FleecaBankTellerDoors = { -- Place you door hash for the teller doors here, remember to follow the order shown above
  [1] = "CR_"..Config.Framework.MLO.."Fleecas-legion_teller",
  [2] = "CR_"..Config.Framework.MLO.."Fleecas-pinkcage_teller",
  [3] = "CR_"..Config.Framework.MLO.."Fleecas-hawick_teller",
  [4] = "CR_"..Config.Framework.MLO.."Fleecas-delperro_teller",
  [5] = "CR_"..Config.Framework.MLO.."Fleecas-harmony_teller",
  [6] = "CR_"..Config.Framework.MLO.."Fleecas-ocean_teller",
}
--~ Prevault Doors
Config.PreVaultDoors = { -- Place you door hash for the Pre-Vault Room doors here, remember to follow the order shown above
  [1] = "CR_"..Config.Framework.MLO.."Fleecas-legion_prevault",
  [2] = "CR_"..Config.Framework.MLO.."Fleecas-pinkcage_prevault",
  [3] = "CR_"..Config.Framework.MLO.."Fleecas-hawick_prevault",
  [4] = "CR_"..Config.Framework.MLO.."Fleecas-delperro_prevault",
  [5] = "CR_"..Config.Framework.MLO.."Fleecas-harmony_prevault",
  [6] = "CR_"..Config.Framework.MLO.."Fleecas-ocean_prevault",
}

Config.KeyList = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

-- BELOW ARE ALL THE COORDINATES NECESSARY FOR THE BANKS. YOU SHOULDN'T NEED TO TOUCH ANYTHING UNLESS YOU KNOW WHAT YOU ARE DOING.

if Config.Framework.MLO == "K4MB1" then
  Config.Banks = {
    [1] = { --Legion Square
      name = "Legion Square",
      loc = vector4(148.13, -1042.5, 29.37, 337.44),
      TellerDoors = {
        coords = vector3(145.64, -1040.86, 29.37),
        heading = 250.48, minZ = 29.37, maxZ = 29.52,
      },
      Cameras = {
        coords = vector3(138.86, -1056.2, 28.81),
        heading = 340.0, minZ = 29.37, maxZ = 29.52,
        z1 = vector4(149.33, -1042.69, 29.37, 160.0),
        z2 = vector4(146.06, -1044.70, 29.38, 160.0),
      },
      ComputerCoords = {
        coords = vector3(151.09, -1042.08, 29.67),
        heading = 339.3193, minZ = 29.52, maxZ = 29.72,
      },
      Printer = {
        coords = vector3(152.52, -1043.84, 29.37),
        heading = 334.0, minZ = 28.27, maxZ = 29.87,
      },
      PreVaultDoor = {
        coords = vector3(144.3, -1043.19, 29.37),
        heading = 342, minZ = 29.57, maxZ = 29.92,
      },
      Safe = {
        coords = vector3(145.32, -1045.99, 29.37),
        heading = 339.00, DoorHeading = 160.00,
        minZ = 29.12, maxZ = 29.77,
      },
      CardSwipe = {
        coords = vector3(147.30, -1046.30, 29.37),
        heading = 250.00, minZ = 29.72, maxZ = 29.87,
      },
      VaultDoor = {
        coords = vector3(148.00, -1044.36, 29.63),
        ClosedHeading = 249.846, OpenHeading = 150.00
      },
      Table = {
        coords = vector3(148.90, -1049.15, 29.20),
        heading = 156.00,
      },
      Trays = {
        [1] = {coords = vector3(149.96, -1045.21, 28.35), heading = 160.87, rot = vector3(0, 0, 160.87), isSpawned = false, grabbed = false},
        [2] = {coords = vector3(150.91, -1046.47, 28.35), heading = 69.08, rot = vector3(0, 0, 69.08), isSpawned = false, grabbed = false},
        [3] = {coords = vector3(150.47, -1048.43, 28.35), heading = 118.00, rot = vector3(0, 0, 118.00), isSpawned = false, grabbed = false},
        [4] = {coords = vector3(147.87, -1047.62, 28.35), heading = 198.00, rot = vector3(0, 0, 198.00), isSpawned = false, grabbed = false},
        [5] = {coords = vector3(147.00, -1050.15, 28.35), heading = 337.70, rot = vector3(0, 0, 337.70), isSpawned = false, grabbed = false},
      },
      DepositBoxes = {
        [1] = {coords = vector3(150.8, -1050.07, 29.35), heading = 340.0, minZ = 28.8, maxZ = 29.55, BoxAmount = 0, LootedAmount = 0, type = 1},
        [2] = {coords = vector3(149.0, -1051.27, 29.35), heading = 250.0, minZ = 28.8, maxZ = 29.55, BoxAmount = 0, LootedAmount = 0, type = 2},
        [3] = {coords = vector3(146.61, -1048.52, 29.35), heading = 340.0, minZ = 28.8, maxZ = 29.55, BoxAmount = 0, LootedAmount = 0, type = 1},
      }
    },
    [2] = { --Pink Cage
      ['name'] = "Pink Cage",
      loc = vector4(312.56, -281.2, 54.16, 340.3),
      TellerDoors = {
        coords = vector3(310.00, -279.27, 54.16),
        heading = 248.46, minZ = 54.16, maxZ = 54.36
      },
      Cameras = {
        coords = vector3(319.73, -315.86, 50.8),
        heading = 250.0, minZ = 29.37, maxZ = 29.52,
        z1 = vector4(314.0, -280.96, 54.16, 160.0),
        z2 = vector4(310.44, -282.98, 54.17, 160.0),
      },
      ComputerCoords = {
        coords = vector3(315.424, -280.437, 54.38),
        heading = 338.96, minZ = 54.36, maxZ = 54.50,
      },
      Printer = {
        coords = vector3(316.83, -282.24, 54.16),
        heading = 339.0, minZ = 53.16, maxZ = 54.56,
      },
      PreVaultDoor = {
        coords = vector3(308.66, -281.57, 54.16),
        heading = 340.0, minZ = 54.36, maxZ = 54.76,
      },
      Safe = {
        coords = vector3(309.66, -284.35, 54.17),
        heading = 340.00, DoorHeading = 160.00,
        minZ = 53.77, maxZ = 54.57,
      },
      CardSwipe = {
        coords = vector3(311.69, -284.68, 54.17),
        heading = 251.00, minZ = 54.47, maxZ = 54.67,
      },
      VaultDoor = {
        coords = vector3(312.33, -282.727, 54.42),
        ClosedHeading = 249.846, OpenHeading = 150.00
      },
      Table = {
        coords = vector3(313.1, -287.50, 54.00),
        heading = 156.00,
      },
      Trays = {
        [1] = {coords = vector3(314.71, -283.75, 53.14), heading = 160.00, rot = vector3(0, 0, 160.8), isSpawned = false, grabbed = false},
        [2] = {coords = vector3(315.33, -284.81, 53.14), heading = 70.07, rot = vector3(0, 0, 70.07), isSpawned = false, grabbed = false},
        [3] = {coords = vector3(314.82, -286.76, 53.14), heading = 120.00, rot = vector3(0, 0, 120.00), isSpawned = false, grabbed = false},
        [4] = {coords = vector3(312.18, -285.80, 53.14), heading = 190.00, rot = vector3(0, 0, 190.00), isSpawned = false, grabbed = false},
        [5] = {coords = vector3(311.5, -288.50, 53.14), heading = 332.04, rot = vector3(0, 0, 332.04), isSpawned = false, grabbed = false},
      },
      DepositBoxes = {
        [1] = {coords = vector3(315.1, -288.4, 54.14), heading = 340.00, minZ = 53.59, maxZ = 54.34, BoxAmount = 0, LootedAmount = 0, type = 1},
        [2] = {coords = vector3(313.34, -289.6, 54.14), heading = 250.00, minZ = 53.59, maxZ = 54.34, BoxAmount = 0, LootedAmount = 0, type = 2},
        [3] = {coords = vector3(310.92, -286.84, 54.14), heading = 340.00, minZ = 53.59, maxZ = 54.34, BoxAmount = 0, LootedAmount = 0, type = 1},
      }
    },
    [3] = { --Hawick Ave
      ['name'] ="Hawick Avenue",
      loc = vector4(-352.6, -52.12, 49.04, 338.48),
      TellerDoors = {
        coords = vector3(-355.16, -50.13, 49.04),
        heading = 245.63, minZ = 49.04, maxZ = 49.24,
      },
      Cameras = {
        coords = vector3(-356.04, -50.42, 54.38),
        heading = 250.0, minZ = 29.37, maxZ = 29.52,
        z1 = vector4(-351.0, -52.0, 49.04, 160.0),
        z2 = vector4(-354.75, -53.85, 49.05, 160.0),
      },
      ComputerCoords = {
        coords = vector3(-349.71, -51.226, 49.252),
        heading = 336.16, minZ = 49.24, maxZ = 49.40,
      },
      Printer = {
        coords = vector3(-348.3, -52.97, 49.04),
        heading = 340.0, minZ = 48.04, maxZ = 49.44,
      },
      PreVaultDoor = {
        coords = vector3(-356.49, -52.48, 49.04),
        heading = 340.0, minZ = 49.24, maxZ = 49.64,
      },
      Safe = {
        coords = vector3(-355.35, -55.11, 49.05),
        heading = 340.0, DoorHeading = 160.00,
        minZ = 48.85, maxZ = 49.45,
      },
      CardSwipe = {
        coords = vector3(-353.4, -55.5, 49.05),
        heading = 250.00, minZ = 49.25, maxZ = 49.65
      },
      VaultDoor = {
        coords = vector3(-352.757, -53.56, 49.294),
        ClosedHeading = 240.859, OpenHeading = 150.00
      },
      Table = {
        coords = vector3(-351.79, -58.39, 48.86),
        heading = 156.00,
      },
      Trays = {
        [1] = {coords = vector3(-351.01, -54.16, 48.01), heading = 160.00, rot = vector3(0, 0, 160.0), isSpawned = false, grabbed = false},
        [2] = {coords = vector3(-349.73, -55.7, 48.01), heading = 65.07, rot = vector3(0, 0, 65.07), isSpawned = false, grabbed = false},
        [3] = {coords = vector3(-350.28, -57.54, 48.01), heading = 129.00, rot = vector3(0, 0, 129.00), isSpawned = false, grabbed = false},
        [4] = {coords = vector3(-352.96, -56.76, 48.01), heading = 189.00, rot = vector3(0, 0, 189.00), isSpawned = false, grabbed = false},
        [5] = {coords = vector3(-353.47, -59.41, 48.01), heading = 335.04, rot = vector3(0, 0, 335.04), isSpawned = false, grabbed = false},
      },
      DepositBoxes = {
        [1] = {coords = vector3(-349.89, -59.18, 49.01), heading = 340.00, minZ = 48.46, maxZ = 49.21, BoxAmount = 0, LootedAmount = 0, type = 1},
        [2] = {coords = vector3(-351.6, -60.4, 49.01), heading = 250.00, minZ = 48.46, maxZ = 49.21, BoxAmount = 0, LootedAmount = 0, type = 2},
        [3] = {coords = vector3(-354.07, -57.73, 49.01), heading = 340.00, minZ = 48.46, maxZ = 49.21, BoxAmount = 0, LootedAmount = 0, type = 1},
      }
    },
    [4] = { --Del Perro Ave Cage
      ['name'] = "Del Perro Avenue",
      loc = vector4(-1212.76, -333.69, 37.78, 23.21),
      TellerDoors = {
        coords = vector3(-1215.42, -333.92, 37.78),
        heading = 290.89, minZ = 37.78, maxZ = 37.98,
      },
      Cameras = {
        coords = vector3(-1217.15, -332.97, 42.09),
        heading = 116.0, minZ = 29.37, maxZ = 29.52,
        z1 = vector4(-1211.69, -332.50, 37.78, 206.86),
        z2 = vector4(-1212.51, -336.20, 37.79, 206.86),
      },
      ComputerCoords = {
        coords = vector3(-1210.84, -330.75, 37.99),
        heading = 32.08, minZ = 37.98, maxZ = 38.10,
      },
      Printer = {
        coords = vector3(-1208.6, -330.93, 37.78),
        heading = 295.0, minZ = 36.78, maxZ = 38.18,
      },
      PreVaultDoor = {
        coords = vector3(-1214.57, -336.44, 37.78),
        heading = 25.0, minZ = 37.98, maxZ = 38.38,
      },
      Safe = {
        coords = vector3(-1211.95, -337.58, 37.79),
        heading = 26.0, DoorHeading = 206.86,
        minZ = 37.39, maxZ = 38.19
      },
      CardSwipe = {
        coords = vector3(-1210.28, -336.37, 37.79),
        heading = 300.00, minZ = 37.99, maxZ = 38.39,
      },
      VaultDoor = {
        coords = vector3(-1211.277, -334.573, 38.039),
        ClosedHeading = 296.859, OpenHeading = 180.00
      },
      Table = {
        coords = vector3(-1207.13, -337.22, 37.62),
        heading = 207.00,
      },
      Trays = {
        [1] = {coords = vector3(-1209.3, -333.71, 36.76), heading = 209.80, rot = vector3(0, 0, 209.8), isSpawned = false, grabbed = false},
        [2] = {coords = vector3(-1207.69, -333.88, 36.76), heading = 115.84, rot = vector3(0, 0, 115.84), isSpawned = false, grabbed = false},
        [3] = {coords = vector3(-1206.65, -335.40, 36.76), heading = 189.85, rot = vector3(0, 0, 189.85), isSpawned = false, grabbed = false},
        [4] = {coords = vector3(-1209.15, -336.75, 36.76), heading = 235.99, rot = vector3(0, 0, 235.99), isSpawned = false, grabbed = false},
        [5] = {coords = vector3(-1207.94, -339.10, 36.76), heading = 360.00, rot = vector3(0, 0, 360.00), isSpawned = false, grabbed = false},
      },
      DepositBoxes = {
        [1] = {coords = vector3(-1205.21, -336.4, 37.76), heading = 28.00, minZ = 37.26, maxZ = 37.96, BoxAmount = 0, LootedAmount = 0, type = 1},
        [2] = {coords = vector3(-1205.57, -338.49, 37.76), heading = 118.00, minZ = 37.26, maxZ = 37.96, BoxAmount = 0, LootedAmount = 0, type = 2},
        [3] = {coords = vector3(-1209.14, -338.41, 37.76), heading = 28.00, minZ = 37.26, maxZ = 37.96, BoxAmount = 0, LootedAmount = 0, type = 1},
      }
    },
    [5] = { --Harmony Ave
      ['name'] = "Harmony",
      loc = vector4(1176.36, 2709.46, 38.09, 183.21),
      TellerDoors = {
        coords = vector3(1178.9, 2708.41, 38.09),
        heading = 96.57, minZ = 38.09, maxZ = 38.29,
      },
      Cameras = {
        coords = vector3(1158.21, 2714.17, 38.06),
        heading = 270.0, minZ = 29.37, maxZ = 29.52,
        z1 = vector4(1175.05, 2708.86, 38.09, 360.0),
        z2 = vector4(1177.44, 2711.82, 38.109, 360.0),
      },
      ComputerCoords = {
        coords = vector3(1173.45, 2707.65, 38.30),
        heading = 180.21, minZ = 38.29, maxZ = 38.40
      },
      Printer = {
        coords = vector3(1171.54, 2708.82, 38.09),
        heading = 0.0, minZ = 37.09, maxZ = 38.49,
      },
      PreVaultDoor = {
        coords = vector3(1179.39, 2711.04, 38.09),
        heading = 0.0, minZ = 38.29, maxZ = 38.69,
      },
      Safe = {
        coords = vector3(1177.52, 2713.22, 38.1),
        heading = 180.00, DoorHeading = 360.00,
        minZ = 37.7, maxZ = 38.5,
      },
      CardSwipe = {
        coords = vector3(1175.61, 2712.93, 38.09),
        heading = 89.00, minZ = 38.29, maxZ = 38.69,
      },
      VaultDoor = {
        coords = vector3(1175.56, 2710.86, 37.346),
        ClosedHeading = 89.999, OpenHeading = 0.00
      },
      Table = {
        coords = vector3(1173.08, 2715.14, 37.92),
        heading = 0.00,
      },
      Trays = {
        [1] = {coords = vector3(1173.43, 2711.0, 37.07), heading = 5.03, rot = vector3(0, 0, 5.03), isSpawned = false, grabbed = false},
        [2] = {coords = vector3(1172.08, 2711.94, 37.07), heading = 270.93, rot = vector3(0, 0, 270.93), isSpawned = false, grabbed = false},
        [3] = {coords = vector3(1171.82, 2713.83, 37.07), heading = 346.52, rot = vector3(0, 0, 346.52), isSpawned = false, grabbed = false},
        [4] = {coords = vector3(1174.61, 2713.84, 37.07), heading = 22.33, rot = vector3(0, 0, 22.33), isSpawned = false, grabbed = false},
        [5] = {coords = vector3(1174.53, 2716.48, 37.07), heading = 159.37, rot = vector3(0, 0, 159.37), isSpawned = false, grabbed = false},
      },
      DepositBoxes = {
        [1] = {coords = vector3(1171.02, 2715.25, 38.07), heading = 0.00, minZ = 37.52, maxZ = 38.27, BoxAmount = 0, LootedAmount = 0, type = 1},
        [2] = {coords = vector3(1172.24, 2716.92, 38.07), heading = 90.00, minZ = 37.52, maxZ = 38.27, BoxAmount = 0, LootedAmount = 0, type = 2},
        [3] = {coords = vector3(1175.4, 2715.25, 38.07), heading = 0.00, minZ = 37.52, maxZ = 38.27, BoxAmount = 0, LootedAmount = 0, type = 1},
      }
    },
    [6] = { -- Great Ocean
      ['name'] = "Great Ocean",
      loc = vector4(-2960.09, 481.14, 15.7, 241.51),
      TellerDoors = {
        coords = vector3(-2961.15, 478.95, 15.95),
        heading = 0.0, minZ = 15.70, maxZ = 16.00,
      },
      Cameras = {
        coords = vector3(-2948.03, 481.04, 15.76),
        heading = 270.0, minZ = 29.37, maxZ = 29.52,
        z1 = vector4(-2960.45, 482.89, 15.70, 265.0),
        z2 = vector4(-2957.79, 480.35, 15.71, 265.0),
      },
      ComputerCoords = {
        coords = vector3(-2961.65, 484.48, 15.93),
        heading = 90.21, minZ = 15.90, maxZ = 16.0
      },
      Printer = {
        coords = vector3(-2960.25, 486.34, 15.58),
        heading = 0.0, minZ = 15.09, maxZ = 16.49,
      },
      PreVaultDoor = {
        coords = vector3(-2958.52, 478.44, 16.07),
        heading = 0.0, minZ = 15.92, maxZ = 16.20,
      },
      Safe = {
        coords = vector3(-2956.28, 480.2, 15.81),
        heading = 87.542, DoorHeading = 280.00,
        minZ = 15.45, maxZ = 16.15,
      },
      CardSwipe = {
        coords = vector3(-2956.49, 482.15, 16.12),
        heading = 0.00, minZ = 16.05, maxZ = 16.20,
      },
      VaultDoor = {
        coords = vector3(-2958.53, 482.27, 15.83),
        ClosedHeading = 357.54, OpenHeading = 0.00
      },
      Table = {
        coords = vector3(-2954.20, 484.55, 15.52),
        heading = 268.00,
      },
      Trays = {
        [1] = {coords = vector3(-2958.40, 484.14, 14.7), heading = 275.03, isSpawned = false, grabbed = false},
        [2] = {coords = vector3(-2957.39, 485.82, 14.7), heading = 180.93, isSpawned = false, grabbed = false},
        [3] = {coords = vector3(-2955.45, 485.88, 14.7), heading = 256.52, isSpawned = false, grabbed = false},
        [4] = {coords = vector3(-2955.55, 483.07, 14.7), heading = 292.33, isSpawned = false, grabbed = false},
        [5] = {coords = vector3(-2952.87, 482.908, 14.7), heading = 69.37, isSpawned = false, grabbed = false},
      },
      DepositBoxes = {
        [1] = {coords = vector3(-2953.94, 486.67, 15.50), heading = 88.00, minZ = 15.10, maxZ = 15.90, BoxAmount = 0, LootedAmount = 0, type = 1},
        [2] = {coords = vector3(-2952.25, 485.30, 15.50), heading = 358.00, minZ = 15.10, maxZ = 15.90, BoxAmount = 0, LootedAmount = 0, type = 2},
        [3] = {coords = vector3(-2954.22, 482.09, 15.50), heading = 268.00, minZ = 15.10, maxZ = 15.90, BoxAmount = 0, LootedAmount = 0, type = 1},
      }
    },
  }
elseif Config.Framework.MLO == "Gabz" then
  Config.Banks = {
    [1] = { --Legion Square
      name = "Legion Square",
      loc = vector4(148.13, -1042.5, 29.37, 337.44),
      TellerDoors = {
        coords = vector3(145.73, -1040.82, 29.49),
        heading = 250.48, minZ = 29.45, maxZ = 29.60,
      },
      ComputerCoords = {
        coords = vector3(150.98, -1042.21, 29.6),
        heading = 339.3193, minZ = 29.50, maxZ = 29.65,
      },
      Printer = {
        coords = vector3(152.52, -1043.84, 29.37),
        heading = 334.0, minZ = 28.27, maxZ = 29.87,
      },
      PreVaultDoor = {
        coords = vector3(143.715, -1044.59, 29.72),
        heading = 250.0, minZ = 29.69, maxZ = 29.92,
      },
      Safe = {
        coords = vector3(145.15, -1045.36, 29.76),
        heading = 339.00, DoorHeading = 160.00,
        minZ = 27.5, maxZ = 30.80,
      },
      CardSwipe = {
        coords = vector3(146.74, -1046.29, 29.61),
        heading = 250.00, minZ = 29.3, maxZ = 29.87,
      },
      VaultDoor = {
        coords = vector3(148.00, -1044.36, 29.63),
        ClosedHeading = 249.846, OpenHeading = 150.00
      },
      Table = {
        coords = vector3(148.90, -1049.15, 29.20),
        heading = 156.00,
      },
      Trays = {
        [1] = {coords = vector3(149.96, -1045.21, 28.35), heading = 160.87, rot = vector3(0, 0, 160.87), isSpawned = false, grabbed = false},
        [2] = {coords = vector3(150.91, -1046.47, 28.35), heading = 69.08, rot = vector3(0, 0, 69.08), isSpawned = false, grabbed = false},
        [3] = {coords = vector3(150.47, -1048.43, 28.35), heading = 118.00, rot = vector3(0, 0, 118.00), isSpawned = false, grabbed = false},
        [4] = {coords = vector3(147.87, -1047.62, 28.35), heading = 198.00, rot = vector3(0, 0, 198.00), isSpawned = false, grabbed = false},
        [5] = {coords = vector3(147.00, -1050.15, 28.35), heading = 337.70, rot = vector3(0, 0, 337.70), isSpawned = false, grabbed = false},
      },
      DepositBoxes = {
        [1] = {coords = vector3(150.80, -1050.09, 29.56), heading = 340.0, minZ = 28.8, maxZ = 30.55, BoxAmount = 0, LootedAmount = 0, type = 1},
        [2] = {coords = vector3(149.0, -1051.37, 29.56), heading = 250.0, minZ = 28.8, maxZ = 30.55, BoxAmount = 0, LootedAmount = 0, type = 2},
        [3] = {coords = vector3(146.52, -1048.52, 29.56), heading = 159.5, minZ = 28.8, maxZ = 30.55, BoxAmount = 0, LootedAmount = 0, type = 1},
      }
    },
    [2] = { --Pink Cage
      ['name'] = "Pink Cage",
      loc = vector4(312.56, -281.2, 54.16, 340.3),
      TellerDoors = {
        coords = vector3(310.06, -279.22, 54.31),
        heading = 248.46, minZ = 54.16, maxZ = 54.36
      },
      ComputerCoords = {
        coords = vector3(315.3, -280.6, 54.4),
        heading = 338.96, minZ = 54.36, maxZ = 54.50,
      },
      Printer = {
        coords = vector3(316.83, -282.24, 54.16),
        heading = 339.0, minZ = 53.16, maxZ = 54.56,
      },
      PreVaultDoor = {
        coords = vector3(308.03, -282.98, 54.49),
        heading = 250.0, minZ = 54.36, maxZ = 54.76,
      },
      Safe = {
        coords = vector3(309.49, -283.73, 54.51),
        heading = 340.00, DoorHeading = 160.00,
        minZ = 53.60, maxZ = 55.57,
      },
      CardSwipe = {
        coords = vector3(311.08, -284.66, 54.39),
        heading = 251.00, minZ = 54.10, maxZ = 54.67,
      },
      VaultDoor = {
        coords = vector3(312.33, -282.727, 54.42),
        ClosedHeading = 249.846, OpenHeading = 150.00
      },
      Table = {
        coords = vector3(313.1, -287.50, 54.00),
        heading = 156.00,
      },
      Trays = {
        [1] = {coords = vector3(314.02, -283.4, 53.14), heading = 160.00, rot = vector3(0, 0, 160.8), isSpawned = false, grabbed = false},
        [2] = {coords = vector3(315.33, -284.81, 53.14), heading = 70.07, rot = vector3(0, 0, 70.07), isSpawned = false, grabbed = false},
        [3] = {coords = vector3(314.82, -286.76, 53.14), heading = 120.00, rot = vector3(0, 0, 120.00), isSpawned = false, grabbed = false},
        [4] = {coords = vector3(312.18, -285.80, 53.14), heading = 190.00, rot = vector3(0, 0, 190.00), isSpawned = false, grabbed = false},
        [5] = {coords = vector3(311.5, -288.50, 53.14), heading = 332.04, rot = vector3(0, 0, 332.04), isSpawned = false, grabbed = false},
      },
      DepositBoxes = {
        [1] = {coords = vector3(315.2, -288.4, 54.40), heading = 340.00, minZ = 53.59, maxZ = 55.34, BoxAmount = 0, LootedAmount = 0, type = 1},
        [2] = {coords = vector3(313.34, -289.75, 54.40), heading = 250.00, minZ = 53.59, maxZ = 55.34, BoxAmount = 0, LootedAmount = 0, type = 2},
        [3] = {coords = vector3(310.85, -286.84, 54.40), heading = 160.00, minZ = 53.59, maxZ = 55.34, BoxAmount = 0, LootedAmount = 0, type = 1},
      }
    },
    [3] = { --Hawick Ave
      ['name'] ="Hawick Avenue",
      loc = vector4(-352.6, -52.12, 49.04, 338.48),
      TellerDoors = {
        coords = vector3(-355.16, -50.13, 49.04),
        heading = 245.63, minZ = 49.04, maxZ = 49.24,
      },
      ComputerCoords = {
        coords = vector3(-349.81, -51.42, 49.25),
        heading = 338.16, minZ = 49.24, maxZ = 49.40,
      },
      Printer = {
        coords = vector3(-348.3, -52.97, 49.04),
        heading = 340.0, minZ = 48.04, maxZ = 49.44,
      },
      PreVaultDoor = {
        coords = vector3(-357.05, -53.87, 49.38),
        heading = 250.0, minZ = 49.40, maxZ = 49.60,
      },
      Safe = {
        coords = vector3(-355.6, -54.62, 48.42),
        heading = 340.0, DoorHeading = 160.00,
        minZ = 48.40, maxZ = 50.45,
      },
      CardSwipe = {
        coords = vector3(-353.99, -55.52, 49.29),
        heading = 250.00, minZ = 49.0, maxZ = 49.55
      },
      VaultDoor = {
        coords = vector3(-352.757, -53.56, 49.294),
        ClosedHeading = 240.859, OpenHeading = 150.00
      },
      Table = {
        coords = vector3(-351.79, -58.39, 48.86),
        heading = 156.00,
      },
      Trays = {
        [1] = {coords = vector3(-351.01, -54.16, 48.01), heading = 160.00, rot = vector3(0, 0, 160.0), isSpawned = false, grabbed = false},
        [2] = {coords = vector3(-349.73, -55.7, 48.01), heading = 65.07, rot = vector3(0, 0, 65.07), isSpawned = false, grabbed = false},
        [3] = {coords = vector3(-350.28, -57.54, 48.01), heading = 129.00, rot = vector3(0, 0, 129.00), isSpawned = false, grabbed = false},
        [4] = {coords = vector3(-352.96, -56.76, 48.01), heading = 189.00, rot = vector3(0, 0, 189.00), isSpawned = false, grabbed = false},
        [5] = {coords = vector3(-353.47, -59.41, 48.01), heading = 335.04, rot = vector3(0, 0, 335.04), isSpawned = false, grabbed = false},
      },
      DepositBoxes = {
        [1] = {coords = vector3(-349.80, -59.18, 49.26), heading = 340.00, minZ = 48.46, maxZ = 50.21, BoxAmount = 0, LootedAmount = 0, type = 1},
        [2] = {coords = vector3(-351.65, -60.55, 49.26), heading = 250.00, minZ = 48.46, maxZ = 50.21, BoxAmount = 0, LootedAmount = 0, type = 2},
        [3] = {coords = vector3(-354.20, -57.73, 49.26), heading = 160.00, minZ = 48.46, maxZ = 50.21, BoxAmount = 0, LootedAmount = 0, type = 1},
      }
    },
    [4] = { --Del Perro Ave Cage
      ['name'] = "Del Perro Avenue",
      loc = vector4(-1212.76, -333.69, 37.78, 23.21),
      TellerDoors = {
        coords = vector3(-1215.42, -333.92, 37.78),
        heading = 290.89, minZ = 37.78, maxZ = 37.98,
      },
      ComputerCoords = {
        coords = vector3(-1210.78, -330.96, 38.0),
        heading = 30.08, minZ = 37.98, maxZ = 38.10,
      },
      Printer = {
        coords = vector3(-1208.6, -330.93, 37.78),
        heading = 295.0, minZ = 36.78, maxZ = 38.18,
      },
      PreVaultDoor = {
        coords = vector3(-1214.02, -337.90, 38.11),
        heading = 295.0, minZ = 38.10, maxZ = 38.35,
      },
      Safe = {
        coords = vector3(-1212.47, -337.33, 38.16),
        heading = 26.0, DoorHeading = 206.86,
        minZ = 37.0, maxZ = 39.19
      },
      CardSwipe = {
        coords = vector3(-1210.74, -336.82, 38.02),
        heading = 300.00,
        minZ = 37.69, maxZ = 38.30,
      },
      VaultDoor = {
        coords = vector3(-1211.277, -334.573, 38.039),
        ClosedHeading = 296.859, OpenHeading = 180.00
      },
      Table = {
        coords = vector3(-1207.13, -337.22, 37.62),
        heading = 207.00,
      },
      Trays = {
        [1] = {coords = vector3(-1209.3, -333.71, 36.76), heading = 209.80, rot = vector3(0, 0, 209.8), isSpawned = false, grabbed = false},
        [2] = {coords = vector3(-1207.69, -333.88, 36.76), heading = 115.84, rot = vector3(0, 0, 115.84), isSpawned = false, grabbed = false},
        [3] = {coords = vector3(-1206.65, -335.40, 36.76), heading = 189.85, rot = vector3(0, 0, 189.85), isSpawned = false, grabbed = false},
        [4] = {coords = vector3(-1209.15, -336.75, 36.76), heading = 235.99, rot = vector3(0, 0, 235.99), isSpawned = false, grabbed = false},
        [5] = {coords = vector3(-1207.94, -339.10, 36.76), heading = 360.00, rot = vector3(0, 0, 360.00), isSpawned = false, grabbed = false},
      },
      DepositBoxes = {
        [1] = {coords = vector3(-1205.16, -336.4, 38.05), heading = 28.00, minZ = 37.26, maxZ = 38.96, BoxAmount = 0, LootedAmount = 0, type = 1},
        [2] = {coords = vector3(-1205.57, -338.69, 38.05), heading = 298.00, minZ = 37.26, maxZ = 38.96, BoxAmount = 0, LootedAmount = 0, type = 2},
        [3] = {coords = vector3(-1209.30, -338.41, 38.05), heading = 208.00, minZ = 37.26, maxZ = 38.96, BoxAmount = 0, LootedAmount = 0, type = 1},
      }
    },
    [5] = { --Harmony Ave
      ['name'] = "Harmony",
      loc = vector4(1176.36, 2709.46, 38.09, 183.21),
      TellerDoors = {
        coords = vector3(1178.91, 2708.4, 38.23),
        heading = 96.57, minZ = 38.09, maxZ = 38.29,
      },
      ComputerCoords = {
        coords = vector3(1173.5, 2707.85, 38.32),
        heading = 180.21, minZ = 38.29, maxZ = 38.40
      },
      Printer = {
        coords = vector3(1171.54, 2708.82, 38.09),
        heading = 0.0, minZ = 37.09, maxZ = 38.49,
      },
      PreVaultDoor = {
        coords = vector3(1179.52, 2712.55, 38.35),
        heading = 90.0, minZ = 38.4, maxZ = 38.55,
      },
      Safe = {
        coords = vector3(1177.94, 2712.78, 38.46),
        heading = 359.00, DoorHeading = 360.00,
        minZ = 37.0, maxZ = 39.5,
      },
      CardSwipe = {
        coords = vector3(1176.08, 2713.11, 38.34),
        heading = 90.00, minZ = 38.0, maxZ = 38.60,
      },
      VaultDoor = {
        coords = vector3(1175.56, 2710.86, 37.346),
        ClosedHeading = 89.999, OpenHeading = 0.00
      },
      Table = {
        coords = vector3(1173.08, 2715.14, 37.92),
        heading = 0.00,
      },
      Trays = {
        [1] = {coords = vector3(1173.43, 2711.0, 37.07), heading = 5.03, rot = vector3(0, 0, 5.03), isSpawned = false, grabbed = false},
        [2] = {coords = vector3(1172.08, 2711.94, 37.07), heading = 270.93, rot = vector3(0, 0, 270.93), isSpawned = false, grabbed = false},
        [3] = {coords = vector3(1171.82, 2713.83, 37.07), heading = 346.52, rot = vector3(0, 0, 346.52), isSpawned = false, grabbed = false},
        [4] = {coords = vector3(1174.61, 2713.84, 37.07), heading = 22.33, rot = vector3(0, 0, 22.33), isSpawned = false, grabbed = false},
        [5] = {coords = vector3(1174.53, 2716.48, 37.07), heading = 159.37, rot = vector3(0, 0, 159.37), isSpawned = false, grabbed = false},
      },
      DepositBoxes = {
        [1] = {coords = vector3(1170.90, 2715.25, 38.33), heading = 180.00, minZ = 37.52, maxZ = 39.27, BoxAmount = 0, LootedAmount = 0, type = 1},
        [2] = {coords = vector3(1172.24, 2717.1, 38.33), heading = 90.00, minZ = 37.52, maxZ = 39.27, BoxAmount = 0, LootedAmount = 0, type = 2},
        [3] = {coords = vector3(1175.55, 2715.25, 38.33), heading = 0.00, minZ = 37.52, maxZ = 39.27, BoxAmount = 0, LootedAmount = 0, type = 1},
      }
    },
    [6] = { -- Great Ocean
    ['name'] = "Great Ocean",
    loc = vector4(-2960.09, 481.14, 15.7, 241.51),
    TellerDoors = {
      coords = vector3(-2961.23, 479.01, 15.83),
      heading = 0.0, minZ = 15.70, maxZ = 16.0,
    },
    ComputerCoords = {
      coords = vector3(-2961.45, 484.43, 15.93),
      heading = 90.21, minZ = 15.90, maxZ = 16.0
    },
    Printer = {
      coords = vector3(-2960.17, 486.34, 15.58),
      heading = 0.0, minZ = 15.09, maxZ = 16.49,
    },
    PreVaultDoor = {
      coords = vector3(-2957.0, 478.23, 15.95),
      heading = 0.0, minZ = 15.92, maxZ = 16.20,
    },
    Safe = {
      coords = vector3(-2956.71, 479.92, 16.08),
      heading = 90.00, DoorHeading = 360.00,
      minZ = 15.3, maxZ = 17.0,
    },
    CardSwipe = {
      coords = vector3(-2956.31, 481.63, 15.95),
      heading = 0.00, minZ = 15.6, maxZ = 16.20,
    },
    VaultDoor = {
      coords = vector3(-2958.53, 482.27, 15.83),
      ClosedHeading = 357.54, OpenHeading = 0.00
    },
    Table = {
      coords = vector3(1173.08, 2715.14, 37.92),
      heading = 0.00,
    },
    Trays = {
      [1] = {coords = vector3(-2958.45, 484.14, 14.7), heading = 275.03, isSpawned = false, grabbed = false},
      [2] = {coords = vector3(-2957.41, 485.82, 14.7), heading = 180.93, isSpawned = false, grabbed = false},
      [3] = {coords = vector3(-2955.3, 485.95, 14.7), heading = 256.52, isSpawned = false, grabbed = false},
      [4] = {coords = vector3(-2955.42, 483.07, 14.7), heading = 292.33, isSpawned = false, grabbed = false},
      [5] = {coords = vector3(-2952.87, 482.88, 14.7), heading = 69.37, isSpawned = false, grabbed = false},
    },
    DepositBoxes = {
      [1] = {coords = vector3(-2953.94, 486.67, 15.93), heading = 90.00, minZ = 14.90, maxZ = 16.47, BoxAmount = 0, LootedAmount = 0, type = 1},
      [2] = {coords = vector3(-2952.16, 485.06, 15.93), heading = 0.00, minZ = 14.90, maxZ = 16.47, BoxAmount = 0, LootedAmount = 0, type = 2},
      [3] = {coords = vector3(-2954.22, 482.09, 15.93), heading = 270.00, minZ = 14.90, maxZ = 16.47, BoxAmount = 0, LootedAmount = 0, type = 1},
    }
    },
  }
end