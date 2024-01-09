local QBCore = exports['qb-core']:GetCoreObject()
local Midnight = exports['mdn-nighttime']:GetMidnightCore()
local Targets = {}
local Props = {}
local milking = false
local collecting = false

CollectTimers = {
}

local CowZone =
    PolyZone:Create(
    AnimalSettings.Cows.CowZone.Zone,
    {
        name = "CowZone",
        debugPoly = Config.DebugOptions.Debug,
        minZ = AnimalSettings.Cows.CowZone.minZ,
        maxZ = AnimalSettings.Cows.CowZone.maxZ
    }
)
local EggZone =
    PolyZone:Create(
    AnimalSettings.Chickens.EggZone,
    {
        name = "EggZone",
        debugPoly = Config.DebugOptions.Debug,
        minZ = AnimalSettings.Chickens.EggminZ,
        maxZ = AnimalSettings.Chickens.EggmaxZ
    }
)
local killing = false
AnimalsAlive = {}
local animalTypes = {}
local Keys = {
    [322] = "ESC", [288] = "F1", [289] = "F2", [170] = "F3", [166] = "F5",
    [167] = "F6", [168] = "F7", [169] = "F8", [56] = "F9", [57] = "F10",
    [243] = "~", [157] = "1", [158] = "2", [160] = "3", [164] = "4",  [165] = "5", [159] = "6", [161] = "7", [162] = "8", [163] = "9", [84] = "-", [83] = "=",  [177] = "BACKSPACE", [37] = "TAB",
    [44] = "Q", [32] = "W", [38] = "E", [45] = "R", [245] = "T", [246] = "Y", [303] = "U", [199] = "P",
    [39] = "[",  [40] = "]", [18] = "ENTER", [137] = "CAPS",
    [34] = "A", [8] = "S", [9] = "D", [23] = "F", [47] = "G",
    [74] = "H", [311] = "K", [182] = "L", [21] = "LEFTSHIFT",
    [20] = "Z", [73] = "X", [26] = "C", [0] = "V",  [29] = "B", [249] = "N",
    [244] = "M", [82] = ",", [81] = "."
}

for _, v in pairs(AnimalSettings) do
    if type(v) == "table" then
        if v.BlipSettings and v.BlipSettings.Enabled then
            makeBlip(
                {
                    coords = v.BlipSettings.BlipLoc,
                    sprite = v.BlipSettings.BlipSprite,
                    col = v.BlipSettings.BlipColor,
                    scale = 0.65,
                    disp = 6,
                    name = v.BlipSettings.Label
                }
            )
        end
    end
end
function isPlayerCloseToAnimal(animalType)
    local playerCoords = GetEntityCoords(PlayerPedId())
    for key, animal in ipairs(AnimalsAlive[animalType]) do
        local animalCoords = GetEntityCoords(animal)
        local dist = #(playerCoords - animalCoords)
        if dist < 1.5 then
            return true, {animalType = animalType, entity = animal, key = key}
        end
    end
    return false
end
if AnimalSettings.Cows.Target then
    animalTypes["cows"] = {
        model = "a_c_cow",
        setups = Config.CowSetup,
        wanderarea = AnimalSettings.Cows.Setup.wanderarea,
        zoneRadius = 30.0,
        parameters = {
            options = {
                -- {
                --     num = 1,
                --     action = function(entity)
                --         if IsPedAPlayer(entity) then
                --             return false
                --         end
                --         killCow({entity = entity, animalType = "cows"})
                --     end,
                --     icon = "fas fa-paw",
                --     label = Loc[Config.CoreOptions.Lan].target["kill_cow"],
                --     job = Config.ScriptOptions.Job,
                --     canInteract = function(entity)
                --         if IsPedAPlayer(entity) then
                --             return false
                --         end
                --         return CowZone:isPointInside(GetEntityCoords(PlayerPedId()))
                --     end
                -- },
                {
                    num = 1,
                    action = function(entity)
                        if IsPedAPlayer(entity) then
                            return false
                        end
                        MilkCow(entity)
                    end,
                    icon = "fas fa-paw",
                    label = Loc[Config.CoreOptions.Lan].target["milk_cow"],
                    job = Config.ScriptOptions.Job,
                    canInteract = function(entity)
                        if IsPedAPlayer(entity) then
                            return false
                        end
                        return CowZone:isPointInside(GetEntityCoords(PlayerPedId()))
                    end
                }
            },
            distance = 2.5
        }
    }
