local huntingrifle = Config.Huntingrifle

local hasHuntingRifle = false
local isFreeAiming = false
local blockShotActive = false

--- Localise Functions

local Wait = Wait
local GetEntityPlayerIsFreeAimingAt = GetEntityPlayerIsFreeAimingAt
local IsPlayerFreeAiming = IsPlayerFreeAiming
local GetEntityType = GetEntityType
local IsPedAPlayer = IsPedAPlayer
local IsPedInAnyVehicle = IsPedInAnyVehicle
local DisableControlAction = DisableControlAction
local DisablePlayerFiring = DisablePlayerFiring

--- Functions

local function aimBlock()
    if blockShotActive then return end

    blockShotActive = true

    CreateThread(function()
        while hasHuntingRifle do
            Wait(0)

            local player = cache.playerId
            local entity = nil
            local aiming, entity = GetEntityPlayerIsFreeAimingAt(player)
            local freeAiming = IsPlayerFreeAiming(player)
            local type = GetEntityType(entity)

            if not freeAiming or IsPedAPlayer(entity) or type == 2 or (type == 1 and IsPedInAnyVehicle(entity)) then
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 47, true)
                DisableControlAction(0, 58, true)
                DisablePlayerFiring(cache.ped, true)
            end
        end

        blockShotActive = false
    end)
end

--- Threads

lib.onCache('weapon', function(value)
    if value == huntingrifle then
        hasHuntingRifle = true
        aimBlock()
    else
        hasHuntingRifle = false
    end
end)
