local QBCore = exports['qb-core']:GetCoreObject()
local PackageCoords, MethVehicle, VehDist, PackagePed
---@alias vec3 any


function ResetExtras()
    PackageCoords = nil
    MethVehicle = nil
    VehDist = nil
    PackagePed = nil
end

function ActivateStarterPedTarget(npc)
    if Config.UseTarget then
        exports['qb-target']:AddTargetEntity(npc, { options = {
            { type = "client", event = "cr-methrun:client:StartRun", icon = "fas fa-comments", label = Lcl('interact_StartRun'),
                canInteract = function() return not LocalPlayer.state.JobDone end },
            { type = "client", event = "cr-methrun:client:CollectPayment", icon = "fas fa-comments-dollar", label = Lcl('interact_Payment'),
                canInteract = function() return LocalPlayer.state.JobDone end }, }, distance = 3.0 })
    else
        local ped = PlayerPedId()
        local target = GetEntityCoords(npc)
        local Label, Event
        while true do
            local PackDist
            local wait = 5000
            local pcoords = GetEntityCoords(ped)
            local vcoords = GetOffsetFromEntityInWorldCoords(MethVehicle, 0, -4.0, 0)
            local dist = #(pcoords - target)
            if LocalPlayer.state.GettingPackage then PackDist = #(pcoords - PackageCoords) print(PackDist) end
            if MethVehicle then VehDist = #(pcoords - vcoords) end
            if dist < 75 or (PackDist and PackDist < 75) or (VehDist and VehDist < 75) then
                wait = 1
            end
            if dist <= 2 then
                if not LocalPlayer.state.JobDone then Label = Lcl('interact_StartRun') Event = 'cr-methrun:client:StartRun' else Label = Lcl('interact_Payment') Event = 'cr-methrun:client:CollectPayment' end
                if LocalPlayer.state.JobDone or not GlobalState.RunInProgress then
                if not LocalPlayer.state['textui'] then MethRunDrawText(true, "["..Config.InteractKey.."] "..Label) LocalPlayer.state:set('textui', true, true) end
                if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then MethRunDrawText(false) TriggerEvent(Event, {npc = npc}) end end
            elseif LocalPlayer.state.GettingPackage and PackDist <= 2 then
                if not LocalPlayer.state['textui'] then MethRunDrawText(true, "["..Config.InteractKey.."] "..Lcl('interact_GetPackage')) LocalPlayer.state:set('textui', true, true) end
                if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then MethRunDrawText(false) TriggerEvent('cr-methrun:client:getPackage', {npc = PackagePed}) end
            elseif LocalPlayer.state.HasGoods and VehDist and VehDist <= 1 then
                if not LocalPlayer.state['textui'] then MethRunDrawText(true, "["..Config.InteractKey.."] "..Lcl('interact_DeliverGoods')) LocalPlayer.state:set('textui', true, true) end
                if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then MethRunDrawText(false) LocalPlayer.state:set('textui', false, true) TriggerEvent('cr-methrun:client:DeliverGoods') end
            else
                if LocalPlayer.state['textui'] then MethRunDrawText(false) LocalPlayer.state:set('textui', false, true) end
            end
            Wait(wait)
        end
    end
end

function ActivatePedTarget(ped)
    if Config.UseTarget then
        exports['qb-target']:AddTargetEntity(ped, { options = {
        { type = "client", event = "cr-methrun:client:getPackage", icon = "fas fa-box", label = Lcl('interact_GetPackage'), npc = ped,
        canInteract = function() return LocalPlayer.state.GettingPackage end },}, distance = 2.0 })
    else
        PackageCoords = GetEntityCoords(ped)
        PackagePed = ped
    end
end

function ActivateDeliveringTarget(veh)
    if Config.UseTarget then
        exports['qb-target']:AddTargetEntity(veh, { options = { { type = "client", event = "cr-methrun:client:DeliverGoods", icon = "fas fa-box-open", label = Lcl('interact_DeliverGoods'),
        canInteract = function() return LocalPlayer.state.HasGoods end },}, distance = 2.0 })
    else
        MethVehicle = veh
    end
end

-- DrawText Function
--- @param bool boolean - Enable/Disable Drawtext
--- @param text? string - if Enabled, Message Shown
function MethRunDrawText(bool, text)
	if bool then
		if Config.DrawText == 'qb' then
			exports['qb-core']:DrawText(text, 'right')
		elseif Config.DrawText == 'okok' then
			exports['okokTextUI']:Open(text, 'darkblue', 'right')
		end
	else
		if Config.DrawText == 'qb' then
			exports['qb-core']:HideText()
		elseif Config.DrawText == 'okok' then
			exports['okokTextUI']:Close()
		end
	end
end

-- Call Cops Function
---@param coords vec3 - Coordinates for the police call
-- Sends the police call either directly to the dispatch script which takes care of who gets the notification, or sends the call to every player and triggers the notification on their end.
function CallCops(vehInfo, coords, veh)
    if Config.Police.CallCops then
        if Config.Police.SendCallToAll or Config.Police.Dispatch == 'qb' then
            TriggerServerEvent("cr-methrun:server:callCops", vehInfo, coords, veh)
        else
            TriggerEvent("cr-methrun:client:callCops", vehInfo, coords, veh)
        end
    end
end

-- Check if Player is part of a police job.
function IsPolice()
    for _, value in ipairs(Config.Police.PoliceJobs) do
        if value == QBCore.Functions.GetPlayerData().job.name then
            return true
        end
    end
    return false
end

-- Check if a player is on Duty
function OnDuty()
    return QBCore.Functions.GetPlayerData().job.onduty
