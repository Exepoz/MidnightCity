local QBCore = exports['qb-core']:GetCoreObject()

--- Custom SQL
function CustomsSQL(plugin,type,query,var)
    if type == 'fetchAll' and plugin == 'mysql-async' then
        local result = MySQL.Sync.fetchAll(query, var)
        return result
    end
    if type == 'execute' and plugin == 'mysql-async' then
        MySQL.Sync.execute(query,var)
    end
    if type == 'execute' and plugin == 'ghmattisql' then
        exports['ghmattimysql']:execute(query, var)
    end
    if type == 'fetchAll' and plugin == 'ghmattisql' then
        local data = nil
        exports.ghmattimysql:execute(query, var, function(result)
            data = result
        end)
        while data == nil do Wait(0) end
        return data
    end
    if type == 'execute' and plugin == 'oxmysql' then
        exports.oxmysql:execute(query, var)
    end
    if type == 'fetchAll' and plugin == 'oxmysql' then
        local result = exports.oxmysql:fetchSync(query, var)
        return result
    end
end exports(CustomsSQL, 'CustomsSQL')

RegisterConsoleListener(function(channel, message)
    local logStr = {}
    if string.find(message, "[eE][rR][rR][oO][rR]") then -- Error Catch
        if channel == "script:pac" and string.find(message, "Socket") then return end
        logStr.status = "Error"
        logStr.description = message
        logStr.resource = channel
        lib.logger("Console", "Script Error", logStr, "script_error")

    elseif string.find(message, "server thread hitch") then -- Server Thread
        if GetConvarInt("svMainLogs", 0) == 0 then return end
        local mms = tonumber(string.sub(tostring(message), 48, #message-13))
        logStr.status = "Info"
        logStr.description = message
        logStr.resource = channel
        logStr.ServerHitchDuration = mms
        logStr.title = mms.."mms"
        lib.logger("Console", "Server Hitch Warning", logStr, "server_hitch")

    elseif string.find(message, "sync thread hitch") then -- Sync Thread
        if GetConvarInt("svSyncLogs", 0) == 0 then return end
        local mms = tonumber(string.sub(tostring(message), 46, #message-13))
        logStr.status = "Info"
        logStr.description = message
        logStr.resource = channel
        logStr.SyncHitchDuration = mms
        logStr.title = mms.."mms"
        lib.logger("Console", "Sync Hitch Warning", logStr, "sync_hitch")

    elseif string.find(message, "network thread hitch") then -- Network Thread
        if GetConvarInt("svNetLogs", 0) == 0 then return end
        local mms = tonumber(string.sub(tostring(message), 49, #message-13))
        logStr.status = "Info"
        logStr.description = message
        logStr.resource = channel
        logStr.NetworkHitchDuration = mms
        logStr.title = mms.."mms"
        lib.logger("Console", "Network Hitch Warning", logStr, "network_hitch")
        
    elseif string.find(message, "[wW][aR][rR][nN][iN][nN][gG]%a*")   then --Warnings
        if string.find(message, "could not find") or string.find(message, "Started resource") then return end
        logStr.status = "Warn"
        logStr.description = message
        logStr.resource = channel
        lib.logger("Console", "Script Warning", logStr, "script_warning")
    end
end)