local QBCore = exports['qb-core']:GetCoreObject()

exports['qb-target']:RemoveZone("goldenTrailDrugLaptop")
exports['qb-target']:AddBoxZone("goldenTrailDrugLaptop", vector3(569.46, -3127.42, 18.77), 0.5, 0.5, {name="goldenTrailDrugLaptop", heading=0, debugPoly=false, minZ=18.5, maxZ=19.0},
{options = {{event = "malmo-goldentrail:client:Login", icon = "fas fa-laptop", label = "Turn on Laptop"}}, distance = 2.5})

local LoadHe = function(a)
    QBCore.Functions.Progressbar("vpnConnect", 'Reaching Server...', 10000, true, true,
    { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true },
    {}, {}, {}, function() TriggerServerEvent('malmo-goldentrail:server:CheckHeistReq', a.d, a.i)
    end, function() ClearPedTasks(PlayerPedId()) end)
end

lib.registerContext({
    id = 'GTmethSupplies',
    title = '**Golden Lab Supplies**\n\nMeth Ingredients\n\n_50 Cosmo Each_',
    menu = 'GTsuppliesMenu',
    options = {
        {title = 'Intercept Thorium Oxide Deal.', description = 'Steal boxes of Thorium Oxide from a gang', onSelect = LoadHe, args = {d = 'meth', i = 'thorium'}},
        {title = 'Steal Methylamine Barrel.', description = 'Steal from a factory, at night, without getting seen.', onSelect = LoadHe, args = {d = 'meth', i = 'methylamine'}},
        {title = 'Acquire Aluminum.', description = '"Borrow" Aluminum from the quarry and bring it to the Foundry.', onSelect = LoadHe, args = {d = 'meth', i = 'alluminum'}},
    }
})

lib.registerContext({
    id = 'GTsuppliesMenu',
    title = '**Golden Lab Supplies**',
    menu = 'goldenTrailLaptop',
    options = {
        {title = 'Bulk Meth Production Supplies', description = 'Thorium Oxide, Methylamine Barrels & Alluminum.', menu = 'GTmethSupplies'},
        --{title = 'Bulk Coke Production Supplies', description = 'Kerosene, Limeslack & Hydrochloric Acid.', menu = 'GTcokeSupplies'},
    }
})

RegisterNetEvent('malmo-goldentrail:client:Login', function()
    local pData = QBCore.Functions.GetPlayerData()
    if pData.job.name == "police" or pData.job.name == "ambulance" or not QBCore.Functions.HasItem('vpn') then QBCore.Functions.Notify('That\'s just a regular laptop...') return end
    QBCore.Functions.Progressbar("vpnConnect", 'Initializing VPN...', 5000, true, true,
    { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true },
    {}, {}, {}, function()
        QBCore.Functions.Progressbar("vpnConnect", 'Connecting to the Dark Web...', 5000, true, true,
        { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true },
        {}, {}, {}, function()
            lib.registerContext({
                id = 'goldenTrailLaptop',
                title = 'The Golden Trail',
                options = {
                  {
                    title = 'Golden Lab Supplies',
                    description = 'Bulk Stuff of Questionnable Origins',
                    menu = 'GTsuppliesMenu',
                  },
                  {
                    title = 'Chatrooms',
                    description = 'Chat About Anything and Everything, To Anyone...',
                    onSelect = function() TriggerServerEvent('malmo-goldentrail:server:checkChatrooms') end,
                  },

                }
            }) lib.showContext('goldenTrailLaptop')
        end, function() ClearPedTasks(PlayerPedId()) end)
    end, function() ClearPedTasks(PlayerPedId()) end)
end)

RegisterNetEvent('malmo-goldentrail:client:showChatrooms', function(chatrooms)
    local pData = QBCore.Functions.GetPlayerData()
    if #chatrooms == 0 then QBCore.Functions.Notify('There is no one connected at the moment', 'error') lib.showContext('goldenTrailLaptop') return end
    lib.registerContext({
        id = 'goldenTrailLaptop',
        title = 'Chatrooms',
        options = chatrooms
    }) lib.showContext('goldenTrailLaptop')
end)


