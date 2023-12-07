-- World Wreck on Generation Event
-- if enabled for the scenario, This event gets triggered when the player first receives the world wreck information.
---@param wwType string - Current World Wreck type/scenario
---@param wwCoords any - World Wreck Coords
function WorldWreckOnGenerationEvent(wwType, wwCoords)
    if not Config.WorldWrecks[GlobalState.CRSalvage.WorlWreckType].onGenerationEvent then return end
    if wwType == "plane" then
        print("You hear a big explosion in the distance!")
    elseif wwType == "AnotherScenario" then -- Change me
        print("You can setup whatever you want.") -- Change me
        print("Coords are available | "..wwCoords)
    end
end

-- World Wreck on Spawn Event
-- if enabled for the scenario, This function gets triggered when the player gets close enough.
-- GlobalState.CRSalvage.isSpawnEventThere can be used if you want to dynamically control if the event happens when the player get close.
---@param WorldWreck integer - Entity ID of the spawned World Wreck
---@param WorldWreckCoords any - World Wreck Coords
function WorldWreckOnSpawnEvent(WorldWreck, WorldWreckCoords)
    TriggerServerEvent('cr-salvage:server:WorldWreckSpawnEvent')
    if not Config.WorldWrecks[GlobalState.CRSalvage.WorlWreckType].onSpawnEvent then return end
    if GlobalState.CRSalvage.WorlWreckType == "plane" and GlobalState.CRSalvage.isSpawnEventThere then
        if Config.Debug then print(Lcl('debug_spawningFlightBox')) end
        LoadModel(Config.FlightBox.Hash)
        local FlightBox = GetClosestObjectOfType(WorldWreckCoords.xyz, 60.0, Config.FlightBox.Hash, 0, 0, 0)
        if not FlightBox or FlightBox == 0 then
            local Xoffset = math.random(-15, 15) + 0.5 local Yoffset = math.random(10, 25) + 0.5
            local coords = GetOffsetFromEntityInWorldCoords(WorldWreck, Xoffset, Yoffset, 10.0)
            Wait(1000)
            FlightBox = CreateObject(Config.FlightBox.Hash, coords.xyz, true, true, false)
            local exists, Zcoords
            exists, Zcoords = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, false)
            while not exists do
                exists, Zcoords = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, true)
                Wait(0)
            end
            SetEntityCoords(FlightBox, coords.x, coords.y, Zcoords+0.1)
            FreezeEntityPosition(FlightBox, true)
            if Config.Debug then print(Lcl('debug_flightboxSpawned', GetEntityCoords(FlightBox), FlightBox)) end
        end
        WWSpawnEventTarget(FlightBox)
    elseif GlobalState.CRSalvage.WorlWreckType == "AnotherScenario" then -- Change me
        print("You can setup whatever you want.") -- Change me
        print("Coords are available | "..WorldWreckCoords) -- Change me
    end
end

-- On SkillCheck Success Event
---@param world boolean - true if wreck harvested is a world wreck
local function SkillCheckSuccess(world)
    if Config.SkillCheck.Behaviour.Type == "bonusrolls" then
        TriggerServerEvent('cr-salvage:server:getScrapLoot', true, world)
		-- If Arg#1 is true, gives bonus rolls on loot
		-- Arg#2 is if the wreck is the 'world wreck' / crashed wreckage. 
    else
        TriggerServerEvent('cr-salvage:server:getScrapLoot', false, world)
    end
end

-- On SkillCheck Failure Event
---@param world boolean - true if wreck harvested is a world wreck
local function SkillCheckFailed(world)
    if Config.SkillCheck.Behaviour.Type == "break" then
        local chance = math.random(100)
        StopSalvage() -- Makes the player stop salvaging
        if chance <= Config.SkillCheck.Behaviour.BreakSettings.ChanceOfBreaking then
            TriggerServerEvent('cr-salvage:server:BreakSaw') -- Breaks the powersaw and replaces it with a bladeless powersaw
        end
    elseif Config.SkillCheck.Behaviour.Type == "bonusrolls" then
        TriggerServerEvent('cr-salvage:server:getScrapLoot', false, world)
    elseif Config.SkillCheck.Behaviour.Type == "stop" then
        SCUtils.SalvageNotif(2, Lcl('notif_sawjammed'), Lcl('salvagetitle'))
        StopSalvage()
    end
end

-- SkillCheck Event
---@param world boolean - true if wreck harvested is a world wreck
function SalvageSkillCheck(world)
    exports['ps-ui']:Circle(function(success)
        if success then
            SkillCheckSuccess(world)
        else
            SkillCheckFailed(world)
        end
    end, math.random(Config.SkillCheck.Repetition.min, Config.SkillCheck.Repetition.max), math.random(Config.SkillCheck.Duration.min, Config.SkillCheck.Duration.max))
end

-- Key Disableing
---@param bool boolean - When true, disables configured keys
-- Loops every tick while player is salvaging. Works in conjunction with IsPlayerBusy Export.
function CRDisableControls(bool)
    for _, v in pairs(Config.ControlsDisabled) do
        DisableControlAction(0, v, bool)
    end
end