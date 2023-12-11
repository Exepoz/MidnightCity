local QBCore = exports['qb-core']:GetCoreObject()

local contracts = {}

--- Functions

--- Prints a message in debug format
---@param string - Message to print
---@return nil
local debugPrint = function(...)
    if type(...) ~= 'string' then return end
    print('^3[qb-chopshop] ^5' .. ... .. '^7')
end

--- Returns a random license plate and checks for duplicates
---@return generatePlate string - Unique license plate
local generatePlate = function()
    local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
    local result = MySQL.Sync.fetchScalar('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })

    if result then
        return generatePlate()
    else
        return plate:upper()
    end
end

--- Events

RegisterNetEvent('qb-chopshop:server:RequestContract', function(sentSource)
    local src = sentSource
    if type(sentSource) == 'table' then src = source end
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local citizenid = Player.PlayerData.citizenid

    -- Check if already has a contract
    if contracts[citizenid] then
        Utils.Notify(src, Locales['already_have'], 'error', 5000)
        return
    end

    -- Create new contract
    local model = Shared.Vehicles[math.random(#Shared.Vehicles)]
    local location = Shared.Locations[math.random(#Shared.Locations)]
    local dropOff = Shared.DropOffLocations[math.random(#Shared.DropOffLocations)]
    local plate = generatePlate()

    local tempVehicle = CreateVehicle(model, 0, 0, 0, 0, true, true)
    while not DoesEntityExist(tempVehicle) do Wait(0) end

    local vehicleType = GetVehicleType(tempVehicle)
    DeleteEntity(tempVehicle)

    local vehicle = CreateVehicleServerSetter(model, vehicleType, location.x, location.y, location.z, location.w)
    while not DoesEntityExist(vehicle) do Wait(0) end
    SetVehicleNumberPlateText(vehicle, plate)

    -- if math.random(100) < Shared.LaptopChance then
    --     local glovebox = 'glove' .. plate
    --     exports['ox_inventory']:AddItem(glovebox, 'boostinglaptop', 1)
    -- end

    contracts[citizenid] = {
        model = model,
        location = location,
        dropOff = dropOff,
        plate = plate,
        vehicle = vehicle,
        state = 0
    }

    -- Send New Contract
    Utils.PhoneNotification(src, Locales['phone_wait'], 6000)

    SetTimeout(Shared.Time * 60 * 1000, function()
        -- Send out mail
        Utils.PhoneMail(src, Player.PlayerData.citizenid, Player.PlayerData.charinfo.firstname, QBCore.Shared.Vehicles[model].brand .. ' ' .. QBCore.Shared.Vehicles[model].name, plate)

        debugPrint(citizenid .. ' Received new contract')

        TriggerClientEvent('qb-chopshop:client:ReceiveNewContract', src, model, plate, location, dropOff, false)
    end)
end)

RegisterNetEvent('qb-chopshop:server:ChopVehicle', function(netId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local citizenid = Player.PlayerData.citizenid
    local ped = GetPlayerPed(src)
    local vehicle = NetworkGetEntityFromNetworkId(netId)

    if vehicle ~= contracts[citizenid].vehicle then return end
    if #(contracts[citizenid].dropOff - GetEntityCoords(vehicle)) > 5.0 then return end
    if #(contracts[citizenid].dropOff - GetEntityCoords(ped)) > 5.0 then return end

    -- Cash
    local payout = math.random(Shared.CashReward.min, Shared.CashReward.max)
    Player.Functions.AddMoney('cash', payout, 'chopshop-reward')

    -- Items
    for i = 1, Shared.RewardDrops do
        local randItem = Shared.RewardTable[math.random(#Shared.RewardTable)]
        local amount = math.random(Shared.RewardAmount.min, Shared.RewardAmount.max)

        if Shared.Inventory == 'ox_inventory' then
            if exports['ox_inventory']:CanCarryItem(src, randItem, amount) then
                exports['ox_inventory']:AddItem(src, randItem, amount)
            else
                local amountToAdd = exports['ox_inventory']:CanCarryAmount(src, randItem)
                exports['ox_inventory']:AddItem(src, randItem, amountToAdd)
        
                Utils.Notify(src, Locales['inventory_full'], 'error', 5000)
            end
        elseif Shared.Inventory == 'qb' then
            Player.Functions.AddItem(randItem, amount, false)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[randItem], 'add', amount)
        end

        Wait(250)
    end

    DeleteEntity(vehicle)
    contracts[Player.PlayerData.citizenid] = nil
    debugPrint(Player.PlayerData.name .. ' Finished contract')

    if Shared.AutoRestart then
        SetTimeout(Shared.AutoRestartDelay * 60 * 1000 , function()
            TriggerEvent('qb-chopshop:server:RequestContract', src)
        end)
    end
end)

RegisterNetEvent('qb-chopshop:server:CancelJob', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if contracts[Player.PlayerData.citizenid] then
        local veh = contracts[Player.PlayerData.citizenid].vehicle
        if DoesEntityExist(veh) then DeleteEntity(veh) end
        contracts[Player.PlayerData.citizenid] = nil
        debugPrint(Player.PlayerData.name .. ' Canceled contract')
    end
end)

--- Callbacks

lib.callback.register('qb-chopshop:server:GetVehicleNetId', function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    local netId = NetworkGetNetworkIdFromEntity(contracts[Player.PlayerData.citizenid].vehicle)
    contracts[Player.PlayerData.citizenid].state = 1
    debugPrint(Player.PlayerData.citizenid .. ' Contract state: 1')
    return netId
end)

lib.callback.register('qb-chopshop:server:GetContractData', function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not contracts[Player.PlayerData.citizenid] then
        return nil
    else
        debugPrint(Player.PlayerData.citizenid .. ' Restarting contract after disconnect')
        return {
            model = contracts[Player.PlayerData.citizenid].model,
            location = contracts[Player.PlayerData.citizenid].location,
            dropOff = contracts[Player.PlayerData.citizenid].dropOff,
            plate = contracts[Player.PlayerData.citizenid].plate,
            state = contracts[Player.PlayerData.citizenid].state,
            vehLoc = GetEntityCoords(contracts[Player.PlayerData.citizenid].vehicle)
        }
    end
end)

--- Threads

CreateThread(function() -- This will check if all the vehicles in the config are in the QBCore Shared Vehicles
    Wait(1000)

    for i = 1, #Shared.Vehicles do
        local veh = Shared.Vehicles[i]
        if not QBCore.Shared.Vehicles[veh] then
            debugPrint(Shared.Vehicles[i]..' is not in the QBCore Shared Vehicles!')
        end
    end

    debugPrint('Done checking vehicles in config')

    if Shared.ClearMails then -- This deletes all old emails when the script starts (when the server starts up)
        MySQL.query('DELETE FROM player_mails WHERE sender = :sender AND subject = :subject', {
            ['sender'] = Shared.MailAuthor, 
            ['subject'] = Shared.MailTitle
        })

        debugPrint('Deleted old mails from database')
    end
end)
