CRPaletoLocales = {
    ['PaletoTitle'] = "Paleto Bank Robbery", -- okok Notification Title
    ['doclabel'] = "Door Code :", -- Label for the Printed Document
    ['stickynotelabelsecurity'] = "Security Sequence : %s", -- Label for the sticky note with the Security answer code
    ['stickynotelabelvault'] = "Vault Code : %s", -- Label for the sticky note with the vault code

    ['debug_loadingbank'] = 'Loading Paleto Bank...', -- When Loading Bank Settings on Player Loaded
    ['debug_targetsloaded'] = 'Paleto Bank Targets Loaded...', -- When All Targets Succesfully Loaded
    ['debug_startlockpick'] = 'Lockpicking Door... (Project Sloth UI : %s)', -- When Lockpicking Door (%s -> true/false if using PS-UI)
    ['debug_unlockdoor'] = "Unlocking door %s", -- When unlocking a door. (%s -> Door Name)
    ['debug_startinghack'] = 'Starting Hacking Sequence (%s)', -- When Starting Hacking Sequence (%s -> Hacking Game Name Configured)
    ['debug_hackconfigerror'] = 'Bank Hack Configuration Error, please advise your Server\'s Staff Team', -- When there is an error in the hacking configuration
    ['debug_printingcodes'] = "Hack Success, Printing Codes & Activating Printer Target", -- When Succesfully Completing the Hack
    ['debug_generatingloot'] = 'Generating Bank Loot (Paleto Bank)', -- When bank loot gets generated (%s -> Bank Name)
    ['debug_generatingtable'] = "Table : %s", -- Type of loot on the table (%s -> gold/cash)
    ['debug_generatingtray'] = "Tray #%s | Type : %s", -- Tray Loot Info (first %s -> Tray #, second %s -> gold/cash)
    ['debug_generatingwall'] = "Wall #%s | Boxes : %s", -- Deposit Boxes Info (first %s -> Wall #, second %s -> Amount of boxes/loot rolls)
    ['debug_trayspawnerror'] = "Error Setting Up Tray Targets. Entity %s does not exist.", -- Debug if tray spawning doesnt work. (%s --> Entity #)
    ['debug_createtraytarget'] = "Creating Target on Tray #%s. Tray Location : %s", -- When creating a target for trays
    ['debug_cooldownerror'] = "Cooldown Configuration not setup properly.", -- When the Cooldown Config is not setup properly
    ['debug_resetbanks'] = 'Resetting Banks...', -- When Banks gets Reset
    ['debug_standalonefunction'] = "Standalone Function Implementation Needed",
    ['debug_BankActive'] = "Paleto Bank Active For %s minutes.",
    ['debug_BankInactive'] = "Bank Now Inactive, Starting Cooldown.", -- When the bank gets on Cooldown
    ['debug_SomethingWrong'] = "Oops, something went wrong...",
    ['debug_DoorConfigError'] = "Door Configuration Error, please advise Staff Team.",


    ['notif_EnterTellerOffice'] = "You\'ve broken into the teller office...", -- When a player breaks into the teller office
    ["notif_MissingSpecificItem"] = "You need a % do do this...", -- When the player is missing a specific item
    ["notif_MissingItem"] = "You don't have the tool do this", -- When player is missing a specific item (%s = Item Name)
    ["notif_LockpickFailed"] = "You failed to unlock the door", -- When a player fails to breaks into the teller office
    ["notif_USBInserted"] = "You insert the usb in the computer", -- When a player enters the usb to hack the computer
    ["notif_CodesFound"] = "You\'ve found security codes in the files!", -- When the computer finds the codes
    ["notif_SecurityBypass"] = "You\'ve bypassed the security system! Writing Down Vault Code...", -- When the player succesfuly hack the system
    ["notif_SecurityBypassFailed"] = "You\'ve failed to bypass the security system!", -- When the player fails to hack the system
    ['notif_SafeTick'] = "You hear a small noise inside the safe", -- When the safe "ticks"
    ['notif_SafeCrackFailed'] = "You messed up the combination!", -- When a player fails to open the safe
    ["notif_ReadingCard"] = "Reading Security Card Details...", -- When a player swipes the fleeca bank card
    ["notif_HumanInputRequired"] = "Vault Security Code Required", -- When a player needs to input the vault codes
    ["notif_OpenningVaultDoor"] = "Security Timelock Active. The Vault Door Will Open In %s seconds(s).", -- When the player enters the vault code (%s -> Time (in minutes))
    ["notif_VaultHalfTime"] = "The Vault Door will open in %s seconds", -- When the vault door is at half-time (to open) (%s -> Time (in minutes))
    ["notif_VaultDoorOpenned"] = "Security Timelock Over. Oppening Vault Door.", -- When the vault door opens
    ["notif_GrabbedLootMoney"] = "You found $ %s !", -- When Player Finds money (not in bags) (%s -> Amount of Money Received)
    ["notif_GrabbedLootItem"] = "You found %s %ss !", -- When Player Finds Items (money or item) (first %s -> Amount of Items received, second %s -> Item Name)
    ["notif_DrillBroke"] = "The Drill Broke!", -- When the drill breaks
    ['notif_DrillOverHeat'] = "The Drill bit is too hot!",
    ["notif_DepositBoxEmpty"] = "This safety box was empty!", -- When a safety box is empty
    ["notif_EmptyWall"] = "You\'ve looked through all of the boxes on that wall.", -- When a safety box wall is empty
    ["notif_BoxLockBroke"] = "You broke this security box\'s locks!", -- When a player breaks a safety box lock
    ["notif_CooldownMessage"] = "The Bank is on Lockdown!", -- When the bank cooldown is active
    ["notif_NotEnoughCops"] = "Not enough cops around right now!", -- Not Enough Cops
    ['notif_NothingImportant'] = "You don't find anything important here.",
    ['notif_FoundSticky'] = "You found a sticky note with a code on it.",
    ['notif_VaultCodeSuccess'] = "Code Accepted",
    ['notif_PhoneRinging'] = "The phone is ringing.. Maybe you should answer it?",
    ['notif_GroupeSixCall'] = "Hello! this is Groupe Six calling about an unscheduled vault oppening. Can we have your security key code please?",
    ['notif_GroupeSixWaiting'] = "Hello? We need your Security Code",
    ['notif_GroupeSixCallingCops'] = "Failed to Answer, we're putting the bank on lockdown.",
    ['notif_GroupeSixCallingCops2'] = "This is not the correct security code, we're putting the bank on lockdown.",
    ['notif_GroupeSixWrongCode'] = "I\'m sorry, can you say that again?",
    ['notif_GroupeSixCorrectCode'] = "Correct! Authorizing Vault Oppening. The door will open in %s seconds",
    ["notif_ThermiteFailed"] = "You failed to arm the device.", -- When failing to arm the thermite or vault bomb
    ["notif_AlreadyDone"] = "Somebody did this already.", -- When trying to perform an action already done by someone
    ['notif_SawBladeBroke'] = "The Saw Blade overheated and broke!",
    ['notif_MissingKey'] = "You don\'t have the key to this door...",
    ['notif_PrintingCodes'] = "Printing Vault Codes",
    ['notif_CantDoThat'] = "You can\'t do this right now",
    ['notif_timerActive'] = "There is already a vault door timer active right now, please wait until it is done.",
    ['notif_CombinationUnkown'] = "You don't know the combination!",

    ['phone_Prompt'] = "Groupe Six needs the Bank's Security Code, what do you do?",
    ['phone_GiveCode'] = "Give the code",
    ['phone_HangUp'] = "Hang Up",

    ['SawUI_Saw'] = "Break Boxes", -- M1 "Saw" Action
    ['SawUI_Heat'] = "Blade Heat", -- Blade Heat

    ['DrillingUI_Drill'] = "Drill", -- M1 "Drill" action
    ['DrillingUI_Stop'] = "Stop", -- G "Stop" action
    ['DrillingUI_Progress'] = "Progress", -- Progress
    ['DrillingUI_Depth'] = "Depth", -- Blade Heat
    ['DrillingUI_Hold'] = "Hold Position", -- When the player hit the sweetspot and can get bonus loot.
    ['DrillingUI_TooDeep'] = "Too Deep", -- When the player hit the sweetspot and can get bonus loot.

    ['input_CodeTitle'] = "Paleto Bank Security Code",
    ['input_GiveCode'] = "Give Code",
    ['input_Code'] = "Code",

    ['progbar_lookingforcodes'] = 'Looking for Codes...', -- When looking through the computer
    ['progbar_searching'] = "Searching Through Documents...",
    ['progbar_printingcodes'] = 'Printing Codes...', -- When printing door codes
    ['progbar_lockpicking'] = 'Lockpicking...', -- When lockpicking the teller door
    ['progbar_insertingusb'] = 'Inserting USB Device...', -- When inserting USB in the computer
    ['progbar_grabbing'] = 'Grabbing..', -- When grabbing items
    ['progbar_swipingcard'] = 'Swiping Card...', -- When swiping the security card
    ['progbar_readingdetails'] = 'Reading Card Details...', -- When reading security card details
    ['progbar_LoadingDatabase'] = "Bank Security Database...",
    ['progbar_DismountingDrill'] = "Dismounting Drill...",

    ['hack_Verifying'] = "Verifying",
    ['hack_WaitForPaired'] = "Waiting For Paired User",
    ['hack_ConnectionTimedOut'] = "Connection Timed Out",
    ['hack_ConnectionEstablished'] = "Connection Established",
    ['hack_Header'] = "Security Database\nPaired User Sequence : %s",
    ['hack_InputSequence'] = "Input Own Sequence",
    ['hack_KeyboardTitle'] = "Personnal Security Sequence",
    ['hack_AccessGranted'] = "Access Granted.",
    ['hack_AccessDenied'] = "Access Denied.",

    ['target_TellerDoor'] = "Lockpick", -- Lockpicking Target
    ['target_UnlockDoor'] = "Unlock Door",
    ['target_VaultComputer'] = "Hack System", -- Hack Target
    ['target_Printers'] = "Take Document", -- Printer Target
    ['target_Search'] = "Search",
    ['target_AnswerPhone'] = "Answer Phone",
    ['target_VaultKeypad'] = "Enter Code", -- PreVault Door Target
    ['target_AttemptSafe'] = "Attempt Combination", -- Crack Safe Target
    ['target_LootSafe'] = "Loot Safe", -- Loot Safe Target
    ['target_VaultCards'] = "Insert Keycard", -- Slide Card Target
    ['target_DepositBoxes'] = "Drill Deposit Boxes", -- Drill Target
    ['target_GrabLoot'] = "Grab Loot", -- Grab Loot Target
    ['target_Thermite'] = "Burn",
    ['target_BreakBoxes'] = "Break Deposit Boxes",
    ['target_GrabKeys'] = "Grab Keys",
    ['target_InstallDrill'] = "Install Drill",
    ['target_DismountDrill'] = "Dismount Drill",
    ['target_GrabCodes'] = "Grab Codes",
    ['target_BombDoor'] = "Attach Explosives",

    ['logs_robberystarted'] = '%s Has started the Fleeca Bank Robbery at %s', -- After Successful Hack (first %s -> Player Name, second %s -> Bank Name)
    ['logs_vaultoppened'] = "%s Has Oppened the Main Vault", -- After Opening the Vault (%s -> Player Name)
    ['logs_safelooted'] = "Safe Looted", -- Title when Looting Safe
    ['logs_loottitle'] = "Loot Received", -- Title when Looting others
    ['logs_player'] = "Player :", -- Player
    ['logs_found'] = "Found :", -- Found
    ['logs_qty'] = "Quantity :", -- Quantity
    ['logs_worth'] = "Worth :",
    ['logs_BankStarted'] = "Someone has started the Paleto Bank Robbery!",
    ['logs_TooFarExploit'] = "%s (ID : %s) tried to trigger event [%s] but is too far! (Distance : %s) They might be exploiting!", -- Exploit Check (1st s = steam name, 2nd = server id, 3rd = event triggered, 4th = distance from actual trigger)
}