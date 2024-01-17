local QBCore = exports['qb-core']:GetCoreObject()

local function AddItem(src, item, amt, info)
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(item, amt, false, info)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amt)
    Wait(500)
end

local function GenerateLoot(items)
    local total_prob = 0
    for _, item in pairs(items) do
        total_prob = total_prob + item.probability
    end

    local total_weight = 0
    for _, item in pairs(items) do
        item.weight = math.ceil(item.probability / total_prob * 100)
        total_weight = total_weight + item.weight
    end

    local chosenLoot = math.random(total_weight)
    local chosenItem = 0
    for k, item in pairs(items) do
        chosenLoot = chosenLoot - item.weight
        if chosenLoot <= 0 then chosenItem = k break end
    end
    return chosenItem
end

local useLootBag = function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    local logStr = ""
    local charinfo = Player.PlayerData.charinfo
    local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
    local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
    local pName = firstName.." "..lastName
    logStr = "Player : ".. GetPlayerName(source) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n"
    local heist = Player.PlayerData.items[item.slot].info.type
    local lucky = Player.PlayerData.items[item.slot].info.lucky or false
    logStr = logStr.."Lootbag : "..heist.."\n"
    if not Player.Functions.RemoveItem('lootbag', 1, item.slot) then return end
    Wait(500)
    for k, v in pairs(Config.Heists[heist]) do
        if k == "Money" then
            local ranMoney = math.random(v.Amount.min, v.Amount.max)
            if lucky then ranMoney = ranMoney + math.floor(ranMoney*0.1) end
            local bagStr = ""
            if v.MoneyInBags then
                local bagAmount = math.random(v.BagAmount.min, v.BagAmount.max)
                local apb = math.floor(ranMoney/bagAmount)
                local info = {worth = apb}
                AddItem(source, 'markedbills', bagAmount, info)
                bagStr = "(In Bags)"
            else
                Player.Functions.AddMoney('cash', 'ranMoney', 'Openned Loot bag ('..heist..')')
            end
            local MoneyStr = "\nMoney Found : "..ranMoney.." "..bagStr..(lucky and " (Lucky + 10%)" or "")
            logStr = logStr..MoneyStr.."\n"
        end
        if k == 'GuarenteedLoot' then
            local garStr = "\nFound Guarenteed Loot :"
            for _, b in pairs(v) do
                AddItem(source, b.item, b.amount, b.info)
                --local infoStr = b.info or ""
                garStr = garStr.."\n"..b.amount.."x "..QBCore.Shared.Items[b.item].label.."\n"
            end
            logStr = logStr.."\n"..garStr.."\n"
        end
        if k == 'ChanceLoot' then
            local ChanceStr = "\nFound Random Loot :"
            if v.pools then
                local lpool = Player.PlayerData.items[item.slot].info.lootpool
                if not lpool then lpool = 'pool1' end
                local pool = v.pools[lpool]
                local rolls = math.random(pool.rolls.min, pool.rolls.max)
                local poolStr = "\n**Loot pool :** "..lpool
                local reroll = false
                local lootRec = 0
                ::reroll::
                for _ = 1, rolls do
                    local rStr = "\n"
                    local ranLoot = GenerateLoot(pool.pool)
                    if ranLoot ~= 0 and pool.pool[ranLoot].item ~= '' then
                        lootRec = lootRec + 1
                        local reward = pool.pool[ranLoot].item
                        local ranAmount = math.random(pool.pool[ranLoot].amt.min, (pool.pool[ranLoot].amt.max + (luck and pool.pool[ranLoot].amt.max > 1 and 1 or 0)))
                        local info = pool.pool[ranLoot].info
                        AddItem(source, reward, ranAmount, info)
                        rStr = rStr..ranAmount.."x "..(QBCore.Shared.Items[reward].label or reward)..(lucky and " (Lucky! Max + 1)" or "")
                    else
                        rStr = rStr.."Nothing!"
                    end
                    poolStr = poolStr..rStr
                    if pool.minLoot and reroll and lootRec >= pool.minLoot then break end
                end
                if pool.minLoot and lootRec < pool.minLoot then reroll = true goto reroll end
                ChanceStr = ChanceStr..poolStr
                logStr = logStr..ChanceStr.."\n"
            else
                local rolls = math.random(v.rolls.min, v.rolls.max)
                local reroll = false
                local lootRec = 0
                ::reroll::
                for _ = 1, rolls do
                    local rStr = "\n"
                    local ranLoot = GenerateLoot(v.pool)
                    if ranLoot ~= 0 and v.pool[ranLoot].item ~= '' then
                        lootRec = lootRec + 1
                        local reward = v.pool[ranLoot].item
                        local ranAmount = math.random(v.pool[ranLoot].amt.min, (v.pool[ranLoot].amt.max + (luck and v.pool[ranLoot].amt.max > 1 and 1 or 0)))
                        local info = v.pool[ranLoot].info
                        AddItem(source, reward, ranAmount, info)
                        rStr = rStr..ranAmount.."x "..(QBCore.Shared.Items[reward].label or reward)..(lucky and " (Lucky! Max + 1)" or "")
                    else
                        rStr = rStr.."Nothing!"
                    end
                    ChanceStr = ChanceStr..rStr
                    if v.minLoot and reroll and lootRec >= v.minLoot then break end
                end
                if v.minLoot and lootRec < v.minLoot then reroll = true goto reroll end
                logStr = logStr..ChanceStr.."\n"
            end
        end
        if k == 'SpecialLoot' then
            if math.random(100) + (luck and 5 or 0) < v.chance then
                AddItem(source, v.item, 1, v.info)
                logStr = logStr.."\nLucky Loot Found :\n".. 1 .."x "..QBCore.Shared.Items[v.item].label.."\n"..(lucky and " (Lucky! Luck + 5%)" or "")
            end
        end
        if k == 'Electronics' then
            local _, am, item = GiveHeistElectronics(source, v, lucky)
            logStr = logStr.."\nElectronics Given :\n".. am .."x "..QBCore.Shared.Items[item].label.."\n"..(lucky and " (Lucky! Amount + 5%)" or "")
        end
        if k == 'Blueprint' then if math.random(1000) + (lucky and 50 or 0) > v.on1000 then
                exports['cw-crafting']:giveBlueprintItem(source, v.item)
                logStr = logStr.."\nBlueprint Found! :\n".. 1 .."x "..QBCore.Shared.Items[v.item].label..(lucky and " (Lucky! Luck + 5%)" or "")--.."\n"
            end
        end
        Wait(500)
    end
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['lootbag'], "remove", 1)
    TriggerEvent("qb-log:server:CreateLog", "lootingbag", "Lootbag Openned.", "green", {ply = GetPlayerName(source), txt = logStr})
