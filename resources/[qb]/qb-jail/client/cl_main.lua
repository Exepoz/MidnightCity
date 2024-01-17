QBCore = exports['qb-core']:GetCoreObject()
PlayerData = QBCore.Functions.GetPlayerData()

insidePrisonZone = false

--- Menus

lib.registerContext({
    id = 'jail_prisonservices',
    title = Locales['menu_title_prisonservice'],
    options = {
        {
            title = Locales['menu_title_timeremaining'],
            description = Locales['menu_description_timeremaining'],
            icon = 'fas fa-stopwatch',
            event = 'qb-jail:client:CheckTimeRemaining',
        },
        {
            title = Locales['menu_title_logout'],
            description = Locales['menu_description_logout'],
            icon = 'fas fa-users',
            serverEvent = 'qb-houses:server:LogoutLocation',
        },
    }
})

lib.registerContext({
    id = 'jail_timeremaining',
    title = Locales['menu_title_prisonservice'],
    menu = 'jail_prisonservices',
    options = {
        {
            title = Locales['menu_title_released'],
            icon = 'fas fa-angle-left',
            serverEvent = 'qb-jail:server:RequestPrisonExit',
        },
        {
            title = Locales['menu_title_exit'],
            description = Locales['menu_description_exit'],
            icon = 'fas fa-stopwatch',
            serverEvent = 'qb-jail:server:RequestPrisonExit',
        },
    }
})

--- Functions

local onEnter = function()
    insidePrisonZone = true

    if Config.AntiHelicopter and not Utils.PlayerIsLeo(PlayerData.job) then
        triggerAntiHeli()
    end
end

local onExit = function()
    insidePrisonZone = false

    if PlayerData.metadata and PlayerData.metadata.injail ~= 0 then
        if Config.JailBreak.JailBreakActive then
            TriggerServerEvent('qb-jail:server:RequestJailBreakRelease')
        else
            local ped = cache.ped
            if not DoesEntityExist(ped) then return end

            Utils.Notify(Locales['notify_found_guards'], 'primary', 4000)

            DoScreenFadeOut(1000)
            while not IsScreenFadedOut() do Wait(10) end

            local cell = math.random(#Config.Locations['cells'])
            SetEntityCoords(ped, Config.Locations['cells'][cell].xyz)
            SetEntityHeading(ped, Config.Locations['cells'][cell].w)

            TriggerServerEvent('InteractSound_SV:PlayOnSource', 'jail', 0.5)

            Wait(100)
            DoScreenFadeIn(1000)
        end
    end
end

local PrisonPoly = lib.zones.poly({
    points = {
        vector3(1824.32, 2475.59, 65.50),
        vector3(1851.63, 2521.75, 65.50),
        vector3(1852.44, 2613.25, 65.50),
        vector3(1848.94, 2699.52, 65.50),
        vector3(1773.17, 2762.88, 65.50),
        vector3(1649.58, 2757.98, 65.50),
        vector3(1569.73, 2680.37, 65.50),
        vector3(1534.66, 2585.32, 65.50),
        vector3(1540.47, 2469.55, 65.50),
        vector3(1658.93, 2394.60, 65.50),
        vector3(1761.55, 2410.23, 65.50)
    },
    thickness = 50,
    debug = false,
    onEnter = onEnter,
    onExit = onExit
})

--- Startup Events

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
end)

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() ~= resource then return end
    destroyJobBlips()

    for i = 1, #jobSelectionBoards do
        DeleteEntity(jobSelectionBoards[i])
    end

    for i = 1, #jobObjects do
        DeleteEntity(jobObjects[i])
    end

    if DoesEntityExist(prisonerPed) then
        DeleteEntity(prisonerPed)
    end
end)

--- Player Load / UnLoad Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    
    lib.callback('qb-jail:server:GetJailBreakConfig', false, function(result)
        Config.JailBreak = result

        if result.JailBreakActive then
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
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
    currentJob = nil
    destroyJobBlips()
end)

