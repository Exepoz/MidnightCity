local QBCore = exports['qb-core']:GetCoreObject()

local CurrentRuns = {}

local usedPlates = {}

local function Notifications(src, type, msg, group)
    if group then
        exports['qb-phone']:pNotifyGroup(group,
            "PostOP Delivery",
            msg,
            "fas fa-truck",
            "#2193eb",
            7500
        )
    else
        TriggerClientEvent('QBCore:Notify', src, msg, type)
    end
end

local function RandomPlate()
    local string = "POST"..QBCore.Shared.RandomInt(4)
    if usedPlates[string] then
        return RandomPlate()
    else
        usedPlates[string] = true
        return string
    end
end

local function SpawnVehicle(carType, location, group, coords)
    local car = CreateVehicle(joaat(carType), coords.x, coords.y, coords.z, coords.w, true, false)

    while not DoesEntityExist(car) do
        Wait(25)
    end

    if Config.RenewedFuel then exports['Renewed-Fuel']:SetFuel(car, 100.0) end
    local NetID = NetworkGetNetworkIdFromEntity(car)
    local plate = RandomPlate()

    SetVehicleNumberPlateText(car, plate)

    local m = exports['qb-phone']:getGroupMembers(group)
    for i=1, #m do
        TriggerClientEvent("Renewed-Deliveries:client:NewPlace", m[i], location, NetID, plate)
    end
    return NetID, plate
end

