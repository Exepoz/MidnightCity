PBCUtils = {}
if Config.Framework.Framework == "QBCore" then
    QBCore = nil
    QBCore = exports['qb-core']:GetCoreObject()
    PlayerLoaded = "QBCore:Client:OnPlayerLoaded"
elseif Config.Framework.Framework == "ESX" then
    ESX = exports['es_extended']:getSharedObject()
    PlayerLoaded = "esx:playerLoaded"
end

RegisterNetEvent(PlayerLoaded, function()
    Wait(5000) DistanceCheck() SetupPaletoBank() PBCUtils.Debug(Lcl('debug_targetsloaded'))
end)

--~=====================~--
--~ Cops & Jobs Related ~--
--~=====================~--

--- Get the amount of cops on duty
---@return function -- Amount of Cops on Duty
function PBCUtils.GetCurrentCops()
    local p = promise.new()
    if Config.Framework.Framework == "QBCore" then
        QBCore.Functions.TriggerCallback('cr-paletobankrobbery:server:GetCops', function(amount)
            if amount then p:resolve(amount) else p:reject() end
        end)
    elseif Config.Framework.Framework == "ESX" then
        ESX.TriggerServerCallback('cr-paletobankrobbery:server:GetCops', function(amount)
            if amount then p:resolve(amount) else p:reject() end
        end)
    end
    return p
end

-- Call Cops Function
---@param type string - Type of call
-- Sends the police call either directly to the dispatch script which takes care of who gets the notification, or sends the call to every player and triggers the notification on their end.
function PBCUtils.CallCops(type)
    if Config.Police.ServerSideDispatch or Config.Police.Dispatch == 'qb' then
        TriggerServerEvent("cr-paletobankrobbery:server:callCops", type)
    else
        TriggerEvent("cr-paletobankrobbery:client:callCops", type)
    end
end

-- Check if Player is part of a police job.
function PBCUtils.IsPolice()
    if Config.Framework.Framework == "QBCore" then
        for _, value in ipairs(Config.Police.PoliceJobs) do
            if value == QBCore.Functions.GetPlayerData().job.name then
                return true
            end
        end
        return false
    elseif Config.Framework.Framework == "ESX" then
        for _, value in ipairs(Config.Police.PoliceJobs) do
            if value == ESX.GetPlayerData().job.name then
                return true
            end
        end
        return false
    end
end

-- Check if a player is on Duty
function PBCUtils.OnDuty()
    if Config.Framework.Framework == "QBCore" then
        return QBCore.Functions.GetPlayerData().job.onduty
    elseif Config.Framework.Framework == "ESX" then
        return ESX.GetPlayerData().job.onduty
    end
end

--~===========~--
--~ Minigames ~--
--~===========~--

--- Door Lockpicking
function PBCUtils.Circle(type)
    local p = promise.new() -- Do not touch
    local Diff = Config.Difficulties[type].CircleMinigameTimeDifficulty
    local Circles = Config.Difficulties[type].CircleAmount
    if Config.Framework.CircleMinigame == "ps-ui" then
        exports['ps-ui']:Circle(function(success)
            p:resolve(success)
        end, math.random(Circles.min, Circles.max), math.random(Diff.min, Diff.max))
    elseif Config.Framework.CircleMinigame == "qb-lock" then
        local circles = math.random(Circles.min, Circles.max)
        local seconds = math.random(Diff.min, Diff.max)
        local success = exports['qb-lock']:StartLockPickCircle(circles, seconds)
        p:resolve(success)
    elseif Config.Framework.CircleMinigame == "oxlib" then
        local pass = 0
        local circleAmount = math.random(Circles.min, Circles.max)
        for i = 1, circleAmount do
            local success = lib.skillCheck(Config.Difficulties[type].OxLibDifficulty)
            if not success then break end
            pass = i
        end
        if pass >= circleAmount then p:resolve(true) else p:resolve(false) end
    end
    return p -- Do not touch
end

