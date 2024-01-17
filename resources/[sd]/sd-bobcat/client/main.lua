local SD = exports['sd_lib']:getLib()

local lootingTypes = { 'smgs', 'explosives', 'rifles', 'ammo' } -- Variable to track looting types
local itemTypeToLocation = { smgs = 'SMGs', rifles = 'Rifles', explosives = 'Explosives', ammo = 'Ammo' } -- Variable to associate looting types with Location

local props = {}
local lootingFunctions = {}
local nearBobcat = false
local bobcat = nil
local inBobcat = false

Zones = {}

local models = Config.PedParameters.Ped

if Config.MLOType == 'nopixel' then
CreateThread(function()
    RequestIpl("prologue06_int")
    local interiorid = GetInteriorAtCoords(883.4142, -2282.372, 31.44168)
    ActivateInteriorEntitySet(interiorid, "np_prolog_clean")
    DeactivateInteriorEntitySet(interiorid, "np_prolog_broken")
    RefreshInterior(interiorid)
end)
end

if Config.MLOType == 'gabz' then
   bobcat = PolyZone:Create({
    vector2(916.3, -2108.64),
    vector2(912.87, -2139.07),
    vector2(873.36, -2135.59),
    vector2(875.07, -2106.08), 
    vector2(898.87, -2106.42),
  }, {
    name="bobcat",
    minZ = 0.0,
    maxZ = 45.0,
    debugGrid = false,
  })
elseif Config.MLOType == 'nopixel' then
  bobcat = PolyZone:Create({
    vector2(870.47, -2253.74),
    vector2(899.18, -2257.2),
    vector2(895.36, -2301.92),
    vector2(865.77, -2300.27)
  }, {
    name="bobcat",
    minZ = 0.0,
    maxZ = 45.0,
    debugGrid = false,
  })
end

-- This function listens for the event from the server
RegisterNetEvent('sd-bobcat:client:changeState', function(locationKey, stateType, stateValue)
    if Config.Locations[Config.MLOType] and Config.Locations[Config.MLOType][locationKey] then
        Config.Locations[Config.MLOType][locationKey][stateType] = stateValue
    end
end)

-- Minigame and Heist Starting 
-- Play Alarm Sound (if enabled)
local function playAlarmSound()
    if Config.Alarm.SoundAlarm then
        local soundId = GetSoundId() 
        local alarmCoords = Config.Alarm.Coordinates[Config.MLOType]
        PlaySoundFromCoord(soundId, Config.Alarm.SoundSettings.Name, alarmCoords.x, alarmCoords.y, alarmCoords.z, Config.Alarm.SoundSettings.Ref, true, 5000, false)
        SetTimeout(Config.Alarm.SoundSettings.Timeout * 60 * 1000, function()
            StopSound(soundId)
            ReleaseSoundId(soundId)
        end)
    end
end

local function ThermiteDoor(success, doorNumber)
    if success then
        if doorNumber == 1 then
            firstDoor()
            TriggerServerEvent('sd-bobcat:server:changeState', 'FirstDoor', 'hacked', true)
        elseif doorNumber == 2 then
            if Config.Alarm.SoundAlarm then playAlarmSound() end
            secondDoor()
            TriggerServerEvent('sd-bobcat:server:changeState', 'SecondDoor', 'hacked', true)
            TriggerServerEvent('sd-bobcat:server:startCooldown')
        end
        policeAlert()
    else
        if doorNumber == 1 then
            TriggerServerEvent('sd-bobcat:server:changeState', 'FirstDoor', 'busy', false)
        elseif doorNumber == 2 then
            TriggerServerEvent('sd-bobcat:server:changeState', 'SecondDoor', 'busy', false)
        end
        if Config.RemoveThermiteOnFail then
            TriggerServerEvent('sd-bobcat:server:removeItem', Config.Items.Thermite)
        end
        SD.ShowNotification(Lang:t('error.you_failed'), 'error')
    end
