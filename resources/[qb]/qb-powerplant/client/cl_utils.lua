Utils = {}

Utils.Notify = function(message, notifType, timeOut)
    if Config.Notify == 'qb' then
        QBCore.Functions.Notify(message, notifType, timeOut)
    elseif Config.Notify == 'ox' then
        lib.notify({
            description = message,
            duration = timeOut,
            type = notifType,
            position = 'center-right',
        })
    end
end
