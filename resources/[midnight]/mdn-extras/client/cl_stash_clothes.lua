local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('saveguard:OpenBox', function(name)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", name, {
        maxweight = 700000,
        slots = 50
    })
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "StashOpen", 0.4)
    TriggerEvent("inventory:client:SetCurrentStash", name)
end)

-- Extra Stashes & Clothing

local function OpenStash(name, weight, slots)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", name, {
        maxweight = weight,
        slots = slots
    })
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "StashOpen", 0.4)
    TriggerEvent("inventory:client:SetCurrentStash", name)
end

RegisterNetEvent('mdn-extras:OpenHouseStash', function(id, others)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", 'Housing_' .. id, others)
    TriggerEvent("inventory:client:SetCurrentStash", 'Housing_' .. id)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "StashOpen", 0.4)
end)

RegisterNetEvent('mdn-extras:client:accessclothing', function(data)
    local hasAccess = false
    local PlayerData = QBCore.Functions.GetPlayerData()
    if data.cids then
        for k, v in pairs(data.cids) do
            if PlayerData.citizenid == v then
                hasAccess = true
                break
            end
        end
    end
    if data.gangs and not hasAccess then
        for k, v in pairs(data.gangs) do
            if PlayerData.gang.name == v then
                hasAccess = true
                break
            end
        end
    end
    if data.jobs and not hasAccess then
        for k, v in pairs(data.jobs) do
            if PlayerData.job.name == v then
                hasAccess = true
                break
            end
        end
    end
    if not data.cids and not data.gangs and not data.jobs then hasAccess = true end
    if hasAccess then TriggerEvent('illenium-appearance:client:openOutfitMenu', {false, false}) else QBCore.Functions.Notify('You can\'t access this', 'error') end
end)

RegisterNetEvent('mdn-extras:client:accessStash', function(data)
    local hasAccess = false
    local PlayerData = QBCore.Functions.GetPlayerData()
    if data.cids then
        for _, v in pairs(data.cids) do
            if PlayerData.citizenid == v then
                hasAccess = true
                break
            end
        end
    end
    if data.gangs and not hasAccess then
        for _, v in pairs(data.gangs) do
            if PlayerData.gang.name == v then
                hasAccess = true
                break
            end
        end
    end
    if data.jobs and not hasAccess then
        for _, v in pairs(data.jobs) do
            if PlayerData.job.name == v then
                hasAccess = true
                break
            end
        end
    end
    if not data.cids and not data.gangs and not data.jobs then hasAccess = true end
    if hasAccess then OpenStash(data.sname, Config.Stashes[data.key].maxWeight, Config.Stashes[data.key].slots) else QBCore.Functions.Notify('You can\'t access this', 'error') end
end)


local clocks = {}
Citizen.CreateThread(function()
    for k, v in pairs(Config.Clockins) do
        local onExit = function()
            local job = QBCore.Functions.GetPlayerData().job
            if job.name == k and job.onduty then TriggerServerEvent("QBCore:ToggleDuty") end
        end
        local zone = lib.zones.poly({
            points = v.zone,
            thickness = v.t,
            debug = false,
            onExit = onExit
        })
        if not v.coords then return end
        local p = lib.points.new(v.coords, v.r)
        function p:onEnter()
            if QBCore.Functions.GetPlayerData().job.name ~= k then return end
            exports['qb-core']:DrawText('[E] To Clock In/Out')
        end
        function p:nearby()
            if IsControlJustPressed(0, 38) then
                if QBCore.Functions.GetPlayerData().job.name ~= k then return end
                TriggerServerEvent("QBCore:ToggleDuty")
                exports['qb-core']:HideText()
            end
        end
        function p:onExit()
            exports['qb-core']:HideText()
        end
    end
end)