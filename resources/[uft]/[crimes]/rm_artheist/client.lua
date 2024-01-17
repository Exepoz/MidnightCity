local QBCore = exports['qb-core']:GetCoreObject()

ArtHeist = {
    ['start'] = false,
    ['cuting'] = false,
    ['startPeds'] = {},
    ['sellPeds'] = {},
    ['cut'] = 0,
    ['objects'] = {},
    ['scenes'] = {},
    ['painting'] = {}
}

local h_rgb = {
    {100, 28,131,191},
    {200, 158,191,28},
    {300, 191,147,28},
    {400, 255,0,0},
}

local MansionBlip, MansionPoint
local noiseLvl, stopAll, madeGuards, gGroup = 0, false, false, 0
local pPoints, netGuards = {}, {}
local maxAlertLevel = 0

local pagerLines = {
    [1] = {
        {l ='Hello? Whatsup Juan? Is Everything good?', t = 8000},
        {l ='Juan? Do you copy?', t = 8000},
        {l ='I\'ll have to sound the alarm if you don\'t answer...', t = 8000},
    }
}

local pagerAnswers = {
    [1] = {
        p = {l ='Yes! Hi.. I\'m sorry.. I dropped my sandwhich and uh... triggered my radio...', t = 8000},
        g = {l ='Hmm.. Okay.. Yeah.. sure...', t = 8000},
    }
}

--[[ Ideas art
    start at GT laptop, chatrooms
    User M4RCH4ND4RT online if heist available
    More painting locations, randomize them
    drawers & other search locations
    gives small jewellry & random house robb items
    chance to give vangellico card/access code
]]

--[[ ideas vangellico
    computer gives location of the vangellico truck
    player can locate from the computer, send location to someone.
    they can signal the truck to wait at its location (The truck will wait there as long as you stay in the room)
    player gets notification that if they leave vangellico, the truck will leave its location
    needs to be intercepted by externals, if not they lose the truck
    truck + 2 guards npcs at location
    police receoves armored truck distress signal when thermite is placed
    1 minute thermite
    when gets bag, notif that say they can leave the area without the cops being here
]]