local function SetupStarterPed(coords)
    RequestModel("g_m_m_armlieut_01")
    while not HasModelLoaded("g_m_m_armlieut_01") do
        Wait(20)
    end
    StarterPed = CreatePed(0, 'g_m_m_armlieut_01', coords, 227.43, false, true)
    while StarterPed == 0 do CreatePed(0, 'g_m_m_armlieut_01', coords, 227.43, false, true) Wait(0) end
    print(StarterPed)
    NetworkRegisterEntityAsNetworked(StarterPed)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(StarterPed), true)
    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(StarterPed), true)
    GiveWeaponToPed(StarterPed, GetHashKey('WEAPON_COMBATPISTOL'), 255, false, true)
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
    local _, Hash = AddRelationshipGroup("Guards")
    SetRelationshipBetweenGroups(0, Hash, Hash)
    SetRelationshipBetweenGroups(4, Hash, pedGroud)
    SetRelationshipBetweenGroups(4, pedGroud, Hash)
    SetPedRelationshipGroupHash(ped, Hash)

    return StarterPed
end

-- local pagerLines = {
--     [1] = {
--         {l ='Hello? Whatsup Juan? Is Everything good?', t = 8000},
--         {l ='Juan? Do you copy?', t = 8000},
--         {l ='I\'ll have to sound the alarm if you don\'t answer...', t = 8000},
--     }
-- }

-- local pagerAnswers = {
--     [1] = {
--         p = {l ='Yes! Hi.. I\'m sorry.. I dropped my sandwhich and uh... triggered my radio...', t = 8000},
--         g = {l ='Hmm.. Okay.. Yeah.. sure...', t = 8000},
--     }
-- }

-- RegisterNetEvent('pagerEnabled',function(ped)
--     Wait(5000)
--     local pagerEnabled = false
--     exports['qb-target']:AddTargetEntity(ped, {
--         options = {
--             {
--                 icon = "fas fa-hand",
--                 label = 'Answer Pager',
--                 canInteract = function() return pagerEnabled end,
--                 action = function()
--                     print("Pager Answered")
--                     pagerEnabled = false

--                     local time = GetGameTimer()
--                     local currLine = 1
--                     local elapsed = 0

--                     Citizen.CreateThread(function()
--                         exports['xsound']:Destroy('RadioClick')
--                         Wait(100)
--                         exports['xsound']:PlayUrlPos("RadioClick", './sounds/radiostatic2.ogg', 1.0, GetEntityCoords(ped))--radioclick --radiostatic1
--                         local p1 = false
--                         while true do
--                             elapsed = GetGameTimer() - time
--                             if elapsed > pagerAnswers[1][currLine].p.t then
--                                 p1 = true
--                                 time = GetGameTimer() elapsed = 0
--                                 ShowText("~b~[Pager]~w~ "..pagerAnswers[1][currLine].g.l, 4, {255, 255, 255}, 0.5, 0.6, 0.888 + 0.025)
--                                 if elapsed > pagerAnswers[1][currLine].p.t + 5000 then break end
--                             end
--                             ShowText("~b~[You]~w~ "..pagerAnswers[1][currLine].p.l, 4, {255, 255, 255}, 0.5, 0.6, 0.500 + 0.025)
--                             Citizen.Wait(0)
--                         end
--                     end)
--                 end
--             }
--         },
--         distance = 3.0
--     })
--     local time = GetGameTimer()
--     local currLine = 1
--     local elapsed = 0
--     -- if stop then exports['xsound']:Destroy('PhoneRinging')
--     -- else exports['xsound']:PlayUrlPos("PhoneRinging", './sounds/phoneringing.ogg', 0.8, coords) end

--     print(2)
--     Citizen.CreateThread(function()
--         pagerEnabled = true
--         exports['xsound']:Destroy('RadioClick')
--         Wait(100)
--         exports['xsound']:PlayUrlPos("RadioClick", './sounds/radiostatic2.ogg', 1.0, GetEntityCoords(ped))--radioclick --radiostatic1
--         while true do
--             elapsed = GetGameTimer() - time
--             if elapsed > pagerLines[1][currLine].t then
--                 currLine = currLine + 1 time = GetGameTimer() elapsed = 0
--                 print(GetEntityCoords(ped))
--                 exports['xsound']:Destroy('RadioClick')
--                 Wait(100)
--                 exports['xsound']:PlayUrlPos("RadioClick", './sounds/radiostatic2.ogg', 1.0, GetEntityCoords(ped))
--             end
--             ShowText("~b~[Pager]~w~ "..pagerLines[1][currLine].l, 4, {255, 255, 255}, 0.5, 0.6, 0.888 + 0.025)
--             if pagerEnabled == false then break end
--             if not pagerLines[1][currLine] then
--                 exports['xsound']:Destroy('RadioClick')
--                 pagerEnabled = false print("Alarm")
--             end
--             Citizen.Wait(0)
--         end
--     end)
-- end)




