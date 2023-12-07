-- Disable Controls
---@param bool boolean - Disabled Configured Controls when the player is busy
function CRDisableControls(bool)
    for _, v in pairs(Config.ControlsDisabled) do
        DisableControlAction(0, v, bool)
    end
end

-- Main Call Cops Event
---@param coords any - coords being called when robbing the bank
RegisterNetEvent('cr-fleecabankrobbery:client:callCops', function(coords)
    if Config.Police.Dispatch == "cd" then
        --Code Design Dispatch Call
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = Config.Police.PoliceJobs,
            coords = coords,
            title = Config.Police.TenCode.." - "..Config.Police.DispatchMessageTitle,
            message = Config.Police.DispatchMessage,
            flash = true,
            unique_id = tostring(math.random(0000000,9999999)),
            blip = {
                sprite = 207,
                scale = 1.1,
                colour = 1,
                flashes = true,
                text = Config.Police.DispatchMessageTitle,
                time = (5*60*1000),
                sound = 1,
            }
        })
    elseif Config.Police.Dispatch == "core" then
        --Core Dispatch's Call
        TriggerServerEvent("core_dispatch:addCall", Config.Police.TenCode, Config.Police.DispatchMessageTitle,
        {{icon = "fa-solid fa-box"}}, {coords}, Config.Police.PoliceJobs, 5000, 207, 1)

    elseif Config.Police.Dispatch == "ps-dispatch" then
        -- Project Sloth
        exports['ps-dispatch']:CRFleecaBankRobbery(Config.Police.TenCode, Config.Police.DispatchMessage, Config.Police.PoliceJobs, Config.Police.camID)

    elseif Config.Police.Dispatch == "qb" then
        -- qb-policejob
        if FBCUtils.IsPolice() and FBCUtils.OnDuty() then
            TriggerEvent("police:client:policeAlert", coords, Config.Police.DispatchMessage)
        end
        --luacheck: push ignore
    else
        --(You can add any Police Dispatch System over here)
    --luacheck: pop
    end
end)