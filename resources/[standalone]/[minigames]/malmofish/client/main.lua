-- Define whether the fishing game is active or not
local isFishingGameActive = false
local p = nil
-- Function to start the fishing game
function MalmoFish(cb)
    if not isFishingGameActive then
        p = promise.new()
        SetNuiFocus(true, true)
        SendNUIMessage({ action = "startGame" }) -- Tell the HTML/JS game to start
        isFishingGameActive = true

        local result = Citizen.Await(p)
        cb(result)
    end
end

exports("MalmoFish", MalmoFish)


RegisterNUICallback('fish-success', function(data, cb)
    if p then
        p:resolve(true)
        p = nil
    end
    isFishingGameActive = false
    SetNuiFocus(false, false)
    cb('success')
end)

RegisterNUICallback('fish-fail', function(data, cb)
    if p then
        p:resolve(false)
        p = nil
    end
    isFishingGameActive = false
    SetNuiFocus(false, false)
    cb('failed')
end)


RegisterCommand("malmofish", function()
    exports['malmofish']:MalmoFish(function(success)
        if success then
            print("success")
        else
            print("fail")
        end
    end)
end)