function PBCUtils.HackingMinigame(heist)
    local p = promise.new() -- Do not touch
    local Heist = Config.Difficulties[heist]
    if Heist.Hack == "Dimbo" then
        PBCUtils.Debug(Lcl('debug_startinghack', "Dimbo Password"))
        TriggerEvent("DimboPassHack:StartHack", Heist.Dimbo.Difficulty, function(passed)
            p:resolve(passed)
        end)
    elseif Heist.Hack == "VAR" then
        PBCUtils.Debug(Lcl('debug_startinghack', "VAR"))
        if Heist.Var.Script == "psui" then
            exports['ps-ui']:VarHack(function(success)
                p:resolve(success)
            end, Heist.Var.Blocks, Heist.Var.TimeToShow)
        elseif Heist.Var.Script == "standalone" then
            exports['varhack']:OpenHackingGame(function(success)
                p:resolve(success)
            end, Heist.Var.Blocks,Heist.Var.TimeToShow)
        end
    elseif Heist.Hack == "NumberColor" then
        if Heist.NumberColor.Script == "jesper" then
            exports["hacking"]:hacking(function()
                p:resolve(true)
            end, function() p:resolve(false) end)
        elseif Heist.NumberColor.Script == "nathan" then
            exports['hacking']:OpenHackingGame(Heist.NumberColor.TimeToType, Heist.NumberColor.Amount, Heist.NumberColor.Repeats, function(Success)
                p:resolve(Success)
            end)
        else PBCUtils.Debug(Lcl('debug_hackconfigerror')) end
    elseif Heist.Hack == "mHacking" then
        TriggerEvent("mhacking:show")
        TriggerEvent("mhacking:start", Heist.mHacking.NumberAmount, Heist.mHacking.TimeToHack, function(success)
            TriggerEvent('mhacking:hide')
            p:resolve(success)
        end)
    end
    return p -- Do not touch
end

function PBCUtils.GateExplosive()
    local Diff = Config.Difficulties.MetalGate
    local p = promise.new() -- Do not touch
    if Diff.Script == "MemoryGame" then
        exports['memorygame']:thermiteminigame(Diff.CorrectBlocks, Diff.IncorrectBlocks, Diff.TimeToShow, Diff.TimeToLose,
        function() p:resolve(true) end, function() p:resolve(false) end)
    elseif Diff.Script == "PSUI" then
        exports['ps-ui']:Thermite(function(success) p:resolve(success) end, 10, 5, Diff.IncorrectBlocks)
    end
    return p -- Do not touch
end

--~===============~--
--~ Items Related ~--
--~===============~--

-- Item Check Function
---@param item string - Item Looked For
function PBCUtils.HasItem(item)
    local p  = promise.new() -- Do not touch
    if Config.Framework.UseOxInv then
        local invItem = exports.ox_inventory:Search('slots', item)
        if invItem[1] then p:resolve(invItem[1].label) else p:resolve(false) end
    elseif Config.Framework.Framework == "QBCore" then
        local hasItem = QBCore.Functions.HasItem(item)
        if hasItem then p:resolve(QBCore.Shared.Items[item].label) else p:resolve(false) end
    elseif Config.Framework.Framework == "ESX" then
        ESX.TriggerServerCallback('cr-paletobankrobbery:server:HasItem', function(HasItem)
            p:resolve(HasItem)
        end, item)
    else
        PBCUtils.Debug(Lcl('debug_standalonefunction'))
    end
    return p -- Do not touch
end

-- Show Missing Item
---@param item string -Item Name for Item Displayed 
function PBCUtils.MissingItem(item)
    if Config.Framework.Framework == "QBCore" then
        local data = {[1] = {name = QBCore.Shared.Items[item]["name"], image = QBCore.Shared.Items[item]["image"]}}
        Wait(250)
        TriggerEvent('inventory:client:requiredItems', data, true)
        Wait(2500)
        TriggerEvent('inventory:client:requiredItems', data, false)
    elseif Config.Framework.Framework == "ESX" then
        -- Shows a notification instead of an item box
        FBCUtils.Notif(3, Lcl('notif_MissingSpecificItem', item), Lcl('PaletoTitle', item))
    end