RegisterCommand('patrolTest', function()

    -- local ped = SetupStarterPed(vector3(1401.05, 1129.26, 114.33))
    -- print(ped, (ped and GetEntityCoords(ped)) or "nil")
    -- OpenPatrolRoute('miss_Madrazdo_0')
    -- AddPatrolRouteNode(0, "StandGuard", vector3(1401.05, 1129.26, 114.33), vector3(1396.76, 1132.54, 114.33), math.random(10000,15000))
    -- AddPatrolRouteNode(1, "", vector3(1391.92, 1129.74, 114.33), vector3(0,0,0), 0)
    -- AddPatrolRouteNode(2, "StandGuard", vector3(1391.41, 1132.85, 114.33), vector3(1387.8, 1132.61, 114.33), math.random(7500,10000))
    -- AddPatrolRouteNode(3, "", vector3(1392.0, 1134.53, 114.33), vector3(0,0,0), 0)
    -- AddPatrolRouteNode(4, "", vector3(1398.18, 1135.58, 114.33), vector3(0,0,0), 0)
    -- AddPatrolRouteNode(5, "StandGuard", vector3(1398.34, 1143.4, 114.33), vector3(1405.53, 1149.69, 114.33), math.random(10000,15000))
    -- AddPatrolRouteNode(6, "", vector3(1398.35, 1147.75, 114.33), vector3(0,0,0), 0)
    -- AddPatrolRouteNode(7, "StandGuard", vector3(1392.13, 1147.44, 114.33), vector3(1387.95, 1147.62, 114.33), math.random(7500,10000))
    -- AddPatrolRouteNode(8, "", vector3(1398.35, 1147.75, 114.33), vector3(0,0,0), 0)
    -- AddPatrolRouteNode(9, "", vector3(1398.33, 1137.24, 114.33), vector3(0,0,0), 0)
    -- AddPatrolRouteNode(10, "", vector3(1400.42, 1134.27, 114.33), vector3(0,0,0), 0)
    -- AddPatrolRouteLink(0,1)
    -- AddPatrolRouteLink(1,2)
    -- AddPatrolRouteLink(2,3)
    -- AddPatrolRouteLink(3,4)
    -- AddPatrolRouteLink(4,5)
    -- AddPatrolRouteLink(5,6)
    -- AddPatrolRouteLink(6,7)
    -- AddPatrolRouteLink(7,8)
    -- AddPatrolRouteLink(8,9)
    -- AddPatrolRouteLink(9,0)

    -- local ped = SetupStarterPed(vector3(1387.2, 1127.32, 114.33))
    -- print(ped, (ped and GetEntityCoords(ped)) or "nil")
    -- OpenPatrolRoute('miss_Madrazdo_1')
    -- AddPatrolRouteNode(0, "StandGuard", vector3(1387.2, 1127.32, 114.33), vector3(1374.22, 1133.42, 114.09), math.random(10000,15000))
    -- AddPatrolRouteNode(1, "", vector3(1387.45, 1154.43, 114.33), vector3(0,0,0), 0)
    -- AddPatrolRouteNode(2, "WORLD_HUMAN_AA_SMOKE", vector3(1383.23, 1154.87, 114.33), vector3(1374.8, 1155.32, 114.01), math.random(45000,60000))
    -- AddPatrolRouteNode(3, "", vector3(1387.53, 1155.11, 114.33), vector3(0,0,0), 0)
    -- AddPatrolRouteNode(4, "", vector3(1387.24, 1126.96, 114.33), vector3(0,0,0), 0)
    -- AddPatrolRouteNode(5, "StandGuard", vector3(1409.34, 1127.22, 114.33), vector3(1414.24, 1132.85, 114.35), math.random(10000,15000))
    -- AddPatrolRouteLink(0,1)
    -- AddPatrolRouteLink(1,2)
    -- AddPatrolRouteLink(2,3)
    -- AddPatrolRouteLink(3,4)
    -- AddPatrolRouteLink(4,5)
    -- AddPatrolRouteLink(5,0)


    -- local ped = SetupStarterPed(vector3(1388.6, 1162.45, 114.33))
    -- print(ped, (ped and GetEntityCoords(ped)) or "nil")
    -- OpenPatrolRoute('miss_Madrazdo_2')
    -- AddPatrolRouteNode(0, "StandGuard", vector3(1388.6, 1162.45, 114.33), vector3(1375.96, 1162.62, 114.21), math.random(10000,15000))
    -- AddPatrolRouteNode(1, "", vector3(1387.35, 1162.57, 114.33), vector3(0,0,0), 0)
    -- AddPatrolRouteNode(2, "StandGuard", vector3(1387.52, 1167.41, 114.33), vector3(1380.4, 1173.34, 114.39), math.random(10000,15000))
    -- AddPatrolRouteNode(3, "StandGuard", vector3(1410.13, 1167.31, 114.33), vector3(1409.67, 1176.14, 114.31), math.random(10000,15000))
    -- AddPatrolRouteNode(4, "", vector3(1410.26, 1154.54, 114.33), vector3(0,0,0), 0)
    -- AddPatrolRouteNode(5, "StandGuard", vector3(1418.28, 1151.84, 114.67), vector3(1421.29, 1151.9, 112.97), math.random(7500,10000))
    -- AddPatrolRouteNode(6, "", vector3(1410.26, 1154.54, 114.33), vector3(0,0,0), 0)
    -- AddPatrolRouteNode(7, "StandGuard", vector3(1410.13, 1167.31, 114.33), vector3(1409.67, 1176.14, 114.31), math.random(10000,15000))
    -- AddPatrolRouteNode(8, "StandGuard", vector3(1387.52, 1167.41, 114.33), vector3(1380.4, 1173.34, 114.39), math.random(10000,15000))
    -- AddPatrolRouteNode(9, "", vector3(1387.35, 1162.57, 114.33), vector3(0,0,0), 0)
    -- AddPatrolRouteLink(0,1)
    -- AddPatrolRouteLink(1,2)
    -- AddPatrolRouteLink(2,3)
    -- AddPatrolRouteLink(3,4)
    -- AddPatrolRouteLink(4,5)
    -- AddPatrolRouteLink(5,6)
    -- AddPatrolRouteLink(6,7)
    -- AddPatrolRouteLink(7,8)
    -- AddPatrolRouteLink(8,9)
    -- AddPatrolRouteLink(9,0)

    -- local ped = SetupStarterPed(vector3(1399.28, 1165.17, 114.33))
    -- print(ped, (ped and GetEntityCoords(ped)) or "nil")
    -- OpenPatrolRoute('miss_Madrazdo_3')
    -- AddPatrolRouteNode(0, "WORLD_HUMAN_WINDOW_SHOP_BROWSE", vector3(1399.28, 1165.17, 114.33), vector3(1399.21, 1165.79, 114.33), math.random(10000,15000))
    -- AddPatrolRouteNode(1, "StandGuard", vector3(1399.28, 1165.17, 114.33), vector3(1400.01, 1164.97, 114.33), 1000)
    -- AddPatrolRouteNode(2, "WORLD_HUMAN_WINDOW_SHOP_BROWSE", vector3(1399.28, 1165.17, 114.33), vector3(1400.01, 1164.97, 114.33), math.random(10000,15000))
    -- AddPatrolRouteNode(3, "StandGuard", vector3(1399.28, 1165.17, 114.33), vector3(1399.28, 1158.87, 114.33), math.random(10000,15000))
    -- AddPatrolRouteNode(4, "", vector3(1399.18, 1151.33, 114.33), vector3(0,0,0), 0)
    -- AddPatrolRouteNode(5, "StandGuard", vector3(1396.8, 1152.16, 114.33), vector3(1393.49, 1153.33, 114.44), math.random(10000,15000))
    -- AddPatrolRouteNode(6, "", vector3(1400.08, 1149.97, 114.33), vector3(0,0,0), 0)
    -- AddPatrolRouteNode(7, "StandGuard", vector3(1408.36, 1149.8, 114.33), vector3(1412.94, 1147.85, 114.33), math.random(10000,15000))
    -- AddPatrolRouteNode(8, "StandGuard", vector3(1408.18, 1144.66, 114.33), vector3(1401.42, 1149.48, 114.33), math.random(7500,10000))
    -- AddPatrolRouteNode(9, "", vector3(1406.23, 1145.25, 114.33), vector3(0,0,0), 0)
    -- AddPatrolRouteNode(10, "", vector3(1399.37, 1145.18, 114.33), vector3(0,0,0), 0)

    -- AddPatrolRouteLink(0,1)
    -- AddPatrolRouteLink(1,2)
    -- AddPatrolRouteLink(2,3)
    -- AddPatrolRouteLink(3,4)
    -- AddPatrolRouteLink(4,5)
    -- AddPatrolRouteLink(5,6)
    -- AddPatrolRouteLink(6,7)
    -- AddPatrolRouteLink(7,8)
    -- AddPatrolRouteLink(8,9)
    -- AddPatrolRouteLink(9,10)
    -- AddPatrolRouteLink(10,0)

    -- local ped = SetupStarterPed(vector3(1431.32, 1179.95, 114.17))
    -- print(ped, (ped and GetEntityCoords(ped)) or "nil")
    -- OpenPatrolRoute('miss_Madrazdo_4')
    -- AddPatrolRouteNode(0, "WORLD_HUMAN_AA_SMOKE", vector3(1431.32, 1179.95, 114.17), vector3(1431.16, 1188.9, 114.16), math.random(10000,15000))
    -- AddPatrolRouteNode(1, "StandGuard", vector3(1432.32, 1123.58, 114.3), vector3(1422.11, 1119.51, 114.67), math.random(10000,15000))
    -- AddPatrolRouteNode(2, "", vector3(1423.53, 1115.41, 114.54), vector3(0,0,0), 0)
    -- AddPatrolRouteNode(3, "", vector3(1390.53, 1115.61, 114.82), vector3(0,0,0), 0)
    -- AddPatrolRouteNode(4, "", vector3(1372.7, 1124.33, 114.13), vector3(0,0,0), 0)
    -- AddPatrolRouteNode(5, "StandGuard", vector3(1368.33, 1135.49, 113.76), vector3(1363.72, 1144.27, 113.76), math.random(10000,15000))
    -- AddPatrolRouteNode(6, "", vector3(1372.7, 1124.33, 114.13), vector3(0,0,0), 0)
    -- AddPatrolRouteNode(7, "", vector3(1390.53, 1115.61, 114.82), vector3(0,0,0), 0)
    -- AddPatrolRouteNode(8, "StandGuard", vector3(1423.53, 1115.41, 114.54), vector3(1429.41, 1110.54, 114.19), math.random(10000,15000))
    -- AddPatrolRouteNode(9, "StandGuard", vector3(1432.32, 1123.58, 114.3), vector3(0,0,0), 0)

    -- AddPatrolRouteLink(0,1)
    -- AddPatrolRouteLink(1,2)
    -- AddPatrolRouteLink(2,3)
    -- AddPatrolRouteLink(3,4)
    -- AddPatrolRouteLink(4,5)
    -- AddPatrolRouteLink(5,6)
    -- AddPatrolRouteLink(6,7)
    -- AddPatrolRouteLink(7,8)
    -- AddPatrolRouteLink(8,9)
    -- AddPatrolRouteLink(9,0)

    local ped = SetupStarterPed(vector3(1361.39, 1161.03, 113.75))
    print(ped, (ped and GetEntityCoords(ped)) or "nil")
    OpenPatrolRoute('miss_Madrazdo_5')
    AddPatrolRouteNode(0, "WORLD_HUMAN_AA_SMOKE", vector3(1361.39, 1161.03, 113.75), vector3(1361.17, 1154.46, 113.76), math.random(10000,15000))
    AddPatrolRouteNode(1, "StandGuard", vector3(1360.7, 1182.3, 112.49), vector3(1360.43, 1188.86, 112.45), math.random(10000,15000))
    AddPatrolRouteNode(2, "", vector3(1366.92, 1189.31, 112.76), vector3(0,0,0), 0)
    AddPatrolRouteNode(3, "StandGuard", vector3(1416.69, 1187.73, 114.0), vector3(1431.47, 1186.33, 114.16), math.random(10000,15000))
    AddPatrolRouteNode(4, "", vector3(1366.92, 1189.31, 112.76), vector3(0,0,0), 0)
    AddPatrolRouteNode(5, "StandGuard", vector3(1341.34, 1188.54, 110.17), vector3(1331.43, 1188.79, 108.39), math.random(10000,15000))
    AddPatrolRouteNode(6, "", vector3(1354.29, 1188.47, 112.17), vector3(0,0,0), 0)
    AddPatrolRouteNode(7, "", vector3(1360.7, 1182.3, 112.49), vector3(0,0,0), 0)

    AddPatrolRouteLink(0,1)
    AddPatrolRouteLink(1,2)
    AddPatrolRouteLink(2,3)
    AddPatrolRouteLink(3,4)
    AddPatrolRouteLink(4,5)
    AddPatrolRouteLink(5,6)
    AddPatrolRouteLink(6,7)
    AddPatrolRouteLink(7,0)

    ClosePatrolRoute()
    CreatePatrolRoute()
    ::patrol::
    TaskPatrol(ped, "miss_Madrazdo_5", 0, 1, 0)
    local dead = false
    local alertLevel = 0
    local h_rgb = {
        {100, 28,131,191},
        {200, 158,191,28},
        {300, 191,147,28},
        {400, 255,0,0},
    }
    Citizen.CreateThread(function()
        local player = PlayerPedId()
        local wait = 2000
        while true do
            local rgb = {255,128,0}
            local o = GetOffsetFromEntityInWorldCoords(ped, 0, -0.8, -0.9)
            local head = GetOffsetFromEntityInWorldCoords(ped, 0, 0.0, 1.2)
            local front =  GetOffsetFromEntityInWorldCoords(ped, 0, 5.0, 0)
            local pcoords = GetEntityCoords(player)
            local dist = #(pcoords - o)
            local front_dist =#(pcoords - front)
            if dist < 15.0 then wait = 0 end
            if front_dist < 5.0 then
                if exports['rpemotes']:IsPlayerCrouched() and HasEntityClearLosToEntityInFront(ped, player) then
                    alertLevel = alertLevel + 1
                end
            elseif front_dist < 10.0 and exports['rpemotes']:IsPlayerCrouched() then
                if HasEntityClearLosToEntityInFront(ped, player) then print("LOS") alertLevel = alertLevel + 1 end
            elseif front_dist < 10.0 then
                if HasEntityClearLosToEntityInFront(ped, player) then print("LOS") alertLevel = 500 break end
            elseif alertLevel > 0 then alertLevel = alertLevel - 1 end

            if dist < 2.0 and GetPedStealthMovement() == false then
                rgb = {0,255,0}
                SetPedStealthMovement(player, 1, "DEFAULT_ACTION")
            elseif dist >= 2.0 then
                SetPedStealthMovement(player, 0, "DEFAULT_ACTION")
            end
            if IsPedBeingStealthKilled(ped) and IsPedPerformingStealthKill(player) then
                print("Killed by player")
                SetPedStealthMovement(player, 0, "DEFAULT_ACTION")
                dead = true
                TriggerEvent('pagerEnabled', ped)
                break
            end

            if IsPedDeadOrDying(ped) then dead = true break end
            if IsPedInCombat(ped, player) then combat = true break end
            local hrgb = {28,131,191}
            for _, v in pairs(h_rgb) do if alertLevel < v[1] then hrgb = {v[2], v[3], v[4]} break end end
            DrawMarker(25, o, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, rgb[1], rgb[2], rgb[3], 60, false, false, 2, 0, nil, nil, false)
            DrawMarker(32, head, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, hrgb[1], hrgb[2], hrgb[3], alertLevel > 0 and 60 or 0, false, true, 2, 0, nil, nil, false)
            if alertLevel >= 500 then alertLevel = 500 break end
            Citizen.Wait(wait)
        end
    end)
    while true do
        Citizen.Wait(1000)
        print("Alert Level : "..alertLevel)
        if alertLevel == 500 then
            local pedGroud = (GetPedRelationshipGroupHash(PlayerPedId()))
            local _, Hash = AddRelationshipGroup("Guards")
            SetRelationshipBetweenGroups(0, Hash, Hash)
            SetRelationshipBetweenGroups(5, Hash, pedGroud)
            SetRelationshipBetweenGroups(5, pedGroud, Hash)
            SetPedRelationshipGroupHash(ped, Hash)
        end
        if not GetIsTaskActive(ped, 355) then print("Finished Route") break end
        if dead then print("Dead..") break end
    end
    Wait(2000)
    if IsPedInCombat(ped, PlayerPedId()) then elseif not dead then goto patrol end
    --TaskPatrol(PlayerPedId(), "miss_Madrazdo_0", 0, 0, 0)

    -- Wait(5000)
    -- TaskPatrol(PlayerPedId(), "miss_Madrazdo", 1, 0, 0)

    -- ClearPedTasks(PlayerPedId())
    -- print(2)
    -- TaskPatrol(PlayerPedId(), "miss_Madrazdo", 1, 1, 1)
end)


