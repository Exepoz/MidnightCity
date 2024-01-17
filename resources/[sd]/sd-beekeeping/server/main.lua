local SD = exports['sd_lib']:getLib()

SD.VersionCheck() -- Version Check

-- Global table to store beekeeping data
local beekeepingData = {}

-- Ped Creation
-- Event to set the location of the beekeeper when resource starts
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
		math.randomseed(os.time())
        GlobalState.BeekeeperLocation = Beekeeping.Beekeeper.Location[math.random(#Beekeeping.Beekeeper.Location)]
    end
end)

-- Helper function to format Product Name
local function FormatProductName(product)
    return product:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end):gsub("-", " ")
end

-- Beekeeper Buying/Selling Logic
-- Buying Items
RegisterNetEvent('sd-beekeeping:buyProduct', function(product, quantity)
    local cost = 0

    if product == 'bee-house' then cost = Beekeeping.Shop.Buy['bee-house'] * quantity elseif product == 'bee-hive' then cost = Beekeeping.Shop.Buy['bee-hive'] * quantity end

    local hasMoney = SD.GetPlayerAccountFunds(source, 'money', cost)

    if hasMoney >= cost then
        SD.RemoveMoney(source, 'cash', cost)
        SD.AddItem(source, product, quantity)
        TriggerClientEvent('sd_bridge:notification', source, Lang:t('notifications.purchase_success', {product = FormatProductName(product), quantity = quantity}), 'success')
    else
        TriggerClientEvent('sd_bridge:notification', source, Lang:t('notifications.not_enough_money'), 'error')
    end
end)

-- Selling Items
RegisterNetEvent('sd-beekeeping:sellProduct', function(product, quantity)
    local price = 0

    if product == 'bee-honey' then price = Beekeeping.Shop.Sell['bee-honey'] * quantity elseif product == 'bee-wax' then price = Beekeeping.Shop.Sell['bee-wax'] * quantity end

    if SD.HasItem(source, product) >= quantity then
        SD.RemoveItem(source, product, quantity)
        SD.AddMoney(source, 'cash', price)
        TriggerClientEvent('sd_bridge:notification', source, Lang:t('notifications.sell_success', {product = FormatProductName(product), quantity = quantity}), 'success')
    else
        TriggerClientEvent('sd_bridge:notification', source, Lang:t('notifications.not_enough_items'), 'error')
    end
end)

-- [[ USABLE ITEMS ]]
-- Beehouse
SD.RegisterUsableItem(Beekeeping.Items.HouseItem, function(source, item)
    TriggerClientEvent('sd-beekeeping:objects:client:SpawnObject', source, {
        object = Beekeeping.Props.bee_house,
        hive_type = 'house',
        distance = 100,
        item = item,
        citizenid = SD.GetIdentifier(source)
    })
end)

-- Beehive
SD.RegisterUsableItem(Beekeeping.Items.HiveItem, function(source, item)
    TriggerClientEvent('sd-beekeeping:objects:client:SpawnObject', source, {
        object = Beekeeping.Props.bee_hive,
        hive_type = 'hive',
        distance = 100,
        item = item,
        citizenid = SD.GetIdentifier(source)
    })
end)

-- Remove item
RegisterNetEvent('sd-beekeeping:server:removeItem', function(item, amount)
    local src = source
    SD.RemoveItem(src, item, amount)
end)

function LoadBeekeepingData()
    MySQL.Async.fetchAll('SELECT * FROM sd_beekeeping', {}, function(results)
        for k, v in pairs(results) do
            beekeepingData[v["id"]] = {
                hive_type = v["hive_type"],
                coords = v["coords"],
                options = v["options"] and json.decode(v["options"]) or nil,
                data = v["data"] and json.decode(v["data"]) or nil,
                citizenid = v["citizenid"],
                last_maintained = v["last_maintained"]
            }
        end
    end)
end

-- Event to add newly created objects to the beekeepingData table.
RegisterNetEvent("sd-beekeeping:server:AddToBeekeepingData", function(id, hive_type, coords, options, defaultData, citizenid, last_maintained)
    beekeepingData[id] = {
        hive_type = hive_type,
        coords = coords,
        options = options,
        data = defaultData,
        citizenid = citizenid,
        last_maintained = last_maintained
    }
end)

RegisterNetEvent("sd-beekeeping:server:RemoveFromBeekeepingData", function(id)
    if beekeepingData[id] then beekeepingData[id] = nil end
end)