else
    local killkey = AnimalSettings.Cows.KillKey
    local milkKey = AnimalSettings.Cows.MilkKey
    local key = Keys[killkey]
    local key2 = Keys[milkKey]
    animalTypes["cows"] = {
        model = "a_c_cow",
        setups = Config.CowSetup,
        wanderarea = AnimalSettings.Cows.Setup.wanderarea,
        zoneRadius = 30.0
    }
    CowZone:onPlayerInOut(
        function(isPointInside)
            animalType = "cows"
            playerIsInside = isPointInside
            local player = PlayerPedId()
            CreateThread(
                function()
                    while playerIsInside do
                        Wait(0)
                        local isCloseToAnimal, animal = isPlayerCloseToAnimal(animalType)
                        if isCloseToAnimal then
                            local animalCoords = GetEntityCoords(animal.entity)
                            DrawText3D(
                                animalCoords.x,
                                animalCoords.y,
                                animalCoords.z,
                                "~g~ " ..
                                    key ..
                                        "~w~ " ..
                                            tostring(Loc[Config.CoreOptions.Lan].target["kill_cow"]) ..
                                                " ~n~~g~" ..
                                                    key2 ..
                                                        "~w~" ..
                                                            tostring(Loc[Config.CoreOptions.Lan].target["milk_cow"])
                            )
                            if IsControlJustPressed(0, killkey) then
                                killCow(animal)
                            elseif IsControlJustPressed(0, milkKey) then
                                MilkCow(animal.entity)
                            end
                        end
                    end
                    SetEntityInvincible(player, false)
                end
            )
        end
    )
end
if AnimalSettings.Chickens.Target then
    animalTypes["chickens"] = {
        model = "a_c_hen",
        setups = Config.EggSetup,
        wanderarea = vector3(2123.99, 5012.06, 41.36),
        zoneRadius = 10.0,
        parameters = {
            options = {
                {
                    num = 1,
                    action = function(entity)
                        if IsPedAPlayer(entity) then
                            return false
                        end
                        CollectEggs(entity)
                    end,
                    icon = "fas fa-paw",
                    label = Loc[Config.CoreOptions.Lan].target["collect_egg"],
                    job = Config.ScriptOptions.Job,
                    canInteract = function(entity)
                        if IsPedAPlayer(entity) then
                            return false
                        end
                        return EggZone:isPointInside(GetEntityCoords(PlayerPedId()))
                    end
                }
            },
            distance = 2.5
        }
    }
else
    local catchkey = AnimalSettings.Chickens.InteractionKey
    local key = Keys[catchkey]
    animalTypes["chickens"] = {
        model = "a_c_hen",
        setups = Config.EggSetup,
        wanderarea = vector3(2123.99, 5012.06, 41.36),
        zoneRadius = 10.0
    }
    EggZone:onPlayerInOut(
        function(isPointInside)
            animalType = "chickens"
            playerIsInside = isPointInside
            local player = PlayerPedId()
            CreateThread(
                function()
                    while playerIsInside and #AnimalsAlive["chickens"] do
                        Wait(0)
                        local isCloseToAnimal, animal = isPlayerCloseToAnimal(animalType)
                        if isCloseToAnimal then
                            local animalCoords = GetEntityCoords(animal.entity)
                            DrawText3D(
                                animalCoords.x,
                                animalCoords.y,
                                animalCoords.z,
                                "~g~" .. key .. "~w~ " .. Loc[Config.CoreOptions.Lan].game["collect_egg"]
                            )
                            if IsControlJustPressed(0, catchkey) then
                                CollectEggs(animal.entity)
                            end
                        end
                    end
                    SetEntityInvincible(player, false)
                end
            )
        end
    )
