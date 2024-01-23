if Config.Debug then SetConvar("ox:printlevel:mdn-nighttime", "debug") end
local QBCore = exports['qb-core']:GetCoreObject()
local preys = {}
local hunters = {}
local BloodyPreys = {}
GlobalState.BloodyPreys = BloodyPreys


AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
    local bPreys = MySQL.Sync.fetchAll('SELECT * FROM midnight_bloodypreys')
    BloodyPreys = bPreys
    GlobalState.BloodyPreys = BloodyPreys
    --QBCore.Debug(BloodyPreys)
end)

---@param src? number Checks Player's jobs to see if they can be hunted.
---@return boolean Can be hunted?
local function safeJob(src)
    local job = QBCore.Functions.GetPlayer(src).PlayerData.job.name
    return Config.SafeJobs[job]
end

---@param src? number -- Player source
---@return string -- Player's Character Name
Midnight.Functions.GetCharName = function(src)
    local Player = QBCore.Functions.GetPlayer(src)
    local charinfo = Player.PlayerData.charinfo
    local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
    local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
    local pName = firstName.." "..lastName
    return pName
end

--- Sets an individual as bloody prey (NOT CODDED YET)
local setBloodyPrey = function(src, bool, prize)
    local cid = QBCore.Functions.GetPlayer(src).PlayerData.citizenid
    local Player = QBCore.Functions.GetPlayer(src)
    local logStr = {}
    if bool then
        local data = {
            cid = cid,
            name = Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname,
            time = os.time(),
            prize = prize or 500
        }
        BloodyPreys[cid] = data
        MySQL.update.await('INSERT INTO midnight_bloodypreys (cid, name, time, prize) VALUES (:cid, :name, :time, :prize)', data)
        local result = MySQL.query.await('SELECT * FROM midnight_hunters WHERE CID = ?', {cid})
        if not result or not result[1] then
            MySQL.insert('INSERT INTO midnight_hunters (CID, blacklisted, blacklisted_time) VALUES (?, ?, ?)', {CID, true, data.time})
        else
            local points = math.floor(result[1].points / 2)
            local bank = math.floor(result[1].bank / 2)
            MySQL.update.await('UPDATE midnight_hunters SET points = ?, unclaimed = ?, bank = ?, blacklisted = ?, blacklisted_time = ? WHERE cid = ?', {points, 0, bank, true, data.time, cid})
        end

        local pName = Midnight.Functions.GetCharName(src)
        local logString = {ply = GetPlayerName(src), txt = "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\n ** Has become a bloody prey."}
        TriggerEvent("qb-log:server:CreateLog", "bountyHunter", "New Bloody Prey.", "green", logString)
    else
        if not BloodyPreys[cid] then return end
        BloodyPreys[cid] = nil
        MySQL.query.await('DELETE FROM midnight_bloodypreys WHERE cid = ?', {cid})

        local pName = Midnight.Functions.GetCharName(src)
        local logString = {ply = GetPlayerName(src), txt = "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\n ** is not a bloody prey anymore."}
        TriggerEvent("qb-log:server:CreateLog", "bountyHunter", "Bloody Prey Removed.", "green", logString)
    end
    GlobalState.BloodyPreys = BloodyPreys
    TriggerClientEvent('nighttime:client:BloodyPreysUpdated', -1, BloodyPreys)
end

---
RegisterNetEvent('nighttime:server:createHunterProfile', function(alias)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CID = Player.PlayerData.citizenid
    MySQL.insert('INSERT INTO midnight_hunters (CID, nickname, hunter) VALUES (?, ?, ?)', {CID, alias, 1})
    Player.Functions.SetMetaData('huntAlias', alias)
    Midnight.Functions.Debug('Added New Hunter to the Database : (CID : '..CID..' | Player : '..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname.. " | Alias : "..alias)

    local pName = Midnight.Functions.GetCharName(src)
    local logString = {huntA = alias, ply = GetPlayerName(src), txt = "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\nNew Bounty Hunter Added to the Database : "..alias}
    TriggerEvent("qb-log:server:CreateLog", "bountyHunter", "New Hunter", "green", logString)
end)

