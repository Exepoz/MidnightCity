local QBCore = exports['qb-core']:GetCoreObject()
local Blip

-- Util Function
local getDispo = function(setting) return GlobalState.Disposals[setting] > 0 or GlobalState.DispoNeedPay[setting] ~= nil end

-- Disposal Zones
Citizen.CreateThread(function()
    for k, v in pairs(Config.Disposals) do
        exports['qb-target']:AddBoxZone("DisposalZone_"..k, vector3(v.d.x, v.d.y, v.d.z-1), 1.3, 1.3, {name = "DisposalZone_"..k, heading = 100.0, debugPoly = false, minZ = v.d.z-1, maxZ = v.d.z+1},
        { options = {{type = "client", event = "mdn-extras:client:disposeBody", icon = 'fas fa-user-secret', setting = k, label = 'Dispose Body', canInteract = function() return getDispo(k) end}}, distance = 2.5, })
    end
end)

-- Using Phone
RegisterNetEvent('mdn-extras:client:useHTPhone', function()
    QBCore.Functions.Progressbar('dinerRes', 'Contacting Reservation Services...', 5000, false, false, {
        disableMovement = false, disableCarMovement = false, disableMouse = false, disableCombat = true}, {}, {}, {}, function()
            local options = {}
            for k, v in pairs(Config.Disposals) do options[#options+1] = {value = k, label = v.label} end
            local input = lib.inputDialog('Setup Diner Reservation', {
                {type = 'slider', label = 'Amount of People (1000 Crumbs / Guest)', required = true, min = 1, max = 6, icon = 'people-group',},
                {type = 'select', label = 'Chose Meal', options = options ,description = 'Chose which meal you like to serve.', icon = 'drumstick-bite'},
            })
            local ped = PlayerPedId()
            if not input then ClearPedTasks(ped) return end
            QBCore.Functions.TriggerCallback('mdn-extras:server:setupDispo', function(paid)
                if not paid then return end
                exports['qb-phone']:PhoneNotification('Reservation Confirmed.', 'Cost : '..paid.." crumbs", 'fas fa-check', '#139516', 5000)
                local setting = Config.Disposals[input[2]]
                SetNewWaypoint(setting.p.x, setting.p.y)
                Blip = AddBlipForCoord(setting.p)
                SetBlipSprite(Blip, 685)
                SetBlipColour(Blip, 1)
                SetBlipScale(Blip, 1.0)
                SetBlipHiddenOnLegend(Blip, true)
            end, input[2], input[1])
    end, function() end)
end)

-- Throwing Body
RegisterNetEvent('mdn-extras:client:disposeBody', function(data)
    local player = PlayerPedId()
    local carriedPlayer = nil
    local players = GetActivePlayers()

    QBCore.Functions.TriggerCallback('mdn-extras:server:payDispo', function(paid)
        if not paid then return end
        for i = 1, #players do
            local otherPlayerPed = GetPlayerPed(players[i])
            if IsEntityAttachedToEntity(otherPlayerPed, player) then
                carriedPlayer = otherPlayerPed
                break
            end
        end

        if carriedPlayer == nil then QBCore.Functions.Notify('You are not escorting anyone!', 'error') return end
        QBCore.Functions.TriggerCallback('mdn-extras:server:isEscorted', function(bool)
            if not bool then QBCore.Functions.Notify('You need to be escorting the other player!', 'error') return end
            ExecuteCommand("escort") Citizen.Wait(1000)
            if GlobalState.Disposals[data.setting] <= 0 then QBCore.Functions.Notify('That\'s enough bodies, I ain\'t cleaning more.', 'error') return end
            TriggerServerEvent('mdn-extras:server:disposeBody', data.setting, GetPlayerServerId(NetworkGetPlayerIndexFromPed(carriedPlayer)))
        end, GetPlayerServerId(NetworkGetPlayerIndexFromPed(carriedPlayer)))
    end, data.setting)
end)

-- Removing Blip
RegisterNetEvent('mdn-extras:client:endDisposal', function() RemoveBlip(Blip) end)