end

AddEventHandler(
    "onClientResourceStart",
    function(resource)
        if resource == GetCurrentResourceName() then
            local data = {}
            for type, animalData in pairs(animalTypes) do
                data = {
                    animalModel = animalData.model,
                    wanderarea = animalData.wanderarea,
                    zoneRadius = animalData.zoneRadius,
                    parameters = animalData.parameters,
                    animalGroup = type
                }
                for _, setup in pairs(animalData.setups) do
                    data.setup = setup
                    spawnAnimal(data)
                end
            end
            scriptStarted = true
        end
    end
)

local function respawnAnimals(animalType)
    local animalData = animalTypes[animalType]
    data = {
        animalModel = animalData.model,
        wanderarea = animalData.wanderarea,
        zoneRadius = animalData.zoneRadius,
        parameters = animalData.parameters,
        animalGroup = animalType
    }
    for k, setup in pairs(animalData.setups) do
        data.setup = setup
        spawnAnimal(data)
    end
end

AddRelationshipGroup("PED")
function spawnAnimal(data)
    local entity = makePed( data.animalModel, vector4(data.setup.coords.x, data.setup.coords.y, data.setup.coords.z + 0.03, data.setup.coords.w),   0, nil, nil, nil )

    if data.speed then
        CreateThread(
            function()
                while DoesEntityExist(entity) do
                    local speed = data.speed
                    SetPedMoveRateOverride(entity, speed)
                    SetPedMaxMoveBlendRatio(entity, 2.0)
                    SetPedDesiredMoveBlendRatio(entity, 2.0)
                    Wait(0)
                end
            end )
    end
    if data.parameters then
        exports["qb-target"]:AddTargetEntity(entity, data.parameters)
    end
    local animalGroup = data.animalGroup
    if not AnimalsAlive[animalGroup] then
        AnimalsAlive[animalGroup] = {}
    end
    table.insert(AnimalsAlive[animalGroup], entity)
    data.setup.handle = entity
    if data.setup.animDict and data.setup.animName then
        loadAnimDict(data.setup.animDict)
        TaskPlayAnim(entity, data.setup.animDict, data.setup.animName, 8.0, 0, -1, 1, 0, 0, 0)
    end
    SetEntityNoCollisionEntity(entity, PlayerPedId())
    if data.noevent then
        TaskSetBlockingOfNonTemporaryEvents(entity, true)
    end
    SetPedRelationshipGroupHash(entity, GetHashKey("PED"))
    SetEntityCanBeDamagedByRelationshipGroup(entity, false, GetHashKey("PED"))
    SetRelationshipBetweenGroups(0, GetHashKey("PED"), GetHashKey("PLAYER"))
    if data.flee then
        TaskReactAndFleePed(entity, PlayerPedId())
    elseif data.setup.frozen then
        FreezeEntityPosition(entity, true)
    else
        CreateThread(
            function()
                TaskWanderInArea( entity,
                    data.wanderarea.x,
                    data.wanderarea.y,
                    data.wanderarea.z,
                    data.zoneRadius,
                    2, 10.0 )
            end )
    end
end

