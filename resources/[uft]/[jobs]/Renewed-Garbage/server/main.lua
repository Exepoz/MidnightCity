local QBCore = exports[Config.CoreName]:GetCoreObject()

local CurrentRuns = {}

local usedPlates = {}


local function Notifications(src, type, msg, group)
    if group then
        exports['qb-phone']:pNotifyGroup(group,
            "Sanitation",
            msg,
            "fas fa-recycle",
            "#2193eb",
            7500
        )
    else
        TriggerClientEvent('QBCore:Notify', src, msg, type)
    end
end


local function RandomPlate()
    local string = "GARB"..QBCore.Shared.RandomInt(4)
    if usedPlates[string] then
        return RandomPlate()
    else
        usedPlates[string] = true
        return string
    end
end


local function SpawnVehicle(carType, location, group, coords)
    local CreateAutomobile = joaat('CREATE_AUTOMOBILE')
    local car = Citizen.InvokeNative(CreateAutomobile, joaat(carType), coords, true, false)

    while not DoesEntityExist(car) do
        Wait(25)
    end

    if Config.RenewedFuel then exports['Renewed-Fuel']:SetFuel(car, 100.0) end
    local NetID = NetworkGetNetworkIdFromEntity(car)
    local plate = RandomPlate()

    SetVehicleNumberPlateText(car, plate)

    local m = exports['qb-phone']:getGroupMembers(group)
    for i=1, #m do
        TriggerClientEvent("Renewed-Garbage:client:NewPlace", m[i], location, NetID, plate)
    end
    return NetID, plate
end

