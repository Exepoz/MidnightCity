local QBCore = exports['qb-core']:GetCoreObject()
local Midnight = exports['mdn-nighttime']:GetMidnightCore()
local currentGames = {}
GlobalState.CurrentBowlingGames = currentGames
local pastGames = {}
GlobalState.PastBowlingGames = pastGames


RegisterNetEvent('bp-bowling:syncLane', function(lane, bool)
    TriggerClientEvent('bp-bowling:syncLane', -1, lane, bool)
end)

RegisterNetEvent('bowling:updateScore', function(lane, game, throw, score)
    local src = source
    if not currentGames[lane] then currentGames[lane] = {} end
    if not currentGames[lane].games then currentGames[lane].games = {} end
    if not currentGames[lane].games[game] then
        currentGames[lane].games[game] = {}
    end
    currentGames[lane].games[game][throw] = score

    local totalPts = 0
    for _, v in pairs(currentGames[lane].games) do
        totalPts = totalPts + v[#v]
    end
    currentGames[lane].games[game]['tot'] = totalPts
    currentGames[lane] = {
        lane = lane,
        name = currentGames[lane].name or Midnight.Functions.GetCharName(src, true),
        games = currentGames[lane].games,
        totalPoints = totalPts
    }
    GlobalState.CurrentBowlingGames = currentGames
    QBCore.Debug(currentGames)
end)

RegisterNetEvent('bowling:finishScore', function(lane)
    pastGames[#pastGames+1] = currentGames[lane]
    currentGames[lane] = nil
    GlobalState.CurrentBowlingGames = currentGames
    GlobalState.PastBowlingGames = pastGames
end)


QBCore.Functions.CreateUseableItem("bowlingball", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('bp-bowling:client:itemused', source)
end)


QBCore.Functions.CreateCallback('bp-bowling:purchaseItem', function(source, cb , key , lane)
    local Player = QBCore.Functions.GetPlayer(source)
    if(lane == true) then
        Player.Functions.RemoveMoney("cash", 25)
        local info = {
            lane = key,
            game = math.random(11111,99999)
        }
        Player.Functions.AddItem('bowlingreceipt', 1, false, info)
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["bowlingreceipt"], "add")
        cb(true)
    else
        cb(true)
        Player.Functions.RemoveMoney("cash", 50)
        Player.Functions.AddItem('bowlingball', 1, false, info)
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["bowlingball"], "add")
    end

end)

QBCore.Functions.CreateCallback('bp-bowling:getLaneAccess', function(source, cb , currentid)
 local Player = QBCore.Functions.GetPlayer(source)

  local item = Player.Functions.GetItemByName('bowlingreceipt')
  if(item == nil) then
    cb(false)
  else
    if(item.info.lane == currentid) then
        cb(true)
    end
  end
end)





RegisterServerEvent("bp-bowling:RemoveItem")
AddEventHandler("bp-bowling:RemoveItem" , function()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem('bowlingball', 1)
    Player.Functions.RemoveItem('bowlingreceipt', 1)
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["bowlingball"], "remove")
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["bowlingreceipt"], "remove")

end)