function killCow(animal)
    local entity = animal.entity
    local animalType = animal.animalType
    if HasItem("weapon_knife", 1) then
        if not killing then
            killing = true
        else
            return triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["wait"], "error")
        end
        local player = PlayerPedId()
        local entityCoords = GetEntityCoords(entity)
        local playerCoords = GetEntityCoords(player)
        local effect = "ent_dst_chick_carcass"
        TaskTurnPedToFaceEntity(player, entity, 1200)
        ClearPedTasksImmediately(entity)
        FreezeEntityPosition(entity, true)
        if not IsPedHeadingTowardsPosition(player, entityCoords, 20.0) then
            TaskTurnPedToFaceCoord(player, entityCoords, 1500)
            Wait(1500)
        end
        if #(entityCoords - playerCoords) > 1.5 then
            TaskGoStraightToCoord(player, entityCoords, 0.5, 1000, 0.0, 0)
            Wait(1100)
        end
        FreezeEntityPosition(player, true)

        if animalType == "cows" then
            EmoteStart({emoteName = "stab"})
        else
            EmoteStart({emoteName = "kneel"})
            EmoteStart({emoteName = "stab"})
        end
        if Config.ScriptOptions.ParticleFXEnabled then
            CreateThread(
                function()
                    loadPtfxDict("core")
                    UseParticleFxAssetNextCall("core")
                    local particle =
                        StartParticleFxLoopedAtCoord(
                        effect,
                        GetEntityCoords(entity).x,
                        GetEntityCoords(entity).y,
                        GetEntityCoords(entity).z,
                        0.0,
                        0.0,
                        GetEntityHeading(entity) - 180.0,
                        2.5,
                        0.0,
                        0.0,
                        0.0
                    )
                    Wait(5000)
                    StopParticleFxLooped(particle, true)
                end
            )
        end
        if
            progressBar(
                {
                    label = Loc[Config.CoreOptions.Lan].progress["progress_killing"] .. animalType,
                    time = 5000,
                    cancel = true
                }
            )
         then
            table.remove(AnimalsAlive[animalType], animal.key)
            DeleteEntity(entity)
            if AnimalSettings.StressWhenKilling then
                TriggerServerEvent("hud:server:GainStress", AnimalSettings.Cows.StressPerKill)
            end
            local rep = Config.ScriptOptions.FarmingRep
            TriggerServerEvent("jixel-farming:KillAnimal", animalType, rep)
            EmoteCancel()
            ClearPedTasksImmediately(player)
            FreezeEntityPosition(player, false)
            Wait(60000 * AnimalSettings.KillingWaitTime) -- Wait til kill again
            killing = false
            if #AnimalsAlive[animalType] == 0 then
                respawnAnimals(animalType)
            end
        end
    else
        triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["noknife"], "error")
    end
end

function MilkCow(entity)
    print(milking)
    if HasItem("emptymilkbucket", 1) then
        if CollectTimers[entity] and GetGameTimer() < CollectTimers[entity] + AnimalSettings.CollectWaitTime*60000 or milking then
        triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["wait"], "error") return end
        --if not milking then milking = true else return end
        milking = true
        CollectTimers[entity] = GetGameTimer()
        local player = PlayerPedId()
        local CowCoords = GetEntityCoords(entity)
        local PlayerCoords = GetEntityCoords(player)
        ClearPedTasksImmediately(entity)
        TaskStartScenarioInPlace(entity, "WORLD_COW_GRAZING", 0, true)
        TaskTurnPedToFaceEntity(player, CowCoords, 1200)
        Wait(1300)
        FreezeEntityPosition(entity, true)
        if not IsPedHeadingTowardsPosition(player, CowCoords.xyz, 20.0) then
            TaskTurnPedToFaceCoord(player, CowCoords.xyz, 1500)
            Wait(1500)
        end
        if #(CowCoords.xyz - GetEntityCoords(PlayerPedId())) > 1.5 then
            TaskGoStraightToCoord(player, CowCoords.xyz, 0.5, 1000, 0.0, 0)
            Wait(1100)
        end
        FreezeEntityPosition(player, true)
        Wait(1000)
        EmoteStart({emoteName = "kneel"})
        milkprop =
            CreateObject(
            GetHashKey("prop_bucket_01a"),
            PlayerCoords.x + 0.5,
            PlayerCoords.y,
            PlayerCoords.z,
            0,
            true,
            true,
            true
        )
        PlaceObjectOnGroundProperly(milkprop)
        if progressBar({label = Loc[Config.CoreOptions.Lan].progress["progress_milking"], time = 5000, cancel = true}) then
            Wait(5000)
            TriggerServerEvent("jixel-farming:server:MilkCow")
            TaskStartScenarioInPlace(entity, "WORLD_COW_GRAZING", 0, false)
            Wait(5000)
            FreezeEntityPosition(entity, false)
            TaskWanderInArea(entity, 2257.88, 4928.65, 40.97, 30.0, 2, 10.0)
            EmoteCancel()
            destroyProp(milkprop)
            FreezeEntityPosition(player, false)
            ClearPedTasksImmediately(player)
            milking = false
            print("milking done")
            -- if Config.DebugOptions.Debug == false then
            --     Wait(60000 * AnimalSettings.CollectWaitTime)
            -- else
            --     milking = false
            -- end
        else
            destroyProp(milkprop)
            ClearPedTasks(player)
            killing = false
            triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["cancel"], "error")
        end
    else
        triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["nobucket"], "error")
    end
