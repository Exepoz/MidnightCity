local Translations = {
    error = {
        ["canceled"]                 = "Annulé..",
        ["no_c4"]                    = "Vous n'avez pas de C4!",
        ["you_failed"]               = "Vous avez échoué!",
        ["how_you_get_here"]         = "Comment êtes-vous arrivé ici?",
        ["missing_something"]        = "Il vous manque du Thermite.",
        ["missing_something2"]       = "Vous n'avez pas la carte-clé requise.",
        ["no_cops"]                  = "Pas assez de policiers!",
        ["recently_robbed"]          = "Cet endroit a été récemment cambriolé!",
        ["cannot_use_here"]          = "Vous ne pouvez pas utiliser cet article ici..",
        ["timer_too_high"] = "La durée maximale du minuteur peut être :",
    },
    success = {
        ["planted_bomb"]             = "L'explosif a été planté! Éloignez-vous en sécurité!",
    },
    target = {
        ["place_bomb"]               = "Placer des explosifs",
        ["take_weapon"]              = "Prendre des armes",
        ["take_ammo"]                = "Prendre des munitions",
        ["plant_thermite"]           = "Planter du Thermite",
        ["swipe_card"]               = "Glisser la carte",
    },
    prints = {
        ["cooldown_started"]         = "BOBCAT: Refroidissement commencé",
        ["cooldown_finished"]        = "BOBCAT: Refroidissement terminé",
    },
    menu = {
        ["submit_text"] = "Soumettre",
        ["enter_timer"] = "Entrez le minuteur (En Secondes):",
        ["bomb_timer"] = "Minuteur de bombe",
        ["seconds"] = "secondes",
    },
    progress = {
        ["looting_crate"]            = "Pillage de la caisse..",
    },   
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})