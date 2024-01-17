local QBCore = exports['qb-core']:GetCoreObject()

local Rewards = {
    ['door'] = {
        [1] = {item = "rolex",                      amt = {min = 1, max = 3}, probability = 1/5},
        [2] = {item = "goldchain",                  amt = {min = 1, max = 3}, probability = 1/5},
        [3] = {item = "samsungphone",               amt = {min = 1, max = 3}, probability = 1/5},
        [4] = {item = "iphone",                     amt = {min = 1, max = 3}, probability = 1/5},
        [5] = {item = "skunk_joint",                 amt = {min = 1, max = 3}, probability = 1/5},

        [6] = {item = "weapon_knife",               amt = {min = 1, max = 1}, probability = 1/10},
        [7] = {item = "weapon_knuckle",             amt = {min = 1, max = 1}, probability = 1/15},
        [8] = {item = "weapon_pistol",               amt = {min = 1, max = 1}, probability = 1/50},
        [9] = {item = "weapon_heavypistol",                  amt = {min = 1, max = 1}, probability = 1/60},

        [10] = {item = "phone",              amt = {min = 1, max = 1}, probability = 1/7},
        [11] = {item = "malmo_skunk_seed",          amt = {min = 3, max = 5}, probability = 1/10},
        [12] = {item = "tint_supplies",             amt = {min = 1, max = 1}, probability = 1/20},
        [13] = {item = "joint",         amt = {min = 1, max = 1}, probability = 1/15},
        [14] = {item = "burnerphone_loot",          amt = {min = 1, max = 1}, probability = 1/15},
        [15] = {item = "burnerphone_wep",           amt = {min = 1, max = 1}, probability = 1/15},
        [16] = {item = "burnerphone_mat",           amt = {min = 1, max = 1}, probability = 1/15},
        [17] = {item = "nothing",                   amt = {min = 1, max = 1}, probability = 1/10},
    },
    ['hood'] = {
        [1] = {item = "iron",                    amt = {min = 10, max = 16}, probability = 1/20},

        --[2] = {item = "turbo",                      amt = {min = 1, max = 1}, probability = 1/20},
        --[3] = {item = "modified_turbo",             amt = {min = 1, max = 1}, probability = 1/500},

        [4] = {item = "steel",              amt = {min = 10, max = 18}, probability = 1/20},

        [5] = {item = "headlights",                amt = {min = 1, max = 1}, probability = 1/20},
        [6] = {item = "hood",                      amt = {min = 1, max = 1}, probability = 1/20},
        [7] = {item = "externals",                 amt = {min = 1, max = 1}, probability = 1/20},
        [8] = {item = "bumper",                    amt = {min = 1, max = 1}, probability = 1/20},
        [9] = {item = "crack_baggy",                    amt = {min = 1, max = 1}, probability = 1/25},
        [10] = {item = "nothing",                   amt = {min = 1, max = 1}, probability = 1/10},

    },
    ['wheel'] = {
        [1] = {item = "rubber",                amt = {min = 17, max = 21}, probability = 1/5},
        [2] = {item = "rims",                       amt = {min = 1, max = 1}, probability = 1/5},
        [3] = {item = "brakes2",                    amt = {min = 1, max = 1}, probability = 1/5},
        [4] = {item = "car_armor",                  amt = {min = 1, max = 1}, probability = 1/5},

        --[5] = {item = "pd_adpt_tracker",           amt = {min = 1, max = 1}, probability = 1/20},
        [6] = {item = "nothing",                   amt = {min = 1, max = 1}, probability = 1/10},
    },
    ['trunk'] = {
        [1] = {item = "bumper",                     amt = {min = 1, max = 1}, probability = 1/20},
        [2] = {item = "walkstick",                    amt = {min = 1, max = 1}, probability = 1/20},
        [3] = {item = "exhaust",                    amt = {min = 1, max = 1}, probability = 1/20},
        [4] = {item = "skirts",                     amt = {min = 1, max = 1}, probability = 1/20},

        [5] = {item = "laptop",                     amt = {min = 1, max = 2}, probability = 1/10},
        [6] = {item = "hackingdevice",                  amt = {min = 1, max = 1}, probability = 1/20},
        [7] = {item = "rolex",                      amt = {min = 2, max = 3}, probability = 1/5},
        [8] = {item = "goldchain",                  amt = {min = 2, max = 3}, probability = 1/5},
        [9] = {item = "boostingtablet",               amt = {min = 1, max = 1}, probability = 1/300},
        [10] = {item = "iphone",                    amt = {min = 2, max = 3}, probability = 1/5},
        [11] = {item = "gold_watch",                amt = {min = 2, max = 3}, probability = 1/5},

        [12] = {item = "cokebaggy",               amt = {min = 2, max = 3}, probability = 1/5},
        [13] = {item = "dongle",                    amt = {min = 2, max = 3}, probability = 1/15},
        [14] = {item = "crack_baggy",                       amt = {min = 1, max = 1}, probability = 1/25},
        [15] = {item = "nothing",                   amt = {min = 1, max = 1}, probability = 1/10},
    },
}