end

function CollectEggs(entity)
    local basketneeded = Process.ChickenProcess.BasketNeeded
    --local hasbasket = HasItem("emptybasket", 1)
    -- if not collecting then
    --     collecting = true
    -- else
    --     return triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["wait"], "error")
    -- end
    if CollectTimers[entity] and GetGameTimer() < CollectTimers[entity] + AnimalSettings.CollectWaitTime*60000 or collecting then
        triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["wait"], "error") return end
        --if not milking then milking = true else return end
        collecting = true
        CollectTimers[entity] = GetGameTimer()

    if not basketneeded or (basketneeded and hasbasket) then
        local player = PlayerPedId()
        local ChickenCoords = GetEntityCoords(entity)
        local PlayerCoords = GetEntityCoords(player)
        local basketprop = CreateObject(GetHashKey("prop_fruit_basket"), 0, 0, 0, true, true, true)
        ClearPedTasksImmediately(entity)
        TaskStartScenarioInPlace(entity, "WORLD_HEN_PECKING", 0, true)
        TaskTurnPedToFaceEntity(player, ChickenCoords, 1200)
        Wait(1300)
        FreezeEntityPosition(entity, true)
        if not IsPedHeadingTowardsPosition(player, ChickenCoords.xyz, 20.0) then
            TaskTurnPedToFaceCoord(player, ChickenCoords.xyz, 1500)
            Wait(1500)
        end
        if #(ChickenCoords.xyz - GetEntityCoords(PlayerPedId())) > 1.5 then
            TaskGoStraightToCoord(player, ChickenCoords.xyz, 0.5, 1000, 0.0, 0)
            Wait(1100)
        end
        Wait(1000)
        AttachEntityToEntity(
            basketprop,
            player,
            GetPedBoneIndex(PlayerPedId(), 60309),
            0.12,
            0,
            0.30,
            -145.0,
            100.0,
            0.0,
            true,
            true,
            false,
            true,    1, true
        )
        TaskPlayAnim(player, "anim@heists@box_carry@", "idle", 2.0, 2.0, 10000, 46, 0, false, false, false)
        EmoteStart({emoteName = "kneel"})
        FreezeEntityPosition(player, true)
        if
            progressBar(
                {label = Loc[Config.CoreOptions.Lan].progress["progress_eggcollect"], time = 5000, cancel = true}
            )
         then
            Wait(2000)
            TriggerServerEvent("jixel-farming:CollectEggs")
            TaskStartScenarioInPlace(entity, "WORLD_HEN_PECKING", 0, false)
            Wait(5000)
            FreezeEntityPosition(entity, false)
            EmoteCancel()
            destroyProp(basketprop)
            TaskWanderInArea(entity, 2123.99, 5012.06, 41.36, 11.0, 2, 10.0)
            ClearPedTasksImmediately(player)
            FreezeEntityPosition(player, false)
            collecting = false
            -- if Config.DebugOptions.Debug == false then
            --     Wait(60000 * AnimalSettings.CollectWaitTime)
            --     collecting = false
            -- else
            --     collecting = false
            -- end
        else
            destroyProp(basketprop)
            ClearPedTasks(player)
            killing = false
            triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["cancel"], "error")
        end
    else
        triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["nobucket"], "error")
    end
