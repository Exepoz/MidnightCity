Utils = {}

Utils.Notify = function(source, message, notifType, timeOut)
    if Config.Notify == 'qb' then
        TriggerClientEvent('QBCore:Notify', source, message, notifType, timeOut)
    elseif Config.Notify == 'ox' then
        TriggerClientEvent('ox_lib:notify', source, {
            title = Locales['notify_title'],
            description = message,
            duration = timeOut,
            type = notifType,
            position = 'center-right',
        })
    end
end