end

function MethRunEmails(type, vehicle, plate)
    local PhoneType
    local sender
    local subject
    local message
    if Config.Phone == "qb" then PhoneType = 'qb-phone:server:sendNewMail'
    elseif Config.Phone == "gks" then PhoneType = 'gksphone:NewMail'
    elseif Config.Phone == "qs" then PhoneType = 'qs-smartphone:server:sendNewMail' end
    if type == "VehicleLocated" then sender = Lcl('email_Sender') subject = Lcl('email_subject_VehicleLocated') message = Lcl('email_message_VehicleLocated', QBCore.Shared.Vehicles[vehicle].name, plate)
    elseif type == "ProductReady" then sender = Lcl('email_Sender') subject = Lcl('email_subject_PackageReady') message = Lcl('email_message_PackageReady')
    elseif type == "DeliveryInProgress" then sender = Lcl('email_Sender') subject = Lcl('email_subject_DeliveryInProgress') message = Lcl('email_message_DeliveryInProgress') end
    TriggerServerEvent(PhoneType, {
        sender = sender,
        subject = subject,
        message = message
    })
end

-- Notification Function
---@param notifType integer - Notification Type (1 = Success | 2 = Information | 3 = Error/Negative Output)
---@param message string - Message Sent
---@param title string - Notification Title (If Applicable)
function MethRunNotif(notifType, message, title)
    if Config.Notifications == 'qb' or 'tnj' then
        if notifType == 1 then
            QBCore.Functions.Notify(message, 'success')
        elseif notifType == 2 then
            QBCore.Functions.Notify(message, 'info')
        elseif notifType == 3 then
            QBCore.Functions.Notify(message, 'error')
        end
    elseif Config.Notifications == "okok" then
        if notifType == 1 then
            exports['okokNotify']:Alert(title, message, 5000, 'success')
        elseif notifType == 2 then
            exports['okokNotify']:Alert(title, message, 5000, 'info')
        elseif notifType == 3 then
            exports['okokNotify']:Alert(title, message, 5000, 'error')
        end
    elseif Config.Notifications == "mythic" then
        if notifType == 1 then
            exports['mythic_notify']:DoHudText('success', message)
        elseif notifType == 2 then
            exports['mythic_notify']:DoHudText('inform', message)
        elseif notifType == 3 then
            exports['mythic_notify']:DoHudText('error', message)
        end
    elseif Config.Notifications == 'chat' then
        TriggerEvent('chatMessage', message)
    end
end

--This is the blip being sent every Config.Police.BlipInterval
RegisterNetEvent("cr-methrun:client:SendBlip", function(coords)
    if IsPolice() and OnDuty() then
        local blipcoords
        local policeBlip
        if Config.Police.BlipType == "precise" then
            blipcoords = coords
            policeBlip = AddBlipForCoord(blipcoords.x, blipcoords.y, blipcoords.z)
            SetBlipSprite(policeBlip, 225)
            BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Lcl('blip_StolenVehicle'))
			EndTextCommandSetBlipName(policeBlip)
        elseif Config.Police.BlipType == "area" then
            local Xoffset = math.random(-75, 75)
            local Yoffset = math.random(-75, 75)
            blipcoords = coords + vector3(Xoffset, Yoffset, 0)
            policeBlip = AddBlipForRadius(blipcoords.x, blipcoords.y, blipcoords.z, 100.0)
            SetBlipAlpha(policeBlip, 128)
        end
        SetBlipColour(policeBlip, 1)
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        Wait((Config.Police.BlipInterval * 1000) - 3000) -- BLip Disappears 3 seconds before the updated blip.
        RemoveBlip(policeBlip)
    end
end)

-- A Dispatch call is sent every 3rd tracker blips (The Event Right Abvove)
-- You can add any other dispatch system if you want, simply copy the code needed in the "other" section, and make sure you set the config to the appropriate setup.
RegisterNetEvent('cr-methrun:client:callCops', function(info, coords, vehicle)
    --print(info, coords, vehicle)
    -- info contains :
    -- info.vehicle = Vehicle Type (Hash)
    -- info.color = Vehicle Color
    -- info.plate = License Plate
    if Config.Police.Dispatch == "cd" then
        --Code Deisgn Dispatch Call
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = Config.Police.PoliceJobs,
            coords = coords,
            title = Config.Police.TenCode.." - "..Config.Police.DispatchMessageTitle,
            message = Config.Police.DispatchMessage,
            flash = false,
            unique_id = tostring(math.random(0000000,9999999)),
            blip = {
                sprite = 225,
                scale = 1.1,
                colour = 1,
                flashes = false,
                text = Config.Police.DispatchMessageTitle,
                time = (5*60*1000),
                sound = 1,
            }
        })
    elseif Config.Police.Dispatch == "core" then
        --Core Dispatch's Call
        TriggerServerEvent("core_dispatch:addCall", Config.Police.TenCode, Config.Police.DispatchMessageTitle,
        {{icon = "fa-solid fa-box", info = info}}, {coords}, Config.Police.PoliceJobs, 5000, 140, 1)
    elseif Config.Police.Dispatch == "ps-dispatch" then
        exports['ps-dispatch']:MethRun(vehicle, Config.Police.PoliceJobs)
    elseif Config.Police.Dispatch == "qb" then
        if IsPolice() and OnDuty() then
            TriggerEvent("police:client:policeAlert", coords, Config.Police.DispatchMessage)
        end
    --luacheck: push ignore
    elseif Config.Police.Dispatch == "other" then
        --(You can add any Police Dispatch System over here)
    --luacheck: pop
    end
end)