--- Sets individuals as potential preys.
RegisterNetEvent('nighttime:server:enterHunt', function(serversource, bloody)
    local src = serversource or source
    if safeJob(src) and not bloody then return end
    local alr = false
    for k, v in pairs(preys) do if v == src then Midnight.Functions.Debug(src..' Person is already a prey') return end end
    table.insert(preys, src)
    GlobalState.BountyTargets = preys
    Player(src).state.isPrey = true
    Midnight.Functions.Debug(src..' has entered the hunt')
end)

local function leaveHunt(serversource, quit)
    local src = serversource or source
    for k, v in pairs(preys) do if v == src then
        if Player(src).state.Bloody and not quit then break
        else
            Player(src).state.isPrey = false
            preys[k] = nil end
    end end
    GlobalState.BountyTargets = preys
    Midnight.Functions.Debug(src..' has left the hunt')
end

--- Removes the player from the prey list.
RegisterNetEvent('nighttime:server:leaveHunt', function(serversource, quit)
    local src = serversource or source
    leaveHunt(src, quit)
end)

--- Adds the player to the hunters list.
RegisterNetEvent('nighttime:server:startHunting', function()
    local src = source
    Player(src).state.isHunting = true
    local Player = QBCore.Functions.GetPlayer(src)
    hunters[Player.PlayerData.citizenid] = 0
    exports['qb-phone']:sendNewMailToOffline(Player.PlayerData.citizenid, {
        sender = 'Anonymous',
        subject = 'Welcome to the Hunt!',
        message = 'Welcome Hunter!<br><br>'..
        'You are now receivng the location of individuals who are outside, unprotected* at night. ' ..
        'You may cycle through preys to find one suitable to your current location. Every minute, your will receive a more precise location, until you get your prey\'s exact coordinates.' ..
        'You may identify any individuals you see in the target\'s sector to find out if they are your prey.' ..
        'Once you find the correct prey, you are allowed reap their bounty and slay them.' ..
        '<br><br>- Do NOT kill any innocent individual while being an active hunter or else you will be marked as a Bloody Prey.' ..
        '<br>- You may kill an other hunter to steal their unclaimed points.' ..
        '<br>- You can go cash in your bounties at the Quartermaster located at the Hub when the night is over.'
    })
    Midnight.Functions.Debug(src..' just entered as a bounty hunter.')

    local pName = Midnight.Functions.GetCharName(src)
    local logString = {huntA = Player.PlayerData.metadata.huntAlias, ply = GetPlayerName(src), txt = "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\nHas Started Hunting"}
    TriggerEvent("qb-log:server:CreateLog", "bountyHunter", "Started Hunting.", "green", logString)
end)

--- Removes the player from the hunters list.
RegisterNetEvent('nighttime:server:stopHunting', function(serversource)
    local src = serversource or source
    local Player = QBCore.Functions.GetPlayer(src)
    hunters[Player.PlayerData.citizenid] = nil
    Midnight.Functions.Debug(src..' has stopped hunting')

    local pName = Midnight.Functions.GetCharName(src)
    local logString = {huntA = Player.PlayerData.metadata.huntAlias, ply = GetPlayerName(src), txt = "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\nHas Stopped Hunting"}
    TriggerEvent("qb-log:server:CreateLog", "bountyHunter", "Started Hunting.", "green", logString)
end)

--- Toggle state for when a player has id'ed their target.
RegisterNetEvent('nighttime:server:preyFound', function(target) Player(target).state.preyId = true end)

