Config = {}

SD = SD or {}

-- Version Check Settings
Config.CheckForUpdates = true -- true/false -- Should the scripts check for updates? Leaving this as true is recommended for keeping your scripts up-to-date and bug free!
Config.OnlyPrintWhenNew = false -- true/false -- Should the scripts only print messages when there is a new update available? This only applies if Config.CheckForUpdates is also set to true.

-- Logging Settings
Config.EnableLogs = false -- true/false -- If set to true, all functions will log information and send it to a Webhook. If set to false, no logs will be generated. (Make sure to set a Webhook in the logs.lua)
Config.LogTime = 60 -- This is the time interval (in seconds) at which the logs are sent to the webhook. For example, if it is set to 60, the logs will be sent every minute.

-- What type of functions do you want logged?!
Config.LogType = {
    HasItem = false, -- true/false
    AddItem = true, -- true/false
    RemoveItem = true, -- true/false
    AddMoney = true, -- true/false
    RemoveMoney = true, -- true/false
    AddWeapon = true -- true/false
}

-- HasGroup Settings
Config.CheckForDuty = true -- true/false (CURRENTLY ONLY WORKS ON QBCORE) -- When set to true, only players on duty will be included in any HasGroup count.
SD.PoliceJobs = { 'police', --[['bsco', 'sheriff']] } -- List of job identifiers that will be checked during cop count callbacks

-- Police Dispatch Settings
-- ps-dispatch-old refers to versions (of ps-dispatch) below 2.0 (eg. 1.4.3 and downwards)
Config.Dispatch = '' -- ps-dispatch/ps-dispatch-old/linden_outlawalert/cd_dispatch/core_dispatch/qs-dispatch/custom (In client/cl_utils.lua, you can add your own dispatch system into the 'custom' field)
Config.JobTypes = { 'leo', --[['ems']] } -- List of job types that will checked (This concerns only QBCore & 'ps-dispatch')

-- Phone Email Settings
Config.Phone = '' -- qb-phone/lb-phone/qs-smartphone/high-phone/npwd-phone/gks-phone/custom -- This is the phone system that will be used for sending emails (or in some cases, notifications)  (In client/cl_utils.lua, you can add your own phone system into the 'custom' field)

-- Target Options
Config.Targets = {'qtarget', 'qb-target'} -- If you're using 'qb-target' for ex. and have renamed it, update its respective entry in this list!
Config.OXTarget = 'ox_target' -- If you've renamed 'ox_target', update this entry to match the new name.

-- Names for the Core that'll be used to split ESX/QBCore Logic.
Config.CoreNames = {
    QBCore = 'qb-core', -- Edit, if you've renamed qb-core.
    ESX = 'es_extended', -- Edit, if you've renamed es_extended
}

-- Name that sd_lib will check for to then use ox_inventory specific exports.
Config.InvName = {
    OX = 'ox_inventory' -- Edit if you've renamed ox_inventory
}

-- If ox_lib has been imported into sd_lib, you can use the following settings to configure it.
Config.OxLibSettings = {
    EnableMenus = true, -- true/false -- If set to true, the resource will use ox_lib menus for all menus.(Contextual/Input), false will use the built-in menus.
    EnableNotifications = true, -- true/false -- If set to true, the resource will use ox_lib notifications for all notifications, false will use your framework-specific notifications (eg. QBCore.Functions.Notify for ex.)
    EnableProgressBars = true, -- true/false -- If set to true, the resource will use ox_lib progressbars for all progressbars, false will use your framework-specific progressbars (eg. QBCore.Functions.Progressbar for ex.)

    -- Settings for ox_lib menus/progressbars & notifications
    NotificationPos = 'top-right', -- position?: 'top' or 'top-right' or 'top-left' or 'bottom' or 'bottom-right' or 'bottom-left' or 'center-right' or 'center-left'
    ProgressBarType = 'normal', -- normal/circular
    CircularPos = 'bottom' -- position of the circular progressBar: 'middle' or 'bottom'
}