PLAYER_JOB = nil

function PoliceDispatch(eventCoords)
    if not Config.dispatch.enabled then
        return
    end

    local chance = math.random(0, 100)
    if chance > Config.dispatch.alertChance then
        return
    end

    local system = Config.dispatch.system
    local blipData = Config.dispatch.blip
    
    if system == 'default' then
        TriggerServerEvent('kq_smash_n_grab:server:sendDispatch', eventCoords)
    
    elseif system == 'ps-dispatch' then
        exports['ps-dispatch']:CustomAlert({
            coords = eventCoords,
            message = Config.dispatch.eventName,
            dispatchCode = Config.dispatch.policeCode,
            description = Config.dispatch.description,
            radius = 0,
            sprite = blipData.sprite,
            color = blipData.color,
            scale = blipData.scale,
            length = 3,
            recipientList = Config.policeJobs
        })
    
    elseif system == 'core-dispatch-old' then
        local hash, _ = GetStreetNameAtCoord(eventCoords.x, eventCoords.y, eventCoords.z)
        local street = GetStreetNameFromHashKey(hash)
        for _, job in ipairs(Config.policeJobs) do
            TriggerServerEvent(
                    'core_dispatch:addCall',
                    Config.dispatch.policeCode,
                    Config.dispatch.eventName,
                    {{icon = 'fa-solid fa-user-police', info=street}},
                    {eventCoords[1], eventCoords[2], eventCoords[3]},
                    job,
                    blipData.timeout * 1000,
                    blipData.sprite,
                    blipData.color
            )
        end
    elseif system == 'core-dispatch-new' then
        local hash, _ = GetStreetNameAtCoord(eventCoords.x, eventCoords.y, eventCoords.z)
        local street = GetStreetNameFromHashKey(hash)
        for _, job in ipairs(Config.policeJobs) do
            exports['core_dispach']:addCall(
                    Config.dispatch.policeCode,
                    Config.dispatch.eventName,
                    {
                        {icon = 'fa-map-signs', info=street}
                    },
                    {eventCoords[1], eventCoords[2], eventCoords[3]},
                    job,
                    blipData.timeout * 1000,
                    blipData.sprite,
                    blipData.color
            )
        end
    
    elseif system == 'cd-dispatch' then
        local hash, _ = GetStreetNameAtCoord(eventCoords.x, eventCoords.y, eventCoords.z)
        local street = GetStreetNameFromHashKey(hash)
        
        exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = Config.policeJobs,
            coords = eventCoords,
            title = Config.dispatch.policeCode,
            message = Config.dispatch.eventName .. ' at '.. street,
            flash = 0,
            unique_id = 'kq_smash_n_grab_' .. tostring(math.random(0000000,9999999)),
            blip = {
                sprite = blipData.sprite,
                scale = blipData.scale,
                colour = blipData.color,
                flashes = blipData.showRadar,
                text = Config.dispatch.eventName,
                time = blipData.timeout * 1000,
                sound = 1,
            }
        })
    end
end


RegisterNetEvent('kq_smash_n_grab:client:sendDispatch')
AddEventHandler('kq_smash_n_grab:client:sendDispatch', function(coords)
    if not Contains(Config.policeJobs, PLAYER_JOB) then
        return
    end
    
    CreatePoliceBlip(coords, Config.dispatch.blip.sprite)
    
    SendDispatchMessage(Config.dispatch.description, Config.dispatch.eventName)
    if Config.dispatch.blip.showRadar then
        CreatePoliceBlip(coords, 161)
    end
end)


function CreatePoliceBlip(coords, sprite)
    Citizen.CreateThread(function()
        local blipData = Config.dispatch.blip
        local blip = AddBlipForCoord(coords)
    
        SetBlipSprite(blip, sprite)
        SetBlipHighDetail(blip, true)
        SetBlipColour(blip, blipData.color)
        SetBlipAlpha(blip, 255)
        SetBlipScale(blip, blipData.scale)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(Config.dispatch.eventName)
        EndTextCommandSetBlipName(blip)
        SetBlipAsShortRange(blip, false)
    
        RealWait(Config.dispatch.blip.timeout * 1000)
        
        RemoveBlip(blip)
    end)
end


function SendDispatchMessage(message, subtitle)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    
    -- Set the notification icon, title and subtitle.
    local title = L('Dispatch')
    local iconType = 0
    local flash = false -- Flash doesn't seem to work no matter what.
    EndTextCommandThefeedPostMessagetext('CHAR_CALL911', 'CHAR_CALL911', flash, iconType, title, subtitle)
    
    -- Draw the notification
    local showInBrief = true
    local blink = false -- blink doesn't work when using icon notifications.
    EndTextCommandThefeedPostTicker(blink, showInBrief)
end
