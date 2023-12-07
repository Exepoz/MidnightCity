local ChatResourceAPI = {}

-- /me and /do integration (optional)

local peds = {}

local function displayText(ped, text, yOffset)
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local targetPos = GetEntityCoords(ped)
    local dist = #(playerPos - targetPos)
    local los = HasEntityClearLosToEntity(playerPed, ped, 17)

    if dist <= 250 and los then
        peds[ped] = {
            time = GetGameTimer() + 5000,
            text = text,
            yOffset = yOffset
        }

        if not peds[ped].exists then
            peds[ped].exists = true

            Citizen.CreateThread(function()
                while GetGameTimer() <= peds[ped].time do
                    local pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, peds[ped].yOffset)
                    clib.wrappers.DrawText3D(peds[ped].text, pos, 0.5, { 255, 255, 255, 255 }, false, 4)
                    Citizen.Wait(0)
                end

                peds[ped] = nil
            end)
        end
    end
end

RegisterNetEvent("displayMeAboveHead")
AddEventHandler("displayMeAboveHead", function(player, message)
    local ped = GetPlayerPed(-1)

    if not DoesEntityExist(ped) then
        return
    end

    local offset = PublicSharedChatConfig.MeAndDoCommand.Offset

    displayText(ped, "~r~** " .. message .. " **", offset)
end)

RegisterNetEvent("displayDoAboveHead")
AddEventHandler("displayDoAboveHead", function(player, message)
    local ped = GetPlayerPed(-1)

    if not DoesEntityExist(ped) then
        return
    end

    local offset = PublicSharedChatConfig.MeAndDoCommand.Offset

    displayText(ped, "~b~** " .. message .. " **", offset)
end)

if PublicSharedChatConfig.MeAndDoCommand.UseMeAndDoCommand then
    TriggerEvent("chat:addSuggestion", '/me', "Displays an action or emote your character is performing.")
    TriggerEvent("chat:addSuggestion", '/me', "Describe or respond in roleplay.")
end