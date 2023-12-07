local QBCore = exports['qb-core']:GetCoreObject()
local emote, prog, nearby = false, false, nil
local Additionals = {}

RegisterNetEvent('mdn-extras:client:GTWatch', function(data)
    local header = {{ isMenuHeader = true, icon = "fa-solid fa-circle-info", header = "Golden Trail System Watch"}}
    for _, a in ipairs(Config.SysBreacher.Order) do
        local v = GlobalState.HeistCD[a]
        local state = (not v.onCooldown and "Available") or "Not Available"
        --if v.bank and BankRobberyCD then state = "Not Available" end
        if v.reserved and not v.onCooldown then state = "Reserved" end
        header[#header+1] = { header = v.Header, txt = state, icon = v.icon, isMenuHeader = true}
    end
    header[#header+1] = {
        header = "Go Back",
        icon = "fa-solid fa-angle-left",
        params = {event = "mdn-extras:client:SysBreacher", args = {item = data.item}}
    } exports['qb-menu']:openMenu(header)
end)

RegisterNetEvent('mdn-extras:client:InstallBreach', function(data)
    if GlobalState.HeistCD[data.h].reserved or GlobalState.HeistCD[data.h].onCooldown then QBCore.Functions.Notify("Someone else has reserved this, please try again later.", 'error') Wait(1000) TriggerEvent('mdn-extras:client:SysBreacher', data) return end
    local ped = PlayerPedId()
    local pData = QBCore.Functions.GetPlayerData()
    QBCore.Functions.Progressbar('installbreach', 'Installing Program...', 1000, false, false, {
        disableMovement = false, disableCarMovement = false, disableMouse = false, disableCombat = false}, {}, {}, {}, function()
            QBCore.Functions.Notify('Breaching Protocol Succesfully Installed!', 'success')
            TriggerServerEvent('mdn-extras:server:resHeist', data.h, pData.citizenid, data.item)
    end, function() end)
end)

RegisterNetEvent('mdn-extras:client:UninstallProt', function(data)
    local ped = PlayerPedId()
    QBCore.Functions.Progressbar('installbreach', 'Uninstalling Breaching Protocol...', 1000, false, true, {
        disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true}, {}, {}, {}, function()
            QBCore.Functions.Notify('Breaching Protocol Succesfully Uninstalled!', 'success')
            TriggerServerEvent('mdn-extras:server:RemoveProt', data.item)
    end, function()
        emote = false
        ClearPedTasks(ped)
    end)
end)

RegisterNetEvent('mdn-extras:client:InstallProt', function(data)
    local menu = {{header = "Install Breaching Protocol", isMenuHeader = true}}
    local av = false
    for k, v in pairs(GlobalState.HeistCD) do
        if QBCore.Functions.HasItem(v.dongle) then av = true menu[#menu+1] = {header = v.Header.." Breaching Protocol", text = QBCore.Shared.Items[v.dongle].label, icon = 'fas fa-viruses', params = {event = 'mdn-extras:client:InstallBreach', args = {h = k, item = data.item}}} end
    end
    if not av then menu[#menu+1] = {header = "No Compatible Device Detected", icon = 'fas fa-ban', disabled = true} end
    menu[#menu+1] = {header = "Go Back", icon = "fa-solid fa-angle-left", params = {event = "mdn-extras:client:SysBreacher", args = {item = data.item}}}
    exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent('mdn-extras:client:Connect', function(data)
    if nearby and CheckHasProgram(nearby, data.item) then TriggerEvent(Config.SysBreacher.Heists[nearby].event) end
end)

RegisterNetEvent('mdn-extras:client:SysBreacher', function(item)
    if item and item.item then item = item.item end
    local ped, pData = PlayerPedId(), QBCore.Functions.GetPlayerData()
    if not QBCore.Functions.HasItem('uhackingdevice') then return end
    --if not emote then ExecuteCommand('e texting') emote = true Wait(1500) end
    CreateThread(function() while true do if not IsNuiFocused() then ClearPedTasks(ped) emote = false return end Wait(1000) end end)
    local wait = false
    local installed = pData.items[item.slot].info.heist or "None"
    local SysMainMenu = {{header = "System Breacher", isMenuHeader = true}}
    if installed == "None" then SysMainMenu[#SysMainMenu+1] = { header = "Install Program", icon = 'fas fa-download', params = {event = 'mdn-extras:client:InstallProt', args = {item = item}}}
    else
        if not GlobalState.HeistCD[installed].resTime then RemoveProtocol(item) SysMainMenu[#SysMainMenu+1] = { header = "Install Program", icon = 'fas fa-download', params = {event = 'mdn-extras:client:InstallProt', args = {item = item}}} else
            wait = true
            QBCore.Functions.TriggerCallback('mdn-extras:FetchServerTime', function(time)
                local timeLeft = 0
                timeLeft = (time - GlobalState.HeistCD[installed].resTime) or 0
                timeLeft = (1800 - timeLeft)/60
                local tries = pData.items[item.slot].info.tries or 0
                SysMainMenu[#SysMainMenu+1] = { header = "Installed Program", text = Config.SysBreacher.Heists[installed].Header.."<br>Time Left : "..math.ceil(timeLeft).." min | Tries : "..tries, icon = Config.SysBreacher.Heists[installed].icon, disabled = true}
                SysMainMenu[#SysMainMenu+1] = { header = "Uninstall Program", icon = 'fas fa-upload', params = {event = 'mdn-extras:client:UninstallProt', args = {item = item}}}
                wait = false
            end)
        end
    end
    while wait do Wait(0) end
    local dis = true
    if nearby then dis = false end
    SysMainMenu[#SysMainMenu+1] = { header = "Connect to Nearby System", icon = 'fas fa-link', disabled = dis, params = {event = 'mdn-extras:client:Connect', args = {item = item}}}
    SysMainMenu[#SysMainMenu+1] = { header = "View Golden Trail System Watch", icon = 'fas fa-low-vision', params = {event = 'mdn-extras:client:GTWatch', args = {item = item}}}
    for _, v in pairs(Additionals) do SysMainMenu[#SysMainMenu+1] = v end
    SysMainMenu[#SysMainMenu+1] = { header = "Exit", icon = 'fas fa-power-of', params = {event = 'qb-menu:client:closeMenu'}}
    exports['qb-menu']:openMenu(SysMainMenu)
end)

-- Nearby Connect Points
CreateThread(function()
    for k, v in pairs(Config.SysBreacher.Heists) do
        if v.m_coords then
            for _,b in pairs(v.coords) do
                local point = lib.points.new(b, 1.5)
                function point:onEnter() nearby = k end
                function point:onExit() nearby = nil end
            end
        else
            local point = lib.points.new(v.coords, 1.5)
            function point:onEnter() nearby = k end
            function point:onExit() nearby = nil end
        end
    end
end)

-- Exports
function AddSysBreacherOption(name, option) Additionals[name] = option end exports('AddSysBreacherOption', AddSysBreacherOption)
function RemoveSysBreacherOption(name) Additionals[name] = nil end exports('RemoveSysBreacherOption', RemoveSysBreacherOption)
function RemoveHackUse(heist) TriggerServerEvent('mdn-extras:server:RemoveHackUse', heist) end exports('RemoveHackUse', RemoveHackUse)
function RemoveProtocol() TriggerServerEvent('mdn-extras:server:RemoveProt') end exports('RemoveProtocol', RemoveProtocol)
function CheckHasProgram(heist)
    local hasProg = false
    local pData = QBCore.Functions.GetPlayerData()
    if not QBCore.Functions.HasItem('uhackingdevice') then QBCore.Functions.Notify('You don\'t have a system breacher on you...', 'error') return false end
    local wait = true
    for k, v in pairs(pData.items) do
        if v.name == 'uhackingdevice' and v.info.heist == heist then
            QBCore.Functions.TriggerCallback('mdn-extras:FetchServerTime', function(time)
                local timeLeft = time - GlobalState.HeistCD[heist].resTime
                timeLeft = (1800 - timeLeft/1000)/60
                --local installed = pData.items[item.slot].info.heist or "None"
                if (1800 - timeLeft/1000)/60 > 0 then hasProg = true
                else QBCore.Functions.Notify('You don\'t have the required Breaching Protocol to do this', 'error') end
                wait = false
            end) while wait do Wait(0) end return hasProg
        end
    end
    if not hasProg then QBCore.Functions.Notify('You don\'t have the required Breaching Protocol to do this', 'error') return false end
end exports('CheckHasProgram', CheckHasProgram)


-- RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
--     local pData = QBCore.Functions.GetPlayerData()
--     for k, v in pairs(GlobalState.HeistCD) do if v.reserved and v.reserved == pData.citizenid then end end
-- end)