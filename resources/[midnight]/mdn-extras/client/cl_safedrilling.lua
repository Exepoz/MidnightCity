local QBCore = exports['qb-core']:GetCoreObject()
local SoundID, Pfx

local doors = {
    --'ch_prop_ch_arcade_safe_door',
    -1992154984
}

RegisterNetEvent('mdn-extras:client:DrillSafe', function(data)
    local safe = data.entity
    --if not QBCore.Functions.HasItem('crpaleto_mounteddrill') then QBCore.Functions.Notify('You don\'t have a drill?', 'error') return end
    --TriggerServerEvent('mdn-extras::server:RemItem', Config.Items.MountedDrill.item, 1)
    local ped = PlayerPedId()
    local scoords = GetEntityCoords(safe)
    if not safe or safe == 0 or GlobalState.Safes[scoords] then return end
    TriggerServerEvent('mdn-extras:server:SafeBusy', scoords, true)
    TriggerServerEvent('mdn-extras:server:SafeSync', 'RequestSound')
    local x,y,z = table.unpack(GetEntityCoords(safe))
    TaskTurnPedToFaceCoord(scoords, 1000)
    Wait(1000)
    ExecuteCommand('e uncuff')
    --ExecuteCommand('e mechanic4')
    local drillModel, bagModel = GetHashKey("k4mb1_prop_drill2"), GetHashKey('hei_p_m_bag_var22_arm_s')
    LoadModel(drillModel) LoadModel(bagModel)
    local drill = CreateObject(drillModel, x, y, z-3.0,  true, 1, 0)
    AttachEntityToEntity(drill, ped, GetPedBoneIndex(ped, 64016), 0.0, 0.0, -0.1, 0.0, 0.0, 90.0, false, false, false, false, 2, true)--right bone:28422
    SetEntityCollision(drill, true)
    Citizen.Wait(2000)
    AttachEntityToEntity(drill, safe, 1, -0.35, -0.26, 0.39, 0.0, -90.0, 180.0, false, false, false, false, 2, true)--right bone:28422
    DetachEntity(drill, true, true) FreezeEntityPosition(drill, true)
    ClearPedTasks(ped)
    DeleteEntity(bagObj)
    Wait(1000)
    FreezeEntityPosition(ped, false)
    local netID = NetworkGetNetworkIdFromEntity(drill)
    local fxCoords = GetOffsetFromEntityInWorldCoords(drill, 0, -0.2, 0)
    TriggerServerEvent('mdn-extras:server:SafeSync', "SawSound", netID)
    TriggerServerEvent('mdn-extras:server:SafeSync', "DrillFx", fxCoords)
    CreateThread(function()
       Wait(10000)
       TriggerServerEvent('mdn-extras:server:SafeSync', "StopSound")
       TriggerServerEvent('mdn-extras:server:SafeSync', "StopFx")
       local options = {{ event = "mdn-extras:server:client:DismantleDrill", icon = "fas fa-hand", label = "Dismantle", drill = drill, scoords = scoords, data = data }}
       exports['qb-target']:AddTargetEntity(drill, { options = options, distance = 2 })
    end)
end)

RegisterNetEvent('mdn-extras:server:client:DismantleDrill', function(data)
    local ped = PlayerPedId()
    TaskTurnPedToFaceEntity(ped, data.drill, 1500)
    Wait(1500)
    QBCore.Functions.Progressbar('dimsantle', 'Dismantling', 5000, false, false, { -- Name | Label | Time | useWhileDead | canCancel
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'anim@gangops@facility@servers@',
        anim = 'hotwire',
        flags = 16,
    }, {}, {}, function() -- Play When Done
        ClearPedTasks(ped)
        DeleteEntity(data.drill)
        if data.data.safeType == "r14" then
            TriggerServerEvent('r14-obj:server:drillopensafe', data.data)
        end
    end)
end)

local SafeSync = {
    ['StopSound'] = function() StopSound(SoundID) ReleaseSoundId(SoundID) end,
    ['StopFx'] = function() StopParticleFxLooped(Pfx, 0) Pfx = nil end,
    ['SawSound'] = function(nID)
        SoundID = GetSoundId()
        local saw = NetworkGetEntityFromNetworkId(nID)
        if not saw then return end
        PlaySoundFromEntity(SoundID, 'Drill', saw, 'DLC_HEIST_FLEECA_SOUNDSET', true, 0)
    end,
    ['DrillFx'] = function(coords)
        local pfxAsset, pfxEffect = 'core', 'ent_anim_pneumatic_drill'
        LoadPfxAsset(pfxAsset) SetPtfxAssetNextCall(pfxAsset)
        Pfx = StartParticleFxLoopedAtCoord(pfxEffect, coords, 0.0, 0.0, 0.0, 1.0, false, false, false, false, 0)
    end,
    ['RequestSound'] = function()
        RequestAmbientAudioBank('DLC_HEIST_FLEECA_SOUNDSET', true)
        RequestAmbientAudioBank('DLC_MPHEIST\\HEIST_FLEECA_DRILL', 1)
        RequestAmbientAudioBank('DLC_MPHEIST\\HEIST_FLEECA_DRILL_2', 0)
    end,
} RegisterNetEvent('mdn-extras:client:SafeSync', function(type, ...) SafeSync[type](...) end)
