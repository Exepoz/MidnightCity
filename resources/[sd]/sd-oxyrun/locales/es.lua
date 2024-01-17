local Translations = {
    error = {
        ["canceled"]                    = "Cancelado..",
        ["done_recently"]               = "Lo has hecho recientemente, ¡vuelve pronto!",
        ["someone_recently_did_this"]   = "Alguien lo hizo recientemente..",
        ["cannot_do_this_right_now"]    = "No puedes hacer esto ahora mismo..",
        ["does_not_speak"]              = "Trae el otro paquete primero..",
        ["get_out_vehicle"]             = "Primero sal de tu vehículo..",
        ["bring_other_package"]         = "Trae el otro paquete primero..",
        ["what_do_you_want"]            = "¿Qué quieres?",
        ["you_cannot_do_this"]          = "No puedes hacer esto..",
        ["you_dont_have_enough_money"]  = "No tienes suficiente dinero..",
        ["no_package"]                  = "No tienes ningún paquete..",
        ["leave_area"]                  = "Tus clientes se irán si no te quedas en el área..",
        ["occupied_routes"]             = "Todas las rutas están ocupadas actualmente, inténtalo más tarde..",
        ["missing_required_item"]       = "Te falta algo..",
        ["you_robbed"]                  = "¡El cliente está tratando de alejarse sin darte tu oxy!",
        ["you_were_robbed"]             = "¡El cliente se ha ido sin pagarte con oxy!",
        ["robbery_stopped"] = "¡Has logrado impedir que el cliente se vaya sin pagarte con oxy!",

    },
    success = {
        ["you_have_arrived"]            = "Has llegado a la ubicación marcada, espera a los clientes..",
        ["drive_to_location"]           = "Conduce a la ubicación marcada en tu GPS..",
        ["arrived_location"]            = "Has llegado a la ubicación marcada, espera a los clientes..",
        ["suppliers_position"]          = "La posición del proveedor ha sido marcada en tu GPS..",
        ["send_email_right_now"]        = "Te enviaré un correo electrónico ahora mismo..",
        ["start_run"]                   = "Te has registrado, consigue un vehículo..",
        ["run_ended"]                   = "Tu carrera ha terminado..",
    },
    prints = {
        ["cooldown_started"] = "OXY RUN: Tiempo de espera iniciado",
        ["cooldown_finished"] = "OXY RUN: Tiempo de espera finalizado",
    },
    mailstart = {
        ["sender"]                      = "Desconocido",
        ["subject"]                     = "Entrega Especial",
        ["message"]                     = "¡Gracias por ayudarme, serás recompensado generosamente! ¡Encuentra un vehículo para llegar al proveedor!",
    },
    mailfinish = {
        ["sender"]                      = "Desconocido",
        ["subject"]                     = "Entrega Especial",
        ["message"]                     = "¡Me has hecho un gran favor! ¡Vuelve a mí cuando estés listo para más!",
    },
    --
    target = {
        ["oxyboss"]                     = "Registrarse",
        ["oxysupplier"]                 = "Coger Paquete",
        ["handoff_package"]             = "Entregar Paquete",
    },
    progress = {
        ["talking_to_boss"]             = "Hablando con el jefe..",
},
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})