--- Processes an indvidual's death.
RegisterNetEvent('nighttime:server:processDeath', function(killer, inGreen)
    local src = source
    Midnight.Functions.Debug(src..' Processing Death for '..src)
    local Killer = QBCore.Functions.GetPlayer(killer)
    local Prey = QBCore.Functions.GetPlayer(src)
    local headerN = ''
    local descS = ''
    local hunterName = Midnight.Functions.GetCharName(killer)
    local preyName = Midnight.Functions.GetCharName(src)

    if not Config.Debug then Wait(math.random(3,5)*1000) end
    if inGreen then
        -- Player got killed inside a green zone (BAD)
        -- Wait(math.random(3,5)*1000)
        Midnight.Functions.Debug(killer..' just spilled blood in a green zone.. ('..src..')')
        exports['qb-phone']:sendNewMailToOffline(Killer.PlayerData.citizenid, {
            sender = 'Anonymous',
            subject = 'Blood Spilled...',
            message = 'Dear Hunter,<br><br>'..
            'You have wronged the Golden Trail. You have killed an individual inside a protected area.' ..
            'For this, you will now be marked as a <b>Bloody Prey</b>.' ..
            '<br><br>-Night Hunters are able to select you as their prey. Your location is updated live for anyone hunting you.' ..
            '<br>- You are barred from any Hub Services for the next 48 hours.' ..
            '<br>- You have lost h+alf of your hunter score. (if applicable)',
            '<br>Thank you for your cooperation. We will enjoy seeing you run.'
        })
        descS = 'Has spilled blood in a green zone.'
        headerN = "Process Death - GreenZone"
        Killer.Functions.SetMetaData('bloodyPrey', true)

        local logString = {huntA = Killer.PlayerData.metadata.huntAlias, ply = GetPlayerName(killer), txt = "Player : ".. GetPlayerName(killer) .. "\nCharacter : "..hunterName.."\nCID : "..Killer.PlayerData.citizenid.."\n\n"..descS}
        TriggerEvent("qb-log:server:CreateLog", "bountyHunter", headerN, "green", logString)

        setBloodyPrey(killer, true)
        return
    end
    if not hunters[Killer.PlayerData.citizenid] then return end
    -- Killer is a hunter
    if hunters[Killer.PlayerData.citizenid] == src then
        -- Player killed was hunter's prey (GOOD)
        Midnight.Functions.Debug(killer..' just killed their bounty ('..src..')')
        TriggerClientEvent('nighttime:addBountyDied', killer, src, NetworkGetNetworkIdFromEntity(GetPlayerPed(src)))

        descS = 'Has killed their prey.'
        headerN = "Process Death - Prey"

    elseif hunters[Prey.PlayerData.citizenid] then
        -- Player killed was also a hunter (OKAY)
        Midnight.Functions.Debug(killer..' just killed an other hunter.. ('..src..')')
        TriggerClientEvent('nighttime:addBountyDied', killer, src, NetworkGetNetworkIdFromEntity(GetPlayerPed(src)), true)
        exports['qb-phone']:sendNewMailToOffline(Killer.PlayerData.citizenid, {
            sender = 'Anonymous',
            subject = 'Hunter Killed.',
            message = 'Dear Hunter,<br><br>'..
            'You are lucky to have killed an other hunter' ..
            '<br>You may reap their unclaimed bounty points if they are carrying some.' ..
            '<br><br>Be careful of who you kill. Harming an innocenent person holds grave consequences.'
        })

        descS = 'Has killed an other hunter.'
        headerN = "Process Death - Hunter"
    else
        local grace = MySQL.query.await('SELECT grace FROM midnight_hunters WHERE CID = ?', {Killer.PlayerData.citizenid})
        if grace > 0 then
            -- Player killed was a random person, but killer has Marks of Grace. (OKAY)
            Midnight.Functions.Debug(killer..' just spilled the wrong blood but had Marks of Grace.. ('..src..')')
            exports['qb-phone']:sendNewMailToOffline(Killer.PlayerData.citizenid, {
                sender = 'Anonymous',
                subject = 'Wrong Blood Spilled.',
                message = 'Dear Hunter,<br><br>'..
                'You have killed an individual which was NOT your target, and NOT a hunter.' ..
                'You are lucky to be currently holding some Marks of Grace.' ..
                'One will be deducted from your account. Be careful next time...'
            })

            descS = 'Has killed an innocent person, but had Marks of Grace.'
            headerN = "Process Death - Innocent (MOG)"
            MySQL.Async.execute('UPDATE midnight_hunters SET grace = grace - 1 WHERE CID = ?', {Killer.PlayerData.citizenid})
        else
            -- Player killed was a random person, not the prey. (BAD!!)
            Midnight.Functions.Debug(killer..' just spilled the wrong blood.. ('..src..')')
            exports['qb-phone']:sendNewMailToOffline(Killer.PlayerData.citizenid, {
                sender = 'Anonymous',
                subject = 'Wrong Blood Spilled.',
                message = 'Dear Hunter,<br><br>'..
                'You have broken the terms of the hunt. You have killed an individual which was NOT your target.' ..
                'For this, you will now be marked as a <b>Bloody Prey</b>.' ..
                '<br><br>- Hunters are able to select you as their prey. Your location is updated live for anyone hunting you.' ..
                '<br>- You are barred from any Hub Services for the next 48 hours.' ..
                '<br>- You have lost half of your hunter score.'
            })

            descS = 'Has killed an innocent person.'
            headerN = "Process Death - Innocent"

            Killer.Functions.SetMetaData('bloodyPrey', true)
            setBloodyPrey(killer, true)
        end
    end
    local logString = {huntA = Killer.PlayerData.metadata.huntAlias, ply = GetPlayerName(killer), txt = "Player : ".. GetPlayerName(killer) .. "\nCharacter : "..hunterName.."\nCID : "..Killer.PlayerData.citizenid.."\n\n"..descS}
    TriggerEvent("qb-log:server:CreateLog", "bountyHunter", headerN, "green", logString)
end)

