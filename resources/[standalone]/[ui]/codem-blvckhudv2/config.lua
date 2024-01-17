
-------------------------------------------- General --------------------------------------------
Config = {}
Config.Framework = "newqb" -- newqb, oldqb, esx
Config.Mysql = "oxmysql" -- mysql-async, ghmattimysql, oxmysql
Config.DefaultHud = "radial" -- Default hud when player first login avaliable huds [radial, classic, text]
Config.DefaultSpeedUnit = "mph" -- Default speed unit when player first login avaliable speed units [kmh, mph]
Config.HudSettingsCommand = 'hud' -- Command for open hud settings
Config.DisplayMapOnWalk = true -- true - Show map when walking | false - Hide map when walking
Config.DisplayRealTime = false -- if you set this to true will show the real time according to player local time | if false it will show the game time
Config.EnableSpamNotification = true -- Spam preventation for seatbelt, cruise etc.
Config.EnableDateDisplay = false -- Determines if display date or nor
Config.DefaultMap = "rectangle" -- rectangle, radial
Config.DefaultSpeedometerSize = 0.7 -- 0.5 - 1.3
Config.DefaultHudSize = 1.0 -- 0.5 - 1.3
Config.EnableAmmoHud = true -- Determines if display ammo hud or nor
Config.DefaultRefreshRate = 200 -- Refresh rate for vehicle hud
Config.EnableHealth = true
Config.EnableHunger = true
Config.EnableThirst = true
Config.EnableHud = true
Config.EnableArmor = true
Config.EnableStamina = true
Config.EnableSpeedometer = true



Config.DefaultHudColors = {
    ["radial"] = {
        ["health"] = "#FF4848ac",
        ["armor"] = "#FFFFFFac",
        ["hunger"] = "#FFA048ac",
        ["thirst"] = "#4886FFac",
        ["stress"] = "#48A7FFac",
        ["stamina"] = "#C4FF48ac",
        ["oxy"] = "#48A7FFac",
        ["parachute"] = "#48FFBDac",
        ["nitro"] = "#AFFF48ac",
        ["altitude"] = "#00FFF0ac",
    },
    ["text"] = {
        ["health"] = "#FF4848ac",
        ["armor"] = "#FFFFFFac",
        ["hunger"] = "#FFA048ac",
        ["thirst"] = "#4886FFac",
        ["stress"] = "#48A7FFac",
        ["stamina"] = "#C4FF48ac",
        ["parachute"] = "#48FFBDac",
        ["oxy"] = "#48A7FFac",
        ["nitro"] = "#AFFF48ac",
        ["altitude"] = "#00FFF0ac",
    },
    ["classic"] = {
        ["health"] = "#9F2929",
        ["armor"] = "#2E3893",
        ["hunger"] = "#B3743A",
        ["thirst"] = "#2F549C",
        ["stress"] = "#AA35A6",
        ["oxy"] = "#48A7FFac",
        ["stamina"] = "#c4ff48",
        ["parachute"] = "#48ffde",
        ["nitro"] = "#8eff48",
        ["altitude"] = "#48deff",
    },
}


-------------------------------------------- Watermark hud --------------------------------------------
Config.DisableWaterMarkTextAndLogo = true -- true - Disable watermark text and logo
Config.UseWaterMarkText = false -- if true text will be shown | if  false logo will be shown
Config.WaterMarkText1 = "Midnight" -- Top right server text
Config.WaterMarkText2 = "City"  -- Top right server text
Config.WaterMarkLogo = "https://cdn.discordapp.com/attachments/1134551241603682354/1183115208214982716/Transparent_Logo.png" -- Logo url
Config.LogoWidth = "150px"
Config.LogoHeight = "150px"
Config.EnableId = true -- Determines if display server id or nor
Config.EnableWatermarkCash = false -- Determines if display cash or nor
Config.EnableWatermarkBankMoney = false -- Determines if display bank money or nor
Config.EnableWatermarkJob = false -- Determines if display job or nor
Config.EnableWatermarkWeaponImage = false -- Determines if display weapon image or nor
Config.EnableWaterMarkHud = true -- Determines if right-top hud is enabled or not