end

QBCore.Functions.CreateUseableItem('lootbag', function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.HasItem('lootbag') then useLootBag(source, item) end
end)

for k, v in pairs(Config.Blueprints) do
    QBCore.Functions.CreateUseableItem(k, function(source, item)
        local Player = QBCore.Functions.GetPlayer(source)
        local logStr = ""
        local charinfo = Player.PlayerData.charinfo
        local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
        local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
        local pName = firstName.." "..lastName
        logStr = "Player : ".. GetPlayerName(source) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n"
        logStr = logStr.."Case Type : "..v.lab.."\n"
        if not Player.Functions.RemoveItem(k, 1, item.slot) then return end
        local ChanceStr = "\nFound Blueprint :"
        Wait(500)
        ::reroll::
        local rStr = "\n"
        local ranLoot = GenerateLoot(v.pool)
        if ranLoot ~= 0 and v.pool[ranLoot].item ~= '' then
            local reward = v.pool[ranLoot].item
            exports['cw-crafting']:giveBlueprintItem(source, reward)
            rStr = rStr.. 1 .."x "..QBCore.Shared.Items[reward].label or reward
        else
            rStr = rStr.."Nothing!"
            goto reroll
        end
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[k], "remove", 1)
        ChanceStr = ChanceStr..rStr
        TriggerEvent("qb-log:server:CreateLog", "lootingbag", "Blueprint Case Openned.", "green", {ply = GetPlayerName(source), txt = logStr})
    end)
end

