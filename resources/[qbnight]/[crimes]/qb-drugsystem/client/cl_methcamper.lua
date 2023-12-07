if not Shared.Enable.Methcamper then return end

local sentMessage = false
local IsBlurred = false
local fumesEffect = false
SetTimecycleModifier("")
SetTransitionTimecycleModifier("")

MethLabs, MethLabsData, CurrentMethLab, IsInsideMethLab = {}, {}, nil, false
MinigameActive = false
local sparkHydro, sparkProd = false, false

local minTemp = 320 -- Outside these values, the van will explode, make sure the optimal value in sv_methcamper is between these two values
local maxTemp = 540

AddEventHandler('onResourceStart', function(resource)
	if (GetCurrentResourceName() ~= resource) then return end
	Wait(1000)

	-- Fetching Labs
	local p2 = promise.new()
	QBCore.Functions.TriggerCallback('qb-drugsystem:server:getLabTables', function(LabTable) p2:resolve(LabTable) end)
	MethLabsData = Citizen.Await(p2)

	isSpawned = true
end)


RegisterNetEvent("QBCore:Client:OnPlayerLoaded" , function()
    Wait(2000)
	-- -- Fetching Labs
	local p2 = promise.new()
	QBCore.Functions.TriggerCallback('qb-drugsystem:server:getLabTables', function(LabTable) p2:resolve(LabTable) end)
	MethLabsData = Citizen.Await(p2)

	isSpawned = true
	Wait(2000) CheckInsideMethLab()
end)

-- Meth Van Ptfx
RegisterNetEvent('qb-drugsystem:client:ptfx', function(coords)
    CreateThread(function()
        SetPtfxAssetNextCall('core') --exp_grd_bzgas_smoke
        local smoke = StartParticleFxLoopedAtCoord('exp_grd_flare', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
        SetParticleFxLoopedAlpha(smoke, 0.8)
        SetParticleFxLoopedColour(smoke, 0.0, 0.0, 0.0, 0)
        Wait(420000)
        StopParticleFxLooped(smoke, 0)
    end)
end)

RegisterNetEvent('qb-drugsystem:client:updateLabsData', function(data) MethLabsData = data end)


--- Functions

-- Spawns the van used to cook low quality meth in
RegisterNetEvent('qb-drugsystem:client:spawnVehicle', function()
    QBCore.Functions.TriggerCallback('qb-drugsystem:server:JourneyRenting', function(paid)
       if not paid then QBCore.Functions.Notify('You don\'t have enough money!', 'error', 2500) return end
        QBCore.Functions.SpawnVehicle('journey', function(veh)
            DoScreenFadeOut(250)
            Wait(250)
            SetEntityHeading(veh, Shared.MethcamperSpawn.w)
            Entity(veh).state.CanCookMeth = true
            TriggerEvent('vehiclekeys:client:SetOwner', GetVehicleNumberPlateText(veh))
            Wait(250)
            DoScreenFadeIn(250)
            exports['cdn-fuel']:SetFuel(veh, 50.0)
            SetVehicleEngineOn(veh, true, true)
            isProducing = false
        end, Shared.MethcamperSpawn.xyz, true, true)
    end)
end)

--- Sends Chemical Smell alert to all police
--- @return nil
local sendPoliceAlert = function(isExplosion)
    if GetResourceState('ps-dispatch') ~= 'started' then return end
    local pedCoords = GetEntityCoords(PlayerPedId())
    if isExplosion then
        exports['ps-dispatch']:CustomAlert({
            coords = pedCoords,
            message = _U('methcamper_copalert_explosion'),
            dispatchCode = _U('methcamper_copalert_explosion_1Ocode') .. _U('methcamper_copalert_explosion'),
            description = _U('methcamper_copalert_explosion'),
            radius = 50,
            sprite = 380,
            color = 1,
            scale = 1.5,
            length = 2,
        })
    else
        exports['ps-dispatch']:CustomAlert({
            coords = pedCoords,
            message = _U('methcamper_copalert_chemical'),
            dispatchCode = _U('methcamper_copalert_chemical_1Ocode') .. _U('methcamper_copalert_chemical'),
            description = _U('methcamper_copalert_chemical'),
            radius = 50,
            sprite = 205,
            color = 1,
            scale = 1.5,
            length = 2,
        })
    end
end

local IsInsideNoGoZone = false
local NoGoZones = {
    {coords = vector3(1690.34, 2603.54, 45.57), radius = 300.0},
    {coords = vector3(1079.49, 2687.85, 38.94), radius = 200.0},
    {coords = vector3(360.16, 2676.63, 46.77), radius = 300.0},
    {coords = vector3(1889.6, 3839.02, 32.44), radius = 300.0},
    {coords = vector3(1513.74, 3629.81, 34.83), radius = 300.0},
    {coords = vector3(1809.7, 4823.99, 42.54), radius = 400.0},
    {coords = vector3(-74.06, 6457.02, 31.41), radius = 400.0},
    {coords = vector3(-301.49, 6232.87, 31.45), radius = 400.0},
    {coords = vector3(-2099.73, 3064.97, 32.81), radius = 900.0},
    {coords = vector3(3529.23, 3727.55, 36.45), radius = 200.0},
    {coords = vector3(2933.2, 2823.54, 48.04), radius = 400.0},
    {coords = vector3(-925.95, -1676.97, 6.55), radius = 3250.0},
}
Citizen.CreateThread(function()
    for k, v in pairs(NoGoZones) do
        local p = lib.points.new(v.coords, v.radius)
        function p:onEnter() IsInsideNoGoZone = true end
        function p:onExit() if self.isClosest then IsInsideNoGoZone = false end end
        NoGoZones[k].point = p

        -- NoGoZones[k].Blip = AddBlipForRadius(v.coords, v.radius)
        -- SetBlipColour( NoGoZones[k].Blip, 47)
        -- SetBlipAlpha( NoGoZones[k].Blip, 128)
    end
end)

--- Function to check if player is wearing a gas mask or not
---@return boolean - Is the player wearing a gas mask?
function IsWearingGasMask()
    local index = GetPedDrawableVariation(PlayerPedId(), 1)
    local model = GetEntityModel(PlayerPedId())
    local retval = false

    if model == 'mp_m_freemode_01' then
        if Shared.MaleGasMasks[index] ~= nil and Shared.MaleGasMasks[index] then
            retval = true
        end
    else
        if Shared.FemaleGasMasks[index] ~= nil and Shared.FemaleGasMasks[index] then
            retval = true
        end
    end
    return retval
end

local EventList = {
    [1] = function()
        print("Leaking Event")
        QBCore.Functions.Notify('The hose is leaking!', 'error')
        Wait(3000) if QBCore.Functions.HasItem('ducttape', 1) then
            QBCore.Functions.Notify('You quickly fix it with duct tape!', 'success')
            TriggerServerEvent('qb-drugsystem:server:remItem', 'ducttape')
        else TriggerServerEvent('qb-drugsystem:server:modCook', 'purity', -5) end
    end,
    [2] = function()
        print("Beaker Event")
        QBCore.Functions.Notify('You dropped a beaker...', 'error')
        TriggerServerEvent('qb-drugsystem:server:beakerBreak')
        TriggerServerEvent('qb-drugsystem:server:modCook', 'amount', -3)
    end,
    [3] = function()
        print("Gas Event")
        QBCore.Functions.Notify('There\'s a bit too much gas here...', 'error')
        Wait(3000) if not IsWearingGasMask() then
            IsBlurred = true
            --Drug_deadman
            --Drug_deadman_blend
            --FixerShortTrip_Distort
            --MP_Arena_theme_storm
            SetTimecycleModifier("DRUG_gas_huffin")
            QBCore.Functions.Notify('You feel Dizzy...', 'error')
        else QBCore.Functions.Notify('Your Gas Mask protects you from the gases...', 'error')
        end
    end,
    [4] = function()
        print("Chemical Spill Event")
        QBCore.Functions.Notify('You spill some chemicals!', 'error')
        TriggerServerEvent('qb-drugsystem:server:modCook', 'purity', -2)
        TriggerServerEvent('qb-drugsystem:server:modCook', 'amount', -1)
        Wait(3000) if QBCore.Functions.HasItem('cleaningkit', 1) then
            QBCore.Functions.Notify('You wipe off the spillage.', 'success')
            TriggerServerEvent('qb-drugsystem:server:remItem', 'cleaningkit')
        else TriggerServerEvent('hud:server:GainStress', 15) end
    end,
    [5] = function()
        print("Pseudo Event")
        if QBCore.Functions.HasItem('pseudoephedrine', 1) then
            QBCore.Functions.Notify('You accidentally used too much pseudoephedrine!', 'info')
            TriggerServerEvent('qb-drugsystem:server:remItem', 'pseudoephedrine', true)
            TriggerServerEvent('qb-drugsystem:server:modCook', 'purity', -5)
            TriggerServerEvent('qb-drugsystem:server:modCook', 'amount', 3)
        else
            QBCore.Functions.Notify('You didnt have enough pseudoephedrine for the last batch...', 'error')
            TriggerServerEvent('qb-drugsystem:server:modCook', 'amount', -3)
        end
    end,
    [6] = function()
        print("Tripping Event")
        QBCore.Functions.Notify('You trip while transporting the chemicals!', 'error')
        Wait(500)
        local success = lib.skillCheck({'easy'}, {'a','s','d','f','g','h','j','k','l'})
        if not success then QBCore.Functions.Notify('You dropped a good amount of meth on the floor...', 'error')
            TriggerServerEvent('qb-drugsystem:server:modCook', 'amount', -10)
        else QBCore.Functions.Notify('You catch yourself just in time!', 'success') end
    end,
    [7] = function()
        print("Fuse Event")
        QBCore.Functions.Notify('You notice a fuse has blown!', 'error') Wait(3000)
        if QBCore.Functions.HasItem('fuse', 1) then
            QBCore.Functions.Notify('You use a fuse to fix it.', 'success')
            -- Add removing fuse item.
        else
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            SetVehicleEngineHealth(veh, 0.0)
            Entity(veh).state.CanCookMeth = false
            QBCore.Functions.Notify('The vehicle\'s battery blows!', 'false')
        end
    end,
    [8] = function()
        print("Thirst Event")
        QBCore.Functions.Notify('You\'re getting thirsty...', 'info') Wait(3000)
        if QBCore.Functions.HasItem('watter_bottle', 1) then
            TriggerServerEvent('qb-drugsystem:server:remItem', 'watter_bottle')
            QBCore.Functions.Notify('You drink some water!', 'success')
        else
            TriggerServerEvent('qb-drugsystem:server:modCook', 'purity', -2)
            TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] - 25)
        end
    end,
    [9] = function()
        print("Filter Event")
        QBCore.Functions.Notify('The filter is getting dirty...', 'info') Wait(3000)
        if QBCore.Functions.HasItem('filter', 1) then
            TriggerServerEvent('qb-drugsystem:server:remItem', 'filter')
            QBCore.Functions.Notify('You replace it with a spare one!', 'success')
        else
            TriggerServerEvent('qb-drugsystem:server:modCook', 'purity', -10)
        end
    end,
    [10] = function()
        print("Pressure Event")
        local str = ""
        local unstable = false
        local tpe = 'info'
        if math.random(20) == 1 then
            unstable = true
            str, tpe = "highly ", 'error'
        end
        QBCore.Functions.Notify('The pressure seems '..str..'unstable...', tpe)
        Wait(3000)
        local success = lib.skillCheck({'easy', 'easy', 'medium'}, {'a','s','d','f','g','h','j','k','l'})
        if not success then
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            QBCore.Functions.Notify('You fail to regulate the pressure in time...', 'error')
            Wait(2000)
            if unstable then
                local vehCoords = GetEntityCoords(veh)
                QBCore.Functions.Notify(_U('methcamper_unstable_alert'), 'error', 6000)
                isProducing = false
                Wait(8000) AddExplosion(vehCoords.x, vehCoords.y, vehCoords.z, 7, 200.0, true, false, 5.0, false)
                Wait(2000) sendPoliceAlert(true)
            else
                TriggerServerEvent('qb-drugsystem:server:modCook', 'purity', -5)
                TriggerServerEvent('qb-drugsystem:server:modCook', 'amount', -3)
            end
        else QBCore.Functions.Notify('You regulate the pressure and everything is fine.', 'success') end
    end,
}

