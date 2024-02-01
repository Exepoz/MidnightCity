if Config.Framework == nil or Config.Framework == 0 then
    if GetResourceState('es_extended') == 'starting' or GetResourceState('es_extended') == 'started' then
        Config.Framework = 1
        if GetResourceState('esx_addonaccount') == 'starting' or GetResourceState('esx_addonaccount') == 'started' then
            Config.SocietySystem = 1
        end
    end
end

if Config.Framework == 1 then
    if Config.FrameworkTriggers['notify'] == '' or string.strtrim(string.lower(Config.FrameworkTriggers['notify'])) == 'esx' then
        Config.FrameworkTriggers['notify'] = 'esx:showNotification'
    end

    if Config.FrameworkTriggers['object'] == '' or string.strtrim(string.lower(Config.FrameworkTriggers['object'])) == 'esx' then
        Config.FrameworkTriggers['object'] = 'esx:getSharedObject'
    end

    if Config.FrameworkTriggers['resourceName'] == '' or string.strtrim(string.lower(Config.FrameworkTriggers['resourceName'])) == 'esx' then
        Config.FrameworkTriggers['resourceName'] = 'es_extended'
    end
end

CreateThread(function()
    if Config.Framework == 1 then
        local ESX = Citizen.Await(GetSharedObjectSafe())

        SendNotification = function(source, text)
            TriggerClientEvent(Config.FrameworkTriggers['notify'], source, text)
        end

        GetPlayerMoney = function(source)
            return ESX.GetPlayerFromId(source).getMoney()
        end
        
        PlayerHasMoney = function(serverId, amount)
            return GetPlayerMoney(serverId) >= amount
        end

        PlayerTakeMoney = function(source, amount)
            return ESX.GetPlayerFromId(source).removeMoney(amount)
        end

        RemoveSocietyMoney = function(jobName, amount)
            if Config.SocietySystem == 1 then
                TriggerEvent('esx_addonaccount:getSharedAccount', Config.SocietyPrefix..jobName, function(account)
                    account.removeMoney(amount)
                end)
            end
        end

        AddSocietyMoney = function(jobName, amount)
            if Config.SocietySystem == 1 then
                TriggerEvent('esx_addonaccount:getSharedAccount', Config.SocietyPrefix..jobName, function(account)
                    if account ~= nil then
                        account.addMoney(amount)
                    end
                end)
            end
        end
    end
end)
