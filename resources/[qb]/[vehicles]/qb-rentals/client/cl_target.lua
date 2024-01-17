CreateThread(function(data)
    exports['qb-target']:AddCircleZone("VehiclePed",vector3(1015.89, -2319.89, 30.51), 0.5, {
        name = "vehicleped",
        debugPoly = false,
      }, {
        options = {
            {
                type = "client",
                event = "qb-rental:client:LicenseCheck",
                icon = "fas fa-car",
                label = "Rent Vehicle",
                LicenseType = "driver",
                MenuType = "vehicle",
            },
        },
        distance = 3.0
      })

    exports['qb-target']:AddCircleZone("AircraftPed", vector3(-220.64, -1167.85, 23.01), 0.5, {
        name = "aircraftped",
        debugPoly = false,
      }, {
        options = {
            {
                type = "client",
                event = "qb-rental:client:LicenseCheck",
                icon = "fas fa-car",
                label = "Rent Vehicle",
                LicenseType = "pilot",
                MenuType = "aircraft",
            },
        },
        distance = 3.0
        })

    exports['qb-target']:AddCircleZone("BoatPed", vector3(1852.88, 2582.35, 45.67), 0.5, {
        name = "boatped",
        debugPoly = false,
        }, {
        options = {
            {
                type = "client",
                event = "qb-rental:client:openMenu",
                icon = "fas fa-car",
                label = "Rent Vehicle",
                MenuType = "boat"
            },
        },
        distance = 3.0
        })
end)