local Translations = {
    houses = {
        ["title"]                  = 'Maison des Abeilles',
        ["capturing"]              = 'Capture des Abeilles',
        ["queens"]                 = 'Reines (%{currentQueens} / %{maxQueens})',
        ["workers"]                = 'Ouvrières (%{currentWorkers} / %{maxWorkers})',
        ["destroy"]                = 'Détruire la Maison des Abeilles',
        ["refresh"]                = 'Rafraîchir',
        ["withdraw_queens"]        = 'Retirer les Reines',
        ["withdraw_workers"]       = 'Retirer les Ouvrières',
        ["confirm_destroy"]        = 'Êtes-vous sûr de vouloir supprimer cette Maison des Abeilles ?',
    },
    hives = {
        ["title"]                  = 'Ruche',
        ["producing"]              = 'Production de Miel...',
        ["insert_queens"]          = 'Insérer %{needed} Reine(s)',
        ["insert_workers"]         = 'Insérer %{needed} Ouvrière(s)',
        ["honey_level"]            = 'Niveau de Miel [%{currentHoney} / %{maxHoney}]',
        ["wax_level"]              = 'Niveau de Cire [%{currentWax} / %{maxWax}]',
        ["destroy"]                = 'Détruire la Ruche',
        ["refresh"]                = 'Rafraîchir',
        ["withdraw_honey"]         = 'Retirer le Miel',
        ["withdraw_wax"]           = 'Retirer la Cire',
        ["confirm_destroy"]        = 'Êtes-vous sûr de vouloir supprimer cette Ruche ?',
    },
    target = {
        ["open_bee_house"]         = 'Maison des Abeilles',
        ["open_bee_hive"]          = 'Ruche',
        ["beekeeper"]              = 'Parler à l’Apiculteur',
    },
    beekeeper = {
        ["buy_bee_house"] = 'Acheter une Maison des Abeilles',
        ["purchase_bee_house_desc"] = 'Achetez une Maison des Abeilles pour collecter des ouvrières et des reines.',
        ["buy_bee_hive"] = 'Acheter une Ruche',
        ["purchase_bee_hive_desc"] = 'Obtenez une Ruche pour commencer à produire du miel et de la cire.',
        ["purchase_tools_title"] = 'Acheter du Matériel d’Apiculture',
        ["sell_honey"] = 'Vendre du Miel',
        ["sell_honey_desc"] = 'Vendez votre miel récolté pour réaliser un profit.',
        ["sell_wax"] = 'Vendre de la Cire',
        ["sell_wax_desc"] = 'Commercialisez votre cire d’abeilles pour divers usages.',
        ["sell_products_title"] = 'Vendre des Produits d’Apiculture',
        ["purchase_tools"] = 'Acheter des Outils/Objets',
        ["purchase_tools_desc"] = 'Achetez les outils et objets essentiels pour l’apiculture.',
        ["sell_items"] = 'Vendre des Articles',
        ["sell_items_desc"] = 'Vendez vos produits d’apiculture comme le Miel et la Cire.',
        ["main_menu_title"] = 'Apiculteur',
        ["return_main_menu"] = 'Retour au Menu Principal',
    },
    notifications = {
        ["title"]                  = 'Apiculture',
        ["incorrect_ground"]       = 'Vous ne pouvez pas le placer ici. Le sol est incorrect.',
        ["already_placing"]        = 'Vous êtes déjà en train de placer un objet.',
        ["not_enough_bees"]        = 'Il n’y a pas assez d’abeilles dans la maison.',
        ["not_enough_product"]     = 'Il n’y a pas assez de produit dans la ruche.',
        ["house_error"]            = 'Erreur avec la Maison des Abeilles, veuillez contacter un administrateur.',
        ["hive_error"]             = 'Erreur avec la Ruche, veuillez contacter un administrateur.',
        ["owner_error"]            = 'Cette ruche/maison des abeilles n’a pas de propriétaire, veuillez contacter un administrateur.',
        ["inventory_full_bees"]    = 'Vous n’avez pas assez d’espace dans votre inventaire pour rassembler les abeilles !',
        ["inventory_full_products"] = 'Vous n’avez pas assez d’espace dans votre inventaire pour rassembler les produits !',
        ["not_enough_queens"]      = 'Vous n’avez pas %{needed} reine(s) sur vous.',
        ["not_enough_workers"]     = 'Vous n’avez pas %{needed} ouvrière(s) sur vous.',
        ["no_access"]              = 'Vous n’êtes pas le propriétaire.',
        ["max_limit_reached"]      = 'Vous avez atteint le nombre maximum de ruches/maisons que vous pouvez placer.',
        ["purchase_success"]       = 'Achat réussi de %{quantity} x %{product}.',
        ["not_enough_money"]       = 'Pas assez d’argent pour compléter l’achat.',
        ["sell_success"]           = 'Vente réussie de %{quantity} x %{product}.',
        ["not_enough_items"]       = 'Pas assez d’articles à vendre.',
        ["in_exclusion_zone"] = "Vous ne pouvez pas placer de ruche/maison ici !",
    },
    scaleforms = {
        ["cancel_button"]          = 'Annuler',
        ["place_button"]           = 'Placer l’Objet',
        ["rotate_button"]          = 'Pivoter l’Objet',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})