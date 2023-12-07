QBCore = exports['qb-core']:GetCoreObject()
PlayerData = QBCore.Functions.GetPlayerData()

local effectActive = false
local buffActive = false

--- Functions

--- Method to apply drugged screen effect if not active
--- @return nil
local drugEffect = function()
    if effectActive then return end
    effectActive = true
    StartScreenEffect('DrugsTrevorClownsFightIn', 3.0, 0)
    Wait(3000)
    StartScreenEffect('DrugsTrevorClownsFight', 3.0, 0)
    Wait(3000)
    StartScreenEffect('DrugsTrevorClownsFightOut', 3.0, 0)
    StopScreenEffect('DrugsTrevorClownsFight')
    StopScreenEffect('DrugsTrevorClownsFightIn')
    StopScreenEffect('DrugsTrevorClownsFightOut')
    effectActive = false
end

--- Start/Stop Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    PlayerData = QBCore.Functions.GetPlayerData()
end)

--- Events

RegisterNetEvent('qb-drugsystem:client:MakeBaggies', function(drug)
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, 'PROP_HUMAN_PARKING_METER', 0, true)
    QBCore.Functions.Progressbar('druglabs_makebaggies', _U('making_smaller_bags'), 6000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(ped)
        TriggerServerEvent('qb-drugsystem:server:MakeBaggies', drug)
    end, function() -- Cancel
        ClearPedTasks(ped)
        QBCore.Functions.Notify(_U('canceled'), 'error', 2500)
    end)
end)

RegisterNetEvent('qb-drugsystem:client:UseMethBag', function(purity)
    QBCore.Functions.Progressbar('smoke_meth', _U('smoking_meth'), math.random(5000, 8000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'switch@trevor@trev_smoking_meth',
        anim = 'trev_smoking_meth_loop',
        flags = 49,
    }, {
        model = 'prop_cs_crackpipe',
        bone = 28422,
        rotation = { x = 0.0, y = 180.0, z = 0.0 }
    }, {}, function() -- Done
        if not buffActive and purity >= Shared.BuffPurityRequired then
            CreateThread(function()
                buffActive = true
                local ped = PlayerPedId()
                local startTimer = Shared.BuffDuration
                while startTimer > 0 do
                    Wait(1000)
                    RestorePlayerStamina(PlayerId(), 1.0)
                    local armour = GetPedArmour(ped)
                    if armour + Shared.BuffArmourPerSecond <= 100 then
                        SetPedArmour(ped, GetPedArmour(ped) + Shared.BuffArmourPerSecond)
                    end
                    startTimer -= 1
                end
                buffActive = false
            end)
        end
        drugEffect()
    end, function() -- Cancel
        QBCore.Functions.Notify(_U('canceled'), 'error', 2500)
	end)
end)

RegisterNetEvent('qb-drugsystem:client:UseCokeBag', function(purity)
    QBCore.Functions.Progressbar('snort_coke', _U('snorting_coke'), math.random(5000, 8000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'switch@trevor@trev_smoking_meth',
        anim = 'trev_smoking_meth_loop',
        flags = 49,
    }, {}, {}, function() -- Done
        if not buffActive and purity >= Shared.BuffPurityRequired then
            CreateThread(function()
                buffActive = true
                local ped = PlayerPedId()
                local startTimer = Shared.BuffDuration
                SetRunSprintMultiplierForPlayer(PlayerId(), Shared.BuffSprintMultiplier)
                while startTimer > 0 do
                    Wait(1000)
                    RestorePlayerStamina(PlayerId(), 1.0)
                    startTimer -= 1
                end
                SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
                buffActive = false
            end)
        end
        drugEffect()
    end, function() -- Cancel
        QBCore.Functions.Notify(_U('canceled'), 'error', 2500)
	end)
end)
