local MinigameActive = false
local Result = nil

-- RegisterCommand('testhack', function()
--     local success = Begin(3, 5000)
-- end)

Begin = function(icons, time)
    if MinigameActive then return end

    if LocalPlayer.state.foodBuff == 'hacking' then
        exports['mdn-nighttime']:Notify('You feel more focused...')
        time = time + time*0.1
    end

    MinigameActive = true
    SetNuiFocus(true, true)
    SendNUIMessage({res = 'BEGIN_MINIGAME', icons = icons, time = time})

    while MinigameActive do
        Citizen.Wait(100)
    end

    return Result
end

exports('Begin', Begin)

RegisterNUICallback('finished', function(data, cb)
    Result = data.result
    MinigameActive = false
    SetNuiFocus(false, false)
    cb('ok')
end)