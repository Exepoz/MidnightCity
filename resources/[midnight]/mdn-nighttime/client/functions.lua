local QBCore = exports['qb-core']:GetCoreObject()

Midnight.Functions = {
    --- Checks if it's Night time (9pm-6am)
    ---@return boolean -- Bool ~ it night time?
    IsNightTime = function()
        return (GetClockHours() < 6 or GetClockHours() >= 21)
    end,
    safeJob = function()
        local job = QBCore.Functions.GetPlayerData().job.name
        return Config.SafeJobs[job]
    end,

    Notif = function(text, ttype, lenght)
        QBCore.Functions.Notify(text, ttype, lenght)
    end,

    IsBlacklisted = function()
        local p = promise.new()
        QBCore.Functions.TriggerCallback('mdn-nighttime:IsBlacklisted', function(isBlacklisted)
            p:resolve(isBlacklisted)
        end)
        return p
    end,

    --Debug = function(...) local str = "" for k, v in ipairs({...}) do str = str..tostring(v).." | " end print('^5[DEBUG]^3 '.. str) end,

    Debug = function(...) local str = "" for k, v in ipairs({...}) do if k ~= 1 then str = str.." | " end str = str..tostring(v) end print('^5[DEBUG]^3 '.. str .. "^7") end,

}

exports('Notify', function(text, ttype, lenght) Midnight.Functions.Notif(text, ttype, lenght) end)