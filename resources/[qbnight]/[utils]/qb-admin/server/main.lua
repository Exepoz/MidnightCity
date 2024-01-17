
PlayerList = {}
PlayerListCache = {}
ServerInformation = {
    StaffCount = nil,
    CharacterCount = nil,
    VehicleCount = nil,
    BansCount = nil,
}
LoadedRole = {}

AdminPanel = {}
AdminPanel.AdminChat = {}
AdminPanel.Reports = {}
InterceptedLogs = {}
PlayersB = {}

Citizen.CreateThread(function()
    Wait(1000)
    AdminPanel.GetAllPlayers()
    while AdminPanel.Open do
        Wait(5000)
        AdminPanel.GetAllPlayers()
    end
end)

if Config.SaveTOJSON then
    Citizen.CreateThread(function()
        AdminPanel.Reports = json.decode(LoadResourceFile(GetCurrentResourceName(), "./json/reports.json"))
        AdminPanel.AdminChat = json.decode(LoadResourceFile(GetCurrentResourceName(), "./json/adminchat.json"))
        InterceptedLogs = json.decode(LoadResourceFile(GetCurrentResourceName(), "./json/logs.json"))
    end)

    AddEventHandler("onResourceStop", function(name)
        if name == GetCurrentResourceName() then
            SaveResourceFile(GetCurrentResourceName(), "json/reports.json", json.encode(AdminPanel.Reports), -1)
            SaveResourceFile(GetCurrentResourceName(), "json/logs.json", json.encode(InterceptedLogs), -1)
            SaveResourceFile(GetCurrentResourceName(), "json/adminchat.json", json.encode(AdminPanel.AdminChat), -1)
        end
    end)
end

if Config.EnableAdminPanelCommand then
    RegisterCommand(Config.AdminPanelCommand, function(source, args)
        if AdminPanel.HasPermission(source, "adminmenu") then
            OpenPanel(source)
        end
    end, false)
end

RegisterNetEvent("919-admin:server:ReportReply", function(data)
    local citizenid = nil
    if data.name ~= nil then
        for k, v in ipairs(GetPlayers()) do
            v = tonumber(v)
            local correctname = GetPlayerName(v).." ("..Compat.GetCharacterName(v)..")"
            if correctname == data.name then
                citizenid = Compat.GetCharacterIdentifier(v)
                TriggerClientEvent("chat:addMessage", tonumber(v), {
                    template = "<div class=\"chat-message server\">You have received a new reply to your report: <strong>{0}</strong></div>",
                    args = {data.message}
                })
            end
        end
    end
end)

RegisterNetEvent("919-admin:server:RequestPanel", function()
    local src = source
    if AdminPanel.HasPermission(src, "adminmenu") then
        OpenPanel(src)
    end
end)

OpenPanel = function(source)
    local src = source
    local playerList = {}
    local version = GetResourceMetadata(GetCurrentResourceName(), "version", 0)
    AdminPanel.GetAllPlayers(function()
        AdminPanel.Open = true
        local hasPerms = false
        if AdminPanel.HasPermission(src, "clearreports") and AdminPanel.HasPermission(src, "clearadminchat") then
            hasPerms = true
        end
        local role = "Staff"
        TriggerClientEvent("919-admin:client:OpenMenu", source, json.encode(ServerInformation.PlayerList), ServerInformation, GetConvarInt("sv_maxclients", 32), version, hasPerms, role)
    end)
end

Compat.CreateCallback("919-Admin:GetPlayerName", function(source, cb, id)
    local test = Compat.GetCharacterData(id)
    cb(test.CharacterName)
end)

