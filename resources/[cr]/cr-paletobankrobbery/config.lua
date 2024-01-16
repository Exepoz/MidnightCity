Config = {}
-- Locales System Inspired by Code Design.
function Lcl(txt, ...) if CRPaletoLocales[txt] then return string.format(CRPaletoLocales[txt], ...) else print('Locale Error, Contact Server Admin. ('..txt..')') end end

Config.Framework = {
  MLO = "Gabz", --
  Framework = "QBCore",
  --PolyZone = "PolyZone", -- "PolyZone" | "oxlib"
  Interaction = {
    UseTarget = GetConvar('UseTarget', 'false') == 'true', -- Leave true if you are using qb-target. Set to false to disable targetting and enable DrawText for all interactions
    Target = "qb-target", -- "qb-target" ~ Requires "PolyZone" ~ | "oxtarget" ~ Requires "oxlib" ~
    ShowRequiredItems = true,
  },
  Doorlocks = "qb",
  --Framework Overrides (You can change specific framework related functions to ones from other scripts.)
  UseOxInv = false, -- For ESX and QBCore. Lets ESX users have item metadata for the Power Saw and the Saw Blade Pack. Otherwise they'd have infinite use.
  CircleMinigame = "ps-ui", -- "qb-lock" | "ps-ui" | "oxlib"
  Notifications = "qb", -- "okok" | "mythic" | "tnj" | "oxlib" | "qb" | "ESX" | "chat"
  ProgressUI = "", -- "oxlib" | "mythic" | "rprogress" (Custom Settings at the bottom) |  Otherwise leave blank ("") to use Framework Settings.
  DrawText = "", -- "oxlib" | "okok" | "psui" | Otherwise leave blank ("") to use Framework Settings.
}

Config.DevMode = false -- Set to 'true' if you are Testing the Resource
Config.Debug = false -- True = Debug Prints Enabled | false = Debug Prints Disabled
Config.DebugPoly = false -- true = Visible Polyzones Enabled | fase = Visible Polyzones Disabled
Config.Scoreboard = false -- true = qb-scoreboard Enabled | false = qb-scoreboard disabled
Config.Logs = false -- true = qb-logs Enabled | qb-logs Disabled
Config.InteractKey = "G" -- Key to press when interacting with things (Default : G | See Config.KeyList to know which string to change this value to.)
Config.ControlsDisabled = {36, 73, 322} -- Disable Controls when doing actions. Default : LEFT_CTRL, X, ESC


-- Server Restarts Specific Configurations
Config.TsunamiCooldown = true -- true = Bank Cooldown on Server Start Enabled | false =  Bank Cooldown on Server Start Disabled
Config.TsunamiCooldownTime = 45 -- Time Is In Minutes | Cooldown is GLOBAL

Config.Police = {
  CopsNeeded = {
    Heist1 = 5, -- Amount of Cops needed to be online for the first robbery to start (5)
    Heist2 = 5 -- Amount of Cops needed to be online for the second robbery to start (6)
  },
  PoliceJobs = {"police"}, -- Name of the police jobs | You can add as many jobs in the table.
  Dispatch = "ps-dispatch", -- "qb" = Default (qb-policejob) | "cd" = Code Design's Dispatch | "core" = Core Dispatch | "ps-dispatch" = Project Sloth Dispatch | "other" = custom (see client/cl_extras.lua)
  ServerSideDispatch = false, -- Set true if using a dispatch system which needs to call the dispatch server-side.
  TenCode = "10-90", -- 10-code used for the robery call (CD Dispatch + Core Dispatch)
  ['Intrusion'] = {TenCode = "911", Title = "Break & Entering", Message = "Suspect Intrusion in a restricted area at Paleto Bank"},
  ['Robbery'] = {TenCode = "10-90", Title = "Bank Robbery", Message = "Paleto Bank Robbery in progress!"},
}

Config.HeistOptions = {
  TimeToComplete = 15, -- Time in minutes to complete the heist from the first interaction with one of the steps.
  LockpickingSequenceDoorCallsCops = true, -- Sends a police call when a player lockpick's the door with the security sequences (For both Heist 1 and Heist 2)
  CooldownTime = 120, -- Cooldown time to reset everything in the bank (minutes)
  Heist1 = {
    CallCops = true, -- true = calls the cops when the Vault Timer starts | false = Doesn't call the cops when Vault Timer starts (Making the heist stealthy)
    CallTime = 45, -- Time to annswer the phone & give the security sequence
    LockVaultOnFailure = true, -- true = Locks Vault Door & ends the heist if players fails to give correct security sequence. | false = Only calls cops when wrong security sequence is given
    DoorTimer = 120, -- Time in seconds to open the vault door
  },
  Heist2 = {
    CallCops = true, -- true = calls the cops when the Vault Timer starts | false = Doesn't call the cops when Vault Timer starts (Making the heist stealthy)
    PhoneCall = true, -- If true, players receive call from group 6 and are required to have the security sequence (From heist 1)
    LockVaultOnFailure = true, -- true = Locks Vault Door & ends the heist if players fails to give correct security sequence. | false = Only calls cops when wrong security sequence is given
    DoorTimer = 120, -- Time in seconds to open the vault door
    SoloDataBase = false -- FOR TESTING ONLY. Makes the Database connection require only 1 person (You still need the paired code found in the console)
  },
}

Config.Items = {
  SitckyNote = {item = "stickynote", name = "sticky note"},
  PrinterDocument = {item = "printed_document", name = "Vault Codes"},
  Lockpick = {item = "lockpick", name = "lockpick"},
  VaultComputerHacking = {item = "crpaleto_usb", name = "Paleto Bank USB", uses = 3},
  OfficeComputerHacking = {item = "crpaleto_usb", name = "Paleto Bank USB", uses = 3},
  PowerSaw = {item = "powersaw", name = "Power Saw"},
  BrokenSaw = {item = "brokenpowersaw", name = "Broken Power Saw"},
  ManagerKey = {item = "crpaleto_managerkey", name = "Manager\'s Office Key"},
  OfficeKey = {item = "crpaleto_officekey", name = "Office Key"},
  Keycard = {item = "crpaleto_keycard", name = "Paleto Bank Keycard"},
  DirtyMoney = {item = "markedbills", name = "Marked Money"},
  GoldBar = {item = "goldbar", name = "gold bar"},
  Drill = {item = "drill", name = "drill"},
  Explosives = {item = "crpaleto_explosives", name = "Homemade Explosives"},
  MountedDrill = {item = "crpaleto_mounteddrill", name = "Mounted Drill"}
}

