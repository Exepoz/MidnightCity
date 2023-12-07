BurnerPhonesLocales = {

    ["title_OrderSuccessful"] = "Order Successful!", -- When a player succesfully orders something
        ["notif_OrderSuccessful"] = "Wait some time, we'll send you the location for the drop off.",

    ["title_LocSent"] = "GPS Updated", -- When the player GPS's gets updated with the drop location
        ["notif_LocSent"] = "You receieved the drop location.",

    ["title_Searching"] = "Searching...", -- When a player is seatching the drop off
        ["notif_Searching"] = "You\'re carefully looking inside the package",

    ["title_ItemFound"] = "Found Something!", -- When a player finds something in the package
        ["notif_ItemFound"] = "You have found something!",

    ["title_BatteryOut"] = "Battery Out!", -- When the phone has no uses left.
        ["notif_BatteryOut"] = "The phone died!",

    ["title_CooldownActive"] = "No Answer.", -- When ordering is on Cooldown 
        ["notif_CooldownActive"] = "The phone is not picking up.",

    ["title_Error"] = "Error...", -- If the player loses their phone while they're ordering something
        ["notif_MissingPhone"] = "Where is your phone!?",

    ["title_EmptyBox"] = "There\'s nothing...", -- If there is nothing inside the drop off (Someone took it already)
        ["notif_Empty"] = "The box is empty",

    ["title_Cancelled"] = "Cancelled.", -- When a player cancells their interaction
        ["notif_Cancelled"] = "You stop what you were doing.",

    ['title_CantCarry'] = "Too heavy...",
        ['notif_CantCarry'] = "You cant carry this",

    ['dispatch_title'] = "Suspicious Package Drop Off", -- Dispatch Call
    ['dispatch_message'] = "A concerned citizen just witnessed someone dropping off a suspicious package.", -- Dispatch Message

    ['progbar_calling'] = "Calling Acquaintance...", -- Calling Progress bar
    ['progbar_vpnconnect'] = "Connecting to the VPN...", -- VPN Progress bar 1
    ['progbar_network'] = "Reaching Network...", -- VPN Progress bar 2
    ['progbar_searchingpackage'] = "Searching throught package...",

    ['interact_searchbox'] = "Search Box", -- Interaction to search the drop offf (Target or DrawText)

    ['logs_ItemPickedUp'] = "Item Picked Up", -- Title
    ['logs_BurnerphoneBroke'] = "Burnerphone Broken", -- Title
    ['logs_BurnerPhoneUsed'] = "Burnerphone Used (%s)", -- Phone Used (%s = item)
    ['logs_Player'] = "Player", -- Player
    ['logs_Item'] = "Item", -- Item
    ['logs_Amount'] = "Amount", -- Amount

    ['debug_SettingUpUses'] = "Setting Up Burnerphone Uses", -- When a burnerphone gets used for the first time
    ['debug_ErrorSelecting'] = "Error Selecting New Location, All locations seems to be currently busy", -- If the loop that selects new locations times out
    ['debug_PlayingEmote'] = "Playing Emote (%s)", -- When the player plays an emote ("%s = Emote played")
    ['debug_uses'] = "Burnerphone uses : %s / %s", -- Uses Left on the Burnerphone (First %s = Uses Left, Second %s = Max Uses)
    ['debug_AnimError'] = "Animation incorrectly setup for item #%s (Phone : %s). Please advise your server's staff team to fix this issue." -- Animation Error (1st %s = Item. 2nd %s = Phone)
}