FBCUtils = {}
local PlayerLoaded = ""
if Config.Framework.Framework == "QBCore" then
    QBCore = nil
    QBCore = exports['qb-core']:GetCoreObject()
    PlayerLoaded = "QBCore:Client:OnPlayerLoaded"
elseif Config.Framework.Framework == "ESX" then
    ESX = exports['es_extended']:getSharedObject()
    PlayerLoaded = "esx:playerLoaded"
end

RegisterNetEvent(PlayerLoaded, function()
    if Config.Debug then  print(Lcl('debug_loadingbanks')) end
    Wait(5000) SetupCRFleecaBanks()
    if Config.Framework.MLO == "Gabz" then PrepareBanks() end
    if Config.Debug then print(Lcl('debug_targetsloaded')) end
end)

-- Spawns Keypad props for Gabz's MLO
function PrepareBanks()
    LoadModel(579127396)
    for _, v in pairs(Config.Banks) do
        local keypad = CreateObject(579127396, v.PreVaultDoor.coords, false, false, false)
        SetEntityHeading(keypad, v.PreVaultDoor.heading)
    end
end

-- Show Missing Item
---@param item string -Item Name for Item Displayed
function FBCUtils.MissingItem(item)
    if Config.Framework.Framework == "QBCore" then
        local data = {[1] = {name = QBCore.Shared.Items[item]["name"], image = QBCore.Shared.Items[item]["image"]}}
        Wait(250)
        TriggerEvent('inventory:client:requiredItems', data, true)
        Wait(2500)
        TriggerEvent('inventory:client:requiredItems', data, false)
    elseif Config.Framework.Framework == "ESX" then
        -- Shows a notification instead of an item box
        FBCUtils.Notif(3, Lcl('MissingSpecificItem', item), Lcl('FleecaTitle'))
    end
end

--Show Items When Nearby
---@param item table - Table containing Item Name and Item Label
---@param bool boolean - Toggles if the item is showned or disabled
function FBCUtils.ShowItem(item, bool)
    if Config.Framework.Framework == "QBCore" then
        local data = {[1] = {name = QBCore.Shared.Items[item.item]["name"], image = QBCore.Shared.Items[item.item]["image"]}}
        TriggerEvent('inventory:client:requiredItems', data, bool)
    elseif Config.Framework.Framework == "ESX" then
        -- Shows a notification instead of an item box
        FBCUtils.Notif(3, Lcl('MissingSpecificItem', item.name), Lcl('FleecaTitle'))
    end
end

--- Get the amount of cops on duty
function FBCUtils.GetCurrentCops()
    local p = promise.new()
    if Config.Framework.Framework == "QBCore" then
        QBCore.Functions.TriggerCallback('cr-fleecabankrobbery:server:GetCops', function(amount)
            if amount then p:resolve(amount) else p:reject() end
        end)
    elseif Config.Framework.Framework == "ESX" then
        ESX.TriggerServerCallback('cr-fleecabankrobbery:server:GetCops', function(amount)
            if amount then p:resolve(amount) else p:reject() end
        end)
    end
    return p
end

--- Play an emote through DPEmote
---@param emote string - Emote Played
function FBCUtils.PlayEmote(emote)
    if Config.Debug then print(Lcl('debug_PlayingEmote', emote)) end
    TriggerEvent('animations:client:EmoteCommandStart', {emote})
end

--- Computer Hack Minigame
function FBCUtils.HackingMinigame()
    local p = promise.new() -- Do not touch
    local Heist = Config.Difficulties.ComputerHack
    if Heist.Hack == "Dimbo" then
        if Config.Debug then print(Lcl('debug_startinghack', "Dimbo Password")) end
        TriggerEvent("DimboPassHack:StartHack", Heist.Dimbo.Difficulty, function(passed)
            p:resolve(passed)
        end)
    elseif Heist.Hack == "VAR" then
        if Config.Debug then print(Lcl('debug_startinghack', "VAR")) end
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
            exports['hacking']:OpenHackingGame(Heist.NumberColor.TimeToType, Heist.NumberColor.Amount, Heist.NumberColor.Repeats, function(success)
                p:resolve(success)
            end)
        else print(Lcl('debug_hackconfigerror')) end
    elseif Heist.Hack == "mHacking" then
        TriggerEvent("mhacking:show")
        TriggerEvent("mhacking:start", Heist.mHacking.NumberAmount, Heist.mHacking.TimeToHack, function(success)
            TriggerEvent('mhacking:hide')
            p:resolve(success)
        end)
    elseif Heist.Hack == "Custom" then
        local settings = {gridSize = 15, lives = 3, timeLimit = 8500}
        exports["glow_minigames"]:StartMinigame(function(success)
            p:resolve(success)
        end, "path", settings)
    end
    return p -- Do not touch
