local QBCore = exports['qb-core']:GetCoreObject()
local ele, goingDown

RegisterCommand("createelevator", function()
    TriggerServerEvent('mdn-extras:server:elev')
end)

RegisterCommand("goup", function()
    TriggerServerEvent('mdn-extras:server:goUp')
end)

RegisterCommand("godown", function()
    TriggerServerEvent('mdn-extras:server:goDown')
end)

RegisterNetEvent('mdn-extras:client:goUp', function()
    CreateThread(function()
        local obj = ele
        --local obj = GetClosestObjectOfType(vector3(-158.70, -942.10, 28.7), 2.0, GetHashKey('prop_conslift_lift'), 0, 0, 0)
        if not obj or obj == 0 then return end
        local ecoords = GetEntityCoords(obj)
        local eZ = ecoords.z
        while true do
            if eZ < 270.3 then
                --SetEntityHeading(object, entHeading - 0.5)
                --SetEntityCoords(obj, ecoords.x, ecoords.y, eZ + 0.015)
                SetEntityCoords(obj, ecoords.x, ecoords.y, eZ + 0.02)
                --eZ = eZ + 0.015
                eZ = eZ + 0.2
                if goingDown then break end
            else break end
            Wait(1)
        end
    end)
end)

RegisterNetEvent('mdn-extras:client:goDown', function()
    CreateThread(function()
        local obj = ele
        --local obj = GetClosestObjectOfType(vector3(-158.70, -942.10, 270.3), 2.0, GetHashKey('prop_conslift_lift'), 0, 0, 0)
        if not obj or obj == 0 then return end
        local ecoords = GetEntityCoords(obj)
        local eZ = ecoords.z
        goingDown = true
        while true do
            if eZ > 28.7+2.7 then
                --SetEntityHeading(object, entHeading - 0.5)
                SetEntityCoords(obj, ecoords.x, ecoords.y, eZ - 0.02)
                eZ = eZ - 0.02
            else break end
            Wait(1)
        end
    end)
end)

RegisterNetEvent('mdn-extras:client:elev', function()
    --'prop_conslift_lift'
    --'prop_dock_crane_lift'
    LoadModel('prop_conslift_lift')
    ele = CreateObject(GetHashKey('prop_conslift_lift'), vector3(-158.75, -942.20, 28.6), 0, 0, 0, 0)
    SetEntityHeading(ele, 160.0)
    FreezeEntityPosition(ele, true)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
       DeleteEntity(ele)
    end
 end)

