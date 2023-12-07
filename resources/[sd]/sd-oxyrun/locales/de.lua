local Translations = {
    error = {
        ["canceled"]                    = "Abgebrochen..",
        ["done_recently"]               = "Du hast das kürzlich gemacht, komm bald wieder!",
        ["someone_recently_did_this"]   = "Jemand hat das kürzlich gemacht..",
        ["cannot_do_this_right_now"]    = "Kann das gerade nicht machen..",
        ["does_not_speak"]              = "Bring erst das andere Paket weg..",
        ["get_out_vehicle"]             = "Steige zuerst aus deinem Fahrzeug aus..",
        ["bring_other_package"]         = "Bring erst das andere Paket weg..",
        ["what_do_you_want"]            = "Was möchtest du?",
        ["you_cannot_do_this"]          = "Du kannst das nicht tun..",
        ["you_dont_have_enough_money"]  = "Du hast nicht genug Geld..",
        ["no_package"]                  = "Du hältst kein Paket..",
        ["leave_area"]                  = "Deine Kunden werden gehen, wenn du nicht in der Gegend bleibst..",
        ["occupied_routes"]             = "Alle Routen sind derzeit belegt, versuche es später erneut..",
        ["missing_required_item"]       = "Dir fehlt etwas..",
    },
    success = {
        ["you_have_arrived"]            = "Du bist am markierten Ort angekommen, warte auf Kunden..",
        ["drive_to_location"]           = "Fahre zur Position, die auf deinem GPS markiert ist..",
        ["arrived_location"]            = "Du bist am markierten Ort angekommen, warte auf Kunden..",
        ["suppliers_position"]          = "Die Position des Lieferanten wurde auf deinem GPS markiert..",
        ["send_email_right_now"]        = "Ich werde dir jetzt eine E-Mail senden..",
        ["start_run"]                   = "Du hast dich angemeldet, besorge dir ein Fahrzeug..",
        ["run_ended"]                   = "Dein Lauf ist beendet..",
    },
    prints = {
        ["global_cooldown_started"] = "OXY RUN: Abklingzeit gestartet",
        ["global_cooldown_finished"] = "OXY RUN: Abklingzeit beendet",
    },
    -- Locales Used in qb-phone email event if Config.SendEmail is true.
    mailstart = {
        ["sender"]                      = "Unbekannt",
        ["subject"]                     = "Spezial Lieferung",
        ["message"]                     = "Danke, dass du mir hilfst, du wirst großzügig belohnt! Besorge dir ein Fahrzeug, um zum Lieferanten zu kommen!",
    },
    mailfinish = {
        ["sender"]                      = "Unbekannt",
        ["subject"]                     = "Spezial Lieferung",
        ["message"]                     = "Du hast mir einen großen Gefallen getan! Komm zurück zu mir, wenn du bereit für mehr bist!",
    },
    --
    target = {
        ["oxyboss"]                     = "Anmelden",
        ["oxysupplier"]                 = "Paket greifen",
        ["handoff_package"]             = "Paket übergeben",
    },
    progress = {
        ["talking_to_boss"]             = "Reden mit dem Boss..",
},
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})