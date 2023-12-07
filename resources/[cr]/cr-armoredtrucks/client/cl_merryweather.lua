local QBCore = exports['qb-core']:GetCoreObject()
local payPhone, armTruck, phonePoint, ExoStarted
local keyset, guards, backGuards, MW_CanLoot, MW_Bombplanted = {}, {}, {}, false, false
Citizen.CreateThread(function() for k in pairs(Config.Merryweather.PhoneLocations) do keyset[#keyset+1] = k end end)
FinishExoSays = nil
--------------------
-- Computer Stuff --
--------------------

-- exports['qb-target']:AddBoxZone("stockadeLaptop", vector3(569.46, -3127.42, 18.77), 0.5, 0.5, {name="stockadeLaptop", heading=0, debugPoly=false, minZ=18, maxZ=18.7},
-- {options = {
--     {event = "cr-armoredtrucks:client:checkReq", icon = "fas fa-laptop", label = "Login", canInteract = function() return not GlobalState.StockadeState.MissionInProgress end},
--     {event = "malmo-goldentrail:client:checkReq", icon = "fas fa-laptop", label = "Gang Login", canInteract = function() return QBCore.Functions.GetPlayerData().gang and QBCore.Functions.GetPlayerData().gang.name ~= "none" end}
-- }, distance = 2.5})
-- RegisterNetEvent('cr-armoredtrucks:client:checkReq', function() TriggerServerEvent('cr-armoredtrucks:server:checkReq') end)

RegisterNetEvent('cr-armoredtrucks:client:TruckGuy', function(data)
    local menu = {}
    local options = {}
    if not data.order then
        options = {
            { title = '3QU1N0X', disabled = true,
                description = "Hey you\'re the guy who\'s good with trucks right? If you find some security contracts from one of the trucks you hit, I\'ll happily get it off your hands." },
            { title = 'You (Send Reply)', onSelect = function() end,
                description = "Hmm, Alright. I\'ll come back if I stumble upon that." },
            { title = 'You (Send Reply)', onSelect = function() end,
                description = "This sounds really fishy... fuck that." },
            { title = 'Disconnect', onSelect = function() end},
        }
    else
        options = {
            { title = '3QU1N0X', disabled = true, description = "Hey have you got that information I asked you about???" },
            { title = 'You (Send Reply)', event = 'cr-armoredtrucks:client:EnableFax', description = "Yeah, don\'t ask me how I got that." },
            { title = 'You (Send Reply)', onSelect = function() end, description =  "Nope. Totally not. I\'ll go now." },
            { title = 'Disconnect', onSelect = function() end},
        }
    end
    lib.registerContext({
        id = 'truckGuyChat',
        title = 'The Golden Tail\n\n_Chatrooms_',
        options = options
    }) lib.showContext('truckGuyChat')
end)

RegisterNetEvent('cr-armoredtrucks:client:EnableFax', function()
    lib.registerContext({
        id = 'truckGuyFax',
        title = 'The Golden Tail\n\n_Chatrooms_',
        options = {
            { title = '3QU1N0X', disabled = true, description = "Alright, fax me the contract using the machine over there. Send it to "..GlobalState.StockadeState.name.." at "..GlobalState.StockadeState.number.."."},
            { title = 'You (Send Reply)', onSelect = function() end, description =  "Uh yeah sure..." },
            { title = 'Disconnect', onSelect = function() end},
        }
    }) lib.showContext('truckGuyFax')
    local fax = GetClosestObjectOfType(562.84, -3126.84, 19.12, 1.0, 1785922871, 0, 0, 0)
    if not fax then return end Citizen.CreateThread(function() exports['qb-target']:AddTargetEntity(fax, { options = {{ type = "client", event = "cr-armoredtrucks:client:sendFax", icon = "fa-solid fa-printer", label = "Send Fax", canInteract = function() return not GlobalState.StockadeState.MissionInProgress end}}, distance = 2.0 }) end)
end) RegisterNetEvent('cr-armoredtrucks:client:sendFax', function() TriggerServerEvent('cr-armoredtrucks:server:receiveFax') end)

----------------
-- Phone Call --
----------------

local function PhoneAnswered(phone, win)
    if win then -- Exo Completed
        exports['qb-target']:RemoveZone('startPhone')
        phonePoint = lib.points.new(phone.PhoneCoords, 10.0)
        function phonePoint:onEnter() if payPhone then RemoveBlip(payPhone) end
            TriggerServerEvent('cr-armoredtrucks:server:MerryweatherSync', "removePhonePoint")
            Wait(math.random(10,20)*1000) --TODO
            TriggerServerEvent('cr-armoredtrucks:server:MerryweatherSync', "payphoneCall", phone)
        end
    end
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    local coords =  vector3(568.98, -3127.42, 18.77)
    if #(pcoords - coords) > 10 then return end
    exports['xsound']:Destroy('PhoneRinging')
end

RegisterNetEvent('cr-armoredtrucks:client:phoneCall', function(completed)
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    local coords =  vector3(568.98, -3127.42, 18.77)
    if #(pcoords - coords) > 10 then return end
    exports['xsound']:PlayUrlPos("PhoneRinging", './sounds/phoneringing.ogg', 0.8, coords)
    Wait(1000) if not completed then QBCore.Functions.Notify('Maybe you should answer that?', 'info', 5000) end
    exports['qb-target']:AddBoxZone("startPhone", coords, 0.5, 0.5, { name="startPhone", heading=0, debugPoly=true, minZ=18, maxZ=18.7 }, { options = {
        {event = "cr-armoredtrucks:answerStartPhone", icon = "fas fa-phone", label = "Answer Phone", canInteract = function () if ExoStarted or GlobalState.StockadeState.ExoCompleted then return false end return true end},
        {event = "cr-armoredtrucks:client:ExoCompleted", icon = "fas fa-phone", label = "Answer Phone", canInteract = function () return GlobalState.StockadeState.ExoCompleted end}
    }, distance = 2.5 })
end)

--------------
-- Exo Says --
--------------

-- Answering Phone and start minigame
RegisterNetEvent('cr-armoredtrucks:answerStartPhone', function()
    QBCore.Functions.Notify("I wanna play a game hehe... Exo Says!", 'success', 3000)
    TriggerServerEvent('cr-armoredtrucks:server:MerryweatherSync', 'officePhoneAnswered', phone)
    Wait(3000)
    TriggerServerEvent('cr-armoredtrucks:server:PlayExoSays')
end)

-- function to show the lights / colors
local function ShowColors()
    CreateThread(function()
        while true do
            if FinishExoSays then break end
            if GlobalState.ExoSays then DrawLightWithRange(GlobalState.ExoSays.coords.xyz, GlobalState.ExoSays.r, GlobalState.ExoSays.g, GlobalState.ExoSays.b, 5.0, 3.0) end
            Wait(1)
        end
    end)
end

-- Minigame Initiating
RegisterNetEvent('cr-armoredtrucks:client:InitiateExoSays', function()
    if #(GetEntityCoords(PlayerPedId()) - vector3(570.16, -3126.8, 18.77)) > 15 then return end
    local red, blue, green, yellow = false, false, false, false
    local b
    CreateThread(function()
        while true do
            if b then break end
            if blue then DrawLightWithRange(vector3(570.63, -3127.94, 18.73), 0, 0, 255, 5.0, 3.0) end
            if green then DrawLightWithRange(vector3(570.2, -3127.97, 18.73), 0, 255, 0, 5.0, 3.0) end
            if red then DrawLightWithRange(vector3(569.78, -3127.97, 18.73), 255, 0, 0, 5.0, 3.0) end
            if yellow then DrawLightWithRange(vector3(569.36, -3127.96, 18.73), 255, 255, 0, 5.0, 3.0) end
            Wait(1)
        end
    end)
    blue = true
    Wait(650) blue, green = false, true
    Wait(650) green, red = false, true
    Wait(650) red, yellow = false, true
    Wait(650) yellow = false

    Wait(150) blue, green = false, true
    Wait(150) green, red = false, true
    Wait(150) red, yellow = false, true
    Wait(150) yellow, red = false, true
    Wait(150) red, green = false, true
    Wait(150) green, blue = false, true
    Wait(150) blue = false

    Wait(500) blue, green, red, yellow = true, true, true, true
    Wait(1500) blue, green, red, yellow = false, false, false, false
    b = true
    ShowColors()
end)

-- Player Input after colors are showned
RegisterNetEvent('cr-armoredtrucks:client:GetPlayerInput', function(length)
    local input_sequence = {}
    for i = 1, length do
        local input = lib.inputDialog('Exo Says', {{type = 'select', label = 'Color '..i, options = {{value = 'blue', label = 'Blue'},{value = 'green', label = 'Green'},{value = 'red', label = 'Red'},{value = 'yellow', label = 'Yellow'}}, required = true}})
        if not input then return end
        table.insert(input_sequence, {color = input[1]})
    end
    if not input_sequence then return end
    TriggerServerEvent('cr-armoredtrucks:server:RecPlayerInput', input_sequence)
end)

-- Player Input is correct
RegisterNetEvent('cr-armoredtrucks:client:ShowRoundSuccess', function()
    if #(GetEntityCoords(PlayerPedId()) - vector3(570.16, -3126.8, 18.77)) > 15 then return end
    local b
    CreateThread(function()
        while true do
            if b then break end
            DrawLightWithRange(vector3(570.63, -3127.94, 18.73), 0, 255, 0, 5.0, 3.0)
            DrawLightWithRange(vector3(570.2, -3127.97, 18.73), 0, 255, 0, 5.0, 3.0)
            DrawLightWithRange(vector3(569.78, -3127.97, 18.73), 0, 255, 0, 5.0, 3.0)
            DrawLightWithRange(vector3(569.36, -3127.96, 18.73), 0, 255, 0, 5.0, 3.0)
            Wait(1)
        end
    end)
    Wait(2000) b = true
end)

-- Player Input is incorrect
RegisterNetEvent('cr-armoredtrucks:client:ShowGameOver', function()
    if #(GetEntityCoords(PlayerPedId()) - vector3(570.16, -3126.8, 18.77)) > 15 then return end
    local show, b = true, nil
    CreateThread(function()
        while true do
            if show then
                if b then break end
                DrawLightWithRange(vector3(570.63, -3127.94, 18.73), 255, 0, 0, 5.0, 3.0)
                DrawLightWithRange(vector3(570.2, -3127.97, 18.73), 255, 0, 0, 5.0, 3.0)
                DrawLightWithRange(vector3(569.78, -3127.97, 18.73), 255, 0, 0, 5.0, 3.0)
                DrawLightWithRange(vector3(569.36, -3127.96, 18.73), 255, 0, 0, 5.0, 3.0)
            end
            Wait(1)
        end
    end)
    Wait(250) show = false
    Wait(250) show = true
    Wait(250) show = false
    Wait(250) show = true
    Wait(250) show = false
    b = true
end)

-- Player Wins the game
RegisterNetEvent('cr-armoredtrucks:client:ShowGameWin', function()
    if #(GetEntityCoords(PlayerPedId()) - vector3(570.16, -3126.8, 18.77)) > 15 then return end
    local show = true
    local b
    CreateThread(function()
        while true do
            if b then break end
            if show then
                DrawLightWithRange(vector3(570.63, -3127.94, 18.73), 0, 255, 0, 5.0, 3.0)
                DrawLightWithRange(vector3(570.2, -3127.97, 18.73), 0, 255, 0, 5.0, 3.0)
                DrawLightWithRange(vector3(569.78, -3127.97, 18.73), 0, 255, 0, 5.0, 3.0)
                DrawLightWithRange(vector3(569.36, -3127.96, 18.73), 0, 255, 0, 5.0, 3.0)
            end
            Wait(1)
        end
    end)
    Wait(250) show = false
    Wait(250) show = true
    Wait(250) show = false
    Wait(250) show = true
    Wait(250) show = false
    Wait(250) show = true
    Wait(250) show = false
    Wait(250) show = true
    Wait(250) show = false
    b = true
    FinishExoSays = true
end)

-- Completed Game & Player Answered the phone call
RegisterNetEvent('cr-armoredtrucks:client:ExoCompleted', function()
    local phone = Config.Merryweather.PhoneLocations[keyset[math.random(#keyset)]]
    ClearAllBlipRoutes()
    TriggerServerEvent('cr-armoredtrucks:server:MerryweatherSync', 'officePhoneAnswered2', phone)
    QBCore.Functions.Notify("Alright you win. I\'ll let you in on a Merryweather truck I have been tracking. Head to this location and wait for a phone call. Meanwhile I\'ll work my magic and arrange to intercept the truck.", 'success', 10000)
    payPhone = AddBlipForCoord(phone.PhoneCoords)
    SetBlipRoute(payPhone,true)
end)

--------------
-- Payphone --
--------------
RegisterNetEvent('cr-armoredtrucks:client:giveName', function(data)
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    if data.name ~= GlobalState.StockadeState.name then QBCore.Functions.Notify("Wrong.", 'error') Wait(1000) AddOwnedExplosion(ped, pcoords, 2, 10.0, true, false, 1.0) return end
    QBCore.Functions.Notify("From?", 'info', 5000)
    local keyboard = exports["qb-input"]:ShowInput({ header = "Phonecall", submitText = "Answer.", inputs = {{type = 'number', isRequired = true, name = 'from', text = "From?"}}})
    if not keyboard or tonumber(keyboard.from) ~= GlobalState.StockadeState.number then QBCore.Functions.Notify("Wrong.", 'error') Wait(1000) AddOwnedExplosion(ped, pcoords, 2, 10.0, true, false, 1.0) return end
    Wait(1000) QBCore.Functions.Notify("Alright, it\'s you. I needed to make sure. ")
    Wait(1000) QBCore.Functions.Notify("I have modified the GPS of a truck currently doing a delivery. They should divert near your location. Keep your eyes open, I\'m not sure when it\'s gonna pass by.")
    Wait((math.random(Config.Merryweather.TimeToSpawn.min,Config.Merryweather.TimeToSpawn.max) * 60000)) --TODO
    TriggerServerEvent('cr-armoredtrucks:server:nameGiven', data.phone)
end)

RegisterNetEvent('cr-armoredtrucks:payphoneCall', function(data)
    TriggerServerEvent('cr-armoredtrucks:server:MerryweatherSync', "answerPayphone")
    QBCore.Functions.Notify("Who sent you?", 'info', 5000) Wait(2000)
    local ranE, ranName = math.random(5), math.random(5)
    while ranName == ranE do ranName = math.random(5) if ranName ~= ranE then break end end
    local menu, names = {}, {}
    --print(GlobalState.StockadeState.name, GlobalState.StockadeState.number) --TODO
    for i = 1, 5 do
        local name = ""
        if i == ranE then name = "Equinox"
        elseif i == ranName then name = GlobalState.StockadeState.name
        else name = Config.Merryweather.Names[math.random(#Config.Merryweather.Names)]
            while name == GlobalState.StockadeState.name or names[name] == true do
                name = Config.Merryweather.Names[math.random(#Config.Merryweather.Names)]
                if name ~= GlobalState.StockadeState.name or not names[name] then break end
            end
        end
        names[name] = true
        menu[#menu+1] = { header = name, icon = 'fa-solid fa-comments', params = { event = 'cr-armoredtrucks:client:giveName', args = {name = name, phone = data.phone}}}
    end
    menu[#menu+1] = { header = "Hang Up.", icon = 'fa-solid fa-phone-slash', params = { event = 'cr-armoredtrucks:client:giveName', args = {name = "hangup", phone = data.phone}}}
    exports['qb-menu']:openMenu(menu)
end)

local function PayphoneCall(phone)
    exports['xsound']:PlayUrlPos("Payphone", './sounds/payphone.ogg', 0.8, phone.PhoneCoords)
    exports['qb-target']:AddBoxZone("payPhone", phone.PhoneCoords, 0.5, 0.5, { name="payPhone", heading=phone.Heading, debugPoly=false, minZ=phone.MinZ, maxZ=phone.MinZ+1.3},
    { options = { { event = "cr-armoredtrucks:payphoneCall", icon = "fas fa-phone", label = "Answer Phone", phone = phone }, }, distance = 2.5 })
end

------------------
-- Truck Spawn  --
------------------

-- Door Targets
local function CreateMwTarget()
    local FleecaTruckBones = {'seat_dside_r', 'seat_pside_r'}
    exports['qb-target']:AddTargetBone(FleecaTruckBones, {
        options = {
            {type = "client", icon = 'fas fa-bomb', label = 'Plant Thermite', event = "cr-armoredtrucks:client:checkIfExplosive", canInteract = function(entity) if entity == armTruck and not MW_Bombplanted then return true end return false end },
            {type = "client", icon = 'fas fa-money-bill-1-wave', label = 'Grab Loot', event = 'cr-armoredtrucks:client:lootTruck', canInteract = function(entity) if entity == armTruck and MW_CanLoot then return true end return false end}
        }, distance = 1.
    })
end

--Get close to payphone, then wander + driver health check
local function GoCloseToPoint(phone)
    Citizen.CreateThread(function()
        while true do
            local dst = #(GetEntityCoords(armTruck) - phone.Destination)
            if dst <= 5 then TaskVehicleDriveWander(guards[1], armTruck, 10.0, 8388614) end
            local health = GetEntityHealth(guards[1])
            if health < 110 then TriggerServerEvent('cr-armoredtrucks:server:MerryweatherSync', 'driverIsDead') break end
            Wait(2000)
        end
    end)
end

-- Guards Configuation
local function guardStuff()
    G = Config.Merryweather.Guards
    for _, v in pairs(guards) do
        SetPedFleeAttributes(v, 0, 0)
        GiveWeaponToPed(v, G.Weapon[math.random(#G.Weapon)], -1, false, true)
        SetPedArmour(v, G.Armor)
        SetPedMaxHealth(v, G.Health)
        SetPedAccuracy(v, G.Accuracy)
        SetPedCombatAttributes(v, 46, 1)
        SetPedCombatAbility(v, 100)
        SetPedCombatMovement(v, math.random(2))
        SetPedCombatRange(v, math.random(2))
        SetPedKeepTask(v, true)
        SetPedAsCop(v, true)
        SetPedDropsWeaponsWhenDead(v, false)
        SetPedRelationshipGroupHash(v, `HATES_PLAYER`)
        SetPedSuffersCriticalHits(v, false)
    end
end

-- Spawns the truck
RegisterNetEvent('cr-armoredtrucks:client:makeTruck',function(phone)
    if not GlobalState.StockadeState.nameGiven then return end
    local hash, pedHash = "stockade4", Config.Merryweather.Guards.Model
    LoadModel(hash) LoadModel(pedHash)
    QBCore.Functions.SpawnVehicle(hash, function(vehicle)
        if phone.SpawnCoords.r then SetEntityHeading(armTruck, phone.SpawnCoords.r) else SetEntityHeading(armTruck, 100.0) end
        armTruck = vehicle
        local spawnCoords = GetEntityCoords(armTruck)
        SetVehicleOnGroundProperly(armTruck)
        SetDisableVehicleWindowCollisions(armTruck, false)
        SetVehicleLivery(armTruck, 11)
        SetVehicleColours(armTruck, 1, 1)
        SetVehicleInteriorColor(armTruck, 3)
        SetVehicleTyresCanBurst(armTruck, false)
        Wait(100)
        for i = 1, 2 do
            guards[i] = CreatePed(28, pedHash, spawnCoords.x+2, spawnCoords.y+2, spawnCoords.z, 0, true, false)
            SetEntityAsMissionEntity(guards[i], true, true)
        end
        if guards[1] == 0 then
            QBCore.Functions.DeleteVehicle(armTruck)
            TriggerEvent('cr-armoredtrucks:client:makeTruck', phone)
            return
        end
        Wait(400) for k, v in pairs(guards) do TaskWarpPedIntoVehicle(v, armTruck, k-2) end
        Wait(1000) TaskVehicleDriveToCoord(guards[1], armTruck, phone.Destination, 10.0, false, hash, 262144, 2.0, 0) --262144 --8388614
        local netID = NetworkGetNetworkIdFromEntity(armTruck)
        TriggerServerEvent('cr-armoredtrucks:server:MerryweatherSync', 'truckSpawn', netID)
        guardStuff() GoCloseToPoint(phone)
    end, phone.SpawnCoords.xyz)
    exports['ps-dispatch']:MerryWeatherTruckSpotted(armTruck)
    SetModelAsNoLongerNeeded(pedHash)
    SetModelAsNoLongerNeeded(model)
end)


-------------------------
-- Explosion & Looting --
-------------------------

function MW_TruckExpl()
    local g = Config.Merryweather.Guards
    for i = 1, 2 do
        backGuards[i] = CreatePedInsideVehicle(armTruck, 5, 's_m_y_blackops_01', i, 1, 1)
        TaskLeaveVehicle(backGuards[i], armTruck, 0)
        SetEntityAsMissionEntity(backGuards[i])
        SetEntityVisible(backGuards[i], true)
        SetPedRelationshipGroupHash(backGuards[i], `HATES_PLAYER`)
        SetPedAccuracy(backGuards[i], g.Accuracy)
        SetPedArmour(backGuards[i], g.Armor)
        SetPedMaxHealth(backGuards[i], g.Health)
        SetPedCanSwitchWeapon(backGuards[i], true)
        SetPedDropsWeaponsWhenDead(backGuards[i], false)
        SetPedFleeAttributes(backGuards[i], 0, false)
        local weapon = g.Weapon[math.random(#g.Weapon)]
        GiveWeaponToPed(backGuards[i], weapon, -1, false, true)
        SetPedSuffersCriticalHits(backGuards[i], false)
        SetPedCanRagdoll(backGuards[i], false)
        SetVehicleDoorOpen(armTruck, i+2, false, true)
    end
    TriggerServerEvent('cr-armoredtrucks:server:MerryweatherSync', 'truckExpl')
end

RegisterNetEvent('cr-armoredtrucks:client:openBack', function()
    if IsVehicleStopped(armTruck) then
        local t = Config.Merryweather.ThermiteHack
        exports['memorygame']:thermiteminigame(t.CorrectBlocks, t.IncorrectBlocks, t.TimeToShow, t.TimeToLose,
        function()
            TriggerServerEvent('cr-armoredtrucks:server:MerryweatherSync', 'backDoorHackDone')
            exports['ps-dispatch']:MerryWeatherTruckExpl()
            SetVehicleDoorsShut(armTruck,true)
            local dict = 'anim@heists@ornate_bank@thermal_charge_heels'
            LoadAnimDict(dict)
            local ped = PlayerPedId()
            local x,y,z = table.unpack(GetEntityCoords(ped))
            local hash = "prop_c4_final"
            local c4 = CreateObject(hash, x, y, z+0.2,  true,  true, true)
            AttachEntityToEntity(c4, ped, GetPedBoneIndex(ped, 60309), 0.06, 0.0, 0.06, 90.0, 0.0, 0.0, true, true, false, true, 1, true)
            Citizen.Wait(700) FreezeEntityPosition(ped, true)
            TaskPlayAnim(ped, 'anim@heists@ornate_bank@thermal_charge_heels', "thermal_charge", 3.0, -8, -1, 63, 0, 0, 0, 0 )
            Citizen.Wait(5500) ClearPedTasks(ped) DetachEntity(c4)
            AttachEntityToEntity(c4, armTruck, GetEntityBoneIndexByName(armTruck, 'door_pside_r'), -0.7, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
            FreezeEntityPosition(ped, false) QBCore.Functions.Notify('Explosive armed! Take cover!')
            Citizen.Wait(60000)
            --Citizen.Wait(10000) --TODO
            SetVehicleDoorBroken(armTruck, 2, false)
            SetVehicleDoorBroken(armTruck, 3, false)
            local TruckPos = GetEntityCoords(armTruck)
            AddExplosion(TruckPos.x,TruckPos.y,TruckPos.z, 2, 10.0, true, false, 1.0)
            ApplyForceToEntity(armTruck, 0, TruckPos.x,TruckPos.y,TruckPos.z, 0.0, 0.0, 0.0, 0.02, false, true, true, true, true)
            TruckIsExploded = true
            DeleteEntity(c4)
            MW_TruckExpl()
        end,
        function() QBCore.Functions.Notify('You failed to arm the explosive...') end)
    end
end)

RegisterNetEvent('cr-armoredtrucks:client:lootTruck', function()
    if not MW_CanLoot then QBCore.Functions.Notify('Truck already looted', 'error') return end
    TriggerServerEvent('cr-armoredtrucks:server:MerryweatherSync', 'lootingTruck')
    local dict = 'anim@heists@ornate_bank@grab_cash_heels'
    LoadAnimDict(dict)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local moneyBag = CreateObject("prop_cs_heist_bag_02", pos.x, pos.y,pos.z, true, true, true)
    AttachEntityToEntity(moneyBag, ped, GetPedBoneIndex(ped, 57005), 0.0, 0.0, -0.16, 250.0, -30.0, 0.0, false, false, false, false, 2, true)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@grab_cash_heels", "grab", 8.0, -8.0, -1, 1, 0, false, false, false)
    FreezeEntityPosition(ped, true)
    QBCore.Functions.Notify('Looting truck...')
    Citizen.Wait(25000) DeleteEntity(moneyBag)
    ClearPedTasks(ped) FreezeEntityPosition(ped, false)
    TriggerServerEvent('cr-armoredtrucks:server:MerryweatherPayout')
end)

RegisterNetEvent('cr-armoredtrucks:client:checkIfExplosive', function() TriggerServerEvent('cr-armoredtrucks:server:checkExplosives') end)






-----------
-- Sync --
-----------

local MerryweatherSync = {
    ['InitiateExoSays'] = function() ExoStarted = true InitiateExoSays() end,
    ['GameOver'] = function() GameOver() end,
    ['RoundWon'] = function() RoundWon() end,
    ['ExoSuccess'] = function() ExoSuccess() end,

    ['answerPayphone'] = function() exports['qb-target']:RemoveZone('payPhone') exports['xsound']:Destroy('Payphone') end,
    ['payphoneCall'] = function(phone) PayphoneCall(phone) end,
    ['removePhonePoint'] = function() phonePoint:remove() end,
    ['officePhoneAnswered'] = function(phone) PhoneAnswered(phone) end,
    ['officePhoneAnswered2'] = function(phone) PhoneAnswered(phone, true) end,
    ['truckExpl'] = function() local stockade = {'stockade4'} exports['qb-target']:RemoveZone(stockade) Wait(1000) MW_CanLoot = true end,
    ['truckSpawn'] = function(netID) armTruck = NetworkGetEntityFromNetworkId(netID) end,
    ['driverIsDead'] = function() CreateMwTarget() end,
    ['backDoorHackDone'] = function() MW_Bombplanted = true end,
    ['ExoSays'] = function() ShowColors() end,
    ['lootingTruck'] = function() MW_CanLoot = false  end,
    ['reset'] = function() ExoStarted, payPhone, armTruck, phonePoint, guards, backGuards, MW_CanLoot, MW_Bombplanted = false, nil, nil, nil, {}, {}, false, false end
}

RegisterNetEvent('cr-armoredtrucks:client:MerryweatherSync', function(sync, ...)
    --print(sync, ...)
    MerryweatherSync[sync](...)
end)

function print_table(node)
    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)

    print(output_str)
end


