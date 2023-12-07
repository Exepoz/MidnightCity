local Translations = {
    error = {
        ["canceled"]                    = "Annulé..",
        ["done_recently"]               = "Vous avez fait ça récemment, revenez bientôt !",
        ["someone_recently_did_this"]   = "Quelqu'un l'a fait récemment..",
        ["cannot_do_this_right_now"]    = "Impossible de le faire en ce moment..",
        ["does_not_speak"]              = "Apportez d'abord l'autre colis..",
        ["get_out_vehicle"]             = "Sortez d'abord de votre véhicule..",
        ["bring_other_package"]         = "Apportez d'abord l'autre colis..",
        ["what_do_you_want"]            = "Que voulez-vous ?",
        ["you_cannot_do_this"]          = "Vous ne pouvez pas faire ça..",
        ["you_dont_have_enough_money"]  = "Vous n'avez pas assez d'argent..",
        ["no_package"]                  = "Vous ne tenez pas de colis..",
        ["leave_area"]                  = "Vos clients partiront si vous ne restez pas dans la zone..",
        ["occupied_routes"]             = "Toutes les routes sont actuellement occupées, réessayez plus tard..",
        ["missing_required_item"]       = "Il vous manque quelque chose..",
    },
    success = {
        ["you_have_arrived"]            = "Vous êtes arrivé à l'emplacement marqué, attendez les clients..",
        ["drive_to_location"]           = "Conduisez à l'emplacement marqué sur votre GPS..",
        ["arrived_location"]            = "Vous êtes arrivé à l'emplacement marqué, attendez les clients..",
        ["suppliers_position"]          = "La position du fournisseur a été marquée sur votre GPS..",
        ["send_email_right_now"]        = "Je vais vous envoyer un e-mail tout de suite..",
        ["start_run"]                   = "Vous vous êtes inscrit, procurez-vous un véhicule..",
        ["run_ended"]                   = "Votre course est terminée..",
    },
    prints = {
        ["cooldown_started"] = "OXY RUN: Délai de récupération commencé",
        ["cooldown_finished"] = "OXY RUN: Délai de récupération terminé",
    },
    -- Locales Used in qb-phone email event if Config.SendEmail is true.
    mailstart = {
        ["sender"]                      = "Inconnu",
        ["subject"]                     = "Livraison spéciale",
        ["message"]                     = "Merci de m'aider, vous serez généreusement récompensé ! Trouvez-vous un véhicule pour vous rendre chez le fournisseur !",
    },
    mailfinish = {
        ["sender"]                      = "Inconnu",
        ["subject"]                     = "Livraison spéciale",
        ["message"]                     = "Vous m'avez rendu un grand service ! Revenez vers moi quand vous serez prêt pour plus !",
    },
    --
    target = {
        ["oxyboss"]                     = "Se connecter",
        ["oxysupplier"]                 = "Prendre le colis",
        ["handoff_package"]             = "Remettre le colis",
    },
    progress = {
        ["talking_to_boss"]             = "Parler au patron..",
},
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})