RegisterNetEvent('qb-drugsystem:client:lostLab', function()
    isProducing = false
end)

function CheckInsideNoGoZone()
    local retval = false
    for k, v in pairs(NoGoZones) do
        if v.point.currentDistance and v.point.currentDistance < v.point.distance then retval = true end
    end
    return retval
end exports('CheckInsideNoGoZone', CheckInsideNoGoZone)

--------------
-- Meth Lab --
--------------
local PanelLocs = {
    [1] = {ofs = {-7.0, -5.2, -2.5}, light = {-7.05, -5.3, -2.7}},
    [2] = {ofs = {-6.3, -5.2, -2.5}, light = {-6.3, -5.3, -2.5}},
    [3] = {ofs = {-5.1, -5.2, -2.4}, light = {-5.1, -5.3, -2.5}},
    [4] = {ofs = {-5.15, -3.1, -2.5}, light = {-5.15, -3.0, -2.6}},
    [5] = {ofs = {-5.85, -3.1, -2.5}, light = {-5.85, -3.0, -2.6}},
    [6] = {ofs = {-7.05, -3.1, -2.4}, light = {-7.05, -3.0, -2.4}},
}

local LabEvents = {
    [1] = function()
        print("Labs Fumes Event")
        QBCore.Functions.Notify('You notice fumes are starting to build up quickly, you need to air the room!', 'error')
        VentsEnabled = true
        Wait(3000) if not IsWearingGasMask() then
            IsBlurred = true
            if not fumesEffect then
                fumesEffect = true
                SetTimecycleModifier("DRUG_gas_huffin")
                QBCore.Functions.Notify('You feel Dizzy...', 'error')
            end
        else QBCore.Functions.Notify('Your Gas Mask protects you from the gases...', 'error')
        end
    end,
    [2] = function()
        print("Methylamine Event")
        QBCore.Functions.Notify('You realize there isnt enough methylamine!', 'error')
    end,
    [3] = function()
        print("Aluminum Event")
        QBCore.Functions.Notify('You realize there isnt enough shredded aluminum!', 'error')
    end,
    [4] = function()
        print("Thorium Event")
        QBCore.Functions.Notify('You realize there isnt enough thorium oxide!', 'error')
    end,
    [5] = function()
        print("Hydrogene Event")
        QBCore.Functions.Notify('The solution is lacking hydrogene...', 'error')
        local coords = Shared.MethLabs[CurrentLab].loc.coords
        local baseLamp = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.0, 1614163124, 0, 0, 0)
        local lightCoords = GetOffsetFromEntityInWorldCoords(baseLamp, -12.85, -6.6, -2.8)
        while true do
            if GlobalState['methProduction:'..CurrentLab..':eventControl'] ~= 5 then break end
            DrawLightWithRange(lightCoords.x, lightCoords.y, lightCoords.z, 255, 0, 0, 2.0, 3.0)
            Wait(0)
        end
    end,
    [6] = function()
        print("Lit Panels Event")
        Citizen.CreateThread(function()
            --ent_amb_fbi_light_door --core
            local panel = GlobalState['methProduction:'..CurrentLab..':activePanel']
            local coords = Shared.MethLabs[CurrentLab].loc.coords
            local baseLamp = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.0, 1614163124, 0, 0, 0)
            local v = PanelLocs[panel]
            local lightCoords = GetOffsetFromEntityInWorldCoords(baseLamp, v.light[1], v.light[2], v.light[3])
            while true do
                if GlobalState['methProduction:'..CurrentLab..':activePanel'] ~= panel then break end
                DrawLightWithRange(lightCoords.x, lightCoords.y, lightCoords.z, 255, 0, 0, 2.0, 20.0)
                Wait(300)
            end
        end)
        QBCore.Functions.Notify('One of the panels is flashing a red light...', 'error')
    end,
    [7] = function()
        print("Minigame Panels Event")
        Citizen.CreateThread(function()
            --ent_amb_fbi_light_door --core
            MinigameActive = true
            local coords = Shared.MethLabs[CurrentLab].loc.coords
            local baseLamp = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.0, 1614163124, 0, 0, 0)
            local lightCoords = GetOffsetFromEntityInWorldCoords(baseLamp, -10.0, -3.5, -2.5)
            while true do
                if GlobalState['methProduction:'..CurrentLab..':eventControl'] ~= 7 then break end
                DrawLightWithRange(lightCoords.x, lightCoords.y, lightCoords.z, 255, 0, 0, 2.0, 20.0)
                Wait(0)
            end
        end)
        QBCore.Functions.Notify('The production pannel lights up bright red...', 'error')
    end,
    [8] = function()
        print("Broken Hydro Event")
        Citizen.CreateThread(function()
            --ent_amb_fbi_light_door --core
            sparkHydro = true
            local coords = Shared.MethLabs[CurrentLab].loc.coords
            local baseLamp = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.0, 1614163124, 0, 0, 0)
            local lightCoords = GetOffsetFromEntityInWorldCoords(baseLamp, -12.9, -6.65, -2.7)
            RequestNamedPtfxAsset('des_car_show_room')
            while not HasNamedPtfxAssetLoaded('des_car_show_room') do Wait(1) end
            local effect = 'ent_ray_arm3_sparking_wires'
            while true do
                if GlobalState['methProduction:'..CurrentLab..':eventControl'] ~= 9 then break end
                SetPtfxAssetNextCall('des_car_show_room') --vector3(22.19, 6433.59, 42.78)
                StartParticleFxNonLoopedAtCoord(effect, lightCoords.x, lightCoords.y, lightCoords.z, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0)
                Wait(math.random(5000,10000))
            end
        end)

        QBCore.Functions.Notify('You hear a spark and some weird noises...', 'error')
    end,
    [9] = function()
        print("Broken Production Panel Event")
        Citizen.CreateThread(function()
            --ent_amb_fbi_light_door --core
            sparkProd = true
            local coords = Shared.MethLabs[CurrentLab].loc.coords
            local baseLamp = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.0, 1614163124, 0, 0, 0)
            local lightCoords = GetOffsetFromEntityInWorldCoords(baseLamp, -9.60, -3.5, -2.5)
            RequestNamedPtfxAsset('des_car_show_room')
            while not HasNamedPtfxAssetLoaded('des_car_show_room') do Wait(1) end
            local effect = 'ent_ray_arm3_sparking_wires'
            while true do
                if GlobalState['methProduction:'..CurrentLab..':eventControl'] ~= 9 then break end
                SetPtfxAssetNextCall('des_car_show_room') --vector3(22.19, 6433.59, 42.78)
                StartParticleFxNonLoopedAtCoord(effect, lightCoords.x, lightCoords.y, lightCoords.z, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0)
                Wait(math.random(5000,10000))
            end
        end)
        QBCore.Functions.Notify('You hear a spark and some weird noises...', 'error')
    end,
    [10] = function()
        print("Breaker Blew")
        Citizen.CreateThread(function()
            --ent_amb_fbi_light_door --core
            sparkProd = true
            local coords = Shared.MethLabs[CurrentLab].loc.coords
            local baseLamp = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.0, 1614163124, 0, 0, 0)
            local lightCoords = GetOffsetFromEntityInWorldCoords(baseLamp, -9.60, -3.5, -2.5)
            RequestNamedPtfxAsset('des_car_show_room')
            while not HasNamedPtfxAssetLoaded('des_car_show_room') do Wait(1) end
            local effect = 'ent_ray_arm3_sparking_wires'
            while true do
                if GlobalState['methProduction:'..CurrentLab..':eventControl'] ~= 9 then break end
                SetPtfxAssetNextCall('des_car_show_room') --vector3(22.19, 6433.59, 42.78)
                StartParticleFxNonLoopedAtCoord(effect, lightCoords.x, lightCoords.y, lightCoords.z, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0)
                Wait(math.random(5000,10000))
            end
        end)
        QBCore.Functions.Notify('You hear a spark and some weird noises...', 'error')
    end,

    -- Need to check X target, (press buttons and stuff, no real things needed)
}