Config.Text1Style = {
    ["color"] = '#e960c7',
    ["text-shadow"] = "0px 0.38rem 2.566rem rgba(116, 5, 147, 0.55)",
}

Config.Text2Style = {
    ["color"] = "#ffffff",
}

-------------------------------------------- Keys --------------------------------------------
Config.DefaultCruiseControlKey = "Y" -- Default control key for cruise. Players can change the key according to their desire
Config.DefaultSeatbeltControlKey = "B" -- Default control key for seatbelt. Players can change the key according to their desire
Config.VehicleEngineToggleKey = "G" -- Default control key for toggle engine. Players can change the key according to their desire
Config.NitroKey = "SHIFT" -- Default control key for use nitro. Players can change the key according to their desire

-------------------------------------------- Nitro --------------------------------------------
Config.RemoveNitroOnpress = 2 -- Determines of how much you want to remove nitro when player press nitro key
Config.NitroItem = "nitro" -- item to install nitro to a vehicle
Config.EnableNitro = false -- Determines if nitro system is enabled or not
Config.NitroForce = 50.0 -- Nitro force when player using nitro

-------------------------------------------- Money commands --------------------------------------------
Config.EnableCashAndBankCommands = true -- Determines if money commands are enabled or not
Config.CashCommand = "cash"  -- command to see cash
Config.BankCommand = "bank" -- command to see bank money

-------------------------------------------- Engine Toggle --------------------------------------------
Config.EnableEngineToggle = true -- Determines if engine toggle is enabled or not

-------------------------------------------- Vehicle Functionality --------------------------------------------
Config.EnableCruise = true -- Determines if cruise mode is active
Config.EnableSeatbelt = false -- Determines if seatbelt is active

-------------------------------------------- Settings text --------------------------------------------
Config.SettingsLocale = { -- Settings texts
    ["text_hud_1"] = "Test",
    ["text_hud_2"] = "HUD",
    ["classic_hud_1"] = "Classic",
    ["classic_hud_2"] = "HUD",
    ["radial_hud_1"] = "Radial",
    ["radial_hud_2"] = "HUD",
    ["hide_hud"] = "Hide Hud",
    ["health"] = "Vitals",
    ["armor"] = "Armor",
    ["thirst"] = "Thirst",
    ["stress"] = "Stress",
    ["oxy"] = "Oxygen",
    ["hunger"] = "Hunger",
    ["show_hud"] = "Show Hud",
    ["stamina"] = "Stamina",
    ["nitro"] = "Nitro",
    ["Altitude"] = "Altitude",
    ["Parachute"] = "Parachute",
    ["enable_cinematicmode"] = "Enable Cinematic",
    ["disable_cinematicmode"] = "Disable Cinematic",
    ["exit_settings_1"] = "Exit",
    ["exit_settings_2"] = "Setting",
    ["speedometer"] = "Speedometer",
    ["map"] = "Map",
    ["show_compass"] = "Show Compass",
    ["hide_compass"] = "Hide Compass",
    ["rectangle"] = "Rectangle",
    ["radial"] = "Radial",
    ["dynamic"] = "Dynamic",
    ["status"] = "Status",
    ["enable"] = "Enable",
    ["hud_size"] = "Hud Size",
    ["disable"] = "Disable",
    ["hide_at"] = "Hide At",
    ["and_above"] = "And Above",
    ["enable_edit_mode"] = "Move Hud (Single Icon)",
    ["enable_edit_mode_2"] = "Move HUD (In Bulk)",
    ["change_status_size"] = "Change the size Hud",
    ["change_color"] = "Change Hud Color",
    ["disable_edit_mode"] = "Disable Edit Mode",
    ["reset_hud_positions"] = "Reset Hud",
    ["info_text"] = "Keep in mind that increasing the refresh rate can reduce the performance!",
    ["speedometer_size"] = "Speedometer Size",
    ["refresh_rate"] = "Refresh Rate",
    ["esc_to_exit"] = "Press ESC to Exit"
}

