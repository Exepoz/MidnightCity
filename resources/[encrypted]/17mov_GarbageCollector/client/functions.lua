local Core

Config.Framework = "STANDALONE"

CreateThread(function()
    Citizen.Wait(2500)
    if Core == nil or Config.UseBuiltInNotifications then
        RegisterNetEvent('17mov_DrawDefaultNotification'..GetCurrentResourceName(), function(msg)
            Notify(msg)
        end)
        
        if Core == nil then
            TriggerEvent("esx:getSharedObject", function(obj)
                Core = obj
                Config.Framework = "ESX"
            end)

            Citizen.Wait(5000)
            if Core == nil then
                InitalizeScript()
            end
        end
    end
end)

TriggerEvent("__cfx_export_qb-core_GetCoreObject", function(getCore)
    Core = getCore()
    Config.Framework = "QBCore"
end)

TriggerEvent("__cfx_export_es_extended_getSharedObject", function(getCore)
    Core = getCore()
    Config.Framework = "ESX"
end)

function onBagDetach(entity) 
    -- Here u can do some custom events on bag detach
end

function onBagPickup(entity) 
    -- Another function for devs
end

function GetClosestVehicle(coords)
    if Config.Framework == "QBCore" then
        return Core.Functions.GetClosestVehicle(coords)
    elseif Config.Framework == "ESX" then
        return Core.Game.GetClosestVehicle(coords)
    else
        local vehicles = GetGamePool('CVehicle')
        local closestDst = 200.0
        local closestVeh = 0
        for k,v in pairs(vehicles) do
            local distance = #(GetEntityCoords(v) - GetEntityCoords(PlayerPedId())) 
            if distance < closestDst then
                closestDst = distance
                closestVeh = v
            end
        end
        
        return closestVeh
    end
end

function GetPlayerData()
    if Config.Framework == "QBCore" then
        return Core.Functions.GetPlayerData()
    elseif Config.Framework == "ESX" then
        return Core.GetPlayerData()
    else
        return {job = {name = "unknown", grade = 0}}
    end
end

function DeleteVehicleByCore(vehicle)
    if Config.Framework == "QBCore" then
        Core.Functions.DeleteVehicle(vehicle)
    elseif Config.Framework == "ESX" then
        Core.Game.DeleteVehicle(vehicle)
    else 
        SetEntityAsMissionEntity(vehicle, false, true)
        DeleteVehicle(vehicle)
    end
end

function Notify(msg)
    if Config.UseBuiltInNotifications and Config.useModernUI then
        local type = "good"
        if CheckIfNotificationIsWrong(msg) then
            type = "wrong"
        end

        SendNUIMessage({
            action = "showNotification",
            type = type,
            msg = msg
        })
    else
        if Config.Framework == "QBCore" then
            Core.Functions.Notify(msg)
        elseif Config.Framework == "ESX" then
            Core.ShowNotification(msg)
        else
            SetNotificationTextEntry('STRING')
            AddTextComponentString(msg)
            DrawNotification(0,1)
        end
    end
end

function SetVehicle(vehicle)

    -- Setup here your vehicle keys, fuel etc..

    if Config.Framework == "QBCore" then
        exports['cdn-fuel']:SetFuel(vehicle, 100.0)
        TriggerEvent("vehiclekeys:client:SetOwner", Core.Functions.GetPlate(vehicle))
    elseif Config.Framework == "ESX" then

    else

    end
end

function PrepeareVehicle()
    -- Before Vehicle spawn
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.030+ factor, 0.03, 0, 0, 0, 150)
end

function ShowHelpNotification(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function ChangeClothes(type) 

    if Config.Framework ~= "QBCore" and Config.Framework ~= "ESX" then
        print("CANNOT CHANGE CLOTHES, PLEASE CONFIGURE UR CLOTHES SYSTEM IN /Client/Functions.lua file.")
        return
    end

    RequestAnimDict("clothingshirt")
    while not HasAnimDictLoaded("clothingshirt") do Citizen.Wait(0) end

    local PlayerPed = PlayerPedId()
    TaskPlayAnim(PlayerPed, "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    Citizen.Wait(1000)
    if type == "work" then
        if GetEntityModel(PlayerPedId()) == 1885233650 then
            for k,v in pairs(Config.realClothes.male) do
                SetPedComponentVariation(PlayerPed, v["component_id"], v["drawable"], v["texture"], 0)
            end
        else
            for k,v in pairs(Config.realClothes.female) do
                SetPedComponentVariation(PlayerPed, v["component_id"], v["drawable"], v["texture"], 0)
            end
        end
    else 
        if Config.Framework == "QBCore" then
            TriggerServerEvent('qb-clothes:loadPlayerSkin')
        elseif Config.Framework == "ESX" then
            Core.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        end

        TriggerEvent("fivem-appearance:client:reloadSkin")
        TriggerEvent("fivem-appearance:ReloadSkin")
        TriggerEvent("illenium-appearance:client:reloadSkin")
        TriggerEvent("illenium-appearance:ReloadSkin")
    end
    Citizen.Wait(1000)
    ClearPedTasks(PlayerPed)
end

function CheckIfNotificationIsWrong(text)
    local arrayName
    for k,v in pairs(Config.Lang) do
        if v == text then
            arrayName = k
            break
        end
    end

    return Config.WrongNotifications[arrayName] or false
end

Config.WrongNotifications = {
    ["no_permission"] = true,
    ["too_far"] = true,
    ["alreadyWorking"] = true,
    ["cantSpawnVeh"] = true,
    ["full"] = true,
    ["wrongCar"] = true,
    ["CarNeeded"] = true,
    ["nobodyNearby"] = true,
    ["cantInvite"] = true,
    ["spawnpointOccupied"] = true,
    ["notFullJob"] = true,
    ["notADriver"] = true,
    ["wrongReward1"] = true,
    ["wrongReward2"] = true,
    ["partyIsFull"] = true,
    ["isAlreadyHost"] = true,
    ["isBusy"] = true,
    ["hasActiveInvite"] = true,
    ["HaveActiveInvite"] = true,
    ["InviteDeclined"] = true,
    ["error"] = true,
    ["kickedOut"] = true,
    ["RequireOneFriend"] = true,
    ["penalty"] = true,
    ["clientsPenalty"] = true,
    ["dontHaveReqItem"] = true,
    ["notEverybodyHasRequiredJob"] = true,
}

Config.realClothes = {
    male = {},
    female = {},
}

local componentIdTranslation = {
    ["mask"] = 1,
    ["arms"] = 3,
    ["pants"] = 4,
    ["bag"] = 5,
    ["shoes"] = 6,
    ["t-shirt"] = 8,
    ["torso"] = 11,
    ["decals"] = 10,
    ["kevlar"] = 9,
}

for k,v in pairs(Config.Clothes.male) do
    table.insert(Config.realClothes.male, {component_id = componentIdTranslation[k], drawable = v.clotheId, texture = v.variation})
end

for k,v in pairs(Config.Clothes.female) do
    table.insert(Config.realClothes.female, {component_id = componentIdTranslation[k], drawable = v.clotheId, texture = v.variation})
end