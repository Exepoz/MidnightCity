local QBCore = exports['qb-core']:GetCoreObject()

local Queue = {}
local ConvoyQueue = {}
local TruckAccepted = false
local CurrentContracts = {}
local QueueTime
local QueueStarted = false
local TruckFound = false
local HeistInProgress = false
SoftProgressLock = 0
local AmountInQueue = 0
local CurrentHeistTime = nil


local TimeOut
local Completed

local onCooldown = false

local TruckDelivery = {}
local TruckRoaming = {}
GlobalState.TruckDelivery = TruckDelivery
GlobalState.TruckRoaming = TruckRoaming

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Citizen.Wait(Config.InitWait * 60000)
        TriggerEvent('cr-armoredtrucks:server:TruckQueue') -- Starts Queue
        GenerateInformation() -- Generates Sender Information for Merryweather
    end
end)

---------------
-- FUNCTIONS --
---------------

function GetTimeOut() return TimeOut end
function SetTimeOut(bool) TimeOut = bool end

function SetCompleted(bool) HeistInProgress = not bool end

function SetCooldown(bool) onCooldown = bool end

function AddQueue(ply, cid)
    Queue[ply] = cid
    local Player = QBCore.Functions.GetPlayer(ply)
    local charinfo = Player.PlayerData.charinfo
    local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
    local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
    local pName = firstName.." "..lastName
	local logString = {ply = GetPlayerName(ply), txt ="Player : ".. GetPlayerName(ply) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\nJoined Queue."}
	TriggerEvent("qb-log:server:CreateLog", "armTruck", "Joined Queue.", "green", logString)
end
function GetQueue() return Queue end
function GetQueueState() return QueueStarted end
function ResetQueue() QueueStarted = false end

function GetConvoyQueue() return ConvoyQueue end
function AddConvoyQueue(ply, cid)
    ConvoyQueue[ply] = cid
    local Player = QBCore.Functions.GetPlayer(ply)
    local charinfo = Player.PlayerData.charinfo
    local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
    local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
    local pName = firstName.." "..lastName
	local logString = {ply = GetPlayerName(ply), txt ="Player : ".. GetPlayerName(ply) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\nJoined Lvl 2 Queue."}
	TriggerEvent("qb-log:server:CreateLog", "armTruck", "Joined Lvl 2 Queue.", "green", logString)

end

function Debug(...)
    if not Config.DebugPrints then return end
    local msg = ""
    --for _, v in pairs(...) do msg = msg.." | "..v end
    print("^4[^1DEBUG^4]^2 ".. ... .."^0")
end

function GetCops()
    local amount = 0
    for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
        for _, jobs in pairs(Config.PoliceJobs) do
            if v.PlayerData.job.name == jobs and v.PlayerData.job.onduty then
                amount = amount + 1
            end
        end
    end
    return amount
end

function GiveXP(src)
	local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.SetMetaData('armtruckrep', Player.PlayerData.metadata.armtruckrep+1)
end

-- -----------------
-- -- QUEUE STUFF --
-- -----------------
-- Truck Queue
RegisterNetEvent('cr-armoredtrucks:server:TruckQueue', function()
    CreateThread(function()
        Debug('Starting Queue')
        if QueueStarted or HeistInProgress then return end
        QueueStarted = true
        --if cd then Wait(Config.QueueTime*60000) end
        Debug('Checking Availability.')
        if GetCops() < Config.Delivery.Cops or onCooldown then Debug("Heist Unavailable") Wait(10*60000) QueueStarted = false TriggerEvent('cr-armoredtrucks:server:TruckQueue')
        else
            --local currentQueue = 0
            --for _, _ in pairs(Queue) do currentQueue = currentQueue + 1 end
            --if currentQueue > AmountInQueue then AmountInQueue = currentQueue Debug("New People in queue, Adding Time...") Wait(15*60000) QueueStarted = false TriggerEvent('cr-armoredtrucks:server:TruckQueue') return end
            TriggerClientEvent('cr-armoredtrucks:client:Clean', -1)
            TruckAccepted, TruckFound, TimeOut, Completed, CurrentContracts = false, false, false, false, {}
            QueueTime = os.time()
            local l = 0
            Debug("Generating Queue")
            for k,v in pairs(Queue) do
                local emailData ={}
                if ConvoyQueue[k] and GetCops() >= Config.Roaming.Cops then
                    emailData = {
                        sender = 'Anonymous',
                        subject = 'Roaming Truck Spotted.',
                        message = 'Hey, one of my guys spotted a roaming truck. Do whatever you want with that info. The location is in the attachment.',
                        button = {enabled = true, buttonEvent = 'cr-armoredtrucks:client:acceptConvoy'}
                    }
                    --if Config.RemoveFromQueueOnEmailSend then ConvoyQueue[k] = nil end
                else
                    if ConvoyQueue[k] then
                        emailData = {
                            sender = 'Anonymous',
                            subject = 'Truck Spotted.',
                            message = 'Hey, we couldn\'t find a roaming truck, but one of my guys spotted one parked. At least it\'s something.. The location is in the attachment.',
                            button = {enabled = true, buttonEvent = 'cr-armoredtrucks:client:acceptTruck'}
                        }
                    else
                        emailData = {
                            sender = 'Elliot Lockheart',
                            subject = 'Truck Spotted.',
                            message = 'Hey, we spotted a bank truck. Open the attachment and you will get the location. Be quick or I will send this to someone else...',
                            button = {enabled = true, buttonEvent = 'cr-armoredtrucks:client:acceptTruck'}
                        }
                        if Config.RemoveFromQueueOnEmailSend then AmountInQueue = AmountInQueue - 1 Queue[k] = nil end
                    end
                end
                CurrentContracts[#CurrentContracts+1] = v
                TriggerEvent('qs-smartphone:server:sendNewMailToOffline', v, emailData)
                l = l+1 if l >= Config.EmailAmountSent then Debug("Emails Sent") break end
            end
            Debug("Emails Sent")
            Wait(Config.TimeToAccept*60000)
            QueueStarted = false
            if not TruckAccepted then Debug("Finding New Contract") CurrentContracts = {} TriggerEvent('cr-armoredtrucks:server:TruckQueue') end
        end
    end)
end)

-- -- Revives the bank truck queue when someone reconnects
-- RegisterNetEvent('cr-armoredtrucks:server:ReviveQueue', function()
--     local src = source
--     local Player = QBCore.Functions.GetPlayer(src)
--     local cid = Player.PlayerData.citizenid
--     for k, v in pairs(Queue) do
--         if v == cid then
--             if ConvoyQueue[k] then ConvoyQueue[source] = cid ConvoyQueue[k] = nil end
--             Queue[source] = cid Queue[k] = nil
--             print(cid.." Back in Queue")
--             TriggerClientEvent('QBCore:Notify', src, 'You are back in the Groupe 6 Truck Queue.', 'success')
--             break
--         end
--     end
-- end)

-------------------------------
-- Heists Start & Generation --
-------------------------------

RegisterNetEvent('cr-armoredtrucks:server:HeistStarted', function(heist)
    local Player = QBCore.Functions.GetPlayer(source)
    local cid = Player.PlayerData.citizenid
    TruckFound = true
    local emailData = {}
    if heist == "convoy" then
        emailData = {
            sender = 'Anonymous',
            subject = 'Mutual Interests',
            message = "There's some things you should know about those trucks. The vehicle is rigged with explosives linked to a heartbeat monitor attached to the driver. You need to hack into it\'s security using your System Breacher and disable it. Then, kill everyone, blow up the back door, & take what\'s inside. You can do this.",
        }
    elseif heist == "delivery" then
        emailData = {
            sender = 'Anonymous',
            subject = 'Mutual Interests',
            message = "Hey. We see you with that Truck. It would be in both our best interests if you secure that truck for me. I will let you have some of it\'s content. Wait until I update your gps with the drop off location.",
        }
    end
    TriggerEvent('qs-smartphone:server:sendNewMailToOffline', cid, emailData)
end)

RegisterNetEvent('cr-armoredtrucks:server:foundTruck', function() TruckFound = true end)

RegisterNetEvent('cr-armoredtrucks:server:startParkedTruck', function(success, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local time = os.time()

    if not success or HeistInProgress then
        TriggerClientEvent('QBCore:Notify', src, 'Truck Location Lost.', 'error')
        Player.PlayerData.items[item.slot].info.cooldown = time
        Player.Functions.SetInventory(Player.PlayerData.items)
    return end

    local charinfo = Player.PlayerData.charinfo
    local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
    local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
    local pName = firstName.." "..lastName
    local heistType = "Parked Truck Heist"
    local logString = {ply = GetPlayerName(src), txt ="Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\nHas started the "..heistType}
    TriggerEvent("qb-log:server:CreateLog", "armTruck", "Parked Armored Truck.", "green", logString)

    HeistInProgress = true
    CurrentHeistTime = time
    local truckPos = Config.Delivery.TruckLocations[math.random(#Config.Delivery.TruckLocations)]
    TruckDelivery.Pos = truckPos
    --TruckDelivery.DelPos = delPos
    GlobalState.TruckDelivery = TruckDelivery
    TriggerClientEvent('cr-armoredtrucks:client:StartDelivery', src, truckPos)
end)


RegisterNetEvent('cr-armoredtrucks:server:AcceptTruck', function(convoy)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if os.time() < QueueTime + Config.TimeToAccept*60000 and not TruckAccepted and src ~= nil then
        local match, cid = false, Player.PlayerData.citizenid
        for _, v in pairs(CurrentContracts) do if cid == v then match = true break end end
        if not match then
            TriggerClientEvent('qs-smartphone:client:notify', src, {
                title = 'Attachment Expired',
                text = 'The attachment is no longer available.',
                icon = "./img/apps/ping.png",
                timeout = 5000
            })
            return end
        TruckAccepted = true
        if not Config.RemoveFromQueueOnEmailSend then Queue[src] = nil if ConvoyQueue[src] then ConvoyQueue[src] = nil end end
        TriggerClientEvent('qs-smartphone:client:notify', src, {
            title = 'GPS Updated',
            text = 'GPS Updated with Truck Location.',
            icon = "./img/apps/ping.png",
            timeout = 2500
        })
        local charinfo = Player.PlayerData.charinfo
        local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
        local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
        local pName = firstName.." "..lastName
        local heistType = convoy and "Truck Convoy" or "Truck Delivery"
        local logString = {ply = GetPlayerName(src), txt ="Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\nHas started the "..heistType}
        TriggerEvent("qb-log:server:CreateLog", "armTruck", "Accepted Email.", "green", logString)
        -- Start Heist
        if convoy then
            ConvoyQueue[src] = nil
            Queue[src] = nil
            TruckRoaming.Type = Config.Roaming.TruckTypes[math.random(#Config.Roaming.TruckTypes)]
            GlobalState.TruckRoaming = TruckRoaming
            TriggerClientEvent('cr-armoredtrucks:client:GetTruckLocation', src)
        -- else
        --     local truckPos = Config.Delivery.TruckLocations[math.random(#Config.Delivery.TruckLocations)]
        --     TruckDelivery.Pos = truckPos
        --     --TruckDelivery.DelPos = delPos
        --     GlobalState.TruckDelivery = TruckDelivery
        --     TriggerClientEvent('cr-armoredtrucks:client:StartDelivery', src, truckPos)
        end
        HeistInProgress = true
        Debug('Heist In Progress')
        Wait(Config.TimeToFind*60000)
        Debug('Checking if Truck Found')
        if TruckFound then Debug('Truck Found, waiting for heist end') Wait(Config.TimeToComplete*60000)
            Debug('Time to complete the heist ended, checking if heist is still in progress.')
            if not HeistInProgress then return end
            Debug("Heist Took too long.. Resetting & Starting Cooldown.")
            HeistInProgress, TimeOut = false, true
            TriggerClientEvent('qs-smartphone:client:notify', src, {
                title = 'Truck Moved.',
                text = 'You took too long, the truck is gone!',
                icon = "./img/apps/ping.png",
                timeout = 5000
            })
            CreateThread(function()
                onCooldown = true
                local waitTime = Config.Delivery.Cooldown
                if convoy then waitTime = Config.Roaming.Cooldown end
                Wait(waitTime)
                onCooldown = false
                Debug("Cooldown Ended, Starting Queue.")
                TriggerEvent('cr-armoredtrucks:server:TruckQueue')
            end)
        else
            HeistInProgress = false
            onCooldown = false
            Debug('Truck not found, restarting queue.')
            TriggerEvent('cr-armoredtrucks:server:TruckQueue')
        end
    else
        TriggerClientEvent('qs-smartphone:client:notify', src, {
            title = 'Attachment Expired',
            text = 'The attachment is no longer available.',
            icon = "./img/apps/ping.png",
            timeout = 5000
        })
    end
end)

RegisterNetEvent('cr-armoredtrucks:server:remThermite', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(Config.Delivery.ThermiteItem, 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Delivery.ThermiteItem], "remove", 1)
end)

QBCore.Functions.CreateUseableItem('green_hacking', function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) then
        if item.cooldown and item.cooldown + 60 < os.time() then TriggerClientEvent('QBCore:Notify', src, 'The device is on cooldown...', 'error') return end
        TriggerClientEvent('QBCore:Notify', src, 'Locating Bank Truck...', 'info')
        Wait(math.random(2,4))
        if HeistInProgress then TriggerClientEvent('QBCore:Notify', src, 'There is not trucks around currently.', 'error') return end
        TriggerClientEvent('cr-armoredtrucks:client:locatingBankTruck', src, item)
    end
end)

----------------
-- Debug Stuff--
----------------

if Config.Debug then
    RegisterCommand('queue', function() TriggerEvent('cr-armoredtrucks:server:GetInConvoyQueue', src) end)
    RegisterCommand('SpawnTruck', function() TriggerEvent('cr-armoredtrucks:server:TruckQueue') end)

    RegisterNetEvent('mb-t', function(amount)
        local info = {worth = amount}
        local Player = QBCore.Functions.GetPlayer(source)
        Player.Functions.AddItem('markedbills', 1, false, info)
    end)
end


-- RegisterNetEvent('cr-armoredtrucks:server:bobcatHack', function()
--     local src = source
--     local Player = QBCore.Functions.GetPlayer(src)
--     Player.Functions.AddItem("bobcatorder", 1)
--     TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["bobcatorder"], "add", 1)
-- end)

-- local KeyGrabbed = false
-- RegisterNetEvent('cr-armoredtrucks:server:grabkeys', function()
--     local src = source
--     local Player = QBCore.Functions.GetPlayer(src)
--     if math.random(100) < 35 and not KeyGrabbed then
--         KeyGrabbed = true
--         Player.Functions.AddItem("bobcatkeys", 1)
--         TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["bobcatkeys"], "add", 1)
--     else
--         TriggerClientEvent('QBCore:Notify', src, 'You don\'t find anything useful...', 'error')
--     end
-- end)

RegisterCommand('getQueue', function()
    print_table(Queue)
    print_table(ConvoyQueue)
end)
