local QBCore = exports['qb-core']:GetCoreObject()

LocalPlayer.state:set('GettingPackage', false, true)
LocalPlayer.state:set("MethRunActive", false, true)
LocalPlayer.state:set("HasGoods", false, true)
LocalPlayer.state:set("JobDone", false, true)
LocalPlayer.state:set('textui', false, true)
local GoodsTaken = 0
local guards = {}
local LookingForVehicle = false
local TrackerActive = false
local LicensePlate
local GoodsAmount
local MethCar
local DropOffCoords
local StarterPed
local carBlip
local CheckCarCoords
local goodsBlip
local dropBlip
local Vehicle

local function GenerateLicensePlate()
    local i = 0
    local plate = ""
    while i < 2 do
        local randuppercase = string.char(math.random(65, 65 + 25))
        plate = plate..randuppercase
        i = i + 1
    end
    local ranint = math.random(100,999)
    plate = plate..tostring(ranint)
    i = 0
    while i < 3 do
        local randuppercase = string.char(math.random(65, 65 + 25))
        plate = plate..randuppercase
        i = i + 1
    end
    return plate
end

local function SetupStarterPed()
    RequestModel("cs_josh")
    while not HasModelLoaded("cs_josh") do
        Wait(20)
    end
    StarterPed = CreatePed(0, 'cs_josh', Config.StartLocation.coords['x'], Config.StartLocation.coords['y'], Config.StartLocation.coords['z']-1, Config.StartLocation.heading, false, false)
    SetEntityInvincible(StarterPed, true)
    SetBlockingOfNonTemporaryEvents(StarterPed, true)
    PlaceObjectOnGroundProperly(StarterPed)
    FreezeEntityPosition(StarterPed, true)
    ActivateStarterPedTarget(StarterPed)
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(2000) SetupStarterPed()
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        SetupStarterPed()
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        StarterPed = nil
    end
end)

local function Blip(type, coords)
    if type == "car" then
        carBlip = AddBlipForRadius(coords, 200.0)
        SetBlipColour(carBlip, 47)
        SetBlipAlpha(carBlip, 128)
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    elseif type == "goods" then
        local blipcoords = coords
        goodsBlip = AddBlipForCoord(blipcoords.x, blipcoords.y, blipcoords.z)
        SetBlipSprite(goodsBlip, 478)
        SetBlipColour(goodsBlip, 47)
        SetBlipRoute(goodsBlip)
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    elseif type == "drop" then
        local blipcoords = coords
        dropBlip = AddBlipForCoord(blipcoords.x, blipcoords.y, blipcoords.z)
        SetBlipSprite(dropBlip, 478)
        SetBlipColour(dropBlip, 47)
        SetBlipRoute(dropBlip)
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    end
end

local function VehicleInfo(vehicle)
    local vehInfo = {
        vehicle = Vehicle,
        plate = LicensePlate,
        color = GetVehicleColourCombination(vehicle),
    }
    return vehInfo
end

local function SetVehicleTracker()
    local DispatchCall = 3
    Wait(5000)
    Citizen.CreateThread(function()
        while TrackerActive do
            local vehCoords = GetEntityCoords(MethCar)
            if DispatchCall == 3 then CallCops(VehicleInfo(MethCar), vehCoords, MethCar) DispatchCall = 0 else TriggerServerEvent('cr-methrun:server:SendBlip', vehCoords) end
            DispatchCall = DispatchCall + 1
            Wait(Config.Police.BlipInterval * 1000)
        end
    end)
end

