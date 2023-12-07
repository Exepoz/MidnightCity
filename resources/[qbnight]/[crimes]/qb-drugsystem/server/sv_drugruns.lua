if not Shared.Enable.Drugruns then return end

local packageCache = {}

--- Events

RegisterNetEvent('qb-drugsystem:server:CollectPackageGoods', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid
    if not packageCache[citizenid] then return end

    if packageCache[citizenid].state == 'waiting' then
        TriggerClientEvent('QBCore:Notify', src, _U('still_waiting'), 'error', 2500)
    elseif packageCache[citizenid].state == 'done' then
        local info = {
            drug = packageCache[citizenid].drug,
            purity = packageCache[citizenid].purity
        }
        if Player.Functions.AddItem(Shared.DrugrunPackageItem, 1, false, info) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Shared.DrugrunPackageItem], 'add', 1)
            debugPrint(GetPlayerName(src) .. ' (' .. src .. ')' .. ' has received suspicious package ' .. packageCache[citizenid].drug .. ' purity ' .. packageCache[citizenid].purity)
            packageCache[citizenid] = nil
            TriggerClientEvent('qb-drugsystem:client:PackageGoodsReceived', src)
        else
            TriggerClientEvent('QBCore:Notify', src, _U('could_not_add_item'), 'error', 2500)
        end
    end
end)

RegisterNetEvent('qb-drugsystem:server:DestroyWaitForPackage', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid
    if not packageCache[citizenid] then return end
    
    packageCache[citizenid] = nil
    TriggerClientEvent('QBCore:Notify', src, _U('moved_too_far'), 'error', 2500)
    debugPrint(GetPlayerName(src) .. ' (' .. src .. ')' .. ' destroyed waiting for suspicious package')
end)

RegisterNetEvent('qb-drugsystem:server:DrugrunDelivery', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local item = Player.Functions.GetItemByName(Shared.DrugrunPackageItem)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], 'remove', 1)
        Wait(2000)
        local cops = getCopCount()
        if cops > Shared.PayOut.copCap then cops = copCap end
        local payout = math.random(Shared.PayOut.baseMin, Shared.PayOut.baseMax) + cops * Shared.PayOut.copMultiplier + item.info.purity * Shared.PayOut.purityMultiplier
        Player.Functions.AddMoney('cash', payout)
        debugPrint(GetPlayerName(src) .. ' (' .. src .. ')' .. ' Delivered suspicious package ' .. payout)
    end
end)

--- Callbacks

QBCore.Functions.CreateCallback('qb-drugsystem:server:PackageGoods', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid

    if packageCache[citizenid] then
        cb(false)
        return
    end

    for _, item in pairs(Player.PlayerData.items) do
        if item.name == Shared.DrugLabs['meth'].items.curedItem then
            Player.Functions.RemoveItem(item.name, 1, item.slot)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], 'remove', 1)
            packageCache[citizenid] = {
                state = 'waiting',
                drug = 'meth',
                purity = item.info.purity
            }
            CreateThread(function()
                Wait(Shared.DrugrunPackageTime * 60 * 1000)
                if packageCache[citizenid] then
                    packageCache[citizenid].state = 'done'
                end
            end)
            cb(true)
            return
        elseif item.name == Shared.DrugLabs['coke'].items.curedItem then
            Player.Functions.RemoveItem(item.name, 1, item.slot)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], 'remove', 1)
            packageCache[citizenid] = {
                state = 'waiting',
                drug = 'coke',
                purity = item.info.purity
            }
            CreateThread(function()
                Wait(Shared.DrugrunPackageTime * 60 * 1000)
                if packageCache[citizenid] then
                    packageCache[citizenid].state = 'done'
                end
            end)
            cb(true)
            return
        elseif item.name == Shared.DrugLabs['weed'].items.curedItem then
            Player.Functions.RemoveItem(item.name, 1, item.slot)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], 'remove', 1)
            packageCache[citizenid] = {
                state = 'waiting',
                drug = 'weed',
                purity = item.info.purity
            }
            CreateThread(function()
                Wait(Shared.DrugrunPackageTime * 60 * 1000)
                if packageCache[citizenid] then
                    packageCache[citizenid].state = 'done'
                end
            end)
            cb(true)
            return
        end
    end

    cb(false)
end)