-- UpdateHousesProgress function
function UpdateHousesProgress()
    for id, v in pairs(beekeepingData) do
        local data = v.data
        if v.hive_type == 'house' then
            if data and data.time and data.queens and data.workers then
                if data.time < Beekeeping.House.CaptureTime then
                    data.time = data.time + 1
                else
                    local spawnQueen = math.random(1, 100)
                    local queens, bees, workers = 0, 0, 0

                    if spawnQueen < Beekeeping.House.QueenSpawnChance then
                        if data.queens < Beekeeping.House.MaxQueens then
                            queens = type(Beekeeping.House.QueensPerCapture) == 'number' and Beekeeping.House.QueensPerCapture or math.random(Beekeeping.House.QueensPerCapture[1], Beekeeping.House.QueensPerCapture[2])
                        end
                    end

                    bees = data.workers < Beekeeping.House.MaxWorkers and (type(Beekeeping.House.BeesPerCapture) == 'number' and Beekeeping.House.BeesPerCapture or math.random(Beekeeping.House.BeesPerCapture[1], Beekeeping.House.BeesPerCapture[2])) or 0
                    workers = bees - queens

                    data.time = 0
                    data.queens = (data.queens or 0) + queens
                    data.workers = (data.workers or 0) + workers
                end
            end
        elseif v.hive_type == 'hive' then
            if data.time < Beekeeping.Hives.HoneyTime and data.haveQueen and data.haveWorker then
                data.time = data.time + 1
            else
                local honeyLevel = math.random(Beekeeping.Hives.HoneyPerTime[1], Beekeeping.Hives.HoneyPerTime[2])
                local waxLevel = 0

                if math.random(1, 100) <= Beekeeping.Hives.ChanceOfWax then
                    waxLevel = math.random(Beekeeping.Hives.WaxPerTime[1], Beekeeping.Hives.WaxPerTime[2])
                end

                if data.honey < Beekeeping.Hives.MaxHoney then
                    data.honey = (data.honey or 0) + honeyLevel
                end

                if data.wax < Beekeeping.Hives.MaxWax then
                    data.wax = (data.wax or 0) + waxLevel
                end

                data.time = 0
            end
        end
    end
end

CreateThread(function()
    LoadBeekeepingData()
    while true do
        Wait(1250) UpdateHousesProgress() -- Update every 1.25 seconds
    end
end)

-- Function to save data for a specific player
function SavePlayerData(playerCitizenId)
    for id, v in pairs(beekeepingData) do
        if v.citizenid == playerCitizenId then
            local serializedData = json.encode(v.data)
            MySQL.Async.execute('UPDATE sd_beekeeping SET data = ? WHERE id = ?', {serializedData, id})
        end
    end
end

-- Event handler for player dropping
AddEventHandler('playerDropped', function(reason)
    local citizenId = SD.GetIdentifier(source)
    SavePlayerData(citizenId)
end)

-- Withdrawing Bee's from Houses
RegisterNetEvent('sd-beekeeping:withdrawBee', function(id, type, amount)
    local src = source
    local data = beekeepingData[id] and beekeepingData[id].data

    if data and data[type] >= amount then
        local item
        if type == 'queens' then item = Beekeeping.Items.QueenItem else item = Beekeeping.Items.WorkerItem end
        SD.AddItem(src, tostring(item), tonumber(amount))
        data[type] = data[type] - amount
    else
        TriggerClientEvent('sd_bridge:notification', src, Lang:t('notifications.not_enough_bees'), 'error')
    end
end)

-- Withdrawing Product from Hives
RegisterNetEvent('sd-beekeeping:withdrawProduct', function(id, type, amount)
    local src = source
    local data = beekeepingData[id] and beekeepingData[id].data

    if data and data[type] >= amount then
        local item
        if type == 'honey' then item = Beekeeping.Items.HoneyItem else item = Beekeeping.Items.WaxItem end
        SD.AddItem(src, tostring(item), tonumber(amount))
        data[type] = data[type] - amount
    else
        TriggerClientEvent('sd_bridge:notification', src, Lang:t('notifications.not_enough_product'), 'error')
    end
end)

RegisterNetEvent('sd-beekeeping:removeStructure', function(id)
    TriggerEvent('sd-beekeeping:server:RemoveFromBeekeepingData', id)
    TriggerEvent('sd-beekeeping:objects:server:DeleteObject', id)
end)

-- Insert queen into Hive
RegisterNetEvent('sd-beekeeping:insertQueen', function(id)
    local src = source
    if SD.HasItem(src, Beekeeping.Items.QueenItem) >= 1 then
        SD.RemoveItem(src, Beekeeping.Items.QueenItem, Beekeeping.Hives.NeededQueens)
        local data = beekeepingData[id] and beekeepingData[id].data

        if data and beekeepingData[id].hive_type == 'hive' then
            data.haveQueen = true
        else
            return
        end
    else
        TriggerClientEvent('sd_bridge:notification', src, Lang:t('notifications.not_enough_queens', {needed = Beekeeping.Hives.NeededQueens}), 'error')
    end
end)

-- Insert worker into Hive.
RegisterNetEvent('sd-beekeeping:insertWorker', function(id)
    local src = source
    if SD.HasItem(src, Beekeeping.Items.WorkerItem, Beekeeping.Hives.NeededWorkers) >= 5 then
        SD.RemoveItem(src, Beekeeping.Items.WorkerItem, Beekeeping.Hives.NeededWorkers)
        local data = beekeepingData[id] and beekeepingData[id].data

        if data and beekeepingData[id].hive_type == 'hive' then
            data.haveWorker = true
            data.honey = 0
            data.wax = 0
        else
            return
        end
    else
        TriggerClientEvent('sd_bridge:notification', src, Lang:t('notifications.not_enough_workers', {needed = Beekeeping.Hives.NeededWorkers}), 'error')
    end
end)

lib.callback.register('sd-beekeeping:getHiveData', function(source, hiveId)
    local id = hiveId if beekeepingData[id] then return beekeepingData[id] else return false end
end)

lib.callback.register('sd-beekeeping:server:CheckHiveCount', function(source, data)
    local maxLimit = (data.hive_type == 'house') and Beekeeping.Max.Houses or Beekeeping.Max.Hives local count = 0
    for _, hive in pairs(beekeepingData) do if hive.citizenid == data.citizenid and hive.hive_type == data.hive_type then count = count + 1 end end
    return count >= maxLimit
end)