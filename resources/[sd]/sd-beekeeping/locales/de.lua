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
        ["beekeeper"] = 'Mit dem Imker sprechen',
    },
    beekeeper = {
        ["buy_bee_house"] = 'Bienenhaus kaufen',
        ["purchase_bee_house_desc"] = 'Kaufen Sie ein Bienenhaus, um Arbeiter und Königinnen zu sammeln.',
        ["buy_bee_hive"] = 'Bienenstock kaufen',
        ["purchase_bee_hive_desc"] = 'Erwerben Sie einen Bienenstock, um mit der Produktion von Honig und Wachs zu beginnen.',
        ["purchase_tools_title"] = 'Imkereiausrüstung kaufen',
        ["sell_honey"] = 'Honig verkaufen',
        ["sell_honey_desc"] = 'Verkaufen Sie Ihren geernteten Honig und erzielen Sie Gewinn.',
        ["sell_wax"] = 'Wachs verkaufen',
        ["sell_wax_desc"] = 'Vermarkten Sie Ihr Bienenwachs für verschiedene Zwecke.',
        ["sell_products_title"] = 'Imkereiprodukte verkaufen',
        ["purchase_tools"] = 'Werkzeuge/Objekte kaufen',
        ["purchase_tools_desc"] = 'Kaufen Sie wichtige Werkzeuge und Objekte für die Imkerei.',
        ["sell_items"] = 'Artikel verkaufen',
        ["sell_items_desc"] = 'Verkaufen Sie Ihre Imkereiprodukte wie Honig und Wachs.',
        ["main_menu_title"] = 'Imker',
        ["return_main_menu"] = 'Zum Hauptmenü zurückkehren',
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
        ["max_limit_reached"] = 'Sie haben die maximale Anzahl an Bienenstöcken/Häusern erreicht, die Sie platzieren können.',
        ["purchase_success"] = 'Erfolgreich %{quantity} x %{product} gekauft.',
        ["not_enough_money"] = 'Nicht genug Geld für den Kauf.',
        ["sell_success"] = 'Erfolgreich %{quantity} x %{product} verkauft.',
        ["not_enough_items"] = 'Nicht genug Artikel zum Verkauf.',
        ["in_exclusion_zone"] = "Sie können hier keinen Bienenstock/Haus platzieren!",
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