end
--~=======~--
--~ Utils ~--
--~=======~--

function PBCUtils.Debug(msg)
    if not Config.Debug then return end
    print("^4[^1DEBUG^4]^2 "..msg.."^0")
end

--- Progress Bar
---@param time integer --Time in MS
---@param text string -- Text Displayed
---@param onFinish function -- On Finsh Function
---@param onCancel function -- On Cancel Function
---@param canCancel boolean -- Can the player cancel the animation
---@param freezeplayer boolean -- Does it Freeze the player
---@param dict? string -- Animation Dict
---@param anim? string -- Animation
---@param flag? integer -- Animation Flag
function PBCUtils.ProgressUI(time, text, onFinish, onCancel, canCancel, freezeplayer, dict, anim, flag)
    if not onFinish then onFinish = function() end end
    if not onCancel then onCancel = function() end end
    if Config.Framework.ProgressUI == "mythic" then
        TriggerEvent("mythic_progbar:client:progress", {name = "CRBurnerphoneCall", duration = time, label = text, useWhileDead = false, canCancel = canCancel,
            controlDisables = { disableMovement = freezeplayer, disableCarMovement = freezeplayer, disableMouse = false, disableCombat = true },
            animation = { animDict = dict, anim = anim, flags = flag },
        }, function(status) if status then onCancel() else onFinish() end end)
    elseif Config.Framework.ProgressUI == "rprogress" then
        local Progress = Config.RProgressUI
        local Anim = {animationDictionary = dict, animationName = anim}
        local Controls = {Mouse = false, Player = freezeplayer, Vehicle = freezeplayer}
        Progress.canCancel = canCancel Progress.Duration = time Progress.Label = text Progress.Animation = Anim Progress.DisableControls = Controls
        Progress.onComplete = function(cancelled) if cancelled then onCancel() else onFinish() end end
        exports['rprogress']:Custom(Progress)
    elseif Config.Framework.ProgressUI == "oxlib" then
        local pb = { duration = time, label = text, useWhileDead = false, canCancel = canCancel, disable = {car = freezeplayer, move = freezeplayer, combat = freezeplayer}}
        if dict and anim then pb.anim = {dict = dict, clip = anim, flag = flag} end
        if lib.progressBar(pb) then onFinish() else onCancel() end
    elseif Config.Framework.Framework == "QBCore" then
        QBCore.Functions.Progressbar("CRPaletoBankRobbery", text, time, true, canCancel,
        { disableMovement = freezeplayer, disableCarMovement = freezeplayer, disableMouse = false, disableCombat = true },
        { animDict = dict, anim = anim, flags = flag},
        {}, {}, function() onFinish() end, function() onCancel() end)
    elseif Config.Framework.Framework == "ESX" then
        ESX.Progressbar(text, time,{ FreezePlayer = freezeplayer,
            animation = { type = "anim", dict = dict, lib = anim },
            onFinish = onFinish(), onCancel = onCancel()
        })
    else
        PBCUtils.Debug(Lcl('debug_standalonefunction'))
    end
end

function PBCUtils.PhoneSound(stop, coords)
    if stop then exports['xsound']:Destroy('PhoneRinging')
    else exports['xsound']:PlayUrlPos("PhoneRinging", './sounds/phoneringing.ogg', 0.8, coords) end
end

--- Update Scoreboard status
---@param active boolean -- true = Heist Active or In Cooldown | false = Heist Available
function PBCUtils.UpdateScoreboard(active)
    if not Config.Framework.Framework == "QBCore" then return end
    TriggerServerEvent('qb-scoreboard:server:SetActivityBusy', "paletobankrobbery", active)
end