RegisterNetEvent('Renewed-Garbage:server:StartJob', function(run, coords)
    local src = source
    if not run or not coords then return end

    local ped = GetPlayerPed(src)
    if #(GetEntityCoords(ped) - vector3(Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z)) > 5 then return end

    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end
    local group = exports['qb-phone']:GetGroupByMembers(src) or exports['qb-phone']:CreateGroup(src, "Garbage-"..Player.PlayerData.citizenid)

    if not group then return end

    local Size = exports['qb-phone']:getGroupSize(group)

    if Size > Config.GroupLimit then TriggerClientEvent('QBCore:Notify', src, "Your group can only have a maximum of 2 participants for this...", "error") return end

    if exports['qb-phone']:getJobStatus(group) ~= "WAITING" then TriggerClientEvent('QBCore:Notify', src, "Your group is currently busy with a different job...", "error") return end
    if not exports['qb-phone']:isGroupLeader(src, group) then TriggerClientEvent('QBCore:Notify', src, "I cannot give you a job if you're not the group leader...", "error") return end

    if CurrentRuns[group] then TriggerClientEvent('QBCore:Notify', src, "Your group is already doing a run!", "error") return end

    local deliverData = Player.PlayerData.metadata["garbage"] or 0
    if Config.Route[run] > deliverData then TriggerClientEvent('QBCore:Notify', src, "You don't have enough deliveries to do this route!", "error") return end

    local v = Config.StopsAmt
    local maxRuns = run == "small" and math.random(v["small"].min, v["small"].max) or run == "medium" and math.random(v["medium"].min, v["medium"].max) or math.random(v["large"].min, v["large"].max)

    local stop = math.random(1, #Config.Stops)
    local location = Config.Stops[stop]
    local vehicle, plate = SpawnVehicle(Config.GarbageVehicle, location, group, coords)
    if not vehicle or not plate then TriggerClientEvent('QBCore:Notify', src, "Error try again!", "error") return end

    local packages = math.random(Config.Deliver.min, Config.Deliver.max) * Size
    local finalNumber = packages < Config.MaxDeliver and packages or Config.MaxDeliver
    CurrentRuns[group] = {
        status = run,
        runsLeft = maxRuns,
        totalRuns = maxRuns,
        runsDone = 0,
        currentLocation = location,
        Delivered = 0,
        packages = finalNumber,
        car = vehicle,
        plate = plate,
        history = {
            [stop] = true,
        },
        Stages = {
            {name = ("Go to your assigned Zone(s): %s/%s"):format(0, maxRuns), isDone = false, id = 1},
            {name = "Return back to recieve your payment", isDone = false, id = 2}
        }
    }

    exports['qb-phone']:setJobStatus(group, ("Garbage %s Route"):format(run), CurrentRuns[group].Stages)
end)

RegisterNetEvent('Renewed-Garbage:server:CollectCheck', function()
    local src = source

    local group = exports['qb-phone']:GetGroupByMembers(src)

    if not group then return end

    local ped = GetPlayerPed(src)

    if Config.LeaderReturn and not exports['qb-phone']:isGroupLeader(src, group) then TriggerClientEvent('QBCore:Notify', src, "Only your group leader can give say when you're done!", "error") return end

    if #(GetEntityCoords(ped) - vector3(Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z)) > 5 then return end

    local m = exports['qb-phone']:getGroupMembers(group)
    local groupSize = exports['qb-phone']:getGroupSize(group)
    local buff = groupSize >= Config.GroupPayLimit and Config.GroupPay or 0.5
    local pay = ((CurrentRuns[group].Delivered * Config.PriceBrackets[CurrentRuns[group].status]) * buff) / groupSize
    local MetaData = CurrentRuns[group].Delivered / groupSize

    local MaterialCheck = MetaData >= Config.MaterialCheck and math.floor(MetaData / Config.MaterialCheck) or 0

    if not m then return end
    if pay > 0 then
        for i=1, #m do
            if m[i] then
                local xPlayer = QBCore.Functions.GetPlayer(m[i])
                local CID = xPlayer.PlayerData.citizenid
                local deliverData = xPlayer.PlayerData.metadata["garbage"] or 0

                local payBonus = Config.Buffs and Player(src).state.foodBuff == 'luck' and Config.BuffPay or 1
                local final = pay * payBonus

                xPlayer.Functions.SetMetaData('garbage', deliverData + MetaData)
                xPlayer.Functions.AddMoney("bank", final, "Sanitation")

                if Config.MaterialTicket and MaterialCheck > 0 then
                    if Player.Functions.AddItem('matticket', MaterialCheck) then
                        TriggerClientEvent('inventory:client:ItemBox', xPlayer.PlayerData.source, QBCore.Shared.Items['matticket'], "add", MaterialCheck)
                     end
                end

                if Config.RenewedBanking then
                    local name = ("%s %s"):format(xPlayer.PlayerData.charinfo.firstname, PlayexPlayerr.PlayerData.charinfo.lastname)
                    local text = "Sanitation PaySlip for turning in "..CurrentRuns[group].Delivered.." Trash Bags"
                    exports['Renewed-Banking']:handleTransaction(CID, "Sanitation", final, text, "Los Santos Sanitation", name, "deposit")
                end

                TriggerClientEvent('Renewed-Garbage:client:ResetClient', m[i])
            end
        end
    else
        for i=1, #m do
            if m[i] then
                TriggerClientEvent('Renewed-Garbage:client:ResetClient', m[i])
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


RegisterNetEvent('Renewed-Garbage:server:MaterialTrade', function(material)
    if not Config.MaterialTicket then return end

    local src = source
    if not Config.Trade[material] then return end

    local coords = GetEntityCoords(GetPlayerPed(src))

    if #(coords - vector3(Config.PedLocation.x, Config.PedLocation.y,Config.PedLocation.z)) > 5 then return end

    local Player = QBCore.Functions.GetPlayer(src)
    if not Player.Functions.GetItemByName("matticket") then return end
    if not QBCore.Shared.Items[material] then return end
    if not QBCore.Shared.Items["matticket"] then return end

    if Player.Functions.AddItem(material, Config.Trade[material]) then
        TriggerClientEvent('inventory:client:ItemBox', Player.PlayerData.source, QBCore.Shared.Items[material], "add", Config.Trade[material])

        Player.Functions.RemoveItem('matticket', 1)
        TriggerClientEvent('inventory:client:ItemBox', Player.PlayerData.source, QBCore.Shared.Items['matticket'], "remove", 1)
    end
end)

QBCore.Functions.CreateCallback("Renewed-Garbage:server:DeliverPackage", function(source, cb, Shop)
    local src = source

    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local group = exports['qb-phone']:GetGroupByMembers(src)

    if not group then return cb(false) end

    local vehCoords = GetEntityCoords(NetworkGetEntityFromNetworkId(CurrentRuns[group].car))

    if #(coords - vehCoords) > 10 then return cb(false) end
    CurrentRuns[group].Delivered = CurrentRuns[group].Delivered + 1
    if CurrentRuns[group].packages <= 0 then
        CurrentRuns[group].runsLeft = CurrentRuns[group].runsLeft - 1
        CurrentRuns[group].runsDone = CurrentRuns[group].runsDone + 1
        if CurrentRuns[group].runsLeft <= 0 then
            local m = exports['qb-phone']:getGroupMembers(group)
            for i=1, #m do
                TriggerClientEvent('Renewed-Garbage:client:JobDone', m[i])
            end

            CurrentRuns[group].Stages = {
                {name = ("Go to your assigned Zone(s): %s/%s"):format(CurrentRuns[group].runsDone, CurrentRuns[group].totalRuns), isDone = true, id = 1},
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

            CurrentRuns[group].Stages = {
                {name = ("Go to your assigned Zone(s): %s/%s"):format(CurrentRuns[group].runsDone, CurrentRuns[group].totalRuns), isDone = false, id = 1},
                {name = "Return back to recieve your payment", isDone = false, id = 2}
            }

            local m = exports['qb-phone']:getGroupMembers(group)
            for i=1, #m do
                TriggerClientEvent('Renewed-Garbage:client:NewPlace', m[i], location)
            end
            Notifications(_, _, "Delivery complete for this location headover to the next!", group)
        end
    end

    if Shop then
        TriggerEvent('qb-shops:server:RestockShopItems', Shop)
    end

    exports['qb-phone']:setJobStatus(group, ("Garbage %s Route"):format(CurrentRuns[group].status), CurrentRuns[group].Stages)

    cb(true)
end)



QBCore.Functions.CreateCallback('Renewed-Garbage:server:CanGrabPackage', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    local group = exports['qb-phone']:GetGroupByMembers(src)

    if not group or not CurrentRuns[group] then return cb(false) end

    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)

    if #(coords - CurrentRuns[group].currentLocation) > 200 then return cb(false) end

    if CurrentRuns[group].packages <= 0 then
        cb(false)
    else
        CurrentRuns[group].packages = CurrentRuns[group].packages - 1
        cb(true)

        if CurrentRuns[group].packages == 0 then
            Notifications(_, _, "Last garbage bag", group)
        else
            Notifications(_, _, ("%s Garbage bags left"):format(CurrentRuns[group].packages), group)
        end
    end
end)

AddEventHandler('qb-phone:server:GroupDeleted', function(group, players)
    if not CurrentRuns[group] then return end
    if CurrentRuns[group].plate then usedPlates[CurrentRuns[group].plate] = nil end
    CurrentRuns[group] = nil
    for i=1, #players do
        TriggerClientEvent("Renewed-Garbage:client:ResetClient", players[i])
    end
end)