--- Claiming Bounty when killing proper target
RegisterNetEvent('nighttime:server:claimBounty', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    MySQL.Async.execute('UPDATE midnight_hunters SET unclaimed = unclaimed + 1 WHERE CID = ?', {Player.PlayerData.citizenid})
    hunters[Player.PlayerData.citizenid] = 0
    TriggerClientEvent('nighttime:client:bountyCooldown', src)

    local pName = Midnight.Functions.GetCharName(src)
    local txt = 'Has Claimed their prey\'s Bounty.\n\n'
    local logString = {huntA = Player.PlayerData.metadata.huntAlias, ply = GetPlayerName(src), txt = "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\n"..txt}
    TriggerEvent("qb-log:server:CreateLog", "bountyHunter", "Bounty Claimed", "green", logString)
end)

--- Receiving hunt Dongle
RegisterNetEvent('nighttime:server:giveHuntDongle', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem('bh_dongle', 1, false, {cid = Player.PlayerData.citizenid})
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['bh_dongle'], "add", 1)
    -- local pName = Midnight.Functions.GetCharName(src)
    -- local txt = 'Has Claimed their prey\'s Bounty.\n\n'
    -- local logString = {huntA = Player.PlayerData.metadata.huntAlias, ply = GetPlayerName(src), txt = "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\n"..txt}
    -- TriggerEvent("qb-log:server:CreateLog", "bountyHunter", "Bounty Claimed", "green", logString)
end)