local function StartCountdown()
    LocalPlayer.state:set("MethRunActive", true, true)
    local Time = math.random(Config.Countdown.MinTime, Config.Countdown.MaxTime)
    local EmailWaitTime = math.random(15000, 30000)
    Wait(EmailWaitTime)
    TrackerActive = true
    SetVehicleTracker()
    MethRunEmails("DeliveryInProgress")
    Wait((Time * 1000)*60)
    TrackerActive = false
    local ranLoc = math.random(#Config.DropOffLocations)
    local loc = Config.DropOffLocations[ranLoc]
    DropOffCoords = loc.coords
    SetNewWaypoint(loc.coords['x'], loc.coords['y'])
    Blip("drop", DropOffCoords)
    MethRunNotif(2, Lcl("notif_DropOffLocated"), Lcl("notif_MethRunTitle"))
    ActivateDeliveringTarget(MethCar)
    --ActivateEndCooldown()
end


-- RegisterCommand('metthrun', function()
--     StartCountdown()
-- end)

local function SpawnGoodsPed(ranLoc)
    RequestModel("cs_josh")
    while not HasModelLoaded("cs_josh") do
        Wait(1)
    end
    GoodsAmount = math.random(Config.MinGoods, Config.MaxGoods)
    local npc = CreatePed(0, 'cs_josh', Config.GoodsPickupLocation[ranLoc].coords, Config.GoodsPickupLocation[ranLoc].heading, true, 1)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    PlaceObjectOnGroundProperly(npc)
    LocalPlayer.state:set('GettingPackage', true, true)
    ActivatePedTarget(npc)
end

RegisterNetEvent('cr-methrun:client:isInVehicle', function()
    RemoveBlip(carBlip)
    Wait(5000)
    MethRunEmails("ProductReady")
    local ranLoc = math.random(#Config.GoodsPickupLocation)
    Wait(1000)
    SetNewWaypoint(Config.GoodsPickupLocation[ranLoc].coords.x, Config.GoodsPickupLocation[ranLoc].coords.y)
    Blip("goods", Config.GoodsPickupLocation[ranLoc].coords)
    MethRunNotif(1, Lcl("notif_GPSUpdate"), Lcl("notif_MethRunTitle"))
    SpawnGoodsPed(ranLoc)
end)

local function SpawnGuards(coords)
    local ped = PlayerPedId()
    local pedGroud = (GetPedRelationshipGroupHash(ped))
    local _, Hash = AddRelationshipGroup("Guards")
    SetRelationshipBetweenGroups(0, Hash, Hash)
    SetRelationshipBetweenGroups(5, Hash, pedGroud)
    SetRelationshipBetweenGroups(5, pedGroud, Hash)
    for k, v in pairs(Config.Guards) do
        local SpawnCoords = vector4(coords.x + v.pos[1], coords.y + v.pos[2], coords.z + v.pos[3], coords.x + v.pos[4])
        RequestModel(GetHashKey(v.ped))
        while not HasModelLoaded(GetHashKey(v.ped)) do
            Wait(1)
        end
        guards[k] = CreatePed(4, GetHashKey(v.ped), SpawnCoords.x, SpawnCoords.y, SpawnCoords.z, SpawnCoords.h, true, true)
        NetworkRegisterEntityAsNetworked(guards[k])
        SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(guards[k]), true)
        SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(guards[k]), true)
        GiveWeaponToPed(guards[k], GetHashKey(v.weapon), 255, false, false)
        SetPedRelationshipGroupHash(guards[k], Hash)
        SetPedAccuracy(guards[k], v.accuracy)
        SetPedArmour(guards[k], v.armor)
        SetPedFleeAttributes(guards[k], 0, false)
        SetPedCanSwitchWeapon(guards[k], true)
        SetPedDropsWeaponsWhenDead(guards[k], false)
        SetPedAsEnemy(guards[k], true)
        SetPedCombatMovement(guards[k], 3)
        SetPedAlertness(guards[k], 3)
        SetPedCombatRange(guards[k], 3)
        SetPedSeeingRange(guards[k], 150.0)
        SetPedHearingRange(guards[k], 150.0)
        SetPedCombatAttributes(guards[k], 46, 1)
        SetPedCanRagdollFromPlayerImpact(guards[k], false)
        SetEntityAsMissionEntity(guards[k])
        SetEntityVisible(guards[k], true)
        SetEntityMaxHealth(guards[k], v.health)
        SetEntityHealth(guards[k], v.health)
        TaskStandGuard(guards[k], coords.x + v.pos[1], coords.y + v.pos[2], coords.z + v.pos[3], coords.x + v.pos[4], "WORLD_HUMAN_GUARD_STAND")
    end
end

