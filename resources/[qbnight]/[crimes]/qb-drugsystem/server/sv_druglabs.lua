if not Shared.Enable.Druglabs then return end

local druglabs = {}

local means = { -- Between 0 and 100
    [1] = 15,
    [2] = 50,
    [3] = 35
}

--- Functions

--- Method to check if the player is the owner of the specific druglab
--- @param citizenid string - Player character citizenid
--- @param id number - druglab index id
--- @return boolean - isLabOwner
local isLabOwner = function(citizenid, id)
    return druglabs[id] and druglabs[id].owned == 1 and druglabs[id].owner == citizenid
end

--- Method to generate a random alphanumeric password with length k
--- @param k number - Password length
--- @return string string - Password string
local generatePassword = function(k)
    local charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local string = ''
    for i=1, k do
        local rand = math.random(#charset)
        string = string .. string.sub(charset, rand, rand)
    end
    return string
end

--- Method to draw a gaussian for given mean and variance
--- @param mean number - Mean of the distribution
--- @param variance number - Variance of the distribution
--- @return number - Calculated gaussian for given mean and variance
local function gaussian(mean, variance)
    return math.sqrt(-2 * variance * math.log(math.random())) * math.cos(2 * math.pi * math.random()) + mean
end

--- Method to calculate purity for given user inputs and gaussian
--- @param lab string - Name of the drug lab index
--- @return purity number - Calculated purity percentage
local function CalculatePurity(id)
    local task1 = 33 - (math.abs(druglabs[id].tasks[1].parameter - math.floor(gaussian(means[1], 5))))
    local task2 = 34 - (math.abs(druglabs[id].tasks[2].parameter - math.floor(gaussian(means[2], 5))))
    local task3 = 33 - (math.abs(druglabs[id].tasks[3].parameter - math.floor(gaussian(means[3], 5))))
    local purity = task1 + task2 + task3
    if purity < Shared.MinimumPurity then -- minimum purity
        purity = Shared.MinimumPurity
    end
    return purity
end

--- Events

RegisterNetEvent('qb-drugsystem:server:PurchaseDrugLab', function(id)
    print(1)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not druglabs[id] or druglabs[id].owned == 1 then return end
    print(2)
    local price = druglabs[id].price
    if Player.Functions.RemoveMoney('cash', price) or Player.Functions.RemoveMoney('bank', price) then
        local cid = Player.PlayerData.citizenid
        druglabs[id].owner = cid
        druglabs[id].owned = 1
        MySQL.update('UPDATE druglabs SET owner = :owner, owned = :owned WHERE id = :id', {
            ['owner'] = cid,
            ['owned'] = 1,
            ['id'] = id
        })
        print(3)
        TriggerClientEvent('qb-drugsystem:client:LabPurchased', -1, id, cid)
        TriggerEvent('qb-phone:server:sendNewMailToOffline', cid, {
            sender = 'Drug Lab',
            subject = 'Purchased New',
            message = 'Your current password is: ' .. druglabs[id].code
        })
        print(4)
        debugPrint(GetPlayerName(src) .. ' (' .. src .. ')' .. ' has purchased Lab ' .. id .. ' price ' .. price)
    else
        TriggerClientEvent('QBCore:Notify', src, _U('not_enough_money'), 'error', 2500)
    end
end)

RegisterNetEvent('qb-drugsystem:server:ChangeCode', function(id, inputCurrent, inputNew)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not isLabOwner(Player.PlayerData.citizenid, id) then return end

    if inputCurrent == druglabs[id].code then
        druglabs[id].code = inputNew
        MySQL.update('UPDATE druglabs SET code = :code WHERE id = :id', {
            ['code'] = inputNew,
            ['id'] = id
        })
        TriggerClientEvent('QBCore:Notify', src, _U('pass_changed_success'), 'success', 2500)
        debugPrint(GetPlayerName(src) .. ' (' .. src .. ')' .. ' has changed code of Lab ' .. id .. ' to ' .. inputNew)
    end
end)

RegisterNetEvent('qb-drugsystem:server:AddStock', function(id)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not druglabs[id] then return end

    local supplyItem = Shared.DrugLabs[druglabs[id].type].items.supply
    local item = Player.Functions.GetItemByName(supplyItem)
    if not item then return end

    if Player.Functions.RemoveItem(supplyItem, item.amount, item.slot) then
        local newSupply = druglabs[id].stock + item.amount
        druglabs[id].stock = newSupply
        MySQL.update('UPDATE druglabs SET stock = :stock WHERE id = :id', {
            ['stock'] = newSupply,
            ['id'] = id
        })
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[supplyItem], 'remove', item.amount)
        TriggerClientEvent('QBCore:Notify', src, _U('add_ingredients_success'), 'success', 2500)
        debugPrint(GetPlayerName(src) .. ' (' .. src .. ')' .. ' has added ' .. item.amount .. ' stock to Lab ' .. id .. ', New: ' .. newSupply)
    end
end)

