local QBCore = exports['qb-core']:GetCoreObject()

local tg = 0
local Groups = {}
GlobalState.HeistGroups = {}


local GangsData ={}
GlobalState.GangsData = {}

Heists = {
    ['thorium'] = {done = false},
    ['methylamine'] = {done = false},
    ['alluminum'] = {done = false},
}

CreateThread(function()
	local LoadJson = json.decode(LoadResourceFile(GetCurrentResourceName(), 'goldenTrailGangs.json'))
    GangsData = LoadJson
    GlobalState.GangsData = GangsData
end)

local getCops = function()
    local amount = 0
    for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
        for _, jobs in pairs({'police'}) do
            if v.PlayerData.job.name == jobs and v.PlayerData.job.onduty then
                amount = amount + 1
            end
        end
    end
    return amount
end

-- Drug Heists
RegisterNetEvent('malmo-goldentrail:server:CheckHeistReq', function(drug, heist)
    local src = source
    if Heists[heist].done then TriggerClientEvent("QBCore:Notify", src, 'Someone already did this today!','error') return end
    --if getCops() < 3 then TriggerClientEvent("QBCore:Notify", src, 'Ther server is unreachable, try again later.','error') return end
    local Player = QBCore.Functions.GetPlayer(src)
    local gang = Player.PlayerData.gang.name
    if not GangsData[gang] then GangsData[gang] = {} end --259200
    if GangsData[gang][heist] and os.time() > GangsData[gang][heist]+259200 then TriggerClientEvent("QBCore:Notify", src, 'Your gang has done this too recently, come back an other time!','error') return end
    if not Player.Functions.RemoveMoney('cosmo', 50, "Starting Drug Supply Heist ["..heist.."]") then TriggerClientEvent("QBCore:Notify", src, 'You don\'t have enough Cosmo...','error') return end
    print("starting heist "..heist)
    GangsData[gang][heist] = os.time()
    GangsData[gang].HeistInProgress = heist
    GlobalState.GangsData = GangsData
    if heist == 'thorium' then
        TriggerClientEvent('qb-drugsystem:client:StartMission', src , 'gang')
    elseif heist == 'kerosene' then
        if GangsData[gang].KeroBarrels == 2 then
            local str = "Hey. You have to bring back at least one of the barrels you took. We can\'t arise suspicion and our contact needs to bring back the barrels so we don\'t get caught. Bring it to the location marked on your GPS."
            local emailData = {
                sender = 'Anonymous',
                subject = _U('phone_title_current'),
                message = str
            }TriggerEvent('qb-phone:server:sendNewMail', emailData, Player.PlayerData.citizenid)
            TriggerClientEvent('qb-drugsystem:client:BringBackBarrel', src , 'kerosene', gang)
        else
            TriggerEvent('qb-drugsystem:client:StartBarrels', src , 'kerosene')
        end
    elseif heist == 'methylamine' then
        if GangsData[gang].MethBarrels == 2 then
            local str = "Hey. You have to bring back at least one of the barrels you took. We can\'t arise suspicion and our contact needs to bring back the barrels so we don\'t get caught. Bring it to the location marked on your GPS."
            local emailData = {
                sender = 'Anonymous',
                subject = _U('phone_title_current'),
                message = str
            } TriggerEvent('qb-phone:server:sendNewMail', emailData, Player.PlayerData.citizenid)
            TriggerClientEvent('qb-drugsystem:client:BringBackBarrel', src , 'methy', gang)
        else
            TriggerEvent('qb-drugsystem:server:CanStartBarrels', src , 'methy')
        end
    elseif heist == "alluminum" then
        TriggerClientEvent('qb-drugsystem:client:StartQuarry', src , 'alluminum')
    elseif heist == "slack" then
        TriggerClientEvent('qb-drugsystem:client:StartQuarry', src , 'slack')
    end
    SaveGangData()
end)

RegisterNetEvent('malmo-goldentrail:server:giveBackBarrel', function(src, mission)
    local Player = QBCore.Functions.GetPlayer(src)
    local gang = Player.PlayerData.gang.name
    if mission == "methy" then
        GangsData[gang].MethBarrels = GangsData[gang].MethBarrels - 1
    elseif missione == "kerosene" then
        GangsData[gang].KeroBarrels = GangsData[gang].KeroBarrels - 1
    end
    SaveGangData()
end)

RegisterNetEvent('malmo-goldentrail:server:checkChatrooms', function(drug, heist)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local gang = Player.PlayerData.gang.name
    local chatrooms = {}
    local MWHeist, BobcatOrder = exports['cr-armoredtrucks']:GetMWTruckReq(src)
    local ArtHeist = exports['rm_artheist']:CheckCanRob()
    if MWHeist then chatrooms[#chatrooms+1] = {title = '3QU1N0X', event = 'cr-armoredtrucks:client:TruckGuy', args = {order = BobcatOrder}} end
    if ArtHeist then chatrooms[#chatrooms+1] = {title = 'M4RCH4ND4RT', event = 'artheist:client:setupHeist'} end
    TriggerClientEvent('malmo-goldentrail:client:showChatrooms', src, chatrooms)
end)

QBCore.Functions.CreateCallback('getPlayersCloseby',function(source,cb,coords)
    local players = QBCore.Functions.GetQBPlayers()
    local group = {}
    for k,v in pairs(players) do
        if #(GetEntityCoords(GetPlayerPed(v.PlayerData.source)) - coords) < 10.0 then --and k ~= source then
            table.insert(group, {src = v.PlayerData.source, cid = v.PlayerData.citizenid, name = v.PlayerData.charinfo.firstname.." "..v.PlayerData.charinfo.lastname})
        end
    end
    if #group > 0 then cb(group) else cb(false) end
end)

RegisterNetEvent('malmo-goldentrail:server:makeGroup', function(group, heist)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local gang = Player.PlayerData.gang.name
    tg = tg + 1
    table.insert(group, {src = src, cid = Player.PlayerData.citizenid, name = Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname, leader = true})
    group = {gang = gang or false, grp = group, heist = heist}
    Groups[tg] = group
    GlobalState.HeistGroups = Groups
    for _, v in pairs(group.grp) do
        TriggerClientEvent('malmo-goldentrail:client:addToGroup', v.src, tg, Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname)
    end
end)

RegisterNetEvent('malmo-goldentrail:server:deleteGroup', function(group)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    for _, v in pairs(Groups[group].grp) do
        TriggerClientEvent('malmo-goldentrail:client:removeFromGroup', v.src)
    end
    Groups[group] = nil
    GlobalState.HeistGroups = Groups
end)

RegisterCommand('getHeistGroups', function()
    print_table(Groups)
end)

function SaveGangData()
    SaveResourceFile(GetCurrentResourceName(), "goldenTrailGangs.json", json.encode(GangsData), -1)
end