Utils = {}

Utils.Notify = function(source, message, notifType, timeOut)
    if Shared.Notify == 'qb' then
        TriggerClientEvent('QBCore:Notify', source, message, notifType, timeOut)
    elseif Shared.Notify == 'ox' then
        TriggerClientEvent('ox_lib:notify', source, {
            title = Locales['phone_current'],
            description = message,
            duration = timeOut,
            type = notifType,
            position = 'center-right',
        })
    end
end

Utils.PhoneNotification = function(source, message, timeOut)
    if Shared.Phone == 'QBCore' then
        TriggerClientEvent('qb-phone:client:CustomNotification', source, Locales['phone_current'], message, 'fas fa-car', '#ff002f', timeOut)
    elseif Shared.Phone == 'GKS' then
        exports["gksphone"]:SendNotification(source, {
            title = Locales['phone_current'], 
            message = message, 
            img = '/html/static/img/icons/messages.png', 
            duration = timeOut
        })
    elseif Shared.Phone == 'Qs' then
        TriggerClientEvent('qs-smartphone:client:notify', source, {
            title = Locales['phone_current'],
            text = message,
            icon = "./img/apps/whatsapp.png",
            timeout = timeOut
        })
    elseif Shared.Phone == 'lb-phone' then
        exports["lb-phone"]:SendNotification(source, {
            app = "Messages",
            title = Locales['phone_current'],
            content = message,
            --icon = "https://www.example.com/photo.jpg", -- the icon of the notification (optional)
        })
    end
end

Utils.PhoneMail = function(source, citizenid, firstName, vehicle, plate)
    if Shared.Phone == 'QBCore' then
        -- Older, using event
        TriggerEvent('qb-phone:server:sendNewMailToOffline', citizenid, {
            sender = Shared.MailAuthor,
            subject = Shared.MailTitle,
            message = 'Hey ' .. firstName .. ', I need you to pick up a ' .. vehicle .. ' for me.. Plate: ' .. plate
        })

        -- Recent, using export
        -- exports['qb-phone']:sendNewMailToOffline(citizenid, {
        --     sender = Shared.MailAuthor,
        --     subject = Shared.MailTitle,
        --     message = 'Hey ' .. firstName .. ', I need you to pick up a ' .. vehicle .. ' for me.. Plate: ' .. plate
        -- })
    elseif Shared.Phone == 'GKS' then
        exports["gksphone"]:SendNewMail(source, {
            sender = Shared.MailAuthor,
            image = '/html/static/img/icons/mail.png',
            subject = Shared.MailTitle,
            message = 'Hey ' .. firstName .. ', I need you to pick up a ' .. vehicle .. ' for me.. Plate: ' .. plate
        })
    elseif Shared.Phone == 'Qs' then
        TriggerEvent('qs-smartphone:server:sendNewMailToOffline', citizenid, {
            sender = Shared.MailAuthor,
            subject = Shared.MailTitle,
            message = 'Hey ' .. firstName .. ', I need you to pick up a ' .. vehicle .. ' for me.. Plate: ' .. plate
        })
    elseif Shared.Phone == 'lb-phone' then
        local number = exports["lb-phone"]:GetEquippedPhoneNumber(source)
        local mail = exports["lb-phone"]:GetEmailAddress(number)

        exports["lb-phone"]:SendMail({
            to = mail,
            subject = Shared.MailTitle,
            message = 'Hey ' .. firstName .. ', I need you to pick up a ' .. vehicle .. ' for me.. Plate: ' .. plate,
        })
    end
end

Utils.CreateLog = function(logType, title, message)
    TriggerEvent("qb-log:server:CreateLog", logType, title, message)
end