end

--- Progress Bar
---@param time integer --Time in MS
---@param text string -- Text Displayed
---@param onFinish? function -- On Finsh Function
---@param onCancel? function -- On Cancel Function
---@param canCancel boolean -- Can the player cancel the animation
---@param freezeplayer boolean -- Does it Freeze the player
---@param dict? string -- Animation Dict
---@param anim? string -- Animation
---@param flag? integer -- Animation Flag
function FBCUtils.ProgressUI(time, text, onFinish, onCancel, canCancel, freezeplayer, dict, anim, flag)
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
        QBCore.Functions.Progressbar("CRBurnerphoneCall", text, time, true, canCancel,
        { disableMovement = freezeplayer, disableCarMovement = freezeplayer, disableMouse = false, disableCombat = true },
        { animDict = dict, anim = anim, flags = flag},
        {}, {}, function() onFinish() end, function() onCancel() end)
    elseif Config.Framework.Framework == "ESX" then
        ESX.Progressbar(text, time,{ FreezePlayer = freezeplayer,
            animation ={ type = "anim", dict = dict, lib = anim },
            onFinish = onFinish(), onCancel = onCancel()
        })
    else
        print(Lcl('debug_standalonefunction'))
    end
end

function FBCUtils.Logs(title, color, text)
    if Config.Framework.Framework == "QBCore" then
        TriggerServerEvent('qb-log:server:CreateLog', 'fleecabankrobbery', title, color, text)
    end
end

-- Update Scoreboard status (Only when bank cooldowns are global)
function FBCUtils.UpdateScoreboard(active)
    if Config.Framework.Framework == "QBCore" then
        TriggerServerEvent('qb-scoreboard:server:SetActivityBusy', "fleecabanks", active)
    end
end

