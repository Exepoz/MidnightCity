local QBCore = exports['qb-core']:GetCoreObject()

local lastrob = 0
local guardSpawned = false
local guardLeader = 0

for i = 1, 6 do
    GlobalState['artheist:paintings:'..i] = "show"
end

function CheckCanRob()
    if (os.time() - lastrob) < Config['ArtHeist']['nextRob'] and lastrob ~= 0 then return false
    else return true end
end exports("CheckCanRob", CheckCanRob)

QBCore.Functions.CreateCallback('artheist:server:checkRobTime', function(source, cb)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)

    if (os.time() - lastrob) < Config['ArtHeist']['nextRob'] and lastrob ~= 0 then
        local seconds = Config['ArtHeist']['nextRob'] - (os.time() - lastrob)
        TriggerClientEvent('QBCore:Notify', src, Strings['wait_nextrob'] .. ' ' .. math.floor(seconds / 60) .. ' ' .. Strings['minute'], "primary")
        cb(false)
    else
        lastrob = os.time()
        cb(true)
    end
end)

RegisterNetEvent('artheist:server:policeAlert')
AddEventHandler('artheist:server:policeAlert', function(coords)
    local players = QBCore.Functions.GetPlayers()

    for i = 1, #players do
        local player = QBCore.Functions.GetPlayer(players[i])
        if player.PlayerData.job.name == 'police' then
            TriggerClientEvent('artheist:client:policeAlert', players[i], coords)
        end
    end
end)

RegisterServerEvent('artheist:server:sendStartEmail', function(group)
    local str = "Alright, get to the Madrazo's Mansion & steal the paintings you see in the attachment. You can keep everything else you find but I NEED these paintins. Oh, and try not to alert the guards? Maybe sneak in or something. You can also kill everyone but that\'ll get the cops on your for sure.."
    local emailData = {
        sender = 'M4RCH4ND4RT',
        subject = "Things for you to know...",
        message = str,
        button = {enabled = true, buttonEvent = 'artheist:client:startEmailButton'}
    }
    for _, v in pairs(GlobalState.HeistGroups[group].grp) do
        TriggerEvent('qs-smartphone:server:sendNewMailToOffline', v.cid, emailData)
        TriggerClientEvent('artheist:client:gettinClose', v.src)
    end
end)

RegisterServerEvent('artheist:server:syncHeistStart', function() GlobalState['artheist:inProgress'] = true end)
RegisterServerEvent('artheist:server:syncPainting', function(k) GlobalState['artheist:paintings:'..k] = "taken" end)

RegisterServerEvent('artheist:server:syncAllPainting')
AddEventHandler('artheist:server:syncAllPainting', function()
    TriggerClientEvent('artheist:client:syncAllPainting', -1)
end)

RegisterServerEvent('artheist:server:AlertGuards', function(group)
    GlobalState['artheist:guardsAlerted'] = true
    for _, v in pairs(GlobalState.HeistGroups[group].grp) do
        TriggerClientEvent('artheist:client:AlertGuards', v.src, v.leader)
    end
end)

RegisterServerEvent('artheist:server:rewardItem')
AddEventHandler('artheist:server:rewardItem', function(scene)
    GlobalState['artheist:paintings:'..k] = "hide"
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local item = scene['rewardItem']

    if player then
        player.Functions.AddItem(item, 1)
    end
end)

RegisterServerEvent('artheist:server:finishHeist')
AddEventHandler('artheist:server:finishHeist', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)

    if player then
        for k, v in pairs(Config['ArtHeist']['painting']) do
            local count = player.Functions.GetItemByName(v['rewardItem'])
            if count ~= nil and count.amount > 0 then
                player.Functions.RemoveItem(v['rewardItem'], 1)
                player.Functions.AddMoney('cash', v['paintingPrice'], 'Art Heist')
            end
        end
    end
end)

QBCore.Functions.CreateCallback('artheist:SpawnGuards', function(source, cb)
    print("Checking Guards Spawn")
    if guardSpawned then cb(false) else guardSpawned = true guardLeader = source print("Spawning Guards") cb(true) end
end)

RegisterServerEvent('artheist:server:guardsAreSpawned', function(guards, group)
    print("Sending Guards Ids to group member")
    for k, v in pairs(guards) do
        print(v)
        for _, v_ in pairs(GlobalState.HeistGroups[group].grp) do
            TriggerClientEvent('artheist:client:guardsAlertLogic', v_.src, k, v)
        end
    end
    local src = source
end)