--- Events

RegisterNetEvent('qb-prison:client:SendPlayerToPrison', function(takeMugshot, time)
    Wait(1000)
    local ped = cache.ped
    if not DoesEntityExist(ped) then return end

    if time > 0 then
        Utils.Notify((Locales['notify_sent_prison']):format(time), 'primary', 4000)
    else
        Utils.Notify(Locales['notify_sent_prison2'], 'primary', 4000)
    end

    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do Wait(10) end

    if takeMugshot then
        -- Mugshot
        Wait(100)
        DoScreenFadeIn(1000)
        FreezeEntityPosition(ped, true)
        SetEntityCoords(ped, Config.Locations['mugshot'].xyz)
        SetEntityHeading(ped, Config.Locations['mugshot'].w)

        local animDict = 'mp_character_creation@customise@male_a'
        local anim = 'loop'
        local prop = `prop_police_id_board`

        lib.requestAnimDict(animDict, 1500)
        lib.requestModel(prop, 1500)

        Wait(1000)

        local created_object = CreateObject(prop, Config.Locations['mugshot'].x, Config.Locations['mugshot'].y, Config.Locations['mugshot'].z + 0.2,  true,  true, true)
        AttachEntityToEntity(created_object, ped, GetPedBoneIndex(ped, 58868), 0.12, 0.24, 0.0, 5.0, 0.0, 70.0, true, true, false, true, 1, true)
        TaskPlayAnim(ped, animDict, anim, 2.0, 2.0, -1, 1, 0, false, false, false)

        Wait(1500)
        TriggerServerEvent('InteractSound_SV:PlayOnSource', 'photo', 0.5)

        Wait(1500)
        SetEntityHeading(ped, Config.Locations['mugshot'].w - 90.0)
        TriggerServerEvent('InteractSound_SV:PlayOnSource', 'photo', 0.5)

        Wait(1500)
        SetEntityHeading(ped, Config.Locations['mugshot'].w + 90.0)
        TriggerServerEvent('InteractSound_SV:PlayOnSource', 'photo', 0.5)

        Wait(1500)
        SetEntityHeading(ped, Config.Locations['mugshot'].w)

        Wait(2000)
        
        StopAnimTask(ped, animDict, anim, 1.0)
        FreezeEntityPosition(ped, false)
        DeleteEntity(created_object)
        SetModelAsNoLongerNeeded(prop)
        RemoveAnimDict(animDict)
    end

    -- Send to prison
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do Wait(10) end

    local cell = math.random(#Config.Locations['cells'])
    SetEntityCoords(ped, Config.Locations['cells'][cell].xyz)
    SetEntityHeading(ped, Config.Locations['cells'][cell].w)

    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'jail', 0.5)
    Wait(100)
    
    -- Apply Clothing
    if Config.PrisonOutfit.Enable then
        local gender = PlayerData.charinfo.gender
        if gender == 0 then
            TriggerEvent('qb-clothing:client:loadOutfit', Config.PrisonOutfit.Outfits.male)
        else
            TriggerEvent('qb-clothing:client:loadOutfit', Config.PrisonOutfit.Outfits.female)
        end
    end

    DoScreenFadeIn(1000)
    TriggerEvent('qb-jail:client:ChangeJob', 'lockup')
    Wait(1000)
    createPrisonPed()
end)

RegisterNetEvent('qb-jail:client:PrisonServices', function()
    lib.showContext('jail_prisonservices')
end)

RegisterNetEvent('qb-jail:client:CheckTimeRemaining', function()
    if PlayerData.metadata.injail < 0 then
        lib.showContext('jail_timeremaining')
    elseif PlayerData.metadata.injail > 0 then
        Utils.Notify((Locales['notify_time_left']):format(PlayerData.metadata.injail), 'primary', 4000)
    else
        -- You're not supposed to be here
    end
end)