-- DrawText Function
---@param bool boolean - true = Displays DrawText | False = Removes Current DrawText
---@param text? string - Message shown
function PBCUtils.DrawText(bool, text)
	if bool then
        if not text then text = "" end
        if Config.Framework.DrawText == "oxlib" then lib.showTextUI(text)
		elseif Config.Framework.DrawText == 'okok' then exports['okokTextUI']:Open(text, 'darkblue', 'right')
        elseif Config.Framework.DrawText == "PSUI" then exports['ps-ui']:DisplayText(text, "primary")
		elseif Config.Framework.Framework == 'QBCore' then exports['qb-core']:DrawText(text, 'right')
        elseif Config.Framework.Framework == "ESX" then exports['esx_textui']:TextUI(text)
		end
	else
        if Config.Framework.DrawText == "oxlib" then lib.hideTextUI()
		elseif Config.Framework.DrawText == 'okok' then exports['okokTextUI']:Close()
        elseif Config.Framework.DrawText == "PSUI" then exports['ps-ui']:HideText()
		elseif Config.Framework.Framework == 'QBCore' then exports['qb-core']:HideText()
        elseif Config.Framework.Framework == "ESX" then exports['esx_textui']:HideUI()
        end
	end
end

-- Unlocking a door
---@param door string - Door ID
function PBCUtils.UnlockDoor(door)
    PBCUtils.Debug(Lcl('debug_unlockdoor', door))
    if Config.Framework.Doorlocks == "qb" or Config.Framework.Doorlocks == "QB" then
        TriggerServerEvent('qb-doorlock:server:updateState', door, false, false, true, true, false, false)
    elseif Config.Framework.Doorlocks == "nui" or Config.Framework.Doorlocks == "NUI" then
        TriggerServerEvent('nui_doorlock:server:updateState', door, false, false, false, true)
    else
        PBCUtils.Debug(Lcl('debug_DoorConfigError'))
    end
end

-- Reseting a bank's door
---@param door string -Door Being Reset
function PBCUtils.ResetDoors(door)
    if Config.Framework.Doorlocks == "qb" or Config.Framework.Doorlocks == "QB" then
        TriggerServerEvent('qb-doorlock:server:updateState', door, true, false, true, true, false, false)
    elseif Config.Framework.Doorlocks == "nui" or Config.Framework.Doorlocks == "NUI" then
        TriggerServerEvent('nui_doorlock:server:updateState', door, true, false, false, true)
    elseif Config.Framework.Doorlocks == "ox" then
        TriggerServerEvent('cr-paletobankrobbery:server:TriggerOxLocks', door, 1)
    else
        print("Door Configuration Error, please advise Staff Team.")
    end
end

-- Client-Sided Notification Matrix
---@param notifType number - Notification Type (1 = Success, 2 = Info, 3 = Failure)
---@param message string - Message Sent
---@param title? string - Message Title (If Applicable)
function PBCUtils.Notif(notifType, message, title)
    local notif = Config.Framework.Notifications
    local nType = ''
    local oxType = 'inform'
    if notifType == 1 then nType = "success" oxType = "success"
    elseif notifType == 2 then
        if notif == "qb" or notif == "tnj" then nType = "primary"
        elseif notif == "okok" or notif == "ESX" then nType = "info"
        elseif notif == "mythic" then nType = "inform" end
    elseif notifType == 3 then nType = "error" oxType = "error"
    end

	if notif == "okok" then exports['okokNotify']:Alert(title, message, 3000, nType)
	elseif notif == "mythic" then exports['mythic_notify']:DoHudText(nType, message)
	elseif notif == 'chat' then TriggerEvent('chatMessage', message)
	elseif notif == "tnj" then exports['tnj-notify']:Notify(message, nType, 3000)
    elseif notif == "oxlib" then lib.notify({title = title, description = message, type = oxType})
    elseif notif == 'qb' then QBCore.Functions.Notify(message, nType)
    elseif notif == "ESX" then ESX.ShowNotification(message, nType, 3000)
--luacheck: push ignore
	elseif notif == 'other' then
		--You can add any notification system here.
	end
--luacheck: pop
end

-- Client Event used for oxlib server-to-client notification
RegisterNetEvent('cr-paletobankrobbery:client:Notify', function(type, message, title)
    PBCUtils.Notif(type, message, title)
end)