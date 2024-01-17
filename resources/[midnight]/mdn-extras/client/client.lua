local QBCore = exports['qb-core']:GetCoreObject()
local StarterPed
local locBlip

-- Get Time
RegisterCommand('time', function() QBCore.Functions.Notify("Current Time : "..GetClockHours()..":"..GetClockMinutes()) end)

-- Radio Clicks
RegisterNetEvent('mdn-extras:client:radioclicks', function(toggle) exports["pma-voice"]:setVoiceProperty("micClicks", toggle) end)

-- Boat Anchor
RegisterCommand("anchor", function()
    local plyPed = PlayerPedId()
    local plyCoords = GetEntityCoords(plyPed)

    if IsPedInAnyBoat(plyPed) then
        local boat = GetVehiclePedIsIn(plyPed, false)

        if GetEntitySpeed(boat) >= 5 then
            QBCore.Functions.Notify('you are going way to fast!', 'error')
            return
        end

        if IsBoatAnchoredAndFrozen(boat) then
            SetBoatAnchor(boat, false)
            SetBoatFrozenWhenAnchored(boat, false)
            QBCore.Functions.Notify('anchor detached!', 'success')
        else
            SetBoatAnchor(boat, true)
            SetBoatFrozenWhenAnchored(boat, true)

            QBCore.Functions.Notify('anchor attached!', 'success')
        end
    else
        QBCore.Functions.Notify('you are not in a boat!', 'error')
    end
end, false)

---------------
-- Roll Dice --
---------------

local displayCount = 1
local function DrawText3D(x,y,z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 370
		DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 100)
    end
end

local function CreateRollString(rollTable, sides)
    local s = "Roll: "
    local total = 0
    for k, roll in pairs(rollTable) do
        total = total + roll
        if k == 1 then
            s = s .. roll .. "/" .. sides
        else
            s = s .. " | " .. roll .. "/" .. sides
        end
    end
    s = s .. " | (Total: "..total..")"
    return s
end

local function ShowRoll(text, sourcePlayer, maxDistance, offset)
    local display = true
    CreateThread(function()
        Wait(7000)
        display = false
    end)

    CreateThread(function()
        displayCount = displayCount + 1
        while display do
            Wait(7)
            local sourcePos = GetEntityCoords(GetPlayerPed(sourcePlayer), false)
            local pos = GetEntityCoords(PlayerPedId(), false)
            if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < maxDistance) then
                DrawText3D(sourcePos.x, sourcePos.y, sourcePos.z + offset - 1.25, text)
            end
        end
        displayCount = displayCount - 1
    end)
end

RegisterNetEvent("fs-diceroll:client:roll", function(sourceId, maxDinstance, rollTable, sides)
    local rollString = CreateRollString(rollTable, sides)
    local offset = 1 + (displayCount*0.2)
    RequestAnimDict("anim@mp_player_intcelebrationmale@wank")
    while (not HasAnimDictLoaded("anim@mp_player_intcelebrationmale@wank")) do
        Wait(0)
    end
    TaskPlayAnim(GetPlayerPed(GetPlayerFromServerId(sourceId)), "anim@mp_player_intcelebrationmale@wank" ,"wank" ,8.0, -8.0, -1, 49, 0, false, false, false )
    Wait(2400)
    ClearPedTasks(GetPlayerPed(GetPlayerFromServerId(sourceId)))
    ShowRoll(rollString, GetPlayerFromServerId(sourceId), maxDinstance, offset)
end)

-----------
-- Utils --
-----------

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

function LoadPfxAsset(Asset)
    while not HasNamedPtfxAssetLoaded(Asset) do
        RequestNamedPtfxAsset(Asset)
        Wait(50)
    end
end

--- Makes Food relating to a certain difficulty
---@param item string Food item being made
---@param action? table Table containing progressbar actions (with keys) {controlDisables, animation, prop, prop2}
---@param dirChangeChance? number Chance for the block to change directions | 0.96 - 1.0
---@param pointerSpeed? number Speed at which the pointer moves
---@param totalTime? integer Total time to make the food
---@param halfThreshold? integer % needed for "half" status | 0-100
---@param upSpeed? number Speed at which progress go up | 0.0-1.0
---@param downSpeed? number Speed at which progress go down when not on the block | 0.0 - 1.0
---@param blockSpeed? number Speed at which the block moves | 0.0-1.0
---@return any result NUMBER | Final progress %, 100 if completed.
local MakeFood = function(item, action, dirChangeChance, pointerSpeed, totalTime, halfThreshold, upSpeed, downSpeed, blockSpeed)
    local p = promise.new()
    local sdata =  {difficultyFactor = dirChangeChance or 0.98, lineSpeedUp = pointerSpeed or 1, time = totalTime or 30, halfSuccessMin = halfThreshold or 100,
    valueUpSpeed = upSpeed or 0.5, valueDownSpeed = downSpeed or 0.3, areaMoveSpeed = blockSpeed or 0.5, img = "nui://ps-inventory/html/images/"..QBCore.Shared.Items[item or 'orange'].image}
    exports['nakres_skill']:GetMiniGame().Start(sdata, action, function(progress) p:resolve(progress) end)
    return p
end exports('MakeFood', MakeFood)

-------------------------
-- Disable Idle Camera --
-------------------------

-- -- Camera initialization code
Citizen.CreateThread(function()
    DisableIdleCamera(true)
end)

RegisterNetEvent('mdn-extras:c:getPlushie', function() TriggerServerEvent('mdn-extras:s:getPlushie') end)
-----
RegisterCommand('stockShop', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "cigarettemachine", { maxweight = 5000, slots = 1, })
    TriggerEvent("inventory:client:SetCurrentStash", "cigarettemachine")
end)

RegisterCommand('openShop', function()
    QBCore.Functions.TriggerCallback('qb-inventory:server:GetStashItems', function(items)
        print(items)
        if items[1] and items[1].name == "cigarette_pack" then
            TriggerServerEvent("inventory:server:OpenInventory", "shop", "Cigarette Machine", {
                label = "Cigarette Machine",
                slots = 1,
                items = {
                    [1] = {
                        name = "cigarette_pack",
                        price = 100,
                        amount = items[1].amount,
                        info = {},
                        type = "item",
                        slot = 1,
                    },
                }
            })
        end
    end, 'cigarettemachine')
end)


