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
        TriggerClientEvent('QBCore:Notify', source, message, notifType, timeOut)
    elseif Config.Notify == 'ox' then
        TriggerClientEvent('ox_lib:notify', source, {
            description = message,
            duration = timeOut,
            type = notifType,
            position = 'center-right',
        })
    end
end