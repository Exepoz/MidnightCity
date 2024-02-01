local QBCore = exports['qb-core']:GetCoreObject()

-- Deposit Loot into box & Get in Queue
RegisterNetEvent('cr-armoredtrucks:server:depoThatBag', function(dataBag)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local typeMatch, enoughMoney = false, false
    if (dataBag and Player.PlayerData.items[dataBag.bag].name ~= 'lootbag') then TriggerClientEvent('QBCore:Notify', src, 'You don\'t seem to have these items with you anymore...', 'error') return end
    if dataBag and Player.PlayerData.items[dataBag.bag].info.type == "TruckDelivery" then typeMatch = true end
    local emailData, nope
    if not dataBag then nope = true emailData = {sender = 'Anonymous', subject = '?????', message = 'Uh, where is the Loot??? Why is there only money???'}
    --elseif not dataMoney then nope = true emailData = {sender = 'Anonymous', subject = '?????', message = 'Did you forget the money????? I\'m keeping your stuff. Don\'t forget next time.'}
    --elseif not enoughMoney then nope = true emailData = {sender = 'Anonymous', subject = '?????', message = 'Are you trying to undercut me? You forgot some of the money.'}
    elseif not typeMatch then nope = true emailData = {sender = 'Anonymous', subject = '?????', message = 'I don\'t know why you dropped off that kind of loot, but eh, THANKS ANYWAYS. Next time bring me what I ask.'}
    end
    if dataBag then
        Player.Functions.RemoveItem('lootbag', 1, dataBag.bag)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['lootbag'], "remove", 1)
    end
    -- if dataMoney then
    --     Player.Functions.RemoveItem('markedbills', 1, dataMoney.money)
    --     TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "remove", 1)
    -- end
    if nope then Wait(math.random(120,180)*1000) TriggerEvent('qb-phone:server:sendNewMail', emailData, Player.PlayerData.citizenid)
    else TriggerEvent('cr-armoredtrucks:server:GetInConvoyQueue', src) end
end)

-- Get in Queue (Depoed loot in truck)
RegisterNetEvent('cr-armoredtrucks:server:GetInConvoyQueue', function(src)
    local Player = QBCore.Functions.GetPlayer(src)
    local cid =  Player.PlayerData.citizenid
    local emailData = {}
    if GetConvoyQueue()[src] then
        if not Config.Debug then Wait(math.random(120,180)*1000) end
        emailData = {sender = 'Anonymous', subject = 'Mutual Interests.', message = 'We already made that deal.. Welp thanks for the extra stuff haha!'}
    else
        AddQueue(src, cid) AddConvoyQueue(src, cid)
        if not Config.Debug then Wait(math.random(120,180)*1000) end
        emailData = {sender = 'Anonymous', subject = 'Mutual Interests.', message = 'Thank you for the drop off. I\'ll send you an email if I see a roaming truck...'}
    end
    TriggerEvent('qb-phone:server:sendNewMail', emailData, cid)
end)


RegisterServerEvent('cr-armoredtrucks:server:Payouts', function()
    if GetTimeOut() then TriggerClientEvent('QBCore:Notify', source, 'You took too long... The deal is off!', 'error') SetTimeOut(false) return end
    SetCompleted(true)
    SetCooldown(true)
	local PlayerId = source
    local bagInfo = {}
	local Player = QBCore.Functions.GetPlayer(PlayerId)
    -- bagInfo.type = "RoamingTruck"
    -- bagInfo.typeName = "Roaming Armored Truck"
    -- bagInfo.pool = GlobalState.TruckRoaming.Type
	-- Player.Functions.AddItem('lootbag', 1, false, bagInfo)
	-- TriggerClientEvent('inventory:client:ItemBox', PlayerId, QBCore.Shared.Items['lootbag'], "add", 1)
    exports['mdn-extras']:GiveLootBag(PlayerId, 'RoamingTruck', GlobalState.TruckRoaming.Type.company)
    Debug(Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. " has finished the bank truck convoy and now has "..Player.PlayerData.metadata['armtruckrep']+1 .." reputation")
    if Player.PlayerData.metadata['armtruckrep'] < Config.Reputation.RoamingCap then GiveXP(PlayerId) end
    if Player.PlayerData.metadata['armtruckrep'] == Config.Reputation.XPNeededForMerryweather then
        Debug('Sending Merryweather Info Email')
        local emailData = {
            sender = 'Anonymous',
            subject = 'Mutual Interests',
            message = "Hey. You\'ve become a real pro. Thank you for what you\'ve done. I can get you in contact with some other people, but you\'ll need to connect to a chatroom on the darkweb. There\'s a laptop at 10100, you can connect to it. Maybe you could find some harder jobs on there.",
            button = {enabled = true, buttonEvent = 'cr-armoredtrucks:client:get10100Room'}
        }
        TriggerEvent('qb-phone:server:sendNewMail', emailData, Player.PlayerData.citizenid)
    end

    local charinfo = Player.PlayerData.charinfo
    local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
    local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
    local pName = firstName.." "..lastName
    local logString = {ply = GetPlayerName(PlayerId), txt = "Player : ".. GetPlayerName(PlayerId) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\n ** Has completed the Truck Convoy\n\nCurrent Rep :** "..Player.PlayerData.metadata['armtruckrep']+1}
    TriggerEvent("qb-log:server:CreateLog", "armTruck", "Heist Completed (Lvl 2).", "green", logString)

    CreateThread(function()
        Wait(Config.Roaming.Cooldown * 60000)
        SetCooldown(false)
        ResetQueue()
        Wait(5000)
        if not GetQueueState() then TriggerEvent('cr-armoredtrucks:server:TruckQueue', true) return end
    end)
end)

-- RegisterCommand('setTruckXP',function()
--     local PlayerId = source
--     local Player = QBCore.Functions.GetPlayer(PlayerId)
--     Player.Functions.SetMetaData('armtruckrep', 40)
-- end)