function ShowText(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(colour[1],colour[2],colour[3], 255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    --SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end

-- Sell Peds Thread
Citizen.CreateThread(function()
    for k, v in pairs(Config['ArtHeist']['sellPainting']['peds']) do
        loadModel(v['ped'])
        ArtHeist['sellPeds'][k] = CreatePed(4, GetHashKey(v['ped']), v['pos']['x'], v['pos']['y'], v['pos']['z'] - 0.95, v['heading'], false, true)
        FreezeEntityPosition(ArtHeist['sellPeds'][k], true)
        SetEntityInvincible(ArtHeist['sellPeds'][k], true)
        SetBlockingOfNonTemporaryEvents(ArtHeist['sellPeds'][k], true)
    end
end)

-- Thread for paitings when they're close
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pedCo = GetEntityCoords(ped)
        local sleep = 1000
        local sellDist = #(pedCo - Config['ArtHeist']['sellPainting']['pos'])
        if sellDist <= 3.0 then
            sleep = 1
            ShowHelpNotification(Strings['sell_painting'])
            if IsControlJustPressed(0, 38) then
                FinishHeist()
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent('artheist:client:policeAlert')
AddEventHandler('artheist:client:policeAlert', function(targetCoords)
    QBCore.Functions.Notify(Strings['police_alert'])
    local alpha = 250
    local artheistBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, 50.0)

    SetBlipHighDetail(artheistBlip, true)
    SetBlipColour(artheistBlip, 1)
    SetBlipAlpha(artheistBlip, alpha)
    SetBlipAsShortRange(artheistBlip, true)

    while alpha ~= 0 do
        Citizen.Wait(125)
        alpha = alpha - 1
        SetBlipAlpha(artheistBlip, alpha)

        if alpha == 0 then
            RemoveBlip(artheistBlip)
            return
        end
    end
end)

function FinishHeist()
    for k, v in pairs(ArtHeist['sellPeds']) do
        TaskTurnPedToFaceEntity(v, PlayerPedId(), 1000)
    end
    TriggerServerEvent('artheist:server:finishHeist')
    RemoveBlip(sellBlip)
    if DoesBlipExist(stealBlip) then
        RemoveBlip(stealBlip)
    end
end

local pagerEnabled = false
RegisterNetEvent('pagerEnabled',function(ped)
    Wait(5000)
    Citizen.CreateThread(function()
        exports['qb-target']:AddTargetEntity(ped, {
            options = {
                {
                    icon = "fas fa-hand",
                    label = 'Answer Pager',
                    canInteract = function() return pagerEnabled end,
                    action = function()
                        print("Pager Answered")
                        pagerEnabled = false

                        local time = GetGameTimer()
                        local currLine = 1
                        local elapsed = 0

                        Citizen.CreateThread(function()
                            exports['xsound']:Destroy('RadioClick')
                            Wait(100)
                            exports['xsound']:PlayUrlPos("RadioClick", './sounds/radiostatic2.ogg', 1.0, GetEntityCoords(ped))--radioclick --radiostatic1
                            local p1 = false
                            while true do
                                elapsed = GetGameTimer() - time
                                if elapsed > pagerAnswers[1].p.t or p1 then
                                    if not p1 then
                                        time = GetGameTimer()
                                        elapsed = 0
                                    end
                                    p1 = true
                                    ShowText("~r~[Pager]~w~ "..pagerAnswers[1].g.l, 4, {255, 255, 255}, 0.5, 0.7, 0.82)
                                    if elapsed > pagerAnswers[1].p.t + 5000 then break end
                                end
                                ShowText("~b~[You]~w~ "..pagerAnswers[1].p.l, 4, {255, 255, 255}, 0.5, 0.7, 0.85)
                                Citizen.Wait(0)
                            end
                        end)
                    end
                }
            },
            distance = 3.0
        })
        local time = GetGameTimer()
        local currLine = 1
        local elapsed = 0
        -- if stop then exports['xsound']:Destroy('PhoneRinging')
        -- else exports['xsound']:PlayUrlPos("PhoneRinging", './sounds/phoneringing.ogg', 0.8, coords) end


        pagerEnabled = true
        exports['xsound']:Destroy('RadioClick')
        Wait(100)
        exports['xsound']:PlayUrlPos("RadioClick", './sounds/radiostatic2.ogg', 1.0, GetEntityCoords(ped))--radioclick --radiostatic1
        while true do
            elapsed = GetGameTimer() - time
            if elapsed > pagerLines[1][currLine].t then
                currLine = currLine + 1 time = GetGameTimer() elapsed = 0
                exports['xsound']:Destroy('RadioClick')
                Wait(100)
                exports['xsound']:PlayUrlPos("RadioClick", './sounds/radiostatic2.ogg', 1.0, GetEntityCoords(ped))
            end
            if pagerEnabled == false then break end
            if not pagerLines[1][currLine] then
                exports['xsound']:Destroy('RadioClick')
                pagerEnabled = false print("Alarm")
                break
            end
            ShowText("~r~[Pager]~w~ "..pagerLines[1][currLine].l, 4, {255, 255, 255}, 0.5, 0.7, 0.85)
            Citizen.Wait(0)
        end
    end)
end)

local patrolLogic = function(k, v, ped)
    local pnum = k-1
    OpenPatrolRoute('miss_Madrazdo_'..pnum)
    for k_, v_ in ipairs(v.path) do AddPatrolRouteNode(k_-1, v_.stance, v_.coords, v_.lookat, v_.time ~= 0 and math.random(v_.time.min,v_.time.max) or 0) end
    for i = 1, #v.path do AddPatrolRouteLink(i-1, i ~= #v.path and i or 0) end
    ClosePatrolRoute()
    CreatePatrolRoute()
    ::patrol::
    TaskPatrol(ped, "miss_Madrazdo_"..pnum, 0, 1, 0)
end


local function SetupNPC(model, coords, weapon)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(20)
    end
    StarterPed = CreatePed(0, model, coords, 227.43, false, true)
    while StarterPed == 0 do CreatePed(0, model, coords, 227.43, false, true) Wait(0) end

    NetworkRegisterEntityAsNetworked(StarterPed)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(StarterPed), true)
    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(StarterPed), true)
    GiveWeaponToPed(StarterPed, GetHashKey(weapon), 255, false, true)
    SetPedAccuracy(StarterPed, 30)
    SetPedArmour(StarterPed, 30)

    SetPedFleeAttributes(StarterPed, 0, false)
    SetPedCanSwitchWeapon(StarterPed, true)
    SetPedDropsWeaponsWhenDead(StarterPed, false)
    SetPedCombatRange(StarterPed, 0)
    SetPedSeeingRange(StarterPed, 10.0)
    SetPedHearingRange(StarterPed, 10.0)
    SetPedCombatAttributes(StarterPed, 46, 1)
    SetPedCanRagdollFromPlayerImpact(StarterPed, false)

    SetEntityAsMissionEntity(StarterPed)
    SetEntityVisible(StarterPed, true)
    SetEntityMaxHealth(StarterPed, 200)
    SetEntityHealth(StarterPed, 200)
    --SetBlockingOfNonTemporaryEvents(StarterPed, true)
    PlaceObjectOnGroundProperly(StarterPed)

    local pedGroud = (GetPedRelationshipGroupHash(PlayerPedId()))
    _, gGroup = AddRelationshipGroup("Guards")
    print(gGroup)
    SetRelationshipBetweenGroups(0, Hash, Hash)
    SetRelationshipBetweenGroups(4, Hash, pedGroud)
    SetRelationshipBetweenGroups(4, pedGroud, Hash)
    SetPedRelationshipGroupHash(ped, Hash)

    return StarterPed