RegisterNetEvent('qb-jail:client:PhoneCall', function()
    local input = lib.inputDialog(Locales['input_prison_phone'], {
        {
            type = 'number',
            label = Locales['input_label_phone'],
            icon = 'hashtag',
        },
    })

    if not input then return end

    if Config.Phone == 'GKS' then
        local number = tonumber(input[1])
        exports['gksphone']:StartingCall(number)
    elseif Config.Phone == 'QBCore' then
        local calldata = {
            number = input[1],
            name = input[1]
        }

        exports['qb-phone']:CallContact(calldata , true) -- You need to create this export in qb-phone, see readme
    end
end)

RegisterNetEvent('qb-jail:client:PrisonRevive', function()
    if PlayerData.metadata.injail ~= 0 or Utils.PlayerIsLeo(PlayerData.job) then

        if exports['qb-policejob']:IsHandcuffed() then
            TriggerEvent('police:client:GetCuffed', -1)
        end
        
        TriggerEvent('police:client:DeEscort')

        DoScreenFadeOut(1000)
        while not IsScreenFadedOut() do Wait(10) end
        local bedCoords = vector4(1761.80, 2594.74, 45.66, 270.41)
        local ped = cache.ped
        SetEntityCoords(ped, bedCoords.xyz)
        ClearPedTasks(ped)

        lib.requestAnimDict('anim@gangops@morgue@table@', 1500)
        TaskPlayAnim(ped, 'anim@gangops@morgue@table@', 'body_search', 8.0, 1.0, -1, 1, 0, 0, 0, 0)
        SetEntityHeading(ped, bedCoords.w)
        FreezeEntityPosition(ped, true)

        local cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', 1)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
        AttachCamToPedBone(cam, ped, 31085, 0, 1.0, 1.0 , true)
        SetCamFov(cam, 90.0)
        
        local heading = GetEntityHeading(ped)
        heading = (heading > 180) and heading - 180 or heading + 180
        SetCamRot(cam, -45.0, 0.0, heading, 2)

        DoScreenFadeIn(1000)
        while not IsScreenFadedIn() do Wait(10) end

        Wait(4000)

        lib.requestAnimDict('switch@franklin@bed', 1500)
        FreezeEntityPosition(ped, false)
        SetEntityInvincible(ped, false)
        SetEntityHeading(ped, 90)
        TaskPlayAnim(ped, 'switch@franklin@bed', 'sleep_getup_rubeyes', 100.0, 1.0, -1, 8, -1, 0, 0, 0)
        Wait(4000)
        ClearPedTasks(ped)
        RenderScriptCams(0, true, 200, true, true)
        DestroyCam(cam, false)
        FreezeEntityPosition(ped, false)

        TriggerEvent('hospital:client:Revive')
    end
end)

RegisterNetEvent('qb-jail:client:CheckInmates', function()
    local options = {}
    local prisoners = lib.callback.await('qb-jail:server:GetAllPrisoners', false) or {}

    for i = 1, #prisoners do
        options[#options + 1] = {
            title = ('[%s] - %s'):format(i, prisoners[i].name),
            description = ('Time Remaining: %s'):format((prisoners[i].time > 0 and prisoners[i].time or Locales['released'])),
            icon = 'fas fa-angle-left',
            event = 'qb-jail:client:CheckInmate',
            args = prisoners[i]
        }
    end

    lib.registerContext({
        id = 'jail_checkinmates',
        title = Locales['menu_title_prisoninmates'],
        options = options,
    })

    lib.showContext('jail_checkinmates')
end)

RegisterNetEvent('qb-jail:client:CheckInmate', function(prisoner)
    if not prisoner then return end

    lib.registerContext({
        id = 'jail_checkinmate',
        title = prisoner.name,
        menu = 'jail_checkinmates',
        options = {
            {
                title = Locales['menu_title_prisoner'],
                description = Locales['menu_description_prisoner'],
                icon = 'fas fa-user-clock',
                serverEvent = 'qb-jail:server:RequestPrisoner',
                args = prisoner.id
            }
        },
    })

    lib.showContext('jail_checkinmate')
end)

