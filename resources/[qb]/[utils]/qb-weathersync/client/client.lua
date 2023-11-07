local CurrentWeather = Config.StartWeather
local lastWeather = CurrentWeather
local baseTime = Config.BaseTime
local timeOffset = Config.TimeOffset
local timer = 0
local freezeTime = Config.FreezeTime
local blackout = Config.Blackout
local blackoutVehicle = Config.BlackoutVehicle
local disable = Config.Disabled
local freezeTimer, freezeWeather, freezeRain = {18, 0, 0}, 'CLEAR', 0.0
local pause = false


RegisterCommand('getms', function()
    print(GetMillisecondsPerGameMinute())
end)

-- RegisterCommand('setms', function()
--     print(SetMillisecondsPerGameMinute())
-- end)

GetCurrentFreeze = function()
    return freezeTimer, freezeWeather, freezeRain
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    disable = false
    TriggerServerEvent('qb-weathersync:server:RequestStateSync')
end)

RegisterNetEvent('qb-weathersync:client:EnableSync', function()
    disable = false
    TriggerServerEvent('qb-weathersync:server:RequestStateSync')
end)

function getPause() return pause end

RegisterNetEvent('qb-weathersync:client:DisableSync', function(time, weather, u)
    if disable and not u then return end
    if not time then time = {18, 0, 0} end
    if not weather then weather = "CLEAR" end
    local rL = weather == "RAIN" and 0.3 or weather == "THUNDER" and 0.5 or 0.0
    if not disable then freezeTimer = time freezeWeather = weather freezeRain = rL
    elseif disable and u then
        pause = true
        freezeTimer = time freezeWeather = weather freezeRain = rL
        SetWeatherTypeOverTime(freezeWeather, 15.0)
        SetRainLevel(freezeRain)
        Wait(15000)
        pause = false
        return end
	disable = true
	CreateThread(function()
        -- local t,w,r
		while disable do
            if not pause then
                SetRainLevel(freezeRain)
                SetWeatherTypePersist(freezeWeather)
                SetWeatherTypeNow(freezeWeather)
                SetWeatherTypeNowPersist(freezeWeather)
                NetworkOverrideClockTime(freezeTimer[1], freezeTimer[2], freezeTimer[3])
            end
			Wait(5000)
		end
	end)
end)

RegisterNetEvent('qb-weathersync:client:DisableSyncOilRig', function()
    disable = true
    CreateThread(function()
        while disable do
            SetRainLevel(1.0)
            SetWeatherTypePersist('RAIN')
            SetWeatherTypeNow('RAIN')
            SetWeatherTypeNowPersist('RAIN')
            NetworkOverrideClockTime(23, 0, 0)
            Wait(5000)
        end
    end)
end)

RegisterNetEvent('qb-weathersync:client:SyncWeather', function(NewWeather, newblackout)
    CurrentWeather = NewWeather
    blackout = newblackout
end)

RegisterNetEvent('qb-weathersync:client:SyncTime', function(base, offset, freeze)
    freezeTime = freeze
    timeOffset = offset
    baseTime = base
end)

CreateThread(function()
    while true do
        if not disable then
            if lastWeather ~= CurrentWeather then
                lastWeather = CurrentWeather
                SetWeatherTypeOverTime(CurrentWeather, 15.0)
                Wait(15000)
            end
            Wait(100) -- Wait 0 seconds to prevent crashing.
            SetArtificialLightsState(blackout)
            SetArtificialLightsStateAffectsVehicles(blackoutVehicle)
            ClearOverrideWeather()
            ClearWeatherTypePersist()
            SetWeatherTypePersist(lastWeather)
            SetWeatherTypeNow(lastWeather)
            SetWeatherTypeNowPersist(lastWeather)
            if lastWeather == 'XMAS' then
                SetForceVehicleTrails(true)
                SetForcePedFootstepsTracks(true)
            else
                SetForceVehicleTrails(false)
                SetForcePedFootstepsTracks(false)
            end
            if lastWeather == 'RAIN' then
                SetRainLevel(0.3)
            elseif lastWeather == 'THUNDER' then
                SetRainLevel(0.5)
            else
                SetRainLevel(0.0)
            end
        else
            Wait(1000)
        end
    end
end)

-- for 10 real life minutes, 1 hour in game should pass
-- for 1 real life minute, 60000, 6 minutes should pass in game
-- for 10 real life seconds, 1 minute should pas in game
CreateThread(function()
    SetMillisecondsPerGameMinute(10000)
    local hour
    local minute = 0
    local second = 0        --Add seconds for shadow smoothness
    while true do
        if not disable then
            Wait(0)
            local newBaseTime = baseTime
            if GetGameTimer() - 152  > timer then    --Generate seconds in client side to avoid communiation
                second = second + 1                 --Minutes are sent from the server every 2 seconds to keep sync
                timer = GetGameTimer()
            end
            if freezeTime then
                timeOffset = timeOffset + baseTime - newBaseTime
                second = 0
            end
            baseTime = newBaseTime
            hour = math.floor(((baseTime+timeOffset)/60)%24)
            if minute ~= math.floor((baseTime+timeOffset)%60) then  --Reset seconds to 0 when new minute
                minute = math.floor((baseTime+timeOffset)%60)
                second = 0
            end
            print(hour,minute,second)
            NetworkOverrideClockTime(hour, minute, second)          --Send hour included seconds to network clock time
        else
            Wait(1000)
        end
    end
end)

-- -- 4 second cycle
-- CreateThread(function()
--     SetMillisecondsPerGameMinute(4000)
--     local hour
--     local minute = 0
--     local second = 0        --Add seconds for shadow smoothness
--     while true do
--         if not disable then
--             Wait(0)
--             local newBaseTime = baseTime
--             if GetGameTimer() - 59  > timer then    --Generate seconds in client side to avoid communiation
--                 second = second + 1                 --Minutes are sent from the server every 2 seconds to keep sync
--                 timer = GetGameTimer()
--             end
--             if freezeTime then
--                 timeOffset = timeOffset + baseTime - newBaseTime
--                 second = 0
--             end
--             baseTime = newBaseTime
--             hour = math.floor(((baseTime+timeOffset)/60)%24)
--             if minute ~= math.floor((baseTime+timeOffset)%60) then  --Reset seconds to 0 when new minute
--                 minute = math.floor((baseTime+timeOffset)%60)
--                 second = 0
--             end
--             print(hour, minute, second)
--             NetworkOverrideClockTime(hour, minute, second)          --Send hour included seconds to network clock time
--         else
--             Wait(1000)
--         end
--     end
-- end)