end

local g_alertness = {}
-- Email Button for blip & painting previews
RegisterNetEvent('artheist:client:guardsAlertLogic', function(guardK, guardId)
    print("Guard Logic")
    while not NearMansion do
        Wait(2000)
    end
    Citizen.CreateThread(function()
        local e = NetworkGetEntityFromNetworkId(guardId)
        while not DoesEntityExist(e) do Wait(0) end
        netGuards[guardK] = e
        local dead = false

        local player = PlayerPedId()
        local wait = 2000
        local alertLevel = 0
        print("Start")
        while true do
            if stopAll then break end
            local rgb = {255,128,0}
            local o = GetOffsetFromEntityInWorldCoords(e, 0, -0.8, -0.9)
            local head = GetOffsetFromEntityInWorldCoords(e, 0, 0.0, 1.2)
            local front = head
            local pcoords = GetEntityCoords(player)
            local dist = #(pcoords - o)
            local front_dist = #(pcoords - front)
            local isFacing = IsPedFacingPed(e, player, 100.0)
            local isCrouched = exports['rpemotes']:IsPlayerCrouched()
            if front_dist <= 11 then
                local LoS = HasEntityClearLosToEntityInFront(e, player)
                if isFacing and front_dist < 5.0 then
                    if isCrouched and LoS then
                        alertLevel = alertLevel + 2
                    elseif LoS then
                        alertLevel = 500
                        stopAll = true
                        TriggerServerEvent('artheist:server:AlertGuards', LocalPlayer.state.heistGroup)
                    end
                elseif isFacing and front_dist < 10.0 then
                    if isCrouched and LoS then alertLevel = alertLevel + 1
                    elseif LoS then
                        alertLevel = 500
                        stopAll = true
                        TriggerServerEvent('artheist:server:AlertGuards', LocalPlayer.state.heistGroup)
                    end
                elseif alertLevel > 0 then alertLevel = alertLevel - 1 end
            elseif alertLevel > 0 then alertLevel = alertLevel - 1 end
            --if alertLevel > maxAlertLevel then maxAlertLevel = alertLevel end
            if dist < 2.0 and GetPedStealthMovement() == false then
                rgb = {0,255,0}
                SetPedStealthMovement(player, 1, "DEFAULT_ACTION")
            elseif dist >= 2.0 then
                SetPedStealthMovement(player, 0, "DEFAULT_ACTION")
            end
            if IsPedBeingStealthKilled(e) and IsPedPerformingStealthKill(player) then
                print("Killed by player")
                SetPedStealthMovement(player, 0, "DEFAULT_ACTION")
                dead = true
                TriggerEvent('pagerEnabled', e)
                break
            end

            if IsPedDeadOrDying(e) then dead = true break end
            if IsPedInCombat(e, player) then combat = true break end
            local hrgb = {28,131,191}
            for _, v in pairs(h_rgb) do if alertLevel < v[1] then hrgb = {v[2], v[3], v[4]} break end end
            if dist < 5.0 then DrawMarker(25, o, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, rgb[1], rgb[2], rgb[3], 60, false, false, 2, 0, nil, nil, false) end
            if dist < 15 then wait = 0 end
            if alertLevel > 0 then DrawMarker(32, head, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, hrgb[1], hrgb[2], hrgb[3], 60, false, true, 2, 0, nil, nil, false) end
            if alertLevel >= 500 then
                alertLevel = 500
                stopAll = true
                TriggerServerEvent('artheist:server:AlertGuards', LocalPlayer.state.heistGroup)
            break end
            g_alertness[guardK] = alertLevel
            Citizen.Wait(wait)
        end
    end)
end)

