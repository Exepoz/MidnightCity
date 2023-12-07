local QBCore = exports['qb-core']:GetCoreObject()


-- Disable Controls
---@param bool boolean - Disabled Configured Controls when the player is busy
function CRDisableControls(bool)
    for _, v in pairs(Config.ControlsDisabled) do
        DisableControlAction(0, v, bool)
    end
end

--Show Items When Nearby
---@param item table - Table containing Item Name and Item Image 
---@param bool boolean - Toggles if the item is showned or disabled 
function ShowItem(item, bool)
    if bool then
        TriggerEvent('inventory:client:requiredItems', item, true)
    else
        TriggerEvent('inventory:client:requiredItems', item, false)
    end
end

-- Main Call Cops Event
RegisterNetEvent('cr-paletobankrobbery:client:callCops', function(type)
    local coords = vector3(-108.07, 6465.74, 31.63)
    if Config.Police.Dispatch == "cd" then
        --Code Design Dispatch Call
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = Config.Police.PoliceJobs,
            coords = coords,
            title = Config.Police[type].TenCode.." - "..Config.Police[type].Title,
            message = Config.Police[type].Message,
            flash = (type == "Robbery"),
            unique_id = tostring(math.random(0000000,9999999)),
            blip = {
                sprite = 207,
                scale = 1.1,
                colour = 1,
                flashes = true,
                text = Config.Police[type].Title,
                time = (5*60*1000),
                sound = 1,
            }
        })
    elseif Config.Police.Dispatch == "core" then
        --Core Dispatch's Call
        TriggerServerEvent("core_dispatch:addCall", Config.Police[type].TenCode, Config.Police[type].Title,
        {{icon = "fa-solid fa-box"}}, {coords}, Config.Police.PoliceJobs, 5000, 207, 1)

    elseif Config.Police.Dispatch == "ps-dispatch" then
        -- Project Sloth
        exports['ps-dispatch']:CRPaletoBankRobbery(Config.Police[type].TenCode, Config.Police[type].Message, Config.Police.PoliceJobs, Config.Police.camID)

    elseif Config.Police.Dispatch == "qb" then
        -- qb-policejob
        if PBCUtils.IsPolice() and PBCUtils.OnDuty() then
            TriggerEvent("police:client:policeAlert", coords, Config.Police[type].Message)
        end
        --luacheck: push ignore
    else
        --(You can add any Police Dispatch System over here)
    --luacheck: pop
    end
end)