local drops = {1,2}
local function GenLoot(items, dropA)
    local itemsL = {}

    local rec_ = 0
    ::list::
    for k, v in pairs(items) do
        local ran = math.random(0,1)
        --print(ran, v.probability)
        if v.probability < ran then
            table.insert(itemsL, k)
            rec_ = rec_ + 1
        end
    end
    if rec_ < drops[dropA] then goto list
    else return itemsL end
end

-- RegisterCommand('genLoot', function()
--     for i = 1, 50 do
--         --print('---- car #'..i..'----')
--         for k, v in pairs(Rewards) do
--             --print("REWARDS FOR : "..k)
--             local rec = 0
--             local dropA = math.random(#drops)
--             if drops[dropA] > 0 then
--                 local loot = GenLoot(v, dropA)
--                 for k, v_ in pairs(loot) do
--                     if not v[v_].chosen then v[v_].chosen = 0 end
--                     v[v_].chosen = v[v_].chosen + 1
--                     rec = rec + 1
--                     if rec >= dropA then break end
--                 end
--             end
--             print("\n----- "..k.." -----")
--             for k_, v_ in pairs(v) do
--                 print("Item : "..v_.item.." | "..(v_.chosen and "Chosen "..v_.chosen.." times." or "Not Chosen"))
--             end
--         end
--     end
-- end)

local function GenerateLoot(items)
    local total_prob = 0
    for _, item in pairs(items) do
        --print(item.item, (1-item.probability))
        total_prob = total_prob + item.probability
    end

    local total_weight = 0
    for _, item in pairs(items) do
        item.weight = math.ceil(item.probability / total_prob * 100)
        total_weight = total_weight + item.weight
    end
    --local nothing_prob = 1 - total_prob
    --local nothing_weight = math.ceil(nothing_prob / total_prob * 100)
    --print(total_weight, nothing_weight)
    --total_weight = total_weight + nothing_weight

    local chosenLoot = math.random(total_weight)
    local chosenItem = 0
    for k, item in pairs(items) do
        chosenLoot = chosenLoot - item.weight
        if chosenLoot <= 0 then chosenItem = k break end
    end
    return chosenItem
end
local totI = {}
RegisterCommand('genLoot', function(_, args)
    print("generating loot for "..tonumber(args[1]))
    for i = 1, tonumber(args[1]) do
        i = i +1
        --print('---- car #'..i..'----')
        for k, v in pairs(Rewards) do
            if not totI[k] then totI[k] = 0 end
            --print("REWARDS FOR : "..k)
            local roll = math.random(2)
            for r = 1, roll do
                local loot = GenerateLoot(v)
                if not v[loot].chosen then v[loot].chosen = 0 end
                v[loot].chosen = v[loot].chosen + 1
                totI[k] = totI[k] + 1
            end
            --print(totI[k])
            if i == 50 then
                print("\n----- "..k.." -----")
                for k_, v_ in ipairs(v) do
                    print("Item : "..v_.item.." | "..(v_.chosen and "Chosen "..v_.chosen.." times." or "Not Chosen").." | ".. string.format("%.2f", (v_.chosen or 0)/totI[k]*100) .. "%")
                end
            end
        end
    end
end)


--- Returns a random license plate and checks for duplicates
local GeneratePlate = function()
    local plate = QBCore.Shared.RandomInt(1)..QBCore.Shared.RandomStr(2)..QBCore.Shared.RandomInt(3)..QBCore.Shared.RandomStr(2)
    local result = MySQL.Sync.fetchScalar('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return GeneratePlate()
    else
        return plate:upper()
    end
end

RegisterNetEvent('qb-chopshop:server:SendEmail', function(cid, email)
    TriggerEvent('qs-smartphone:server:sendNewMailToOffline', cid, email)
end)

RegisterNetEvent('qb-chopshop:server:Reward', function(type)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if type == 'door' then
        local giv = false
        local rndm = math.random(1,2) -- 3 item drops
        for i=1, rndm do
            local randItem = GenerateLoot(Rewards[type])
            if randItem ~= #Reward[type] and ranItem ~= 0 then
                giv = true
                local amount = math.random(Rewards[type][randItem].amt.min, Rewards[type][randItem].amt.max)
                Player.Functions.AddItem(Rewards[type][randItem].item, amount, false)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Rewards[type][randItem].item], "add", amount)
            end
            Wait(250)
        end
        if not giv then TriggerClientEvent('QBCore:Notify', src, "You did not find anything useful here...", "info") end
    elseif type == 'hood' then
        local giv = false
        local rndm = math.random(1,2) -- 3 item drops
        for i=1, rndm do
            local randItem = GenerateLoot(Rewards[type])
            if randItem ~= #Reward[type] and ranItem ~= 0 then
                giv = true
                local amount = math.random(Rewards[type][randItem].amt.min, Rewards[type][randItem].amt.max)
                Player.Functions.AddItem(Rewards[type][randItem].item, amount, false)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Rewards[type][randItem].item], "add", amount)
                Wait(250)
            end
        end
        if not giv then TriggerClientEvent('QBCore:Notify', src, "You did not find anything useful here...", "info") end
    elseif type == 'wheel' then
        local giv = false
        local rndm = math.random(1,2) -- 3 item drops
        for i=1, rndm do
            local randItem = GenerateLoot(Rewards[type])
            if randItem ~= #Reward[type] and ranItem ~= 0 then
                giv = true
                local amount = math.random(Rewards[type][randItem].amt.min, Rewards[type][randItem].amt.max)
                Player.Functions.AddItem(Rewards[type][randItem].item, amount, false)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Rewards[type][randItem].item], "add", amount)
            end
            Wait(250)
        end
        if not giv then TriggerClientEvent('QBCore:Notify', src, "You did not find anything useful here...", "info") end
    elseif type == 'trunk' then
        local giv = false
        local rndm = math.random(1,2) -- 3 item drops
        for i=1, rndm do
            local randItem = GenerateLoot(Rewards[type])
            if randItem ~= #Reward[type] and ranItem ~= 0 then
                giv = true
                local amount = math.random(Rewards[type][randItem].amt.min, Rewards[type][randItem].amt.max)
                Player.Functions.AddItem(Rewards[type][randItem].item, amount, false)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Rewards[type][randItem].item], "add", amount)
            end
            Wait(250)
        end
        if not giv then TriggerClientEvent('QBCore:Notify', src, "You did not find anything useful here...", "info") end
    elseif type == 'cash' then
        local payout = math.random(810, 1500) -- cash payout between 810 and 2.190
        Player.Functions.AddItem('dirtymoney', payout, 'chopshop-reward')
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['dirtymoney'], "add", amount)
        Wait(250)
    end
