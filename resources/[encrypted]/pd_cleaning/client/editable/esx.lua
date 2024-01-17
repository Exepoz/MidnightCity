if Config.framework == 'esx' then
    ESX = nil
    isPlayerCleaner = false

    Citizen.CreateThread(function()
        if Config.useNewESXExport then
            ESX = exports["es_extended"]:getSharedObject()
        else
            Citizen.CreateThread(function()
                while ESX == nil do
                    TriggerEvent('esx:getSharedObject', function(obj)
                        ESX = obj
                    end)
                    Citizen.Wait(0)
                end
            end)
        end

        if ESX.IsPlayerLoaded() then
            Citizen.Wait(100)
            TriggerServerEvent('pd_cleaning:syncPlayer')

            if IsCleaner() or not Config.cleanerJob.jobOnly and #blips == 0  then
                CreateBlips()

                Citizen.Wait(5000)
                if Config.debug then
                    print('Blips Created', json.encode(blips))
                end
            end
        end

        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end

        ESX.PlayerData = ESX.GetPlayerData()
    end)

    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function(job)
        ESX.PlayerData.job = job
        Citizen.Wait(100)

        if IsCleaner() or not Config.cleanerJob.jobOnly and #blips == 0 then
            Citizen.Wait(5000)
            if Config.debug then
                print('Blips Created', json.encode(blips))
            end

            CreateBlips()
        else
            RemoveAllBlips()
        end
    end)

    function IsCleaner()
        local job = ESX.GetPlayerData().job
        while job == nil do
            Wait(100)
        end

        if Contains(Config.cleanerJob.jobNames, job.name) then
            isPlayerCleaner = true
        else
            isPlayerCleaner = false
        end

        return isPlayerCleaner
    end
end

function Contains(list, x)
    for _, v in pairs(list) do
        if v == x then
            return true
        end
    end
    return false
end

--ILFK