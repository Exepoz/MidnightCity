local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('garages:getGangMembers', function(source, cb, gang, grade)
    local GangMembers = {}
    --local results = MySQL.query.await("SELECT * FROM `players` WHERE `gang` LIKE ? AND `gang` LIKE ?", {"%"..gang.."%", "%\"grade\":{\"level\":"..grade.."%"})
    local results = MySQL.query.await("SELECT * FROM `players` WHERE `gang` LIKE ?", {"%"..gang.."%"})
    for k1,v1 in ipairs(results) do
        local CharInfo = json.decode(v1.charinfo)
        local CharName = "Unknown?"
        if CharInfo then
            CharName = CharInfo.firstname .. ' ' .. CharInfo.lastname
        end
        local GangInfo = json.decode(v1.gang)
        local GradeInfo = GangInfo.grade
        table.insert(GangMembers, {
            Name = v1.name,
            CitizenId = v1.citizenid,
            CharName = CharName,
            IsBoss = GangInfo.isboss,
            Grade = {name = GradeInfo.name, level = GradeInfo.level},
        })
    end
    cb(GangMembers)
end)

RegisterNetEvent('garages:server:setupPapers',  function(plate, cid)
    local src = source
    local success = MySQL.update.await("UPDATE player_vehicles set gang_papers = ? WHERE plate = ?", {cid, plate})
    if success then TriggerClientEvent('QBCore:Notify', src, "Successfully set the vehicle's paper holder!", 'success')
    else TriggerClientEvent('QBCore:Notify', src, "Something went wrong...", 'error') end
end)
