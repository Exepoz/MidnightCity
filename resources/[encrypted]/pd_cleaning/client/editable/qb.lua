if Config.framework == 'qbcore' then
    Citizen.CreateThread(function()
        job = nil
        isPlayerCleaner = false

        QBCore = exports['qb-core']:GetCoreObject()
        job = QBCore.Functions.GetPlayerData().job

        if QBCore.Functions.GetPlayerData() and QBCore.Functions.GetPlayerData().job then
            job = QBCore.Functions.GetPlayerData().job
            Wait(200)
            if IsCleaner() or not Config.cleanerJob.jobOnly then
                CreateBlips()
            end
        end

        RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
        AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
            TriggerServerEvent('pd_cleaning:syncPlayer')
            Citizen.Wait(200)
            job = QBCore.Functions.GetPlayerData().job

            if IsCleaner() or not Config.cleanerJob.jobOnly and #blips == 0 then
                CreateBlips()
            end
        end)

        RegisterNetEvent('QBCore:Client:OnJobUpdate')
        AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
            job = JobInfo

            Citizen.Wait(200)

            if #blips == 0 then
                CreateBlips()
            end

            if not IsCleaner() then
                RemoveAllBlips()
            end
        end)
    end)

    function IsCleaner()
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
