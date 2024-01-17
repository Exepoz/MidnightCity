local QBCore = exports['qb-core']:GetCoreObject()

local doinJob = false -- Boolean to decide weather or not we doing job

local function GetSpawn()
    for _, v in pairs(Config.CarSpawns) do
        if not IsAnyVehicleNearPoint(v.x, v.y, v.z, 8.0) then
            return v
        end
    end
end

RegisterNetEvent('Renewed-Deliveries:client:clientChecks', function(data)
    local coords = GetSpawn()

    if not coords then return QBCore.Functions.Notify("There's a car in the way...", 'error', 7500) end

    TriggerServerEvent('Renewed-Deliveries:server:StartJob', data.size, coords)
end)


RegisterNetEvent('Renewed-Deliveries:client:RequestJob', function()
    local menu = {}
    local PlayerData = QBCore.Functions.GetPlayerData()
    local data = PlayerData.metadata["delivery"]
    menu[#menu+1] = {
        header = "Small Route",
        txt = ("Get a route with %s-%s Delivery Locations"):format(Config.StopsAmt["small"].min, Config.StopsAmt["small"].max),
        icon = "fa-solid fa-user",
        disabled = data and data < Config.Route["small"],
        params = {
            event = "Renewed-Deliveries:client:clientChecks",
            args = {
                size = "small",
            }
        }
    }
    menu[#menu+1] = {
        header = "Medium Route",
        txt = ("Get a route with %s-%s Delivery Locations"):format(Config.StopsAmt["medium"].min, Config.StopsAmt["medium"].max),
        icon = "fa-solid fa-user",
        disabled = data and data < Config.Route["medium"],
        params = {
            event = "Renewed-Deliveries:client:clientChecks",
            args = {
                size = "medium",
            }
        }
    }
    menu[#menu+1] = {
        header = "Large Route",
        txt = ("Get a route with %s-%s Delivery Locations"):format(Config.StopsAmt["large"].min, Config.StopsAmt["large"].max),
        icon = "fa-solid fa-user",
        disabled = data and data < Config.Route["large"],
        params = {
            event = "Renewed-Deliveries:client:clientChecks",
            args = {
                size = "large",
            }
        }
    }

    exports[Config.Menu]:openMenu(menu)
end)

RegisterNetEvent('Renewed-Deliveries:client:OpenMainMenu', function()
    local menu = {
        {
            header = "Delivery Man",
            isMenuHeader = true,
            icon = "fa-solid fa-circle-exclamation",
        }
    }

    if doinJob then
        menu[#menu+1] = {
            header = "Get Paid",
            txt = "Collect any pending Paychecks",
            icon = "fa-solid fa-truck-arrow-right",
            params = {
                isServer = true,
                event = "Renewed-Deliveries:server:CollectCheck",
            }
        }
    else
        menu[#menu+1] = {
            header = "Request Job",
            txt = "Request a Delivery Job",
            icon = "fa-solid fa-truck-arrow-right",
            params = {
                event = "Renewed-Deliveries:client:RequestJob",
            }
        }
    end

    menu[#menu+1] = {
        header = "Exit",
        icon = "fa-solid fa-circle-xmark",
        params = {
            event = "qb-menu:client:closeMenu",
        }
    }

    exports[Config.Menu]:openMenu(menu)
end)












local CachedNet = nil -- NetID Handler from serverside.
local blip = nil -- Blip Handler
local pZone = nil -- PolyZone
local listen = false -- Listen for key presses
local curLocation = nil -- Current location
local prop = nil -- just the prop shit

local function Listen4Control()
    listen = true
    CreateThread(function()
        while listen do
            if IsControlJustPressed(0, 38) and prop then
                listen = false
                TriggerEvent('Renewed-Deliveries:client:DeliverPackage')
            end
            Wait(1)
        end
    end)
end