RegisterNetEvent('qb-drugsystem:server:GrabStock', function(id)
    local src = source
    if not druglabs[id] or druglabs[id].stock < 0 then return end
    druglabs[id].stock -= 1
    MySQL.update('UPDATE druglabs SET stock = stock - 1 WHERE id = :id', {
        ['id'] = id
    })
    debugPrint(GetPlayerName(src) .. ' (' .. src .. ')' .. ' has grabbed stock from Lab ' .. id .. ', New: ' .. druglabs[id].stock)
end)

RegisterNetEvent('qb-drugsystem:server:ReturnStock', function(id)
    local src = source
    if not druglabs[id] then return end
    druglabs[id].stock += 1
    MySQL.update('UPDATE druglabs SET stock = stock + 1 WHERE id = :id', {
        ['id'] = id
    })
    debugPrint(GetPlayerName(src) .. ' (' .. src .. ')' .. ' has returned stock from Lab ' .. id .. ', New: ' .. druglabs[id].stock)
end)

RegisterNetEvent('qb-drugsystem:server:AddTaskIngredients', function(id, task)
    local src = source
    if not druglabs[id] or not druglabs[id].tasks[task] then return end
    druglabs[id].tasks[task].current += 1
    debugPrint(GetPlayerName(src) .. ' (' .. src .. ')' .. ' has added ingredients to Lab ' .. id .. ' Task ' .. task .. ' to ' .. druglabs[id].tasks[task].current)
    if druglabs[id].tasks[task].current > Shared.DrugLabs[druglabs[id].type].tasks[task].requiredIngredients then
        druglabs[id].tasks[task].current = Shared.DrugLabs[druglabs[id].type].tasks[task].requiredIngredients
    end
end)

RegisterNetEvent('qb-drugsystem:server:SetTaskParameter', function(id, task, input)
    local src = source
    if not druglabs[id] then return end
    druglabs[id].tasks[task].parameter = input
    debugPrint(GetPlayerName(src) .. ' (' .. src .. ')' .. ' has set parameter of Lab ' .. id .. ' Task ' .. task .. ' to ' .. input)
end)

RegisterNetEvent('qb-drugsystem:server:StartMachine', function(data)
    local id = data.id
    local task = data.task
    local src = source
    if not druglabs[id] or not druglabs[id].tasks[task] then return end
    if druglabs[id].tasks[task].state == 'notstarted' and druglabs[id].tasks[task].current >= Shared.DrugLabs[druglabs[id].type].tasks[task].requiredIngredients then
        druglabs[id].tasks[task].state = 'started'
        debugPrint(GetPlayerName(src) .. ' (' .. src .. ')' .. ' has started Lab ' .. id .. ' Task ' .. task)
        CreateThread(function()
            Wait(Shared.DrugLabs[druglabs[id].type].tasks[task].duration * 1000)
            druglabs[id].tasks[task].state = 'completed'
            debugPrint('Completed Lab ' .. id .. ' Task ' .. task)
        end)
    end
end)

RegisterNetEvent('qb-drugsystem:server:CheckReward', function(id)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not druglabs[id] then return end
    for k, v in pairs(druglabs[id].tasks) do
        if v.state ~= 'completed' then
            TriggerClientEvent('QBCore:Notify', src, _U('finish_all_steps'), 'error', 2500)
            return
        end
    end

    local item = Shared.DrugLabs[druglabs[id].type].items.batchItem
    local pure = CalculatePurity(id)
    local info = { purity = pure }
    Player.Functions.AddItem(item, 1, false, info)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add', 1)
    debugPrint(GetPlayerName(src) .. ' (' .. src .. ')' .. ' received reward from ' .. id .. ' Purity ' .. pure)

    druglabs[id].tasks = {
        [1] = {
            current = 0,
            state = 'notstarted',
            parameter = 100
        },
        [2] = {
            current = 0,
            state = 'notstarted',
            parameter = 100
        },
        [3] = {
            current = 0,
            state = 'notstarted',
            parameter = 100
        }
    }
end)

