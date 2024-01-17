-- Generated with https://configurator.jgscripts.com at 10/16/2023, 2:15:08 PM

Config = {}
Config.Framework = 'QBCore'
Config.FuelSystem = 'cdn-fuel'
Config.VehicleKeys = 'qb-vehiclekeys'
Config.Notifications = 'default'
Config.Locale = 'en'
Config.DateFormat = 'en-GB'
Config.CurrencySymbol = '$U'
Config.DrawText = 'qb-DrawText'
Config.OpenGarageKeyBind = 38
Config.OpenImpoundKeyBind = 38
Config.InsertVehicleKeyBind = 38
Config.OpenGaragePrompt = '[E] Open Garage'
Config.OpenImpoundPrompt = '[E] Open Impound'
Config.InsertVehiclePrompt = '[E] Store Vehicle'
Config.DoNotSpawnInsideVehicle = false
Config.SaveVehicleDamage = true
Config.AdvancedVehicleDamage = true
Config.SaveVehiclePropsOnInsert = true
Config.GarageVehicleTransferCost = 0
Config.EnableTransfers = {
  betweenGarages = false,
  betweenPlayers = true,
}
Config.AllowInfiniteVehicleSpawns = false
Config.JobGaragesAllowInfiniteVehicleSpawns = false
Config.GangGaragesAllowInfiniteVehicleSpawns = false
Config.GarageVehicleReturnCost = 750
Config.GarageVehicleReturnCostSocietyFund = false
Config.GarageShowBlips = true
Config.GarageUniqueBlips = false
Config.GarageLocations = {
  ['Legion Square'] = {
    coords = vector3(215.09, -805.17, 30.81),
    spawn = vector4(212.42, -798.77, 30.88, 336.61),
    distance = 15,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Islington South'] = {
    coords = vector3(273.0, -343.85, 44.91),
    spawn = vector4(270.75, -340.51, 44.92, 342.03),
    distance = 15,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Grove Street'] = {
    coords = vector3(14.66, -1728.52, 29.3),
    spawn = vector4(23.93, -1722.9, 29.3, 310.58),
    distance = 15,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Mirror Park'] = {
    coords = vector3(1032.84, -765.1, 58.18),
    spawn = vector4(1023.2, -764.27, 57.96, 319.66),
    distance = 15,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Great Ocean Highway'] = {
    coords = vector3(-2961.58, 375.93, 15.02),
    spawn = vector4(-2964.96, 372.07, 14.78, 86.07),
    distance = 15,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Sandy South'] = {
    coords = vector3(217.33, 2605.65, 46.04),
    spawn = vector4(216.94, 2608.44, 46.33, 14.07),
    distance = 15,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Sandy North'] = {
    coords = vector3(1878.44, 3760.1, 32.94),
    spawn = vector4(1880.14, 3757.73, 32.93, 215.54),
    distance = 15,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['North Vinewood Blvd'] = {
    coords = vector3(365.21, 295.65, 103.46),
    spawn = vector4(364.84, 289.73, 103.42, 164.23),
    distance = 15,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  Grapeseed = {
    coords = vector3(1713.06, 4745.32, 41.96),
    spawn = vector4(1710.64, 4746.94, 41.95, 90.11),
    distance = 15,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Paleto Bay'] = {
    coords = vector3(107.32, 6611.77, 31.98),
    spawn = vector4(110.84, 6607.82, 31.86, 265.28),
    distance = 15,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  Boats = {
    coords = vector3(-795.15, -1510.79, 1.6),
    spawn = vector4(-798.66, -1507.73, -0.47, 102.23),
    distance = 20,
    type = 'sea',
    hideBlip = false,
    blip = {
      id = 410,
      color = 15,
      scale = 0.6,
    },
  },
  Hangar = {
    coords = vector3(-1243.49, -3391.88, 13.94),
    spawn = vector4(-1258.4, -3394.56, 13.94, 328.23),
    distance = 20,
    type = 'air',
    hideBlip = false,
    blip = {
      id = 423,
      color = 15,
      scale = 0.6,
    },
  },
  ['MacDonald Street'] = {
    coords = vector3(353.07, -1687.69, 32.53),
    spawn = vector4(361.99, -1704.91, 32.53, 322.43),
    distance = 10,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Maze Bank Arena'] = {
    coords = vector3(-82.26, -2011.33, 18.02),
    spawn = vector4(-82.13, -2010.62, 18.02, 170.03),
    distance = 20,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Airport Parking (La Puerta)'] = {
    coords = vector3(-779.11, -2031.88, 8.88),
    spawn = vector4(-777.29, -2042.7, 8.89, 314.46),
    distance = 15,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Airport Parking (Terminal)'] = {
    coords = vector3(-1038.83, -2665.05, 13.83),
    spawn = vector4(-1047.89, -2657.62, 13.83, 219.35),
    distance = 15,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Docks - Trucking HQ'] = {
    coords = vector3(1154.37, -3130.87, 5.9),
    spawn = vector4(1152.47, -3125.9, 5.9, 179.27),
    distance = 10,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Eclipse Nightclub'] = {
    coords = vector3(-835.88, -751.23, 22.9),
    spawn = vector4(-829.7, -746.72, 23.36, 97.11),
    distance = 15,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Rockford Drive'] = {
    coords = vector3(-1163.8, -743.34, 19.54),
    spawn = vector4(-1165.16, -748.41, 19.3, 41.59),
    distance = 12,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Pier'] = {
    coords = vector3(-1581.76, -1031.14, 13.02),
    spawn = vector4(-1577.74, -1012.4, 13.02, 142.44),
    distance = 15,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Bay City Beach'] = {
    coords = vector3(-2031.2, -458.61, 11.5),
    spawn = vector4(-2013.21, -471.65, 11.52, 51.8),
    distance = 10,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Vespucci Beach'] = {
    coords = vector3(-1185.36, -1498.95, 4.38),
    spawn = vector4(-1175.27, -1496.8, 4.38, 126.6),
    distance = 10,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Marina'] = {
    coords = vector3(-691.57, -1413.36, 5.0),
    spawn = vector4(-691.16, -1422.13, 5.0, 48.92),
    distance = 10,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Vespucci Boulevard'] = {
    coords = vector3(-463.6, -806.86, 30.71),
    spawn = vector4(-472.35, -809.28, 30.54, 186.2),
    distance = 10,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Alta Apartments'] = {
    coords = vector3(-309.92, -981.03, 31.08),
    spawn = vector4(-304.65, -988.11, 31.08, 341.14),
    distance = 10,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Mount Zonah (Underground)'] = {
    coords = vector3(-473.52, -359.42, 24.23),
    spawn = vector4(-466.73, -362.35, 24.23, 5.53),
    distance = 15,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Diamond Casino'] = {
    coords = vector3(898.93, -17.87, 78.76),
    spawn = vector4(906.27, -22.91, 78.76, 239.35),
    distance = 15,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Recyling Center'] = {
    coords = vector3(717.38, -1394.15, 26.34),
    spawn = vector4(717.38, -1394.15, 26.34, 6.24),
    distance = 15,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Marina Helipad'] = {
    coords = vector3(-745.47, -1468.53, 5.0),
    spawn = vector4(-745.47, -1468.53, 5.0, 140.47),
    distance = 15,
    type = 'air',
    hideBlip = false,
    blip = {
      id = 64,
      color = 15,
      scale = 0.6,
    },
  },
  ['Sandy Airfield Helipad'] = {
    coords = vector3(1770.43, 3239.75, 42.13),
    spawn = vector4(1770.43, 3239.75, 42.13, 101.89),
    distance = 15,
    type = 'air',
    hideBlip = false,
    blip = {
      id = 64,
      color = 15,
      scale = 0.6,
    },
  },
  ['Midnight Manor (Guests)'] = {
    coords = vector3(-1794.62, 399.05, 112.79),
    spawn = vector4(-1795.2, 400.2, 112.79, 106.38),
    distance = 10,
    type = 'car',
    hideBlip = true,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Vanilla Unicorn (Guests)'] = {
    coords = vector3(151.13, -1305.06, 29.21),
    spawn = vector4(152.69, -1309.95, 29.21, 61.76),
    distance = 10,
    type = 'car',
    hideBlip = true,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['Club77 (Guests)'] = {
    coords = vector3(203.62, -3128.46, 5.79),
    spawn = vector4(203.76, -3128.44, 5.79, 86.75),
    distance = 15,
    type = 'car',
    hideBlip = false,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },
  ['The Project'] = {
    coords = vector3(1024.01, -2299.36, 30.51),
    spawn = vector4(1025.19, -2295.26, 30.51, 171.08),
    distance = 8,
    type = 'car',
    hideBlip = true,
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
  },

}
Config.JobGarageShowBlips = true
Config.JobGarageUniqueBlips = false
Config.JobGarageSetVehicleCommand = 'setjobvehicle'
Config.JobGarageRemoveVehicleCommand = 'removejobvehicle'
Config.JobGarageLocations = {
  ['Vineyard (Personal Vehicles)'] = {
    coords = vector3(157.86, -3005.9, 7.03),
    spawn = vector4(165.26, -3014.94, 5.9, 268.8),
    distance = 15,
    job = 'winery',
    type = 'car',
    vehiclesType = 'personal',
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
  },
  ['Rising Sun (Personal Vehicles)'] = {
    coords = vector3(-369.92, -112.98, 38.68),
    spawn = vector4(-361.43, -115.12, 38.72, 156.97),
    distance = 7,
    job = 'rising',
    type = 'car',
    vehiclesType = 'personal',
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
  },
  ['uWu Cafe (Personal Vehicles)'] = {
    coords = vector3(-619.85, -1059.31, 21.79),
    spawn = vector4(-620.52, -1058.78, 21.79, 269.3),
    distance = 5,
    job = 'catcafe',
    type = 'car',
    vehiclesType = 'personal',
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
  },
  ['uWu Cafe (Job Vehicles)'] = {
    coords = vector3(-609.52, -1059.14, 21.79),
    spawn = vector4(-610.59, -1059.06, 21.79, 88.89),
    distance = 5,
    job = 'catcafe',
    type = 'car',
    vehiclesType = 'personal',
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
  },
  ['Pops Diner (Employee)'] = {
    coords = vector3(1573.14, 6461.5, 24.81),
    spawn = vector4(1572.81, 6461.51, 24.77, 164.17),
    distance = 5,
    job = 'popsdiner',
    type = 'car',
    vehiclesType = 'personal',
    blip = {
      id = 357,
      color = 10,
      scale = 0.6,
    },
    hideBlip = false,
  },
  ['Hayes Auto (Employee)'] = {
    coords = vector3(-1410.44, -460.54, 34.48),
    spawn = vector4(-1410.44, -460.54, 34.48, 121.49),
    distance = 5,
    job = 'hayes',
    type = 'car',
    vehiclesType = 'personal',
    blip = {
      id = 357,
      color = 10,
      scale = 0.6,
    },
    hideBlip = false,
  },
  ['Pizza This (Employee)'] = {
    coords = vector3(803.86, -731.31, 27.66),
    spawn = vector4(800.5, -736.12, 27.66, 89.73),
    distance = 7,
    job = 'pizzathis',
    type = 'car',
    vehiclesType = 'personal',
    blip = {
      id = 357,
      color = 10,
      scale = 0.6,
    },
    hideBlip = false,
  },
  ['Burgershot (Employee)'] = {
    coords = vector3(-1170.1, -893.7, 13.93),
    spawn = vector4(-1170.1, -893.7, 13.93, 32.4),
    distance = 5,
    job = 'burgershot',
    type = 'car',
    vehiclesType = 'personal',
    blip = {
      id = 357,
      color = 10,
      scale = 0.6,
    },
    hideBlip = false,
  },
  ['Ammunation (Employee)'] = {
    coords = vector3(-8.66, -1112.32, 28.53),
    spawn = vector4(-8.66, -1112.32, 28.53, 160.79),
    distance = 5,
    job = 'ammunation',
    type = 'car',
    vehiclesType = 'personal',
    blip = {
      id = 357,
      color = 10,
      scale = 0.6,
    },
    hideBlip = false,
  },
  ['White Widow (Employee)'] = {
    coords = vector3(189.47, -266.09, 50.36),
    spawn = vector4(189.47, -266.09, 50.36, 248.23),
    distance = 5,
    job = 'whitewidow',
    type = 'car',
    vehiclesType = 'personal',
    blip = {
      id = 357,
      color = 10,
      scale = 0.6,
    },
    hideBlip = false,
  },

  -- ['Vineyard (Job Vehicles)'] = {
  --   coords = vector3(-1918.86, 2038.02, 140.74),
  --   spawn = vector4(-1922.99, 2036.29, 140.74, 261.37),
  --   distance = 15,
  --   job = 'winery',
  --   type = 'car',
  --   vehiclesType = 'owned',
  --   blip = {
  --     id = 524,
  --     color = 15,
  --     scale = 0.6,
  --   },
  --   hideBlip = false,
  -- },
  ['MCPD (Lot)'] = {
    coords = vector3(434.48, -1016.97, 28.83),
    spawn = vector4(434.55, -1014.54, 28.49, 91.56),
    distance = 7,
    job = 'police',
    type = 'car',
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
    vehiclesType = 'personal',

  },
  ['MCPD (Inside)'] = {
    coords = vector3(441.31, -971.32, 23.94),
    spawn = vector4(441.18, -970.96, 23.94, 86.77),
    distance = 7,
    job = 'police',
    type = 'car',
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
    hideBlip = true,
    vehiclesType = 'spawner',
    showLiveriesExtrasMenu = true,
    vehicles = {
      {
        vehicle = 'bcat',
        plate = 'PDCAT',
        minJobGrade = 6,
      },
      -- {
      --   vehicle = 'police2',
      --   plate = false,
      --   minJobGrade = 3,
      -- },
    },
  },
  ['MCPD (Helipad)'] = {
    coords = vector3(449.17, -981.15, 43.69),
    spawn = vector4(449.17, -981.15, 43.69, 358.61),
    distance = 5,
    job = 'police',
    type = 'air',
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
    hideBlip = true,
    vehiclesType = 'owned',
  },
  ['Pillbox (Ambulances)'] = {
    coords = vector3(-503.13, -335.16, 34.39),
    spawn = vector4(-503.13, -335.16, 34.39, 261.59),
    distance = 5,
    job = 'ambulance',
    type = 'car',
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
    hideBlip = true,
    vehiclesType = 'owned',
  },
}
Config.GangGarageShowBlips = true
Config.GangGarageUniqueBlips = false
Config.GangGarageSetVehicleCommand = 'setgangvehicle'
Config.GangGarageRemoveVehicleCommand = 'removegangvehicle'
Config.GangGarageLocations = {
  ['MCPD (SEU)'] = {
    coords = vector3(440.04, -957.32, 23.94),
    spawn = vector4(440.04, -957.32, 23.94, 179.97),
    distance = 7,
    gang = 'seu',
    type = 'car',
    vehiclesType = 'owned',
    blip = {
      id = 524,
      color = 15,
      scale = 0.6,
    },
    hideBlip = true,
  },
  ['Lost MC Clubhouse'] = {
    coords = vector3(1424.94, -2606.2, 48.03),
    spawn = vector4(1423.25, -2608.93, 48.03, 351.26),
    distance = 7,
    gang = 'lostmc',
    type = 'car',
    vehiclesType = 'personal',
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
  },
  ['Midnight Compound (Gang Vehicles)'] = {
    coords = vector3(-593.79, -1604.32, 27.01),
    spawn = vector4(-593.79, -1604.32, 27.01, 354.98),
    distance = 5,
    gang = 'midnight',
    type = 'car',
    vehiclesType = 'owned',
    blip = {
      id = 524,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
  },
  ['Midnight Compound (Upper)'] = {
    coords = vector3(-617.96, -1599.16, 26.75),
    spawn = vector4(-618.7, -1593.79, 26.75, 136.47),
    distance = 7,
    gang = 'midnight',
    type = 'car',
    vehiclesType = 'personal',
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
  },
  ['Midnight Compound (Lower)'] = {
    coords = vector3(-579.62, -1642.47, 19.45),
    spawn = vector4(-582.91, -1644.83, 19.5, 249.71),
    distance = 7,
    gang = 'midnight',
    type = 'car',
    vehiclesType = 'personal',
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
  },
  ['Midnight Compound (Helipad)'] = {
    coords = vector3(-584.45, -1622.03, 37.85),
    spawn = vector4(-584.45, -1622.03, 37.85, 176.38),
    distance = 7,
    gang = 'midnight',
    type = 'air',
    vehiclesType = 'personal',
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
    hideBlip = true,
  },
  ['Midnight Manor (Upper)'] = {
    coords = vector3(-1792.36, 458.33, 128.31),
    spawn = vector4(-1792.36, 458.33, 128.31, 102.4),
    distance = 7,
    gang = 'midnight',
    type = 'car',
    vehiclesType = 'personal',
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
  },
  ['Cabal Mansion'] = {
    coords = vector3(-108.4, 833.54, 235.72),
    spawn = vector4(-110.45, 834.42, 235.7, 282.74),
    distance = 7,
    gang = 'cabal',
    type = 'car',
    vehiclesType = 'personal',
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
  },
  ['Cabal Mansion (Gang Vehicles)'] = {
    coords = vector3(-74.12, 897.91, 235.57),
    spawn = vector4(-74.12, 897.91, 235.57, 25.75),
    distance = 5,
    gang = 'cabal',
    type = 'car',
    vehiclesType = 'owned',
    blip = {
      id = 524,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
  },

  ['Vagos HQ'] = {
    coords = vector3(323.54, -2030.55, 20.83),
    spawn = vector4(328.36, -2034.57, 20.96, 49.9),
    distance = 7,
    gang = 'vagos',
    type = 'car',
    vehiclesType = 'personal',
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
  },
  ['Vagos HQ (Gang Vehicles)'] = {
    coords = vector3(275.19, -2074.18, 16.88),
    spawn = vector4(275.19, -2074.18, 16.88, 14.17),
    distance = 5,
    gang = 'cabal',
    type = 'car',
    vehiclesType = 'owned',
    blip = {
      id = 524,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
  },

  ['Peaky Boys House'] = {
    coords = vector3(-755.39, 815.93, 213.5),
    spawn = vector4(-755.39, 815.93, 213.5, 285.02),
    distance = 7,
    gang = 'luciano',
    type = 'car',
    vehiclesType = 'personal',
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
    hideBlip = true,
  },
  ['Club77 (Private Lot)'] = {
    coords = vector3(-755.39, 815.93, 213.5),
    spawn = vector4(-755.39, 815.93, 213.5, 285.02),
    distance = 7,
    gang = 'gambino',
    type = 'car',
    vehiclesType = 'personal',
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
  },
  ['Club77 (Gang Vehicles)'] = {
    coords = vector3(271.9, -3191.05, 5.79),
    spawn = vector4(271.62, -3191.07, 5.79, 275.29),
    distance = 7,
    gang = 'gambino',
    type = 'car',
    vehiclesType = 'owned',
    blip = {
      id = 524,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
  },

  ['Misfits Compound (Garage)'] = {
    coords = vector3(-668.18, -879.46, 24.51),
    spawn = vector4(-666.95, -878.37, 24.51, 89.06),
    distance = 7,
    gang = 'misfits',
    type = 'car',
    vehiclesType = 'personal',
    blip = {
      id = 357,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
  },
  ['Misfits Compound (Gang Vehicles)'] = {
    coords = vector3(-688.0, -886.87, 24.5),
    spawn = vector4(-684.86, -887.47, 24.5, 238.43),
    distance = 7,
    gang = 'gambino',
    type = 'car',
    vehiclesType = 'owned',
    blip = {
      id = 524,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
  },

}
Config.ImpoundShowBlips = true
Config.ImpoundUniqueBlips = false
Config.ImpoundCommand = 'iv'
Config.ImpoundJobRestriction = {
  'police',
}
Config.ImpoundFeesSocietyFund = 'police'
Config.ImpoundLocations = {
  ['MCPD Impound'] = {
    coords = vector3(431.34, -957.24, 23.94),
    spawn = vector4(431.34, -957.25, 23.94, 180.47),
    distance = 5,
    type = 'car',
    blip = {
      id = 68,
      color = 15,
      scale = 0.6,
    },
    hideBlip = true,
  },

  ['City Impound'] = {
    coords = vector3(409.04, -1622.69, 29.29),
    spawn = vector4(398.23, -1636.87, 29.29, 228.17),
    distance = 3,
    type = 'car',
    blip = {
      id = 68,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
  },
  ['Sandy Shores Impound'] = {
    coords = vector3(1649.71, 3789.61, 34.79),
    spawn = vector4(1643.66, 3798.36, 34.49, 216.16),
    distance = 15,
    type = 'car',
    blip = {
      id = 68,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
  },
  ['Air Impound'] = {
    coords = vector3(-1261.05, -3408.4, 13.94),
    spawn = vector4(-1268.03, -3392.79, 13.94, 325.99),
    distance = 15,
    type = 'air',
    blip = {
      id = 68,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
  },
  ['Boat Impound'] = {
    coords = vector3(-768.93, -1426.26, 1.6),
    spawn = vector4(-775.88, -1429.27, -0.07, 138.52),
    distance = 15,
    type = 'sea',
    blip = {
      id = 68,
      color = 15,
      scale = 0.6,
    },
    hideBlip = false,
  },
}
Config.PrivGarageCreateCommand = 'privategarages'
Config.PrivGarageCreateJobRestriction = {
  'realestate',
}
Config.ChangeVehiclePlate = 'vplate'
Config.DeleteVehicleFromDB = 'dvdb'
Config.ReturnVehicleToGarage = 'vreturn'
Config.VehicleLabels = {
  spawnName = 'Pretty Vehicle Label',
}
Config.__v2Config = true
