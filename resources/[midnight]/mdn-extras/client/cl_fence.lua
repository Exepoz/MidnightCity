local QBCore = exports['qb-core']:GetCoreObject()

local spawnedPeds = {}

-- Time Check

RegisterNetEvent('sd-fence:client:TimeCheck', function()
    local hours = GetClockHours()
    -- print(hours)
    if hours >= Config.Fence.Time.max or hours <= Config.Fence.Time.min then
        TriggerServerEvent('malmo-fence:server:sellItems')
    else
        QBCore.Functions.Notify("Wait till it gets a bit darker..", "error")
    end
end)

-- Blip Creation

CreateThread(function()
    if Config.Fence.Blip.Enable then
        local blip = AddBlipForCoord(Config.Fence.Blip.Location)
        SetBlipSprite(blip, Config.Fence.Blip.Sprite)
        SetBlipDisplay(blip, Config.Fence.Blip.Display)
        SetBlipScale(blip, Config.Fence.Blip.Scale)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, Config.Fence.Blip.Colour)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Fence.Blip.Name)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Ped Creation

Citizen.CreateThread(function()
    for i, fence in pairs(Config.Fence.NPC) do
        local hash = GetHashKey(fence.model)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(100)
        end
    
        fence.ped = CreatePed(0, hash, fence.location, false, false)
        SetEntityAsMissionEntity(fence.ped, true, true)
        FreezeEntityPosition(fence.ped, true)
        SetEntityInvincible(fence.ped, true)
        SetBlockingOfNonTemporaryEvents(fence.ped, true)
        SetEntityHeading(fence.ped, fence.heading)
        exports['qb-target']:AddTargetEntity(Config.Fence.NPC[i].ped, {
            options = {
                {
                    icon = "fas fa-hand",
                    label = 'Sell to Fence',
                    canInteract = function()
                        return true
                    end,
                    action = function()
                        TriggerEvent('sd-fence:client:TimeCheck')
                    end
                }
            },
            distance = 3.0
        })
    end
end)