local Translations = {
    error = {
        ["canceled"]                 = "Canceled..",
        ["no_c4"]                    = "You dont have C4!",
        ["you_failed"]               = "You failed!",
        ["how_you_get_here"]         = "How did you get here?",
        ["missing_something"]        = "You're missing Thermite.",
        ["missing_something2"]        = "You don't have the required Keycard.",
        ["no_cops"]                  = "Not enough cops!",
        ["recently_robbed"]          = "This place has been robbed recently!",
        ["cannot_use_here"]          = "You cannot use this item here..",
        ["timer_too_high"]          = "The maximum length the timer can be:",
    },
    success = {
        ["planted_bomb"]             = "Explosive has been planted! Get to safe a distance!",
    },
    target = {
        ["place_bomb"]               = "Plant Explosives",
        ["take_weapon"]              = "Take Weapons",
        ["take_ammo"]                = "Take Ammo",
        ["plant_thermite"]           = "Plant Thermite",
        ["swipe_card"]               = "Swipe Card",
        ["loot"] = "Loot",
    },
    prints = {
        ["cooldown_started"]         = "BOBCAT: Cooldown started",
        ["cooldown_finished"]        = "BOBCAT: Cooldown finished",
    },
    menu = {
        ["submit_text"] = "Submit",
        ["enter_timer"] = "Enter Timer (In Seconds):",
        ["bomb_timer"] = "Bomb Timer",
        ["seconds"] = "seconds",
    },
    progress = {
        ["looting_crate"]            = "Looting Crate..",
    },   
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})