RegisterNetEvent('qb-drugsystem:client:LabEvents', function(lab, event)
    if not IsInsideMethLab or CurrentLab ~= lab then return end
    PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1) Wait(200)
    PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1) Wait(200)
    PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
    LabEvents[event]()
end)


RegisterNetEvent('qb-drugsystem:client:labFlare', function(coords)
    SetPtfxAssetNextCall('core') --exp_grd_bzgas_smoke
    --local smoke = StartParticleFxLoopedAtCoord('exp_grd_flare', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
    local smoke = StartParticleFxLoopedAtCoord('exp_grd_flare', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
    SetParticleFxLoopedAlpha(smoke, 0.8)
    SetParticleFxLoopedColour(smoke, 0.0, 0.0, 0.0, 0)
    Wait(30000)
    StopParticleFxLooped(smoke, 0)
end)

RegisterCommand('testfumes', function()
    local coords = Shared.MethLabs[CurrentLab].loc.coords
    local baseLamp = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.0, 1614163124, 0, 0, 0)
    local lightCoords = GetOffsetFromEntityInWorldCoords(baseLamp, -9.60, -3.5, -2.5)
    RequestNamedPtfxAsset('des_car_show_room')
    while not HasNamedPtfxAssetLoaded('des_car_show_room') do Wait(1) end
    local effect = 'ent_ray_arm3_sparking_wires'
    while true do
        --if GlobalState['methProduction:'..CurrentLab..':eventControl'] ~= 8 then break end
        SetPtfxAssetNextCall('des_car_show_room') --vector3(22.19, 6433.59, 42.78)
        StartParticleFxNonLoopedAtCoord(effect, lightCoords.x, lightCoords.y, lightCoords.z, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0)
        Wait(math.random(5000,10000))
    end
end)

--- Toggles producing meth
--- @return nil
local StartProducing = function()
    if isProducing then return end
    -- Cop & Item Check
    QBCore.Functions.TriggerCallback('qb-drugsystem:server:GetCopCount', function(cops)
        if cops < Shared.MethcamperMinCops then QBCore.Functions.Notify(_U('not_enough_cops'), 'error', 2500) isProducing = false sentMessage = false return end
        local ped = PlayerPedId()
        if GetEntityCoords(ped).y < 2342.00 then QBCore.Functions.Notify('You should go further north to do this...', 'error') isProducing = false sentMessage = false return end
        if CheckInsideNoGoZone() then QBCore.Functions.Notify('This place is too populated to cook!', 'error') isProducing = false sentMessage = false return end
        if not Entity(GetVehiclePedIsIn(ped, false)).state.CanCookMeth then QBCore.Functions.Notify('You can\'t install any equipment in this vehicle.', 'error') isProducing = false sentMessage = false return end
        QBCore.Functions.TriggerCallback('qb-drugsystem:server:hasMethCamperItems', function(hasItem)
            if not hasItem then isProducing = false sentMessage = false return end
            isProducing = true
            QBCore.Functions.Progressbar('methcamper_part1', _U('methcamper_progressbar_methcamper_part1'), math.random(5000), false, true, { -- 1
                disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true,
            }, {}, {}, {}, function() if not isProducing then return end

                -- Temperature Input
                local temp = nil

                local input = lib.inputDialog('Cook Settings', {{type = 'slider', label = 'Temperature', description = 'Set the cooking temperature', required = true, min = 200, max = 800, default = 500},})
                if not isProducing then return end
                if input and input[1] then
                    temp = tonumber(input[1])
                    if temp <= minTemp or temp >= maxTemp then
                        local veh = GetVehiclePedIsIn(ped, false)
                        local vehCoords = GetEntityCoords(veh)
                        QBCore.Functions.Notify(_U('methcamper_unstable_alert'), 'error', 6000)
                        Wait(8000) AddExplosion(vehCoords.x, vehCoords.y, vehCoords.z, 7, 200.0, true, false, 5.0, false)
                        Wait(2000) sendPoliceAlert(true)
                        return
                    end
                else
                    local veh = GetVehiclePedIsIn(ped, false)
                    local vehCoords = GetEntityCoords(veh)
                    QBCore.Functions.Notify(_U('methcamper_unstable_alert'), 'error', 6000)
                    Wait(6000) AddExplosion(vehCoords.x, vehCoords.y, vehCoords.z, 7, 200.0, true, false, 5.0, false)
                    Wait(2000) sendPoliceAlert(true)
                    return
                end
                -- Random Cop Call
                if math.random(100) <= Shared.MethcamperCopChance then sendPoliceAlert(false) end

                -- Production
                local pos = GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(ped, false), -0.7, -1.85, 0.6)
                TriggerServerEvent('qb-drugsystem:server:ptfx', pos)

                local EventsDone = {}
                local veh = GetVehiclePedIsIn(ped, false)
                local Events = {}
                Events[math.random(1,14)] = true
                Events[math.random(15,28)] = true
                Events[math.random(29,42)] = true
                local progress = 0
                -- Cooking Loop
                for i = 1, 42 do
                    if GetPedInVehicleSeat(veh, -1) == 0 and (GetPedInVehicleSeat(veh, 1) == ped or GetPedInVehicleSeat(veh, 2) == ped) then
                        if not isProducing then break end
                        progress = progress + 100/42
                        exports['qb-core']:DrawText('Progress : '..math.ceil(progress).."%")
                        Wait(10000)
                        if Events[i] then
                            ::start::
                            local ran = math.random(#EventList)
                            if EventsDone[ran] then goto start end
                            EventsDone[ran] = true
                            EventList[ran]()
                        end
                    else print("Not in Vehicle") break end
                end
                EventsDone = {}
                lib.hideTextUI()

                QBCore.Functions.Progressbar('methcamper_part3', _U('methcamper_progressbar_methcamper_part3'), math.random(45000, 60000), false, true, {
                disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true,
                }, {}, {}, {}, function()
                    if not isProducing then return end
                    TriggerServerEvent('qb-drugsystem:server:methcamperReward', temp)
                    IsBlurred = false
                    SetTimecycleModifier("")
                    SetTransitionTimecycleModifier("")
                    isProducing = false sentMessage = false
                end, function()
                    IsBlurred = false
                    SetTimecycleModifier("")
                    SetTransitionTimecycleModifier("")
                    isProducing = false  QBCore.Functions.Notify(_U('canceled'), 'error', 2500)
                end)
            end, function()
                IsBlurred = false
                SetTimecycleModifier("")
                SetTransitionTimecycleModifier("")
                isProducing = false sentMessage = false
                QBCore.Functions.Notify(_U('canceled'), 'error', 2500)
            end)
        end)
    end)
end

--- Animation to Carry & Pour an ingredient
---@param item string -- The item being carried
---@return integer CarryPackage -- The carried prop handle
local CarryAndPour = function(item)
    local model = `prop_offroad_barrel01`
    if item == 'shredded_aluminum' then model = "v_ind_ss_box01" elseif item == 'thorium_oxide' then model = "bkr_prop_meth_sacid" end
    RequestModel(model)
    local ped = PlayerPedId()
    while not HasModelLoaded(model) do Wait(10) end
    local pos = GetEntityCoords(ped, true)
    CarryPackage = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)
    AttachEntityToEntity(CarryPackage, ped, GetPedBoneIndex(ped, 28422), 0.55, 0.00, 0.00, 00.0, -90.0, 0.0, true, true, false, true, 1, true)
    RequestNamedPtfxAsset('core')
    while not HasNamedPtfxAssetLoaded('core') do Wait(10) end
    SetPtfxAssetNextCall('core')
    local effect = StartParticleFxLoopedOnEntity('ent_sht_water', CarryPackage, 0.35, 0.0, 0.25, 0.0, 0.0, 0.0, 2.0, false, false, false)
    return CarryPackage