Config.Difficulties = {
  SequenceDoor = {
    RemoveLockpick = true, -- Sets if there
    LockpickRemovalChance = 100, -- Chance to remove the lockpick if enabled
    CircleAmount = {min = 5, max = 8}, -- Amount of circles for the lockpick minigame
    CircleMinigameTimeDifficulty = {min = 7, max = 15}, -- Difficulty for the Teller door lockpicking
    OxLibDifficulty = "medium", -- Oxlib difficulty for the teller door lockpicking
  },
  Heist1Hack = {
    Hack = "NumberColor", -- "NumberColor" | "VAR" | "Dimbo" | "mHacking"
    SuccesfulHackRemoveUSB = true, -- If the hack is successful, does the item gets 100% removed? If, false, has chance/uses to get removed
    RemovalType = "uses", -- If the hack is failed or above option is false, type of removal (Chance to lose the item or # of item uses)
    RemovalChance = 50, -- If chance selected, chance to remove the item on fail.
    NumberColor = {
      Script = 'nathan', -- jesper = Jespers's NoPixel Number Color Hack | nathan = nathan's fork which include hack configuration
      -- Configuration (If using Nathan's)
      TimeToType = 10, -- (If using Nathan's) Time in Seconds to remember the information shown
      Amount = 5, -- Amount of blocks shown on screen
      Repeats = 5, --Amount of correct answers needed to complete the hack
    },
    Dimbo = { -- Difficulty Settings For Dimbo PassHack
      Difficulty = 4 -- Chose Between (1-8) (The higher the difficulty, the more numbers have to be remembered)
    },
    Var = { -- Difficulty Settings For VAR-Hack
      Script = "psui", -- "psui" or "standalone"
      Blocks = 5, -- Blocks Needed to be found
      TimeToShow = 3 -- Time in seconds for the player to memorize the blocks
    },
    mHacking = {
      NumberAmount = 3, -- Amount of digit per "set" needed to be found
      TimeToHack = 10 -- Time in seconds to finish the hack
    }
  },
  PhoneCall = {
    TimeToAnswerThePhone = 30, -- Time in seconds to pickup the phone
    UIPosition = {
      Text = {scale = 0.8, x = 0.01, y = 0.6},
      Commands = {scale = 0.6, x = 0.01, y = 0.7}
    }
  },
  -- Heist 2
  CorridorDepositBox = {
    ProgressSpeedMultiplier = 2, -- How fast does the progress goes
    BladeHeatMultiplier = 3, -- How fast does the heat accumulates
    UIPosition = { -- Position for the UI
    Text = {scale = 0.8, x = 0.01, y = 0.6},
    Commands = {scale = 0.6, x = 0.01, y = 0.7}
    },
  },
  Heist2Hack = {
    Hack = "NumberColor", -- "NumberColor" | "VAR" | "Dimbo" | "mHacking"
    SuccesfulHackRemoveUSB = true, -- If the hack is successful, does the item gets 100% removed? If, false, has chance/uses to get removed
    RemovalType = "uses", -- If the hack is failed or above option is false, type of removal (Chance to lose the item or # of item uses)
    RemovalChance = 50, -- If chance selected, chance to remove the item on fail.

    NumberColor = {
      Script = 'nathan', -- jesper = Jespers's NoPixel Number Color Hack | nathan = nathan's fork which include hack configuration
      -- Configuration (If using Nathan's)
      TimeToType = 8, -- (If using Nathan's) Time in Seconds to remember the information shown
      Amount = 4, -- Amount of blocks shown on screen
      Repeats = 1, --Amount of correct answers needed to complete the hack
    },
    Dimbo = { -- Difficulty Settings For Dimbo PassHack
      Difficulty = 4 -- Chose Between (1-8) (The higher the difficulty, the more numbers have to be remembered)
    },
    Var = { -- Difficulty Settings For VAR-Hack
      Script = "psui", -- "psui" or "standalone"
      Blocks = 5, -- Blocks Needed to be found
      TimeToShow = 3 -- Time in seconds for the player to memorize the blocks
    },
    mHacking = {
      NumberAmount = 3, -- Amount of digit per "set" needed to be found
      TimeToHack = 10 -- Time in seconds to finish the hack
    }
  },
  DatabaseConnection = {
    TimeToPair = 80, -- Time for both people to complete their hack and connect to the databse
    TimedOutTime = 80 -- Time to enter code after getting access to the database
  },
  WallSafe = {
    TimeToDrill = 120 -- seconds
  },
  -- K4MB1 Only
  MetalGate = {
    Script = "MemoryGame", --MemoryGame | PSUI
    CorrectBlocks = 6, -- Thermite correct blocks
    IncorrectBlocks = 3, -- Wrong answers until losing
    TimeToLose = 10, -- Time to lose if not completed
    TimeToShow = 6, -- Time to look at the blocks
    GridSize = 8, -- PSUI Only (5-10)
    RemoveItemOnFail = true,
    TimeToExpload = 30
  },
  -- Vault
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

Config.Rewards = {
  Safe = {
    CleanMoney = {enabled = false, min = 5000, max = 15000}, -- Amount of Raw cash the player gets
    DirtyMoney = {enabled = true, bagAmount = {min = 1, max = 4}, moneyPerBag = {min = 7000, max = 10000}}, -- Amount of dirty money and the metadata if needed
    Items = {enabled = true, rolls = {min = 1, max = 3}, pool = { -- Items received (Rolls = amount of different items someone can get)
      [1] = {item = "diamond", amount = {Min = 3, Max = 7}, weight = 40},
      [2] = {item = "goldchain", amount = {Min = 5, Max = 8}, weight = 50},
      [3] = {item = "rolex", amount = {Min = 3, Max = 7}, weight = 60},
      [4] = {item = "money_orders", amount = {Min = 1, Max = 1}, weight = 8},
    }},
  },
  Heist1 = {
    Vault = {
      Trays = {
        TrayAmount = {min = 2, max = 4}, -- Amount of Trays that can spawn (K4MB1 Max = 5 | Gabz Max = 4)
        GoldChance = 40, -- Chance for the Tray to be gold bars.
        GoldAmount = {Min = 6, Max = 12}, -- Amount of Gold Bars per Trays
        MoneyBagAmount = {Min = 8, Max = 9}, -- Amount of Money Bags received per trays.
        MoneyWorth = {Min = 5000, Max = 6500}, -- Amount of Money Per Bags
        MoneyInBags = true, --If False, receives the entire amount directly in cash ('MoneyBagAmount' times 'MoneyWorth')
      },
      DepositBoxes = {
        BoxAmount = {min = 2, max = 3},
        ItemAmount = {min = 1, max = 3},
        EmptyChance = 20, -- % Chance of a "Box" being empty
        -- The config above is only used if you use the custom drilling. If you chose to use FieM-Drilling, you should up the MinAmount and MaxAmount, as players only receive 1 set of loot and not multiple.
        Loot = {
          [1] = {item = "diamond_ring", amount = {min = 1, max = 2}, weight = 50},
          [2] = {item = "rolex", amount = {min = 1, max = 2}, weight = 50},
          [3] = {item = "goldchain", amount = {min = 2, max = 3}, weight = 50},
          [4] = {item = "10kgoldchain", amount = {min = 2, max = 3}, weight = 25},
          [5] = {item = "diamond", amount = {min = 2, max = 3}, weight = 10},
        },
        SpecialLoot = '', -- Any item that can be considered rare or special loot
        SpecialLootChance = 5,
      },
      Table = { -- Only for K4MB1's MLO
        GoldChance = 25, -- Chance for the loot on the table to be gold
        BagAmount = {min = 6, max = 9}, -- Amount of Money Item received  from the table.
        GoldAmount = {min = 6, max = 9}, -- Amount of gold bars in the table gold pile.
        MoneyWorth = {min = 5000, max = 10000}, -- Worth of the money in each bags received from the table.
        MoneyInBags = true-- If False, receives the entire amount directly in cash ('MoneyBagAmount' times 'MoneyWorth')
      },
    }
  },
  Heist2 = {
    Vault = {
      Trays = {
        TrayAmount = {min = 1, max = 2}, -- Amount of Trays that can spawn (K4MB1 Max = 5 | Gabz Max = 4)
        GoldChance = 100, -- Chance for the Tray to be gold bars.
        GoldAmount = {Min = 13, Max = 20}, -- Amount of Gold Bars per Trays
        MoneyBagAmount = {Min = 1, Max = 2}, -- Amount of Money Bags received per trays.
        MoneyWorth = {Min = 2000, Max = 3000}, -- Amount of Money Per Bags
        MoneyInBags = true, --If False, receives the entire amount directly in cash ('MoneyBagAmount' times 'MoneyWorth')
      },
      DepositBoxes = {
        BoxAmount = {min = 4, max = 4},
        EmptyChance = 45, -- % Chance of a "Box" being empty
        -- The config above is only used if you use the custom drilling. If you chose to use FieM-Drilling, you should up the MinAmount and MaxAmount, as players only receive 1 set of loot and not multiple.
        Loot = {
          [1] = {item = "diamond_ring", amount = {min = 1, max = 2}, weight = 50},
          [2] = {item = "rolex", amount = {min = 1, max = 2}, weight = 50},
          [3] = {item = "goldchain", amount = {min = 2, max = 3}, weight = 50},
          [4] = {item = "10kgoldchain", amount = {min = 2, max = 3}, weight = 25},
          [5] = {item = "diamond", amount = {min = 2, max = 3}, weight = 10},
        },
        SpecialLoot = '',-- Any item that can be considered rare or special loot
        SpecialLootChance = 5,
      },
      Table = { -- Only for K4MB1's MLO
        GoldChance = 25, --Chance for the loot on the table to be gold
        BagAmount = {min = 3, max = 6}, -- Amount of Money Item received  from the table.
        GoldAmount = {min = 3, max = 6}, -- Amount of gold bars in the table gold pile.
        MoneyWorth = {min = 7000, max = 10000}, -- Worth of the money in each bags received from the table.
        MoneyInBags = true-- If False, receives the entire amount directly in cash ('MoneyBagAmount' times 'MoneyWorth')
      },
    },
    InnerVaultDepositBoxes = {
      BoxAmount = {min = 4, max = 4},
      EmptyChance = 45, -- % Chance of a "Box" being empty
      -- The config above is only used if you use the custom drilling. If you chose to use FieM-Drilling, you should up the MinAmount and MaxAmount, as players only receive 1 set of loot and not multiple.
      Loot = {
        [1] = {item = "diamond_ring", amount = {min = 1, max = 2}, weight = 50},
        [2] = {item = "rolex", amount = {min = 1, max = 2}, weight = 50},
        [3] = {item = "goldchain", amount = {min = 2, max = 3}, weight = 50},
        [4] = {item = "10kgoldchain", amount = {min = 2, max = 3}, weight = 25},
        [5] = {item = "diamond", amount = {min = 2, max = 3}, weight = 10},
      },
      SpecialLoot = '', -- Any item that can be considered rare or special loot
      SpecialLootChance = 5,
    },
  }
}

Config.EmptyBackID = 0 --Set this as the clothing ID corresponding to the ped having nothing on their back. Useful if a random bag appears on the player's back.

-- Options for custom progress bar if using RProgress
Config.RProgressUI = {
  Async = true,
  cancelKey = 178,        -- Custom cancel key
  x = 0.5,                -- Position on x-axis
  y = 0.5,                -- Position on y-axis
  Radius = 60,            -- Radius of the dial
  Stroke = 10,            -- Thickness of the progress dial
  Cap = 'butt',           -- or 'round'
  Padding = 0,            -- Padding between the progress dial and the background dial
  MaxAngle = 360,         -- Maximum sweep angle of the dial in degrees
  Rotation = 0,           -- 2D rotation of the dial in degrees
  Width = 300,            -- Width of bar in px if Type = 'linear'
  Height = 40,            -- Height of bar in px if Type = 'linear'
  ShowTimer = true,       -- Shows the timer countdown within the radial dial
  ShowProgress = false,   -- Shows the progress % within the radial dial
  Easing = "easeLinear",
  LabelPosition = "right",
  Color = "rgba(255, 255, 255, 1.0)",
  BGColor = "rgba(0, 0, 0, 0.4)",
  ZoneColor = "rgba(51, 105, 30, 1)",
}

if Config.Framework.MLO == "K4MB1" then
  -- You shouldn't touch anything in Config.Targets unless you understand what you are doing.
  Config.Targets = {
    VaultDoor = {coords = vector3(-105.27, 6473.13, 31.63), ClosedHeading = 45.0, OpenHeading = 150.0, hash = -1185205679},
    SecSeq = { coords = vector3(-109.60, 6468.37, 31.63), heading = 44.29, minZ = 31.65, maxZ = 31.85, Hash = -1184592117},
    VaultComputer = { coords = vector3(-106.38, 6470.34, 31.43), heading = 105.00, minZ = 31.45, maxZ = 31.55},
    VaultKeypad = { coords = vector3(-105.90, 6472.15, 31.85), heading = 45.00, minZ = 31.8, maxZ = 32.0, width = 0.4},
    OutsideKeypad = {coords = vector3(-95.48, 6473.01, 31.81), heading = 134.29, minZ = 31.80, maxZ = 32.1, Hash = 623406777},
    OfficeDoor = {[1] = { coords = vector3(-98.74, 6461.99, 31.65), heading = 45.00, minZ = 31.60, maxZ = 31.80}},
    Drill = {coords = vector3(-105.83, 6457.05, 31.63), w = 1.0, l = 1.0, heading = 192.12, minZ = 30.0, maxZ = 32.1, hash = 2947971326}, --vector3(-104.23, 6457.7, 31.95)
    CorridorDoor = {coords = vector3(-99.3, 6467.93, 31.67), heading = 44.29, minZ = 31.55, maxZ = 31.75},
    Gate = {coords = vector3(-105.89, 6460.92, 31.95), heading = 44.29, minZ = 31.80, maxZ = 32.0},
    ManagerDoor = {coords = vector3(-103.52, 6463.91, 31.69), heading = 44.29, minZ = 31.65, maxZ = 31.85, Hash = -147325430},
    Printer = { coords = vector3(-100.20, 6464.50, 30.68), heading = 135.00, minZ = 31.00, maxZ = 31.90},
    InnerVaultKeypad = { coords = vector3(-102.73, 6459.164, 32.22), heading = 135.00, minZ = 32.12, maxZ = 32.32},
    InnerGate = { coords = vector3(-105.95, 6460.996, 31.92), heading = 135.00, minZ = 31.82, maxZ = 32.05},
    OutDepo = {coords = vector3(-96.61, 6470.39, 32.23), heading = 223.00, minZ = 30.82, maxZ = 33.05},
    Table = {coords = vector3(-104.49, 6477.07, 31.48), heading = 315.00, minZ = 30.82, maxZ = 33.05},
    Binders = {
      [1] = {coords = vector3(-112.64, 6473.31, 31.8), heading = 295.00, minZ = 31.80, maxZ = 31.95, hash = -1883980157},
      [2] = {coords = vector3(-112.51, 6473.26, 32.15), heading = 225.00, minZ = 32.05, maxZ = 32.30, hash = -1883980157},
      [3] = {coords = vector3(-112.75, 6473.45, 32.15), heading = 225.00, minZ = 32.05, maxZ = 32.30, hash = -1883980157},
      [4] = {coords = vector3(-112.18, 6472.84, 32.47), heading = 225.00, minZ = 32.30, maxZ = 32.60, hash = -1883980157},
      [5] = {coords = vector3(-111.75, 6472.49, 31.80), heading = 235.00, minZ = 31.80, maxZ = 31.95, hash = -1883980157},
      [6] = {coords = vector3(-110.33, 6471.01, 31.88), heading = 225.00, minZ = 31.80, maxZ = 31.95, hash = -1883980157},
      [7] = {coords = vector3(-110.28, 6471.03, 32.14), heading = 235.00, minZ = 32.05, maxZ = 32.30, hash = -1883980157},
    },
    ManagerKey = {
      [1] = { coords = vector3(-94.23, 6461.98, 31.43), heading = 45.00},
      [2] = { coords = vector3(-95.35, 6463.15, 31.43), heading = 45.00},
      [3] = { coords = vector3(-95.26, 6464.12, 31.43), heading = 45.00},
      [4] = { coords = vector3(-92.61, 6464.28, 31.51), heading = 45.00},
      [5] = { coords = vector3(-94.46, 6466.14, 31.52), heading = 45.00},
      [6] = { coords = vector3(-96.78, 6465.72, 31.43), heading = 45.00},
      [7] = { coords = vector3(-98.48, 6466.17, 31.43), heading = 45.00},
      [8] = { coords = vector3(-97.51, 6465.21, 31.43), heading = 45.00},
    },
    Phones = {
      [1] = {coords = vector3(-105.51, 6469.62, 31.48), heading = 160.00, minZ = 31.45, maxZ = 31.55},
    },
    OfficeComputers = {
      [1] = {coords = vector3(-97.40, 6466.14, 31.42), heading = 138.00, minZ = 31.40, maxZ = 31.50},
      [2] = {coords = vector3(-94.32, 6463.09, 31.42), heading = 138.00, minZ = 31.40, maxZ = 31.50},
    },
    ThermiteDoors = {
      [1] = {coords = vector3(-105.84, 6472.62, 31.63), heading = 315.00, minZ = 31.73, maxZ = 31.88},
      [2] = {coords = vector3(-105.48, 6475.10, 31.99), heading = 225.00, minZ = 31.73, maxZ = 31.88},
    },
    Trays = {
      [1] = {coords = vector3(-107.51, 6474.04, 30.63), heading = 315.63, rot = vector3(0, 0, 315.63), isSpawned = false, grabbed = false},
      [2] = {coords = vector3(-107.57, 6475.58, 30.63), heading = 227.78, rot = vector3(0, 0, 227.78), isSpawned = false, grabbed = false},
      [3] = {coords = vector3(-106.50, 6477.34, 30.63), heading = 277.33, rot = vector3(0, 0, 277.33), isSpawned = false, grabbed = false},
      [4] = {coords = vector3(-104.77, 6479.20, 30.63), heading = 192.63, rot = vector3(0, 0, 192.63), isSpawned = false, grabbed = false},
      [5] = {coords = vector3(-102.27, 6476.71, 30.63), heading = 91.35, rot = vector3(0, 0, 91.35), isSpawned = false, grabbed = false},
      [6] = {coords = vector3(-104.06, 6474.92, 30.63), heading = 5.21, rot = vector3(0, 0, 5.21), isSpawned = false, grabbed = false},
    },
    DepositBoxes = {
      [1] = {coords = vector3(-106.13, 6478.81, 31.80), Plcoords = vector3(-105.7, 6478.31, 30.63), heading = 41.74, minZ = 31.0, maxZ = 33.0, BoxAmount = 0, LootedAmount = 0, type = 1},
      [2] = {coords = vector3(-103.04, 6478.36, 31.80), Plcoords = vector3(-103.37, 6477.96, 30.63), heading = 314.08, minZ = 31.0, maxZ = 33.0, BoxAmount = 0, LootedAmount = 0, type = 2},
      [3] = {coords = vector3(-102.64, 6475.39, 31.80), Plcoords = vector3(-103.04, 6475.8, 30.63), heading = 228.93, minZ = 31.0, maxZ = 33.0, BoxAmount = 0, LootedAmount = 0, type = 1},
    },
    InnerVaultBoxes = {
      [1] = {coords = vector3(-100.17, 6459.48, 31.95), Plcoords = vector3(-100.76, 6458.92, 31.63), heading = 311.74, minZ = 31.0, maxZ = 33.0, BoxAmount = 0, LootedAmount = 0, type = 1},
      [2] = {coords = vector3(-100.07, 6457.89, 31.98), Plcoords = vector3(-100.5, 6458.18, 31.63), heading = 224.08, minZ = 31.0, maxZ = 33.0, BoxAmount = 0, LootedAmount = 0, type = 2},
      [3] = {coords = vector3(-101.77, 6456.19, 31.97), Plcoords = vector3(-102.2, 6456.57, 31.63), heading = 224.93, minZ = 31.0, maxZ = 33.0, BoxAmount = 0, LootedAmount = 0, type = 1},
      [4] = {coords = vector3(-103.4, 6456.21, 31.96), Plcoords = vector3(-103.01, 6456.65, 31.63), heading = 134.93, minZ = 31.0, maxZ = 33.0, BoxAmount = 0, LootedAmount = 0, type = 1},
    },
  }
  Config.Doors = {
    SequenceDoor = 'CR_K4MB1Paleto-SequenceDoor',
    --Vault = 'CR_K4MB1Paleto-Vault',
    ManagerOffice = 'CR_K4MB1Paleto-ManagerOffice',
    OutsideKeypad = 'CR_K4MB1Paleto-OutsideKeypad',
    CorridorDoor = 'CR_K4MB1Paleto-Corridor',
    InnerVault = "CR_K4MB1Paleto-Vault",
    Prevault = 'CR_K4MB1Paleto-PreVault',
    GabzOffices = {
      [1] = "CR_K4MB1Paleto-Office-1",
      [2] = "CR_K4MB1Paleto-Office-2"
    }
  }
elseif Config.Framework.MLO == "Gabz" then
  Config.Targets = {
        --VaultDoor = {coords = vector3(-100.12, 6464.55, 31.88), ClosedHeading = 224.0, OpenHeading = 120.0, hash = -2050208642},
        SecSeq = { coords = vector3(-93.10, 6468.20, 31.75), heading = 44.29, minZ = 31.65, maxZ = 31.85, Hash = -147325430},
        VaultComputer = { coords = vector3(-106.41, 6473.8, 31.47), heading = 235.00, minZ = 31.45, maxZ = 31.55},
        VaultKeypad = { coords = vector3(-101.95, 6462.89, 32.12), heading = 45.00, minZ = 31.9, maxZ = 32.4, width = 0.4},
        OutDepo = {coords = vector3(-114.77, 6472.31, 31.63), heading = 225.00, minZ = 30.93, maxZ = 33.13},
        ManagerDoor = {coords = vector3(-103.79, 6474.75, 31.77), heading = 44.29, minZ = 31.65, maxZ = 31.85, Hash = -147325430},
        OutsideKeypad = {coords = vector3(-115.56, 6480.23, 31.93), heading = 44.29, minZ = 31.80, maxZ = 32.1, Hash = -147325430},
        InnerVaultKeypad = { coords = vector3(-104.78, 6479.36, 31.43), heading = 245.00, minZ = 31.30, maxZ = 31.55},
        CorridorDoor = {coords = vector3(-112.0, 6474.55, 31.77), heading = 44.29, minZ = 31.75, maxZ = 31.80},
        Drill = {coords = vector3(-105.04, 6480.91, 31.99), w = 0.7, l = 0.48, heading = 315.0, minZ = 31.70, maxZ = 32.3, hash = -1992154984}, --vector3(-104.23, 6457.7, 31.95)
        Printer = {coords = vector3(-104.30, 6457.40, 31.95) , heading = 222.0, minZ = 31.70, maxZ = 32.1}, --vector3(-104.23, 6457.7, 31.95)
        ManagerKey = {
          [1] = { coords = vector3(-98.27, 6469.67, 31.70), heading = 45.00},
          [2] = { coords = vector3(-95.2, 6466.87, 31.69), heading = 45.00},
          [3] = { coords = vector3(-96.9, 6467.15, 31.43), heading = 45.00},
          [4] = { coords = vector3(-106.43, 6461.42, 31.69), heading = 45.00},
          [5] = { coords = vector3(-103.99, 6458.01, 31.69), heading = 45.00},
          [6] = { coords = vector3(-104.28, 6460.21, 31.43), heading = 45.00},
        },
        OutsidePower = {
          [1] = { coords = vector3(-103.16, 6451.8, 31.56), heading = 225.00, minZ = 31.0, maxZ = 32.00},
          [2] = { coords = vector3(-109.45, 6483.29, 31.67), heading = 135.00, minZ = 31.3, maxZ = 32.15},
          [3] = { coords = vector3(-97.32, 6475.05, 31.52), heading = 45.00, minZ = 31.15, maxZ = 32.00},
        },
        OfficeDoor = {
          [1] = { coords = vector3(-99.8, 6468.85, 31.8), heading = 45.00, minZ = 31.70, maxZ = 31.90},
          [2] = { coords = vector3(-105.7, 6462.95, 31.8), heading = 45.00, minZ = 31.70, maxZ = 31.90},
        },
        OfficeComputers = {
          [1] = {coords = vector3(-103.81, 6460.40, 31.43), heading = 65.00, minZ = 31.40, maxZ = 31.50},
          [2] = {coords = vector3(-98.16, 6466.08, 31.43), heading = 65.00, minZ = 31.40, maxZ = 31.50},
        },
        Phones = {
          --[1] = {coords = vector3(-104.55, 6479.78, 31.48), heading = 245.00, minZ = 31.45, maxZ = 31.55, hash = 1146022803},
          [1] = {coords = vector3(-107.23, 6473.04, 31.48), heading = 215.00, minZ = 31.40, maxZ = 31.60, hash = 1146022803},
          [2] = {coords = vector3(-109.77, 6471.04, 31.58), heading = 125.00, minZ = 31.50, maxZ = 31.70, hash = 1146022803},
          [3] = {coords = vector3(-110.13, 6470.73, 31.58), heading = 320.00, minZ = 31.50, maxZ = 31.70, hash = 1146022803},
        },
        Binders = {
          [1] = {coords = vector3(-90.05, 6465.90, 30.85), heading = 225.00, minZ = 30.75, maxZ = 31.05, hash = 1573132612},
          [2] = {coords = vector3(-90.55, 6465.40, 30.85), heading = 225.00, minZ = 30.75, maxZ = 31.05, hash = -1524553731},
          [3] = {coords = vector3(-91.85, 6464.57, 30.94), heading = 225.00, minZ = 30.75, maxZ = 31.15, hash = 1573132612},
          [4] = {coords = vector3(-92.70, 6463.65, 30.94), heading = 225.00, minZ = 30.75, maxZ = 31.15, hash = -1524553731},
          [5] = {coords = vector3(-93.00, 6463.30, 30.94), heading = 225.00, minZ = 30.75, maxZ = 31.15, hash = 1573132612},
          [6] = {coords = vector3(-95.25, 6463.00, 30.94), heading = 315.00, minZ = 30.75, maxZ = 31.15, hash = 1573132612},
          [7] = {coords = vector3(-95.95, 6463.80, 30.94), heading = 315.00, minZ = 30.75, maxZ = 31.15, hash = -1524553731},
          [8] = {coords = vector3(-95.66, 6463.15, 31.81), heading = 315.00, minZ = 31.65, maxZ = 32.00, hash = 1573132612},
        },
        Trays = {
          [1] = {coords = vector3(-95.8, 6461.44, 30.63), heading = 86.15, rot = vector3(0, 0, 86.15), isSpawned = false, grabbed = false},
          [2] = {coords = vector3(-101.17, 6461.98, 30.63), heading = 276.25, rot = vector3(0, 0, 276.25), isSpawned = false, grabbed = false},
          [3] = {coords = vector3(-98.78, 6464.37, 30.63), heading = 184.7, rot = vector3(0, 0, 184.7), isSpawned = false, grabbed = false},
          [4] = {coords = vector3(-98.28, 6459.03, 30.63), heading = 358.64, rot = vector3(0, 0, 358.64), isSpawned = false, grabbed = false},
        },
        DepositBoxes = {
          [1] = {coords = vector3(-96.85, 6463.55, 31.83), Plcoords = vector3(-97.40, 6463.20, 30.63), heading = 314.71, minZ = 31.0, maxZ = 33.0, BoxAmount = 0, LootedAmount = 0, type = 1},
          [2] = {coords = vector3(-96.41, 6459.70, 31.83), Plcoords = vector3(-96.90, 6460.0, 30.63), heading = 222.68, minZ = 31.0, maxZ = 33.0, BoxAmount = 0, LootedAmount = 0, type = 2},
          [3] = {coords = vector3(-100.30, 6459.95, 31.83), Plcoords = vector3(-99.90, 6460.5, 30.63), heading = 134.82, minZ = 31.0, maxZ = 33.0, BoxAmount = 0, LootedAmount = 0, type = 1},
        },
        MiddleTray = {coords = vector3(-98.62, 6461.53, 31.63), grabbed = false}
  }
  Config.Doors = {
    SequenceDoor = 'CR_GabzPaleto-SequenceDoor',
    Vault = 'CR_GabzPaleto-Vault',
    ManagerOffice = 'CR_GabzPaleto-ManagerOffice',
    OutsideKeypad = 'CR_GabzPaleto-OutsideKeypad',
    CorridorDoor = 'CR_GabzPaleto-Corridor',

    Prevault = 'CR_Paleto-PreVault',
    GabzOffices = {
      [1] = "CR_GabzPaleto-Office-1",
      [2] = "CR_GabzPaleto-Office-2"
    }
  }
end

-- Config.Targets = {
--   K4MB1 = {
--     VaultDoor = {coords = vector3(-105.27, 6473.13, 31.63), ClosedHeading = 45.0, OpenHeading = 150.0, hash = -1185205679},
--     TellerDoor = { coords = vector3(-109.60, 6468.37, 31.63), heading = 44.29, minZ = 31.65, maxZ = 31.85, Hash = -1184592117},
--     VaultComputer = { coords = vector3(-106.38, 6470.34, 31.43), heading = 105.00, minZ = 31.45, maxZ = 31.55},
--     VaultKeypad = { coords = vector3(-105.90, 6472.15, 31.85), heading = 45.00, minZ = 31.8, maxZ = 32.0},
--     OfficeDoor = {
--       [1] = { coords = vector3(-98.74, 6461.99, 31.65), heading = 45.00, minZ = 31.60, maxZ = 31.80},
--     },
--     Printer = { coords = vector3(-100.20, 6464.50, 30.68), heading = 135.00, minZ = 31.00, maxZ = 31.90},
--     InnerVaultKeypad = { coords = vector3(-102.73, 6459.164, 32.22), heading = 135.00, minZ = 32.12, maxZ = 32.32},
--     InnerGate = { coords = vector3(-105.95, 6460.996, 31.92), heading = 135.00, minZ = 31.82, maxZ = 32.05},
--     OutDepo = {coords = vector3(-96.61, 6470.39, 32.23), heading = 223.00, minZ = 30.82, maxZ = 33.05},
--     Table = {coords = vector3(-104.49, 6477.07, 31.48), heading = 315.00, minZ = 30.82, maxZ = 33.05},
--     Binders = {
--       [1] = {coords = vector3(-112.64, 6473.31, 31.8), heading = 295.00, minZ = 31.80, maxZ = 31.95, hash = -1883980157},
--       [2] = {coords = vector3(-112.51, 6473.26, 32.15), heading = 225.00, minZ = 32.05, maxZ = 32.30, hash = -1883980157},
--       [3] = {coords = vector3(-112.75, 6473.45, 32.15), heading = 225.00, minZ = 32.05, maxZ = 32.30, hash = -1883980157},
--       [4] = {coords = vector3(-112.18, 6472.84, 32.47), heading = 225.00, minZ = 32.30, maxZ = 32.60, hash = -1883980157},
--       [5] = {coords = vector3(-111.75, 6472.49, 31.80), heading = 235.00, minZ = 31.80, maxZ = 31.95, hash = -1883980157},
--       [6] = {coords = vector3(-110.33, 6471.01, 31.88), heading = 225.00, minZ = 31.80, maxZ = 31.95, hash = -1883980157},
--       [7] = {coords = vector3(-110.28, 6471.03, 32.14), heading = 235.00, minZ = 32.05, maxZ = 32.30, hash = -1883980157},
--     },
--     Phones = {
--       [1] = {coords = vector3(-105.51, 6469.62, 31.48), heading = 160.00, minZ = 31.45, maxZ = 31.55},
--       [2] = {coords = vector3(-97.07, 6465.62, 31.46), heading = 165.00, minZ = 31.40, maxZ = 31.60},
--     },
--     OfficeComputers = {
--       [1] = {coords = vector3(-97.40, 6466.14, 31.42), heading = 228.00, minZ = 31.40, maxZ = 31.50},
--       [2] = {coords = vector3(-94.32, 6463.09, 31.42), heading = 228.00, minZ = 31.40, maxZ = 31.50},
--     },
--     ThermiteDoors = {
--       [1] = {coords = vector3(-105.84, 6472.62, 31.63), heading = 315.00, minZ = 31.73, maxZ = 31.88},
--       [2] = {coords = vector3(-105.48, 6475.10, 31.99), heading = 225.00, minZ = 31.73, maxZ = 31.88},
--     },
--     Trays = {
--       [1] = {coords = vector3(-107.51, 6474.04, 30.63), heading = 315.63, rot = vector3(0, 0, 315.63), isSpawned = false, grabbed = false},
--       [2] = {coords = vector3(-107.57, 6475.58, 30.63), heading = 227.78, rot = vector3(0, 0, 227.78), isSpawned = false, grabbed = false},
--       [3] = {coords = vector3(-106.50, 6477.34, 30.63), heading = 277.33, rot = vector3(0, 0, 277.33), isSpawned = false, grabbed = false},
--       [4] = {coords = vector3(-104.77, 6479.20, 30.63), heading = 192.63, rot = vector3(0, 0, 192.63), isSpawned = false, grabbed = false},
--       [5] = {coords = vector3(-102.27, 6476.71, 30.63), heading = 91.35, rot = vector3(0, 0, 91.35), isSpawned = false, grabbed = false},
--       [6] = {coords = vector3(-104.06, 6474.92, 30.63), heading = 5.21, rot = vector3(0, 0, 5.21), isSpawned = false, grabbed = false},
--     },
--     DepositBoxes = {
--       [1] = {coords = vector3(-106.13, 6478.81, 31.80), Plcoords = vector3(-105.7, 6478.31, 30.63), heading = 41.74, minZ = 31.0, maxZ = 33.0, BoxAmount = 0, LootedAmount = 0, type = 1},
--       [2] = {coords = vector3(-103.04, 6478.36, 31.80), Plcoords = vector3(-103.37, 6477.96, 30.63), heading = 314.08, minZ = 31.0, maxZ = 33.0, BoxAmount = 0, LootedAmount = 0, type = 2},
--       [3] = {coords = vector3(-102.64, 6475.39, 31.80), Plcoords = vector3(-103.04, 6475.8, 30.63), heading = 228.93, minZ = 31.0, maxZ = 33.0, BoxAmount = 0, LootedAmount = 0, type = 1},
--     }
--   },
--   Gabz = {--vector3(-103.79, 6474.75, 31.77)
--     --VaultDoor = {coords = vector3(-100.12, 6464.55, 31.88), ClosedHeading = 224.0, OpenHeading = 120.0, hash = -2050208642},
--     TellerDoor = { coords = vector3(-93.10, 6468.20, 31.75), heading = 44.29, minZ = 31.65, maxZ = 31.85, Hash = -147325430},
--     VaultComputer = { coords = vector3(-106.41, 6473.8, 31.47), heading = 232.00, minZ = 31.45, maxZ = 31.55},
--     VaultKeypad = { coords = vector3(-101.95, 6462.89, 32.12), heading = 45.00, minZ = 31.9, maxZ = 32.4, width = 0.4},
--     OutDepo = {coords = vector3(-114.77, 6472.31, 31.63), heading = 225.00, minZ = 30.93, maxZ = 33.13},
--     ManagerDoor =  {coords = vector3(-103.79, 6474.75, 31.77), heading = 44.29, minZ = 31.65, maxZ = 31.85, Hash = -147325430},
--     ManagerKey = {
--       [1] = { coords = vector3(-114.309, 6471.611, 31.69), heading = 45.00},
--       [2] = { coords = vector3(-112.37, 6473.330, 31.692), heading = 45.00},
--       [3] = { coords = vector3(-108.871, 6472.902, 31.534), heading = 45.00},
--       [4] = { coords = vector3(-109.5, 6476.01, 31.69), heading = 45.00},
--       [5] = { coords = vector3(-109.89, 6470.58, 31.53), heading = 45.00},
--       [6] = { coords = vector3(-98.27, 6469.67, 31.70), heading = 45.00},
--       [7] = { coords = vector3(-95.2, 6466.87, 31.69), heading = 45.00},
--       [8] = { coords = vector3(-96.9, 6467.15, 31.43), heading = 45.00},
--       [9] = { coords = vector3(-106.43, 6461.42, 31.69), heading = 45.00},
--       [10] = { coords = vector3(-103.99, 6458.01, 31.69), heading = 45.00},
--       [11] = { coords = vector3(-104.28, 6460.21, 31.43), heading = 45.00},
--       [12] = { coords = vector3(-91.33, 6465.45, 31.43), heading = 45.00},
--       [13] = { coords = vector3(-95.73, 6463.77, 31.43), heading = 45.00},
--       [14] = { coords = vector3(-93.31, 6463.49, 31.43), heading = 45.00},
--     },
--     OutsidePower = {
--       [1] = { coords = vector3(-103.16, 6451.8, 31.56), heading = 225.00, minZ = 31.0, maxZ = 32.00},
--       [2] = { coords = vector3(-109.45, 6483.29, 31.67), heading = 135.00, minZ = 31.3, maxZ = 32.15},
--       [3] = { coords = vector3(-97.32, 6475.05, 31.52), heading = 45.00, minZ = 31.15, maxZ = 32.00},
--     },
--     OfficeDoor = {
--       [1] = { coords = vector3(-105.7, 6462.95, 31.8), heading = 45.00, minZ = 31.70, maxZ = 31.90},
--       [2] = { coords = vector3(-99.8, 6468.85, 31.8), heading = 45.00, minZ = 31.70, maxZ = 31.90},
--     },
--     OfficeComputers = {
--       [1] = {coords = vector3(-103.81, 6460.40, 31.43), heading = 65.00, minZ = 31.40, maxZ = 31.50},
--       [2] = {coords = vector3(-98.16, 6466.08, 31.43), heading = 65.00, minZ = 31.40, maxZ = 31.50},
--     },
--     Phones = {
--       [1] = {coords = vector3(-104.55, 6479.78, 31.48), heading = 245.00, minZ = 31.45, maxZ = 31.55, hash = 1146022803},
--       [2] = {coords = vector3(-107.23, 6473.04, 34.48), heading = 215.00, minZ = 31.40, maxZ = 31.60, hash = 1146022803},
--       [3] = {coords = vector3(-109.77, 6471.04, 31.58), heading = 125.00, minZ = 31.50, maxZ = 31.70, hash = 1146022803},
--       [4] = {coords = vector3(-110.13, 6470.73, 31.58), heading = 320.00, minZ = 31.50, maxZ = 31.70, hash = 1146022803},
--     },
--     Binders = {
--       [1] = {coords = vector3(-90.05, 6465.90, 30.85), heading = 225.00, minZ = 30.75, maxZ = 31.05, hash = 1573132612},
--       [2] = {coords = vector3(-90.55, 6465.40, 30.85), heading = 225.00, minZ = 30.75, maxZ = 31.05, hash = -1524553731},
--       [3] = {coords = vector3(-91.85, 6464.57, 30.94), heading = 225.00, minZ = 30.75, maxZ = 31.15, hash = 1573132612},
--       [4] = {coords = vector3(-92.70, 6463.65, 30.94), heading = 225.00, minZ = 30.75, maxZ = 31.15, hash = -1524553731},
--       [5] = {coords = vector3(-93.00, 6463.30, 30.94), heading = 225.00, minZ = 30.75, maxZ = 31.15, hash = 1573132612},
--       [6] = {coords = vector3(-95.25, 6463.00, 30.94), heading = 315.00, minZ = 30.75, maxZ = 31.15, hash = 1573132612},
--       [7] = {coords = vector3(-95.95, 6463.80, 30.94), heading = 315.00, minZ = 30.75, maxZ = 31.15, hash = -1524553731},
--       [8] = {coords = vector3(-95.66, 6463.15, 31.81), heading = 315.00, minZ = 31.65, maxZ = 32.00, hash = 1573132612},
--     },
--     Trays = {
--       [1] = {coords = vector3(-95.8, 6461.44, 30.63), heading = 86.15, rot = vector3(0, 0, 86.15), isSpawned = false, grabbed = false},
--       [2] = {coords = vector3(-101.17, 6461.98, 30.63), heading = 276.25, rot = vector3(0, 0, 276.25), isSpawned = false, grabbed = false},
--       [3] = {coords = vector3(-98.78, 6464.37, 30.63), heading = 184.7, rot = vector3(0, 0, 184.7), isSpawned = false, grabbed = false},
--       [4] = {coords = vector3(-98.28, 6459.03, 30.63), heading = 358.64, rot = vector3(0, 0, 358.64), isSpawned = false, grabbed = false},
--     },
--     DepositBoxes = {
--       [1] = {coords = vector3(-96.9, 6463.50, 31.63), Plcoords = vector3(-97.40, 6463.20, 30.63), heading = 314.71, minZ = 31.0, maxZ = 33.0, BoxAmount = 0, LootedAmount = 0, type = 1},
--       [2] = {coords = vector3(-96.41, 6459.70, 31.63), Plcoords = vector3(-97.10, 6460.2, 30.63), heading = 222.68, minZ = 31.0, maxZ = 33.0, BoxAmount = 0, LootedAmount = 0, type = 2},
--       [3] = {coords = vector3(-100.27, 6460.0, 31.63), Plcoords = vector3(-99.90, 6460.5, 30.63), heading = 129.82, minZ = 31.0, maxZ = 33.0, BoxAmount = 0, LootedAmount = 0, type = 1},
--     }
--   }
-- }

Config.KeyList = { -- List of usable keys
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
