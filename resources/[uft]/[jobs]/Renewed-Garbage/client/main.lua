local QBCore = exports[Config.CoreName]:GetCoreObject()

local doinJob = false -- Boolean to decide weather or not we doing job

local function GetSpawn()
    for _, v in pairs(Config.CarSpawns) do
        if not IsAnyVehicleNearPoint(v.x, v.y, v.z, 4) then
            return v
        end
    end
end

local function LoadAnimation(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end
end

RegisterNetEvent('Renewed-Garbage:client:clientChecks', function(data)
    local coords = GetSpawn()

    if not coords then return QBCore.Functions.Notify("There's a car in the way...", 'error', 7500) end

    TriggerServerEvent('Renewed-Garbage:server:StartJob', data.size, coords)
end)

RegisterNetEvent('Renewed-Garbage:client:MaterialTrade', function()
    local menu = {}
    local hasItem = QBCore.Functions.HasItem("matticket")

    for k, v in pairs(Config.Trade) do
        menu[#menu+1] = {
            header = ("Trade 1x voucher for %s %s"):format(v, QBCore.Shared.Items[k].label),
            icon = "fa-solid fa-recycle",
            disabled = not hasItem,
            params = {
                isServer = true,
                event = "Renewed-Garbage:server:MaterialTrade",
                args = k,
            }
        }
    end

    exports[Config.Menu]:openMenu(menu)
end)


RegisterNetEvent('Renewed-Garbage:client:RequestJob', function()
    local menu = {}
    local PlayerData = QBCore.Functions.GetPlayerData()
    local data = PlayerData.metadata["garbage"]
    menu[#menu+1] = {
        header = "Small Route",
        txt = ("Get a route with %s-%s Delivery Locations"):format(Config.StopsAmt["small"].min, Config.StopsAmt["small"].max),
        icon = "fa-solid fa-user",
        disabled = data and data < Config.Route["small"],
        params = {
            event = "Renewed-Garbage:client:clientChecks",
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
            event = "Renewed-Garbage:client:clientChecks",
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
            event = "Renewed-Garbage:client:clientChecks",
            args = {
                size = "large",
            }
        }
    }

    exports[Config.Menu]:openMenu(menu)
end)

RegisterNetEvent('Renewed-Garbage:client:OpenMainMenu', function()
    local menu = {
        {
            header = "Eddie the Garbage Man",
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
                event = "Renewed-Garbage:server:CollectCheck",
            }
        }
    else
        menu[#menu+1] = {
            header = "Request Job",
            txt = "Request a Garbage Route",
            icon = "fa-solid fa-truck-arrow-right",
            params = {
                event = "Renewed-Garbage:client:RequestJob",
            }
        }
    end

    if Config.MaterialTicket then
        menu[#menu+1] = {
            header = "Trade Vouchers",
            txt = "Trade your vouchers for some left over materials",
            icon = "fa-solid fa-clipboard-list",
            params = {
                event = "Renewed-Garbage:client:MaterialTrade",
            }
        }
    end

    menu[#menu+1] = {
        header = "Exit",
        icon = "fa-solid fa-circle-xmark",
        params = {
            event = "ps-ui:client:closeMenu",
        }
    }

    exports[Config.Menu]:openMenu(menu)
end)

















local CachedNet = nil -- NetID Handler from serverside.
local blip = nil -- Blip Handler
local curLocation = nil -- Current location
local prop = nil -- just the prop shit
local Looted = {} -- Looted locations

local mainBlip = nil -- Just the location of the garbage job
local looting = false

local function TakeGarbage(entity)
    QBCore.Functions.TriggerCallback('Renewed-Garbage:server:CanGrabPackage', function(result)
        if result then
            Looted[entity] = true
            local ped = PlayerPedId()
            if entity then
                TaskTurnPedToFaceEntity(ped, entity, 500)
                Wait(500)
            end
            looting = true
            QBCore.Functions.Progressbar('RenewedGarbage', 'Grabbing Garbage...', math.random(1500, 3000), false, false, { -- Name | Label | Time | useWhileDead | canCancel
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                anim = "machinic_loop_mechandplayer",
                flags = 16,
            }, {}, {}, function() -- Play When Done
                LoadAnimation('missfbi4prepp1')
                TaskPlayAnim(ped, 'missfbi4prepp1', '_bag_walk_garbage_man', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
                prop = CreateObject(`prop_cs_rub_binbag_01`, 0, 0, 0, true, true, true)
                AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 57005), 0.12, 0.0, -0.05, 220.0, 120.0, 0.0, true, true, false, true, 1, true)
                ClearPedTasks(ped)
                looting = false
            end, function() -- Play When Cancel
                QBCore.Functions.Notify('Cancelled...', 'error', 7500)
                looting = false
                ClearPedTasks(ped)
            end)
        end
    end)
end

RegisterNetEvent('Renewed-Garbage:client:NewPlace', function(location, NetID, plate)
    if NetID and plate then
        CachedNet = NetID
        local vehicle = NetToVeh(NetID)
        if not Config.RenewedFuel then exports['Legacy-Fuel']:SetFuel(vehicle, 100.0) end
        TriggerServerEvent("qb-vehiclekeys:server:AcquireVehicleKeys", plate)
    end

    curLocation = location


    Looted = {}
    if blip then RemoveBlip(blip) end
    if not doinJob then doinJob = true end

    blip = AddBlipForRadius(curLocation.x, curLocation.y, curLocation.z, 200.0)
    SetBlipAlpha(blip, 150)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, true)


