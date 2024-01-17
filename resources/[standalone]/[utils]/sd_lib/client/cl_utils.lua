SD = SD or {}
SD.target = {}
SD.utils = SD.utils or {}

-- Utility Functions
-- Load Animation
SD.utils.LoadAnim = function(animDict)
    RequestAnimDict(animDict); while not HasAnimDictLoaded(animDict) do Wait(1) end
end

-- Load Model
SD.utils.LoadModel = function(model)
	if not HasModelLoaded(model) and IsModelInCdimage(model) then
		RequestModel(model)
	
		while not HasModelLoaded(model) do
			Wait(1)
		end
	end
end

-- Load Ptfx
SD.utils.LoadPtfxAsset = function(dict)
	RequestNamedPtfxAsset(dict); while not HasNamedPtfxAssetLoaded(dict) do Wait(1) end
end

-- Doorlock 
SD.utils.Doorlock = function(data)
    if data.type == 'qb' then
        TriggerServerEvent('qb-doorlock:server:updateState', data.id, data.locked, false, false, data.enablesounds, false, false)
    elseif data.type == 'nui' then
        TriggerServerEvent('nui_doorlock:server:updateState', data.id, data.locked, false, false, data.enablesounds)
    elseif data.type == 'ox' or data.type == 'cd' then
        TriggerServerEvent('sd_lib:doorToggle', data)
    end
end

-- Police Alert
SD.utils.PoliceDispatch = function(data)
    data = data or {}
    local playerCoords = GetEntityCoords(PlayerPedId())

    -- Fetch the street name based on the player's current coordinates
    local streetName, crossingRoad = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
    local locationInfo = GetStreetNameFromHashKey(streetName)

        -- Check if crossingRoad is valid and not just an empty or nil value
        if crossingRoad and crossingRoad ~= "" then
            local crossName = GetStreetNameFromHashKey(crossingRoad)
        if crossName and crossName ~= "" then  -- Another check to ensure crossName isn't empty or invalid
            locationInfo = locationInfo .. " & " .. crossName
        end
    end


    local gender = 'Unknown'
    if Framework == 'qb' and Config.Dispatch == 'ps-dispatch' then
        gender = "Male"
        if QBCore and QBCore.Functions.GetPlayerData().charinfo.gender == 1 then 
            gender = "Female" 
        end
    end

    if Config.Dispatch == 'linden_outlawalert' then
        local d = {
            displayCode = data.displayCode,
            description = data.description,
            isImportant = 0,
            recipientList = SD.PoliceJobs,
            length = '10000',
            infoM = 'fa-info-circle',
            info = data.message
        }
        local dispatchData = {dispatchData = d, caller = 'Citizen', coords = playerCoords}
        TriggerServerEvent('wf-alerts:svNotify', dispatchData)

    elseif Config.Dispatch == 'cd_dispatch' then
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = SD.PoliceJobs,
            coords = playerCoords,
            title = data.title,
            message = data.message .. ' on ' .. locationInfo,
            flash = 0,
            unique_id = math.random(999999999),
            sound = 1,
            blip = {
                sprite = data.sprite,
                scale = data.scale,
                colour = data.colour,
                flashes = false,
                text = data.blipText,
                time = 5,
                radius = 0,
            }
        })

    elseif Config.Dispatch == 'ps-dispatch' then
        local dispatchData = {
            message = data.title,
            codeName = data.dispatchcodename,
            code = data.displayCode,
            icon = 'fas fa-info-circle',
            priority = 2,
            coords = playerCoords,
            gender = gender,
            street = locationInfo,
            jobs = Config.JobTypes
        }
        TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
        
    elseif Config.Dispatch == 'ps-dispatch-old' then
        TriggerServerEvent("dispatch:server:notify",{
            dispatchcodename = data.dispatchcodename,
            dispatchCode = data.displayCode,
            firstStreet = locationInfo,
            gender = gender,
            model = nil,
            plate = nil,
            priority = 2,
            firstColor = nil,
            automaticGunfire = false,
            origin = {
                x = playerCoords.x,
                y = playerCoords.y,
                z = playerCoords.z
            },
            dispatchMessage = data.title,
            job = SD.PoliceJobs
        })

    elseif Config.Dispatch == 'qs-dispatch' then
        TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', {
            job = SD.PoliceJobs,
            callLocation = playerCoords,
            callCode = { code = data.displayCode, snippet = data.description },
            message = data.message .. ' on ' .. locationInfo,
            flashes = false,
            blip = {
                sprite = data.sprite,
                scale = data.scale,
                colour = data.colour,
                flashes = true,
                text = data.blipText,
                time = (6 * 60 * 1000),
            }
        })

    elseif Config.Dispatch == 'core_dispatch' then
        TriggerServerEvent("core_dispatch:addCall",
            data.displayCode,
            data.description,
            {{icon = "fa-info-circle", info = data.message}},
            {playerCoords.x, playerCoords.y, playerCoords.z},
            SD.PoliceJobs,
            10000,
            data.sprite,
            data.colour
        )

    elseif Config.Dispatch == 'custom' then
        -- Add your custom dispatch system here
    elseif Config.Dispatch == '' then
        -- If no Dispatch system is selected, do nothing with the data.
    end
