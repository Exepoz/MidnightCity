--- Anti Helicopter Guards

--- Method to spawn guards with rocket launchers to target the helicopter
---@return nil
triggerAntiHeli = function()
    if not Config.AntiHelicopter then return end
    local ped = cache.ped
    if cache.seat == -1 then
        if IsPedInAnyPlane(ped) or IsPedInAnyHeli(ped) then
            lib.callback('qb-jail:server:SpawnAntiHelicopterGuards', 1000, function(netIds)
                Wait(1000)

                for i = 1, #netIds do
                    local guard = NetworkGetEntityFromNetworkId(netIds[i])
                    SetPedDropsWeaponsWhenDead(guard, false)
                    SetEntityInvincible(guard, true)
                    SetEntityMaxHealth(guard, 500)
                    SetEntityHealth(guard, 500)
                    SetCanAttackFriendly(guard, false, true)
                    SetPedCombatAttributes(guard, 46, true)
                    SetPedCombatAttributes(guard, 0, false)
                    SetPedCombatAbility(guard, 100)
                    SetPedAsCop(guard, true)
                    TaskCombatPed(guard, ped, 0, 16)
                    SetPedAccuracy(guard, 100)
                    SetPedFleeAttributes(guard, 0, 0)
                    SetPedKeepTask(guard, true)
                end
            end)
        end
    end
end

--- Prison break

