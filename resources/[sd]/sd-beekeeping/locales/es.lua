local Translations = {
    houses = {
        ["title"]                  = 'Casa de Abejas',
        ["capturing"]              = 'Capturando Abejas',
        ["queens"]                 = 'Reinas (%{currentQueens} / %{maxQueens})',
        ["workers"]                = 'Obreras (%{currentWorkers} / %{maxWorkers})',
        ["destroy"]                = 'Destruir Casa de Abejas',
        ["refresh"]                = 'Actualizar',
        ["withdraw_queens"]        = 'Retirar Reinas',
        ["withdraw_workers"]       = 'Retirar Obreras',
        ["confirm_destroy"]        = '¿Estás seguro de que quieres eliminar esta Casa de Abejas?',
    },
    hives = {
        ["title"]                  = 'Colmena de Abejas',
        ["producing"]              = 'Produciendo Miel...',
        ["insert_queens"]          = 'Insertar %{needed} Reina(s)',
        ["insert_workers"]         = 'Insertar %{needed} Obrera(s)',
        ["honey_level"]            = 'Nivel de Miel [%{currentHoney} / %{maxHoney}]',
        ["wax_level"]              = 'Nivel de Cera [%{currentWax} / %{maxWax}]',
        ["destroy"]                = 'Destruir Colmena de Abejas',
        ["refresh"]                = 'Actualizar',
        ["withdraw_honey"]         = 'Retirar Miel',
        ["withdraw_wax"]           = 'Retirar Cera',
        ["confirm_destroy"]        = '¿Estás seguro de que quieres eliminar esta Colmena de Abejas?',
    },
    target = {
        ["open_bee_house"]         = 'Casa de Abejas',
        ["open_bee_hive"]          = 'Colmena de Abejas',
    },
    notifications = {
        ["title"]                  = 'Apicultura',
        ["incorrect_ground"]       = 'No puedes colocarlo aquí. El suelo es incorrecto.',
        ["already_placing"]        = 'Ya estás colocando un objeto.',
        ["not_enough_bees"]        = 'No hay suficientes abejas en la casa.',
        ["not_enough_product"]     = 'No hay suficiente producto en la colmena.',
        ["house_error"]            = 'Error con la Casa de Abejas, por favor contacta a un administrador.',
        ["hive_error"]             = 'Error con la Colmena de Abejas, por favor contacta a un administrador.',
        ["owner_error"]            = 'Esta Casa/Colmena de Abejas no tiene dueño, por favor contacta a un administrador.',
        ["inventory_full_bees"]    = '¡No tienes suficiente espacio en tu inventario para recoger las abejas!',
        ["inventory_full_products"] = '¡No tienes suficiente espacio en tu inventario para recoger los productos!',
        ["not_enough_queens"]      = 'No tienes %{needed} Reina(s) contigo.',
        ["not_enough_workers"]     = 'No tienes %{needed} Obrera(s) contigo.',
        ["no_access"]              = 'No eres el dueño.',
        ["max_limit_reached"] = 'Has alcanzado el número máximo de colmenas/casas que puedes colocar.'
    },
    scaleforms = {
        ["cancel_button"]          = 'Cancelar',
        ["place_button"]           = 'Colocar Objeto',
        ["rotate_button"]          = 'Girar Objeto',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})