end
--- Adds a single ingredient for the ingredients event
--- @return nil
local AddSingleIngredient = function()
    if not IsInsideMethLab then return end
    QBCore.Functions.TriggerCallback('qb-drugsystem:server:hasIngredient', function(hasItem)
        if not hasItem then return end
        -- Carry & Pour Methylamine Barrel
        local carry = CarryAndPour(GlobalState['methProduction:'..CurrentLab..':neededIngredient'])
        QBCore.Functions.Progressbar('methcamper_part1', 'Pouring Ingredients', 3000, false, true, { -- 1
            disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true,
        }, { animDict = 'weapon@w_sp_jerrycan', anim = 'fire', flags = 1,}, {}, {},
        function()
            DeleteEntity(carry)
            ClearPedTasks(PlayerPedId())
        end)
    end, CurrentLab)
end

--- Meth Lab Production
--- @return nil
local AddMethIngredients = function()
    print(2342342)
    if isProducing or not IsInsideMethLab then isProducing = false sentMessage = false return end
    local ped = PlayerPedId()
    -- Checking if player has items & removing their content.
    QBCore.Functions.TriggerCallback('qb-drugsystem:server:hasMethLabItems', function(hasItem)
        if not hasItem then isProducing = false sentMessage = false return end
        isProducing = true
        -- Carry & Pour Methylamine Barrel
        local carry = CarryAndPour('methylamine')
        QBCore.Functions.Progressbar('methcamper_part1', 'Pouring Ingredients', 3000, false, true, { -- 1
            disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true,
        }, { animDict = 'weapon@w_sp_jerrycan', anim = 'fire', flags = 1,}, {}, {},
        function()
            if not isProducing then return end
            DeleteEntity(carry)
            ClearPedTasks(ped)
            Wait(500)
            -- Carry & Pour Aluminum
            carry = CarryAndPour('shredded_aluminum')
            QBCore.Functions.Progressbar('methcamper_part1', 'Pouring Ingredients', 3000, false, true, { -- 1
                disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true,
            }, { animDict = 'weapon@w_sp_jerrycan', anim = 'fire', flags = 1, }, {}, {},
            function()
                if not isProducing then return end
                DeleteEntity(carry)
                ClearPedTasks(ped)
                Wait(500)
                -- Carry & Pour Thorium Oxide
                carry = CarryAndPour('thorium_oxide')
                QBCore.Functions.Progressbar('methcamper_part1', 'Pouring Ingredients', 3000, false, true, { -- 1
                    disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true,
                }, { animDict = 'weapon@w_sp_jerrycan', anim = 'fire', flags = 1, }, {}, {},
                function()
                    if not isProducing then return end
                    DeleteEntity(carry)
                    ClearPedTasks(ped)
                    Wait(500)
                    -- Temperature & Pressure Input
                    TriggerServerEvent('qb-drugsystem:server:enableMethProdSettings', CurrentLab)
                end)
            end)
        end)
    end, CurrentLab)
end

--- Meth Lab Production
--- @return nil
local StartMethProduction = function()
    local temp = GlobalState['methProduction:'..CurrentLab..':temperature']
    local pressure = GlobalState['methProduction:'..CurrentLab..':pressure']
    if not temp or not pressure then QBCore.Functions.Notify('The settingd aren\'t right...', 'error') return end
    --if not isProducing then return end

    -- --WAIT FOR PEEVS
    -- if temp <= minTemp or temp >= maxTemp then
    --     TriggerServerEvent('qb-drugsystem:server:sendLabPassout')
    --     return
    -- end
    -- -- WAIT FOR PEEVS
    -- if pressure <= minPressure or pressure >= minPressure then
    --     TriggerServerEvent('qb-drugsystem:server:sendLabPassout')
    --     return
    -- end

    -- -- Random Cop Call
    -- -- WAIT FOR PEEVS
    -- if math.random(100) <= Shared.MethcamperCopChance then sendPoliceAlert(false) end

    TriggerServerEvent('qb-drugsystem:server:startProduction', CurrentLab)
end

--- Temperature & Pressure Selection UI
--- @return nil
local SetLabSettings = function()
	local oldtemp = GlobalState['methProduction:'..CurrentLab..':temperature'] or 0
	local oldName = GlobalState['methProduction:'..CurrentLab..':strainName'] or "Not chosen yet."
	local oldpressure = GlobalState['methProduction:'..CurrentLab..':pressure'] or 0
	local string = 'Temperature : '..oldtemp.."°\nPressure : "..oldpressure.." psi\nStrain Name : "..oldName
	lib.registerContext({
		id = 'checkVatMenu',
		title = 'Production Settings',
		options = {
			{
				title = 'Current Settings :',
				description = string,
				icon = 'vial-circle-check',
				disabled = true,
			},
			{
				title = 'Set Production Settings',
				description = 'Decide the temperature and pressure for this cook.',
				icon = 'sliders',
				onSelect = function()
                    local temp, pressure = nil, nil
                    local input = lib.inputDialog('Production Settings', {
                        {type = 'slider', label = 'Temperature', description = 'Set the cooking temperature', required = true, min = 200, max = 800, default = 500},
                        {type = 'slider', label = 'Pressure', description = 'Set the cooking pressure', required = true, min = 200, max = 800, default = 500},
                        {type = 'input', label = 'Strain Name', description = 'Give a name to your production!', required = true},
                    })
                    if not isProducing then return end
                    if input and input[1] then
                        temp = tonumber(input[1])
                        TriggerServerEvent('qb-drugsystem:server:SetProdSettings', CurrentLab, 'temperature',temp)
                    end
                    if input and input[2] then
                        pressure = tonumber(input[2])
                        TriggerServerEvent('qb-drugsystem:server:SetProdSettings', CurrentLab, 'pressure', pressure)
                    end
                    if input and input[3] then
                        TriggerServerEvent('qb-drugsystem:server:SetProdSettings', CurrentLab, 'strainName', input[3])
                    end
                end,
			},
            {
				title = 'Start Production',
				description = "Start up your production (~ 30 minustes)",
				icon = 'vial-circle-check',
                disabled = GlobalState['methProduction:'..CurrentLab..':temperature'] == 0 or GlobalState['methProduction:'..CurrentLab..':pressure'] == 0 or GlobalState['methProduction:'..CurrentLab..':cooking'],
				onSelect = StartMethProduction,
			},
		}
	})
	lib.showContext('checkVatMenu')
