FSUtils = {}
-- Server-sided Notification Matrix
---@param notifType number - Type of Notification Shown (1 = Success, 2 = Info, 3 = Failure)
---@param message string - Message Sent
---@param title string - Message Title (If Applicable)
---@param serversource? number -- Sent if source is needed.
function FSUtils.Notif(notifType, message, title, serversource)
    local src = source
    if serversource then src = serversource end

    local notif = Config.Framework.Notifications
    local nType
    if notifType == 1 then
        nType = "success"
    elseif notifType == 2 then
        if notif == "qb" or notif == "tnj" or notif == "oxlib" then
            nType = "primary"
        elseif notif == "okok" or notif == "ESX" then
            nType = "info"
        elseif notif == "mythic" then
            nType = "inform"
        end
    elseif notifType == 3 then
        nType = "error"
    end
	if Config.Framework.Notifications == 'qb' or Config.Framework.Notifications == 'tnj' then
        TriggerClientEvent('QBCore:Notify', src, message, nType)
	elseif Config.Framework.Notifications == "okok" then
        TriggerClientEvent('okokNotify:Alert', src, title, message, 5000, nType)
	elseif Config.Framework.Notifications == "mythic" then
        TriggerClientEvent('mythic_notify:client:SendAlert:custom', src, { type = nType, text = message, length = 5000})
	elseif Config.Framework.Notifications == 'chat' then
		TriggerClientEvent('chatMessage', src, message)
    elseif Config.Framework.Notifications == "oxlib" then
        TriggerClientEvent('cr-fleecabankrobbery:client:Notify', src, nType, message, title)
    elseif Config.Framework.Notifications == "ESX" then
        TriggerClientEvent('esx:showNotification', src, message, nType)
--luacheck: push ignore
	elseif Config.Framework.Notifications == 'other' then
		--You can add any notification system here.
	end
--luacheck: pop
end