--- Door Lockpicking
function FBCUtils.Circle(type)
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
        local circleAmount = math.random(Circles.min, Circles.max)
        local circles = {}
        for _ = 1, circleAmount do circles[#circles+1] = Config.Difficulties[type].OxLibDifficulty end
        local success = lib.skillCheck(circles)
        p:resolve(success)
    end
    return p -- Do not touch
end

--- Skillbar
function FBCUtils.Skillbar()
    local p = promise.new() -- Do not touch
    local Safe = Config.Difficulties.Safecracking.SkillbarDifficulty
    if Config.Framework.Skillbar == "qb-skillbar" then
        local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
        Skillbar.Start({
            duration = math.random(Safe.Duration.min * 1000, Safe.Duration.max * 1000),
            pos = math.random(10, 30),
            width = math.random(Safe.Width.min, Safe.Width.max),
        }, function() p:resolve(true) end, function() p:resolve(false) end)
    elseif Config.Framework.Skillbar == "custom" then
        print("Custom Hack Configuration")
        -- You can insert your own skillcheck here
        -- to return Success/Failure you need to use the following:
        -- p:resolve(true/false)
    end
    return p -- Do not touch
end

-- Check if Player is part of a police job.
function FBCUtils.IsPolice()
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
function FBCUtils.OnDuty()
    if Config.Framework.Framework == "QBCore" then
        return QBCore.Functions.GetPlayerData().job.onduty
    elseif Config.Framework.Framework == "ESX" then
        return ESX.GetPlayerData().job.onduty
    end
end

-- Call Cops Function
---@param coords any - Coordinates for the police call
-- Sends the police call either directly to the dispatch script which takes care of who gets the notification, or sends the call to every player and triggers the notification on their end.
function FBCUtils.CallCops(coords)
    if Config.Police.CallCops then
        if Config.Police.ServerSideDispatch or Config.Police.Dispatch == 'qb' then
            TriggerServerEvent("cr-fleecabankrobbery:server:callCops", coords)
        else
            TriggerEvent("cr-fleecabankrobbery:client:callCops", coords)
        end
    end
end

-- DrawText Function
---@param bool boolean - true = Displays DrawText | False = Removes Current DrawText
---@param text? string - Message shown
function FBCUtils.DrawText(bool, text)
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

-- Item Check Function
---@param item string - Item Looked For
---@return boolean
function FBCUtils.HasItem(item)
    local p  = promise.new()
    if Config.Framework.UseOxInv then
        local invItem = exports.ox_inventory:Search('slots', item)
        if invItem[1] then p:resolve(invItem[1].label) else p:resolve(false) end
    elseif Config.Framework.Framework == "QBCore" then
        local hasItem = QBCore.Functions.HasItem(item)
        if hasItem then p:resolve(QBCore.Shared.Items[item].label) else p:resolve(false) end
    elseif Config.Framework.Framework == "ESX" then
        ESX.TriggerServerCallback('cr-fleecabankrobbery:server:HasItem', function(HasItem)
            p:resolve(HasItem)
        end, item)
    else
        print(Lcl('debug_standalonefunction'))
    end
    return p
end

-- Unlocking a door
---@param door string - Door ID
function FBCUtils.UnlockDoor(door)
    if Config.Debug then
        print(Lcl('debug_unlockdoor', door))
    end
    if Config.Framework.Doorlocks == "qb" or Config.Framework.Doorlocks == "QB" then
        TriggerServerEvent('qb-doorlock:server:updateState', door, false, false, true, true, false, false)
    elseif Config.Framework.Doorlocks == "nui" or Config.Framework.Doorlocks == "NUI" then
        TriggerServerEvent('nui_doorlock:server:updateState', door, false, false, false, true)
    elseif Config.Framework.Doorlocks == "ox" then
        TriggerServerEvent('cr-fleecabankrobbery:server:TriggerOxLocks', door, 0)
    else
        print("Teller Door Configuration Error, please advise Staff Team.")
    end
end

-- Reseting a bank's door
---@param bank integer -Bank Being Reset
function FBCUtils.ResetDoors(bank)
    if Config.Framework.Doorlocks == "qb" or Config.Framework.Doorlocks == "QB" then
        TriggerServerEvent('qb-doorlock:server:updateState', Config.FleecaBankTellerDoors[bank], true, false, true, true, false, false)
        TriggerServerEvent('qb-doorlock:server:updateState', Config.PreVaultDoors[bank], true, false, true, true, false, false)
    elseif Config.Framework.Doorlocks == "nui" or Config.Framework.Doorlocks == "NUI" then
        TriggerServerEvent('nui_doorlock:server:updateState', Config.FleecaBankTellerDoors[bank], true, false, false, true)
        TriggerServerEvent('nui_doorlock:server:updateState', Config.PreVaultDoors[bank], true, false, false, true)
    elseif Config.Framework.Doorlocks == "ox" then
        TriggerServerEvent('cr-fleecabankrobbery:server:TriggerOxLocks', Config.FleecaBankTellerDoors[bank], 1)
        TriggerServerEvent('cr-fleecabankrobbery:server:TriggerOxLocks', Config.PreVaultDoors[bank], 1)
    else
        print("Door Configuration Error, please advise Staff Team.")
    end
end

-- Client-Sided Notification Matrix
---@param notifType number - Notification Type (1 = Success, 2 = Info, 3 = Failure)
---@param message string - Message Sent
---@param title? string - Message Title (If Applicable)
function FBCUtils.Notif(notifType, message, title)
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


--- Get the amount of cops on duty
function FBCUtils.hasItemData()
    local p = promise.new()
    if Config.Framework.Framework == "QBCore" then
        QBCore.Functions.TriggerCallback('cr-fleecabankrobbery:server:hasItemData', function(works)
            p:resolve(works)
        end)
    elseif Config.Framework.Framework == "ESX" then
        ESX.TriggerServerCallback('cr-fleecabankrobbery:server:GetCops', function(amount)
            if amount then p:resolve(amount) else p:reject() end
        end)
    end
    return p
end


-- Client Event used for oxlib server-to-client notification
RegisterNetEvent('cr-fleecabankrobbery:client:Notify', function(type, message, title)
    FBCUtils.Notif(type, message, title)
end)