RegisterNetEvent('qb-jail:client:PostPrisonExit', function()
    lib.hideTextUI()

    currentJob = nil

    destroyJobBlips()

    if DoesEntityExist(prisonerPed) then
        DeleteEntity(prisonerPed)
    end
    
    if Config.PrisonOutfit.Enable then
        TriggerServerEvent('qb-clothes:loadPlayerSkin')
    end
end)

CreateThread(function()
    -- Prison Blip
    local blip = AddBlipForCoord(Config.BlipCoords.x, Config.BlipCoords.y, Config.BlipCoords.z)
    SetBlipSprite(blip, 188)
    SetBlipDisplay(blip, 2)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 38)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Locales['blip_jail'])
    EndTextCommandSetBlipName(blip)

    -- Prison Phone
    exports['qb-target']:AddBoxZone('prison_services', vector3(1828.75, 2579.79, 46.00), 0.6, 0.5, {
        name = 'prison_services',
        heading = 270,
        debugPoly = Config.TargetDebug,
        minZ = 46.00,
        maxZ = 47.00
    }, {
        options = { 
            {
                type = 'client',
                event = 'qb-jail:client:PrisonServices',
                icon = 'fas fa-circle-chevron-right',
                label = Locales['menu_title_prisonservice']
            },
            {
                type = 'client',
                event = 'qb-jail:client:PhoneCall',
                icon = 'fas fa-phone-flip',
                label = Locales['target_phone_call']
            },
            {
                type = 'client',
                event = 'qb-phone:client:CancelCall',
                icon = 'fas fa-phone-slash',
                label = Locales['target_phone_hangup']
            }
        },
        distance = 1.5,
    })

    -- Infirmary ped
    local infirmaryPedModel = `s_f_y_scrubs_01`
    lib.requestModel(infirmaryPedModel, 1500)

    local infirmaryPed = CreatePed(0, infirmaryPedModel, Config.InfirmaryPed.x, Config.InfirmaryPed.y, Config.InfirmaryPed.z - 1.0, Config.InfirmaryPed.w, false, false)
    TaskStartScenarioInPlace(infirmaryPed, 'WORLD_HUMAN_CLIPBOARD', true)
    FreezeEntityPosition(infirmaryPed, true)
    SetEntityInvincible(infirmaryPed, true)
    SetBlockingOfNonTemporaryEvents(infirmaryPed, true)

    exports['qb-target']:AddTargetEntity(infirmaryPed, {
        options = {
            {
                type = 'client',
                icon = 'fa fa-clipboard',
                event = 'qb-jail:client:PrisonRevive',
                label = Locales['target_infirmary'],
            }
        },
        distance = 2.5
    })

    -- Reception ped
    local receptionPedModel = `s_m_m_prisguard_01`
    lib.requestModel(receptionPedModel, 1500)

    local receptionPed = CreatePed(0, receptionPedModel, Config.ReceptionPedCoords.x, Config.ReceptionPedCoords.y, Config.ReceptionPedCoords.z - 1.0, Config.ReceptionPedCoords.w, false, false)
    TaskStartScenarioInPlace(receptionPed, 'WORLD_HUMAN_CLIPBOARD', true)
    FreezeEntityPosition(receptionPed, true)
    SetEntityInvincible(receptionPed, true)
    SetBlockingOfNonTemporaryEvents(receptionPed, true)

    exports['qb-target']:AddTargetEntity(receptionPed, {
        options = {
            {
                type = 'client',
                icon = 'fa fa-clipboard',
                event = 'qb-jail:client:CheckInmates',
                label = Locales['target_inmates'],
            }
        },
        distance = 2.5
    })
    
end)