end

function getBucket(amount)
    local ped = PlayerPedId()
    RequestAnimDict("anim@heists@box_carry@")
    Wait(100)
    local milkprop = CreateObject(GetHashKey("prop_bucket_01a"), 0, 0, 0, true, true, true)
    AttachEntityToEntity( milkprop, ped,  GetPedBoneIndex(PlayerPedId(), 60309),  0.12, 0, 0.30,  -145.0, 100.0, 0.0, true, true, false,  true, 1, true)
    TaskPlayAnim(ped, "anim@heists@box_carry@", "idle", 2.0, 2.0, 5000, 51, 0, false, false, false)
    Wait(5000)
    DeleteObject(milkprop)
    TriggerServerEvent("jixel-farming:server:getcowbucket", amount)
end

RegisterNetEvent("jixel-farming:client:SlaughterChicken", function()
        local player = PlayerPedId()
        local Coords = GetEntityCoords(player)
        local effect = "ent_dst_chick_carcass"
        if HasMetaItem("alivechicken", 1) then
            if Config.ScriptOptions.ParticleFXEnabled then
                CreateThread(
                    function()
                        loadPtfxDict("core")
                        UseParticleFxAssetNextCall("core")
                        local particle = StartParticleFxLoopedAtCoord( effect, GetEntityCoords(Coords).x,GetEntityCoords(Coords).y, GetEntityCoords(Coords).z,
                            0.0, 0.0, GetEntityHeading(Coords) - 180.0, 2.5, 0.0, 0.0,  0.0 )
                        Wait(5000)
                        StopParticleFxLooped(particle, true)
                    end )
            end
            if
                progressBar(
                    {
                        label = Loc[Config.CoreOptions.Lan].progress["progress_killing"],
                        time = math.random(4000, 8000),
                        cancel = true,
                        dict = "melee@hatchet@streamed_core_fps",
                        anim = "plyr_front_takedown_b",
                        flag = 8
                    }
                )
             then
                TriggerServerEvent("jixel-farming:KillAnimal", "chickens",0, "alivechicken")
            else
            end
            ClearPedTasks(PlayerPedId())
        else
            triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["nochicken"], "error")
        end
    end
)

RegisterNetEvent("jixel-farming:client:PrepareChicken", function()
        local player = PlayerPedId()
        local Coords = GetEntityCoords(player)
        if HasMetaItem("deadchicken", 1) then
            if
                progressBar(
                    {
                        label = Loc[Config.CoreOptions.Lan].progress["prepare_chicken"],
                        time = math.random(4000, 8000),
                        cancel = true,
                        dict = "melee@hatchet@streamed_core_fps",
                        anim = "plyr_front_takedown_b",
                        flag = 8
                    }
                )
             then
                TriggerServerEvent("jixel-farming:server:toggleItem", false, "deadchicken")
                TriggerServerEvent("jixel-farming:server:toggleItem", true, "rawchicken")
            else
            end
            ClearPedTasks(PlayerPedId())
        else
            triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["nochicken"], "error")
        end
    end)