local soundWait = {
    [100] = 1500,
    [200] = 1000,
    [300] = 500,
}
local guardProxSound = function()
    Citizen.CreateThread(function()
        while true do
            table.sort(g_alertness, function(a,b) return a < b end)
            maxAlertLevel = #g_alertness > 0 and g_alertness[#g_alertness] or 0
            if maxAlertLevel > 0 then
                print(maxAlertLevel)
                PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
                local lvl = maxAlertLevel < 100 and 100 or maxAlertLevel < 200 and 200 or maxAlertLevel < 300 and 300
                Wait(soundWait[maxAlertLevel < 100 and 100 or maxAlertLevel < 200 and 200 or maxAlertLevel < 300 and 300])
            end
            if stopAll then break end
            Wait(500)
        end
    end)
end

RegisterCommand('closebyy', function()
    TriggerEvent('artheist:client:gettinClose')
end)

-- Getting Close to the house, loading all the paintings.
RegisterNetEvent('artheist:client:gettinClose', function()
    MansionPoint = lib.points.new(vector3(1397.66, 1140.42, 114.268), 100.0)
    function MansionPoint:onEnter()
        NearMansion = true
        QBCore.Functions.TriggerCallback('artheist:SpawnGuards', function(spawn)
            if not spawn then return end
            Citizen.CreateThread(function()
                local peds = {}
                for k, v in ipairs(Config.Patrols) do
                    local ped = SetupNPC(v.npc.model, v.npc.coords, v.npc.weapon)
                    local netId = NetworkGetNetworkIdFromEntity(ped)
                    table.insert(peds, netId)
                    patrolLogic(k, v, ped)
                end
                TriggerServerEvent('artheist:server:guardsAreSpawned', peds, LocalPlayer.state.heistGroup)
                madeGuards = true
            end)
        end)
        NoiseZone()
        guardProxSound()
        for k, v in pairs(Config['ArtHeist']['painting']) do
            loadModel(v['object'])
            ArtHeist['painting'][k] = CreateObjectNoOffset(GetHashKey(v['object']), v['objectPos'], 0, 1, 0)
            SetEntityRotation(ArtHeist['painting'][k], 0, 0, v['objHeading'], 2, true)
            local p = lib.points.new(v['objectPos'], 1.5)
            function p:onEnter()
                if GlobalState['artheist:paintings:'..k] == "show" then exports['qb-core']:DrawText('[E] Take Painting') end
            end
            function p:nearby()
                if IsControlJustPressed(0, 38) then
                    if GlobalState['artheist:paintings:'..k] ~= "show" then return end
                    exports['qb-core']:HideText()
                    local weapon = GetSelectedPedWeapon(PlayerPedId())
                    if weapon ~= GetHashKey('WEAPON_SWITCHBLADE') then QBCore.Functions.Notify('You need a switchblade to do this', "error") return end
                    if not ArtHeist['cuting'] then HeistAnimation(k)
                    else QBCore.Functions.Notify(Strings['already_cuting']) end
                end
            end
            function p:onExit() exports['qb-core']:HideText() end
            AddStateBagChangeHandler("artheist:paintings:"..k, nil, function(bagName, key, va)
                if va == "hide" then SetEntityAlpha(ArtHeist['painting'][k], 0) end
            end)
        end
    end
    function MansionPoint:onExit() NearMansion = false end
end)


