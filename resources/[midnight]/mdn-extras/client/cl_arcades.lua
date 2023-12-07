local QBCore = exports['qb-core']:GetCoreObject()

-- exports['qb-target']:RemoveZone("coincabinet")
-- exports['qb-target']:AddBoxZone("coincabinet", vector3(326.90, -926.97, 29.25), 0.6, 0.5, { name="coincabinet", heading = 0, debugPoly = Config.DebugPoly, minZ = 28.251, maxZ = 29.251, },
-- { options = { { event = "cyberbar:client:getcoins", icon = "fas fa-coins", label = "Get Coins" }, }, distance = 2 })

CreateThread(function()
    local dict = 'anim_casino_a@amb@casino@games@arcadecabinet@maleleft'
    LoadAnimDict(dict)
end)

for k, v in pairs(Config.Arcades) do
    exports['qb-target']:RemoveZone("arcade"..k)
    exports['qb-target']:AddBoxZone("arcade"..k, v.coords, 0.9, 0.9, { name="arcade"..k, heading = 0, debugPoly = Config.DebugPoly, minZ = v.coords.z-1, maxZ = v.coords.z+1, },
    { options = { { event = "cyberbar:client:insertcoin", icon = "fas fa-coins", label = "Insert Coin", arcade = k }, }, distance = 2 })
end

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function LoadModel(model)
    while (not HasModelLoaded(model)) do
        RequestModel(model)
        Citizen.Wait(5)
    end
end

local function HackingMinigames(game)
    local p = promise.new()
        local success = Config.HackingMinigames[game].Game()
        p:resolve(success)
    return p
end

RegisterNetEvent('cyberbar:client:getcoins', function()
    PlayerData = {}
    PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData.job.name == "cyberbar" and PlayerData.job.isboss then
        QBCore.Functions.Notify('You grab some coins.', 'success', 7500)
        TriggerServerEvent('cyberbar:server:gencoins')
    else
        QBCore.Functions.Notify('You don\'t have the key!', 'error', 7500)
    end
end)

RegisterNetEvent('cyberbar:client:playgame', function(data)
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    local dict = 'anim_casino_a@amb@casino@games@arcadecabinet@maleleft'
    LoadAnimDict(dict)
    ---TaskPlayAnim(ped, dict, 'insert_coins', 4.0, 4.0, -1, 1, 1.0, 1, 1, 1)

    local scene = NetworkCreateSynchronisedScene(pcoords.x-0.7, pcoords.y-0.01, pcoords.z-0.98, GetEntityRotation(ped), 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene, dict, 'insert_coins', 4.0, 4.0, 5000, 0, 1000.0, 0)
    NetworkStartSynchronisedScene(scene)

    local idlescene = NetworkCreateSynchronisedScene(pcoords.x-0.7, pcoords.y-0.01, pcoords.z-0.98, GetEntityRotation(ped), 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, idlescene, dict, 'playidle', 4.0, 4.0, 5000, 0, 1000.0, 0)

    Wait(2000)
    TriggerServerEvent('cyberbar:server:PayCoins')
    Wait(3000)
    --TaskPlayAnim(ped, dict, 'playidle', 4.0, 4.0, -1, 1, 1.0, 1, 1, 1)
    NetworkStartSynchronisedScene(idlescene)
    HackingMinigames(data.game):next(function(success)
        if success then
            local winscene = NetworkCreateSynchronisedScene(pcoords.x-0.7, pcoords.y-0.01, pcoords.z-0.98, GetEntityRotation(ped), 2, false, true, 1065353216, 0, 1.3)
            NetworkAddPedToSynchronisedScene(ped, winscene, dict, 'win', 4.0, 4.0, 5000, 0, 1000.0, 0)
            NetworkStartSynchronisedScene(winscene)
            --TaskPlayAnim(ped, dict, 'win', 4.0, 4.0, -1, 1, 1.0, 1, 1, 1)
            Wait(2000) ClearPedTasks(ped)
            --TriggerServerEvent('cyberbar:server:coupons')
        else
            local losescene = NetworkCreateSynchronisedScene(pcoords.x-0.7, pcoords.y-0.01, pcoords.z-0.98, GetEntityRotation(ped), 2, false, true, 1065353216, 0, 1.3)
            NetworkAddPedToSynchronisedScene(ped, losescene, dict, 'lose', 4.0, 4.0, 5000, 0, 1000.0, 0)
            NetworkStartSynchronisedScene(losescene)
            --TaskPlayAnim(ped, dict, 'lose', 4.0, 4.0, -1, 1, 1.0, 1, 1, 1)
            Wait(1500) ClearPedTasks(ped)
        end
    end)
end)

RegisterNetEvent('cyberbar:client:stop', function()
    local ped = PlayerPedId()
    ClearPedTasks(ped)
end)

RegisterNetEvent('cyberbar:client:insertcoin', function(data)
    local Arcade = Config.Arcades[data.arcade]
    local obj = GetClosestObjectOfType(Arcade.coords, 1.0, Arcade.hash, 0 , 0, 0)
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    TaskTurnPedToFaceEntity(ped, obj, -1)
    Wait(2000)
    if obj == 0 then return end
    QBCore.Functions.TriggerCallback('cyberbar:server:insertcoin', function(result)
        if result then
            local dict = 'anim_casino_a@amb@casino@games@arcadecabinet@maleleft'
            LoadAnimDict(dict)
            --TaskPlayAnim(ped, dict, 'idle', 4.0, 4.0, -1, 1, 1.0, 1, 1, 1)
            local scene = NetworkCreateSynchronisedScene(Arcade.coords.x, Arcade.coords.y, Arcade.coords.z-0.98, GetEntityRotation(ped), 2, false, true, 1065353216, 0, 1.3)
            NetworkAddPedToSynchronisedScene(ped, scene, dict, 'idle', 4.0, 4.0, 5000, 0, 1000.0, 0)
            NetworkStartSynchronisedScene(scene)
            local ArcadeMenu = {{ header = "CyberArcade", isMenuHeader = true}}
            for k, v in pairs(Config.HackingMinigames) do
                ArcadeMenu[#ArcadeMenu+1] = {
                    header = v.Name,
                    icon = v.Icon,
                    params = { event = 'cyberbar:client:playgame', args = { game = k } }
                }
            end
            ArcadeMenu[#ArcadeMenu+1] = {header = "Leave", params = { event = 'cyberbar:client:stop'}}
            exports['qb-menu']:openMenu(ArcadeMenu)
        else
            QBCore.Functions.Notify('You don\'t have enough coins to play!', 'error', 7500)
            ClearPedTasks(ped)
        end
    end)
end)