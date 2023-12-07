local SD = exports['sd_lib']:getLib()

SD.VersionCheck() -- Version Check

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

-- [[ FUNCTIONS ]]
function UpdateHousesProgress()
    MySQL.Async.fetchAll('SELECT * FROM sd_beekeeping', {}, function(results)
        for k, v in pairs(results) do
            local data = json.decode(v["data"]) or nil
            if v['hive_type'] == 'house' then
                if data and data.time and data.queens and data.workers then
                    if data.time < Beekeeping.House.CaptureTime then
                        data.time = data.time + 1
                        MySQL.Async.execute('UPDATE sd_beekeeping SET data = ? WHERE id = ?', {json.encode(data), v["id"]})
                    else
                        local spawnQueen = math.random(1, 100)
                        local queens, bees, workers = 0, 0, 0

                        if spawnQueen < Beekeeping.House.QueenSpawnChance then
                            if data.queens < Beekeeping.House.MaxQueens then
                                if spawnQueen then if type(Beekeeping.House.QueensPerCapture) == 'number' then queens = Beekeeping.House.QueensPerCapture else queens = math.random(Beekeeping.House.QueensPerCapture[1], Beekeeping.House.QueensPerCapture[2]) end end
                            end
                        else queens = 0 end

                        if data.workers < Beekeeping.House.MaxWorkers then
                            if type(Beekeeping.House.BeesPerCapture) == 'number' then bees = Beekeeping.House.BeesPerCapture else bees = math.random(Beekeeping.House.BeesPerCapture[1], Beekeeping.House.BeesPerCapture[2]) end
                        else bees = 0 end
                        workers = bees - queens
                        MySQL.Async.execute('UPDATE sd_beekeeping SET data = ? WHERE id = ?', {json.encode({time = 0, queens = data.queens + queens or data.queens, workers = data.workers + workers or data.workers}), v["id"]})
                    end
                end
            end

            if v['hive_type'] == 'hive' then
                if data.time < Beekeeping.Hives.HoneyTime and data.haveQueen and data.haveWorker then
                    data.time = data.time + 1
                    MySQL.Async.execute('UPDATE sd_beekeeping SET data = ? WHERE id = ?', {json.encode(data), v["id"]})
                else
                    local newData = table.clone(data)
                    local honeyLevel = math.random(Beekeeping.Hives.HoneyPerTime[1], Beekeeping.Hives.HoneyPerTime[2])
                    local waxLevel = 0

                    local waxRandom = math.random(1,100)
                    if waxRandom <= Beekeeping.Hives.ChanceOfWax then waxLevel = math.random(Beekeeping.Hives.WaxPerTime[1], Beekeeping.Hives.WaxPerTime[2]) end
                    if data.honey < Beekeeping.Hives.MaxHoney then newData.honey = data.honey + honeyLevel end
                    if data.wax < Beekeeping.Hives.MaxWax then newData.wax = data.wax + waxLevel end
                    
                    newData.time = 0
                    MySQL.Async.execute('UPDATE sd_beekeeping SET data = ? WHERE id = ?', {json.encode(newData), v["id"]})
                end
            end
        end
    end)

    SetTimeout(1000, UpdateHousesProgress)
end UpdateHousesProgress()

-- [[ EVENTS ]]
RegisterNetEvent('sd-beekeeping:withdrawBee', function(id, type, amount)
    local src = source
    MySQL.Async.fetchAll('SELECT * FROM sd_beekeeping WHERE id = ?', {id}, function(hiveData)
        local data = json.decode(hiveData[1]["data"])

        if data[type] >= amount then
            local item
            if type == 'queens' then item = Beekeeping.Items.QueenItem else item = Beekeeping.Items.WorkerItem end
            SD.AddItem(src, tostring(item), tonumber(amount))
            data[type] = data[type] - amount
            MySQL.Async.execute('UPDATE sd_beekeeping SET data = ? WHERE id = ?', {json.encode(data), id})
        else
            TriggerClientEvent('sd_bridge:notification', src, Lang:t('notifications.not_enough_bees'), 'error')
        end
    end)
end)