-- Email Button for blip & painting previews
RegisterNetEvent('artheist:client:startEmailButton', function()
    local paintingList = {}
    for k, v in pairs(Config['ArtHeist']['painting']) do table.insert(paintingList, {v['object']}) end
    SendNUIMessage({action = 'open', list = paintingList})
    Wait(3000)
    stealBlip = addBlip(vector3(1397.66, 1140.42, 114.268), 439, 0, Strings['steal_blip'])
end)

-- Heist Start Check after group making
RegisterNetEvent('artheist:client:startHeist', function()
    QBCore.Functions.TriggerCallback('artheist:server:checkRobTime', function(time)
        if time then
            if GlobalState['artheist:inProgress'] then
                QBCore.Functions.Notify("Looks like someone snatched the contract already... Maybe an other time.", "error", 5000)
                TriggerServerEvent('malmo-goldentrail:server:deleteGroup', LocalPlayer.state.heistGroup)
            return end
            TriggerServerEvent('artheist:server:sendStartEmail', LocalPlayer.state.heistGroup)
        end
    end)
end)

-- Golden Trail Chatroom Mission Start & Group Matchmaking
RegisterNetEvent('artheist:client:setupHeist', function()
    local menu = {}
    local options = {}
    options = {
        { title = 'M4RCH4ND4RT', disabled = true,
            description = 'Hey. I need some help for a simple "acquisition". Let\'s just say I need you to get some stuff back from an old friend\'s house, are you interested?' },
        { title = 'You (Send Reply)', onSelect = function()
            exports['mdn-extras']:MakeGangGroup('artheist:client:startHeist')
        end, description = "Yeah sure, sounds easy enough." },
        { title = 'You (Send Reply)', onSelect = function() end,
            description = "Yeah that usually ends with a tons of cops and jail time, thats not for me." },
        { title = 'Disconnect', onSelect = function() end},
    }
    lib.registerContext({
        id = 'artGuyChat',
        title = 'The Golden Tail\n\n_Chatrooms_',
        options = options
    }) lib.showContext('artGuyChat')
end)