RegisterNetEvent('Renewed-Deliveries:server:StartJob', function(run, coords)
    local src = source

    if not run or not coords then return end

    local ped = GetPlayerPed(src)
    local pedCoords = GetEntityCoords(ped)

    if #(pedCoords - vector3(Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z)) > 5 then return end

    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end
    local group = exports['qb-phone']:GetGroupByMembers(src) or exports['qb-phone']:CreateGroup(src, "PostOP-"..Player.PlayerData.citizenid)

    if not group then return end

    local groupSize = exports['qb-phone']:getGroupSize(group)

    if groupSize > Config.MaxMembers then TriggerClientEvent('QBCore:Notify', src, "Your group cannot have more than "..Config.MaxMembers.." Group Members for this job!", "error") return end

    if exports['qb-phone']:getJobStatus(group) ~= "WAITING" then TriggerClientEvent('QBCore:Notify', src, "Your group is currently busy with a different job...", "error") return end
    if not exports['qb-phone']:isGroupLeader(src, group) then TriggerClientEvent('QBCore:Notify', src, "I cannot give you a job if you're not the group leader...", "error") return end

    if CurrentRuns[group] then TriggerClientEvent('QBCore:Notify', src, "Your group is already doing a run!", "error") return end

    local deliverData = Player.PlayerData.metadata["delivery"] or 0
    if Config.Route[run] > deliverData then TriggerClientEvent('QBCore:Notify', src, "You don't have enough deliveries to do this route!", "error") return end
    local placeHolder = run == "small" and "boxville4" or run == "medium" and "boxville4" or "pounder"

    local v = Config.StopsAmt
    local maxRuns = run == "small" and math.random(v["small"].min, v["small"].max) or run == "medium" and math.random(v["medium"].min, v["medium"].max) or math.random(v["large"].min, v["large"].max)

    local stop = math.random(1, #Config.Stops)
    local location = Config.Stops[stop]
    local vehicle, plate = SpawnVehicle(placeHolder, location, group, coords)
    if not vehicle or not plate then TriggerClientEvent('QBCore:Notify', src, "Error try again!", "error") return end

    local packages = math.random(Config.Deliver.min, Config.Deliver.max) * groupSize
    local finalNumber = packages < Config.MaxDeliver and packages or Config.MaxDeliver

    CurrentRuns[group] = {
        status = run,
        runsLeft = maxRuns,
        totalRuns = maxRuns,
        runsDone = 0,
        currentLocation = location,
        Delivered = 0,
        packages = finalNumber,
        collected = 0,
        car = vehicle,
        plate = plate,
        history = {
            [stop] = true,
        },
        Stages = {
            {name = ("Go to Delivery Points %s/%s"):format(0, maxRuns), isDone = false, id = 1},
            {name = "Return back to recieve your payment", isDone = false, id = 2}
        }
    }

    exports['qb-phone']:setJobStatus(group, ("Post OP %s Deliver"):format(run), CurrentRuns[group].Stages)
end)

RegisterNetEvent('Renewed-Deliveries:server:CollectCheck', function()
    local src = source

    local group = exports['qb-phone']:GetGroupByMembers(src)

    if not group then return end

    local ped = GetPlayerPed(src)

    if Config.LeaderReturn and not exports['qb-phone']:isGroupLeader(src, group) then TriggerClientEvent('QBCore:Notify', src, "Only your group leader can give say when you're done!", "error") return end

    if #(GetEntityCoords(ped) - vector3(Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z)) > 5 then return end

    local m = exports['qb-phone']:getGroupMembers(group)
    local groupSize = exports['qb-phone']:getGroupSize(group)

    if groupSize > Config.MaxMembers then return end

    local buff = groupSize >= Config.GroupPayLimit and Config.GroupPay or 1.0
    local pay = ((CurrentRuns[group].Delivered * Config.PriceBrackets[CurrentRuns[group].status]) * buff) / groupSize
    local MetaData = CurrentRuns[group].Delivered / groupSize

    if not m then return end
    if pay > 0 then
        for i=1, #m do
            if m[i] then
                local Player = QBCore.Functions.GetPlayer(m[i])
                local CID = Player.PlayerData.citizenid
                local deliverData = Player.PlayerData.metadata["delivery"] or 0

                local payBonus = Config.Buffs and exports[Config.BuffExport]:HasBuff(CID, Config.BuffType) and Config.BuffPay or 1.0
                local final = pay * payBonus

                Player.Functions.SetMetaData('delivery', deliverData + MetaData)
                Player.Functions.AddMoney("bank", final, "PostOP Delivery")

                if Config.RenewedBanking then
                    local name = ("%s %s"):format(Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname)
                    local text = "PostOP PaySlip for delivering "..CurrentRuns[group].Delivered.." Packages"
                    exports['Renewed-Banking']:handleTransaction(CID, "PostOP Delivery", final, text, "PostOP", name, "deposit")
                end

                TriggerClientEvent('Renewed-Deliveries:client:ResetClient', m[i])
            end
        end
    else
        for i=1, #m do
            if m[i] then
                TriggerClientEvent('Renewed-Deliveries:client:ResetClient', m[i])
            end
        end
    end

    DeleteEntity(NetworkGetEntityFromNetworkId(CurrentRuns[group].car))
    usedPlates[CurrentRuns[group].plate] = nil
    CurrentRuns[group] = nil

    if exports['qb-phone']:isGroupTemp(group) then
        exports['qb-phone']:DestroyGroup(group)
    else
        exports['qb-phone']:resetJobStatus(group)
    end
end)


QBCore.Functions.CreateCallback("Renewed-Deliveries:server:DeliverPackage", function(source, cb, Shop)
    local src = source

    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)

    local group = exports['qb-phone']:GetGroupByMembers(src)

    if not group then return cb(false) end

    if #(coords - CurrentRuns[group].currentLocation) > 5 then return cb(false) end
    CurrentRuns[group].Delivered += 1

    if (CurrentRuns[group].packages-CurrentRuns[group].collected) < 1 and CurrentRuns[group].collected == CurrentRuns[group].Delivered then
        CurrentRuns[group].runsLeft = CurrentRuns[group].runsLeft - 1
        CurrentRuns[group].runsDone = CurrentRuns[group].runsDone + 1
        if CurrentRuns[group].runsLeft == 0 then
            local m = exports['qb-phone']:getGroupMembers(group)
            for i=1, #m do
                TriggerClientEvent('Renewed-Deliveries:client:JobDone', m[i])
            end

            CurrentRuns[group].Stages = {
                {name = ("Go to Delivery Points %s/%s"):format(CurrentRuns[group].runsDone, CurrentRuns[group].totalRuns), isDone = true, id = 1},
                {name = "Return back to recieve your payment", isDone = false, id = 2}
            }

            Notifications(_, _, "Delivery Complete return to get your payslip", group)
        else
            local stop = math.random(1, #Config.Stops)
            while CurrentRuns[group].history[stop] do
                stop = math.random(1, #Config.Stops)
                Wait(10)
            end
            local location = Config.Stops[stop]
            CurrentRuns[group].history[stop] = true

            CurrentRuns[group].currentLocation = location

            local packages = math.random(Config.Deliver.min, Config.Deliver.max) * exports['qb-phone']:getGroupSize(group)
            local finalNumber = packages < Config.MaxDeliver and packages or Config.MaxDeliver

            CurrentRuns[group].packages = finalNumber
            CurrentRuns[group].collected = 0
            CurrentRuns[group].Delivered = 0

            CurrentRuns[group].Stages = {
                {name = ("Go to Delivery Points %s/%s"):format(CurrentRuns[group].runsDone, CurrentRuns[group].totalRuns), isDone = false, id = 1},
                {name = "Return back to recieve your payment", isDone = false, id = 2}
            }

            local m = exports['qb-phone']:getGroupMembers(group)
            for i=1, #m do
                TriggerClientEvent('Renewed-Deliveries:client:NewPlace', m[i], location)
            end
            Notifications(_, _, "Delivery complete for this location headover to the next!", group)
        end
    end

    if Shop then
         TriggerEvent('qb-shops:server:RestockShopItems', Shop)
    end

    exports['qb-phone']:setJobStatus(group, ("Post OP %s Deliver"):format(CurrentRuns[group].status), CurrentRuns[group].Stages)

    cb(true)
end)


QBCore.Functions.CreateCallback('Renewed-Deliveries:server:CanGrabPackage', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local group = exports['qb-phone']:GetGroupByMembers(src)
    if not group or not CurrentRuns[group] then return cb(false) end

    if CurrentRuns[group].collected >= CurrentRuns[group].packages then return cb(false) end
    local NetID = CurrentRuns[group].car
    if not NetID then return cb(false) end

    local vehicle = NetworkGetEntityFromNetworkId(NetID)
    local ped = GetPlayerPed(src)
    if #(GetEntityCoords(vehicle) - GetEntityCoords(ped)) > 15.0 then return cb(false) end

    CurrentRuns[group].collected += 1
    cb(true)
    local remaining = CurrentRuns[group].packages-CurrentRuns[group].collected
    if remaining == 1 then
        Notifications(_, _, "Last package for this location", group)
    elseif  remaining == 0 then
        Notifications(_, _, "No packages remaining", group)
    else
        Notifications(_, _, ("%s Packages Left"):format(remaining), group)
    end
end)

AddEventHandler('qb-phone:server:GroupDeleted', function(group, players)
    if not CurrentRuns[group] then return end
    if CurrentRuns[group].plate then usedPlates[CurrentRuns[group].plate] = nil end
    CurrentRuns[group] = nil
    for i=1, #players do
        TriggerClientEvent("Renewed-Deliveries:client:ResetClient", players[i])
    end
end)
