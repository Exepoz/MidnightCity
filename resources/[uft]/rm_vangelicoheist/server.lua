QBCore = nil
local QBCore = exports['qb-core']:GetCoreObject()
local lastrob = 0
local start = false
discord = {
    ['webhook'] = 'youweebhook',
    ['name'] = 'rm_vangelicoheist',
    ['image'] = 'https://cdn.discordapp.com/avatars/869260464775921675/dea34d25f883049a798a241c8d94020c.png?size=1024'
}

QBCore.Functions.CreateUseableItem(Config['VangelicoHeist']['gasMask']['itemName'], function(source)
	local src = source
    local player = QBCore.Functions.GetPlayer(src)

    if player then
        TriggerClientEvent('vangelicoheist:client:wearMask', src)
		player.Functions.RemoveItem(Config['VangelicoHeist']['gasMask']['itemName'], 1)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config['VangelicoHeist']['gasMask']['itemName']], "remove")
    end
end)

QBCore.Functions.CreateCallback('vangelicoheist:server:checkPoliceCount', function(source, cb)
    local src = source
    local players = QBCore.Functions.GetPlayer(src)
    local policeCount = 0

    for i = 1, #players do
        local player = QBCore.Functions.GetPlayer(players[i])
        if (player.PlayerData.job.name == 'police' and player.PlayerData.job.onduty) then
            policeCount = policeCount + 1
        end
    end

    if policeCount >= Config['VangelicoHeist']['requiredPoliceCount'] then
        cb(true)
    else
        cb(false)
        TriggerClientEvent('vangelicoheist:client:showNotification', src, Strings['need_police'])
    end
end)

QBCore.Functions.CreateCallback('vangelicoheist:server:checkTime', function(source, cb)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    
    if (os.time() - lastrob) < Config['VangelicoHeist']['nextRob'] and lastrob ~= 0 then
        local seconds = Config['VangelicoHeist']['nextRob'] - (os.time() - lastrob)
        TriggerClientEvent('QBCore:Notify', src, Strings['wait_nextrob'] .. ' ' .. math.floor(seconds / 60) .. ' ' .. Strings['minute'], "error")
        cb(false)
    else
        lastrob = os.time()
        start = true
        discordLog(player.PlayerData.name, ' started the Vangelico Heist!')
        cb(true)
    end
end)

QBCore.Functions.CreateCallback('vangelicoheist:server:hasItem', function(source, cb)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local playerItem = player.Functions.GetItemByName('gasmask')

    if player and playerItem ~= nil then
        if playerItem then
            cb(true, playerItem.label)
        else
            cb(false, playerItem.label)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'You need to add the required items to server database', "error")
    end
end)

RegisterServerEvent('vangelicoheist:server:policeAlert')
AddEventHandler('vangelicoheist:server:policeAlert', function(coords)
	local src = source
    local players = QBCore.Functions.GetPlayer(src)
    
    for i = 1, #players do
        local player = QBCore.Functions.GetPlayer(players[i])
        if (player.PlayerData.job.name == 'police' and player.PlayerData.job.onduty) then
            TriggerClientEvent('vangelicoheist:client:policeAlert', players[i], coords)
        end
    end
end)

RegisterServerEvent('vangelicoheist:server:rewardItem')
AddEventHandler('vangelicoheist:server:rewardItem', function(item)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local whitelistItems = {}

    if player then
        for k, v in pairs(Config['VangelicoHeist']['smashRewards']) do
            whitelistItems[v['item']] = true
        end

        for k, v in pairs(Config['VangelicoInside']['glassCutting']['rewards']) do
            whitelistItems[v['item']] = true
        end

        for k, v in pairs(Config['VangelicoInside']['painting']) do
            whitelistItems[v['rewardItem']] = true
        end

        if whitelistItems[item] then
            player.Functions.AddItem(item, 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
        else
            TriggerClientEvent('QBCore:Notify', src, 'Add item exploit playerID: ' .. src .. ' name: ' .. player.PlayerData.name, "error")
        end
    end
end)

RegisterServerEvent('vangelicoheist:server:sellRewardItems')
AddEventHandler('vangelicoheist:server:sellRewardItems', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local totalMoney = 0

    if player then
        for k, v in pairs(Config['VangelicoHeist']['smashRewards']) do
            local playerItem = player.Functions.GetItemByName(v['item']).amount
            if playerItem >= 1 then
                player.Functions.RemoveItem(v['item'], playerItem)
                player.Functions.AddMoney('cash', playerItem.count * v['price'], 'vangelico')
				totalMoney = totalMoney + (playerItem.count * v['price'])
            end
        end

        for k, v in pairs(Config['VangelicoInside']['glassCutting']['rewards']) do
            local playerItem = player.Functions.GetItemByName(v['item']).amount
            if playerItem >= 1 then
                player.Functions.RemoveItem(v['item'], playerItem)
                player.Functions.AddMoney('cash', playerItem.count * v['price'], 'vangelico')
                totalMoney = totalMoney + (playerItem.count * v['price'])
            end
        end

        for k, v in pairs(Config['VangelicoInside']['painting']) do
            local playerItem = player.Functions.GetItemByName(v['rewardItem']).amount
            if playerItem >= 1 then
                player.Functions.RemoveItem(v['rewardItem'], playerItem)
                player.Functions.AddMoney('cash', playerItem.count * v['paintingPrice'], 'vangelico')
                totalMoney = totalMoney + (playerItem.count * v['paintingPrice'])
            end
        end

        discordLog(player.PlayerData.name, ' Gain $' .. math.floor(playerItem) .. ' on the Vangelico Heist Buyer!')
        TriggerClientEvent('QBCore:Notify', src, Strings['total_money'] .. ' $' .. math.floor(playerItem), "success")
    end
end)

RegisterCommand('pdvangelico', function(source, args)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    
    if player then
        if (player.PlayerData.job.name == 'police' and player.PlayerData.job.onduty) then
            if start then
                TriggerClientEvent('vangelicoheist:client:resetHeist', -1)
                start = false
            end
        else
            TriggerClientEvent('QBCore:Notify', src, 'You are not cop!', "error")
        end
    end
end)

RegisterServerEvent('vangelicoheist:server:startGas')
AddEventHandler('vangelicoheist:server:startGas', function()
    TriggerClientEvent('vangelicoheist:client:startGas', -1)
end)

RegisterServerEvent('vangelicoheist:server:insideLoop')
AddEventHandler('vangelicoheist:server:insideLoop', function()
    TriggerClientEvent('vangelicoheist:client:insideLoop', -1)
end)

RegisterServerEvent('vangelicoheist:server:lootSync')
AddEventHandler('vangelicoheist:server:lootSync', function(type, index)
    TriggerClientEvent('vangelicoheist:client:lootSync', -1, type, index)
end)

RegisterServerEvent('vangelicoheist:server:globalObject')
AddEventHandler('vangelicoheist:server:globalObject', function(obj, random)
    TriggerClientEvent('vangelicoheist:client:globalObject', -1, obj, random)
end)

RegisterServerEvent('vangelicoheist:server:smashSync')
AddEventHandler('vangelicoheist:server:smashSync', function(sceneConfig)
    TriggerClientEvent('vangelicoheist:client:smashSync', -1, sceneConfig)
end)

function discordLog(name, message)
    local data = {
        {
            ["color"] = '3553600',
            ["title"] = "**".. name .."**",
            ["description"] = message,
        }
    }
    PerformHttpRequest(discord['webhook'], function(err, text, headers) end, 'POST', json.encode({username = discord['name'], embeds = data, avatar_url = discord['image']}), { ['Content-Type'] = 'application/json' })
end