RegisterNetEvent('malmo-goldentrail:client:addToGroup', function(group, name) QBCore.Functions.Notify('You have been added to '..name..'\'s group.') LocalPlayer.state.heistGroup = group end)
RegisterNetEvent('malmo-goldentrail:client:removeFromGroup', function() QBCore.Functions.Notify('Your group has been disbanded.') LocalPlayer.state.heistGroup = nil end)
function MakeGangGroup(e)
    QBCore.Functions.TriggerCallback('getPlayersCloseby', function(players)
        if not players then return end
        local gvalues = {}
        for k, v in ipairs(players) do gvalues[k] = {label = v.name, value = k} end
        local input = lib.inputDialog('Select Group Members', {
            {type = 'multi-select', label = 'Chose Heist Group', description = 'Chose your group members which will help with the heist.', options = gvalues, required = true},
        }) if not input or not #input[1] then return end
        if #input[1] > 5 then QBCore.Functions.Notify('You can only chose up to 5 other people.', 'error') return end
        local pstr, confirmedGroup = '', {}
        for k, v in ipairs(input[1]) do
            confirmedGroup[k] = players[v]
            pstr = pstr..", \n "..players[v].name
        end
        local alert = lib.alertDialog({
            header = 'Confirm Heist Group.',
            content = '**Group Contained of :** \n\n Yourself'..pstr..' \n\n **Proceed with heist?**',
            centered = true,
            cancel = true
        })
        if alert ~= "confirm" then return end
        TriggerServerEvent('malmo-goldentrail:server:makeGroup', confirmedGroup)
        TriggerEvent(e)
    end, GetEntityCoords(PlayerPedId()))
end exports("MakeGangGroup", MakeGangGroup)