Compat.CreateCallback("919-admin:server:Refresh", function(source, cb)
    if AdminPanel.HasPermission(src, "adminmenu") then
        local playerList = {}
        for k, v in ipairs(GetPlayers()) do
            v = tonumber(v)
            local identifiers, steamIdentifier = GetPlayerIdentifiers(v)
            for _, v2 in pairs(identifiers) do
                if string.find(v2, "license:") then
                    steamIdentifier = v2
                end
                if not Config.ShowIPInIdentifiers then
                    if string.find(v2, "ip:") then
                        identifiers[_] = nil
                    end
                end
            end

            local PlayerData = Compat.GetCharacterData(v)
            table.insert(playerList,
                {
                    id = v, 
                    name = GetPlayerName(v), 
                    identifiers = json.encode(identifiers), 
                    role = PlayerData.Role,
                    bank = "$"..comma_value(PlayerData.Bank),
                    cash = "$"..comma_value(PlayerData.Cash),
                    steamid = steamIdentifier,
                    citizenid = PlayerData.CharacterIdentifier,
                    job = PlayerData.Job,
                    rank = PlayerData.Rank,
                    health = GetEntityHealth(GetPlayerPed(playerId)) / 2,
                    armor = GetPedArmour(GetPlayerPed(playerId)),
                    jobboss = PlayerData.IsBoss and "<span class=\"badge badge-success\">"..Lang:t("alerts.yes").."</span>" or "<span class=\"badge badge-danger\">"..Lang:t("alerts.no").."</span>",
                    duty = PlayerData.OnDuty and "<span class=\"badge badge-success\">"..Lang:t("alerts.yes").."</span>" or "<span class=\"badge badge-danger\">"..Lang:t("alerts.no").."</span>",
                    gang = PlayerData.GangLabel,
                    gangrank = PlayerData.GangRank,
                    gangboss = PlayerData.GangIsBoss and "<span class=\"badge badge-success\">"..Lang:t("alerts.yes").."</span>" or "<span class=\"badge badge-danger\">"..Lang:t("alerts.no").."</span>",
                    charname = PlayerData.CharacterName,
                }
            )
        end
        cb(playerList)
    end
end)

RegisterNetEvent("919-admin:AddPlayer", function()
    local src = source
    TriggerClientEvent("919-admin:AddPlayer", -1, src, os.time() )
end)

RegisterNetEvent("919-admin:server:RequestJobPageInfo", function()
    local src = source
    if AdminPanel.HasPermission(src, "jobpage") then
        TriggerClientEvent("919-admin:client:ReceiveJobPageInfo", src, Compat.GetMasterEmployeeList())
    end
end)

RegisterNetEvent("919-admin:server:RequestGangPageInfo", function()
    local src = source
    if AdminPanel.HasPermission(src, "gangpage") then
        TriggerClientEvent("919-admin:client:ReceiveGangPageInfo", src, Compat.GetMasterGangList())
    end
end)

RegisterNetEvent("919-admin:server:RequestBansInfo", function()
    local src = source
    if AdminPanel.HasPermission(src, "banspage") then
        local results = MySQL.query.await("SELECT * FROM `"..Config.DB.BansTable.."`")
        local BansInfo = {}
        for k1,v1 in ipairs(results) do
            table.insert(BansInfo, {
                ID = v1.id,
                Name = v1.name,
                License = v1.license,
                Discord = v1.discord,
                IP = v1.ip,
                Reason = v1.reason,
                Expire = v1.expire,
                BannedBy = v1.bannedby
            })
        end
        TriggerClientEvent("919-admin:client:ReceiveBansInfo", src, BansInfo)
    end
end)

RegisterNetEvent("919-admin:server:ClearJSON", function(type)
    if type == "admin" then
        AdminPanel.AdminChat = {}
        SaveResourceFile(GetCurrentResourceName(), "json/adminchat.json", json.encode(AdminPanel.AdminChat), -1)
    elseif type == "reports" then
        AdminPanel.Reports = {}
        SaveResourceFile(GetCurrentResourceName(), "json/reports.json", json.encode(AdminPanel.Reports), -1)
    elseif type == "logs" then
        InterceptedLogs = {}
        SaveResourceFile(GetCurrentResourceName(), "json/logs.json", json.encode(InterceptedLogs), -1)
    end
end)

RegisterNetEvent("919-admin:server:RequestReportsInfo", function()
    local src = source
    if AdminPanel.HasPermission(src, "viewreports") then
        TriggerClientEvent("919-admin:client:ReceiveReportsInfo", src, AdminPanel.Reports)
    end
end)

RegisterNetEvent("919-admin:server:RequestAdminChat", function()
    local src = source
    if AdminPanel.HasPermission(src, "adminchat") then
        TriggerClientEvent("919-admin:client:ReceiveAdminChat", src, AdminPanel.AdminChat)
    end
end)

RegisterNetEvent("919-admin:server:RequestVehiclesInfo", function()
    local src = source
    if AdminPanel.HasPermission(src, "vehiclesinfo") then
        local results = Compat.GetVehiclesList()
        if results ~= nil then
            TriggerClientEvent("919-admin:client:ReceiveVehiclesInfo", src, results)
        end
    end
end)

