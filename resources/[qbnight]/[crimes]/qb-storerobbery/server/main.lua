local QBCore = exports['qb-core']:GetCoreObject()

local SafeCodes = {}

local cashA = 45 				--<< how much minimum you can get from a robbery
local cashB = 100              --<< how much maximum you can get from a robbery
local SafeCashMin = 5000				--<< how much maximum you can get from a safe robbery
local SafeCashMax = 7500

CreateThread(function()
    while true do
        SafeCodes = {
            [1] = math.random(1000, 9999),
            [2] = {math.random(99), math.random(99), math.random(99)},
            [3] = {math.random(99), math.random(99), math.random(99)},
            [4] = math.random(1000, 9999),
            [5] = math.random(1000, 9999),
            [6] = {math.random(99), math.random(99), math.random(99)},
            [7] = math.random(1000, 9999),
            [8] = math.random(1000, 9999),
            [9] = math.random(1000, 9999),
            [10] = {math.random(99), math.random(99), math.random(99)},
            [11] = math.random(1000, 9999),
            [12] = math.random(1000, 9999),
            [13] = math.random(1000, 9999),
            [14] = {math.random(99), math.random(99), math.random(99)},
            [15] = math.random(1000, 9999),
            [16] = math.random(1000, 9999),
            [17] = math.random(1000, 9999),
            [18] = {math.random(99), math.random(99), math.random(99)},
            [19] = math.random(1000, 9999),
        }
        Wait((1000 * 60) * 40)
    end
end)

RegisterNetEvent('qb-storerobbery:server:takeMoney', function(register, isDone)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local worth = math.random(cashA, cashB)
    Player.Functions.AddMoney("cash", worth)
	-- Add some stuff if you want, this here above the if statement will trigger every 2 seconds of the animation when robbing a cash register.
    if isDone then
        if math.random(1, 100) <= 50 then
            local info = {}
            local code = SafeCodes[Config.Registers[register].safeKey]
            if Config.Safes[Config.Registers[register].safeKey].type == "keypad" then
                info = {
                    label = "Safe Code: "..tostring(code)
                }
            else
                local num = #code
                local label = "Safe Code: "
                for k, v in ipairs(code) do
                    if k == 1 then label = label..v else label = label.."-"..v end
                end
                info = {label = label}
            end
            Player.Functions.AddItem("stickynote", 1, false, info)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["stickynote"], "add")
        end
    end
end)

RegisterNetEvent('qb-storerobbery:server:setRegisterStatus', function(register)
    Config.Registers[register].robbed   = true
    Config.Registers[register].time     = Config.resetTime
    TriggerClientEvent('qb-storerobbery:client:setRegisterStatus', -1, register, Config.Registers[register])
end)

RegisterNetEvent('qb-storerobbery:server:setSafeStatus', function(safe)
    TriggerClientEvent('qb-storerobbery:client:setSafeStatus', -1, safe, true)
    Config.Safes[safe].robbed = true

    SetTimeout(math.random(40, 80) * (60 * 1000), function()
        TriggerClientEvent('qb-storerobbery:client:setSafeStatus', -1, safe, false)
        Config.Safes[safe].robbed = false
    end)
end)



RegisterNetEvent('qb-storerobbery:server:SafeReward', function(safe)
    local src = source
    exports['mdn-extras']:GiveHeistElectronics(src, 'stores')
    exports['mdn-extras']:GiveLootBag(src, 'StoreRobbery')
end)

function GenerateLoot()
    local items = Config.RareSafeItems
    local total_weight = 0
    for _, item in ipairs(items) do
        total_weight = total_weight + item.weight
    end
    local chosenLoot = math.random(total_weight)
    local chosenItem
    for k, item in ipairs(items) do
        chosenLoot = chosenLoot - item.weight
        if chosenLoot <= 0 then chosenItem = k break end
    end
    return chosenItem
end

--safecracker
QBCore.Functions.CreateUseableItem('safecracker', function(source)
    TriggerClientEvent('safecracker:safecracker', source)
end)

CreateThread(function()
    while true do
        local toSend = {}
        for k in ipairs(Config.Registers) do

            if Config.Registers[k].time > 0 and (Config.Registers[k].time - Config.tickInterval) >= 0 then
                Config.Registers[k].time = Config.Registers[k].time - Config.tickInterval
            else
                if Config.Registers[k].robbed then
                    Config.Registers[k].time = 0
                    Config.Registers[k].robbed = false
                    toSend[#toSend+1] = Config.Registers[k]
                end
            end
        end

        if #toSend > 0 then
            --The false on the end of this is redundant
            TriggerClientEvent('qb-storerobbery:client:setRegisterStatus', -1, toSend, false)
        end

        Wait(Config.tickInterval)
    end
end)

-- Minimum Cop Callback
QBCore.Functions.CreateCallback('qb-storerobbery:server:getCops', function(source, cb)
    local amount = 0
    local players = QBCore.Functions.GetQBPlayers()
    for _, Player in pairs(players) do
        if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    cb(amount)
end)

QBCore.Functions.CreateCallback('qb-storerobbery:server:isCombinationRight', function(_, cb, safe)
    cb(SafeCodes[safe])
end)

QBCore.Functions.CreateCallback('qb-storerobbery:server:getPadlockCombination', function(_, cb, safe)
    cb(SafeCodes[safe])
end)

QBCore.Functions.CreateCallback('qb-storerobbery:server:getRegisterStatus', function(_, cb)
    cb(Config.Registers)
end)

QBCore.Functions.CreateCallback('qb-storerobbery:server:getSafeStatus', function(_, cb)
    cb(Config.Safes)
end)


RegisterNetEvent('qb-storerobbery:server:RemoveItem', function(ItemName, Amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(ItemName, Amount)
    TriggerClientEvent('inventory:client:ItemBox', src,  QBCore.Shared.Items[ItemName], "remove", Amount)
end)