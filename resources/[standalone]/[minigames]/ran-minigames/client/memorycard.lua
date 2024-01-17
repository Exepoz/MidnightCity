local pnis

function MemoryCard(time)

    if LocalPlayer.state.foodBuff == 'hacking' then
        exports['mdn-nighttime']:Notify('You feel more focused...')
        time = time + math.ceil(time*0.1)
    end

    pnis = promise.new()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "open-memory-game",
        data = {
            value = true,
            timer = time
        }
    })
    return Citizen.Await(pnis)
end

exports("MemoryCard", MemoryCard)

RegisterNUICallback("memory-game", function(data, cb)
    SetNuiFocus(false, false)
    cb(0)
    pnis:resolve(data)
end)

RegisterNUICallback("memory-exit", function(data, cb)
    SetNuiFocus(false, false)
    cb(0)
    pnis:resolve(data)
end)
