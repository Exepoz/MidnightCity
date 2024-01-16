local QBCore = exports['qb-core']:GetCoreObject()
local FilledBox = false
local LootBag, MoneyBag

local CanLoot = false
local TruckThermited = false
local TruckZoneBlip = nil
local Driver = nil
local CoPilot = nil
local TruckBlip = nil
local ThermiteProp = nil
local HacksLeft = 0
local oldTruckCoords = nil

---------------
-- Box Stuff --
---------------
exports['qb-target']:AddBoxZone("banktrucks_Box", vector3(240.6, 369.69, 105.74), 1, 1, { name="banktrucks_Box", heading = 335, debugPoly = false, minZ = 104.99, 105.79, },
{ options = { { event = "cr-armoredtrucks:client:depositlootbag", icon = "fas fa-box-open", label = "Suspicious Box" }, }, distance = 2 })

-- Main Menu
RegisterNetEvent('cr-armoredtrucks:client:depositlootbag', function()
    if FilledBox then QBCore.Functions.Notify('You already put something in there...', 'error') return end
    if not Config.Debug then
        local pData = QBCore.Functions.GetPlayerData()
        if pData.metadata['armtruckrep'] < Config.Reputation.DeliveryNeededForConvoy then QBCore.Functions.Notify('Just an empty box, nothing to see there...') return end
    end
    local l_txt, m_txt
    if LootBag then l_txt = "Already Selected" end
    --if MoneyBag then m_txt = "Already Selected" end
    local menu = {
        {header = "Deposit Box", isMenuHeader = true},
        {header = "Loot Bag", text = l_txt, icon = "lootbag", params = {event = 'cr-armoredtrucks:client:lootBagMenu'}},
       -- {header = "Dirty Money", text = m_txt, icon = "markedbills", params = {event = 'cr-armoredtrucks:client:moneyBagMenu'}},
        {header = "Deposit Loot", icon = "orderbox", params = {event = 'cr-armoredtrucks:client:depoStuff'}},
        {header = "Exit", icon = 'fas fa-sign-out-alt', params = {event = 'qb-menu:client:closeMenu'}}
    } exports['qb-menu']:openMenu(menu)
end)