--- Stealing hunters's unclaimed points.
RegisterNetEvent('nighttime:server:stealPoints', function(data)
    local src = source
    local hSrc = data.hSrc
    local cid = QBCore.Functions.GetPlayer(src).PlayerData.citizenid
    local kcid = QBCore.Functions.GetPlayer(hSrc).PlayerData.citizenid
    local result = MySQL.query.await('SELECT unclaimed FROM midnight_hunters WHERE CID = ?', {kcid})
    MySQL.Async.execute(
        'UPDATE midnight_hunters SET unclaimed = CASE WHEN CID = :killed THEN 0 WHEN CID = :killer THEN unclaimed + :newPoints ELSE unclaimed END WHERE CID IN (:killed, :killer)',
        {killed = kcid, killer = cid, newPoints = result[1].unclaimed}
    )

    local pName = Midnight.Functions.GetCharName(src)
    local oName = Midnight.Functions.GetCharName(hSrc)
    local txt = 'Killed '..oName.."("..QBCore.Functions.GetPlayer(hSrc).PlayerData.metadata.huntAlias..") and stole their unclaimed points ("..result[1].unclaimed..")"
    local logString = {huntA = QBCore.Functions.GetPlayer(src).PlayerData.metadata.huntAlias, ply = GetPlayerName(src), txt = "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..cid.."\n\n"..txt}
    TriggerEvent("qb-log:server:CreateLog", "bountyHunter", "Bounty Claimed", "green", logString)


    Midnight.Functions.Debug(src..' has stolen '..result[1].unclaimed.." unclaimed points from "..hSrc)
    TriggerClientEvent('QBCore:Notify', src, 'You have stolen '..result[1].unclaimed.. ' points from an other hunter.', 'info')
end)

--- Kicks the player from the server.
RegisterNetEvent('nighttime:GoToBed', function()
    local src = source
    DropPlayer(src, "Went to bed.")
    Midnight.Functions.Debug(src..' quit at The District.')
end)

--- Checks if player is bloody when they go online
RegisterNetEvent('nighttime:server:checkIsBloodyPrey', function()
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local cid = Ply.PlayerData.citizenid
    for k,v in pairs(BloodyPreys) do
        if v.cid == cid then
            Player(src).state.isPrey = true
            Player(src).state.Bloody = true
            BloodyPreys[k].online = true
            BloodyPreys[k].source = src
            Ply.Functions.SetMetaData('bloodyPrey', true)
            TriggerEvent('nighttime:server:enterHunt', src, true)
            TriggerClientEvent('nighttime:server:alertIsBloody', src)
            break
        end
    end
end)

--- Selects a bloody prey as a player's target
RegisterNetEvent('nighttime:server:selectBloodyPrey', function(data)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local cid = Ply.PlayerData.citizenid
    if src == data.source then TriggerClientEvent('QBCore:Notify', src, 'You cannot hunt yourself...', 'error') return end
    local preyData = data.source ~= nil and QBCore.Functions.GetPlayer(data.source) or false
    local ped = GetPlayerPed(data.source)
    if not preyData or not ped or ped == 0 or not canBeHunted(data.source) then
        Midnight.Functions.Debug('Cant find new #'..src.."\'s target #"..data.source)
        TriggerClientEvent('QBCore:Notify', src, 'Cannot find prey currently...', 'error')
    return end
    Midnight.Functions.Debug('New Target Found for #'..src.." : "..newTarget.." (Bloody Prey)")
    hunters[cid] = data.source
    TriggerClientEvent('nighttime:client:selectBloodyPrey', src, data)
end)

--- Selects a bloody prey as a player's target
RegisterNetEvent('nighttime:server:bankPoints', function(data)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local cid = Ply.PlayerData.citizenid
    MySQL.update.await('UPDATE midnight_hunters SET bank = bank + unclaimed, points = points + unclaimed, unclaimed = 0 WHERE cid = ?', {cid})
    Wait(100)
    TriggerClientEvent('crimHub:client:talkToQuartermaster', src)
end)

--- buying marks of grace
RegisterNetEvent('nighttime:server:buyMOG', function(amount)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local cid = Ply.PlayerData.citizenid
    local result = MySQL.query.await('SELECT grace, bank FROM midnight_hunters WHERE CID = ?', {cid})
    if not result or not result[1] then return end
    local grace, bank = result[1].grace, result[1].bank
    if grace + amount > 6 then amount = 6 - grace end
    if amount == 0 then
        TriggerClientEvent('QBCore:Notify', src, 'You can\'t buy any more Marks of Grace!', 'error')
        Wait(100)
        TriggerClientEvent('crimHub:client:talkToQuartermaster', src)
    return end
    if bank - (3*amount) >= 0 then
        MySQL.update.await('UPDATE midnight_hunters SET bank = ?, grace = ? WHERE cid = ?', {bank - (3*amount), grace + amount, cid})
        TriggerClientEvent('QBCore:Notify', src, 'You have successfully purchased more Marks Of Grace', 'success')
        Wait(100)
        TriggerClientEvent('crimHub:client:talkToQuartermaster', src)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You don\'t have enough banked points to buy these!', 'error')
        Wait(100)
        TriggerClientEvent('crimHub:client:talkToQuartermaster', src)
    end
end)