end

RegisterNetEvent('sd-bobcat:client:startHeist', function() 
    local ped = PlayerPedId() local coords = GetEntityCoords(ped) local bobcatarea
    if Config.MLOType == 'gabz' then bobcatarea = vector3(911.61, -2121.13, 31.23) elseif Config.MLOType == 'nopixel' then bobcatarea = vector3(881.95, -2263.41, 30.47) end
    local distance = GetDistanceBetweenCoords(coords, bobcatarea, true)
    
    if distance < 10.0 then
        SD.ServerCallback("sd-bobcat:server:getCops", function(enoughCops)
            if enoughCops >= Config.MinimumPolice then   
                SD.ServerCallback("sd-bobcat:server:cooldown", function(cooldown)
                    if not cooldown then
                        SD.ServerCallback("sd-bobcat:server:hasItem", function(hasItem)
                            if hasItem then
                                if #(coords - Config.Locations[Config.MLOType].FirstDoor.location) < 2.0 then
                                    if not Config.Locations[Config.MLOType].FirstDoor.busy and not Config.Locations[Config.MLOType].FirstDoor.hacked  then
                                        TriggerServerEvent('sd-bobcat:server:changeState', 'FirstDoor', 'busy', true)
                                        if Config.MainMinigame == "ps-ui" then
                                            exports['ps-ui']:Thermite(function(success)
                                                ThermiteDoor(success, 1)
                                            end, Config.TimeP, Config.GridP, 3)
                                        elseif Config.MainMinigame == 'memorygame' then
                                            exports["memorygame"]:thermiteminigame(Config.Blocks, Config.Attempts, Config.Show, Config.Time, function()
                                                ThermiteDoor(true, 1)
                                            end, function()
                                                ThermiteDoor(false, 1)
                                            end)
                                        end
                                    end
                                elseif #(coords - Config.Locations[Config.MLOType].SecondDoor.location) < 2.0 then
                                    if not Config.Locations[Config.MLOType].SecondDoor.busy and not Config.Locations[Config.MLOType].SecondDoor.hacked then
                                        TriggerServerEvent('sd-bobcat:server:changeState', 'SecondDoor', 'busy', true)
                                        if Config.MainMinigame == "ps-ui" then
                                            exports['ps-ui']:Thermite(function(success)
                                                ThermiteDoor(success, 2)
                                            end, Config.TimeP2, Config.GridP2, 3)
                                        elseif Config.MainMinigame == "memorygame" then
                                            exports["memorygame"]:thermiteminigame(Config.Blocks, Config.Attempts, Config.Show, Config.Time, function()
                                                ThermiteDoor(true, 2)
                                            end, function()
                                                ThermiteDoor(false, 2)
                                            end)
                                        end
                                    end
                                end
                            else
                                SD.ShowNotification(Lang:t('error.missing_something'), 'error')
                            end
                        end, Config.Items.Thermite)
                    else
                        SD.ShowNotification(Lang:t('error.recently_robbed'), 'error')
                    end
                end)
            else
                SD.ShowNotification(Lang:t('error.no_cops'), 'error')
            end
        end)
    end
end)

-- Police Alert for Bobcat Heist (Used Dispatch System can be changed in sd_lib/sh_config.lua)
function policeAlert()
    SD.utils.PoliceDispatch({
        displayCode = "10-31B",                          -- Emergency, all units stand by
        title = 'Bobcat Weapons Heist',                 -- Title is used in cd_dispatch/ps-dispatch
        description = "Weapons depot heist in progress",-- Description of the heist
        message = "Suspects reported at the Bobcat Security weapons depot", -- Additional message
        -- Blip information is used for ALL dispatches besides ps_dispatch, please reference dispatchcodename below.
        sprite = 313,                                  -- The blip sprite for weapons depot or related icon
        scale = 1.0,                                   -- The size of the blip
        colour = 2,                                    -- Color of the blip
        blipText = "Bobcat Heist",                      -- Text on the Blip
        -- ps-dispatch
        dispatchcodename = "bobcat_heist"               -- This is the name used by ps-dispatch users for the sv_dispatchcodes.lua or config.lua under the Config.Blips entry. (Depending on Version)
    })
