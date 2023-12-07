local Translations = {
    houses = {
        ["title"]                  = 'Maison d\'Abeilles',
        ["capturing"]              = 'Capture des Abeilles',
        ["queens"]                 = 'Reines (%{currentQueens} / %{maxQueens})',
        ["workers"]                = 'Ouvrières (%{currentWorkers} / %{maxWorkers})',
        ["destroy"]                = 'Détruire la Maison d\'Abeilles',
        ["refresh"]                = 'Actualiser',
        ["withdraw_queens"]        = 'Retirer les Reines',
        ["withdraw_workers"]       = 'Retirer les Ouvrières',
        ["confirm_destroy"]        = 'Êtes-vous sûr de vouloir supprimer cette Maison d\'Abeilles?',
    },
    hives = {
        ["title"]                  = 'Ruche d\'Abeilles',
        ["producing"]              = 'Production de Miel...',
        ["insert_queens"]          = 'Insérer %{needed} Reine(s)',
        ["insert_workers"]         = 'Insérer %{needed} Ouvrière(s)',
        ["honey_level"]            = 'Niveau de Miel [%{currentHoney} / %{maxHoney}]',
        ["wax_level"]              = 'Niveau de Cire [%{currentWax} / %{maxWax}]',
        ["destroy"]                = 'Détruire la Ruche d\'Abeilles',
        ["refresh"]                = 'Actualiser',
        ["withdraw_honey"]         = 'Retirer le Miel',
        ["withdraw_wax"]           = 'Retirer la Cire',
        ["confirm_destroy"]        = 'Êtes-vous sûr de vouloir supprimer cette Ruche d\'Abeilles?',
    },
    target = {
        ["open_bee_house"]         = 'Maison d\'Abeilles',
        ["open_bee_hive"]          = 'Ruche d\'Abeilles',
    },
    notifications = {
        ["title"]                  = 'Apiculture',
        ["incorrect_ground"]       = 'Vous ne pouvez pas le placer ici. Le sol n\'est pas correct.',
        ["already_placing"]        = 'Vous placez déjà un objet.',
        ["not_enough_bees"]        = 'Il n\'y a pas assez d\'abeilles dans la maison.',
        ["not_enough_product"]     = 'Il n\'y a pas assez de produit dans la ruche.',
        ["house_error"]            = 'Erreur avec la Maison d\'Abeilles, veuillez contacter un administrateur.',
        ["hive_error"]             = 'Erreur avec la Ruche d\'Abeilles, veuillez contacter un administrateur.',
        ["owner_error"]            = 'Cette ruche/maison d\'abeilles n\'a pas de propriétaire, veuillez contacter un administrateur.',
        ["inventory_full_bees"]    = 'Vous n\'avez pas assez de place dans votre inventaire pour rassembler les abeilles!',
        ["inventory_full_products"] = 'Vous n\'avez pas assez de place dans votre inventaire pour rassembler les produits!',
        ["not_enough_queens"]      = 'Vous n\'avez pas %{needed} reine(s) sur vous.',
        ["not_enough_workers"]     = 'Vous n\'avez pas %{needed} ouvrière(s) sur vous.',
        ["no_access"]              = 'Vous n\'êtes pas le propriétaire.',
        ["max_limit_reached"] = 'Vous avez atteint le nombre maximal de ruches/maisons que vous pouvez placer.'
    },
    scaleforms = {
        ["cancel_button"]          = 'Annuler',
        ["place_button"]           = 'Placer l\'Objet',
        ["rotate_button"]          = 'Tourner l\'Objet',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})