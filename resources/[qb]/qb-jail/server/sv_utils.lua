Utils = {}

Utils.PlayerIsLeo = function(Job)
    -- return Job.name == 'police' and Job.onduty
    return Job.type == 'leo' and Job.onduty
end

Utils.GetCopCount = function()
    local amount = 0
    local players = QBCore.Functions.GetQBPlayers()

    for _, Player in pairs(players) do
        if Utils.PlayerIsLeo(Player.PlayerData.job) then
            amount += 1
        end
    end

    return amount
end

Utils.Notify = function(source, message, notifType, timeOut)
    if Config.Notify == 'qb' then
        QBCore.Functions.Notify(source, message, notifType, timeOut)
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

Utils.DoorUpdate = function(source, doorId, state)
    if Config.Doorlock == 'ox' then
        state = state and 1 or 0
        TriggerEvent('ox_doorlock:setState', exports['ox_doorlock']:getDoorFromName(doorId).id, 0)
    elseif Config.Doorlock == 'qb' then
        TriggerEvent('qb-doorlock:server:updateState', doorId, false, false, false, true, false, false, source)
    end
end

Utils.CreateLog = function(source, event, title, message)
    if Config.Logs == 'ox' then
        lib.logger(source, event, message)
    elseif Config.Logs == 'qb' then
        TriggerEvent('qb-log:server:CreateLog', event, title, 'default', message)
    end
end