end 

-- Blip Creation
CreateThread(function()
    if Config.Blip.Enable then
        local blip = AddBlipForCoord(Config.Blip.Locations[Config.MLOType])
        SetBlipSprite(blip, Config.Blip.Sprite)
        SetBlipDisplay(blip, Config.Blip.Display)
        SetBlipScale(blip, Config.Blip.Scale)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, Config.Blip.Colour)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Blip.Name)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Doorlock Handler 
RegisterNetEvent('sd-bobcat:client:changeDoorlock', function(doorId, state)
   SD.utils.Doorlock({type = Config.DoorLock, id = doorId, locked = state, enablesounds = true, doorNames = {'bobcatfirst', 'bobcatsecond', 'bobcatthird'}, location = 'bobcat'})
end)

local function thirdunlock(success)
    local ped = PlayerPedId()
    if success then
        if Config.RemoveKeyCardOnUse then
            TriggerServerEvent('sd-bobcat:server:removeItem', Config.Items.Keycard)
        end
        if Config.KeycardMinigame == 'mhacking' then
        TriggerEvent('mhacking:hide')
        end
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped) 
        local id_card = 'p_ld_id_card_01'
        SD.utils.LoadModel(id_card)
        idProp = CreateObject(id_card, coords, 1, 1, 0)
        local boneIndex = GetPedBoneIndex(ped, 28422)
        AttachEntityToEntity(idProp, ped, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
        
        SD.utils.LoadAnim("amb@prop_human_atm@male@enter")
        SD.utils.LoadAnim("amb@prop_human_atm@male@idle_a")
        TaskPlayAnim(ped, "amb@prop_human_atm@male@enter", "enter", 1.0, 1.0, -1, 49, 0, 0, 0, 0)

        Wait(1500)
        DetachEntity(idProp, false, false)
        DeleteEntity(idProp)

        Wait(2500) 
        TriggerEvent("sd-bobcat:client:changeDoorlock", 'bobcatthird', false) 
        ClearPedTasks(ped)
        TriggerServerEvent('sd-bobcat:server:changeState', 'ThirdDoor', 'hacked', true)
    else
        if Config.RemoveKeyCardOnFail then TriggerServerEvent('sd-bobcat:server:removeItem', Config.Items.Keycard) end
        TriggerServerEvent('sd-bobcat:server:changeState', 'ThirdDoor', 'busy', false)
        SD.ShowNotification(Lang:t('error.you_failed'), 'error')
        if Config.KeycardMinigame == 'mhacking' then
        TriggerEvent('mhacking:hide')
        end
    end
end

RegisterNetEvent('sd-bobcat:client:openThirdDoor', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    if #(coords - Config.Locations[Config.MLOType].ThirdDoor.location) < 3.0 then
        SD.ServerCallback('sd-bobcat:server:hasItem', function(hasItem)
            if hasItem then
                if Config.EnableHacking then
                    if not Config.Locations[Config.MLOType].ThirdDoor.hacked and Config.Locations[Config.MLOType].SecondDoor.hacked then 
                        if not Config.Locations[Config.MLOType].ThirdDoor.busy then
                            TriggerServerEvent('sd-bobcat:server:changeState', 'ThirdDoor', 'busy', true)
                            if Config.KeycardMinigame == 'ps-ui' then
                                exports['ps-ui']:Scrambler(function(success)
                                    thirdunlock(success)
                                end, Config.Type, Config.TimeP3, Config.Mirrored)
                            elseif Config.KeycardMinigame == 'mhacking' then
                                Wait(1000)
                                TriggerEvent("mhacking:show")
                                TriggerEvent("mhacking:start", math.random(Config.MinChar, Config.MaxChar), Config.Time, thirdunlock)
                            elseif Config.KeycardMinigame == 'hacking' then
                                exports['hacking']:OpenHackingGame(Config.BobTime, Config.BobBlocks, Config.BobRepeat, thirdunlock)
                            end
                        end
                    end
                elseif not Config.EnableHacking then
                    TriggerEvent("sd-bobcat:client:changeDoorlock", 'bobcatthird', false)
                    TriggerServerEvent('sd-bobcat:server:changeState', 'ThirdDoor', 'hacked', true)
                    TriggerServerEvent('sd-bobcat:server:vaultsync') 
                    if Config.RemoveKeyCardOnUse then
                        TriggerServerEvent('sd-bobcat:server:removeItem', Config.Items.Keycard)
                    end
                end
            else
                SD.ShowNotification(Lang:t('error.missing_something2'), 'error')
            end
        end, Config.Items.Keycard)
    else
        SD.ShowNotification(Lang:t('error.how_you_get_here'), 'error')
    end
end)

-- Guards
RobGuard = function(entity)
  local ped = PlayerPedId()
      SD.utils.LoadAnim("pickup_object")
      TaskPlayAnim(ped, "pickup_object", "pickup_low", 8.0, -8.0, -1, 1, 0, false, false, false)

      local netId = NetworkGetNetworkIdFromEntity(entity)
      TriggerServerEvent('sd-bobcat:server:LootGuards', netId)
      
      -- FINISH
      Wait(1000)
      ClearPedTasks(ped)
end

RegisterNetEvent('sd-bobcat:client:Reward', function()
  TriggerServerEvent('sd-bobcat:server:Reward')
end)

RegisterNetEvent('sd-bobcat:client:SpawnGuards', function(netIds)
  Wait(1000)
  SetPedRelationshipGroupHash(PlayerPedId(), 'PLAYER')
  AddRelationshipGroup('npcguards')

  for i = 1, #netIds, 1 do
    local guard = NetworkGetEntityFromNetworkId(netIds[i])
    SetPedDropsWeaponsWhenDead(guard, false)
    SetEntityHealth(guard, Config.PedParameters.Health)
    SetPedSuffersCriticalHits(guard, Config.PedParameters.Headshots)
    SetCanAttackFriendly(guard, false, true)
    SetPedCombatAttributes(guard, 46, true)
    SetPedCombatAttributes(guard, 0, false)
    SetPedCombatAbility(guard, Config.PedParameters.CombatAbility)
    SetPedAsCop(guard, true)
    SetPedAccuracy(guard, Config.PedParameters.Accuracy)
    SetPedCombatRange(guard, Config.PedParameters.CombatRange)
    SetPedCombatMovement(guard, Config.PedParameters.CombatMovement)
    SetPedFleeAttributes(guard, 0, 0)
    SetPedRelationshipGroupHash(guard, 'npcguards')
  end

  SetRelationshipBetweenGroups(0, 'npcguards', 'npcguards')
  SetRelationshipBetweenGroups(5, 'npcguards', 'PLAYER')
  SetRelationshipBetweenGroups(5, 'PLAYER', 'npcguards')
end)

CreateThread(function()

  if Config.EnableLooting then
    SD.target.AddTargetModel(models, {
        distance = 1.5,
        options = { { action = function(entity) RobGuard(entity) end, icon = 'fas fa-circle', label = Lang:t('target.loot'),
        canInteract = function(entity) if inBobcat and IsPedOnFoot(PlayerPedId()) and IsPedDeadOrDying(entity) then return true end return false end, } },
      }
    )
  end
end)

-- Particles 
RegisterNetEvent("sd-bobcat:client:particles", function()
    PlayParticleEffect(1)
end)

RegisterNetEvent("sd-bobcat:client:particles2", function()
    PlayParticleEffect(2)
end)

function PlayParticleEffect(method)
    local ptfx

    SD.utils.LoadPtfxAsset("scr_ornate_heist")

    if Config.MLOType == 'gabz' then
        if method == 1 then
            ptfx = vector3(914.63, -2120.97, 31.12)
        elseif method == 2 then
            ptfx = vector3(908.64, -2119.11, 31.15)
        end
    elseif Config.MLOType == 'nopixel' then
        if method == 1 then
            ptfx = vector3(882.1320, -2257.34, 30.561)
        elseif method == 2 then
            ptfx = vector3(880.49, -2263.60, 30.441)
        end
    end

    SetPtfxAssetNextCall("scr_ornate_heist")
    local effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", ptfx, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    Wait(4000) 
    StopParticleFxLooped(effect, 0)
end

-- Vault Opening 
RegisterNetEvent('sd-bobcat:client:explosion', function()
    TriggerServerEvent("sd-bobcat:server:explodeVaultDoorSync")

    -- Resetting 'looted' state for each location
    local locations = {"SMGs", "Explosives", "Rifles", "Ammo"}
    for _, location in ipairs(locations) do
        TriggerServerEvent('sd-bobcat:server:changeState', location, 'looted', false)
    end
end)

local function closeVaultDoor()
    if Config.MLOType == 'gabz' then
        if vaultdooropen then
            SetStateOfRayfireMapObject(vaultobject, 4)
            vaultdooropen = false
        end
    elseif Config.MLOType == 'nopixel' then
        RequestIpl("prologue06_int")
        local interiorid = GetInteriorAtCoords(883.4142, -2282.372, 31.44168)
        ActivateInteriorEntitySet(interiorid, "np_prolog_clean")
        DeactivateInteriorEntitySet(interiorid, "np_prolog_broken")
        RefreshInterior(interiorid)
    end
end

RegisterNetEvent('sd-bobcat:client:updateIPL', function()
    if Config.MLOType == 'gabz' then
    vaultdoorcoords = { x = 888.12, y = -2130.54, z = 31.54 }
    vaultobject = GetRayfireMapObject(vaultdoorcoords.x, vaultdoorcoords.y, vaultdoorcoords.z, 10.0, "DES_VaultDoor001")
    doesvaultobjectexist = DoesRayfireMapObjectExist(vaultobject)
    vaultobjectstat = GetStateOfRayfireMapObject(vaultobject)
    vaultdooropen = false
    
            Citizen.Wait(100)
            SetStateOfRayfireMapObject(vaultobject, 4)
            Citizen.Wait(100)
            SetStateOfRayfireMapObject(vaultobject, 5)
            Citizen.Wait(100)
            SetStateOfRayfireMapObject(vaultobject, 6)
            Citizen.Wait(100)
            SetStateOfRayfireMapObject(vaultobject, 7)
            Citizen.Wait(100)
            SetStateOfRayfireMapObject(vaultobject, 8)
            AddExplosion(vaultdoorcoords.x, vaultdoorcoords.y, vaultdoorcoords.z, Config.ExplosionType, 150000.0, true, true, true, true)
            Citizen.Wait(100)
            SetStateOfRayfireMapObject(vaultobject, 9)
            Citizen.Wait(100)
            vaultdooropen = true
    elseif Config.MLOType == 'nopixel' then
        AddExplosion(890.7849, -2284.88, 32.441, Config.ExplosionType, 150000.0, true, false, 4.0)
        AddExplosion(894.0084, -2284.90, 32.580, Config.ExplosionType, 150000.0, true, false, 4.0)
        local interiorid = GetInteriorAtCoords(883.4142, -2282.372, 31.44168)
        ActivateInteriorEntitySet(interiorid, "np_prolog_broken")
        RemoveIpl(interiorid, "np_prolog_broken")
        DeactivateInteriorEntitySet(interiorid, "np_prolog_clean")
        RefreshInterior(interiorid)
    
    end
end)

local function openTimerInput()
    SD.ShowNotification(Lang:t('error.timer_too_high') .. " " .. Config.MaxBombTime .. ' ' .. Lang:t('menu.seconds') , 'error')
    local mdialog = SD.menu.ShowInput({
        header = Lang:t('menu.enter_timer'),
        submitText = Lang:t('menu.submit_text'),
        inputs = {
            {
                text = Lang:t('menu.bomb_timer'),
                name = "timer",
                type = "number",
                isRequired = true
            }
        },
    })

    if not mdialog.result then
        return
    end

    local enteredTimer = ""
    if mdialog.method == "lib" then
        if not mdialog.result[1] then
            return
        end
        enteredTimer = mdialog.result[1]
    elseif mdialog.method == "nui" then
        if not mdialog.result.timer then
            return
        end
        enteredTimer = mdialog.result.timer
    end

    -- Convert the entered timer to a number
    local timer = tonumber(enteredTimer)
    if timer and timer > Config.MaxBombTime then
        SD.ShowNotification(Lang:t('error.timer_too_high') .. " " .. Config.MaxBombTime, 'error')
        return
    end

    if mdialog ~= nil then
        TriggerServerEvent('sd-bobcat:server:changeState', 'VaultDoor', 'hacked', true)
        bombplant(timer * 1000)
    else
        SD.ShowNotification(Lang:t('error.timer_input_closed'), 'error')
    end
end
    
local function PlaceBomb(success)
    if success then
        openTimerInput()
    else
        TriggerServerEvent('sd-bobcat:server:changeState', 'VaultDoor', 'busy', false)
        SD.ShowNotification(Lang:t('error.you_failed'), 'error')
    end
end

RegisterNetEvent('sd-bobcat:client:bomb', function()
    SD.ServerCallback('sd-bobcat:server:hasItem', function(hasItem)
        if hasItem then
            if not Config.VaultHacking then 
                openTimerInput() 
            end

            if Config.VaultHacking then
                if not Config.Locations[Config.MLOType].VaultDoor.busy and Config.Locations[Config.MLOType].ThirdDoor.hacked then 
                    TriggerServerEvent('sd-bobcat:server:changeState', 'VaultDoor', 'busy', true)
                    if Config.VaultMinigame == "ps-ui" then
                        exports['ps-ui']:VarHack(function(success)
                            PlaceBomb(success)
                        end, Config.Blocks4, Config.Time4)
                    elseif Config.VaultMinigame == "memorygame" then
                        exports["memorygame"]:thermiteminigame(Config.Blocks3, Config.Attempts, Config.Show, Config.Time, function()
                            PlaceBomb(true)
                        end, function()
                            PlaceBomb(false)
                        end)
                    end
                end
            end
        else
            SD.ShowNotification(Lang:t('error.no_c4'), 'error')
        end
    end, Config.Items.Bomb)
end)

RegisterNetEvent('sd-bobcat:client:resetVault', function()
    -- Reset looting functions and states
    lootingFunctions = {}
    closeVaultDoor()

    if Config.Locations[Config.MLOType] then
        for _, location in pairs(Config.Locations[Config.MLOType]) do
            location.busy = false
            location.hacked = true
            location.looted = true
        end
    end

    -- Define doors data
    local doors = {
        {id = 'bobcatfirst', locked = true, enablesounds = true, type = Config.DoorLock, doorNames = {'bobcatfirst', 'bobcatsecond', 'bobcatthird'}, location = 'bobcat'},
        {id = 'bobcatsecond', locked = true, enablesounds = true, type = Config.DoorLock, doorNames = {'bobcatfirst', 'bobcatsecond', 'bobcatthird'}, location = 'bobcat'},
        {id = 'bobcatthird', locked = true, enablesounds = true, type = Config.DoorLock, doorNames = {'bobcatfirst', 'bobcatsecond', 'bobcatthird'}, location = 'bobcat'}
    }

    -- Lock the doors
    for _, doorData in ipairs(doors) do
        SD.utils.Doorlock(doorData)
    end
end)

-- Prop Creation
if Config.MLOType == 'gabz' then
    CreateThread(function()
        local weaponbox = CreateObject(GetHashKey("ex_prop_crate_ammo_sc"), 887.27, -2125.41, 30.2, 229.5, false,  true, true)
        SetEntityHeading(weaponbox, 60.8)
        FreezeEntityPosition(weaponbox, true)
        table.insert(props, weaponbox) -- Add to the props table

        local weaponbox2 = CreateObject(GetHashKey("ex_prop_crate_expl_sc"), 885.87, -2127.64, 30.2, 265.84, false,  true, true)
        SetEntityHeading(weaponbox2, 87.02)
        FreezeEntityPosition(weaponbox2, true)
        table.insert(props, weaponbox2)

        local weaponbox3 = CreateObject(GetHashKey("ex_prop_crate_expl_bc"), 891.35, -2126.4, 30.2, 200.64, false,  true, true)
        SetEntityHeading(weaponbox3, 265.64)
        FreezeEntityPosition(weaponbox3, true)
        table.insert(props, weaponbox3)

        local weaponbox4 = CreateObject(GetHashKey("ex_prop_crate_ammo_bc"), 890.85, -2121.0, 30.2, 148.99, false,  true, true)
        SetEntityHeading(weaponbox4, 340.02)
        FreezeEntityPosition(weaponbox4, true)
        table.insert(props, weaponbox4)
    end)
end

local function giveRandomForType(itemType)
    TriggerServerEvent('sd-bobcat:giveRandomBox', itemType)
    if itemTypeToLocation[itemType] then
        TriggerServerEvent('sd-bobcat:server:changeState', itemTypeToLocation[itemType], 'looted', true)
    end
end

for _, itemType in ipairs(lootingTypes) do
    lootingFunctions[itemType] = {
        giveRandom = function() giveRandomForType(itemType) end
    }
end

local function startLooting(itemType)
    local ped = PlayerPedId()
    SD.utils.LoadAnim('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
    TaskPlayAnim(ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, 8.0, 6000, 49, 1, 0, 0, 0)
    
    if not Config.Locations[Config.MLOType][itemTypeToLocation[itemType]].looted and not Config.Locations[Config.MLOType][itemTypeToLocation[itemType]].busy  then
        local lootingData = lootingFunctions[itemType]
        if lootingData then
            TriggerServerEvent('sd-bobcat:server:changeState', itemTypeToLocation[itemType], 'busy', true)
            SD.StartProgress('looting' .. itemType, Lang:t('progress.looting_crate'), math.random(3500, 5000),
                function()
                    lootingData.giveRandom()
                    ClearPedTasks(ped)
                end,
                function()
                    TriggerServerEvent('sd-bobcat:server:changeState', itemTypeToLocation[itemType], 'busy', false)
                    SD.ShowNotification(Lang:t('error.canceled'), 'error')
                    ClearPedTasks(ped)
                end)
        else
            ClearPedTasks(ped)
        end
    end
end

CreateThread(function()
    Zones["Boom"] = SD.target.AddCircleZone("boom", Config.Locations[Config.MLOType].VaultDoor.location, 2.0, {
        distance = 2.0,
        options = { { label = Lang:t('target.place_bomb'), icon = "fas fa-bomb", event = "sd-bobcat:client:bomb", canInteract = function() return Config.Locations[Config.MLOType].ThirdDoor.hacked and not Config.Locations[Config.MLOType].VaultDoor.hacked and not Config.Locations[Config.MLOType].VaultDoor.busy or false end  } },
    }, Config.BobcatDebug)
    
    Zones["Smgs"] = SD.target.AddCircleZone("smgs", Config.Locations[Config.MLOType].SMGs.location, 2.0, {
        distance = 2.0,
        options = { { label = Lang:t('target.take_weapon'), icon = "fas fa-box", action = function() startLooting('smgs') end, canInteract = function() return not Config.Locations[Config.MLOType].SMGs.looted or false end  } },
    }, Config.BobcatDebug)
    
    Zones["Explosives"] = SD.target.AddCircleZone("explosives", Config.Locations[Config.MLOType].Explosives.location, 2.0, {
        distance = 2.0,
        options = { { label = Lang:t('target.take_weapon'), icon = "fas fa-box", action = function() startLooting('explosives') end, canInteract = function() return not Config.Locations[Config.MLOType].Explosives.looted or false end  } },
    }, Config.BobcatDebug)
    
    Zones["Rifles"] = SD.target.AddCircleZone("Rifles", Config.Locations[Config.MLOType].Rifles.location, 2.0, {
        distance = 2.0,
        options = { { label = Lang:t('target.take_weapon'), icon = "fas fa-box", action = function() startLooting('rifles') end, canInteract = function() return not Config.Locations[Config.MLOType].Rifles.looted or false end  } },
    }, Config.BobcatDebug)
    
    Zones["Ammo"] = SD.target.AddCircleZone("Ammo", Config.Locations[Config.MLOType].Ammo.location, 1.3, {
        distance = 2.0,
        options = { { label = Lang:t('target.take_ammo'), icon = "fas fa-box", action = function() startLooting('ammo') end, canInteract = function() return not Config.Locations[Config.MLOType].Ammo.looted or false end } },
    }, Config.BobcatDebug)

    if Config.UseTargetForDoors then
        Zones["firstDoor"] = SD.target.AddCircleZone("firstDoor", Config.Locations[Config.MLOType].FirstDoor.location, 2.0, {
            distance = 2.0,
            options = { { label = Lang:t('target.plant_thermite'), icon = "fas fa-bomb", event = "sd-bobcat:client:startHeist", canInteract = function() return not Config.Locations[Config.MLOType].FirstDoor.hacked end } },
        }, Config.BobcatDebug)

        Zones["secondDoor"] = SD.target.AddCircleZone("secondDoor", Config.Locations[Config.MLOType].SecondDoor.location, 2.0, {
            distance = 2.0,
            options = { { label = Lang:t('target.plant_thermite'), icon = "fas fa-bomb", event = "sd-bobcat:client:startHeist", canInteract = function() return not Config.Locations[Config.MLOType].SecondDoor.hacked end } },
        }, Config.BobcatDebug)

        Zones["thirdDoor"] = SD.target.AddCircleZone("thirdDoor", Config.Locations[Config.MLOType].ThirdDoor.location, 2.0, {
            distance = 2.0,
            options = { { label = Lang:t('target.swipe_card'), icon = "fa-sharp fa-solid fa-hands", event = "sd-bobcat:client:openThirdDoor", canInteract = function() return not Config.Locations[Config.MLOType].ThirdDoor.hacked end,  } },
        }, Config.BobcatDebug)
    end
end)

AddEventHandler('onResourceStop', function(resource) 
    if resource ~= GetCurrentResourceName() then 
        return 
    end
    closeVaultDoor()
    for k in pairs(Zones) do 
        SD.target.RemoveZone(k)
    end
    for _, prop in ipairs(props) do
        if DoesEntityExist(prop) then
            DeleteEntity(prop)
        end
    end
end)

-- Polyzone
RegisterNetEvent('sd-bobcat:client:addPlayer', function()
    if inBobcat then
        local p = promise.new()
        SD.ServerCallback("sd-bobcat:server:addPlayerCallback", function(added)
            p:resolve(added)
        end)
        return Citizen.Await(p)
    end
end)

bobcat:onPlayerInOut(function(isPointInside)
    if isPointInside then
    inBobcat = true
    TriggerEvent('sd-bobcat:client:addPlayer')
else
    inBobcat = false
    TriggerServerEvent('sd-bobcat:server:removePlayer')
    end
end)