RegisterNetEvent('qb-drugsystem:server:AddCureBatch', function(id)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not druglabs[id] then return end
    if druglabs[id].curing.state ~= 'notstarted' then return end
    local item = Player.Functions.GetItemByName(Shared.DrugLabs[druglabs[id].type].items.batchItem)
    if item and item.info.purity then
        Player.Functions.RemoveItem(item.name, 1, item.slot)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], 'remove', 1)
        druglabs[id].curing.state = 'started'
        druglabs[id].curing.purity = item.info.purity
        debugPrint(GetPlayerName(src) .. ' (' .. src .. ')' .. ' added batch to ' .. id .. ' Purity ' .. item.info.purity)
        CreateThread(function()
            Wait(Shared.DrugLabs[druglabs[id].type].curing.duration * 1000)
            druglabs[id].curing.state = 'completed'
            debugPrint('Completed batch curing ' .. id .. ' Purity ' .. item.info.purity)
        end)
    else
        TriggerClientEvent('QBCore:Notify', src, _U('nothing_to_cure'), 'error', 2500)
    end
end)

RegisterNetEvent('qb-drugsystem:server:GrabCureBatch', function(id)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not druglabs[id] then return end
    if druglabs[id].curing.state ~= 'completed' then return end
    local info = { purity = druglabs[id].curing.purity }
    local item = Shared.DrugLabs[druglabs[id].type].items.curedItem
    Player.Functions.AddItem(item, 1, false, info)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add', 1)
    debugPrint(GetPlayerName(src) .. ' (' .. src .. ')' .. ' received cured batch from ' .. id .. ' Purity ' .. druglabs[id].curing.purity)
    druglabs[id].curing.state = 'notstarted'
    druglabs[id].curing.purity = nil
end)

--- Callbacks

QBCore.Functions.CreateCallback('qb-drugsystem:server:GetLabData', function(source, cb)
    cb(druglabs)
end)

QBCore.Functions.CreateCallback('qb-drugsystem:server:GetSupplyInfo', function(source, cb, id)
    cb(druglabs[id].stock)
end)

QBCore.Functions.CreateCallback('qb-drugsystem:server:GetTaskData', function(source, cb, id, task)
    for k, v in pairs(druglabs[id].tasks) do
        if k < task and v.state ~= 'completed' then
            TriggerClientEvent('QBCore:Notify', source, _U('too_soon'), 'error', 2500)
            cb(nil)
            return
        end
    end
    cb(druglabs[id].tasks[task])
end)

QBCore.Functions.CreateCallback('qb-drugsystem:server:GetCuringData', function(source, cb, id)
    cb(druglabs[id].curing)
end)

--- Commands

QBCore.Commands.Add(Shared.Creation.command, 'Create a new druglab', {{name = 'type', help = 'meth/coke/weed'}, {name = 'price', help = 'Price'}}, true, function(source, args)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local drug = args[1]
    local price = tonumber(args[2])
    if not Player or not drug or not price or not Shared.DrugLabs[drug] then return end

    local coords = GetEntityCoords(GetPlayerPed(src))
    local code = generatePassword(6)

    MySQL.insert('INSERT into druglabs (coords, type, code, stock, price, owned) VALUES (:coords, :type, :code, :stock, :price, :owned)', {
        ['coords'] = json.encode(coords),
        ['type'] = drug,
        ['code'] = code,
        ['stock'] = 0,
        ['price'] = price,
        ['owned'] = 0
    }, function(data)
        druglabs[data] = {
            id = data,
            coords = coords,
            type = drug,
            owner = nil,
            code = code,
            stock = 0,
            price = price,
            owned = 0,
            tasks = {
                [1] = {
                    current = 0,
                    state = 'notstarted',
                    parameter = 100
                },
                [2] = {
                    current = 0,
                    state = 'notstarted',
                    parameter = 100
                },
                [3] = {
                    current = 0,
                    state = 'notstarted',
                    parameter = 100
                }
            },
            curing = {
                purity = nil,
                state = 'notstarted'
            }
        }
        debugPrint(GetPlayerName(src) .. ' (' .. src .. ')' .. ' has created new Lab ' .. data .. ' Price ' .. price .. ' Coords ' .. coords)
        TriggerClientEvent('qb-drugsystem:client:NewForSaleLab', -1, druglabs[data])
    end)
end, Shared.Creation.rank)

--- Threads

CreateThread(function()
    local result = MySQL.query.await('SELECT * FROM druglabs', {})
    for k, v in pairs(result) do
        local co = json.decode(v.coords)
        local coords = vector3(co.x, co.y, co.z)
        druglabs[v.id] = {
            id = v.id,
            coords = coords,
            type = v.type,
            owner = v.owner,
            code = v.code,
            stock = v.stock,
            price = v.price,
            owned = v.owned,
            tasks = {
                [1] = {
                    current = 0,
                    state = 'notstarted',
                    parameter = 100
                },
                [2] = {
                    current = 0,
                    state = 'notstarted',
                    parameter = 100
                },
                [3] = {
                    current = 0,
                    state = 'notstarted',
                    parameter = 100
                }
            },
            curing = {
                purity = nil,
                state = 'notstarted'
            }
        }
    end
end)
