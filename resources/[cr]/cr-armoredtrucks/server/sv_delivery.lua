local QBCore = exports['qb-core']:GetCoreObject()
local CurrentPlayer

RegisterNetEvent('cr-armoredtrucks:server:GetInQueue', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if GetQueue()[source] then TriggerClientEvent('QBCore:Notify', src, 'We already made this deal...', 'error') return end
    if not Player.Functions.RemoveMoney('cash', Config.Delivery.QueuePrice) then TriggerClientEvent('QBCore:Notify', src, 'Come back when you have the money... in CASH.', 'error') return end
    AddQueue(source, Player.PlayerData.citizenid)
    TriggerClientEvent('QBCore:Notify', src, 'Perfect, keep your phone near you and don\'t miss it! Plenty of people would like this info...', 'success')
end)

local function isCop(job)
    for _, v in pairs(Config.PoliceJobs) do
        if job == v then return true end
    end
    return false
end

RegisterNetEvent('cr-armoredtrucks:server:PoliceGps', function (DeliveryTruckPosition)
    local players = QBCore.Functions.GetQBPlayers()
    for _, v in pairs(players) do
        if v and isCop(v.PlayerData.job.name) then
            TriggerClientEvent('cr-armoredtrucks:client:PoliceGps', v.PlayerData.source, DeliveryTruckPosition)
        end
    end
end)

RegisterServerEvent('cr-armoredtrucks:server:DeliveryPayouts', function()
    if GetTimeOut() then TriggerClientEvent('QBCore:Notify', source, 'You took too long... The deal is off!', 'error') SetTimeOut(false) return end
    SetCompleted(true)
    SetCooldown(true)
	local PlayerId = source
	local Player = QBCore.Functions.GetPlayer(PlayerId)
    local bagInfo = {}
    bagInfo.type = "TruckDelivery"
    bagInfo.typeName = "Groupe 6 Truck Delivery"
	Player.Functions.AddItem('lootbag', 1, false, bagInfo)
    Debug(Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. " has finished the bank truck delivery and now has "..Player.PlayerData.metadata['armtruckrep']+1 .." reputation")
	TriggerClientEvent('inventory:client:ItemBox', PlayerId, QBCore.Shared.Items['lootbag'], "add", 1)
    if Player.PlayerData.metadata['armtruckrep'] < Config.Reputation.DeliveryCap then GiveXP(PlayerId) end
    if Player.PlayerData.metadata['armtruckrep']+1 == Config.Reputation.DeliveryNeededForConvoy then
        Debug('Sending Convoy Info Email')
        local emailData = {
            sender = 'Anonymous',
            subject = 'Mutual Interests',
            message = "Hey. You\'ve been doing quite a good job with those trucks. I might have something better for you. If you bring me back the loot you get, I\'ll let you in on some information that will get you better stuff. Drop it off in a box in the storage room at the corner of Alta Street & Clinton Ave. Oh, and make sure you\'ve got a System Breacher with you.. You will need it.",
            button = {enabled = true, buttonEvent = 'cr-armoredtrucks:client:getConvoyDropOffLocation'}
        }
        TriggerEvent('qs-smartphone:server:sendNewMailToOffline', Player.PlayerData.citizenid, emailData)
    end
    if Player.PlayerData.metadata['armtruckrep']+1 == 3 then
        Debug('Sending Progression Info Email')
        local emailData = {
            sender = 'Anonymous',
            subject = 'Mutual Interests',
            message = "Hey. Keep doing what you\'re doing and I\'ll contact you with a great opportunity. We\'re watching you.",
            --button = {enabled = false, buttonEvent = ''}
        }
        TriggerEvent('qs-smartphone:server:sendNewMailToOffline', Player.PlayerData.citizenid, emailData)
    end

    local charinfo = Player.PlayerData.charinfo
    local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
    local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
    local pName = firstName.." "..lastName
    local logString = {ply = GetPlayerName(PlayerId), txt = "Player : ".. GetPlayerName(PlayerId) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\n **Has completed the Truck Delivery\nCurrent Rep :** "..Player.PlayerData.metadata['armtruckrep']+1}
    TriggerEvent("qb-log:server:CreateLog", "armTruck", "Heist Completed.", "green", logString)

    CreateThread(function()
        Debug('Cooldown Started')
        Wait(Config.Delivery.Cooldown * 60000)
        Debug('Cooldown Finished')
        SetCooldown(false)
        ResetQueue()
        Wait(5000)
        if not GetQueueState() then TriggerEvent('cr-armoredtrucks:server:TruckQueue', true) return end
    end)
end)

QBCore.Functions.CreateCallback('cr-armoredtrucks:timeout', function(_, cb) cb(GetTimeOut()) end)
RegisterNetEvent('cr-armoredtrucks:setPlayer', function() CurrentPlayer = source end)
RegisterNetEvent('cr-armoredtrucks:server:LoopFx', function(coords) print('yeah') print(coords) TriggerClientEvent('cr-armoredtrucks:client:LoopFx', -1, coords) end)