--- Sends server sided ptfx for the thermite charge
---@return nil
local ThermiteEffect = function(index)
    lib.requestAnimDict('anim@heists@ornate_bank@thermal_charge', 1500)
    local ped = cache.ped
    local ptfx = Config.JailBreak.Thermite[index][2]
    Wait(1500)
    
    TriggerServerEvent('qb-powerplant:server:ThermitePtfx', ptfx)
    Wait(500)

    TaskPlayAnim(ped, 'anim@heists@ornate_bank@thermal_charge', 'cover_eyes_intro', 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
    TaskPlayAnim(ped, 'anim@heists@ornate_bank@thermal_charge', 'cover_eyes_loop', 8.0, 8.0, 3000, 49, 1, 0, 0, 0)
end

--- Performs the PlantThermite function and starts the minigame for thermite
---@return nil
local ThermitePlantCharge = function(index)
    lib.requestAnimDict('anim@heists@ornate_bank@thermal_charge', 1500)
    lib.requestModel('hei_p_m_bag_var22_arm_s', 1500)
    lib.requestNamedPtfxAsset('scr_ornate_heist', 1500)

    local ped = cache.ped
    local pos = Config.JailBreak.Thermite[index][1]
    SetEntityHeading(ped, pos.w)
    Wait(100)
    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(ped)))
    local bagscene = NetworkCreateSynchronisedScene(pos.x, pos.y, pos.z, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(`hei_p_m_bag_var22_arm_s`, pos.x, pos.y, pos.z,  true,  true, false)
    SetEntityCollision(bag, false, true)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local charge = CreateObject(`hei_prop_heist_thermite`, x, y, z + 0.2,  true,  true, true)
    SetEntityCollision(charge, false, true)
    AttachEntityToEntity(charge, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    NetworkAddPedToSynchronisedScene(ped, bagscene, 'anim@heists@ornate_bank@thermal_charge', 'thermal_charge', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, 'anim@heists@ornate_bank@thermal_charge', 'bag_thermal_charge', 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)
    Wait(5000)
    DetachEntity(charge, 1, 1)
    FreezeEntityPosition(charge, true)
    DeleteObject(bag)
    NetworkStopSynchronisedScene(bagscene)

    CreateThread(function()
        Wait(15000)
        DeleteEntity(charge)
    end)
end

RegisterNetEvent('qb-jail:client:SetPowerPlant', function(state)
    Config.JailBreak.PowerplantHit = state
end)

RegisterNetEvent('qb-jail:client:ThermiteHit', function(index)
    Config.JailBreak.Thermite[index][4] = true
end)

RegisterNetEvent('qb-jail:client:OutsideThermite', function(data)
    if Config.JailBreak.Thermite[data.index][4] then return end
    
    lib.callback('qb-powerplant:server:getCops', false, function(cops)
        if data.index == 1 and cops < Config.JailBreakCops then
            Utils.Notify(Locales['notify_not_enough_police'], 'error', 2500)
            return
        else
            if Config.Inventory == 'ox_inventory' and exports['ox_inventory']:Search('count', 'thermite') == 0 then
                Utils.Notify(Locales['notify_missing_items'], 'error', 2500)
                return
            elseif Config.Inventory == 'qb' and not QBCore.Functions.HasItem('thermite') then
                Utils.Notify(Locales['notify_missing_items'], 'error', 2500)
                return
            end

            TriggerServerEvent('qb-powerplant:server:RemoveThermite')
            ThermitePlantCharge(data.index)
            exports['memorygame']:thermiteminigame(Config.Minigames.ThermiteSettings.correctBlocks, Config.Minigames.ThermiteSettings.incorrectBlocks, Config.Minigames.ThermiteSettings.timetoShow, Config.Minigames.ThermiteSettings.timetoLose, function()
                TriggerServerEvent('qb-jail:server:ThermiteHit', data.index)
                ThermiteEffect(data.index)
            end, function()
                Utils.Notify(Locales['notify_thermite_fail'], 'error', 2500)
            end)
        end
    end)   
end)

RegisterNetEvent('qb-jail:client:OutsideHack', function()
    if not Config.JailBreak.PowerplantHit or not Config.JailBreak.Thermite[1][4] or Config.JailBreak.VARHack then return end

    local ped = cache.ped
    local animDict = 'anim@heists@prison_heiststation@cop_reactions'
    local anim = 'cop_b_idle'

    lib.requestAnimDict(animDict, 1500)
    TaskPlayAnim(ped, animDict, anim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)

    exports['varhack']:OpenHackingGame(function(success)
        StopAnimTask(ped, animDict, anim, 1.0)
        if success then
            PlaySound(-1, 'Lose_1st', 'GTAO_FM_Events_Soundset', 0, 0, 1)
            Utils.AlertCops()
            TriggerServerEvent('qb-jail:server:OutsideHack')
        end
    end, Config.Minigames.VarSettings.varBlocks, 7)
end)

RegisterNetEvent('qb-jail:client:ActivateLockdown', function(state)
    Config.JailBreak.VARHack = state
    Config.JailBreak.JailBreakActive = state

    if state then
        local alarmIpl = GetInteriorAtCoordsWithType(1787.004, 2593.1984, 45.7978, 'int_prison_main')
        RefreshInterior(alarmIpl)
        EnableInteriorProp(alarmIpl, 'prison_alarm')

        CreateThread(function()
            while not PrepareAlarm('PRISON_ALARMS') do
                Wait(100)
            end

            StartAlarm('PRISON_ALARMS', true)
        end)
    else
        local alarmIpl = GetInteriorAtCoordsWithType(1787.004, 2593.1984, 45.7978, 'int_prison_main')
        RefreshInterior(alarmIpl)
        DisableInteriorProp(alarmIpl, 'prison_alarm')

        CreateThread(function()
            while not PrepareAlarm('PRISON_ALARMS') do
                Wait(100)
            end

            StopAllAlarms(true)
        end)
    end
end)

RegisterNetEvent('qb-jail:client:UnlockCellDoors', function()
    if not Config.JailBreak.JailBreakActive then return end

    local input = lib.inputDialog(Locales['input_unlockcelldoor'], {
        {
            type = 'select',
            label = Locales['input_selectcell'],
            icon = 'door-closed',
            required = false,
            default = '1',
            options = {
                { value = '1', text = (Locales['input_cell']):format('1') },
                { value = '2', text = (Locales['input_cell']):format('2') },
                { value = '3', text = (Locales['input_cell']):format('3') },
                { value = '4', text = (Locales['input_cell']):format('4') },
                { value = '5', text = (Locales['input_cell']):format('5') },
                { value = '6', text = (Locales['input_cell']):format('6') },
                { value = '7', text = (Locales['input_cell']):format('7') },
                { value = '8', text = (Locales['input_cell']):format('8') },
                { value = '9', text = (Locales['input_cell']):format('9') },
                { value = '10', text = (Locales['input_cell']):format('10') },
                { value = '11', text = (Locales['input_cell']):format('11') },
                { value = '12', text = (Locales['input_cell']):format('12') },
                { value = '13', text = (Locales['input_cell']):format('13') },
                { value = '14', text = (Locales['input_cell']):format('14') },
                { value = '15', text = (Locales['input_cell']):format('15') },
                { value = '16', text = (Locales['input_cell']):format('16') },
                { value = '17', text = (Locales['input_cell']):format('17') },
                { value = '18', text = (Locales['input_cell']):format('18') },
                { value = '19', text = (Locales['input_cell']):format('19') },
                { value = '20', text = (Locales['input_cell']):format('20') },
                { value = '21', text = (Locales['input_cell']):format('21') },
                { value = '22', text = (Locales['input_cell']):format('22') },
                { value = '23', text = (Locales['input_cell']):format('23') },
                { value = '24', text = (Locales['input_cell']):format('24') },
                { value = '25', text = (Locales['input_cell']):format('25') },
                { value = '26', text = (Locales['input_cell']):format('26') },
                { value = '27', text = (Locales['input_cell']):format('27') }
            },
        }
    })

    if not input then return end

    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'DoorOpen', 0.5)
    TriggerServerEvent('qb-jail:server:OpenCellDoor', input[1])
end)

CreateThread(function()
    exports['qb-target']:AddBoxZone('jailbreak_outsidethermite_1', vector3(1846.61, 2571.43, 44.67), 1.4, 0.5, {
        name = 'jailbreak_outsidethermite_1',
        heading = 0,
        debugPoly = Config.TargetDebug,
        minZ = 44.67,
        maxZ = 46.47
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:OutsideThermite',
                icon = 'fas fa-user-secret',
                label = Locales['target_tamper_security'],
                index = 1,
                canInteract = function()
                    return Config.JailBreak.PowerplantHit and not Config.JailBreak.Thermite[1][4] and not Config.JailBreak.VARHack
                end
            }
        },
        distance = 1.5,
    })

    exports['qb-target']:AddBoxZone('jailbreak_outsidethermite_2', vector3(1791.74, 2612.13, 45.20), 0.5, 0.4, {
        name = 'jailbreak_outsidethermite_2',
        heading = 0,
        debugPoly = Config.TargetDebug,
        minZ = 45.20,
        maxZ = 46.20
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:OutsideThermite',
                icon = 'fas fa-user-secret',
                label = Locales['target_tamper_security'],
                index = 2,
                canInteract = function()
                    return Config.JailBreak.PowerplantHit and not Config.JailBreak.Thermite[2][4]
                end
            }
        },
        distance = 1.5,
    })

    exports['qb-target']:AddBoxZone('jailbreak_outsidethermite_3', vector3(1761.29, 2517.19, 45.20), 1.0, 0.5, {
        name = 'jailbreak_outsidethermite_3',
        heading = 345,
        debugPoly = Config.TargetDebug,
        minZ = 45.20,
        maxZ = 46.80
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:OutsideThermite',
                icon = 'fas fa-user-secret',
                label = Locales['target_tamper_security'],
                index = 3,
                canInteract = function()
                    return Config.JailBreak.PowerplantHit and not Config.JailBreak.Thermite[3][4] and Config.JailBreak.VARHack
                end
            }
        },
        distance = 1.5,
    })

    exports['qb-target']:AddBoxZone('jailbreak_outsidehack_1', vector3(1831.31, 2603.95, 45.57), 0.6, 0.4, {
        name = 'jailbreak_outsidehack_1',
        heading = 280,
        debugPoly = Config.TargetDebug,
        minZ = 45.57,
        maxZ = 46.27
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:OutsideHack',
                icon = 'fas fa-user-secret',
                label = Locales['target_tamper_security'],
                canInteract = function()
                    return Config.JailBreak.PowerplantHit and Config.JailBreak.Thermite[1][4]
                end
            }
        },
        distance = 1.5,
    })

    exports['qb-target']:AddBoxZone('jailbreak_cell_panel', vector3(1775.0, 2492.35, 49.67), 2.2, 0.4, {
        name = 'jailbreak_cell_panel',
        heading = 30,
        debugPoly = Config.TargetDebug,
        minZ = 49.67,
        maxZ = 50.87
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:UnlockCellDoors',
                icon = 'fas fa-user-secret',
                label = Locales['target_unlock_celldoor'],
                canInteract = function()
                    return Config.JailBreak.JailBreakActive and Config.JailBreak.Thermite[3][4]
                end
            },
            {
                type = 'server',
                event = 'qb-jail:server:ClearLockDown',
                icon = 'fas fa-user-shield',
                label = Locales['target_clear_lockdown'],
                canInteract = function()
                    return Utils.PlayerIsLeo(PlayerData.job) and Config.JailBreak.JailBreakActive
                end
            }
        },
        distance = 1.5,
    })

end)
