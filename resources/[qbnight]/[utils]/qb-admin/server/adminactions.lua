SendPlayerBack = {}
SendBack = {}
SpectatingPlayer = {}
Frozen = {}

RegisterServerEvent("919-admin:server:SetPosition", function(playerId, x, y, z)
    local src = source
    if AdminPanel.HasPermission(src, "teleport") then
        SetEntityCoords(GetPlayerPed(playerId), x, y, z)
    end
end)

RegisterServerEvent("919-admin:server:KillPlayer", function(playerId)
    local src = source
    if AdminPanel.HasPermission(src, "kill") then
        TriggerClientEvent("hospital:client:KillPlayer", playerId)
        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.killed").." " .. GetPlayerName(playerId) .. ".")
        TriggerEvent("qb-log:server:CreateLog", "adminactions", "KICK", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** "..Lang:t("alerts.killed").." **" .. GetPlayerName(playerId) .. "** [" .. playerId .. "]", false)
    end
end)

RegisterServerEvent("919-admin:server:SavePlayer", function(playerId)
    local src = source
    if QBCore then
        if AdminPanel.HasPermission(src, "savedata") then
            local TargetPlayer = QBCore.Functions.GetPlayer(playerId)
            TargetPlayer.Functions.Save()
            TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.savedToDB", {value = GetPlayerName(playerId)}))
            TriggerEvent("qb-log:server:CreateLog", "adminactions", "KICK", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "**" ..Lang:t("alerts.savedToDB", {value = GetPlayerName(playerId)}) .. "** [" .. playerId .. "]", false)
        end
    end
end)

RegisterServerEvent("919-admin:server:KickPlayer", function(playerId, reason)
    local src = source
    if AdminPanel.HasPermission(src, "kick") then
        TriggerEvent("qb-log:server:CreateLog", "adminactions", "KICK", "red", Lang:t("alerts.kickedPlayer", {value = GetPlayerName(src), value2 = GetPlayerName(playerId), value3 = playerId, value4 = reason}), false)
        DropPlayer(playerId, Lang:t("alerts.YouBeenKicked").."\n" .. reason .. "\n\n🔸 "..Lang:t("alerts.joinDiscord").." " .. Config.ServerDiscord)
    end
end)

RegisterServerEvent("919-admin:server:Freeze", function(playerId)
    local src = source
    if AdminPanel.HasPermission(src, "freeze") then
        if not Frozen[playerId] then
            Frozen[playerId] = true
            FreezeEntityPosition(GetPlayerPed(playerId), true)
            --TriggerClientEvent("QBCore:Notify", src, "Froze "..GetPlayerName(playerId)..".", "success")
            TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.froze").." " .. GetPlayerName(playerId) .. ".")
            TriggerEvent("qb-log:server:CreateLog", "adminactions", "Frozen", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** "..Lang:t("alerts.froze").." **" .. GetPlayerName(playerId) .. "** [" .. playerId .. "]", false)
        else
            Frozen[playerId] = false
            FreezeEntityPosition(GetPlayerPed(playerId), false)
            --TriggerClientEvent("QBCore:Notify", src, "Unfroze "..GetPlayerName(playerId)..".", "success")
            TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.unfroze").." " .. GetPlayerName(playerId) .. ".")
            TriggerEvent("qb-log:server:CreateLog", "adminactions", "Frozen", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** "..Lang:t("alerts.unfroze").." **" .. GetPlayerName(playerId) .. "** [" .. playerId .. "]", false)
        end
    end
end)

RegisterServerEvent("919-admin:server:KickAllPlayers", function(reason)
    local src = source
    if AdminPanel.HasPermission(src, "kickall") then
        for k, v in pairs(GetPlayers()) do
            v = tonumber(v)
            if v ~= src then
                DropPlayer(v, Lang:t("alerts.kickedFrom", {value = Config.ServerName, value2 = reason}) .. "\n\n🔸 "..Lang:t("alerts.joinDiscord").." " .. Config.ServerDiscord)
            end
        end
    end
end)

RegisterNetEvent("919-admin:server:BanPlayer", function(player, time, reason, citizenid)
    local src = source
    if AdminPanel.HasPermission(src, "ban") then
        local time = tonumber(time)
        local banTime = tonumber(os.time() + time)
        if banTime > 2147483647 then
            banTime = 2147483647
        end
        local timeTable = os.date("*t", banTime)
        if player ~= "OFFLINE" then
            AdminPanel.OnlineBanPlayer(src, player, time, timeTable, reason)
        else
            if citizenid ~= nil then
                local result = MySQL.query.await("SELECT * FROM `" .. Config.DB.CharactersTable .. "` WHERE `citizenid` = ?", {citizenid})
                if result[1] then
                    local online = false
                    for k, v in pairs(GetPlayers()) do
                        v = tonumber(v)
                        if QBCore then
                            if QBCore.Functions.GetIdentifier(v, "license") == result[1].license then --Player is online but not on this character. so we"ll ban them online
                                AdminPanel.OnlineBanPlayer(src, v, time, timeTable, reason)
                                online = true
                                break
                            end
                        else
                            if ESX.GetIdentifier(player) == result[1].Identifier then --Player is online but not on this character. so we"ll ban them online
                                AdminPanel.OnlineBanPlayer(src, v, time, timeTable, reason)
                                online = true
                                break
                            end
                        end
                    end
                    if not online then
                        MySQL.insert("INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)", {
                            result[1].name,
                            result[1].license,
                            "",
                            "",
                            reason,
                            banTime,
                            GetPlayerName(src)
                        })
                        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "Banned " .. result[1].name .. " (OFFLINE) for " .. (time / 60 / 60) .. " hours.")
                        if Config.AnnounceBan then
                            TriggerClientEvent("chat:addMessage", -1, {
                                template = "<div class=\"chat-message server\"><strong>{0}</strong> "..Lang:t("alerts.bannedOffBy").." <strong>{1}</strong> "..Lang:t("alerts.for1").." {2} "..lang:t("alerts.bannedOffBy2").." {3}</div>",
                                args = {result[1].name, GetPlayerName(src), time / 60 / 60, reason}
                            })
                        end
                        TriggerEvent("qb-log:server:CreateLog", "bans", "Player Banned", "red", string.format("%s was banned by %s for %s (%s hours)", result[1].name, GetPlayerName(src), reason, time / 60 / 60), Config.TagEveryone)
                    end
                else
                    DebugTrace("Offline ban citizenid had no results. CitizenID: " .. citizenid)
                end
            else
                DebugTrace("Tried to ban offline but citizenid was invalid. Scripting error.")
            end
        end
    end
end)

AdminPanel.OnlineBanPlayer = function(source, player, time, timeTable, reason)
    local src = source
    local time = tonumber(time)
    local banTime = tonumber(os.time() + time)
    if banTime > 2147483647 then
        banTime = 2147483647
    end
    if QBCore then
        MySQL.insert("INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)", {
            GetPlayerName(player),
            QBCore.Functions.GetIdentifier(player, "license"),
            QBCore.Functions.GetIdentifier(player, "discord"),
            QBCore.Functions.GetIdentifier(player, "ip"),
            reason,
            banTime,
            GetPlayerName(src)
        })
    else
        MySQL.insert("INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)", {
            GetPlayerName(player),
            ESX.GetIdentifier(player),
            "Unknwon",
            "Unknown",
            reason,
            banTime,
            GetPlayerName(src)
        })
    end

    TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "Banned " .. GetPlayerName(player) .. " for " .. (time / 60 / 60) .. " hours.")
    if Config.AnnounceBan then
        TriggerClientEvent("chat:addMessage", -1, {
            template = "<div class=\"chat-message server\"><strong>{0}</strong> has been banned by <strong>{1}</strong> for {2} hours. Reason: {3}</div>",
            args = {GetPlayerName(player), GetPlayerName(src), time / 60 / 60, reason}
        })
    end
    TriggerEvent("qb-log:server:CreateLog", "bans", "Player Banned", "red", string.format("%s was banned by %s for %s (%s hours)", GetPlayerName(player), GetPlayerName(src), reason, time / 60 / 60), Config.TagEveryone)
    if banTime >= 2147483647 then
        DropPlayer(player, Lang:t("alerts.bannedPermanent", {value = reason}).." " .. Config.ServerDiscord)
    else
        DropPlayer(player, Lang:t("alerts.bannedTemp", {value = reason, value2 = timeTable["day"], value3 = timeTable["month"], value4 = timeTable["year"], value5 = timeTable["hour"], value6 = timeTable["min"], value7 = Config.ServerDiscord}))
    end
end

RegisterNetEvent("919-admin:server:WarnPlayer", function(player, reason, citizenid)
    local src = source
    if AdminPanel.HasPermission(src, "warn") then
        if player ~= "OFFLINE" then
            AdminPanel.OnlineWarnPlayer(src, player, reason)
        else
            if citizenid ~= nil then
                local result = MySQL.query.await("SELECT * FROM `" .. Config.DB.CharactersTable .. "` WHERE `citizenid` = ?", {citizenid})
                if result[1] then
                    local online = false
                    for k, v in pairs(GetPlayers()) do
                        v = tonumber(v)
                        if QBCore then
                            if QBCore.Functions.GetIdentifier(v, "license") == result[1].license then
                                AdminPanel.OnlineWarnPlayer(src, v, reason)
                                online = true
                                break
                            end
                        else
                            if ESX.GetIdentifier(player) == result[1].Identifier then
                                AdminPanel.OnlineWarnPlayer(src, v, reason)
                                online = true
                                break
                            end
                        end
                    end
                    if not online then
                        MySQL.insert("INSERT INTO warns (name, license, reason, warnedby) VALUES (?, ?, ?, ?)", {
                            result[1].name,
                            result[1].license,
                            reason,
                            GetPlayerName(src)
                        })
                        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.warnedPlayerOffline", {value = result[1].name}))
                        TriggerEvent("qb-log:server:CreateLog", "warns", "Player Warned", "red", string.format("%s was warned by %s for %s", result[1].name, GetPlayerName(src), reason), false)
                    end
                else
                    DebugTrace("Offline warning citizenid had no results. CitizenID: " .. citizenid)
                end
            else
                DebugTrace("Tried to warn offline but citizenid was invalid. Scripting error.")
            end
        end
    end
end)

AdminPanel.OnlineWarnPlayer = function(source, player, reason)
    local src = source
    local identifier = nil
    if QBCore then
        identifier = QBCore.Functions.GetIdentifier(player, "license")
    else
        identifier = ESX.GetIdentifier(player)
    end

    MySQL.insert("INSERT INTO warns (name, license, reason, warnedby) VALUES (?, ?, ?, ?)", {
        GetPlayerName(player),
        identifier,
        reason,
        GetPlayerName(src)
    })
    TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.warnedPlayerOnline", {value = GetPlayerName(player)}))
    TriggerEvent("qb-log:server:CreateLog", "warns", "Player Warned", "red", string.format("%s was warned by %s for %s", GetPlayerName(player), GetPlayerName(src), reason), false)
    TriggerClientEvent("919-admin:client:WarnPlayer", player, GetPlayerName(src), reason)
end

RegisterNetEvent("919-admin:server:ViewWarnings", function(player, citizenid)
    local src = source
    local license = nil
    if AdminPanel.HasPermission(src, "checkwarns") then
        if player ~= "OFFLINE" then
            if QBCore then
                license = QBCore.Functions.GetIdentifier(player, "license")
            else
                license = ESX.GetIdentifier(player)
            end
            DebugTrace("[919-admin:server:ViewWarnings] Got license (online): " .. license)
        else
            if citizenid ~= nil then
                local result = MySQL.query.await("SELECT * FROM `" .. Config.DB.CharactersTable .. "` WHERE `citizenid` = ?", {citizenid})
                if result[1] then
                    license = result[1].license
                    DebugTrace("[919-admin:server:ViewWarnings] Got license (offline): " .. license)
                else
                    DebugTrace("Offline view warnings citizenid had no results. CitizenID: " .. citizenid)
                end
            else
                DebugTrace("Citizenid nil")
            end
        end
        if license ~= nil then
            local result = MySQL.query.await("SELECT * FROM `warns` WHERE `license` = ?", {license})
            if #result > 0 then
                TriggerClientEvent("919-admin:client:ViewWarnings", src, result)
                DebugTrace("[919-admin:server:ViewWarnings] Sending warnings")
            else
                if player ~= "OFFLINE" then
                    TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.noWarnings").."</strong> "..Lang:t("alerts.noWarningsPlayer"))
                else
                    TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.noWarnings").."</strong> "..Lang:t("alerts.noWarningsPlayer"))
                end
            end
        else
            DebugTrace("Citizenid nil")
        end
    end
end)

RegisterNetEvent("919-admin:server:CuffPlayer", function(target)
    local src = source
    if AdminPanel.HasPermission(src, "cuff") then
        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.cuffed"))
        TriggerEvent("qb-log:server:CreateLog", "adminactions", "Revive", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** cuffed/uncuffed **" .. GetPlayerName(target) .. "** [" .. target .. "]", false)
        local targetTrigger = "police:client:GetCuffed"
        if ESX then
            targetTrigger = "esx_policejob:handcuff"
        end
        TriggerClientEvent(targetTrigger, target)
    end
end)

RegisterServerEvent("919-admin:server:RevivePlayer", function(target)
    local src = source
    if AdminPanel.HasPermission(src, "revive") then
        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.revivePlayer", {value = GetPlayerName(target)}))
        TriggerEvent("qb-log:server:CreateLog", "adminactions", "Revive", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** revived **" .. GetPlayerName(target) .. "** [" .. target .. "]", false)
        local targetTrigger = "hospital:client:Revive"
        if ESX then
            targetTrigger = "esx_ambulancejob:revive"
        end
        TriggerClientEvent(targetTrigger, target)
    end
end)

RegisterServerEvent("919-admin:server:ReviveAll", function()
    local src = source
    if AdminPanel.HasPermission(src, "reviveall") then
        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.revivedAll"))
        TriggerEvent("qb-log:server:CreateLog", "adminactions", "Revive", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** revived all players.", false)
        if ESX then
            for k, v in pairs(ESX.GetPlayers()) do
                local Player = ESX.GetPlayerFromId(v)
                TriggerClientEvent("esx_ambulancejob:revive", Player.source)
            end
        elseif QBCore then
            TriggerClientEvent("hospital:client:Revive", -1)
        end
    end
end)

RegisterServerEvent("919-admin:server:MessageAll", function(message)
    local src = source
    if AdminPanel.HasPermission(src, "messageall") then
        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.sentMessageAll"))
        TriggerClientEvent("chat:addMessage", -1, {
            color = {255, 50, 50},
            multiline = true,
            args = {"SYSTEM", message}
        })
    end
end)

RegisterServerEvent("919-admin:server:DeleteAllEntities", function(entityType)
    local src = source
    local entityTypeString = "VEHICLES"
    if AdminPanel.HasPermission(src, "massdeleteentities") then
        if entityType == 2 then entityTypeString = "PEDS" elseif entityType == 3 then entityTypeString = "OBJECTS" end
        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.DeletedAllEntities", {value = entityTypeString}))
        TriggerClientEvent("919-admin:client:DeleteAllEntities", -1, entityType)
    end
end)

RegisterServerEvent("919-admin:server:SetWeather", function(weatherType)
    local src = source
    if AdminPanel.HasPermission(src, "weather") then
        if QBCore then
            exports["qb-weathersync"]:setWeather(weatherType)
            TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.setWeather", {weatherType}))
        elseif ESX then
            TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "error", "<strong>"..Lang:t("alerts.error").."</strong> This feature is currently unavailable!")
        end
    end
end)

RegisterServerEvent("919-admin:server:SetTime", function(hour, minute)
    local src = source
    if AdminPanel.HasPermission(src, "time") then
        if QBCore then
            exports["qb-weathersync"]:setTime(hour, 0)
            TriggerClientEvent("919-admin:client:ShowPanelAlert", "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.setTime", {value = hour}))
        elseif ESX then
            TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "error", "<strong>"..Lang:t("alerts.error").."</strong> This feature is currently unavailable!")
        end
    end
end)

RegisterServerEvent("919-admin:server:FeedPlayer", function(target)
    local src = source
    if AdminPanel.HasPermission(src, "foodandwater") then
        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.setMaxValues"))
        TriggerEvent("919-admin:server:SetMetaDataForPlayer", target, "thirst", 100)
        TriggerEvent("919-admin:server:SetMetaDataForPlayer", target, "hunger", 100)
        if QBCore then
            TriggerClientEvent("hud:client:UpdateNeeds", target, 100, 100)
        elseif ESX then
            TriggerClientEvent("esx_status:set", target, "hunger", 1000000)
            TriggerClientEvent("esx_status:set", target, "thirst", 1000000)
        end
        TriggerEvent("qb-log:server:CreateLog", "adminactions", "Food & Water Max", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** fed and watered **" .. GetPlayerName(target) .. "** [" .. target .. "]", false)
    end
end)

RegisterServerEvent("919-admin:server:RelieveStress", function(target)
    local src = source
    if AdminPanel.HasPermission(src, "relievestress") then
        if QBCore then
            TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.stressRelieved"))
            TriggerEvent("919-admin:server:SetMetaDataForPlayer", target, "stress", 0)
            TriggerClientEvent("hud:client:UpdateStress", target, 0)
            TriggerEvent("qb-log:server:CreateLog", "adminactions", "Relieve Stress", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** relieved stress of **" .. GetPlayerName(target) .. "** [" .. target .. "]", false)
        end
    end
end)

RegisterServerEvent("919-admin:server:SetMetaDataForPlayer", function(PlayerId, Meta, Data)
    if Meta == "hunger" or Meta == "thirst" then
        if Data >= 100 then
            Data = 100
        end
    end

    if QBCore then
        local Player = QBCore.Functions.GetPlayer(PlayerId)
        Player.Functions.SetMetaData(Meta, Data)
        TriggerClientEvent("qb-hud:client:update:needs", PlayerId, Player.PlayerData.metadata["hunger"], Player.PlayerData.metadata["thirst"])
    elseif ESX then
        TriggerClientEvent("esx_status:add",PlayerId,Meta,Data)
    end
end)

RegisterNetEvent("919-admin:server:SetPedModel", function(player, model)
    local src = source
    if AdminPanel.HasPermission(src, "setpedmodel") then
        TriggerClientEvent("919-admin:client:SetPedModel", player, model)
    end
end)

RegisterNetEvent("919-admin:server:RequestSpectate", function(player)
    local src = source
    if AdminPanel.HasPermission(src, "spectate") then
        local coords = GetEntityCoords(GetPlayerPed(player))
        SpectatingPlayer[src] = player
        TriggerClientEvent("919-admin:client:RequestSpectate", src, player, coords, GetPlayerName(player))
        TriggerEvent("qb-log:server:CreateLog", "adminactions", "Spectate", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** started spectating **" .. GetPlayerName(player) .. "** [" .. player .. "]", false)
    end
end)

RegisterNetEvent("919-admin:server:requestNextSpectate", function()
    local src = source
    if AdminPanel.HasPermission(src, "spectate") and SpectatingPlayer[src] then
        local foundPlayer = false
        local i = SpectatingPlayer[src] + 1
        local crashCounter = 0
        local Player = nil
        repeat
            Player = Compat.GetPlayer(i)
            if Player ~= nil then
                if i == src then
                else
                    local coords = GetEntityCoords(GetPlayerPed(i))
                    TriggerClientEvent("919-admin:client:RequestSpectate", src, i, coords, GetPlayerName(i))
                    TriggerEvent("qb-log:server:CreateLog", "adminactions", "Spectate", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** started spectating **" .. GetPlayerName(i) .. "** [" .. i .. "]", false)
                    SpectatingPlayer[src] = i
                    foundPlayer = true
                    crashCounter = 0
                    break
                end
            end
            i = i + 1
            if i >= 200 then
                i = 1
                crashCounter = crashCounter + 1
                if crashCounter > 1 then
                    break
                end
            end
        until i == 200
        if not foundPlayer then
            if QBCore then
                TriggerClientEvent("QBCore:Notify", src, Lang:t("notify.noPlayerFound"), "error")
            elseif ESX then
                ESX.GetPlayerFromId(source).showNotification(Lang:t("notify.noPlayerFound"))
            end
        end
    end
end)

RegisterNetEvent("919-admin:server:requestPrevSpectate", function()
    local src = source
    if AdminPanel.HasPermission(src, "spectate") and SpectatingPlayer[src] then
        local foundPlayer = false
        local i = SpectatingPlayer[src] - 1
        local crashCounter = 0
        local Player = nil
        repeat
            Player = Compat.GetPlayer(i)
            if (Player ~= nil) and i ~= src then
                local coords = GetEntityCoords(GetPlayerPed(i))
                TriggerClientEvent("919-admin:client:RequestSpectate", src, i, coords, GetPlayerName(i))
                TriggerEvent("qb-log:server:CreateLog", "adminactions", "Spectate", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** started spectating **" .. GetPlayerName(i) .. "** [" .. i .. "]", false)
                SpectatingPlayer[src] = i
                foundPlayer = true
                crashCounter = 0
                break
            end
            i = i - 1
            if i <= 0 then
                i = 200
                crashCounter = crashCounter + 1
                if crashCounter > 1 then
                    break
                end
            end
        until i == 0
        if not foundPlayer then
            if QBCore then
                TriggerClientEvent("QBCore:Notify", src, Lang:t("notify.noPlayerFound"), "error")
            elseif ESX then
                ESX.GetPlayerFromId(source).showNotification(Lang:t("notify.noPlayerFound"))
            end
        end
    end
end)

RegisterNetEvent("919-admin:server:ScreenshotSubmit", function(playerId)
    local src = source
    if AdminPanel.HasPermission(src, "screenshot") then
        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.screenshotting"))
        local screenshotOptions = {
            encoding = "png",
            quality = 1
        }
        local ids = ExtractIdentifiers(playerId);
        local playerIP = ids.ip;
        local playerSteam = ids.steam;
        local playerLicense = ids.license;
        local playerXbl = ids.xbl;
        local playerLive = ids.live;
        local playerDisc = ids.discord;
        exports["discord-screenshot"]:requestCustomClientScreenshotUploadToDiscord(playerId, Config.ScreenshotWebhook, screenshotOptions, {
            username = Config.ServerName .. " SS Bot", avatar_url = "", content = "",
            embeds = {
                {
                    color = 16711680,
                    author = {
                        name = "[" .. Config.ServerName .. " SS Bot]",
                        icon_url = ""
                    },
                    title = "Requested Screenshot",
                    description = "**__Player Identifiers:__** \n\n"
                    .. "**Server ID:** `" .. playerId .. "`\n\n"
                    .. "**Username:** `" .. GetPlayerName(playerId) .. "`\n\n"
                    .. "**IP:** `" .. playerIP .. "`\n\n"
                    .. "**Steam:** `" .. playerSteam .. "`\n\n"
                    .. "**License:** `" .. playerLicense .. "`\n\n"
                    .. "**Xbl:** `" .. playerXbl .. "`\n\n"
                    .. "**Live:** `" .. playerLive .. "`\n\n"
                    .. "**Discord:** `" .. playerDisc .. "`\n\n",
                    footer = {
                        text = "[" .. playerId .. "]" .. GetPlayerName(playerId),
                    }
                }
            }
        });
    end
end)

RegisterNetEvent("919-admin:server:SaveCar", function(mods, vehicle, hash, plate, senderId)
    local src = source
    local Player = Compat.GetPlayer(src)
    local result = MySQL.query.await("SELECT plate FROM `"..Config.DB.VehiclesTable.."` WHERE plate = ?", {plate})
    if result[1] == nil then
        MySQL.insert("INSERT INTO `"..Config.DB.VehiclesTable.."` (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)", {
            Player.PlayerData.license or Player.getIdentifier(),
            Player.PlayerData.citizenid or Player.getIdentifier(),
            vehicle.model,
            vehicle.hash,
            json.encode(mods),
            plate,
            0
        })
        if QBCore then
            TriggerClientEvent("QBCore:Notify", src, Lang:t("notify.VehicleYours"), "success", 5000)
        else
            ESX.GetPlayerFromId(source).showNotification(Lang:t("notify.VehicleYours"))
        end
        if senderId then
            TriggerEvent("qb-log:server:CreateLog", "adminactions", "Admin Car", "red", "**STAFF MEMBER " .. GetPlayerName(senderId) .. "** has added a " .. vehicle.model .. " (" .. plate .. ") to the garage of " .. GetPlayerName(src), false)
            TriggerClientEvent("919-admin:client:ShowPanelAlert", senderId, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.addedVehicle", {value = vehicle.model}))
        end
    else
        if senderId then
            TriggerClientEvent("919-admin:client:ShowPanelAlert", senderId, "danger", "<strong>"..Lang:t("alerts.error").."</strong> "..Lang:t("alerts.playerOwnsAlready"))
        end
        if QBCore then
            TriggerClientEvent("QBCore:Notify", src, Lang:t("notify.vehicleAlreadyYours"), "error", 3000)
        elseif ESX then
            ESX.GetPlayerFromId(source).showNotification(Lang:t("notify.vehicleAlreadyYours"))
        end
    end
end)

RegisterServerEvent("919-admin:server:RequestVehicleSpawn", function(modelName)
    local src = source
    if AdminPanel.HasPermission(src, "spawncar") then
        TriggerClientEvent("QBCore:Command:SpawnVehicle", src, modelName)
    end
end)

RegisterServerEvent("919-admin:server:DeleteCharacter", function(citizenId)
    local src = source
    if AdminPanel.HasPermission(src, "deletecharacter") then
        MySQL.query("SELECT * FROM  `" .. Config.DB.CharactersTable .. "` WHERE citizenid = ? LIMIT 1", {citizenId}, function(result)
            if result[1] then
                MySQL.query("DELETE FROM `" .. Config.DB.CharactersTable .. "` WHERE citizenid = ? LIMIT 1", {citizenId}, function(rowsAffected)
                    if rowsAffected then
                        local charInfo = json.decode(result[1].charinfo) or {firstname = result[1].firstname, lastname = result[1].lastname}
                        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.deletedCharacter"))
                        TriggerEvent("qb-log:server:CreateLog", "bans", "Player Unbanned", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** deleted " .. result[1].name .."'s character ".. charInfo.firstname .. " " .. charInfo.lastname, false)
                    else
                        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "danger", "<strong>"..Lang:t("alerts.error").."</strong> "..Lang:t("alerts.noRowsDeleted"))
                    end
                    local results = MySQL.query.await("SELECT * FROM `"..Config.DB.CharactersTable.."`")
                    TriggerClientEvent("919-admin:client:ReceiveCharacters", src, results)
                end)
            else
                TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "danger", "<strong>"..Lang:t("alerts.error").."</strong> "..Lang:t("alerts.cantFindLicense"))
            end
        end)
    end
end)


RegisterServerEvent("919-admin:server:UnbanPlayer", function(license)
    local src = source
    if AdminPanel.HasPermission(src, "unban") then
        MySQL.query("SELECT * FROM `bans` WHERE license = ? LIMIT 1", {license}, function(result)
            if result[1] then
                MySQL.query("DELETE FROM `bans` WHERE license = ? LIMIT 1", {license}, function(rowsAffected)
                    if rowsAffected then
                        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.unbanned"))
                        TriggerEvent("qb-log:server:CreateLog", "bans", "Player Unbanned", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** unbanned " .. result[1].name, false)
                    else
                        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "danger", "<strong>"..Lang:t("alerts.error").."</strong> "..Lang:t("alerts.noRowsDeleted"))
                    end
                    local results = MySQL.query.await("SELECT * FROM `bans`")
                    local BansInfo = {}
                    for k1, v1 in ipairs(results) do
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
                end)
            else
                TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "danger", "<strong>"..Lang:t("alerts.error").."</strong> "..Lang:t("alerts.cantFindLicense"))
            end
        end)
    end
end)


RegisterServerEvent("919-admin:server:ClearInventory", function(targetId)
    local src = source
    if AdminPanel.HasPermission(src, "clearinventory") then
        Compat.ClearPlayerInventory(targetId)
        TriggerEvent("qb-log:server:CreateLog", "adminactions", "Inventory Cleared", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** has cleared the inventory of " .. GetPlayerName(targetId), false)
        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.clearedInventory"))
    end
end)

RegisterServerEvent("919-admin:server:SetJob", function(targetId, job, grade)
    local src = source
    if AdminPanel.HasPermission(src, "setjob") then
        Compat.SetPlayerJob(targetId, job, grade)
        TriggerEvent("qb-log:server:CreateLog", "adminactions", "Set Job", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** set the job of " .. GetPlayerName(targetId) .. " to " .. job .. " (" .. grade .. ")", false)
        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.jobSet", {value = job, value2 = grade}))
    end
end)

RegisterServerEvent("919-admin:server:SetGang", function(targetId, gang, grade)
    local src = source
    if AdminPanel.HasPermission(src, "setgang") then
        if QBCore then
            if QBCore.Shared.Gangs[gang] ~= nil then
                if QBCore.Shared.Gangs[gang].grades[tostring(grade)] ~= nil then
                    local targetPlayer = QBCore.Functions.GetPlayer(targetId)
                    if targetPlayer then
                        targetPlayer.Functions.SetGang(gang, grade)
                        targetPlayer.Functions.Save()
                        TriggerEvent("qb-log:server:CreateLog", "adminactions", "Set Gang", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** set the gang of " .. GetPlayerName(targetId) .. " to " .. gang .. " (" .. grade .. ")", false)
                        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.jobSet", {value = gang, value2 = grade}))
                    end
                else
                    TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "danger", "<strong>"..Lang:t("alerts.error").."</strong> "..Lang:t("alerts.invalidgangGrade"))
                end
            else
                TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "danger", "<strong>"..Lang:t("alerts.error").."</strong> "..Lang:t("alerts.invalidgang"))
            end
        end
    end
end)

RegisterServerEvent("919-admin:server:GiveItem", function(targetId, item, amount)
    local src = source
    if AdminPanel.HasPermission(src, "giveitem") then
        if QBCore then
            if QBCore.Shared.Items[item] ~= nil then
                if targetId == "self" or targetId == nil or targetId == "" or targetId == " " then
                    targetId = source
                end
                local targetPlayer = nil
                targetPlayer = QBCore.Functions.GetPlayer(tonumber(targetId))
                if targetPlayer then
                    targetPlayer.Functions.AddItem(item, amount)
                    TriggerEvent("qb-log:server:CreateLog", "adminactions", "Set Gang", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** gave " .. item .. " (x" .. amount .. ") to " .. GetPlayerName(targetId), false)
                    TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.gaveItem", {value = item}))
                    TriggerClientEvent("QBCore:Notify", targetId, Lang:t("notify.givenItem", {value = item}), "success")
                end
            else
                TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "danger", "<strong>"..Lang:t("alerts.error").."</strong> "..Lang:t("alerts.invalidItem"))
            end
        elseif ESX then
            if targetId == nil then
                targetId = source
            elseif targetId == "self" then
                targetId = source
            elseif targetId == "" then
                targetId = source
            elseif targetId == " " then
                targetId = source
            end
            local targetPlayer = nil
            targetPlayer = ESX.GetPlayerFromId(tonumber(targetId))

            if targetPlayer then
                targetPlayer.addInventoryItem(item, amount)
                TriggerEvent("qb-log:server:CreateLog", "adminactions", "Set Gang", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** gave " .. item .. " (x" .. amount .. ") to " .. GetPlayerName(targetId), false)
                TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.gaveItem", {value = item}))
                TriggerClientEvent("QBCore:Notify", targetId, Lang:t("notify.givenItem", {value = item}), "success")
            end
        end
    end
end)

RegisterServerEvent("919-admin:server:FireJob", function(targetId)
    local src = source
    if AdminPanel.HasPermission(src, "firejob") then
        Compat.SetPlayerJob(targetId, "unemployed", 0)
        TriggerEvent("qb-log:server:CreateLog", "adminactions", "Set Job", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** fired " .. GetPlayerName(targetId) .. " from their job.", false)
        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.firedJob"))
    end
end)

RegisterServerEvent("919-admin:server:FireGang", function(targetId)
    local src = source
    if AdminPanel.HasPermission(src, "firegang") then
        Compat.SetPlayerGang(targetId, "none", 0)
        TriggerEvent("qb-log:server:CreateLog", "adminactions", "Set Gang", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** removed " .. GetPlayerName(targetId) .. " from their gang.", false)
        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.firedGang"))
    end
end)

RegisterServerEvent("919-admin:server:FireJobByCitizenId", function(citizenId)
    local src = source
    if AdminPanel.HasPermission(src, "firejob") then
        local targetPlayer = Compat.GetPlayerFromCharacterIdentifier(citizenId)
        if targetPlayer then
            if QBCore then
                targetPlayer.Functions.SetJob("unemployed", 0)
                targetPlayer.Functions.Save()
            elseif ESX then
                targetPlayer.setJob("unemployed", 0)
            end
            TriggerEvent("qb-log:server:CreateLog", "adminactions", "Set Job", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** removed " .. GetPlayerName(targetPlayer.PlayerData.source) .. " from their job.", false)
            TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.firedJob"))
        else -- Player is offline, so we"re going to formulate the default JSON for unemployed and set it to the offline character
            if QBCore then
                PlayerData = {}
                PlayerData.job = {}
                PlayerData.job.name = "unemployed"
                PlayerData.job.label = "Civilian"
                PlayerData.job.payment = 10
                if QBCore.Shared.ForceJobDefaultDutyAtLogin or PlayerData.job.onduty == nil then
                    PlayerData.job.onduty = QBCore.Shared.Jobs[PlayerData.job.name].defaultDuty
                end
                PlayerData.job.isboss = false
                PlayerData.job.grade = {}
                PlayerData.job.grade.name = "Freelancer"
                PlayerData.job.grade.level = 0

                MySQL.update("UPDATE `" .. Config.DB.CharactersTable .. "` SET `job` = ? WHERE `citizenid` = ?", {json.encode(PlayerData.job), citizenId}, function(rowsAffected)
                    if rowsAffected ~= 0 and rowsAffected ~= nil then
                        TriggerEvent("qb-log:server:CreateLog", "adminactions", "Set Job", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** removed (OFFLINE) Citizen ID " .. citizenId .. " from their job.", false)
                        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.firedJob"))
                    end
                end)
            elseif ESX then
                MySQL.update("UPDATE `" .. Config.DB.CharactersTable .. "` SET `job` = ? WHERE `identifier` = ?", {"unemployed", citizenId}, function(rowsAffected)
                    if rowsAffected ~= 0 and rowsAffected ~= nil then
                        TriggerEvent("qb-log:server:CreateLog", "adminactions", "Set Job", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** removed (OFFLINE) Citizen ID " .. citizenId .. " from their job.", false)
                        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.firedJob"))
                    end
                end)
            end
        end
    end
end)

RegisterServerEvent("919-admin:server:FireGangByCitizenId", function(citizenId)
    local src = source
    if AdminPanel.HasPermission(src, "firegang") then
        if QBCore then
            local targetPlayer = QBCore.Functions.GetPlayerByCitizenId(citizenId)
            if targetPlayer then
                targetPlayer.Functions.SetGang("none", 0)
                targetPlayer.Functions.Save()
                TriggerEvent("qb-log:server:CreateLog", "adminactions", "Set Job Grade", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** removed " .. GetPlayerName(targetPlayer.PlayerData.source) .. " from their gang.", false)
                TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.firedGang"))
            else -- Player is offline, so we"re going to formulate the default JSON for unemployed and set it to the offline character
                PlayerData = {}
                PlayerData.gang = {}
                PlayerData.gang.name = "none"
                PlayerData.gang.label = "No Gang Affiliaton"
                PlayerData.gang.isboss = false
                PlayerData.gang.grade = {}
                PlayerData.gang.grade.name = "none"
                PlayerData.gang.grade.level = 0
                MySQL.update("UPDATE `" .. Config.DB.CharactersTable .. "` SET `gang` = ? WHERE `citizenid` = ?", {json.encode(PlayerData.gang), citizenId}, function(rowsAffected)
                    if rowsAffected ~= 0 and rowsAffected ~= nil then
                        TriggerEvent("qb-log:server:CreateLog", "adminactions", "Set Gang", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** removed (OFFLINE) Citizen ID " .. citizenId .. " from their gang.", false)
                        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.firedGang"))
                    end
                end)
            end
        end
    end
end)

RegisterServerEvent("919-admin:server:SetGangGradeByCitizenId", function(citizenId, grade)
    local src = source
    if AdminPanel.HasPermission(src, "setgang") then
        if QBCore then
            local targetPlayer = QBCore.Functions.GetPlayerByCitizenId(citizenId)
            if targetPlayer then
                if QBCore.Shared.Gangs[targetPlayer.PlayerData.gang.name].grades[grade] ~= nil then
                    targetPlayer.Functions.SetGang(targetPlayer.PlayerData.gang.name, grade)
                    targetPlayer.Functions.Save()
                    TriggerEvent("qb-log:server:CreateLog", "adminactions", "Set Gang Grade", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** set gang grade of " .. GetPlayerName(targetPlayer.PlayerData.source) .. " to " .. grade .. ".", false)
                    TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> Set gang grade of " .. AdminPanel.CharacterName(targetPlayer) .. " (" .. GetPlayerName(targetId) .. ") to " .. grade)
                else
                    TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "danger", "<strong>"..Lang:t("alerts.error").."</strong> "..Lang:t("alerts.invalidgangGrade"))
                end
            else
                local result = MySQL.query.await("SELECT `gang` FROM "..Config.DB.CharactersTable.." WHERE citizenid = ?", {citizenId})
                if result ~= nil then
                    local gangInfo = json.decode(result[1].gang)
                    if gangInfo.grade ~= nil then
                        if QBCore.Shared.Gangs[gangInfo.name].grades[grade] ~= nil then
                            gangInfo.isboss = (QBCore.Shared.Gangs[gangInfo.name].grades[grade].isboss and true or false)-- We dont need a "payment" here because gangs dont have a salary.
                            gangInfo.grade.name = QBCore.Shared.Gangs[gangInfo.name].grades[grade].name -- We only need isboss, grade.name information from framework
                            gangInfo.grade.level = tonumber(grade)
                            MySQL.update("UPDATE `" .. Config.DB.CharactersTable .. "` SET `gang` = ? WHERE `citizenid` = ?", {json.encode(gangInfo), citizenId}, function(rowsAffected)
                                if rowsAffected ~= 0 and rowsAffected ~= nil then
                                    TriggerEvent("qb-log:server:CreateLog", "adminactions", "Set Gang", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** set citizen id " .. citizenId .. " to gang grade " .. grade .. " (OFFLINE)", false)
                                    TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.gangGradeSet", {value = grade}))
                                else
                                    TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "danger", "<strong>"..Lang:t("alerts.error").."</strong> "..Lang:t("alerts.databaseError"))
                                end
                            end)
                        else
                            TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "danger", "<strong>"..Lang:t("alerts.error").."</strong> "..Lang:t("alerts.invalidgangGrade"))
                        end
                    else
                        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "danger", "<strong>"..Lang:t("alerts.error").."</strong> "..Lang:t("alerts.databaseError2"))
                    end
                else
                    TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "danger", "<strong>"..Lang:t("alerts.error").."</strong> "..Lang:t("alerts.databaseError3"))
                end
            end
        end
    end
end)

RegisterServerEvent("919-admin:server:SetJobGradeByCitizenId", function(citizenId, grade)
    local src = source
    if AdminPanel.HasPermission(src, "setjob") then
        local targetPlayer = Compat.GetPlayerFromCharacterIdentifier(citizenId)
        if targetPlayer then
            if QBCore then
                if QBCore.Shared.Jobs[targetPlayer.PlayerData.job.name].grades[grade] ~= nil then
                    targetPlayer.Functions.SetJob(targetPlayer.PlayerData.job.name, grade)
                    targetPlayer.Functions.Save()
                    TriggerEvent("qb-log:server:CreateLog", "adminactions", "Set Job", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** set job grade of " .. GetPlayerName(targetPlayer.PlayerData.source) .. " to " .. grade .. ".", false)
                    TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> Set job grade of " .. AdminPanel.CharacterName(targetPlayer) .. " (" .. GetPlayerName(targetId) .. ") to " .. grade)
                else
                    TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "danger", "<strong>"..Lang:t("alerts.error").."</strong> Invalid job grade.")
                end
            elseif ESX then
                targetPlayer.setJob(targetPlayer.getJob().name, grade)
                TriggerEvent("qb-log:server:CreateLog", "adminactions", "Set Job", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** set job grade of " .. GetPlayerName(targetPlayer.PlayerData.source) .. " to " .. grade .. ".", false)
                TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> Set job grade of " .. AdminPanel.CharacterName(targetPlayer) .. " (" .. GetPlayerName(targetId) .. ") to " .. grade)
            end
        else
            local result = nil
            if QBCore then
                result = MySQL.query.await("SELECT `job` FROM `"..Config.DB.CharactersTable.."` WHERE citizenid = ?", {citizenId})
            elseif ESX then
                result = MySQL.query.await("SELECT `job` FROM `"..Config.DB.CharactersTable.."` WHERE identifier = ?", {citizenId})
            end
            if result ~= nil then
                jobInfo = result[1].job
                if QBCore then
                    jobInfo = json.decode(result[1].job)
                    if QBCore.Shared.Jobs[jobInfo.name].grades[grade] ~= nil then
                        jobInfo.payment = QBCore.Shared.Jobs[jobInfo.name].grades[grade].payment -- ;))) I actually thought of this before I had to test it. Gotta give me cred for that
                        jobInfo.isboss = (QBCore.Shared.Jobs[jobInfo.name].grades[grade].isboss and true or false)-- This is because QBCore only sets isboss if grade is boss.
                        jobInfo.grade.name = QBCore.Shared.Jobs[jobInfo.name].grades[grade].name
                        jobInfo.grade.level = tonumber(grade)
                        MySQL.update("UPDATE `" .. Config.DB.CharactersTable .. "` SET `job` = ? WHERE `citizenid` = ?", {json.encode(jobInfo), citizenId}, function(rowsAffected)
                            if rowsAffected ~= 0 and rowsAffected ~= nil then
                                TriggerEvent("qb-log:server:CreateLog", "adminactions", "Set Gang", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** set citizen id " .. citizenId .. " to job grade " .. grade .. " (OFFLINE)", false)
                                TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.jobGradeSet", {value = grade}))
                            else
                                TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "danger", "<strong>"..Lang:t("alerts.error").."</strong> "..Lang:t("alerts.databaseError"))
                            end
                        end)
                    else
                        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "danger", "<strong>"..Lang:t("alerts.error").."</strong> "..Lang:t("alerts.invalidJobGrade"))
                    end
                elseif ESX then
                    MySQL.update("UPDATE `" .. Config.DB.CharactersTable .. "` SET `job_grade` = ? WHERE `identifier` = ?", {jobInfo.grade.level, citizenId}, function(rowsAffected)
                        if rowsAffected ~= 0 and rowsAffected ~= nil then
                            TriggerEvent("qb-log:server:CreateLog", "adminactions", "Set Gang", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** set citizen id " .. citizenId .. " to job grade " .. grade .. " (OFFLINE)", false)
                            TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.jobGradeSet", {value = grade}))
                        else
                            TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "danger", "<strong>"..Lang:t("alerts.error").."</strong> "..Lang:t("alerts.databaseError"))
                        end
                    end)
                end
            else
                TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "danger", "<strong>"..Lang:t("alerts.error").."</strong> "..Lang:t("alerts.databaseError3"))
            end
        end
    end
end)

RegisterServerEvent("919-admin:server:AddVehicleToGarage", function(targetId)
    local src = source
    if AdminPanel.HasPermission(src, "savecar") then
        TriggerClientEvent("919-admin:client:SaveCar", targetId, src)
    end
end)

RegisterServerEvent("919-admin:server:BringPlayer", function(targetId)
    local src = source
    if AdminPanel.HasPermission(src, "teleport") then
        SendPlayerBack[targetId] = GetEntityCoords(GetPlayerPed(targetId))
        local coords = GetEntityCoords(GetPlayerPed(src))
        SetEntityCoords(GetPlayerPed(targetId), coords)
        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.teleportToYou", {value = GetPlayerName(targetId)}))
        TriggerEvent("qb-log:server:CreateLog", "adminactions", "Teleport", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** brought **" .. GetPlayerName(targetId) .. "** [" .. targetId .. "] to them", false)
    end
end)

RegisterServerEvent("919-admin:server:SendPlayerBack", function(targetId)
    local src = source
    if AdminPanel.HasPermission(src, "teleport") then
        if SendPlayerBack[targetId] then
            SetEntityCoords(GetPlayerPed(targetId), SendPlayerBack[targetId])
            TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.teleportedBack", {value = GetPlayerName(targetId)}))
            SendPlayerBack[targetId] = nil
        else
            TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "danger", "<strong>"..Lang:t("alerts.error").."</strong> "..Lang:t("alerts.noPosition"))
        end
    end
end)

RegisterServerEvent("919-admin:server:SendBackSelf", function()
    local src = source
    if AdminPanel.HasPermission(src, "teleport") then
        if SendBack[src] then
            SetEntityCoords(GetPlayerPed(src), SendBack[src])
            TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.sentSelfBack"))
            SendBack[src] = nil
        else
            TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "danger", "<strong>"..Lang:t("alerts.error").."</strong> "..Lang:t("alerts.noPosition"))
        end
    end
end)


RegisterServerEvent("919-admin:server:GotoPlayer", function(targetId)
    local src = source
    if AdminPanel.HasPermission(src, "teleport") then
        SendBack[src] = GetEntityCoords(GetPlayerPed(src))
        local coords = GetEntityCoords(GetPlayerPed(targetId))
        SetEntityCoords(GetPlayerPed(src), coords.x, coords.y, coords.z)
        TriggerClientEvent("919-admin:client:ShowPanelAlert", src, "success", "<strong>"..Lang:t("alerts.success").."</strong> " ..Lang:t("alerts.teleportedTo", {value = GetPlayerName(targetId)}))
        TriggerEvent("qb-log:server:CreateLog", "adminactions", "Teleport", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** teleported to **" .. GetPlayerName(targetId) .. "** [" .. targetId .. "]", false)
    end
end)

if QBCore then
    QBCore.Functions.CreateCallback("919-admin:server:HasPermissions", function(source, cb, group)
        local src = source
        local retval = false
        if QBCore.Functions.HasPermission(src, group) then
            retval = true
        end
        cb(retval)
    end)

    QBCore.Functions.CreateCallback("919-admin:server:GetPlayerPositions", function(source, cb)
        local PlayerPositions = {}
        for k, v in pairs(GetPlayers()) do
            v = tonumber(v)
            table.insert(PlayerPositions, {pos = GetEntityCoords(GetPlayerPed(v)), name = GetPlayerName(v), id = v})
        end
        cb(PlayerPositions)
    end)
elseif ESX then
    ESX.RegisterServerCallback("919-admin:server:HasPermissions", function(source, cb, group)
        local src = source
        local retval = false
        local Player = ESX.GetPlayerFromId(source)
        if Player.group == group then
            retval = true
        end
        cb(retval)
    end)

    ESX.RegisterServerCallback("919-admin:server:GetPlayerPositions", function(source, cb)
        local PlayerPositions = {}
        local Trigger = nil
        for k, v in pairs(ESX.GetPlayers()) do
            local Player = nil
            local PlayerSource = source
            Player = ESX.GetPlayerFromId(v)
            PlayerSource = Player.source
            if Player then
                table.insert(PlayerPositions, {pos = GetEntityCoords(GetPlayerPed(PlayerSource)), name = GetPlayerName(PlayerSource), id = PlayerSource})
            end
        end
        cb(PlayerPositions)
    end)
end

RegisterServerEvent("919-admin:server:SetPermissions", function(targetId, group)
    if QBCore then
        QBCore.Functions.AddPermission(targetId, group.rank)
    elseif ESX then
        local Player = ESX.GetPlayerFromId(targetId)
        Player.setGroup(group)
    end
    TriggerClientEvent("QBCore:Notify", targetId, Lang:t("alerts.permissionsSet", {value = group.label}))
end)

RegisterServerEvent("919-admin:server:OpenSkinMenu", function(targetId)
    local src = source
    if AdminPanel.HasPermission(src, "skinmenu") then
        TriggerClientEvent("919-admin:client:ShowPanelAlert", source, "success", "<strong>"..Lang:t("alerts.success").."</strong> "..Lang:t("alerts.skinMenuOpened", {value = GetPlayerName(targetId)}))
        if QBCore then
            TriggerClientEvent("qb-clothing:client:openMenu", targetId)
        elseif ESX then
            TriggerClientEvent("919-admin:client:OpenSkinMenu1", targetId)
        end
        TriggerEvent("qb-log:server:CreateLog", "adminactions", "Skin Menu", "red", "**STAFF MEMBER " .. GetPlayerName(src) .. "** opened skin menu for " .. GetPlayerName(targetId), false)
    end
end)