RegisterNetEvent("919-admin:server:RequestLeaderboardInfo", function()
    local src = source
    if AdminPanel.HasPermission(src, "leaderboardinfo") then
        local money, vehicles = Compat.GetLeaderboardInfo()
        TriggerClientEvent("919-admin:client:ReceiveLeaderboardInfo", src, money, vehicles)
    end
end)

RegisterNetEvent("919-admin:server:RequestItemsInfo", function()
    local src = source
    if AdminPanel.HasPermission(src, "itemsinfo") then
        local items = Compat.GetItemsList()
        TriggerClientEvent("919-admin:client:ReceiveItemsInfo", src, items)
    end
end)

RegisterNetEvent("919-admin:server:RequestCharacters", function()
    local src = source
    if AdminPanel.HasPermission(src, "characterspage") then
        local results = MySQL.query.await("SELECT * FROM `"..Config.DB.CharactersTable.."`")
        TriggerClientEvent("919-admin:client:ReceiveCharacters", src, results)
    end
end)

RegisterNetEvent("919-admin:server:RequestNoClip", function()
    local src = source
    if AdminPanel.HasPermission(src, "noclip") then
        TriggerClientEvent("919-admin:client:ToggleNoClip", src)
    end
end)

RegisterNetEvent("919-admin:server:AdminChatSend", function(message)
    local src = source
    if AdminPanel.HasPermission(src, "adminchat") then
        local SenderName = GetPlayerName(src)
        local SentTime = os.time()
        table.insert(AdminPanel.AdminChat, {Sender = SenderName, TimeStamp = SentTime, Message = message})
        TriggerEvent("qb-log:server:CreateLog", "adminactions", "Admin chat send", "red", SenderName.." Has sent the following message in the adminchat: "..message.." At: "..SentTime, false)

        for k, v in pairs(GetPlayers()) do
            v = tonumber(v)
            if AdminPanel.HasPermissionEx(v, "adminchat") then
                TriggerClientEvent("919-admin:client:ReceiveAdminChat", v, AdminPanel.AdminChat)
            end
        end
    end
end)