RegisterNetEvent('Renewed-Deliveries:client:NewPlace', function(location, NetID, plate)
    if NetID and plate then
        CachedNet = NetID
        local vehicle = NetToVeh(NetID)
        if not Config.RenewedFuel then exports['cdn-fuel']:SetFuel(vehicle, 100.0) end
        TriggerServerEvent("qb-vehiclekeys:server:AcquireVehicleKeys", plate)
    end

    curLocation = location

    if blip then RemoveBlip(blip) end
    if pZone then exports['qb-core']:HideText() pZone:destroy() listen = false pZone = nil end
    if not doinJob then doinJob = true end

    blip = AddBlipForCoord(curLocation)
    SetBlipSprite(blip, 50)
    SetBlipScale(blip, 1.0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Drop Off")
    EndTextCommandSetBlipName(blip)
    SetBlipColour(blip, 28)
    SetBlipRoute(blip, true)

    pZone = CircleZone:Create(curLocation, 1.5, {
        name="Deliver_ZonePostOP",
        useZ = true,
        debugPoly = false,
    })

    pZone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            if prop == nil then return end
            exports['qb-core']:DrawText("[E] Deliver Package",'left')
            Listen4Control()
        else
            listen = false
            exports['qb-core']:HideText()
        end
    end)
end)