--- Buying crumbs for golden crumbs
RegisterNetEvent('nighttime:server:buyBHCrumbs', function(amount)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local cid = Ply.PlayerData.citizenid
    local result = MySQL.query.await('SELECT bank FROM midnight_hunters WHERE CID = ?', {cid})
    if not result or not result[1] then return end
    local bank = result[1].bank
    if amount > bank then amount = bank end
    if amount == 0 then
        TriggerClientEvent('QBCore:Notify', src, 'You don\'t have any points?', 'error')
        Wait(100) TriggerClientEvent('crimHub:client:talkToQuartermaster', src)
    return end
    local crumbs = amount * exports['mdn-extras']:fetchExchangeRate()
    if Ply.Functions.AddItem('midnight_crumbs', crumbs) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['midnight_crumbs'], "add", crumbs)
        MySQL.update.await('UPDATE midnight_hunters SET bank = ? WHERE cid = ?', {bank - amount, cid})
        Wait(100) TriggerClientEvent('crimHub:client:talkToQuartermaster', src)

        local pName = Midnight.Functions.GetCharName(src)
        local txt = 'Has bought '..crumbs..' Gold Crumbs with their Bounty Hunter Points.\n\n New Banked Points : '..bank - amount
        local logString = {huntA = Ply.PlayerData.metadata.huntAlias, ply = GetPlayerName(src), txt = "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\n"..txt}
        TriggerEvent("qb-log:server:CreateLog", "bountyHunter", "Crumbs Bought", "green", logString)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You can\'t carry these crumbs!', 'error')
        Wait(100) TriggerClientEvent('crimHub:client:talkToQuartermaster', src)
    end
end)

local function removeAllPreys()
    for _, v in pairs(preys) do
        leaveHunt(v, false)
    end
end

--- Toggle function for day/night (Triggered by weather/time resource)
---@param isNight boolean true -> is night time | false -> is day time.
---@param pre boolean true if this is for the warning 1 hour before night time
local ToggleDayNight = function(isNight, pre)
    Midnight.Functions.Debug('Toggle Daytime State - '..((pre and '1 hour before night') or (isNight and "Night") or "Day"))
    if pre then
        TriggerClientEvent('nighttime:client:nightWarning', -1, 'pre')
    elseif isNight then
        TriggerClientEvent('nighttime:client:nightWarning', -1, 'night')
    else
        TriggerClientEvent('nighttime:client:nightWarning', -1, 'day')
        removeAllPreys()
    end
end exports("ToggleDayNight", ToggleDayNight)