local function MethRunSpawnVehicle(vehicle, coords, heading, plate)
    QBCore.Functions.SpawnVehicle(vehicle, function(veh)
        SetEntityHeading(veh, heading)
        SetVehicleEngineOn(veh, false, false)
        SetVehicleOnGroundProperly(veh)
        SetVehicleNeedsToBeHotwired(veh, false)
        SetVehicleNumberPlateText(veh, plate)

        SetVehicleIsStolen(veh, true)
        --SetVehicleColours(vehicle, 0, 0)
        exports[Config.FuelSystem]:SetFuel(veh, Config.FuelLevel)
        for i = 0, 5 do
            SetVehicleDoorShut(veh, i, true)
        end
        LicensePlate = plate
        Vehicle = vehicle
        MethCar = veh
    end, coords, true)
    SetVehicleModKit(MethCar, 0)
    SetVehicleTyresCanBurst(MethCar, false)
    SetVehicleMod(MethCar, 11, Config.VehicleModifications.Engine, 0)
    SetVehicleMod(MethCar, 12, Config.VehicleModifications.Breaks, 0)
    SetVehicleMod(MethCar, 13, Config.VehicleModifications.Transmission, 0)
    SetVehicleMod(MethCar, 15, Config.VehicleModifications.Suspension, 0)
    SetVehicleMod(MethCar, 16, Config.VehicleModifications.Armor, 0)
    ToggleVehicleMod(MethCar, 18, Config.VehicleModifications.Turbo)
    SetVehicleMod(MethCar, 46, 2)
    if Config.VehicleNeons.Enabled then
        SetVehicleNeonLightEnabled(MethCar, 0, true)
        SetVehicleNeonLightEnabled(MethCar, 1, true)
        SetVehicleNeonLightEnabled(MethCar, 2, true)
        SetVehicleNeonLightEnabled(MethCar, 3, true)
        local ran = math.random(#Config.VehicleNeons.Color)
        SetVehicleNeonLightsColour(MethCar, Config.VehicleNeons.Color[ran].r, Config.VehicleNeons.Color[ran].g, Config.VehicleNeons.Color[ran].b)
    end
    SpawnGuards(coords)
    IsVehicleSpawned = true
    PickUpBlip = true
    local vehID = VehToNet(MethCar)
    TriggerServerEvent('cr-methrun:server:MethRunVehicle', vehID)
end

local function MethRunVehicleSpawning(location)
    local ped = PlayerPedId()
    local randomVeh = math.random(#Config.VehicleList)
    local plate = GenerateLicensePlate()
    MethRunNotif(1, Lcl("notif_EmailSent"), Lcl("notif_MethRunTitle"))
    MethRunEmails("VehicleLocated", Config.VehicleList[randomVeh].vehicle, plate)
    Wait(5000)
    MethRunNotif(1, Lcl("notif_GPSUpdate"), Lcl("notif_MethRunTitle"))
    Citizen.CreateThread(function()
        local wait = 2000
        while LookingForVehicle do
            local pedCoords = GetEntityCoords(ped)
            local dist = #(Config.VehicleCoords[location].coords - pedCoords)
            if dist <= 500 then wait = 100 end
            if dist <= 200 then
                MethRunSpawnVehicle(Config.VehicleList[randomVeh].vehicle, Config.VehicleCoords[location].coords, Config.VehicleCoords[location].heading, plate)
                LookingForVehicle = false
                break
            end
            Wait(wait)
        end
    end)
end

local function MethRunVehiclePickUp()
    local luck = math.random(#Config.VehicleCoords)
    local Xoffset = math.random(-175, 175)
    local Yoffset = math.random(-175, 175)
    local coords = Config.VehicleCoords[luck].coords + vector3(Xoffset, Yoffset, 0)
    Blip("car", coords)
    LookingForVehicle = true
    MethRunVehicleSpawning(luck)
end

local function ResetRun()
    ResetExtras()
    MethCar = nil
    Vehicle = nil
    GoodsTaken = 0
    GoodsAmount = 0
    CheckCarCoords = false
    if carBlip then RemoveBlip(carBlip) end
    if dropBlip then RemoveBlip(dropBlip) end
    if goodsBlip then RemoveBlip(goodsBlip) end
    LocalPlayer.state:set("JobDone", false, true)
    LocalPlayer.state:set("HasGoods", false, true)
    LocalPlayer.state:set("MethRunActive", false, true)
    LocalPlayer.state:set('GettingPackage', false, true)
end

local function CheckVehicle()
    local ped = PlayerPedId()
    local Notified = false
    Citizen.CreateThread(function()
        while CheckCarCoords do
            local pedCoords = GetEntityCoords(ped)
            local carCoords = GetEntityCoords(MethCar)
            local dist = #(carCoords - DropOffCoords)
            local pedDist = #(carCoords - pedCoords)

            if pedDist >= 300 then
                SetEntityAsNoLongerNeeded(MethCar)
                DeleteEntity(MethCar)
                LocalPlayer.state:set("JobDone", true, true)
                TriggerServerEvent("cr-methrun:server:Cooldown")
                CheckCarCoords = false
                break
            end
            
            if dist >= 300 then
                MethRunNotif(3, Lcl("notif_TooFar"), Lcl("notif_MethRunTitle"))
                ResetRun()
                TriggerServerEvent("cr-methrun:server:Cooldown")
                CheckCarCoords = false
                break
            end

            if dist >= 100 and not Notified then
                MethRunNotif(2, Lcl("notif_GettingTooFar"), Lcl("notif_MethRunTitle"))
                Notified = true
            end

            Wait(1000)
        end
    end)
end

RegisterNetEvent("cr-methrun:client:DeliverGoods", function()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    if LocalPlayer.state.inv_busy then return end
    local DropOffDist = #(pedCoords - vector3(DropOffCoords.x, DropOffCoords.y, DropOffCoords.z))
    if not LocalPlayer.state.MethRunActive then MethRunNotif(3, Lcl("notif_Useless"), Lcl("notif_MethRunTitle")) return end
    if not QBCore.Functions.HasItem('outdoorfurniturecleaner') and not LocalPlayer.state.HasGoods then MethRunNotif(3, Lcl("notif_MissingGoods"), Lcl("notif_MethRunTitle")) return end
    if DropOffDist > 10 then MethRunNotif(3, Lcl("notif_DropOffTooFar"), Lcl("notif_MethRunTitle")) return end
    local TrunkPoint = GetOffsetFromEntityInWorldCoords(MethCar, 0.0, -4.0, 0.0)
    local dist = #(pedCoords - vector3(TrunkPoint.x, TrunkPoint.y, TrunkPoint.z))
    if dist > 2 then return end
    LocalPlayer.state:set('inv_busy', true, true)
    TaskTurnPedToFaceEntity(ped, MethCar, 2000)
    Wait(2000)
    QBCore.Functions.Progressbar('getmethpackage', Lcl('progbar_Delivering'), math.random(20000, 30000), true, true,
    { disableMovement = true, disableCarMovement = true, isableMouse = false, disableCombat = true, },
    { animDict = "move_crouch_proto", anim = "idle", flags = 16 },
    {}, {}, function()
        LocalPlayer.state:set("HasGoods", false, true)
        LocalPlayer.state:set('inv_busy', false, true)
        CheckCarCoords = true
        ClearPedTasks(ped)
        RemoveBlip(dropBlip)
        CheckVehicle()
        TriggerServerEvent("cr-methrun:server:RemoveMethPackage", GoodsAmount)
        MethRunNotif(1, Lcl("notif_DropOffSuccess"), Lcl("notif_MethRunTitle"))
    end, function() ClearPedTasks(ped) LocalPlayer.state:set('inv_busy', false, true) end)
end)

RegisterNetEvent("cr-methrun:client:getPackage", function(data)
    local ped = PlayerPedId()
    local pedCoords  = GetEntityCoords(ped)
    local CarCoords = GetEntityCoords(MethCar, 0)
    local dist = #(CarCoords - pedCoords)
    if GoodsTaken >= GoodsAmount then MethRunNotif(3, Lcl("notif_NothingLeft"), Lcl("notif_MethRunTitle")) LocalPlayer.state:set('textui', false, true) return end
    if dist > 20 then MethRunNotif(3, Lcl("notif_MissingCar"), Lcl("notif_MethRunTitle")) LocalPlayer.state:set('textui', false, true) return end
    QBCore.Functions.Progressbar('getmethpackage', Lcl('progbar_CollectingPackage'), math.random(6500, 10000), true, true,
    { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, },
    { animDict = "amb@world_human_drug_dealer_hard@male@idle_b", anim = "idle_d", flags = 16 },
    {}, {}, function()
        ClearPedTasks(ped)
        TriggerServerEvent('cr-methrun:server:getMethPackage')
        LocalPlayer.state:set('textui', false, true)
        GoodsTaken = GoodsTaken + 1
        if GoodsTaken >= GoodsAmount then
            LocalPlayer.state:set('GettingPackage', false, true)
            LocalPlayer.state:set("HasGoods", true, true)
            SetEntityAsNoLongerNeeded(data.npc)
            RemoveBlip(goodsBlip)
            ClearPedTasks(ped)
            MethRunNotif(2, Lcl("notif_ReceivedAllGoods"), Lcl("notif_MethRunTitle"))
            StartCountdown()
        else
            MethRunNotif(2, Lcl("notif_ReceiveGoods"), Lcl("notif_MethRunTitle"))
        end
    end, function() ClearPedTasks(ped) LocalPlayer.state:set('textui', false, true) end)
end)

RegisterNetEvent('cr-methrun:client:CollectPayment', function()
    if not LocalPlayer.state.JobDone then MethRunNotif(3, Lcl("notif_NothingForYou"), Lcl("notif_MethRunTitle")) LocalPlayer.state:set('textui', false, true) return end
    MethRunNotif(1, Lcl("notif_EndRun"), Lcl("notif_MethRunTitle"))
    Wait(1500)
    TriggerServerEvent("cr-methrun:server:MethRunEnded")
    LocalPlayer.state:set('textui', false, true)
    ResetRun()
end)

RegisterNetEvent("cr-methrun:client:FindCar")
AddEventHandler("cr-methrun:client:FindCar", function()
    Wait(5000)
    local waitTime = math.random((Config.MinStartRunWait * 1000), (Config.MaxStartRunWait * 1000))
    MethRunNotif(2, Lcl("notif_StartRunInfoMessage"), Lcl("notif_MethRunTitle"))
    Wait(waitTime)
    MethRunVehiclePickUp()
end)

RegisterNetEvent('cr-methrun:client:StartRun')
AddEventHandler('cr-methrun:client:StartRun', function()
    QBCore.Functions.TriggerCallback('cr-methrun:server:CooldownCheck', function(result)
        if result then MethRunNotif(3, Lcl("notif_CooldownMessage"), Lcl("notif_MethRunTitle")) LocalPlayer.state:set('textui', false, true) return end
        QBCore.Functions.TriggerCallback('cr-methrun:server:GetCops', function(amount)
            if amount < Config.Police.CopsNeeded then MethRunNotif(3, Lcl("notif_NotEnoughCops"), Lcl("notif_MethRunTitle")) LocalPlayer.state:set('textui', false, true) return end
            local ped = PlayerPedId()
            QBCore.Functions.Progressbar('negociating', Lcl('progbar_Negotiate'), math.random(6500, 10000), true, true,
            { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, },
            { animDict = "amb@world_human_drug_dealer_hard@male@idle_b", anim = "idle_d", flags = 16 },
            {}, {}, function()
                TriggerServerEvent("cr-methrun:server:StartRun") ClearPedTasks(ped)
            end, function()
                LocalPlayer.state:set('textui', false, true) ClearPedTasks(ped)
            end)
        end)
    end)
end)

if Config.DevMode then
    RegisterCommand("testmethrun", function()
        TriggerEvent('cr-methrun:client:StartRun')
    end)
end

-- local function ActivateDepoGoodsTarget(veh)
--     exports['qb-target']:AddTargetEntity(veh, {
--         options = {
--             {
--                 type = "client",
--                 event = "cr-methrun:client:PlaceGoodsInTrunk",
--                 icon = "fas fa-car",
--                 label = "Place Package In Trunk",
--             },
--         },
--         distance = 3.0
--     })
-- end

-- RegisterNetEvent("cr-methrun:client:PlaceGoodsInTrunk", function()
--     local ped = PlayerPedId()
--     local pedCoords = GetEntityCoords(ped)
--     local TrunkPoint = GetOffsetFromEntityInWorldCoords(MethCar, 0.0, -4.0, 0.0)
--     local dist = #(pedCoords - vector3(TrunkPoint['x'], TrunkPoint['y'], TrunkPoint['z']))
--     if dist <= 2 then
--         TaskTurnPedToFaceEntity(ped, MethCar, 2000)
--         Wait(2000)
--         TriggerServerEvent("cr-methrun:server:RemoveMethPackage")
--         StartCountdown()
--     else
--         MethRunNotif(3, Lcl("TrunkTooFar"], Lcl("notif_MethRunTitle"])
--     end
-- end)