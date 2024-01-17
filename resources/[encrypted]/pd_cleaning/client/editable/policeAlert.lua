----------------------
-- BLIPS
----------------------
local policeBlips = {}

RegisterNetEvent('pd_cleaning:activatePoliceAlarm')
AddEventHandler('pd_cleaning:activatePoliceAlarm', function(locationCoords)
    PoliceAlarm(locationCoords)
    local streetNameHash
    local intersectionNameHash
    streetNameHash, intersectionNameHash = GetStreetNameAtCoord(locationCoords.x, locationCoords.y, locationCoords.z)
    local streetName = GetStreetNameFromHashKey(streetNameHash)
    SendDispatchMessage(L('Robbery commited at ~y~') .. streetName .. L('. ~w~ Get them!'), 'Customer Support')
    Wait(15000)
    ClearPoliceBlips()
end)

function PoliceAlarm(locationCoords)
    local blipConf = Config.blips.policeBlip
    local blip = CreatePoliceBlip(locationCoords, blipConf.sprite, blipConf.color, blipConf.alpha, blipConf.scale, L('Valuables thief'))
    SetBlipDisplay(blip, 8)
    table.insert(policeBlips, blip)
end

function ClearPoliceBlips()
    for k, blip in pairs(policeBlips) do
        RemoveBlip(blip)
    end
    policeBlips = {}
end

function CreatePoliceBlip(coords, sprite, color, alpha, scale, message)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

    SetBlipSprite(blip, sprite)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, color)
    SetBlipAlpha(blip, alpha)
    SetBlipScale(blip, scale)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(message)
    EndTextCommandSetBlipName(blip)
    return blip
end

---------------------
-- DISPATCH MESSAGES
----------------------

function EndPoliceAlarm()
    if trailerBlip ~= nil then
        RemovePoliceTrailerBlip()
        SendDispatchMessage(L('Our truck has arrived to its destination. Thank you for your assistance'), L('Truck arrived'))
    end
end

function SendDispatchMessage(message, subtitle)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)

    -- Set the notification icon, title and subtitle.
    local title = 'UberCleans'
    local iconType = 0
    local flash = false -- Flash doesn't seem to work no matter what.
    EndTextCommandThefeedPostMessagetext('CHAR_CHAT_CALL', 'CHAR_CHAT_CALL', flash, iconType, title, subtitle)

    -- Draw the notification
    local showInBrief = true
    local blink = false -- blink doesn't work when using icon notifications.
    EndTextCommandThefeedPostTicker(blink, showInBrief)
end

------------------------------
-- UBERCLEANS SUPPORT MESSAGES
------------------------------

function SendSupportMessage(message, iconTexture)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)

    -- Set the notification icon, title and subtitle.
    local title = L("UberCleans")
    local subtitle = L("Customer support")
    local iconType = 1
    local flash = false -- Flash doesn't seem to work no matter what.
    EndTextCommandThefeedPostMessagetext(iconTexture, iconTexture, flash, iconType, title, subtitle)

    -- Draw the notification
    local showInBrief = true
    local blink = false -- blink doesn't work when using icon notifications.
    EndTextCommandThefeedPostTicker(blink, showInBrief)
end

function ShowTooltip(msg)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(msg) -- B
    DrawNotification(true, false)
end