function GiveLootBag(src, type, subtype)
    local luck = Player(src).state.foodBuff == 'luck'
    local Player = QBCore.Functions.GetPlayer(src)
    local bagInfo = {}
    bagInfo.type = type
    bagInfo.typeName = Config.Heists[type].label
    bagInfo.lootpool = subtype or nil
    bagInfo.lucky = true
    if Player.Functions.AddItem('lootbag', 1, false, bagInfo) then
	    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['lootbag'], "add", 1)
        if luck then QBCore.Functions.Notify('You feel lucky when filling up the bag...') end
        return true
    else return false end
end exports("GiveLootBag", GiveLootBag)

QBCore.Commands.Add("giveLootBag", "Gives a lootbag of a certain type (Gods Only)", {{name="type", help="Type of Bag"}, {name="subtype", help="Sub Type (If Applicable)"}}, false, function(source, args)
    local t = args[1]
    local st = args[2]
    if not t then TriggerClientEvent('QBCore:Notify', source, "You need to enter a type of lootbag!", "error") return end
    if not Config.Heists[t] then TriggerClientEvent('QBCore:Notify', source, "This loot bag does not exist!", "error") return end
    if Config.Heists[t]['ChanceLoot'] and Config.Heists[t]['ChanceLoot'].pools and not st then TriggerClientEvent('QBCore:Notify', source, "This loot bag type requires a subtype!", "error") return end
    if not GiveLootBag(source, t, st) then TriggerClientEvent('QBCore:Notify', source, "Couldn't give lootbag!", "error") return end
end, 'god')

-- local totI = 0
-- RegisterCommand('genLootBag', function(_, args)
--     local t = args[1]
--     local st = args[2]
--     if Config.Heists[t]['ChanceLoot'].pools then
--         for i = 1, tonumber(args[3]) do
--             i = i +1
--             --print('---- car #'..i..'----')
--             --print("REWARDS FOR : "..k)
--             local v = Config.Heists[t]['ChanceLoot'].pools[st]
--             local roll = math.random(v.rolls.min, v.rolls.max)
--             print(roll.. " rolls")
--             for r = 1, roll do
--                 local loot = GenerateLoot(v.pool)
--                 if not v.pool[loot].chosen then v.pool[loot].chosen = 0 end
--                 v.pool[loot].chosen = v.pool[loot].chosen + 1
--                 totI = totI + 1
--             end
--             print(totI)
--             if i == tonumber(args[3])+1 then
--                 for k_, v_ in ipairs(v.pool) do
--                     print("Item : "..v_.item.." | "..(v_.chosen and "Chosen "..v_.chosen.." times." or "Not Chosen").." | ".. string.format("%.2f", (v_.chosen or 0)/totI*100) .. "%")
--                 end
--             end
--         end
--     else
--         for i = 1, tonumber(args[3]) do
--             i = i +1
--             --print('---- car #'..i..'----')
--             local v = Config.Heists[t]['ChanceLoot']
--             local roll = math.random(v.rolls.min, v.rolls.max)
--             print(roll.. " rolls")
--             for r = 1, roll do
--                 local loot = GenerateLoot(v.pool)
--                 if not v.pool[loot].chosen then v.pool[loot].chosen = 0 end
--                 v.pool[loot].chosen = v.pool[loot].chosen + 1
--                 totI = totI + 1
--             end
--             --print(totI[k])
--             if i == tonumber(args[3])+1 then
--                 for k_, v_ in ipairs(v.pool) do
--                     print("Item : "..v_.item.." | "..(v_.chosen and "Chosen "..v_.chosen.." times." or "Not Chosen").." | ".. string.format("%.2f", (v_.chosen or 0)/totI*100) .. "%")
--                 end
--             end
--         end
--     end

-- end)

function GiveHeistElectronics(src, heist, lucky)
    local Player = QBCore.Functions.GetPlayer(src)
    local h = Config.Electronics[heist]
    local am = math.random(h.min, h.max)
    if lucky then am = math.ceil(am+(am*0.05)) end
    if Player.Functions.AddItem(h.item, am) then
	    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[h.item], "add", am)
        return true, am, h.item
    else return false end
end exports("GiveHeistElectronics", GiveHeistElectronics)