RegisterNetEvent('sd-beekeeping:withdrawProduct', function(id, type, amount)
    local src = source
    MySQL.Async.fetchAll('SELECT * FROM sd_beekeeping WHERE id = ?', {id}, function(hiveData)
        local data = json.decode(hiveData[1]["data"])

        if data[type] >= amount then
            local item
            if type == 'honey' then item = Beekeeping.Items.HoneyItem else item = Beekeeping.Items.WaxItem end
            SD.AddItem(src, tostring(item), tonumber(amount))
            data[type] = data[type] - amount
            MySQL.Async.execute('UPDATE sd_beekeeping SET data = ? WHERE id = ?', {json.encode(data), id})
        else
            TriggerClientEvent('sd_bridge:notification', src, Lang:t('notifications.not_enough_product'), 'error')
        end
    end)
end)

RegisterNetEvent('sd-beekeeping:removeStructure', function(id)
    TriggerEvent('sd-beekeeping:objects:server:DeleteObject', id)
end)

RegisterNetEvent('sd-beekeeping:insertQueen', function(id)
    local src = source
    if SD.HasItem(src, Beekeeping.Items.QueenItem) >= 1 then
        SD.RemoveItem(src, Beekeeping.Items.QueenItem, Beekeeping.Hives.NeededQueens)
        MySQL.Async.fetchAll('SELECT * FROM sd_beekeeping WHERE id = ?', {id}, function(hiveData)
            if hiveData[1] then
                local hiveData = hiveData[1]
                local data = json.decode(hiveData.data)
    
                if hiveData.hive_type == 'hive' then
                    data.haveQueen = true
                    MySQL.execute('UPDATE sd_beekeeping SET data = ? WHERE id = ?', {json.encode(data), id})
                else return end
            end
        end)
    else
        TriggerClientEvent('sd_bridge:notification', src, Lang:t('notifications.not_enough_queens', {needed = Beekeeping.Hives.NeededQueens}), 'error')
    end
end)

RegisterNetEvent('sd-beekeeping:insertWorker', function(id)
    local src = source
    if SD.HasItem(src, Beekeeping.Items.WorkerItem, Beekeeping.Hives.NeededWorkers) >= 5 then
        SD.RemoveItem(src, Beekeeping.Items.WorkerItem, Beekeeping.Hives.NeededWorkers)
        MySQL.Async.fetchAll('SELECT * FROM sd_beekeeping WHERE id = ?', {id}, function(hiveData)
            if hiveData[1] then
                local hiveData = hiveData[1]
                local data = json.decode(hiveData.data)
                local newData = table.clone(data)
    
                if hiveData.hive_type == 'hive' then
                    newData.haveWorker = true
                    newData.honey = 0
                    newData.wax = 0
                    MySQL.execute('UPDATE sd_beekeeping SET data = ? WHERE id = ?', {json.encode(newData), id})
                else return end
            end
        end)
    else
        TriggerClientEvent('sd_bridge:notification', src, Lang:t('notifications.not_enough_workers', {needed = Beekeeping.Hives.NeededWorkers}), 'error')
    end
end)

-- [[ CALLBACKS ]]
lib.callback.register('sd-beekeeping:getHiveData', function(source, hiveId)
    local data = MySQL.query.await('SELECT * FROM sd_beekeeping WHERE id = ?', {hiveId})
    if data[1] then return data[1] else return false end
end)

lib.callback.register('sd-beekeeping:server:CheckHiveCount', function(source, data)
    local maxLimit if data.hive_type == 'house' then maxLimit = Beekeeping.Max.Houses else maxLimit = Beekeeping.Max.Hives end
    local query = 'SELECT COUNT(*) as count FROM sd_beekeeping WHERE citizenid = ? AND hive_type = ?'
    local result = exports.oxmysql:scalarSync(query, {data.citizenid, data.hive_type})
    if result >= maxLimit then return true else return false end
end)