end

-- Email Function
SD.utils.SendEmail = function(sender, subject, message)
    if Config.Phone == 'qb-phone' then
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = sender,
            subject = subject,
            message = message,
        })

    elseif Config.Phone == 'qs-smartphone' then
        TriggerServerEvent('qs-smartphone:server:sendNewMail', {
            sender = sender,
            subject = subject,
            message = message,
            button = {}
        })

    elseif Config.Phone == 'high-phone' then
        local senderData = {
            address = sender.address or "",
            name = sender,
            photo = sender.photo or ""
        }
        TriggerServerEvent("high_phone:sendMailFromServer", senderData, subject, message, {})

    elseif Config.Phone == 'npwd-phone' then
        exports["npwd"]:createNotification({
            notisId = "npwd:emailNotification",
            appId = "EMAIL",
            content = message,
            secondaryTitle = subject,
            keepOpen = false,
            duration = 5000,
            path = "/email",
        })

    elseif Config.Phone == 'lb-phone' then
        exports["lb-phone"]:SendNotification({
            app = "Email",
            title = subject,
            content = message,
        })

    elseif Config.Phone == 'gks-phone' then
        -- Prepare data for gks-phone
        local MailData = {
            sender = sender,
            image = '/html/static/img/icons/mail.png',
            subject = subject,
            message = message
        }
        exports["gksphone"]:SendNewMail(MailData)

    elseif Config.Phone == 'custom' then
        print('No phone system was identified - please update your Config.Phone')

    elseif Config.Phone == '' then
        print('No phone system was identified - please update your Config.Phone')
    end
end

-- Target functions
-- Target Initialization
local oxTarget = GetResourceState(Config.OXTarget)

local targets = Config.Targets
if oxTarget == 'started' then
    SD.targetName = 'qtarget'
else
    for i=1, #targets do
        if GetResourceState(targets[i]) == 'started' then
            SD.targetName = targets[i]
            break
        end
    end
end

if not SD.targetName then return end

-- Add Box Zone
SD.target.AddBoxZone = function(identifier, coords, width, length, data, debugPoly)
    exports[SD.targetName]:AddBoxZone(identifier, coords, width, length, {
        name = identifier,
        heading = data.heading,
        debugPoly = debugPoly,
        minZ = coords.z - 1.2,
        maxZ = coords.z + 1.2,
    }, {
        options = data.options,
        distance = data.distance,
    })
end

-- Add Circle Zone
SD.target.AddCircleZone = function(identifier, coords, radius, data, debugPoly)
    exports[SD.targetName]:AddCircleZone(identifier, coords, radius, {
        name = identifier,
        useZ = true,
        debugPoly = debugPoly,
    }, {
        options = data.options,
        distance = data.distance,
    })
end

-- Add Target Entity
SD.target.AddTargetEntity = function(netId, data) 
    exports[SD.targetName]:AddTargetEntity(netId, {
        options = data.options,
        distance = data.distance,
    })
end

-- Add Target model
SD.target.AddTargetModel = function(models, data)
    exports[SD.targetName]:AddTargetModel(models, {
        options = data.options,
        distance = data.distance,
    })
end

-- Remove a target entity
SD.target.RemoveTargetEntity = function(entity)
    exports[SD.targetName]:RemoveTargetEntity(entity)
end

-- Remove Zone
SD.target.RemoveZone = function(identifier)
    exports[SD.targetName]:RemoveZone(identifier)
end