-- -- Dirty Money Menu
-- RegisterNetEvent('cr-armoredtrucks:client:placedMoneyBag', function(data) MoneyBag = data TriggerEvent('cr-armoredtrucks:client:depositlootbag') end)
-- RegisterNetEvent('cr-armoredtrucks:client:moneyBagMenu', function()
--     --if MoneyBag then QBCore.Functions.Notify('You already put a loot bag in there...', 'error') TriggerEvent('cr-armoredtrucks:client:depositlootbag') return end
--     local pData = QBCore.Functions.GetPlayerData()
--     local menu = { {header = "Deposit Dirty Money", isMenuHeader = true} }
--     for _, v in pairs(pData.items) do if v.name == "markedbills" then menu[#menu+1] = {header = "Dirty Money", text = "$"..v.info.worth, icon = "markedbills", params = {event = 'cr-armoredtrucks:client:placedMoneyBag', args = {money = v.slot}}} end end
--     menu[#menu+1] = {header = "Back", icon = 'fas fa-sign-out-alt', params = {event = 'cr-armoredtrucks:client:depositlootbag'}}
--     exports['qb-menu']:openMenu(menu)
-- end)

-- Loot Bag Menu
RegisterNetEvent('cr-armoredtrucks:client:placedLootBag', function(data) LootBag = data TriggerEvent('cr-armoredtrucks:client:depositlootbag') end)
RegisterNetEvent('cr-armoredtrucks:client:lootBagMenu', function()
    --if LootBag then QBCore.Functions.Notify('You already put some money in there...', 'error') TriggerEvent('cr-armoredtrucks:client:depositlootbag') return end
    local pData = QBCore.Functions.GetPlayerData()
    local menu = {{header = "Deposit Loot Bag", isMenuHeader = true}}
    for _, v in pairs(pData.items) do if v.name == "lootbag" then menu[#menu+1] = {header = "Loot Bag", text = v.info.typeName, icon = "lootbag", params = {event = 'cr-armoredtrucks:client:placedLootBag', args = {bag = v.slot}}} end end
    menu[#menu+1] = {header = "Back", icon = 'fas fa-sign-out-alt', params = {event = 'cr-armoredtrucks:client:depositlootbag'}}
    exports['qb-menu']:openMenu(menu)
end)

-- Send Loot
RegisterNetEvent('cr-armoredtrucks:client:depoStuff', function()
    if LootBag then FilledBox = true end
    if not FilledBox then QBCore.Functions.Notify('There is nothing in the box...', 'error', 7500) return end
    TriggerServerEvent('cr-armoredtrucks:server:depoThatBag', LootBag)
end)

-- Email Button Event
RegisterNetEvent('cr-armoredtrucks:client:acceptConvoy', function() TriggerServerEvent('cr-armoredtrucks:server:AcceptTruck', true) end)
-- Get Box location when player receives Lvl2 Email.
RegisterNetEvent('cr-armoredtrucks:client:getConvoyDropOffLocation', function() SetNewWaypoint(240.47, 370.09) end)

-- Zone to spawn truck when nearby
RegisterNetEvent("ps-zones:enter", function(ZoneName, ZoneData)
    if ZoneName == 'Truck-Zone' then
        RemoveBlip(TruckZoneBlip)
        if Truck then return end
        QBCore.Functions.LoadModel("stockade4")
        Truck = CreateVehicle("stockade4", TruckLocation.x, TruckLocation.y, TruckLocation.z, TruckLocation[4], true, true)

        -- Get Truck Skin Depending on its type.
        local skin = GlobalState.TruckRoaming.Type
        SetVehicleLivery(Truck, skin.livery)
        SetVehicleColours(Truck, skin.colors.primary, skin.colors.secondary)
        SetVehicleInteriorColor(Truck, skin.colors.int)

        SetEntityAsMissionEntity(Truck)
        AddVehiclePhoneExplosiveDevice(Truck)

        TruckBlip = AddBlipForEntity(Truck)
        SetBlipSprite(TruckBlip, 67)
        SetBlipScale(TruckBlip, 0.75)
        SetBlipColour(TruckBlip, 2)
        SetBlipFlashes(TruckBlip, true)

        QBCore.Functions.LoadModel(Config.Roaming.PedModels)
        Driver = CreatePed(26, Config.Roaming.PedModels, TruckLocation.x, TruckLocation.y, TruckLocation.z, 268.9422, true, false)
        CoPilot = CreatePed(26, Config.Roaming.PedModels, TruckLocation.x, TruckLocation.y, TruckLocation.z, 268.9422, true, false)
        SetPedIntoVehicle(Driver, Truck, -1)
        SetPedIntoVehicle(CoPilot, Truck, 0)
        SetPedRelationshipGroupHash(CoPilot, `HATES_PLAYER`)
        GiveWeaponToPed(CoPilot, `WEAPON_SMG`, 250, false, true)
        SetPedSuffersCriticalHits(Driver, false)
        SetPedSuffersCriticalHits(CoPilot, false)
        TaskVehicleDriveWander(Driver, Truck, 70.0, 262144)
        exports["ps-zones"]:DestroyZone('Truck-Zone')
        LocalPlayer.state.ArmTruckHacksFailed = 0
        LocalPlayer.state.HackText = "Breaches Done : 0/"..skin.hacks.." | Failures : 0/3"
        HacksLeft = skin.hacks
        TruckHacking()
        local option = {header = "Breach Armored Truck\'s Security System", icon = "fas fa-bug", text = LocalPlayer.state.HackText, params = {event = 'cr-armoredtrucks:client:breachSecurity'}}
        exports["mdn-extras"]:AddSysBreacherOption('hack_armtruck', option)
        local FleecaTruckBones = {'seat_dside_r', 'seat_pside_r'}
        exports['qb-target']:AddTargetBone(FleecaTruckBones, {
            options = {
                { type = "client", icon = 'fas fa-bomb', label = 'Plant Explosives', event = 'cr-armoredtrucks:client:PlantThermite', canInteract = function(entity, distance, data) if entity == Truck and not TruckThermited and HacksLeft == 0 then return true end return false end},
                { type = "client", icon = 'fas fa-money-bill-1-wave', label = 'Grab Loot', event = 'cr-armoredtrucks:client:GrabLoot', canInteract = function(entity, distance, data) if entity == Truck and CanLoot then return true end return false end}
            }, distance = 1.5})
        TriggerServerEvent('cr-armoredtrucks:server:foundTruck')
    end
end)

RegisterNetEvent('cr-armoredtrucks:client:breachSecurity', function()
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    local tcoords = GetEntityCoords(Truck)
    local finished = false
    if not Truck or #(GetEntityCoords(Truck) - pcoords) > 25 then QBCore.Functions.Notify('The truck is not in range...') return end
    if oldTruckCoords then print(tcoords - oldTruckCoords) end
    if oldTruckCoords and #(tcoords - oldTruckCoords) < 10.0 then QBCore.Functions.Notify('The truck is too close from the last hacked location...') return end
    oldTruckCoords = tcoords
    QBCore.Functions.Progressbar('secbreach', 'Connecting to Vehicle Security', 5000, false, true,
    { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, },
    {}, {}, {}, function()
        local difficulty = 5
        --if Config.Debug then difficulty = 2 end
        local hacks = GlobalState.TruckRoaming.Type.hacks
        local success = exports['howdy-hackminigame']:Begin(difficulty, 5000)
        exports['mdn-extras']:RemoveSysBreacherOption('hack_armtruck')
        if success then
            HacksLeft = HacksLeft - 1
            LocalPlayer.state.HackText = "Beaches Done : "..(hacks-HacksLeft).."/"..hacks.." | Failures : "..LocalPlayer.state.ArmTruckHacksFailed.."/3"
            local option = {header = "Breach Armored Truck\'s Security System", icon = "fas fa-bug", disabled = true, text = LocalPlayer.state.HackText, params = {event = 'cr-armoredtrucks:client:breachSecurity'}}
            exports["mdn-extras"]:AddSysBreacherOption('hack_armtruck', option)
            if HacksLeft == 0 then
                finished = true
                QBCore.Functions.Notify('The Armored Truck\'s Security System is now disabled!')
                exports['mdn-extras']:RemoveSysBreacherOption('hack_armtruck')
            end
        else
            LocalPlayer.state.ArmTruckHacksFailed = LocalPlayer.state.ArmTruckHacksFailed + 1
            LocalPlayer.state.HackText = "Beaches Done : "..(hacks-HacksLeft).."/"..hacks.." | Failures : "..LocalPlayer.state.ArmTruckHacksFailed.."/3"
            local option = {header = "Breach Armored Truck\'s Security System", icon = "fas fa-bug", disabled = true, text = LocalPlayer.state.HackText, params = {event = 'cr-armoredtrucks:client:breachSecurity'}}
            exports["mdn-extras"]:AddSysBreacherOption('hack_armtruck', option)
            if LocalPlayer.state.ArmTruckHacksFailed >= 3 then
                finished = true
                QBCore.Functions.Notify('Your system breacher sudently turns off and is now rebooting...')
                exports['mdn-extras']:RemoveSysBreacherOption('hack_armtruck')
            end
        end
        if finished then return end
        Wait(30000)
        exports['mdn-extras']:RemoveSysBreacherOption('hack_armtruck')
        local option = {header = "Breach Armored Truck\'s Security System", icon = "fas fa-bug", text = LocalPlayer.state.HackText, params = {event = 'cr-armoredtrucks:client:breachSecurity'}}
        exports["mdn-extras"]:AddSysBreacherOption('hack_armtruck', option)
    end, function() end, 'uhackingdevice')
end)

function TruckHacking()
    CreateThread(function()
        while HacksLeft > 0 do
            if GetEntityHealth(Driver) <= 75 or GetEntityHealth(CoPilot) <= 75 then
                DetonateVehiclePhoneExplosiveDevice()
                ExplodeVehicle(Truck, true, false)
                RemoveBlip(TruckBlip)
                local FleecaTruckBones = {'seat_dside_r', 'seat_pside_r'}
                exports['qb-target']:RemoveTargetBone(FleecaTruckBones)
                QBCore.Functions.Notify('Your system breacher sudently turns off and is now rebooting...')
                exports['mdn-extras']:RemoveSysBreacherOption('hack_armtruck')
                return
            end
            Wait(3000)
        end
    end)
end

RegisterNetEvent('cr-armoredtrucks:client:GetTruckLocation', function ()
    TruckLocation = Config.Roaming.TruckLocations[math.random(#Config.Roaming.TruckLocations)]
    TruckZoneBlip = AddBlipForCoord(TruckLocation)
    SetBlipSprite(TruckZoneBlip, 67)
    SetBlipScale(TruckZoneBlip, 0.75)
    SetBlipColour(TruckZoneBlip, 2)
    SetBlipRoute(TruckZoneBlip, true)
    SetBlipRouteColour(TruckZoneBlip, 2)

    exports["ps-zones"]:CreateCircleZone("Truck-Zone", TruckLocation, 300.0, {
        debugPoly = false,
        minZ = TruckLocation.z - 1,
        maxZ = TruckLocation.z + 1,
    })
    Wait(10000) TriggerServerEvent('cr-armoredtrucks:server:HeistStarted', 'convoy')
end)

RegisterNetEvent('cr-armoredtrucks:client:PlantThermite', function ()
    if IsVehicleStopped(Truck) and not IsEntityInWater(Truck) then
        if QBCore.Functions.HasItem(Config.BombItem) then
            local ped = PlayerPedId()
            TruckThermited = true
            SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
            Wait(1500)
            RequestAnimDict('anim@heists@ornate_bank@thermal_charge_heels')
            while not HasAnimDictLoaded('anim@heists@ornate_bank@thermal_charge_heels') do Wait(50) end
            local x, y, z = table.unpack(GetEntityCoords(ped))
            ThermiteProp = CreateObject(GetHashKey('prop_c4_final_green'), x, y, z + 0.2, true, true, true)
            AttachEntityToEntity(ThermiteProp, ped, GetPedBoneIndex(ped, 60309), 0.06, 0.0, 0.06, 90.0,0.0, 0.0, true, true, false, true, 1, true)
            TaskPlayAnim(ped, 'anim@heists@ornate_bank@thermal_charge_heels', "thermal_charge", 3.0, -8,-1, 63, 0, 0, 0, 0)
            QBCore.Functions.Progressbar("search_body", "Setting Timer", 5000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                Dispatch()
                local diff = Config.Roaming.ThermiteHack
                exports['memorygame']:thermiteminigame(diff.CorrectBlocks, diff.IncorrectBlocks, diff.TimeToShow, diff.TimeToLose, function()
                    TruckThermited = true
                    TriggerServerEvent("cr-armoredtrucks:server:remThermite")
                    ClearPedTasks(ped)
                    DetachEntity(ThermiteProp)
                    AttachEntityToEntity(ThermiteProp, Truck, GetEntityBoneIndexByName(Truck, 'door_pside_r'), -0.7, 0.0,0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
                    QBCore.Functions.Notify("Wait for the the door to blow", 'primary', 3000)
                    Wait(Config.Roaming.BombTimer * 60000)
                    --Wait(10000)
                    CanLoot = true
                    local FleecaTruckCoords = GetEntityCoords(Truck)
                    SetVehicleDoorBroken(Truck, 2, false)
                    SetVehicleDoorBroken(Truck, 3, false)
                    AddExplosion(FleecaTruckCoords.x, FleecaTruckCoords.y, FleecaTruckCoords.z, 'EXPLOSION_TANKER', 2.0, true, false, 2.0)
                    ApplyForceToEntity(Truck, 0, FleecaTruckCoords.x, FleecaTruckCoords.y, FleecaTruckCoords.z, 0.0, 0.0, 0.0, 1, false,true, true, true, true)
                    SetVehicleUndriveable(Truck, true)
                    -- TriggerEvent('cr-armoredtrucks:client:SpawnBackGuardsDel')
                end, function()
                    TruckThermited = false
                    ClearPedTasks(ped)
                    QBCore.Functions.Notify("Failed to arm the explosive...", 'error')
                end)
            end, function() -- Cancel
                TruckThermited = false
                QBCore.Functions.Notify("Cancelled?", 'error')
                ClearPedTasks(ped)
            end, "fas fa-code")
        else
            NeedAccess2 = true
            QBCore.Functions.Notify("You need a low yield explosive to do this", 'error')
        end
    end
end)

RegisterNetEvent('cr-armoredtrucks:client:SpawnBackGuardsDel', function()
    local Guard = {}
    QBCore.Functions.LoadModel(Config.Roaming.PedModels)
    for i = 1, 2 do
        Guard[i] = CreatePedInsideVehicle(Truck, 5, Config.Roaming.PedModels, i, 1, 1)
        TaskLeaveVehicle(Guard[i], Truck, 0)
        SetEntityAsMissionEntity(Guard[i])
        SetEntityVisible(Guard[i], true)
        SetPedRelationshipGroupHash(Guard[i], `HATES_PLAYER`)
        SetPedAccuracy(Guard[i], Config.Roaming.Guards.Accuracy)
        SetPedArmour(Guard[i], Config.Roaming.Guards.Armor)
        SetPedMaxHealth(Guard[i], Config.Roaming.Guards.Health)
        SetPedCanSwitchWeapon(Guard[i], true)
        SetPedDropsWeaponsWhenDead(Guard[i], false)
        SetPedFleeAttributes(Guard[i], 0, false)
        GiveWeaponToPed(Guard[i], GetHashKey(Config.Roaming.Guards.Weapon), -1, false, true)
        SetPedSuffersCriticalHits(Guard[i], false)
        SetPedCanRagdoll(Guard[i], false)
    end
    SetVehicleDoorOpen(Truck, 3, false, true)
    SetVehicleDoorOpen(Truck, 4, false, true)
    --Search Bodies
    -- local options = {{event = "cr-armoredtrucks:client:searchBody", icon = "fas fa-hand", label = "Search Body",
    -- --canInteract = function(entity) if IsPedDeadOrDying(entity) and pData.metadata['armtruckrep'] >= Config.Reputation.XPNeededForKeys then return true else return false end end} --TODO
    -- canInteract = function(entity) if IsPedDeadOrDying(entity) then return true else return false end end}}
    -- exports['qb-target']:AddTargetEntity(Guard1, { options = options, distance = 2 })
    -- exports['qb-target']:AddTargetEntity(Guard2, { options = options, distance = 2 })
end)

RegisterNetEvent('cr-armoredtrucks:client:GrabLoot', function ()
    CanLoot = false
    SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
    ClearPedTasks(PlayerPedId())
    Wait(1500)
    QBCore.Functions.Progressbar("start_looting", 'Looting', 10000, false, true,
    { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
    { animDict = "anim@heists@ornate_bank@grab_cash_heels", anim = "grab", flags = 49},
    { model = "prop_cs_heist_bag_02", bone = 57005, coords = { x = -0.004, y = 0.00, z = -0.14 }, rotation = { x = 235.0, y = -25.0, z = 0.0 }},
    {}, function()
        CanLoot = false
        RemoveBlip(TruckBlip)
        TriggerServerEvent('cr-armoredtrucks:server:Payouts')
    end, function()
        CanLoot = true
        QBCore.Functions.Notify("Cancelled", 'error')
    end,"fas fa-boxes-stacked")
end)