-------------------------------------------- Fuel --------------------------------------------
Config.UseLegacyFuel = false --Enable this if you use legacy fuel

Config.GetVehicleFuel = function(vehicle) -- you can change LegacyFuel export if you use another fuel system
    if Config.UseLegacyFuel then
        return exports["cnd-fuel"]:SetFuel(vehicle)
    else
        return GetVehicleFuelLevel(vehicle)
    end
end

-------------------------------------------- Stress --------------------------------------------

Config.UseStress = false -- if you set this to false the stress hud will be removed
Config.StressWhitelistJobs = { -- Add here jobs you want to disable stress
    'police', 'ambulance'
}

Config.WhitelistedWeaponStress = {
    `weapon_petrolcan`,
    `weapon_hazardcan`,
    `weapon_fireextinguisher`
}

Config.AddStress = {
    ["on_shoot"] = {
        min = 1,
        max = 3,
        enable = true,
    },
    ["on_fastdrive"] = {
        min = 1,
        max = 3,
        enable = true,
    },
}

Config.RemoveStress = { -- You can set here amounts by your desire
    ["on_eat"] = {
        min = 5,
        max = 10,
        enable = true,

    },
    ["on_drink"] = {
        min = 5,
        max = 10,
        enable = true,

    },
    ["on_swimming"] = {
        min = 5,
        max = 10,
        enable = true,

    },
    ["on_running"] = {
        min = 5,
        max = 10,
        enable = true,
    },

}



-------------------------------------------- Notifications --------------------------------------------

Config.Notifications = { -- Notifications
    ["stress_gained"] = {
        message = 'Getting Stressed',
        type = "error",
        time = 5000
    },
    ["stress_relive"] = {
        message =  'You Are Relaxing',
        type = "success",
        time = 5000
    },
    ["took_off_seatbelt"] = {
        type = "error",
        message = "Seatbelt Off",
        time = 5000
    },
    ["took_seatbelt"] = {
        type = "success",
        message = "Seat Belt On",
        time = 5000
    },
    ["cruise_actived"] = {
        type = "success",
        message = "Crusie Activated",
        time = 5000
    },
    ["cruise_disabled"] = {
        type = "error",
        message = "Cruise Deactivated",
        time = 5000
    },
    ["spam"] = {
        type = "error",
        message = "Aspetta qualche secondo.",
        time = 5000
    },
    ["engine_on"] = {
        type = "success",
        message = "Engine On",
        time = 5000
    },
    ["engine_off"] = {
        type = "success",
        message = "Engine Off",
        time = 5000
    },
    ["cant_install_nitro"] = {
        type = "error",
        message = "Can\'t Install Nitro",
        time = 5000
    },
    ["no_veh_nearby"] = {
        type = "error",
        message = "No Vehicle Nearby",
        time = 5000
    },
    ["cash_display"] = {
        type = "success",
        message = "You have $%s in your pocket.",
        time = 5000
    },
    ["bank_display"] = {
        type = "success",
        message = "You have $%s in your bank.",
        time = 5000
    },
}

Config.Notification = function(message, type, isServer, src) -- You can change here events for notifications
    if isServer then
        if Config.Framework == "esx" then
            TriggerClientEvent('okokNotify:Alert', src, "HUD", message, 3000, type)
        else
            TriggerClientEvent('QBCore:Notify', src, message, type, 1500)
        end
    else
        if Config.Framework == "esx" then
            exports["okokNotify"]:Alert("HUD", message, 3000, type)
        else
            TriggerEvent('QBCore:Notify', message, type, 1500)
        end
    end
end