RegisterNetEvent('jixel-farming:client:CowGameMenu', function(data)
    local GameMenu = {}
    if Config.CoreOptions.Menu ~= "ox" then
        GameMenu[#GameMenu + 1] = { icon = "fas fa-tractor", header = Loc[Config.CoreOptions.Lan].menu["job_header"], isMenuHeader = true, }
		GameMenu[#GameMenu + 1] = { icon = "fas fa-circle-xmark", header = Loc[Config.CoreOptions.Lan].menu["close"], params = { event = "qb-menu:client:closeMenu" } }
    end
	GameMenu[#GameMenu + 1] = {
            icon = "fas fa-car-tunnel",
            header = Loc[Config.CoreOptions.Lan].menu["start_job"],
            title = Loc[Config.CoreOptions.Lan].menu["start_job"],
			event = "jixel-farming:client:payForAnimal",
			args = { animalType = "cows", speed = 1.15, price = AnimalSettings.Cow.Price }, -- The chosen stop amount will be passed as an argument
            params = { event = "jixel-farming:client:payForAnimal", args = { animalType = "cows", speed = 1.15, jobDifficulty = "easy", price = AnimalSettings.Cow.Price } } -- The chosen stop amount will be passed as an argument
	}
    if Config.CoreOptions.Menu == "ox" then
        exports.ox_lib:registerContext({ id = 'CowsGameMenu', title = "Cows Game Menu", position = 'top-right', options = GameMenu })
        exports.ox_lib:showContext("CowsGameMenu")
    else
        exports['qb-menu']:openMenu(GameMenu)
    end
end)
RegisterNetEvent('jixel-farming:client:ChickyGameMenu', function(data)
    local GameMenu = {}
    if Config.CoreOptions.Menu ~= "ox" then
        GameMenu[#GameMenu + 1] = { icon = "fas fa-tractor", header = Loc[Config.CoreOptions.Lan].menu["job_header"], isMenuHeader = true, }
		GameMenu[#GameMenu + 1] = { icon = "fas fa-circle-xmark", header = Loc[Config.CoreOptions.Lan].menu["close"], params = { event = "qb-menu:client:closeMenu" } }
    end
	GameMenu[#GameMenu + 1] = {
            icon = "fas fa-car-tunnel",
            header = Loc[Config.CoreOptions.Lan].menu["start_job"],
            title = Loc[Config.CoreOptions.Lan].menu["start_job"],
			event = "jixel-farming:client:payForAnimal",
			args = { animalType = "chickens", speed = 0 , price = AnimalSettings.Chickens.Price }, -- The chosen stop amount will be passed as an argument
            params = { event = "jixel-farming:client:payForAnimal", args = { animalType = "chickens", speed = 0, jobDifficulty = "easy", price = AnimalSettings.Chickens.Price } } -- The chosen stop amount will be passed as an argument
	}
    if Config.CoreOptions.Menu == "ox" then
        exports.ox_lib:registerContext({ id = 'ChickyGameMenu', title = "Chicky Game Menu", position = 'top-right', options = GameMenu })
        exports.ox_lib:showContext("ChickyGameMenu")
    else
        exports['qb-menu']:openMenu(GameMenu)
    end
end)

RegisterNetEvent('jixel-farming:client:PigGameMenu', function(data)
    local GameMenu = {}
    if Config.CoreOptions.Menu ~= "ox" then
        GameMenu[#GameMenu + 1] = { icon = "fas fa-tractor", header = Loc[Config.CoreOptions.Lan].menu["job_header"], isMenuHeader = true, }
		GameMenu[#GameMenu + 1] = { icon = "fas fa-circle-xmark", header = Loc[Config.CoreOptions.Lan].menu["close"], params = { event = "qb-menu:client:closeMenu" } }
    end
	GameMenu[#GameMenu + 1] = {
            icon = "fas fa-car-tunnel",
            header = Loc[Config.CoreOptions.Lan].menu["start_job"],
            title = Loc[Config.CoreOptions.Lan].menu["start_job"],
            event = "jixel-farming:client:payForAnimal",
            args = { animalType = "pigs", speed = 1.15, price = AnimalSettings.Pigs.Price }, -- The chosen stop amount will be passed as an argument
            params = { event = "jixel-farming:client:payForAnimal", args = { animalType = "pigs", speed = 1.15, price = AnimalSettings.Pigs.Price } } -- The chosen stop amount will be passed as an argument
	}

    if Config.CoreOptions.Menu == "ox" then
        exports.ox_lib:registerContext({ id = 'PigGameMenu', title = "Pig Game Menu", position = 'top-right', options = GameMenu })
        exports.ox_lib:showContext("PigGameMenu")
    else
        exports['qb-menu']:openMenu(GameMenu)
    end
end)

RegisterNetEvent('jixel-farming:client:payForAnimal', function(data)
    if Midnight.Functions.IsNightTime() then QBCore.Functions.Notify('It\'s too late right now! Come back when it\'s daytime...') return end
    local alert = exports.ox_lib:alertDialog({
        header = 'Pay for your meat!',
        content = 'Catching these animals will cost you $'..data.price..'.\nDo you want to proceed?',
        centered = true,
        cancel = true
    })
    if alert ~= "confirm" then return end
    QBCore.Functions.TriggerCallback('jixel-farming:server:payForAnimal', function(paid)
        if not paid then QBCore.Functions.Notify('You don\'t have enough money to do this!') return end
        TriggerEvent("jixel-farming:client:StartSlaughterRun", data)
    end, data.price)
end)

--not in use (skipped)
RegisterNetEvent('jixel-farming:client:StartSlaughterRun:SubMenu:Pigs', function(data)
	local JobDifficulty = {
        {
            label = "easy",
			speed = 1.15,
        },
        {
            label = "medium",
			speed = 5.0,
        },
        {
            label = "hard",
            speed = 10.0,
        }
    }
    local GameMenu = {}
    if Config.CoreOptions.Menu ~= "ox" then
        GameMenu[#GameMenu + 1] = { icon = "fas fa-tractor", header = Loc[Config.CoreOptions.Lan].menu["job_header"], isMenuHeader = true, }
		GameMenu[#GameMenu + 1] = { icon = "fas fa-circle-xmark", header = Loc[Config.CoreOptions.Lan].menu["close"], params = { event = "qb-menu:client:closeMenu" } }
    end
	for _ , jobDifficulty in ipairs(JobDifficulty) do
        GameMenu[#GameMenu + 1] = {
            icon = "fas fa-car-tunnel",
            header = Loc[Config.CoreOptions.Lan].menu["job_size"] .. " [" .. jobDifficulty.label .. "]",
            title = Loc[Config.CoreOptions.Lan].menu["job_size"] .. " [" .. jobDifficulty.label .. "]",
            event = "jixel-farming:client:StartSlaughterRun",
            args = { animalType = "pigs", speed = jobDifficulty.speed }, -- The chosen stop amount will be passed as an argument
            params = { event = "jixel-farming:client:StartSlaughterRun", args = { animalType = "pigs", speed = jobDifficulty.speed, jobDifficulty = jobDifficulty.label } } -- The chosen stop amount will be passed as an argument
        }
    end
    if Config.CoreOptions.Menu == "ox" then
        exports.ox_lib:registerContext({ id = 'PiggyGameSubMenu', title = "Piggy Game Sub Menu", position = 'top-right', options = GameMenu })
        exports.ox_lib:showContext("PiggyGameSubMenu")
    else
        exports['qb-menu']:openMenu(GameMenu)
    end
end)

AddEventHandler("onResourceStop", function(r)
        if r ~= GetCurrentResourceName() then
            return
        end
        AnimalsAlive = {}
        for _, v in pairs(Props) do
            unloadModel(GetEntityModel(v))
            DeleteObject(v)
        end
        for k in pairs(Targets) do
            exports["qb-target"]:RemoveZone(k)
        end
        for _, v in pairs(Config.CowSetup) do
            if DoesEntityExist(v.handle) then
                DeleteEntity(v.handle)
            end
        end
        for _, v in pairs(Config.EggSetup) do
            if DoesEntityExist(v.handle) then
                DeleteEntity(v.handle)
            end
        end
        exports[Config.CoreOptions.CoreName]:HideText()
    end)
