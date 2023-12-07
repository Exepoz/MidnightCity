local QBCore = exports['qb-core']:GetCoreObject()

local run, ExoPlayer = 1, 0
local currentSequence, StockadeState = {}, {}
local t_o, a, RecIn, exoCompleted = false, false, false, false
local startTime = nil
local onCooldown = false

local TruckLooted = false

GlobalState.StockadeState = StockadeState

-- StockadeState.nameGiven

------------------------
-- Initiating Mission --
------------------------

-- Check if the heist is already InProgress, or  onCooldown, or if there is enough Cops, or if the player meats the XP Requirements
-- RegisterNetEvent('cr-armoredtrucks:server:checkReq', function()
-- 	local src = source
-- 	local Player = QBCore.Functions.GetPlayer(src)
-- 	if Player.PlayerData.metadata['armtruckrep'] < 40 then TriggerClientEvent("QBCore:Notify", src, 'You don\'t have the credentials to connect to this laptop','error') return end
--     if GetCops() < Config.Merryweather.CopsRequired or MissionInProgress or onCooldown then TriggerClientEvent("QBCore:Notify", src, 'There is no one connected to the chatroom at the moment.','error') return end
-- 	local order = Player.Functions.GetItemByName('security_contract')
-- 	TriggerClientEvent('cr-armoredtrucks:client:connectToLaptop', src, order or false)
-- end)

GetMWTruckReq = function(src)
    local retval = true
	local Player = QBCore.Functions.GetPlayer(src)
	if Player.PlayerData.metadata['armtruckrep'] < 40 then retval =  false end
    if GetCops() < Config.Merryweather.CopsRequired or MissionInProgress or onCooldown then retval = false end
	local order = Player.Functions.GetItemByName('security_contract')
    return retval, order or false
end exports('GetMWTruckReq', GetMWTruckReq)

-- Sending Fax, Activating Minigame / Mission
RegisterNetEvent('cr-armoredtrucks:server:receiveFax', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local order = Player.Functions.GetItemByName('security_contract')
	if not order then TriggerClientEvent("QBCore:Notify", src, 'You\'ve got nothing to send','error') return end
	Player.Functions.RemoveItem('security_contract', 1)
	startTime = os.time()
    MissionInProgress = true
	StockadeState.MissionInProgress = true
	GlobalState.StockadeState = StockadeState
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['security_contract'], "remove", 1)
    Wait(1000) TriggerClientEvent('cr-armoredtrucks:client:phoneCall', -1)
end)

--------------
-- Exo Says --
--------------

-- Colors & Location
local colors = {
    {color = 'blue', r = 0, g = 0, b = 255, coords = vector3(570.63, -3127.94, 18.73)},
    {color = 'green', r = 0, g = 255, b = 0, coords = vector3(570.2, -3127.97, 18.73)},
    {color = 'red', r = 255, g = 0, b = 0, coords = vector3(569.78, -3127.97, 18.73)},
    {color = 'yellow', r = 255, g = 255, b = 0, coords = vector3(569.36, -3127.96, 18.73)}
}

