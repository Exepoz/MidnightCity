local Translations = {
    error = {
        ["canceled"]                 = "Abgebrochen..",
        ["no_c4"]                    = "Du hast kein C4!",
        ["you_failed"]               = "Du hast versagt!",
        ["how_you_get_here"]         = "Wie bist du hierher gekommen?",
        ["missing_something"]        = "Dir fehlt Thermit.",
        ["missing_something2"]       = "Du hast keine erforderliche Schlüsselkarte.",
        ["no_cops"]                  = "Nicht genug Polizisten!",
        ["recently_robbed"]          = "Dieser Ort wurde kürzlich ausgeraubt!",
        ["cannot_use_here"]          = "Du kannst diesen Gegenstand hier nicht verwenden..",
        ["timer_warning"] = "Die maximale Länge des Timers kann sein:",
        ["timer_too_high"] = "Die maximale Länge des Timers kann sein:",
    },
    success = {
        ["planted_bomb"]             = "Sprengstoff wurde platziert! Geh auf sichere Entfernung!",
    },
    target = {
        ["place_bomb"]               = "Sprengstoff platzieren",
        ["take_weapon"]              = "Waffen nehmen",
        ["take_ammo"]                = "Munition nehmen",
        ["plant_thermite"]           = "Thermit platzieren",
        ["swipe_card"]               = "Karte durchziehen",
    },
    prints = {
        ["cooldown_started"]         = "BOBCAT: Abkühlungsphase gestartet",
        ["cooldown_finished"]        = "BOBCAT: Abkühlungsphase beendet",
    },
    menu = {
        ["submit_text"] = "Einreichen",
        ["enter_timer"] = "Zeitgeber eingeben (in Sekunden):",
        ["bomb_timer"] = "Bombenzeitschalter",
        ["seconds"] = "Sekunden",
    },
    progress = {
        ["looting_crate"]            = "Kiste plündern..",
    },   
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})