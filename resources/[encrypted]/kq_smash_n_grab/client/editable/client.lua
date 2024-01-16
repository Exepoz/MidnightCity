-- This function is responsible for drawing all the 3d texts ('Press [E] to take off the wheel' e.g)
function Draw3DText(coords, textInput, scaleX)
    scaleX = scaleX * Config.textScale
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, coords, true)
    local scale = (1 / dist) * 20
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    
    SetTextScale(scaleX * scale, scaleX * scale)
    SetTextFont(Config.textFont or 4)
    SetTextProportional(1)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(coords, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function IsPlayerUnreachable()
    local playerPed = PlayerPedId()
    return IsPedRagdoll(playerPed) or IsEntityDead(playerPed)
end


function KeybindTip(message)
    SetTextComponentFormat("STRING")
    AddTextComponentString(message)
    EndTextCommandDisplayHelp(0, 0, 0, 200)
end

-- This function is responsible for all the tooltips displayed on top right of the screen, you could
-- replace it with a custom notification etc.
function Notify(message)
    SetTextComponentFormat("STRING")
    AddTextComponentString(message)
    EndTextCommandDisplayHelp(0, 0, 0, -1)
end

RegisterNetEvent('kq_smash_n_grab:client:notify')
AddEventHandler('kq_smash_n_grab:client:notify', function(message)
    Notify(message)
end)

function PlayAnim(dict, anim, flag, duration)
    Citizen.CreateThread(function()
        RequestAnimDict(dict)
        local timeout = 0
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(50)
            timeout = timeout + 1
            if timeout > 100 then
                return
            end
        end
        TaskPlayAnim(PlayerPedId(), dict, anim, 1.5, 1.0, duration or -1, flag or 1, 0, false, false, false)
        RemoveAnimDict(dict)
    end)
end


-- Keybinds display
buttons = nil
keybinds = {}

function AddKeybindDisplay(key, label)
    buttons = nil
    
    table.insert(keybinds, {
        key = '~' .. key .. '~',
        label = label,
    })
    
    buttons = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
    while not HasScaleformMovieLoaded(buttons) do
        Wait(0)
    end
    
    BeginScaleformMovieMethod(buttons, "CLEAR_ALL")
    EndScaleformMovieMethod()
    
    for k, keybind in pairs(keybinds) do
        BeginScaleformMovieMethod(buttons, "SET_DATA_SLOT")
        ScaleformMovieMethodAddParamInt(k - 1)
        ScaleformMovieMethodAddParamPlayerNameString(keybind.key)
        PushScaleformMovieMethodParameterString(keybind.label)
        EndScaleformMovieMethod()
    end
    
    BeginScaleformMovieMethod(buttons, "DRAW_INSTRUCTIONAL_BUTTONS")
    EndScaleformMovieMethod()
end

function ClearKeybinds()
    buttons = nil
    keybinds = {}
end


Citizen.CreateThread(function()
    while true do
        local sleep = 500
        if alertActive then
            sleep = 1
            local scaleform = RequestScaleformMovie('mp_big_message_freemode')
            while not HasScaleformMovieLoaded(scaleform) do
                Citizen.Wait(1)
            end
            PushScaleformMovieFunction(scaleform, 'SHOW_SHARD_WASTED_MP_MESSAGE')
            PushScaleformMovieFunctionParameterString(alertTitle)
            PushScaleformMovieFunctionParameterString(alertMessage)
            PopScaleformMovieFunctionVoid()
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
        end
        
        if buttons ~= nil then
            sleep = 1
            DrawScaleformMovieFullscreen(buttons, 255, 255, 255, 255, 0)
        end
        Citizen.Wait(sleep)
    end
end)
