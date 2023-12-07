CRFleecaLocales = {
    ['FleecaTitle'] = "Fleeca Bank Robbery", -- okok Notification Title
    ['doclabel'] = "Door Code :", -- Label for the Printed Document
    ['stickynotelabel'] = "Vault Code :", -- Label for the sticky note with the vault code

    ['debug_loadingbanks'] = 'Loading Fleeca Banks...', -- When Loading Bank Settings on Player Loaded
    ['debug_targetsloaded'] = 'Fleeca Bank Targets Loaded...', -- When All Targets Succesfully Loaded
    --['debug_startlockpick'] = 'Lockpicking Door... (Project Sloth UI : %s)', -- When Lockpicking Door (%s -> true/false if using PS-UI)
    ['debug_unlockdoor'] = "Unlocking door %s", -- When unlocking a door. (%s -> Door Name)
    ['debug_startinghack'] = 'Starting Hacking Sequence (%s)', -- When Starting Hacking Sequence (%s -> Hacking Game Name Configured)
    ['debug_hackconfigerror'] = 'Bank Hack Configuration Error, please advise your Server\'s Staff Team', -- When there is an error in the hacking configuration
    ['debug_printingcodes'] = "Hack Success, Printing Codes & Activating Printer Target", -- When Succesfully Completing the Hack
    ['debug_generatingloot'] = 'Generating Bank Loot (%s)', -- When bank loot gets generated (%s -> Bank Name)
    ['debug_generatingtable'] = "Table : %s", -- Type of loot on the table (%s -> gold/cash)
    ['debug_generatingtray'] = "Tray #%s | Type : %s", -- Tray Loot Info (first %s -> Tray #, second %s -> gold/cash)
    ['debug_generatingwall'] = "Wall #%s | Boxes : %s", -- Deposit Boxes Info (first %s -> Wall #, second %s -> Amount of boxes/loot rolls)
    ['debug_trayspawnerror'] = "Error Setting Up Tray Targets. Entity %s does not exist.", -- Debug if tray spawning doesnt work. (%s --> Entity #)
    ['debug_createtraytarget'] = "Creating Target on Tray #%s. Tray Location : %s", -- When creating a target for trays
    ['debug_cooldownerror'] = "Cooldown Configuration not setup properly.", -- When the Cooldown Config is not setup properly
    ['debug_resetbanks'] = 'Resetting Banks...', -- When Banks gets Reset
    ['debug_BankActive'] = "Bank Active For 10 minutes : %s", -- When some hits the bank
    ['debug_BankInactive'] = "Bank Now Inactive, Starting Cooldown.", -- When the bank gets on Cooldown

    ['EnterTellerOffice'] = "You\'ve broken into the teller office...", -- When a player breaks into the teller office
    ["MissingItem"] = "You are missing something", -- When the player is missing an item needed
    ["MissingSpecificItem"] = "You need a % do do this...", -- When the player is missing a specific item
    ["LockpickFailed"] = "You failed to unlock the door", -- When a player fails to breaks into the teller office
    ["USBInserted"] = "You insert the usb in the computer", -- When a player enters the usb to hack the computer
    ["CodesFound"] = "You\'ve found security codes in the files!", -- When the computer finds the codes
    ["SecurityBypass"] = "You\'ve bypassed the security system!", -- When the player succesfuly hack the system
    ["SecurityBypassFailed"] = "You\'ve failed to bypass the security system!", -- When the player fails to hack the system
    ["CodesPrinted"] = "Codes Printed, get them in the printer!", -- When the PreVault Door Codes are printed
    ['SafeTick'] = "You hear a small noise inside the safe", -- When the safe "ticks"
    ['SafeCrackFailed'] = "You messed up the combination!", -- When a player fails to open the safe
    ["ReadingCard"] = "Reading Security Card Details...", -- When a player swipes the fleeca bank card
    ["HumanInputRequired"] = "Vault Security Code Required", -- When a player needs to input the vault codes
    ["OpenningVaultDoor"] = "Security Timelock Active. The Vault Door Will Open In %s minute(s).", -- When the player enters the vault code (%s -> Time (in minutes))
    ["VaultHalfTime"] = "The Vault Door will open in %s minutes", -- When the vault door is at half-time (to open) (%s -> Time (in minutes))
    ["VaultDoorOpenned"] = "Security Timelock Over. Oppening Vault Door.", -- When the vault door opens
    ["GrabbedLootMoney"] = "You found $ %s !", -- When Player Finds money (not in bags) (%s -> Amount of Money Received)
    ["GrabbedLootItem"] = "You found %s %ss !", -- When Player Finds Items (money or item) (first %s -> Amount of Items received, second %s -> Item Name)
    ["DrillBroke"] = "The Drill Broke!", -- When the drill breaks
    ["DepositBoxEmpty"] = "This safety box was empty!", -- When a safety box is empty
    ["EmptyWall"] = "You\'ve looked through all of the boxes on that wall.", -- When a safety box wall is empty
    ["BoxLockBroke"] = "You broke this security box\'s locks!", -- When a player breaks a safety box lock
    ["CooldownMessage"] = "The Bank is on Lockdown!", -- When the bank cooldown is active
    ["NotEnoughCops"] = "Not enough cops around right now!", -- Not Enough Cops
    ['SecurityNeedsDisabling'] = "You can't do this right now.", -- If someone tries to open the safe or swipe the card while the bank isnt active
    ['SawBladeBroke'] = "The Saw Blade overheated and broke!",
    ['DontKnowCode'] = "You don\'t know the combination!", -- ESX ONlY (If the player doesn't have the printed document from the computer hack)

    ['progbar_lookingforcodes'] = 'Looking for Codes...', -- When looking through the computer
    ['progbar_printingcodes'] = 'Printing Codes...', -- When printing door codes
    ['progbar_lockpicking'] = 'Lockpicking...', -- When lockpicking the teller door
    ['progbar_insertingusb'] = 'Inserting USB Device...', -- When inserting USB in the computer
    ['progbar_grabbing'] = 'Grabbing..', -- When grabbing items
    ['progbar_swipingcard'] = 'Swiping Card...', -- When swiping the security card
    ['progbar_readingdetails'] = 'Reading Card Details...', -- When reading security card details

    ['target_TellerDoors'] = "Lockpick", -- Lockpicking Target
    ['target_TellerComputers'] = "Hack System", -- Hack Target
    ['target_Printers'] = "Take Document", -- Printer Target
    ['target_PreVaultDoors'] = "Enter Code", -- PreVault Door Target
    ['target_AttemptSafe'] = "Attempt Combination", -- Crack Safe Target
    ['target_LootSafe'] = "Loot Safe", -- Loot Safe Target
    ['target_VaultCards'] = "Swipe Card", -- Slide Card Target
    ['target_DepositBoxes'] = "Drill Deposit Boxes", -- Drill Target
    ['target_GrabLoot'] = "Grab Loot", -- Grab Loot Target
    ['target_BreakBoxes'] = "Break Deposit Boxes",

    ['SawUI_Saw'] = "Break Boxes", -- M1 "Saw" Action
    ['SawUI_Heat'] = "Blade Heat", -- Blade Heat

    ['DrillingUI_Drill'] = "Drill", -- M1 "Drill" action
    ['DrillingUI_Stop'] = "Stop", -- G "Stop" action
    ['DrillingUI_Progress'] = "Progress", -- Progress
    ['DrillingUI_Depth'] = "Depth", -- Blade Heat
    ['DrillingUI_Hold'] = "Hold Position", -- When the player hit the sweetspot and can get bonus loot.
    ['DrillingUI_TooDeep'] = "Too Deep", -- When the player hit the sweetspot and can get bonus loot.

    ['logs_robberystarted'] = '%s Has started the Fleeca Bank Robbery at %s', -- After Successful Hack (first %s -> Player Name, second %s -> Bank Name)
    ['logs_vaultoppened'] = "%s Has Oppened the Main Vault", -- After Opening the Vault (%s -> Player Name)
    ['logs_safelooted'] = "Safe Looted", -- Title when Looting Safe
    ['logs_loottitle'] = "Loot Received", -- Title when Looting others
    ['logs_player'] = "Player :", -- Player
    ['logs_found'] = "Found :", -- Found
    ['logs_qty'] = "Quantity :", -- Quantity
}