Utils = {}

Utils.PhoneNotification = function(message, timeOut)
    if Shared.Phone == 'QBCore' then
        TriggerEvent('qb-phone:client:CustomNotification', Locales['phone_current'], message, 'fas fa-car', '#F9FF5E', timeOut)
    elseif Shared.Phone == 'GKS' then
        exports['gksphone']:SendNotification({
            title = Locales['phone_current'], 
            message = message, 
            img= '/html/static/img/icons/messages.png', 
            duration = timeOut
        })
    elseif Shared.Phone == 'Qs' then
        TriggerEvent('qs-smartphone:client:notify', {
            title = Locales['phone_current'],
            text = message,
            icon = './img/apps/whatsapp.png',
            timeout = timeOut
        })
    elseif Shared.Phone == 'lb-phone' then
        exports['lb-phone']:SendNotification({
            app = 'Messages',
            title = Locales['phone_current'],
            content = message,
        })
    end
end