end)

RegisterNetEvent('qb-chopshop:server:DeleteVehicle', function(netId)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
	DeleteEntity(vehicle)
end)

QBCore.Functions.CreateCallback('qb-chopshop:server:GetPlate', function(source, cb)
    local plate = GeneratePlate()
    cb(plate)
end)

QBCore.Functions.CreateCallback('qb-chopshop:server:SpawnVehicle', function(source, cb, model, loc, plate)
    local veh = CreateVehicle(model, loc.x, loc.y, loc.z, loc.w, true, false)
    SetVehicleNumberPlateText(veh, plate)
    while not DoesEntityExist(veh) do Wait(10) end
    local netId = NetworkGetNetworkIdFromEntity(veh)
    cb(netId)
end)

CreateThread(function() -- This will check if all the vehicles in the config are in the QBCore Shared Vehicles
    Wait(1000)
    for i=1, #Shared.Vehicles do
        local veh = Shared.Vehicles[i]
        if not QBCore.Shared.Vehicles[veh] then
            print("^3[qb-chopshop] ^5"..Shared.Vehicles[i].." is not in the QBCore Shared Vehicles!^7")
        end
    end
    print("^3[qb-chopshop] ^5Done checking vehicles in config.^7")
end)

CreateThread(function() -- This deletes all old emails when the script starts (when the server starts up)
    if Shared.ClearMails then
        MySQL.Async.execute("DELETE FROM player_mails WHERE sender = ? AND subject = ?", {
            Shared.MailAuthor,
            Shared.MailTitle
        })
        print("^3[qb-chopshop] ^5Deleted old mails from database.^7")
    end
end)
