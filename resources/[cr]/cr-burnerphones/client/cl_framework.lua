BCUtils = {}
if Config.Framework.Framework == "QBCore" then
    QBCore = nil
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework.Framework == "ESX" then
    ESX = exports['es_extended']:getSharedObject()
end

--~=====================~--
--~ Cops & Jobs Related ~--
--~=====================~--

--- Get the amount of cops on duty
function BCUtils.GetCurrentCops()
    local p = promise.new()
    if Config.Framework.Framework == "QBCore" then
        QBCore.Functions.TriggerCallback('cr-burnerphones:server:GetCops', function(amount)
            if amount then p:resolve(amount) else p:reject() end
        end)
    elseif Config.Framework.Framework == "ESX" then
        ESX.TriggerServerCallback('cr-burnerphones:server:GetCops', function(amount)
            if amount then p:resolve(amount) else p:reject() end
        end)
    end
    return p
end

-- Check if Player is part of a police job.
function BCUtils.IsPolice()
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
function BCUtils.OnDuty()
    if Config.Framework.Framework == "QBCore" then
        return QBCore.Functions.GetPlayerData().job.onduty
    elseif Config.Framework.Framework == "ESX" then
        return ESX.GetPlayerData().job.onduty
    end
end

-- Call Cops Function
---@param coords any - Coordinates for the police call
-- Sends the police call either directly to the dispatch script which takes care of who gets the notification, or sends the call to every player and triggers the notification on their end.
function BCUtils.CallCops(phone, coords)
    if Config.Burnerphones[phone].CallCops then
        if Config.Police.SendCallToAll or Config.Police.Dispatch == 'qb' then
            TriggerServerEvent("cr-burnerphones:server:callCops", coords)
        else
            TriggerEvent("cr-burnerphones:client:callCops", coords)
        end
    end
end

--~===============~--
--~ Items Related ~--
--~===============~--

-- Item Check Function
---@param item string - Item Looked For
---@return boolean
function BCUtils.HasItem(item)
    local p  = promise.new()
    if Config.Framework.UseOxInv then
        local invItem = exports.ox_inventory:Search('slots', item)
        if invItem[1] then p:resolve(invItem[1].label) else p:resolve(false) end
    elseif Config.Framework.Framework == "QBCore" then
        local hasItem = QBCore.Functions.HasItem(item)
        if hasItem then p:resolve(QBCore.Shared.Items[item].label) else p:resolve(false) end
    elseif Config.Framework.Framework == "ESX" then
        ESX.TriggerServerCallback('cr-salvage:server:HasItem', function(HasItem)
            p:resolve(HasItem)
        end, item)
    else
        print(Lcl('debug_standalonefunction'))
    end
    return p
end

--~=======~--
--~ Utils ~--
--~=======~--

--- Play an emote through DPEmote
---@param emote string - Emote Played
function BCUtils.PlayEmote(emote)
    if Config.Debug then print(Lcl('debug_PlayingEmote', emote)) end
    TriggerEvent('animations:client:EmoteCommandStart', {emote})
end

--- Progress Bar
---@param time integer --Time in MS
---@param text string -- Text Displayed
---@param onFinish function -- On Finsh Function
---@param onCancel function -- On Cancel Function
---@param freezeplayer boolean -- Does it Freeze the player
---@param dict? string -- Animation Dict
---@param anim? string -- Animation
---@param flag? integer -- Animation Flag
function BCUtils.ProgressUI(time, text, onFinish, onCancel, canCancel, freezeplayer, dict, anim, flag)
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

-- DrawText Function
---@param bool boolean - true = Displays DrawText | False = Removes Current DrawText
---@param text? string - Message shown
function BCUtils.DrawText(bool, text)
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

-- Client-Sided Notification Matrix
---@param notifType number - Notification Type (1 = Success, 2 = Info, 3 = Failure)
---@param message string - Message Sent
---@param title? string - Message Title (If Applicable)
function BCUtils.Notif(notifType, message, title)
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
RegisterNetEvent('cr-burnerphones:client:Notify', function(type, message, title)
    BCUtils.Notif(type, message, title)
end)