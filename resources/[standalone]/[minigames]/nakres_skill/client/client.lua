local QBCore = exports['qb-core']:GetCoreObject()


successFunc, failFunc, halfFunc = nil, nil, nil
func = nil
miniGame = {
    Active = false,
}

local Action = {
    name = '',
    duration = 0,
    label = '',
    useWhileDead = false,
    canCancel = true,
    disarm = true,
    controlDisables = {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = false,
    },
    animation = {
        animDict = nil,
        anim = nil,
        flags = 0,
        task = nil,
    },
    prop = {
        model = nil,
        bone = nil,
        coords = vec3(0.0, 0.0, 0.0),
        rotation = vec3(0.0, 0.0, 0.0),
    },
    propTwo = {
        model = nil,
        bone = nil,
        coords = vec3(0.0, 0.0, 0.0),
        rotation = vec3(0.0, 0.0, 0.0),
    },
}

local isDoingAction = false
local wasCancelled = false
local prop_net = nil
local propTwo_net = nil
local isAnim = false
local isProp = false
local isPropTwo = false

local controls = {
    disableMouse = { 1, 2, 106 },
    disableMovement = { 30, 31, 36, 21, 75 },
    disableCarMovement = { 63, 64, 71, 72 },
    disableCombat = { 24, 25, 37, 47, 58, 140, 141, 142, 143, 263, 264, 257 }
}

-- Functions

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(5)
    end
end

local function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(5)
    end
end

local function createAndAttachProp(prop, ped)
    loadModel(prop.model)
    local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 0.0)
    local propEntity = CreateObject(GetHashKey(prop.model), coords.x, coords.y, coords.z, true, true, true)
    local netId = ObjToNet(propEntity)
    SetNetworkIdExistsOnAllMachines(netId, true)
    NetworkUseHighPrecisionBlending(netId, true)
    SetNetworkIdCanMigrate(netId, false)
    local boneIndex = GetPedBoneIndex(ped, prop.bone or 60309)
    AttachEntityToEntity(
        propEntity, ped, boneIndex,
        prop.coords.x, prop.coords.y, prop.coords.z,
        prop.rotation.x, prop.rotation.y, prop.rotation.z,
        true, true, false, true, 0, true
    )
    return netId
end

local function disableControls()
    CreateThread(function()
        while isDoingAction do
            for disableType, isEnabled in pairs(Action.controlDisables) do
                if isEnabled and controls[disableType] then
                    for _, control in ipairs(controls[disableType]) do
                        DisableControlAction(0, control, true)
                    end
                end
            end
            if Action.controlDisables.disableCombat then
                DisablePlayerFiring(PlayerId(), true)
            end
            Wait(0)
        end
    end)
end

local function StartActions()
    local ped = PlayerPedId()
    if isDoingAction then
        if not isAnim and Action.animation then
            if Action.animation.task then
                TaskStartScenarioInPlace(ped, Action.animation.task, 0, true)
            else
                local anim = Action.animation
                if anim.animDict and anim.anim and DoesEntityExist(ped) and not IsEntityDead(ped) then
                    loadAnimDict(anim.animDict)
                    TaskPlayAnim(ped, anim.animDict, anim.anim, 3.0, 3.0, -1, anim.flags or 1, 0, false, false, false)
                end
            end
            isAnim = true
        end
        if not isProp and Action.prop and Action.prop.model then
            prop_net = createAndAttachProp(Action.prop, ped)
            isProp = true
        end
        if not isPropTwo and Action.propTwo and Action.propTwo.model then
            propTwo_net = createAndAttachProp(Action.propTwo, ped)
            isPropTwo = true
        end
        disableControls()
    end
end

local function ActionCleanup()
    local ped = PlayerPedId()
    if Action.animation then
        if Action.animation.task or (Action.animation.animDict and Action.animation.anim) then
            ClearPedSecondaryTask(ped)
            StopAnimTask(ped, Action.animDict, Action.anim, 1.0)
        else
            ClearPedTasks(ped)
        end
    end
    if prop_net then
        DetachEntity(NetToObj(prop_net), true, true)
        DeleteObject(NetToObj(prop_net))
    end
    if propTwo_net then
        DetachEntity(NetToObj(propTwo_net), true, true)
        DeleteObject(NetToObj(propTwo_net))
    end
    prop_net = nil
    propTwo_net = nil
    isDoingAction = false
    wasCancelled = false
    isAnim = false
    isProp = false
    isPropTwo = false
    LocalPlayer.state:set('inv_busy', false, true)
    Action = {
        name = '',
        duration = 0,
        label = '',
        useWhileDead = false,
        canCancel = true,
        disarm = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = false,
        },
        animation = {
            animDict = nil,
            anim = nil,
            flags = 0,
            task = nil,
        },
        prop = {
            model = nil,
            bone = nil,
            coords = vec3(0.0, 0.0, 0.0),
            rotation = vec3(0.0, 0.0, 0.0),
        },
        propTwo = {
            model = nil,
            bone = nil,
            coords = vec3(0.0, 0.0, 0.0),
            rotation = vec3(0.0, 0.0, 0.0),
        },
    }
end

miniGame.Start = function(data, action, funct)
    QBCore.Debug(Action)
    if not miniGame.Active then
        if not action then action = Action
        else
            action.controlDisables = action.controlDisables or Action.controlDisables
            action.animation = action.animation or Action.animation
            action.prop = action.prop or Action.prop
            action.propTwo = action.propTwo or Action.propTwo
        end
        isDoingAction = true
        Action = action
        displayMinigame(data);
        if action then StartActions() end
        func = funct or function() end;
        -- successFunc = scFunc and scFunc or function() end;
        -- failFunc = flFunc and flFunc or function() end;
        -- halfFunc = halfscFunc and halfscFunc or function() end;
    else
        print('Zaten birşeylerle meşgulsün')
    end
end


miniGame.Stop = function()
    ActionCleanup()
    displayMinigame()
end

function displayMinigame(data)
    miniGame.Active = not miniGame.Active;
    SetNuiFocus(miniGame.Active, miniGame.Active);
    if miniGame.Active then
        SendNUIMessage({
            type = "start",
            data = data,
        })
    else
        SendNUIMessage({
            type = "stop",
        })
    end
end

RegisterNUICallback('endGame', function(value)
    miniGame.Stop();
    ActionCleanup()
    func(value)
end)

function GetMiniGame()
    return miniGame
end

exports("GetMiniGame", GetMiniGame)