local jobDone = false
RegisterNetEvent('Renewed-Deliveries:client:JobDone', function()
    if pZone then exports['qb-core']:HideText() pZone:destroy() listen = false pZone = nil end
    if blip then RemoveBlip(blip) blip = nil end
    jobDone = true
    curLocation = vector3(-427.09, -2785.91, 6.0)
    blip = AddBlipForCoord(curLocation)
    SetBlipSprite(blip, 67)
    SetBlipScale(blip, 1.0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Return Truck")
    EndTextCommandSetBlipName(blip)
    SetBlipColour(blip, 28)
    SetBlipRoute(blip, true)
end)

RegisterNetEvent('Renewed-Deliveries:client:ResetClient', function()
    if pZone then exports['qb-core']:HideText() pZone:destroy() listen = false pZone = nil end
    if blip then RemoveBlip(blip) blip = nil end
    jobDone = false

    CachedNet = nil
    curLocation = nil
    prop = nil
    doinJob = false
end)


-- Just a funciton that gets the distance from the cars trunk, this way I can actually get accurate targets instead of using SHIITY bone targets --
local function canTakePackage(car)
    local coords, _ = GetModelDimensions(GetEntityModel(car))
    local tempCoords = GetOffsetFromEntityInWorldCoords(car, 0.0, coords.y - 0.5, 0.0)

    return #(tempCoords - GetEntityCoords(PlayerPedId())) <= 1.0
end
local postPed = nil

CreateThread(function()
    local mainBlip = AddBlipForCoord(Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z)
    SetBlipSprite(mainBlip, 616)
    SetBlipDisplay(mainBlip, 4)
    SetBlipScale(mainBlip, 1.0)
    SetBlipAsShortRange(mainBlip, true)
    SetBlipColour(mainBlip, 24)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Delivery")
    EndTextCommandSetBlipName(mainBlip)

    Wait(2500) -- QB target sometimes dosnt load it straight away and fucks it up, so I just wait a bit.

    local model = joaat(Config.Ped)
    local coords = Config.PedLocation

    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    postPed = CreatePed(0, model, coords.x, coords.y, coords.z-1, coords.w, false, false)
    TaskStartScenarioInPlace(postPed, 'WORLD_HUMAN_AA_COFFEE', 0, true)
    FreezeEntityPosition(postPed, true)
    SetEntityInvincible(postPed, true)
    SetBlockingOfNonTemporaryEvents(postPed, true)

    if lib then
        exports.ox_target:addLocalEntity(postPed, {{
            name = 'renewed_deliveries_mainped',
            event = 'Renewed-Deliveries:client:OpenMainMenu',
            icon = 'fa-solid fa-cubes',
            label = 'PostOP Delivery',
            canInteract = function(entity, distance)
                return distance < 2.5 and true or false
            end
        }})
        exports.ox_target:addGlobalVehicle({
            {
                name = 'renewed_deliveries_vehiclecontrol',
                event = 'Renewed-Deliveries:client:TakePackage',
                icon = 'fas fa-box',
                label = 'Take Package',
                canInteract = function(entity, distance)
                    if distance > 1.5 then return false end
                    if not doinJob then return false end
                    if jobDone then return false end
                    if GetEntityModel(entity) ~= joaat("boxville2") and GetEntityModel(entity) ~= joaat("pounder") then return false end
                    if GetVehicleDoorLockStatus(entity) ~= 1 then return false end
                    if prop then return false end
                    if GetVehicleEngineHealth(entity) <= 0 then return false end
                    if #(GetEntityCoords(PlayerPedId()) - curLocation) > 60.0 then return false end
                    return canTakePackage(entity)
                end
            }
        })
    else
        exports['qb-target']:AddTargetEntity(postPed, {
            options = {
                {
                    event = "Renewed-Deliveries:client:OpenMainMenu",
                    icon = 'fa-solid fa-cubes',
                    label = 'PostOP Delivery',
                },
            },
            distance = 2.5,
        })

        exports['qb-target']:AddGlobalVehicle({
            options = {
            {
                type = "client",
                event = "Renewed-Deliveries:client:TakePackage",
                icon = 'fas fa-box',
                label = 'Take Package',
                canInteract = function(entity)
                    if not doinJob then return false end
                    if jobDone then return false end
                    if GetEntityModel(entity) ~= joaat("boxville2") and GetEntityModel(entity) ~= joaat("pounder") then return false end
                    if GetVehicleDoorLockStatus(entity) ~= 1 then return false end
                    if prop then return false end
                    if GetVehicleEngineHealth(entity) <= 0 then return false end
                    if #(GetEntityCoords(PlayerPedId()) - curLocation) > 60.0 then return false end
                    return canTakePackage(entity)
                end,
            }
            },
            distance = 1.0,
        })
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if lib then
            exports.ox_target:removeGlobalVehicle({'renewed_deliveries_vehiclecontrol'})
            exports.ox_target:removeLocalEntity(postPed, {'renewed_deliveries_mainped'})
        else
            exports['qb-target']:RemoveTargetEntity(postPed, {'renewed_deliveries_mainped'})
        end
        DeleteEntity(postPed)
    end
end)



local randomTable = {
    "pack1",
    "pack2",
    "pack3",
}


RegisterNetEvent('Renewed-Deliveries:client:TakePackage', function()
    if prop then return end
    QBCore.Functions.TriggerCallback('Renewed-Deliveries:server:CanGrabPackage', function(result)
        if result then
            local model = `hei_prop_heist_box`
            loadModel(model)
            prop = CreateObject(model, GetEntityCoords(PlayerPedId()), true)
            Wait(50)
            PickUp()
        end
    end, CachedNet)
end)

local function GetShop()
    local coords = GetEntityCoords(PlayerPedId())
    if not coords then return nil end
    for k, v in pairs(Config.Locations) do
        if v and v["coords"] then
            if #(coords - vector3(v["coords"].x, v["coords"].y, v["coords"].z)) <= 15.0 then
                return k
            end
        end
    end
    return nil
end

RegisterNetEvent('Renewed-Deliveries:client:DeliverPackage', function()
    local shop = GetShop()
    QBCore.Functions.TriggerCallback('Renewed-Deliveries:server:DeliverPackage', function(result)
        if result then
            Drop()
            prop = nil
        end
    end, shop)
end)


function PickUp()
    loadAnimDict('anim@heists@box_carry@')
    DisableControls()
    CreateThread(function()
        while prop ~= nil do 
            if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
                TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
            end
            if not IsEntityAttachedToEntity(prop, PlayerPedId()) then  AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xEB95), 0.075, -0.09, 0.257, -130.0, 105.0, 0.0, true, true, false, false, 0, true) end
            Wait(1000)
        end
    end)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

function loadModel(model)
    while (not HasModelLoaded(model)) do
        RequestModel(model)
        Wait(5)
    end
end

function Drop()
    ClearPedTasks(PlayerPedId())
    DeleteObject(prop)
end

function DisableControls()
    CreateThread(function()
        while prop ~= nil do 
            DisableControlAction(0, 21, true) -- Sprinting
            DisableControlAction(0, 22, true) -- Jumping
            DisableControlAction(0, 23, true) -- Vehicle Entering
            DisableControlAction(0, 36, true) -- Ctrl
            DisableControlAction(0, 24, true) -- disable attack
            DisableControlAction(0, 25, true) -- disable aim
            DisableControlAction(0, 47, true) -- disable weapon
            DisableControlAction(0, 58, true) -- disable weapon
            DisableControlAction(0, 263, true) -- disable melee
            DisableControlAction(0, 264, true) -- disable melee
            DisableControlAction(0, 257, true) -- disable melee
            DisableControlAction(0, 140, true) -- disable melee
            DisableControlAction(0, 141, true) -- disable melee
            DisableControlAction(0, 142, true) -- disable melee
            DisableControlAction(0, 143, true) -- disable melee
            Wait(1)
        end
    end)
end