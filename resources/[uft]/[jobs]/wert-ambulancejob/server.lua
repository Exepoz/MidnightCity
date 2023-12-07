local QBCore = exports['qb-core']:GetCoreObject()

local DefaultVolume = 0.3
local xSound = exports.xsound
local BloodData = {}

local LLANG = LANG[Config.Locale]

RegisterNetEvent('wert-ambulancejob:mr-start', function(data)
	if data == "start" then
		xSound:PlayUrlPos(-1, "mr", "https://www.youtube.com/watch?v=wbdlBwhvsTg", DefaultVolume, vector3(337.06, -575.19, 43.28))
		xSound:Distance(-1, "mr", 15)
	elseif data == "stop" then
		xSound:Destroy(-1, "mr")
	end
end)

RegisterNetEvent('wert-ambulancejob:server:mr-other-start', function(plyid)
	local Player = QBCore.Functions.GetPlayer(plyid)
	if Player then TriggerClientEvent("wert-ambulancejob:client:mr-other-start", Player.PlayerData.source) end
end)

RegisterNetEvent('wert-ambulancejob:server:xray-other-start', function(plyid)
	local Player = QBCore.Functions.GetPlayer(plyid)
	if Player then TriggerClientEvent("wert-ambulancejob:client:xray-other-start", Player.PlayerData.source) end
end)

QBCore.Functions.CreateCallback('wert-ambulancejob:server:get-players-coords', function(source, cb, distance, coords)
    local src = source
    local players = {}
    local coreplayers = QBCore.Functions.GetQBPlayers()
    for k,v in pairs(coreplayers) do
        if v.PlayerData.source ~= src then
            local pped = GetPlayerPed(v.PlayerData.source)
            local ppcoords = GetEntityCoords(pped)
            local fullname = v.PlayerData.charinfo.firstname .. " " .. v.PlayerData.charinfo.lastname
            local targetdistance = #(ppcoords - coords)
            if targetdistance <= distance then
                players[v.PlayerData.source] = fullname
            end
        end
    end
    cb(players)
end)

RegisterNetEvent('wert-ambulancejob:send-bill', function(playerid, amount)
    local src = source
    local biller = QBCore.Functions.GetPlayer(src)
    local billed = QBCore.Functions.GetPlayer(playerId)
    if billed ~= nil then
        MySQL.Async.insert(
            'INSERT INTO phone_invoices (citizenid, amount, society, sender, sendercitizenid) VALUES (?, ?, ?, ?, ?)',
            {billed.PlayerData.citizenid, amount, biller.PlayerData.job.name,
            biller.PlayerData.charinfo.firstname, biller.PlayerData.citizenid})
        TriggerClientEvent('qb-phone:RefreshPhone', billed.PlayerData.source)
        TriggerClientEvent('qb-phone:client:bill-notif', billed.PlayerData.source, "$"..amount.. " " .. LLANG["sendbill"])
    end
end)

--
QBCore.Functions.CreateCallback('wert-ambulancejob:hasta-kayit', function(source, cb)
	MySQL.Async.fetchAll('SELECT * FROM hastakayit', {}, function(result)
        cb(result)
    end)
end)
RegisterServerEvent('wert-ambulancejob:hasta-kayit-et')
AddEventHandler('wert-ambulancejob:hasta-kayit-et', function(hasta, aciklama)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if xPlayer then
        local name = xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname
	    MySQL.Async.insert('INSERT INTO hastakayit (name, hasta, aciklama, date) VALUES (?, ?, ?, ?)', {
	    	name,
	    	hasta,
	    	aciklama,
	    	os.date("%d:%m:%y %H:%M", os.time()),
	    })
    end
end)

