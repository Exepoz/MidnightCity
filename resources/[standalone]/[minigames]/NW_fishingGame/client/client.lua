CreateThread(function()
    SendNUIMessage({ --these are just the text in the ui. head over to the config file to easily swap these
        type = "setLocale",
        hook = Config.locale["hook"],
        success = Config.locale["success"],
        fail = Config.locale["fail"],
        gotaway = Config.locale["got_away2"],
        fishon = Config.locale["fish_on"],
        toosoon = Config.locale["too_soon"],
    })
end)

uiOpen = false
isReeling = false
value = nil
isItOver = false
reelingProgress = 0

local currentDiff = nil
local startingDiff = nil


local difficulty = Config.difficulty



function DisableControls()
    CreateThread(function()
        while uiOpen do
            Wait(0)
            DisableControlAction(0, 24, true)
        end
    end)
end

function fishingGameStart(diff) --"easy", "medium", "hard"
    currentDiff = diff or "medium"
    startingDiff = currentDiff
    SendNUIMessage({
        type = "updateDifficulty",
        tensionIncrease = math.random(difficulty[currentDiff].tensionIncrease.min,difficulty[currentDiff].tensionIncrease.max),
        tensionDecrease = math.random(difficulty[currentDiff].tensionDecrease.min,difficulty[currentDiff].tensionDecrease.max),
        progressIncrease = math.random(difficulty[currentDiff].progressIncrease.min,difficulty[currentDiff].progressIncrease.max),
        progressDecrease = math.random(difficulty[currentDiff].progressDecrease.min,difficulty[currentDiff].progressDecrease.max),
    })
    Wait(250)
    reelingProgress = 0
    uiOpen = true
    isItOver = false
    SetNuiFocus(true, false)
    SetNuiFocusKeepInput(true)
    DisableControls()
    local ply = PlayerPedId()
    local plyCords = GetEntityCoords(ply)
    local fishcoords = GetOffsetFromEntityInWorldCoords(ply, 0.0, 15.0, 0.0) -- 15.0 is the distance from the player that the ui starts
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(fishcoords.x, fishcoords.y, fishcoords.z)
    local dist = #(plyCords - fishcoords)
    local savedcord = nil
    SendNUIMessage({
        type = "start",
        x = _x,
        y = _y,
    });
    while uiOpen do
        Wait(10)
        local progresscords = GetOffsetFromEntityInWorldCoords(ply, 0, (dist - (dist * (reelingProgress / 100))) + 1,-0.5)
        if not isItOver then
            savedcord = progresscords
            Draw3dNUI(progresscords)
        else
            Draw3dNUI(savedcord)
        end
    end
    return value --value returned here is pass or fail true/false
end

exports("fishingGameStart", fishingGameStart)

RegisterNetEvent('nuifalse', function()
    cancelGame()
end)

function cancelGame()
    uiOpen = false
    value = nil
    SendNUIMessage({
        type = "close",
    })
    Wait(100)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
end

exports("cancelGame", cancelGame)

function DiffChanger()
    local difficultyTransitions = {
        easy = { easy = "medium", medium = "easy" },
        medium = { easy = "hard", medium = "medium", hard = "easy" },
        hard = { medium = "medium", hard = "medium" }
    }

    local function getNextDifficulty()
        local transition = difficultyTransitions[startingDiff][currentDiff]
        if transition == "medium" then
            return math.random(1, 2) == 1 and "hard" or "easy"
        else
            return transition
        end
    end

    local function updateDifficulty()
        SendNUIMessage({
            type = "updateDifficulty",
            tensionIncrease = math.random(difficulty[currentDiff].tensionIncrease.min,difficulty[currentDiff].tensionIncrease.max),
            tensionDecrease = math.random(difficulty[currentDiff].tensionDecrease.min,difficulty[currentDiff].tensionDecrease.max),
            progressIncrease = math.random(difficulty[currentDiff].progressIncrease.min,difficulty[currentDiff].progressIncrease.max),
            progressDecrease = math.random(difficulty[currentDiff].progressDecrease.min,difficulty[currentDiff].progressDecrease.max),
        })
    end

    CreateThread(function()
        while isReeling do
            Wait(math.random(12000, 15000))
            currentDiff = getNextDifficulty()
            updateDifficulty()
        end
    end)
end

RegisterCommand("testfishinggame",function(source, args, rawCommand) --remove this before putting in your live server. this is for testing purposes
    local success = exports["NW_fishingGame"]:fishingGameStart(args[1]) --will return true or false if the game is passed or not
    if success then
        --passed fishing game. reward fish here
        print("SUCCESS")
    else
        --failed fishing game do something else
        print("FAIL")
    end
end, false)
