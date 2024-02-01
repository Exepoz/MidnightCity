if Config.Framework == nil or Config.Framework == 0 then
    if GetResourceState('qb-core') == 'starting' or GetResourceState('qb-core') == 'started' then
        Config.Framework = 2

        if GetResourceState('qb-bossmenu') == 'starting' or GetResourceState('qb-bossmenu') == 'started' then
            Config.SocietySystem = 2
        end
    
        if GetResourceState('qb-management') == 'starting' or GetResourceState('qb-management') == 'started' then
            Config.SocietySystem = 3
        end
    end
end

if Config.Framework == 2 then
    if Config.FrameworkTriggers['notify'] == '' or string.strtrim(string.lower(Config.FrameworkTriggers['notify'])) == 'qbcore' then
        Config.FrameworkTriggers['notify'] = 'QBCore:Notify'
    end

    if Config.FrameworkTriggers['object'] == '' or string.strtrim(string.lower(Config.FrameworkTriggers['object'])) == 'qbcore' then
        Config.FrameworkTriggers['object'] = 'QBCore:GetObject'
    end

    if Config.FrameworkTriggers['resourceName'] == '' or string.strtrim(string.lower(Config.FrameworkTriggers['resourceName'])) == 'qbcore' then
        Config.FrameworkTriggers['resourceName'] = 'qb-core'
    end
end


CreateThread(function()
    if Config.Framework == 2 then
        local QBCore = Citizen.Await(GetSharedObjectSafe())

        SendNotification = function(source, text)
            TriggerClientEvent(Config.FrameworkTriggers['notify'], source, text)
        end

        GetPlayerMoney = function(source)
            return QBCore.Functions.GetPlayer(source).PlayerData.money.cash
        end

        PlayerHasMoney = function(serverId, amount)
            return GetPlayerMoney(serverId) >= amount
        end

        PlayerTakeMoney = function(source, amount)
            return QBCore.Functions.GetPlayer(source).Functions.RemoveMoney('cash', amount)
        end

        RemoveSocietyMoney = function(jobName, amount)
            if Config.SocietySystem == 2 then
                TriggerEvent('qb-bossmenu:server:removeAccountMoney', jobName, amount)
            elseif Config.SocietySystem == 3 then
                exports['qb-management']:RemoveMoney(jobName, amount)
            end
        end

        AddSocietyMoney = function(jobName, amount)
            if Config.SocietySystem == 2 then
                TriggerEvent('qb-bossmenu:server:addAccountMoney', jobName, amount)
            elseif Config.SocietySystem == 3 then
                return exports['qb-management']:AddMoney(jobName, amount)
            end
        end
    end
end)