-- Generating Sequence
local function GenerateSequence(length)
    currentSequence = {}
    for _ = 1, length do
      local color = colors[math.random(#colors)]
      table.insert(currentSequence, color)
    end
    return currentSequence
end

-- Compare Sequences
local function CompareSequences(sequence1, sequence2)
    if sequence1.color ~= sequence2.color then return false end
    for i = 1, #sequence1 do if sequence1[i].color ~= sequence2[i].color then return false end end return true
end

-- Failure (Wrong Answer or TimeOut)
local function GameOver()
    TriggerClientEvent('cr-armoredtrucks:client:ShowGameOver', -1)
    Wait(2000)
    run, currentSequence, ExoPlayer, t_o, a, RecIn = 1, {}, 0, false, false, false
    GlobalState.ExoSays = nil
end

-- Showing Current Sequence
local function ShowExoSequence()
    for i = 1, #currentSequence do
        GlobalState.ExoSays = currentSequence[i] Wait(1000)
        GlobalState.ExoSays = nil Wait(300)
    end
    GlobalState.ExoSays = nil
    Wait(500) RecIn = true
    TriggerClientEvent('cr-armoredtrucks:client:GetPlayerInput', ExoPlayer, Config.Merryweather.ExoSays.Length[run])
    -- TimeOut if no answer received
    CreateThread(function()
        local init = os.time()
        while true do
            if a then break end
            if os.time() > init + Config.Merryweather.ExoTimeOutTime then
                t_o = true
                GameOver()
                break
            end
            Wait(1000)
        end
    end)
end

-- Game Loop
local function TriggerExo()
    if run > 3 then
        TriggerClientEvent('cr-armoredtrucks:client:ShowGameWin', -1)
        exoCompleted = true
        StockadeState.ExoCompleted = true
        GlobalState.StockadeState = StockadeState
        Wait(2000) TriggerClientEvent('cr-armoredtrucks:client:phoneCall', -1, true)
    else
        currentSequence = GenerateSequence(Config.Merryweather.ExoSays.Length[run])
        ShowExoSequence()
    end
end

-- Receiving Player Input & Rerunning Game / Failure
RegisterNetEvent('cr-armoredtrucks:server:RecPlayerInput', function(data)
    if not data or t_o or not RecIn then return end
    a = true
    local is_correct = CompareSequences(currentSequence, data)
    if is_correct then
        run = run+1
        TriggerClientEvent('cr-armoredtrucks:client:ShowRoundSuccess', -1)
        Wait(3000)
        TriggerExo()
    else
        GameOver()
    end
end)

-- Initate Game
RegisterNetEvent('cr-armoredtrucks:server:PlayExoSays', function()
    ExoPlayer = source
    TriggerClientEvent('cr-armoredtrucks:client:InitiateExoSays', -1)
    Wait(6300)
    TriggerExo()
end)


--------------------------------
-- Lvl 3 - Merryweather Truck --
--------------------------------

RegisterNetEvent('cr-armoretrcuks:server:nameGiven', function(phone)
    if not exoCompleted then
        --todo malicious player!!
        return
    else
        StockadeState.nameGiven = true
        TriggerClientEvent('cr-armoredtrucks:client:makeTruck', source, phone)
    end
end)

-- Generate New Sender Information
function GenerateInformation()
	local name = Config.Merryweather.Names[math.random(#Config.Merryweather.Names)]
	local number = math.random(1000, 9999)
	StockadeState.name = name StockadeState.number = number
	GlobalState.StockadeState = StockadeState
end

local function InitiateCooldown(time)
    CreateThread(function()
        Wait(time * 60000)
        TruckLooted = false
        onCooldown = false
        TriggerClientEvent('cr-armoredtrucks:server:MerryweatherSync', -1, 'reset')
    end)
end

-- Payout Stuff
RegisterServerEvent('cr-armoredtrucks:server:MerryweatherPayout', function()
    if TruckLooted then TriggerClientEvent('QBCore:Notify', source, 'There is nothing left inside!', 'error') return end
    if os.time() > startTime + Config.TimeToComplete then TriggerClientEvent('QBCore:Notify', source, 'You took too long... The deal is off!', 'error') return end
    TruckLooted = true
	local PlayerId = source
    local bagInfo = {}
	local Player = QBCore.Functions.GetPlayer(PlayerId)
    bagInfo.type = "MerryweatherTruck"
    bagInfo.typeName = "Merryweather Truck"
	Player.Functions.AddItem('lootbag', 1, false, bagInfo)
	TriggerClientEvent('inventory:client:ItemBox', PlayerId, QBCore.Shared.Items['lootbag'], "add", 1)
    GiveXP(PlayerId)
    InitiateCooldown()
end)

-- Check & Remove Explosives
RegisterNetEvent('cr-armoredtrucks:server:checkExplosives', function()
	local src = source
	local xPlayer = QBCore.Functions.GetPlayer(src)
	local item = xPlayer.Functions.GetItemByName(Config.BombItem)
	if not item or item.amount <= 0 then return TriggerClientEvent("QBCore:Notify", src, 'You don\'t have anything to blow the back of the truck open.','error') end
    xPlayer.Functions.RemoveItem(Config.BombItem, 1)
    TriggerClientEvent('cr-armoredtrucks:client:openBack', src)
end)

RegisterNetEvent('cr-armoredtrucks:server:MerryweatherSync', function(sync, ...) TriggerClientEvent('cr-armoredtrucks:client:MerryweatherSync', -1, sync, ...) end)
