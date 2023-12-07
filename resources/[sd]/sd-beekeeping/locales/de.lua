local Translations = {
    houses = {
        ["title"]                  = 'Bienenhaus',
        ["capturing"]              = 'Bienen einfangen',
        ["queens"]                 = 'Königinnen (%{currentQueens} / %{maxQueens})',
        ["workers"]                = 'Arbeiterinnen (%{currentWorkers} / %{maxWorkers})',
        ["destroy"]                = 'Bienenhaus zerstören',
        ["refresh"]                = 'Aktualisieren',
        ["withdraw_queens"]        = 'Königinnen entnehmen',
        ["withdraw_workers"]       = 'Arbeiterinnen entnehmen',
        ["confirm_destroy"]        = 'Sind Sie sicher, dass Sie dieses Bienenhaus löschen möchten?',
    },
    hives = {
        ["title"]                  = 'Bienenstock',
        ["producing"]              = 'Honig Produzieren...',
        ["insert_queens"]          = '%{needed} Königin(nen) einfügen',
        ["insert_workers"]         = '%{needed} Arbeiterin(nen) einfügen',
        ["honey_level"]            = 'Honigstand [%{currentHoney} / %{maxHoney}]',
        ["wax_level"]              = 'Wachsstand [%{currentWax} / %{maxWax}]',
        ["destroy"]                = 'Bienenstock zerstören',
        ["refresh"]                = 'Aktualisieren',
        ["withdraw_honey"]         = 'Honig entnehmen',
        ["withdraw_wax"]           = 'Wachs entnehmen',
        ["confirm_destroy"]        = 'Sind Sie sicher, dass Sie diesen Bienenstock löschen möchten?',
    },
    target = {
        ["open_bee_house"]         = 'Bienenhaus',
        ["open_bee_hive"]          = 'Bienenstock',
    },
    notifications = {
        ["title"]                  = 'Imkerei',
        ["incorrect_ground"]       = 'Sie können es hier nicht platzieren. Der Boden ist nicht korrekt.',
        ["already_placing"]        = 'Sie platzieren bereits ein Objekt.',
        ["not_enough_bees"]        = 'Es sind nicht genug Bienen im Haus.',
        ["not_enough_product"]     = 'Es ist nicht genug Produkt im Stock.',
        ["house_error"]            = 'Fehler mit dem Bienenhaus, bitte kontaktieren Sie einen Admin.',
        ["hive_error"]             = 'Fehler mit dem Bienenstock, bitte kontaktieren Sie einen Admin.',
        ["owner_error"]            = 'Dieses Bienenhaus/Bienenstock hat keinen Besitzer, bitte kontaktieren Sie einen Admin.',
        ["inventory_full_bees"]    = 'Sie haben nicht genug Platz in Ihrem Inventar, um die Bienen zu sammeln!',
        ["inventory_full_products"] = 'Sie haben nicht genug Platz in Ihrem Inventar, um die Produkte zu sammeln!',
        ["not_enough_queens"]      = 'Sie haben keine %{needed} Königin(nen) bei sich.',
        ["not_enough_workers"]     = 'Sie haben keine %{needed} Arbeiterin(nen) bei sich.',
        ["no_access"]              = 'Sie sind nicht der Besitzer.',
        ["max_limit_reached"] = 'Sie haben die maximale Anzahl an Bienenstöcken/Häusern erreicht, die Sie platzieren können.'
    },
    scaleforms = {
        ["cancel_button"]          = 'Abbrechen',
        ["place_button"]           = 'Objekt platzieren',
        ["rotate_button"]          = 'Objekt drehen',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})