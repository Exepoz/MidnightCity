local QBCore = exports['qb-core']:GetCoreObject()
--Callback for the cop count.
--Cops need to be on duty for them to count.
QBCore.Functions.CreateCallback('cr-methrun:server:GetCops', function(_, cb)
	local amount = 0
    for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
        for _, job in pairs(Config.Police.PoliceJobs) do
            if v.PlayerData.job.name == job and v.PlayerData.job.onduty then
                amount = amount + 1
            end
        end
    end
    cb(amount)
end)

function MethRunNotify(notifType, message, title)
    if Config.Notifications == 'qb' or 'tnj' then
        if notifType == 1 then
            TriggerClientEvent('QBCore:Notify', source, message, 'success')
        elseif notifType == 2 then
            TriggerClientEvent('QBCore:Notify', source, message, 'primary')
        elseif notifType == 3 then
            TriggerClientEvent('QBCore:Notify', source, message, 'error')
        end
    elseif Config.Notifications == 'okok' then
        if notifType == 1 then
            TriggerClientEvent('okokNotify:Alert', source, title, message, 5000, 'success')
        elseif notifType == 2 then
            TriggerClientEvent('okokNotify:Alert', source, title, message, 5000, 'info')
        elseif notifType == 3 then
            TriggerClientEvent('okokNotify:Alert', source, title, message, 5000, 'error')
        end
    elseif Config.Notifications == 'mythic' then
        if notifType == 1 then
            TriggerClientEvent('mythic_notify:client:SendAlert:custom', source, { type = 'success', text = message, length = 5000})
        elseif notifType == 2 then
            TriggerClientEvent('mythic_notify:client:SendAlert:custom', source, { type = 'inform', text = message, length = 5000})
        elseif notifType == 3 then
            TriggerClientEvent('mythic_notify:client:SendAlert:custom', source, { type = 'error', text = message, length = 5000})
        end
    elseif Config.Notifications == 'chat' then
        TriggerClientEvent('chatMessage', source, message)
    end
end