QBCore.Functions.CreateCallback('wert-ambulancejob:get-units', function(source, cb)
    local players = {}
    local coreplayers = QBCore.Functions.GetQBPlayers()
    for k,v in pairs(coreplayers) do
        if v.PlayerData.job.name == "ambulance" and v.PlayerData.job.onduty then
            local fullname = v.PlayerData.charinfo.firstname .. " " .. v.PlayerData.charinfo.lastname
            players[v.PlayerData.citizenid] = {
                name = fullname,
                phone = v.PlayerData.charinfo.phone
            }
        end
    end
    cb(players)
end)

--Blood

QBCore.Functions.CreateCallback('wert-ambulancejob:server:get-blood-bank', function(source, cb)
    cb(BloodData)
end)

RegisterNetEvent("wert-ambulancejob:server:blood-actions", function(action, group)
    if action == "add" then
        if BloodData[group:lower()] then
            BloodData[group:lower()] = BloodData[group:lower()] + 1
        else
            BloodData[group:lower()] = 1
        end
        SaveResourceFile(GetCurrentResourceName(), "./data.json", json.encode(BloodData), -1)
    elseif action == "remove" then
        if BloodData[group:lower()] then
            BloodData[group:lower()] = BloodData[group:lower()] - 1
            if BloodData[group:lower()] < 0 then BloodData[group:lower()] = 0 end
        else
            BloodData[group:lower()] = 0
        end
        SaveResourceFile(GetCurrentResourceName(), "./data.json", json.encode(BloodData), -1)
    end
end)

RegisterNetEvent("wert-ambulancejob:server:kan-alındı", function(id)
    local src = source
    local target = QBCore.Functions.GetPlayer(id)
    local ply = QBCore.Functions.GetPlayer(src)
    if target then
        local bloodtype = target.PlayerData.metadata['bloodtype']
        if bloodtype and ply then
            local info = {}
            info.bloodtype = bloodtype
            ply.Functions.AddItem("bloodtube", 1, nil, info)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["bloodtube"], 'add')
        end
    end
end)

QBCore.Functions.CreateCallback('wert-ambulancejob:online-doctor', function(source, cb)
    local amount = 0
    local players = QBCore.Functions.GetQBPlayers()
    for k, v in pairs(players) do
        if v.PlayerData.job.name == "ambulance" and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
	cb(amount)
end)

QBCore.Functions.CreateUseableItem("emptysyringe", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player then
        TriggerClientEvent('wert-ambulancejob:take-blood', source)
    end
end)

QBCore.Functions.CreateCallback('wert-ambulancejob:kan-paket', function(source, cb, type)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local item = Player.Functions.GetItemByName("bloodtube")

    else
        cb(false)
    end
end)

RegisterNetEvent('wert-ambulancejob:kan-paket', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local item = Player.Functions.GetItemByName("bloodtube")
        if item and item.info.bloodtype then
            if type(item.info.bloodtype) == 'table' then
                if next(item.info.bloodtype) ~= nil then
                    TriggerClientEvent('wert-ambulancejob:kan-paketle', src, item.info.bloodtype, item.slot)
                else
                    print("Item not have blood data")
                end
                
            else
                print(item.info.bloodtype)
                TriggerClientEvent('wert-ambulancejob:kan-paketle', src, item.info.bloodtype, item.slot)
            end
        else
            print("Item not have blood data")
        end
    end
end)

RegisterNetEvent('wert-ambulancejob:kan-load-bank', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local item = Player.Functions.GetItemByName("bloodbag")

        if item and item.info.bloodtype then
            if type(item.info.bloodtype) == 'table' then
                if next(item.info.bloodtype) ~= nil then
                    TriggerClientEvent('wert-ambulancejob:kan-setup', src, item.info.bloodtype, item.slot)
                else
                    print("Item not have blood data")
                end
                
            else
                print(item.info.bloodtype)
                TriggerClientEvent('wert-ambulancejob:kan-setup', src, item.info.bloodtype, item.slot)
            end
        else
            print("Item not have blood data")
        end
    end
end)