RegisterNetEvent("919-admin:server:SendReport", function(subject, info, type)
    local src = source

    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local CitizenId = Compat.GetCharacterIdentifier(src)
        local reportCount = 0
        for k,v in pairs(AdminPanel.Reports) do
            if v.SenderCitizenID == CitizenId then
                reportCount = reportCount + 1
            end
        end
        if reportCount >= Config.MaxReportsPerPlayer then
            return TriggerClientEvent("919-admin:client:ShowReportAlert", src, Lang:t("alerts.failedReportSend"), Lang:t("alerts.reportLimitReached"))
        end
        TriggerClientEvent("919-admin:client:ShowReportAlert", src, Lang:t("alerts.reportSent"), "Your report was sent to server staff!")
        local sendername = GetPlayerName(src).." ("..Compat.GetCharacterName(src)..")"
        table.insert(AdminPanel.Reports, {ReportID = #AdminPanel.Reports + 1, Claimed = nil, ReportTime = os.time(), SenderCitizenID = CitizenId, SenderID = src, SenderName = sendername, Subject = subject, Info = info, Type = type})
        TriggerEvent("qb-log:server:CreateLog", "adminactions", Lang:t("alerts.reportSent"), "red", sendername..""..Lang:t("alerts.sentFollowingReport").." "..subject.." "..Lang:t("alerts.message").." "..info, false)
        for k, v in pairs(GetPlayers()) do
            v = tonumber(v)
            if AdminPanel.HasPermissionEx(v, "viewreports") then
                TriggerClientEvent("919-admin:client:ShowReportAlert", v, Lang:t("alerts.newReport"), sendername..": "..subject.." Report ID: "..#AdminPanel.Reports)
            end
        end
    end
end)

RegisterServerEvent("919-admin:server:ClaimReport", function(id)
    local src = source
    if AdminPanel.HasPermission(src, "claimreport") then
        if AdminPanel.Reports[tonumber(id)] then
            AdminPanel.Reports[tonumber(id)].Claimed = GetPlayerName(src)
            TriggerEvent("qb-log:server:CreateLog", "adminactions", Lang:t("alerts.reportClaimed"), "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** claimed report ID "..id, false)
            for k, v in pairs(GetPlayers()) do
                v = tonumber(v)
                if AdminPanel.HasPermission(v, "viewreports") then
                    TriggerClientEvent("919-admin:client:ShowReportAlert", v, Lang:t("alerts.reportClaimed"), GetPlayerName(src).." claimed Report ID ".. id.." from "..AdminPanel.Reports[tonumber(id)].SenderName..".")
                end
            end
            TriggerClientEvent("919-admin:client:ShowPanelAlert", AdminPanel.Reports[tonumber(id)].SenderID, "success", "<strong>"..Lang:t("alerts.report").."</strong>"..Lang:t("alerts.reportClaimedByStaff").. "<strong>"..GetPlayerName(src).."</strong>.")
            TriggerClientEvent("919-admin:client:ReceiveReportsInfo", src, AdminPanel.Reports)
        end
    end
end)


RegisterServerEvent("919-admin:server:DeleteReport", function(id)
    local src = source
    if AdminPanel.HasPermission(src, "deletereport") then
        if AdminPanel.Reports[tonumber(id)] then
            AdminPanel.Reports[tonumber(id)] = nil
            TriggerEvent("qb-log:server:CreateLog", "adminactions", "Report Deleted", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** deleted report ID "..id, false)
            TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>SUCCESS:</strong> Deleted Report ID " .. id..".")
            TriggerClientEvent("919-admin:client:ReceiveReportsInfo", src, AdminPanel.Reports)
        end
    end
end)

RegisterNetEvent("919-admin:server:ResourceAction", function(resourceName, action)
    local src = source
    if AdminPanel.HasPermission(src, "adminmenu") then
        if action == "start" then
            if GetResourceState(resourceName) == "stopped" then
                StartResource(resourceName)
                Wait(500)
                TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.startedResource").."</strong> "..resourceName)
            else
                TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.error").."</strong>"..Lang:t("alerts.resourceAlready"))
            end
        elseif action == "stop" then
            if GetResourceState(resourceName) == "started" then
                StopResource(resourceName)
                Wait(500)
                TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.stoppedResource").."</strong> "..resourceName)                else
                TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.error").."</strong>"..Lang:t("alerts.resouceStoppedAlready"))
            end
        elseif action == "restart" then
            if GetResourceState(resourceName) == "started" then
                StopResource(resourceName)
                Wait(500)
                StartResource(resourceName)
                TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.RestartedResource").."</strong> "..resourceName)
            else
                TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.error").."</strong>"..Lang:t("alerts.resouceRestartedAlready"))
            end
        end
        TriggerClientEvent("919-admin:client:ForceReloadResources", src)
    end
end)

RegisterNetEvent("919-admin:server:MonetaryAction", function(targetId, action, amount)
    local src = source
    if AdminPanel.HasPermission(src, "givetakemoney") then
        if action == "givecash" then
            Compat.PlayerActions.AddMoney(targetId, amount)
            TriggerClientEvent("919-admin:client:ShowPanelAlert", source, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.gaveCash", {value = amount, value2 = GetPlayerName(targetId)}))
        elseif action == "removecash" then
            Compat.PlayerActions.RemoveMoney(targetId, amount)
            TriggerClientEvent("919-admin:client:ShowPanelAlert", source, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.removeCash", {value = amount, value2 = GetPlayerName(targetId)}))
        elseif action == "givebank" then
            Compat.PlayerActions.AddBank(targetId, amount)
            TriggerClientEvent("919-admin:client:ShowPanelAlert", source, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.gaveBank", {value = amount, value2 = GetPlayerName(targetId)}))
        elseif action == "removebank" then
            Compat.PlayerActions.RemoveBank(targetId, amount)
            TriggerClientEvent("919-admin:client:ShowPanelAlert", source, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.removeBank", {value = amount, value2 = GetPlayerName(targetId)}))
        end
    end
end)

RegisterNetEvent("919-admin:server:RequestViewPlayer", function(CitizenId)
    DebugTrace(CitizenId)
    local src = source
    local Player = Compat.GetPlayerFromCharacterIdentifier(CitizenId)
    if Player then
        local sourcer = Player.source or Player.PlayerData.source
        TriggerClientEvent("919-admin:client:ViewPlayer", src, true, sourcer)
    else
        TriggerClientEvent("919-admin:client:ViewPlayer", src, false, Compat.GetOfflinePlayerFromCharacterIdentifier(CitizenId))
    end
end)

AddEventHandler("playerDropped", function()
	local src = source
    TriggerClientEvent("919-admin:RemovePlayer", -1, src)
end)

RegisterNetEvent("919-admin:server:RefreshMenu", function(silent)
    local src = source
    TriggerClientEvent("919-admin:client:RefreshMenu", src, json.encode(Compat.GetPlayerList()), silent)
end)

RegisterServerEvent("qb-log:server:CreateLog",  function(name, title, color, message, tagEveryone)
    if name == "adminactions" then
        local webHook = Config.LogsWebhook
        if webHook == "" or webHook == "CHANGEME" then
            print("Webhook missing from config!")
            return
        end
        local embedData = {
            {
                ["title"] = title,
                ["color"] = 16743168,
                ["footer"] = {
                    ["text"] = os.date("%c"),
                },
                ["description"] = message,
                ["author"] = {
                    ["name"] = "Adminchat",
                    ["icon_url"] = "https://cdn.discordapp.com/attachments/870094209783308299/870104723338973224/Logotype_-_Display_Picture_-_Stylized_-_Red.png",
                },
            }
        }
        PerformHttpRequest(webHook, function(err, text, headers) end, "POST", json.encode({ username = "Admin log!", embeds = embedData}), { ["Content-Type"] = "application/json" })
    end
    table.insert(InterceptedLogs, {time=os.time(), from=name, title=title, message=message})
end)


Compat.CreateCallback("919-admin:server:HasPermission", function(source, cb, permission)
    if AdminPanel.HasPermission(source, permission) then
        return cb(true)
    end
end)

AdminPanel.HasPermission = function(targetId, permName)
    local Player = Compat.GetPlayer(targetId)
    local hasPerms = false
    if Player then
        for k,v in pairs(Config.Permissions) do
            if QBCore then
                if QBCore.Functions.HasPermission(targetId, k)  then
                    hasPerms = true
                    for _,action in pairs(v.AllowedActions) do
                        if action == permName then
                            return true
                        end
                    end
                end
            elseif ESX then
                if k == Player.group then
                    hasPerms = true
                    for _,action in pairs(v.AllowedActions) do
                        if action == permName then
                            return true
                        end
                    end
                end
            end
        end
    end

    if hasPerms then
        if permName ~= "clearreports" and permName ~= "clearadminchat" then
            TriggerClientEvent("919-admin:client:ShowPanelAlert", targetId, "danger", "<strong>"..Lang:t("alerts.error").."</strong> "..Lang:t("alerts.noPermission"))
        end
        TriggerClientEvent("919-admin:client:ResetMenu", targetId)
    end
    return false
end

AdminPanel.HasPermissionEx = function(targetId, permName)
    local Player = Compat.GetPlayer(targetId)
    local Permission = nil
    if Player then
        for k,v in pairs(Config.Permissions) do
            if QBCore then
                if QBCore.Functions.HasPermission(targetId, k) then
                    for _,action in pairs(v.AllowedActions) do
                        if action == permName then
                            return true
                        end
                    end
                end
            elseif ESX then
                if Player.group == k then
                    for _,action in pairs(v.AllowedActions) do
                        if action == permName then
                            return true
                        end
                    end
                end
            end
        end
    end
    TriggerClientEvent("919-admin:client:ResetMenu", targetId)
    return false
end

AdminPanel.CharacterName = function(Player)
    if Player.PlayerData then
        return Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
    end
end

RegisterNetEvent("919-admin:server:RequestResourcePageInfo", function()
    local src = source
    if AdminPanel.HasPermission(src, "resourcepage") then
        local resourceList = {}
        for i = 0, GetNumResources(), 1 do
            local resource_name = GetResourceByFindIndex(i)
            if resource_name then
                if resource_name ~= "_cfx_internal" and resource_name ~= "fivem" then -- Ignore these two base resources. Others are ok.
                    table.insert(resourceList, { resource_name, GetResourceState(resource_name) })
                end
            end
        end
        TriggerClientEvent("919-admin:client:ReceiveResourcePageInfo", src, resourceList)
    end
end)

RegisterNetEvent("919-admin:server:RequestCurrentLogs", function()
    local src = source
    if AdminPanel.HasPermission(src, "serverlogs") then
        TriggerClientEvent("919-admin:client:ReceiveCurrentLogs", src, InterceptedLogs)
    end
end)

RegisterNetEvent("919-Admin:server:OpenInventory", function(target)
    TriggerClientEvent("inventory:client:RobPlayer:Admin", target, tonumber(target))
end)

RegisterNetEvent("919-admin:server:RequestServerMetrics", function()
    local src = source
    if AdminPanel.HasPermission(src, "servermetrics") then
        local ServerMetrics = {}
        ServerMetrics.StaffCount = 0
        local results
        results = MySQL.query.await("SELECT * FROM `"..Config.DB.CharactersTable.."`", {})
        ServerMetrics.CharacterCount = #results
        ServerMetrics.TotalCash = 0
        for k,v in pairs(results) do
            if v.money then
                local money = json.decode(v.money)
                if money then
                    ServerMetrics.TotalCash = ServerMetrics.TotalCash + money.cash
                end
            elseif v.accounts then
                local money = json.decode(v.accounts)
                if money then
                    ServerMetrics.TotalCash = ServerMetrics.TotalCash + money.money
                end
            end
        end
        ServerMetrics.TotalBank = 0
        for k,v in pairs(results) do
            if v.money then
                local money = json.decode(v.money)
                if money then
                    ServerMetrics.TotalBank = ServerMetrics.TotalBank + money.bank
                end
            elseif v.accounts then
                local money = json.decode(v.accounts)
                if money then
                    ServerMetrics.TotalBank = ServerMetrics.TotalBank + money.bank
                end
            end
        end
        ServerMetrics.TotalItems = 0
        for k,v in pairs(results) do
            if v.inventory then
                local inv = json.decode(v.inventory)
                if inv then
                    local count = 0
                    for k,v in pairs(inv) do
                        count = count + 1
                    end
                    ServerMetrics.TotalItems = ServerMetrics.TotalItems + count
                end
            end
        end
        results = MySQL.query.await("SELECT * FROM `"..Config.DB.VehiclesTable.."`", {})
        ServerMetrics.VehicleCount = #results
        results = MySQL.query.await("SELECT * FROM `"..Config.DB.BansTable.."`", {})
        ServerMetrics.BansCount = #results
        if QBCore then
            results = MySQL.query.await("SELECT DISTINCT `license` FROM `"..Config.DB.CharactersTable.."`", {})
        elseif ESX then
            results = MySQL.query.await("SELECT DISTINCT `identifier` FROM `"..Config.DB.CharactersTable.."`", {})
        end
        ServerMetrics.UniquePlayers = #results
        TriggerClientEvent("919-admin:client:ReceiveServerMetrics", src, ServerMetrics)
    end
end)

function comma_value(amount)
    local formatted = math.floor(amount)
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
        if (k==0) then
            break
        end
    end
    return formatted
end

AdminPanel.GetAllPlayers = function(cb)
    ServerInformation.PlayerList = {}
    ServerInformation.StaffCount = 0
    ServerInformation.PlayerList = Compat.GetPlayerList()
    for k,v in ipairs(GetPlayers()) do
        v = tonumber(v)
        local Player = Compat.GetPlayer(v)
        if Player then
            local identifiers, steamIdentifier = GetPlayerIdentifiers(v)
            for _, v2 in pairs(identifiers) do
                if string.find(v2, "license:") then
                    steamIdentifier = v2
                end
                if not Config.ShowIPInIdentifiers then
                    if string.find(v2, "ip:") then
                        identifiers[_] = nil
                    end
                end
            end
            local playerRole = "user"
            if QBCore then
                if QBCore.Functions.HasPermission(tonumber(v), "god") then
                    ServerInformation.StaffCount = ServerInformation.StaffCount + 1
                    playerRole = "god"
                elseif QBCore.Functions.HasPermission(tonumber(v), "admin") then
                    ServerInformation.StaffCount = ServerInformation.StaffCount + 1
                    playerRole = "admin"
                end
            elseif ESX then
                playerRole = Player.group
                if Player.group ~= "user" then
                    ServerInformation.StaffCount = ServerInformation.StaffCount + 1
                end
            end
            LoadedRole[tonumber(v)] = playerRole
        end
    end
    if cb then cb() end
end

RegisterNetEvent("919-admin:server:GetPlayersForBlips", function()
    local src = source
    if Config.EnableNames then
        local tempPlayers = {}
        for _, v in pairs(GetPlayers()) do
            v = tonumber(v)
            local targetped = GetPlayerPed(v)
            local charname = Compat.GetCharacterName(v)
            tempPlayers[#tempPlayers + 1] = {
                name = (charname .. " | (" .. (GetPlayerName(v) or "") .. ")"),
                id = v,
                coords = GetEntityCoords(targetped),
                cid = charname,
                citizenid = "---",
                sources = targetped,
                sourceplayer = v
            }
        end
        -- Sort PlayersB list by source ID (1,2,3,4,5, etc) --
        table.sort(tempPlayers, function(a, b)
            return a.id < b.id
        end)
        PlayersB = tempPlayers
        TriggerClientEvent("919-admin:client:Show", src, PlayersB)
    end
end)