--- Generates a new target from the list of preys
---@param source number Hunter's source ID
---@param current number Hunter's current target
local generateNewTarget = function(source, current)
    local newTarget = preys[math.random(#preys)]
    Midnight.Functions.Debug("Generated : "..(newTarget or "NIL"))
    if newTarget == current or newTarget == source or newTarget == nil then return nil
    else return newTarget end
end

local canBeHunted = function(source)
    local retval = true
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.metadata.isdead then retval = false end
    return retval
end

Midnight.Functions.IsBlacklisted = function(src)
    local Player = QBCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT * FROM midnight_hunters WHERE CID = ?', {cid})
    if not result or not result[1] then return false end
    local isBlacklisted, blTime = result[1].blacklisted == 1 and true or false, result[1].blacklisted_time
    if isBlacklisted and os.time() > blTime + 172800 then
        isBlacklisted = false
        blTime = nil
        if result[1].hunter == 0 then MySQL.query.await('DELETE FROM midnight_hunters WHERE cid = ?', {cid})
        else MySQL.Async.execute('UPDATE midnight_hunters SET blacklisted = ?, blacklisted_time = ? WHERE CID = ?', {0, nil, tonumber(cid)}) end
        return false
    elseif isBlacklisted then return true
    else return false end
end

--- Fetches if a player is blacklisted
QBCore.Functions.CreateCallback('mdn-nighttime:IsBlacklisted', function(source, cb)
    local retval = Midnight.Functions.IsBlacklisted(source)
    cb(retval)
end)

--- Fetches the online bloody preys
QBCore.Functions.CreateCallback('mdn-bountyHunt:fetchBloodyPreys', function(_, cb)
    for k, v in pairs(BloodyPreys) do
        local player = QBCore.Functions.GetPlayerByCitizenId(tostring(v.cid))
        if player then BloodyPreys[k].online = true
        else BloodyPreys[k].online = false end
    end
    cb(BloodyPreys)
end)

--- Fetches the target's location
---@param target number Hunter's current target
QBCore.Functions.CreateCallback('mdn-bountyHunt:getTargetLocation', function(_, cb, target)
    if target == nil then cb('notFound') return end
    if not DoesPlayerExist(target) or not Player(target).state.isPrey or QBCore.Functions.GetPlayer(target).PlayerData.metadata.isDead then cb('notFound') return end
    local ped = GetPlayerPed(target)
    if ped and ped ~= 0 then cb(GetEntityCoords(ped)) else cb("notFound") end
end)

--- Acquire a new target for the hunter
QBCore.Functions.CreateCallback('mdn-bountyHunt:getNewTarget', function(source, cb)
    Midnight.Functions.Debug('Finding new target for '..source)
    local Player = QBCore.Functions.GetPlayer(source)
    ::generate::
    Midnight.Functions.Debug('List of preys : ')
    if #preys < 3 then Midnight.Functions.Debug('There are not enough preys around currently.') TriggerClientEvent('QBCore:Notify', source, 'There are not enough preys around currently.', 'error') cb(nil) return end
    local currentTarget = hunters[Player.PlayerData.citizenid]
    --local newTarget = generateNewTarget(source, currentTarget)
    --local time = GetGameTimer()

    local newTarget = lib.waitFor(function()
        return generateNewTarget(source, currentTarget)
    end, 'Fetching Prey Timed Out', 3000)

    --while newTarget == nil do newTarget = generateNewTarget(source, currentTarget) if GetGameTimer() > time + 3000 then Midnight.Functions.Debug('Finding new target TimeOut for '..source) break end end
    if not newTarget then cb(nil) return end
    local ped = GetPlayerPed(newTarget)
    if not ped or ped == 0 or not canBeHunted(newTarget) then Midnight.Functions.Debug('Cant find new #'..source.."\'s target #"..newTarget) goto generate end
    hunters[Player.PlayerData.citizenid] = newTarget
    Midnight.Functions.Debug('New Target Found for #'..source.." : "..newTarget)
    cb(newTarget, GetEntityCoords(ped))
end)

--- Check if player is dead.
-- Currently Unused?
QBCore.Functions.CreateCallback("mdn-bountyHunt:isPlayerDead", function(source, cb, playerid)
    local Player = QBCore.Functions.GetPlayer(playerid)
    if Player.PlayerData.metadata["isdead"] then cb(true) else cb(false) end
end)

--- Fetches the user's data
QBCore.Functions.CreateCallback('nighttime:fetchUserData', function(source, cb, QM)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local cid = xPlayer.PlayerData.citizenid
    local item = xPlayer.Functions.GetItemByName('bh_dongle')
    local result = MySQL.query.await('SELECT * FROM midnight_hunters WHERE CID = ?', { cid})
    if not result or not result[1] then cb(false, item and item.info.cid or nil)
    else
        local isBlacklisted, blTime = result[1].blacklisted == 1 and true or false, result[1].blacklisted_time
        if isBlacklisted and os.time() > blTime + 172800 then
            isBlacklisted = false
            blTime = nil
            MySQL.Async.execute('UPDATE midnight_hunters SET blacklisted = ?, blacklisted_time = ?, WHERE CID = ?', {isBlacklisted, nil, xPlayer.PlayerData.citizenid})
        end
        local data = {
            CID = result[1].CID,
            nickname = result[1].nickname,
            points = result[1].points,
            unclaimed = result[1].unclaimed,
            bank = result[1].bank,
            blacklisted = isBlacklisted,
            blacklisted_time = blTime,
            grace = result[1].grace,
        }
        Player(src).state:set('bhprofile', data, true)
        cb(data, item.info.cid)
    end
end)

-- remove them if they're dropped
AddEventHandler('playerDropped', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not Player.PlayerData then return end
    if hunters[Player.PlayerData.citizenid] then TriggerEvent('nighttime:server:stopHunting', src) end
    TriggerEvent('nighttime:server:leaveHunt', src, true)
end)

RegisterCommand('checkPreys', function()
    Midnight.Functions.Debug('List of Current Preys :')
    QBCore.Debug(preys)
end)

RegisterCommand('checkHunters', function()
    Midnight.Functions.Debug('List of Current Hunters :')
    QBCore.Debug(hunters)
end)