-- Xray || Mr
local links = {
    ["beyin"] = "https://cdn.discordapp.com/attachments/471988729196838924/971429048976830524/unknown.png",
    ["kalca"] = "https://cdn.discordapp.com/attachments/971695978962907176/971696110202658866/unknown.png",
    ["tabdomen"] = "https://cdn.discordapp.com/attachments/971695978962907176/971696236375736350/unknown.png",
    ["tchest"] = "https://cdn.discordapp.com/attachments/971695978962907176/971696442508980234/unknown.png",
    ["elbilek"] = "https://cdn.discordapp.com/attachments/971695978962907176/971696521085087784/unknown.png",
    ["omuz"] = "https://cdn.discordapp.com/attachments/971695978962907176/971696619865133056/unknown.png",
    ["diz"] = "https://cdn.discordapp.com/attachments/971695978962907176/971696691629686834/unknown.png",
    ["tboyun"] = "https://cdn.discordapp.com/attachments/971695978962907176/971696814157885460/unknown.png",
    ["hipofiz"] = "https://cdn.discordapp.com/attachments/971695978962907176/971696882663444520/unknown.png",
}

QBCore.Functions.CreateUseableItem("mri", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if item.info and item.info.plan and item.info.hasta then
        if links[item.info.plan] then
            TriggerClientEvent("wert-ambulancejob:client:use-photo", source, links[item.info.plan])
        end
    end
end)


local xraylinks = {
    ["kafa"] = "https://cdn.discordapp.com/attachments/971695978962907176/971697604972916746/unknown.png",
    ["omuz"] = "https://cdn.discordapp.com/attachments/971695978962907176/971697737886208000/unknown.png",
    ["humerus"] = "https://cdn.discordapp.com/attachments/971695978962907176/971698068904869928/unknown.png",
    ["onkol"] = "https://cdn.discordapp.com/attachments/971695978962907176/971698142816907304/unknown.png",
    ["pelvis"] = "https://cdn.discordapp.com/attachments/971695978962907176/971698255727575100/unknown.png",
    ["femur"] = "https://cdn.discordapp.com/attachments/971695978962907176/971698337914953749/unknown.png",
    ["diz"] = "https://cdn.discordapp.com/attachments/971695978962907176/971698409071345664/unknown.png",
    ["ayak"] = "https://cdn.discordapp.com/attachments/971695978962907176/971698512293158912/unknown.png",
    ["ciger"] = "https://cdn.discordapp.com/attachments/971695978962907176/971698573102174258/unknown.png",
}

QBCore.Functions.CreateUseableItem("xray", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if item.info and item.info.plan and item.info.hasta then
        if xraylinks[item.info.plan] then
            TriggerClientEvent("wert-ambulancejob:client:use-photo", source, xraylinks[item.info.plan])
        end
    end
end)

-- Check money
QBCore.Functions.CreateCallback('wert-ambulancejob:server:check-money', function(source, cb, type, money)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        if Player.Functions.RemoveMoney(type, tonumber(money)) then
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

-- Kan kart
QBCore.Functions.CreateUseableItem("kankart", function(source, item)
	if item.info and item.info.kankartdata then
        TriggerClientEvent("wert-ambulancejob:use-blood-card", source, item.info.kankartdata)
    end
end)

RegisterNetEvent("Wert-Ambulance:AddItem", function(name, amount, slot, info)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddItem(name, amount, slot, info)
    end
end)

RegisterNetEvent("Wert-Ambulance:RemoveItem", function(name, amount, slot)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.RemoveItem(name, amount, slot)
    end
end)

CreateThread(function()
    Wait(500)
    BloodData = json.decode(LoadResourceFile(GetCurrentResourceName(), "./data.json"))
    local bloodtypes = QBCore.Config.Player.Bloodtypes
    for k,v in pairs(bloodtypes) do
        if BloodData[v:lower()] == nil then
            BloodData[v:lower()] = 0
        end
    end
    --[[ SaveResourceFile(GetCurrentResourceName(), "./data.json", json.encode(BloodData), -1) ]]
end)