if not Shared.Enable.Missions then return end

local missionBlip
local isBusy = false

QBCore.Functions.LoadModel(`s_m_y_swat_01`)

--- Functions

--- Method to perform the searching animation and sends the netId of the entity to the server to delete
--- @param entity number - entity handle
--- @return nil
local grabMaterials = function(entity)
    if entity == 0 then return end
    if isBusy then return end
    isBusy = true
    local ped = PlayerPedId()
    local netId = NetworkGetNetworkIdFromEntity(entity)
    TaskTurnPedToFaceEntity(ped, entity, 1.0)
    Wait(1500)

    QBCore.Functions.Progressbar('druglabs_stealing', _U('stealing_materias'), 7800, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'anim@gangops@facility@servers@bodysearch@',
        anim = 'player_search',
        flags = 16,
    }, {}, {}, function() -- Done
        TriggerServerEvent('qb-drugsystem:server:GrabMaterialCrate', netId)
        isBusy = false
    end, function() -- Cancel
        QBCore.Functions.Notify(_U('canceled'), 'error', 2500)
        isBusy = false
    end)
end

--- Events

AddEventHandler('onResourceStop', function (resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    if DoesBlipExist(missionBlip) then
        RemoveBlip(missionBlip)
    end
end)

RegisterNetEvent('qb-drugsystem:client:StartMission', function(missionType)
    QBCore.Functions.TriggerCallback('qb-drugsystem:server:CanStartMission', function(canStart, mission)
        if not canStart then return end
        local mCoords = Shared.Missions[missionType][mission].coordinate
        missionBlip = AddBlipForRadius(mCoords.x, mCoords.y, mCoords.z , 150.00)
        SetBlipHighDetail(missionBlip, true)
        SetBlipAlpha(missionBlip, 100)
        SetBlipColour(missionBlip, 3)
        TriggerEvent('qb-phone:client:CustomNotification', _U('phone_title_current'), _U('goto_area'), 'fas fa-user-shield', '#ff002f', 6000)

        local missionZone = CircleZone:Create(mCoords.xyz, Shared.Missions[missionType][mission].radius, {
            name = 'druglabs_mission',
            debugPoly = Shared.Debug
        })
        missionZone:onPlayerInOut(function(isPointInside, point)
            if isPointInside then
                missionZone:destroy()
                RemoveBlip(missionBlip)
                TriggerEvent('qb-phone:client:CustomNotification', _U('phone_title_current'), _U('enter_area'), 'fas fa-user-shield', '#ff002f', 6000)
                QBCore.Functions.TriggerCallback('qb-drugsystem:server:EnterMissionZone', function(netIds, health)
                    Wait(1000)
                    for i=1, #netIds do
                        local npc = NetworkGetEntityFromNetworkId(netIds[i])
                        SetPedDropsWeaponsWhenDead(npc, false)
                        SetPedMaxHealth(npc, health)
                        SetCanAttackFriendly(npc, false, true)
                        SetPedCombatAttributes(npc, 46, true)
                        SetPedCombatAttributes(npc, 0, false)
                        SetPedCombatAbility(npc, 100)
                        SetPedAsCop(npc, true)
                        SetPedRelationshipGroupHash(npc, `HATES_PLAYER`)
                        SetPedAccuracy(npc, 60)
                        SetPedFleeAttributes(npc, 0, 0)
                        SetPedKeepTask(npc, true)
                        SetBlockingOfNonTemporaryEvents(npc, true)
                    end
                end, missionType)
            end
        end)
    end, missionType)
end)

--- Threads

CreateThread(function()
    exports['qb-target']:AddTargetModel('ch_prop_ch_chemset_01a', {
        options = {
            {
                action = function(entity)
                    grabMaterials(entity)
                end,
                icon = 'fas fa-user-secret',
                label = _U('mission_grab_materials')
            }
        },
        distance = 1.5,
    })
end)