function HeistAnimation(sceneId)
    local ped = PlayerPedId()
    local pedCo, pedRotation = GetEntityCoords(ped), vector3(0.0, 0.0, 0.0)
    local scenes = {false, false, false, false}
    local animDict = "anim_heist@hs3f@ig11_steal_painting@male@"
    local scene = Config['ArtHeist']['painting'][sceneId]
    TriggerServerEvent('artheist:server:syncPainting', sceneId)
    loadAnimDict(animDict)

    for k, v in pairs(Config['ArtHeist']['objects']) do
        loadModel(v)
        ArtHeist['objects'][k] = CreateObject(GetHashKey(v), pedCo, 1, 1, 0)
    end

    ArtHeist['objects'][3] = ArtHeist['painting'][sceneId]

    for i = 1, 10 do
        ArtHeist['scenes'][i] = NetworkCreateSynchronisedScene(scene['scenePos']['x'], scene['scenePos']['y'], scene['scenePos']['z'], scene['sceneRot'], 2, true, false, 1065353216, 0, 1065353216)
        NetworkAddPedToSynchronisedScene(ped, ArtHeist['scenes'][i], animDict, 'ver_01_'..Config['ArtHeist']['animations'][i][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
        NetworkAddEntityToSynchronisedScene(ArtHeist['objects'][3], ArtHeist['scenes'][i], animDict, 'ver_01_'..Config['ArtHeist']['animations'][i][3], 1.0, -1.0, 1148846080)
        NetworkAddEntityToSynchronisedScene(ArtHeist['objects'][1], ArtHeist['scenes'][i], animDict, 'ver_01_'..Config['ArtHeist']['animations'][i][4], 1.0, -1.0, 1148846080)
        NetworkAddEntityToSynchronisedScene(ArtHeist['objects'][2], ArtHeist['scenes'][i], animDict, 'ver_01_'..Config['ArtHeist']['animations'][i][5], 1.0, -1.0, 1148846080)
    end

    cam = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
    SetCamActive(cam, true)
    RenderScriptCams(true, 0, 3000, 1, 0)

    --Entire Cutting Animation
    ArtHeist['cuting'] = true
    FreezeEntityPosition(ped, true)
    NetworkStartSynchronisedScene(ArtHeist['scenes'][1])
    PlayCamAnim(cam, 'ver_01_top_left_enter_cam_ble', animDict, scene['scenePos'], scene['sceneRot'], 0, 2)
    Wait(3000)
    NetworkStartSynchronisedScene(ArtHeist['scenes'][2])
    PlayCamAnim(cam, 'ver_01_cutting_top_left_idle_cam', animDict, scene['scenePos'], scene['sceneRot'], 0, 2)
    repeat
        ShowHelpNotification(Strings['cute_right'])
        if IsControlJustPressed(0, 38) then
            scenes[1] = true
        end
        Wait(1)
    until scenes[1] == true
    NetworkStartSynchronisedScene(ArtHeist['scenes'][3])
    PlayCamAnim(cam, 'ver_01_cutting_top_left_to_right_cam', animDict, scene['scenePos'], scene['sceneRot'], 0, 2)
    Wait(3000)
    NetworkStartSynchronisedScene(ArtHeist['scenes'][4])
    PlayCamAnim(cam, 'ver_01_cutting_top_right_idle_cam', animDict, scene['scenePos'], scene['sceneRot'], 0, 2)
    repeat
        ShowHelpNotification(Strings['cute_down'])
        if IsControlJustPressed(0, 38) then
            scenes[2] = true
        end
        Wait(1)
    until scenes[2] == true
    NetworkStartSynchronisedScene(ArtHeist['scenes'][5])
    PlayCamAnim(cam, 'ver_01_cutting_right_top_to_bottom_cam', animDict, scene['scenePos'], scene['sceneRot'], 0, 2)
    Wait(3000)
    NetworkStartSynchronisedScene(ArtHeist['scenes'][6])
    PlayCamAnim(cam, 'ver_01_cutting_bottom_right_idle_cam', animDict, scene['scenePos'], scene['sceneRot'], 0, 2)
    repeat
        ShowHelpNotification(Strings['cute_left'])
        if IsControlJustPressed(0, 38) then
            scenes[3] = true
        end
        Wait(1)
    until scenes[3] == true
    NetworkStartSynchronisedScene(ArtHeist['scenes'][7])
    PlayCamAnim(cam, 'ver_01_cutting_bottom_right_to_left_cam', animDict, scene['scenePos'], scene['sceneRot'], 0, 2)
    Wait(3000)
    repeat
        ShowHelpNotification(Strings['cute_down'])
        if IsControlJustPressed(0, 38) then
            scenes[4] = true
        end
        Wait(1)
    until scenes[4] == true
    NetworkStartSynchronisedScene(ArtHeist['scenes'][9])
    PlayCamAnim(cam, 'ver_01_cutting_left_top_to_bottom_cam', animDict, scene['scenePos'], scene['sceneRot'], 0, 2)
    Wait(1500)
    NetworkStartSynchronisedScene(ArtHeist['scenes'][10])
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    Wait(7500)

    -- Rewards & Clearing Ped
    TriggerServerEvent('artheist:server:rewardItem', scene)
    ClearPedTasks(ped)
	FreezeEntityPosition(ped, false)
    RemoveAnimDict(animDict)
    for k, v in pairs(ArtHeist['objects']) do
        DeleteObject(v)
    end
    DeleteObject(ArtHeist['painting'][sceneId])
    ArtHeist['objects'] = {}
    ArtHeist['scenes'] = {}
    ArtHeist['cuting'] = false
    ArtHeist['cut'] = ArtHeist['cut'] + 1
    scenes = {false, false, false, false}

    if ArtHeist['cut'] == #Config['ArtHeist']['painting'] then
        TriggerServerEvent('artheist:server:syncHeistStart')
        TriggerServerEvent('artheist:server:syncAllPainting')
        QBCore.Functions.Notify(Strings['go_sell'])
        RemoveBlip(stealBlip)
        sellBlip = addBlip(Config['ArtHeist']['sellPainting']['pos'], 500, 0, Strings['sell_blip'])
        ArtHeist['cut'] = 0
    end
end

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(50)
    end
end

function loadModel(model)
    while not HasModelLoaded(GetHashKey(model)) do
        RequestModel(GetHashKey(model))
        Citizen.Wait(50)
    end
end

function ShowHelpNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function addBlip(coords, sprite, colour, text)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.8)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
    return blip
end

AddEventHandler('onResourceStop', function (resource)
    if resource == GetCurrentResourceName() then
        for k, v in pairs(ArtHeist['painting']) do
            DeleteObject(v)
        end
        for k, v in pairs(ArtHeist['objects']) do
            DeleteObject(v)
        end
    end
end)

local zone = {
    vector3(1356.3, 1185.97, 112.22),
    vector3(1354.69, 1161.99, 112.22),
    vector3(1347.54, 1155.92, 112.22),
    vector3(1333.96, 1152.71, 112.22),
    vector3(1341.53, 1136.71, 112.22),
    vector3(1349.27, 1138.1, 112.22),
    vector3(1356.53, 1133.26, 112.22),
    vector3(1363.43, 1131.97, 112.22),
    vector3(1371.73, 1114.75, 112.22),
    vector3(1390.18, 1109.0, 112.22),
    vector3(1426.84, 1109.89, 112.22),
    vector3(1437.92, 1109.79, 112.22),
    vector3(1438.53, 1185.37, 112.22)
}

local StopNoiseCheck = false
local nearManor = false

RegisterNetEvent('artheist:client:AlertGuards', function(leader)
    print("Alerted!!!")
    StopNoiseCheck = true
    stopAll = true
    SendNUIMessage({closeProgress = true})
    if madeGuards then
        local pGroup = (GetPedRelationshipGroupHash(PlayerPedId()))
        SetRelationshipBetweenGroups(5, pGroup, gGroup)
        SetRelationshipBetweenGroups(5, gGroup, pGroup)
        for k, v in pairs(netGuards) do
            SetPedRelationshipGroupHash(v, gGroup)
            SetPedCombatRange(v, 1)
            SetPedSeeingRange(v, 25.0)
            SetPedHearingRange(v, 20.0)
            ClearPedTasks(v)
            --TaskWanderInArea(v, GetEntityCoords(v), 50.0, 5000, 10000)
            TaskCombatHatedTargetsInArea(v, GetEntityCoords(v), 100.0, 1)
        end
    end
end)


local function noiseNUI(progress) if nearManor then SendNUIMessage({runProgress = true, Length = progress}) end end

function NoiseZone()
    local ped = PlayerPedId()
    local z = lib.zones.poly({points = zone, thickness = 10,
        onEnter = function() nearManor = true end,
        inside = function()
            if stopAll or StopNoiseCheck or not nearManor then SendNUIMessage({closeProgress = true}) return end
            noiseNUI(noiseLvl)
            if IsPedShooting(ped) then noiseLvl = noiseLvl + 20 end
            if GetEntitySpeed(ped) > 1.5 then noiseLvl = noiseLvl + LocalPlayer.state.foodBuff == 'sneaky' and 5 or 10
                if GetEntitySpeed(ped) > 2.5 then noiseLvl = noiseLvl + LocalPlayer.state.foodBuff == 'sneaky' and 10 or 15 end
                if GetEntitySpeed(ped) > 3.0 then noiseLvl = noiseLvl + LocalPlayer.state.foodBuff == 'sneaky' and 15 or 20 end
                Citizen.Wait(300)
            else
                noiseLvl = noiseLvl - 2
                if noiseLvl < 0 then noiseLvl = 0 end
                Citizen.Wait(1000)
            end
            noiseNUI(noiseLvl)
            if noiseLvl > 100 then
                if not alarmTriggered then
                    QBCore.Functions.Notify("You've alerted someone!", 'error')
                    alarmTriggered = true
                    TriggerServerEvent('artheist:server:AlertGuards', LocalPlayer.state.heistGroup)
                end
                noiseLvl = 100
            end
            Citizen.Wait(5)
            if heistFinished then StopNoiseCheck = true end
        end,
        onExit = function()
            nearManor = false
            SendNUIMessage({closeProgress = true})
        end
    })

end

RegisterCommand('crouchZone', function() NoiseZone() end)