local QBCore = exports['qb-core']:GetCoreObject()

function SetupTargets()
    -- Clothes
    for _, v in pairs(Config.ClothingMenus) do
        exports['qb-target']:RemoveZone(v.name)
        exports['qb-target']:AddBoxZone(v.name, v.coords, v.w, v.l, { name=v.name, heading = v.h, debugPoly = Config.DebugPoly, minZ = v.minz, maxZ = v.maxz },
        { options = { { event = "mdn-extras:client:accessclothing", icon = "fas fa-tshirt", label = "Access Clothes", cids = v.cids, jobs = v.jobs, gangs = v.gangs}, }, distance = 2 })
    end

    -- Stashes
    for k, v in pairs(Config.Stashes) do
        exports['qb-target']:RemoveZone(v.name)
        exports['qb-target']:AddBoxZone(v.name, v.coords, v.w, v.l, { name=v.name, heading = v.h, debugPoly = Config.DebugPoly, minZ = v.minz, maxZ = v.maxz },
        { options = {
            { event = "mdn-extras:client:accessStash", icon = "fas fa-box-open", label = "Access Storage", key = k, cids = v.cids, sname = v.name, jobs = v.jobs, gangs = v.gangs },
            { event = "mdn-extras:client:accessStash", icon = "fas fa-box-open", label = "Search", key = k, sname = v.name, job = 'police', jobs = {'police'} },
        }, distance = 2 })
    end

    -- Slime Dispenser
    exports['qb-target']:RemoveZone("slimeDispenser")
    exports['qb-target']:AddBoxZone("slimeDispenser", vector3(-158.48, -1608.3, 33.65), 0.2, 0.4, { name="slimeDispenser", heading = 340, debugPoly = Config.DebugPoly, minZ = 33.35, maxZ = 33.9 },
    { options = { {
        action = function()
            local input = lib.inputDialog('Slime Can', {{ type = "number", label = "Vial Amount", default = 1 }})
            if not input or not input[1] or tonumber(input[1]) <= 0 or tonumber(input[1]) > 50 then QBCore.Functions.Notify('Invalid Amount!', 'error', 7500) return end
            TriggerServerEvent('mdn-extras:server:getslime', tonumber(input[1]))
        end,
    icon = "fas fa-hand", label = "Get Slime", gang = "slimegang" }, }, distance = 2 })

    -- MDT Weapon Regiser Stations
    exports['qb-target']:AddBoxZone("SelfRegister", vector3(454.80, -985.65, 30.45), 0.75, 0.75, { name="SelfRegister", heading = 0.0, debugPoly=Config.Debug, minZ = 30.10, maxZ = 30.80, },
    { options = { { type = "client", event = "ps-mdt:client:selfregister", icon = "fa-solid fa-gun", label = "Register Weapon" },
    }, distance = 2.0 })
end

local licenceNames = {
    ['weapon1'] = "Weapon Class 1",
    ['weapon2'] = "Weapon Class 2",
    ['weapon3'] = "Weapon Class 3",
    ['hunting'] = "Hunting"
}



local AmmuDoor = lib.points.new(vector3(18.21, -1107.04, 28.8), 1.5)
function AmmuDoor:onEnter()
    local pData = QBCore.Functions.GetPlayerData()
    if pData.job.name ~= 'ammunation' then return end
    lib.addRadialItem({id = "AmmuTablet", icon = 'tablet', label = 'Check Licenses',
    onSelect = function()
        ExecuteCommand('e tablet2')
        local input = lib.inputDialog('License Checker 1.0', {'Citizen ID (ABC12345)'})
        if not input or not input[1] then ExecuteCommand('cancelemote') return end
        QBCore.Functions.TriggerCallback('Ammunation:CheckLicenses', function(licenses)
            if not licenses then return end
            local string = licenses['name'].."\n\n"
            local emj = (licenses['weapon1'] and "Y ~ ") or 'X ~ '
            string = string..emj..licenceNames['weapon1'].."\n\n"
            emj = (licenses['weapon2'] and "Y ~ ") or 'X ~ '
            string = string..emj..licenceNames['weapon2'].."\n\n"
            emj = (licenses['weapon3'] and "Y ~ ") or 'X ~ '
            string = string..emj..licenceNames['weapon3'].."\n\n"
            emj = (licenses['hunting'] and "Y ~ ") or 'X ~ '
            string = string..emj..licenceNames['weapon3']
            lib.alertDialog({
                header = 'Licenses Checker 1.0',
                content = string,
                centered = true,
                cancel = false
            }) ExecuteCommand('cancelemote')
        end, tostring(input[1]))
    end})
end

-- function AmmuDoor:onEnter()
--     local pData = QBCore.Functions.GetPlayerData()
--     if pData.job.name ~= 'ammunation' then return end
--     lib.addRadialItem({id = "AmmuTablet", icon = 'tablet', label = 'Check Licenses',
--     onSelect = function()
--         ExecuteCommand('e tablet2')
--     local newinputs = {} -- Begin qb-input creation here.
--         --Retrieve a list of nearby players from server
--         local p = promise.new() QBCore.Functions.TriggerCallback('jim-payments:MakePlayerList', function(cb) p:resolve(cb) end)
--         local onlineList = Citizen.Await(p)
--         local nearbyList = {}
--         --Convert list of players nearby into one qb-input understands + add distance info
--         for _, v in pairs(QBCore.Functions.GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 5)) do
--             local dist = #(GetEntityCoords(GetPlayerPed(v)) - GetEntityCoords(PlayerPedId()))
--             for i = 1, #onlineList do
--                 if onlineList[i].value == GetPlayerServerId(v) then
--                     if v ~= PlayerId() or Config.Debug then
--                         nearbyList[#nearbyList+1] = onlineList[i].value--{ value = onlineList[i].value, text = onlineList[i].text..' ('..math.floor(dist+0.05)..'m)' }
--                     end
--                 end
--             end
--         end
--         --If list is empty(no one nearby) show error and stop
--         if not nearbyList[1] then QBCore.Functions.Notify("No one nearby!", "error") return end
--         newinputs[#newinputs+1] = {label = 'Nearby Citizen', values = nearbyList}
--        -- newinputs[#newinputs+1] = { text = " ", name = "citizen", type = "select", options = nearbyList }
--     --Continue adding payment options to qb-input

--     --newinputs[#newinputs+1] = {label = 'Check Licenses'}

--     --Grab Player Job name or Gang Name if needed
--     lib.RegisterMenu({id = "AmmuTablet", title = "License Checker 1.0", position = 'bottom-left', options = newinputs}, function(selected, scrollIndex, args)
--         print(selected, scrollIndex, args)
--     end) lib.showMenu('AmmuTablet')
--     --local dialog = exports['qb-input']:ShowInput({ header = img..label.." Cash Register", submitText = "Send", inputs = newinputs})
--     end})
-- end
function AmmuDoor:onExit() lib.removeRadialItem('AmmuTablet') end


RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() Wait(5000) SetupTargets() end)
AddEventHandler('onResourceStart', function(resource) if resource == GetCurrentResourceName() then SetupTargets() end end)