end

--- Handler when activating the air vents
---@ return nil
local ActivateAirVents = function() TriggerServerEvent('qb-drugsystem:server:activateAirVents', CurrentLab) end

--- Handler when adjusting the hydrogene level
---@ return nil
local ActivateHydrogene = function()
    if GlobalState['methProduction:'..CurrentLab..':brokenHydro'] then QBCore.Functions.Notify("The panel is unresponsive...", "error") return end
    QBCore.Functions.Progressbar('methcamper_hydrogene', 'Adjusting Hydrogene Levels', 10000, false, true,
    { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
    { animDict = 'anim@amb@business@meth@meth_monitoring_cooking@monitoring@', anim = 'button_press_v2_monitor', flags = 1},
    {}, {}, function()
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('qb-drugsystem:server:adjustHydrogene', CurrentLab)
    end)
end

--- Handler when fixing the hydrogene panel
---@ return nil
local FixHydrogene = function()
    if not GlobalState['methProduction:'..CurrentLab..':brokenHydro'] and not GlobalState['methProduction:'..CurrentLab..':sparkHydro'] then return end
    if GlobalState['methProduction:'..CurrentLab..':brokenHydro'] and GlobalState['methProduction:'..CurrentLab..':cooking'] then QBCore.Functions.Notify("The panel is too damaged to do this while a production is going.", "error") return end
    if not QBCore.Functions.HasItem("electronickit", 3) then QBCore.Functions.Notify("You need some electronics to repair the panel....", "error") return end
    QBCore.Functions.Progressbar('methcamper_fixhydrogene', 'Replacing Internal Electronics....', 5000, false, true,
    { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
    { animDict = 'anim@amb@business@meth@meth_monitoring_cooking@monitoring@', anim = 'button_press_v2_monitor', flags = 1}, --event needs changing
    {}, {}, function()
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('qb-drugsystem:server:fixHydrogene', CurrentLab)
    end)
end

--- Handler when fixing the production panel
---@ return nil
local FixMinigames = function()
    if not GlobalState['methProduction:'..CurrentLab..':brokenProd'] and not GlobalState['methProduction:'..CurrentLab..':sparkProd'] then return end
    if GlobalState['methProduction:'..CurrentLab..':brokenProd'] and GlobalState['methProduction:'..CurrentLab..':cooking'] then QBCore.Functions.Notify("The panel is too damaged to do this while a production is going.", "error") return end
    if not QBCore.Functions.HasItem("electronickit", 3) then QBCore.Functions.Notify("You need some electronics to repair the panel....", "error") return end
    QBCore.Functions.Progressbar('methcamper_fixhydrogene', 'Replacing Internal Electronics....', 5000, false, true,
    { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
    { animDict = 'anim@amb@business@meth@meth_monitoring_cooking@monitoring@', anim = 'button_press_v2_monitor', flags = 1}, --event needs changing
    {}, {}, function()
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('qb-drugsystem:server:fixProduction', CurrentLab)
    end)
end

RegisterNetEvent('qb-drugsystem:client:AdjustLitPanels', function(data)
    QBCore.Functions.Progressbar('methcamper_litPanel', 'Adjusting some settings...', 7000, false, true,
    { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
    { animDict = 'anim@amb@business@meth@meth_monitoring_cooking@monitoring@', anim = 'button_press_v2_monitor', flags = 1},
    {}, {}, function()
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('qb-drugsystem:server:adjustPanel', CurrentLab, data.panel)
    end)
end)

local MethMinigames = function()
    local games = {'circle', 'path', 'spot'}
    local g = math.random(3)
    local success
    local done = false
    if games[g] == 'circle' then
        success = lib.skillCheck({'easy', 'easy', 'easy', 'easy', 'easy'}, {'a','s','d','f','g','h','j','k','l'})
        done = true
    elseif games[g] == 'path'  then
        exports['glow_minigames']:StartMinigame(function(s)
            success = s
            done = true
        end, 'path', {gridSize = 21, lives = 3, timeLimit = 10000})
    elseif games[g] == 'spot'  then
        local tps = {'numeric', 'alphabet', 'alphanumeric'}
        exports['glow_minigames']:StartMinigame(function(s)
            success = s
            done = true
        end, 'spot', {gridSize = 6, timeLimit = 8000, charSet = tps[math.random(3)], required = 10})
    end
    while not done do Wait(0) end
    QBCore.Functions.Progressbar('methcamper_litPanel', 'Adjusting some settings...', 7000, false, false,
    { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
    { animDict = 'anim@amb@business@meth@meth_monitoring_cooking@monitoring@', anim = 'button_press_v2_monitor', flags = 1},
    {}, {}, function()
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('qb-drugsystem:server:adjustMinigames', CurrentLab, success)
    end)
end

local PourMeth = function()
    TriggerServerEvent('qb-drugsystem:server:methLabPour', CurrentLab)
end

local function ScalingMeth(t, selected)
    -- Confirmation & Animation
	local pData = QBCore.Functions.GetPlayerData()
	local data = ""
	if t == 'batch' then data = "1 Big Bag."
	elseif t == 'baggies' then if not QBCore.Functions.HasItem('emptybaggy', selected.info.methAmt) then QBCore.Functions.Notify('You don\'t have enough baggies with you!') return end
		data = "about ~"..selected.info.methAmt.." Small Baggies."
	end
	local batch = pData.items[selected.slot]
    if batch.info.methAmt ~= selected.info.methAmt then print('Not the same bag?') return end
	local alert = lib.alertDialog({
		header = 'Meth Scaling Table\n\n**'..batch.info.methStrainName.."**\n\n"..batch.info.purity.."% Purity | ~"..batch.info.methAmt.. " baggies.",
		content = 'Scale Batch Into '..data,
		centered = true,
		cancel = true
	}) if alert ~= "confirm" then return end
    LocalPlayer.state:set('inv_busy', true, true)
	local ped = PlayerPedId()
    QBCore.Functions.Progressbar('methcamper_breakGlass', 'Breaking Down Meth...', 10000, false, true,
    { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
    { animDict = 'anim@amb@business@meth@meth_smash_weight_check@', anim = 'break_weigh_v3_char02', flags = 1},
    {}, {}, function()
        ClearPedTasks(PlayerPedId())
    end)
    if selected.name == 'meth_cured' then Wait(10500) end
    QBCore.Functions.Progressbar('methcamper_breakGlass', 'Saling Meth...', 15000, false, true,
    { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
    { animDict = 'anim@amb@business@meth@meth_smash_weight_check@', anim = 'break_weigh_v3_char01', flags = 1},
    {}, {}, function()
        ClearPedTasks(PlayerPedId())
        LocalPlayer.state:set('inv_busy', false, true)
        TriggerServerEvent('qb-drugsystem:server:ScaleMeth', t, selected.slot)
    end)
end

-- Size Selection
local function ScaleSelectedMeth(selected, item)
	local options = {
		{title = "Scale Into Small Baggies", description = "Pack into ~" .. selected.info.methAmt .." small baggies, for consumption & street selling.", onSelect = function() ScalingMeth('baggies', selected) end},
		{title = "Scale Into 1 _Batch_ Bag", description = "Pack into 1 bag, for bulk selling.", disabled = item == 'batch', onSelect = function() ScalingMeth('batch', selected) end},
	}
	lib.registerContext({ id = 'scaleSelection', title = 'Select Scaling Size', canClose = true, options = options}) lib.showContext('scaleSelection')
end

-- Scale Table Main Menu
local ScaleMeth = function()
	local ped = PlayerPedId()
	local pData = QBCore.Functions.GetPlayerData()
	local options = {}
	for k, v in pairs(pData.items) do
		if v.name == "meth_cured" then
			options[#options + 1] = {title = v.info.methStrainName, description = v.info.purity.."% Purity\nThis batch is good for "..v.info.methAmt.." baggies", onSelect = function() ScaleSelectedMeth(v, 'tray') end}
        elseif v.name == 'meth_batch' then
            options[#options + 1] = {title = v.info.methStrainName, description = v.info.purity.."% Purity\nThis batch is good for "..v.info.methAmt.." baggies", onSelect = function() ScaleSelectedMeth(v, 'batch') end}
		end
	end
	if #options < 1 then QBCore.Functions.Notify('You don\'t have any cured meth or meth batch!', 'error') return end
	lib.registerContext({ id = 'MethScaleTable', title = 'Select Batch', canClose = true, options = options })
	lib.showContext('MethScaleTable')
end

-------------------
-- Meth Lab Zone --
-------------------
---
RegisterNetEvent('qb-drugsystem:client:CheckFridge', function(data)
    if not IsInsideMethLab or not data.fridge then return end
	local fridge = MethLabsData[CurrentLab]['Fridge'..data.fridge]
	local pData = QBCore.Functions.GetPlayerData()
	QBCore.Functions.TriggerCallback('qb-drugsystem:server:getTime', function(time)
		local options = {}
        for i = 1, 5 do
            local currentRack = fridge[i]
            local progress = 0
            local nothingCuring = false
            local timeRemaining = (currentRack.time and currentRack.time+21600 - time) or 0 --21600
            if timeRemaining > 0 then progress = math.ceil(100 - ((timeRemaining / 21600) * 100)) else progress = 100 end
            if currentRack.state == 'empty' or not currentRack.state then nothingCuring = true progress = 0 end
            local strainStr = currentRack.strain or "Unknown"
            local knowInfo = pData.gang.name == currentRack.gang
            local purityStr = (knowInfo and currentRack.purity and currentRack.purity.."%") or "No"
            local progressStr = (knowInfo and progress.."%") or "Unknown"
            local pbar = (knowInfo and progress) or nil
            local dis = pData.job.name ~= 'police' and false or (progress > 0 and progress < 100)
            --dis = false
            local onS = function()
                if pData.job.name == 'police' then TriggerServerEvent('qb-drugsystem:server:takeMethTray', CurrentLab, i, 'police')
                elseif progress == 0 then
                    local options2 = {}
                    for _, v in pairs(pData.items) do
                        if v.name == "meth_tray" then
                            options2[#options2 + 1] = {title = "Strain : "..v.info.methStrainName, description = v.info.purity.."% Purity", onSelect = function() TriggerServerEvent('qb-drugsystem:server:depoMethTray', CurrentLab, data.fridge, i, v.slot) end}
                        end
                    end
                    if #options2 < 1 then QBCore.Functions.Notify('You don\'t have any meth trays on you!', 'error') return end
                    lib.registerContext({ id = 'MethCuringFridge', title = 'Select Tray to Cure', canClose = true, options = options2 })
                    lib.showContext('MethCuringFridge')
                elseif progress == 100 then TriggerServerEvent('qb-drugsystem:server:takeMethTray', CurrentLab, data.fridge, i) end
            end
            local pA = pData.job.name == 'police' and '\nClick to Seize.' or ''
            local description = nothingCuring and '\nCurrently Empty.' or ('Strain : '..strainStr..'\nPurity : '..purityStr..' | Progress : '.. progressStr..pA)
            options[#options + 1] = {title = 'Curing Rack '..i, description = description, progress = pbar, disabled = dis, onSelect = onS}
        end
		lib.registerContext({id = 'methFridge', title = 'Curing Fridge', canClose = true, options = options })
		lib.showContext('methFridge')
    end)
end)


--- Notifies everyone in a specific lab of something happening
RegisterNetEvent('qb-drugsystem:client:labNotify', function(lab, text, notifType)
    if not IsInsideMethLab or CurrentLab ~= lab then return false end
    QBCore.Functions.Notify(text, notifType, 5000)
end)

--- Shows Ptfx on lab vents during cooks
RegisterNetEvent('qb-drugsystem:client:labPfx', function(coords)
    CreateThread(function()
        SetPtfxAssetNextCall('core') --exp_grd_bzgas_smoke
        --local smoke = StartParticleFxLoopedAtCoord('exp_grd_flare', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
        local smoke = StartParticleFxLoopedAtCoord('ent_amb_generator_smoke', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
        SetParticleFxLoopedAlpha(smoke, 0.8)
        SetParticleFxLoopedColour(smoke, 0.0, 0.0, 0.0, 0)
        Wait(30000)
        StopParticleFxLooped(smoke, 0)
    end)
end)



RegisterCommand('smoke', function()
    CreateThread(function()
        SetPtfxAssetNextCall('core') --exp_grd_bzgas_smoke
        --ent_ray_ch2_farm_smoke_dble
        --exp_grd_bzgas_smoke
        local smoke = StartParticleFxLoopedAtCoord('exp_grd_flare', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
        --local smoke = StartParticleFxLoopedAtCoord('ent_amb_generator_smoke', vector3(1403.88, 2125.74, 108.18), 0.0, 0.0, 0.0, 2.0, false, false, false, false)
        SetParticleFxLoopedAlpha(smoke, 0.8)
        SetParticleFxLoopedColour(smoke, 0.0, 0.0, 0.0, 0)
        Wait(30000)
        StopParticleFxLooped(smoke, 0)
    end)
end)
--- Loop while player is inside a lab.
--- Checks for Fumes, & Shows UI
--- @return nil
local InsideLabLoop = function()
    Citizen.CreateThread(function()
        while true do
            if not IsInsideMethLab then fumesEffect = false SetTimecycleModifier("") break end

            -- Fumes Check
            if GlobalState['methProduction:'..CurrentLab..':fumesLevel'] >= 2 and not IsWearingGasMask() and not fumesEffect then
                fumesEffect = true
                SetTimecycleModifier("DRUG_gas_huffin")
                QBCore.Functions.Notify('You feel Dizzy...', 'error')
            elseif IsWearingGasMask() or GlobalState['methProduction:'..CurrentLab..':fumesLevel'] == 0 then fumesEffect = false SetTimecycleModifier("") end

            -- Cooking Progress UI
            if GlobalState['methProduction:'..CurrentLab..':cooking'] then
                exports['qb-core']:DrawText('Progress : '..math.floor(GlobalState['methProduction:'..CurrentLab..':cookProgress']).."%")
            end
            Citizen.Wait(5000)
        end
    end)
end

-------------------
-- Targets Check --
-------------------

--- Target Check if settings can be accessed
--- @return boolean
local CheckProductionEnabled = function()
    if not IsInsideMethLab then return false end
    return GlobalState['methProduction:'..CurrentLab..':settingsEnabled']
end

--- Target Check if ingredients have been added
--- @return boolean
local CheckIngredientsAdded = function()
    if not IsInsideMethLab then return false end
    return not GlobalState['methProduction:'..CurrentLab..':ingredients']
end

--- Target Check if addtional ingredients are needed
--- @return boolean
local CheckNeedAddtionalIngredient = function()
    if not IsInsideMethLab then return false end
    return GlobalState['methProduction:'..CurrentLab..':neededIngredient'] ~= nil
end

--- Target Check if rooom needs to be aired out
--- @return boolean
local CheckVentsEnabled = function()
    if not IsInsideMethLab then return false end
    return GlobalState['methProduction:'..CurrentLab..':fumesLevel'] > 0
end

--- Target Check if production needs hydrogene
--- @return boolean
local CheckHydrogeneEnabled = function()
    if not IsInsideMethLab then return false end
    return GlobalState['methProduction:'..CurrentLab..':eventControl'] == 5
end

--- Target Check if hydrogene panel needs fixing
--- @return boolean
local CheckHydrogeneFix = function()
    if not IsInsideMethLab then return false end
    return GlobalState['methProduction:'..CurrentLab..':eventControl'] == 8 or GlobalState['methProduction:'..CurrentLab..':brokenHydro']
end

--- Target Check if production panel needs fixing
--- @return boolean
local CheckMinigamesFix = function()
    if not IsInsideMethLab then return false end
    return GlobalState['methProduction:'..CurrentLab..':eventControl'] == 9 or GlobalState['methProduction:'..CurrentLab..':brokenProd']
end

--- Target Check if a cook is in progress
--- @return boolean
local CheckProductionCooking = function()
    if not IsInsideMethLab then return false end
    return GlobalState['methProduction:'..CurrentLab..':cooking']
end

--- Target Check if a cook is in progress
--- @return boolean
local CheckCanPour = function()
    if not IsInsideMethLab then return false end
    return GlobalState['methProduction:'..CurrentLab..':cookDone']
end


--- Function to disable everything when exiting the lab
--- @return nil
local function onExit()
	IsInsideMethLab = false
    CurrentLab = nil
    SetTimecycleModifier("")
    exports['qb-core']:HideText()
	-- if Planters then for _, v in pairs(Planters) do DeleteEntity(v.e) v.e = nil end end
	-- if Lights then for _, v in pairs(Lights) do DeleteEntity(v.e) v.e = nil end end
	-- Planters = {}
	-- Lights = {}
	exports['qb-target']:RemoveZone("MethElectPanel")
	exports['qb-target']:RemoveZone("MethVat")
	exports['qb-target']:RemoveZone("MethVatMainSettings")
    exports['qb-target']:RemoveZone("MethHydroPanel")
    exports['qb-target']:RemoveZone("MethVentsPanel")
end

local FridgeLocs = {
    [1] = {ofs = {-3.0, -7.3, -2.5}},
    [2] = {ofs = {-12.3, 5.0, -2.5}},
    [3] = {ofs = {-15.0, 5.0, -2.5}},
}

--- Function to enable everything when the player enters the lab
--- @return nil
local function onMethLabEnter(coords, lab)
	CurrentLab = lab
	IsInsideMethLab = true

    local p2 = promise.new()
	QBCore.Functions.TriggerCallback('qb-drugsystem:server:getLabTables', function(LabTable) p2:resolve(LabTable) end)
	MethLabsData = Citizen.Await(p2)

	local baseLamp = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.0, 1614163124, 0, 0, 0)
	local baseHeading = GetEntityHeading(baseLamp)
    InsideLabLoop()
    --VentsEnabled = true
    if GlobalState['methProduction:'..CurrentLab..':fumesLevel'] >= 2 then
        SetTimecycleModifier("DRUG_gas_huffin")
    end

	-- Prop Removals
	-- for i = 1, 10 do
	-- 	local plant = GetClosestObjectOfType(coords.x, coords.y, coords.z, 25.0, 716763602, 0, 0, 0)
	-- 	SetEntityCoords(plant, coords.x, coords.y, coords.z-30.0, 0.0, 0.0, 0.0, 0)
	-- 	Wait(10)
	-- end
	-- local ofs = GetOffsetFromEntityInWorldCoords(baseLamp, -2.0, 0.0, -1.0)
	-- SetEntityCoords(GetClosestObjectOfType(ofs.x, ofs.y, ofs.z, 2.0, -1685625437, 0, 0, 0), ofs.x, ofs.y, ofs.z-30.0, 0.0, 0.0, 0.0, 0)
	-- SetEntityCoords(GetClosestObjectOfType(coords.x, coords.y, coords.z, 25.0, -1322183878, 0, 0, 0), coords.x, coords.y, coords.z-30.0, 0.0, 0.0, 0.0, 0)
	-- SetEntityCoords(GetClosestObjectOfType(coords.x, coords.y, coords.z, 25.0, 661161633, 0, 0, 0), coords.x, coords.y, coords.z-30.0, 0.0, 0.0, 0.0, 0)

    -- Main Vat
	exports['qb-target']:RemoveZone("MethVat")
	local vatLoc = GetOffsetFromEntityInWorldCoords(baseLamp, -11.0, -7.1, -2.5)
	local Options =  {
        {name = "MethVat", action = AddMethIngredients, icon = "fa-solid fa-droplet", label = 'Add Ingredients', canInteract = CheckIngredientsAdded},
        {name = "MethVat", action = AddSingleIngredient, icon = "fa-solid fa-droplet", label = 'Add Ingredient', canInteract = CheckNeedAddtionalIngredient}
    }
	exports['qb-target']:AddBoxZone("MethVat", vatLoc, 1.5, 1.5, {name = "MethVat", heading = 0.0, debugPoly = false, minZ = vatLoc.z-1.0, maxZ = vatLoc.z+1.0}, {options = Options, distance = 1.5})
    -- Main Settings
	exports['qb-target']:RemoveZone("MethVatMainSettings")
	local vatSettingsLoc = GetOffsetFromEntityInWorldCoords(baseLamp, -9.0, -7.5, -2.6)
	local VatSettingOptions =  {{name = "MethVatMainSettings", action = SetLabSettings, icon = "fa-solid fa-sliders", label = 'Check Production Settings', canInteract = CheckProductionEnabled}}
	exports['qb-target']:AddBoxZone("MethVatMainSettings", vatSettingsLoc, 0.7, 1.0, {name = "MethVatMainSettings", heading = baseHeading, debugPoly = false, minZ = vatSettingsLoc.z-0.5, maxZ = vatSettingsLoc.z+0.8}, {options = VatSettingOptions, distance = 1.5})

    -- Vents
	exports['qb-target']:RemoveZone("MethVentsPanel")
	local ventsLoc = GetOffsetFromEntityInWorldCoords(baseLamp, 3.7, -2.0, -2.0)
	local Options3 =  {{name = "MethVentsPanel", action = ActivateAirVents, icon = "fa-solid fa-fan", label = 'Enable Air Vents', canInteract = CheckVentsEnabled}}
	exports['qb-target']:AddBoxZone("MethVentsPanel", ventsLoc, 1.0, 1.0, {name = "MethVentsPanel", heading = baseHeading, debugPoly = false, minZ = ventsLoc.z-0.5, maxZ = ventsLoc.z+0.5}, {options = Options3, distance = 2.5})

    -- Hydrogene Adjustment
	exports['qb-target']:RemoveZone("MethHydroPanel")
	local heatLoc = GetOffsetFromEntityInWorldCoords(baseLamp, -12.8, -7.0, -2.9)
	local heatOptions =  {
        {name = "MethHydroPanel", action = ActivateHydrogene, icon = "fa-solid fa-sliders", label = 'Adjust Hydrogene Levels', canInteract = CheckHydrogeneEnabled},
        {name = "MethHydroPanel", action = FixHydrogene, icon = "fa-solid fa-screwdriver-wrench", label = 'Fix Panel', canInteract = CheckHydrogeneFix}
    }
	exports['qb-target']:AddBoxZone("MethHydroPanel", heatLoc, 0.7, 0.7, {name = "MethHydroPanel", heading = baseHeading, debugPoly = false, minZ = heatLoc.z-0.3, maxZ = heatLoc.z+0.6}, {options = heatOptions, distance = 1.5})
	-- exports['qb-target']:RemoveZone("MethElectPanel")
	-- local elecLoc = GetOffsetFromEntityInWorldCoords(baseLamp, -17.40, -8.2, -2.5)
	-- local elecOptions =  {{name = "MethElectPanel", event = 'qb-drugsystem:client:CheckLightsInt', icon = "fa-solid fa-lightbulb", label = 'Check Lights Settings'}}
	-- exports['qb-target']:AddBoxZone("MethElectPanel", elecLoc, 0.7, 1.7, {name = "MethElectPanel", heading = baseHeading, debugPoly = true, minZ = elecLoc.z-0.8, maxZ = elecLoc.z+0.8}, {options = elecOptions, distance = 1.5})

    -- Minigames
	exports['qb-target']:RemoveZone("MethMinigames")
	local miniLoc = GetOffsetFromEntityInWorldCoords(baseLamp, -9.20, -3.5, -2.5)
	local miniOptions =  {
        {name = "MethMinigames", action = MethMinigames, icon = "fa-solid fa-sliders", label = 'Adjust Settings', canInteract = function() return MinigameActive end},
        {name = "MethMinigames", action = FixMinigames, icon = "fa-solid fa-screwdriver-wrench", label = 'Fix Panel', canInteract = CheckMinigamesFix}

    }
	exports['qb-target']:AddBoxZone("MethMinigames", miniLoc, 1.2, 1.7, {name = "MethMinigames", heading = baseHeading, debugPoly = false, minZ = miniLoc.z-0.8, maxZ = miniLoc.z+0.8}, {options = miniOptions, distance = 1.5})

    -- Hydrogene Adjustment
	exports['qb-target']:RemoveZone("MethPour")
	local pourLoc = GetOffsetFromEntityInWorldCoords(baseLamp, -15.8, -7.0, -2.6)
	local pourOptions =  {{name = "MethPour", action = PourMeth, icon = "fa-solid fa-sliders", label = 'Pour Meth', canInteract = CheckCanPour}}
	exports['qb-target']:AddBoxZone("MethPour", pourLoc, 1.0, 1.0, {name = "MethPour", heading = baseHeading, debugPoly = false, minZ = pourLoc.z-1.0, maxZ = pourLoc.z+1.0}, {options = pourOptions, distance = 1.5})

    -- Hydrogene Adjustment
	exports['qb-target']:RemoveZone("MethBreak")
	local breakLoc = GetOffsetFromEntityInWorldCoords(baseLamp, -3.5, 0.2, -2.6)
	local breakOptions =  {{name = "MethBreak", action = ScaleMeth, icon = "fa-solid fa-scale-unbalanced-flip", label = 'Break & Scale Meth'}}
	exports['qb-target']:AddBoxZone("MethBreak", breakLoc, 1.5, 4.0, {name = "MethBreak", heading = baseHeading, debugPoly = false, minZ = breakLoc.z-1.0, maxZ = breakLoc.z+0.5}, {options = breakOptions, distance = 1.5})


    for k, v in pairs(PanelLocs) do
        exports['qb-target']:RemoveZone("MethLitPanel_"..k)
        local panelLoc = GetOffsetFromEntityInWorldCoords(baseLamp, v.ofs[1], v.ofs[2], v.ofs[3])
        local panelOptions =  {{name = "MethLitPanel_"..k, event = 'qb-drugsystem:client:AdjustLitPanels', icon = "fa-solid fa-lightbulb", label = 'Adjust Panel', panel = k, canInteract = CheckProductionCooking }}
        exports['qb-target']:AddBoxZone("MethLitPanel_"..k, panelLoc, 0.3, 0.6, {name = "MethLitPanel_"..k, heading = baseHeading, debugPoly = false, minZ = panelLoc.z-0.5, maxZ = panelLoc.z+0.3}, {options = panelOptions, distance = 1.5})
    end

    for k, v in pairs(FridgeLocs) do
        exports['qb-target']:RemoveZone("MethFridge_"..k)
        local fridgeLoc = GetOffsetFromEntityInWorldCoords(baseLamp, v.ofs[1], v.ofs[2], v.ofs[3])
        local fridgeOptions =  {{name = "MethFridge_"..k, event = 'qb-drugsystem:client:CheckFridge', icon = "fa-solid fa-snowflake", label = 'Check Fridge', fridge = k,}}
        exports['qb-target']:AddBoxZone("MethFridge_"..k, fridgeLoc, 1.8, 1.8, {name = "MethFridge_"..k, heading = baseHeading, debugPoly = false, minZ = fridgeLoc.z-1.5, maxZ = fridgeLoc.z+1.0}, {options = fridgeOptions, distance = 1.5})
    end
end

--- Util Function to chekc if Player is in MethLab
--- @return nil
function CheckInsideMethLab()
	local pcoords = GetEntityCoords(PlayerPedId())
	for k, v in pairs(Shared.MethLabs) do
		if MethLabs[k]:isPointInside(pcoords) then onMethLabEnter(v.loc.coords, k) break end
	end
end

function TrevorEffect(p)
    p = 1 - (p/200)
    StartScreenEffect("DrugsTrevorClownsFightIn", 3.0, 0)
    Wait(3000*p)
    StartScreenEffect("DrugsTrevorClownsFight", 3.0, 0)
    Wait(3000*p)
	StartScreenEffect("DrugsTrevorClownsFightOut", 3.0, 0)
	StopScreenEffect("DrugsTrevorClownsFight")
	StopScreenEffect("DrugsTrevorClownsFightIn")
	StopScreenEffect("DrugsTrevorClownsFightOut")
end

local HighOnMeth = false
RegisterNetEvent('qb-drugsystem:client:smokeMeth', function(purity)
    QBCore.Functions.Progressbar("snort_meth", "Smoking Meth...", 7500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, { animDict = "switch@trevor@trev_smoking_meth", anim = "trev_smoking_meth_loop", flags = 49, },
    {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        TriggerEvent("evidence:client:SetStatus", "widepupils", 300)
		TriggerEvent("evidence:client:SetStatus", "agitated", 300)
        SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) - 10)
        TriggerServerEvent('hud:server:GainStress', math.random(25, 35))
        TrevorEffect(purity)
        if purity < 34 then return end
        if HighOnMeth then QBCore.Functions.Notify('You are already under the influence of some meth...', 'error') return end
        HighOnMeth = true
        local purEffect = purity/100
        if not exports['ps-buffs']:HasBuff('super-armor') then  exports['ps-buffs']:AddBuff('super-armor', 5*60000) end
        TriggerServerEvent('hospital:server:SetArmor', (GetPedArmour(PlayerPedId()) + math.ceil(50*purEffect)))
        SetPedArmour(PlayerPedId(), (GetPedArmour(PlayerPedId()) + math.ceil(50*purEffect)))
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.3)
		Citizen.CreateThread(function() Wait(1000) SetRunSprintMultiplierForPlayer(PlayerId(), 1.0) end)
        Citizen.CreateThread(function()
            for _ = 1, 5 do
                if purity ~= 100 then TrevorEffect(purity) end
                TriggerServerEvent('hospital:server:SetArmor', (GetPedArmour(PlayerPedId()) + 10 + math.floor(purity/10)))
				SetPedArmour(PlayerPedId(), (GetPedArmour(PlayerPedId()) + 10 + math.floor(purity/10)))
                Wait(60000)
            end
            HighOnMeth = false
        end)
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        QBCore.Functions.Notify("Canceled..", "error")
	end)
end)


--- Threads

CreateThread(function()
    -- exports['qb-target']:SpawnPed({
    --     model = 'a_m_o_acult_02',
    --     coords = Shared.MethcamperPed,
    --     minusOne = true,
    --     freeze = true,
    --     invincible = true,
    --     blockevents = true,
    --     scenario = 'WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT',
    --     target = {
    --         options = {
    --             {
    --                 type = 'client',
    --                 event = 'qb-drugsystem:client:spawnVehicle',
    --                 icon = 'fas fa-user-secret',
    --                 label = _U('methcamper_rent_vehicle')
    --             }
    --         },
    --         distance = 1.5
    --     },
    -- })

    for k, v in ipairs(Shared.MethLabs) do
		MethLabs[k] = BoxZone:Create(v.loc.coords, 25.0, 15.0, {name = "MethLab_"..k, debugPoly = false, heading = v.loc.h, minZ = v.loc.coords.z-4.92, maxZ = v.loc.coords.z+3.28,
		offset = {0.0,15.0,0}}) MethLabs[k]:onPlayerInOut(function(isPointInside) if isPointInside then onMethLabEnter(v.loc.coords, k) else onExit() end end)
	end
end)

CreateThread(function()
    Wait(1000)
    while true do
        local sleep = 5000
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= 0 and IsVehicleModel(veh, `journey`) and not IsInsideMethLab then
            sleep = 1000
            if GetPedInVehicleSeat(veh, -1) == 0 and (GetPedInVehicleSeat(veh, 1) == ped or GetPedInVehicleSeat(veh, 2) == ped) then
                if not sentMessage then exports['qb-core']:DrawText(_U('methcamper_start_producing'), 'left') sentMessage = true end
                sleep = 1
                if IsControlJustReleased(0, 38) then StartProducing() exports['qb-core']:KeyPressed(38) sentMessage = false end
            else if sentMessage then exports['qb-core']:HideText() sentMessage = false end isProducing = false end
        elseif not IsInsideMethLab then
            if IsBlurred then IsBlurred = false SetTimecycleModifier("") SetTransitionTimecycleModifier("") end
            if sentMessage then exports['qb-core']:HideText() sentMessage = false end
        end
        Wait(sleep)
    end
end)