end)

RegisterNetEvent('Renewed-Garbage:client:JobDone', function()
    if blip then RemoveBlip(blip) blip = nil end

    SetNewWaypoint(Config.PedLocation.x, Config.PedLocation.y)
end)

RegisterNetEvent('Renewed-Garbage:client:ResetClient', function()
    if blip then RemoveBlip(blip) blip = nil end
    looting = false
    CachedNet = nil
    curLocation = nil
    prop = nil
    doinJob = false
end)


-- Just a funciton that gets the distance from the cars trunk, this way I can actually get accurate targets instead of using SHIITY bone targets --
local function canDeliverPackage(car)
    local coords, _ = GetModelDimensions(GetEntityModel(car))
    local tempCoords =  GetOffsetFromEntityInWorldCoords(car, 0.0, coords.y - 0.5, 0.0)
    return #(tempCoords - GetEntityCoords(PlayerPedId())) <= 2.3
end

CreateThread(function()

    mainBlip = AddBlipForCoord(Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z)
    SetBlipSprite(mainBlip, 318)
    SetBlipDisplay(mainBlip, 4)
    SetBlipScale(mainBlip, 1.0)
    SetBlipAsShortRange(mainBlip, true)
    SetBlipColour(mainBlip, 39)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Sanitation")
    EndTextCommandSetBlipName(mainBlip)

    exports['qb-target']:AddGlobalVehicle({
        options = {
          {
            type = "client",
            event = "Renewed-Garbage:client:DeliverPackage",
            icon = 'fas fa-box',
            label = 'Put Garbage in Truck',
            canInteract = function(entity)
                if not doinJob then return false end
                if not CachedNet then return false end
                if GetEntityModel(entity) ~= joaat(Config.GarbageVehicle) then return false end
                if GetVehicleDoorLockStatus(entity) ~= 1 then return false end
                if not prop then return false end
                if GetVehicleEngineHealth(entity) <= 0 then return false end
                if entity ~= NetworkGetEntityFromNetworkId(CachedNet) then return false end
                if GetVehicleDoorAngleRatio(entity, 5) <= 0 then return false end
                if #(GetEntityCoords(PlayerPedId()) - vector3(curLocation.x, curLocation.y, curLocation.z)) > 200.0 then return false end
                return canDeliverPackage(entity)
            end,
          }
        },
        distance = 1.0,
    })

    exports['qb-target']:SpawnPed({
        model = Config.Ped,
        coords = Config.PedLocation,
        minusOne = true,
        freeze = true,
        invincible = true,
        blockevents = true,
        scenario = 'WORLD_HUMAN_AA_COFFEE',
        target = {
            options = {
                {
                    event = "Renewed-Garbage:client:OpenMainMenu",
                    icon = 'fa-solid fa-cubes',
                    label = 'Talk to Eddie',
                }
            },
            distance = 2.5,
        },
    })

      exports['qb-target']:AddTargetModel(Config.Target, {
        options = {
          {
            label = "Grab Garbage",
            icon = 'fa-solid fa-trash',
            action = function(entity) TakeGarbage(entity) end,
            canInteract = function(entity)
                if not doinJob then print("not doing job") return false end
                if prop then print("prop attatched") return false end
                if looting then return end
                if not curLocation then print("No locations") return false end
                if Looted and Looted[entity] then print("entity taken") return false end
                return #(GetEntityCoords(entity) - vector3(curLocation.x, curLocation.y, curLocation.z)) < 200.0
            end,
          }
        },
        distance = 1.5,
      })
end)






local function DeliverAnim(ped)
    LoadAnimation('missfbi4prepp1')
    TaskPlayAnim(ped, 'missfbi4prepp1', '_bag_throw_garbage_man', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
    FreezeEntityPosition(ped, true)
    canTakeBag = false
    SetTimeout(1250, function()
        DetachEntity(garbageObject, 1, false)
        DeleteObject(garbageObject)
        TaskPlayAnim(ped, 'missfbi4prepp1', 'exit', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
        FreezeEntityPosition(ped, false)
        garbageObject = nil
        canTakeBag = true
    end)
end

RegisterNetEvent('Renewed-Garbage:client:DeliverPackage', function()
    local ped = PlayerPedId()
    TaskTurnPedToFaceEntity(ped, NetToVeh(CachedNet), 500)
    Wait(500)
    DeliverAnim(ped)
    QBCore.Functions.Progressbar('RenewedGarbage33', 'Throwing Trash in Trashmaster', 1500, false, false, { -- Name | Label | Time | useWhileDead | canCancel
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Play When Done
        ClearPedTasks(ped)
        QBCore.Functions.TriggerCallback('Renewed-Garbage:server:DeliverPackage', function(result)
            if result then
                DeleteEntity(prop)
                prop = nil
            end
        end)
    end, function() -- Play When Cancel
        ClearPedTasks(ped)
        QBCore.Functions.Notify('Cancelled...', 'error', 7500)
    end)
end)


AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
      if prop then
        DeleteEntity(prop)
      end
   end
end)