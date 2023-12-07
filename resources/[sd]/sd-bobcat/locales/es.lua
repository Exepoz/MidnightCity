local Translations = {
    error = {
        ["canceled"]                 = "Cancelado..",
        ["no_c4"]                    = "¡No tienes C4!",
        ["you_failed"]               = "¡Has fallado!",
        ["how_you_get_here"]         = "¿Cómo llegaste aquí?",
        ["missing_something"]        = "Te falta termita.",
        ["missing_something2"]       = "No tienes una tarjeta clave requerida.",
        ["no_cops"]                  = "¡No hay suficientes policías!",
        ["recently_robbed"]          = "¡Este lugar ha sido robado recientemente!",
        ["cannot_use_here"]          = "No puedes usar este objeto aquí..",
        ["timer_too_high"] = "La duración máxima que puede tener el temporizador es:",
    },
    success = {
        ["planted_bomb"]             = "¡El explosivo ha sido plantado! ¡Aléjate a una distancia segura!",
    },
    target = {
        ["place_bomb"]               = "Colocar explosivos",
        ["take_weapon"]              = "Tomar armas",
        ["take_ammo"]                = "Tomar municiones",
        ["plant_thermite"]           = "Colocar termita",
        ["swipe_card"]               = "Deslizar tarjeta",
    },
    prints = {
        ["cooldown_started"]         = "BOBCAT: Comienza el enfriamiento",
        ["cooldown_finished"]        = "BOBCAT: Enfriamiento terminado",
    },
    menu = {
        ["submit_text"] = "Enviar",
        ["enter_timer"] = "Introduce el temporizador (En Segundos):",
        ["bomb_timer"] = "Temporizador de bomba",
        ["seconds"] = "segundos",
    },
    progress = {
        ["looting_crate"]            = "Saqueando la caja..",
    },   
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})